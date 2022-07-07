Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B0035698FE
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 06:10:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234853AbiGGEKw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 00:10:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiGGEKv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 00:10:51 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2080.outbound.protection.outlook.com [40.107.237.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 042A91BEBD;
        Wed,  6 Jul 2022 21:10:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E9RBR2xkQv9jXy8XSWYwJHEjNehUabOvWGXRrddoLwtSin6K90C0xwzntUm49y+TC6xv5eaEo56Sxdl4X/4GlS3c4nxd8PPl0XnowdCk38ZjuTW9RRj7qvn7Xt2bGY2PpJ1dx67ZDNP/rOtK+ZNP80UON39HJP5LR66q7ucBYwEOGIKXFsSt92zp7Prnqk3lFURhA/i4S7Npv13B9DE+0mAL4SJYRVRwpdrQzQmg1nmcjStZllafQkMDStKTbsMRL/R1lMLe4aDK1AQCcF+8oO0pfnVbEKPsSM2jq8BlFO5uZ0lqJP5PBQCpojsZgvehHsWXtKFEBy53ncExuV53+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=34Dt8Hzu2lOD5tku//mnUotKrYGGClZ9fK3OcKqSYy8=;
 b=IN1mYcq1boSp2jyiD0gNPPbOELGgQvglK+heFpH+AbEVPsPpJ5kIOeLls8svPd2uJdsqBc2pd2mvr6tKg/yUzrag2Osi1b4493dp6jIuU2GmXpiT5TqRsTGmY46pCtI/JWvxgJybAtcpi/0GyuKSYzu/LeDIAN0Ips5TPer5O0PSS9R7fQ71munVfFJywrQKV7C1HV6EiEFUSSqatIRO55TMaKbtaftZrZOw8IjV7dW7bKwhRDZgtao5/DFz3eksuyARWD/mqpNf9+xA16RqkVFU6fMdn5k4u69oXmvdbkrnAnDG2/A0KYIBF6fSsJhrXQQUluMX6K/VafXitWnm8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=34Dt8Hzu2lOD5tku//mnUotKrYGGClZ9fK3OcKqSYy8=;
 b=DukLoP3QbpN5Awsqv7mQ0cLMj4b1kLMVZ3NVKcNnhpm9R3Ht+jWm+fu+3G27uoaepGIxBrMgG1EBrwKQB8X1t6uBmcgHtuC9Q7RSQvOQeYrqXu5uV/lUsLKk0uLXrmDJUReI5wrt9z+UNV6/1SaoSbJAcEzw+WpO9or2AlSnJGgi9sYH8h51rA/4OBcJD5n3iw6E1yick4yY//ZNTMjTKBjHqJRqHH2Gbun1y7yJRpcgxscQGOsDsnuj/Fl1AISDK/aK8Tl/n2+tcLRR07iourhsEwiJ1YD2jjRDexldeI2iM66//OMzLiLqcNteW+968IBJ6ErMQe/rQ+SnJYxzDQ==
Received: from LV2PR12MB5727.namprd12.prod.outlook.com (2603:10b6:408:17d::7)
 by DM6PR12MB2905.namprd12.prod.outlook.com (2603:10b6:5:181::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.18; Thu, 7 Jul
 2022 04:10:47 +0000
Received: from LV2PR12MB5727.namprd12.prod.outlook.com
 ([fe80::458b:20e1:c82f:9e79]) by LV2PR12MB5727.namprd12.prod.outlook.com
 ([fe80::458b:20e1:c82f:9e79%9]) with mapi id 15.20.5395.020; Thu, 7 Jul 2022
 04:10:46 +0000
From:   Bhadram Varka <vbhadram@nvidia.com>
To:     Thierry Reding <thierry.reding@gmail.com>,
        Rob Herring <robh@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "will@kernel.org" <will@kernel.org>
Subject: RE: [PATCH net-next v1 5/9] dt-bindings: net: Add Tegra234 MGBE
Thread-Topic: [PATCH net-next v1 5/9] dt-bindings: net: Add Tegra234 MGBE
Thread-Index: AQHYhtVsfRDuhi/5xEev+PCpYCX6HK1lRGMAgALQpYCACkxdEA==
Date:   Thu, 7 Jul 2022 04:10:46 +0000
Message-ID: <LV2PR12MB5727FEFE23ECC8165A4E97B8AF839@LV2PR12MB5727.namprd12.prod.outlook.com>
References: <20220623074615.56418-1-vbhadram@nvidia.com>
 <20220623074615.56418-5-vbhadram@nvidia.com>
 <20220628195534.GA868640-robh@kernel.org> <Yr25O9Spphgw+5lS@orome>
In-Reply-To: <Yr25O9Spphgw+5lS@orome>
Accept-Language: en-US
Content-Language: en-US
X-Mentions: robh@kernel.org
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 524cab43-6f74-4053-e303-08da5fceab4e
x-ms-traffictypediagnostic: DM6PR12MB2905:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1MVIQgxjyUWosShjbln9niPKgvw7mGADKmd/vwy1stywx2DDfWA4nDqZ8Lt3pHORQcSpJtlVyN23A8/lPHsMpWkQpzXMFyJfHOFkmjt3sw6y03WdKuvodOuabw/Pl73KnxkC4Vn6JcG3a+plFXgQmkf4nvpzxkd98yENL3jpvCS9aD/YzHq4XI+bFD3XCV4oXNcRPHSo5czoBqZCYB1VPz66vDpXHyWX2nM0/aS+oR8Zpvap0BM6GTwi6xYP2W7rMolLtKcq/82SQudql1GN/3t7YrpRC1ylmO0pDxTR5MrpSUGgpb4KplmFiJl3oN9b0IAaYomHrKrjtj5diwipikUwoLZUlbOwfFhtCcqgkHvhsghap1DzZ/07+VLobN0zBqFXcx1yFIWu+zsqB4jTcIjDU0Y7HSZONOfjX9MlEIoUVqOIJoKQlg+zujOgKqpora7hRfMn79+a2HO6aGLJEmnGNKEMYjindxKq+c6Co9cvF7CPOPpM9IJoWcc1Tc5PvTCgcJjMjsu1uHj+PEJes8r/dALSuKS0EoSxXWQuJjSqgS+vU8mnOWRI7gQYxNvizIfYyDb8qKlsb5fHY+nn+SAe9BFxUiVNT4AJk8KHn8yoSSuy4k6+cJQLXYiIRwASGHrUUaM4V2ri/Qm4A9ZhBvdT4tsLwMgJJKjKeeX6gjdQLyTPZWGW7B0Y6q8CNP87WFjpCb835gRUZa8WWbDXFq8CdPBZqsS78zapXoFEub/Bu1WwpbfO1gD0XusOHOFujKTD28mscb0MqrQXexZVlJiuTamih7YRvlvp6UYKT+ZhZq+Nae9yhGTMJuZO9BmGY+M1NWf/kwS42S3gYSkEdZszAfPvCzuhTGI6zTW5wfvJV5mUh7FJmxDbHKzA9ei0JvpsnIvMxZ0Lp0PrE5uzZgkcD44pX07wyLc3Wtlegy1L8jwhbD6qALWtg5MIy4Oa
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5727.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(396003)(376002)(39860400002)(136003)(366004)(110136005)(54906003)(966005)(478600001)(9686003)(71200400001)(55016003)(41300700001)(26005)(5660300002)(8936002)(316002)(52536014)(86362001)(55236004)(53546011)(38070700005)(66446008)(64756008)(6506007)(186003)(122000001)(8676002)(66946007)(4326008)(66476007)(66556008)(76116006)(38100700002)(2906002)(7696005)(83380400001)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?plqJNBVgof+R8PJRik2aqfqm/IOMKSEEa2uwPeppBzG0Qg71cVKEnw+EDQ1v?=
 =?us-ascii?Q?KzCIG2MH0HBMIlUrxDK7O4uIHTAZMrnF2HWO7DvlX0sRmuTSmgf39N5op0Aw?=
 =?us-ascii?Q?BNQ8/beeWHGQyp0PNvBZ6d24s7ixbUEAqQGvARbZLWuq9AyCn624KyzsPYUE?=
 =?us-ascii?Q?V/cWfmmdSaWG5SGos32RWWS2lD/W0SsretZso+F/zeAGHiaJRFaDVlvQVhF8?=
 =?us-ascii?Q?ghfnzNYBYTWOIUr5dFEg1GzT/m9TV+fhHONolR6eCBxLdw4AuK32nX9KVD9t?=
 =?us-ascii?Q?prPL3D77qmtdlhOHRGERh35xvyP2mMBFvs+Pnhr8Jms826P6tSC0zhb7sXbA?=
 =?us-ascii?Q?fyK/UBYMpMA8eZfSa7Lqs5kbUoW1eY8LfizUqvx4vKlUNtk5C0ym4dJKJANP?=
 =?us-ascii?Q?bQGLTgp3PFO8hUlzY5wH31vp6wtZR3AqFhtoVpnirvlzQSjn1EqagsFOImhN?=
 =?us-ascii?Q?NNQm083ZUd2K5tKrZpV9z20dS8AsOx7+bfrvlJgGjHGi6ssG+aA9Tqo72zbM?=
 =?us-ascii?Q?eRpmHTB3gIjOKuC1gyPzJV6nzjLOYabspSq7cGyKida3AmixNkvPSq/TUr5S?=
 =?us-ascii?Q?oh3yVqOuLR9ECgQa10YOH0PoxdWcnfeaOD3RcdeJRK9v0FtFA7NrfbKh0RJ/?=
 =?us-ascii?Q?TMmh8YM3VAuBXjuRchtl2XrbdN22xH1p3fIjAG8kI1GMPQISt4ZjlObSQ9nS?=
 =?us-ascii?Q?evRSJ7+MPc8eVdeP/lhq3fchARlhxE6eNqnVIJ+2rU1O6Rr1Znfo7c5JMmFf?=
 =?us-ascii?Q?q4NOVyLnbwCkQrq6EhwghBNJGFxPrDdqHcq/K2e74XMryzUdi60lAYisOfOn?=
 =?us-ascii?Q?jkK2qWpatkVERuk4nTq3pT2VRjqRuCyc8RtkIoYUOJMY+3Hb8534OFCPTb3k?=
 =?us-ascii?Q?Vyod0a+USqLramnp3uhbQk5jsgLTMxKDwxUzDGK2/8yMX9/n7Cq6vTY8R3OW?=
 =?us-ascii?Q?dxy0IuQt28+t/z6lvoD2kzyINB1xAKWfAumXEpplFQSYqIU7oUCnydwYiydS?=
 =?us-ascii?Q?hl3kBeO/gygONx7U7BHW87fknfuvMM8+lIJw89FtaWevkLYdhH88+PnZM9X9?=
 =?us-ascii?Q?GCAqmCLBN1ljqochAPq+3tKmKu6+IX1FTM/cXp1b51ik+uq5Jngyx5om2loI?=
 =?us-ascii?Q?WxQH0fHWN+PQ/RB4mof2C5GHoio8IoRycEgI4Kqz3SshTTMBKyQLmaL04uTL?=
 =?us-ascii?Q?3CB/bhMl73DiSYFz1xfXh5Du/NM9SdEfx/vb2tFe3TtEHSmdqpavCDgOCYg1?=
 =?us-ascii?Q?RgGKlfgemuRrfcu/G1wM1HCU2FLBw9kYIrItYsjT/eBlu6twYQ03hip7i3uh?=
 =?us-ascii?Q?4J4KGlAyNn87cAsGSQfw5cq86txWX1A3zruUbLJt5XaXtQ51oHmYccbeGhkl?=
 =?us-ascii?Q?y/91wuvFIJyeHHw1Gz1B5J/ZfEKTlwe6AN7N9tmPJm5NrvAj5zdgbXzHv1NN?=
 =?us-ascii?Q?W0UWMeCcml8O8S0LpOYtv9bKCypkZAVX0ZFFNa0Mi6mDOWACmgIuwUAeJ25y?=
 =?us-ascii?Q?8hP09u1HKbqkk+kkRYcPpT+vZMqfiEn0OMdIN62EqacnMvh1O6Iivtt4UO8V?=
 =?us-ascii?Q?ZDiyWcK3mrmCn95tzaxWPccvaL5nMHHXwTkc61nb?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5727.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 524cab43-6f74-4053-e303-08da5fceab4e
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jul 2022 04:10:46.8009
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8/vcWcrkdjim2Kt4vkqFiKYTIrGXl1SKYTBjbNoYnHTbcuBoZEejjGNAJ83H2BqgTBS00EJP2iOBVoM4Hjt6+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2905
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi @Rob Herring,
Thanks for the review.

> -----Original Message-----
> From: Thierry Reding <thierry.reding@gmail.com>
> Sent: 30 June 2022 08:25 PM
> To: Rob Herring <robh@kernel.org>; Bhadram Varka
> <vbhadram@nvidia.com>
> Cc: netdev@vger.kernel.org; devicetree@vger.kernel.org; linux-
> tegra@vger.kernel.org; krzysztof.kozlowski+dt@linaro.org; Jonathan Hunter
> <jonathanh@nvidia.com>; kuba@kernel.org; catalin.marinas@arm.com;
> will@kernel.org
> Subject: Re: [PATCH net-next v1 5/9] dt-bindings: net: Add Tegra234 MGBE
>=20
> On Tue, Jun 28, 2022 at 01:55:34PM -0600, Rob Herring wrote:
> > On Thu, Jun 23, 2022 at 01:16:11PM +0530, Bhadram Varka wrote:
> > > Add device-tree binding documentation for the Tegra234 MGBE ethernet
> > > controller.
> > >
> > > Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
> > > Signed-off-by: Bhadram Varka <vbhadram@nvidia.com>
> > > ---
> > >  .../bindings/net/nvidia,tegra234-mgbe.yaml    | 163
> ++++++++++++++++++
> > >  1 file changed, 163 insertions(+)
> > >  create mode 100644
> > > Documentation/devicetree/bindings/net/nvidia,tegra234-mgbe.yaml
> > >
> > > diff --git
> > > a/Documentation/devicetree/bindings/net/nvidia,tegra234-mgbe.yaml
> > > b/Documentation/devicetree/bindings/net/nvidia,tegra234-mgbe.yaml
> > > new file mode 100644
> > > index 000000000000..d6db43e60ab8
> > > --- /dev/null
> > > +++ b/Documentation/devicetree/bindings/net/nvidia,tegra234-
> mgbe.yam
> > > +++ l
> > > @@ -0,0 +1,163 @@
> > > +# SPDX-License-Identifier: GPL-2.0
> >
> > Dual license. checkpatch.pl will tell you this.
Addressed this comment.
> >
> > > +%YAML 1.2
> > > +---
> > > +$id: http://devicetree.org/schemas/net/nvidia,tegra234-mgbe.yaml#
> > > +$schema: http://devicetree.org/meta-schemas/core.yaml#
> > > +
> > > +title: Tegra234 MGBE Device Tree Bindings
> >
> > s/Device Tree Bindings/???bit Ethernet Controller/
Addressed this comment
> >
> > > +
> > > +maintainers:
> > > +  - Thierry Reding <treding@nvidia.com>
> > > +  - Jon Hunter <jonathanh@nvidia.com>
> > > +
> > > +properties:
> > > +
> > > +  compatible:
> > > +    const: nvidia,tegra234-mgbe
> > > +
> > > +  reg:
> > > +    minItems: 3
> > > +    maxItems: 3
> > > +
> > > +  reg-names:
> > > +    items:
> > > +      - const: hypervisor
> > > +      - const: mac
> > > +      - const: xpcs
> >
> > Is this really part of the same block? You don't have a PHY (the one
> > in front of the ethernet PHY) and PCS is sometimes part of the PHY.
>=20
> Yes, these are all part of the same block. As an example, the MGBE0
> instantiation of this block on Tegra234 is assigned an address space from
> 0x06800000 to 0x068fffff. Within that there are three main sections of
> registers:
>=20
> 	MAC 0x06800000-0x0689ffff
> 	PCS 0x068a0000-0x068bffff
> 	SEC 0x068c0000-0x068effff
>=20
> Each of these are further subdivided (hypervisor and mac are within that
> MAC section, while XPCS is in the PCS section) and we don't have reg entr=
ies
> for all of them because things like SEC and virtualization aren't support=
ed
> upstream yet.
>=20
> > > +
> > > +  interrupts:
> > > +    minItems: 1
> > > +
> > > +  interrupt-names:
> > > +    items:
> > > +      - const: common
> >
> > Just drop interrupt-names. Not a useful name really.
>=20
> There will eventually be other interrupts that could be used here. For
> example there are five additional interrupts that are used for virtualiza=
tion
> and another two for the MACSEC module. Neither of which are supported in
> upstream at the moment, so we didn't want to define these yet. However,
> specifying the interrupt-names property from the start, it will allow the=
se
> other interrupts to be added in a backwards- compatible and easy way late=
r
> on.
>=20
> >
> > > +
> > > +  clocks:
> > > +    minItems: 12
> > > +    maxItems: 12
> > > +
> > > +  clock-names:
> > > +    minItems: 12
> > > +    maxItems: 12
> > > +    contains:
> > > +      enum:
> > > +        - mgbe
> > > +        - mac
> > > +        - mac-divider
> > > +        - ptp-ref
> > > +        - rx-input-m
> > > +        - rx-input
> > > +        - tx
> > > +        - eee-pcs
> > > +        - rx-pcs-input
> > > +        - rx-pcs-m
> > > +        - rx-pcs
> > > +        - tx-pcs
> > > +
> > > +  resets:
> > > +    minItems: 2
> > > +    maxItems: 2
> > > +
> > > +  reset-names:
> > > +    contains:
> > > +      enum:
> > > +        - mac
> > > +        - pcs
> > > +
> > > +  interconnects:
> > > +    items:
> > > +      - description: memory read client
> > > +      - description: memory write client
> > > +
> > > +  interconnect-names:
> > > +    items:
> > > +      - const: dma-mem # read
> > > +      - const: write
> > > +
> > > +  iommus:
> > > +    maxItems: 1
> > > +
> > > +  power-domains:
> > > +    items:
> > > +      - description: MGBE power-domain
> >
> > What else would it be? Just 'maxItems: 1'.
>=20
> It's possible that we have some generic descriptions like this in other
> bindings, but I agree that this doesn't add anything useful. I can look i=
nto
> other bindings and remove these generic descriptions so that they don't s=
et
> a bad example.
>=20
> > > +
> > > +  phy-handle: true
> > > +
> > > +  phy-mode: true
> >
> > All possible modes are supported by this h/w? Not likely.
Updated the comments to reflect usxgmii and xfi
> >
> > > +
> > > +  mdio:
> > > +    $ref: mdio.yaml#
> > > +    unevaluatedProperties: false
> > > +    description:
> > > +      Creates and registers an MDIO bus.
> >
> > That's OS behavior...
>=20
> I suppose we can just leave out the description here because this is fair=
ly
> standard.
>=20
> Bhadram, can you address the comments in this and send out a v2 of the
> whole series? As suggested by Jakub, let's either leave out the driver bi=
ts at
> this point so as not to confuse maintainers any further, or at least make=
 sure
> that the driver patch is the last one in the series to make it a bit more=
 obvious
> what needs to be applied to net/next.
>=20
Okay.

> Also, keep in mind that if we want to get this into v5.20, we need to get=
 the
> bindings finalized in the next couple of days.
>=20
> Thierry
