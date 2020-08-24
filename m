Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD6CF24F0F4
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 03:46:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727894AbgHXBp4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Aug 2020 21:45:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726600AbgHXBpz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Aug 2020 21:45:55 -0400
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD653C061573
        for <netdev@vger.kernel.org>; Sun, 23 Aug 2020 18:45:53 -0700 (PDT)
Received: by mail-ot1-x343.google.com with SMTP id e11so6063818otk.4
        for <netdev@vger.kernel.org>; Sun, 23 Aug 2020 18:45:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VkIrKKWc2G3OMQ969RIc4Lq15BKDuVxkX257AX2u/OU=;
        b=R22pT+BFy3TlCqrDp3Th3sqp85ko13BALOydub7l45duQhoGDA3bmmxbP8Tq0LTMMi
         yUqj8fjk/h4TbWtHmHKvMWeYobvDxur1iTZ+zU1q//gnbuBvjvRtbT5nsrPOQcgbOFSG
         uuaJ7dN9aim5ePX1ww9A/jrj5DHxFGPREfZIDiMdvf7noRbJoPQ+SYW1AB8gLRqwukTM
         HCiziGGbQPQB89PR3zjTbpxztcKE+j7PgaG5C9ofK4tPMjBUgl6wgZTy9gMdLlOQ2vI8
         C5+I42/4l36lmoe//u703wZpQylAkQIBm2dU8pihhJulU/JIS6XfdEKHk07GyKm8ftVf
         uYTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VkIrKKWc2G3OMQ969RIc4Lq15BKDuVxkX257AX2u/OU=;
        b=IKfDIoAnH7B/lTVNSdIW4hkGLDB1lk7ccllqLvw8p7tn2jXlMv1xZFuS8bZDona3OM
         vVXH11Qg3mgt2HC+okwVupYJTYD2JSAQ8wehuK6EMNGak+PNe/DlOuLSgBvOGMIv8Fht
         e//5sZdRYzR1mS48T3F7SkfGhtmBLeuEWWYqV01AFfZL8BvqENzkNJVoBvBk8GEGcN6k
         BRkOS9gNjXznk9cU/UaVR8wLzO+1mCxWAlKd1M+MPiVT1vlZkcpa7RYUh4wP8qVmT9b2
         Bdz7UyeZTVRx8AgpfhDyk1XjVssrNLNAdpaXlScAMVkiDjBI52KjMMgV3UnkRODWp2jA
         4tZw==
X-Gm-Message-State: AOAM530MhS0uPXvv5ZYmIm9G/q7S8eqHevsnPNEkEQbj10nmOKEVWIoa
        A4ytpfjFF89MZVIjVKnh25M0D4l3RTP26A==
X-Google-Smtp-Source: ABdhPJyKouChiLJd3puYvzD3JXEQW2WzcxiRso+mnHK/IVonuOz69t+n4V1k2M0phyARnmkixHiofQ==
X-Received: by 2002:a9d:6b8e:: with SMTP id b14mr2144507otq.307.1598233553155;
        Sun, 23 Aug 2020 18:45:53 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:39b0:ac18:30c6:b094])
        by smtp.googlemail.com with ESMTPSA id s141sm2022757oos.11.2020.08.23.18.45.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 23 Aug 2020 18:45:52 -0700 (PDT)
Subject: Re: [PATCH 2/2] genl: ctrl: support dumping netlink policy
To:     Johannes Berg <johannes@sipsolutions.net>, netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>
References: <20200819102903.21740-1-johannes@sipsolutions.net>
 <20200819102903.21740-2-johannes@sipsolutions.net>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <3e300840-35ea-5f05-e9c1-33a66646042e@gmail.com>
Date:   Sun, 23 Aug 2020 19:45:51 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200819102903.21740-2-johannes@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/19/20 4:29 AM, Johannes Berg wrote:
> @@ -100,6 +102,30 @@ static int print_ctrl_grp(FILE *fp, struct rtattr *arg, __u32 ctrl_ver)
>  
>  }
>  
> +static const char *get_nla_type_str(unsigned int attr)
> +{
> +	switch (attr) {
> +#define C(x) case NL_ATTR_TYPE_ ## x: return #x
> +	C(U8);
> +	C(U16);
> +	C(U32);
> +	C(U64);
> +	C(STRING);
> +	C(FLAG);
> +	C(NESTED);
> +	C(NESTED_ARRAY);
> +	C(NUL_STRING);
> +	C(BINARY);
> +	C(S8);
> +	C(S16);
> +	C(S32);
> +	C(S64);
> +	C(BITFIELD32);
> +	default:
> +		return "unknown";
> +	}
> +}
> +

This should go in libnetlink since it generic NLA type strings.

>  /*
>   * The controller sends one nlmsg per family
>  */

