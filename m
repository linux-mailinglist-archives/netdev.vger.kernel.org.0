Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD7B84DD79C
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 11:04:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234816AbiCRKGB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 06:06:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234079AbiCRKGA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 06:06:00 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DD581B48F2;
        Fri, 18 Mar 2022 03:04:41 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id p14so1988568lfe.4;
        Fri, 18 Mar 2022 03:04:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=YU03jiBAcerQT0l4E2lmllhgXvcv8P1ss+XUJlDusDI=;
        b=izmDWdGzXzppKXHiL+xFEUedRKHGbqSz2a6SbWD6N9OqdYTuUYxkKco7caJRqlLZOg
         x80diqejq0IIheAAmnZUU/Yt5hqhKX4AsWgKdWjY3uH7EN5OPseR6IFK9fRaojAE6vDj
         hFyih9fwtWICFyRrEEfMh3D9jQQP/AEj2M6CP4bIqwjhUB8TnRj8hy1urGyZhfcP4MYo
         gTh6iAoUOh5RZaQxf14FMcpICeXN44HJNu4ioJEuzFLlfk/wUFp7w1Fk3mZF4reOy2Iu
         cHppfhsKEWtOo3LqWZQcC8tt2JOFkGXi2gmim7nqsygDOkuAenAnUPlbjCGbW660/+8j
         8HXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=YU03jiBAcerQT0l4E2lmllhgXvcv8P1ss+XUJlDusDI=;
        b=DBXww9/n/sawV3RpB3d4pRNNg1uB7jZxU5JtK0EGYvh2pWQoOPsamQ/KZ9O1VUH4bk
         uWoiUjRU9h2msCbdICYcd6W+PadS4+9z6QIfKxD9CEX09YadhUiQauuHILOL08XFBTaX
         kIaoMrRBgmp/V7VK9G8l88olXzbmxsmvMgwGR501xdF5nvd/SJ5Si/Pyr0vyg8SXFHzd
         +brVcfrIrg++tS/wbCOO064iGG2fIQfev6rFH3B4XQ0MSaEjeSTqYfbVHb14Vmik8How
         dY5qVo+KatAp3AqNUVRQhyZEa/IucTl20X189/uvfHWLGWdlHw8Ji5oG8FiN8gncdXRb
         GTpA==
X-Gm-Message-State: AOAM531qdTb07+kvgjxOUwWpaDNMFPFETx13j8YlqvWRxjzpXBL4lOUK
        JLfbYZDNvB1BraHn0Ysw5sM=
X-Google-Smtp-Source: ABdhPJyboY22igQqAMEoaRYyt6YDL1pxHedfyStGzOXqAxRONXjSMug/d6tDqeONOZ881gN45btf+g==
X-Received: by 2002:a05:6512:1510:b0:445:cbc3:a51f with SMTP id bq16-20020a056512151000b00445cbc3a51fmr5721722lfb.116.1647597879601;
        Fri, 18 Mar 2022 03:04:39 -0700 (PDT)
Received: from wse-c0127 ([208.127.141.29])
        by smtp.gmail.com with ESMTPSA id 15-20020ac24d4f000000b0044839228149sm776419lfp.173.2022.03.18.03.04.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Mar 2022 03:04:39 -0700 (PDT)
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
In-Reply-To: <20220317172013.rhjvknre5w7mfmlo@skbuf>
References: <20220310142320.611738-4-schultz.hans+netdev@gmail.com>
 <20220310142836.m5onuelv4jej5gvs@skbuf> <86r17495gk.fsf@gmail.com>
 <20220316233447.kwyirxckgancdqmh@skbuf> <86lex9hsg0.fsf@gmail.com>
 <YjNDgnrYaYfviNTi@lunn.ch> <20220317153625.2ld5zgtuhoxbcgvo@skbuf>
 <86ilscr2a4.fsf@gmail.com> <20220317161808.psftauoz5iaecduy@skbuf>
 <8635jg5xe5.fsf@gmail.com> <20220317172013.rhjvknre5w7mfmlo@skbuf>
Date:   Fri, 18 Mar 2022 11:04:36 +0100
Message-ID: <86tubvk24r.fsf@gmail.com>
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

On tor, mar 17, 2022 at 19:20, Vladimir Oltean <olteanv@gmail.com> wrote:
> On Thu, Mar 17, 2022 at 05:58:26PM +0100, Hans Schultz wrote:
>> On tor, mar 17, 2022 at 18:18, Vladimir Oltean <olteanv@gmail.com> wrote:
>> > On Thu, Mar 17, 2022 at 05:07:15PM +0100, Hans Schultz wrote:
>> >> On tor, mar 17, 2022 at 17:36, Vladimir Oltean <olteanv@gmail.com> wrote:
>> >> > On Thu, Mar 17, 2022 at 03:19:46PM +0100, Andrew Lunn wrote:
>> >> >> On Thu, Mar 17, 2022 at 09:52:15AM +0100, Hans Schultz wrote:
>> >> >> > On tor, mar 17, 2022 at 01:34, Vladimir Oltean <olteanv@gmail.com> wrote:
>> >> >> > > On Mon, Mar 14, 2022 at 11:46:51AM +0100, Hans Schultz wrote:
>> >> >> > >> >> @@ -396,6 +414,13 @@ static irqreturn_t mv88e6xxx_g1_atu_prob_irq_thread_fn(int irq, void *dev_id)
>> >> >> > >> >>  				    "ATU miss violation for %pM portvec %x spid %d\n",
>> >> >> > >> >>  				    entry.mac, entry.portvec, spid);
>> >> >> > >> >>  		chip->ports[spid].atu_miss_violation++;
>> >> >> > >> >> +		if (mv88e6xxx_port_is_locked(chip, chip->ports[spid].port))
>> >> >> > >> >> +			err = mv88e6xxx_switchdev_handle_atu_miss_violation(chip,
>> >> >> > >> >> +									    chip->ports[spid].port,
>> >> >> > >> >> +									    &entry,
>> >> >> > >> >> +									    fid);
>> >> >> > >> >
>> >> >> > >> > Do we want to suppress the ATU miss violation warnings if we're going to
>> >> >> > >> > notify the bridge, or is it better to keep them for some reason?
>> >> >> > >> > My logic is that they're part of normal operation, so suppressing makes
>> >> >> > >> > sense.
>> >> >> > >> >
>> >> >> > >> 
>> >> >> > >> I have been seeing many ATU member violations after the miss violation is
>> >> >> > >> handled (using ping), and I think it could be considered to suppress the ATU member
>> >> >> > >> violations interrupts by setting the IgnoreWrongData bit for the
>> >> >> > >> port (sect 4.4.7). This would be something to do whenever a port is set in locked mode?
>> >> >> > >
>> >> >> > > So the first packet with a given MAC SA triggers an ATU miss violation
>> >> >> > > interrupt.
>> >> >> > >
>> >> >> > > You program that MAC SA into the ATU with a destination port mask of all
>> >> >> > > zeroes. This suppresses further ATU miss interrupts for this MAC SA, but
>> >> >> > > now generates ATU member violations, because the MAC SA _is_ present in
>> >> >> > > the ATU, but not towards the expected port (in fact, towards _no_ port).
>> >> >> > >
>> >> >> > > Especially if user space decides it doesn't want to authorize this MAC
>> >> >> > > SA, it really becomes a problem because this is now a vector for denial
>> >> >> > > of service, with every packet triggering an ATU member violation
>> >> >> > > interrupt.
>> >> >> > >
>> >> >> > > So your suggestion is to set the IgnoreWrongData bit on locked ports,
>> >> >> > > and this will suppress the actual member violation interrupts for
>> >> >> > > traffic coming from these ports.
>> >> >> > >
>> >> >> > > So if the user decides to unplug a previously authorized printer from
>> >> >> > > switch port 1 and move it to port 2, how is this handled? If there isn't
>> >> >> > > a mechanism in place to delete the locked FDB entry when the printer
>> >> >> > > goes away, then by setting IgnoreWrongData you're effectively also
>> >> >> > > suppressing migration notifications.
>> >> >> > 
>> >> >> > I don't think such a scenario is so realistic, as changing port is not
>> >> >> > just something done casually, besides port 2 then must also be a locked
>> >> >> > port to have the same policy.
>> >> >> 
>> >> >> I think it is very realistic. It is also something which does not work
>> >> >> is going to cause a lot of confusion. People will blame the printer,
>> >> >> when in fact they should be blaming the switch. They will be rebooting
>> >> >> the printer, when in fact, they need to reboot the switch etc.
>> >> >> 
>> >> >> I expect there is a way to cleanly support this, you just need to
>> >> >> figure it out.
>> >> >
>> >> > Hans, why must port 2 also be a locked port? The FDB entry with no
>> >> > destinations is present in the ATU, and static, why would just locked
>> >> > ports match it?
>> >> >
>> >> You are right of course, but it was more from a policy standpoint as I
>> >> pointed out. If the FDB entry is removed after some timeout and the
>> >> device in the meantime somehow is on another port that is not locked
>> >> with full access, the device will of course get full access.
>> >> But since it was not given access in the first instance, the policy is
>> >> not consistent.
>> >> 
>> >> >> > The other aspect is that the user space daemon that authorizes catches
>> >> >> > the fdb add entry events and checks if it is a locked entry. So it will
>> >> >> > be up to said daemon to decide the policy, like remove the fdb entry
>> >> >> > after a timeout.
>> >> >
>> >> > When you say 'timeout', what is the moment when the timer starts counting?
>> >> > The last reception of the user space daemon of a packet with this MAC SA,
>> >> > or the moment when the FDB entry originally became unlocked?
>> >> 
>> >> I think that if the device is not given access, a timer should be
>> >> started at that moment. No further FDB add events with the same MAC
>> >> address will come of course until the FDB entry is removed, which I
>> >> think would be done based on the said timer.
>> >> >
>> >> > I expect that once a device is authorized, and forwarding towards the
>> >> > devices that it wants to talk to is handled in hardware, that the CPU no
>> >> > longer receives packets from this device. In other words, are you saying
>> >> > that you're going to break networking for the printer every 5 minutes,
>> >> > as a keepalive measure?
>> >> 
>> >> No, I don't think that would be a good idea, but as we are in userspace,
>> >> that is a policy decision of those creating the daemon. The kernel just
>> >> facilitates, it does not make those decisions as far as I think.
>> >> >
>> >> > I still think there should be a functional fast path for authorized
>> >> > station migrations.
>> >> >
>> >> I am not sure in what way you are suggesting that should be, if the
>> >> kernel should actively do something there? If a station is authorized,
>> >> and somehow is transferred to another port, if that port is not locked it
>> >> will get access, if the port is locked a miss violation will occur etc...
>> >
>> > Wait, if the new port is locked and the device was previously
>> > authorized, why will the new port trigger a miss violation? This is the
>> > part I'm not following. The authorization is still present in the form
>> > of an ATU entry on the old locked port, is it not?
>> >
>> I am sure (have not tested) that a miss violation will occur. It might
>> be a member violation in this instance though.
>> When thinking of it, afaik there is no way today of having fine control
>> over the DPV when adding a FDB entry.
>> If the DPV could be finer controlled the entry could cover several
>> possible ports and the fast (immediate migration) will be accomplished?
>
> I'm not sure I understand this, either.
>
> You're saying we should configure the authorizations as de-facto
> multicast ATU entries towards all locked ports, so that there wouldn't
> be any violation when a station migrates, because the new port is still
> in the destination port mask of the ATU entry?
>
> Yes, but... this leaks traffic between ports to a significant degree.
> Any packet that targets your printer now targets your colleague's printer too.
>
> I was expecting you'd say that when the cable is unplugged from the
> switch, the authorization daemon is notified through rtnetlink of the
> link state change, and it flushes the port of addresses it has added
> (because the kernel surely does not do this).
>
So, my HW tests show that when the link is removed, the FDB entries
related to the port are flushed automatically.

> This could work to an extent, but it wouldn't handle the case where the
> printer isn't connected directly to the 802.1X port, but through
> another dumb switch. I don't know enough about 802.1X, but I don't see
> why this isn't a valid configuration.
>
ATM, the dynamic flag (bridge fdb add MAC dev DEV master dynamic)
doesn't create an ageing FDB entry in the offloaded case. Maybe if that
was solved, it would be a good enough solution, as for a noisy device,
it would lose some packets every 5 minutes, which higher layers should
be able to handle?

> To explain what I'm thinking of. At office, IT gave one Ethernet port to
> each desk, but I have multiple devices. I have a PC, a printer, and a
> development board, each with a single Ethernet port, so I use a dumb
> 4-port switch to connect all these devices to the 802.1X port beneath my
> desk. I talked to IT, brought my printer to them, they agreed to bypass
> 802.1X authorization for it based on the MAC address on its label.
>
> I've been working from home for the past few years, but now I need to
> return to office. But since years have passed, some colleagues left,
> some new colleagues came, and I need to change my desk. The new one
> belonged to a co-worker who also had a dumb switch on his desk, so I see
> no reason to move mine too. I unplug the printer from my dumb switch,
> plug it into the new one, but it doesn't work. What do I do, open a
> ticket to IT asking for halp?
>
> To be honest this is purely fictional and I haven't tried it, but it
> sounds like I should when I get the chance, to get a better image of how
> things are supposed to work.
>
>> >> >> > > Oh, btw, my question was: could you consider suppressing the _prints_ on
>> >> >> > > an ATU miss violation on a locked port?
>> >> >> > 
>> >> >> > As there will only be such on the first packet, I think it should be
>> >> >> > logged and those prints serve that purpose, so I think it is best to
>> >> >> > keep the print.
>> >> >> > If in the future some tests or other can argue for suppressing the
>> >> >> > prints, it is an easy thing to do.
>> >> >> 
>> >> >> Please use a traffic generator and try to DOS one of your own
>> >> >> switches. Can you?
>> >> >> 
>> >> >> 	  Andrew
