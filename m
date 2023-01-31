Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FE77682520
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 07:57:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231342AbjAaG5J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 01:57:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230428AbjAaG5E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 01:57:04 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2054.outbound.protection.outlook.com [40.107.243.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B8EA367EC;
        Mon, 30 Jan 2023 22:56:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TXgDlya1MpV7q+VYBqteQy/9SGreOfLsiMoN3TdHjtM9wcDfhX1Ham/lahxezWCb7X5t1lrzzej/u6w6HW4NHGGqkJ/v8dwijzp06W5kyM5cx9qtf+0X7d0gMPzGBB4gZVC+VAFvQeUzK+GpY0ywQL6RSCD2xcD3Qyezvt67WAUSqBB0cNW0b0sRp8ILYB/LQPI9d5pWvEtpQCbzwAZHGlXpUP31+AGOIy6BWPBJ+Esd/GsgPHhXq4aIoRn/2kbMtateVC9ZCKsjx5xgA5CuzBfQlfMgx35aK7fI5p8HaAPez+aIjABRJi7mlqSmtZGmdxhtTPwipEvDQuH7bRi5fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gd2cf+oqzXpl/coVAfs13m5dmfFtHk5u3VIAy+hdU0A=;
 b=CLWxI3y7DBKqTwMwNNiJscgqEwJsbySmEpksT/h/LsB4z7APgZ4Dr4wUSuPLL92s4+2+jbhyXSTdwR5hhKKDxadMsOtlY3vJWnGfZ98CtgP5+ucLHrHCEazBONrZf/nwHEHTEWWjLUyafotr/gsDHu68j8MeOydCYqcuwIkddUwTcUVZaM1Z/nQpLuhx0sz8Gt2hLxtHXE9AOmy1DzKjPpU3c9qMI0+8UjpjGMCcBozSti6AwGLhT7ptIpF0lx6gie62Te8QUegVw3s7CAteuLwi9LX1BYDzGSSu9Hv6wrYvHEPu/XERjAKWfMmaPW1fUSEGvU1Z0tjwkcSLSj0wbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gd2cf+oqzXpl/coVAfs13m5dmfFtHk5u3VIAy+hdU0A=;
 b=WA9cvI5qOXIzoX7sjOLnoJskYuGc/DmPVkW5Y0JtrvmIxMhkiBdMXS+lM8+Pv+VL82mPSI8uLlgK91iKaOHsqiTkD+cynsUEhp7wZyjFt3c8maLfv05FS3LHAsm4cGCJgec/ZT0SduD1KNdm9MvdiXEDo139DVMH9wJfv4oqz2BR3KPNavvyb0q7bkba/5uFm5Gg/gRJfr3DHmDNLAR9tFsjW1Rx7RqDXWFuIlQaXzOBiXQMK1yqeInnChiW/2kDzXnpXkAsK8x38U/rA4tAGOIYVWWyK6f09ggFb9mnADwlZCee/GThr7qdPfvDzCp3xCq7e2fJzi70xZbIqwCFvw==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by IA0PR12MB7674.namprd12.prod.outlook.com (2603:10b6:208:434::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.36; Tue, 31 Jan
 2023 06:56:56 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::b84c:b6e:dc0:8d7]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::b84c:b6e:dc0:8d7%2]) with mapi id 15.20.6043.036; Tue, 31 Jan 2023
 06:56:56 +0000
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
Subject: Re: [PATCH 05/23] target: use bvec_set_page to initialize bvecs
Thread-Topic: [PATCH 05/23] target: use bvec_set_page to initialize bvecs
Thread-Index: AQHZNIxk9En6tjtKxkm1j5/3Zd2wZa64GU+A
Date:   Tue, 31 Jan 2023 06:56:56 +0000
Message-ID: <716a5ef2-3174-0cf1-7f27-f4cfab610c6e@nvidia.com>
References: <20230130092157.1759539-1-hch@lst.de>
 <20230130092157.1759539-6-hch@lst.de>
In-Reply-To: <20230130092157.1759539-6-hch@lst.de>
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
x-ms-office365-filtering-correlation-id: 47f8baa5-2b7f-4581-2d0d-08db03585791
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4yoOit4cJc65qwcpwbM9B+aZUXhY2krVhEafMsjNa6qQdJkVNJrLYGTeE27flnG48lkZha8TwZODfUntzGJlKP3oJuc49cFocjjXA4LsaHwNbp0oDUOixYSx6/YxL0ZPEt6q6P3LKgs7VWEoPIFm2UhTatvL97PuwHr8e80yqH6yv3a4hZrWOP9L69XDS/C+U19deHwjOuD3LJTVibQiE6GEzSpc+nJuDKDVIbIkIdzh28E0J1xft1jXQxrNqtJqJ+6AGa9Rxy74dVSme8v5SFzWkytLVitkwl8BEyL7zX31qQLpbvONOK5lVWfeNs7mcvWCdu7xAKlTqRczg+OtHCaZm3xjfSOnSKY60zonShKeykV40Lsj0UajB/HOSBxU3LJiJCRrRUrn7FK3A/dok7Q71E2WqLDeVG0AmGee6yT6jxlTSsZKdVf5rpkhTYrN9Z7SBmVvVMH2OIoIXBpYZGxhMRJV9S3a9UGeCHMdepshmABxOFQ7O6D8Z8hpc93azwf1cKL3a09TfCt0StvV7tflDOdSuGqG7ceOwSqJOeBpCZ6Lm6Yla7cvCMwVKvwLzPedai8c61E4FK1m3Xf812PB/aaH2YKOxXnmdID/tM4ngjC2Ug63v6kKLTH0uRVurZdDFndKoWBxpRlodRTUZ/YguKaIlbVLBMw+QOZz0i7TALMOSehpqddS7TdYCRzllBQFPe+OtKju93XCzvaQsOkoNIwuW9Dl75X6QR8lnFFy5Ewy/78bcpIh13jPwVX1x8dw43OB1FGgXk4Xj/5Mkw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(39860400002)(136003)(396003)(376002)(366004)(451199018)(31686004)(7416002)(7406005)(5660300002)(8936002)(2906002)(41300700001)(2616005)(8676002)(38070700005)(122000001)(54906003)(66476007)(66556008)(66446008)(478600001)(36756003)(316002)(4326008)(38100700002)(6486002)(64756008)(71200400001)(110136005)(86362001)(6512007)(186003)(31696002)(53546011)(6506007)(558084003)(91956017)(66946007)(76116006)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aWxxQk5EYkVVbmZsL0MxREtObW1hYXJXK2lQRHQrdHRiREwreE1pUUdnaXpD?=
 =?utf-8?B?NDdQYzVWN1JiMndEazhrNmxURTNyRmF3TGZ1Nml4NWtIdW1UZGR2MnZpWkJB?=
 =?utf-8?B?MmV4MnFjV2JwRktXMzZsVmNHZUhqTlRwS1N1VkZBVXpTeExScU9FYkwzTGMw?=
 =?utf-8?B?MHMxa2s1QXdVS21qb0xERGs0ZGpRaWZzTEkxV0RSUVhHMnNzT01uYnlMM2FE?=
 =?utf-8?B?dyt6c3E4SW4wZmFzY1cvaXV0dHdOMXdsMlZQOU9YT2FCQmVNd3AvRXgzUEl1?=
 =?utf-8?B?Y3BZVkFpL1VnMGNJRmdhc00xVVU3M2p3Zlk1TUFJdzN2OEJMZXAwQ01JQXR1?=
 =?utf-8?B?Qjd6TzZtNW1Td1BvZ2x1NVhlUjBrQWRlRWFsd2RjaGo3ZXJYMjJ1UWxJN0cy?=
 =?utf-8?B?MFZpajhLdnRQTlcxcDErWEd0TkJmV3h2WTZRUmxKOC9BOWFpV2pnblROcXVm?=
 =?utf-8?B?UGR3Y3V5cjZVenlkSXZmNlBwT1Y1K2FxMTMrNkZxd2haeWhvb3FXOHNySFdC?=
 =?utf-8?B?YjJMcTJwQUx0Nk0wYWVMb3VqZVVPRW5YL25JYVBDYTlsMnRZRWxCNXZCeFk5?=
 =?utf-8?B?NkJscU9kWmFINXVJbWdzRlczeUM3S1RVeEIvZGNidzRLWitmQzQ0WGlkaG9j?=
 =?utf-8?B?WXlrazZ0aC9ZN2J3bmxTZ1R2SW1yUTUvd1RETlhTV0dMQ1M0YzJLMmhnM3Q2?=
 =?utf-8?B?dVJMc3RZQXBaWVlHUHZ3TVRZMVQvMFVGZDB3bEdvdkFSbEs1ZU9scGFWZ1RI?=
 =?utf-8?B?dTRMVXRSYWNBb2VMSkFmOVY1TngzWktzdGM5WmVNNk0rZnZNWXFSODljWEJl?=
 =?utf-8?B?b3lPU3FzRkdzQkNLN0dlVi8zY0xrcXFtdjFjbGxKM2lTVmdTRkFNVVpIWDN1?=
 =?utf-8?B?ZDhUMEpkUEIrY3VvVHJEVXlncWlUNGU1WHIycEVFOHVMZnNCUG9WcDNGNTlE?=
 =?utf-8?B?MkdsTW1EMmZGNHZsOHRkd1ltTVJlRGZ0Kzg1NlVldVp4VUZ6bmx6dFU1WU05?=
 =?utf-8?B?RTUreEFySlQ4NjZGS3lqdUlEQUJkR3BnWFE1d09QM3U1MWN3NzNLUW9nWVYr?=
 =?utf-8?B?OEdZMzc4K0c2T3BNeDNWZTFFeVcvVTg1WmR2ZWxQMmFlWnUrbnlWbi81SGx5?=
 =?utf-8?B?d1JsRGp3R0RVaXVUaXN2elJDSHdLcVFwWGxRaGhwTFZ3aE5QYy9xY1VjQUhJ?=
 =?utf-8?B?NjRLUWNzQ1UrRndEYm80d095QlIwcHdHcURSc2Z2cURRWHFWY2Q5MmxqVjNH?=
 =?utf-8?B?cGFuSkFkQUJLT2phRzJFSlk3RWViN3Vpc0pUMmFqczlIVElQdlNNZTJtNUk4?=
 =?utf-8?B?R0ZjcHYyWjZBTlJOc01nZFJaNE5UdUYzbHpLZW11U0wvTE5nWkFNZmFhZFNp?=
 =?utf-8?B?TWN6MkwyN2VvK1NSTThhaFlPNWFhRXRuSzBRZTVDUGZBWVVQZFQxajYxb0Vo?=
 =?utf-8?B?cVdZTUpxSFNmTHMzQW5LZERJNVpkY0s3SHFPazZyQlphRVBTY1h3bjFBcit1?=
 =?utf-8?B?OFhQY01DYzlJemtFT2kyaUxOd2tNRDFsNGpRdnhpbmR2dmlDVGFQNGVQR0VT?=
 =?utf-8?B?U2VidldyQ1dEc2JzQWJmNjJ0QmhoTkc1OE9LazFEQ2E3VllsQU5WNThCNGNV?=
 =?utf-8?B?WWFNeFgxenVJOWt2NW9RZXdacXN6N2pSbVkrTGtML1ErNnNPQWJGdk5MdWZP?=
 =?utf-8?B?REM0azBWRkNCL1FtOVI0SGlOTERLckFydVgwSjdCMU9kU240QzZmcjE3SkR1?=
 =?utf-8?B?ME1CY0UwTkJUL1YydjZOdnV1b3AvcVVHZlhmYXh4OGJtWllJdHdHQmMzbzlx?=
 =?utf-8?B?U0tta1pWcmdMTUpkUkdoWXZwZG9hczNxc1dNdDM1UWVRTnhXbW1QcVhaVkNX?=
 =?utf-8?B?S0pZSFdGVG9GLzJHTFpnOXNScmNLeHVsZWIyQmw2aFlwU3lnYTBycE5rQjNW?=
 =?utf-8?B?UzBMYnAyWnR6K0VNVk5JUHliMk5JTHVqdXRzVFFwdGhHc3gvcklGc0ZablE0?=
 =?utf-8?B?TFVPNkc1SUZKblJQQ3FKK29HS3JncHRpYjJPUW1CTFFzUmpCR3hLMHpMTzI4?=
 =?utf-8?B?TUUrR1dhNWxMMkhZbkJWK29rcjd0QVM2Qm45TkxxTWpVbWZpT2JNY2RadWVH?=
 =?utf-8?B?bmh5ZDdScWw4eUNJRjVGa0hxRmpJT3FiWjdtb1F1OE9VZWp3V1NOOTNjNVQ1?=
 =?utf-8?B?Zmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D3DDC62117B0E34C9C8AC9FF112A9094@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47f8baa5-2b7f-4581-2d0d-08db03585791
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jan 2023 06:56:56.4038
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DDC0T1ZFUPy6YE3mZ7athAx0ixGBeVBTXFE7j8hq6PK1Odzvo11Md4Q6kxEpAam8LUp7uRsC2+NvAbUb03tOvQ==
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
Y19zZXRfcGFnZSBoZWxwZXIgdG8gaW5pdGlhbGl6ZSBidmVjcy4NCj4gDQo+IFNpZ25lZC1vZmYt
Ynk6IENocmlzdG9waCBIZWxsd2lnIDxoY2hAbHN0LmRlPg0KPiAtLS0NCg0KDQpMb29rcyBnb29k
Lg0KDQpSZXZpZXdlZC1ieTogQ2hhaXRhbnlhIEt1bGthcm5pIDxrY2hAbnZpZGlhLmNvbT4NCg0K
LWNrDQoNCg0K
