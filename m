Return-Path: <netdev+bounces-2100-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A2D3A70041C
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 11:42:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 23726281A28
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 09:42:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33DDCBE5C;
	Fri, 12 May 2023 09:42:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2650A747E
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 09:42:19 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D98811DAF;
	Fri, 12 May 2023 02:41:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=7IRubd/9LUDaS7AZzS9MSSlrTD+Lz1RxX42jUzfFNis=; b=qZECOHXy4PsT+NcZQUsq6/3ZQH
	MOKcOYAQDHgL5BDNC7W37CmfNq82INs3FUVzxmJO9ofFepVuA/lmdd7B27ea+TrqCEDXOiesozFCZ
	HmEFwmCTtrSuoSMt8rGMCmVGI4WHY2600Dlpz88KW2NEEHdNS3lSkhvEfX3VGOEIwWFRDzyEFU/gD
	kNiDYQI+essXwyQRc/DqfbO0cIZNGVLvXD/9xOsGFf5Ett8di61JhVhbqio9hfLm01Wk1Oh1XdgHT
	1RA11imCbi4fCSxusHES6zHE5odbSJ6sZRiFiVu7nwvhMo2yY3XDewd+M0xmXM48qt3oMc869nL4X
	5mO9qzKw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:60252)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1pxPHT-00085g-GI; Fri, 12 May 2023 10:41:43 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1pxPHR-0004y9-Oq; Fri, 12 May 2023 10:41:41 +0100
Date: Fri, 12 May 2023 10:41:41 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Yan Wang <rk.code@outlook.com>
Cc: andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5] net: mdiobus: Add a function to deassert reset
Message-ID: <ZF4J1VqEqbnE6JG9@shell.armlinux.org.uk>
References: <KL1PR01MB54486A247214CC72CAB5A433E6759@KL1PR01MB5448.apcprd01.prod.exchangelabs.com>
 <ZF4AjX6csKkVJzht@shell.armlinux.org.uk>
 <KL1PR01MB54488021E5650ED8A203057FE6759@KL1PR01MB5448.apcprd01.prod.exchangelabs.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <KL1PR01MB54488021E5650ED8A203057FE6759@KL1PR01MB5448.apcprd01.prod.exchangelabs.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 12, 2023 at 05:28:47PM +0800, Yan Wang wrote:
> 
> 
> On 5/12/2023 5:02 PM, Russell King (Oracle) wrote:
> > On Fri, May 12, 2023 at 03:08:53PM +0800, Yan Wang wrote:
> > > +	gpiod_set_value_cansleep(reset, gpiod_is_active_low(reset));
> > > +	fsleep(reset_assert_delay);
> > > +	gpiod_set_value_cansleep(reset, !gpiod_is_active_low(reset));
> > Andrew, one of the phylib maintainers and thus is responsible for code
> > in the area you are touching. Andrew has complained about the above
> > which asserts and then deasserts reset on two occasions now, explained
> > why it is wrong, but still the code persists in doing this.
> > 
> > I am going to add my voice as another phylib maintainer to this and say
> > NO to this code, for the exact same reasons that Andrew has given.
> > 
> > You now have two people responsible for the code in question telling
> > you that this is the wrong approach.
> > 
> > Until this is addressed in some way, it is pointless you posting
> > another version of this patch.
> > 
> > Thanks.
> > 
> I'm very sorry, I didn't have their previous intention.
> The meaning of the two assertions is reset and reset release.
> If you believe this is the wrong method, please ignore it.

As Andrew has told you twice:

We do not want to be resetting the PHY while we are probing the bus,
and he has given one reason for it.

The reason Andrew gave is that hardware resetting a PHY that was not
already in reset means that any link is immediately terminated, and
the PHY has to renegotiate with its link partner when your code
subsequently releases the reset signal. This is *not* the behaviour
that phylib maintainers want to see.

The second problem that Andrew didn't mention is that always hardware
resetting the PHY will clear out any firmware setup that has happened
before the kernel has been booted. Again, that's a no-no.

The final issue I have is that your patch is described as "add a
function do *DEASSERT* reset" not "add a function to *ALWAYS* *RESET*"
which is what you are actually doing here. So the commit message and
the code disagree with what's going on - the summary line is at best
misleading.

If your hardware case is that the PHY is already in reset, then of
course you don't see any of the above as a problem, but that is not
universally true - and that is exactly why Andrew is bringing this
up. There are platforms out there where the reset is described in
the firmware hardware description, *but* when the kernel boots, the
reset signal is already deasserted. Raising it during kernel boot as
you are doing will terminate the PHY's link with the remote end,
and then deasserting it will cause it to renegotiate.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

