Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59116312C1F
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 09:45:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbhBHIoa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 03:44:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230229AbhBHIkH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 03:40:07 -0500
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD766C061788;
        Mon,  8 Feb 2021 00:39:26 -0800 (PST)
Received: by mail-il1-x132.google.com with SMTP id a16so12001082ilq.5;
        Mon, 08 Feb 2021 00:39:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=xrlABt8xZzBMmL1usXf8h81+BV1kZdYMMJHdZ44mqiU=;
        b=ih8odndVnd/L56HleuyXjfd06/ZiXz4mxQkqJN7Tc1nUF9gKlyAH9tRmMNFIeuC9JW
         tEb7V3tna3744zT13Yd5nhBgjpLzj+aSXn7goSWAoJoSOVJPs7Qa/4Bjtq7S8gDN3U9R
         pzQUNeXqxb6D1D/jFsdkggSfBBshifpJbOjeBg7uyMrtO1XYMzFCmfSa6vsG5DJCPKnM
         PfyTz6UB4gQOkz7X0YvsNax0zhJC4FMgVzoVS54WKySmij8DymmYykWeJrb6sK05VL0Q
         3Wf3XrEtryE0riUWZl+HpWHeTI/GZpCmNVUUKglW8sSKTHFK9cW0Qig0op26di6iXWLd
         wHFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=xrlABt8xZzBMmL1usXf8h81+BV1kZdYMMJHdZ44mqiU=;
        b=HIGKo8pEmthe3imKh8C9SO2oswjkojAC2xHF1OqNsKNDNUzDrRoyrCPJZtF+7rIaBx
         JN6xeGeCR7j3baDR8Dovu4ACsBXJm8P8x7V4gfVcpu0Qna1QW92Zn05tt1Tkt4RZTTgY
         5dh32KzO3KfaxUIk/YQTU6v+G1J6ywWhtChu/xdOwMaffC3bAcqE67Ga1paoUlqLY9Qt
         oHAYQ6ubNZ2q4//GVX1kw+xi7CWFUz3hNMBzIWOajvIyhfFKRCpUIupO59UzV+T0K6bi
         G3MFexHi4i8Go9y3aUPuOVFMO9mrEmuV5Ca8cVhXgfsvr73CIL5+vHs47+OFkfk5yhys
         0p3A==
X-Gm-Message-State: AOAM532qUJbqkGRyAU4uocZNUyQiu2p3Jur4rh3uOeklWapYdhHKdZIW
        EmQDeC5GJIKsugYZ+cLA4e8=
X-Google-Smtp-Source: ABdhPJwtLaGW+EkLcoH7sdqwOw8rgzYpp8ViUahZJi1dDBoL6YCT8Nkzuw0yX2j84+w5T4AdFWSsRw==
X-Received: by 2002:a92:90d:: with SMTP id y13mr13332508ilg.193.1612773566405;
        Mon, 08 Feb 2021 00:39:26 -0800 (PST)
Received: from localhost ([172.243.146.206])
        by smtp.gmail.com with ESMTPSA id f9sm8376327ilu.36.2021.02.08.00.39.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Feb 2021 00:39:25 -0800 (PST)
Date:   Mon, 08 Feb 2021 00:39:18 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        duanxiongchun@bytedance.com, wangdongdong.6@bytedance.com,
        jiang.wang@bytedance.com, Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>
Message-ID: <6020f8b616d4_cc8682087d@john-XPS-13-9370.notmuch>
In-Reply-To: <87ft2a4uz4.fsf@cloudflare.com>
References: <20210203041636.38555-1-xiyou.wangcong@gmail.com>
 <20210203041636.38555-3-xiyou.wangcong@gmail.com>
 <87ft2a4uz4.fsf@cloudflare.com>
Subject: Re: [Patch bpf-next 02/19] skmsg: get rid of struct sk_psock_parser
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Sitnicki wrote:
> On Wed, Feb 03, 2021 at 05:16 AM CET, Cong Wang wrote:
> > From: Cong Wang <cong.wang@bytedance.com>
> >
> > struct sk_psock_parser is embedded in sk_psock, it is
> > unnecessary as skb verdict also uses ->saved_data_ready.
> > We can simply fold these fields into sk_psock.
> >
> > Cc: John Fastabend <john.fastabend@gmail.com>
> > Cc: Daniel Borkmann <daniel@iogearbox.net>
> > Cc: Jakub Sitnicki <jakub@cloudflare.com>
> > Cc: Lorenz Bauer <lmb@cloudflare.com>
> > Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> > ---
> 
> This one looks like a candidate for splitting out of the series, as it
> stands on its own, to make the itself series smaller.
> 
> Also, it seems that we always have:
> 
>   parser.enabled/bpf_running == (saved_data_ready != NULL)
> 
> Maybe parser.enabled can be turned into a predicate function.
> 
> [...]

Agree. To speed this along consider breaking it into three
series.

 - couple cleanup things: this patch, config option, etc.

 - udp changes

 - af_unix changes.

Although if you really think udp changes and af_unix need to go
together that is fine imo. I think the basic rule is to try and avoid
getting patch counts above 10 or so if at all possible.

At least this patch, the renaming patch, and the config patch
can get pulled out into their own series so we can get those
merged and out of the way.

Thanks,
John
