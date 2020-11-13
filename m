Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 138A02B25EF
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 21:54:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726543AbgKMUyH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 15:54:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726092AbgKMUyH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 15:54:07 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 285ACC0613D1
        for <netdev@vger.kernel.org>; Fri, 13 Nov 2020 12:54:07 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id 34so4796341pgp.10
        for <netdev@vger.kernel.org>; Fri, 13 Nov 2020 12:54:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=n49VU+5gSzvqk1lyNtCutB9GBykXEZ7P1U86PcwHJ/U=;
        b=s55i0pNUoeZshxgRJLgzYNNUVbCSReEEABN+m11hmTwnVEReXHC6XSaNIHu/ah083V
         T+0j1KxKRjJKKqaTRflqf7U9j90zSD+AUgZNlFNO4SzjJj+yFLNzkjXPhCfCc3dEIjkz
         +EFmIi4vPFMghYi8hgtteYq1PHjBMWXY9uanh6Vs+mMxmrhQ4OjU7A8w0L709m0qagDb
         Z9UrpmD71tAJPEhWXjOqGFhfUJsE1H6z4ATRIUB9qSoOnttY+NR0KMPwVXURveEspco0
         WrMIof6QugJKHAjmoaNBxR2RnIhut/mJRlruaMi0WBW8g1KXOIFgC8PqlShbxHgiZUhW
         y4UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=n49VU+5gSzvqk1lyNtCutB9GBykXEZ7P1U86PcwHJ/U=;
        b=VJpe+pvjmNpzlQQXX+ayQoBPzpMYoQUC2KJiAGGYfJ8JCsR6B7oyQyWUrY/9LLjmBB
         sRk6T5Nh3H6Ji3ySDpxhPV2kdrndQwwD8Hssuu+WUvSUp9q17AOtl7HsVpMSjpE1PQo4
         193zTC128HDE5n2vZE0Df8Bfo2NhSb9vf2fQy4UW2QM5p27/E5BT6QmFmuzK6rU+EiQR
         cd41BrDYnGpEsqfSuuKWHdHRO2TEJl0OGftp4mL001MGFtrjrUAEkitkhnn/1wHlVxOk
         U8EGLhEzujJyOcCKF4mqpPKb4qyg7YGFwTp4YiS30k/hmRAIkkitxBaOu0bcQkBUAvb7
         /84Q==
X-Gm-Message-State: AOAM533XIzhykMgTtxsLGdVM9HTe0a7ZDTn6qlsTFub04Agg8m4Zzkjf
        jZGYLUTyG+s6ccc+stt3+eMLiJBNyKNKdw8W
X-Google-Smtp-Source: ABdhPJxk1F8NjLrsHY8By4LYgm++G/ly7JY5vKXD7SlHjANNDlsE+itQ2xaBy2B9PDGrfFFLW8epIQ==
X-Received: by 2002:a63:f843:: with SMTP id v3mr3482796pgj.412.1605300846741;
        Fri, 13 Nov 2020 12:54:06 -0800 (PST)
Received: from ?IPv6:2601:648:8400:9ef4:34d:9355:e74:4f1b? ([2601:648:8400:9ef4:34d:9355:e74:4f1b])
        by smtp.gmail.com with ESMTPSA id q19sm10838071pfh.37.2020.11.13.12.54.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2020 12:54:06 -0800 (PST)
Message-ID: <60f766ec7553471f774314459e849dc3f3324aea.camel@gmail.com>
Subject: Re: [PATCH 1/3] net: add support for sending probe messages
From:   Andreas Roeseler <andreas.a.roeseler@gmail.com>
To:     davem@davemloft.net
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        netdev@vger.kernel.org
Date:   Fri, 13 Nov 2020 12:54:05 -0800
In-Reply-To: <20201113050234.8165-1-andreas.a.roeseler@gmail.com>
References: <cover.1605238003.git.andreas.a.roeseler@gmail.com>
         <20201113050234.8165-1-andreas.a.roeseler@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-11-12 at 21:02 -0800, Andreas Roeseler wrote:
> Modifying the ping_supported function to support probe messages
> allows
> users to send probe messages while using the existing framework for
> sending ping messages.
> 
> Signed-off-by: Andreas Roeseler <andreas.a.roeseler@gmail.com>
> ---
>  net/ipv4/ping.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
> index 248856b301c4..0077ef838fef 100644
> --- a/net/ipv4/ping.c
> +++ b/net/ipv4/ping.c
> @@ -453,7 +453,9 @@ EXPORT_SYMBOL_GPL(ping_bind);
>  static inline int ping_supported(int family, int type, int code)
>  {
>         return (family == AF_INET && type == ICMP_ECHO && code == 0)
> ||
> -              (family == AF_INET6 && type == ICMPV6_ECHO_REQUEST &&
> code == 0);
> +              (family == AF_INET && type == ICMP_EXT_ECHO  && code
> == 0) ||
> +              (family == AF_INET6 && type == ICMPV6_ECHO_REQUEST &&
> code == 0) ||
> +              (family == AF_INET6 && type == ICMPV6_EXT_ECHO_REQUEST
> && code == 0);
>  }
>  
>  /*


