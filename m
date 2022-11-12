Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6664626B3B
	for <lists+netdev@lfdr.de>; Sat, 12 Nov 2022 20:25:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235010AbiKLTZm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Nov 2022 14:25:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231252AbiKLTZl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Nov 2022 14:25:41 -0500
Received: from mxout017.mail.hostpoint.ch (mxout017.mail.hostpoint.ch [IPv6:2a00:d70:0:e::317])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B1745FD9
        for <netdev@vger.kernel.org>; Sat, 12 Nov 2022 11:25:39 -0800 (PST)
Received: from [10.0.2.45] (helo=asmtp012.mail.hostpoint.ch)
        by mxout017.mail.hostpoint.ch with esmtps  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.95 (FreeBSD))
        (envelope-from <thomas@kupper.org>)
        id 1otw8H-000Jlq-Ra;
        Sat, 12 Nov 2022 20:25:37 +0100
Received: from [82.197.179.206] (helo=[192.168.169.11])
        by asmtp012.mail.hostpoint.ch with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.95 (FreeBSD))
        (envelope-from <thomas@kupper.org>)
        id 1otw8H-000Ceb-Lq;
        Sat, 12 Nov 2022 20:25:37 +0100
X-Authenticated-Sender-Id: thomas@kupper.org
Message-ID: <e1f9d9d1-93c1-ca1d-a0e6-819e45373a03@kupper.org>
Date:   Sat, 12 Nov 2022 20:25:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v2 net 1/1] amd-xgbe: fix active cable
Content-Language: en-US
From:   Thomas Kupper <thomas@kupper.org>
To:     Tom Lendacky <thomas.lendacky@amd.com>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Raju Rangoju <Raju.Rangoju@amd.com>,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
References: <b65b029d-c6c4-000f-dc9d-2b5cabad3a5c@kupper.org>
 <b2dedffc-a740-ed01-b1d4-665c53537a08@amd.com>
 <28351727-f1ba-5b57-2f84-9eccff6d627f@kupper.org>
 <64edbded-51af-f055-9c2f-c1f81b0d3698@kupper.org>
In-Reply-To: <64edbded-51af-f055-9c2f-c1f81b0d3698@kupper.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 11/11/22 10:00, Thomas Kupper wrote:
> > 
> > On 11/11/22 15:18, Tom Lendacky wrote:
> > > On 11/11/22 02:46, Thomas Kupper wrote:
> > > > When determine the type of SFP, active cables were not handled.
> > > > 
> > > > Add the check for active cables as an extension to the passive cable check.
> > > 
> > > Is this fixing a particular problem? What SFP is this failing for? A more \
> > > descriptive commit message would be good. 
> > > Also, since an active cable is supposed to be advertising it's capabilities in \
> > > the eeprom, maybe this gets fixed via a quirk and not a general check this field.
> > 
> > It is fixing a problem regarding a Mikrotik S+AO0005 AOC cable (we were in contact \
> > back in Feb to May). And your right I should have been more descriptive in the \
> > commit message.
> 
> That looks like a fiber cable with a dedicated SFP+. Can you supply the 
> output of an "ethtool -m XXX" command and a "ethtool -m XXX hex on" command?

(Sorry, didn't see your email, seems it went to the mailing list only)

ethtool -m enp6s0f2
	Identifier                                : 0x03 (SFP)
	Extended identifier                       : 0x04 (GBIC/SFP defined by 2-wire interface ID)
	Connector                                 : 0x21 (Copper pigtail)
	Transceiver codes                         : 0x00 0x00 0x00 0x00 0x00 0x08 0x00 0x00 0x00
	Transceiver type                          : Active Cable
	Encoding                                  : 0x06 (64B/66B)
	BR, Nominal                               : 10300MBd
	Rate identifier                           : 0x00 (unspecified)
	Length (SMF,km)                           : 0km
	Length (SMF)                              : 0m
	Length (50um)                             : 0m
	Length (62.5um)                           : 0m
	Length (Copper)                           : 5m
	Length (OM3)                              : 0m
	Active Cu cmplnce.                        : 0x0c (unknown) [SFF-8472 rev10.4 only]
	Vendor name                               : MikroTik
	Vendor OUI                                : 00:00:00
	Vendor PN                                 : S+AO0005
	Vendor rev                                : 1.0
	Option values                             : 0x00 0x12
	Option                                    : RX_LOS implemented
	Option                                    : TX_DISABLE implemented
	BR margin, max                            : 0%
	BR margin, min                            : 0%
	Vendor SN                                 : STST050B1900001
	Date code                                 : 210515

ethtool -m enp6s0f2 hex on
Offset		Values
------		------
0x0000:		03 04 21 00 00 00 00 00 08 00 00 06 67 00 00 00
0x0010:		00 00 05 00 4d 69 6b 72 6f 54 69 6b 20 20 20 20
0x0020:		20 20 20 20 00 00 00 00 53 2b 41 4f 30 30 30 35
0x0030:		20 20 20 20 20 20 20 20 31 2e 30 20 0c 00 00 5a
0x0040:		00 12 00 00 53 54 53 54 30 35 30 42 31 39 30 30
0x0050:		30 30 31 20 32 31 30 35 31 35 20 20 00 00 05 25
0x0060:		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
0x0070:		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
0x0080:		31 31 35 35 38 38 36 32 ff ff ff ff ff ff ff ff
0x0090:		32 31 30 34 32 38 30 31 32 ff ff ff ff ff ff ff
0x00a0:		ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
0x00b0:		32 31 30 35 30 34 30 30 31 ff ff ff ff ff ff ff
0x00c0:		ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
0x00d0:		32 31 30 35 30 34 30 30 32 ff ff ff ff ff ff ff
0x00e0:		37 37 31 ff ff ff ff ff ff ff ff ff ff ff ff ff
0x00f0:		31 31 35 35 38 38 36 32 ff ff ff ff ff ff ff ff
0x0100:		55 00 f6 00 50 00 fb 00 8c a0 6d 60 88 b8 71 48
0x0110:		1d 4c 00 fa 17 70 01 f4 31 2d 04 ea 27 10 06 30
0x0120:		31 2d 01 3c 27 10 01 8e 00 00 00 00 00 00 00 00
0x0130:		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
0x0140:		00 00 00 00 3f 80 00 00 00 00 00 00 01 00 00 00
0x0150:		01 00 00 00 01 00 00 00 01 00 00 00 00 00 00 44
0x0160:		20 e6 7f 00 0c b0 1e 54 0d e4 00 00 00 00 30 00
0x0170:		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
0x0180:		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
0x0190:		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
0x01a0:		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
0x01b0:		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
0x01c0:		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
0x01d0:		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
0x01e0:		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
0x01f0:		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

Thanks
/Thomas

> > > > Fixes: abf0a1c2b26a ("amd-xgbe: Add support for SFP+ modules")
> > > > Signed-off-by: Thomas Kupper <thomas.kupper@gmail.com>
> > > > ---
> > > > drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c | 5 +++--
> > > > 1 file changed, 3 insertions(+), 2 deletions(-)
> > > > 
> > > > diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c \
> > > > b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c index 4064c3e3dd49..1ba550d5c52d \
> > > >                 100644
> > > > --- a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
> > > > +++ b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
> > > > @@ -1158,8 +1158,9 @@ static void xgbe_phy_sfp_parse_eeprom(struct \
> > > > xgbe_prv_data *pdata) }
> > > > 
> > > > /* Determine the type of SFP */
> > > > -    if (phy_data->sfp_cable == XGBE_SFP_CABLE_PASSIVE &&
> > > > -        xgbe_phy_sfp_bit_rate(sfp_eeprom, XGBE_SFP_SPEED_10000))
> > > > +    if ((phy_data->sfp_cable == XGBE_SFP_CABLE_PASSIVE ||
> > > > +         phy_data->sfp_cable == XGBE_SFP_CABLE_ACTIVE) &&
> > > > +         xgbe_phy_sfp_bit_rate(sfp_eeprom, XGBE_SFP_SPEED_10000))
> > > 
> > > This is just the same as saying:
> > > 
> > > if (xgbe_phy_sfp_bit_rate(sfp_eeprom, XGBE_SFP_SPEED_10000))
> > > 
> > > since the sfp_cable value is either PASSIVE or ACTIVE.
> > > 
> > > I'm not sure I like fixing whatever issue you have in this way, though. If \
> > > anything, I would prefer this to be a last case scenario and be placed at the end \
> > > of the if-then-else block. But it may come down to applying a quirk for your \
> > > situation.
> > 
> > I see now that this cable is probably indeed not advertising its capabilities \
> > correctly, I didn't understand what Shyam did refer to in his mail from June 6. 
> > Unfortunately I haven't hear back from you guys after June 6 so I tried to fix it \
> > myself ... but do lack the knowledge in that area. 
> 
> Adding Shyam back to see what the status is...
> 
> > A quirk seems a good option.
> 
> The quirk may be that the parsing code calls a function that updates the 
> eeprom data in memory based on the SFP identifier.
> 
> Thanks,
> Tom
> 
> > 
> > From my point of view this patch can be cancelled/aborted/deleted.
> > I'll look into how to fix it using a quirk but maybe I'm not the hest suited \
> > candidate to do it. 
> > /Thomas
> > 
> > > 
> > > Thanks,
> > > Tom
> > > 
> > > > phy_data->sfp_base = XGBE_SFP_BASE_10000_CR;
> > > > else if (sfp_base[XGBE_SFP_BASE_10GBE_CC] & XGBE_SFP_BASE_10GBE_CC_SR)
> > > > phy_data->sfp_base = XGBE_SFP_BASE_10000_SR;
> > > > -- 
> > > > 2.34.1
