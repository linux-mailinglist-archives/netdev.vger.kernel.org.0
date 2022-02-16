Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E1B14B93CE
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 23:24:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237007AbiBPWYO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 17:24:14 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236979AbiBPWYO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 17:24:14 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0A35E23D3EB
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 14:24:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645050240;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bAJ6BYombLsJhUsYzUrsttdjvWIKcfXL7xSsIlKXCIM=;
        b=FSi15x/k83Zdx4/bL+zczgCSG4zds0mY0YurhY5R0ISILzHC4FAsHQmAAOA73UY9bHUP1G
        7BIKOChZHyNxfbAxM8vktYcb5s+jI6vhiM7BaPvc8d15LCc0e/KKBZzqy6F1tKgMUW7jph
        YCz19tFNn1JUGaS5F5C4ocO2c6l26RE=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-320-MUhi2UwxNnOmbOYkeFEhwQ-1; Wed, 16 Feb 2022 17:23:58 -0500
X-MC-Unique: MUhi2UwxNnOmbOYkeFEhwQ-1
Received: by mail-wm1-f70.google.com with SMTP id r11-20020a1c440b000000b0037bb51b549aso2659300wma.4
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 14:23:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bAJ6BYombLsJhUsYzUrsttdjvWIKcfXL7xSsIlKXCIM=;
        b=xebkSIpOS1YXZ7bCU1+k6oNLdYVYlpt9vMgPFdL88KoQiL2zkZqS5eBz45Uuzo0160
         Eh1iFJtsBH+lBmUhVgto7VM+DTKVX23HvqR9BOLeoCznWYNQpjkDaRt8TIklppx0je8E
         jw7gnKriw2VFeucl1caShlh5RNtL8+w3PX0puzd91LFYxkXARoywgHlmeYDJSKw0Y2Bp
         xkKS5ShAgVgGoM05T9taY4UQpTxmIoLVIKANz9jM7jhWCXobS3kEG9WoWX6TvWkgkrr8
         4po78TR8NxO1uKUrezkXiLy8bc0I2UpPJTv61uL9XNYm9lkBF9tNvMrjDHo4oDBCHxI+
         6Ptw==
X-Gm-Message-State: AOAM530KjqU/DdjmPc3/kZzxvfIrVQR5Kw7GIBwY4oXbDnlqzjk/q4h0
        gVyvCri7NQ4brFm1gwAPy6EbO55Y+r3T1y0XSJkl0S4mNWgXum/EI/wr0iotE91YJX2WNBAcD4N
        E+rdPfBeuoo+FfJIg
X-Received: by 2002:a05:6000:2a2:b0:1e8:6dd5:767b with SMTP id l2-20020a05600002a200b001e86dd5767bmr85733wry.444.1645050237477;
        Wed, 16 Feb 2022 14:23:57 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxkvpcZpsU8GOJti65A4Jk4im9KbB30pxuoEd3Z+5Nr23/oYYSlEb1zL7X0TlITUvTboj03aQ==
X-Received: by 2002:a05:6000:2a2:b0:1e8:6dd5:767b with SMTP id l2-20020a05600002a200b001e86dd5767bmr85723wry.444.1645050237210;
        Wed, 16 Feb 2022 14:23:57 -0800 (PST)
Received: from pc-4.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id c18sm31837187wro.81.2022.02.16.14.23.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Feb 2022 14:23:55 -0800 (PST)
Date:   Wed, 16 Feb 2022 23:23:52 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     dsahern@gmail.com, stephen@networkplumber.org,
        netdev@vger.kernel.org
Subject: Re: [RFC iproute2] tos: interpret ToS in natural numeral system
Message-ID: <20220216222352.GA3432@pc-4.home>
References: <20220216194205.3780848-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220216194205.3780848-1-kuba@kernel.org>
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 16, 2022 at 11:42:05AM -0800, Jakub Kicinski wrote:
> Silently forcing a base numeral system is very painful for users.
> ip currently interprets tos 10 as 0x10. Imagine user's bash script
> does:
> 
>   .. tos $((TOS * 2)) ..
> 
> or any numerical operation on the ToS.
> 
> This patch breaks existing scripts if they expect 10 to be 0x10.

I agree that we shouldn't have forced base 16 in the first place.
But after so many years I find it a bit dangerous to change that.

What about just printing a warning when the value isn't prefixed with
'0x'? Something like (completely untested):

@@ -535,6 +535,12 @@ int rtnl_dsfield_a2n(__u32 *id, const char *arg)
 	if (!end || end == arg || *end || res > 255)
 		return -1;
 	*id = res;
+
+	if (strncmp("0x", arg, 2))
+		fprintf(stderr,
+			"Warning: dsfield and tos parameters are interpreted as hexadecimal values\n"
+			"Use 'dsfield 0x%02x' to avoid this message\n", res);
+
 	return 0;
 }


> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> --
> I get the feeling this was discussed in the past.
> 
> Also there's more:
> 
> devlink/devlink.c:	val = strtoull(str, &endptr, 10);
> devlink/devlink.c:	val = strtoul(str, &endptr, 10);
> devlink/devlink.c:	val = strtoul(str, &endptr, 10);
> devlink/devlink.c:	val = strtoul(str, &endptr, 10);
> lib/utils.c:	res = strtoul(arg, &ptr, base);
> lib/utils.c:		n = strtoul(cp, &endp, 16);
> lib/utils.c:		tmp = strtoul(tmpstr, &endptr, 16);
> lib/utils.c:		tmp = strtoul(arg + i * 3, &endptr, 16);
> misc/lnstat_util.c:			unsigned long f = strtoul(ptr, &ptr, 16);
> tc/f_u32.c:	htid = strtoul(str, &tmp, 16);
> tc/f_u32.c:		hash = strtoul(str, &tmp, 16);
> tc/f_u32.c:			nodeid = strtoul(str, &tmp, 16);
> tc/tc_util.c:	maj = strtoul(str, &p, 16);
> tc/tc_util.c:	maj = strtoul(str, &p, 16);
> tc/tc_util.c:		min = strtoul(str, &p, 16);

After a very quick look, many of these seem to make sense though. For
example lnstat_util.c parses output from /proc, hexstring_a2n() is used
by ipmacsec.c to parse crypto keys, etc.

But I agree that we should probably audit the strtol() (and variants)
that don't use base 0.

> ---
>  lib/rt_names.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/lib/rt_names.c b/lib/rt_names.c
> index b976471d7979..7eb63dad7d4d 100644
> --- a/lib/rt_names.c
> +++ b/lib/rt_names.c
> @@ -531,7 +531,7 @@ int rtnl_dsfield_a2n(__u32 *id, const char *arg)
>  		}
>  	}
>  
> -	res = strtoul(arg, &end, 16);
> +	res = strtoul(arg, &end, 0);
>  	if (!end || end == arg || *end || res > 255)
>  		return -1;
>  	*id = res;
> -- 
> 2.34.1
> 

