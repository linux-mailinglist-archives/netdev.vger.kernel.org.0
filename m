Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5511668BA99
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 11:43:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbjBFKn0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 05:43:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229925AbjBFKnT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 05:43:19 -0500
Received: from mail.kernel-space.org (unknown [IPv6:2a01:4f8:c2c:5a84::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99C39FF3D
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 02:43:06 -0800 (PST)
Received: from ziongate (localhost [127.0.0.1])
        by ziongate (OpenSMTPD) with ESMTP id f323a07c;
        Mon, 6 Feb 2023 10:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=simple; d=kernel-space.org; h=
        message-id:date:mime-version:subject:to:cc:references:from
        :in-reply-to:content-type:content-transfer-encoding; s=default;
         bh=hv4AvXBhZ77PZSm9p7xqaUfh0N4=; b=k/n5s+3XWFlPRJoEg0GDMdV0UmTg
        rbDpKZtfLET+wltBN6qsEdxwfIzis8TSFsR9EnxUHb4o5G5c9+PHM5RpraLJAKy2
        A+60ZgyaY/bHP0z//WslPS2yY3ffrURybLbJbxYM0VkfLpqE8IZfWL7w5j2Q0qc6
        DuE01wpv0jRNkB8=
DomainKey-Signature: a=rsa-sha1; c=simple; d=kernel-space.org; h=
        message-id:date:mime-version:subject:to:cc:references:from
        :in-reply-to:content-type:content-transfer-encoding; q=dns; s=
        default; b=poHrMMAuf9jicRaaXBvMAAkiw/djg+i6Vr8flCuXFRGSoUdwFLJrX
        UHP1F0pR1y/jw8MfhP6i8wf2ITLHIHhhMOF+F2+nVoQvPMW8zhB/n3uPXw24Pl1B
        yBfx+uJfxNVkIRcsXya3zcDLUm531Dk2IQpSW9V9LnFXqkSmzEdlA4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel-space.org;
        s=20190913; t=1675680183;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=e7/XaIVIBso7u4NZ1i2Ab/QXWfxIRu0kBxgGTFlWpFQ=;
        b=tsfsNjVKdwrhQadhkNuq2fXBXgw1fg6aFWdLKi0Ic0Ck0kv6yAmNmcm+CnvFVPdDC7oJTt
        C2mlav2CBJWP4OZg/z1jo9rKowwKIfYbxzxHFQRgmq7y2VoiUfj3Eo7VxAKJEOexJffk2A
        Uq3plafojCYjpTKDqkxVCAxXbVq4i+w=
Received: from [192.168.0.2] (host-82-49-214-117.retail.telecomitalia.it [82.49.214.117])
        by ziongate (OpenSMTPD) with ESMTPSA id 9f098385 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Mon, 6 Feb 2023 10:43:03 +0000 (UTC)
Message-ID: <1423df62-11aa-bbe3-8573-e5fd4fb17bbb@kernel-space.org>
Date:   Mon, 6 Feb 2023 11:43:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.0
Subject: Re: mv88e6321, dual cpu port
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org
References: <Y7yIK4a8mfAUpQ2g@lunn.ch>
 <ed027411-c1ec-631a-7560-7344c738754e@kernel-space.org>
 <20230110222246.iy7m7f36iqrmiyqw@skbuf> <Y73ub0xgNmY5/4Qr@lunn.ch>
 <8d0fce6c-6138-4594-0d75-9a030d969f99@kernel-space.org>
 <20230123112828.yusuihorsl2tyjl3@skbuf>
 <7e29d955-2673-ea54-facb-3f96ce027e96@kernel-space.org>
 <20230123191844.ltcm7ez5yxhismos@skbuf> <Y87pLbMC4GRng6fa@lunn.ch>
 <7dd335e4-55ec-9276-37c2-0ecebba986b9@kernel-space.org>
 <Y8/jrzhb2zoDiidZ@lunn.ch>
From:   Angelo Dureghello <angelo@kernel-space.org>
In-Reply-To: <Y8/jrzhb2zoDiidZ@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RDNS_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

still thanks a lot,

On 24/01/23 14:57, Andrew Lunn wrote:
> On Tue, Jan 24, 2023 at 08:21:35AM +0100, Angelo Dureghello wrote:
>>
>> Hi Andrew and Vladimir,
>>
>> On Mon, 23 Jan 2023, Andrew Lunn wrote:
>>
>>>> I don't know what this means:
>>>>
>>>> | I am now trying this way on mv88e6321,
>>>> | - one vlan using dsa kernel driver,
>>>> | - other vlan using dsdt userspace driver.
>>>>
>>>> specifically what is "dsdt userspace driver".
>>>
>>> I think DSDT is Marvells vendor crap code.
>>>
>> Yes, i have seen someone succeeding using it, why do you think it's crap ?
> 
> In the Linux kernel community, that is the name given to vendor code,
> because in general, that is the quality level. The quality does vary
> from vendor to vendor and SDK to SDK, some are actually O.K.
> 
>>
>>> Having two drivers for the same hardware is a recipe for disaster.
>>>
>>>   Andrew
>>>
>>
>> What i need is something as
>>
>>          eth0 ->  vlan1 -> port5(rmii)  ->  port 0,1,2
>>          eth1 ->  vlan2 -> port6(rgmii) ->  port 3,4
>>
>> The custom board i have here is already designed in this way
>> (2 fixed-link mac-to-mac connecitons) and trying my best to have
>> the above layout working.
> 
> With todays mainline i would do:
> 
> So set eth0 as DSA master port.
> 
> Create a bridge br0 with ports 0, 1, 2.
> Create a bridge br1 with ports 3, 4, 6.
> 

This is what i am testing now, a bit different,
swapped ports 5 and 6.

#
# Configuration:
#                                   cpu      +---- port0
#              br0 eth0  <-> rgmii  port 6  -+---- port1
#                                            |
#                                            +---- port2
#
#                                  user      +---- port3
#              br1 eth1  <-> rmii  port 5   -+-----port4
#
#

mdio {
		#address-cells = <1>;
		#size-cells = <0>;

		switch1: switch1@1d {
			compatible = "marvell,mv88e6085";
			reg = <0x1d>;
			interrupt-parent = <&lsio_gpio3>;
			interrupts = <4 IRQ_TYPE_LEVEL_LOW>;
			interrupt-controller;
			#interrupt-cells = <2>;

			ports {
				#address-cells = <1>;
				#size-cells = <0>;

				port@0 {
					reg = <0>;
					label = "port0";
					phy-mode = "1000base-x";
					managed = "in-band-status";
					sfp = <&sfp_0>;
				};
				port@1 {
					reg = <1>;
					label = "port1";
					phy-mode = "1000base-x";
					managed = "in-band-status";
					sfp = <&sfp_1>;
				};
				/* This is phyenet0 now */
				port@2 {
					reg = <2>;
					label = "port2";
					phy-handle = <&switchphy2>;
				};
				port@6 {
					/* wired to cpu fec1 */
					reg = <6>;
					label = "cpu";
					ethernet = <&fec1>;
					fixed-link = <0 1 1000 0 0>;
				};
				port@3 {
					/* phy is internal to the switch */
					reg = <3>;
					label = "port3";
					phy-handle = <&switchphy3>;
				};
				port@4 {
					/* phy is internal to the switch */
					reg = <4>;
					label = "port4";
					phy-handle = <&switchphy4>;
				};
				port@5 {
					/* wired to cpu fec2 */
					reg = <5>;
					label = "port5";
					ethernet = <&fec2>;
					fixed-link = <1 1 100 0 0>;
				};
			};

All seems to work properly, but on ports 0, 1, 2 i cannot go
over 100Mbit even if master port (6) is rgmii
(testing by iperf3).

What could the reason of this limitation ?

> You don't actually make use of the br1 interface in Linux, it just
> needs to be up. You can think of eth1 being connected to an external
> managed switch.
> 
> 	Andrew

Thanks a lot,
angelo


