Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36431176F34
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 07:16:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727446AbgCCGQt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 01:16:49 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:37701 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725840AbgCCGQt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 01:16:49 -0500
Received: by mail-lj1-f195.google.com with SMTP id q23so2186461ljm.4
        for <netdev@vger.kernel.org>; Mon, 02 Mar 2020 22:16:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VIV13PJeXefr+b5Po/cA8ExBiUvmn3EP14rhWC4WrW4=;
        b=llaFyE3P8pYnqH3ymsVtgXT9WelC2BtEulyKjOPyibkHLoINzwz/s9dQPvhAm/uVDg
         UBlyP5ef4MMauGgEMnON1isPIRl7EWLFGafIrtdkg/rh+I5AlrEJw2Wu1rIEaeFxZCYh
         E93ztr3z2BcL7NgqbnxxFyfHalzHtzDf4xJEaXbdAMCv6ejbVg5jMzFzlix/hf0H5tpH
         uH3hREPROxrJqQxmLqjwg9IKcZkYd2aUv9cmIdeDOhn06bD6U3PJzgMkuOZJib5UwwgW
         T/nJAh+O0Y/IUet2BoSngAgE3IUg0mXEbgQdHt3Op0kEBHFTZnCNfPLDqgt9pC+jCs05
         3LBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VIV13PJeXefr+b5Po/cA8ExBiUvmn3EP14rhWC4WrW4=;
        b=bKom6hDAxAJVEoltSElOxruHZjC95A6/i3lV28FajdEEoIb1rTDozVD3acvzGS48RN
         d4WGt90hMZMcQqoElqT8RyZiwzqjbSzTTE2L6FBlvOhQsxMiXB6WhqNMZjafVCzdwJUe
         8ic+bRQzTrITkcV6wnU3+RsQoAMU7CkciwJheFdF/PYYiXfiXuTTVtZfAIuEJEUi83qk
         5O0iyaqa0LPJSAHNt5yLBxFqBIXmafEwqC47bmemFsejr/CBqWm6SKckyi8Q3tEcH+Dj
         g6iWVSDi4W81DpQhwO6wPzo4hVMAaUTXKFTVXBckcuo1FmJ7xnUtRaA14JQEWgfLQ5jw
         z4/w==
X-Gm-Message-State: ANhLgQ1QGYFLCD2lP9p26Exf9ZHvPQtOCLXlRKBujJw5UxvBl9kcN6d5
        221N7PNK1FBKpF7sksXn3D0=
X-Google-Smtp-Source: ADFU+vuD5tIlHccVE9+1YuWnslZSY6wc2kmqdlpWg3+pkCwqQBANCHidLaegJtHGMS7lrtS7KRlQCA==
X-Received: by 2002:a2e:145e:: with SMTP id 30mr1439082lju.25.1583216206590;
        Mon, 02 Mar 2020 22:16:46 -0800 (PST)
Received: from elitebook.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.googlemail.com with ESMTPSA id f4sm12047559ljo.79.2020.03.02.22.16.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Mar 2020 22:16:45 -0800 (PST)
Subject: Re: Regression: net/ipv6/mld running system out of memory (not a
 leak)
From:   =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To:     Network Development <netdev@vger.kernel.org>,
        Hangbin Liu <liuhangbin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc:     Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Jo-Philipp Wich <jo@mein.io>
References: <CACna6rwD_tnYagOPs2i=1jOJhnzS5ueiQSpMf23TdTycFtwOYQ@mail.gmail.com>
Message-ID: <b9d30209-7cc2-4515-f58a-f0dfe92fa0b6@gmail.com>
Date:   Tue, 3 Mar 2020 07:16:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <CACna6rwD_tnYagOPs2i=1jOJhnzS5ueiQSpMf23TdTycFtwOYQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12.02.2020 08:37, Rafał Miłecki wrote:
> I run Linux based OpenWrt distribution on home wireless devices (ARM
> routers and access points with brcmfmac wireless driver). I noticed
> that using wireless monitor mode interface results in my devices (128
> MiB RAM) running out of memory in about 2 days. This is NOT a memory
> leak as putting wireless down brings back all the memory.
> 
> Interestingly this memory drain requires at least one of:
> net.ipv6.conf.default.forwarding=1
> net.ipv6.conf.all.forwarding=1
> to be set. OpenWrt happens to use both by default.
> 
> This regression was introduced by the commit 1666d49e1d41 ("mld: do
> not remove mld souce list info when set link down") - first appeared
> in 4.10 and then backported. This bug exists in 4.9.14 and 4.14.169.
> Reverting that commit from 4.9.14 and 4.14.169 /fixes/ the problem.

I have some interesting debugging results to share. I decided to log all
kfree() operations in mcast.c. Logging mld_clear_delrec() provided some
promising info.

With kernel 4.14.169 (affected by regression) bringing monitor ifaces
down doesn't result in freeing any memory in mld_clear_delrec():

down
[   73.487846] [ipv6_mc_down] idev->dev->name:mon-phy0
[   73.917823] [ipv6_mc_down] idev->dev->name:mon-phy1

down
[   76.767781] [ipv6_mc_down] idev->dev->name:mon-phy0
[   77.157790] [ipv6_mc_down] idev->dev->name:mon-phy1

down
[   79.658260] [ipv6_mc_down] idev->dev->name:mon-phy0
[   80.047805] [ipv6_mc_down] idev->dev->name:mon-phy1

down
[   83.067773] [ipv6_mc_down] idev->dev->name:mon-phy0
[   83.447778] [ipv6_mc_down] idev->dev->name:mon-phy1

down
[   86.555700] [ipv6_mc_down] idev->dev->name:mon-phy0
[   86.985706] [ipv6_mc_down] idev->dev->name:mon-phy1

However removing interfaces reveals there were duplicated entries in
idev->mc_tomb lists:

remove
[   89.694038] [ipv6_mc_down] idev->dev->name:wlan1
[   89.717953] [ipv6_mc_destroy_dev] idev->dev->name:mon-phy1
[   89.723433] [ipv6_mc_down] idev->dev->name:mon-phy1
[   89.728375] [ipv6_mc_destroy_dev -> mld_clear_delrec] kfree(pmc:c6e2c600) ff02::2
[   89.736013] [ipv6_mc_destroy_dev -> mld_clear_delrec] kfree(pmc:c620b100) ff02::2
[   89.743643] [ipv6_mc_destroy_dev -> mld_clear_delrec] kfree(pmc:c620b900) ff02::2
[   89.751275] [ipv6_mc_destroy_dev -> mld_clear_delrec] kfree(pmc:c620b680) ff02::2
[   89.758901] [ipv6_mc_destroy_dev -> mld_clear_delrec] kfree(pmc:c620b580) ff02::2
[   89.868542] [ipv6_mc_down] idev->dev->name:wlan0
[   89.878203] [ipv6_mc_destroy_dev] idev->dev->name:wlan1
[   89.883479] [ipv6_mc_down] idev->dev->name:wlan1
[   89.888208] [ipv6_mc_destroy_dev -> mld_clear_delrec] kfree(pmc:c6e2ca80) ff02::2
[   89.895901] [ipv6_mc_destroy_dev -> mld_clear_delrec] kfree(pmc:c6e2ca00) ff02::1:ff10:e018
[   89.904412] [ipv6_mc_destroy_dev -> mld_clear_delrec] kfree(pmc:c6e2c980) ff02::1:ff00:0
[   89.937564] [ipv6_mc_destroy_dev] idev->dev->name:mon-phy0
[   89.943062] [ipv6_mc_down] idev->dev->name:mon-phy0
[   89.948070] [ipv6_mc_destroy_dev -> mld_clear_delrec] kfree(pmc:c6e2c300) ff02::2
[   89.955728] [ipv6_mc_destroy_dev -> mld_clear_delrec] kfree(pmc:c620b780) ff02::2
[   89.963392] [ipv6_mc_destroy_dev -> mld_clear_delrec] kfree(pmc:c620b980) ff02::2
[   89.971035] [ipv6_mc_destroy_dev -> mld_clear_delrec] kfree(pmc:c620b700) ff02::2
[   89.978688] [ipv6_mc_destroy_dev -> mld_clear_delrec] kfree(pmc:c620b080) ff02::2
[   90.068433] [ipv6_mc_destroy_dev] idev->dev->name:wlan0
[   90.073672] [ipv6_mc_down] idev->dev->name:wlan0
[   90.078357] [ipv6_mc_destroy_dev -> mld_clear_delrec] kfree(pmc:c620bf00) ff02::2
[   90.085992] [ipv6_mc_destroy_dev -> mld_clear_delrec] kfree(pmc:c620be80) ff02::1:ff0e:5018
[   90.094530] [ipv6_mc_destroy_dev -> mld_clear_delrec] kfree(pmc:c620bd80) ff02::1:ff00:0

It appears that every interface up & down sequence results in adding a
new ff02::2 entry to the idev->mc_tomb. Doing that over and over will
obviously result in running out of memory at some point. That list isn't
cleared until removing an interface.

I searched and found ff02::2 to be described as "all routers" address.
Any idea why is it being added over and over?



Just to make my debugging complete I tried the same logging with the
kernel 4.4.194 (before regression). It clears idev->mc_tomb list on
every interface down so that list never grows so big.

down
[  119.241112] [ipv6_mc_down] idev->dev->name:mon-phy0
[  119.246025] [ipv6_mc_down -> mld_clear_delrec] kfree(pmc:c6c80b40) ff02::2
[  119.649975] [ipv6_mc_down] idev->dev->name:mon-phy1
[  119.654873] [ipv6_mc_down -> mld_clear_delrec] kfree(pmc:c6c80300) ff02::2

down
[  125.220060] [ipv6_mc_down] idev->dev->name:mon-phy0
[  125.224969] [ipv6_mc_down -> mld_clear_delrec] kfree(pmc:c6c80540) ff02::2
[  125.580000] [ipv6_mc_down] idev->dev->name:mon-phy1
[  125.584900] [ipv6_mc_down -> mld_clear_delrec] kfree(pmc:c6c80180) ff02::2

down
[  128.520013] [ipv6_mc_down] idev->dev->name:mon-phy0
[  128.524921] [ipv6_mc_down -> mld_clear_delrec] kfree(pmc:c6c800c0) ff02::2
[  128.879994] [ipv6_mc_down] idev->dev->name:mon-phy1
[  128.884899] [ipv6_mc_down -> mld_clear_delrec] kfree(pmc:c6c80e40) ff02::2

down
[  131.820028] [ipv6_mc_down] idev->dev->name:mon-phy0
[  131.824934] [ipv6_mc_down -> mld_clear_delrec] kfree(pmc:c6ca53c0) ff02::2
[  132.179992] [ipv6_mc_down] idev->dev->name:mon-phy1
[  132.184894] [ipv6_mc_down -> mld_clear_delrec] kfree(pmc:c6ca5240) ff02::2

down
[  134.759991] [ipv6_mc_down] idev->dev->name:mon-phy0
[  134.764901] [ipv6_mc_down -> mld_clear_delrec] kfree(pmc:c6ca5540) ff02::2
[  135.119995] [ipv6_mc_down] idev->dev->name:mon-phy1
[  135.124897] [ipv6_mc_down -> mld_clear_delrec] kfree(pmc:c6ca5a80) ff02::2

remove
[  140.746744] [ipv6_mc_down] idev->dev->name:wlan1
[  140.751432] [ipv6_mc_down -> mld_clear_delrec] kfree(pmc:c6ca5480) ff02::2
[  140.758457] [ipv6_mc_down -> mld_clear_delrec] kfree(pmc:c6c800c0) ff02::1:ff10:e018
[  140.766367] [ipv6_mc_down -> mld_clear_delrec] kfree(pmc:c6c80e40) ff02::1:ff00:0
[  140.791016] [ipv6_mc_down] idev->dev->name:wlan0
[  140.795686] [ipv6_mc_down -> mld_clear_delrec] kfree(pmc:c6ca5c00) ff02::2
[  140.802814] [ipv6_mc_down -> mld_clear_delrec] kfree(pmc:c6ca59c0) ff02::1:ff0e:5018
[  140.810818] [ipv6_mc_down -> mld_clear_delrec] kfree(pmc:c6ca50c0) ff02::1:ff00:0
[  140.820225] [ipv6_mc_destroy_dev] idev->dev->name:mon-phy1
[  140.825849] [ipv6_mc_down] idev->dev->name:mon-phy1
[  140.830785] [ipv6_mc_destroy_dev] igmp6_group_dropped(c6c80840)
[  140.902121] [ipv6_mc_destroy_dev] idev->dev->name:mon-phy0
[  140.907622] [ipv6_mc_down] idev->dev->name:mon-phy0
[  140.912622] [ipv6_mc_destroy_dev] igmp6_group_dropped(c6cc4a80)
[  140.983259] [ipv6_mc_destroy_dev] idev->dev->name:wlan1
[  140.988472] [ipv6_mc_down] idev->dev->name:wlan1
[  140.993151] [ipv6_mc_destroy_dev] igmp6_group_dropped(c72f6780)
[  141.013696] [ipv6_mc_destroy_dev] idev->dev->name:wlan0
[  141.018933] [ipv6_mc_down] idev->dev->name:wlan0
[  141.023722] [ipv6_mc_destroy_dev] igmp6_group_dropped(c5c4da80)
