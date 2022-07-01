Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 494E95627C5
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 02:37:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231124AbiGAAhz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 20:37:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbiGAAhx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 20:37:53 -0400
Received: from mail-yw1-x1134.google.com (mail-yw1-x1134.google.com [IPv6:2607:f8b0:4864:20::1134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04B6344A24
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 17:37:51 -0700 (PDT)
Received: by mail-yw1-x1134.google.com with SMTP id 00721157ae682-317a66d62dfso9229347b3.7
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 17:37:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VvnQLRW3jtos30YOXCac41NBCyC2GZh1yMj7tf5Q9R0=;
        b=oyKgnTd4PpBv38WuQljuauvS82SM3dQlAPCb0vgCngpk91UWhkvTbZ51UyYbfAoPxT
         emAKlWy7SwOEebwyrY/bBlmJ7gBRqbOBdvj1P9MoQ4xxBvLVL5YPNa172XzXRY2FHp0H
         w2PV+L3bfaqtsyPtMEvIpSBAPKjV/QZNEyFmJ5sEU1kg24dtrFeUBpECBRoklWoXFZE/
         J/YZVng3McgGPZFq/KpeWHT/1N3xNE3GUH3gGkPhKBLhmrhYlOEh2+3RKVhy5pZaPEPH
         oYcoVGcU8mbLw8UZFRcEzdlq8qpnbjYWAOPuj+WSMPfq5aGJDObMbOGZGGljUFCYxDAr
         YsXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VvnQLRW3jtos30YOXCac41NBCyC2GZh1yMj7tf5Q9R0=;
        b=ga4BDzcreM/WZQIPQW7jUbKze/DQJ6Wqsug+Bzb45VEbPdZUEMR4PQpKD9eisTZaVB
         FK1H7rV6gUtbXQrNtcLWkH+7ZOiG2lhi0cY7t3RAdlEcR3VW7W6LEYLA+74vq42YyNF2
         lOMhG8lhOy6H320QQsS/hYpPY5BMAOFvh1717T92nqO7mPlXE0aPYBt8RFUCNB/RigaC
         hRM0lNNuDbYUxurqIu4HzqBZBE4gBb65abH3E2dwzcEjjRMRtFjvUmo4ct8XnoI8iYUr
         +kZESVaMWZJWccuvMInQ7GVieES1nzFO0h3UheKUhiLyMfFiK59TObr4d3zPW+03hm0M
         YcPA==
X-Gm-Message-State: AJIora/teCHsWRxQn0iHb/JCKoTBCbROw0aUAzcItxVeIfuEQj1ilKlM
        86Tm1dBti1IHZp/tLDEmvCfoPJXvLkQTuv0vF7n8+Q==
X-Google-Smtp-Source: AGRyM1umaTTvGggQULFTozCe9tetZyZETwjRyDuJ0B5d5pAN2Z0BoGkXYjkuA50JAwucoHRiSQCT/DR4v+US44sWmFM=
X-Received: by 2002:a0d:ca16:0:b0:31b:7adf:d91 with SMTP id
 m22-20020a0dca16000000b0031b7adf0d91mr13637664ywd.455.1656635871014; Thu, 30
 Jun 2022 17:37:51 -0700 (PDT)
MIME-Version: 1.0
References: <20220601070707.3946847-1-saravanak@google.com>
 <20220601070707.3946847-2-saravanak@google.com> <YrFzK6EiVvXmzVG6@atomide.com>
 <4799738.LvFx2qVVIh@steina-w>
In-Reply-To: <4799738.LvFx2qVVIh@steina-w>
From:   Saravana Kannan <saravanak@google.com>
Date:   Thu, 30 Jun 2022 17:37:14 -0700
Message-ID: <CAGETcx_1qa=gGT4LVkyPpcA1vFM9FzuJE+0DhL_nFyg5cbFjVg@mail.gmail.com>
Subject: Re: [PATCH v2 1/9] PM: domains: Delete usage of driver_deferred_probe_check_state()
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
Content-Type: multipart/mixed; boundary="0000000000009dba6c05e2b398fc"
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

--0000000000009dba6c05e2b398fc
Content-Type: text/plain; charset="UTF-8"

On Thu, Jun 23, 2022 at 5:08 AM Alexander Stein
<alexander.stein@ew.tq-group.com> wrote:
>
> Hi,
>
> Am Dienstag, 21. Juni 2022, 09:28:43 CEST schrieb Tony Lindgren:
> > Hi,
> >
> > * Saravana Kannan <saravanak@google.com> [700101 02:00]:
> > > Now that fw_devlink=on by default and fw_devlink supports
> > > "power-domains" property, the execution will never get to the point
> > > where driver_deferred_probe_check_state() is called before the supplier
> > > has probed successfully or before deferred probe timeout has expired.
> > >
> > > So, delete the call and replace it with -ENODEV.
> >
> > Looks like this causes omaps to not boot in Linux next. With this
> > simple-pm-bus fails to probe initially as the power-domain is not
> > yet available. On platform_probe() genpd_get_from_provider() returns
> > -ENOENT.
> >
> > Seems like other stuff is potentially broken too, any ideas on
> > how to fix this?
>
> I think I'm hit by this as well, although I do not get a lockup.
> In my case I'm using arch/arm64/boot/dts/freescale/imx8mq-tqma8mq-mba8mx.dts
> and probing of 38320000.blk-ctrl fails as the power-domain is not (yet)
> registed.

Ok, took a look.

The problem is that there are two drivers for the same device and they
both initialize this device.

    gpc: gpc@303a0000 {
        compatible = "fsl,imx8mq-gpc";
    }

$ git grep -l "fsl,imx7d-gpc" -- drivers/
drivers/irqchip/irq-imx-gpcv2.c
drivers/soc/imx/gpcv2.c

IMHO, this is a bad/broken design.

So what's happening is that fw_devlink will block the probe of
38320000.blk-ctrl until 303a0000.gpc is initialized. And it stops
blocking the probe of 38320000.blk-ctrl as soon as the first driver
initializes the device. In this case, it's the irqchip driver.

I'd recommend combining these drivers into one. Something like the
patch I'm attaching (sorry for the attachment, copy-paste is mangling
the tabs). Can you give it a shot please?

-Saravana

--0000000000009dba6c05e2b398fc
Content-Type: application/x-patch; name="0001-combine-drivers.patch"
Content-Disposition: attachment; filename="0001-combine-drivers.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_l51q58ij0>
X-Attachment-Id: f_l51q58ij0

RnJvbSAwOGI4Nzk1YjYzMDBkZTg5NTAyYTI2YmEzMzQ3YjJlNTRkNDMzODFkIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTYXJhdmFuYSBLYW5uYW4gPHNhcmF2YW5ha0Bnb29nbGUuY29t
PgpEYXRlOiBUaHUsIDMwIEp1biAyMDIyIDE3OjA0OjI2IC0wNzAwClN1YmplY3Q6IFtQQVRDSF0g
Y29tYmluZSBkcml2ZXJzCgotLS0KIGRyaXZlcnMvaXJxY2hpcC9pcnEtaW14LWdwY3YyLmMgfCAx
OSArKysrLS0tLS0tLS0tLS0tLS0tCiBkcml2ZXJzL3NvYy9pbXgvZ3BjdjIuYyAgICAgICAgIHwg
MTAgKysrKysrKysrKwogMiBmaWxlcyBjaGFuZ2VkLCAxNCBpbnNlcnRpb25zKCspLCAxNSBkZWxl
dGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL2lycWNoaXAvaXJxLWlteC1ncGN2Mi5jIGIv
ZHJpdmVycy9pcnFjaGlwL2lycS1pbXgtZ3BjdjIuYwppbmRleCBiOWMyMmY3NjRiNGQuLjYyMTIx
MWU1ODAwYSAxMDA2NDQKLS0tIGEvZHJpdmVycy9pcnFjaGlwL2lycS1pbXgtZ3BjdjIuYworKysg
Yi9kcml2ZXJzL2lycWNoaXAvaXJxLWlteC1ncGN2Mi5jCkBAIC0xOTksMTMgKzE5OSwxMyBAQCBz
dGF0aWMgY29uc3Qgc3RydWN0IG9mX2RldmljZV9pZCBncGN2Ml9vZl9tYXRjaFtdID0gewogCXsg
LyogRU5EICovIH0KIH07CiAKLXN0YXRpYyBpbnQgX19pbml0IGlteF9ncGN2Ml9pcnFjaGlwX2lu
aXQoc3RydWN0IGRldmljZV9ub2RlICpub2RlLAotCQkJICAgICAgIHN0cnVjdCBkZXZpY2Vfbm9k
ZSAqcGFyZW50KQoraW50IGlteF9ncGN2Ml9pcnFjaGlwX2luaXQoc3RydWN0IHBsYXRmb3JtX2Rl
dmljZSAqcGRldiwKKwkJCSAgIHVuc2lnbmVkIGxvbmcgY29yZV9udW0pCiB7CisJc3RydWN0IGRl
dmljZV9ub2RlICpub2RlID0gcGRldi0+ZGV2Lm9mX25vZGU7CisJc3RydWN0IGRldmljZV9ub2Rl
ICpwYXJlbnQgPSBvZl9pcnFfZmluZF9wYXJlbnQobm9kZSk7CiAJc3RydWN0IGlycV9kb21haW4g
KnBhcmVudF9kb21haW4sICpkb21haW47CiAJc3RydWN0IGdwY3YyX2lycWNoaXBfZGF0YSAqY2Q7
Ci0JY29uc3Qgc3RydWN0IG9mX2RldmljZV9pZCAqaWQ7Ci0JdW5zaWduZWQgbG9uZyBjb3JlX251
bTsKIAlpbnQgaTsKIAogCWlmICghcGFyZW50KSB7CkBAIC0yMTMsMTQgKzIxMyw2IEBAIHN0YXRp
YyBpbnQgX19pbml0IGlteF9ncGN2Ml9pcnFjaGlwX2luaXQoc3RydWN0IGRldmljZV9ub2RlICpu
b2RlLAogCQlyZXR1cm4gLUVOT0RFVjsKIAl9CiAKLQlpZCA9IG9mX21hdGNoX25vZGUoZ3BjdjJf
b2ZfbWF0Y2gsIG5vZGUpOwotCWlmICghaWQpIHsKLQkJcHJfZXJyKCIlcE9GOiB1bmtub3duIGNv
bXBhdGliaWxpdHkgc3RyaW5nXG4iLCBub2RlKTsKLQkJcmV0dXJuIC1FTk9ERVY7Ci0JfQotCi0J
Y29yZV9udW0gPSAodW5zaWduZWQgbG9uZylpZC0+ZGF0YTsKLQogCXBhcmVudF9kb21haW4gPSBp
cnFfZmluZF9ob3N0KHBhcmVudCk7CiAJaWYgKCFwYXJlbnRfZG9tYWluKSB7CiAJCXByX2Vycigi
JXBPRjogdW5hYmxlIHRvIGdldCBwYXJlbnQgZG9tYWluXG4iLCBub2RlKTsKQEAgLTI4NSw2ICsy
NzcsMyBAQCBzdGF0aWMgaW50IF9faW5pdCBpbXhfZ3BjdjJfaXJxY2hpcF9pbml0KHN0cnVjdCBk
ZXZpY2Vfbm9kZSAqbm9kZSwKIAlvZl9ub2RlX2NsZWFyX2ZsYWcobm9kZSwgT0ZfUE9QVUxBVEVE
KTsKIAlyZXR1cm4gMDsKIH0KLQotSVJRQ0hJUF9ERUNMQVJFKGlteF9ncGN2Ml9pbXg3ZCwgImZz
bCxpbXg3ZC1ncGMiLCBpbXhfZ3BjdjJfaXJxY2hpcF9pbml0KTsKLUlSUUNISVBfREVDTEFSRShp
bXhfZ3BjdjJfaW14OG1xLCAiZnNsLGlteDhtcS1ncGMiLCBpbXhfZ3BjdjJfaXJxY2hpcF9pbml0
KTsKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc29jL2lteC9ncGN2Mi5jIGIvZHJpdmVycy9zb2MvaW14
L2dwY3YyLmMKaW5kZXggODVhYTg2ZTEzMzhhLi4zY2E1MzgyZmY1ZDMgMTAwNjQ0Ci0tLSBhL2Ry
aXZlcnMvc29jL2lteC9ncGN2Mi5jCisrKyBiL2RyaXZlcnMvc29jL2lteC9ncGN2Mi5jCkBAIC0z
MDUsNiArMzA1LDcgQEAgc3RydWN0IGlteF9wZ2NfZG9tYWluX2RhdGEgewogCXNpemVfdCBkb21h
aW5zX251bTsKIAljb25zdCBzdHJ1Y3QgcmVnbWFwX2FjY2Vzc190YWJsZSAqcmVnX2FjY2Vzc190
YWJsZTsKIAljb25zdCBzdHJ1Y3QgaW14X3BnY19yZWdzICpwZ2NfcmVnczsKKwl1bnNpZ25lZCBs
b25nIGlycV9jb3JlX251bTsKIH07CiAKIHN0YXRpYyBpbmxpbmUgc3RydWN0IGlteF9wZ2NfZG9t
YWluICoKQEAgLTU0OSw2ICs1NTAsNyBAQCBzdGF0aWMgY29uc3Qgc3RydWN0IGlteF9wZ2NfZG9t
YWluX2RhdGEgaW14N19wZ2NfZG9tYWluX2RhdGEgPSB7CiAJLmRvbWFpbnNfbnVtID0gQVJSQVlf
U0laRShpbXg3X3BnY19kb21haW5zKSwKIAkucmVnX2FjY2Vzc190YWJsZSA9ICZpbXg3X2FjY2Vz
c190YWJsZSwKIAkucGdjX3JlZ3MgPSAmaW14N19wZ2NfcmVncywKKwkuaXJxX2NvcmVfbnVtID0g
MiwKIH07CiAKIHN0YXRpYyBjb25zdCBzdHJ1Y3QgaW14X3BnY19kb21haW4gaW14OG1fcGdjX2Rv
bWFpbnNbXSA9IHsKQEAgLTcxOCw2ICs3MjAsNyBAQCBzdGF0aWMgY29uc3Qgc3RydWN0IGlteF9w
Z2NfZG9tYWluX2RhdGEgaW14OG1fcGdjX2RvbWFpbl9kYXRhID0gewogCS5kb21haW5zX251bSA9
IEFSUkFZX1NJWkUoaW14OG1fcGdjX2RvbWFpbnMpLAogCS5yZWdfYWNjZXNzX3RhYmxlID0gJmlt
eDhtX2FjY2Vzc190YWJsZSwKIAkucGdjX3JlZ3MgPSAmaW14N19wZ2NfcmVncywKKwkuaXJxX2Nv
cmVfbnVtID0gNCwKIH07CiAKIHN0YXRpYyBjb25zdCBzdHJ1Y3QgaW14X3BnY19kb21haW4gaW14
OG1tX3BnY19kb21haW5zW10gPSB7CkBAIC0xNDI1LDYgKzE0MjgsOSBAQCBzdGF0aWMgc3RydWN0
IHBsYXRmb3JtX2RyaXZlciBpbXhfcGdjX2RvbWFpbl9kcml2ZXIgPSB7CiB9OwogYnVpbHRpbl9w
bGF0Zm9ybV9kcml2ZXIoaW14X3BnY19kb21haW5fZHJpdmVyKQogCitleHRlcm4gaW50IGlteF9n
cGN2Ml9pcnFjaGlwX2luaXQoc3RydWN0IHBsYXRmb3JtX2RldmljZSAqcGRldiwKKwkJCQkgIHVu
c2lnbmVkIGxvbmcgY29yZV9udW0pOworCiBzdGF0aWMgaW50IGlteF9ncGN2Ml9wcm9iZShzdHJ1
Y3QgcGxhdGZvcm1fZGV2aWNlICpwZGV2KQogewogCWNvbnN0IHN0cnVjdCBpbXhfcGdjX2RvbWFp
bl9kYXRhICpkb21haW5fZGF0YSA9CkBAIC0xNDQ0LDYgKzE0NTAsMTAgQEAgc3RhdGljIGludCBp
bXhfZ3BjdjJfcHJvYmUoc3RydWN0IHBsYXRmb3JtX2RldmljZSAqcGRldikKIAl2b2lkIF9faW9t
ZW0gKmJhc2U7CiAJaW50IHJldDsKIAorCXJldCA9IGlteF9ncGN2Ml9pcnFjaGlwX2luaXQocGRl
diwgZG9tYWluX2RhdGEtPmlycV9jb3JlX251bSk7CisJaWYgKHJldCkKKwkJcmV0dXJuIHJldDsK
KwogCXBnY19ucCA9IG9mX2dldF9jaGlsZF9ieV9uYW1lKGRldi0+b2Zfbm9kZSwgInBnYyIpOwog
CWlmICghcGdjX25wKSB7CiAJCWRldl9lcnIoZGV2LCAiTm8gcG93ZXIgZG9tYWlucyBzcGVjaWZp
ZWQgaW4gRFRcbiIpOwotLSAKMi4zNy4wLnJjMC4xNjEuZzEwZjM3YmVkOTAtZ29vZwoK
--0000000000009dba6c05e2b398fc--
