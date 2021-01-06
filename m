Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0B0D2EB73E
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 01:59:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726475AbhAFA6f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 19:58:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726096AbhAFA6e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 19:58:34 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60640C061793;
        Tue,  5 Jan 2021 16:57:54 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id e25so1231099wme.0;
        Tue, 05 Jan 2021 16:57:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KXYCn82HDF++SErLqK8nsHG9ESramoIEaNfyckxwBPI=;
        b=SW5O3QRjqle9V5TgLatZv6eQGXERxBJrGoLURd0zTSbfWDVB7rAhiqoBIMhNHCmTdb
         Qgh9CKpzehPTXoEvq4A5mn7egguzLVii0l5PGZ9NnneosWxLzx77DnzDSTdF0RItUcD4
         1dsl3PHJPQW360UxkvDwQ/VUjTItqJC2yr8OvZWBMRFEsizEGMgTDWsUTOTLu0NJGe5e
         HVmoTwwhtKVm+Bxr4DKx6w3apnBn5X3hQXPNwP5ThIauCYsqgXV7uxupjZFnbEXkNhlv
         R2vCDaHxr4PMwkG+EuewZp/fnE2lCrNg7PZbhnjHRqPjFnUjss1S5IvLwGtglgHD8gtd
         oywQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KXYCn82HDF++SErLqK8nsHG9ESramoIEaNfyckxwBPI=;
        b=LPguTtAva+fVzVkWlIbHpxpMs5AmKFb9clLRENCyVg2Yz5+irLtaath+F8kXY5Vrqf
         83jFT6WaEweupVcENs01IZDNxdZ8X+IRxSnbEHen+8HHmBtN6O4XbFMTM6G1RXX5vFo1
         2wCdcTVCmNl55M0OD9kpSdxBwQPJNvdNu8s5IPs2AXDVerL4FylQZL5QPs0leqLQEoz4
         DQt8F6/1rMJiyp+8aWdPfXovNLUKNll1rj+yARwyyblOCAp/wrTCu75PMaWgbxNFSqfW
         6KtBCodzLXKQlkxkUdLR/4ZmG5LxLwRBpHsY50YXz9Eym494CMK9bH6H9pYzqpwv6Pyy
         OZBQ==
X-Gm-Message-State: AOAM532QaMNEmg2H3nfoh90hsL/2ZM/EtRYjnhps2Ixj6kaibLyTNGgz
        aBIWdw7TAQCyp3UauRLFzCufUykig2A=
X-Google-Smtp-Source: ABdhPJzwo+LWEvo/adaKIVydcUGt2CQ1KNHP13ImnpMofj5R7uq/XsdAN/rBGeAnspxRg7PXXOP0rg==
X-Received: by 2002:a1c:9684:: with SMTP id y126mr1455713wmd.2.1609894672880;
        Tue, 05 Jan 2021 16:57:52 -0800 (PST)
Received: from ?IPv6:2003:ea:8f06:5500:303d:91bf:ac5c:51a1? (p200300ea8f065500303d91bfac5c51a1.dip0.t-ipconnect.de. [2003:ea:8f06:5500:303d:91bf:ac5c:51a1])
        by smtp.googlemail.com with ESMTPSA id v4sm1036267wrw.42.2021.01.05.16.57.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Jan 2021 16:57:52 -0800 (PST)
Subject: Re: [PATCH 2/3] ARM: iop32x: improve N2100 PCI broken parity quirk
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20210106002833.GA1286114@bjorn-Precision-5520>
 <9d2d3d61-8866-f7d3-09e9-a43b05128689@gmail.com>
 <20210106005257.GH1551@shell.armlinux.org.uk>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <98b79572-4445-3e4f-062a-590a874943e9@gmail.com>
Date:   Wed, 6 Jan 2021 01:57:47 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210106005257.GH1551@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06.01.2021 01:52, Russell King - ARM Linux admin wrote:
> On Wed, Jan 06, 2021 at 01:44:03AM +0100, Heiner Kallweit wrote:
>> The machine type check is there to protect from (theoretical) cases
>> where the n2100 code (incl. the RTL8169 quirk) may be compiled in,
>> but the kernel is used on another machine.
> 
> That is far from a theoretical case. The ARM port has always supported
> multiple machines in a single kernel. They just had to be "compatible"
> in other words, the same SoC. All the platforms supported by
> arch/arm/mach-iop32x can be built as a single kernel image and run on
> any of those platforms.
> 
Good to know, then we indeed need the machine check. IOW, based on
what you state we could even now have the following situation:
N2100 support is compiled in, and the kernel is used on another machine
that by chance also has Realtek RTL8169 in PCI slots 1 or 2.
Then the PCI quirk would be applied, even though the machine doesn't
have the parity issue.
