Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 099895E5FDE
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 12:29:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231282AbiIVK3K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 06:29:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbiIVK3J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 06:29:09 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2053.outbound.protection.outlook.com [40.107.94.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F94BD01CA
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 03:29:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VtMzMlF/rb0K77qZm6rmmZdVRZd+FBaiAhKxppIguDx901/2KYJ01WklHjAUAq46TFFjP/OQxRxQDRi08EdLmeCA6n6EuRDgDnFiRsNNxF8xcV5ujMTc6idAcC+AWPMaJhnGAPPMG34wJB63MKMDdiRcawW7fPHoOU7O8ywzuKitpdIEuv6x5tzlWTbMvq9AjbDj3kXKWhUhwzZbDbfz1gObVoqvqINrkkONENl9VjI621zeS00/skVHxUy5z5ElpjiWQg6XYNy2ippLqcKUbVnfh3xofDzfSuYrSfyDslb6vXpkKJIDSdqVtqj+uW3GyFwMEi+hBGNcCdUb8wHHZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gHiILdCTfFciszWE8XfVw5tPG372idwgI+2VS1FyMwo=;
 b=NG2hRFa1+SwChRmnKoGC4Afx3ej9q8HvBikwAc83GHKw/5y1PAJqjNpVFL2nMmaJnzSamghOA80+vIWy1iHDDRpG2Z91s6iZAwkBCrrMEWXbMg34rFHLWeaF6nph2QSmVPmBi29GA/gl0cti9RQk0VyK2tShIanTfaHXewVvbAjcwb3y8x+rgmN42Lz+C7Yew9zKx7snqfcJNY60JVl2xrRZPHOgSXkvCA8Y+YIVuNu6rsXxJbw4gn6uKRAoCspMWNvXQgxtRtbDQ3NjLKyy1WavT6hEhhCRbKkPCpTCJ4z1trkyEsb5npGIbW7NnwBWMIvp0tugdPUpFUAqrrTINg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gHiILdCTfFciszWE8XfVw5tPG372idwgI+2VS1FyMwo=;
 b=nCBdj+G+8Zud9QK/Lr221EDss7MBO2YCKmAGeUFmw3n0O5C92errbZWzDsIW+0KXBrjjfmsD1PI5wEZU5rqI6DVkDZfgdD6wgn1OhE6vVnxlRRANk5wl2vPXfwDUekwZO7Y/q3Ey5G7WZ8H42EAQCDcnAh3aQecRB6MKbWRPEXbUlguvRPNh+YwrsmOuxQMCGgSHPayysUSOkzhLUt3wCQAExhVdSlaHxtZh1DSxGYIGybQcLuGXjo2JYLkB7cGnoFx3Kc2/PAtfkbTpz7TLanBrIShMDVz4AM5aoWoFoDNF1jxW5gHj9S4dF9EjTND9i3A57gdbqCbHcEzSS7cyww==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by BY5PR12MB4918.namprd12.prod.outlook.com (2603:10b6:a03:1df::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.19; Thu, 22 Sep
 2022 10:29:07 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::1429:e3e9:dc54:ba98]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::1429:e3e9:dc54:ba98%9]) with mapi id 15.20.5654.018; Thu, 22 Sep 2022
 10:29:07 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
CC:     Gavin Li <gavinl@nvidia.com>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "jesse.brandeburg@intel.com" <jesse.brandeburg@intel.com>,
        "alexander.h.duyck@intel.com" <alexander.h.duyck@intel.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "sridhar.samudrala@intel.com" <sridhar.samudrala@intel.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "loseweigh@gmail.com" <loseweigh@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "virtio-dev@lists.oasis-open.org" <virtio-dev@lists.oasis-open.org>,
        Gavi Teitz <gavi@nvidia.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>
Subject: RE: [PATCH v5 2/2] virtio-net: use mtu size as buffer length for big
 packets
Thread-Topic: [PATCH v5 2/2] virtio-net: use mtu size as buffer length for big
 packets
Thread-Index: AQHYvagejmrtcrshK0GYXpgvFbRGE63rUekAgAAHfNCAAAOhgIAAA8Og
Date:   Thu, 22 Sep 2022 10:29:06 +0000
Message-ID: <PH0PR12MB548150E063647B281671B341DC4E9@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20220901021038.84751-1-gavinl@nvidia.com>
 <20220901021038.84751-3-gavinl@nvidia.com>
 <20220922052734-mutt-send-email-mst@kernel.org>
 <PH0PR12MB5481374E6A14EFC39533F9A8DC4E9@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220922060753-mutt-send-email-mst@kernel.org>
In-Reply-To: <20220922060753-mutt-send-email-mst@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR12MB5481:EE_|BY5PR12MB4918:EE_
x-ms-office365-filtering-correlation-id: 21729123-5eda-47f1-0a62-08da9c854779
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: p2FAasXmOU7DGa5Fmr+f/wV/H7FI8DugIImrGfTNVWWtvowRjzpaXxoumLi9nek/e+6rBctyyuioqmEHkHFfpuPoZd+uD4sOgbgXDq/PwyYH7x0ADR0mR0qjFXBrz/ouJcsUgaCCqwSOET5/eCjpUKn6A+EI5L7VLyczPVIgAK0t+f6Audvdu9YMoPsvpDIQzVA+JsygjdKtc+jsnKLkCO6yE8xJeQsPPlYLngMaNbh+qyS0dcEVntpttwfMlINnSjRAfEZOAq0RwF5O9vpOWkEED/qGbTXXBUoSLL/rpcBtsPwAEw1z2Pzf2y4KLYU3Nkxi/wuICgYGs0P3+gyoiok1rfM9L1yRE5D4Q7AvA+oBYOGy38SbykEst8mjJs1pXY9KGdcIEP0Jjb9oG4DvYwpiAZf+CJxHFaRirHSNa2fwvhHpcDpqTitmS+gsoW579S9ILRiPlsXO9ziVLo8USZ4ekfd5Eo3TRnk7P8HeB4l2Gba0ePeZtwKUXF906jjCxLqTvG/9QvRxaVyIjg1DyqGrbHaYE7ZGXeptb5TsoJ2VpyUeIPzzsxWF+cGPEBu22cYo3B/A+LJWgSuY3TcXyklDOk7IhArvY8X22IjYQe6Qivi+wj8Os9FR0D7M7tHk4Es4vbJLY9hIfGe4X6eXRS6GOgolJLq9WvKRDBsDmKFfMFwVLzkZ2eUYtOPHx6upESZEs/ZhKUUlUiBkNLvF8Ksq8c5x8VRGg2QPJ/b76caAMltYUNgiLkI+5mjDWzzIwd6NENibqR76grOuAEpQFg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(396003)(376002)(346002)(136003)(39860400002)(451199015)(83380400001)(186003)(38100700002)(38070700005)(5660300002)(122000001)(9686003)(7416002)(2906002)(41300700001)(8936002)(52536014)(55016003)(478600001)(6506007)(71200400001)(7696005)(4326008)(8676002)(64756008)(66446008)(66476007)(66556008)(66946007)(76116006)(316002)(6916009)(54906003)(558084003)(33656002)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ZUOEaIyiFcCC29Rpmp2y5LxrticfqDnmbUdlAKE2O8WVoP2TUZY3M/80s9t9?=
 =?us-ascii?Q?EzgZpE4BHnvHQH8URn2LI/04LAwQgxn3iQotZb4voMDNXvd3zoT1lQ72Gz2n?=
 =?us-ascii?Q?3qWH1yemAUFPRZxz/wnRbc7DbcHVymH68KIz4iXRddXlcSq9tv3dQ6/aWK5J?=
 =?us-ascii?Q?x0Lr3JOtMNU7ZpNY0ODQz1/jS69aGzX87kzY0zP4xh+ViqC37a8iaYkLNR0s?=
 =?us-ascii?Q?LlDWrC8tOLhnWMqDdCHPD8/p6vNPKxVH6cMYmJ/kfnEQPHnSkLnhk5csBhzR?=
 =?us-ascii?Q?Jz+jtPeWdloCBUuUaklXscofnxtlWtEZh6ARd0+wkSx4TLNhZHXP8HYRNppS?=
 =?us-ascii?Q?0mvF7kvrSLyKubnHeVUR6KnsXL1m3psWMP9wApYbdEuMmE0y205WTMV1ip7J?=
 =?us-ascii?Q?rahxHVRwcFGdjqo2KtMUOJTdsNA1mBYjqE4zc9bI4zYwGOjKaJQhNLZHItO9?=
 =?us-ascii?Q?M7L/4STDdD29PvcPtO+jjPssKL0dZhrDR3KvWEZ7fyIUJ2QK1THNTPv8BSRx?=
 =?us-ascii?Q?c0ROUmlzwg2Apsse0gVwI1jM3qzh5o5He2gyepJis7j1YBWoG66HvNKMbjXx?=
 =?us-ascii?Q?Cx6i8LEog4YMIwivEMlwB+JKq9NKYAMUmAPsY+2pjPz9AwN8kGPGXrHdb4Sn?=
 =?us-ascii?Q?3+wOIPsqkkL40ZrgIFmLPoAwCFVKs8U3izFQx2ys8OLy7/oBE/S5SIvAN8vr?=
 =?us-ascii?Q?dMftuClkO9ruGk9Jav5vrGVhV9nQ0xE96Sq6y4tpnWche65Vrv1pRis10Cdf?=
 =?us-ascii?Q?Y2g2LLtZvjtxkkbUwlMGouz4GPj/ofOCJRn+ijR9pZ8DrLJGLeWTAWsvWGS3?=
 =?us-ascii?Q?jgJA5AUwIhWfA9Vx4y7MO6Pmbhdhvs0E+/N56F8E+cSIrTHFNcc0VprQBJVc?=
 =?us-ascii?Q?JBGT0VfcOF7PV/giRHQYxPzMg3hIlV2Qz7d0Uol7cAIGhi7GnAr44HGgruhj?=
 =?us-ascii?Q?YpBCdseHhxIc38TyocNN7Qu87E6MqJ/iZwQFY4bOTUvEhir9jLFj4mYzvu2E?=
 =?us-ascii?Q?0AzLMTQ3LnSiXXJ4Fa5nTFMMM1/Qp11NzdKIWdilr9w3OM+PfX8fNAH6P+lv?=
 =?us-ascii?Q?BwGkeioCrkjIZNk6TTufytha5w15CZBLUIbjGWWV0QJxqbRwwO/kXOKzG/32?=
 =?us-ascii?Q?9xBhq9kYIlnyF7SR2GG3F7c7i+0EJIVyQgpxW8WDlUd4P3KPNoZ90hL5zIKE?=
 =?us-ascii?Q?RW0A2xjBY0M1TT9uU8tzL7X/q3fPJ73cPS0pM+5IqBUlLKIlTp3t6M7Kziot?=
 =?us-ascii?Q?hEZSkdELBz1qTTx+raV4e6nLe6FaVNPCPm+/g25CzBAdt6SYzvp85Fa4buZT?=
 =?us-ascii?Q?llPJiPX2kEyPGyJWrzqphnsRfxkSnpgujVTFs/T9c34ZUbsQ/QlUCF8e+SQB?=
 =?us-ascii?Q?ADLRFZqQL9zdrx4sYvoJGao8BhGyC+asZlhVqyOpHmG5kQfQqS6mPN0JkQdA?=
 =?us-ascii?Q?tmtcsCj+i9dQD9Qcah+ISJ4c1xcGqUyG6VIh/Qh0F/iPXnMtU/6VeG7eCsG5?=
 =?us-ascii?Q?Q0qq9t1wVmPdDGSGLrUNYb8hvoT47p+B6TB5qR1ZEqvaYVtGeQBmXIvEimPQ?=
 =?us-ascii?Q?ipWkpZFX4upO2ZMbVduv2wkRRJaXw7GgWikZS3U6R0yVCcti5AM6qwePE6Nd?=
 =?us-ascii?Q?GHwDt1oUWP/YaB3HuNLdIvQ=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21729123-5eda-47f1-0a62-08da9c854779
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Sep 2022 10:29:06.9888
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FHeoslwgyc3eUfLgSoyIKIws0xe5UPw8XhRZft9gerfuOLa+l23UNmRjfjJufGtclBP4mHH3R3rgcUYWbEd0ow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4918
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> From: Michael S. Tsirkin <mst@redhat.com>
> Sent: Thursday, September 22, 2022 6:15 AM
>=20
> It's nitpicking to be frank. v6 arrived while I was traveling and I didn'=
t notice it.
> I see Jason acked that so I guess I will just apply as is. Do you ack v6 =
too?
>=20
Yes. I reviewed it. Gavin added reviewed-by.
Thanks.
