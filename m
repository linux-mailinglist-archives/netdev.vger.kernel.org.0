Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38E1657879A
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 18:40:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235214AbiGRQkd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 12:40:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233635AbiGRQkd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 12:40:33 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2076.outbound.protection.outlook.com [40.107.223.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A3F5E08A
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 09:40:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z8PTV88RgdQXdoQiwur2Caw62adFy1xzYQk8dteeROtRQzVd6HFdfpe13lDspkTIpfNplqe3YVKmWhd7ta1XYFkaWRb6SO4fkE2ZyhoQM0wM1oRdBVcsvKuswBFcztayGCeZvRGzVwIZWAKvAlH1C+0uBgkeaWXBUifVUc/oWn1DpX6tGNQ+FVmxzyzfJ6HDHkV6FLvkKsULHY5nLq0+UjR12vtCaRM0z0Nit+SVazntX4gYDpbOZpWJi+Hh+wVBPTrjXPApD+wfIFy2TA8FWoOzbhVQrMxZWElrdPVNdqUI5LyMdH7AsGj764/+tK86nFLotuVbop/dGSaZ0ZeDFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tcoM1eLkq6dXG6UismK7gCElUQVQqjtrmsqx++r/GYk=;
 b=aOPtIXnzUjybpNkshECjJqrgm8t9Jg3an/44OKi3LFo2lkov13GmcFFtjmWWneHAaA8kpWCh80icPdz9X6rDfsjYWqaFoMrqauNv0XCLVfpPxanaEWTBLNx0G7rbBi4Nh33gVR0Mzwk/299ghtlXJy5GIM/jovYuQoI2v3UoIcgDKhzIXFVM4FvaInmErMmIIP4cwd06dJi8H6w2rr9nmiDcOL/ob7V67qu1ST/9MjBr6bbMtjAn5XJV01nCTEHuhIlNA6wExS4V95DRE69FxY6BqwMj1SjWNQE/isyuLhavW8NjPgZT1JWrS09ppl7PPON9PLRi6WpaNbJn16RkEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tcoM1eLkq6dXG6UismK7gCElUQVQqjtrmsqx++r/GYk=;
 b=XRANCmxvdBBxdiNVpQR8+xxqFi+rNHiuaxeqiFUfLc7onKFN8GtnmuD490fFGidINQTjGPayxXJI4gmVnoMecAw4zQxE2T0hEbNfliUVmkulBLOwmhi9UYpFoJMHV0IM2AYRDNoVwyT78bWCqcikeUni8KwHnLjwu4iBNYawZW6wXSVghv2O6xz2STmTiOEsyu6ryjnK6AXjY8laZ4G3c/309AVfw+0FAfJoIFPKr8OtyWgiIMVXXULYWnQglKaf2N2/BhKM4FhU/EqGSez9avyVfO4tu2gufL+a9Ot7rGHkwsJvetPNIKAJdN8DDHINOJOLe2EF6ZCrDHzawMlWJw==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by DM6PR12MB4974.namprd12.prod.outlook.com (2603:10b6:5:1bb::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.17; Mon, 18 Jul
 2022 16:40:30 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::544b:6e21:453e:d3d6]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::544b:6e21:453e:d3d6%9]) with mapi id 15.20.5438.023; Mon, 18 Jul 2022
 16:40:30 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>
Subject: RE: [PATCH iproute2] uapi: add vdpa.h
Thread-Topic: [PATCH iproute2] uapi: add vdpa.h
Thread-Index: AQHYmsPhPF43jT2bm0m1aWtbt7S4ia2EUpFQ
Date:   Mon, 18 Jul 2022 16:40:30 +0000
Message-ID: <PH0PR12MB5481AAD7096EA95956ED6801DC8C9@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20220718163112.11023-1-stephen@networkplumber.org>
In-Reply-To: <20220718163112.11023-1-stephen@networkplumber.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d158c836-5d5a-4159-ee34-08da68dc3a46
x-ms-traffictypediagnostic: DM6PR12MB4974:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TWS8bFACz/vLunylkuXt+C2dXrbT6aoVI4R1JwwuWyBLjQfBG6jrBUujiLg2v1qjgQs5W1F8jgpBp4/dwd/4aaBnutIGC50fWT9X6D8U5JXq3B3AtqGIAQ0Hbt6dIQwcQzkZCNpA0O2F7kE3BWNIELQK8C0cMSa5bcSa7a4gmMixCFKDBdkPHqUEJ/RtYuFChHLLe9fN3Z28ezDTAQDNuoynBHdIgQQQNU32PeDPEa+cEJ1gcCeUlIysOSgBVttQQsSGcJEU9ibhGvkUNp+kR/cQQ+Et6ksDTLd0kEfKTLtuNFmjhgxlzzvtavi0luTuA+V7C+4YCH+Gyslj1atz/YBWAw/pAjRYsjU7WeI5dsciRMY/YMIHaKKAZsk77ZFlC+MEHTA0okdf6GbHlQKuCaIq0e5QVhIArUzM3bbSzq2VISTSqft1BE/T0r0VoV6/Q3NtKDNx4jqxhauO+zAa3dIsOxnksbZMc9zHoYvx9DqSjbK8++Ewnb/b4J5YAWN7gPy5swnWv2MKU0j5zdXniBIjRG2Ui6aA233vLXpRJjzu4887I/g1iWlKsskw2s9P3T7GIQq2LLRWlv3+Gb60aVJeg0j9y5HpVF5LQrQQi2QqPEVIbaDlrRT1cSgI9jLWEzW3FGW+TABFIcisi1h7Y/DqOb+bk/m5clPtrS5scArdhHuzW2yJi2PjgX403JTOTaKvZQSA6DY6OPICYY6f5rp9o5Q6ggcQ19xx0ZPYuM/VgD4phyZTkxZqWhpqVAMbdQtyiRJsKuu95p3UHRTF47cp2ojNT55n5CAWdltscUTSsbaduJVoDwpqQ1UudUbt
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(376002)(39860400002)(366004)(396003)(346002)(54906003)(6916009)(7696005)(6506007)(41300700001)(9686003)(2906002)(478600001)(71200400001)(55016003)(66476007)(66556008)(66446008)(66946007)(64756008)(4326008)(8676002)(316002)(52536014)(8936002)(5660300002)(122000001)(33656002)(38070700005)(86362001)(38100700002)(76116006)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?BD8kHaO+84Eg8AfXtkMcNR7QUedOx2EMneWSYR2XyJAw4UhSmsPkrpbEZygZ?=
 =?us-ascii?Q?gFDgKBRCgQRyUn+59qkNnD6pTopzz2HfvTORsDV/JAQSFM0EmrxaCecXPn+K?=
 =?us-ascii?Q?xGlh7KWUHmJ+aSUjFmDliiApIBnP6iGltlRROLu5SunCLdO487p/LadnEXTQ?=
 =?us-ascii?Q?wyXzMXiNxTQFEeyMKEeYlM/Siankz/cTEb/41tV3pIC7mRN5iFWHEm5AY8dp?=
 =?us-ascii?Q?MrWw4/pFngaE+/D65yaTnOyIXhCCOWwgl0cF6UxX6Rr35G9/yIBV0rO4dm3B?=
 =?us-ascii?Q?HgdinnUyV0lZzKO2NWfhgzlwiG7dbTZNqQGgH2W8sDg9EqpIxMSLb8EFxXJn?=
 =?us-ascii?Q?/NZppeqZv8gltqUauEWx4lNDa8PD4VFlTVqG+YKVfWWKX9HkzRbFVZdoxocz?=
 =?us-ascii?Q?kcMZjnhkJn8kVjywGbit5Jk90OKTYDvhb6zKPHOUWkTXENs/8ttjmlQoJaJl?=
 =?us-ascii?Q?Z8nR2efd9jR2KFVE78KZ/ejzSeyHczwsci8s6Gt2E72LgPltgQDUsKLwKtxn?=
 =?us-ascii?Q?K+cXNoYJh/HlVZcj8yduXy1A4FroXp4PKBI4bBgMXdzUIkzU11JPzhIV6paG?=
 =?us-ascii?Q?eyJ+IyV5gK/cANnb7a7X8xxhCfea3DUu2mgzwkKiejQ6C6cMNq8W0bnTHbeH?=
 =?us-ascii?Q?PbXFGw2OmPRphOzIi1avHDIJ2k8E3Ww3t4Yafp2vMweFx/7DgxxNfui3hc4A?=
 =?us-ascii?Q?/XUpHrvqRyYEwy2I9NPpIBZTDO6mo89y5N8BFV3XdMRIyYLOwzHmPH5kClGI?=
 =?us-ascii?Q?FtMJB264HPacsh+DVvkRnyExVjjpz1hgUjzw2LDdreYtnD7ZreIhXwnQ6c92?=
 =?us-ascii?Q?OSG3iIH5vHLfLulaHi60fHazqjjkwJ4gBWzb28AfbQrtAGbyuWSZmM44netf?=
 =?us-ascii?Q?2e8XSOdYP0irSmkr4Ul1rxlBsd8zbTUQ+b/KIXopDe7sc2Y0CUDwG2qo5ysB?=
 =?us-ascii?Q?/C2BWZsxTBpFLto7IuofzJyX59W96jxnSsqknq8IT+HmYeui0G4HeHLzuPC7?=
 =?us-ascii?Q?3YcfSHaHqzN6C1DwhCqg5STjD8hYI/aEnoVTX2rRzgZC0SEESCfT6kk1QX6x?=
 =?us-ascii?Q?BGFTnEB7MKeIisMtQ9krfHzs/UndP2OEL+TkfScdTtOwyVrcstbLw9ZevVDr?=
 =?us-ascii?Q?vN7vH1uX/Vt6hvs5W2OtegxnxA+fggLbcjZWuaSIqdeisTRnf9tNV2GqLNNX?=
 =?us-ascii?Q?Zt9Exd1FbXGOlJctP9kgD3vv1btyx75HFMWubhuapJyUxcPFv24T9PR4ZMNu?=
 =?us-ascii?Q?7Vrtwp59TyvlzzzGnin58CX7n8/xsgDLCI0ibcV7j2Qq6q3Sy5TNH11avbbf?=
 =?us-ascii?Q?M1ZVNirYyo+wQN/15HyM6uSyWpnH/vOPbPaEGgmR4J36Am7pMB2SEqd9CZe9?=
 =?us-ascii?Q?3+7jVUdyrLeEMuPw4brSEgP3+cADyJ/yqthA8kWJBlYKiZTCmzfFOYQF//GJ?=
 =?us-ascii?Q?suQD9O7O1RyYpf8bMSkn6qBLeARhCLgXjPGvH/tY5G+LceYGeLhfsTcttmf4?=
 =?us-ascii?Q?mTbWbF3xcZXFAetJJbWyqFLQ+pEsKkd/rF+B6htqi8AGW4atsk+l0ZLVqNeq?=
 =?us-ascii?Q?k6tSlsuEnLAYL2hSqYnOjpr9gP35nS8xvOx46zG3z1GpiYpdteuxKAEq4qk4?=
 =?us-ascii?Q?X5r/rVulrE//31mpk3xUgPQ=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d158c836-5d5a-4159-ee34-08da68dc3a46
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jul 2022 16:40:30.5699
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Wx94B9WBL6BX5wdHydyWJG6j6HIqVG1proH4O8CiLTTk3hgNxuyWJhoHI/wes56Z0MfMxTxjTMjmD0IRC6v1lA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4974
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+ David

Hi Stephen,

> From: Stephen Hemminger <stephen@networkplumber.org>
> Sent: Monday, July 18, 2022 12:31 PM
>=20
> Iproute2 depends on kernel headers and all necessary kernel headers shoul=
d
> be in iproute tree. When vdpa was added the kernel header file was not.
>=20
> Fixes: c2ecc82b9d4c ("vdpa: Add vdpa tool")
> Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>

> ---
>  include/uapi/linux/vdpa.h | 59
> +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 59 insertions(+)
>  create mode 100644 include/uapi/linux/vdpa.h
>=20
> diff --git a/include/uapi/linux/vdpa.h b/include/uapi/linux/vdpa.h new fi=
le
> mode 100644 index 000000000000..94e4dad1d86c
> --- /dev/null
> +++ b/include/uapi/linux/vdpa.h

We kept this in vdpa/include/uapi/linux/vdpa.h after inputs from David.
This is because vdpa was following rdma style sync with the kernel headers.
Rdma subsystem kernel header is in rdma/include/uapi/rdma/rdma_netlink.h.

Any reason to take different route for vdpa?
If so, duplicate file from vdpa/include/uapi/linux/vdpa.h should be removed=
.
So that there is only one vdpa.h file.

If so, should we move rdma files also similarly?

Similar discussion came up in the past. (don't have ready reference to the =
discussion).
And David's input was to keep the way it is like rdma.

Added him for his inputs if something changed lately.
