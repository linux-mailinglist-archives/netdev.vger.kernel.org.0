Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C279682506
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 07:55:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229572AbjAaGzz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 01:55:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230495AbjAaGzu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 01:55:50 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2045.outbound.protection.outlook.com [40.107.243.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E370F27D4E;
        Mon, 30 Jan 2023 22:55:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GoUOERG/uRTSJdHdT2wE8kDQWh87DENwd1hevabp6YuFKgtpTlSV/ZKObAH+s6Ao88Og2aLOUlV5Yyl6mGv1wEIkmYCRoIm+IgO+JMwy4uqDvMUoWN7Qo/ILbd/7GSfuZs8oNeJWH7RRry0Pg+w3kpt8IDjuszGUS6Dng89Jfd5GDNkJGmdvmSTUBjccbYD4OYDPL7xX2YhDlpFfwLVDm9pxIxvSbhigI/3MAUy0heEFhDqjQgwL5CT3Vos9m9lkIPwtfyI6HKaoCh62J8FGNUvfltI3a6x8Lp4lKfH6tym09HlNwK9pIVsrWxTna3h7ja1gwNzpm7Towk4cEgHzRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H92W6FKFvCrIKKSMiHeKnvn8IA61fBALG40B1SGs/Rg=;
 b=Tc3M4cvlfG08W/FqRpesPZB/PhAhASOnmfY8otqwwpJinVdGFN4XXuvxB+2GEhCPhiCcq62QWaFxx7ZyoWOquF7BEr4OIfy7+OxkcGE6GKX2ghHmGBKgsTErBQABLPabtOjbikQ50kdS3tZX6ST1KP2A38UrdrtzJIqlpBK3/eINc2g515YerJwmLHqv0kYJC2vHrVCEO7ktz07j+qc6qsXfU4sez0Im/vWPC83an7DXaN2+lwFsch2dMKaIudZmjuC9RqD+YbcRoo9Sop2vPxhc0nl72Z1TnMp5yUfXNrNCCiN9j30e6/ri7RJzC+rmRyhekJ1k/3oRY6x7Yve6bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H92W6FKFvCrIKKSMiHeKnvn8IA61fBALG40B1SGs/Rg=;
 b=MAKknAnmYy1GkZwAILjPr6/Im9Gbxv0oQtsooYtYEhBM8mL9qF2xwwF3eHS+VbW963zhAfhJLWeIG9d+L7QBvjd15Xw9pS2cYBmkuLBNOpk6+ZYITMMjx95Bo6NcK7bW5isB9YWYJYEl7Gm3pme3clJ7Hbkj7o9cQodivQDDaWXMf2aGVap7Abx6ghm9gvR1knUk16J5URWZ8JJbYbIxoDQe+vGfI0IwSJBFYIiv9BQmkDjxMgYg+EHKVBlYJX6GKqk9rEWmwvyWjDkRTxH+ak7Xmm+95lrdq/8sZPvDtM/fqejxrcT9S8X2JcJpb7/ovwqK+hBbAvNurDbZC6keXA==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by IA0PR12MB7674.namprd12.prod.outlook.com (2603:10b6:208:434::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.36; Tue, 31 Jan
 2023 06:55:44 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::b84c:b6e:dc0:8d7]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::b84c:b6e:dc0:8d7%2]) with mapi id 15.20.6043.036; Tue, 31 Jan 2023
 06:55:44 +0000
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
Subject: Re: [PATCH 03/23] block: add a bvec_set_virt helper
Thread-Topic: [PATCH 03/23] block: add a bvec_set_virt helper
Thread-Index: AQHZNIxefZgAH/R860mx8hQPrrOI7664GPmA
Date:   Tue, 31 Jan 2023 06:55:44 +0000
Message-ID: <640401b1-7b42-caa8-2486-713cd07f2512@nvidia.com>
References: <20230130092157.1759539-1-hch@lst.de>
 <20230130092157.1759539-4-hch@lst.de>
In-Reply-To: <20230130092157.1759539-4-hch@lst.de>
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
x-ms-office365-filtering-correlation-id: 00452011-aaf0-4b9d-9b62-08db03582c7c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IEGy90Wkc0bMs0kpHRKd66Mq9uczYpRD3iAeS1t5HEjZBCBKB07cHiVMle85RykW82czZn4Kye2sRNSsPnuxGzkEG7/geElOYdzKBENpsJY2hQaSTmU8EUS5EtrUSG5OsptlfStSnAHCwZ6hBlDlmw+QiBwCox/cJeTpEB6Dfy3CRXDP2XCRZKDfpPp8xx69YmvKz6YPBGWEqoMjK8fuqn1t4dRX4ryM4uxPMsz6hbFOC1TgKMPq1jpVg/Z1NK3K4n6EzAl+r5vUsfeU6R7vg9oyufLV1FRJiakavgqsoQyyuhGF/T+pPWQA6Hn4l6+RTnUlgia0M+azCbEmE019RZzJLUyDzTnez0FGtJXG7PpYaYynsGTyx4lQ1HTviHHn9AQ9BRliQNdMkKIw6dQibP0n2RGpT+ZEuA5hE/xFD9JDv2NOEKpT07KXvFpZz09Yw2K0O/AY156E4U/BGBGMCf7G/LVSwUVpEhfaOXtxMTl0wgzcHzYVbDG5jqUR7Q0YVDDblGKWKrbwjAvGlYQ+Sb1+0ewnwOrtT7h7sldGoMSTo2VQjdb7CQliPvyOUrbg2cetZEo/1DGUP4w0quTTCoa2tqCwzPs0hck301rZ+iZwO+xgC4u+g8VxPnM8bI7YXFgFwhPtVoK1PoywXA6nEY5XcOruEv2q4/PWGh5NweVj0mQ2XJswsyZIMxPt2uG8GryBU3spwB7lh4pUhtNusi3WDJf8o+TVqPkn7lx5yYWB8e8qocgYfEwxYNkk7wH4pUoCP+Hczd8HPsKR+7XjnQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(39860400002)(136003)(396003)(376002)(366004)(451199018)(31686004)(7416002)(7406005)(5660300002)(8936002)(2906002)(41300700001)(2616005)(8676002)(38070700005)(122000001)(54906003)(66476007)(66556008)(66446008)(478600001)(36756003)(316002)(4326008)(38100700002)(6486002)(64756008)(71200400001)(110136005)(86362001)(6512007)(186003)(31696002)(53546011)(6506007)(558084003)(91956017)(66946007)(76116006)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bDhjbks5cTV3ZnpCaklLSUFiNWE5Sk1IVW4xVTYxWmJBSlRVVHkzcGFZTGJw?=
 =?utf-8?B?dTlnUVZJTWtoMzVaRnVkbjNTM1VZTVIxRWFQaUJhOUdqQjkzK09tclpRS1ZV?=
 =?utf-8?B?RXpaaitiUmF0NHIyWlZSQnFuUEZxcGE2bmMzeGw1ckVYTHF0MHJId1M2QUNS?=
 =?utf-8?B?VTkvQWoyNm5ISHljL2w5Q0Y0L2hXb1N4Tk42TVJLSHF6YnZMMkl0YXZpVmp2?=
 =?utf-8?B?Y0RscDJ6bHNwRUJzRno4eUFFL0YyVWE1ejBSQnRPOTF6Qi9LREZQemhDNGJW?=
 =?utf-8?B?aWlEWVBZZmttYS90cjJ2UWdJdGJpbDhwbWtKL1FCcDNvTk5rb0JyMVlOczVS?=
 =?utf-8?B?YnZyU25URm1iejNEcWdLVjZTK0FxVGwzcXZmTVBEU1JOZWRmQ0xTRmpBMFhG?=
 =?utf-8?B?TUVySkU5SXpVWUo0U2x1TU5lWDhxRVNVc0EvZVNlZ3Nuc1JRc1RSRC9GaHJ0?=
 =?utf-8?B?OGRNNEJCVXdDeTRrbjV4ODQ1cklUREp3a3VZUlJUNkRNQW1ZWnVTVXRFc0Fp?=
 =?utf-8?B?U29aaFo2SEFlWHZpQldHc1JHR3hYeTZ2UXlzeld5bDdDd3NHYTZ2VXJkb3lk?=
 =?utf-8?B?aTFOYys3OENycnBKZ2IrNUExNUZvTVhxNi91MCtHa200S1E0UHlJTVVkN2Fi?=
 =?utf-8?B?Q2YzMVFaSXZhaGdBZmhtN2xKeFY1STV4NVJKTndYN3g3Nkp0cElWVVRIeW9S?=
 =?utf-8?B?ODkwdXNxQXB1M1hrNXBDYUp2TXBGUVVsVElqK01KQjJ4VHpTckVIU3pRMmly?=
 =?utf-8?B?Lzh4ZUxHZmJpd3FOQldzWk1HUHY3dk5MZkt1OW1NT2RGcDVteGtUTVBkRXJn?=
 =?utf-8?B?a3RlOXUvKzRqWU9JSDJySmdVeFQvanhTK0M2VmV3YVRCUHk1NXF2Tjk0SW9H?=
 =?utf-8?B?Y3p5ZUp6WHNHQTc5cnM2K2gvQU5yL3B3ZGEzZ3k3M1IzZ1VjaFQvRkIvNWRj?=
 =?utf-8?B?bTdyYlVidDFTcytSNklZK1Q2Y0FTOUNEVHN5aVZOMWdhY2ZWamEzemFUWVh5?=
 =?utf-8?B?VGk3SmU2NzkrdGtGdU1Ma3VXY051MFQrTlNaaHVHTHQ1ZWF2Z21wQTNOUjNL?=
 =?utf-8?B?ZkJiN3RJaWFoOTUvbVFtM2NyQ1l3d0JOQmUzcjJOWVJZbGVsdk8rdDdibllr?=
 =?utf-8?B?eWRlUHN5S2lrclBOdGdPMnZrRFhxZ2hpNG5OUFpYZDNuSjJGTmFGSTZtZ2xV?=
 =?utf-8?B?OXV5VkFHYXdIbHJoY0gyVC9SYmhQdGk3RVAyMGx4MDh0Z2J3SE91c05DSzNW?=
 =?utf-8?B?TFd0R1pCckx3NVlWajNjb01qaXFoWTJtUnduUjBLZ3pTbnIzenZCK3JjSjlO?=
 =?utf-8?B?bzFVRVlCM0ZvNjQ3Z1EvQ3NnZTJndngzUXpTZXJsa0lYa29WYnJ3K1hNdDJV?=
 =?utf-8?B?WVplREVsZnlnbzhzN2xFSVNQcEJPZXVtcVo5b3hIcXd1QUwyV1l4cFgySXRN?=
 =?utf-8?B?RkhvUk8zSkpNNTdueWpzTXJ5cWo0U3NCa3ZRYXdRWWlPY1ZYUFdiYnF1Zjd2?=
 =?utf-8?B?ZVY1WlBoN21rT3o1TEk1RmNGVTZ0dHk5cnNJNmhrMXpMbVZ3dW1xMjZoMkVa?=
 =?utf-8?B?K0lZcTd6VlJoYTM2MzA1MVRwSCs2L3BLQkFkQzJXWXNmQU5UWHo3ZzBFanZG?=
 =?utf-8?B?OXVBajFTRVczRFNON1JQalByU0taTlRLRCs2VlZNeStIQWJ2NGdSZjRaaHNR?=
 =?utf-8?B?TUlyNGxRWENFQTh1OWxLczJwVTU4MkhRMUdqSFlPV3pza2tsZ2RURGFlRlMy?=
 =?utf-8?B?VTFtWWxXeGNuY2s5TUNyWW54bjJBa2F0MEFUZG00WjVyeDRsazA3VnJ1c0s3?=
 =?utf-8?B?SkQ1NUZpZmlJQ0tCNXQxYmMyRm12bUVmc05UUzFYdnVoTTBCRU1VMHFlUXdV?=
 =?utf-8?B?RldtQTFSdU5MVWJsRzVHNlN5Tm1xY09HM0haNU1HeTc0VmJpcUxneGQ5cDhZ?=
 =?utf-8?B?RTFOeEltODJMK0tVQTBob015WjBWNGNqcU1SRXc5TGJDNXIwWkNwNG54SThv?=
 =?utf-8?B?eDFxRlhETkdLMERsVVZsdWFQcnl3TXN5RWZpUW5oS2pEYloyK25HbUpsUzZC?=
 =?utf-8?B?TDROdkZDTFdPRDBYRlJpRkJ4a1lvb1d5R0JsWE03YzFrUzZsZEUrT1NxRlA4?=
 =?utf-8?B?c3UwQjR1THlaSEM3SjJkeENyZjJxZktSTC93Q3VVRmVLSm9SVHc2bkU4YUc5?=
 =?utf-8?B?VGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <191206403DAD3D459550E8D969E3FC54@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00452011-aaf0-4b9d-9b62-08db03582c7c
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jan 2023 06:55:44.1113
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qRTXJ/QJNE3uXM3f8C0P0VzmG2gcvQDSdfZKYi14Jkf6D8EqE9rfPTh8Brs4+LKvwgNUDPAECkbNvn3U3H73mw==
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

T24gMS8zMC8yMyAwMToyMSwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+IEEgc21hbGwgd3Jh
cHBlciBhcm91bmQgYnZlY19zZXRfcGFnZSBmb3IgY2FsbGVycyB0aGF0IGhhdmUgYSB2aXJ0dWFs
DQo+IGFkZHJlc3MuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBDaHJpc3RvcGggSGVsbHdpZyA8aGNo
QGxzdC5kZT4NCj4gLS0tDQoNCkxvb2tzIGdvb2QuDQoNClJldmlld2VkLWJ5OiBDaGFpdGFueWEg
S3Vsa2FybmkgPGtjaEBudmlkaWEuY29tPg0KDQotY2sNCg0KDQo=
