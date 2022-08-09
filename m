Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CED3F58E07A
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 21:49:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239083AbiHITtN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 15:49:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344569AbiHITtA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 15:49:00 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2066.outbound.protection.outlook.com [40.107.101.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 390D9DC7
        for <netdev@vger.kernel.org>; Tue,  9 Aug 2022 12:48:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ftbugF4id8A8VQ7mgNfabTmtaH2AkwVSlqL1qUo48yYbwLt3wyCbooi8xlEzabbaddi//GNEqEABHajqRhjrrBvstcceH/dMFGBUyjrNpznkI1XIpnMk01DakExQSSrupIJkZklrCkJCorpvnj1PyGt+Jtvx/AJDjv+sCL1PKi2uzbkK0RI/SG6T4NEaH2X6BgzX3sIcn9sxMhtnF1tc8t/ZwGJit7zwD8wnmxkyz+J4dT9fQ03yJdQ6WARLPQtz5RBJBpwus3kycu4MMJVSg5oJJKbIWdMe9o6M9N4yVlEeENuV+pHG8PuBh8GQHwMtldq5l9Tsedft90oZJtoQcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k+NY0tmSk98bxoq2ZE8VIrdTeu5juSycP9BuvXLrXV0=;
 b=jj7sRickK2AhNI2XQUNTgZN89FMPnyDtdxCu6JK/9nc9VLDJGFFmMPovRv6EvBHrEl1vG8Y/ppndu3bE99AGiAKo6LWqQCxSeQx2fFTetPmoOJXMDEzbHr3tWtfAnJbNEkLOKXXiqlNfUGTh+jR1DuqxpI7YGbtLAH9PJbzYWiTb1QyhpqyudxpA1MdbXNqgGlkXsS7wt/9QyiS8ppJWtz1y3nOHZdy19FVJkXD4/PqKhr9yoc4drUn2NDoOd3i1Epbk+O0KiqUWRmXRi6n4xiHw725gXv6Pljr0dw/xRmyl92Qipxde8r2fsobJ1xu2CTQRzcPTdXxiv0GJ1Zh0lA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k+NY0tmSk98bxoq2ZE8VIrdTeu5juSycP9BuvXLrXV0=;
 b=eUX0Z/Wt497phPtu90/kzF955qrvXZ9Dlg+UNl3bJvQfpCuIjrGbHLaPn/bop++XgHYKdl+U/Gkeht6R9CaULWG3Zw4Z9jONizWibfg2TJ8fH/Ul3VaR/+vsq+yZlGboM8346QJk/RfeW59UbR6BsnaX0tb3YntIIpeYCi/vSRkphVBMA1j/lM2l14qY50+fPhz0meqTO126o6X9E/qgKKK7h07IhB6nXqM9BybwQo42DEmAwI7rmJgxB5RSPuwatODOtbxeFsnpAr8Cw5kV2rUR4O4CZw9bXbo8Z6N9vVt+503QqtKV1m0u2j3+poJdUKBafUJms2jLYXBXv9fwJQ==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by SJ0PR12MB6966.namprd12.prod.outlook.com (2603:10b6:a03:449::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.16; Tue, 9 Aug
 2022 19:48:57 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::957c:a0c7:9353:411e]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::957c:a0c7:9353:411e%5]) with mapi id 15.20.5504.020; Tue, 9 Aug 2022
 19:48:57 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
CC:     Zhu Lingshan <lingshan.zhu@intel.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "xieyongji@bytedance.com" <xieyongji@bytedance.com>,
        "gautam.dawar@amd.com" <gautam.dawar@amd.com>
Subject: RE: [PATCH V4 5/6] vDPA: answer num of queue pairs = 1 to userspace
 when VIRTIO_NET_F_MQ == 0
Thread-Topic: [PATCH V4 5/6] vDPA: answer num of queue pairs = 1 to userspace
 when VIRTIO_NET_F_MQ == 0
Thread-Index: AQHYncLEMRm26lhNu0yNCaNFKnyXX62KXhiQgBy05YCAAAFAYA==
Date:   Tue, 9 Aug 2022 19:48:57 +0000
Message-ID: <PH0PR12MB54818103964517F3B1746C9ADC629@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20220722115309.82746-1-lingshan.zhu@intel.com>
 <20220722115309.82746-6-lingshan.zhu@intel.com>
 <PH0PR12MB5481AC83A7C7B0320D6FB44CDC909@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220809152457-mutt-send-email-mst@kernel.org>
In-Reply-To: <20220809152457-mutt-send-email-mst@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 14e683c1-03a6-4e36-cbae-08da7a4032d9
x-ms-traffictypediagnostic: SJ0PR12MB6966:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BHr7YpbwYbys1hVKmfuaOelbMm+135nrBkG73B2SeAE9ikopega+lcmCeag112RcMKw4mS2gMFq/Fq/eTzK8bKBHHZG9GYdybLpLL4p3+3rhZO2BJYqYB41sCajGh339NK8uahC5rTfYA6g4u7y7/Ty2YcMtTZ9RwuerApK++bti1dR8WyvGZiaUAvaEWlaIDELLTwXPeNMtlaRdRmAA8T1ce3aiimqThO5/u+yzBirUmQOE17lTHYRf4lsX98FNqczuOW8dRYxSqmot8RDL7w5N+yNGnGjHH3Xa7tufcq+kHxPAeAXPodBmRzrFmD7ctfCKzU1giZ6TyDMu8Az2uZSDQwC5C5+U+SvxcGvd0LIQ3wPVp0NXiPtvpvScV++2U1x6wkjhY+knstxCWV9LswfoD1GAY4V2SgtkuPO9I7SIXzkunuISccjFGZx303yY07GP2Sn0KGQJvjM7l+0iyCVEbayRUItqbzWezNdsTi9tX5PbGYvB95+ZsbcA5y6RLKtPM6N3f68Xb2PaAI9lBjCIAbPotOMhJEq7noJjTdU1X1R4yUtaVRo4ZNnDWL3H0FtBHnnGxZB+KSP1vWh+hr1/6L15prWFAA4yrnrXKe3xT7r/JjXHZ1giynPaMdNRKha3kFIOC9bndHIi4GzOypEPE7eQmxcL5dElW34i04fCkqH087mU3JE0tnzpGwWM2z0pq1+ojWmzjqsnb1simk2oMM4hEOhBRA458GMzvwxk0lyA0ABWapzdQiNR53IIB+rDx69A1xvWNjVstnoK9Dv5/pPKKWQMX3vl/AuTn5R/b+iYHTaPjodKBRk+laaK
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(39860400002)(366004)(346002)(376002)(136003)(2906002)(38070700005)(8936002)(38100700002)(122000001)(52536014)(66946007)(66446008)(8676002)(54906003)(64756008)(478600001)(186003)(55016003)(66476007)(76116006)(66556008)(6916009)(9686003)(5660300002)(86362001)(41300700001)(6506007)(7696005)(4326008)(26005)(33656002)(71200400001)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?FvkGt3SahyUB9hly5Ry31FajcYLwrxfG039oI2B+c7yXSgNZCdMI/nB2WjTS?=
 =?us-ascii?Q?VAEnq6FvJowBtG4sCQbAECHSSzaWV3v5SK926L9Jzu6NN0d1m+bEEbCbi+fl?=
 =?us-ascii?Q?j/LVZomxF9qKdRFLFur/Wlw0AqZl3TslsIpFq3sZ5YQh5uzA2R8WtRpCm54R?=
 =?us-ascii?Q?wina9xOmrQadBva6pURS7sy3bVFyFAxPKOS2oy/3bXaT4VuCe6dc0wjxw2Dy?=
 =?us-ascii?Q?mkdbQn0B6zVMzvvjK7G9e/oSf/9E1sFnE9Q2tvF8BBvKuV6sFgdMIY/JSdmJ?=
 =?us-ascii?Q?DzfJgcEQ81sACljh3mQ+m769titWOVW3CnfOaUdj5b3ojeDUeJYPhrdxmYUs?=
 =?us-ascii?Q?4d/pv53AfTACblNJ4aLIQ7mzfI331nEJPJ+Lc/8IklI7Ok5mZeUFaaOlWUMP?=
 =?us-ascii?Q?dW+Iv5lKNRN6//1utSdp8p6cqsryVChrBWFustvz2vQ5GSAVvsdD3Z5e6tL1?=
 =?us-ascii?Q?8ymIbq46Upg7MoDiYHlPuzwICgrM07y8N++hzuwBlTl/y1Z1o9pZRV4HGOAr?=
 =?us-ascii?Q?RhR1MauMLt5gfOPHlID3pIK1r3ycdcneTC5yoaePU2X7XA5QXtEv18Yq75HO?=
 =?us-ascii?Q?+rxnw+c20hlXEF5aIuyrjmpL84rjO2CGnlUNjCuc1L6Tu09FOFXsOREuvmL4?=
 =?us-ascii?Q?Ru7vhUqWfcD+C1duSDHaauxfGgHgOcwj+rnRV8Z2dIvIg5GlP/KI/kL2Zlpq?=
 =?us-ascii?Q?f8viTvMcoCczbvOHfcOuCZmFeyj3wwh4DBybvwCHLnCttmxLY1My1Yq1uu56?=
 =?us-ascii?Q?PEn93SnhHPRb9gx0SI2UufXZsycncZ33YEfsUvIHKJ/+mSDg4F5WkLdRNuHZ?=
 =?us-ascii?Q?er31IPGUtoOh3OloPhXqQ0NWpZ+HbUaerdYASL45+8NP2G1aJFBb7sGFGCLv?=
 =?us-ascii?Q?ginyLZZiMuPifb0SAVlc6eevEVtsclAar8UY8HA+DRP/OZ5jfxnnTBnGtDgq?=
 =?us-ascii?Q?EXSkUQcdEHulA6SaHq4lEDhAQM2Zg/F2nMgqEI97X/kGubdRLpaHNnYlXbKJ?=
 =?us-ascii?Q?VPEpOWJ/epzraDQGhPRBAazMk6RBJx8kIAS70OFZ9sDmf5X37jMDDFx6Q8Gb?=
 =?us-ascii?Q?LMGPAbBNUXqn2P8zojXeFyNy3Q69RnIazpr2QnHJ6PcDnyQjDIQ3jGgwikMs?=
 =?us-ascii?Q?41sTT+rN/9Gl8e4EUgzEi0hnfbuwGsD7OABspHDJHCoVFvplcQXwsPk6MZ64?=
 =?us-ascii?Q?o2GKGojFzy/Q8JOLmQdtibhZQXQeN/rTbvIivNcr54HWyY2zPyqx+NJHjTMD?=
 =?us-ascii?Q?ygQExZLTcZ+Iymb7tkwVlykBiKmLd+H4dxQcpsfMd40U4C7nlahIMpgpARYo?=
 =?us-ascii?Q?Y+TSG9LRSe9kVb7Ivc+AbCGnUhXZS4mmfs7qDNChPO4ZgBSaspb/waQlYdds?=
 =?us-ascii?Q?R+fzGe6tgEUxXxb+sDAwgib2NKeeIA7UmWsTSfR596Q8omw3k3CgXSXtPPg1?=
 =?us-ascii?Q?CemueaEW/+RByaYt/Vwncm77ZIMrRRKKxaPrp/IQqsAPEGUHtWFYSvTnYYnN?=
 =?us-ascii?Q?Ab5TmcdzRbdIDQJOlPt2NSKW1U8BaCKIrWQYtCpmGR/31LsKpNSICzmYbr8e?=
 =?us-ascii?Q?EMUPyoKTdm7Is8zeoCU=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14e683c1-03a6-4e36-cbae-08da7a4032d9
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Aug 2022 19:48:57.5820
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2atbJkeIPGLwuR8hfodjidq+P5eESL+6+VtMPYq4I6za6rF2vFcRX45yjMUKpv5p7dSbv2fA6moMqybEmnrh3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6966
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Michael S. Tsirkin <mst@redhat.com>
> Sent: Tuesday, August 9, 2022 3:36 PM

> > > After applying this commit, when MQ =3D 0, iproute2 output:
> > > $vdpa dev config show vdpa0
> > > vdpa0: mac 00:e8:ca:11:be:05 link up link_announce false
> > > max_vq_pairs 1 mtu 1500
> > >
> > No. We do not want to diverge returning values of config space for fiel=
ds
> which are not present as discussed in previous versions.
> > Please drop this patch.
> > Nack on this patch.
>=20
> Wrt this patch as far as I'm concerned you guys are bikeshedding.
>=20
> Parav generally don't send nacks please they are not helpful.

Ok. I explained the technical reasoning that we don't diverge in fields. Al=
l are linked to the respective feature bits uniformly.
This I explained repeatedly in almost v1 to v3.
And reporting 1 is mis-leading, because it says _MQ is not negotiated, how =
come this device tells its config space has max_qp =3D 1.

But if you want to proceed to diverge kernel on feature bits go ahead. It r=
equires inspection feature but feature.
I just don't see how this can be well maintained.

Commit log doesn't even describe the weird use case that says "as user spac=
e, I do not want to read device feature bits and just want to read config s=
pace to decide...".
Odd..

