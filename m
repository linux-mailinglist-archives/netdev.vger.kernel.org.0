Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBCD35B9411
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 07:59:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229538AbiIOF7U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 01:59:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbiIOF7S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 01:59:18 -0400
Received: from mail-oa1-x2f.google.com (mail-oa1-x2f.google.com [IPv6:2001:4860:4864:20::2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00C499019F;
        Wed, 14 Sep 2022 22:59:17 -0700 (PDT)
Received: by mail-oa1-x2f.google.com with SMTP id 586e51a60fabf-11e9a7135easo46040428fac.6;
        Wed, 14 Sep 2022 22:59:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date;
        bh=QuYwY1WWD4oc1w5hcjaVeyURITDJWRc1kZVgbGtIbbk=;
        b=DSP1awPcWe1qx8PIBW3q/pE0+uNiUeGrVwlFlzVld6dQTJO30r+sBX70NGFeDfhk3g
         nb5lz++dIYu7Vjnrdsd3ZyGNeiUu5QyOMjERF8VZ9H2SMYJMYSpoCAB91fs57kVa94RN
         u8wr2rxMrMPYv/RsOKfUQP5D5X89yMRnZAhf125eRSMAeACbzPFRJwS9/x8zSdUyyvML
         KbDDHR/VeYj3bqMxszYOhNico+rHvehIgE4Grrfz4OQaTNhiIRvvtL6XeT5S7fd5dE87
         uAQjmjDejEe3YxAWHxI1I/RiFu62t97x+6R7/1OYnzwctPkXpCB8Hy6HM7QHRcswgbsY
         HscA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date;
        bh=QuYwY1WWD4oc1w5hcjaVeyURITDJWRc1kZVgbGtIbbk=;
        b=pas9WzvvPphRueuzhoOiBv4fqNs/CVxBtHJOWF6kspispsjk8fREyDEJbpmmXWgOxx
         hLgmWDMoHjL40XBJCJR5SO+2DIKqBYfNGH7WIOjYewPYv8Gf4XU0uVjpETtkwFYgZoVo
         5rFBNcwhvZ49V8OLM3Rj2RDm1KJQ33mzTSqDE1LcOnYTDkB15rseKLwKc+hlzVCqfZOl
         Q7gzad4qVw3m3gIWsh9lYrvecf4W1MVnLFFdwWY3F8LE8hwrH62QZVKN7dnOmKKC2YAC
         pV45pXFXYsKVgaxurN9xdqWLzfBukv9K3qQq++SQ/qi9nhvMYieEs4wpFCaK0BGVqYRQ
         B/rw==
X-Gm-Message-State: ACgBeo1WXSWM0X+kT5iOLSZoNwBGqZnx9YrPIR35d2fxyjDptlxCxQPH
        BgOGPA7AVlmsSfn/veOF4D3Kb67++okwcudoEbM=
X-Google-Smtp-Source: AA6agR7q6lVtWmHCXQBdt68pJfxkqrpvlVB8rMWyDEedFfJdCaTm2edGPrVJcncfUWp2Y38mPeBJ2uDrSVgmICNIUu0=
X-Received: by 2002:a05:6870:c0c8:b0:101:b3c3:abc3 with SMTP id
 e8-20020a056870c0c800b00101b3c3abc3mr4359750oad.144.1663221556310; Wed, 14
 Sep 2022 22:59:16 -0700 (PDT)
MIME-Version: 1.0
References: <20220914085451.11723-1-arinc.unal@arinc9.com> <20220914085451.11723-6-arinc.unal@arinc9.com>
 <CAMhs-H9pj+qEdOCEhkyCJPvbFonLuhgSHgL4L6kkhO3YRh52vw@mail.gmail.com>
 <6593afa8-931b-81eb-d9a8-ec3adbd047c6@arinc9.com> <CAMhs-H_woEpWVEWbe+1p76g6M3ALjoVn-OgzpnJQHOjd02tHxw@mail.gmail.com>
In-Reply-To: <CAMhs-H_woEpWVEWbe+1p76g6M3ALjoVn-OgzpnJQHOjd02tHxw@mail.gmail.com>
From:   Sergio Paracuellos <sergio.paracuellos@gmail.com>
Date:   Thu, 15 Sep 2022 07:59:04 +0200
Message-ID: <CAMhs-H9m9LdQ3J5PjDNo_fh1b6rhSdu5Ddb3nfE=2nWxfTCP=A@mail.gmail.com>
Subject: Re: [PATCH 05/10] mips: dts: ralink: mt7621: fix some dtc warnings
To:     =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, erkin.bozoglu@xeront.com,
        netdev <netdev@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>, linux-arm-kernel@lists.infradead.org,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "open list:MIPS" <linux-mips@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 15, 2022 at 5:30 AM Sergio Paracuellos
<sergio.paracuellos@gmail.com> wrote:
>
> On Wed, Sep 14, 2022 at 12:46 PM Ar=C4=B1n=C3=A7 =C3=9CNAL <arinc.unal@ar=
inc9.com> wrote:
> >
> > Hi Sergio,
> >
> > On 14.09.2022 12:14, Sergio Paracuellos wrote:
> > > Hi Arinc,
> > >
> > > On Wed, Sep 14, 2022 at 10:55 AM Ar=C4=B1n=C3=A7 =C3=9CNAL <arinc.una=
l@arinc9.com> wrote:
> > >>
> > >> Fix the dtc warnings below.
> > >>
> > >> /cpus/cpu@0: failed to match any schema with compatible: ['mips,mips=
1004Kc']
> > >> /cpus/cpu@1: failed to match any schema with compatible: ['mips,mips=
1004Kc']
> > >> uartlite@c00: $nodename:0: 'uartlite@c00' does not match '^serial(@.=
*)?$'
> > >>          From schema: /home/arinc9/Documents/linux/Documentation/dev=
icetree/bindings/serial/8250.yaml
> > >> uartlite@c00: Unevaluated properties are not allowed ('clock-names' =
was unexpected)
> > >>          From schema: /home/arinc9/Documents/linux/Documentation/dev=
icetree/bindings/serial/8250.yaml
> > >> sdhci@1e130000: $nodename:0: 'sdhci@1e130000' does not match '^mmc(@=
.*)?$'
> > >>          From schema: /home/arinc9/Documents/linux/Documentation/dev=
icetree/bindings/mmc/mtk-sd.yaml
> > >> sdhci@1e130000: Unevaluated properties are not allowed ('bus-width',=
 'cap-mmc-highspeed', 'cap-sd-highspeed', 'disable-wp', 'max-frequency', 'v=
mmc-supply', 'vqmmc-supply' were unexpected)
> > >>          From schema: /home/arinc9/Documents/linux/Documentation/dev=
icetree/bindings/mmc/mtk-sd.yaml
> > >> xhci@1e1c0000: $nodename:0: 'xhci@1e1c0000' does not match '^usb(@.*=
)?'
> > >>          From schema: /home/arinc9/Documents/linux/Documentation/dev=
icetree/bindings/usb/mediatek,mtk-xhci.yaml
> > >> xhci@1e1c0000: compatible: ['mediatek,mt8173-xhci'] is too short
> > >>          From schema: /home/arinc9/Documents/linux/Documentation/dev=
icetree/bindings/usb/mediatek,mtk-xhci.yaml
> > >> switch0@0: $nodename:0: 'switch0@0' does not match '^(ethernet-)?swi=
tch(@.*)?$'
> > >>          From schema: /home/arinc9/Documents/linux/Documentation/dev=
icetree/bindings/net/dsa/mediatek,mt7530.yaml
> > >> port@1: status:0: 'off' is not one of ['okay', 'disabled', 'reserved=
']
> > >>          From schema: /home/arinc9/.local/lib/python3.10/site-packag=
es/dtschema/schemas/dt-core.yaml
> > >> port@2: status:0: 'off' is not one of ['okay', 'disabled', 'reserved=
']
> > >>          From schema: /home/arinc9/.local/lib/python3.10/site-packag=
es/dtschema/schemas/dt-core.yaml
> > >> port@3: status:0: 'off' is not one of ['okay', 'disabled', 'reserved=
']
> > >>          From schema: /home/arinc9/.local/lib/python3.10/site-packag=
es/dtschema/schemas/dt-core.yaml
> > >>
> > >> - Remove "mips,mips1004Kc" compatible string from the cpu nodes. Thi=
s
> > >> doesn't exist anywhere.
> > >> - Change "memc: syscon@5000" to "memc: memory-controller@5000".
> > >> - Change "uartlite: uartlite@c00" to "serial0: serial@c00" and remov=
e the
> > >> aliases node.
> > >> - Remove "clock-names" from the serial0 node. The property doesn't e=
xist on
> > >> the 8250.yaml schema.
> > >> - Change "sdhci: sdhci@1e130000" to "mmc: mmc@1e130000".
> > >> - Change "xhci: xhci@1e1c0000" to "usb: usb@1e1c0000".
> > >> - Add "mediatek,mtk-xhci" as the second compatible string on the usb=
 node.
> > >> - Change "switch0: switch0@0" to "switch0: switch@0"
> > >> - Change "off" to "disabled" for disabled nodes.
> > >>
> > >> Remaining warnings are caused by the lack of json-schema documentati=
on.
> > >>
> > >> /cpuintc: failed to match any schema with compatible: ['mti,cpu-inte=
rrupt-controller']
> > >> /palmbus@1e000000/wdt@100: failed to match any schema with compatibl=
e: ['mediatek,mt7621-wdt']
> > >> /palmbus@1e000000/i2c@900: failed to match any schema with compatibl=
e: ['mediatek,mt7621-i2c']
> > >> /palmbus@1e000000/spi@b00: failed to match any schema with compatibl=
e: ['ralink,mt7621-spi']
> > >> /ethernet@1e100000: failed to match any schema with compatible: ['me=
diatek,mt7621-eth']
> > >>
> > >> Signed-off-by: Ar=C4=B1n=C3=A7 =C3=9CNAL <arinc.unal@arinc9.com>
> > >> ---
> > >>   .../boot/dts/ralink/mt7621-gnubee-gb-pc1.dts  |  2 +-
> > >>   .../boot/dts/ralink/mt7621-gnubee-gb-pc2.dts  |  2 +-
> > >>   arch/mips/boot/dts/ralink/mt7621.dtsi         | 32 +++++++--------=
----
> > >>   3 files changed, 14 insertions(+), 22 deletions(-)
> > >>
> > >> diff --git a/arch/mips/boot/dts/ralink/mt7621-gnubee-gb-pc1.dts b/ar=
ch/mips/boot/dts/ralink/mt7621-gnubee-gb-pc1.dts
> > >> index 24eebc5a85b1..6ecb8165efe8 100644
> > >> --- a/arch/mips/boot/dts/ralink/mt7621-gnubee-gb-pc1.dts
> > >> +++ b/arch/mips/boot/dts/ralink/mt7621-gnubee-gb-pc1.dts
> > >> @@ -53,7 +53,7 @@ system {
> > >>          };
> > >>   };
> > >>
> > >> -&sdhci {
> > >> +&mmc {
> > >>          status =3D "okay";
> > >>   };
> > >>
> > >> diff --git a/arch/mips/boot/dts/ralink/mt7621-gnubee-gb-pc2.dts b/ar=
ch/mips/boot/dts/ralink/mt7621-gnubee-gb-pc2.dts
> > >> index 34006e667780..2e534ea5bab7 100644
> > >> --- a/arch/mips/boot/dts/ralink/mt7621-gnubee-gb-pc2.dts
> > >> +++ b/arch/mips/boot/dts/ralink/mt7621-gnubee-gb-pc2.dts
> > >> @@ -37,7 +37,7 @@ key-reset {
> > >>          };
> > >>   };
> > >>
> > >> -&sdhci {
> > >> +&mmc {
> > >>          status =3D "okay";
> > >>   };
> > >>
> > >> diff --git a/arch/mips/boot/dts/ralink/mt7621.dtsi b/arch/mips/boot/=
dts/ralink/mt7621.dtsi
> > >> index ee46ace0bcc1..9302bdc04510 100644
> > >> --- a/arch/mips/boot/dts/ralink/mt7621.dtsi
> > >> +++ b/arch/mips/boot/dts/ralink/mt7621.dtsi
> > >> @@ -15,13 +15,11 @@ cpus {
> > >>
> > >>                  cpu@0 {
> > >>                          device_type =3D "cpu";
> > >> -                       compatible =3D "mips,mips1004Kc";
> > >>                          reg =3D <0>;
> > >>                  };
> > >>
> > >>                  cpu@1 {
> > >>                          device_type =3D "cpu";
> > >> -                       compatible =3D "mips,mips1004Kc";
> > >>                          reg =3D <1>;
> > >>                  };
> > >>          };
> > >
> > > Instead of removing this, since compatible is correct here, I think a
> > > cpus yaml file needs to be added to properly define mips CPU's but
> > > compatible strings using all around the sources are a bit messy. Take
> > > a look of how is this done for arm [0]
> >
> > I did investigate the arm bindings beforehand. I've seen that some of
> > the strings are also checked by code. I don't see the mips strings used
> > anywhere but DTs so I had decided to remove it here. I guess we can mak=
e
> > a basic binding to list the mips processor cores.
>
> At the very least I do think a compatible string should exist for cpu
> nodes :). And because of the mess with MIPS cpu nodes in dts files all
> around I think we should only add this 'compatible' as a requirement
> and mark 'reg' and 'device_type' as optionals.

I have just sent a patch to start from containing all compatible
strings I have found in the 'arch/mips/boot/dts' folder:

https://lore.kernel.org/linux-devicetree/20220915055514.463241-1-sergio.par=
acuellos@gmail.com/T/#u

>
> >
> > What do you think Thomas?
> >
> > >
> > >> @@ -33,11 +31,6 @@ cpuintc: cpuintc {
> > >>                  compatible =3D "mti,cpu-interrupt-controller";
> > >>          };
> > >>
> > >> -       aliases {
> > >> -               serial0 =3D &uartlite;
> > >> -       };
> > >> -
> > >> -
> > >>          mmc_fixed_3v3: regulator-3v3 {
> > >>                  compatible =3D "regulator-fixed";
> > >>                  regulator-name =3D "mmc_power";
> > >> @@ -110,17 +103,16 @@ i2c: i2c@900 {
> > >>                          pinctrl-0 =3D <&i2c_pins>;
> > >>                  };
> > >>
> > >> -               memc: syscon@5000 {
> > >> +               memc: memory-controller@5000 {
> > >>                          compatible =3D "mediatek,mt7621-memc", "sys=
con";
> > >>                          reg =3D <0x5000 0x1000>;
> > >>                  };
> > >>
> > >
> > > I think syscon nodes need to use 'syscon' in the node name, but I am
> > > not 100% sure.
> >
> > I've tested this patch series on my GB-PC2, it currently works fine.
> > Also, DT binding for MT7621 memory controller uses memory-controller on
> > the example so I guess it's fine?
>
> I know that works fine but when the node is a syscon it is good to
> have that syscon in the node name (I don't know if having it is a rule
> or something, I guess no). In any case I agree that binding and dts
> should match.
>
> Best regards,
>     Sergio Paracuellos
> >
> > Ar=C4=B1n=C3=A7

Best regards,
    Sergio Paracuellos
