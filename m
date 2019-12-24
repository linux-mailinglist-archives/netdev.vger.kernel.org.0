Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53E3D12A3FF
	for <lists+netdev@lfdr.de>; Tue, 24 Dec 2019 20:05:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726328AbfLXTFf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Dec 2019 14:05:35 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:46315 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726216AbfLXTFf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Dec 2019 14:05:35 -0500
Received: by mail-pl1-f194.google.com with SMTP id y8so8725509pll.13
        for <netdev@vger.kernel.org>; Tue, 24 Dec 2019 11:05:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=lp5nKwFEQenglRHtTsw+wp5gzBIjN5gq9ij463a3eHY=;
        b=T6mdBtYdsUXLe0bUcp3kRPz+JPGwav+8trn8ETyNN/Gh4fiavFWcg4vl2o9PB2aS+p
         GsrJqYPdSNUsb2NN8rRvIBbFjZx5wDDCgW7Ayn+vZoGyOGbEjV2R1/eMQ2zw7gOREAfa
         0I7juKBv6Yk14OCZJwo9JVR0t5+VjvQOFwrmLMY+8gTCz0mUqmCi1+1Ti6iT66BnkWdQ
         sB+5s57WJoLQwnVjMGkDuJYxAXZbTKI2Y1uRNaimyzDxSIJYz5AzGVb0r9pMfMFR2B2V
         AN6Ex65tvEWU4yjU1h6RIx0V8mTx5ffGDmQjgAC++gRUElGAo+HOrvnNEjrEQ85KtzAX
         cwew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=lp5nKwFEQenglRHtTsw+wp5gzBIjN5gq9ij463a3eHY=;
        b=V20klsrRvnafddT2cob/KIJB7Kxver04BmLHGR1pGPRrlWUz+OgJzkysiGnchSB9e4
         aE8w9+GJwy6hzwxycfSBCsno7/ARU6gJEi+rmMPpRfRW/2lT0ncaOufimt5jU/719vX1
         GeJKXoQOLOfxFMd2PNyCFbSVcoV4VA409leGo83S/1ocWhMpXkgY+ILlYAtkf2NZSNU/
         kA/bRdzZl3swU5pfyhdAdLKHigWewDZRPm76z/hmtE8ppReiRl18vCmjqfsqISZSle0Z
         huWV6ItyA27EaWBqG2ZvR8bgOSM35Mq7bpwpAmHBxVfsDAOTY7sDT90GQaIwO7Zb1v3f
         T70Q==
X-Gm-Message-State: APjAAAW87WyyeNb3aMYZTX06nfRF3V0K7R7TPDcK6ZQvi6KaTqvImW34
        aZsBLKZPDGz7FXFE/nPTGg4=
X-Google-Smtp-Source: APXvYqyLgsFWkNdQzizIfZ43IuwHwt70Q9D+hFgrtJFqMHfCHWL/ZEcgQj4vPm7L6vPFdN3dwO2sZw==
X-Received: by 2002:a17:90a:3244:: with SMTP id k62mr7883089pjb.43.1577214334283;
        Tue, 24 Dec 2019 11:05:34 -0800 (PST)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id 12sm30381768pfn.177.2019.12.24.11.05.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Dec 2019 11:05:33 -0800 (PST)
Date:   Tue, 24 Dec 2019 11:05:31 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     "Keller, Jacob E" <jacob.e.keller@intel.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net] net: dsa: sja1105: Fix double delivery of TX
 timestamps to socket error queue
Message-ID: <20191224190531.GA426@localhost>
References: <20191216223344.2261-1-olteanv@gmail.com>
 <02874ECE860811409154E81DA85FBB58B26DEDC3@fmsmsx101.amr.corp.intel.com>
 <CA+h21hob3FmbQYyXMeLTtbHF1SeFO=LZVGyQt4jniS9-VXEO-w@mail.gmail.com>
 <02874ECE860811409154E81DA85FBB58B26DF1C9@fmsmsx101.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <02874ECE860811409154E81DA85FBB58B26DF1C9@fmsmsx101.amr.corp.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 17, 2019 at 10:21:29PM +0000, Keller, Jacob E wrote:
> > -----Original Message-----
> > From: netdev-owner@vger.kernel.org <netdev-owner@vger.kernel.org> On
> > Behalf Of Vladimir Oltean

> My understanding was that setting it prevented the stack from
> generating a SW timestamp if the hardware timestamp was going to be
> provided. Basically, this is because we would otherwise report the
> timestamp twice to applications that expect only one timestamp.

Correct. 

> There were some patches from Miroslav that enabled optionally
> allowed the reporting of both SW and HW timestamps at the same time.

Not quite.  If the user sets SOF_TIMESTAMPING_OPT_TX_SWHW, then there
will be two packets delivered to the error queue, one SW and one HW.

> > There are many more drivers that are in principle broken with DSA PTP,
> > since they don't even have the equivalent check for priv->hwts_tx_en.

Please stop saying that.  It is not true.

> Right. I'm wondering what the correct fix would be so that we can
> fix the drivers and hopefully avoid introducing a similar issue in
> the future.

No fix is needed.  MAC drivers must set SKBTX_IN_PROGRESS and call
skb_tstamp_tx() to deliver the transmit time stamp.  DSA drivers
should call skb_complete_tx_timestamp() to deliver the transmit time
stamp, and they should *not* set SKBTX_IN_PROGRESS.

Thanks,
Richard
