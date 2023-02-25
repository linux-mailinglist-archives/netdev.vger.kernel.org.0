Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B11886A2842
	for <lists+netdev@lfdr.de>; Sat, 25 Feb 2023 10:22:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbjBYJWX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Feb 2023 04:22:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjBYJWW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Feb 2023 04:22:22 -0500
Received: from smtp-outbound2.duck.com (smtp-outbound2.duck.com [20.67.223.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31F0FA254
        for <netdev@vger.kernel.org>; Sat, 25 Feb 2023 01:22:21 -0800 (PST)
MIME-Version: 1.0
Subject: Re: 4-port ASMedia/RealTek RTL8125 2.5Gbps NIC freezes whole system
References: <AF9C0500-2909-4FF4-8E4E-3BAD8FD8AA14.1@smtp-inbound1.duck.com>
 <92181e0e-3ca0-b19c-71f3-607fbfdc40a3@gmail.com>
 <00F8F608-C2C6-454E-8CA4-F963BC9D7005.1@smtp-inbound1.duck.com>
 <0EC01861-B6F5-40C9-AAD0-6B4ACC1EA13A.1@smtp-inbound1.duck.com>
 <cc8e02fd-53d4-6156-8728-262462958c64@gmail.com>
 <F65B5EFE-9DA8-4725-8DE4-28E02327C239.1@smtp-inbound1.duck.com>
Content-Type: text/plain;
        charset=UTF-8;
        format=flowed
Content-Transfer-Encoding: 8bit
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Received: by smtp-inbound1.duck.com; Sat, 25 Feb 2023 04:22:19 -0500
Message-ID: <4181032B-BA7D-408B-ACCC-0A380FC8BB43.1@smtp-inbound1.duck.com>
Date:   Sat, 25 Feb 2023 04:22:19 -0500
From:   fk1xdcio@duck.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=duck.com; h=From:
 Date: Message-ID: Cc: To: Content-Transfer-Encoding: Content-Type:
 References: Subject: MIME-Version; q=dns/txt; s=postal-KpyQVw;
 t=1677316939; bh=2ePMkdMKtG95J+eHqEpMRHryJWRsVhz7LaoscIj4cWE=;
 b=HsA/RjhUZME6nfP9C2KLnq5DmPnGebqEmYhJ2OyT+ay1FEUt+ppOnlTVioxDa8nOb2y+g+tGR
 svk9S8j1TkViCItDw27oSP8QfWgmI9ntCh0HE4YXAdg+BG96dvVFeJ6RCyJI6f194ClehaYyOD1
 tKbjQDp0xs4Db2P4kzXAsWM=
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2023-02-25 03:04, Heiner Kallweit wrote:
> On 25.02.2023 00:52, fk1xdcio@duck.com wrote:
>> On 2023-02-24 15:21, Heiner Kallweit wrote:
>>> On 24.02.2023 15:37, fk1xdcio@duck.com wrote:
>>>> I'm having problems getting this 4-port 2.5Gbps NIC to be stable. I 
>>>> have tried on multiple different physical systems both with Xeon 
>>>> server and i7 workstation chipsets and it behaves the same way on 
>>>> everything. Testing with latest Arch Linux and kernels 6.1, 6.2, and 
>>>> 5.15. I'm using the kernel default r8169 driver.
>> ...
>>>> "SSU-TECH" (generic/counterfeit?) 4-port 2.5Gbps PCIe x4 card
>>>>   ASMedia ASM1812 PCIe switch (driver: pcieport)
>>>>   RTL8125BG x4 (driver: r8169)
>> ...
>>> The network driver shouldn't be able to freeze the system. You can 
>>> test whether vendor driver r8125 makes a difference.
>>> This should provide us with an idea whether the root cause is at a 
>>> lower level.
...
>> I don't know what "cmd = 0xff" is referring to. Is this a command 
>> directly to the Ethernet chipset?
> 
> cmd is a chipset register and value 0xff indicates that it's not 
> accessible.
> To me it looks like the issue is somewhere on PCIe level.


I think you're right. I'm putting my efforts in to debugging the PCIe 
port and I'll take this to linux-pci.

Thanks again
