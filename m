Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F148682544
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 08:00:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231546AbjAaG77 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 01:59:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231297AbjAaG7c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 01:59:32 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2081.outbound.protection.outlook.com [40.107.243.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAD6D274B3;
        Mon, 30 Jan 2023 22:59:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ou+IpK0utf3574WZkDmaKC+wQCBrF9GCND+KUNXcGQr9Z1nfxEtvKRKWtwLRHEzVAdgavW/+iQ9PeCJ2KsGZp5KwF0ZeVJP3ZTf3CW3mtBrCYXvQOw2curVXTgUXLJoyuRyFs32xNBalr8baRc1Z+YQoi7sO06LOL3tTzDslKn++vuS5Ju1oVYGqh0OWCAE6Z0mRnTGwO07s4+OYhDXCVYk9jmhAm/imupPC7PFNp4tptsg2PkPCAZaSf9sE+sBpHvxC386TzxruKqgUFSaUInp/tC7ZV0DeGq0k4l1VvvI9wKyZx+fLNSHhQB0AYhJ1RKNtKsMC5t+HkC5U9TT15Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xiSXn7W6BKl+9MgK1+6308Sa+v8yfTX1IoGCT9b0PEk=;
 b=BqutPvGUgZ99iw0u9UB3yW1qsdgccqcdkHRC6pxOE4P4ahQcScFXxZ4ddTLjY4Tyt2uMMOwckQulslOIEH3AV0lMmMzFrL3cznzDGayTkYI0u2S8v5QoSXyjBSBGqvhmIU0VqFgL2sNSu1kfQ6zUZ0VpmLcQmO3IpK1Kzca1Jp8wD8hHYsmiFIV6lPxtjrZFAx6kNmWhvIaXV06IKPr2603bAbkd7/sNdFWYG9cBa39pY6vv5Gc6NIdcFI2R+21IHKvAOxyGo/W0aLSDn4FDWpwsgDC2DPFqV+Jsi4Zc8ABlMyuLfwYo6mmgpcrA/R5MacKBOzF62+NnuCYQUsuCKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xiSXn7W6BKl+9MgK1+6308Sa+v8yfTX1IoGCT9b0PEk=;
 b=Z154++1xBUH7LHAu/ocQeDAdgMJ/MXcD/ggxK9I+/hE9W5jQ/KLDUBHWVdcY5PGb8WguSdvM7NrYOep6rFyIyQRrdKkbh0ugJU8EB9kT9aC0aNOZbwESSKhZz9NkjV2BN4uY/eXYQ/ypy5QwSK6vTigyyuWzgw15l9U0YET573Z2HoSft24Mr3spnxXL28amf4sn+HfHOMYh/45ZOOJUkHrZDRAs70F2KdQynrC+kQqv41Af1amrMoaxGcfdBnZzeuYcEko+B8AV8gMd0h985x3qCEyCjd1aAo80ukHWxCyiPer/2oGzC/5kdAGEwZzDlhpx6yki8veWJG54fjqtnA==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by IA0PR12MB7674.namprd12.prod.outlook.com (2603:10b6:208:434::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.36; Tue, 31 Jan
 2023 06:57:52 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::b84c:b6e:dc0:8d7]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::b84c:b6e:dc0:8d7%2]) with mapi id 15.20.6043.036; Tue, 31 Jan 2023
 06:57:51 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
CC:     Ilya Dryomov <idryomov@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Minchan Kim <minchan@kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Keith Busch <kbusch@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        David Howells <dhowells@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        Xiubo Li <xiubli@redhat.com>, Steve French <sfrench@samba.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna@kernel.org>,
        Mike Marshall <hubcap@omnibond.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-afs@lists.infradead.org" <linux-afs@lists.infradead.org>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "devel@lists.orangefs.org" <devel@lists.orangefs.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 09/23] virtio_blk: use bvec_set_virt to initialize
 special_vec
Thread-Topic: [PATCH 09/23] virtio_blk: use bvec_set_virt to initialize
 special_vec
Thread-Index: AQHZNIxpsA+W67WxoEy9SsvME1gLBq64GZKA
Date:   Tue, 31 Jan 2023 06:57:51 +0000
Message-ID: <ba82e25a-c23d-4eaf-0b7c-e21b95cddd3e@nvidia.com>
References: <20230130092157.1759539-1-hch@lst.de>
 <20230130092157.1759539-10-hch@lst.de>
In-Reply-To: <20230130092157.1759539-10-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW2PR12MB4667:EE_|IA0PR12MB7674:EE_
x-ms-office365-filtering-correlation-id: c9406ce2-b0f2-46f4-21f5-08db0358789e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cLdeb5v5tnKjsP8xhPMYMmU4QPzTvWontJpENk6EQRD9Yh4EhpChyj14Qsv97BOFKwVuLbbEor1+ASJA5hjC8/02c7Vh9MT13UbH5zTHPgo4xhLYtAaYyV+iwKNgdBVvbTS7uHONsY1ELuR10tjuG3ESXuUwDY9I3Ojwzl6DAE4kXz7eJmN/FjeC/VdPDy7ZGdzC5s4bgC+QdxSqslyVxj+c6GuyXrOylDejOBxFwXgAQC7kDdoeSp/EmhZE8dYoVZl1+6jpTAUnQLtGnaOzXa8ZpJkLcG9VPB4gjOPIcbnJk1RTZWRgVz5YlDyFRU389HaQcT7ja/KYD9db32+tpvWnxW2Zgd0yj2cW5/uG5c1MAye78jduXxEgH0Q5ni3W6zklcwivqbNr92yspQ6EMJal5ScdK7givYSf8KQ41Nt+y6xAXKHHDdRQI368cx94O5Zs4+K5MwqY5DEwTEQLfIAewO9t/z+lFiBhKOAz8UQUQlb3KYplpnNaUcZfiQlKtFNnmHQN1v+MT1OKO9XdKcvAzZ3LYvWbXxlEgl8km2uEroCT+BKNHVUWG5RuajIPGvClAHiGLBaC+mRgf5VmsAKxKs09oKiClYoAr8l04Opbiruw1At1prtYwmGHC4mE2mpG91g7qGDdHQTLcN4wM4swUoTYyCWGqpn9XhBr2uVrw481f3SFe8XWQXs3brH9glVZ2ZDItnM/Wpi8cF0nzJa8XrD1bJcGsW6sUpTc0uo7bsiN1+CTP/+RzQTwxd5NWTGSykzE0L0DGalBPrvLYw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(39860400002)(136003)(396003)(376002)(366004)(451199018)(31686004)(7416002)(7406005)(5660300002)(8936002)(2906002)(41300700001)(2616005)(8676002)(38070700005)(122000001)(54906003)(66476007)(66556008)(66446008)(478600001)(36756003)(316002)(4326008)(38100700002)(6486002)(64756008)(71200400001)(110136005)(86362001)(6512007)(186003)(31696002)(53546011)(6506007)(558084003)(91956017)(66946007)(76116006)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TG9xaThzMFFST1kzdnBYY2U3d25mZkpTR01rNXBQZ1MvMUJoSjhpdmhrMzhN?=
 =?utf-8?B?L1EvTmxvOHEyTlpHRHlzSWZ3M3BwaE5ZSUUvWW9UWXZaYk50L0dsUzhUSWJO?=
 =?utf-8?B?b3E2VjNyQk80TTVjc1c4VWhNNDhEUFlNcXJRa0Y1OVBOY2lxT0ZMZHEydWRs?=
 =?utf-8?B?NGNva3cvZEZvbjZzc2tWYktkMFI3L3AyTmhxanFpOVVXNWhZL291MENRZUxa?=
 =?utf-8?B?Q1I0SEZsWVZVMjhJTmYzcG1ETUtWUlMzMldUVjdkNW1lcEtEbGUza1hqNDA1?=
 =?utf-8?B?QjJCcEo2TU0xR3BJYUlhQkxra2pLM3RRbjNjQjlKc0Zjb01aVTFoYVNnQ3pr?=
 =?utf-8?B?c2U1d0ZhbEhvcHAwNjV3UGYyNnJRcnFsN0owdThxYXpLYS94T05SUmNyRUFT?=
 =?utf-8?B?WTV5NWY1NlNpbnZPeEE3NmRkR043QW4wS0l6QzlteEwyY0JqOWt4YTFZTmFx?=
 =?utf-8?B?Q1JFTlZmRmxQNjFKUlkydzAyMHkrMTdwQ3FJRUF2NEdobnZOdUlKL0Rjb2wx?=
 =?utf-8?B?U3hINFJpQy83cktSK3BscEduT2RMaDFDQW56NTI0elNYR1pyNVYrMzA3MFFG?=
 =?utf-8?B?SytEMFVRcXlRc2xQN2RPLy9pTVJKQkpTZzVQOFp6eG5yaVJOUVNIZGhCaStj?=
 =?utf-8?B?UUZhQnlHNDJTSlUzL3o2aVRRcHMxYlkxcVVLczR6WjBSMjVLRWphelVGakk4?=
 =?utf-8?B?NWJqeVNodURZeTZhbkVBNE5tT1FCbVV2WDRsaXp4NC9qUC9tRktsT09XazI3?=
 =?utf-8?B?VzM1SUlrRkFWRCsrd3NGUWYvNGg0YWx3MmFkaUI3bkVHODcvZ3NNQW52YkpF?=
 =?utf-8?B?dldsM1hBTnFkcmNjS3lpSmVRQk1WU0ZXcW90aUZOb1N2V05vMVJlWlNES2Iw?=
 =?utf-8?B?dDVjbHJsVDc1blY4dTRIR1VFQzJuMlNUUzZiaUFRSy9PM0NyYnNHK3BWcFlu?=
 =?utf-8?B?ZVAwenhoUldMOGZoUHFwbkovU0cwQTQvci8xS2picUMrQ1NjOGZrNXJabDdK?=
 =?utf-8?B?U3BGNm1LcVhqV3BZWUYwNVZIWTMva0M3cjVZU2ZIcUhzT1Vac1NRM05hRGRn?=
 =?utf-8?B?czVjTTRqS01kekVDNUdzeXZweFcxOUdJMGgvWVRCanJraWhrU29IcnFvN20x?=
 =?utf-8?B?czdLYngrc01qQ0JqbmFncS9JL2h3K1EwNHQ5RG1LQ0hoTllhZzlKMENIY1NN?=
 =?utf-8?B?WmVEMUg3REhrTFNqN0l6ZVl1VldVU1VKOEc2QXJUQ1J0a1diSzNQVGVhZVZV?=
 =?utf-8?B?US9QZlpaOEVybVRiK1AzNVNqOStWNHdLaDFodStDa3ZxSENQSlVzK3RBK1pY?=
 =?utf-8?B?QlRsbWdRUS9XNzF6cVJnaDNIM2dCRFlDUUFVS1poVWpESjBicVBXdzJicXJ4?=
 =?utf-8?B?UGJIS0Z0WTFwVjB1dFl2SUZ4K1ZxOGR0NkMwenpmTWhmS2NrZmtNVDRJQlI0?=
 =?utf-8?B?QXBCSnZQcm1BZ0FEQkNhZ0JBdUZHajRhMXRUZUdKSURyR25LZkpHVENNeENQ?=
 =?utf-8?B?eTRRQTU5amRJUVVGbEhjcGQxOVNzbFBsL0JxVFA1L0pObjdIVDZJSW9DQ2s4?=
 =?utf-8?B?Qi9HVktGTzl6elVLa3dWYjltcmI2c3ZGaE5waXh6emZieFZ4WUx4SFUrL2cx?=
 =?utf-8?B?eUF0cm8wM1M5YmhQeWRWMDdDSFUxaWhKdkNiUE40dTg2UmxPOVF4ZmV4SG9H?=
 =?utf-8?B?by95aHBVSUhLdWtxL3RlSllXdEJseDlrVFJhS2o2Ym1CVG1ENk9wUDBGUzli?=
 =?utf-8?B?c0ltUGk3TDBlZThRU0lEak8waDFCVWVaS25iMjc5QzB6a0pXa3dvbHNsNU9Z?=
 =?utf-8?B?QW0rR2xySnVvM2pVd1BFN0h5Q2JNL0lqTytrSnc1azQxM0YvTHdFRnlZakQ1?=
 =?utf-8?B?RHc5VU1NUnJWTUkrZEFCb2Vlb2FUalVvcU9lMWpuY2YrNmJYWHR2eW42eWZP?=
 =?utf-8?B?aFhGRnlaUmpZdE1XLzFNYVl6OXJCZ1pQVzg2L1h3SHJPdVQvaWtIMDFIRnlT?=
 =?utf-8?B?WUNUejgvZGRRTVdSc3FsUzVGUmhXUDg3WnM4cjdzOEI5Ky9mZW8zM2xWK3lK?=
 =?utf-8?B?V3JSRDhpSWRRbFRYR3c5OStMMnBneGZjQXFSaWZBWjlvN3BvcHRCQ0JFNWFs?=
 =?utf-8?B?ZG9wSVpqYmpDL2JIU0swb2NENHZkZHhyUENNU2dyV0tkZ3JDQ3VSM1pmWnBT?=
 =?utf-8?B?K2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2D9260BFF5A53D479D46AB1A152A3F20@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9406ce2-b0f2-46f4-21f5-08db0358789e
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jan 2023 06:57:51.8535
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kQVM3qrOi28iYYL3FypYHdYQ1PB8hpObqArcLj7pMKFxFUIy3FmpcUWCssYsa1AgePuvHDCDOCv69j0ODcUNQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7674
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMS8zMC8yMyAwMToyMSwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+IFVzZSB0aGUgYnZl
Y19zZXRfdmlydCBoZWxwZXIgdG8gaW5pdGlhbGl6ZSB0aGUgc3BlY2lhbF92ZWMuDQo+IA0KPiBT
aWduZWQtb2ZmLWJ5OiBDaHJpc3RvcGggSGVsbHdpZyA8aGNoQGxzdC5kZT4NCj4gLS0tDQoNCkxv
b2tzIGdvb2QuDQoNClJldmlld2VkLWJ5OiBDaGFpdGFueWEgS3Vsa2FybmkgPGtjaEBudmlkaWEu
Y29tPg0KDQotY2sNCg0K
