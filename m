Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4749C655F20
	for <lists+netdev@lfdr.de>; Mon, 26 Dec 2022 03:08:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231513AbiLZCIa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Dec 2022 21:08:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiLZCI2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Dec 2022 21:08:28 -0500
Received: from cavan.codon.org.uk (irc.codon.org.uk [IPv6:2a00:1098:84:22e::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA6D638B2;
        Sun, 25 Dec 2022 18:08:24 -0800 (PST)
Received: by cavan.codon.org.uk (Postfix, from userid 1000)
        id 58E09424AA; Mon, 26 Dec 2022 02:08:23 +0000 (GMT)
Date:   Mon, 26 Dec 2022 02:08:23 +0000
From:   Matthew Garrett <mjg59@srcf.ucam.org>
To:     Lars Melin <larsm17@gmail.com>
Cc:     johan@kernel.org, bjorn@mork.no, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, Matthew Garrett <mgarrett@aurora.tech>
Subject: Re: [PATCH 1/3] USB: serial: option: Add generic MDM9207
 configurations
Message-ID: <20221226020823.GA10889@srcf.ucam.org>
References: <20221225205224.270787-1-mjg59@srcf.ucam.org>
 <20221225205224.270787-2-mjg59@srcf.ucam.org>
 <10cff30a-719d-f6b0-419c-36c552f4bc4b@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <10cff30a-719d-f6b0-419c-36c552f4bc4b@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-0.8 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,KHOP_HELO_FCRDNS,SPF_HELO_NEUTRAL,
        SPF_NEUTRAL autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 26, 2022 at 08:23:34AM +0700, Lars Melin wrote:
> On 12/26/2022 03:52, Matthew Garrett wrote:
> > +	/* Qualcomm MDM9207 - 0: DIAG, 2: AT, 3: NMEA */
> > +	{ USB_DEVICE(QUALCOMM_VENDOR_ID, 0xf601),
> > +	  .driver_info = RSVD(1) | RSVD(4) | RSVD(5) },
> > +	/* Qualcomm MDM9207 - 2: DIAG, 4: AT, 5: NMEA */
> > +	{ USB_DEVICE(QUALCOMM_VENDOR_ID, 0xf622),
> > +	  .driver_info = RSVD(0) | RSVD(1) | RSVD(3) | RSVD(6) },
> 
> Please tell what the reserved interfaces are used for and why they should be
> blacklisted.

Based on the shipped Windows Qualcomm drivers I have here, for F601 
interface 1 is bound by the qcmdm driver, interface 5 is bound by a QMI 
rmnet, and interfaces 0, 2 and 3 are bound by qcser. That leaves 
interface 4 for adb. For F622, 0 and 1 are RNDIS, 3 is the qcmdm 
interface, 2, 4 and 5 are serial, and 6 is adb. I'm not sure what qcmdm 
does. What format would you like this info in?

> The generic Qualcomm driver for 05c6:f601 (which is used by at least one
> other brand/reseller) specifies that interface#1 is for USB Modem (ppp
> dial-up).

Do you have a pointer to that driver? That seems consistent with the 
Windows drivers, but I have no experience with that.

> I assume that you posses this dongle since you add support for it so you can
> easily verify that function which I assume has not been disabled in your
> version.

Yup, I can check that once I know what it's supposed to be speaking :)
