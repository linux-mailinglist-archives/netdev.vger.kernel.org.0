Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BD6E2DF86E
	for <lists+netdev@lfdr.de>; Mon, 21 Dec 2020 05:54:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728410AbgLUEyo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Dec 2020 23:54:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728361AbgLUEyn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Dec 2020 23:54:43 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BB90C061285
        for <netdev@vger.kernel.org>; Sun, 20 Dec 2020 20:54:03 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id b8so5006001plx.0
        for <netdev@vger.kernel.org>; Sun, 20 Dec 2020 20:54:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5qdPp2BYunqFGDO9k8px1utwe8+O1xFnwXZ4RMNjg5g=;
        b=VVxoAVrvs4vst4okoKw7IdBGX7w9d49iwVeFeVxqhTbZZR68W0fvrwi77P7n7lnBAZ
         YFKO50G4hrQI9PiIPJXTIDnmjM955gL5hxHNPTM36B14EvFEhADKPx2A/kvo+WJkujq9
         e/dLybFKTyUqZHFNWYiGzYRgDIJRcXJdZKesghxtyPCNfFsYprsTax3RwjBMNe9qD5MC
         nJLsQ6F01DWCSGfTbBPjkyzNu03OsgwpwHTlq2Qe6UW7J/R13PsnN4wS2i0kPx5e2JUI
         N5A3xBEye3qDS875E/DyhGofnNmYNY0ZUSwskHeqE9v6kaR0AnGhaUU8xawlizK+fYPR
         +31g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5qdPp2BYunqFGDO9k8px1utwe8+O1xFnwXZ4RMNjg5g=;
        b=TOmRZWfSAvhao6dOocuiaL+2hvXJKcHw4QfDBNkBJWZIBmG1plhW51dJNqpytFlLQ3
         uhQmS3xueWwDEVOixuD3Ik3JxtRIwK1YmIoZE1KFN9cq2onS6TfOBOGVy9p5AhinzNY+
         C4sRMvAwpyA0/5gNfITnupzJfns+y3mVGtvi1vJJ2ludcvZSKV5gpzoWSVlIAIt37mRd
         JjPGeT2w8E8rwOfcRkoMXaSo206ghUiMk4h4NaA1alBJ8n5/2fgTjRryugU5yh6VVPmO
         +IX1Tgl24/Uai5l7t2SbEmJVf2qyEXG4ODYig83MupLN8v4ADFVotgcX2y57qqiYKILE
         qkog==
X-Gm-Message-State: AOAM532y45I0lZlnmn9LIsjbhJez9TNNHzEOK0GnaX1O8ziWPEyhIAR4
        0ZyWMn3z6rd4ii71fkmwmx9sAj79fUg=
X-Google-Smtp-Source: ABdhPJw8B32GiwILnXPGDBfIBRelxzy1YV6y5ShTH+tlGTtpts1e/zOgqhARK9HA2JricygHeyChvw==
X-Received: by 2002:a17:902:9b8a:b029:dc:3baf:201e with SMTP id y10-20020a1709029b8ab02900dc3baf201emr4743495plp.15.1608526442173;
        Sun, 20 Dec 2020 20:54:02 -0800 (PST)
Received: from [10.230.29.166] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id b1sm13848114pjh.54.2020.12.20.20.54.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 20 Dec 2020 20:54:01 -0800 (PST)
Subject: Re: [RFC PATCH net-next 3/4] net: systemport: use standard netdevice
 notifier to detect DSA presence
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "bcm-kernel-feedback-list@broadcom.com" 
        <bcm-kernel-feedback-list@broadcom.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20201218223852.2717102-1-vladimir.oltean@nxp.com>
 <20201218223852.2717102-4-vladimir.oltean@nxp.com>
 <e9f3188d-558c-cb3a-6d5c-17d7d93c5416@gmail.com>
 <20201219121237.tq3pxquyaq4q547t@skbuf>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <f2f420d3-baa0-e999-d23a-3e817e706cc7@gmail.com>
Date:   Sun, 20 Dec 2020 20:53:58 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20201219121237.tq3pxquyaq4q547t@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/19/2020 4:12 AM, Vladimir Oltean wrote:
> On Fri, Dec 18, 2020 at 08:08:56PM -0800, Florian Fainelli wrote:
>> On 12/18/2020 2:38 PM, Vladimir Oltean wrote:
>>> The SYSTEMPORT driver maps each port of the embedded Broadcom DSA switch
>>> port to a certain queue of the master Ethernet controller. For that it
>>> currently uses a dedicated notifier infrastructure which was added in
>>> commit 60724d4bae14 ("net: dsa: Add support for DSA specific notifiers").
>>>
>>> However, since commit 2f1e8ea726e9 ("net: dsa: link interfaces with the
>>> DSA master to get rid of lockdep warnings"), DSA is actually an upper of
>>> the Broadcom SYSTEMPORT as far as the netdevice adjacency lists are
>>> concerned. So naturally, the plain NETDEV_CHANGEUPPER net device notifiers
>>> are emitted. It looks like there is enough API exposed by DSA to the
>>> outside world already to make the call_dsa_notifiers API redundant. So
>>> let's convert its only user to plain netdev notifiers.
>>>
>>> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
>>
>> The CHANGEUPPER has a slightly different semantic than the current DSA
>> notifier, and so events that would look like this during
>> bcm_sysport_init_tx_ring() (good):
>>
>> [    6.781064] brcm-systemport 9300000.ethernet eth0: TDMA cfg, size=256, switch q=0,port=0
>> [    6.789214] brcm-systemport 9300000.ethernet eth0: TDMA cfg, size=256, switch q=1,port=0
>> [    6.797337] brcm-systemport 9300000.ethernet eth0: TDMA cfg, size=256, switch q=2,port=0
>> [    6.805464] brcm-systemport 9300000.ethernet eth0: TDMA cfg, size=256, switch q=3,port=0
>> [    6.813583] brcm-systemport 9300000.ethernet eth0: TDMA cfg, size=256, switch q=0,port=1
>> [    6.821701] brcm-systemport 9300000.ethernet eth0: TDMA cfg, size=256, switch q=1,port=1
>> [    6.829819] brcm-systemport 9300000.ethernet eth0: TDMA cfg, size=256, switch q=2,port=1
>> [    6.837944] brcm-systemport 9300000.ethernet eth0: TDMA cfg, size=256, switch q=3,port=1
>> [    6.846063] brcm-systemport 9300000.ethernet eth0: TDMA cfg, size=256, switch q=0,port=2
>> [    6.854183] brcm-systemport 9300000.ethernet eth0: TDMA cfg, size=256, switch q=1,port=2
>> [    6.862303] brcm-systemport 9300000.ethernet eth0: TDMA cfg, size=256, switch q=2,port=2
>> [    6.870425] brcm-systemport 9300000.ethernet eth0: TDMA cfg, size=256, switch q=3,port=2
>> [    6.878544] brcm-systemport 9300000.ethernet eth0: TDMA cfg, size=256, switch q=0,port=5
>> [    6.886663] brcm-systemport 9300000.ethernet eth0: TDMA cfg, size=256, switch q=1,port=5
>> [    6.894783] brcm-systemport 9300000.ethernet eth0: TDMA cfg, size=256, switch q=2,port=5
>> [    6.902906] brcm-systemport 9300000.ethernet eth0: TDMA cfg, size=256, switch q=3,port=5
>>
>> now we are getting (bad):
>>
>> [    6.678157] brcm-systemport 9300000.ethernet eth0: TDMA cfg, size=256, switch q=0,port=0
>> [    6.686302] brcm-systemport 9300000.ethernet eth0: TDMA cfg, size=256, switch q=1,port=0
>> [    6.694434] brcm-systemport 9300000.ethernet eth0: TDMA cfg, size=256, switch q=2,port=0
>> [    6.702554] brcm-systemport 9300000.ethernet eth0: TDMA cfg, size=256, switch q=3,port=0
>> [    6.710679] brcm-systemport 9300000.ethernet eth0: TDMA cfg, size=256, switch q=0,port=0
>> [    6.718797] brcm-systemport 9300000.ethernet eth0: TDMA cfg, size=256, switch q=1,port=0
>> [    6.726914] brcm-systemport 9300000.ethernet eth0: TDMA cfg, size=256, switch q=2,port=0
>> [    6.735033] brcm-systemport 9300000.ethernet eth0: TDMA cfg, size=256, switch q=3,port=0
>> [    6.743156] brcm-systemport 9300000.ethernet eth0: TDMA cfg, size=256, switch q=0,port=1
>> [    6.751275] brcm-systemport 9300000.ethernet eth0: TDMA cfg, size=256, switch q=1,port=1
>> [    6.759395] brcm-systemport 9300000.ethernet eth0: TDMA cfg, size=256, switch q=2,port=1
>> [    6.767514] brcm-systemport 9300000.ethernet eth0: TDMA cfg, size=256, switch q=3,port=1
>> [    6.775636] brcm-systemport 9300000.ethernet eth0: TDMA cfg, size=256, switch q=0,port=1
>> [    6.783754] brcm-systemport 9300000.ethernet eth0: TDMA cfg, size=256, switch q=1,port=1
>> [    6.791874] brcm-systemport 9300000.ethernet eth0: TDMA cfg, size=256, switch q=2,port=1
>> [    6.799992] brcm-systemport 9300000.ethernet eth0: TDMA cfg, size=256, switch q=3,port=1
>>
>> Looking further in bcm_sysport_map_queues() we are getting the following:
>>
>>     6.223042] brcm-systemport 9300000.ethernet eth0: mapping q=0, p=0
>> [    6.229369] brcm-systemport 9300000.ethernet eth0: mapping q=1, p=0
>> [    6.235659] brcm-systemport 9300000.ethernet eth0: mapping q=2, p=0
>> [    6.241945] brcm-systemport 9300000.ethernet eth0: mapping q=3, p=0
>> [    6.248232] brcm-systemport 9300000.ethernet eth0: mapping q=4, p=0
>> [    6.254519] brcm-systemport 9300000.ethernet eth0: mapping q=5, p=0
>> [    6.260805] brcm-systemport 9300000.ethernet eth0: mapping q=6, p=0
>> [    6.267092] brcm-systemport 9300000.ethernet eth0: mapping q=7, p=0
>>
>> which means that the call to netif_set_real_num_tx_queues() that is
>> executed for the SYSTEMPORT Lite is not taking effect because it is
>> after the register_netdevice(). Insead of using a CHANGEUPPER notifier,
>> we can use a REGISTER notifier event and doing that works just fine with
>> the same semantics as the DSA notifier being removed. This incremental
>> patch on top of your patch works for me (tm):
>>
>> https://github.com/ffainelli/linux/commit/f5095ab5c1f31db133d62273928b224674626b75
> 
> This is odd, the netif_set_real_num_tx_queues() call should not fail or
> be ignored even if the interface was registered. I had tested this already
> on my enetc + felix combo on LS1028A.

Yes that part is fine, see below.

> 
> static int enetc_dsa_join(struct net_device *dev,
> 			  struct net_device *slave_dev)
> {
> 	int err;
> 
> 	netdev_err(slave_dev, "Hello!\n");
> 
> 	err = netif_set_real_num_tx_queues(slave_dev,
> 					   slave_dev->num_tx_queues / 2);
> 	if (err)
> 		return err;
> 
> 	netdev_err(slave_dev, "New number of real TX queues: %d\n",
> 		   slave_dev->real_num_tx_queues);
> 
> 	return 0;
> }
> 
> prints:
> 
> [    7.002328] mscc_felix 0000:00:00.5 swp0 (uninitialized): PHY [0000:00:00.3:10] driver [Microsemi GE VSC8514 SyncE] (irq=POLL)
> [    7.021190] mscc_felix 0000:00:00.5 swp0: Hello!
> [    7.028657] mscc_felix 0000:00:00.5 swp0: New number of real TX queues: 4
> [    7.035589] mscc_felix 0000:00:00.5 swp0: Hello!
> [    7.040380] mscc_felix 0000:00:00.5 swp0: New number of real TX queues: 4
> [    7.290236] mscc_felix 0000:00:00.5 swp1 (uninitialized): PHY [0000:00:00.3:11] driver [Microsemi GE VSC8514 SyncE] (irq=POLL)
> [    7.314383] mscc_felix 0000:00:00.5 swp1: Hello!
> [    7.321292] mscc_felix 0000:00:00.5 swp1: New number of real TX queues: 4
> [    7.328223] mscc_felix 0000:00:00.5 swp1: Hello!
> [    7.332967] mscc_felix 0000:00:00.5 swp1: New number of real TX queues: 4
> [    7.574254] mscc_felix 0000:00:00.5 swp2 (uninitialized): PHY [0000:00:00.3:12] driver [Microsemi GE VSC8514 SyncE] (irq=POLL)
> [    7.598431] mscc_felix 0000:00:00.5 swp2: Hello!
> [    7.605215] mscc_felix 0000:00:00.5 swp2: New number of real TX queues: 4
> [    7.612145] mscc_felix 0000:00:00.5 swp2: Hello!
> [    7.616889] mscc_felix 0000:00:00.5 swp2: New number of real TX queues: 4
> [    7.858868] mscc_felix 0000:00:00.5 swp3 (uninitialized): PHY [0000:00:00.3:13] driver [Microsemi GE VSC8514 SyncE] (irq=POLL)
> [    7.884240] mscc_felix 0000:00:00.5 swp3: Hello!
> [    7.891086] mscc_felix 0000:00:00.5 swp3: New number of real TX queues: 4
> [    7.898018] mscc_felix 0000:00:00.5 swp3: Hello!
> [    7.902763] mscc_felix 0000:00:00.5 swp3: New number of real TX queues: 4
> 
> (I am not sure why the notifier is called twice though)

This is the actual issue that messes up the queue assignment for
bcmsysport because we assign queue/switch port pairs and don't really
expect to be re-doing that once ring->inspect is set to true.

> 
> You are saying that here:
> 
> 	num_tx_queues = slave_dev->real_num_tx_queues;
> 
> num_tx_queues remains assigned to 8? Does this mean that netif_set_real_num_tx_queues
> has returned an error code? Can you check why?
> 

The call to netif_set_real_num_tx_queues() succeeds and
slave_dev->real_num_tx_queues is changed to 4 accordingly. The loop that
assigns the internal queue mapping (priv->ring_map) is correctly limited
to 4, however we get two calls per switch port instead of one. I did not
have much time to debug why we get called twice but I will be looking
into this tomorrow.
-- 
Florian
