Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 632823F8217
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 07:33:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238901AbhHZFe0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 01:34:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229760AbhHZFeZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 01:34:25 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08397C061757
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 22:33:39 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id e129so3579503yba.5
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 22:33:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=c8aDok2+FeTHX5eV50dscMYUNTxEfy2hDZKEYWlW6Ww=;
        b=bXDR9ceaP51nIZobdU8qDgQ41RYdRbHaWlLqGxd2/CXcgntoCDdkTjXzDhuBm+NEdb
         Yd0MP/aqe9IPp87dSrj7FnMyON5zi5LgubcyNbOiGtAIN67/3OOh7fg/75ByXBu0nMag
         jalXRgvRup8ZCs9CrJe6rw2CwMU7uz7CJ8IfwQYGgtkluScU0lg8Eu0Pi+G7DMnq18MS
         9kol7frvDyCcL+7D5TL29ax2mvO3Z+i+4QIlct2tscBHF4n6E35iQOeAfZy32aZIwL9L
         RZ1o9IG744Qi018SB0AvMDsYnm8kqzHre201flAPpesXXa/lXEuGoSnzduEhSC3Q8FBT
         pS+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=c8aDok2+FeTHX5eV50dscMYUNTxEfy2hDZKEYWlW6Ww=;
        b=ZdNozETlLbveYqx7mwnDknk/RAeCRLM2iL8aAy6qsG3rzsRlmpIb5pth3NTy3VJ93o
         4S0sYcvjwoiaxQfAKp/qDoiIyCrHkWLfmqR4WqIQbCNn1nONOxcak7bGTIhMtkzE73C6
         qR7zKOEbaxGTuRyfVL3ThLA/Pvmys+QvSU3RlzfjdGoc2R7Umt5fNHB2WPerabOIo9YS
         zI6PNytgUI5GrzwZ4XIMfuSSWbgKo6wKeKsEmm+5NpqqHhgHaM+fgaGNaG9lDTyzEXpT
         HILd/HXh7qCYIciGLkcue3P+ovYOBwncCMHcZZEeeRqDnqPktYT8sPLPtgkkMmy/mrRa
         gu4w==
X-Gm-Message-State: AOAM533Jl7dUq0D6Kw9dariIeTQQfXkE7ptWm/KKEEY1nebf3vQHdjpm
        R8qZKNWc0fQ8+ng8kg5J7WHQol0CZdyoHhn26IdvkA==
X-Google-Smtp-Source: ABdhPJz2diJUkTbPipGuJpGDmyIeVVr1LhIxzu5VlOnUCIeez+b8t3H6sty93S5PYPC+l9HreQJDlQP1dG2vmlPa6po=
X-Received: by 2002:a25:81ce:: with SMTP id n14mr3136763ybm.32.1629956017711;
 Wed, 25 Aug 2021 22:33:37 -0700 (PDT)
MIME-Version: 1.0
References: <20210817145245.3555077-1-vladimir.oltean@nxp.com>
 <cd0d9c40-d07b-e2ab-b068-d0bcb4685d09@bang-olufsen.dk> <20210817223101.7wbdofi7xkeqa2cp@skbuf>
 <CAGETcx8T-ReJ_Gj-U+nxQyZPsv1v67DRBvpp9hS0fXgGRUQ17w@mail.gmail.com>
 <6b89a9e1-e92e-ca99-9fbd-1d98f6a7864b@bang-olufsen.dk> <CAGETcx_uj0V4DChME-gy5HGKTYnxLBX=TH2rag29f_p=UcG+Tg@mail.gmail.com>
 <875f7448-8402-0c93-2a90-e1d83bb7586a@bang-olufsen.dk> <CAGETcx_M5pEtpYhuc-Fx6HvC_9KzZnPMYUH_YjcBb4pmq8-ghA@mail.gmail.com>
 <CAGETcx_+=TmMq9hP=95xferAmyA1ZCT3sMRLVnzJ9Or9OnDsDA@mail.gmail.com>
 <14891624-655b-a71d-dc04-24404e0c2e1a@bang-olufsen.dk> <CAGETcx-7xgt5y_zNHzSMQf4YFCmWRPfP4_voshbNxKPgQ=b1tA@mail.gmail.com>
 <7e8a9f73-7b30-4bcb-0cf5-bd124e7a147e@bang-olufsen.dk>
In-Reply-To: <7e8a9f73-7b30-4bcb-0cf5-bd124e7a147e@bang-olufsen.dk>
From:   Saravana Kannan <saravanak@google.com>
Date:   Wed, 25 Aug 2021 22:33:01 -0700
Message-ID: <CAGETcx8_vxxPxF8WrXqk=PZYfEggsozP+z9KyOu5C2bEW0VW8g@mail.gmail.com>
Subject: Re: [PATCH net] net: dsa: sja1105: fix use-after-free after calling
 of_find_compatible_node, or worse
To:     =?UTF-8?Q?Alvin_=C5=A0ipraga?= <ALSI@bang-olufsen.dk>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Frank Rowand <frowand.list@gmail.com>,
        Rob Herring <robh+dt@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 25, 2021 at 6:40 AM Alvin =C5=A0ipraga <ALSI@bang-olufsen.dk> w=
rote:
>
> Hi Saravana,
>
> Sorry for the delayed response.
>
> On 8/23/21 8:50 PM, Saravana Kannan wrote:
> > On Sun, Aug 22, 2021 at 7:19 AM Alvin =C5=A0ipraga <ALSI@bang-olufsen.d=
k> wrote:
> >>
> >> Hi Saravana,
> >>
> >> Thanks for the follow-up. I tested your change and it does the trick:
> >> there is no deferral and the PHY driver gets probed first-try during t=
he
> >> mdiobus registration during the call to dsa_register_switch().
> >
> > I'm fairly certain the mdiobus registration happens before
> > dsa_register_switch(). It's in the probe call path of the DSA. The
> > connecting of the PHYs with the DSA is what happens when
> > dsa_register_switch() is called.
>
> Hm, are you sure about this? My understanding is that mdiobus
> registration happens as follows:
>
> dsa_register_switch()
>      -> ...
>          -> rtl836{6,5mb}_setup() # see [1] for RFC patch with rtl8365mb
>              -> realtek_smi_setup_mdio()
>                  -> of_mdiobus_register()

My bad, you are definitely right! Thanks for correcting my understanding.

> As it stands, dsa_register_switch() is currently called from
> realtek_smi_probe(). Your patch just moves this call to
> realtek_smi_sync_state(), but per the above, the mdiobus registration
> happens inside dsa_register_switch(), meaning it doesn't happen in the
> probe call path. Or am I missing something? I'm happy to be wrong :-)

Ok, my sync_state() hack is definitely not a solution anymore. It's
just a terrible hack.

>
> [1] https://lore.kernel.org/netdev/20210822193145.1312668-1-alvin@pqrs.dk=
/T/
>
> >
> >> I tested
> >> with the switch, PHY, and tagging drivers all builtin, or all modules,
> >> and it worked in both cases.
> >>
> >> On 8/20/21 6:52 PM, Saravana Kannan wrote:
> >>> Hi Alvin,
> >>>
> >>> Can you give this a shot to see if it fixes your issue? It basically
> >>> delays the registration of dsa_register_switch() until all the
> >>> consumers of this switch have probed. So it has a couple of caveats:
> >>
> >> Hm, weren't the only consumers the PHYs themselves? It seems like the
> >> main effect of your change is that - by doing the actual
> >> dsa_register_switch() call after the switch driver probe - the
> >> ethernet-switch (provider) is already probed, thereby allowing the PHY
> >> (consumer) to probe immediately.
> >
> > Correct-ish -- if you modify this to account for what I said above.
> >
> >>
> >>> 1. I'm hoping the PHYs are the only consumers of this switch.
> >>
> >> In my case that is true, if you count the mdio_bus as well:
> >>
> >> /sys/devices/platform/ethernet-switch# ls -l consumer\:*
> >> lrwxrwxrwx    1 root     root             0 Aug 22 16:00
> >> consumer:mdio_bus:SMI-0 ->
> >> ../../virtual/devlink/platform:ethernet-switch--mdio_bus:SMI-0
> >> lrwxrwxrwx    1 root     root             0 Aug 22 16:00
> >> consumer:mdio_bus:SMI-0:00 ->
> >> ../../virtual/devlink/platform:ethernet-switch--mdio_bus:SMI-0:00
> >> lrwxrwxrwx    1 root     root             0 Aug 22 16:00
> >> consumer:mdio_bus:SMI-0:01 ->
> >> ../../virtual/devlink/platform:ethernet-switch--mdio_bus:SMI-0:01
> >> lrwxrwxrwx    1 root     root             0 Aug 22 16:00
> >> consumer:mdio_bus:SMI-0:02 ->
> >> ../../virtual/devlink/platform:ethernet-switch--mdio_bus:SMI-0:02
> >> lrwxrwxrwx    1 root     root             0 Aug 22 16:00
> >> consumer:mdio_bus:SMI-0:03 ->
> >> ../../virtual/devlink/platform:ethernet-switch--mdio_bus:SMI-0:03
> >
> > Hmm... mdio_bus being a consumer should prevent the sync_state() from
> > being called on "ethernet-switch". What's the value of the "status"
> > and "sync_state_only" files inside that mdio_bus folder?
>
> Without your patch:
>
> /sys/devices/platform/ethernet-switch# ls -l consumer\:*
> lrwxrwxrwx    1 root     root             0 Aug 25 13:42
> consumer:mdio_bus:SMI-0 ->
> ../../virtual/devlink/platform:ethernet-switch--mdio_bus:SMI-0
> /sys/devices/platform/ethernet-switch# cat consumer\:*/status
> available
> /sys/devices/platform/ethernet-switch# cat consumer\:*/sync_state_only
> 1
>
>
> With your patch:
>
> 0.0.0.0@CA44-:/sys/devices/platform/ethernet-switch# ls -l consumer\:*
> lrwxrwxrwx    1 root     root             0 Aug 25 15:03
> consumer:mdio_bus:SMI-0 ->
> ../../virtual/devlink/platform:ethernet-switch--mdio_bus:SMI-0
> lrwxrwxrwx    1 root     root             0 Aug 25 15:03
> consumer:mdio_bus:SMI-0:00 ->
> ../../virtual/devlink/platform:ethernet-switch--mdio_bus:SMI-0:00
> lrwxrwxrwx    1 root     root             0 Aug 25 15:03
> consumer:mdio_bus:SMI-0:01 ->
> ../../virtual/devlink/platform:ethernet-switch--mdio_bus:SMI-0:01
> lrwxrwxrwx    1 root     root             0 Aug 25 15:03
> consumer:mdio_bus:SMI-0:02 ->
> ../../virtual/devlink/platform:ethernet-switch--mdio_bus:SMI-0:02
> lrwxrwxrwx    1 root     root             0 Aug 25 15:03
> consumer:mdio_bus:SMI-0:03 ->
> ../../virtual/devlink/platform:ethernet-switch--mdio_bus:SMI-0:03
> 0.0.0.0@CA44-:/sys/devices/platform/ethernet-switch#
> 0.0.0.0@CA44-:/sys/devices/platform/ethernet-switch#
> 0.0.0.0@CA44-:/sys/devices/platform/ethernet-switch# cat
> consumer\:*/status
> available
> active
> active
> active
> active
> 0.0.0.0@CA44-:/sys/devices/platform/ethernet-switch# cat
> consumer\:*/sync_state_only
> 1
> 0
> 0
> 0
> 0
>
> Hope that helps you understand what's going on better.
>
> BTW, I noticed that when I build realtek-smi as a module with your
> patch, my kernel crashes if I unload the module. I haven't debugged this
> because it was just a test, nor did I get a stacktrace. LMK if you want
> more info.

Yeah, don't bother. It should never merge.

> >
> >>> 2. All of them have to probe successfully before the switch will
> >>> register itself.
> >>
> >> Yes.
> >
> > Right, it's a yes in your case. But will it be a yes for all instances
> > of "realtek,rtl8366rb"?
> >
> >>> 3. If dsa_register_switch() fails, we can't defer the probe (because
> >>> it already succeeded). But I'm not sure if it's a likely error code.
> >>
> >> It's of course possible that dsa_register_switch() fails. Assuming
> >> fw_devlink is doing its job properly, I think the reason is most likel=
y
> >> going to be something specific to the driver, such as a communication
> >> timeout with the switch hardware itself.
> >
> > But what if someone sets fw_devlink=3Dpermissive? Is it okay to break
> > this? There are ways to make this work for fw_devlink=3Dpermissive and
> > =3Don -- you check for each and decide where to call
> > dsa_register_switch() based on that.
>
> I am new to DSA myself so I think I am unqualified to answer whether
> it's OK to break things or not.
>
> >
> >> I get the impression that you don't necessarily regard this change as =
a
> >> proper fix, so I'm happy to do further tests if you choose to
> >> investigate further.
> >
> > I thought about this in the background the past few days. I think
> > there are a couple of options:
> > 1. We (community/Andrew) agree that this driver would only work with
> > fw_devlink=3Don and we can confirm that the other upstream uses of
> > "realtek,rtl8366rb" won't have any unprobed consumers problem and
> > switch to using my patch. Benefit is that it's a trivial and quick
> > change that gets things working again.
> > 2. The "realtek,rtl8366rb" driver needs to be fixed to use a
> > "component device". A component device is a logical device that
> > represents a group of other devices. It's only initialized after all
> > these devices have probed successfully. The actual switch should be a
> > component device and it should call dsa_register_switch() in it's
> > "bind" (equivalent of probe). That way you can explicitly control what
> > devices need to be probed instead of depending on sync_state() that
> > have a bunch of caveats.
> >
> > Alvin, do you want to take up (2)?
>
> I can give it a shot, but first:
>
>    - It seems Andrew may also need some convincing that this is the
> right approach.

Agreed. Let's wait to see what Andrew thinks of my last response to him.

>    - Are you sure that this will solve the problem? See what I wrote
> upstairs in this email.

Yeah, it would solve the problem with a few changes:
1. The IRQ registration and mdio bus registration would get moved to
realtek_smi_probe() which probes "realtek,rtl8366rb".
2. The component device needs to be set up to be "made up of"
realtek,rtl8366rb and all the PHYs. So it'll wait for all of them to
finish probing before it's initialized. PHYs will initialize now
because realtek,rtl8366rb probe would finish without problems.
3. The component device init would call dsa_register_switch() which
kinda makes sense because the rtl8366rb and all the PHYs combined
together is what makes up the logical DSA switch.

If (2) and (3) could be make part of the framework itself, with (1)
like fix ups done to drivers with have these cyclic dependency issues,
then we could fix bad driver usage model (assuming device_add() will
probe the device before it returns).

>    - I have never written - nor can I recall reading - a component
> driver, so I would appreciate if you could point me to an upstream
> example that you think is illustrative.

The APIs you'll end up using are those in drivers/base/component.c.
You can also grep for component_master_ops and component_ops.
drivers/gpu/drm/msm/msm_drv.c might be one place to start.

Btw, the component API itself could afford some clean up and there was
a series [1], but it looks like Stephen has been busy and hasn't
gotten around to it?
[1] - https://lore.kernel.org/lkml/20210520002519.3538432-1-swboyd@chromium=
.org/

Having said all that, I might be able to give an API to tell
fw_devlink to ignore a specific child node as a supplier. So you'd
call it to ask fw_devlink to ignore the interrupt controller as a
supplier. I still maintain the current model of this driver is
definitely broken, but I'd rather just unblock this right now that
revert phy-handle support because of a few whacky corner cases like
this. I'll try to send those out this week.

> There's one more issue: I do not have an RTL8366 to test on - rather, I
> encountered this problem in realtek-smi while writing a new subdriver
> for it to support the RTL8365MB. So any proposed fix may be perceived as
> speculative if I cannot test on the '66 hardware.

If you know it fixes the issue on a very similar downstream
hardware/driver, I think it's okay to send fixes. And someone else
might be able to test it out for you.

> In that case this may
> have to wait until the '65MB subdriver is accepted. Many ifs and maybes,
> but don't take it to mean I'm not interested in helping. On the contrary
> - I would like to fix this bug since I am affected by it!

Thanks.

-Saravana
