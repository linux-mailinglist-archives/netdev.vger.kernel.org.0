Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C1446EBBE8
	for <lists+netdev@lfdr.de>; Sun, 23 Apr 2023 00:02:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbjDVWCZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Apr 2023 18:02:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbjDVWCX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Apr 2023 18:02:23 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB52A268B;
        Sat, 22 Apr 2023 15:02:22 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id 2adb3069b0e04-4eed6ddcae1so13075226e87.0;
        Sat, 22 Apr 2023 15:02:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682200941; x=1684792941;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=2dGkZFDJrBb5dcOlpUDOnjcit/4DMIiT8lgxh76O1Fc=;
        b=kTHd1OPTWLjdiO0sjUTsgDsPQL1IkmIscMklw6ifSCdcLo6jz6HVZaCkehqdfFJxFG
         AMPUWA+Epr+9/Ql6jnMBEwtlZG4pSii5meYGrWbjBv3tIST/7gX3zedg71xp+iISH/sI
         rIoBSs5bgzPGM5ZbfKj+DQrJbNyUlRAWwke104suSNtsyLWOJ0OnNVr3RawaLQWusvHZ
         MWrUDGHh+tSEqTwgGxF5i4ws48OkYKGldUM1TCUjCCSMbvc2OYbTybjHZgCpq6mzmGyY
         z+EZ3ZvNB3RGi+bCARx83XrUneR4kSh2a4wwdBsl7+tAr16G72fzh9DlVQIG5k7pwxig
         eHHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682200941; x=1684792941;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2dGkZFDJrBb5dcOlpUDOnjcit/4DMIiT8lgxh76O1Fc=;
        b=H6j/g4rlNJ1nfqhm/D9DfV4Kk26xx5dflIaDS4hOuiOSkaTHswvhJTPy1Jl6WiQX9R
         MImXu5n9Lm+t2Bbj6Zf+fcN+I4G7+m25sWO0hxPvAl3aSKEFMPemCbrecIv1C+II0GoR
         BjZiJ9KdS4m7BHyPyHiNvc92oAb98gFct6q6mbuSZCtcdZX57beOR7q1noLQ0gESqyRh
         orajGTIAluVHA1JLDqRnWZTJ5JouKihaT47E6WDGZ5uvWn+A/H5M5nKEG4HwYJx2xwrc
         UiWdSuEELi+4++u4CIRB74xwI7TrQyE9ezKPLYxGaYZZNVhlgM+9qyPnQuRwZbxIEIVZ
         vk1w==
X-Gm-Message-State: AAQBX9fxxMw++JvBmEKJll56ZpvBtUwP3GhzT6xDxnA+wYdHEa7FYLmL
        sswkXwgVtFnNz9lKPHiPvq5bjimTUibybWGq
X-Google-Smtp-Source: AKy350YyP9Mx6PKHYDySzsYS4Kng3481t/YYrpHXjc3ubrI6JKgUZryv6iZz/w3Cd/K9xjSzXPQgvA==
X-Received: by 2002:ac2:4c54:0:b0:4d8:86c1:4782 with SMTP id o20-20020ac24c54000000b004d886c14782mr4428578lfk.23.1682200940808;
        Sat, 22 Apr 2023 15:02:20 -0700 (PDT)
Received: from [100.119.4.164] (93-80-67-109.broadband.corbina.ru. [93.80.67.109])
        by smtp.gmail.com with ESMTPSA id w4-20020ac25d44000000b004eb0c51780bsm1043563lfd.29.2023.04.22.15.02.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Apr 2023 15:02:20 -0700 (PDT)
Message-ID: <38eff1f50343a576edd115be9283f6bd28bd2008.camel@gmail.com>
Subject: Re: [PATCH 3/4] net/ftgmac100: add mac-address-increment option for
 GMA command from NC-SI
From:   Ivan Mikhaylov <fr0st61te@gmail.com>
To:     Rob Herring <robh@kernel.org>
Cc:     Samuel Mendoza-Jonas <sam@mendozajonas.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paul Fertser <fercerpav@gmail.com>,
        openbmc@lists.ozlabs.org
Date:   Sun, 23 Apr 2023 01:02:17 +0000
In-Reply-To: <20230418185445.GA2111443-robh@kernel.org>
References: <20230413002905.5513-1-fr0st61te@gmail.com>
         <20230413002905.5513-4-fr0st61te@gmail.com>
         <20230418185445.GA2111443-robh@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2023-04-18 at 13:54 -0500, Rob Herring wrote:
> On Thu, Apr 13, 2023 at 12:29:04AM +0000, Ivan Mikhaylov wrote:
> > Add s32 mac-address-increment option for Get MAC Address command
> > from
> > NC-SI.
> >=20
> > Signed-off-by: Paul Fertser <fercerpav@gmail.com>
> > Signed-off-by: Ivan Mikhaylov <fr0st61te@gmail.com>
> > ---
> > =C2=A0Documentation/devicetree/bindings/net/ftgmac100.txt | 4 ++++
> > =C2=A01 file changed, 4 insertions(+)
> >=20
> > diff --git a/Documentation/devicetree/bindings/net/ftgmac100.txt
> > b/Documentation/devicetree/bindings/net/ftgmac100.txt
> > index 29234021f601..7ef5329d888d 100644
> > --- a/Documentation/devicetree/bindings/net/ftgmac100.txt
> > +++ b/Documentation/devicetree/bindings/net/ftgmac100.txt
> > @@ -22,6 +22,10 @@ Optional properties:
> > =C2=A0- use-ncsi: Use the NC-SI stack instead of an MDIO PHY. Currently
> > assumes
> > =C2=A0=C2=A0 rmii (100bT) but kept as a separate property in case NC-SI=
 grows
> > support
> > =C2=A0=C2=A0 for a gigabit link.
> > +- mac-address-increment: Increment the MAC address taken by GMA
> > command via
> > +=C2=A0 NC-SI. Specifies a signed number to be added to the host MAC
> > address as
> > +=C2=A0 obtained by the OEM GMA command. If not specified, 1 is used by
> > default
> > +=C2=A0 for Broadcom and Intel network cards, 0 otherwise.
>=20
> This would need to be common. There's been some attempts around how
> to=20
> support a base MAC address with a transform per instance. So far it's
> not clear that something in DT works for everyone. Until there's=20
> something common (if ever), you need platform specific code somewhere
> to=20
> handle this. The nvmem binding has had some extensions to support
> that.
>=20
> Rob

Rob, I agree but unfortunately there isn't a generic option for such
case, maybe something should be added into net/ethernet-
controller.yaml? As example, `mac-address-increment` option using
widely in openwrt project. About nvmem, are we talking `nvmem-cell-
names` option or reverse_mac_address in drivers/nvmem/imx-ocotp.c?

I'll do the transfer into DT schema, that's not a problem but after
naming resolve.

Adding openbmc community, maybe they have some ideas about this one.

Thanks.
