Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FD294467D9
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 18:26:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233498AbhKER2X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Nov 2021 13:28:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233339AbhKER2W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Nov 2021 13:28:22 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D36D5C061714;
        Fri,  5 Nov 2021 10:25:42 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id v11so32950152edc.9;
        Fri, 05 Nov 2021 10:25:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zR7gjaO8D9e9k4JQe4B1G7VMwYnRn+OnExSmrC8Eg4Q=;
        b=HCZB9md5YEecz/sj0Pacg7o0bR+4mX9W2k9US04rhg29hUvCnyxQcrZxaJdUGsyPAV
         l/ZadxIJDjDhltEOCFf9mQUzc4AI2CYyEU6WTtS1lvT1+ligH7rNMnWQ0AMG54seRgZS
         zIKZfDMD3DsnD4V6ku8LlFfGkH+fZ+rGdkM7es1AhhoVhqYLxC45FEpC9yiSMb0kVrWP
         WBsY050llar3nlYY3xNddDwH9qTHtQ9qCxbUIh+JvYeOUjHeHV0UNt9513isPFUe/a1l
         9Ssx6nUa6MieF3hshgpNNGJZmmybBLeyiLEPNAXu3GubyPDF6N/KnhWUWjqQC1N1+Qvb
         3DXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zR7gjaO8D9e9k4JQe4B1G7VMwYnRn+OnExSmrC8Eg4Q=;
        b=ah4FFt/84acVNQtVpRr3KxCD/u2rUVav3mP+n4QZc1otaH3oh75DdPUZhcEGt/TQTh
         IGl42Rwc9dtlrRoCpoJvN021mnsTHlBZqfGdP97oMKU2s6SdLqmysj6+yk5PY5263EL/
         OMo7aw3Jh2OKP0Ngpu+eVoPhi8GpXa6+TaifYItn8QDR6iRqN+qpFAD/HUQNpmoDjecR
         dk5hRh+yCGRdzkGplqQPWocjtgb27RHxSQAC8dSEhLuTGzr7HdM5SHrWjILbCebqHUQY
         GVsFVobW0ypwAlUO+VWEi2pb3oQAZIGZ6Z9L6vJvyXUnA5nQ6Ysm+9ff4N0m4V0buxLB
         R5TQ==
X-Gm-Message-State: AOAM532SHVwDSbCi0A5WtilB77NcyQexWQBiAEt2g1aMRW/6nJqEwXjO
        KpqpZTZneYi3SlYSyOLiWb4=
X-Google-Smtp-Source: ABdhPJxhzAeyoGkbFUnkmxIBZhLH0gGI6yUJx2Utxvme6jHRwwR3OXYPptmhkDNPzo3rqBUpFkOE1g==
X-Received: by 2002:a05:6402:350f:: with SMTP id b15mr5121519edd.25.1636133141356;
        Fri, 05 Nov 2021 10:25:41 -0700 (PDT)
Received: from skbuf ([188.25.175.102])
        by smtp.gmail.com with ESMTPSA id i13sm4497697edc.62.2021.11.05.10.25.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Nov 2021 10:25:40 -0700 (PDT)
Date:   Fri, 5 Nov 2021 19:25:39 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Martin Kaistra <martin.kaistra@linutronix.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 7/7] net: dsa: b53: Expose PTP timestamping ioctls to
 userspace
Message-ID: <20211105172539.2bmj4bavcyw2uimf@skbuf>
References: <20211104133204.19757-1-martin.kaistra@linutronix.de>
 <20211104133204.19757-8-martin.kaistra@linutronix.de>
 <20211104174251.GB32548@hoboy.vegasvil.org>
 <ba543ae4-3a71-13fe-fa82-600ac37eaf5a@linutronix.de>
 <20211105141319.GA16456@hoboy.vegasvil.org>
 <20211105142833.nv56zd5bqrkyjepd@skbuf>
 <20211105080939.2508a51e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211105080939.2508a51e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 05, 2021 at 08:09:39AM -0700, Jakub Kicinski wrote:
> On Fri, 5 Nov 2021 16:28:33 +0200 Vladimir Oltean wrote:
> > On Fri, Nov 05, 2021 at 07:13:19AM -0700, Richard Cochran wrote:
> > > On Fri, Nov 05, 2021 at 02:38:01PM +0100, Martin Kaistra wrote:  
> > > > Ok, then I will remove HWTSTAMP_FILTER_PTP_V2_(EVENT|SYNC|DELAY_REQ) from
> > > > this list, what about HWTSTAMP_FILTER_ALL?  
> > > 
> > > AKK means time stamp every received frame, so your driver should
> > > return an error in this case as well.  
> > 
> > What is the expected convention exactly? There are other drivers that
> > downgrade the user application's request to what they support, and at
> > least ptp4l does not error out, it just prints a warning.
> 
> Which is sad because that's one of the best documented parts of our API:
> 
>   Desired behavior is passed into the kernel and to a specific device by
>   calling ioctl(SIOCSHWTSTAMP) with a pointer to a struct ifreq whose
>   ifr_data points to a struct hwtstamp_config. The tx_type and
>   rx_filter are hints to the driver what it is expected to do. If
>   the requested fine-grained filtering for incoming packets is not
>   supported, the driver may time stamp more than just the requested types
>   of packets.
> 
>   Drivers are free to use a more permissive configuration than the requested
>   configuration. It is expected that drivers should only implement directly the
>   most generic mode that can be supported. For example if the hardware can
>   support HWTSTAMP_FILTER_V2_EVENT, then it should generally always upscale
>   HWTSTAMP_FILTER_V2_L2_SYNC_MESSAGE, and so forth, as HWTSTAMP_FILTER_V2_EVENT
>   is more generic (and more useful to applications).
> 
>   A driver which supports hardware time stamping shall update the struct
>   with the actual, possibly more permissive configuration. If the
>   requested packets cannot be time stamped, then nothing should be
>   changed and ERANGE shall be returned (in contrast to EINVAL, which
>   indicates that SIOCSHWTSTAMP is not supported at all).
> 
> https://www.kernel.org/doc/html/latest/networking/timestamping.html#hardware-timestamping-configuration-siocshwtstamp-and-siocghwtstamp

Yeah, sorry, I've been all over that documentation file for the past few
days, but I missed that section. "that's one of the best documented
parts of our API" is a nice euphemism for all the SO_TIMESTAMPING flags :)
