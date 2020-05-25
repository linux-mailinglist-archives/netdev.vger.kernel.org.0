Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D37E11E1520
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 22:12:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389587AbgEYUMJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 16:12:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388994AbgEYUMJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 16:12:09 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAE6DC061A0E
        for <netdev@vger.kernel.org>; Mon, 25 May 2020 13:12:08 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id s8so18131329wrt.9
        for <netdev@vger.kernel.org>; Mon, 25 May 2020 13:12:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6DyYOArtqvkWNyCxsRj84Ktm1BjPYiqYh6NfzPwu5cg=;
        b=LyT1Ux26xpSFi/N1U9hQkeBpOmfVhsYks54b7dVcRH1oyQF9oXyV1AyWLmO5PjbSsv
         QuHhhwqA/YlsEV5xHlh0byXE2KiXvYuZX9gZbrCjGe4oRbu/oAw5dPsj+gZz3qvMpOsh
         EXq2E1yzhFpDRQ4H3PEK2VE8/qUwV5Nat5N/obhy3kMHJV1OxJAw9FMZrl7RxqvJNiKw
         GaneQ7aVu1opvv6NmlzVnkr54pv7BzQHTbSqkmqGQ9uFqwc40/OuNl9BM1evZscRzCFj
         FLcQtqiVwN7aW0EBGBzE3QI1TumP0moSS+9qNlScTOmYBR+46FfkvtPmiIh2ynAS8ySi
         Xc/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6DyYOArtqvkWNyCxsRj84Ktm1BjPYiqYh6NfzPwu5cg=;
        b=s1rmk+raKLvFCLEVwuQTi4TDShHl+wCRDknoJIelFqqUNa0bl5c7+4Y3+hEiGrfHWY
         MXsRUpgn68VB0vb+/Cr919Hk7fU4wiLQIK3UOwS3tSeXS1bXYS1ECa7kvUyx8l7SCksf
         QFcKUFGmJDHy9Rzf08FT2qB/9Elf97wC9mFhDD1f/EhcqQG1E/apFXPNpFyxo8hqHwlS
         ObuaJSdXzNg6vKZ46+XlkuuEzDXLrlzsqXzS5QE7+AaOwt2uO2IPkeatPRNzRTV4UaA4
         PrqqHlTnE0muBFjxluzeyHL2OUezFqvzGOtCDH0P7l727KkaUkDz9L5rWiokgWa0T6YL
         mskw==
X-Gm-Message-State: AOAM531xoggzISmCxHIH1k1mhdM1F0ou13Y4p3wpSewzRtZqTc2rT5yg
        tFXAc5JAMdValteZUzM7js2/ELT/
X-Google-Smtp-Source: ABdhPJyQkk5A7UhChLJdwOfkcd9RvkETRdqBQosSlmVGQ9LxtmsP5DSWa8OGBigde2k3YPuxq1kjYA==
X-Received: by 2002:adf:fb08:: with SMTP id c8mr16879749wrr.421.1590437526712;
        Mon, 25 May 2020 13:12:06 -0700 (PDT)
Received: from [10.230.188.43] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id z7sm18059452wrt.6.2020.05.25.13.12.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 May 2020 13:12:06 -0700 (PDT)
Subject: Re: [PATCH] dpaa_eth: fix usage as DSA master, try 3
To:     Vladimir Oltean <olteanv@gmail.com>, davem@davemloft.net
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com,
        madalin.bucur@oss.nxp.com, netdev@vger.kernel.org
References: <20200524212251.3311546-1-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <39f2c015-3f1f-74cf-258e-ca6156a779c4@gmail.com>
Date:   Mon, 25 May 2020 13:12:02 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <20200524212251.3311546-1-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/24/2020 2:22 PM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> The dpaa-eth driver probes on compatible string for the MAC node, and
> the fman/mac.c driver allocates a dpaa-ethernet platform device that
> triggers the probing of the dpaa-eth net device driver.
> 
> All of this is fine, but the problem is that the struct device of the
> dpaa_eth net_device is 2 parents away from the MAC which can be
> referenced via of_node. So of_find_net_device_by_node can't find it, and
> DSA switches won't be able to probe on top of FMan ports.
> 
> It would be a bit silly to modify a core function
> (of_find_net_device_by_node) to look for dev->parent->parent->of_node
> just for one driver. We're just 1 step away from implementing full
> recursion.
> 
> Actually there have already been at least 2 previous attempts to make
> this work:
> - Commit a1a50c8e4c24 ("fsl/man: Inherit parent device and of_node")
> - One or more of the patches in "[v3,0/6] adapt DPAA drivers for DSA":
>   https://patchwork.ozlabs.org/project/netdev/cover/1508178970-28945-1-git-send-email-madalin.bucur@nxp.com/
>   (I couldn't really figure out which one was supposed to solve the
>   problem and how).
> 
> Point being, it looks like this is still pretty much a problem today.
> On T1040, the /sys/class/net/eth0 symlink currently points to
> 
> ../../devices/platform/ffe000000.soc/ffe400000.fman/ffe4e6000.ethernet/dpaa-ethernet.0/net/eth0
> 
> which pretty much illustrates the problem. The closest of_node we've got
> is the "fsl,fman-memac" at /soc@ffe000000/fman@400000/ethernet@e6000,
> which is what we'd like to be able to reference from DSA as host port.
> 
> For of_find_net_device_by_node to find the eth0 port, we would need the
> parent of the eth0 net_device to not be the "dpaa-ethernet" platform
> device, but to point 1 level higher, aka the "fsl,fman-memac" node
> directly. The new sysfs path would look like this:
> 
> ../../devices/platform/ffe000000.soc/ffe400000.fman/ffe4e6000.ethernet/net/eth0
> 
> And this is exactly what SET_NETDEV_DEV does. It sets the parent of the
> net_device. The new parent has an of_node associated with it, and
> of_dev_node_match already checks for the of_node of the device or of its
> parent.
> 
> Fixes: a1a50c8e4c24 ("fsl/man: Inherit parent device and of_node")
> Fixes: c6e26ea8c893 ("dpaa_eth: change device used")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

FWIW:

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
--
Florian
