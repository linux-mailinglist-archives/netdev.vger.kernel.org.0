Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E3825634F7
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 16:17:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230211AbiGAORS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 10:17:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbiGAORR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 10:17:17 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E48F39165
        for <netdev@vger.kernel.org>; Fri,  1 Jul 2022 07:17:16 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id a4so4212610lfm.0
        for <netdev@vger.kernel.org>; Fri, 01 Jul 2022 07:17:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aDy2r2mjNIey2tPTZ8zMxUgrEjDJxv0DxpMM+pZ6/4k=;
        b=SqkszKs4pfzF1RGuj4lTFzrOC9SjlE3Yn7SpRRJaFllAa8Djqy53LuHimwc+kB46DU
         6V6sd/DnqKAx1u3clDR9U8OeKkmX70Hr5ZwVQuFXdn+uy9ajmMZkZqwSvq1N+huaPBkX
         2iUiswocAbov3DESf/3YW6+m03T0pMiXNd96sCCjMHKlAS+/pQVmNeXnD8ODpY/TXeMp
         vbnOpSAFSKdM03nt6xcbSIoLTcPC1QyOvjX6DrxLik6K7QgTUwvFnXd+4M/v9L3eicAH
         jJTMX5dZbLcyFYMY+p2SQNRzwqPXen8KI14ZcQL9FujkO7e9gpU2ov6hnKm+T0XMppXv
         OZ8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aDy2r2mjNIey2tPTZ8zMxUgrEjDJxv0DxpMM+pZ6/4k=;
        b=fHGxlAqCG5sxfcl9w4GtNTmA8kpwGw9chGnwXpiw1Uvo+f4A6xvTpua2cIIOsZTiwc
         3LKkSxKkgrc3A8L2FjuuRhemaAfUeMgmjfNQgVz/oTtGTly+h+DKMqe/wKWGlgAQoayw
         gpDk86m7CP2GnH6Cin+qBud+BXVVmcVY0DTrZI/xlKBHtbv4W964QFa97APdVKOyvcra
         L1EwSGBhln0huN/y7OJWhlXAvX6B4Y3tciqTSTsNiuq4SqdaL/x9HbPgDTSzvs9iaOUT
         1LxcowA9U83bI5vj/U/AIEHEnOX92RWCvprBSGCYyIZwIfEbnS1mw5jS6Zkuv71cMsYI
         b0QA==
X-Gm-Message-State: AJIora9wVu9RSQHaqvGyBEdBu9WDpWmRp00e/UcJ+LMBPf2wvH87MBIB
        h1KqXbVEZ10NzGNqnsOwFtIeTr+atRjpfQj2Vq4=
X-Google-Smtp-Source: AGRyM1uESkUdJ2Cuz5qWhHV2HHEaEwFTzEo/j04MR9jXks1jlM5kvyc4vp80H/WauqPYpK+DbIzKX/Ok2F5nlzs6XSU=
X-Received: by 2002:a05:6512:4029:b0:47f:65ed:1e45 with SMTP id
 br41-20020a056512402900b0047f65ed1e45mr10052885lfb.611.1656685034689; Fri, 01
 Jul 2022 07:17:14 -0700 (PDT)
MIME-Version: 1.0
References: <20220629014927.2123-1-u9012063@gmail.com> <e863a394-a2af-505b-5c5c-cbf8b4a1819f@redhat.com>
In-Reply-To: <e863a394-a2af-505b-5c5c-cbf8b4a1819f@redhat.com>
From:   William Tu <u9012063@gmail.com>
Date:   Fri, 1 Jul 2022 07:16:38 -0700
Message-ID: <CALDO+SYoYXKqvHb6ZjHpY_gFXtzXcEhH+5SeGBShTcdfgFB9qA@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] vmxnet3: Add basic XDP support.
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        doshir@vmware.com, Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        gyang@vmware.com, William Tu <tuc@vmware.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 1, 2022 at 12:11 AM Jesper Dangaard Brouer
<jbrouer@redhat.com> wrote:
>
>
> On 29/06/2022 03.49, William Tu wrote:
> > The patch adds native-mode XDP support: XDP_DROP, XDP_PASS, and XDP_TX.
> > The vmxnet3 rx consists of three rings: r0, r1, and dataring.
> > Buffers at r0 are allocated using alloc_skb APIs and dma mapped to the
> > ring's descriptor. If LRO is enabled and packet size is larger than
> > 3K, VMXNET3_MAX_SKB_BUF_SIZE, then r1 is used to mapped the rest of
> > the buffer larger than VMXNET3_MAX_SKB_BUF_SIZE. Each buffer in r1 is
> > allocated using alloc_page. So for LRO packets, the payload will be
> > in one buffer from r0 and multiple from r1, for non-LRO packets,
> > only one descriptor in r0 is used for packet size less than 3k.
> >
> [...]
> >
> > Need Feebacks:
> [...]
>
> > e. I should be able to move the run_xdp before the
> >     netdev_alloc_skb_ip_align() in vmxnet3_rq_rx_complete
> >     so avoiding the skb allocation overhead.
>
> Yes please!
>
> Generally speaking the approach of allocating an SKB and then afterwards
> invoking XDP BPF-prog goes against the principle of native-XDP.

That's a great point, thank you!
I will work on the next version.
William
