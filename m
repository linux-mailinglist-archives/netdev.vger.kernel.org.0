Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B5064DCA20
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 16:37:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235824AbiCQPhr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 11:37:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234018AbiCQPhq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 11:37:46 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3603020A955;
        Thu, 17 Mar 2022 08:36:29 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id yy13so11574329ejb.2;
        Thu, 17 Mar 2022 08:36:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=TVn5dRq4Q2f2mDB25LghomZuVFKBVotFIBV9iK80cMY=;
        b=g8bOl2TeTGUk2xJWTqymUR4Iy78hgvu3Od0Vte65QgxzOzCqWoTx+oxtxqoILuxUuG
         N1I4MYcFIh5+JJHLpCIYlJpYQe9E1CXAQc400cY70WvVMX2ltU35JH+PWboJRfCk/vOU
         555qV0STdAaX04ujNEsdizS7yYjNXOftAJ9uzu+1awFPftTOX4d6QFMy7znFwSav1FwC
         85z8GhR3JJxttcmifL7BPtFsyOzoSfrZG1wLPC4n5y/TI6R2mYJhEkTyDxlsYvBDlW6c
         1CKxEuXC5crBqrOJav9hTjoNsJReAVrL0bpC4/oYB4hZp7CLvRy09pFwIYG/hj7pyUhd
         wXMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TVn5dRq4Q2f2mDB25LghomZuVFKBVotFIBV9iK80cMY=;
        b=6RHYzt/3T6VP+nmOuvdQslQkRhpi7KE6jXn5vFPfmShYTKVAW+2m1XnMnJ+ovTgzuF
         f5teY5pCIgos20z7dHACQB1KyGz0f4jEY70rdt0XHAzxEgDqug799yiwsQplLsHLwn5x
         2CRVvSLNCfrXJ5GO2Y17vhlGre10o2c2qheqCIfjsOKZdP8POegDmc82W0AQPW8iDwzK
         1lBPQ8yvtYs3QLPa9Xcw5VGh1s7VRiT/pPnQFz6dXrXBQWXQl11MADIMGLDRNZ4fd2zb
         f8pkdB2Q4WuEQy1lU4q0pdOTo1SiX9K6jd8Wy5l9x6xanYrGR0vnySJJmAFjGfaZNc2n
         57Bw==
X-Gm-Message-State: AOAM532qXzP6wIHdbNRm89lOYsomKo94BjkYYbdrU9L1lQY/GBD/2uKH
        grOXt/UF15T1C7pp10U/LkU=
X-Google-Smtp-Source: ABdhPJz2Et99ZeBW2NDUki3je6YA4m4DGJwln6jslvIbG+6DKyz3FSjVNWRUaRvC5soY47CBS4QseA==
X-Received: by 2002:a17:907:9706:b0:6db:566a:4408 with SMTP id jg6-20020a170907970600b006db566a4408mr5005975ejc.374.1647531387471;
        Thu, 17 Mar 2022 08:36:27 -0700 (PDT)
Received: from skbuf ([188.26.57.45])
        by smtp.gmail.com with ESMTPSA id t7-20020a1709063e4700b006da6357b1c0sm2521561eji.196.2022.03.17.08.36.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Mar 2022 08:36:26 -0700 (PDT)
Date:   Thu, 17 Mar 2022 17:36:25 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Hans Schultz <schultz.hans@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ido Schimmel <idosch@nvidia.com>, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org
Subject: Re: [PATCH net-next 3/3] net: dsa: mv88e6xxx: mac-auth/MAB
 implementation
Message-ID: <20220317153625.2ld5zgtuhoxbcgvo@skbuf>
References: <20220310142320.611738-1-schultz.hans+netdev@gmail.com>
 <20220310142320.611738-4-schultz.hans+netdev@gmail.com>
 <20220310142836.m5onuelv4jej5gvs@skbuf>
 <86r17495gk.fsf@gmail.com>
 <20220316233447.kwyirxckgancdqmh@skbuf>
 <86lex9hsg0.fsf@gmail.com>
 <YjNDgnrYaYfviNTi@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YjNDgnrYaYfviNTi@lunn.ch>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 17, 2022 at 03:19:46PM +0100, Andrew Lunn wrote:
> On Thu, Mar 17, 2022 at 09:52:15AM +0100, Hans Schultz wrote:
> > On tor, mar 17, 2022 at 01:34, Vladimir Oltean <olteanv@gmail.com> wrote:
> > > On Mon, Mar 14, 2022 at 11:46:51AM +0100, Hans Schultz wrote:
> > >> >> @@ -396,6 +414,13 @@ static irqreturn_t mv88e6xxx_g1_atu_prob_irq_thread_fn(int irq, void *dev_id)
> > >> >>  				    "ATU miss violation for %pM portvec %x spid %d\n",
> > >> >>  				    entry.mac, entry.portvec, spid);
> > >> >>  		chip->ports[spid].atu_miss_violation++;
> > >> >> +		if (mv88e6xxx_port_is_locked(chip, chip->ports[spid].port))
> > >> >> +			err = mv88e6xxx_switchdev_handle_atu_miss_violation(chip,
> > >> >> +									    chip->ports[spid].port,
> > >> >> +									    &entry,
> > >> >> +									    fid);
> > >> >
> > >> > Do we want to suppress the ATU miss violation warnings if we're going to
> > >> > notify the bridge, or is it better to keep them for some reason?
> > >> > My logic is that they're part of normal operation, so suppressing makes
> > >> > sense.
> > >> >
> > >> 
> > >> I have been seeing many ATU member violations after the miss violation is
> > >> handled (using ping), and I think it could be considered to suppress the ATU member
> > >> violations interrupts by setting the IgnoreWrongData bit for the
> > >> port (sect 4.4.7). This would be something to do whenever a port is set in locked mode?
> > >
> > > So the first packet with a given MAC SA triggers an ATU miss violation
> > > interrupt.
> > >
> > > You program that MAC SA into the ATU with a destination port mask of all
> > > zeroes. This suppresses further ATU miss interrupts for this MAC SA, but
> > > now generates ATU member violations, because the MAC SA _is_ present in
> > > the ATU, but not towards the expected port (in fact, towards _no_ port).
> > >
> > > Especially if user space decides it doesn't want to authorize this MAC
> > > SA, it really becomes a problem because this is now a vector for denial
> > > of service, with every packet triggering an ATU member violation
> > > interrupt.
> > >
> > > So your suggestion is to set the IgnoreWrongData bit on locked ports,
> > > and this will suppress the actual member violation interrupts for
> > > traffic coming from these ports.
> > >
> > > So if the user decides to unplug a previously authorized printer from
> > > switch port 1 and move it to port 2, how is this handled? If there isn't
> > > a mechanism in place to delete the locked FDB entry when the printer
> > > goes away, then by setting IgnoreWrongData you're effectively also
> > > suppressing migration notifications.
> > 
> > I don't think such a scenario is so realistic, as changing port is not
> > just something done casually, besides port 2 then must also be a locked
> > port to have the same policy.
> 
> I think it is very realistic. It is also something which does not work
> is going to cause a lot of confusion. People will blame the printer,
> when in fact they should be blaming the switch. They will be rebooting
> the printer, when in fact, they need to reboot the switch etc.
> 
> I expect there is a way to cleanly support this, you just need to
> figure it out.

Hans, why must port 2 also be a locked port? The FDB entry with no
destinations is present in the ATU, and static, why would just locked
ports match it?

> > The other aspect is that the user space daemon that authorizes catches
> > the fdb add entry events and checks if it is a locked entry. So it will
> > be up to said daemon to decide the policy, like remove the fdb entry
> > after a timeout.

When you say 'timeout', what is the moment when the timer starts counting?
The last reception of the user space daemon of a packet with this MAC SA,
or the moment when the FDB entry originally became unlocked?

I expect that once a device is authorized, and forwarding towards the
devices that it wants to talk to is handled in hardware, that the CPU no
longer receives packets from this device. In other words, are you saying
that you're going to break networking for the printer every 5 minutes,
as a keepalive measure?

I still think there should be a functional fast path for authorized
station migrations.

> > > Oh, btw, my question was: could you consider suppressing the _prints_ on
> > > an ATU miss violation on a locked port?
> > 
> > As there will only be such on the first packet, I think it should be
> > logged and those prints serve that purpose, so I think it is best to
> > keep the print.
> > If in the future some tests or other can argue for suppressing the
> > prints, it is an easy thing to do.
> 
> Please use a traffic generator and try to DOS one of your own
> switches. Can you?
> 
> 	  Andrew
