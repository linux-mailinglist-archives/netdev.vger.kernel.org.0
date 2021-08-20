Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B4013F31BD
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 18:53:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232025AbhHTQxl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 12:53:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbhHTQxk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Aug 2021 12:53:40 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79AB0C061575
        for <netdev@vger.kernel.org>; Fri, 20 Aug 2021 09:53:02 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id n126so6614788ybf.6
        for <netdev@vger.kernel.org>; Fri, 20 Aug 2021 09:53:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=D4s3OOPxe9UBaSfqUmk2M0iRKeVy4B1XKJA3knBD+M8=;
        b=a/voE4880/7jjL7JhjuIdipgUcnQNJw2NNJZt6JlKeaGADfDDel58tvrLfjzmCcGg8
         akcPIJfZ+VMCegyhbAC1RKiaS0/ILHUwB+PZJW2Hurs9XESLXrRZnsQkJ/jGNfVZt05s
         DHgIqftlCeeWSxDJeAenG+L/IrOKukIujJ7USW7EFUI2jE9HqBWZv0klJx17Cu+iJc0t
         c7VjfVRMakGJny557mfxqTIeckPRuR/0W2JS9vkYrwTRy18zVF8YVMhXZNHLYuOIVw1A
         2tz/pKazHwLm9ovJIy7DPyswSl3htaPfmycIIdDqZGntCnHKZViC1WnucSLusF/7Q8X2
         A9+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=D4s3OOPxe9UBaSfqUmk2M0iRKeVy4B1XKJA3knBD+M8=;
        b=ofu6b0JMbSu4bol2UYKHCjDBNfosZdjyOl7iPx7hD6oVczOq3nlanqJlUb01fZUVCv
         7ZxUgVfO2BNJFz/rgIRfFRfOd/rfzWOyAyuHC8lmlajswSluxFr395stZOp3kNH/tLAl
         NLxf/v7D5SLST2bPh5nUDo4yfXaehs2RVXpNuJljKP0LbHSgp0yEIQLCNgkTJxxr0FyG
         vskDfGtz73qIOPIlgRjpjRGtiKvGyFv4pK/3mQHJIdSqbzgAEQBpcmXYhmyjZVbpJGEv
         yaKA/mQZ8RzEyComwQmFRXHKS+UsUKrJ/XdcvemBnlfat0PSXsCRkIp2BlzViVSHHD1p
         wBwQ==
X-Gm-Message-State: AOAM533G/JgfmAi/lw9Hbw771HUtw5ECZRA5SUPKykjFtlBGA1DxfjFv
        +LxLKcM4LTWDgGHS6GDvgVBlcdQ1s7e9Gsw+JNArhQ==
X-Google-Smtp-Source: ABdhPJxdQQbJEj5lqeMe9sptco/elS0o99bMjWQsdn40N+LlmI7hVU5KhWKEjpGO1oygIdZrY6RfO5DrcHY9aPxpg6Y=
X-Received: by 2002:a25:bdc6:: with SMTP id g6mr25368869ybk.310.1629478380740;
 Fri, 20 Aug 2021 09:53:00 -0700 (PDT)
MIME-Version: 1.0
References: <20210817145245.3555077-1-vladimir.oltean@nxp.com>
 <cd0d9c40-d07b-e2ab-b068-d0bcb4685d09@bang-olufsen.dk> <20210817223101.7wbdofi7xkeqa2cp@skbuf>
 <CAGETcx8T-ReJ_Gj-U+nxQyZPsv1v67DRBvpp9hS0fXgGRUQ17w@mail.gmail.com>
 <6b89a9e1-e92e-ca99-9fbd-1d98f6a7864b@bang-olufsen.dk> <CAGETcx_uj0V4DChME-gy5HGKTYnxLBX=TH2rag29f_p=UcG+Tg@mail.gmail.com>
 <875f7448-8402-0c93-2a90-e1d83bb7586a@bang-olufsen.dk> <CAGETcx_M5pEtpYhuc-Fx6HvC_9KzZnPMYUH_YjcBb4pmq8-ghA@mail.gmail.com>
In-Reply-To: <CAGETcx_M5pEtpYhuc-Fx6HvC_9KzZnPMYUH_YjcBb4pmq8-ghA@mail.gmail.com>
From:   Saravana Kannan <saravanak@google.com>
Date:   Fri, 20 Aug 2021 09:52:24 -0700
Message-ID: <CAGETcx_+=TmMq9hP=95xferAmyA1ZCT3sMRLVnzJ9Or9OnDsDA@mail.gmail.com>
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

On Thu, Aug 19, 2021 at 6:08 PM Saravana Kannan <saravanak@google.com> wrot=
e:
>
> On Thu, Aug 19, 2021 at 6:42 AM Alvin =C5=A0ipraga <ALSI@bang-olufsen.dk>=
 wrote:
> >
> > Hi Saravana,
> >
> > Thanks for your lucid analysis, it's very much appreciated. Please find
> > my replies inline - but in summary, I don't think there is anything mor=
e
> > I can ask of you right now.
>
> You are welcome.
>
> >
> > On 8/19/21 5:28 AM, Saravana Kannan wrote:
> > > On Wed, Aug 18, 2021 at 3:18 AM Alvin =C5=A0ipraga <ALSI@bang-olufsen=
.dk> wrote:
> > >>
> > >> Hi Saravana,
> > >>
> > >> On 8/18/21 4:46 AM, Saravana Kannan wrote:
> > >>> On Tue, Aug 17, 2021 at 3:31 PM Vladimir Oltean <olteanv@gmail.com>=
 wrote:
> > >>>>
> > >>>> Hi Alvin,
> > >>>>
> > >>>> On Tue, Aug 17, 2021 at 09:25:28PM +0000, Alvin =C5=A0ipraga wrote=
:
> > >>>>> I have an observation that's slightly out of the scope of your pa=
tch,
> > >>>>> but I'll post here on the off chance that you find it relevant.
> > >>>>> Apologies if it's out of place.
> > >>>>>
> > >>>>> Do these integrated NXP PHYs use a specific PHY driver, or do the=
y just
> > >>>>> use the Generic PHY driver?
> > >>>>
> > >>>> They refuse to probe at all with the Generic PHY driver. I have be=
en
> > >>>> caught off guard a few times now when I had a kernel built with
> > >>>> CONFIG_NXP_C45_TJA11XX_PHY=3Dn and their probing returns -22 in th=
at case.
> > >>>>
> > >>>>> If the former is the case, do you experience that the PHY driver =
fails
> > >>>>> to get probed during mdiobus registration if the kernel uses
> > >>>>> fw_devlink=3Don?
> > >>>>
> > >>>> I don't test with "fw_devlink=3Don" in /proc/cmdline, this is the =
first
> > >>>> time I do it. It behaves exactly as you say.
> > >>>>
> > >>>>>
> > >>>>> In my case I am writing a new subdriver for realtek-smi, a DSA dr=
iver
> > >>>>> which registers an internal MDIO bus analogously to sja1105, whic=
h is
> > >>>>> why I'm asking. I noticed a deferred probe of the PHY driver beca=
use the
> > >>>>> supplier (ethernet-switch) is not ready - presumably because all =
of this
> > >>>>> is happening in the probe of the switch driver. See below:
> > >>>>>
> > >>>>> [   83.653213] device_add:3270: device: 'SMI-0': device_add
> > >>>>> [   83.653905] device_pm_add:136: PM: Adding info for No Bus:SMI-=
0
> > >>>>> [   83.654055] device_add:3270: device: 'platform:ethernet-switch=
--mdio_bus:SMI-0': device_add
> > >>>>> [   83.654224] device_link_add:843: mdio_bus SMI-0: Linked as a s=
ync state only consumer to ethernet-switch
> > >>>>> [   83.654291] libphy: SMI slave MII: probed
> > >>>>> ...
> > >>>>> [   83.659809] device_add:3270: device: 'SMI-0:00': device_add
> > >>>>> [   83.659883] bus_add_device:447: bus: 'mdio_bus': add device SM=
I-0:00
> > >>>>> [   83.659970] device_pm_add:136: PM: Adding info for mdio_bus:SM=
I-0:00
> > >>>>> [   83.660122] device_add:3270: device: 'platform:ethernet-switch=
--mdio_bus:SMI-0:00': device_add
> > >>>>> [   83.660274] devices_kset_move_last:2701: devices_kset: Moving =
SMI-0:00 to end of list
> > >>>>> [   83.660282] device_pm_move_last:203: PM: Moving mdio_bus:SMI-0=
:00 to end of list
> > >>>>> [   83.660293] device_link_add:859: mdio_bus SMI-0:00: Linked as =
a consumer to ethernet-switch
> > >>>>> [   83.660350] __driver_probe_device:736: bus: 'mdio_bus': __driv=
er_probe_device: matched device SMI-0:00 with driver RTL8365MB-VC Gigabit E=
thernet
> > >>>>> [   83.660365] device_links_check_suppliers:1001: mdio_bus SMI-0:=
00: probe deferral - supplier ethernet-switch not ready
> > >>>>> [   83.660376] driver_deferred_probe_add:138: mdio_bus SMI-0:00: =
Added to deferred list
> > >>>>
> > >>>> So it's a circular dependency? Switch cannot finish probing becaus=
e it
> > >>>> cannot connect to PHY, which cannot probe because switch has not
> > >>>> finished probing, which....
> > >>>
> > >>> Hi Vladimir/Alvin,
> > >>>
> > >>> If there's a cyclic dependency between two devices, then fw_devlink=
=3Don
> > >>> is smart enough to notice that. Once it notices a cycle, it knows t=
hat
> > >>> it can't tell which one is the real dependency and which one is the
> > >>> false dependency and so stops enforcing ordering between the device=
s
> > >>> in the cycle.
> > >>>
> > >>> But fw_devlink doesn't understand all the properties yet. Just most=
 of
> > >>> them and I'm always trying to add more. So when it only understands
> > >>> the property that's causing the false dependency but not the proper=
ty
> > >>> that causes the real dependency, it can cause issues like this wher=
e
> > >>> fw_devlink=3Don enforces the false dependency and the driver/code
> > >>> enforces the real dependency. These are generally easy to fix -- yo=
u
> > >>> just need to teach fw_devlink how to parse more properties.
> > >>>
> > >>> This is just a preliminary analysis since I don't have all the info
> > >>> yet -- so I could be wrong. With that said, I happened to be workin=
g
> > >>> on adding fw_devlink support for phy-handle property and I think it
> > >>> should fix your issue with fw_devlink=3Don. Can you give [1] a shot=
?
> > >>
> > >> I tried [1] but it did not seem to have any effect.
> > >>
> > >>>
> > >>> If it doesn't fix it, can one of you please point me to an upstream
> > >>> dts (not dtsi) file for a platform in which you see this issue? And
> > >>> ideally also the DT nodes and their drivers that are involved in th=
is
> > >>> cycle? With that info, I should be able to root cause this if the
> > >>> patch above doesn't already fix it.
> > >>
> > >> I'm working with a non-upstream dts - maybe Vladimir is using an
> > >> upstream one? The pattern among the drivers/dts is common between ou=
r
> > >> two cases.
> > >
> > > Ideally, I can get a fully upstream example where this issue is
> > > happening so that I can look at the actual code that's hitting this
> > > issue and be sure my analysis is right.
> >
> > Due to NDA issues at work, I am unable to publish the DTS right now. Bu=
t
> > based on your analysis below, I believe that the problem I am
> > experiencing is exactly for the reasons you describe.
> >
> > >
> > >>
> > >> But for the sake of this discussion, my dts is pretty much the same =
as
> > >> what you will find in arch/arm/boot/dts/gemini-dlink-dir-685.dts. Th=
e
> > >> nodes of interest from that dts file are below, and the driver is in
> > >> drivers/net/ds/{realtek-smi-core.c,rtl8366rb.c}. It's expected that =
the
> > >> Realtek PHY driver in drivers/net/phy/realtek.c will get probed as p=
art
> > >> of the mdiobus registration, but that never happens. See my previous
> > >> reply for a debug log.
> > >
> > > Your DTS might be similar to this, but the driver code also matters
> > > for me to be sure. Anyway, I took a look at this, but my analysis
> > > below is going to be sketchy because I'm not looking at the actual
> > > code that's reproducing this issue.
> >
> > The driver code I am working with is pretty much the same in the probe
> > path (the driver is modelled on rtl8366rb.c and hooks into
> > realtek-smi-core.c), so it was not a waste of your time to analyze the
> > upstream case. Thanks a lot.
>
> Good to know it's useful.
>
> >
> > >
> > > Assuming this issue actually happens with the example you pointed to
> > > (I don't know this yet), here's what is happening:
> > >
> > > The main problem is that the parent device switch seems to be assumin=
g
> > > it's child/grandchild devices (mdiobus/PHYs) will have probed
> > > successfully as soon as they are added. This assumption is not true
> > > and can be broken for multiple reasons such as:
> > >
> > > 1. The driver for the child devices (PHYs in this case) could be
> > > loaded as a module after the parent (switch) is probed. So when the
> > > devices are added, the PHYs would not be probed.
> > > 2. The child devices could defer probe because one of their suppliers
> > > isn't ready yet. Either because of fw_devlink=3Don or the framework
> > > itself returning -EPROBE_DEFER.
> > > 3. The child devices could be getting probed asynchronously. So the
> > > device_add() would kick off a thread to probe the child devices in a
> > > separate thread.
> > >
> > > (2) is what is happening in this case. fw_devlink=3Don sees that
> > > "switch" implements the "switch_intc" and "switch" hasn't finished
> > > probing yet. So it has no way of knowing that switch_intc is actually
> > > ready. And even if switch_intc was registered as part of switch's
> > > probe() by the time the PHYs are added, switch_intc could get
> > > deregistered if the probe fails at a later point. So until probe()
> > > returns 0, fw_devlink can't be fully sure the supplier (switch_intc)
> > > is ready. Which is good in general because you won't have to
> > > forcefully unbind (if that is even handled correctly in the first
> > > place) the consumers of a device if it fails probe() half way through
> > > registering a few services.
> >
> > Right, that makes perfect sense.
> >
> > >
> > > I don't fully understand the networking frameworks, but I think
> > > Vladimir might have a point in his earlier reply [1]. If you can make
> > > the switch driver not assume its child PHYs are ready during the
> > > switch's probe and instead have the switch check if the PHYs are read=
y
> > > when the switch is "opened" that'd be better.
> >
> > I am pretty new to the DSA subsystem,
>
> I know absolutely nothing about DSA. Heck, I don't even know what it
> stands for. It's just about as informative as "XYZ" to me :)
>
> > but it appears to me that DSA is
> > making this assumption: I don't think DSA switches have a concept of
> > "open", as everything is handled in the dsa_register_switch() call in a
> > DSA driver's probe function. And as Vladimir pointed out, this is also
> > where phylink_of_phy_connect() is being called.
>
> Yeah, I noticed that part.
>
> > A quick look at the
> > other DSA drivers suggests that mv88e6xxx may also suffer from case (2)
> > above, so it seems like a more general issue.
> >
>
> I obviously want fw_devlink=3Don to be used by everyone and not have
> people use fw_devlink=3Dpermissive. In this scenario, I think
> fw_devlink=3Don is doing the right thing too. So this is where I'm
> hoping the network experts can jump in and fix the general DSA issue
> and I can help with the parts I understand.

Hi Alvin,

Can you give this a shot to see if it fixes your issue? It basically
delays the registration of dsa_register_switch() until all the
consumers of this switch have probed. So it has a couple of caveats:
1. I'm hoping the PHYs are the only consumers of this switch.
2. All of them have to probe successfully before the switch will
register itself.
3. If dsa_register_switch() fails, we can't defer the probe (because
it already succeeded). But I'm not sure if it's a likely error code.

But, for now, I want to see if it fixes your issues.

-Saravana


+++ b/drivers/net/dsa/realtek-smi-core.c
@@ -454,14 +454,16 @@ static int realtek_smi_probe(struct platform_device *=
pdev)
        smi->ds->priv =3D smi;

        smi->ds->ops =3D var->ds_ops;
-       ret =3D dsa_register_switch(smi->ds);
-       if (ret) {
-               dev_err(dev, "unable to register switch ret =3D %d\n", ret)=
;
-               return ret;
-       }
        return 0;
 }

+static void realtek_smi_sync_state(struct device *dev)
+{
+       struct realtek_smi *smi =3D dev_get_drvdata(dev);
+       if (dsa_register_switch(smi->ds))
+               dev_err(dev, "unable to register switch ret =3D %d\n", ret)=
;
+}
+
 static int realtek_smi_remove(struct platform_device *pdev)
 {
        struct realtek_smi *smi =3D dev_get_drvdata(&pdev->dev);
@@ -492,6 +494,7 @@ static struct platform_driver realtek_smi_driver =3D {
        .driver =3D {
                .name =3D "realtek-smi",
                .of_match_table =3D of_match_ptr(realtek_smi_of_match),
+               .sync_state =3D realtek_smi_sync_state,
        },
        .probe  =3D realtek_smi_probe,
        .remove =3D realtek_smi_remove,
