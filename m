Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA6B2699C76
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 19:39:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230058AbjBPSj3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 13:39:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229709AbjBPSjU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 13:39:20 -0500
Received: from mail.kernel-space.org (unknown [IPv6:2a01:4f8:c2c:5a84::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC42B50AE9
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 10:39:10 -0800 (PST)
Received: from ziongate (localhost [127.0.0.1])
        by ziongate (OpenSMTPD) with ESMTP id a900941e;
        Thu, 16 Feb 2023 18:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=simple; d=kernel-space.org; h=
        message-id:date:mime-version:subject:to:cc:references:from
        :in-reply-to:content-type:content-transfer-encoding; s=default;
         bh=y2Ixs2SEovzmh69KB1znTG7RlsQ=; b=lqH6OCn8u2Nknl2nAxNM+IExRMYj
        XVU9irTi7PsoevHC/6eu+0/p9IVYeN30H8kfzvxbSYYH7qJTo0/FMca+4YHptWeZ
        jPPi0AszVnFtZhhJxdMGx+tFkMRpG44F9NRdQy/UtDYhJOhtnjkd35gzUd3PylWA
        +FLMdsHdwkKEioE=
DomainKey-Signature: a=rsa-sha1; c=simple; d=kernel-space.org; h=
        message-id:date:mime-version:subject:to:cc:references:from
        :in-reply-to:content-type:content-transfer-encoding; q=dns; s=
        default; b=iXZ0SYlMXcIGkX/QLEHSb8Y1Y3kjVQO4YJsfRkHENRlikYnec+dOZ
        vWz34lVigUATqFaN9SXiSEw65stjnTBieYQ545CinXlnHWFV/n3N53cjgFSarOFA
        vqqJZm9DvFUOUz75J+gWH5Li9fTVfrSL3trisbZC9b25F9mccQZzx4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel-space.org;
        s=20190913; t=1676572748;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kgyAkZC9wikdRznyyozxqhHzAF0YPwyyhZsvrauiifs=;
        b=KHjpeJxk4viAu0goESIBRQgQ4AqGHFqrAx1yhXqcQucL8JBMAI1kesMGYBDVnPyTbZ471T
        jLBpgRBD/BpIJ4Z44ZZ/zCBqArTz1N3HTqV4g+DUhRzpoCn1VTmzqVn5mMac487BkzAyCy
        mxeOt8a6Q7R3dlwcrU9xFuTplh4+PHM=
Received: from [192.168.0.2] (host-87-15-216-95.retail.telecomitalia.it [87.15.216.95])
        by ziongate (OpenSMTPD) with ESMTPSA id db2fdc8f (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Thu, 16 Feb 2023 18:39:08 +0000 (UTC)
Message-ID: <07ac38b4-7e11-82bd-8c24-4362d7c83ca0@kernel-space.org>
Date:   Thu, 16 Feb 2023 19:39:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: mv88e6321, dual cpu port
Content-Language: en-US
To:     Vladimir Oltean <olteanv@gmail.com>, Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org
References: <8d0fce6c-6138-4594-0d75-9a030d969f99@kernel-space.org>
 <20230123112828.yusuihorsl2tyjl3@skbuf>
 <7e29d955-2673-ea54-facb-3f96ce027e96@kernel-space.org>
 <20230123191844.ltcm7ez5yxhismos@skbuf> <Y87pLbMC4GRng6fa@lunn.ch>
 <7dd335e4-55ec-9276-37c2-0ecebba986b9@kernel-space.org>
 <Y8/jrzhb2zoDiidZ@lunn.ch>
 <7e379c00-ceb8-609e-bb6d-b3a7d83bbb07@kernel-space.org>
 <20230216125040.76ynskyrpvjz34op@skbuf> <Y+4oqivlA/VcTuO6@lunn.ch>
 <20230216153120.hzhcfo7t4lk6eae6@skbuf>
From:   Angelo Dureghello <angelo@kernel-space.org>
In-Reply-To: <20230216153120.hzhcfo7t4lk6eae6@skbuf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RDNS_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 16/02/23 4:31 PM, Vladimir Oltean wrote:
> On Thu, Feb 16, 2023 at 01:59:22PM +0100, Andrew Lunn wrote:
>> On Thu, Feb 16, 2023 at 02:50:40PM +0200, Vladimir Oltean wrote:
>>> On Thu, Feb 16, 2023 at 12:20:24PM +0100, Angelo Dureghello wrote:
>>>> Still data passes all trough port6, even when i ping from
>>>> host PC to port4. I was expecting instead to see port5
>>>> statistics increasing.
>>>
>>>> # configure the bridge
>>>> ip addr add 192.0.2.1/25 dev br0
>>>> ip addr add 192.0.2.129/25 dev br1
>>>
>>> In this configuration you're supposed to put an IP address on the fec2
>>> interface (eth1), not on br1.
>>>
>>> br1 will handle offloaded forwarding between port5 and the external
>>> ports (port3, port4). It doesn't need an IP address. In fact, if you
>>> give it an IP address, you will make the sent packets go through the br1
>>> interface, which does dev_queue_xmit() to the bridge ports (port3, port4,
>>> port5), ports which are DSA, so they do dev_queue_xmit() through their
>>> DSA master - eth0. So the system behaves as instructed.
>>
>> Yep. As i said in another email, consider eth1 being connected to an
>> external managed switch. br1 is how you manage that switch, but that
>> is all you use br1 for. eth1 is where you do networking.
> 
> It would have been good to have support for subtractive device tree
> overlays, such that when there are multiple CPU ports in the device
> tree, the stable device tree has both CPU ports marked with the
> "ethernet" phandle, but the user has the option of deleting that
> property from one of the CPU ports, turning it into a user port.
> Currently for LS1028A I am doing this device tree post-processing
> from the U-Boot command line:
> 
> => tftp $fdt_addr_r ls1028/fsl-ls1028a-rdb.dtb
> => fdt addr $fdt_addr_r
> => fdt rm /soc/pcie@1f0000000/ethernet-switch@0,5/ports/port@4 ethernet
> 
> but it has the disadvantage that you can only operate with the
> configuration that you booted with.
> 
> I analyzed the possibility for DSA to dynamically switch a port between
> operating as a CPU port or a user port, but it is simply insanely complicated.

thanks really, nice to know, i should not need
dynamic devicetree changes, but interesting that can be
done from u-boot this way.

I have a last issue, migrating from 5.4.70,
in 5.15.32 i have this error for both sfp cages:

# [   45.860784] mv88e6085 5b040000.ethernet-1:1d: p0: 
phylink_mac_link_state() failed: -95
[   45.860814] mv88e6085 5b040000.ethernet-1:1d: p0: 
phylink_mac_link_state() failed: -95
[   49.093371] mv88e6085 5b040000.ethernet-1:1d: p1: 
phylink_mac_link_state() failed: -95
[   49.093400] mv88e6085 5b040000.ethernet-1:1d: p1: 
phylink_mac_link_state() failed: -95


Is seems related to the fact that i am in in-band-status,
but 6321 has not serdes_pcs_get_state() op.

How can i fix this ?

Thanks !
-- 
Angelo Dureghello
