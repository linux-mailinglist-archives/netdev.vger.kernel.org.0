Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4B234B8EB8
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 18:00:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236883AbiBPRAt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 12:00:49 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236850AbiBPRAn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 12:00:43 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E74992A521C
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 09:00:30 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id d10so657651eje.10
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 09:00:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=f8xIakNzQVWTZ40zvyrJZpSWzZUHN6Ie5TpTC2Pm/Y8=;
        b=evz3g+F9FsbpSvl8yjHO1fClJms4SNJa1xT28hv1/0ioP3Cpw/2m2pvxKlhEL1RUvq
         uomOvjP87+HKnjHwdRzpo4jk+cd0hwr1ngnH4f8lcZSLkeHU4cjQif2x7Qv1hu1jWaAE
         T1BFHsAbcKY8aOxRdZjOZZ/5h9eJwZseUj1avZJ/Dc6YEEA6A5vEo+j4/+k4yi4hfiim
         Mn3/8Dg2ysw7SAMsskly9Te+61bSUON2OBrjQ6IV6ETLADIAC7WbCXiRUIMtXhyguVVT
         1PwNK0yTCPdSNjprWluwSctM8zk4836qxfWSRJEb2A8F6n/98aDXMPhoo4NYkKUyivKz
         /J7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=f8xIakNzQVWTZ40zvyrJZpSWzZUHN6Ie5TpTC2Pm/Y8=;
        b=mAL/8DgnX2DF6IUHGQ6BQ0WmWbjR6J0lQs4IoqfViFL36EDeTs9re/DhLF++RQK7jY
         hnlSlc5vZYCROWNSYpnPeUsW3lsTZh3sDAj50eif/XIoLqYJR7EFGtxe8qCcyfCehVOf
         PpLLpCss3x2dsA3hIrXfR4xuA1HHeF8Na3dVGSZGfco09o95TmOzCu9pPcf7MUXKEjEA
         DQTKRopnrt8XcApgxc9urwwh6ODqTEVCRHRvCy2wV/+uKRbB7fwSxnyUGB2VhK3XC+g3
         WnTcUzNH0iJxOu97lZSacHnvz7Y54VK2sSzEey4bd9PdTtYzLhphcm9crz+dg/5iwAMc
         qXeA==
X-Gm-Message-State: AOAM530+1c3T0AlKDr/w4S7ZsLFt7uwJmolP53u0Fzqd8juZBrHqnBvu
        3nob2y54dbczlyTnf8do1Rk=
X-Google-Smtp-Source: ABdhPJxO8PjDIXV9wNBhDYKKUAtNYYZhBTrFUYSpzagWpQa7BJEWQaMYZODOdlruR4JXrjUUxnFKvg==
X-Received: by 2002:a17:906:d8ae:b0:6b7:98d6:6139 with SMTP id qc14-20020a170906d8ae00b006b798d66139mr3002478ejb.498.1645030829331;
        Wed, 16 Feb 2022 09:00:29 -0800 (PST)
Received: from skbuf ([188.27.184.105])
        by smtp.gmail.com with ESMTPSA id z8sm106894ejc.151.2022.02.16.09.00.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Feb 2022 09:00:28 -0800 (PST)
Date:   Wed, 16 Feb 2022 19:00:27 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     =?utf-8?B?TcOlbnMgUnVsbGfDpXJk?= <mans@mansr.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org,
        Egil Hjelmeland <privat@egil-hjelmeland.no>,
        Andrew Lunn <andrew@lunn.ch>,
        Juergen Borleis <jbe@pengutronix.de>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        lorenzo@kernel.org
Subject: Re: DSA using cpsw and lan9303
Message-ID: <20220216170027.yrkj5r4zberrx3qb@skbuf>
References: <yw1x8rud4cux.fsf@mansr.com>
 <d19abc0a-4685-514d-387b-ac75503ee07a@gmail.com>
 <20220215205418.a25ro255qbv5hpjk@skbuf>
 <yw1xa6er2bno.fsf@mansr.com>
 <20220216141543.dnrnuvei4zck6xts@skbuf>
 <yw1x5ype3n6r.fsf@mansr.com>
 <20220216142634.uyhcq7ptjamao6rl@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220216142634.uyhcq7ptjamao6rl@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 16, 2022 at 04:26:34PM +0200, Vladimir Oltean wrote:
> On Wed, Feb 16, 2022 at 02:23:24PM +0000, Måns Rullgård wrote:
> > Vladimir Oltean <olteanv@gmail.com> writes:
> > 
> > > On Wed, Feb 16, 2022 at 01:17:47PM +0000, Måns Rullgård wrote:
> > >> > Some complaints about accessing the CPU port as dsa_to_port(chip->ds, 0),
> > >> > but it's not the first place in this driver where that is done.
> > >> 
> > >> What would be the proper way to do it?
> > >
> > > Generally speaking:
> > >
> > > 	struct dsa_port *cpu_dp;
> > >
> > > 	dsa_switch_for_each_cpu_port(cpu_dp, ds)
> > > 		break;
> > >
> > > 	// use cpu_dp
> > >
> > > If your code runs after dsa_tree_setup_default_cpu(), which contains the
> > > "DSA: tree %d has no CPU port\n" check, you don't even need to check
> > > whether cpu_dp was found or not - it surely was. Everything that runs
> > > after dsa_register_switch() has completed successfully - for example the
> > > DSA ->setup() method - qualifies here.
> > 
> > In this particular driver, the setup function contains this:
> > 
> > 	/* Make sure that port 0 is the cpu port */
> > 	if (!dsa_is_cpu_port(ds, 0)) {
> > 		dev_err(chip->dev, "port 0 is not the CPU port\n");
> > 		return -EINVAL;
> > 	}
> > 
> > I take this to mean that port 0 is guaranteed to be the cpu port.  Of
> > course, it can't hurt to be thorough just in case that check is ever
> > removed.
> 
> Yes, I saw that, and I said that there are other places in the driver
> that assume port 0 is the CPU port. Although I don't know why that is,
> if the switch can only operate like that, etc. I just pointed out how it
> would be preferable to get a hold of the CPU port in a regular DSA
> driver without any special constraints.

Ah, silly me, I should have paid more attention on where you're actually
inserting the code. You could have done:

static int lan9303_port_enable(struct dsa_switch *ds, int port,
			       struct phy_device *phy)
{
	struct dsa_port *dp = dsa_to_port(ds, port);
	struct lan9303 *chip = ds->priv;

	if (!dsa_port_is_user(dp))
		return 0;

	vlan_vid_add(dp->cpu_dp->master, htons(ETH_P_8021Q), port);

	return lan9303_enable_processing_port(chip, port);
}

the advantage being that if this driver ever supports the remapping of
the CPU port, or multiple CPU ports, this logic wouldn't need to be
changed, as it also conveys the user-to-CPU port affinity.

Anyway, doesn't really matter, and you certainly don't need to resend
for this. Sorry again for not paying too much attention.
