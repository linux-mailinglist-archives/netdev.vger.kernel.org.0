Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D31BF58E3A0
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 01:17:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229493AbiHIXRQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 19:17:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbiHIXRP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 19:17:15 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 733016E2C8
        for <netdev@vger.kernel.org>; Tue,  9 Aug 2022 16:17:14 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id f28so12155808pfk.1
        for <netdev@vger.kernel.org>; Tue, 09 Aug 2022 16:17:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gateworks-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc;
        bh=daLNzzCB7AX87ZyaYQTjDFBHl0T6MLp6fE5NbbRrRsM=;
        b=w+KDOfleBXEUK4IDctSrW5ruwe3EDeVNCYIMKvZx4vDN5XnbR4mOMvDgPcjNxDBKS0
         4QXOKHbQWtahsRvAs/TV/3ZORGDMHcS5ycmeCQWhR+vl5uFIsX6CgXfoRd8TN7t6KhLb
         HySvTJmIcuKES/D/8IqKjgDGLzvDQQFxMazvie7KLIEeNpogTxugrnGvQ05eXGWWlFBg
         3WkkZMoAi3MNqeD8u5k3b+TCOX3o8KD27svSoztDB0T42BckuDvma2ZBaYzozaF+zVJE
         c6foZfnbbYQuUHnaZrs5P7pMrJG6YiGGVL4ZRF61DgGy4vJrchBJ7lotdTArTOfd8GTR
         2Wzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc;
        bh=daLNzzCB7AX87ZyaYQTjDFBHl0T6MLp6fE5NbbRrRsM=;
        b=riz2dhL2akz7MxKVGSDTCSPrsnBLR/ufBakHNsHswn/Z0JRbJ4fcF9PorCfarvB7I6
         KBZgXJU4515mM9Gim8kD6PS24MBsG+9GX3DVCQdc7FyclB1DkKgoAHhuefMlUo+WJADw
         a7HJkTbWCcGDOtNqr+XTM1KLfO44hRukQXUaK04SXGxEk0xgxFMGvMfOueB1R6nM89OE
         WakcK7jDX3xXDOCAXF/bHX5S34L7lb76/r3ElD6vgEgwK6ke5XyZeNOsa0D9ZhvPcYJl
         oUYIzXOH6Na5aE7/qasZgk7kbshvOkTIij3waT5rVWRxbrtwu+/xKLVCQtHvAvWJrY1F
         H5hQ==
X-Gm-Message-State: ACgBeo1jSWZyiTO0q+Xi9/HKgPiKdoYm2yanK1am/wm3+QBOCeSV4FA2
        CkGStPmfF6vWA079gMPbP3ctKnAQWVh5xcYbdyL8kQ==
X-Google-Smtp-Source: AA6agR7Hnh/WcdUNm07KPgIvehWPa4Zt0MSkBqXq36EgPig1TYD5pg+U1nm/trqnR5P7C7HgptApO50hl9OrM8la3Gw=
X-Received: by 2002:a63:fd0b:0:b0:415:f76b:a2cd with SMTP id
 d11-20020a63fd0b000000b00415f76ba2cdmr20661547pgh.440.1660087033850; Tue, 09
 Aug 2022 16:17:13 -0700 (PDT)
MIME-Version: 1.0
References: <CAJ+vNU05_xH4b8DFVJLpiDTkJ_z9MrBFvf1gSz9P1KXy9POU7w@mail.gmail.com>
 <5914cae0-e87b-fb94-85dd-33311fc84c52@seco.com> <20220808210945.GP17705@kitsune.suse.cz>
 <20220808143835.41b38971@hermes.local> <20220808214522.GQ17705@kitsune.suse.cz>
 <53f91ad4-a0d1-e223-a173-d2f59524e286@seco.com> <20220809213146.m6a3kfex673pjtgq@pali>
 <b1b33912-8898-f42d-5f30-0ca050fccf9a@seco.com> <20220809214207.bd4o7yzloi4npzf7@pali>
 <2083d6d6-eecf-d651-6f4f-87769cd3d60d@seco.com> <20220809224535.ymzzt6a4v756liwj@pali>
In-Reply-To: <20220809224535.ymzzt6a4v756liwj@pali>
From:   Tim Harvey <tharvey@gateworks.com>
Date:   Tue, 9 Aug 2022 16:17:01 -0700
Message-ID: <CAJ+vNU2xBthJHoD_-tPysycXZMchnXoMUBndLg4XCPrHOvgsDA@mail.gmail.com>
Subject: Re: ethernet<n> dt aliases implications in U-Boot and Linux
To:     =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Cc:     Sean Anderson <sean.anderson@seco.com>,
        =?UTF-8?Q?Michal_Such=C3=A1nek?= <msuchanek@suse.de>,
        Stephen Hemminger <stephen@networkplumber.org>,
        netdev <netdev@vger.kernel.org>, u-boot <u-boot@lists.denx.de>,
        Device Tree Mailing List <devicetree@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 9, 2022 at 3:45 PM Pali Roh=C3=A1r <pali@kernel.org> wrote:
>
> On Tuesday 09 August 2022 18:41:25 Sean Anderson wrote:
> >
> >
> > On 8/9/22 5:42 PM, Pali Roh=C3=A1r wrote:
> > > On Tuesday 09 August 2022 17:36:52 Sean Anderson wrote:
> > >> On 8/9/22 5:31 PM, Pali Roh=C3=A1r wrote:
> > >> > On Tuesday 09 August 2022 16:48:23 Sean Anderson wrote:
> > >> >> On 8/8/22 5:45 PM, Michal Such=C3=A1nek wrote:
> > >> >> > On Mon, Aug 08, 2022 at 02:38:35PM -0700, Stephen Hemminger wro=
te:
> > >> >> >> On Mon, 8 Aug 2022 23:09:45 +0200
> > >> >> >> Michal Such=C3=A1nek <msuchanek@suse.de> wrote:
> > >> >> >>
> > >> >> >> > On Mon, Aug 08, 2022 at 03:57:55PM -0400, Sean Anderson wrot=
e:
> > >> >> >> > > Hi Tim,
> > >> >> >> > >
> > >> >> >> > > On 8/8/22 3:18 PM, Tim Harvey wrote:
> > >> >> >> > > > Greetings,
> > >> >> >> > > >
> > >> >> >> > > > I'm trying to understand if there is any implication of =
'ethernet<n>'
> > >> >> >> > > > aliases in Linux such as:
> > >> >> >> > > >         aliases {
> > >> >> >> > > >                 ethernet0 =3D &eqos;
> > >> >> >> > > >                 ethernet1 =3D &fec;
> > >> >> >> > > >                 ethernet2 =3D &lan1;
> > >> >> >> > > >                 ethernet3 =3D &lan2;
> > >> >> >> > > >                 ethernet4 =3D &lan3;
> > >> >> >> > > >                 ethernet5 =3D &lan4;
> > >> >> >> > > >                 ethernet6 =3D &lan5;
> > >> >> >> > > >         };
> > >> >> >> > > >
> > >> >> >> > > > I know U-Boot boards that use device-tree will use these=
 aliases to
> > >> >> >> > > > name the devices in U-Boot such that the device with ali=
as 'ethernet0'
> > >> >> >> > > > becomes eth0 and alias 'ethernet1' becomes eth1 but for =
Linux it
> > >> >> >> > > > appears that the naming of network devices that are embe=
dded (ie SoC)
> > >> >> >> > > > vs enumerated (ie pci/usb) are always based on device re=
gistration
> > >> >> >> > > > order which for static drivers depends on Makefile linki=
ng order and
> > >> >> >> > > > has nothing to do with device-tree.
> > >> >> >> > > >
> > >> >> >> > > > Is there currently any way to control network device nam=
ing in Linux
> > >> >> >> > > > other than udev?
> > >> >> >> > >
> > >> >> >> > > You can also use systemd-networkd et al. (but that is the =
same kind of mechanism)
> > >> >> >> > >
> > >> >> >> > > > Does Linux use the ethernet<n> aliases for anything at a=
ll?
> > >> >> >> > >
> > >> >> >> > > No :l
> > >> >> >> >
> > >> >> >> > Maybe it's a great opportunity for porting biosdevname to DT=
 based
> > >> >> >> > platforms ;-)
> > >> >> >>
> > >> >> >> Sorry, biosdevname was wrong way to do things.
> > >> >> >> Did you look at the internals, it was dumpster diving as root =
into BIOS.
> > >> >> >
> > >> >> > When it's BIOS what defines the names then you have to read the=
m from
> > >> >> > the BIOS. Recently it was updated to use some sysfs file or wha=
tver.
> > >> >> > It's not like you would use any of that code with DT, anyway.
> > >> >> >
> > >> >> >> Systemd-networkd does things in much more supportable manner u=
sing existing
> > >> >> >> sysfs API's.
> > >> >> >
> > >> >> > Which is a dumpster of systemd code, no thanks.
> > >> >> >
> > >> >> > I want my device naming independent of the init system, especia=
lly if
> > >> >> > it's systemd.
> > >> >>
> > >> >> Well, there's always nameif...
> > >> >>
> > >> >> That said, I have made [1] for people using systemd-networkd.
> > >> >>
> > >> >> --Sean
> > >> >>
> > >> >> [1] https://github.com/systemd/systemd/pull/24265
> > >> >
> > >> > Hello!
> > >> >
> > >> > In some cases "label" DT property can be used also as interface na=
me.
> > >> > For example this property is already used by DSA kernel driver.
> > >> >
> > >> > I created very simple script which renames all interfaces in syste=
m to
> > >> > their "label" DT property (if there is any defined).
> > >> >
> > >> > #!/bin/sh
> > >> > for iface in `ls /sys/class/net/`; do
> > >> >  for of_node in of_node device/of_node; do
> > >> >          if test -e /sys/class/net/$iface/$of_node/; then
> > >> >                  label=3D`cat /sys/class/net/$iface/$of_node/label=
 2>/dev/null`
> > >> >                  if test -n "$label" && test "$label" !=3D "$iface=
"; then
> > >> >                          echo "Renaming net interface $iface to $l=
abel..."
> > >> >                          up=3D$((`cat /sys/class/net/$iface/flags =
2>/dev/null || echo 1` & 0x1))
> > >> >                          if test "$up" !=3D "0"; then
> > >> >                                  ip link set dev $iface down
> > >> >                          fi
> > >> >                          ip link set dev $iface name "$label" && i=
face=3D$label
> > >> >                          if test "$up" !=3D "0"; then
> > >> >                                  ip link set dev $iface up
> > >> >                          fi
> > >> >                  fi
> > >> >                  break
> > >> >          fi
> > >> >  done
> > >> > done
> > >> >
> > >> > Maybe it would be better first to use "label" and then use etherne=
t alias?
> > >> >
> > >>
> > >> It looks like there is already precedent for using ID_NET_LABEL_ONBO=
ARD for
> > >> this purpose (on SMBios boards). It should be a fairly simple extens=
ion to
> > >> add that as well. However, I didn't find any uses of this in Linux o=
r U-Boot
> > >> (although I did find plenty of ethernet LEDs). Do you have an exampl=
e you
> > >> could point me to?
> > >>
> > >> --Sean
> > >
> > > In linux:
> > > $ git grep '"label"' net/dsa/dsa2.c
> > > net/dsa/dsa2.c: const char *name =3D of_get_property(dn, "label", NUL=
L);
> > >
> >
> > Hm, if Linux is using the label, then do we need to rename things in us=
erspace?
>
> It uses it _only_ for DSA drivers. For all other drivers (e.g. USB or
> PCIe based network adapters) it does not use label.

and to my point it doesn't use label for platform devices.

Is something like the following really that crazy of an idea?
diff --git a/net/core/dev.c b/net/core/dev.c
index e0878a500aa9..a679c74a63c6 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1151,6 +1151,15 @@ static int dev_alloc_name_ns(struct net *net,
        int ret;

        BUG_ON(!net);
+#ifdef CONFIG_OF
+       if (dev->dev.parent && dev->dev.parent->of_node) {
+               const char *name =3D
of_get_property(dev->dev.parent->of_node, "label", NULL);
+               if (name) {
+                       strlcpy(dev->name, name, IFNAMSIZ);
+                       return 0;
+               }
+       }
+#endif
        ret =3D __dev_alloc_name(net, name, buf);
        if (ret >=3D 0)
                strlcpy(dev->name, buf, IFNAMSIZ);

I still like using the index from aliases/ethernet* instead as there
is a precedence for that in other Linux drivers as well as U-Boot

Best Regards,

Tim
