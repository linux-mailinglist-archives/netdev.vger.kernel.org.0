Return-Path: <netdev+bounces-4349-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id ABA7E70C284
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 17:35:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 880531C20B5A
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 15:35:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F58214AB4;
	Mon, 22 May 2023 15:35:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6368514AB3
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 15:35:38 +0000 (UTC)
X-Greylist: delayed 2201 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 22 May 2023 08:35:37 PDT
Received: from mail11.truemail.it (mail11.truemail.it [217.194.8.81])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0170CD;
	Mon, 22 May 2023 08:35:36 -0700 (PDT)
Received: from francesco-nb.int.toradex.com (31-10-206-125.static.upc.ch [31.10.206.125])
	by mail11.truemail.it (Postfix) with ESMTPA id 044E721334;
	Mon, 22 May 2023 17:35:34 +0200 (CEST)
Date: Mon, 22 May 2023 17:35:33 +0200
From: Francesco Dolcini <francesco@dolcini.it>
To: Andrew Lunn <andrew@lunn.ch>
Cc: Francesco Dolcini <francesco@dolcini.it>,
	Praneeth Bajjuri <praneeth@ti.com>, Geet Modi <geet.modi@ti.com>,
	"David S. Miller" <davem@davemloft.net>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	Grygorii Strashko <grygorii.strashko@ti.com>,
	Dan Murphy <dmurphy@ti.com>
Subject: Re: DP83867 ethernet PHY regression
Message-ID: <ZGuLxSJwXbSE/Rbb@francesco-nb.int.toradex.com>
References: <ZGuDJos8D7N0J6Z2@francesco-nb.int.toradex.com>
 <e0d4b397-a8d9-4546-a8a2-14cf07914e64@lunn.ch>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="/zTa0TOsm9Yb+E2A"
Content-Disposition: inline
In-Reply-To: <e0d4b397-a8d9-4546-a8a2-14cf07914e64@lunn.ch>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


--/zTa0TOsm9Yb+E2A
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 22, 2023 at 05:15:56PM +0200, Andrew Lunn wrote:
> On Mon, May 22, 2023 at 04:58:46PM +0200, Francesco Dolcini wrote:
> > Hello all,
> > commit da9ef50f545f ("net: phy: dp83867: perform soft reset and retain
> > established link") introduces a regression on my TI AM62 based board.
> > 
> > I have a working DTS with Linux TI 5.10 downstream kernel branch, while
> > testing the DTS with v6.4-rc in preparation of sending it to the mailing
> > list I noticed that ethernet is working only on a cold poweron.
> 
> Do you have more details about how it does not work.
> 
> Please could you use:
> 
> mii-tool -vvv ethX

please see the attached files:

working_da9ef50f545f_reverted.txt
  this is on a v6.4-rc, with da9ef50f545f reverted

not_working.txt
  v6.4-rc not working

working.txt
  v6.4-rc working


It looks like, even on cold boot, it's not working in a reliable way.
Not sure the exact difference when it's working and when it's not.

> in both the good and bad state. The register values might give us a
> clue.

Thanks for your help,
Francesco


--/zTa0TOsm9Yb+E2A
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="not_working.txt"

Using SIOCGMIIPHY=0x8947
eth0: negotiated 1000baseT-FD flow-control, link ok
  registers for MII PHY 0: 
    1140 796d 2000 a231 05e1 c5e1 006f 2001
    5806 0200 3800 0000 0000 4007 0000 3000
    5048 ac02 ec10 0004 2bc7 0000 0000 0040
    6150 4444 0002 0000 0000 0000 0282 0000
  product info: vendor 08:00:28, model 35 rev 1
  basic mode:   autonegotiation enabled
  basic status: autonegotiation complete, link ok
  capabilities: 1000baseT-FD 100baseTx-FD 100baseTx-HD 10baseT-FD 10baseT-HD
  advertising:  1000baseT-FD 100baseTx-FD 100baseTx-HD 10baseT-FD 10baseT-HD flow-control
  link partner: 1000baseT-FD 100baseTx-FD 100baseTx-HD 10baseT-FD 10baseT-HD flow-control

--/zTa0TOsm9Yb+E2A
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment;
	filename="working_da9ef50f545f_reverted.txt"

Using SIOCGMIIPHY=0x8947
eth0: negotiated 1000baseT-FD flow-control, link ok
  registers for MII PHY 0: 
    1140 796d 2000 a231 05e1 c5e1 006d 2001
    5806 0200 3800 0000 0000 4007 0000 3000
    5048 af02 ec10 0000 2bc7 0000 0000 0040
    6150 4444 0002 0000 0000 0000 0282 0000
  product info: vendor 08:00:28, model 35 rev 1
  basic mode:   autonegotiation enabled
  basic status: autonegotiation complete, link ok
  capabilities: 1000baseT-FD 100baseTx-FD 100baseTx-HD 10baseT-FD 10baseT-HD
  advertising:  1000baseT-FD 100baseTx-FD 100baseTx-HD 10baseT-FD 10baseT-HD flow-control
  link partner: 1000baseT-FD 100baseTx-FD 100baseTx-HD 10baseT-FD 10baseT-HD flow-control

--/zTa0TOsm9Yb+E2A
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="working.txt"

Using SIOCGMIIPHY=0x8947
eth0: negotiated 1000baseT-FD flow-control, link ok
  registers for MII PHY 0: 
    1140 796d 2000 a231 05e1 c5e1 006f 2001
    5806 0200 3800 0000 0000 4007 0000 3000
    5048 ac02 ec10 0000 2bc7 0000 0000 0040
    6150 4444 0002 0000 0000 0000 0282 0000
  product info: vendor 08:00:28, model 35 rev 1
  basic mode:   autonegotiation enabled
  basic status: autonegotiation complete, link ok
  capabilities: 1000baseT-FD 100baseTx-FD 100baseTx-HD 10baseT-FD 10baseT-HD
  advertising:  1000baseT-FD 100baseTx-FD 100baseTx-HD 10baseT-FD 10baseT-HD flow-control
  link partner: 1000baseT-FD 100baseTx-FD 100baseTx-HD 10baseT-FD 10baseT-HD flow-control

--/zTa0TOsm9Yb+E2A--

