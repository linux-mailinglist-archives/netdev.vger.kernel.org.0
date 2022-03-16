Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 031B14DA6F1
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 01:36:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239000AbiCPAiI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 20:38:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231308AbiCPAiH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 20:38:07 -0400
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73D9F5D67C;
        Tue, 15 Mar 2022 17:36:53 -0700 (PDT)
Received: by mail-ot1-x32b.google.com with SMTP id o106-20020a9d2273000000b005b21f46878cso446232ota.3;
        Tue, 15 Mar 2022 17:36:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=tEvS1gw6DLo5aNaXc9GNy/7Eww514w2G7asHQnm6tjg=;
        b=Sfx3DJTOtZ6O+9Mb0iKgks9q9NbAM/xpJdr9tUFY7XQj2HGqA1g2QFPE9JAR0/sHRF
         wRAn0qVjSsFT4jOjhPNSVj1HBlRvxKm4OTKdGI5uO3n60cwr5DP0Xfr6coT5LeYi62Cr
         p15TofA8+k5/QjZnuQUB/jSz9Z1bH1cJiHo/+WNTWusMVlH3ddbL50nm7RZAl26bvZee
         hUi8FUQ6IvMd+OPP2vY3xUQL4EEk2P+6TTWmRtEtgmhyhagDEqImBu3yivmPvIW+O4Jr
         e5N3YU+yYQFDZCCHp7iDs6UMlpr+fjH4TQQ+VW7EbCH/ItoQbxwsCY3t+9S/PsBranGm
         UrKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=tEvS1gw6DLo5aNaXc9GNy/7Eww514w2G7asHQnm6tjg=;
        b=4WCVFP3XuIEafZgnm9h43We1c6pcaKNeAZbr3KdiTwU0CFPy4DYPxzITt8zjjL0L3Z
         g3IEpED3nbIPDCaNP50Mi4aYHk70mqPmKHX5UdgmgvZLlMp3/mzdzxrejhJh3YmWwv4J
         a1wHdVFBfiGRgl9OCRnYjcHXfQn6Il1e5j5lj9zRGBCQaAIvgtlq18QvpfdoGkFROxVY
         gahdfg/0duTmBv4/H63m2+Pl3ofCUhbF7ztwsD8CW3bjvuzTVps4QFpXuFASGHjCdJCa
         5z7Vf8L/bJuBFR8GpyJzYqvkl7H5QHDUoRjKz/Xo8fIdOdjLtcXM7Ore+oys4sxXOPmh
         ajoA==
X-Gm-Message-State: AOAM532UrgHqr1tJL0jw7RUqX0eUuXbl/qTFk8J/E67CZsejoLISLVl6
        VDv/2L39/hqTPs1K89zq7tI=
X-Google-Smtp-Source: ABdhPJzVL1dKTKL/4GcAkBuzxqfxCBr9nei0KV3BffRx0eI+LM+p+jUyFIGYlqfKlTN4MiTFj2yvaA==
X-Received: by 2002:a9d:70cf:0:b0:5af:9dda:ec44 with SMTP id w15-20020a9d70cf000000b005af9ddaec44mr12984192otj.23.1647391012407;
        Tue, 15 Mar 2022 17:36:52 -0700 (PDT)
Received: from localhost ([2600:1700:65a0:ab60:b2de:6d1:9e4b:8e55])
        by smtp.gmail.com with ESMTPSA id s62-20020aca4541000000b002d7823c8328sm353718oia.4.2022.03.15.17.36.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Mar 2022 17:36:51 -0700 (PDT)
Date:   Tue, 15 Mar 2022 17:36:50 -0700
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     wangyufen <wangyufen@huawei.com>, ast@kernel.org,
        john.fastabend@gmail.com, daniel@iogearbox.net, lmb@cloudflare.com,
        davem@davemloft.net, kafai@fb.com, dsahern@kernel.org,
        kuba@kernel.org, songliubraving@fb.com, yhs@fb.com,
        kpsingh@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next] bpf, sockmap: Manual deletion of sockmap
 elements in user mode is not allowed
Message-ID: <YjExIgF2ib0ePvbh@pop-os.localdomain>
References: <20220314124432.3050394-1-wangyufen@huawei.com>
 <87sfrky2bt.fsf@cloudflare.com>
 <ff9d0ecf-315b-00a3-8140-424714b204ff@huawei.com>
 <87fsnjxvho.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87fsnjxvho.fsf@cloudflare.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 15, 2022 at 01:12:08PM +0100, Jakub Sitnicki wrote:
> On Tue, Mar 15, 2022 at 03:24 PM +08, wangyufen wrote:
> > 在 2022/3/14 23:30, Jakub Sitnicki 写道:
> >> On Mon, Mar 14, 2022 at 08:44 PM +08, Wang Yufen wrote:
> >>> A tcp socket in a sockmap. If user invokes bpf_map_delete_elem to delete
> >>> the sockmap element, the tcp socket will switch to use the TCP protocol
> >>> stack to send and receive packets. The switching process may cause some
> >>> issues, such as if some msgs exist in the ingress queue and are cleared
> >>> by sk_psock_drop(), the packets are lost, and the tcp data is abnormal.
> >>>
> >>> Signed-off-by: Wang Yufen <wangyufen@huawei.com>
> >>> ---
> >> Can you please tell us a bit more about the life-cycle of the socket in
> >> your workload? Questions that come to mind:
> >>
> >> 1) What triggers the removal of the socket from sockmap in your case?
> > We use sk_msg to redirect with sock hash, like this:
> >
> >  skA   redirect    skB
> >  Tx <-----------> skB,Rx
> >
> > And construct a scenario where the packet sending speed is high, the
> > packet receiving speed is slow, so the packets are stacked in the ingress
> > queue on the receiving side. In this case, if run bpf_map_delete_elem() to
> > delete the sockmap entry, will trigger the following procedure:
> >
> > sock_hash_delete_elem()
> >   sock_map_unref()
> >     sk_psock_put()
> >       sk_psock_drop()
> >         sk_psock_stop()
> >           __sk_psock_zap_ingress()
> >             __sk_psock_purge_ingress_msg()
> >
> >> 2) Would it still be a problem if removal from sockmap did not cause any
> >> packets to get dropped?
> > Yes, it still be a problem. If removal from sockmap  did not cause any
> > packets to get dropped, packet receiving process switches to use TCP
> > protocol stack. The packets in the psock ingress queue cannot be received
> >
> > by the user.
> 
> Thanks for the context. So, if I understand correctly, you want to avoid
> breaking the network pipe by updating the sockmap from user-space.
> 
> This sounds awfully similar to BPF_MAP_FREEZE. Have you considered that?

Doesn't BPF_MAP_FREEZE only freeze write operations from syscalls?
For sockmap, receiving packets is not a part of map write operation.

The problem here is that skmsg can only be consumed when the socket is
still in the map, as it uses a separate queue and a separate type of
message (skmsg vs. skb). So, esstentially this behavior is by design.

Thanks.
