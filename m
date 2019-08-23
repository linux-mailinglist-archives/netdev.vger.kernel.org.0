Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54E109AFFE
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 14:56:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394906AbfHWMyT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 08:54:19 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:46668 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394903AbfHWMyT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Aug 2019 08:54:19 -0400
Received: by mail-qt1-f195.google.com with SMTP id j15so10983848qtl.13
        for <netdev@vger.kernel.org>; Fri, 23 Aug 2019 05:54:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LL/p3Oh0MeexxAXVyBQaDxVp1CsFK0KlId22tRqssGY=;
        b=Cgzb5vQIf5/L/HpjpoTTJcgwY9QS9V3cQZPGFK0EERUuYeJnBug287nLbwgaahvhYT
         JamwfTynCRLdJPe+f+buq8EpwtyfU4GvtEcMCy8DNlkiu3uvAxpRHq/GeS9SUsW6sjJV
         9JKBxDSP3DsIMADcEGz+0ffhjNBU/0VxehJMPBsupPoSAB8Ew5imhQatjsA5crjNd357
         jQZfjb1+xtCqCCbOm5tRnypgO3PcNsMY8GAo6UMdUYzy6742mDbBJo+1UEd3cYSMn3zj
         Rfcr/zMDjjaTF74Gr4/OICJyy+DllR2cuVvNvk4pFY3H2iXyL87Wy8KClqy1AleIvt7K
         90Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LL/p3Oh0MeexxAXVyBQaDxVp1CsFK0KlId22tRqssGY=;
        b=QZzdlKqiIosXu6Tm2LvgRoa0fGNj09NH9sxFjCgAvWJEEN3+kZNt2mJl0aMs0a1Wc1
         L+mqEjxAu55GkuNj1khqbd8NfpuTB6niYXqMWEbzb07Yj/ifHEi9H53R/lII5p725AvB
         Y0oqCs9tW/j45HP2TFw09m5bCO7tqiOteqTF8teSJYbQi8+FuVbBZwQaiadRnNb6bPef
         jQhFwOqjn5sV76aP8J6UK0IZbsi7KdnJV3zRFcHSrNcZ9Y2GGfxXWoMXUH+fD1zeHpAD
         XijZjBVd5IcUvL6T0ILV5Rg4BcKO7+CF+a7SXRPj/CTWhiL7IBMqWC/vE8IIATYDuQ6/
         lgag==
X-Gm-Message-State: APjAAAXg7ItEInr5iDk482Pmj6Kqq/huM5sq3vY2CNFJXSlkbBtUcNUc
        ismyxfDcQmcERlQb+dB42sA=
X-Google-Smtp-Source: APXvYqxwo8Gec9Ny6QmYwtkSozssl7jiOravWI2PLrVdgA4uDTivFYzBtKDpd0WaT4uBOnS4t0e+lA==
X-Received: by 2002:a0c:8c8f:: with SMTP id p15mr3632779qvb.57.1566564858270;
        Fri, 23 Aug 2019 05:54:18 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2604:2000:e8c5:d400:644e:9781:3c50:40ec])
        by smtp.googlemail.com with ESMTPSA id l206sm1130434qke.33.2019.08.23.05.54.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 23 Aug 2019 05:54:17 -0700 (PDT)
Subject: Re: IPv6 routes inserted into the kernel with 'route' end up with
 invalid type
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, bird-users@network.cz,
        Tom Bird <tom@portfast.co.uk>,
        Maria Jan Matejka <jan.matejka@nic.cz>,
        Ondrej Zajicek <santiago@crfreenet.org>
References: <87mug0m4rp.fsf@toke.dk>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <423380ec-b999-d620-9bd6-78c2dabfde99@gmail.com>
Date:   Fri, 23 Aug 2019 08:54:16 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <87mug0m4rp.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/23/19 8:43 AM, Toke Høiland-Jørgensen wrote:
> Hi David
> 
> Tom noticed[0] that on newer kernels, the Bird routing daemon rejects IPv6
> routes received from the kernel if those routes were inserted with the
> old 'route' utility (i.e., when they're inserted through the ioctl
> interface).
> 
> We tracked it down to the routes having an rtm_type of RTN_UNKNOWN, and
> a bit of git archaeology points suggestively at this commit:
> 
> e8478e80e5a ("net/ipv6: Save route type in rt6_info")
> 
> The same setup works with older kernels, so this seems like it's a
> regression, the age of 'route' notwithstanding. Any good ideas for the
> proper way to fix this?
> 

Should be fixed by:

commit c7036d97acd2527cef145b5ef9ad1a37ed21bbe6
Author: David Ahern <dsahern@gmail.com>
Date:   Wed Jun 19 10:50:24 2019 -0700

    ipv6: Default fib6_type to RTN_UNICAST when not set

    A user reported that routes are getting installed with type 0
(RTN_UNSPEC)
    where before the routes were RTN_UNICAST. One example is from accel-ppp
    which apparently still uses the ioctl interface and does not set
    rtmsg_type. Another is the netlink interface where ipv6 does not require
    rtm_type to be set (v4 does). Prior to the commit in the Fixes tag the
    ipv6 stack converted type 0 to RTN_UNICAST, so restore that behavior.

    Fixes: e8478e80e5a7 ("net/ipv6: Save route type in rt6_info")
    Signed-off-by: David Ahern <dsahern@gmail.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>
