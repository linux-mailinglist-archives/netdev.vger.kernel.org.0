Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F361B6B5915
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 07:49:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229827AbjCKGt2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 01:49:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjCKGt1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 01:49:27 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45593124E8E;
        Fri, 10 Mar 2023 22:49:26 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id p4so787254wre.11;
        Fri, 10 Mar 2023 22:49:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678517365;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=t9Sei6I41qwaNDpvUvee9z5C91oyEDGNKLdeZYKLxNI=;
        b=edANvY7i593vAONZaHOUC5NiTyvSEIOaEbRI65vr3O9TxYv0ucfrHbTN/3kKRE+Tkj
         kTzD5JZupdMhbGi/9AnNNPmHiuE08jI/tDmN55s78utBRjPSG+l0RbEZnCYPcGD+Tz1T
         70SRtuq64yUALwEsep5xNXJc6oI5P3t6w/o40wW1OTAPugx9zilfGYPK0knap2c0m2im
         5Z/9gQAteGMZ+0W210gckbP716ypWMyoR+YjhAkCz7XgEa42CNrLjViIRviq6sj4NPdo
         QyuS+vIB0RIRQYRmiUSeCbnb6/CwiOy5Ih0xqHu+CFxbOLzMgGWScerqv1Gusqg8th2l
         zYaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678517365;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=t9Sei6I41qwaNDpvUvee9z5C91oyEDGNKLdeZYKLxNI=;
        b=n7CfY1O6iP7tzscgWDLZq8nATgRf0P+Zg9a4ptPAFWqVtu3XBkEjVycagqRYqNCXKB
         D7Ixwf0oOG5uwsIuduaNEbEI9ERFBQF+ROWPuLll32FT8i1xLZeg2KP7vM+OYls43k0V
         2llxwLfFKq7rw13DDkbpp60Vlf1HCGKUYctoubD2lkd6e77QGL2MkN+cvf9zRpZsLFqj
         +srshrXnTl3Y2Q9sjPKFBuE7V/n+PQK1nhs7HQiBZB6APwwlGFXjE77shPg3e9ihDpKr
         L4+AJGGCG+JSC7Ek+r9L2HL9ykRZcdbZ2GfP8Icy5ZKRK2+emeHSSaAU1ZJwZXIlL1U6
         +CFQ==
X-Gm-Message-State: AO0yUKWZsUfUzuxeKs2NT1cbLg1pehyUfGBZcChhOeAf9qFYbHNK9pvR
        w87YyJMrMsl2thplLUK57ig=
X-Google-Smtp-Source: AK7set/JPr6Wq2tfBtyFn0d5vMSSusNpNT1n3m5tdIocxlx8YgFkE6JLYZ5AoEW5KjyXe2yJU0ieQQ==
X-Received: by 2002:a5d:4a8c:0:b0:2c7:d7ca:4c88 with SMTP id o12-20020a5d4a8c000000b002c7d7ca4c88mr18447829wrq.55.1678517364619;
        Fri, 10 Mar 2023 22:49:24 -0800 (PST)
Received: from ?IPv6:2a02:168:6806:0:c51d:786:86a8:fd19? ([2a02:168:6806:0:c51d:786:86a8:fd19])
        by smtp.gmail.com with ESMTPSA id l2-20020a5d4bc2000000b002c57475c375sm1584656wrt.110.2023.03.10.22.49.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Mar 2023 22:49:24 -0800 (PST)
Message-ID: <bff0e542b8c04980e9e3af1d3e6bf739c87eb514.camel@gmail.com>
Subject: Re: [PATCH net-next v2 4/6] net: mdio: scan bus based on bus
 capabilities for C22 and C45
From:   Klaus Kudielka <klaus.kudielka@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Michael Walle <michael@walle.cc>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Felix Fietkau <nbd@nbd.name>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Joel Stanley <joel@jms.id.au>,
        Andrew Jeffery <andrew@aj.id.au>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-aspeed@lists.ozlabs.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Date:   Sat, 11 Mar 2023 07:49:23 +0100
In-Reply-To: <4abd56aa-5b9f-4e16-b0ca-11989bb8c764@lunn.ch>
References: <20230116-net-next-remove-probe-capabilities-v2-4-15513b05e1f4@walle.cc>
         <449bde236c08d5ab5e54abd73b645d8b29955894.camel@gmail.com>
         <100c439a-2a4d-4cb2-96f2-5bf273e2121a@lunn.ch>
         <712bc92ca6d576f33f63f1e9c2edf0030b10d3ae.camel@gmail.com>
         <db6b8a09-b680-4baa-8963-d355ad29eb09@lunn.ch>
         <0e10aa8492eadb587949d8744b56fccaabbd183b.camel@gmail.com>
         <72530e86-9ba9-4a01-9cd2-68835ecae7a0@lunn.ch>
         <09d65e1ee0679e1e74b4f3a5a4c55bd48332f043.camel@gmail.com>
         <70f5bca0-322c-4bae-b880-742e56365abe@lunn.ch>
         <10da10caea22a8f5da8f1779df3e13b948e8a363.camel@gmail.com>
         <4abd56aa-5b9f-4e16-b0ca-11989bb8c764@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4-1 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2023-03-11 at 00:49 +0100, Andrew Lunn wrote:
> > Yes, that helps. Primarily, because mdiobus_scan_bus_c45 now is called =
only once,
> > and at least some things are done in parallel.
>=20
> Great. Could you cook up a proper patch and submit it?

I can give it a try. The commit message will be from my perspective,
and the change Suggested-By you.

Best regards, Klaus
