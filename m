Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F6094FE2ED
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 15:41:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347377AbiDLNnD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 09:43:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356195AbiDLNm7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 09:42:59 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60069.outbound.protection.outlook.com [40.107.6.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BB6249CB8
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 06:40:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VRLqObIYJ1LAjp2nBF+oNVV1BnVg1UrpkgiQJlpj7K7Dx9QjPDAGQvFDzpOlsTGLhs4ETw8sqcTGpa9GzH4+rakRMo6ROKrq5u9s6ZpVqkmpOLdi82VsVNbUaE60OnCfdwyHEjmUNSYPrILu3DMr5gRidDblInRG9qwQkb3BFnFsqjUIONx0j5azN8QPbHmmvXpJG5mkU8w8w4A0i29o3IYUl/Be2q+rM3IRUP8Ano99OinLcF68jILZmrMQVoqv41W2mtt10a+yNf060ltr7z7/Zb9OYQo6q7hXvSwUc6/ev5+xE/J9XPkJqUZGej19E6bdpzNkgyNr6D+TYlKpeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h1dMrDnf2iDyG+FBK8NFK2IZWmzgEB0S7YOUIFG78/I=;
 b=hp0X0zEVYCN+DBAlhEvSRBG+0ChDo4+8n9AnmthmKvVaqGesFvkwqFN1XskEAGdV47HkoDaQwXLP4Gto9gU72bqSzPhy+bn73L6zhq3MQ7EF589owM9cWPATu7Q6EfTY5NyKB93GVpxLZQBSpNdHeEx28KNnTm94oKoMTNKxlsaJHtui2da99uG8n1pvwRm9tEab1vyfJQMwfy9sm1OXEk24ahpcg6+t+cMYeAUW7winuSt4G/VrW+zvdikQQuWCv2YYSlBNJ7lERBQUmgkwsi5krjWWNdnC+F0bpldtaR6Bd/PPI/WHUJrqzJg8WJ19dvyLhRWW1ff2LjDOX07QnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h1dMrDnf2iDyG+FBK8NFK2IZWmzgEB0S7YOUIFG78/I=;
 b=kBe9XfUGm4BKDqCdGVtRbRoeeqBqcUe42fyTdaXEzOiaaLR5doZMBjQqOGK7/uX8NIvQG0gHxwxXcweYBgTkv7iRXOEyB61u/7b7qfolkg629ZIXwOGPcoETFOPI8aAlU3P9hPdh10J0UH+4cu7FpIPb+ArYqxZukjVDQQxeWQI=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR04MB6531.eurprd04.prod.outlook.com (2603:10a6:208:178::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.30; Tue, 12 Apr
 2022 13:40:37 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e%3]) with mapi id 15.20.5144.029; Tue, 12 Apr 2022
 13:40:36 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Joachim Wiberg <troglobit@gmail.com>
CC:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tobias Waldekranz <tobias@waldekranz.com>
Subject: Re: [PATCH RFC net-next 07/13] selftests: forwarding: new test,
 verify bridge flood flags
Thread-Topic: [PATCH RFC net-next 07/13] selftests: forwarding: new test,
 verify bridge flood flags
Thread-Index: AQHYTamAs7QHO4PKl0yCkkH/jUKUX6zrKB8AgADB64CAAGBlAA==
Date:   Tue, 12 Apr 2022 13:40:36 +0000
Message-ID: <20220412134032.lm54stqcblahdej2@skbuf>
References: <20220411133837.318876-1-troglobit@gmail.com>
 <20220411133837.318876-8-troglobit@gmail.com>
 <20220411202128.n4dafks4mnkbzr2k@skbuf> <87fsmiburw.fsf@gmail.com>
In-Reply-To: <87fsmiburw.fsf@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3fdf7b1f-9cbb-46ea-c361-08da1c8a06b5
x-ms-traffictypediagnostic: AM0PR04MB6531:EE_
x-microsoft-antispam-prvs: <AM0PR04MB6531FB2EC382262D26959A40E0ED9@AM0PR04MB6531.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9zo7PKu27jpbxNLP4ExV/mGQaOilhTIUaY1l2VIKxm+iEp+eYSe2cNq8/VP5BGQRR68UdMkWNyGSlsmqnZ6djVIPEAo72yCFND5ZhlLJhX56BWoY0qkdekxqhBJPPIHrTJI64M8+28triHY3z+bNok4/f1jFmJcEI1YQ/ejlmaBM8RPLbIdU2eyD3nEFsx85CUod80R/7/tqqzvy+SK+dXGUct69QdTIfDQ9raN3q7z/Kppf7dJxvgW8HQgSGDE50VQf3i9WYC3JeVINgmnR+rS19D4vAFq95WomATJJDntXnvyHBu40KjXh4BoAgBxaWL+Pfh/5NTeLMDFSIvj+f8AkKimvb1lDxz72Iow01iFQePiFFy5GyETFXhQ6xwpXRrtoaHIYNVBWyOun4TA0EpkWAL9HJA4Cw6AMDAWqwqZbF4CYlzVPcdUQgmtU/XEZaspU470q3TKuzyY8D5f5W9HvlEAyDgPSbWzaA4fve9octmU3gtxQnYmFXP5Mre5284ZJ8AWeVArbdosN0SUUF3VwASM8i1X7l8V7YJnkLAQeDDdquuY8KoHXq3GfQeyVQFriR9XCqrG3GemfW7w+TMgsZrP691FU3d/T6QxwARklnbg35PuV5n+du9r7o5D37fuJbmdHg+iK4YU/61TmILT1Paq8mThLrd+zdR0pja7b1HzCDzF7D9ZX5UCH60a94SnW16Ka8xfgy43YgU6SVw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(6486002)(316002)(1076003)(6916009)(186003)(53546011)(26005)(122000001)(86362001)(44832011)(8936002)(15650500001)(508600001)(2906002)(83380400001)(33716001)(54906003)(38070700005)(4326008)(91956017)(66946007)(64756008)(66476007)(66556008)(66446008)(8676002)(71200400001)(76116006)(5660300002)(6512007)(9686003)(6506007)(38100700002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?8M/ZSlaxD8onfDKX9x0nCN+5m6heZV1ShKUdVoAdPnEmDYaKJ9udyGb347a/?=
 =?us-ascii?Q?Bbl2+nDN7IqLJKFCF/9uO7yFBje5aUnjaIGCbSMQvJpjquWhfccEcPDI4ZUW?=
 =?us-ascii?Q?2ENRpXUTMxprGnp7HDh5HfqGQtH6jmAQDuPwLIUtSu4HVvfmj5UWo7VAD2md?=
 =?us-ascii?Q?u7saO0434pRhBYuNAKRhbikMKpYXVnQ7kP07jZMhN/lb22ZY8aVeWhR59aOn?=
 =?us-ascii?Q?cuFaYFDIw7pT+h1bXH7s0ugL3iu2FZACvD2BV4FrR3N0QrOZsQ+Uwe1BDw5F?=
 =?us-ascii?Q?2w0CM0VBCXAuBqiH7Jn0YhU7bS9PwtCfDR1/VnhDLlKT6QRjsFMWD9V5TsEg?=
 =?us-ascii?Q?A+HjtONpmSzkm/+gC9KtZIg7YVo5wKafAhK3txm5IxgsfKXLq4lY/69lvuS1?=
 =?us-ascii?Q?6LcwNitqCpoBZQZ0PPLo9HoNmgDo1yWxPyYiopLW4Ww4zYq2YKtNeM0lyPxO?=
 =?us-ascii?Q?UjfqmUX5AfsQLYTFmSTry9JYa+z1iZMSHmXJr2j0N/oqXltFxMMCPGcrdgOi?=
 =?us-ascii?Q?Gje0ldlrFvvO6fRF0tqa1r8ynk0luWqnaQ1O00ZrndXF4ah+jCZYI8KEldoX?=
 =?us-ascii?Q?JoAQXvQ6Iqp4D8coUsu3BEb+IysaTHLz8fz8YsNQiyWKPRam7/fD26qykpx+?=
 =?us-ascii?Q?+Eq1QC03N/qrnUKYyfuUdxKxwSXRf5EFyeenpwsHrePpu8q3lHo6EwTxciHZ?=
 =?us-ascii?Q?V+0cDO7+ln3cwCIS2s788JsJVmwJCYS7itJF2DEEOgvkw5cDUCzkFcC270BN?=
 =?us-ascii?Q?VbFORtWmWXkct6SkwENox/KZSey013CFuePBQ+ljHAp+v00UivfLgRpreZ1h?=
 =?us-ascii?Q?OwchS90k5oF/ZKM/urJp+8Sbm7BnihJtlGK6DpruYH5uUc0zuH/hpxeLq7eb?=
 =?us-ascii?Q?VRJCOoNTSiI2/r1udiPxZj/TjLpN1l7e7OMZpXSGZtivnPQ9cCR1uT9ccQKl?=
 =?us-ascii?Q?I4O327XPU7vyKBOChGE3X1pYfVJDGD4ZR+iO0iJ7UnOOkkUT9yJSSsrRZX4w?=
 =?us-ascii?Q?SHkfSws88DGZeqIWuMY0iuUFq8/9Wqddpxy7K5IW3iZ9WmLlbEuzevQXRrPB?=
 =?us-ascii?Q?xM0KDiyNzEJ2Mr4OfeMHlSBffl8gIk4zb6DI+z3K7yTU9medqtafh9I/uVPc?=
 =?us-ascii?Q?ea91ZA2p27WgLV4X4HRtAzccdJwrB3Mq1dYH7BwSlHOq9xTQO2vDgfFSxb5i?=
 =?us-ascii?Q?Z9h+WweEBtIp2thbfXJIEtUNDp1JhBCMU7ySqcPPx15IatGpojz89K2Aaq/F?=
 =?us-ascii?Q?5h+HpanW2I67jxOKArpIpPYmocq+9jnfDdmsrk5DvdEmgONr3B6lu2gvKP+0?=
 =?us-ascii?Q?udi0F0Alp2q6L7c/tkTWrxhAhtjyq2TlFR/LTblAs0YxNy1fcqJa4bbRxQIw?=
 =?us-ascii?Q?JlNkNEYJ7J6rW73A4GbSZV/0Q8X3PhM8aglRav+KrMK8kBoHqXA90GKs2t2R?=
 =?us-ascii?Q?2snwhRAPaBGgK1jy2CG85jE+tHcnPWMeKUH7CeuxBy+hnDCHSbACfkcr7kHq?=
 =?us-ascii?Q?O/9T5IRC8Hu0YTJqkXUoS5HUQi2slHeiEoKZAXg/Ci96ekR5NzbXjGgoUbiC?=
 =?us-ascii?Q?dm4fmpJqNBBMyr/lFAvSXLfnESGR3rjWl5Geatv6mc/QfQr8ENb2b2BioqX6?=
 =?us-ascii?Q?upmcgfE9miUzYiqQFgb2eC+waUCrotFwwB0oyQwBpuEOwgbE4ruZ+Mw7y6bl?=
 =?us-ascii?Q?9FWq60vEETtG7c7jJlAmZai3HN7stLU4GV7SANjIcxwnGPnNPKRLhizsCM9A?=
 =?us-ascii?Q?QFXz/JJEUGvwzFK8qYeG9pW83PgXqYk=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <43A5C43A578B114AA2E315EFAE5E28B0@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3fdf7b1f-9cbb-46ea-c361-08da1c8a06b5
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Apr 2022 13:40:36.9205
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LTSCBecpfkVZfd7AQyAMJZa5KjnQU1qziC6PZfHcwoF69zO0bf0kH7naNfit6ZciNNDi2uU5PdJWsFNseDC00g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6531
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 12, 2022 at 09:55:31AM +0200, Joachim Wiberg wrote:
> On Mon, Apr 11, 2022 at 20:21, Vladimir Oltean <vladimir.oltean@nxp.com> =
wrote:
> > On Mon, Apr 11, 2022 at 03:38:31PM +0200, Joachim Wiberg wrote:
> >> +# Verify per-port flood control flags of unknown BUM traffic.
> >> +#
> >> +#                     br0
> >> +#                    /   \
> >> +#                  h1     h2
> >
> > I think the picture is slightly inaccurate. From it I understand that h=
1
> > and h2 are bridge ports, but they are stations attached to the real
> > bridge ports, swp1 and swp2. Maybe it would be good to draw all interfa=
ces.
>=20
> Hmm, yeah either that or drop it entirely.  I sort of assumed everyone
> knew about the h<-[veth]->swp (or actual cable) setup, but you're right
> this is a bit unclear.  Me and Tobias have internally used h<-->p (for
> host<-->bridge-port) and other similar nomenclature.  Finding a good
> name that fits easily, and is still readable, in ASCII drawings is hard.
> I'll give it a go in the next drop, thanks!

I wasn't thinking of anything too fancy, this would do I guess.

             br0
            /   \
 h1 --- swp1     swp2 --- h2

> > Also, to be honest, a generic name like "ports" is hard to digest,
> > especially since you have another generic variable name "iface".
> > Maybe "brports" and "station" is a little bit more specific?
>=20
> Is there a common naming standard between bridge tests, or is it more
> important to be consistent the test overview (test heading w/ picture)?
>=20
> Anyway, I'll have a look at the naming for the next drop.

Even if there is a common naming standard in the selftests I wouldn't
know it. I just found the naming here to be vague enough that it is
confusing. If there are other examples of "port" + "iface" please feel
free to disregard.

> >> +declare -A flag1=3D([$swp1]=3Doff [$swp2]=3Doff [br0]=3Doff)
> >> +declare -A flag2=3D([$swp1]=3Doff [$swp2]=3Don  [br0]=3Doff)
> >> +declare -A flag3=3D([$swp1]=3Doff [$swp2]=3Don  [br0]=3Don )
> >> +declare -A flag4=3D([$swp1]=3Doff [$swp2]=3Doff [br0]=3Don )
> > If it's not too much, maybe these could be called "flags_pass1", etc.
> > Again, it was a bit hard to digest on first read.
>=20
> More like flags_pass_fail, but since its the flooding flags, maybe
> flood_patternN would be better?

This works.=
