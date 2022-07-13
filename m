Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B166572E12
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 08:21:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230094AbiGMGV3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 02:21:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiGMGV2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 02:21:28 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2048.outbound.protection.outlook.com [40.107.93.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC697C995D
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 23:21:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QHPyzxVDf4AMxpiiqmeCDTCMXrRVe1da73bec6NA1RuE37ZMqE4Mv4hTEGbjslyW9EBkcqBwIesA+OOXhHKj70DbXZcDqLCenHrNQap39m8/ZA/yrhnJHkAre7bvOjAqbvvJ7vGya8AEfYOIWUBK6mMSewbsBlWD3NZZDscrZdeCgboR1DWpDszqoN5DHJowfmeYIXHZz/dGOnQrrJ5bQrqkEuZ3p/Wm4InKejVkqVZvbZExS37O4SD1z0APmIM/6xqitsKeAC6AtjKHjZdZGrvVySE5C3U1gAHt2cwJDwwGD1xK7D+hUbPRSpZ7ehhPR0T652bgWCYYqbbzSv3dQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ry2zrztemttXwFHP89HF3UM0U5Wp+LYNdwvqzVdFhcQ=;
 b=AZ7gFTkquR2iT2SHVuO1KvXvmA7UyhV08+akzpjPtXyEClejS5iXlRjiBjdPbCNSLGGweBFeT++AWqdJdZ8txjrsZLoLRNsQNlyqQ35qyv/WR/xMYQctgnLmhGjIFclZJ8uqKbLkNJwALRFv4ZSjByHS/3u82peSdcS7SMssjNuj+G4sfes8J9pnvQ9BTH0g1iXSRiKE0NBPwoE/MIiPD1qW8/dAykyeReMj57F3PtBw9Y1Vl9CjILkO1snj93K882C2nVmQrh3e4BcidzdOOwBhMfkytyFhCBicFIhAqBtVjFgd8pRUPaZqQWIMbEpxlY+hxhmqcgJCAgw7N1xBjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ry2zrztemttXwFHP89HF3UM0U5Wp+LYNdwvqzVdFhcQ=;
 b=OizAt1NhVPaqRx5trNWm9hS3oEp7n1uk6VVgS3Nh7eHtjQFZi8MZRi0xfVcXmtxEp2//I3DPrd6FOPn9XT9kACJbc1x6qDkRbyAGCRCujeHICHC2F4fWBDb7QIzVONhgnFnyprDh2VLGEb+MPaYpiV9WgKYMW+xzZ/9pzgDfkELcWZI2USCzmJ57yH/OxKDKX3EOiYv+zcWflEP6UnVAOsZswT1opAlX3FZz7B0ls+wBhu8IjlvZD7MApuntg1mjL6sNlRTTlWP2lgowWTNG+lYLrb0ySClmTAqEJLqvgOfcXy1W1KnxLCYMv4CvKEkdjndnxq/RbxFzX4yEHiJ2sA==
Received: from PH0PR12MB5449.namprd12.prod.outlook.com (2603:10b6:510:e7::24)
 by DM6PR12MB3482.namprd12.prod.outlook.com (2603:10b6:5:3d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.20; Wed, 13 Jul
 2022 06:21:26 +0000
Received: from PH0PR12MB5449.namprd12.prod.outlook.com
 ([fe80::f15d:45d1:4f02:5b52]) by PH0PR12MB5449.namprd12.prod.outlook.com
 ([fe80::f15d:45d1:4f02:5b52%7]) with mapi id 15.20.5417.026; Wed, 13 Jul 2022
 06:21:26 +0000
From:   Lior Nahmanson <liorna@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Paolo Abeni <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Raed Salem <raeds@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Yossi Kuperman <yossiku@nvidia.com>
Subject: RE: [PATCH net-next v3 2/3] net/macsec: Add MACsec skb extension Rx
 Data path support
Thread-Topic: [PATCH net-next v3 2/3] net/macsec: Add MACsec skb extension Rx
 Data path support
Thread-Index: AQHYfxeLrA1D4yQ9x0eLs4ha9L+iN61O7o2AgAAm9ACACrctoIAAfs2AgCAspACAASE9gIAAZ7ow
Date:   Wed, 13 Jul 2022 06:21:25 +0000
Message-ID: <PH0PR12MB544980DAD3694E4F532AB6B1BF899@PH0PR12MB5449.namprd12.prod.outlook.com>
References: <20220613111942.12726-1-liorna@nvidia.com>
        <20220613111942.12726-3-liorna@nvidia.com>
        <e95ebed542745609619701b21220647668c89081.camel@redhat.com>
        <20220614091438.3d0665d9@kernel.org>
        <PH0PR12MB5449F670E890436B0C454D2ABFB39@PH0PR12MB5449.namprd12.prod.outlook.com>
        <20220621122641.3cba3d38@kernel.org>
        <PH0PR12MB54490D24F44759ACDABC950FBF869@PH0PR12MB5449.namprd12.prod.outlook.com>
 <20220712170159.6da38d1b@kernel.org>
In-Reply-To: <20220712170159.6da38d1b@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a00d1042-12c9-4918-1361-08da6497ea44
x-ms-traffictypediagnostic: DM6PR12MB3482:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: y6pXBQCBvTUv+OOqrNcE/lPxQ2ecCS6P399i1YKQ6/QVEn/rWbrXlk9sHaAOIbL3l2xH9VjOF8SiZk8WaDleEXkqfBm3J+PyuNPQamm991IrquDnUc+OMWMLPK2ODozj6G0Qkib9udXNQFuCt1ms/HnEXJqFBTq4Hj2EKmgt9Zwix38xtitmpPG31rIIH7xmxa5GVUMWcQq9ZqH8/v6Jz8BzoXqm3Ei+kKG2tSZRJ24X/5gRjzSqoAYaosQ5n+L9D9v8RvN38ZrBHsIVfIK6QrunOye0bm+fBOGLC5/wV172kH+2Vo1siGke/SHnRXWN+mO5N/oIfCoummYExcJzwTE2CLfn3nTVLht1912Nq985ZCdSyE1KN89Wmt33+WaKiuIIDSDt+QYSSs1CRI8+zuAtn6SzUSAcn4dAo+cP8q/EktwLfOuOfGlllXTjIKu5q3UPL4G35cGRUk0J2FjoubJFb1WRYS/vppeTqd86y873JGGCS7ldtQXxsRhpAkleGs2xfF5gWY/GICdMzh0IVWIk8Jv0QbKa01U85CbKeI77mlE/X2XsAzhRbxGTm8wU8yvkVC6IPjmoJNBwO0Tv/gz8JlAxO4mZebfu6D0uO9pnL3S5PqDNJhw4dC5nLGSl5auNvG/ZnlVMRUvaOteU9siQm8zAEgf0q2E2Ngrbj9YuVPHT6kxZ+dLIlP9kW21u3D7V9sMS/OurbcqjC1JrlzhZnhTypJ8zBnvZWVXMNbH6mJlGuVOBa1J0psO7wtRyKMPUn+niK6YzygZga16o4Mo2QXjz8l2AhbTaiXwssR01XGS+NsnpvTgUlnUN6Hzx
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5449.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(376002)(396003)(366004)(346002)(136003)(64756008)(66446008)(2906002)(66476007)(38070700005)(52536014)(66946007)(76116006)(5660300002)(4326008)(8676002)(83380400001)(71200400001)(8936002)(6506007)(66556008)(316002)(6916009)(26005)(53546011)(54906003)(7696005)(33656002)(86362001)(186003)(38100700002)(55016003)(9686003)(478600001)(122000001)(107886003)(41300700001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?paq+1DeJm5qqbb4Jo82kJWxGoIczVz2PQr5L7D31Ywwuh1HobhF1FdsRq22g?=
 =?us-ascii?Q?ITIb5KtXgvLSSSgQz9FhoZZWYLqMMvX8KR3wG1beFrHBrBFQW5NmoKgltOOx?=
 =?us-ascii?Q?KHpoZPjpKkz60BkJZh8O7tlSios2Uk3Jm6wRVmJ3xYN+RlY3FAmQaHaXH481?=
 =?us-ascii?Q?wc7nnTIKoeA6QcKj6iU0KDxPgdXXzLapShnUaBIQ3l1+xrNpqpUlEoxEfHXi?=
 =?us-ascii?Q?aQ4GYOAJVzP9YcP0p3LzRr4PPdiWvFJZedVT73OYM5u90RL2bQwhqfuajVSq?=
 =?us-ascii?Q?bUCk5jtXYYJ+BIHhUz1G0hTF2OflJwJq8Y0qmRV8iG6QjDou+OnpNccMTf8Z?=
 =?us-ascii?Q?R/IDoonkjDV3wBYeS8bElvVxM/oQhaXZtKQON3SArQqEc0utcaCfOFZtqQkE?=
 =?us-ascii?Q?mS1vUkCvR1yB7ZAMzGyk+2F1wQeIZcQOZgf/ALYFf7VXAt8id+CrSWxWroQt?=
 =?us-ascii?Q?MounSBlrnjK3lZ3QygVkwBP+2Aw1pV6Y0RehI2h34lm3Q0lNaq/Xv35ywO1g?=
 =?us-ascii?Q?JwSkqvCnD7IxC+uB9f5E5cgP22bYmfFbIy7aYoP62qPQrNsCq0jJB9i5tHEq?=
 =?us-ascii?Q?2CUMyoACLLp4zqviq5zYrLHjfpZ17wo/kad6Rj6FdCY068iTmd2ORPcYBfVG?=
 =?us-ascii?Q?1YRCbTsngsCmMf7I6OXPNBiUkCphTxGJAm5ltP0itaPwIks6j+stWUgpHya6?=
 =?us-ascii?Q?PXpxjl1Mj6zRds8AemgZ3H71QL4NtTHC9feAzsfuL+6RDV+i0jC1EzX0lv5y?=
 =?us-ascii?Q?mu1izSx8RXAOkQ5RMu8Ak1puEvwmA9fGu8JFSh/fIsVOrC443e+4VDdNwsh4?=
 =?us-ascii?Q?jQsMZWozW1wLvBC5LDHjNCdKXvpijZ18Tel2tKg59cBkhqLDJT+wZl7pbszo?=
 =?us-ascii?Q?MWOKxFEVIQmViet0gfgzXLWnzhsUH7AseTZn97u0MkycywvsoLzO/SxcOFEY?=
 =?us-ascii?Q?nqLNjhpv6l6uHFtii8Jf7W3yrHEkCGpUf4LTHdd9qa0sXTDCpvEqRxxlvBbR?=
 =?us-ascii?Q?CYajDAveSl944So0Qgk0eWCr1A2JpJWzkY3e0EyOGsFIxbTrR9R4RZ5troWC?=
 =?us-ascii?Q?1X/SzHt2ohW4UTfh1E3KVkItjDuUMuKSH8ORF8tRWIQkiyfrIgJggNiqU1QK?=
 =?us-ascii?Q?Hx5WTYWD2Q3N25Kd+4lpwY5cykunWJrkNElUKH7oihiIx/1SbhCrjA0wx/Ne?=
 =?us-ascii?Q?8IQKOnFNc/+3RWmCw7ZUAJY3496mBxELQqNeYOdqTaSAtNYsqGj6FrsH2eVR?=
 =?us-ascii?Q?2/gyA83p8tKcZfdyfSj9MnngQwKcwnBDBlw51AdpxbP1OcR/8JYg0Jp+Owp0?=
 =?us-ascii?Q?Yoe8w7EyV8y32OI6wzNlGUcFFDyAJM8v1zt+k0zWx+Z8JG+oK4IrgmOBCwNX?=
 =?us-ascii?Q?fXWtzIWG8I1lHpcqDoCaT7Zxk499+UEWuSpiGkXdUNT+SQPPG/b8noc3Wmrc?=
 =?us-ascii?Q?1En+uqxjV2vyStuMepdaJpmjY/lJXVSzKmtdmWayGeSkCocQG5WeTueGKAeU?=
 =?us-ascii?Q?e7VEBaa1tLBU/VufaJU8+OCGMssFlBCD+2T1LlEUhxsbxQ/gzEw0xD+R7wks?=
 =?us-ascii?Q?Gu8ule4Ah8I+QfP9mDA=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5449.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a00d1042-12c9-4918-1361-08da6497ea44
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jul 2022 06:21:25.8879
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: e6Gcx9J0o6NUvASMt/LPLrUREPC6EkjxXoAm1tRYY2m5rLC+aKTvcZUfiZSr7rJ1nle5NOuSbFNf2V04lmQo9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3482
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Wednesday, July 13, 2022 3:02 AM
> To: Lior Nahmanson <liorna@nvidia.com>
> Cc: Paolo Abeni <pabeni@redhat.com>; edumazet@google.com;
> davem@davemloft.net; netdev@vger.kernel.org; Raed Salem
> <raeds@nvidia.com>; Jiri Pirko <jiri@nvidia.com>; Saeed Mahameed
> <saeedm@nvidia.com>; Yossi Kuperman <yossiku@nvidia.com>
> Subject: Re: [PATCH net-next v3 2/3] net/macsec: Add MACsec skb
> extension Rx Data path support
>=20
> External email: Use caution opening links or attachments
>=20
>=20
> On Tue, 12 Jul 2022 06:50:52 +0000 Lior Nahmanson wrote:
> > i considered the usage of skb_metadata_dst, however i still think that
> > skb_ext will fit more to MACsec offload implementation for the followin=
g
> reasons:
> > 1. for Rx, each skb can have a different SCI and offloaded values which
> mandate allocation
> >     of metadata_dst for each skb which contradicts the desired usage fo=
r
> skb_metadata_dst where
> >     it's allocated once and a refcnt held whenever used.
>=20
> How many distinct SCIs do you expect to see?

For Rx there is no limitation for the number of different SCIs.
from MACsec driver code:

struct macsec_secy {
...
     struct macsec_rx_sc __rcu *rx_sc; // each rx_sc contains unique SCI
};

static int macsec_add_rxsc(struct sk_buff *skb, struct genl_info *info)
{
...
    rx_sc =3D create_rx_sc(dev, sci);
...
}

where create_rx_sc() adds new rx_sc node to the secy->rx_sc list.

>=20
> > 2. skb_ext method is used in a similar IPsec offload implementation whi=
ch
> in the future could make it easier
> >     to refactor this section to unify all crypto offloads skb_ext usage=
.
>=20
> MACSec is L2, IPsec has constraints we have to work around.
