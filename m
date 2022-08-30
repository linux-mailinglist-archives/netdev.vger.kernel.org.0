Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6AA05A6898
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 18:42:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbiH3Qmh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 12:42:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbiH3Qmf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 12:42:35 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E732EB4E97
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 09:42:30 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id a36so11175809edf.5
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 09:42:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=QWqlcoOhKViejjGKqPenZXc5x9RaxDwuU7ZN2ehh4p4=;
        b=iZwV30n9ouOMUwArdumF/A855X4o8oYLgU4InXY2hzU2CvFTnxooWavJC+B8OTJWNf
         wJK1tXS3uJHsgF8JG2MXI2f45KR+Y6iMRwGTWdtX4O2eSmrZz0WfYu54cN4ThtIMDixc
         AWu50AyaGzdIc4o0rmzgzQyOmdlwDb5jSvxnAmLxFcyAVv2uOLLJnLVb6nVF5mxjbJ09
         dqXdo9Yp3/prXyBGV+VTdTbvT7q8j6SF79CCRHTkCVd7kLZBEPE6f4g9+IalFqp5Mc04
         xvf+a0ki0OECEtkbgOyaC7FH4swtvMcV7wkTqPVCjMu72xnDss42mpJzuvwzoxSts+XQ
         LS0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=QWqlcoOhKViejjGKqPenZXc5x9RaxDwuU7ZN2ehh4p4=;
        b=mIEAxdwMnb0jtkIwnQa1vsabFp4Lv21cg6UOF5nEo56UBY0MlzbGBH8uwyoGY1BP4C
         RDpSlOs1EAgwY58cfS+LPPNvz4DOfyDt2jGMB+krk2VUa08lVGHT0sWB9+8W0kQ7uNdf
         rMJVX/LvKuDhayzVIhvodhvoqbBw/flgu2zIa8RTcB18Vv08kpwaqyFUztexI9n8Q2Tt
         l2TAWT6MN4pSxA6YhoUnk+CLMj3ZAOjD6zplDOrTENm8dRk8xJselcKYwbbX8XmifBkL
         M21i7vZMSyGHgxwQkI2mKxQbAPt9TqEnAnMAOT8MYb/Ieac/oVAKQV1gsuNYBQ8VkMuW
         GyTA==
X-Gm-Message-State: ACgBeo1NRBp0yNfJ+fBY2TjDmZsl0l6YyqNWlXcKApt0I7HKQ3cPLEK3
        /AIimtecOh4QZH2XLXuHOMA=
X-Google-Smtp-Source: AA6agR513GFNLrNtnak6BBh7LleFnRKiy4G9r5eAol2IPUpDDfzN69PVqe0+RboA402aCtcOHLNTWw==
X-Received: by 2002:aa7:cb06:0:b0:446:7668:2969 with SMTP id s6-20020aa7cb06000000b0044676682969mr20961223edt.206.1661877749121;
        Tue, 30 Aug 2022 09:42:29 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id fh10-20020a1709073a8a00b007307d099ed7sm5958959ejc.121.2022.08.30.09.42.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Aug 2022 09:42:28 -0700 (PDT)
Date:   Tue, 30 Aug 2022 19:42:26 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Mattias Forsblad <mattias.forsblad@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next v2 2/3] dsa: mv88e6xxx: Add support for RMU in
 select switches
Message-ID: <20220830164226.ohmn6bkwagz6n3pg@skbuf>
References: <20220826063816.948397-1-mattias.forsblad@gmail.com>
 <20220826063816.948397-3-mattias.forsblad@gmail.com>
 <20220830163515.3d2lzzc55vmko325@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220830163515.3d2lzzc55vmko325@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 30, 2022 at 07:35:15PM +0300, Vladimir Oltean wrote:
> > +void mv88e6xxx_rmu_master_change(struct dsa_switch *ds, const struct net_device *master,
> > +				 bool operational)
> > +{
> > +	struct mv88e6xxx_chip *chip = ds->priv;
> > +
> > +	if (operational)
> > +		chip->rmu.ops = &mv88e6xxx_bus_ops;
> > +	else
> > +		chip->rmu.ops = NULL;
> > +}
> 
> There is a subtle but very important point to be careful about here,
> which is compatibility with multiple CPU ports. If there is a second DSA
> master whose state flaps from up to down, this should not affect the
> fact that you can still use RMU over the first DSA master. But in your
> case it does, so this is a case of how not to write code that accounts
> for that.
> 
> In fact, given this fact, I think your function prototypes for
> chip->info->ops->rmu_enable() are all wrong / not sufficiently
> reflective of what the hardware can do. If the hardware has a bit mask
> of ports on which RMU operations are possible, why hardcode using
> dsa_switch_upstream_port() and not look at which DSA masters/CPU ports
> are actually up? At least for the top-most switch. For downstream
> switches we can use dsa_switch_upstream_port(), I guess (even that can
> be refined, but I'm not aware of setups using multiple DSA links, where
> each DSA link ultimately goes to a different upstream switch).

Hit "send" too soon. Wanted to give the extra hint that the "master"
pointer is given to you here for a reason. You can look at struct
dsa_port *cpu_dp = master->dsa_ptr, and figure out the index of the CPU
port which can be used for RMU operations. I see that the macros are
constructed in a very strange way:

#define MV88E6352_G1_CTL2_RMU_MODE_DISABLED	0x0000
#define MV88E6352_G1_CTL2_RMU_MODE_PORT_4	0x1000
#define MV88E6352_G1_CTL2_RMU_MODE_PORT_5	0x2000
#define MV88E6352_G1_CTL2_RMU_MODE_PORT_6	0x3000

it's as if this is actually a bit mask of ports, and they all can be
combined together. The bit in G1_CTL2 whose state we can flip can be
made to depend on the number of the CPU port attached to the DSA master
which changed state.
