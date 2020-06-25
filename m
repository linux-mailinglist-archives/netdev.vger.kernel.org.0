Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E781209981
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 07:33:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389330AbgFYFdD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 01:33:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389269AbgFYFdC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 01:33:02 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59DEFC061573
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 22:33:02 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id ne5so2497269pjb.5
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 22:33:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WaaM3CapQRCm9l8U5fCupaPv5QwTL30GYhYrJayXvKg=;
        b=KVh5xkOtKgSlxXwSffynXsu2rSDI7kAEXITvtIUv9ulX6CkuJOsm90PhzMV/H8ZD8d
         2cg8bm2vd4KcpWsxcvAd8+ALJKQGIfDAGmmv1HDTVlcJeQiGhVYwQJxHwqPT8gUgi+WP
         E6xm80h7uK4oJ1uyHiyDPjINvEM8iSzz0QZrG8EaT6hIJCvaNWukyniyrYnw4jhY6Mj+
         EOeinCuk8+fxOuEm3AKccfhZBMBpZhq/mhb6Zou4Gq59gc/XV1dUZpun3gu4KO2cKpRj
         HQIYoRhFeNg/9jjjKqluwH+xOqBw83n5gkfWbGYT5m2Ns38XO7dbsYGvRNUWLBHDiY5w
         HlyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WaaM3CapQRCm9l8U5fCupaPv5QwTL30GYhYrJayXvKg=;
        b=Uu9mM9y6aK4JfAmb4MzWDvaQU4I2GurzsERxkYB/c6kZUg6AH3t5IYSJVak6CuAnVJ
         0y1QBLnArsWtcZ4gVutIOS80oD3H5qyLiXPE3tv8ywm8XowiwqHWg1BR38ezgWQyneSn
         Y+4MH+RT7ifolbk+zxrzZ0mKr9o7oRHUg1f5Et+s6rLRp3W5pFwjUM0iQoA9opXwiJoh
         RO+UZTvCvviYsrYCI+ORRUsLdS+amXhdqu7sQbctsFua+q4154gj/Vnckt/NBFzlkAgI
         R2CX+nLiEj7IJN7ALaDQX+AmTscinDYHF5bRkOxJm8VHgzGPLsCSxpkgo8hjwM3CNnRw
         Tmwg==
X-Gm-Message-State: AOAM532hXHbsOfAHD+9CioVRCL6k5K26s7182sESl1qwT4YSoQ5ZFVXP
        Htw3ntHXSoBRqHkYLSIXXlyB4g==
X-Google-Smtp-Source: ABdhPJyTet2oNhtO+zRBfE7nBdQNLQagjqtuJMp42oQ1TeTg1SkOv4PnqMmRMPvEZtN4xzd0IiRsmQ==
X-Received: by 2002:a17:90a:ea18:: with SMTP id w24mr1478110pjy.158.1593063181930;
        Wed, 24 Jun 2020 22:33:01 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id y3sm21886749pff.37.2020.06.24.22.33.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2020 22:33:01 -0700 (PDT)
Date:   Wed, 24 Jun 2020 22:32:58 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Michal Kubecek <mkubecek@suse.cz>, netdev <netdev@vger.kernel.org>,
        Chris Healy <cphealy@gmail.com>
Subject: Re: [ethtool v2 4/6] Add --json command line argument parsing
Message-ID: <20200624223258.140f6cad@hermes.lan>
In-Reply-To: <20200625001244.503790-5-andrew@lunn.ch>
References: <20200625001244.503790-1-andrew@lunn.ch>
        <20200625001244.503790-5-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 25 Jun 2020 02:12:42 +0200
Andrew Lunn <andrew@lunn.ch> wrote:

> diff --git a/internal.h b/internal.h
> index edb07bd..7135140 100644
> --- a/internal.h
> +++ b/internal.h
> @@ -23,6 +23,8 @@
>  #include <sys/ioctl.h>
>  #include <net/if.h>
>  
> +#include "json_writer.h"
> +
>  #define maybe_unused __attribute__((__unused__))
>  
>  /* internal for netlink interface */
> @@ -221,6 +223,8 @@ struct cmd_context {
>  	int argc;		/* number of arguments to the sub-command */
>  	char **argp;		/* arguments to the sub-command */
>  	unsigned long debug;	/* debugging mask */
> +	bool json;		/* Output JSON, if supported */
> +	json_writer_t *jw;      /* JSON writer instance */

You can avoid the boolean by just checking for NULL jw variable.
