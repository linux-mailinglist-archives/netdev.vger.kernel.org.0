Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 055D769E4F6
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 17:42:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234816AbjBUQmA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 11:42:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234802AbjBUQl5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 11:41:57 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2047.outbound.protection.outlook.com [40.107.22.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4696A2A6FE;
        Tue, 21 Feb 2023 08:41:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=caNesrML8bVM2//H3105/1EZBpg+nJ+9ah8U+taXYsPcRF627XGHxSeLZWEGj80xI/Yi1GvSQ+WC3hR0V5wR+1qygkzSGb6RNMwUEO2wbdVD74EU/8SrubLZ2cutELiELjtjmMxXs3ysGj/JD3EjVeWUQirBuwD51BZhDInEFD6NevwKEE5jxW2OjZ0vZqUHhW12R1gq/MUAuUc/63+xYZ4aswrznwTLmn4kBsBgLT/wxFRlN9m15CFe75gUEN4wRp3fIPQCqjtdD4QUWfd9FFMs11BZuGcrMVoYVgpmluimDLCv7J7P5TIKoq0eba9CKGeKudnGXPauAmgOtwJfiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MWnzAku0qd/Wu5dBUpo6Q5RiZA7N6NtOA4IgfNic7Fs=;
 b=NhPF5/mBSEkKeEldt2EAF3iShw5geYaw+H3OSLpyZp8R/CixZWgZnlsXykygD133ubiiiPBvPxFHLEhuIpPoF5lys7FlkYiz0zidx/uWs5i1RUppFbN+41lfsI0ydI1gUW/pXjltMBiMIUrfHPdWRTdmh8u3kFOXnUM/Gkiw9UEIhvQ1VhqcOOhFRYWeemORa2N1b+PpancBSZIIilftZyTOWDUSrmEZU5mwJGKk+Cgb1eg3FAdP1TmoQbwf+zjj7rSb653RIZ615Ugc6PfekMoQVAdEAXC6IUaTAgat8LeUyZ8sNNMJPMfca5zCiTR3h9+lti3KirI4W3ea6zPtCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MWnzAku0qd/Wu5dBUpo6Q5RiZA7N6NtOA4IgfNic7Fs=;
 b=QlB2hjMXrQZH0hhO/aAzEvWzqnkVuM5eGTM+krrvdXgLIY/QDwkEEe4ByOdYu4z3avRHJo15bL/M7pMMJVNw7NNhLde+ksv7gZOIbhb1JQ2kQylWY0ZogFy5D9D611N0dImxxvUtxS3qCq8HtN/Bc8uSi11Xdlq4Nj3eN9lsYlI=
Received: from DU2PR04MB8600.eurprd04.prod.outlook.com (2603:10a6:10:2db::12)
 by VE1PR04MB7472.eurprd04.prod.outlook.com (2603:10a6:800:1b2::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.21; Tue, 21 Feb
 2023 16:40:25 +0000
Received: from DU2PR04MB8600.eurprd04.prod.outlook.com
 ([fe80::6aa0:508c:be53:7efe]) by DU2PR04MB8600.eurprd04.prod.outlook.com
 ([fe80::6aa0:508c:be53:7efe%6]) with mapi id 15.20.6111.021; Tue, 21 Feb 2023
 16:40:25 +0000
From:   Neeraj sanjay kale <neeraj.sanjaykale@nxp.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "marcel@holtmann.org" <marcel@holtmann.org>,
        "johan.hedberg@gmail.com" <johan.hedberg@gmail.com>,
        "luiz.dentz@gmail.com" <luiz.dentz@gmail.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "jirislaby@kernel.org" <jirislaby@kernel.org>,
        "alok.a.tiwari@oracle.com" <alok.a.tiwari@oracle.com>,
        "hdanton@sina.com" <hdanton@sina.com>,
        "ilpo.jarvinen@linux.intel.com" <ilpo.jarvinen@linux.intel.com>,
        "leon@kernel.org" <leon@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        Amitkumar Karwar <amitkumar.karwar@nxp.com>,
        Rohit Fule <rohit.fule@nxp.com>,
        Sherry Sun <sherry.sun@nxp.com>
Subject: Re: [PATCH v3 2/3] dt-bindings: net: bluetooth: Add NXP bluetooth
 support
Thread-Topic: [PATCH v3 2/3] dt-bindings: net: bluetooth: Add NXP bluetooth
 support
Thread-Index: AQHZRhMyi9n0WyIUWESWPos30tiQbw==
Date:   Tue, 21 Feb 2023 16:40:25 +0000
Message-ID: <DU2PR04MB8600F997FCED520DCBAB2330E7A59@DU2PR04MB8600.eurprd04.prod.outlook.com>
References: <20230213145432.1192911-1-neeraj.sanjaykale@nxp.com>
 <20230213145432.1192911-3-neeraj.sanjaykale@nxp.com>
 <60928656-c565-773d-52e6-2142e997eee4@linaro.org>
In-Reply-To: <60928656-c565-773d-52e6-2142e997eee4@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DU2PR04MB8600:EE_|VE1PR04MB7472:EE_
x-ms-office365-filtering-correlation-id: afc4d793-853e-426b-44ba-08db142a5557
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sOc3FH3HoAmjKhT9JJPZypWL5ktvaRCgQK4WdKZO58SxOXhJcJjGeUB08mmePjV9JN47MUurYizndrLVy37+1UyiIfFPuHlOS+E75jfRfyUbw8z9qUtEGMVOwu1NILdywi8mgUc9eN0Mrn5b5+QVBQ3drDz0dQ6zp0HfbubGAi4VbykSR4cj85skSG7RiFwnZm5bidRxt6Jr5qXx7MJ/ogcgwU8iK2dtNr6GWqq74IGlPJJrCwZ6i8GhqAv484m4sGp426EXqKsjRr4vt8BsJraWGi0i+R1lXhNC4ymqheDc2CvWQ8LtGQNgPpFHFP+Axzs4OPKZo/BqOdt5tAJEyyFABbwHlhDgxfVWZU6a897FPfKvxzdKECaTbjGpFLN1sVf6yNtn+VKRw8JQcqqqqnOA0QX+a0DevSTLg3VVTmLUR8wPHkKfiSquXXeMpNwfIdAN9XcLZrTqYTG1Amv1LOaQi+7HE0pI6OmB7O8ZwGV9DLwvU5zXyP6FCWjFcH5TcOru3MhefBrhza6IGgKYh7lbKHMzBxYF1iKJVJPdJvePVcpA1j961wW2lyGP4uwBuHPFb5QPjl6NZYlEpk0Dyv0fODwExnF6VsN7omSHw8Q/sO+pQTJEKnIiXVs5Rz1V0a5OV0hgoknfb1DV2w5q0geZKl475UoF7IrlzZwgD8lEnt1HFcIE2UFLgvDxiobWyJxA3GplGz6iRdq/6APUOOmbdb6kESlye4UMRONz2vQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU2PR04MB8600.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(136003)(376002)(366004)(396003)(346002)(451199018)(83380400001)(41300700001)(186003)(54906003)(26005)(9686003)(33656002)(6506007)(110136005)(316002)(55016003)(7696005)(86362001)(478600001)(71200400001)(38070700005)(55236004)(921005)(66946007)(64756008)(76116006)(8676002)(66446008)(4326008)(66476007)(66556008)(2906002)(122000001)(38100700002)(7416002)(52536014)(8936002)(5660300002)(4744005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?xx+Gy2YR1Bw4N7RNahKea3yZqKE3JycEY6t/Gldd2Ux4oNUcSh6j1HF58+yX?=
 =?us-ascii?Q?bvplmU2c7gMHUEcPoNJ8CYkObaJulxhZsuTqHYVgMzgKMvfpXYd7oD45KNkm?=
 =?us-ascii?Q?2LiDJcO4q13o0SSVHp0iTT6303EVjpCRU1/D9x6iwCGyIOypZTvtK8Uyx8/l?=
 =?us-ascii?Q?TfEzOC4RytT+MGron8DHS2q0LWQBEcpI3YS2Qabyd1lzMKXiEbS1zkZaNCpS?=
 =?us-ascii?Q?7fj7K6bJAl5MG/1urA3M5gI4xqs7Sd6fAnwjBkNBGebkbzFtKF70wrM4A40z?=
 =?us-ascii?Q?sux0OoBol68ShUFL3lCfD2DEYiBnQ0T8tBHEf7Re75kC4pwAKmf4B4GBV0G+?=
 =?us-ascii?Q?QF9eubhqAVk7rnv2P3SDKT4cp6KkIwfvwe3aE25PlT+tnPT4oN1XpGpkdmug?=
 =?us-ascii?Q?Dksp2npxJXfC4sblqkU3ZFUvvvuYukf2wrvs86lslEHBafrT1w3wOr9xLioE?=
 =?us-ascii?Q?TuZgGV5PnNVlMXz2O2PkSUaGtlUyRHU69JGKqZ6UKzc7lhD83ffuKhybouzA?=
 =?us-ascii?Q?8cN8ES+nmAdttuD9gcu712rgMOKgCMiAk7hMP5qZD7ddVPYCXBti4yS6InhK?=
 =?us-ascii?Q?TW6q4E8NGXAeSDfYKUpEj3mORYImXrLVyTwlG36AfrPrqCaOURXcpM7PskoZ?=
 =?us-ascii?Q?/TQ1+ApDQGAHTwnSoF4lukldOK1FOZST5vHBPtlUxmrxveSlLqTd+q+Z3ZoB?=
 =?us-ascii?Q?g5OfKnxeUAha0B7ZNc0T/Um3S/Qaiy5sENofwF3A0IzW6bSKZvanmql219jT?=
 =?us-ascii?Q?tUjdmQ5W2C24FLBTa39WCeLrDjDvoWBWsp0prEnqSUwMIF4bZfyh4xtFAOJQ?=
 =?us-ascii?Q?F4yLobw4T+to3htBFIIv8rWu3EBFZSAQTZ7yWFkR/8CKzilJSnk1B7vjyq+0?=
 =?us-ascii?Q?m7BsapmFfJL5pjvr4KjvPEk4++oVxhOSLQDlJfala8EZiRNjzkyhUvoF8+uE?=
 =?us-ascii?Q?2NpkSj2uRo3DR5tL0nUCwsKFV7t0ZooImxl1XLKzAl1o3oZnIsMPtY3ZDh0q?=
 =?us-ascii?Q?hKQJyjsork57gyTNp5dBIDyMCuM6gINPLPsVb4I79e3mmc2yLZmPjDDr1fTV?=
 =?us-ascii?Q?HHkar7ArXT5dKvOkDuJUfOQBlnXA0Rnuqdo0bvV98g0B3vNByVnSSTVL0wPt?=
 =?us-ascii?Q?Kp+rxaGVAGOJf1MJokgi6Ii8aODwBxUd56eaHfJmvw60UUluByaSpjjOXI1N?=
 =?us-ascii?Q?ZesbDWz/Ve/Ki7JX2ghlrg2YbRgQ7QHeRKzzQnCVu9gRjS8J9dvxCsm9EoCA?=
 =?us-ascii?Q?nOO9BJQZ3Q0KZL6suBK+7OyJ/tk7yz8OSNPx9ESqnGyh1MZl1tiiq/nbOF7t?=
 =?us-ascii?Q?ootteNLlrpv/ewfFidKYsXKfZmgrvI2ou3fH/+AiYAFcBUwhlOcPmi0fdbfd?=
 =?us-ascii?Q?a8JtnethFt4GNFl2t+1wKmRkooZ6tewLTXcmpIlssjn9242J/EZxjOlx8bPs?=
 =?us-ascii?Q?bfj8c5RImwlnsuIAEdAPwmnnrP+TKSdSdWB/od/99Z/ngSU4KCYeP4p/fqfR?=
 =?us-ascii?Q?G7mt+n+QpRG7Sba9K0mnsVK68gF4y1QH5uNkUDgQgEgU0+fIjmaiDFAJdwwN?=
 =?us-ascii?Q?+k+NubM1JFOq1l2Ccyk4C0jK+LiITTSjR7t7at+jY8w9WrcdFJoWX/EPgeeg?=
 =?us-ascii?Q?0A=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DU2PR04MB8600.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: afc4d793-853e-426b-44ba-08db142a5557
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Feb 2023 16:40:25.5553
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hUo1qRWJ7tzdbXIpWaebt7cNMpxW9NeE+WrU3k1eGhovaom+5XJnBafNjUFzRkTHdUYb1K52m0a5PjW+OvhYGfULcUKKb13Vq5xWde9eFoU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7472
X-Spam-Status: No, score=-0.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,RCVD_IN_VALIDITY_RPBL,SPF_HELO_PASS,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Krzysztof,

Thank you for reviewing this patch. I have fixed all the review comments in=
 this document.
Please let me know if you have any more comments or suggestions on the new =
v4 patch.

> >  .../bindings/net/bluetooth/nxp,w8xxx-bt.yaml  | 44
> > +++++++++++++++++++
>=20
> I don't think I proposed such filename.
Renamed file to nxp,w8987-bt.yaml


> > +examples:
> > +  - |
> > +    uart2 {
>=20
> This is a friendly reminder during the review process.
>=20
> It seems my previous comments were not fully addressed. Maybe my
> feedback got lost between the quotes, maybe you just forgot to apply it.
> Please go back to the previous discussion and either implement all reques=
ted
> changes or keep discussing them.
>=20
> Thank you.
>=20
> > +        uart-has-rtscts;
> > +        bluetooth {
> > +          compatible =3D "nxp,iw416-bt";
>=20
> Wrong indentation. Use 4 spaces for example indentation.
>=20
Updated example indentation to use 4 spaces.

Thanks,
Neeraj
