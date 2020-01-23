Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B04B145FCA
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 01:19:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726885AbgAWATL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 19:19:11 -0500
Received: from mail-ed1-f65.google.com ([209.85.208.65]:38274 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725911AbgAWATL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 19:19:11 -0500
Received: by mail-ed1-f65.google.com with SMTP id i16so1526736edr.5
        for <netdev@vger.kernel.org>; Wed, 22 Jan 2020 16:19:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sATq3SYQOC2Hl5pALtWQ8Qp36rqVIBG61dWJGw3H18E=;
        b=vDFpdCeD/u6WKSflXronpeVz9PtCKkGtDMKfZlSRFHVdgDWSABkGvJVm4DLsQQPa6T
         fctg70cUEUtWB4lbTEm37dJkxYKKBTFGfJHB3NvLeuR+Fa0MbQhpYM2YoqfnGS25QBC2
         oHG3LagPRr4K7vknwvbAqL2+cbjTZymnSFIh4E0dZCTVPzWwPDssJ0FTIoezmoJ2M5vg
         D1Bw/JrT4Muw2SKfU4cmeuQO83Mzys1Jp7AT/BpEC5TUPp2C4E5GojW+tHJg3qYe/CtG
         hpTsYIo+WEHtYHxcjaJSiPHagOShWXJe40jpy1Dyl0jMALUuVDojoXsJcnR8fkBl+QWD
         9mRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sATq3SYQOC2Hl5pALtWQ8Qp36rqVIBG61dWJGw3H18E=;
        b=B+6NZHLiNsgGHDyidaupgXNPPkc7ZxTV/YrxGFDlMZbAkXXX+IAVdZcgUndBjYnC9N
         RMM6xysd6NQ8hKTErIiZ7FarhQ1Sv+xIqVfzQbSZxNWQQZtdNJ9eWGgt81AmNSORG7zz
         g6KJ9z4QFu1bdeOaENopIFFN+sGFsfWNfo/3RPuArTR/M6QmcqVpFjdD+QSlJH1bYy7z
         euvEX/9zz97qlkiz7gR/32s7HQ8q+Up0FAKPjD7K3VNss/Bysj5GBOnEfowilwf6mNVe
         /3d8Zwdcxd/ugsEcHDY+/4/rwSzDkSqBJKDzHznCdoAgio5MfYkBZFbceIALn/ijfXpE
         8lVg==
X-Gm-Message-State: APjAAAV+n/xHriYV1BmYT3QrBSmyopLoSN2dF4ZrK1LXDLozhy5xBD/A
        CDNaqzoSXrAdFRxIYlm5uqzXgiCUSsjzE5IpvFlpiFjw/IA=
X-Google-Smtp-Source: APXvYqxQJZXgb7o/HXDAsasBq1ceqDqrCrXHPGw1pAnDF6zH4rCX4k8Y3FrSn+HQ8GsqfZfVBObFzMfSCnbZ/Ac9sfI=
X-Received: by 2002:aa7:c2cb:: with SMTP id m11mr5181194edp.89.1579738749122;
 Wed, 22 Jan 2020 16:19:09 -0800 (PST)
MIME-Version: 1.0
References: <20200122223326.187954-1-lrizzo@google.com> <20200122234753.GA13647@lunn.ch>
In-Reply-To: <20200122234753.GA13647@lunn.ch>
From:   Luigi Rizzo <lrizzo@google.com>
Date:   Wed, 22 Jan 2020 16:18:56 -0800
Message-ID: <CAMOZA0LiSV2WyzfHuU5=_g0Ru2z-osx0B-WkS-QHMaQeY4GXeA@mail.gmail.com>
Subject: Re: [PATCH] net-core: remove unnecessary ETHTOOL_GCHANNELS initialization
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Michal Kubecek <mkubecek@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 22, 2020 at 3:47 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Wed, Jan 22, 2020 at 02:33:26PM -0800, Luigi Rizzo wrote:
> > struct ethtool_channels does not need .cmd to be set when calling the
> > driver's ethtool methods. Just zero-initialize it.
> >
> > Tested: run ethtool -l and ethtool -L
>
> Hi Luigi
>
> This seems pretty risky. You are assuming ethtool is the only user of
> this API. What is actually wrong with putting a sane cmd value, rather
> than the undefined value 0.

Hi Andrew, if I understand correctly your suggestion is that even if
the values are
unused, it is better to stay compliant with the header file
include/uapi/linux/ethtool.h,
which does suggest a value for .cmd for the various structs, and only
replace the value
in ethtool_set_channels() with the correct one ETHTOOL_SCHANNELS ?

cheers
luigi

>
>      Andrew
