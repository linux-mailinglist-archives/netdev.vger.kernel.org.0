Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0AE012B063
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 02:52:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726982AbfL0Bwg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 20:52:36 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:33115 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726193AbfL0Bwg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Dec 2019 20:52:36 -0500
Received: by mail-pj1-f67.google.com with SMTP id u63so2610730pjb.0
        for <netdev@vger.kernel.org>; Thu, 26 Dec 2019 17:52:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Y+5tks2cU6a5PTdgMwn+wrqN5qv2qlGyw6wNJXYf1OM=;
        b=D8tECnw/1CZpktlCJFaZ15eCUMKPr6WtSadyax382xvVeKyS64gwI1uo1U+ANBnVHA
         sKeP+XsfMUd7inZ16hY1Qfe+4c6zuFVqLA2GvTWc8dvtsiY8IxvAv5hLAb5X9iOVDYOl
         jlj5Z5uyqXd1N3tp1XzriFi1jtQr+G+qJ6sD5iCjiwoXv06NqIlJu7a+iZE/3Yui4Q6g
         cxHUVAtzcwqy5h4imGuwqGuhdLI59ynnvkltf8n6pRsuNVS4QiZ3wWFBoDOc9ldeLOyd
         WmQi8tDVmTLE6yCHjO6dmMw2SHffkghtJ0DeypqjtM/sA8q5ofBi3d0tmkfAOi+b3e2B
         4nbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Y+5tks2cU6a5PTdgMwn+wrqN5qv2qlGyw6wNJXYf1OM=;
        b=s+ElBzOmfjxVmjceewg9ubt59uDTtnxsqA8h5TWZjdUUeC2R0BEXm2dJ08YIVIIzDi
         RzZvNjIvMv7Ke11oUPGwc6Jizr5KOSQDSLwbgw+b4AMdx0uoOeDN3xu1KYuaL44gZdn8
         1mhOSNboNlaqJzjTBmt/UWVuy8/gJCCj/MbcwtaLI+we0aig0AsHBrsxMdH0+5/8Xhl2
         Wnv3t+J5HXI2T7nykGxtx7aKifgUNhQMWGsH690K3Sz6w7O2hsk2LVENjy5IjJVWHBPX
         BoLpNH8AY6AhS5qPP5aVKGWZVUU9SL79vF6UD8ZbTplLuOVivxym2dCvqrS2GNVlb5Hx
         Mv+A==
X-Gm-Message-State: APjAAAWh+fDuAHoP6velCyJtT1w8X3Q0FRgHgw9Yislu/i/6fEJ5JvSO
        ZT/I57W/yTYeXm7wpYaGQCo=
X-Google-Smtp-Source: APXvYqzBda4D13s4clmAqsfmMwIwq8RW8d01/sStH7OfLA46GMg4QL19X7lrZqU0dLYXXne47SPC+w==
X-Received: by 2002:a17:902:462:: with SMTP id 89mr12260483ple.270.1577411555218;
        Thu, 26 Dec 2019 17:52:35 -0800 (PST)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id l22sm12769150pjc.0.2019.12.26.17.52.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Dec 2019 17:52:34 -0800 (PST)
Date:   Thu, 26 Dec 2019 17:52:32 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "Keller, Jacob E" <jacob.e.keller@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net] net: dsa: sja1105: Fix double delivery of TX
 timestamps to socket error queue
Message-ID: <20191227015232.GA6436@localhost>
References: <20191216223344.2261-1-olteanv@gmail.com>
 <02874ECE860811409154E81DA85FBB58B26DEDC3@fmsmsx101.amr.corp.intel.com>
 <CA+h21hob3FmbQYyXMeLTtbHF1SeFO=LZVGyQt4jniS9-VXEO-w@mail.gmail.com>
 <02874ECE860811409154E81DA85FBB58B26DF1C9@fmsmsx101.amr.corp.intel.com>
 <20191224190531.GA426@localhost>
 <CA+h21hrBLedLHCfP3oY2U96BJXqMQO=Uof3tsjji_Fp-b0smHQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21hrBLedLHCfP3oY2U96BJXqMQO=Uof3tsjji_Fp-b0smHQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 26, 2019 at 08:24:19PM +0200, Vladimir Oltean wrote:
> How will these drivers not transmit a second hw TX timestamp to the
> stack, if they don't check whether TX timestamping is enabled for
> their netdev?

Ah, so they are checking SKBTX_HW_TSTAMP on the socket without
checking for HWTSTAMP first?  Yeah, that won't work with DSA time
stamping.  But who cares?  Most of the real world doesn't have gigabit
DSA switches in front of MACs that provide 10 gigabit links or higher.

> Of course, at least that breakage is going to be much more binary and
> obvious: PTP simply won't work at all for drivers stacked on top of
> them until they are fixed.

Right, you can fix individual MAC drivers to work with DSA, one by
one.  You are free to try to get the maintainers to ack your fixes.
(But, here is a friendly hint: don't start out by declaring their
drivers "broken").
 
> Does the TI PHYTER driver count?

No.  It really doesn't count.  It won't work together with MAC time
stamping, but this is a known limitation.  That part is 100 mbit only,
and there are very few implementations.  Unfortunately the
so_timestamping API did not foresee the possibility of simultaneous
MAC and PHY time stamping.  Too bad, that's life.  I didn't invent the
API, and I don't have to defend it, either.

Thanks,
Richard
