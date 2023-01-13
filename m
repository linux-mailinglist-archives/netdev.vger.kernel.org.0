Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC711669CE8
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 16:51:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230361AbjAMPvl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 10:51:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230177AbjAMPuP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 10:50:15 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EC6A84BC9
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 07:43:15 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id c26so12024372pfp.10
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 07:43:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=EE+5vXR6A4AKhBg4Wq8Kn/uiwfPM/feLwvp278kmBtE=;
        b=d2fMtUDL1R6ivdSKzNoAbCBkl00yQktMhsAXaR2jXN0nra7IIc+bY9EyfDzj1WoXCF
         m3C+UWFRzP0th/64Arnib0WLh749BCWdQESt7NaHgD8u9OY1/H00wWUoa0anh0ncK+t7
         bvdxgzgsruMJwO+US5fZy1Kz0AsxonUV1kieXoX8dJ8nLOhfU1FDs0X0H9fk2UPge11u
         KqUEwJJ3XS43BiFBQiJkxrcocrYQdnMaLVfHJd6s/T/RC7FTywLT1w4V8fgw+l4HN3Uj
         AiC0QCUD2neZ66rBS19DqZycDG3YlVNwvka7lQsCjClHW9kdINdOTzrvSn7JZJdQrvTZ
         Q7Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EE+5vXR6A4AKhBg4Wq8Kn/uiwfPM/feLwvp278kmBtE=;
        b=B1njTxlf+wcCDLyTtd+15+7WWvUzHhdIGB13HW1NBro0Vx7r4XEnWHEuCtmB525r1J
         OerKnDLUhQ5B/H+87q1kcoeEoAkkN1pn/4J7xXM3oCpMUhndJE8AtYs/gm1J2cmVgmE5
         4gcv1PN6gj+stmkccuEaYS0OdXfNAkLQGQuHb2fHMQANxg6BGDx2i8wQtFG7liK/Lx1z
         s/JvoaT4M9C+DO+5DQ7Meb0lJ6yhbywfvripzjDpRz7vvSigrArrJDQcwvb2o56fdDPo
         Q3794GUQxK/6VoUrhyhrpKSYdA9ismEmFutwhuI25lBm0b25rMNEH4v1lumzuvo0YNkJ
         Sl9w==
X-Gm-Message-State: AFqh2kqgvVvxBMKYO6/KHaIQQ+GNGA91v5oZMrmeLJbMr49CrbpPiCN9
        eHwwasw2ZuQGhV0+/tbfc9ue++Ex4TlC+pI3DkC2/+Nq
X-Google-Smtp-Source: AMrXdXubLX3osZ9coC8wO/YlymcavKWLiyQM8odDvV4K+15WI+b0EltWadxFXgU+QF7J01XzCmS7gLqTC8/zs2Zkdx8=
X-Received: by 2002:a62:2945:0:b0:582:4d0c:6f5c with SMTP id
 p66-20020a622945000000b005824d0c6f5cmr3649978pfp.44.1673624594512; Fri, 13
 Jan 2023 07:43:14 -0800 (PST)
MIME-Version: 1.0
References: <20230112140743.7438-1-u9012063@gmail.com>
In-Reply-To: <20230112140743.7438-1-u9012063@gmail.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Fri, 13 Jan 2023 07:43:02 -0800
Message-ID: <CAKgT0UfANmVSfGue37zO+D692rnPn8WNX3p8FKRPZ=90yzObTg@mail.gmail.com>
Subject: Re: [RFC PATCH net-next v13] vmxnet3: Add XDP support.
To:     William Tu <u9012063@gmail.com>
Cc:     netdev@vger.kernel.org, jsankararama@vmware.com, gyang@vmware.com,
        doshir@vmware.com, gerhard@engleder-embedded.com,
        alexandr.lobakin@intel.com, bang@vmware.com, tuc@vmware.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 12, 2023 at 6:07 AM William Tu <u9012063@gmail.com> wrote:
>
> The patch adds native-mode XDP support: XDP DROP, PASS, TX, and REDIRECT.
>
> Background:
> The vmxnet3 rx consists of three rings: ring0, ring1, and dataring.
> For r0 and r1, buffers at r0 are allocated using alloc_skb APIs and dma
> mapped to the ring's descriptor. If LRO is enabled and packet size larger
> than 3K, VMXNET3_MAX_SKB_BUF_SIZE, then r1 is used to mapped the rest of
> the buffer larger than VMXNET3_MAX_SKB_BUF_SIZE. Each buffer in r1 is
> allocated using alloc_page. So for LRO packets, the payload will be in one
> buffer from r0 and multiple from r1, for non-LRO packets, only one
> descriptor in r0 is used for packet size less than 3k.
>
> When receiving a packet, the first descriptor will have the sop (start of
> packet) bit set, and the last descriptor will have the eop (end of packet)
> bit set. Non-LRO packets will have only one descriptor with both sop and
> eop set.
>
> Other than r0 and r1, vmxnet3 dataring is specifically designed for
> handling packets with small size, usually 128 bytes, defined in
> VMXNET3_DEF_RXDATA_DESC_SIZE, by simply copying the packet from the backend
> driver in ESXi to the ring's memory region at front-end vmxnet3 driver, in
> order to avoid memory mapping/unmapping overhead. In summary, packet size:
>     A. < 128B: use dataring
>     B. 128B - 3K: use ring0 (VMXNET3_RX_BUF_SKB)
>     C. > 3K: use ring0 and ring1 (VMXNET3_RX_BUF_SKB + VMXNET3_RX_BUF_PAGE)
> As a result, the patch adds XDP support for packets using dataring
> and r0 (case A and B), not the large packet size when LRO is enabled.
>
> XDP Implementation:
> When user loads and XDP prog, vmxnet3 driver checks configurations, such
> as mtu, lro, and re-allocate the rx buffer size for reserving the extra
> headroom, XDP_PACKET_HEADROOM, for XDP frame. The XDP prog will then be
> associated with every rx queue of the device. Note that when using dataring
> for small packet size, vmxnet3 (front-end driver) doesn't control the
> buffer allocation, as a result we allocate a new page and copy packet
> from the dataring to XDP frame.
>
> The receive side of XDP is implemented for case A and B, by invoking the
> bpf program at vmxnet3_rq_rx_complete and handle its returned action.
> The vmxnet3_process_xdp(), vmxnet3_process_xdp_small() function handles
> the ring0 and dataring case separately, and decides the next journey of
> the packet afterward.
>
> For TX, vmxnet3 has split header design. Outgoing packets are parsed
> first and protocol headers (L2/L3/L4) are copied to the backend. The
> rest of the payload are dma mapped. Since XDP_TX does not parse the
> packet protocol, the entire XDP frame is dma mapped for transmission
> and transmitted in a batch. Later on, the frame is freed and recycled
> back to the memory pool.
>
> Performance:
> Tested using two VMs inside one ESXi vSphere 7.0 machine, using single
> core on each vmxnet3 device, sender using DPDK testpmd tx-mode attached
> to vmxnet3 device, sending 64B or 512B UDP packet.
>
> VM1 txgen:
> $ dpdk-testpmd -l 0-3 -n 1 -- -i --nb-cores=3 \
> --forward-mode=txonly --eth-peer=0,<mac addr of vm2>
> option: add "--txonly-multi-flow"
> option: use --txpkts=512 or 64 byte
>
> VM2 running XDP:
> $ ./samples/bpf/xdp_rxq_info -d ens160 -a <options> --skb-mode
> $ ./samples/bpf/xdp_rxq_info -d ens160 -a <options>
> options: XDP_DROP, XDP_PASS, XDP_TX
>
> To test REDIRECT to cpu 0, use
> $ ./samples/bpf/xdp_redirect_cpu -d ens160 -c 0 -e drop
>
> Single core performance comparison with skb-mode.
> 64B:      skb-mode -> native-mode
> XDP_DROP: 1.6Mpps -> 2.4Mpps
> XDP_PASS: 338Kpps -> 367Kpps
> XDP_TX:   1.1Mpps -> 2.3Mpps
> REDIRECT-drop: 1.3Mpps -> 2.3Mpps
>
> 512B:     skb-mode -> native-mode
> XDP_DROP: 863Kpps -> 1.3Mpps
> XDP_PASS: 275Kpps -> 376Kpps
> XDP_TX:   554Kpps -> 1.2Mpps
> REDIRECT-drop: 659Kpps -> 1.2Mpps
>
> Limitations:
> a. LRO will be disabled when users load XDP program
> b. MTU will be checked and limit to
>    VMXNET3_MAX_SKB_BUF_SIZE(3K) - XDP_PACKET_HEADROOM(256) -
>    SKB_DATA_ALIGN(sizeof(struct skb_shared_info))
>
> Signed-off-by: William Tu <u9012063@gmail.com>

I don't see anything else that jumps out at me as needing to be addressed.

Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
