Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8159961842F
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 17:22:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231524AbiKCQWM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 12:22:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230261AbiKCQWF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 12:22:05 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27EB11AD85;
        Thu,  3 Nov 2022 09:22:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1667492521; x=1699028521;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=qiUgXNzS+MR1W5sNXGtCf0GXUaMffr26QOJN1t6Q660=;
  b=VjEsPt9Qy0foq4A/G8Mi6yS59jJvaM2Y8b/Ybe3PM9085uzO+v32Hmm8
   7r55YVJ+eTcb+8mkxbhMbVUaNZatR46ll67cQY1Tnj7wZ0TKI6IEhJKTn
   AZAxJMhali9/Uzj5+mOCaL4ddWk97WUd+J/QpMAR3fGXGeKkNHZL/Yrr1
   PXNQsItzyv7j8Wk85FdW35vB9IqNLoXXQbywDJ+WjT8aovetznV/J4n54
   8vCMEVLYP9xBF3tnKMp/SRLrPhtPMod+Aeyhak1uTSp5Kx7/qF45lpr6j
   SNafFyfaYv7UlHbUvAs1uZ87fah7Ll0YL9Lz/TlDg6phJscaJo9SZj52A
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,134,1665471600"; 
   d="scan'208";a="198285202"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 03 Nov 2022 09:22:00 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Thu, 3 Nov 2022 09:22:01 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Thu, 3 Nov 2022 09:21:57 -0700
Message-ID: <4abec500cb037ca24be496aeaf4355f51a463b69.camel@microchip.com>
Subject: Re: [PATCH net-next v2 2/5] net: microchip: sparx5: Adding more tc
 flower keys for the IS2 VCAP
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Casper Andersson <casper.casan@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        <UNGLinuxDriver@microchip.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        "Wan Jiabing" <wanjiabing@vivo.com>,
        Nathan Huckleberry <nhuck@google.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Daniel Machon <daniel.machon@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Jiri Pirko <jiri@resnulli.us>
Date:   Thu, 3 Nov 2022 17:21:57 +0100
In-Reply-To: <20221102182843.6d14c7ed@kernel.org>
References: <20221028144540.3344995-1-steen.hegelund@microchip.com>
         <20221028144540.3344995-3-steen.hegelund@microchip.com>
         <20221031103747.uk76tudphqdo6uto@wse-c0155>
         <51622bfd3fe718139cece38493946c2860ebdf77.camel@microchip.com>
         <20221031184128.1143d51e@kernel.org>
         <741b628857168a6844b6c2e0482beb7df9b56520.camel@microchip.com>
         <20221101084925.7d8b7641@kernel.org>
         <e9d662682b00a976ad1dedf361a18b5f28aac8fb.camel@microchip.com>
         <20221102182843.6d14c7ed@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.1 
MIME-Version: 1.0
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jacub,

On Wed, 2022-11-02 at 18:28 -0700, Jakub Kicinski wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know th=
e
> content is safe
>=20
> On Wed, 2 Nov 2022 14:11:37 +0100 Steen Hegelund wrote:
> > I have sent a version 4 of the series, but I realized after sending it,=
 that
> > I
> > was probably not understanding the implications of what you were saying
> > entirely.
> >=20
> > As far as I understand it now, I need to have a matchall rule that does=
 a
> > goto
> > from chain 0 (as this is where all traffic processing starts) to my fir=
st
> > IS2
> > VCAP chain and this rule activates the IS2 VCAP lookup.
> >=20
> > Each of the rules in this VCAP chain need to point to the next chain et=
c.
> >=20
> > If the matchall rule is deleted the IS2 VCAP lookups should be disabled=
 as
> > there
> > is no longer any way to reach the VCAP chains.
> >=20
> > Does that sound OK?
>=20
> It does as far as I understand.
>=20
> I haven't grasped what the purpose of using multiple chains is in
> case of your design. IIRC correctly other drivers use it for instance
> to partition TCAMs with each chain having a different set of fields it
> can match on. But I don't see templates used in sparx5.

Yes, so far I have only added the IS2 VCAP, but there are 3 more that I am
planning to to add, and they have very different capabilities in terms of k=
eys
and actions, so I think it makes good sense to keep them in separate chains=
.

>=20
> In general in TC offloads you can reject any configuration you can't
> (or choose not to) support, and make up your own constraints (e.g. only
> specific priority or chain values are supported).

Understood.

>=20
> But for a "target" ruleset, i.e. ruleset comprised fully of rules you
> do offload - the behavior of executing that ruleset in software and in
> the device must be the same.
>=20
> Dunno if that helps :)

It does, thanks!

I been fireing up a QEMU instance so I have been able to test my understand=
ing,
and it looks like I now have the same experience when I test the same rule =
there
and in the hardware of Sparx5.

BR
Steen

