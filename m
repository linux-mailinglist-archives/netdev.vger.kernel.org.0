Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 918A16C8FA8
	for <lists+netdev@lfdr.de>; Sat, 25 Mar 2023 18:03:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230290AbjCYRDF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Mar 2023 13:03:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjCYRDE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Mar 2023 13:03:04 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E2B07AA9
        for <netdev@vger.kernel.org>; Sat, 25 Mar 2023 10:03:02 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id r11so19805044edd.5
        for <netdev@vger.kernel.org>; Sat, 25 Mar 2023 10:03:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679763781;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RkHo9d8+/kVELrpCfV/Y5T7JdPOLKlGrBq3C+s/kLXY=;
        b=am4Fdzow/phJwhXCDTcpNPlYor1H4cJXHUAP7dOzz8Cz2PU3Cg71R0IzvY8rRXARd2
         n8DgiJ+PmM3PynwiTH8pW0oVKFCpmZtS1RiSC44apPfycxAhwW5FubvK++NlfacxtLnT
         xVZ6M9i9ngcD6t155fCSZlLorPABDCIKo1AGtVZbYNljjn2BARxlZQmJ0UQfX1APN9Dj
         E3REG/ES0BK9z4mCGoRhxDQJEF/fbJhfhWQxQlF8ZNBGpfr9xy4F1vK0h6Mm/Cb91LYE
         HdYBreiqbHQXfglknTYXx5+NCYM7T78jwGXEg+GjWinoDiyiMCU8ue3eH8rS4mWc71sc
         3u0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679763781;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RkHo9d8+/kVELrpCfV/Y5T7JdPOLKlGrBq3C+s/kLXY=;
        b=FPMKmmSbb/8L77zl9OfIuiOw7wJNhXPTjgUqf7f3B4EiCtClTjLxU0xuUet9F1S6wx
         mLTL5P7qY6rQHMtarLvqsToNc8E7PBJ+9RoHiMlQ4/9XpRC8kCdWNou+jMU9vVGE7+RW
         /9WX8Ml6CURimckb1K2L6Af4vBmf8UnDQA1s9376Vstp3TlLKkGbLxy43E/tbXFgiQKv
         1JKMxTlUjC5T0B1hbll0y6qY4MfKyw3v+KmkEjaD3aRJRgX0Qz5Fvr/CR9gtxfn0vAUt
         qfhly2iSRiEHMqWVd5qVCA1LwNc4/H+o+nZ19miYAOmW2JuSihB/AblQIcg8Lbry5bze
         uL0w==
X-Gm-Message-State: AAQBX9dTpmU2p4mj7Y2M6wNrczKW3yld/NWkcx2weZTt7QQRRRt3Z9bX
        Tbat3erPb4SuNFS+vFTkI1VR3KAqu/SCSs7Zkwk=
X-Google-Smtp-Source: AKy350Z4WehyGC4yfE7y7jvULgBOV6hpagwZGkzhIplkjMRdasmGPROueEU/gYjTovAIemufTvjm44E7z52/j+g8Pdo=
X-Received: by 2002:a17:906:4887:b0:931:dd22:4486 with SMTP id
 v7-20020a170906488700b00931dd224486mr3352146ejq.8.1679763780789; Sat, 25 Mar
 2023 10:03:00 -0700 (PDT)
MIME-Version: 1.0
References: <20230318214953.36834-1-u9012063@gmail.com> <20230319172052.gkzu7h227ulkog6o@soft-dev3-1>
In-Reply-To: <20230319172052.gkzu7h227ulkog6o@soft-dev3-1>
From:   William Tu <u9012063@gmail.com>
Date:   Sat, 25 Mar 2023 10:02:22 -0700
Message-ID: <CALDO+SY1uUBC7DzxYUV3agxzYirrDe9PON+P0Wv-eh1Bhq+SVg@mail.gmail.com>
Subject: Re: [PATCH RFC v18 net-next] vmxnet3: Add XDP support.
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     netdev@vger.kernel.org, jsankararama@vmware.com, gyang@vmware.com,
        doshir@vmware.com, alexander.duyck@gmail.com,
        alexandr.lobakin@intel.com, bang@vmware.com,
        maciej.fijalkowski@intel.com, witu@nvidia.com,
        Alexander Duyck <alexanderduyck@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Horatiu,

Thanks for your review and finding more issues!

On Sun, Mar 19, 2023 at 10:20=E2=80=AFAM Horatiu Vultur
<horatiu.vultur@microchip.com> wrote:
>
> The 03/18/2023 14:49, William Tu wrote:
>
> Hi William,
>
> ...
>
> > +
> > +static int
> > +vmxnet3_xdp_xmit_frame(struct vmxnet3_adapter *adapter,
> > +                      struct xdp_frame *xdpf,
> > +                      struct vmxnet3_tx_queue *tq, bool dma_map)
> > +{
> > +       struct vmxnet3_tx_buf_info *tbi =3D NULL;
> > +       union Vmxnet3_GenericDesc *gdesc;
> > +       struct vmxnet3_tx_ctx ctx;
> > +       int tx_num_deferred;
> > +       struct page *page;
> > +       u32 buf_size;
> > +       int ret =3D 0;
>
> This doesn't seem to be used anywhere, so it can be removed.

yes, I will just return 0 at the end.

>
> > +       u32 dw2;
> > +
> > +       dw2 =3D (tq->tx_ring.gen ^ 0x1) << VMXNET3_TXD_GEN_SHIFT;
> > +       dw2 |=3D xdpf->len;
> > +       ctx.sop_txd =3D tq->tx_ring.base + tq->tx_ring.next2fill;
> > +       gdesc =3D ctx.sop_txd;
> > +
> > +       buf_size =3D xdpf->len;
> > +       tbi =3D tq->buf_info + tq->tx_ring.next2fill;
> > +
> > +       if (vmxnet3_cmd_ring_desc_avail(&tq->tx_ring) =3D=3D 0) {
> > +               tq->stats.tx_ring_full++;
> > +               return -ENOSPC;
> > +       }
> > +
> > +       tbi->map_type =3D VMXNET3_MAP_XDP;
> > +       if (dma_map) { /* ndo_xdp_xmit */
> > +               tbi->dma_addr =3D dma_map_single(&adapter->pdev->dev,
> > +                                              xdpf->data, buf_size,
> > +                                              DMA_TO_DEVICE);
> > +               if (dma_mapping_error(&adapter->pdev->dev, tbi->dma_add=
r))
> > +                       return -EFAULT;
> > +               tbi->map_type |=3D VMXNET3_MAP_SINGLE;
> > +       } else { /* XDP buffer from page pool */
> > +               page =3D virt_to_page(xdpf->data);
> > +               tbi->dma_addr =3D page_pool_get_dma_addr(page) +
> > +                               XDP_PACKET_HEADROOM;
>
> Shouldn't this be VMXNET3_XDP_HEADROOM?
yes, will fix it.

>
> > +               dma_sync_single_for_device(&adapter->pdev->dev,
> > +                                          tbi->dma_addr, buf_size,
> > +                                          DMA_BIDIRECTIONAL);
>
> Shouldn't this be DMA_TO_DEVICE instead of DMA_BIDERECTIONAL?
sure, will fix it.

Originally I looked at stmmac_main.c and I thought it's an optimization sin=
ce
in the beginning of page pool creation we set it DMA_BIDRIECTIONAL.
I guess it's not applicable here.

>
> > +       }
> > +       tbi->xdpf =3D xdpf;
> > +       tbi->len =3D buf_size;
> > +
> > +       gdesc =3D tq->tx_ring.base + tq->tx_ring.next2fill;
> > +       WARN_ON_ONCE(gdesc->txd.gen =3D=3D tq->tx_ring.gen);
> > +
> > +       gdesc->txd.addr =3D cpu_to_le64(tbi->dma_addr);
> > +       gdesc->dword[2] =3D cpu_to_le32(dw2);
> > +
> > +       /* Setup the EOP desc */
> > +       gdesc->dword[3] =3D cpu_to_le32(VMXNET3_TXD_CQ | VMXNET3_TXD_EO=
P);
> > +
> > +       gdesc->txd.om =3D 0;
> > +       gdesc->txd.msscof =3D 0;
> > +       gdesc->txd.hlen =3D 0;
> > +       gdesc->txd.ti =3D 0;
> > +
> > +       tx_num_deferred =3D le32_to_cpu(tq->shared->txNumDeferred);
> > +       le32_add_cpu(&tq->shared->txNumDeferred, 1);
> > +       tx_num_deferred++;
> > +
> > +       vmxnet3_cmd_ring_adv_next2fill(&tq->tx_ring);
> > +
> > +       /* set the last buf_info for the pkt */
> > +       tbi->sop_idx =3D ctx.sop_txd - tq->tx_ring.base;
> > +
> > +       dma_wmb();
> > +       gdesc->dword[2] =3D cpu_to_le32(le32_to_cpu(gdesc->dword[2]) ^
> > +                                                 VMXNET3_TXD_GEN);
> > +
> > +       /* No need to handle the case when tx_num_deferred doesn't reac=
h
> > +        * threshold. Backend driver at hypervisor side will poll and r=
eset
> > +        * tq->shared->txNumDeferred to 0.
> > +        */
> > +       if (tx_num_deferred >=3D le32_to_cpu(tq->shared->txThreshold)) =
{
> > +               tq->shared->txNumDeferred =3D 0;
> > +               VMXNET3_WRITE_BAR0_REG(adapter,
> > +                                      VMXNET3_REG_TXPROD + tq->qid * 8=
,
> > +                                      tq->tx_ring.next2fill);
> > +       }
> > +
> > +       return ret;
> > +}
>
> ...
>
> > +static int
> > +vmxnet3_run_xdp(struct vmxnet3_rx_queue *rq, struct xdp_buff *xdp,
> > +               struct bpf_prog *prog)
> > +{
> > +       struct xdp_frame *xdpf;
> > +       struct page *page;
> > +       int err;
> > +       u32 act;
> > +
> > +       act =3D bpf_prog_run_xdp(prog, xdp);
> > +       rq->stats.xdp_packets++;
> > +       page =3D virt_to_page(xdp->data_hard_start);
> > +
> > +       switch (act) {
> > +       case XDP_PASS:
> > +               return act;
> > +       case XDP_REDIRECT:
> > +               err =3D xdp_do_redirect(rq->adapter->netdev, xdp, prog)=
;
> > +               if (!err)
> > +                       rq->stats.xdp_redirects++;
> > +               else
> > +                       rq->stats.xdp_drops++;
> > +               return act;
> > +       case XDP_TX:
> > +               xdpf =3D xdp_convert_buff_to_frame(xdp);
>
> If you want, I think you can drop xdp_convert_buff_to_frame() and pass
> directly the page. And then inside vmxnet3_unmap_pkt() you can use
> page_pool_recycle_direct().
> Of course this requires few other changes (I think you need a new
> map_type) but in the end you might save some CPU usage.

Thanks for the suggestion.
Will leave this for future work.

Thanks!
William
