Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95E165B0FAD
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 00:11:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230040AbiIGWLw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 18:11:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbiIGWLv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 18:11:51 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C57D69C1F0
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 15:11:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z4rActdiGZJQjDnfdnt5jUrkL66WQrIZJRT73P/UkjXjvXx1s12UD6QR4mhXmwFHIP3FGTFAgUA6M/GNgbcyOJ2XCtBrM8dYrjqta/IPpF1f5X173hM+rj+v/aJSI8MSmqEbp6yVrw8inNTyAOZNR3MJ3anj9TlcQV6KqiYjO9ttoCz21cP9Nb1roaZ2/lLKvOcAYKnfNaMzYfx+MTmd2pBdfIL2ydjdshArHuz51yqE2QKC1A5GlbvATZh1iSKyZYXQ4q9xSRqgVMefTCraJeVzLsQIDps6A9taWD9DRMrkpK+jf+oSkdc04q1aj3m+LfW+RXNhsDBu/OpQs49SPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EtKKe3rrkpsRvU/7NIqkd6fU5Dako9KCekESepysgM4=;
 b=IK+S7+adrDd5V9CJ8199WctvzovYpmO2H3oQZfjHQ32XHZgcWHv5bqRygCE+3XVkqez5Y9FCVN14p9+L0ylUQOUDMw+jr/mClne/K6AZwgAjvOy5KtZ83J5RKroA1Xl/8QcCqKLg+kZPaQ5fySxfeFKAPAoGp2ZxEPTPQVfbR1EwBAaG2Z6PKApKj9/8F3u1DGLTq4Rh86VaEclLTx48y2AsIxkDjFOFS/b1cU2Ny8xuoVmBclDBjJ0ljhPzE06VubrXW3hNsX5kLKQJnwal5mfby2EFtraDh9gJuyfEud35YBuswcz4D3OQBBna9GQK0u3pSVfthbloyqZRF24Epg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EtKKe3rrkpsRvU/7NIqkd6fU5Dako9KCekESepysgM4=;
 b=h9UxTZfbzm5Mkwz1jTE0Y9NAHS8Eb1cRUTRXT0WPd/J51Ud0lOeZcfUWbZFdA8pyi8lE5wWlO6WCbZy06Z6+UH2+qUhuazuTC4X6ardgadBQvL+B8lgAxBECw12F7W4oYS7ezxPEnLnyZZPnsqDgdXZZ8EkIoX/9xDUo8Fi4MvktPV9nNw5YKUC5z86JnvqwI5l3KbiUCOsqFh6KCX25S42UZxoQ1h81f6LDrm6sERZ+clZ6M9ALuX+72rQeASTUwgWKIsa2HNZXh+E1RaFWizvySX6EOlY3RmOvB9uZoT13TtMV29yGyX0zXWy/Hc2YRGSP4DWt1keVPanbhhwjOA==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by BN9PR12MB5308.namprd12.prod.outlook.com (2603:10b6:408:105::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.11; Wed, 7 Sep
 2022 22:11:49 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::1429:e3e9:dc54:ba98]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::1429:e3e9:dc54:ba98%9]) with mapi id 15.20.5612.014; Wed, 7 Sep 2022
 22:11:48 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Si-Wei Liu <si-wei.liu@oracle.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
CC:     Gavin Li <gavinl@nvidia.com>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "jesse.brandeburg@intel.com" <jesse.brandeburg@intel.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "sridhar.samudrala@intel.com" <sridhar.samudrala@intel.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "loseweigh@gmail.com" <loseweigh@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "virtio-dev@lists.oasis-open.org" <virtio-dev@lists.oasis-open.org>,
        Gavi Teitz <gavi@nvidia.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Subject: RE: [virtio-dev] RE: [PATCH v5 2/2] virtio-net: use mtu size as
 buffer length for big packets
Thread-Topic: [virtio-dev] RE: [PATCH v5 2/2] virtio-net: use mtu size as
 buffer length for big packets
Thread-Index: AQHYwpEbqLdY6RByfkyoSMo8wpA6EK3TsrMAgABG8oCAAA3LAIAAADnAgAACroCAABYGQIAAJjCAgAALaACAAAQwAIAAAFDQgAADKICAAACIkIAAAuAAgAAASDCAACJHAIAAAOVQ
Date:   Wed, 7 Sep 2022 22:11:48 +0000
Message-ID: <PH0PR12MB548125D85533125828CE8454DC419@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20220907101335-mutt-send-email-mst@kernel.org>
 <PH0PR12MB5481D19E1E5DA11B2BD067CFDC419@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220907103420-mutt-send-email-mst@kernel.org>
 <PH0PR12MB5481066A18907753997A6F0CDC419@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220907141447-mutt-send-email-mst@kernel.org>
 <PH0PR12MB5481C6E39AB31AB445C714A1DC419@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220907151026-mutt-send-email-mst@kernel.org>
 <PH0PR12MB54811F1234CB7822F47DD1B9DC419@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220907152156-mutt-send-email-mst@kernel.org>
 <PH0PR12MB5481291080EBEC54C82A5641DC419@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220907153425-mutt-send-email-mst@kernel.org>
 <PH0PR12MB54815E541D435DDC9339CA02DC419@PH0PR12MB5481.namprd12.prod.outlook.com>
 <8d80bb05-2d01-9046-6642-3f74b59cc830@oracle.com>
In-Reply-To: <8d80bb05-2d01-9046-6642-3f74b59cc830@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR12MB5481:EE_|BN9PR12MB5308:EE_
x-ms-office365-filtering-correlation-id: 1de44cce-3714-4273-506e-08da911df5bb
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mvpKK8rFztd5xUyDGZOjAQ2b2PtmLIPAz09KOrCVgLHRrPk3jUjASRWgUfMhiYaNaCLlPWCCcV9bLU+SgEOVNuVJesp8VE+9ty2TbumTZ/uTdApHxiJKeaRj2UBISn/Vx8w29PU1AOmJ6n0JVOQATYuFhv42tldgI2qIhKBjP+Tby1BdMnqx1B45TIjsKQdevIQNfJ1b1REy47NEi31D4daw/gkyqUCTKmFYWlUGJnCOZ407TKftAxX0bDQ3IsJGY008qrKiYQtKgfqsVrDVM3gP4ksWRA0TkZoNXDql1hwSGK6e+vRDLcgC7v3cq3ltijMhUtpjgmnbooiU1pVDJihtifAV781iaE907Ithy66HtBCWECUEiw0qvNSu3Lqs07z4HQDg9ujpuUCXEqS2/e5j+buJ0wL/ydJylLc2BVeG2LI1NEQM6AglKzinG3ksXMZ6SKd+bvGbdi8+g9U4HOCkLgOPLs5l1/nbu77MB7MdxK/aLvwJlhFN+7cH9Hdj/77h+d8ZJ3GvP+bGje297E3XdAlqmulM1lQF8PA5pSKcjMszRKwtglcQBTZma7BOq57poziY0nnstVrgo3J//e7emnSLYTKLkk27+k3ZoFjfPv/ysuV+1Z49Dh2/oramjp9LOsdazbQAs8Ino6D6AtlJ4Geh2mW4X96P7G0adtQ4anvsjLs+x+6ApFoQQAXbrIJnXKgOhngSjzCxTnLE2ryRJmGSHTzf7Q7t60PoHfT/5o1mUsZ4MfYtCMa6AiM1ukMnU6EiXHHq9ocxJmRUjg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(376002)(366004)(136003)(396003)(346002)(66946007)(33656002)(186003)(66446008)(66476007)(54906003)(64756008)(83380400001)(5660300002)(8936002)(66556008)(8676002)(76116006)(7416002)(4326008)(52536014)(26005)(6506007)(53546011)(7696005)(478600001)(71200400001)(41300700001)(316002)(9686003)(86362001)(38100700002)(2906002)(55016003)(110136005)(122000001)(38070700005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TU5oY1VVanVtbUlQVGRYWURoc2Z5dllERlk3REdpNjd2Q2tpSHpSN2t0Zi9v?=
 =?utf-8?B?VTk2SmppVlpFS3VMQm9Iemp0Q1ljTW5sN0l5eW43MUxrTWVIUVFtcmFEV3gz?=
 =?utf-8?B?ZFg3N0RodndCZ3g4WHJtb21STit0bGYvdE4rdHlLZUJrMTRwdklhcitXMjNU?=
 =?utf-8?B?UTFmTVBLZTJIZGF1ck5iUnNqR1JyTEt5ZXZ5SnZ3SUhlRGRNbXJJa2RmK25W?=
 =?utf-8?B?VW9IMStzK25ZNzBUdjNmQU42YWxqZjhwM1cybnMwY3kzc0ExUFdTQnRGRGVq?=
 =?utf-8?B?RXNsTTFuYVFYTC94K1c2Y2hCazN5WU53NDdJWU83VkE5eVlvaGlsdkloRUxm?=
 =?utf-8?B?TmNVQzVZdUtjOFVNbGF2TVRucVBvQ29DdHZiOVBsV3U3YTYvVSsyS0lJRXly?=
 =?utf-8?B?eDl3aXV5R3Iyb3RWS1VzcTd3RFUyOC80a2xTS3JFbW1LNG9DdzlnNkM5N1or?=
 =?utf-8?B?NWJITXppYnQzbjRjcWJ3aGlLZ3NXam9Yb3FBQXp2VGxwR0t1ZTRhZlJ4NmZK?=
 =?utf-8?B?Rlc1ZUo0YmtqU0JZTG16VTZvcXN2YVVXaWxUdlY5d2NFcCtWNisvQk84VWRK?=
 =?utf-8?B?ZTU2dEx6R29tUjY1MjhhTG1uanJjZ056U1Z0aWdhVmhSeWxMM29YWGI0cWJq?=
 =?utf-8?B?Q3FwdkdrUzZVVUhIcHNINkVVaFRob2QxR1NNWm9wMlhHTjVJL0ZSdENxNUNz?=
 =?utf-8?B?QnVOTWRPL3poc2xXTHlaZUdwZmtST1B2L0h1SHBGVkVmcEEvdzF1ZEJJdUh4?=
 =?utf-8?B?ci9NV1VlWTgrYjFhZCtOKzBmdkoyMWtXcEc1N3gxVWNtNmxSV0psOEZFTXJI?=
 =?utf-8?B?bDZHbHhhMWQ5OVg0M2VvK3ZwWG1uUmoxMnJNSEFpNWE1Nm5hTU5WcnlBVmNJ?=
 =?utf-8?B?SHZVY3pCNTFCYWwwSUtDb1VOVGJSYXZ2UjRHU1FQN0pZS0RXVG9oQjJKajBQ?=
 =?utf-8?B?c2RzNzBwMDlBN1NKNm5TSEVKdldULy8wUXJNRXk2UDhyWGpVcmxrTFNtcVBL?=
 =?utf-8?B?K0p0RjZ6dFdvVG0rYTNuMVp2eERlMWY5L0VvTkFJL0w5WVA0SEZWWm9CVXpn?=
 =?utf-8?B?MW5sNzdhQTNMVnRaZUw5V1VaNW9LS044UTNSaUJFNUdSSGI3T2lKRjdHb3Vz?=
 =?utf-8?B?UjJXdnlxTmtmeTZsZnR2N2dPbjQ5bnJicEJ0bkk1a210TmFvSzg5U3B4YSsw?=
 =?utf-8?B?ZjZ3QTJXeWtOVkhLa0N0VVJPcjBSbHVXVEtXUGZmdTFtOUE5clhWL2xPZFZl?=
 =?utf-8?B?ZFI0MWVZY0RkeTRVZHRrTEhhZldyTjU4UnVzNGJGUnhkYmNSaDFpL0ZkT09u?=
 =?utf-8?B?SnVqMUg1WnAvWlJnZmxhZkVLVVFwT29hYS9NeUI5NVBiUVhnUzVkZVd3azdo?=
 =?utf-8?B?Q0lYMXJ1aG5lWXZ3WTV4UXJrUEh5b01LelFwb2c1bXhzWk9qUVhwTjAwQmRO?=
 =?utf-8?B?bnVwcTRRR3kwdU4rSjdHaEducFMwYlVtZ3NsY2tEc04xS2lHVXlVaDlham5a?=
 =?utf-8?B?cUE1WTN1M0dWZDBQN0ozSlVLNXNBMVNGMGw0czNBS1NjcnBaNUpjRDRlVW85?=
 =?utf-8?B?cVFRSEZmR2IwRVpRR2pPMkZvSzdYREs2eU1aeXFKbjR1TUFKa3R5eFhvSmlS?=
 =?utf-8?B?VndISlJBUXp6c05WcXhjZTFYRUMxOHh6Z0JNbjkyWDgzK29Mb05VcE9nL1Vh?=
 =?utf-8?B?U0liMDg5TmhmNDNwZXdGTUdQcW5PYlpNTGR4SVJtdXYrVmh2V2ZsZWhIa2h5?=
 =?utf-8?B?UmkyTllFSmpSWGJNZDVZLzBvUFNHcnp0UVNUay9pNnloOUZBTGVkMjdqVjNV?=
 =?utf-8?B?Yy9mbVkwSmcxQjlESzdyR2Y5ZGRNdE5WY1hpQUFudGRoVnYvR2NkOXNNOU9N?=
 =?utf-8?B?Tkx2b3ZVb3EyZjBGZXdmQ05kQTBSSGpqQitGd0wxeURZdXJ0MGZYc1lSRGlC?=
 =?utf-8?B?RTV0UVNnYndLVXNRbVVaTjVzWk5lb2FOclVVWWJuVWFOQVRTYlBhRWQrNkpE?=
 =?utf-8?B?cTJUQWs3ZzVlaXZnWU1hVnpHRkJXNGNRcXNySkgyd00wMlcrelRJRjhqeHIz?=
 =?utf-8?B?MWZoWHdKUTFmQ05NTGdZYk93ZmZTRVJXT21tbkxVT0pZangxcGo3YTBybkZI?=
 =?utf-8?Q?Vd0k=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1de44cce-3714-4273-506e-08da911df5bb
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Sep 2022 22:11:48.8963
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2hDpkN2gTMaSPRzCrO1FhqPzjecKkH3AAWdcyyAmkyeQPf1/d9GqaP9/mNzOfU7nLafzWRaVr/zF7PrlrPdCEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5308
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IEZyb206IFNpLVdlaSBMaXUgPHNpLXdlaS5saXVAb3JhY2xlLmNvbT4NCj4gU2VudDogV2Vk
bmVzZGF5LCBTZXB0ZW1iZXIgNywgMjAyMiA1OjQwIFBNDQo+IA0KPiANCj4gT24gOS83LzIwMjIg
MTI6NTEgUE0sIFBhcmF2IFBhbmRpdCB3cm90ZToNCj4gPj4gQW5kIEknZCBsaWtlIGNvbW1pdCBs
b2cgdG8gaW5jbHVkZSByZXN1bHRzIG9mIHBlcmYgdGVzdGluZw0KPiA+PiAtIHdpdGggaW5kaXJl
Y3QgZmVhdHVyZSBvbg0KPiA+IFdoaWNoIGRldmljZSBkbyB5b3Ugc3VnZ2VzdCB1c2luZyBmb3Ig
dGhpcyB0ZXN0Pw0KPiA+DQo+IFlvdSBtYXkgdXNlIHNvZnR3YXJlIHZob3N0LW5ldCBiYWNrZW5k
IHdpdGggYW5kIHdpdGhvdXQgZml4IHRvIGNvbXBhcmUuDQo+IFNpbmNlIHRoaXMgZHJpdmVyIGZp
eCBlZmZlY3RpdmVseSBsb3dlcnMgZG93biB0aGUgYnVmZmVyIHNpemUgZm9yIHRoZQ0KPiBpbmRp
cmVjdD1vbiBjYXNlIGFzIHdlbGwsIA0KRG8geW91IGhhdmUgc2FtcGxlIGV4YW1wbGUgZm9yIHRo
aXM/DQoNCj4gaXQncyBhIG5hdHVyYWwgcmVxdWVzdCB0byBtYWtlIHN1cmUgbm8gcGVyZg0KPiBk
ZWdyYWRhdGlvbiBpcyBzZWVuIG9uIGRldmljZXMgd2l0aCBpbmRpcmVjdCBkZXNjcmlwdG9yIGVu
YWJsZWQuIEkgZG9uJ3QNCj4gZXhwZWN0IGRlZ3JhZGF0aW9uIHRob3VnaCBhbmQgdGhpbmsgdGhp
cyBwYXRjaCBzaG91bGQgaW1wcm92ZSBlZmZpY2llbmN5DQo+IHdpdGggbGVzcyBtZW1vcnkgZm9v
dCBwcmludC4NCj4gDQpBbnkgc3BlY2lmaWMgcmVhc29uIHRvIGRpc2NvdW50IHRlc3QgZm9yIHRo
ZSBwYWNrZWQgdnEgaGVyZSBiZWNhdXNlIHRoZSBjaGFuZ2UgYXBwbGllcyB0byBwYWNrZWQgdnEg
dG9vPw0KDQpJdCBpcyBjb3VudGVyIGludHVpdGl2ZSB0byBzZWUgZGVncmFkYXRpb24gd2l0aCBz
bWFsbGVyIHNpemUgYnVmZmVycy4NCkJ1dCBzdXJlLCBjb2RlIHJldmlld3MgY2FuIG1pc3MgdGhp
bmdzIHRoYXQgY2FuIGJyaW5nIHJlZ3Jlc3Npb24gZm9yIHdoaWNoIGl0IHNob3VsZCBiZSB0ZXN0
ZWQuDQoNCkkgYW0gbm90IGFnYWluc3QgdGhlIHRlc3QgaXRzZWxmLiBJdCBpcyBnb29kIHRoaW5n
IHRvIGRvIG1vcmUgdGVzdCBjb3ZlcmFnZS4NCldoYXQgaXMgcHV6emxpbmcgbWUgaXMsIEkgZmFp
bCB0byBzZWUgdGVzdCByZXN1bHRzIG5vdCBhdmFpbGFibGUgaW4gcHJldmlvdXMgY29tbWl0cyBh
bmQgY292ZXIgbGV0dGVycywgd2hpY2ggaXMgbWFraW5nIHRoaXMgcGF0Y2ggc3BlY2lhbCBmb3Ig
dGVzdCBjb3ZlcmFnZS4NCk9yIGEgbmV3IHRyZW5kIGJlZ2lucyB3aXRoIHRoaXMgc3BlY2lmaWMg
cGF0Y2ggb253YXJkcz8NCg0KRm9yIGV4YW1wbGUsIEkgZG9u4oCZdCBzZWUgYSB0ZXN0IHJlc3Vs
dHMgaW4gY29tbWl0IFsxXSwgWzJdLCBbM10gdG8gaW5kaWNhdGUgdGhhdCBubyBkZWdyYWRhdGlv
biBpcyBzZWVuIHdoaWNoIGhlYXZpbHkgdG91Y2hlcyB0aGUgbG9jayBpbiBjb3JlIGRhdGEgcGF0
aC4NCg0KU28gd2FudCB0byBrbm93IHRlc3QgcmVwb3J0aW5nIGd1aWRlbGluZXMgaW4gdGhlIGNv
bW1pdCBsb2dzIGZvciB0aGlzIGFuZCBvdGhlciBwYXRjaGVzLg0KDQpbMV0gY29tbWl0IDVhMmY5
NjZkMGYNClsyXSBjb21taXQgYTc3NjZlZjE4YjMzIA0KWzNdIGNvbW1pdCAyMmJjNjNjNThlODc2
DQo=
