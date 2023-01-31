Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FD8568252C
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 07:58:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230104AbjAaG6j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 01:58:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229918AbjAaG6d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 01:58:33 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2061a.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe59::61a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 656D0EFBE;
        Mon, 30 Jan 2023 22:57:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kpNATSbl1abwzir6xeQDmPlpXZpdDp/u2hy7/YB6rvEAYYy52vj5z9Nfy5275/5wcW1IXDupk/IKLPf/+pxQy+g9dcF/aNgC+jrpv7ahqewr5KPSgO0O7oSciyGxY+19Htwx7KOfpa3u55J2T4ypygGbkUQ6Y+R0sjIQJMbBfRbARfZqdxfvrVvKNDNWD7lmyfvo9bcHYodm4BSTOu1pgMMLTsWLTopLm0fIB0sn6LLAyhYcySPLOD7PjuwSCCh2EXfNbdAxDsk2zJ1wIJr/mImVek2s5RUfRSxh5KPR1gGJjjr1h9ObGoL7YfQONezzMU7jm43A/I7tOsBcKDgbEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RaCHytO3d4YJrFVFeFYQZ3diCPipJZpo8wdL+r2AMLc=;
 b=C+n/aJ5EMIrAzCFD7cYNSW+Dj74j0jRvRW2ARnF5pqa3hRXs7xTp1G3luvQZsi+2MuAoa2DZNwZizgdzqXgbpmm0udHzkr+p0BJm96D1QoO+LXXLN8fvlZ5smD/rqa5M83qYv+NJUSYvdU1UiYSWSrDDG3tdK6qyYnAfpYRooXXp8XVCBwOsyKIUuS+0lhSWIuQTYHyQkqpfjPSTBxokoKoW1taWcrgj3tB51fM+brq45lhIN8Q5fyaLVPPcLVNQc7XA21GLLfaAaT81DEYnXntuNdRzNMItr3SYIW5CrWePZ/J1QB7pzYP5uR7eOdNlDW6EopexydKogNSM+tfGLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RaCHytO3d4YJrFVFeFYQZ3diCPipJZpo8wdL+r2AMLc=;
 b=bMuBAeDTno9y8EzjzclHvSGtcsdHZVUpBu4N7hZteMkFnOVaJqX1PJtv/JR4B6wbzXAId4BZ2jZ7OQ7Ap55bIdGvcKKbSS7/0n9zt2HRpTXO4Jyf6l/QyXvUp+P4KP9Yrf192MC58heBQbwA9HvYKTvVkVgEfPrtdPiOu8e6/ueMH5IBy5RTdsBBt1n3XOv8/qscm9MVTE2mF04OexETq4YKtCGxGwpQGx5ENbIZv5kT6RcQp6EudXvoju8WaGKDBFxfFHbaL5Mv4IjEdlUJW+nMgXyGr9JUWSODAmfVC2RTheFLzgH1uW+UCqUk1GYr/J2hbqvkBs5M2uPcTFc/Ig==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by IA0PR12MB7674.namprd12.prod.outlook.com (2603:10b6:208:434::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.36; Tue, 31 Jan
 2023 06:57:25 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::b84c:b6e:dc0:8d7]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::b84c:b6e:dc0:8d7%2]) with mapi id 15.20.6043.036; Tue, 31 Jan 2023
 06:57:25 +0000
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
Subject: Re: [PATCH 06/23] nvmet: use bvec_set_page to initialize bvecs
Thread-Topic: [PATCH 06/23] nvmet: use bvec_set_page to initialize bvecs
Thread-Index: AQHZNIxofE85mw/C2UO8ns7iewEyYK64GXOA
Date:   Tue, 31 Jan 2023 06:57:25 +0000
Message-ID: <95093888-32e0-3bac-633e-2a5a60ad65f6@nvidia.com>
References: <20230130092157.1759539-1-hch@lst.de>
 <20230130092157.1759539-7-hch@lst.de>
In-Reply-To: <20230130092157.1759539-7-hch@lst.de>
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
x-ms-office365-filtering-correlation-id: abcbf45d-58b7-4a14-7b7c-08db03586902
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wlqBMRKAnbsYqLnRrzcBS+7h7w72MHKqlLT/OxT+3LL34HdIboamFX49OpjYEK0rlxgY6g5Ei1PBpbnb5w15VRkFoCqja3l0r55GNxG2vEAERBuH8B0+N9g5opgE+bbfaq56LHEnA4BW/42ZD8bRkrW2Fy/NvuQyTuBzWUygMcQOocf0WPkpqHgBbzDqaMLz7S3Xc9yioU1VnFU4j+u4HhSUhLTsTFTKdn/X6JHjUje2biJ/I8uP5DMFdkiHQ5gMc8sqF8tBh0BqNRB2JeC9xILNX4yLBgqU4nlQdgCyd2s0MU6XMvOGOL4ySdfP9VmsBA16Rv0vnzVPw8HbH8Jj1PVF1sN4xaSrzyiFAJE3nPvO42JjqWoTiKTkx+BoIQt7Jmlwy6a8NsXQt0xJEFQ4NqzLmIOhxGNa1KMjvYFpgWwBhPqU6w9tiVys+Gg3tPOsOIYF5yQAD9KBqWTaxgWGiBV61YPha0oMyv9TD0q8HrsHFsHkFRrP4g+Q+tvbX1+citMdL3rN27vc9Il3yk8IWPGWoiaY7QfzO4QLgiyzPQiIH4qRRKqDuEr1J6JezOS749dOB8xHdiyEe13LzsX+iDpLs4tyXDCdVeI23vgQLBbY8sjMSFORikSUJJi1t5sDyOwn9J4QVHfT3ZFIxxv64m4CVPZ0JrhnDtXbxrXmvVByzaeG1pK/7f+zqEACfZO0eq3I/Y4xRhp2xjKsQTJOQaPu7Ssnxl+IIlUgJixkjC6uYA7aofcZAGWEuXF2MtXTH/mvKDMgxScKwB6DMjo8GA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(39860400002)(136003)(396003)(376002)(366004)(451199018)(31686004)(7416002)(7406005)(5660300002)(8936002)(2906002)(41300700001)(2616005)(8676002)(38070700005)(122000001)(54906003)(66476007)(66556008)(66446008)(478600001)(36756003)(316002)(4326008)(38100700002)(6486002)(64756008)(71200400001)(110136005)(86362001)(6512007)(186003)(31696002)(53546011)(6506007)(558084003)(91956017)(66946007)(76116006)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?a25MWTVXR1pVZFVtNlF1UkFwTzYzbE5qS2VGQWZCVEpMOVpXdjJNVC9sNEtG?=
 =?utf-8?B?ckhLbjRXNFlHYXBaL29IaUUweWhrenhxOE01QmszVWRhTWpEOVhIVU9WRkpV?=
 =?utf-8?B?c3hWNnFLYTEwM1kvOUhHcFhhT084eXgrRTV1eG5YcmYvZlFHTng0VklCTGFC?=
 =?utf-8?B?Ym1CbWdWdmI1YVh3YWNjSTkwSjMrZ3dZeWZONy9MVXU2T2NVWnArR1lpZU1l?=
 =?utf-8?B?YWZNdnRuL2RSeHJVS3JmN3RLYWUrRjlocnZ5aGxmRFZ1bVNzbDdidnllenJm?=
 =?utf-8?B?bHhUMitvcEw5M01WY0dWQStveThTanI3N0VGOXFPSGJVbHB6eGN5YUxOVjU2?=
 =?utf-8?B?OTl3SWpSeTIrVk5RRHUzN3B0UmFCdFY1VXJEM0sxTXZXZGJhb0ZORWI0azBJ?=
 =?utf-8?B?M3BHQVZiWGwxdklxSldrSWhNRTJZTmhYUE9haXFRbUZDWWZaaWFVL1NieW5F?=
 =?utf-8?B?eU9MQ3FwUTZjNjR6SjBYQmhNVGpBZUljMEY5SDUvYmlZK3ZmSTFNS2NCUW9a?=
 =?utf-8?B?QkIxQk94bVU5Z1hpaFVGNlRMRm4vSkdxdGlMYmY5RHMwVFFXbFRIQVJjMGJW?=
 =?utf-8?B?Ums1QlJXay83SC90Rk5tS0VKQjk4c01aSUZINzNBTk82aCtjSVpvcVlSUmht?=
 =?utf-8?B?V0pVdGVvc2VON3R5dFhHdjJ4b3g3azM3SFRyM1ZsOFV1VVFyRlhiUnltS0Nu?=
 =?utf-8?B?ZG5Qd3ZaZDRrSldzSE4vUTQ5RUZYUXpoZHFXUEpNZjJkS3NKUm9XWml5QnJB?=
 =?utf-8?B?bUFGTStzRnlKejlheXlSUWFSVzdacFNxOHRoMW8wUW9QeEFJV0lkdG15L01k?=
 =?utf-8?B?Q0hsc0NkZk1SQmkxUUxUd203NHVjYnltVlVDc0hDeWw3d09tSG0vdUFaSlpw?=
 =?utf-8?B?YU5GVlQrK1F0VFZsdkRRdktFeEtNcDdNRUl0NVVjZnNXdFhKVklsdW80eXVU?=
 =?utf-8?B?V09GaG53cXRFMys2NXNWbGlhY2JGamtzcUJzT0ZrRERScXl3Vlh0ZmhtWFNx?=
 =?utf-8?B?K3VhWXZvNFlCdHVpaDgzb1FPZ1UxOWJTTld3Z3Z4dFd0cHF0Uzd1c29raU5J?=
 =?utf-8?B?UWNuNGRrK3ZNVFFXS3g2WUNtalhpZFAxL1dxK1UwWm5Bek82QTRaUnd5OVhm?=
 =?utf-8?B?TnFyTzE4akdUdWVYR0NwcCswVC8wNnNZYTRXYVYwL2xqK2ZmYjNnNDlPYk13?=
 =?utf-8?B?andkZXdoUDFaMzB0THUrNjFDTG5uMHArdDZLSGtrSUMxcVYxdkhZK2FEZWp3?=
 =?utf-8?B?TldzeTc0N051K0RWVVp6TVVtTi83TWZOSTA0MU52Njd1MW9WMXVjVzdiVkNq?=
 =?utf-8?B?UmI2dzkyL2JHZXE0SjN6c3hGT3RZS1YwamZzRW1kZ2g4Mkc0c3BRcHFXSnBh?=
 =?utf-8?B?MzFVR2IrUGZlNGxuUElHc3ZQRmp3aFR0L3ovSHZGRmlBRENzaHBER1k3NVpY?=
 =?utf-8?B?OFhsQ3JvOFk2RmFXZlRGbDFQcmtvZWdPaXNFVFVPNVhBT3hybUpxbGRpMGhN?=
 =?utf-8?B?Mzl0VnhycXpCaUtTZzhRandkbkRiamc2bWkyTjVHWnc4NG4wRE5URzQ4Viti?=
 =?utf-8?B?K1krMGErbDRnbHlKQ1JVK295ZXFaZTZUN056SGZ5NmFWUGJydW9kYTl2Sm4y?=
 =?utf-8?B?S1NDbk9rRzNTSWpGZjUra3hNVHp0MDhmaDFLRHRZaTczKzdZMnZvVnVoZUE3?=
 =?utf-8?B?VXkyLzNEbGRDeUxjNk1PNnd4aHF6VXYreHpVaGZQZk9scVVWTUtGTlpvdTB1?=
 =?utf-8?B?VE1tWE1DenJnNk1GaUd1NkVpZUlyZXZpdG1McW83N1AzQ3N5RGQxWEdmWXIr?=
 =?utf-8?B?emh5bjlTRjJSdWZyaGN2bFkrTXVIRFFtMEV1b3d3cTR2SkdjMUdHS0s1VzZ6?=
 =?utf-8?B?K3o4ZkZ2OXllcmtveHlHWTZxRjhSWGdKOGtzMVFoQkw5emxBaFI1ZndqaE9v?=
 =?utf-8?B?eUZSUkYzU3dSNFlmSm5KM2ZNVVRYV3J0d2xTSXl2Zm9PVjUwdnBmM2pkR1Bp?=
 =?utf-8?B?cVZ5bm8xYXF2QURuNDBsZVlmRzNOSjRhblhneFlDdTRnM1VGemNWK0VIazU5?=
 =?utf-8?B?ZFpvSWVjQzA3NTB6bjNHSmhEZU8wamVpZDBxUjVNZ1F5QUNFOWFjM3pUU0E0?=
 =?utf-8?B?dFUwWVNQdDZVV3A3YVhCOGxUamxRYjNUa2pRZ3RLby9ES0o2UHgrbnd0Q05s?=
 =?utf-8?B?Qmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9AC93BC9AC083848BD134EEBB42173B9@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: abcbf45d-58b7-4a14-7b7c-08db03586902
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jan 2023 06:57:25.6364
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: L4fgFs0G5nobvP4lcS/2H/ot9zUjvja0BIu9MqUzqIltvUx//2WJ6ce5fJjLeQc9AFZNrPdSkQS1bXNZvtYfOg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7674
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMS8zMC8yMyAwMToyMSwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+IFVzZSB0aGUgYnZl
Y19zZXRfcGFnZSBoZWxwZXIgdG8gaW5pdGlhbGl6ZSBidmVjcy4NCj4gDQo+IFNpZ25lZC1vZmYt
Ynk6IENocmlzdG9waCBIZWxsd2lnIDxoY2hAbHN0LmRlPg0KPiAtLS0NCg0KTG9va3MgZ29vZC4N
Cg0KUmV2aWV3ZWQtYnk6IENoYWl0YW55YSBLdWxrYXJuaSA8a2NoQG52aWRpYS5jb20+DQoNCi1j
aw0KDQoNCg==
