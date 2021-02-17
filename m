Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCBB231DF83
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 20:21:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232812AbhBQTUT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 14:20:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232691AbhBQTUE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Feb 2021 14:20:04 -0500
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 145D0C061574;
        Wed, 17 Feb 2021 11:19:24 -0800 (PST)
Received: by mail-io1-xd29.google.com with SMTP id s17so6858861ioj.4;
        Wed, 17 Feb 2021 11:19:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=dpCrMI2t6+b/MeJZIr9UxYXodaRVsni1orGaLrBQ0yE=;
        b=k5uLXs1EYLtBPa3OuM4WzyYITShpfI9h1Fbh8iMghoRaNt58moAUOx62i5MEVUWQ8X
         3hHCbnZZrhm2NozS/9LKNPfLzZhFMPHzsdM/macxF9MePY3xEDjqfSJM5n4muOuWYHpC
         wTLGMztjzrOVMp3nLUO+dptq4voDSHvRBonGYDS+Gpz6VlOSCIXJhfE5OSQHe+TC4tcz
         2XMJiTE++qe/E3KeFEUEKwZBQ8jwiq8xz08fmUanHAceVMFnzC06X7qxhdOSoX5d5PHX
         Kle3d9OD4SXkeuH4ZKo9HPXz4fE6vCKJc+UO+WY1R7/66IAl61uMEwiU/UL776ro1n4M
         pyfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=dpCrMI2t6+b/MeJZIr9UxYXodaRVsni1orGaLrBQ0yE=;
        b=Avo26TRKn4QU6EYKVnAFT7lygd9mBzbZ+FNGskqvv5PpJSCoMiwIkZfb4Fjv3ukDKT
         3oLNMeD8NTWmIdzddD3zMUx0CQSzi3L4K6lCxTNzDqVG3nHoU4IwgpuDH1Gqpj03arur
         d88CVr8LzEiK1Stxw/EdL30v9Lan7j7bGQjq9Y0WM+dKh7vMIvkuKZP9UVSOJaOUlofZ
         2ePIBGt7+FON0nMRjFFEnUBhUrCC76AhQJ382DXSsTGG4cVHEi6wnJQ5mqx8iPySmVWU
         94Py7OR9lKQPUod08s48CzWUjsA7JDghfY9PaadUlR6yHEdCM7z8QH7vgQ9/vfdw/wai
         xK1g==
X-Gm-Message-State: AOAM532oMlHlLm5yo5tusz7GEbuS4CGVfDlXjw+q2U7JmBFQ86wkQzWH
        5EMjSR9DmSFY+M9OMLT3t/3v9B/QSDg=
X-Google-Smtp-Source: ABdhPJzjn2Q0nlblmM4L+QowysVbyvLKDlXl4HtP+X+SEXBxHLNtlE0MwpoDTjxUX6dlnxPfhqW0ow==
X-Received: by 2002:a02:c60c:: with SMTP id i12mr972596jan.28.1613589563141;
        Wed, 17 Feb 2021 11:19:23 -0800 (PST)
Received: from localhost ([172.243.146.206])
        by smtp.gmail.com with ESMTPSA id w9sm2004289ioj.0.2021.02.17.11.19.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Feb 2021 11:19:22 -0800 (PST)
Date:   Wed, 17 Feb 2021 11:19:16 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Lorenz Bauer <lmb@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        duanxiongchun@bytedance.com, wangdongdong.6@bytedance.com,
        jiang.wang@bytedance.com, Cong Wang <cong.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>
Message-ID: <602d6c342d136_aed9208a3@john-XPS-13-9370.notmuch>
In-Reply-To: <CACAyw99k43REGCh8cP1PioV+k-_BRAjecVHcmtOdL6fi2shxkQ@mail.gmail.com>
References: <20210213214421.226357-1-xiyou.wangcong@gmail.com>
 <20210213214421.226357-5-xiyou.wangcong@gmail.com>
 <602ac96f9e30f_3ed41208b6@john-XPS-13-9370.notmuch>
 <CACAyw99k43REGCh8cP1PioV+k-_BRAjecVHcmtOdL6fi2shxkQ@mail.gmail.com>
Subject: Re: [Patch bpf-next v3 4/5] skmsg: use skb ext instead of TCP_SKB_CB
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lorenz Bauer wrote:
> On Mon, 15 Feb 2021 at 19:20, John Fastabend <john.fastabend@gmail.com> wrote:
> >
> > Cong Wang wrote:
> > > From: Cong Wang <cong.wang@bytedance.com>
> > >
> > > Currently TCP_SKB_CB() is hard-coded in skmsg code, it certainly
> > > does not work for any other non-TCP protocols. We can move them to
> > > skb ext instead of playing with skb cb, which is harder to make
> > > correct.
> > >
> > > Cc: John Fastabend <john.fastabend@gmail.com>
> > > Cc: Daniel Borkmann <daniel@iogearbox.net>
> > > Cc: Jakub Sitnicki <jakub@cloudflare.com>
> > > Reviewed-by: Lorenz Bauer <lmb@cloudflare.com>
> > > Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> > > ---
> >
> > I'm not seeing the advantage of doing this at the moment. We can
> > continue to use cb[] here, which is simpler IMO and use the ext
> > if needed for the other use cases. This is adding a per packet
> > alloc cost that we don't have at the moment as I understand it.
> 
> John, do you have a benchmark we can look at? Right now we're arguing
> in the abstract.

Sure, but looks like Cong found some spare fields in sk_buff so
that looks much nicer.

I'll mess aound a bit with our benchmarks and see where we can
publish them. It would be good to have some repeatable tests
here folks can use.

Thanks,
John
