Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67C094DCBE8
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 17:58:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236721AbiCQRAA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 13:00:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236738AbiCQQ76 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 12:59:58 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFD557DE09;
        Thu, 17 Mar 2022 09:58:37 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id b28so10054871lfc.4;
        Thu, 17 Mar 2022 09:58:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=7RjURph1ulhWbgSxbLltAc1F3xHz1q5y5PeCWCvajco=;
        b=cbEAAnej0o9xlpSdtxKRVZhY7GC6oaM1nv1v9twreZqw6lrPBziaqNeBb2e1Utf9GS
         u5ZBKctfZ6QBBZb/gQ6Zmg7e/Lcfq2vRuuW0lX4bC+yuv77r0LpdODSBr50JWir+iik8
         OYAq1jK57FPIDWyTApnM3r0ior3f7XqxdSMAVz0PyTrv1Bo+8rLu8k4x6SubSZNwpwss
         RxJxbAs1dz8UP8tR92DhA4oh08nty57zjVm3kuu8yrUi/O+U0ZRMD/nG6H9OR943NwCU
         6hiBBLV//0VxzQgw3RWnR3BHtXFzMdO5ETdfweROJLPKN2qTQjP6Wo5q4LcNyb0BMpmm
         J1qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=7RjURph1ulhWbgSxbLltAc1F3xHz1q5y5PeCWCvajco=;
        b=R4TDwbHA9j9hrJ3rNEVlI48wris8nsYjhQtVUV7Q2sMxV0bt1ksO6WKmwowYMu0TUY
         9Sh4JcFhv/oPWQ6hfTABRmvGyxRVjfH/u2vn2VMD5eYFgsc09ydT6wdFXEMY8X7pea3g
         qlDXt7CAhPqJAQwdi//2agjfUaRIclE/DaASQ/O9iezUbDUzhZm3Z9MV/Z1MGXfhAIub
         8T5tiVpKWZYMGz8fB9SZrwZtXtcbw9Ifr/X2qhB2Al0hGuoq0wDxRi55DiwHB9Hy6LiR
         wUIP+BlL67KQiKG03VN7i4/s3rJ0Aw9af/bqEEGN6x6BPFlHZtt7baDM3bTN1nHm7Oo/
         hSwg==
X-Gm-Message-State: AOAM531vSIJon+Uel7095VWrb/4DemVwQSofCzsRBB0/ANb9sA7B/pCk
        zgIThU7bD1xd1usoqJm2QDg=
X-Google-Smtp-Source: ABdhPJyKrUREvMZTEAjZc2Ua7Whpe4wV/DLxSKhf8JOStOUH/yu5GlY/GxpA3MtpkBCN8t3bhJrogw==
X-Received: by 2002:a05:6512:96e:b0:448:4bd7:fff7 with SMTP id v14-20020a056512096e00b004484bd7fff7mr3490483lft.605.1647536315655;
        Thu, 17 Mar 2022 09:58:35 -0700 (PDT)
Received: from wse-c0127 ([208.127.141.29])
        by smtp.gmail.com with ESMTPSA id d6-20020a056512320600b00448bb4da3a2sm426276lfe.10.2022.03.17.09.58.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Mar 2022 09:58:35 -0700 (PDT)
From:   Hans Schultz <schultz.hans@gmail.com>
X-Google-Original-From: Hans Schultz <schultz.hans+netdev@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>,
        Hans Schultz <schultz.hans@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>,
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
In-Reply-To: <20220317161808.psftauoz5iaecduy@skbuf>
References: <20220310142320.611738-1-schultz.hans+netdev@gmail.com>
 <20220310142320.611738-4-schultz.hans+netdev@gmail.com>
 <20220310142836.m5onuelv4jej5gvs@skbuf> <86r17495gk.fsf@gmail.com>
 <20220316233447.kwyirxckgancdqmh@skbuf> <86lex9hsg0.fsf@gmail.com>
 <YjNDgnrYaYfviNTi@lunn.ch> <20220317153625.2ld5zgtuhoxbcgvo@skbuf>
 <86ilscr2a4.fsf@gmail.com> <20220317161808.psftauoz5iaecduy@skbuf>
Date:   Thu, 17 Mar 2022 17:58:26 +0100
Message-ID: <8635jg5xe5.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On tor, mar 17, 2022 at 18:18, Vladimir Oltean <olteanv@gmail.com> wrote:
> On Thu, Mar 17, 2022 at 05:07:15PM +0100, Hans Schultz wrote:
>> On tor, mar 17, 2022 at 17:36, Vladimir Oltean <olteanv@gmail.com> wrote:
>> > On Thu, Mar 17, 2022 at 03:19:46PM +0100, Andrew Lunn wrote:
>> >> On Thu, Mar 17, 2022 at 09:52:15AM +0100, Hans Schultz wrote:
>> >> > On tor, mar 17, 2022 at 01:34, Vladimir Oltean <olteanv@gmail.com> wrote:
>> >> > > On Mon, Mar 14, 2022 at 11:46:51AM +0100, Hans Schultz wrote:
>> >> > >> >> @@ -396,6 +414,13 @@ static irqreturn_t mv88e6xxx_g1_atu_prob_irq_thread_fn(int irq, void *dev_id)
>> >> > >> >>  				    "ATU miss violation for %pM portvec %x spid %d\n",
>> >> > >> >>  				    entry.mac, entry.portvec, spid);
>> >> > >> >>  		chip->ports[spid].atu_miss_violation++;
>> >> > >> >> +		if (mv88e6xxx_port_is_locked(chip, chip->ports[spid].port))
>> >> > >> >> +			err = mv88e6xxx_switchdev_handle_atu_miss_violation(chip,
>> >> > >> >> +									    chip->ports[spid].port,
>> >> > >> >> +									    &entry,
>> >> > >> >> +									    fid);
>> >> > >> >
>> >> > >> > Do we want to suppress the ATU miss violation warnings if we're going to
>> >> > >> > notify the bridge, or is it better to keep them for some reason?
>> >> > >> > My logic is that they're part of normal operation, so suppressing makes
>> >> > >> > sense.
>> >> > >> >
>> >> > >> 
>> >> > >> I have been seeing many ATU member violations after the miss violation is
>> >> > >> handled (using ping), and I think it could be considered to suppress the ATU member
>> >> > >> violations interrupts by setting the IgnoreWrongData bit for the
>> >> > >> port (sect 4.4.7). This would be something to do whenever a port is set in locked mode?
>> >> > >
>> >> > > So the first packet with a given MAC SA triggers an ATU miss violation
>> >> > > interrupt.
>> >> > >
>> >> > > You program that MAC SA into the ATU with a destination port mask of all
>> >> > > zeroes. This suppresses further ATU miss interrupts for this MAC SA, but
>> >> > > now generates ATU member violations, because the MAC SA _is_ present in
>> >> > > the ATU, but not towards the expected port (in fact, towards _no_ port).
>> >> > >
>> >> > > Especially if user space decides it doesn't want to authorize this MAC
>> >> > > SA, it really becomes a problem because this is now a vector for denial
>> >> > > of service, with every packet triggering an ATU member violation
>> >> > > interrupt.
>> >> > >
>> >> > > So your suggestion is to set the IgnoreWrongData bit on locked ports,
>> >> > > and this will suppress the actual member violation interrupts for
>> >> > > traffic coming from these ports.
>> >> > >
>> >> > > So if the user decides to unplug a previously authorized printer from
>> >> > > switch port 1 and move it to port 2, how is this handled? If there isn't
>> >> > > a mechanism in place to delete the locked FDB entry when the printer
>> >> > > goes away, then by setting IgnoreWrongData you're effectively also
>> >> > > suppressing migration notifications.
>> >> > 
>> >> > I don't think such a scenario is so realistic, as changing port is not
>> >> > just something done casually, besides port 2 then must also be a locked
>> >> > port to have the same policy.
>> >> 
>> >> I think it is very realistic. It is also something which does not work
>> >> is going to cause a lot of confusion. People will blame the printer,
>> >> when in fact they should be blaming the switch. They will be rebooting
>> >> the printer, when in fact, they need to reboot the switch etc.
>> >> 
>> >> I expect there is a way to cleanly support this, you just need to
>> >> figure it out.
>> >
>> > Hans, why must port 2 also be a locked port? The FDB entry with no
>> > destinations is present in the ATU, and static, why would just locked
>> > ports match it?
>> >
>> You are right of course, but it was more from a policy standpoint as I
>> pointed out. If the FDB entry is removed after some timeout and the
>> device in the meantime somehow is on another port that is not locked
>> with full access, the device will of course get full access.
>> But since it was not given access in the first instance, the policy is
>> not consistent.
>> 
>> >> > The other aspect is that the user space daemon that authorizes catches
>> >> > the fdb add entry events and checks if it is a locked entry. So it will
>> >> > be up to said daemon to decide the policy, like remove the fdb entry
>> >> > after a timeout.
>> >
>> > When you say 'timeout', what is the moment when the timer starts counting?
>> > The last reception of the user space daemon of a packet with this MAC SA,
>> > or the moment when the FDB entry originally became unlocked?
>> 
>> I think that if the device is not given access, a timer should be
>> started at that moment. No further FDB add events with the same MAC
>> address will come of course until the FDB entry is removed, which I
>> think would be done based on the said timer.
>> >
>> > I expect that once a device is authorized, and forwarding towards the
>> > devices that it wants to talk to is handled in hardware, that the CPU no
>> > longer receives packets from this device. In other words, are you saying
>> > that you're going to break networking for the printer every 5 minutes,
>> > as a keepalive measure?
>> 
>> No, I don't think that would be a good idea, but as we are in userspace,
>> that is a policy decision of those creating the daemon. The kernel just
>> facilitates, it does not make those decisions as far as I think.
>> >
>> > I still think there should be a functional fast path for authorized
>> > station migrations.
>> >
>> I am not sure in what way you are suggesting that should be, if the
>> kernel should actively do something there? If a station is authorized,
>> and somehow is transferred to another port, if that port is not locked it
>> will get access, if the port is locked a miss violation will occur etc...
>
> Wait, if the new port is locked and the device was previously
> authorized, why will the new port trigger a miss violation? This is the
> part I'm not following. The authorization is still present in the form
> of an ATU entry on the old locked port, is it not?
>
I am sure (have not tested) that a miss violation will occur. It might
be a member violation in this instance though.
When thinking of it, afaik there is no way today of having fine control
over the DPV when adding a FDB entry.
If the DPV could be finer controlled the entry could cover several
possible ports and the fast (immediate migration) will be accomplished?

>> >> > > Oh, btw, my question was: could you consider suppressing the _prints_ on
>> >> > > an ATU miss violation on a locked port?
>> >> > 
>> >> > As there will only be such on the first packet, I think it should be
>> >> > logged and those prints serve that purpose, so I think it is best to
>> >> > keep the print.
>> >> > If in the future some tests or other can argue for suppressing the
>> >> > prints, it is an easy thing to do.
>> >> 
>> >> Please use a traffic generator and try to DOS one of your own
>> >> switches. Can you?
>> >> 
>> >> 	  Andrew
