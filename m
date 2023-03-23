Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E201C6C7138
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 20:43:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231285AbjCWTm6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 15:42:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230502AbjCWTm5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 15:42:57 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24ABD199FB;
        Thu, 23 Mar 2023 12:42:56 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id b18so7171766ybp.1;
        Thu, 23 Mar 2023 12:42:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679600575;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/N6JE9fQcOhbH6T3t/i6aYEoQ51saYDZikfmtE4CaI4=;
        b=k5KFd0+yeGk9fW2K/xokmOVu4NQZaF/lBl97OxvbRvuceiXBJUgKBc1TX2s+xkpWCI
         4X0ufsPNKK0MZq6Xdpro07uIuKePf99dhzsm1+DAQZyDeP+5j5CtgZcE+Bawq6inZzuY
         SO73fIjb1/sA1Dt5s5tEQAMzj5ggfjGTIhRkjVYn0ryDNSEQGxIllp1krCjxuMXxgXPs
         4maV7qtwJAhou2NL1VgjpKR5F4xUk1ARlq6JYBnL9wJcKTakMt01PcHOiRSeCY+7rZd7
         ZFYnxU1UpwI1TXPeXVxUelybOs8UlTs4zTL3hnZmXGobxtqd1bHYwbaONIJQP0ZpDoIh
         BLBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679600575;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/N6JE9fQcOhbH6T3t/i6aYEoQ51saYDZikfmtE4CaI4=;
        b=cSNU7N2YTb2Ua3ncMIWzqSS/2Vsjga7Dc9vFIek+Auzl+kt6eSASfe7PG1paZl/fg0
         xIrxPoUml8AAEPXQf/2V4QE6ei55PMuWhS53SIBGNVXdfqCU01pZH8e/o7LJY9UBuq2w
         jYyQQakSKcveTKKv3JSKlFTeZ6SmZS+Z7kBQfs0kljOeMtdgwFxz4tGFP/I5/7wCMrrO
         V94idRdU+TchGkUkRMn8hMNcBxQC1eV7hXm919S2YeMqun+XvdrUcVG9sEHZFsTg9cUn
         FEalSoVw5YKjslWTb0ejmASebU6CMWRIBKe9ECHTJmZrq0AhbgSk+4bMZpuG4OuaVykE
         LmZA==
X-Gm-Message-State: AAQBX9cNQuOdPiXV6nH8T/NmhtQwaUFMpjyRtL0vk8MgeryL8AEHHOyJ
        s+uPgNw5iUXwkZXuDwmMRP7pSz67E/HyuhSp6EzkIHUjltJU3g==
X-Google-Smtp-Source: AKy350bEuogbud2y4d4QzIhfKuQXyC4PqTRGhyLsFg1qH4UbsAqftR0hbyr0uiT53fv8OGz+B0zWOGgIDGvNjgvfESM=
X-Received: by 2002:a05:6902:a8e:b0:b6c:2d28:b3e7 with SMTP id
 cd14-20020a0569020a8e00b00b6c2d28b3e7mr2994556ybb.9.1679600575010; Thu, 23
 Mar 2023 12:42:55 -0700 (PDT)
MIME-Version: 1.0
References: <20230323170238.210687-1-noltari@gmail.com> <95eb709c-a91f-4390-30b2-9e81e4534e20@gmail.com>
In-Reply-To: <95eb709c-a91f-4390-30b2-9e81e4534e20@gmail.com>
From:   =?UTF-8?B?w4FsdmFybyBGZXJuw6FuZGV6IFJvamFz?= <noltari@gmail.com>
Date:   Thu, 23 Mar 2023 20:42:44 +0100
Message-ID: <CAKR-sGd2oi9jpAG=X1n5JgnC0RR1u1w9vkrDsfeTB7u5OhWXug@mail.gmail.com>
Subject: Re: [PATCH 0/1] net: dsa: b53: mmap: add dsa switch ops
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     jonas.gorski@gmail.com, andrew@lunn.ch, olteanv@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux@armlinux.org.uk, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

El jue, 23 mar 2023 a las 19:19, Florian Fainelli
(<f.fainelli@gmail.com>) escribi=C3=B3:
>
> On 3/23/23 10:02, =C3=81lvaro Fern=C3=A1ndez Rojas wrote:
> > B53 MMAP switches have a MDIO Mux bus controller which should be used i=
nstead
> > of the default phy_read/phy_write ops used in the rest of the B53 contr=
ollers.
> > Therefore, in order to use the proper MDIO Mux bus controller we need t=
o
> > replicate the default B53 DSA switch ops removing the phy_read/phy_writ=
e
> > entries.
>
> Did you try to implement b53_mmap_ops::phy_read16/phy_write16 and have
> them return -EIO such that you do not fallback to the else path:

Actually I tried -EINVAL and it didn't work, but I've just tried -EIO
and it works!
Many thanks for the suggestion!

I will send another patch adding phy_read/write ops and returning
-EIO, so please ignore this patch and sorry for the noise, but it took
a while until we reached a good solution for this :(...

>
>                    ret =3D b53_read16(priv, B53_PORT_MII_PAGE(addr),
>                                     reg * 2, &value);
>
> The reason for the hang I believe is because the B53_PORT_MII_PAGE is
> simply not mapped into the switch register space, and there is no logic
> within the switch block to return an error when you read at that invalid
> location.
>
> Re-implementing dsa_switch_ops is usually done when you have a very
> different switch integration logic, ala bcm_sf2, here it seems a bit of
> a tall order for simply not using the phy_read16/phy_write16 functions.
> --
> Florian
>

--
=C3=81lvaro
