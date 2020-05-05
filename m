Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 374711C56BC
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 15:24:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729088AbgEENYT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 09:24:19 -0400
Received: from mx2.suse.de ([195.135.220.15]:46454 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729020AbgEENYT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 May 2020 09:24:19 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 639E2AB3D;
        Tue,  5 May 2020 13:24:20 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 669E7602B9; Tue,  5 May 2020 15:24:17 +0200 (CEST)
Date:   Tue, 5 May 2020 15:24:17 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Chris Healy <cphealy@gmail.com>, michael@walle.cc
Subject: Re: [PATCH net-next v2 04/10] net: ethtool: Add attributes for cable
 test reports
Message-ID: <20200505132417.GI5989@lion.mk-sys.cz>
References: <20200505001821.208534-1-andrew@lunn.ch>
 <20200505001821.208534-5-andrew@lunn.ch>
 <20200505082838.GH8237@lion.mk-sys.cz>
 <20200505131548.GE208718@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200505131548.GE208718@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 05, 2020 at 03:15:48PM +0200, Andrew Lunn wrote:
> > > + +---------------------------------------------+--------+---------------------+
> > > + | ``ETHTOOL_A_CABLE_TEST_HEADER``             | nested | reply header        |
> > > + +---------------------------------------------+--------+---------------------+
> > > + | ``ETHTOOL_A_CABLE_TEST_STATUS``             | u8     | completed           |
> > > + +---------------------------------------------+--------+---------------------+
> > > + | ``ETHTOOL_A_CABLE_TEST_NTF_NEST``           | nested | all the results     |
> > > + +-+-------------------------------------------+--------+---------------------+
> > > + | | ``ETHTOOL_A_CABLE_TEST_STATUS``           | u8     | completed           |
> > > + +-+-------------------------------------------+--------+---------------------+
> > 
> > You have ETHTOOL_A_CABLE_TEST_STATUS both here and on top level. AFAICS
> > the top level attribute is the right one - but the name is
> > ETHTOOL_A_CABLE_TEST_NTF_STATUS.
> 
> Hi Michal
> 
> They need better names. The first one is about the test run
> status. Started vs complete. A notification is sent when the test is
> started, and a second one at the end with the actual test results. The
> second status is per pair, indicating open, shorted, O.K.
> Maybe this second one shouldd be ETHTOOL_A_CABLE_TEST_NTF_PAIR_STATUS.

The per-pair status is ETHTOOL_A_CABLE_RESULTS_CODE (nested within
ETHTOOL_A_CABLE_TEST_NTF_RESULT), isn't it?

Based on the code, I would say second ETHTOOL_A_CABLE_TEST_STATUS line
should be dropped and first fixed to ETHTOOL_A_CABLE_TEST_NTF_STATUS.

Michal
