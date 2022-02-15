Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 927E54B79E8
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 22:50:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244219AbiBOUyc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 15:54:32 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243497AbiBOUyc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 15:54:32 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B78527171
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 12:54:21 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id u18so334254edt.6
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 12:54:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=71WCayc5/CJZ92qfXlhwclA6u/LxWQLtdQOYakxN0WE=;
        b=kuBsG/MdxpCLBosQOY7fdYzzVAqzvoon2EOIUg36FoJHlJyCO7qyn+l54oM8E34SSt
         aUxUOEoMQKZ6hgfFhgA+j8JRENBMTjGxnMBkWXZ8JBUN5oAuwgD0itaW8UgyGo+k0xK+
         lH9WyoAN3Q12FoYfFBrZg/th4Pk8VmvibKC05kAa6MRSLDeGMjKJzzPUJ6gSyJPu0eiN
         HITcDqFEJlRLryumwi07XPasnOE95rJPWfvnQvvXChCKpiDcPYJ4zZsH/O5AM7Bvf/GN
         TsBWjCBb7a8K2Rk59I7RwJFQQEeIOnKoVPEAbm7BeY25R7zn45QSTY7j3yQgqbTmIU/T
         IX5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=71WCayc5/CJZ92qfXlhwclA6u/LxWQLtdQOYakxN0WE=;
        b=qJy4pR++sn+K1Ashq+nQxo+mXlCHS1hpOHY1BT+7Vf/a9uQnI4EIZ2UL9OQfT0+Pg9
         HjdxI6aJ3PuyE5ApPkT6t9iia7aUEuSumS8oiMaZ4ldJjXGfKIc9ZfZGgEI5fo+0KKcl
         Do3myQT5UeAq+SsIY6jf8ZU9oqMAVqIAz7nfcbQIaNfoNWaHDvF1h6fzestLQPHhdn38
         oVtKD1C343Bys+DGKaU9wgfj1tocxvXCEuWEYylvjVosxEg152X43kwLQHwqMtTzzn0F
         Gry8gS7+eIfpM2Ufnw0cGL6cldfgOh7JC1CuA/sQpVy2LesRK9fL6qJ1oyGHYQ5Vkrn9
         /3cw==
X-Gm-Message-State: AOAM530tdCSYL2ntOpFLHoXgOhWpXsdfWERKNfplGVwKLwFxajVDmg4L
        XYYYVXWg9PxlZ48rDOF2vGo=
X-Google-Smtp-Source: ABdhPJz5uEeJdSEk+g9GHEq6BaxThauJOyer1hVHv28y9fmTDNLx3xy4cXz92AboHoIXT2CIqgd2Hw==
X-Received: by 2002:a05:6402:11cd:: with SMTP id j13mr756562edw.119.1644958459952;
        Tue, 15 Feb 2022 12:54:19 -0800 (PST)
Received: from skbuf ([188.27.184.105])
        by smtp.gmail.com with ESMTPSA id o18sm405722edw.102.2022.02.15.12.54.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Feb 2022 12:54:19 -0800 (PST)
Date:   Tue, 15 Feb 2022 22:54:18 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     =?utf-8?B?TcOlbnMgUnVsbGfDpXJk?= <mans@mansr.com>,
        netdev@vger.kernel.org,
        Egil Hjelmeland <privat@egil-hjelmeland.no>,
        Andrew Lunn <andrew@lunn.ch>,
        Juergen Borleis <jbe@pengutronix.de>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        lorenzo@kernel.org
Subject: Re: DSA using cpsw and lan9303
Message-ID: <20220215205418.a25ro255qbv5hpjk@skbuf>
References: <yw1x8rud4cux.fsf@mansr.com>
 <d19abc0a-4685-514d-387b-ac75503ee07a@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d19abc0a-4685-514d-387b-ac75503ee07a@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Måns,

On Mon, Feb 14, 2022 at 09:16:10AM -0800, Florian Fainelli wrote:
> +others,
> 
> netdev is a high volume list, you should probably copy directly the
> people involved with the code you are working with.
> 
> On 2/14/22 8:44 AM, Måns Rullgård wrote:
> > The hardware I'm working on has a LAN9303 switch connected to the
> > Ethernet port of an AM335x (ZCE package).  In trying to make DSA work
> > with this combination, I have encountered two problems.
> > 
> > Firstly, the cpsw driver configures the hardware to filter out frames
> > with unknown VLAN tags.  To make it accept the tagged frames coming from
> > the LAN9303, I had to modify the latter driver like this:
> > 
> > diff --git a/drivers/net/dsa/lan9303-core.c b/drivers/net/dsa/lan9303-core.c
> > index 2de67708bbd2..460c998c0c33 100644
> > --- a/drivers/net/dsa/lan9303-core.c
> > +++ b/drivers/net/dsa/lan9303-core.c
> > @@ -1078,20 +1079,28 @@ static int lan9303_port_enable(struct dsa_switch *ds, int port,
> >                                struct phy_device *phy)
> >  {
> >         struct lan9303 *chip = ds->priv;
> > +       struct net_device *master;
> >  
> >         if (!dsa_is_user_port(ds, port))
> >                 return 0;
> >  
> > +       master = dsa_to_port(chip->ds, 0)->master;
> > +       vlan_vid_add(master, htons(ETH_P_8021Q), port);
> 
> That looks about right given that net/dsa/tag_lan9303.c appears to be a
> quasi DSA_TAG_PROTO_8021Q implementation AFAICT.

In case it was not clear, I agree with Florian that this looks "about right",
I just thought that mentioning it wouldn't bring much to the table.
But I noticed you submitted a patch for the other issue and not for this.

Some complaints about accessing the CPU port as dsa_to_port(chip->ds, 0),
but it's not the first place in this driver where that is done.

dsa_tag_8021q_port_setup() also has:

	/* Add @rx_vid to the master's RX filter. */
	vlan_vid_add(master, ctx->proto, rx_vid);

which is an indication that other switches with VLAN-based tagging
protocols should handle this somehow, somewhere.

Note, though, that vlan_vid_add() allocates memory, so it would be good
to have a vlan_vid_del() too at some point.
