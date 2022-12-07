Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6428A645926
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 12:40:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229973AbiLGLkK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 06:40:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229878AbiLGLkE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 06:40:04 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4F2E4A047;
        Wed,  7 Dec 2022 03:40:02 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id c17so15935863edj.13;
        Wed, 07 Dec 2022 03:40:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=AgZ0i/6e7j7kcWkFANR2gexiNHfzkWpimQo5SdP0bk0=;
        b=pmdZqmxqMc2n5+sFYonRzoTUi1mNCEmDEtPiFGIwu8XJd0RvMgKg9KdwPRpP/c17Zs
         XYLugMG0Rt+hu/BJikiDoPLvNLVzLmscJmtSD7UGZbyZkP7SiJpVmS8C8FTkbvWMC2mP
         HYVn+41HN67JgEKh5ekw8yUF0UOICmqRPDalVovoI0yy2wHUqaEJD1dNvi8azmgsFamn
         YGk9BdD8Rb8erbB1kLpEEbnuMjCuxW+AUGy5qyktdxg7kfvsXXix9keJhHqfIzvYCeD9
         dg1k0oFHa/X7tuFqpfFEOhOKC4KcnGvbXxHiPZ04y8LZYsPNtunr+eyDCmt1qNXnZbY5
         q+hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AgZ0i/6e7j7kcWkFANR2gexiNHfzkWpimQo5SdP0bk0=;
        b=sdajm+9t8BZaxrD7Wr9XR9+wEbaadHIywb8W9emQ40y6nC+FIsFtSDmSS7jOkRypVN
         Ez0x9oOMOEmf4V7sNxKtPub+8Kx2oZUQkc79Luk2mM4A9y+IUphX2UG4eeCNIYMx6w79
         ZTSEV9UV6cr3Fku3FHrP+fWZcceSAuawt9D10B6fwACzPVwoQNS+cUyrhUuS4xgaEj7p
         H33Fi270FZ7TrxckDPfqNqeaeZafsXTZ5UMEVZZVTDBiwoYY5cfXkxwebChqJVbW0KP+
         7xiZc7h45bpHDF9840qdoEs8pJ/2RfbB7dCvoODSAmjs1NnmY7PKNqaHiRJeHJduXjB+
         bz5A==
X-Gm-Message-State: ANoB5pm2u76Sv2dmkghUBYJulWw4sQgoJt9DAqcR3XHASE3UtNoX1zJu
        LT43Q5iDQPVNjiRv6wPODm8=
X-Google-Smtp-Source: AA0mqf7AvpawazttMWmSyEH5Y0oLshmoH5PPSr1DlCw62r6c0xr8kpkfXrnJw785J5PWfbfSJB241A==
X-Received: by 2002:aa7:c94a:0:b0:46b:74e1:872c with SMTP id h10-20020aa7c94a000000b0046b74e1872cmr33254011edt.301.1670413200980;
        Wed, 07 Dec 2022 03:40:00 -0800 (PST)
Received: from skbuf ([188.26.184.215])
        by smtp.gmail.com with ESMTPSA id q2-20020a17090676c200b00770812e2394sm8359801ejn.160.2022.12.07.03.40.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 03:40:00 -0800 (PST)
Date:   Wed, 7 Dec 2022 13:39:58 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jerry.Ray@microchip.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux@armlinux.org.uk
Subject: Re: [PATCH net-next v3 1/2] dsa: lan9303: Add port_max_mtu API
Message-ID: <20221207113958.6xp64kcp5ekwmlaa@skbuf>
References: <20221206183500.6898-1-jerry.ray@microchip.com>
 <20221206183500.6898-2-jerry.ray@microchip.com>
 <20221206185616.2ksuvlcmgelsfvw5@skbuf>
 <MWHPR11MB16930878ED42D3F4CC95A015EF1B9@MWHPR11MB1693.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MWHPR11MB16930878ED42D3F4CC95A015EF1B9@MWHPR11MB1693.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 06, 2022 at 11:44:58PM +0000, Jerry.Ray@microchip.com wrote:
> > > +/* For non-cpu ports, the max frame size is 1518.
> > > + * The CPU port supports a max frame size of 1522.
> > > + * There is a JUMBO flag to make the max size 2048, but this driver
> > > + * presently does not support using it.
> > > + */
> > > +static int lan9303_port_max_mtu(struct dsa_switch *ds, int port)
> > > +{
> > > +     struct net_device *p = dsa_port_to_master(dsa_to_port(ds, port));
> > 
> > You can put debugging prints in the code, but please, in the code that
> > you submit, do remove gratuitous poking in the master net_device.
> > 
> > > +     struct lan9303 *chip = ds->priv;
> > > +
> > > +     dev_dbg(chip->dev, "%s(%d) entered. NET max_mtu is %d",
> > > +             __func__, port, p->max_mtu);
> > > +
> > > +     if (dsa_port_is_cpu(dsa_to_port(ds, port)))
> > 
> > The ds->ops->port_max_mtu() function is never called for the CPU port.
> > You must know this, you put a debugging print right above. If this would
> > have been called for anything other than user ports, dsa_port_to_master()
> > would have triggered a NULL pointer dereference (dp->cpu_dp is set to
> > NULL for CPU ports).
> > 
> > So please remove dead code.
> > 
> 
> I've written the function to handle being called with any port.  While I
> couldn't directly exercise calling the port_max_mtu with the cpu port, I did
> simulate it to verify it would work.
> 
> I'm using the dsa_to_port() rather than the dsa_port_to_master() function.

No, you're using the dsa_to_port() *and* the dsa_port_to_master() functions.
See? It's in the code you posted:

static int lan9303_port_max_mtu(struct dsa_switch *ds, int port)
{
	struct net_device *p = dsa_port_to_master(dsa_to_port(ds, port));
			       ~~~~~~~~~~~~~~~~~~

> I'd rather include support for calling the api with the cpu port. I didn't
> want to assume otherwise.  That's why I don't consider this dead code.
> 
> > > +             return 1522 - ETH_HLEN - ETH_FCS_LEN;
> > > +     else
> > > +             return 1518 - ETH_HLEN - ETH_FCS_LEN;
> > 
> > Please replace "1518 - ETH_HLEN - ETH_FCS_LEN" with "ETH_DATA_LEN".
> > 
> > Which brings me to a more serious question. If you say that the max_mtu
> > is equal to the default interface MTU (1500), and you provide no means
> > for the user to change the MTU to a different value, then why write the
> > patch? What behaves differently with and without it?
> > 
> 
> I began adding the port_max_mtu api to attempt to get rid of the following
> error message:
> "macb f802c000.ethernet eth0: error -22 setting MTU to 1504 to include DSA overhead"

And how well did that go? That error message is saying that the macb driver
(drivers/net/ethernet/cadence/macb_main.c) does not accept the MTU of 1504.
Maybe because it doesn't have MACB_CAPS_JUMBO, I don't know. But this
patch is clearly unrelated to the problem you've observed.

> If someone were to check the max_mtu supported on the CPU port of the LAN9303,
> they would see that 1504 is okay.

No, they would not see that 1504 is okay. They would get a NULL pointer
dereference in your function, if port_max_mtu() was ever called for a
CPU port.

Don't believe me? You don't even have to. Please look at this patch,
study it, run it, and see what happens with your port_max_mtu()
implementation.

diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
index e5f156940c67..636e4b4df79a 100644
--- a/net/dsa/dsa.c
+++ b/net/dsa/dsa.c
@@ -473,6 +473,12 @@ static int dsa_port_setup(struct dsa_port *dp)
 			break;
 		dsa_port_enabled = true;
 
+		if (ds->ops->port_max_mtu) {
+			dev_info(ds->dev, "max MTU of CPU port %d is %d\n",
+				 dp->index,
+				 ds->ops->port_max_mtu(ds, dp->index));
+		}
+
 		break;
 	case DSA_PORT_TYPE_DSA:
 		if (dp->dn) {

The max_mtu of the CPU port is simply a question that the DSA core does
not ask, so there's no reason to report it. How things are supposed to
work is that the max_mtu of the user ports is propagated to their
net_devices, and when the MTU of any user port is changed, the
port_change_mtu() of that user port is called, and the maximum MTU of
all user ports is recalculated and all CPU and DSA ports also get a
port_change_mtu() call with that maximum value. If those ports need to
program their hardware with something that also includes their tagging
protocol overhead, they do so privately.
