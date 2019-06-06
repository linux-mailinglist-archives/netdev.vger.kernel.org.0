Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CEE337876
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 17:47:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729499AbfFFPri (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 11:47:38 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:45882 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729185AbfFFPrh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 11:47:37 -0400
Received: by mail-pf1-f196.google.com with SMTP id s11so1736039pfm.12;
        Thu, 06 Jun 2019 08:47:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NfifDdL+NpCO8qPZ1Q4+MMf9WNKJ6AKEbZR6EHDrCsM=;
        b=olv0nqRUK9PV5cAJt8TjQa/fI6j8FDIWsOM0MUzfdeBXhSfGVgEIVByYGCkLjwtgk+
         +pGDQd+d39un0hq1WxQ46aDqE2upjHH+eJEpqGggIehYndps9BvDkdqGdtNigdZPMNnp
         xy9fTUnFVz+i8paHHEfSALaMX8art72kUgkd6E0Lt6SuWDooCZRmXoYvh40lz7OglTh+
         WVNvGLXYg4I7RuosFCBH9wT0VIqjyyit8rLYFyOuvcijM7TFR9deJRS8CQOGzhOambs0
         eQlqiMQmPaBTuNwyb25OuoUXBq3ao4zpNxl1A8c0srkJteNezNg4il06U0xTNTXvFbkj
         Pvsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NfifDdL+NpCO8qPZ1Q4+MMf9WNKJ6AKEbZR6EHDrCsM=;
        b=FS0CRnbsvoI9Jbj9XHHgvytA7rXDE3eMpCfP9jByePxJW2VcMkGSH7kcJVxnH4UbrF
         H6SZAbPCNSnsrSimvTBJgWZmBcoKTewg0bc7UmcqolzszKgPBuVAehX3fv1j+E5rE+hM
         +kqUudb352m5F+pZyJ8EPgbdEyza5wEDoKNmObFePolLh3WRGmoA0s8KmVSIF0OrfPBC
         LV7AZrk+NoM5cKsYv7mVmmv9kvEroQy2PHrYjXuoheTL4kCpYiayCGtbiO2FGignEzC4
         cgFkooow1OpP0Y0slkEwUB3OIf+0/Whnqlm60vSn60bBi4POPnMmo1BKFrRu8gnLVy8D
         p/uA==
X-Gm-Message-State: APjAAAUElNFT5hEBG0axbk2zF9gmudOT7E+qpRwUWIWzk51VXYd6jI9p
        YtPzS4/UXI0SQwRiEbAB/m3/f++BZYc=
X-Google-Smtp-Source: APXvYqw8iqwBtgu4kHw/IqFnUk5XYB2C8guVbizPQGLMCgaOX2UvyGGjIhC6POUFeiQg0wkXP1cuMw==
X-Received: by 2002:a62:fb0a:: with SMTP id x10mr31141215pfm.224.1559836057029;
        Thu, 06 Jun 2019 08:47:37 -0700 (PDT)
Received: from [172.27.227.242] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id u16sm2262264pje.6.2019.06.06.08.47.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Jun 2019 08:47:36 -0700 (PDT)
Subject: Re: [PATCH] net: ipv4: fib_semantics: fix uninitialized variable
To:     "Enrico Weigelt, metux IT consult" <info@metux.net>,
        linux-kernel@vger.kernel.org
Cc:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org
References: <1559832197-22758-1-git-send-email-info@metux.net>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <0ba84175-49be-9023-271d-516c93e2d83e@gmail.com>
Date:   Thu, 6 Jun 2019 09:47:34 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <1559832197-22758-1-git-send-email-info@metux.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/6/19 8:43 AM, Enrico Weigelt, metux IT consult wrote:
> From: Enrico Weigelt <info@metux.net>
> 
> fix an uninitialized variable:
> 
>   CC      net/ipv4/fib_semantics.o
> net/ipv4/fib_semantics.c: In function 'fib_check_nh_v4_gw':
> net/ipv4/fib_semantics.c:1027:12: warning: 'err' may be used uninitialized in this function [-Wmaybe-uninitialized]
>    if (!tbl || err) {
>             ^~
> 
> Signed-off-by: Enrico Weigelt <info@metux.net>
> ---
>  net/ipv4/fib_semantics.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
> index b804106..bfa49a8 100644
> --- a/net/ipv4/fib_semantics.c
> +++ b/net/ipv4/fib_semantics.c
> @@ -964,7 +964,7 @@ static int fib_check_nh_v4_gw(struct net *net, struct fib_nh *nh, u32 table,
>  {
>  	struct net_device *dev;
>  	struct fib_result res;
> -	int err;
> +	int err = 0;
>  
>  	if (nh->fib_nh_flags & RTNH_F_ONLINK) {
>  		unsigned int addr_type;
> 

what compiler version?

if tbl is set, then err is set.
