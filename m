Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29B035684F6
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 12:14:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232077AbiGFKMT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 06:12:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232019AbiGFKMR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 06:12:17 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66BAF15A19;
        Wed,  6 Jul 2022 03:12:14 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id c131-20020a1c3589000000b003a19b2bce36so5711623wma.4;
        Wed, 06 Jul 2022 03:12:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8vzw6bFniL24T6OECphPlNcFeN72oaM117VUsHYULlE=;
        b=Thg92U1EPycx9LB0a//LM9U+OMX34Fsr0FAVhF1xY91kKLYsTWAqz9dUlN0CXw3cSP
         J+j87wOTOcH4DzPMD36ypemV/7VtYu029uIRCv8crksOEAT12ZTSRVvJuh/rwNBh94Vk
         maXP4DaacK5HX+wYS+L1H0FWCnzIDfKBzMbIk14zZV5wNHLm9UOc7fLv2WcX8pANnnn9
         HgG9irCgP6JELmnIt3mw1BWBbXOFSwHXUt9IGgO4P+vVuOYEmIwd3vcuVwOz9PsHrvUJ
         Gp7QjAxA8Ubnvn39P1nsHQQjXv8MMRPt6H21f3SFZ5m4fCByeLThxwYTh7coZ5HK5TQx
         kQUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8vzw6bFniL24T6OECphPlNcFeN72oaM117VUsHYULlE=;
        b=abq85OLQcButquyx1iva4enh9qTsDM/HP4op5jdFnj41TkGqs++TB4DP3wODS40ld6
         IL4nnt/Z6FCQIiXKp9nrANSWj/4/c8k2CDcvgrdE3pkFJrKwMXqjLe/jvTKTNLfPDpfy
         daNwofhPaplWvKcURAmyCZ6qOOdVPqUMQB/EP1UC9jM5dwgTueqSvlAwK4uWjCkj/BW7
         Gu+JvrgjxT9KkClouSv6n809uFTf2eXYaz1s4UrlrmAMbea4OGb96htN/qgzNUenMipG
         70hm3gDGfJbiVEminCN7RJrgHhnHBo6j8SEyPKf6+kE9g8ok49N7jdcMAfMCA24LPMDE
         puMg==
X-Gm-Message-State: AJIora8cdIBqJtrbCyFzhmkWuQnmDWcZJJtZY+bvokfaXBvuxi3iGn+e
        SZ7e0uADUsj02ZcsT+zqknzbw3H9ClqQc2+zXAE=
X-Google-Smtp-Source: AGRyM1sCzHST+YhMi5w2+9hHPYiwsrrf6MeFPLaxUs7QmKI7OpMUhP9KCuJGluc5CQjY+3D6X+bEQ1JXW1gQE+tA3s8=
X-Received: by 2002:a05:600c:6004:b0:3a0:41db:aae with SMTP id
 az4-20020a05600c600400b003a041db0aaemr42613766wmb.171.1657102332798; Wed, 06
 Jul 2022 03:12:12 -0700 (PDT)
MIME-Version: 1.0
References: <20220524152144.40527-1-schultz.hans+netdev@gmail.com>
 <20220524152144.40527-4-schultz.hans+netdev@gmail.com> <20220627180557.xnxud7d6ol22lexb@skbuf>
 <CAKUejP7ugMB9d3MVX3m9Brw12_ocFoT+nuJJucYdQH70kzC7=w@mail.gmail.com> <20220706085559.oyvzijcikivemfkg@skbuf>
In-Reply-To: <20220706085559.oyvzijcikivemfkg@skbuf>
From:   Hans S <schultz.hans@gmail.com>
Date:   Wed, 6 Jul 2022 12:12:01 +0200
Message-ID: <CAKUejP7gmULyrjqd3b3PiWwi7TJzF4HNuEbmAf25Cqh3w7a1mw@mail.gmail.com>
Subject: Re: [PATCH V3 net-next 3/4] net: dsa: mv88e6xxx: mac-auth/MAB implementation
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Hans Schultz <schultz.hans+netdev@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ido Schimmel <idosch@nvidia.com>, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 6, 2022 at 10:56 AM Vladimir Oltean <olteanv@gmail.com> wrote:
>
> On Tue, Jun 28, 2022 at 02:26:43PM +0200, Hans S wrote:
> > > Dumb question: if you only flush the locked entries at fast age if the
> > > port is locked, then what happens with the existing locked entries if
> > > the port becomes unlocked before an FDB flush takes place?
> > > Shouldn't mv88e6xxx_port_set_lock() call mv88e6xxx_atu_locked_entry_flush()
> > > too?

BTW:
>> @@ -919,6 +920,9 @@ static void mv88e6xxx_mac_link_down(struct dsa_switch *ds, int port,
>>       if (err)
>>               dev_err(chip->dev,
>>                       "p%d: failed to force MAC link down\n", port);
>> +     else
>> +             if (mv88e6xxx_port_is_locked(chip, port, true))
>> +                     mv88e6xxx_atu_locked_entry_flush(ds, port);
>
>This is superfluous, is it not? The bridge will transition a port whose
>link goes down to BR_STATE_DISABLED, which will make dsa_port_set_state()
>fast-age the dynamic FDB entries on the port, which you've already
>handled below.

I removed this code, but then on link down the locked entries were not
cleared out. Something not as thought?

> >
> > That was my first thought too, but the way the flags are handled with the mask etc, does so that
> > mv88e6xxx_port_set_lock() is called when other flags change. It could be done by the transition
> > from locked->unlocked by checking if the port is locked already.
>
> Why does mv88e6xxx_port_set_lock() get called when other flags change?

That is what seems to happen, but maybe I am wrong. Looking at the dsa
functions dsa_port_inherit_brport_flags() and
dsa_port_clear_brport_flags(), they set the mask for which underlying
function is called, and it looks to me that they call once for all the
flags: BR_LEARNING, BR_FLOOD, BR_MCAST_FLOOD, BR_BCAST_FLOOD,
BR_PORT_LOCKED?

>
> > On the other hand, the timers will timeout and the entries will be removed anyhow.
>
> > > > +static void mv88e6xxx_atu_locked_entry_timer_work(struct atu_locked_entry *ale)
> > >
> > > Please find a more adequate name for this function.
> >
> > Any suggestions?
>
> Not sure. It depends on whether you leave just the logic to delete a
> locked ATU entry, or also the switchdev FDB_DEL_TO_BRIDGE notifier.
> In any case, pick a name that reflects what it does. Something with
> locked_entry_delete() can't be too wrong.
>
> > > From the discussion with Ido and Nikolay I get the impression that
> > > you're not doing the right thing here either, notifying a
> > > SWITCHDEV_FDB_DEL_TO_BRIDGE from what is effectively the
> > > SWITCHDEV_FDB_DEL_TO_DEVICE handler (port_fdb_del).
> >
> > Hmm, my experience tells me that much is opposite the normal
> > conventions when dealing with
> > locked ports, as there was never switchdev notifications from the
> > driver to the bridge before, but
> > that is needed to keep ATU and FDB entries in sync.
>
> On delete you mean? So the bridge signals switchdev a deletion of a
> locked FDB entry (as I pointed out, this function gets indirectly called
> from port_fdb_del), but it won't get deleted until switchdev signals it
> back, is what you're saying?
>

When added they are added with bridge FDB flags: extern_learn offload
locked, with a SWITCHDEV_FDB_ADD_TO_BRIDGE event. So they are owned by
the driver.
When the driver deletes the locked entry the bridge FDB entry is
removes by the SWITCHDEV_FDB_DEL_TO_BRIDGE event from the driver. That
seems quite fair?

> > > Why is the rtnl_unlock() outside the switch statement but the rtnl_lock() inside?
> > > Not to mention, the dsa_port_to_bridge_port() call needs to be under rtnl_lock().
> >
> > Just a small optimization as I also have another case of the switch
> > (only one switch case if
> > you didn't notice) belonging to the next patch set regarding dynamic
> > ATU entries.
>
> What kind of optimization are you even talking about? Please get rid of
> coding patterns like this, sorry.
>
Right!

> > > Please, no "if (chiplock) mutex_lock()" hacks. Just lockdep_assert_held(&chip->reg_lock),
> > > which serves both for documentation and for validation purposes, ensure
> > > the lock is always taken at the caller (which in this case is super easy)
> > > and move on.
> >
> > As I am calling the function in if statement checks, it would make
> > that code more messy, while with
> > this approach the function can be called from anywhere. I also looked
> > at having two functions, with
> > one being a wrapper function taking the lock and calling the other...
>
> There are many functions in mv88e6xxx that require the reg_lock to be
> held, there's nothing new or special here.
>

Now I take the lock in the function regardless. No boolean.

> > >
> > > > +
> > > > +     if (mv88e6xxx_port_read(chip, port, MV88E6XXX_PORT_CTL0, &reg))
> > > > +             goto out;
> > >
> > > It would be good to actually propagate the error to the caller and
> > > "locked" via a pass-by-reference bool pointer argument, not just say
> > > that I/O errors mean that the port is unlocked.
> >
> > Again the wish to be able to call it from if statement checks,.
> >
> > > > +     reg &= MV88E6XXX_PORT_ASSOC_VECTOR_PAV_MASK;
> > > > +     if (locked) {
> > > > +             reg |= MV88E6XXX_PORT_ASSOC_VECTOR_IGNORE_WRONG |
> > > > +                     MV88E6XXX_PORT_ASSOC_VECTOR_LOCKED_PORT |
> > > > +                     MV88E6XXX_PORT_ASSOC_VECTOR_INT_AGE_OUT |
> > > > +                     MV88E6XXX_PORT_ASSOC_VECTOR_HOLD_AT_1;
> > >
> > > I'd suggest aligning these macros vertically.
> >
> > They are according to the Linux kernel coding standard wrt indentation afaik.
>
> Compare:
>
>                 reg |= MV88E6XXX_PORT_ASSOC_VECTOR_IGNORE_WRONG |
>                         MV88E6XXX_PORT_ASSOC_VECTOR_LOCKED_PORT |
>                         MV88E6XXX_PORT_ASSOC_VECTOR_INT_AGE_OUT |
>                         MV88E6XXX_PORT_ASSOC_VECTOR_HOLD_AT_1;
>
> with:
>
>                 reg |= MV88E6XXX_PORT_ASSOC_VECTOR_IGNORE_WRONG |
>                        MV88E6XXX_PORT_ASSOC_VECTOR_LOCKED_PORT |
>                        MV88E6XXX_PORT_ASSOC_VECTOR_INT_AGE_OUT |
>                        MV88E6XXX_PORT_ASSOC_VECTOR_HOLD_AT_1;

I cannot see the difference here...?

Another issue...

I have removed the timers as they are superfluous and now just use the
worker and jiffies. But I have found that the whole ageing time seems
to be broken on the 5.17 kernel I am running. I don't know if it has
been fixed, but the ageing timeout is supposed to be given in seconds.
Here is the output from various functions after the command "ip link
set dev br0 type bridge ageing_time 1500" (that is nominally 1500
seconds according to man page!):

dsa_switch_ageing_time: ageing_time 10000, ageing_time_min 1000,
ageing_time_max 3825000
mv88e6xxx_set_ageing_time: set ageing time to 10000
br0: failed (err=-34) to set attribute (id=6)
dsa_switch_ageing_time: ageing_time 15000, ageing_time_min 1000,
ageing_time_max 3825000
mv88e6xxx_set_ageing_time: set ageing time to 15000

The 15000 set corresponds to 150 seconds! (I hardcoded the dsa
ageing_time_min to 1000)
