Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66F932E153
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 17:41:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726990AbfE2PlM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 11:41:12 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:37979 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726069AbfE2PlL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 11:41:11 -0400
Received: by mail-pg1-f196.google.com with SMTP id v11so129342pgl.5
        for <netdev@vger.kernel.org>; Wed, 29 May 2019 08:41:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6h0n/wFr1oXSKYqj1nh+ITz2wg8lywBPS0H0T50qNl8=;
        b=SROARzGdubKxXmgu+d0k+G9qs2e8uxFtIzUhG54xPGYPsImyPveeZu7kccMOTk5wnG
         0D536xpTgHf+dOReEAeDd+6G2Mihe+E7U6aL7GiFxQvKXEgTOFqmuoPn+yoihmakR1t2
         Hd0+xLHrwouWmQ81wmUvJK64A3XEv15M2y3iDCSoNdxHUz0+1wcSjxTBUU/58e7WDKOc
         /mWGuwjxa+Cwmft7vkf0CJeKnZ+2O2OQRjrKJm1ITPSsaYBIMNJ6EbW6MhxOLBacLs+8
         mAS2x3HQ0XLbRJn+xHt8d8r7WU3f+LXCQHgplCfCzHktl2Lw5DXoStcWOdChjx1nLubZ
         kh4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6h0n/wFr1oXSKYqj1nh+ITz2wg8lywBPS0H0T50qNl8=;
        b=pScC6pRqDkfEhatuY6CEK7ensF0NWKIOOsXhn7AFeKtZSBH2T3mGeX98ZOsElnBdGL
         x5xAqJ7Xz3kCGthLKvlHoxv/mUyZDAghcoMiH/HW03ZQYANk2FmiyAzYsBCUCiJykXni
         pHpaVb/KhUZ26gdGaZjS1UhRbFdtYhZ7rSNTs430kX2f7DYCrk4hV2QUqRPhpFcehIB3
         aAXhbMTVh0/rGJOVIlqhTgjWQUFvaxcl6isXV8iXlwL17HsFxvhJha9yJ8jFVRZ9WDdU
         00w8GSdX8Tyi3CJ2SJFtXq5bo1eS4Qp5RX1UO29Bkuru9IIb0NwTqyNLmDfbgm4+WnH0
         k2Sg==
X-Gm-Message-State: APjAAAXWcGOxNRDRoyvoAV3LNVG9mx/B+V6fD8YgCJSPuCVbEViU+WWE
        mk3/le4Mdr5Z49jvMP1EpJ7v2Z8w
X-Google-Smtp-Source: APXvYqzipy4F+cyL/u/tlAFmVT/m39mBMLz4GRBoC/VKGJs+voKS9UfEn9ASDN7vqXZHAaR41TYcXg==
X-Received: by 2002:a17:90a:be0b:: with SMTP id a11mr12989031pjs.88.1559144470421;
        Wed, 29 May 2019 08:41:10 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:31f1:bcc4:54e4:3069? ([2601:282:800:fd80:31f1:bcc4:54e4:3069])
        by smtp.googlemail.com with ESMTPSA id 8sm20944pfj.93.2019.05.29.08.41.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 29 May 2019 08:41:09 -0700 (PDT)
Subject: Re: [net-next PATCH] net: rtnetlink: Enslave device before bringing
 it up
To:     Phil Sutter <phil@nwl.cc>, David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
References: <20190529135120.32241-1-phil@nwl.cc>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <e684c23a-93cc-d424-e217-e6ac2a371029@gmail.com>
Date:   Wed, 29 May 2019 09:41:07 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190529135120.32241-1-phil@nwl.cc>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/29/19 7:51 AM, Phil Sutter wrote:
> Unlike with bridges, one can't add an interface to a bond and set it up
> at the same time:
> 
> | # ip link set dummy0 down
> | # ip link set dummy0 master bond0 up
> | Error: Device can not be enslaved while up.
> 
> Of all drivers with ndo_add_slave callback, bond and team decline if
> IFF_UP flag is set, vrf cycles the interface (i.e., sets it down and
> immediately up again) and the others just don't care.
> 
> Support the common notion of setting the interface up after enslaving it
> by sorting the operations accordingly.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
>  net/core/rtnetlink.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 

I agree with the intent - enslave before up.

Not sure how likely this is, but it does break the case:
ip li set dummy0 master bond0 down

