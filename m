Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 031671E1782
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 23:59:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731015AbgEYV7W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 17:59:22 -0400
Received: from foss.arm.com ([217.140.110.172]:44600 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727842AbgEYV7V (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 May 2020 17:59:21 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E9CE131B;
        Mon, 25 May 2020 14:59:20 -0700 (PDT)
Received: from [192.168.122.166] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 912333F6C4;
        Mon, 25 May 2020 14:59:20 -0700 (PDT)
Subject: Re: [RFC 01/11] net: phy: Don't report success if devices weren't
 found
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com,
        madalin.bucur@oss.nxp.com, calvin.johnson@oss.nxp.com,
        linux-kernel@vger.kernel.org
References: <20200522213059.1535892-1-jeremy.linton@arm.com>
 <20200522213059.1535892-2-jeremy.linton@arm.com>
 <20200523182054.GW1551@shell.armlinux.org.uk>
 <e6e08ca4-5a6d-5ea3-0f97-946f1d403568@arm.com>
 <20200525094536.GK1551@shell.armlinux.org.uk>
 <be729566-5c63-a711-9a99-acc53d871b88@arm.com>
 <20200525210751.GN1551@shell.armlinux.org.uk>
From:   Jeremy Linton <jeremy.linton@arm.com>
Message-ID: <0eec69af-2099-2fee-f0f1-a83c7e4c2690@arm.com>
Date:   Mon, 25 May 2020 16:59:16 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200525210751.GN1551@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 5/25/20 4:07 PM, Russell King - ARM Linux admin wrote:
> On Mon, May 25, 2020 at 04:02:13PM -0500, Jeremy Linton wrote:
>>> So, I think you're going to have to add a work-around to ignore bit 0,
>>> which brings up the question whether this is worth it or not.
>>
>> It does ignore bit 0, it gets turned into the C22 regs flag, and
>> cleared/ignored in the remainder of the code (do to MMD loop indexes
>> starting at 1).
> 
> However, I've already pointed out that that isn't the case in a
> number of functions that I listed in another email, and I suspect
> was glossed over.
> 

Hmm, right, I might not be understanding, I'm still considering your 
comments in 4/11 and a couple others..

OTOH, the mmd 0 logic could be completely removed, as its actually been 
broken for a year or so in linux (AFAIK) because the code triggering it 
was disabled when the C22 sanitation patch was merged. OTOH, this patch 
is still clearing the C22 flag from devices, so anything dependent 
entirely on that should have the same behavior as before.

So, there is a bug in the is_valid_phy/device macro, because I messed it 
up when I converted it to a function because its using a signed val, 
when it should be unsigned. I don't think that is what you were hinting 
in 4/11 though.

Thanks,
