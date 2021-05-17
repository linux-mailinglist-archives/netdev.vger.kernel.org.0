Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19C903822D2
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 04:38:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233619AbhEQCje (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 May 2021 22:39:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233524AbhEQCjb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 May 2021 22:39:31 -0400
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8BCAC061573
        for <netdev@vger.kernel.org>; Sun, 16 May 2021 19:38:14 -0700 (PDT)
Received: by mail-oi1-x232.google.com with SMTP id j75so5174245oih.10
        for <netdev@vger.kernel.org>; Sun, 16 May 2021 19:38:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=C0keYZq7GxxCNmEQmdKc0qiDg+5bwRoN9U/D5UeSvz4=;
        b=lpxFqgTGKVicy1nTNmPh7vfl6iKmRxuiVYbmY14QqjiQed9qkBCluP5gEO7x42yzRO
         MCkNIzmqIMsAk/oNpmVJ872sXoHJP253B+8+Y+E/zkHAILXTtvwqaZ4FqX6BNkLRDxgy
         g2+i7zrxgDCmh/wvEuUWh/vo38pZ/0egYV7tsXaaYBdJQ68fedDVTIzbvXjNbvf/H6tJ
         qDX4EbqANcTHRqhHULQF2YEPTJ9hcRVr99Qb3PgHp+w+RruSicLvPxG3CVuGXPMDkwgH
         jrBqPXn5RGHO3XmeEnK52Ja/pjn2MkvUTOLR+S29Hazo8C63PqsV2AT/wIJcd2TIug1L
         xW/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=C0keYZq7GxxCNmEQmdKc0qiDg+5bwRoN9U/D5UeSvz4=;
        b=fnZwcEbtSsgFwmpQobzVnpNcM/ePASQruhIOcyPjvn2oXBpr7PxPdXMzK+c/jaSF8r
         YaaHbB+Vkg04g2rExo5vNw0Nxmd8P94MwAh3avo/0cCejBK9nQs3E5zanqzwLZaBnqPo
         dSxUiAlMXDVSGZ21vi5URMHj+naXfSZsKYxMmCUWo8trQnhNrGp/54Yk4kad2HCr8li+
         cjCRvFPxArEoOzM5NewUBqVOygQ5fS1bSO7yKkeMY7a0Ke2OtRjLz7z4cDgG6Hi3ay39
         NabSWfRYALqJKI9dTl0OJZ7OGQvvFCPKWDiz+cySk+8xbuHNaj4Qaa8OHmtvn7FfUkap
         DWhA==
X-Gm-Message-State: AOAM533eDWgRiQjTaqCIgeoUj0ZEIu6JFmDJtKzsEgToYl0t3GWmwZz9
        oW1qD8IzMtez2eKZ5FNy+TdsrFohfxsi6w==
X-Google-Smtp-Source: ABdhPJzzk1+4M8J2ZaJFHVYcmyooRa9DNGnDb0Vu7lQo0Qsd15QcPNzjxKefbSybkoMrU/XtTZrfOQ==
X-Received: by 2002:aca:4749:: with SMTP id u70mr15744029oia.37.1621219093956;
        Sun, 16 May 2021 19:38:13 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.22])
        by smtp.googlemail.com with ESMTPSA id m189sm2472877oif.45.2021.05.16.19.38.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 16 May 2021 19:38:13 -0700 (PDT)
Subject: Re: [PATCH iproute2 v2] libgenl: make genl_add_mcast_grp set errno on
 error
To:     Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org
References: <20210510120602.29288-1-fw@strlen.de>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <1a639c8d-6172-b1d2-f6f2-7d9d3d8ba970@gmail.com>
Date:   Sun, 16 May 2021 20:38:12 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210510120602.29288-1-fw@strlen.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/10/21 6:06 AM, Florian Westphal wrote:
> diff --git a/lib/libgenl.c b/lib/libgenl.c
> index 4c51d47af46b..8b22c06e7941 100644
> --- a/lib/libgenl.c
> +++ b/lib/libgenl.c
> @@ -84,6 +84,7 @@ static int genl_parse_grps(struct rtattr *attr, const char *name, unsigned int *
>  		}
>  	}
>  
> +	errno = ENOENT;
>  	return -1;
>  }
>  
> @@ -108,17 +109,22 @@ int genl_add_mcast_grp(struct rtnl_handle *grth, __u16 fnum, const char *group)
>  	ghdr = NLMSG_DATA(answer);
>  	len = answer->nlmsg_len;
>  
> -	if (answer->nlmsg_type != GENL_ID_CTRL)
> +	if (answer->nlmsg_type != GENL_ID_CTRL) {
> +		errno = EINVAL;
>  		goto err_free;
> +	}
>  
>  	len -= NLMSG_LENGTH(GENL_HDRLEN);
> -	if (len < 0)
> +	if (len < 0) {
> +		errno = EINVAL;
>  		goto err_free;
> +	}
>  
>  	attrs = (struct rtattr *) ((char *) ghdr + GENL_HDRLEN);
>  	parse_rtattr(tb, CTRL_ATTR_MAX, attrs, len);
>  
>  	if (tb[CTRL_ATTR_MCAST_GROUPS] == NULL) {
> +		errno = ENOENT;
>  		fprintf(stderr, "Missing mcast groups TLV\n");
>  		goto err_free;
>  	}
> 

I get compile errors on Ubuntu 20.04:


lib
    CC       libgenl.o
libgenl.c: In function ‘genl_parse_grps’:
libgenl.c:87:2: error: ‘errno’ undeclared (first use in this function)
   87 |  errno = ENOENT;
      |  ^~~~~
libgenl.c:12:1: note: ‘errno’ is defined in header ‘<errno.h>’; did you
forget to ‘#include <errno.h>’?
   11 | #include "libgenl.h"
  +++ |+#include <errno.h>
   12 |
libgenl.c:87:2: note: each undeclared identifier is reported only once
for each function it appears in
   87 |  errno = ENOENT;
      |  ^~~~~
libgenl.c:87:10: error: ‘ENOENT’ undeclared (first use in this function)
   87 |  errno = ENOENT;
      |          ^~~~~~
libgenl.c: In function ‘genl_add_mcast_grp’:
libgenl.c:113:3: error: ‘errno’ undeclared (first use in this function)
  113 |   errno = EINVAL;
      |   ^~~~~
libgenl.c:113:3: note: ‘errno’ is defined in header ‘<errno.h>’; did you
forget to ‘#include <errno.h>’?
libgenl.c:113:11: error: ‘EINVAL’ undeclared (first use in this function)
  113 |   errno = EINVAL;
      |           ^~~~~~
libgenl.c:127:11: error: ‘ENOENT’ undeclared (first use in this function)
  127 |   errno = ENOENT;
