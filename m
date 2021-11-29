Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 187624623FC
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 23:09:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231357AbhK2WMb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 17:12:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231492AbhK2WKa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 17:10:30 -0500
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CFF1C043AD2;
        Mon, 29 Nov 2021 12:50:59 -0800 (PST)
Received: by mail-ot1-x32a.google.com with SMTP id n104-20020a9d2071000000b005799790cf0bso27293265ota.5;
        Mon, 29 Nov 2021 12:50:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pJBTR3BH6vzrkacIA76MPyr7dPfgB6U0dNhSAI4N4Ow=;
        b=kca9GB/UCYu/dIREElCnm6R+uO8PYnBQSUu5QC9nBgCepubV7A9WvE9bv0WzRHXcKH
         l5JEhAY7xZk3yAoXwirrzDRrGOkI6xu6+bSass6mcGggN6gTduzROcT6CSI/A3SOTZl/
         ZVgevoFT2H/kFgAiKazJ6baFaROT1pWEUScjF/DRfv/3pJILr7HVhmLG0w778cq6iDhG
         624tQPYtKod9U3QgxgibN3njIu2Az4TJHYYGnymVcVkO3eVYFzKglkpp0qIJcnWPI1ud
         mbd6bJdw5K/4MXnqvkai+8eUOpfoN09fX9arVlIcULGrnC63V11yrcZNm30erZFfUeHt
         mjWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pJBTR3BH6vzrkacIA76MPyr7dPfgB6U0dNhSAI4N4Ow=;
        b=afctQqt7LdVONkaaQ+q55LpmrbLZiTrRx4LxgyrpvYeC5wgGPi6kzUqxnR3hQLKGzC
         zFoTw5hcjLEdaoFqXCh0VjjAojBSsFuJGnMhL9LmnnqreGBW+OQCxDj3yKqd2th5a97g
         ZS0YxaeBRgdX4LNrr2M/r/5TsdZE31SqK4Somjrw0CccmDWBxeMCNXDa26eI2nB3oUVS
         kRvDYBdRGu2GV7fdNkg6KB9KfrUs5PDhdlD1glKCrT4m3h47joERaIbjcDnFi7GbXjKA
         +ng2uPsEwQvs/ctcSbbcQ56csITQo9QihilSCF10xKKbxjLSMCc2vhJPYjOVaKDDAyE0
         dXOw==
X-Gm-Message-State: AOAM531y427Y8tWD0PxuWdniC1WolpcTJrJzudwQjKsXAqpjdRICWYbZ
        xIe6Uhn/Tb//PM4F1WAC2ee00N6dbRc=
X-Google-Smtp-Source: ABdhPJw/AOSYVMeVke9r4fhDJ9GYRZc0SXypBrljMQAVMd5lAKeZ7m4mJPYSkgxynWY48hhD6+pfQg==
X-Received: by 2002:a05:6830:1be9:: with SMTP id k9mr46292294otb.123.1638219058858;
        Mon, 29 Nov 2021 12:50:58 -0800 (PST)
Received: from localhost ([2600:1700:65a0:ab60:fb28:e684:3c51:f69c])
        by smtp.gmail.com with ESMTPSA id o6sm2436638oou.41.2021.11.29.12.50.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Nov 2021 12:50:58 -0800 (PST)
Date:   Mon, 29 Nov 2021 12:50:57 -0800
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     Song Liu <song@kernel.org>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Cong Wang <cong.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>
Subject: Re: [PATCH bpf] libbpf: fix missing section "sk_skb/skb_verdict"
Message-ID: <YaU9Mdv+7kEa4JOJ@unknown>
References: <20211126204108.11530-1-xiyou.wangcong@gmail.com>
 <CAPhsuW4zR5Yuwuywd71fdfP1YXX5cw6uNmhqULHy8BhfcbEAAQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPhsuW4zR5Yuwuywd71fdfP1YXX5cw6uNmhqULHy8BhfcbEAAQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 26, 2021 at 04:20:34PM -0800, Song Liu wrote:
> On Fri, Nov 26, 2021 at 12:45 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> >
> > From: Cong Wang <cong.wang@bytedance.com>
> >
> > When BPF_SK_SKB_VERDICT was introduced, I forgot to add
> > a section mapping for it in libbpf.
> >
> > Fixes: a7ba4558e69a ("sock_map: Introduce BPF_SK_SKB_VERDICT")
> > Cc: Daniel Borkmann <daniel@iogearbox.net>
> > Cc: John Fastabend <john.fastabend@gmail.com>
> > Cc: Jakub Sitnicki <jakub@cloudflare.com>
> > Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> 
> The patch looks good to me. But seems the selftests are OK without this. So,
> do we really need this?
> 

Not sure if I understand this question.

At least BPF_SK_SKB_STREAM_PARSER and BPF_SK_SKB_STREAM_VERDICT are already
there, so either we should remove all of them or add BPF_SK_SKB_VERDICT for
completeness.

Or are you suggesting we should change it back in selftests too? Note, it was
changed by Andrii in commit 15669e1dcd75fe6d51e495f8479222b5884665b6:

-SEC("sk_skb/skb_verdict")
+SEC("sk_skb")

Thanks.
