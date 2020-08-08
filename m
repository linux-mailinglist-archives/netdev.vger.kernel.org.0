Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1410D23F85B
	for <lists+netdev@lfdr.de>; Sat,  8 Aug 2020 19:37:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726400AbgHHRhl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Aug 2020 13:37:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726200AbgHHRhk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Aug 2020 13:37:40 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78B8DC061756;
        Sat,  8 Aug 2020 10:37:40 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id l15so4398461ils.2;
        Sat, 08 Aug 2020 10:37:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Jd2roWdNEMfG+4gvo7ecPuN3gEg3eBvXK66IE/OKjWE=;
        b=Q/xJ6Albug/dh/TXnY1J/dhPZmpKUvB5cALfJoCdN2NdkDaQ61DhMyydWZZe/1xS/6
         +YePUHa2cXlO9SV2VKxJo2ur1hnmc7nM9nJVkyM1lpv2n/2H3M/oMnX5HR8oHzUzz8oK
         zuIkIg6iTm2CN9E4mfevEhpUcegEo+wMcYsWBH5tbxA2WYCc8SOf4jtUtFqPMpq06ISJ
         1PBvmxFmUSO86qPY09aXej6XJIpvmFLs9iXbXLW+0wLTTDNV+C1wLqdtSm7XQ/PC+nFk
         He6M7FTpEwISlHf0MQFCAtpbOqGT5Fdl+3SWQZ8pXc2DHO1uaKwJNrhyUj8adxxJrFqO
         LsIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Jd2roWdNEMfG+4gvo7ecPuN3gEg3eBvXK66IE/OKjWE=;
        b=KlPH9rj0lGhwyXamovqimDIhe0tehT+ZJ4O275UsdZQJ99GUupW85G/C6Wxj0CgUC2
         2VuFvv/7edfiBzHFZ5DtyNanX6mClyMQed1n8PXqvZQoOUDqirzaK9tCjpv3FWHGc8Hl
         vObZaU41l7z6ItN2RDpv3lFFqmBcj9ffN7i1iJbp61SAGeeI3iQS9NsDQLh4CvV14y0U
         WBbeYQZWu+4SfEMrvim86y6QaXcY+oaZHt0G+knWbHtkFp/iZFiph8RG29nRSsSgr78A
         JA4FsN5BVt5iJ1tANGV+n2NIyS8f0HQFLll9rjs/FdNoS/cFWCebUdD6we1sfX5sg8Fe
         AlaQ==
X-Gm-Message-State: AOAM532QiLjeW/hWaJHXJUGMnpRJxFdLRTY8jKuuwwFtrQYou1In+EHj
        r2DQpPABntZFQqAWs3Ocu2Ylkxgr+x13jqRpwXU=
X-Google-Smtp-Source: ABdhPJzBAzrH7FehaQ18kJ2CFVpEnYMbY6TD8YjBFV5r/TwNOAOadvIzgnlZpF/HOVFIeCxFBSmSCLhng/cwiRcOGws=
X-Received: by 2002:a05:6e02:f94:: with SMTP id v20mr10495513ilo.268.1596908257845;
 Sat, 08 Aug 2020 10:37:37 -0700 (PDT)
MIME-Version: 1.0
References: <20200728021348.4116-1-gaurav1086@gmail.com> <20200808170653.8515-1-gaurav1086@gmail.com>
In-Reply-To: <20200808170653.8515-1-gaurav1086@gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sat, 8 Aug 2020 10:37:26 -0700
Message-ID: <CAM_iQpWd4Z+7-WFUW0vCuRXMrJ4PjP424LDu6wce0O_A-y2rng@mail.gmail.com>
Subject: Re: [PATCH] [net/ipv6] ip6_output: Add ipv6_pinfo null check
To:     Gaurav Singh <gaurav1086@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>, Shaohua Li <shli@fb.com>,
        "open list:NETWORKING [IPv4/IPv6]" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 8, 2020 at 10:07 AM Gaurav Singh <gaurav1086@gmail.com> wrote:
>
> This PR fixes a possible segmentation violation.
>
> In function: ip6_xmit(), we have
> const struct ipv6_pinfo *np = inet6_sk(sk); which returns NULL
> unconditionally (regardless sk being  NULL or not).
>
> In include/linux/ipv6.h:
>
> static inline struct ipv6_pinfo * inet6_sk(const struct sock *__sk)
> {
>     return NULL;
> }
>

Tell us who will use ip6_autoflowlabel() when CONFIG_IPV6
is disabled. :)
