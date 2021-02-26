Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5802326A0D
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 23:35:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230010AbhBZWfk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 17:35:40 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:60924 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229795AbhBZWfe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Feb 2021 17:35:34 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lFlh1-008fcg-S9; Fri, 26 Feb 2021 23:34:39 +0100
Date:   Fri, 26 Feb 2021 23:34:39 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Don Bollinger <don@thebollingers.org>
Cc:     arndb@arndb.de, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, brandon_chuang@edge-core.com,
        wally_wang@accton.com, aken_liu@edge-core.com, gulv@microsoft.com,
        jolevequ@microsoft.com, xinxliu@microsoft.com,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH v2] eeprom/optoe: driver to read/write SFP/QSFP/CMIS
 EEPROMS
Message-ID: <YDl3f8MNWdZWeOBh@lunn.ch>
References: <20210215193821.3345-1-don@thebollingers.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210215193821.3345-1-don@thebollingers.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 15, 2021 at 11:38:21AM -0800, Don Bollinger wrote:
> optoe is an i2c based driver that supports read/write access to all
> the pages (tables) of MSA standard SFP and similar devices (conforming
> to the SFF-8472 spec), MSA standard QSFP and similar devices (conforming
> to the SFF-8636 spec) and CMIS and similar devices (conforming to the
> Common Management Interface Specfication).

Hi Don

Please make sure you Cc: netdev. This is networking stuff.

And we have seen this code before, and the netdev Maintainers have
argued against it before.

> These devices provide identification, operational status and control
> registers via an EEPROM model.  These devices support one or 3 fixed pages
> (128 bytes) of data, and one page that is selected via a page register on
> the first fixed page.  Thus the driver's main task is to map these pages
> onto a simple linear address space for user space management applications.
> See the driver code for a detailed layout.

I assume you have seen the work NVIDIA submitted last week? This idea
of linear pages is really restrictive and we are moving away from it.

> The EEPROM data is accessible to user space and kernel consumers via the
> nvmem interface.

ethtool -m ?

In the past, this code has been NACKed because it does not integrate
into the networking stack. Is this attempt any different?

Thanks
	Andrew
