Return-Path: <netdev+bounces-3423-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 531D17070E7
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 20:38:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3A2E81C20F9E
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 18:38:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48D6131EE2;
	Wed, 17 May 2023 18:38:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A5A14420
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 18:38:08 +0000 (UTC)
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CDFB524E;
	Wed, 17 May 2023 11:38:05 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id 38308e7fff4ca-2ac89e6a5a1so11830611fa.0;
        Wed, 17 May 2023 11:38:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684348684; x=1686940684;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=FuipT8N9AIZhPuetrFCf6nkInGjCzh1d3K2+VTwrcZI=;
        b=gC+vtXyeAJ6dSdPO9ckA5gFbeFI6fhGGVE+IeeHLh/LIpDM3DveIKb2PnQypN3RyCI
         GfrhzjmpK1KfNaTuYgFK0AiYvAeNAQM2tB05rFKDaNFtuS6HyjITY7bNHQkaczRUo10E
         oSYee6FmENAWY0/rtA93xOVPTLBwIqbm+salh6EXh0oIQqRIlKIFNOrt/3F8+wRTF+9N
         lyo7L7pIuyoLah1EDY3ZNBdRbOI2jnalHE6bCfmTMzXspCtMt9OkIXr3jERyGocoVZ6Z
         NPj/L+zzFiprF7/Mq7m2YpzbTh+pRGQ1YAIGKDp1OnV+822undYgBeyjgdWWz2xL2L3r
         nAXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684348684; x=1686940684;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FuipT8N9AIZhPuetrFCf6nkInGjCzh1d3K2+VTwrcZI=;
        b=mFa/sx9XQn8Yu2saLDBQ+o12+bfvlJ9fzUOkUBjn5tX9dX6vssqjdgmjkL6zHft1ZN
         2ujyskQo16xFK+RBtX/EJ/Vi+xAgz5zTqdSeb0k653wmuRtE0S+Ua/7SrEQ5sH7pzBhY
         l9I7UiQfJ+pXnFafQXzKCJrnt6ekKvH/Co9bUz/zbCndEZkJGcgOiNGeYOL4NnOWCDlP
         PUSfLw5lkseztgwkFSKqkmmvUL6rBpZLlWe73dyY14K0p8bASqdaUDjlcn+fBeyAa60h
         vPGQ/Kz57qs0xJiY0C3FtnfdoM8RYvkThn2gDA3jRyIlCXnZUkz/m3Eb4Z76fHPXMj0T
         oNlQ==
X-Gm-Message-State: AC+VfDz6AjiSMzdmiJfFGtqixz4j6fp5zHYzjDzpTg7ruDf6zyqE+hRy
	bbGap5mUDYgt+WVzEFOL4Ag=
X-Google-Smtp-Source: ACHHUZ6aSd8ko9LwiT1p/Y4sOJtZSnY3Z/munJAXGrvF4WuL83R/fb4/bH+qI5hWg4SkULozraJtkQ==
X-Received: by 2002:a2e:800a:0:b0:2a7:96bd:9eb3 with SMTP id j10-20020a2e800a000000b002a796bd9eb3mr10581246ljg.3.1684348683477;
        Wed, 17 May 2023 11:38:03 -0700 (PDT)
Received: from [100.119.125.242] (95-31-187-187.broadband.corbina.ru. [95.31.187.187])
        by smtp.gmail.com with ESMTPSA id t20-20020ac25494000000b004db0d26adb4sm3451405lfk.182.2023.05.17.11.38.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 May 2023 11:38:02 -0700 (PDT)
Message-ID: <5d7421b6a419a9645f97e6240b1dfbf47ffcab4e.camel@gmail.com>
Subject: Re: [PATCH v2 3/5] dt-bindings: net: add mac-address-increment
 option
From: Ivan Mikhaylov <fr0st61te@gmail.com>
To: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>, Samuel
 Mendoza-Jonas <sam@mendozajonas.com>, "David S . Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
 <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Rob Herring
 <robh+dt@kernel.org>, Krzysztof Kozlowski
 <krzysztof.kozlowski+dt@linaro.org>
Cc: netdev@vger.kernel.org, devicetree@vger.kernel.org, 
	linux-kernel@vger.kernel.org, openbmc@lists.ozlabs.org, Paul Fertser
	 <fercerpav@gmail.com>
Date: Wed, 17 May 2023 21:38:02 +0000
In-Reply-To: <38ae4ceb-da21-d73e-9625-1918b4ab4e16@linaro.org>
References: <20230509143504.30382-1-fr0st61te@gmail.com>
	 <20230509143504.30382-4-fr0st61te@gmail.com>
	 <6b5be71e-141e-c02a-8cba-a528264b26c2@linaro.org>
	 <fc3dae42f2dfdf046664d964bae560ff6bb32f69.camel@gmail.com>
	 <8de01e81-43dc-71af-f56f-4fba957b0b0b@linaro.org>
	 <be85bef7e144ebe08f422bf53bb81b59a130cb29.camel@gmail.com>
	 <5b826dc7-2d02-d4ed-3b6a-63737abe732b@linaro.org>
	 <e6247cb39cc16a9328d9432e0595745b67c0aed5.camel@gmail.com>
	 <38ae4ceb-da21-d73e-9625-1918b4ab4e16@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.1 
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, 2023-05-17 at 10:36 +0200, Krzysztof Kozlowski wrote:
> On 16/05/2023 13:47, Ivan Mikhaylov wrote:
> hy this is property of the hardware. I
> > > > > understand
> > > > > that this is something you want Linux to do, but DT is not
> > > > > for
> > > > > that
> > > > > purpose. Do not encode system policies into DT and what above
> > > > > commit
> > > > > says is a policy.
> > > > >=20
> > > >=20
> > > > Krzysztof, okay then to which DT subsystem it should belong? To
> > > > ftgmac100 after conversion?
> > >=20
> > > To my understanding, decision to add some numbers to MAC address
> > > does
> > > not look like DT property at all. Otherwise please help me to
> > > understand
> > > - why different boards with same device should have different
> > > offset/value?
> > >=20
> > > Anyway, commit msg also lacks any justification for this.
> > >=20
> > > Best regards,
> > > Krzysztof
> > >=20
> >=20
> > Krzysztof, essentially some PCIe network cards have like an
> > additional
> > *MII interface which connects directly to a BMC (separate SoC for
> > managing a motherboard) and by sending special ethernet type frames
> > over that connection (called NC-SI) the BMC can obtain MAC, get
> > link
> > parameters etc. So it's natural for a vendor to allocate two MACs
> > per
> > such a board with PCIe card intergrated, with one MAC "flashed
> > into"
> > the network card, under the assumption that the BMC should
>=20
> Who makes the assumption that next MAC should differ by 1 or 2?

Krzysztof, in this above case BMC does, BMC should care about changing
it and doing it with current codebase without any options just by some
hardcoded numbers which is wrong.

>=20
> > automatically use the next MAC. So it's the property of the
> > hardware as
> > the vendor designs it, not a matter of usage policy.
> >=20
> > Also at the nvmem binding tree is "nvmem-cell-cells" which is
> > literally
> > the same as what was proposed but on different level.
> >=20
> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/comm=
it/Documentation/devicetree/bindings/nvmem?id=3D7e2805c203a6c8dc85c1cfda205=
161ed39ae82d5
>=20
> How is this similar? This points the location of mac address on some
> NV
> storage. You add fixed value which should be added to the Ethernet.

It's not the points the location, this particular option provides this
increment for mac addresses to make use of them with multiple
interfaces. Just part of above commit:
"It's used as a base for calculating addresses for multiple interfaces.
It's done by adding proper values. Actual offsets are picked by
manufacturers and vary across devices."

It is same as we talked before about mac-address-increment in openwrt
project, if you want examples, you can look into their github. And same
as we trying to achieve here.

https://github.com/openwrt/openwrt/blob/master/target/linux/generic/pending=
-5.15/682-of_net-add-mac-address-increment-support.patch

"Lots of embedded devices use the mac-address of other interface
extracted from nvmem cells and increments it by one or two. Add two
bindings to integrate this and directly use the right mac-address for
the interface. Some example are some routers that use the gmac
mac-address stored in the art partition and increments it by one for
the
wifi. mac-address-increment-byte bindings is used to tell what byte of
the mac-address has to be increased (if not defined the last byte is
increased) and mac-address-increment tells how much the byte decided
early has to be increased."

Don't you see similarity with nvmem commit?

>=20
> I might be missing the context but there is no DTS example nor user
> of
> this property, so how can I get such?
>=20

I don't see it either in linux kernel DTS tree but it in DTS doc.

Also, just a little bit history about older propositions
https://lore.kernel.org/all/?q=3Dmac-address-increment
https://lore.kernel.org/all/20200919214941.8038-5-ansuelsmth@gmail.com/


Thanks.



