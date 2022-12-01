Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20B8463EDA3
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 11:25:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229989AbiLAKZD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 05:25:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230384AbiLAKYm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 05:24:42 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A1CF99F04
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 02:24:41 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id ay27-20020a05600c1e1b00b003d070f4060bso1134510wmb.2
        for <netdev@vger.kernel.org>; Thu, 01 Dec 2022 02:24:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ToV/x7jzWrW3uT3Zhhk3H5ZjyRsWPDClpDyEzfcVrzA=;
        b=Xlr/Sma5gG0VsPd5tulPMMD9H1GG6nSa56Fz99fQBMwBAlSeQ/IRw2VL7kFMHLv8nG
         Ke6+8zPx3qf9iUCy6XL0tceRk6a3e+Uj7EAsPiGNJlOxqm3erSoWdinwL9AvQcyq2qOw
         SoNEeZA5yrkoO66WTAl2gWubmX1RjL6x6HkKfYWRkyN87TyY/8AXyaPC3OLo85GDnWGD
         PE7a3tDE1K75VmS6ItrgXHCWzsbzE4/SKfIxlmRuX4rZZHUoIyfYpHrDQdbSjWOaIOjN
         NYUHtjm8xyDmDnVAHzErtcoDjdhant3m8NsaKYMHIYABgeMy1Z50uJyHyfcksvNSsRey
         KM9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ToV/x7jzWrW3uT3Zhhk3H5ZjyRsWPDClpDyEzfcVrzA=;
        b=4ywb3WQimu17MgYPQtT1vXbCZesAX6AEazj3Z4OMKBfloavANuPgRZoBHW79oeE3IP
         0HTvbhYmM2jd9Wsxhgk+BXPm3G1+oHCQc7k2XPWl4/QVeUej8oGZvH5Jo5eMEXrvVjjj
         be8eszZ7zjLTQEDnh8O5S0j4GqfW7tUiUqXQYjse9jt4FI0b84+MIkv1H4f0SXc6iKrm
         Rs02QP7c0jvibtNBbw/BXcjXpxXsOYCKf3hu1hz8tM6l7GbfeQR41tqaHL5jqxFLI+bN
         WtFeMUWrMTns2Sp0nWfTxxDgYZTWjXhKR7inNTxnV79kiEPBZZ+WIlCQG9yY2COFzwib
         OrIg==
X-Gm-Message-State: ANoB5pkwNqfqqqTnlmDHO9UoGvhMDRugq/fDO/Q5nX96TlIAC4XkQEYO
        c6IBhpqoqF+m7LO2z5unnmc=
X-Google-Smtp-Source: AA0mqf4QbGV9K8cI4cQm98qhGPxd/S/oUr+1UYhwC4G4d8em11d0WOdEh53QCKbKNuf2hFf5/ygxvQ==
X-Received: by 2002:a05:600c:3d18:b0:3cf:b7bf:352d with SMTP id bh24-20020a05600c3d1800b003cfb7bf352dmr39905241wmb.106.1669890279471;
        Thu, 01 Dec 2022 02:24:39 -0800 (PST)
Received: from gvm01 (net-2-45-26-236.cust.vodafonedsl.it. [2.45.26.236])
        by smtp.gmail.com with ESMTPSA id z10-20020a05600c0a0a00b003c70191f267sm9983037wmp.39.2022.12.01.02.24.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 02:24:38 -0800 (PST)
Date:   Thu, 1 Dec 2022 11:24:42 +0100
From:   Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     kuba@kernel.org, netdev@vger.kernel.org, peppe.cavallaro@st.com
Subject: Re: [PATCH net] stmmac: fix potential division by 0
Message-ID: <Y4iA6mwSaZw+PKHZ@gvm01>
References: <Y4f3NGAZ2rqHkjWV@gvm01>
 <Y4gFt9GBRyv3kl2Y@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y4gFt9GBRyv3kl2Y@lunn.ch>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 01, 2022 at 02:39:03AM +0100, Andrew Lunn wrote:
> On Thu, Dec 01, 2022 at 01:37:08AM +0100, Piergiorgio Beruto wrote:
> > Depending on the HW platform and configuration, the
> > stmmac_config_sub_second_increment() function may return 0 in the
> > sec_inc variable. Therefore, the subsequent div_u64 operation can Oops
> > the kernel because of the divisor being 0.
> 
> I'm wondering why it would return 0? Is the configuration actually
> invalid? Is ptp_clock is too small, such that the value of data is
> bigger than 255, but when masked with 0xff it gives zero?
Ok, I did some more analysis on this. On my reference board, I got two
PHYs connected to two stmmac, one is 1000BASE-T, the other one is
10BASE-T1S.

Fot the 1000BASE-T PHY everything works ok. The ptp_clock is 0ee6b280
which gives data = 8 that is less than FF.

For the 10BASE-T1 PHY the ptp_clock is 001dcd65 which gives data = 400
(too large). Therefore, it is 0 after masking.

The root cause is the MAC using the internal clock as a PTP reference
(default), which should be allowed since the connection to an external
PTP clock is optional from an HW perspective. The internal clock seems
to be derived from the MII clock speed, which is 2.5 MHz at 10 Mb/s.

> 
> I'm wondering if the correct thing to do is return -EINVAL in
> stmmac_init_tstamp_counter().
I've tried that as an alternate fix. The end result is:

/root # ifconfig eth0 up
[   17.535304] socfpga-dwmac ff700000.ethernet eth0: Register MEM_TYPE_PAGE_POOL RxQ-0
[   17.549104] socfpga-dwmac ff700000.ethernet eth0: PHY [stmmac-0:08] driver [NCN26000] (irq=49)
[   17.568801] dwmac1000: Master AXI performs any burst length
[   17.574410] socfpga-dwmac ff700000.ethernet eth0: No Safety Features support found

[   17.595874] socfpga-dwmac ff700000.ethernet eth0: PTP init failed

[   17.605308] socfpga-dwmac ff700000.ethernet eth0: configuring for phy/mii link mode
[   17.613905] socfpga-dwmac ff700000.ethernet eth0: No phy led trigger registered for speed(10)
[   17.624558] socfpga-dwmac ff700000.ethernet eth0: Link is Up - 10Mbps/Half - flow control off

So as you can see the PTP initialization failed, but it soes not seem to
provoke any other unwanted effect.

The real question, in my opinion, is: are we ok just making it fail?
This is certainly good enough for my application, but others may have a
different opinion.

I would suggest to return an error for the time being (as it fixes the
Oops) then see whether a different fix is really needed.

Please, let me know your thoughts.

Kidn Regards,
Piergiorgio

