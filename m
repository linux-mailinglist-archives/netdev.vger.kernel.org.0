Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A59B6630D3C
	for <lists+netdev@lfdr.de>; Sat, 19 Nov 2022 09:18:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232318AbiKSISs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Nov 2022 03:18:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232171AbiKSISq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Nov 2022 03:18:46 -0500
Received: from mail-yw1-x1129.google.com (mail-yw1-x1129.google.com [IPv6:2607:f8b0:4864:20::1129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3D6D5F858
        for <netdev@vger.kernel.org>; Sat, 19 Nov 2022 00:18:43 -0800 (PST)
Received: by mail-yw1-x1129.google.com with SMTP id 00721157ae682-3691e040abaso70009557b3.9
        for <netdev@vger.kernel.org>; Sat, 19 Nov 2022 00:18:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mjyF9GZRbjnKvRIu6G5HCxPcIESHSZ+tBu/Yu/REEs4=;
        b=eyXCEckvHE06z2dtwRm4PcFouCfPbIuLakCBQ9vvDMvBMRmny/HmbxE8OPH2X6KuXL
         +/Yy/OCjAv/7K4K7yKYwHq/RqeulHdbCV6sgJozK0whr/IRu5ykRk9tzmDQgj3TFEswf
         vR0GY2SfZQa5kmbgkaFwE0180whk0dDyUac9GBW9jdmfF1FAjbO48ckdX7WUvTOXn/zI
         GmB9BOW3pYn1woKsphcqan+U3dtIMR+lMGi4FqMW1+aIV7pKeSlDvsVq4h/pfs5bPfVp
         4T69uS0vaax/fUgrDYm6TJKcN4F29DKbk8Khc9VQRrZTWLptStqHtP62kyAILSuk2t3+
         Gr2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mjyF9GZRbjnKvRIu6G5HCxPcIESHSZ+tBu/Yu/REEs4=;
        b=4J9balx5ZfdQtQkJluHFZtpEKZ8gWkRpfh/tzTJIl/ji6uVlm3YQbwZQczbx08KueD
         QfFU0XA/XplZtXhuLNrVY6RM01ltvvvopqV5UhfJkj3kgj4cg9eIB5aIauYQlgiBrUBz
         ybfU0KTNSOr0hmN97cKkf63KlCZSLST7F4r66oFYxgXIpE7mLdRn9CQFkXJMxonpIf2l
         ghH80WiuYjkmlvHCY6713/vfUHAuX3MJr964ZrnR1axnAVUjYx2LYQBE1yu3t7qT7QqT
         qQSbtcYyoB3Ss/K/gT6i3WoXsDUPTxzHEHFbGXzjWX4EqMx1Zh2KqkyuWC7qkjJrM7/i
         cPZA==
X-Gm-Message-State: ANoB5plqPAGg4hoPyiU1hV/6NQev6T35RRgF1MW+G2o+YMino6L+agug
        mOJ4NI2SkquircixaL/sPHGgcum1gybme+l6BqO2kQ==
X-Google-Smtp-Source: AA0mqf5ESgrsqCSEYIFRooYNeokCRBJg7PLLMWGi6CC/opzLtX1pTKtPKCaOn6zZrUtQJQ3HSdg5ZMRUFcJhzJfs3lc=
X-Received: by 2002:a0d:ea05:0:b0:368:52a0:9173 with SMTP id
 t5-20020a0dea05000000b0036852a09173mr9566915ywe.191.1668845922812; Sat, 19
 Nov 2022 00:18:42 -0800 (PST)
MIME-Version: 1.0
References: <20221117215557.1277033-1-miquel.raynal@bootlin.com> <20221117215557.1277033-7-miquel.raynal@bootlin.com>
In-Reply-To: <20221117215557.1277033-7-miquel.raynal@bootlin.com>
From:   Marcin Wojtas <mw@semihalf.com>
Date:   Sat, 19 Nov 2022 09:18:34 +0100
Message-ID: <CAPv3WKdZ+tsW-jRJt_n=KqT+oEe+5QAEFOWKrXsTjHCBBzEh0A@mail.gmail.com>
Subject: Re: [PATCH net-next 6/6] net: mvpp2: Consider NVMEM cells as possible
 MAC address source
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        devicetree@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Taras Chornyi <tchornyi@marvell.com>,
        linux-kernel@vger.kernel.org,
        Robert Marko <robert.marko@sartura.hr>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Michael Walle <michael@walle.cc>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Miquel,


czw., 17 lis 2022 o 22:56 Miquel Raynal <miquel.raynal@bootlin.com> napisa=
=C5=82(a):
>
> The ONIE standard describes the organization of tlv (type-length-value)
> arrays commonly stored within NVMEM devices on common networking
> hardware.
>
> Several drivers already make use of NVMEM cells for purposes like
> retrieving a default MAC address provided by the manufacturer.
>
> What made ONIE tables unusable so far was the fact that the information
> where "dynamically" located within the table depending on the
> manufacturer wishes, while Linux NVMEM support only allowed statically
> defined NVMEM cells. Fortunately, this limitation was eventually tackled
> with the introduction of discoverable cells through the use of NVMEM
> layouts, making it possible to extract and consistently use the content
> of tables like ONIE's tlv arrays.
>
> Parsing this table at runtime in order to get various information is now
> possible. So, because many Marvell networking switches already follow
> this standard, let's consider using NVMEM cells as a new valid source of
> information when looking for a base MAC address, which is one of the
> primary uses of these new fields. Indeed, manufacturers following the
> ONIE standard are encouraged to provide a default MAC address there, so
> let's eventually use it if no other MAC address has been found using the
> existing methods.
>
> Link: https://opencomputeproject.github.io/onie/design-spec/hw_requiremen=
ts.html

Thanks for the patch. Did you manage to test in on a real HW? I am curious =
about

> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> ---
>  drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/ne=
t/ethernet/marvell/mvpp2/mvpp2_main.c
> index eb0fb8128096..7c8c323f4411 100644
> --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> @@ -6104,6 +6104,12 @@ static void mvpp2_port_copy_mac_addr(struct net_de=
vice *dev, struct mvpp2 *priv,
>                 }
>         }
>
> +       if (!of_get_mac_address(to_of_node(fwnode), hw_mac_addr)) {

Unfortunately, nvmem cells seem to be not supported with ACPI yet, so
we cannot extend fwnode_get_mac_address - I think it should be,
however, an end solution.

As of now, I'd prefer to use of_get_mac_addr_nvmem directly, to avoid
parsing the DT again (after fwnode_get_mac_address) and relying
implicitly on falling back to nvmem stuff (currently, without any
comment it is not obvious).

Best regards,
Marcin

> +               *mac_from =3D "nvmem cell";
> +               eth_hw_addr_set(dev, hw_mac_addr);
> +               return;
> +       }
> +
>         *mac_from =3D "random";
>         eth_hw_addr_random(dev);
>  }
> --
> 2.34.1
>
