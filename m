Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B0A5303BBB
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 12:35:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392380AbhAZLep (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 06:34:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405179AbhAZLeK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 06:34:10 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A52D3C061573
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 03:33:29 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id l9so22464175ejx.3
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 03:33:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hg+rMSsqsjBIEYrvbsiJ7xrX7E/QT/4b3cx5oO7n+Tk=;
        b=RI6U59VCI4sJt13Wrl8JLRKjIJrWD9/U/I/tLlViw4rTXxQnTLTzUY/MacjHNhELYI
         Q3KXqTuLRn4RHbkDkb0m41XsWq+WYMX5lrHZzUqiJHpLP8SWO9vwUOGCk2PtC+OroYs5
         1AH6l1oQR3IZXB76gs6mBDRu3/+8n9zTDtgr37U5EScP73YHhhke+7mjYxDzcSOJ22Yy
         mkL0ZgjDCfFTn5R1sBQV834kHZjaqlWTxtbM5CnICMpsBMs0Is9B+h+ibqJoIwTFZQjJ
         FeHMZr5FTNwFJrjwRqp0MoP/YLih5JjqLO3/Yi7C+oJl6+3Oh7iRZGrXyJZUB9/L8d2M
         qR6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hg+rMSsqsjBIEYrvbsiJ7xrX7E/QT/4b3cx5oO7n+Tk=;
        b=XXzFGvcZWB7o9RWeU+4gSLuhVzxZmJDVQaGMeIz2ClVb8S3xrUnjW52A1+lntddfLP
         TwCcT04Xm8C+/+Rm22XBRk24sXyjJC0bNLgJd6w0NqRFgJlgQRTRF2t1XtT/TsLaRufm
         Uj7J52qj7UsFB1KMvEGS+0BE2J/J7ibALF/FZJZ7TJRnRorrCk2YXqWS/iCK95KkUq+w
         onvmKxSb0D3eN0hJYK8VVghrlyKCVZXAiPc8OVsZa/f8WPp7xzhAcJ/Dk0U44BfbRdNF
         MupoaO3/w9gPINeAkNhnhzLkXBAiThVnhCKe1+PqN85TFPgnjfNZsN0RUD6sGuYA1f0K
         jeyQ==
X-Gm-Message-State: AOAM531sMRrnp5Vvv+c9Kbv3bw1yqqe+j6t/u5oQ1fVm5uClYXTpPPRI
        cHxm/Hue34vltCysH+/xat/hrg==
X-Google-Smtp-Source: ABdhPJxX0X1TwxDUKm251Utb6uBsV7IR/qJMbYCzAug+0wSG93cx14O8ujkQ/sFETvHfHblpoWV8Kw==
X-Received: by 2002:a17:906:3146:: with SMTP id e6mr3030574eje.363.1611660808478;
        Tue, 26 Jan 2021 03:33:28 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id h16sm12453790edw.34.2021.01.26.03.33.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jan 2021 03:33:27 -0800 (PST)
Date:   Tue, 26 Jan 2021 12:33:26 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Ahern <dsahern@gmail.com>, Jakub Kicinski <kuba@kernel.org>,
        netdev@vger.kernel.org, davem@davemloft.net,
        jacob.e.keller@intel.com, roopa@nvidia.com, mlxsw@nvidia.com,
        vadimp@nvidia.com
Subject: Re: [patch net-next RFC 00/10] introduce line card support for
 modular switch
Message-ID: <20210126113326.GO3565223@nanopsycho.orion>
References: <X/+nVtRrC2lconET@lunn.ch>
 <20210119115610.GZ3565223@nanopsycho.orion>
 <YAbyBbEE7lbhpFkw@lunn.ch>
 <20210120083605.GB3565223@nanopsycho.orion>
 <YAg2ngUQIty8U36l@lunn.ch>
 <20210120154158.206b8752@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210121153224.GE3565223@nanopsycho.orion>
 <971e9eff-0b71-8ff9-d72c-aebe73cab599@gmail.com>
 <20210122072814.GG3565223@nanopsycho.orion>
 <YArdeNwXb9v55o/Z@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YArdeNwXb9v55o/Z@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Jan 22, 2021 at 03:13:12PM CET, andrew@lunn.ch wrote:
>> I don't see any way. The userspace is the one who can get the info, from
>> the i2c driver. The mlxsw driver has no means to get that info itself.
>
>Hi Jiri
>
>Please can you tell us more about this i2c driver. Do you have any
>architecture pictures?

Quoting Vadim Pasternak:
"
Not upstreamed yet.
It will be mlxreg-lc driver for line card in drivers/platfrom/mellanox and
additional mlxreg-pm for line card powering on/off, setting enable/disable
and handling power off upon thermal shutdown event.
"


>
>It is not unknown for one driver to embed another driver inside it. So
>the i2c driver could be inside the mlxsw. It is also possible to link
>drivers together, the mlxsw could go find the i2c driver and make use
>of its services.

Okay. Do you have examples? How could the kernel figure out the relation
of the instances?


>
>   Andrew
