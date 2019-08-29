Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69645A2214
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 19:21:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727707AbfH2RVR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 13:21:17 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:39099 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726973AbfH2RVR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 13:21:17 -0400
Received: by mail-pf1-f193.google.com with SMTP id y200so2505446pfb.6;
        Thu, 29 Aug 2019 10:21:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=k87dT0Iu+ulqGoBo1xzBIj9YrBih594+mmY3S69xuEs=;
        b=s5O8yNb7NoH2vA0lRZZHfMvZygue8Mx7KxgiVh2KbH/XGvNLFAqStZqUqsTG0GYdUW
         n3moMTU73a+PxMKCQ3l9cgb4lbXF5PaTskKCK5mNkWmBmO7854Aav5CD3CDN2f1s1vbk
         IHtcDId7EVEyIgmDFZi1HJa9msW+dnX724ByA7m/PWGf8gM3uWa2UqItSDWp9NQyJVXw
         TRSDJ2Rx1zS8R6PWYXVurRkpD3avcm+CfCykOmGTIcvyQmfgqFBvnBBMG73bl4kYVO50
         /K6r0Pqpnp2ZKqERqxeuSzMLtMi6CMpfObk/TUT+gq/H1bq7gv1RFC6eBzzirBQL2B9L
         g3IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=k87dT0Iu+ulqGoBo1xzBIj9YrBih594+mmY3S69xuEs=;
        b=J+8o7dVWovn9qKozRxGXoWY8yiPxVgzWLYPejCzhXBjzk7kKwJYG+pJ1p1JbmwDOmY
         Yn8KAutGeVyH8z6PUT+ClxjFNYGN9I7GjhzIyTFB0EyIXKXCb9aIokwtjsOvG/1SEdOs
         yyaE+x9pB88TdwENVrUS888i9ra50w6D65Q80/kYSM0ghzPfoB5MKBLnYgvoo0rEuzll
         dxaPH017C5gD/hBass/J614eKQJKU7FKRIAJmFjkj7if5RO9N/gHEw4Dw60HbH1tTwZJ
         /7R0rhUS4bBwwAfqjnhvGHBsIm/z+dfv/hXQwrM0bDKvW+ReyQroGHCCq02ef94ESwSC
         flLA==
X-Gm-Message-State: APjAAAX4iMQZSTeOPC5C7vifZ5aAUbxTsPpXGteEDEhAq9fkZl3XQ+J2
        5LaPHz+oM2Etl/zfQsF+IMw=
X-Google-Smtp-Source: APXvYqweNhxxRAW8xyJsKIbN9EJYNe87haGF35qasLCJEbQzmYsaM9Pyim2h7f2/WQjVTBdof1gNdA==
X-Received: by 2002:a63:2043:: with SMTP id r3mr9382590pgm.311.1567099276200;
        Thu, 29 Aug 2019 10:21:16 -0700 (PDT)
Received: from localhost (c-73-222-71-142.hsd1.ca.comcast.net. [73.222.71.142])
        by smtp.gmail.com with ESMTPSA id 71sm3909488pfw.157.2019.08.29.10.21.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2019 10:21:15 -0700 (PDT)
Date:   Thu, 29 Aug 2019 10:21:13 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Felipe Balbi <felipe.balbi@linux.intel.com>
Cc:     Christopher S Hall <christopher.s.hall@intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] PTP: introduce new versions of IOCTLs
Message-ID: <20190829172113.GA2166@localhost>
References: <20190829095825.2108-1-felipe.balbi@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190829095825.2108-1-felipe.balbi@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> @@ -139,11 +141,24 @@ long ptp_ioctl(struct posix_clock *pc, unsigned int cmd, unsigned long arg)
>  		break;
>  
>  	case PTP_EXTTS_REQUEST:
> +	case PTP_EXTTS_REQUEST2:
> +		memset(&req, 0, sizeof(req));
> +
>  		if (copy_from_user(&req.extts, (void __user *)arg,
>  				   sizeof(req.extts))) {
>  			err = -EFAULT;
>  			break;
>  		}
> +		if ((req.extts.flags || req.extts.rsv[0] || req.extts.rsv[1])
> +			&& cmd == PTP_EXTTS_REQUEST2) {
> +			err = -EINVAL;
> +			break;
> +		} else if (cmd == PTP_EXTTS_REQUEST) {
> +			req.extts.flags = 0;

This still isn't quite right.  Sorry that was my fault.

The req.extts.flags can be (PTP_ENABLE_FEATURE | PTP_RISING_EDGE |
PTP_FALLING_EDGE), and ENABLE is used immediately below in this case.

Please #define those bits into a valid mask, and then:

- for PTP_EXTTS_REQUEST2 check that ~mask is zero, and
- for PTP_EXTTS_REQUEST clear the ~mask bits for the drivers. 

Thanks again for cleaning this up!

Richard

> +			req.extts.rsv[0] = 0;
> +			req.extts.rsv[1] = 0;
> +		}
> +			
>  		if (req.extts.index >= ops->n_ext_ts) {
>  			err = -EINVAL;
>  			break;
