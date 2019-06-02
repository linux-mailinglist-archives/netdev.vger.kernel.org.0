Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2DA13219E
	for <lists+netdev@lfdr.de>; Sun,  2 Jun 2019 04:17:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726695AbfFBCRN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Jun 2019 22:17:13 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:33992 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726496AbfFBCRN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Jun 2019 22:17:13 -0400
Received: by mail-pf1-f195.google.com with SMTP id c14so6110174pfi.1;
        Sat, 01 Jun 2019 19:17:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=bAo5+LZhfYDx18P1KeMDV5IXd28apXXCR5AehQeAza4=;
        b=rQBvr3VuMXGdnPdm/GXJN7ghjGgJHqk0wzB8l0+v7xw9qJl4chYLACYj0NU1BQp0ir
         RBnqdPVdrVuP1okhKTYYG73qOl+GGSDfJ7UOIO6tnP8B6wwzzPR3fwioDdstQujeQOi0
         f759yRVHxwr7CS0prFkhjmNOI9tn1l7Kd6ziHRBGArdfGcGq0FhR8p3lwwzSiUhsORWW
         YlP57Sl6snwWAozXQMDTNraXIrSs2ShXly4Vc/JmDSdh7n8cJq1hqv1XnBq94EV5hLiy
         VmbV1rIr+3HWB+K+PhBN28EKcrnKQTNFWgRT77QIPw6LylO+EsyCFMVcDJSjQhkb1kG2
         qvXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=bAo5+LZhfYDx18P1KeMDV5IXd28apXXCR5AehQeAza4=;
        b=AxJ1j/x4oibONGtA2C6kk63EKIJzeMgfwy7OULrVyF3G92YR3cQd0muIM/+4TUXLNM
         eGIolXVdO1R1L/dB3L5J/GD+2Rnav0YD1H08yrqih/f/glQLiJW+/te4DmznhgWkWnQe
         cwz9YfpKwSagoamWnC6X50BZTQLdTDWsp8wBE43lSgkFEwMT7J8k05Let7u15VIYjkQZ
         1Yo3OK9/2vVkZVuehc8ass4VJW69EeNLR3nfT90Bt9aISp7JL6qMDfSGv1ddrBFMIe9t
         FTYX50DrQbqbgLspt2QLgAmkJUHAzsP166P77EV719BFyXCPP+sCJfc+zXUIcAtQkz/9
         9Dpw==
X-Gm-Message-State: APjAAAW2JpnXTaLKLRcNkRLZ5yehbpTWJhaO3hdysOKJtUNKDSdT7iAu
        hdgJUVn1zfmyfcUt4AC6EHzHoIen
X-Google-Smtp-Source: APXvYqxb5UBVLpxJsySHukVp6dQkjNUNM5wlyX5vwjQ/tv7+Gzfml/67egPBR5FEMDVn01ArsTnZ+Q==
X-Received: by 2002:a63:295:: with SMTP id 143mr18975279pgc.279.1559441832891;
        Sat, 01 Jun 2019 19:17:12 -0700 (PDT)
Received: from localhost (c-73-222-71-142.hsd1.ca.comcast.net. [73.222.71.142])
        by smtp.gmail.com with ESMTPSA id i3sm10984934pfa.175.2019.06.01.19.17.11
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 01 Jun 2019 19:17:11 -0700 (PDT)
Date:   Sat, 1 Jun 2019 19:17:09 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 0/5] PTP support for the SJA1105 DSA driver
Message-ID: <20190602021709.i7d2ngefox3peodf@localhost>
References: <CA+h21hp9DfW3wFy4YbHMU31rBHyrnUTdF4kKwX36h9vHOW2COw@mail.gmail.com>
 <20190531140841.j4f72rlojmaayqr5@localhost>
 <CA+h21hroywaij3gyO0u6v+GFVO2Fv_dP_a+L3oMGpQH8mQgJ5g@mail.gmail.com>
 <20190531151151.k3a2wdf5f334qmqh@localhost>
 <CA+h21hpHKbTc8toPZf0iprW1b4v6ErnRaSM=C6vk-GCiXM8NvA@mail.gmail.com>
 <20190531160909.jh43saqvichukv7p@localhost>
 <CA+h21hpVrVNJTFj4DHHV+zphs2MjyRO-XZsM3D-STra+BYYHtw@mail.gmail.com>
 <CA+h21houLC7TGJYQ28LxiUxyBE7ju2ZiRcUd41aGo_=uAhgVgQ@mail.gmail.com>
 <20190601050714.xylw5noxka7sa4p3@localhost>
 <CA+h21hr3+vUjS9_m=CtEbFeN9Bgxkg8b-4zuXSMnZXGtfUEOsQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21hr3+vUjS9_m=CtEbFeN9Bgxkg8b-4zuXSMnZXGtfUEOsQ@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 01, 2019 at 01:31:34PM +0300, Vladimir Oltean wrote:
> If I dress the meta frame into a PTP frame (btw is there any
> preferable event message for this purpose?)

I would just make a L2 PTP event message from a specific source
address, just like the phyter does.

Use Ethertype ETH_P_1588 (0x88f7), and make sure the "general" bit
(0x8) of the messageType field (the first payload byte, at offset 14)
is clear.

dp83640.c uses a magic source address to identify a time stamping
status frame:

static u8 status_frame_src[6] = { 0x08, 0x00, 0x17, 0x0B, 0x6B, 0x0F };

HTH,
Richard


