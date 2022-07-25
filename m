Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 192F9580262
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 18:03:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233790AbiGYQD0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 12:03:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbiGYQDZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 12:03:25 -0400
Received: from smtpout140.security-mail.net (smtpout140.security-mail.net [85.31.212.145])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C7A82601
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 09:03:21 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by fx405.security-mail.net (Postfix) with ESMTP id AEA2C32383B
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 18:03:19 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kalray.eu;
        s=sec-sig-email; t=1658764999;
        bh=qyCJW+adJ9RXB+xbEhrrIP5UcPkreLJKvOFMj/kY/ac=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=2aPWVPDknvTFkxIclfJXulmuEdKJTUZ9SV3oDvV7M1HTjLTLHlxo7LrUdB2JPbGUE
         29Grthd4Kp597SV6RSVLqovkk2jYAuNVICAQRp/mzIAVFmxaoR7uZHU56Fm0NiFy4D
         QLZvxz/sQMQmDDUegI+1c/N9vkCKAl91CNMJJQ+o=
Received: from fx405 (localhost [127.0.0.1]) by fx405.security-mail.net
 (Postfix) with ESMTP id 5C674323829; Mon, 25 Jul 2022 18:03:19 +0200 (CEST)
Received: from zimbra2.kalray.eu (unknown [217.181.231.53]) by
 fx405.security-mail.net (Postfix) with ESMTPS id 4B9C13237FE; Mon, 25 Jul
 2022 18:03:18 +0200 (CEST)
Received: from zimbra2.kalray.eu (localhost [127.0.0.1]) by
 zimbra2.kalray.eu (Postfix) with ESMTPS id 2A4B827E04ED; Mon, 25 Jul 2022
 18:03:18 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1]) by zimbra2.kalray.eu
 (Postfix) with ESMTP id 1375627E04EE; Mon, 25 Jul 2022 18:03:18 +0200 (CEST)
Received: from zimbra2.kalray.eu ([127.0.0.1]) by localhost
 (zimbra2.kalray.eu [127.0.0.1]) (amavisd-new, port 10026) with ESMTP id
 LnX4PctOZgXE; Mon, 25 Jul 2022 18:03:18 +0200 (CEST)
Received: from tellis.lin.mbt.kalray.eu (unknown [192.168.36.206]) by
 zimbra2.kalray.eu (Postfix) with ESMTPSA id 01C7F27E04ED; Mon, 25 Jul 2022
 18:03:18 +0200 (CEST)
X-Virus-Scanned: E-securemail, by Secumail
Secumail-id: <16391.62debec6.4954c.0>
DKIM-Filter: OpenDKIM Filter v2.10.3 zimbra2.kalray.eu 1375627E04EE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kalray.eu;
 s=32AE1B44-9502-11E5-BA35-3734643DEF29; t=1658764998;
 bh=ewgC0BzclYOJ/Cr2E7HyPVQeojvYJceqiCtT1QbaVNc=;
 h=Date:From:To:Message-ID:MIME-Version;
 b=CY8dhMFR8KzUICs6zbA51oWL0ZfMTykiqu+PU1thukLa/ld1wafOoyZBpssIonGa/
 ytM0iRMBt26opwzmqO/O+y12sRaCYr2pmyq26GNug3uv8EMwn6Etl+35KoH2Qob5Xg
 xxWMy/iCe7jlt8bZ3Vwfx1p6A1uQNG+4DIoACLHI=
Date:   Mon, 25 Jul 2022 18:03:16 +0200
From:   Jules Maselbas <jmaselbas@kalray.eu>
To:     Claudiu Manoil <claudiu.manoil@nxp.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: ethtool generate a buffer overflow in strlen
Message-ID: <20220725160316.GC9874@tellis.lin.mbt.kalray.eu>
References: <20220722173745.GB13990@tellis.lin.mbt.kalray.eu>
 <20220722142942.48f4332c@kernel.org>
 <20220725122023.GB9874@tellis.lin.mbt.kalray.eu>
 <AM9PR04MB83970688661428BB1327A03B96959@AM9PR04MB8397.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <AM9PR04MB83970688661428BB1327A03B96959@AM9PR04MB8397.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-ALTERMIMEV2_out: done
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 25, 2022 at 12:26:40PM +0000, Claudiu Manoil wrote:
> 
> 
> > -----Original Message-----
> > From: Jules Maselbas <jmaselbas@kalray.eu>
> > Sent: Monday, July 25, 2022 3:20 PM
> > To: Jakub Kicinski <kuba@kernel.org>
> > Cc: Claudiu Manoil <claudiu.manoil@nxp.com>; David S. Miller
> > <davem@davemloft.net>; netdev@vger.kernel.org
> > Subject: Re: ethtool generate a buffer overflow in strlen
> > 
> > On Fri, Jul 22, 2022 at 02:29:42PM -0700, Jakub Kicinski wrote:
> > > On Fri, 22 Jul 2022 19:37:46 +0200 Jules Maselbas wrote:
> > > > There is suspicious lines in the file
> > drivers/net/ethernet/freescale/enetc/enetc_ethtool.c:
> > > >    { ENETC_PM0_R1523X, "MAC rx 1523 to max-octet packets" },
> > > > and:
> > > >    { ENETC_PM0_T1523X, "MAC tx 1523 to max-octet packets" },
> > > >
> > > > Where the string length is actually greater than 32 bytes which is more
> > > > than the reserved space for the name. This structure is defined as
> > > > follow:
> > > >     static const struct {
> > > >         int reg;
> > > >         char name[ETH_GSTRING_LEN];
> > > >     } enetc_port_counters[] = { ...
> > > >
> > > > In the function enetc_get_strings(), there is a strlcpy call on the
> > > > counters names which in turns calls strlen on the src string, causing
> > > > an out-of-bound read, at least out-of the string.
> > > >
> > > > I am not sure that's what caused the BUG, as I don't really know how
> > > > fortify works but I thinks this might only be visible when fortify is
> > > > enabled.
> > > >
> > > > I am not sure on how to fix this issue, maybe use `char *` instead of
> > > > an byte array.
> > >
> > > Thanks for the report!
> > Thanks for the replie :)
> > 
> > > I'd suggest to just delete the RMON stats in the unstructured API
> > > in this driver and report them via
> > >
> > > 	ethtool -S eth0 --groups rmon
> > I am not familiar with ethtool: I don't understand what you're
> > suggesting. Would you mind giving some hints/links to what RMON stats
> > are?
> > 
> 
> I can do it if you're patient.
I am patient :]




