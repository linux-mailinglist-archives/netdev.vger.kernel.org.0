Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 437806016A5
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 20:52:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230352AbiJQSwE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 14:52:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229911AbiJQSwC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 14:52:02 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61A6673C1E;
        Mon, 17 Oct 2022 11:52:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1666032721; x=1697568721;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=E/tkw8Tm/gZ2KRFhNxXlkmeVvOJaZ5nf+Q39n83pRQs=;
  b=kTO+TwY1bKvEW3wNWTT3IMgq4T7UkhCP4LrVtAJl48sOYQdTQBwSkXVR
   Y/gZ8KO7Pup48rsJmoSotloz2+gVrKp1bn0/yjlTDrQ7FBQTQZxCbAkOo
   Xh1aO4HidBpbMtjaoN4B7C1NDNGP4XuFgjH7FPqXVF3pbdCeEJx0kWGfG
   28pp+aqIIAjydoXeil8cnGHmzE7VWj9E/h6d07pdW+ItZip0jRcEL61/m
   KhXm76cR8aIPr3cpBW2hc1vaLAgcJVNmIsU3JnOq7KlbXOVc+6uLvFEfv
   y1FzVoNRXBqGea54Fx2AYXczCEOWO1ixuvPrd+f4BK6UTNPjnc5/hnhUn
   w==;
X-IronPort-AV: E=Sophos;i="5.95,192,1661842800"; 
   d="scan'208";a="185221889"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Oct 2022 11:52:00 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Mon, 17 Oct 2022 11:52:00 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12 via Frontend Transport; Mon, 17 Oct 2022 11:52:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I2kWkMdSagv4daUEkGpIxTVTYM7smFBaGMA2SIbgnKLCwHYKNMmFE1fQR/Kvp0ld2hd5pbUOqKCahOzOeeB+PHC4JA+qmwwaOfuYa6CRUDeY/DXGj6n4A+nNBCXwx1ITet+SGrztA9KejHtsaJt+XtcKulUopCOznlxTAd5d4Wp7Fb5sr5GqoHHvdlj6rp7D1ky0ce/SZc54MT17FOvTSsRvcXheb2QXcLXIKh4okM4n1460jDkJ1QL5BVxHm5VTzlQvFZ/MwstKfxt2+sHM6DYmpUBrpy6xlm9s/H/DFvOnpU1JZtciSvSjmDPXVbgSJKyvYGI+dFASK0vUhfsdwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rq7crhTWbfp/+hOXORi1UR/ShV19DTis+g7iKNuud8Y=;
 b=lpGhIobi8Dp3HJB261qqpjXMDykvaNvQdsz3wSrL9BVwu0d7O7UoggNmGywA/KqWcOGqQDAEWvyYGGywMD9MQuqR8yyEpXE+asfYIl1JdxsUuey1U/g4Ay7f+HzTVngHGgUO1rdw9t/zvACmWGDgPCbpR5aqmCRbNpdpf0223/wUvNSAZWx1Oj+HUXu8a7ihRPkf821WCX71TSyPHeEQRkU8uyjLIcIZ3d6K+uxWSGf7iVO6MSiR+9U/4F9bDqrdNsSPkD0CdvOXh6JcuCiKRTZblOU9BF0EbX9wQ7Ik6+UkNTP+9nBeRt13ndxBAdnyWtGvw1P2Bn7qOzTwA7aJXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rq7crhTWbfp/+hOXORi1UR/ShV19DTis+g7iKNuud8Y=;
 b=sp7Xc2nko6SJ/Qn6h3NpQXrxr7MatHJ+6wA91yUXgdFA67OVfSctLKCToaXl7U4ARh3qr7FYaSWd5ADTxdZ/cmyPiGl30KAKqAjHd7bLWAUghfMACja4MljCvjqDmS5Oqv7xtkTLzZGH3sd+B1yeY716YbDiHiqkbY7sY7nzTsc=
Received: from MWHPR11MB1693.namprd11.prod.outlook.com (2603:10b6:300:2b::21)
 by SN7PR11MB7042.namprd11.prod.outlook.com (2603:10b6:806:299::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.32; Mon, 17 Oct
 2022 18:51:57 +0000
Received: from MWHPR11MB1693.namprd11.prod.outlook.com
 ([fe80::6599:7b75:c033:afcd]) by MWHPR11MB1693.namprd11.prod.outlook.com
 ([fe80::6599:7b75:c033:afcd%12]) with mapi id 15.20.5723.033; Mon, 17 Oct
 2022 18:51:57 +0000
From:   <Jerry.Ray@microchip.com>
To:     <olteanv@gmail.com>, <krzysztof.kozlowski@linaro.org>
CC:     <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <robh+dt@kernel.org>, <krzysztof.kozlowski+dt@linaro.org>,
        <UNGLinuxDriver@microchip.com>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: RE: [net-next][PATCH v4] dt-bindings: dsa: Add lan9303 yaml
Thread-Topic: [net-next][PATCH v4] dt-bindings: dsa: Add lan9303 yaml
Thread-Index: AQHY10fB8CyYFFC0ckOeRLuaLwivma4FI+pagAESu4CAAHYogIAAyUsAgAABoQCAC4wNgA==
Date:   Mon, 17 Oct 2022 18:51:57 +0000
Message-ID: <MWHPR11MB16938D7BA12C1632FF675C0AEF299@MWHPR11MB1693.namprd11.prod.outlook.com>
References: <20221003164624.4823-1-jerry.ray@microchip.com>
 <20221003164624.4823-1-jerry.ray@microchip.com>
 <20221008225628.pslsnwilrpvg3xdf@skbuf>
 <e49eb069-c66b-532c-0e8e-43575304187b@linaro.org>
 <20221009222257.f3fcl7mw3hdtp4p2@skbuf>
 <551ca020-d4bb-94bf-7091-755506d76f58@linaro.org>
 <20221010102914.ut364d57sjhnb3lj@skbuf>
In-Reply-To: <20221010102914.ut364d57sjhnb3lj@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MWHPR11MB1693:EE_|SN7PR11MB7042:EE_
x-ms-office365-filtering-correlation-id: 2800b00e-73f7-4956-a9ec-08dab070aafa
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: g2VukfNm+SG/VzXnMZaVAgsksQQf1SENZqqZ0wDvNTCMDjHA6ifc00zsUB4xeSnJhP7vGHszAyL/xvgrVh/0gGb1FNk5UaWZpSbzHWG1IbkV6e7i2HfJHk/HnMOQefj/aP6+94u7AeWITQLJj+uFP1HB05hm124ekCMJPJWYVKzO+Ae+vK/rrgDqPHh4HrpUyvMRdQ67Ji+MlPaXbCRHfoWdGvu5OF4hNecgQpSwdh6trcjNYqsemadT1ogZ/+FAPS4vUVuylm6+OAO6+xWpPR5oV3VM7STJ3b7WVEw9s8DzgJTCX7bLN712vmEA1e/G+gruhRcVvSgsB131n5YaBB3X+lqfUGC5KOydFW2Mt3rN7JiMwgotdQbZ2y4ysnGPZI58qJYBF3yeJnqg0l3AuqNAZ6ed/1mel9+puQZ9X4TtBIBpdQNg85YYLMeFcxh1sDqMP9fl0Wk9wirN2Xajw8cgDFUECRJzyZJaBDBH8FJo7BJLwLLo7dNz4sNF9se268qcSyqCnm4Jzce8DSehxGGha/VgxO+hy1qAFOWlBKLljwUeyLf2V9CiRqNO8s6JvlO32CKlpYSFPi8OCegmWb+k+h+93DtQJ/tu++mAweWskmZjxnn9aAEFpwaAyiGsdVDnmRoYJK272+hsLCZzB93fwvHd0otYk//3exdeyVElSzOpSiwT8m/ohsboG8mskKsY0tGqo3p1w4/0Ms1m6QT0R/DFGiv6IjBN4/fq3tMfxNw3Ysi62hu0yLtEK8SzrgWoRYLn/RN7Rznc2nBviIgFmyQJpTLq81TXQz9F+J+MfiiKu/VtdvxV8GUAgk+ENmDqDoGiHG5wMsS8lCkCcw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1693.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(39860400002)(396003)(346002)(376002)(136003)(451199015)(6506007)(7696005)(66946007)(66446008)(66556008)(8676002)(76116006)(64756008)(66476007)(110136005)(54906003)(55016003)(33656002)(38100700002)(122000001)(38070700005)(4326008)(478600001)(83380400001)(186003)(316002)(53546011)(9686003)(966005)(86362001)(71200400001)(52536014)(26005)(2906002)(8936002)(41300700001)(7416002)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Umra85OUtLS+HEDNe6RGGlPHIAUI449wEZLP6JBre2ZgXF+A6ZaogEFchvlR?=
 =?us-ascii?Q?e0D2DbWh0wHeL4eEKEPB/7vgb7l2lNfrTo9iE9GBwDsQGaJZupJPgGszcBG+?=
 =?us-ascii?Q?gGlZcjZUIoePCYL/AMjeQjMw6bACtISCQfluxMgJe9n3yZq3seyTLCqfGc20?=
 =?us-ascii?Q?+0+L0/lwkehyR3S+lQvUJtE2y4J/jWs7UwZ/nLTZLTBy9ByY99/5ByrAoaln?=
 =?us-ascii?Q?U8cyW09TI80QqE0ZHgLo/Waq7NkjQVPGux/bne6xwFGpmDgcdilX8ncH5YYG?=
 =?us-ascii?Q?X8V6RUduWoJiF0UxSjX2PubkBMb7soWWrXFN9BBSD+ovcEr6plQhDqQFkEHJ?=
 =?us-ascii?Q?XmABhqzeLOdnS+Xtt6Dn2XKJ9EeExtrbvBZp+ayx+XrmH4FY7PKjIyg3MIDF?=
 =?us-ascii?Q?t8FTd2HeXRHhoOKr9XJQCWfjqKZ9OOXwqFZYO4WfTRB9oi4DKhtMsDxt6+a0?=
 =?us-ascii?Q?sBsfUWL1jAuYvw17V6uInbXzWjx+oGQOXjnv1n0ZY2fOzEeZkJ/vQf1dWkdp?=
 =?us-ascii?Q?FIlreUdv9zsB97KvPG4dHErjWzGgT6/u0oXmyc8zGXHvm2A0GLDDLjvZou0V?=
 =?us-ascii?Q?Xs0EY+AcPso7cK5L/M0AStpm+/BJntzHIKID9u6hwUNgMoagW96T2kFvsXS+?=
 =?us-ascii?Q?4+1AYqZ9FLlLWuKM3ZpUo6DZU55pKQ/bG3rj7XAJUugA2vHCLo16FXa7rLJS?=
 =?us-ascii?Q?Z+PgYSoIAjB2aVLQ9KrD1X4zk/nlzy4pAW/EGeqLGa2D41ldNZrSi6utgofg?=
 =?us-ascii?Q?7mTBr5siuScuXD4FD5n/W066m5MyIcROb0So2Y8yu2K0mvRaAPGQlByn5EyA?=
 =?us-ascii?Q?a/50c+mdILaap6sYvYjOafzqhOALPpIyA2ze5ICNHBY+LS3nIZTcYbDw+pSX?=
 =?us-ascii?Q?jS5PM9CuV7SQcVc9fktxTcI+JRXDFi/1Qf/yd0xZQY2i9Nf3i3kuXp9mj9oZ?=
 =?us-ascii?Q?gPEVcfu79A5jOYzERD39EWlwLinbV7Hq5Q3h1K5chnT63Sk6eZdaI+rFrCk/?=
 =?us-ascii?Q?F4+5hrzG1n2lk/HXk7t6WlnpOA7UmWDILk+UMq2QIYRo6SnPIbd3RhefvjC0?=
 =?us-ascii?Q?HyiGgHoCxhuej4B57OTK7yaQu8LEXWk5ZfNNeqo6fC8/EDyu10w6Xw4EcBHY?=
 =?us-ascii?Q?1z04LEZMstYqZ7+0R+84rTzp7UnYecgU0MtFDjFOim3vhlhaaPKOj1UsFKlv?=
 =?us-ascii?Q?xmnBaz8b8CeARYj9ZYVoPisrJRrxtmzfl/fR1sP7CyQCbVc25Bx2HvkVLKTT?=
 =?us-ascii?Q?57LepM/GzOxNeYPwgKX8dJ3VeAbUDUYYunVRC4F9iE7FV+bz0FZosg7bc1zU?=
 =?us-ascii?Q?79YC7c/oZOanXpX/rhL0zo0FYDKL7GuHi7501J5PldvZTu48tXmpIF2F6tgV?=
 =?us-ascii?Q?jj+kZgcYLfcj4Uo6yq24/K0+UGiB6nAlqT795QEtNP+Sd9Zwd4fWjsFUgVtJ?=
 =?us-ascii?Q?e4kjtdQL5FL59716HYjlvKTuNpIqH/vH8iHuZnla7JUKiNpPETgtegsAljjZ?=
 =?us-ascii?Q?FpEykd6b7OVJj6WkIgEjXmFjuYUVNqlmbxtlgqg2pTNoVeEIdwIm8FkgzmRL?=
 =?us-ascii?Q?zn+my7Oe4K7jWGYkqZ0yypJ+0wYKSQYJh841sOxV?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1693.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2800b00e-73f7-4956-a9ec-08dab070aafa
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Oct 2022 18:51:57.7101
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0a99GIAq2UOV/jpisOcOW7KqATeSYv05uaY05yM+n6ODyhjqBFPPfLaLv0Cft7nwDHQEg8WHHq18y2tfgbragQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7042
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>> On 09/10/2022 18:22, Vladimir Oltean wrote:
>> > On Sun, Oct 09, 2022 at 05:20:03PM +0200, Krzysztof Kozlowski wrote:
>> >> On 09/10/2022 00:56, Vladimir Oltean wrote:
>> >>>>
>> >>>> +MICROCHIP LAN9303/LAN9354 ETHERNET SWITCH DRIVER
>> >>>> +M:      Jerry Ray <jerry.ray@microchip.com>
>> >>>> +M:      UNGLinuxDriver@microchip.com
>> >>>> +L:      netdev@vger.kernel.org
>> >>>> +S:      Maintained
>> >>>> +F:      Documentation/devicetree/bindings/net/dsa/microchip,lan930=
3.yaml
>> >>>> +F:      drivers/net/dsa/lan9303*
>> >>>> +
>> >>>
>> >>> Separate patch please? Changes to the MAINTAINERS file get applied t=
o
>> >>> the "net" tree.
>> >>
>> >> This will also go via net tree, so there is no real need to split it.
>> >
>> > I meant exactly what I wrote, "net" tree as in the networking tree whe=
re
>> > fixes to the current master branch are sent:
>> > https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git, or in
>> > other words, not net-next.git where new features are sent:
>> > https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git
>>
>> Ah, but how it can go to fixes? It has invalid path (in the context of
>> net-fixes) and it is not related to anything in the current cycle.
>
>Personally I'd split the patch into 2 pieces, the MAINTAINERS entry for
>the drivers/net/dsa/lan9303* portion, plus the current .txt schema,
>which goes to "net" right away, wait until the net tree gets merged back
>into net-next (happens when submissions for net-next reopen), then add
>the dt-bindings and rename the .txt schema from MAINTAINERS to .yaml.
>

If this patch should be flagged [net] rather than [net-next], please tell
me.  I'm looking to add content to the driver going forward and assumed
net-next.  Splitting the patch into 2 steps didn't make a lot of sense to
me.  Splitting the patch into 2 patches targeting 2 different repos makes
even less sense.  I assume the net MAINTAINERS list to be updated from
net-next contributions on the next cycle.

As I'm now outright deleting the lan9303.txt file, I'm getting the test bot
error about also needing to change the rst file that references lan9303.txt=
.
I'll do so in the next revision.  The alternative is to drop the yaml, simp=
ly
add to the old txt file, and be done with it.   Your call.

Regards,
Jerry.
