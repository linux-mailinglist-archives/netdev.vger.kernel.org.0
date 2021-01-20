Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A30942FDF5F
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 03:32:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390734AbhATXuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 18:50:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391182AbhATWTo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 17:19:44 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 959A3C0613CF
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 14:18:53 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id 31so967063plb.10
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 14:18:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Xb9j/aFYqhgDrE/OXqRppy/BYsE4FbiAfkQug+nxK3E=;
        b=lbsQJCpyyAJ08lcUAZ4JP7q2VanTBPkg4vJrSQDbIUBHKiTw5iFJp20ae2mcX7Usek
         EAd6ABsC6wfw8cO0wDwvEMZnJHXOTbCwmQeXGAolvKQcW7/w7UyIZfP7LlM/sm28IFaL
         +jcA+ixKLJBMXQtGzqm6wRydkOej2rvRW/ixtPeWZ2GxrErY1m89dG9xSCx3aaFXhAd1
         X8qe8sGhuSCc1iRjzBHRbooPQDMxHG0GV0M3TBVo1rZmocibS0OaRnuzMo2YxT+B3Hdf
         Q9p0oL/CQ4sZ7YAepQqaEpPZiQi6lNuz0rkk+MSKgDE5OcKiTOA2pB+NHIteSso0sitf
         qwNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Xb9j/aFYqhgDrE/OXqRppy/BYsE4FbiAfkQug+nxK3E=;
        b=Nk0Q9fp/co/oYx7S9VsaQ1YDnDcwApeYcqnPpt8wzHKUybLMZutlm+Ls8pvvT+hHhE
         E6Dzl3H1cwQKHKXBmK7jRM7TkK+mnjDyQPuviNb0dB5d2sRWDZQC0q89x/cJ9RIEn8+y
         HwNbfWFAHQXWRlsoIJQPCGVAG5C54x0BiF11lu+nI3JXJJTLOKsIFJcn1kLcHUXQiW7j
         zBGqFPlTh7hglwos2w/Vxyo7Rogihb+L1yG8yEDPHXoWCGl7xVosWUFGKCnxF8eQMwHJ
         JwCEOZ1V2wMjOHv7ejVM/5eHRLLPa41yiXw/oecZ6ZXt+NYBuvh3o78aConyhUaW0/xe
         Ck8g==
X-Gm-Message-State: AOAM531ufPtxiFQJTdEdmvHhD/pySpg+iVFqUyvsSQHUNQcHBlZOZ5XQ
        wY3rqsXSEbIDswWNNGBaVt+K0b4TkZrel8vm9Xej3dRI6kZ92w==
X-Google-Smtp-Source: ABdhPJzSYMiOufDt3ifoZqPpjcLnOf+mEHYggmh1qgmNoNt9K1w7PhG87PjYky84aHSAE5YAKCa+9t4ihJYN3bIAWpU=
X-Received: by 2002:a17:902:d909:b029:df:52b4:8147 with SMTP id
 c9-20020a170902d909b02900df52b48147mr7302424plz.33.1611181133080; Wed, 20 Jan
 2021 14:18:53 -0800 (PST)
MIME-Version: 1.0
References: <1611045110-682-1-git-send-email-wenxu@ucloud.cn>
In-Reply-To: <1611045110-682-1-git-send-email-wenxu@ucloud.cn>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 20 Jan 2021 14:18:41 -0800
Message-ID: <CAM_iQpVs5WOS0-Y7RvpOr12F8u84Rwna8EQ0NzuFof7Suc7Wyw@mail.gmail.com>
Subject: Re: [PATCH v2 net-next ] net/sched: cls_flower add CT_FLAGS_INVALID
 flag support
To:     wenxu <wenxu@ucloud.cn>
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 19, 2021 at 12:33 AM <wenxu@ucloud.cn> wrote:
> diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
> index 2d70ded..c565c7a 100644
> --- a/net/core/flow_dissector.c
> +++ b/net/core/flow_dissector.c
> @@ -237,9 +237,8 @@ void skb_flow_dissect_meta(const struct sk_buff *skb,
>  void
>  skb_flow_dissect_ct(const struct sk_buff *skb,
>                     struct flow_dissector *flow_dissector,
> -                   void *target_container,
> -                   u16 *ctinfo_map,
> -                   size_t mapsize)
> +                   void *target_container, u16 *ctinfo_map,
> +                   size_t mapsize, bool post_ct)

Why do you pass this boolean as a parameter when you
can just read it from qdisc_skb_cb(skb)?

Thanks.
