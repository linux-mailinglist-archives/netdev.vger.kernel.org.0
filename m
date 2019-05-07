Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA230160EA
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 11:30:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726612AbfEGJ3w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 05:29:52 -0400
Received: from mga09.intel.com ([134.134.136.24]:3614 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726249AbfEGJ3w (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 May 2019 05:29:52 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 May 2019 02:29:51 -0700
X-ExtLoop1: 1
Received: from lahna.fi.intel.com (HELO lahna) ([10.237.72.157])
  by fmsmga001.fm.intel.com with SMTP; 07 May 2019 02:29:47 -0700
Received: by lahna (sSMTP sendmail emulation); Tue, 07 May 2019 12:29:46 +0300
Date:   Tue, 7 May 2019 12:29:46 +0300
From:   Mika Westerberg <mika.westerberg@linux.intel.com>
To:     Ruslan Babayev <ruslan@babayev.com>
Cc:     linux@armlinux.org.uk, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, wsa@the-dreams.de, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-acpi@vger.kernel.org,
        xe-linux-external@cisco.com
Subject: Re: [PATCH net-next 2/2] net: phy: sfp: enable i2c-bus detection on
 ACPI based systems
Message-ID: <20190507092946.GS2895@lahna.fi.intel.com>
References: <20190505220524.37266-3-ruslan@babayev.com>
 <20190506045951.GB2895@lahna.fi.intel.com>
 <871s1bv4aw.fsf@babayev.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871s1bv4aw.fsf@babayev.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 06, 2019 at 11:14:15AM -0700, Ruslan Babayev wrote:
> 
> Mika Westerberg writes:
> 
> > On Sun, May 05, 2019 at 03:05:23PM -0700, Ruslan Babayev wrote:
> >> Lookup I2C adapter using the "i2c-bus" device property on ACPI based
> >> systems similar to how it's done with DT.
> >> 
> >> An example DSD describing an SFP on an ACPI based system:
> >> 
> >> Device (SFP0)
> >> {
> >>     Name (_HID, "PRP0001")
> >>     Name (_DSD, Package ()
> >>     {
> >>         ToUUID ("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
> >>         Package () {
> >>             Package () { "compatible", "sff,sfp" },
> >>             Package () { "i2c-bus", \_SB.PCI0.RP01.I2C.MUX.CH0 },
> >
> > Hmm, ACPI has I2cSerialBusV2() resource for this purpose. Why you are not
> > using that?
> 
> I am not an ACPI expert, but my understanding is I2cSerialBusV2() is
> used for slave connections. I am trying to reference an I2C controller
> here.

Ah, the device itself is not sitting on an I2C bus? In that case I
agree, I2CSerialBusV2() is not correct here.
