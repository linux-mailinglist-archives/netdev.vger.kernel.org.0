Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 764E95660AA
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 03:25:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbiGEBZQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 21:25:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231469AbiGEBZP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 21:25:15 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B94BE264B
        for <netdev@vger.kernel.org>; Mon,  4 Jul 2022 18:25:11 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id c143so10806226ybf.3
        for <netdev@vger.kernel.org>; Mon, 04 Jul 2022 18:25:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oxGa/UwGYNXANo3k9McHl4oRBHJAk4Ona0s0oaNIr6k=;
        b=brZaAixxbqg32fFMtecxDPU543uF2DZeknsz+TCPE1RU/iECd1bg9DiQ/XWEIF4tux
         hW9j5SKB/aRSTiykA4kxHU2zXcnmcpzJA5PrVrmvJkn0spxavjRLW/YJsn10RjnWpAkv
         HcmikYQ+e3Fo0EfkK1E3V6cTfYPl0jYS4651nVhE29wYvhZz28slFEvEUsKXZLKlqP74
         5P7WSTTyMFdVyWJkCBS91dIsrIHNSl2KsMbSuID4mS/ba68vVG6ZSrQ0Tvu5zN4GFAr7
         O+vOUSNcJ+2Rupg2vXnKw4qKMMuYK4kx/FphOQCX5tRdMt7oVh+CoP6T9uczVQjkbOLV
         FmJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oxGa/UwGYNXANo3k9McHl4oRBHJAk4Ona0s0oaNIr6k=;
        b=s6t6YcC32BBDWvI+8AFi0qnuN8jjJ7YR9UoDySsv92Erlib4A/ycNZWcMWUVEsjjhJ
         C6IPrRxZKxv/VWj1ZnzeoMQNmiv0kqP4AfHNYkaCC1q5Dp+RnYmCp8bwIQPyiulZYQWc
         GKBk1peyos3qlrxqzEhnSWZgaMJvsvHGb78WznbDXte/UgXaDi+WaQXKBRrpJ/95wOvQ
         Zvc+fNRvSOM2VOVqEduysq2vutCD2FcOn3nQu2udPZVTw5PLFP2t79w+1aA+jNcZ+zUP
         7D3GwAC8qrkDiFOgoFNCxhfTyTu9fDNIjwNMDNzVsOKZBC7CWivqOIUCECadpizAA0iB
         NE5w==
X-Gm-Message-State: AJIora+66NHShY810IF0mRsnOqbEmIAYQOJ8qUdarsdipYF75VKj7gDQ
        BXMPI6w3IfnUqi36LXfNRR9cmRLfKNeH8CSShO+ahw==
X-Google-Smtp-Source: AGRyM1vcsnHjOqIE4a8Iv8znQf+GV37h8OTjSBFnPgReTC2yad5rVaxApqAf/t47hEItPoIylgcdnpihO7Pw5jH5N/c=
X-Received: by 2002:a25:358b:0:b0:668:a642:ccb3 with SMTP id
 c133-20020a25358b000000b00668a642ccb3mr33543842yba.563.1656984310707; Mon, 04
 Jul 2022 18:25:10 -0700 (PDT)
MIME-Version: 1.0
References: <20220601070707.3946847-1-saravanak@google.com>
 <5265491.31r3eYUQgx@steina-w> <CAGETcx-fLAXnG+1S4MHJwg9t7O6jj6Mp+q25bh==C_Z1CLs-mg@mail.gmail.com>
 <5717577.DvuYhMxLoT@steina-w>
In-Reply-To: <5717577.DvuYhMxLoT@steina-w>
From:   Saravana Kannan <saravanak@google.com>
Date:   Mon, 4 Jul 2022 18:24:33 -0700
Message-ID: <CAGETcx8KGOTanmnVTLJ=SSDgv71ofhUcRxXRiqnUBNB3RZsY=A@mail.gmail.com>
Subject: Re: (EXT) Re: (EXT) Re: [PATCH v2 1/9] PM: domains: Delete usage of driver_deferred_probe_check_state()
To:     Alexander Stein <alexander.stein@ew.tq-group.com>
Cc:     Tony Lindgren <tony@atomide.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Kevin Hilman <khilman@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, kernel-team@android.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        iommu@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-gpio@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Content-Type: multipart/mixed; boundary="0000000000003dfee805e304b968"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000003dfee805e304b968
Content-Type: text/plain; charset="UTF-8"

On Mon, Jul 4, 2022 at 12:07 AM Alexander Stein
<alexander.stein@ew.tq-group.com> wrote:
>
> Am Freitag, 1. Juli 2022, 09:02:22 CEST schrieb Saravana Kannan:
> > On Thu, Jun 30, 2022 at 11:02 PM Alexander Stein
> >
> > <alexander.stein@ew.tq-group.com> wrote:
> > > Hi Saravana,
> > >
> > > Am Freitag, 1. Juli 2022, 02:37:14 CEST schrieb Saravana Kannan:
> > > > On Thu, Jun 23, 2022 at 5:08 AM Alexander Stein
> > > >
> > > > <alexander.stein@ew.tq-group.com> wrote:
> > > > > Hi,
> > > > >
> > > > > Am Dienstag, 21. Juni 2022, 09:28:43 CEST schrieb Tony Lindgren:
> > > > > > Hi,
> > > > > >
> > > > > > * Saravana Kannan <saravanak@google.com> [700101 02:00]:
> > > > > > > Now that fw_devlink=on by default and fw_devlink supports
> > > > > > > "power-domains" property, the execution will never get to the
> > > > > > > point
> > > > > > > where driver_deferred_probe_check_state() is called before the
> > > > > > > supplier
> > > > > > > has probed successfully or before deferred probe timeout has
> > > > > > > expired.
> > > > > > >
> > > > > > > So, delete the call and replace it with -ENODEV.
> > > > > >
> > > > > > Looks like this causes omaps to not boot in Linux next. With this
> > > > > > simple-pm-bus fails to probe initially as the power-domain is not
> > > > > > yet available. On platform_probe() genpd_get_from_provider() returns
> > > > > > -ENOENT.
> > > > > >
> > > > > > Seems like other stuff is potentially broken too, any ideas on
> > > > > > how to fix this?
> > > > >
> > > > > I think I'm hit by this as well, although I do not get a lockup.
> > > > > In my case I'm using
> > > > > arch/arm64/boot/dts/freescale/imx8mq-tqma8mq-mba8mx.dts and probing of
> > > > > 38320000.blk-ctrl fails as the power-domain is not (yet) registed.
> > > >
> > > > Ok, took a look.
> > > >
> > > > The problem is that there are two drivers for the same device and they
> > > > both initialize this device.
> > > >
> > > >     gpc: gpc@303a0000 {
> > > >
> > > >         compatible = "fsl,imx8mq-gpc";
> > > >
> > > >     }
> > > >
> > > > $ git grep -l "fsl,imx7d-gpc" -- drivers/
> > > > drivers/irqchip/irq-imx-gpcv2.c
> > > > drivers/soc/imx/gpcv2.c
> > > >
> > > > IMHO, this is a bad/broken design.
> > > >
> > > > So what's happening is that fw_devlink will block the probe of
> > > > 38320000.blk-ctrl until 303a0000.gpc is initialized. And it stops
> > > > blocking the probe of 38320000.blk-ctrl as soon as the first driver
> > > > initializes the device. In this case, it's the irqchip driver.
> > > >
> > > > I'd recommend combining these drivers into one. Something like the
> > > > patch I'm attaching (sorry for the attachment, copy-paste is mangling
> > > > the tabs). Can you give it a shot please?
> > >
> > > I tried this patch and it delayed the driver initialization (those of UART
> > > as
> > > well BTW). Unfortunately the driver fails the same way:
> > Thanks for testing the patch!
> >
> > > > [    1.125253] imx8m-blk-ctrl 38320000.blk-ctrl: error -ENODEV: failed
> > > > to
> > >
> > > attach power domain "bus"
> > >
> > > More than that it even introduced some more errors:
> > > > [    0.008160] irq: no irq domain found for gpc@303a0000 !
> >
> > So the idea behind my change was that as long as the irqchip isn't the
> > root of the irqdomain (might be using the terms incorrectly) like the
> > gic, you can make it a platform driver. And I was trying to hack up a
> > patch that's the equivalent of platform_irqchip_probe() (which just
> > ends up eventually calling the callback you use in IRQCHIP_DECLARE().
> > I probably made some mistake in the quick hack that I'm sure if
> > fixable.
> >
> > > > [    0.013251] Failed to map interrupt for
> > > > /soc@0/bus@30400000/timer@306a0000
> >
> > However, this timer driver also uses TIMER_OF_DECLARE() which can't
> > handle failure to get the IRQ (because it's can't -EPROBE_DEFER). So,
> > this means, the timer driver inturn needs to be converted to a
> > platform driver if it's supposed to work with the IRQCHIP_DECLARE()
> > being converted to a platform driver.
> >
> > But that's a can of worms not worth opening. But then I remembered
> > this simpler workaround will work and it is pretty much a variant of
> > the workaround that's already in the gpc's irqchip driver to allow two
> > drivers to probe the same device (people really should stop doing
> > that).
> >
> > Can you drop my previous hack patch and try this instead please? I'm
> > 99% sure this will work.
> >
> > diff --git a/drivers/irqchip/irq-imx-gpcv2.c
> > b/drivers/irqchip/irq-imx-gpcv2.c index b9c22f764b4d..8a0e82067924 100644
> > --- a/drivers/irqchip/irq-imx-gpcv2.c
> > +++ b/drivers/irqchip/irq-imx-gpcv2.c
> > @@ -283,6 +283,7 @@ static int __init imx_gpcv2_irqchip_init(struct
> > device_node *node,
> >          * later the GPC power domain driver will not be skipped.
> >          */
> >         of_node_clear_flag(node, OF_POPULATED);
> > +       fwnode_dev_initialized(domain->fwnode, false);
> >         return 0;
> >  }
>
> Just to be sure here, I tried this patch on top of next-20220701 but
> unfortunately this doesn't fix the original problem either. The timer errors
> are gone though.

To clarify, you had the timer issue only with my "combine drivers" patch, right?

> The probe of imx8m-blk-ctrl got slightly delayed (from 0.74 to 0.90s printk
> time) but results in the identical error message.

My guess is that the probe attempt of blk-ctrl is delayed now till gpc
probes (because of the device links getting created with the
fwnode_dev_initialized() fix), but by the time gpc probe finishes, the
power domains aren't registered yet because of the additional level of
device addition and probing.

Can you try the attached patch please?

And if that doesn't fix the issues, then enable the debug logs in the
following functions please and share the logs from boot till the
failure? If you can enable CONFIG_PRINTK_CALLER, that'd help too.
device_link_add()
fwnode_link_add()
fw_devlink_relax_cycle()

Btw, part of the reason I'm trying to make sure we fix it the right
way is that when we try to enable async boot by default, we don't run
into issues.

Thanks,
Saravana

--0000000000003dfee805e304b968
Content-Type: text/x-patch; charset="US-ASCII"; name="0001-imx-fix-and-logs.patch"
Content-Disposition: attachment; filename="0001-imx-fix-and-logs.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_l57hngib0>
X-Attachment-Id: f_l57hngib0

RnJvbSAzNGFlNGZhOWM3ZWZjYTI2ZTU5NDY0MjJhYjlhMDkyNWNlNGE1MjkzIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTYXJhdmFuYSBLYW5uYW4gPHNhcmF2YW5ha0Bnb29nbGUuY29t
PgpEYXRlOiBGcmksIDEgSnVsIDIwMjIgMDE6MjU6NTYgLTA3MDAKU3ViamVjdDogW1BBVENIXSBp
bXgtZml4IGFuZCBsb2dzCgotLS0KIGRyaXZlcnMvaXJxY2hpcC9pcnEtaW14LWdwY3YyLmMgfCAg
MSArCiBkcml2ZXJzL3NvYy9pbXgvZ3BjdjIuYyAgICAgICAgIHwgMTAgKysrKysrKysrLQogMiBm
aWxlcyBjaGFuZ2VkLCAxMCBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pCgpkaWZmIC0tZ2l0
IGEvZHJpdmVycy9pcnFjaGlwL2lycS1pbXgtZ3BjdjIuYyBiL2RyaXZlcnMvaXJxY2hpcC9pcnEt
aW14LWdwY3YyLmMKaW5kZXggYjljMjJmNzY0YjRkLi44YTBlODIwNjc5MjQgMTAwNjQ0Ci0tLSBh
L2RyaXZlcnMvaXJxY2hpcC9pcnEtaW14LWdwY3YyLmMKKysrIGIvZHJpdmVycy9pcnFjaGlwL2ly
cS1pbXgtZ3BjdjIuYwpAQCAtMjgzLDYgKzI4Myw3IEBAIHN0YXRpYyBpbnQgX19pbml0IGlteF9n
cGN2Ml9pcnFjaGlwX2luaXQoc3RydWN0IGRldmljZV9ub2RlICpub2RlLAogCSAqIGxhdGVyIHRo
ZSBHUEMgcG93ZXIgZG9tYWluIGRyaXZlciB3aWxsIG5vdCBiZSBza2lwcGVkLgogCSAqLwogCW9m
X25vZGVfY2xlYXJfZmxhZyhub2RlLCBPRl9QT1BVTEFURUQpOworCWZ3bm9kZV9kZXZfaW5pdGlh
bGl6ZWQoZG9tYWluLT5md25vZGUsIGZhbHNlKTsKIAlyZXR1cm4gMDsKIH0KIApkaWZmIC0tZ2l0
IGEvZHJpdmVycy9zb2MvaW14L2dwY3YyLmMgYi9kcml2ZXJzL3NvYy9pbXgvZ3BjdjIuYwppbmRl
eCA4NWFhODZlMTMzOGEuLjA3ZmNlYWY3NGYxOSAxMDA2NDQKLS0tIGEvZHJpdmVycy9zb2MvaW14
L2dwY3YyLmMKKysrIGIvZHJpdmVycy9zb2MvaW14L2dwY3YyLmMKQEAgLTEzNTAsNiArMTM1MCw4
IEBAIHN0YXRpYyBpbnQgaW14X3BnY19kb21haW5fcHJvYmUoc3RydWN0IHBsYXRmb3JtX2Rldmlj
ZSAqcGRldikKIAkJZ290byBvdXRfZ2VucGRfcmVtb3ZlOwogCX0KIAorCWRldl9pbmZvKCIlczog
UHJvYmUgc3VjY2VlZGVkXG4iLCBfX2Z1bmNfXyk7CisKIAlyZXR1cm4gMDsKIAogb3V0X2dlbnBk
X3JlbW92ZToKQEAgLTE0MjMsNyArMTQyNSwxMiBAQCBzdGF0aWMgc3RydWN0IHBsYXRmb3JtX2Ry
aXZlciBpbXhfcGdjX2RvbWFpbl9kcml2ZXIgPSB7CiAJLnJlbW92ZSAgID0gaW14X3BnY19kb21h
aW5fcmVtb3ZlLAogCS5pZF90YWJsZSA9IGlteF9wZ2NfZG9tYWluX2lkLAogfTsKLWJ1aWx0aW5f
cGxhdGZvcm1fZHJpdmVyKGlteF9wZ2NfZG9tYWluX2RyaXZlcikKKworc3RhdGljIGludCBfX2lu
aXQgaW14X3BnY19kb21haW5faW5pdCh2b2lkKQoreworCXJldHVybiBwbGF0Zm9ybV9kcml2ZXJf
cmVnaXN0ZXIoJmlteF9wZ2NfZG9tYWluX2RyaXZlcik7Cit9CitzdWJzeXNfaW5pdGNhbGwoaW14
X3BnY19kb21haW5faW5pdCk7CiAKIHN0YXRpYyBpbnQgaW14X2dwY3YyX3Byb2JlKHN0cnVjdCBw
bGF0Zm9ybV9kZXZpY2UgKnBkZXYpCiB7CkBAIC0xNTE4LDYgKzE1MjUsNyBAQCBzdGF0aWMgaW50
IGlteF9ncGN2Ml9wcm9iZShzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlICpwZGV2KQogCQl9CiAJfQog
CisJZGV2X2luZm8oIiVzOiBQcm9iZSBzdWNjZWVkZWRcbiIsIF9fZnVuY19fKTsKIAlyZXR1cm4g
MDsKIH0KIAotLSAKMi4zNy4wLnJjMC4xNjEuZzEwZjM3YmVkOTAtZ29vZwoK
--0000000000003dfee805e304b968--
