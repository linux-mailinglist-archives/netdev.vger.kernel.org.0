Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A1B9680F05
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 14:31:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236550AbjA3NbX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 08:31:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236193AbjA3NbN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 08:31:13 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 604061421C;
        Mon, 30 Jan 2023 05:31:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1675085469; x=1706621469;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
  b=psPJqaMstjPW8AO+/4zAwNZMEEsLGZvyIhBYWeCVgxQMqyUi+wR3gaaC
   q0XMpm2cJKibydaxt5oYm1/hHU7+fmXXQDG9tKOwKkMmkOnRwtayV94h9
   17K/IDwdHocprwsFKxJSbvw4twMO1BNNoptNj/LySenoZISAAb9DxpIlU
   /ZJiV8Y25xWLDpM/nnjAPEU9bW9rloJj1h0SmYDeOuGjhYiAm5kMftTn3
   lIqSJSnp65JbGMiD+lMsFG1HWf1TvNFFVYM0tVji6Vhetx/kxwe4nGSqv
   mmFQitWv2LAmPgXB1CLjYfyU170gQq9m+8Hg8s9KL3H60KUR8fvdrhX/7
   Q==;
X-IronPort-AV: E=Sophos;i="5.97,258,1669046400"; 
   d="scan'208";a="221878813"
Received: from mail-sn1nam02lp2042.outbound.protection.outlook.com (HELO NAM02-SN1-obe.outbound.protection.outlook.com) ([104.47.57.42])
  by ob1.hgst.iphmx.com with ESMTP; 30 Jan 2023 21:31:05 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g4HjU8pBByOzh294SZVvxv61FF8QN1JuCImMe1r9aAk2qCnmqhlgElVeLus57kBK8WPj7eBX/8AFqCLDjs24JdzwioeJnWag1giJQwhyUfTB49+tatGnKdTuQqUReydclOpXQ4/beuVC84YkZq5XV00r0yVK0JkSpLppYzUpHErqFg8oMsRKhE9Mk3HpTjTUS6tEE1s88L3RnsDmmko5FYMzkMcIVl1Xdo5QgMSoHCCm3cQ3OkDqlKdxQREq+fiF9aH5wpHRyTAw494fQsslj7SoM0+a0KIh1DbX0iPn7k7Jh7/MABT+GFMS+BX90gIcA1l7n2h2oBK6xNMe3Zw4TQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=CQZZTRY7VqdCgcem9jQtLNF9EapzNwSRKaapRxM27oNbKRKpjqkITO9M66hya4HfkzFAA8rAf2WcjJdFDTRgh0f5viLicRxqonOrxL/kDYcAnsLSafqkarmc33YoB9q5NSm0nSDTvQbAM+MEDfzXsVVgYvJrErrqJ8My6ZWhxt9CLk72nNW3gmTEpj2D3C3ghHnMkuEGU12pZSYLWl1jTqxIpiBt8O3wqpuJzDsxIEXk9KrVHHZivEB9tYk9IfTsBAaDXI/Mkx5LAtqkg4SfAmqAXmVP8XJBvD48+k1GntQvPm6zBxjZLQphFwmwbRtLCrBtKG9UrhyiZ0v+Gnvk7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=ak0V98nekLP/kcHQC5VEAfO9V7IPnxx75d997h11R1ozo1gViuxv/zTk9cnYZ56A/NbRd+ZB0kawjLI3waJWuZLdIr0T3kE5QfgXmr+hNpzS1IiyFKmudIy0iMn/RgvvJ29b+viiz/ita0I+XVi3yS476Zw9fAAeSa3pR4xFvZU=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by CH2PR04MB6951.namprd04.prod.outlook.com (2603:10b6:610:a0::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.36; Mon, 30 Jan
 2023 13:31:02 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::8ed8:3450:1525:c60a]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::8ed8:3450:1525:c60a%8]) with mapi id 15.20.6043.036; Mon, 30 Jan 2023
 13:31:02 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
CC:     Ilya Dryomov <idryomov@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Minchan Kim <minchan@kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Keith Busch <kbusch@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>,
        Chaitanya Kulkarni <kch@nvidia.com>,
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
Subject: Re: [PATCH 10/23] zram: use bvec_set_page to initialize bvecs
Thread-Topic: [PATCH 10/23] zram: use bvec_set_page to initialize bvecs
Thread-Index: AQHZNIzTPzs4j3ThZ0KNo2COcLDv0q629RaA
Date:   Mon, 30 Jan 2023 13:31:02 +0000
Message-ID: <170e8433-5400-a78b-65f9-1b4556a6e649@wdc.com>
References: <20230130092157.1759539-1-hch@lst.de>
 <20230130092157.1759539-11-hch@lst.de>
In-Reply-To: <20230130092157.1759539-11-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR04MB7416:EE_|CH2PR04MB6951:EE_
x-ms-office365-filtering-correlation-id: bb21410d-af7e-4ef2-5849-08db02c63b1d
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gTVe4yTEM+dfqx/diRM2DEnKAj2H2ZpJ0NpqyaYou2YcPLp8eV7XjA0Q+KBzQFyBmAnc3dHDtnUl7ugrvS6dgL/khRpPKw/RMfnXyhby24Zypecup1raAZlsVdPpWy7rNrAO2wHnuP4J6+V1d75ZDW03KFQtJHbV3G9dCTLhE31TRDanQmetSgLjqtuylhZAlgz6HbWKsl7BiwuhhzTlMQTKq/3XgiIflG6ZU1qvBCafqoBMZiEiMRP/fj47yd596kxZpT5m1KTrWpKvrSMeAVm2j0NjCVZ4AvrYUa+A+woym+J8shczcl3yq5c/e1qcD3Ke9zPIarYaA6fDI4sr8bV8OmwBG4G0CYHdsP1Ie2kX4GBJVBF1rZ5cfOpCKntPZFUS5im7Zs296d36oAMi3kST0SrBCIo5W06hxYAMbSpwZqvfGdc7W3HJKtD1zwK2mviDU6eJFK5UKQlmxKcAd34BgdLiycc1lM20NjzLYbG0cJF1T7QqiU8h/QjQkswSoapOJ1fPWKSJur8e9BdWLyiAMidHYfky5BhIvTgclg90583MDOxhXqfZQFSEM1/x/u/lgLfc6j5CypyvSaDjcoFEoU/b3ySOGtngB9GNLjo59OySUr8LEJgvUNlgAywWpkLbO4FEbP1zrTHSP1r06Z40VnAmVwasMNkC643y0eYLs603/CGMYQdXv1YmzlBNfuEVFW5VAzq+fpd9rwmRhtbyD7U8k94d/bxYKWCIQF1XwoFhEWjKqb5+dcZfir4SsDzuJDCWYympeJPB2n881g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(366004)(396003)(376002)(136003)(346002)(451199018)(31686004)(2906002)(19618925003)(7406005)(558084003)(66556008)(66446008)(5660300002)(41300700001)(8936002)(7416002)(6512007)(6506007)(2616005)(186003)(82960400001)(38070700005)(31696002)(122000001)(86362001)(38100700002)(4326008)(66946007)(66476007)(76116006)(91956017)(316002)(110136005)(478600001)(4270600006)(54906003)(8676002)(64756008)(36756003)(71200400001)(6486002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?L1NPQ21FU0piU0ZvMkJhaXpPcStBRnJQVkVydHlka2NWQlFXeFJsck9GL01N?=
 =?utf-8?B?MnFTRkl6WnNtNmdHZnRlVDZNSXg5ZGp0SnlSSVdiYXE2dzd0eHZ2M0JvMlRH?=
 =?utf-8?B?ZURLdWpwV0hpTnFPcEFRZStoWG1VNSsyU0pRZnkrMUVnRVUrYkx3ZjR6TEpo?=
 =?utf-8?B?c29PMVdQeFhBMHUrZFd4M0ttRUhXOG1WaG5CQitSUXIvQitkdGYzUkJNcFVx?=
 =?utf-8?B?S1BiOGd5dUJWV0l6NktJRVlnNHA4UjRneFdkZ0R4dXJQSWtybnAzbmI0NHhP?=
 =?utf-8?B?czV5dS9hd1RocEwwSmFJQU5HMFN2d3RpdjFuTE5LOFZ6aHBFVjJHcVFjenAz?=
 =?utf-8?B?aVFuZGYwODNvUHk4WlFsa3BTNDVOdVdnSHQ5ZFRTUlc0dm5GT1AzK3cyeFJl?=
 =?utf-8?B?K0JLeTFqbElpNFdrTWFKUStZaUcybG9xb3kxdDMrQm5HdGFVZmJnZGVheFpP?=
 =?utf-8?B?RHhKWUtTRUMwUkhFaVNUM3RXQnFuTmkvWlVXaHhMcWwrZTkrd0x0RHhtR0RE?=
 =?utf-8?B?bmRGYmdjT3BITVlHNWlvWkdyVzlWMnM2YUg2RDNSYkZwdFZ2T1IwTFZCUDQ3?=
 =?utf-8?B?d2owYWI0NEd0dkZmNk9Mc243VG9QYXpqQmkwazk4aG5UbUlvMGhRL2ZSd0Uv?=
 =?utf-8?B?Z05kZnYxclBucUVISEI5OThQTkFlN3RvTXBUaVFBMERxcmNIVnBKQ1RNMGVp?=
 =?utf-8?B?L09DaHRwTE02SCtBS0hRUGdzc0QyTm8wTVJxVDFRRGwveGx3bU1udTlzelJD?=
 =?utf-8?B?eTh0cVMrNy9kTmhxZjJhVjJ4emtQQ1NkTm9hMFk2M0dzRFk0dDd0a05hMHNk?=
 =?utf-8?B?YVcwR0VDOEs4ZzFrb0ZxUzFnWTlKOUErejN6c05kNExaSk5pTndWZ3pnODFp?=
 =?utf-8?B?TUdrV0pYczJuOFVYNGRuQnRtZTlVV011b2tFbjVnMmRvQjlTcFRpMEJFZSs3?=
 =?utf-8?B?RmcyNWtZVGRVNWJoLzdCVldoWU81aWxwNEpiY2MvaHpiR3BjVW0rODFIM3o2?=
 =?utf-8?B?ZVFmb2xQaU9odnlzOFBOeVBrQzFaNnh4QVY5UVNqNXlaK3Y2dGpBd2o3bmpI?=
 =?utf-8?B?TkhuclhPVVZ2c0dnelNsMnNWdCtyN1FacVBMWFBkblc2WVJrcFcySzBoRUk2?=
 =?utf-8?B?emcvRDluVmpEY3Zrb3hPV3JDOEpkbjZMcnpNZzNEYUtjalRUSWxwSlRnK0xT?=
 =?utf-8?B?djdUSzUrMjRvcHhDUlduZFlRSjJTWVB2dWlJUUR0MmZZSE4vNjFOSW5CWFh5?=
 =?utf-8?B?NmRhRkUyZFY5UjBkVFJIMUQ4KzVUeDI5TFVaKzU5VmFia0pOQ01wcExweDdB?=
 =?utf-8?B?K1ZkdkNyTDBQMW5jRzFqRlFzQkxSV2N1MTNUMlpWK1pSRWVEWEd1SUo0dlBl?=
 =?utf-8?B?V0IxS29JNENzM1Q3N1BPSGdJUitiOVM5VG4rOWo0NWRqMG1yUGdpcStKckJ4?=
 =?utf-8?B?SDhCUFNaVVRiU0xPRkR5ejVOZnh6RlZrT1ArV1hPWjdyVk5oYTJkNXprNTgy?=
 =?utf-8?B?VDUyUk1Kc1l4Y04rVW9KTkV5cENqZkpOWGdUSTc4Mko2NkFxQmVXMm1oN0Vn?=
 =?utf-8?B?dEJWV3NZWHc4c0ozcG53Qmx2Qm4vQ092RURQMkFqOG1QZWhuZzVwd0ZsbThz?=
 =?utf-8?B?RHJBaVFzczdhL2tpaW81Q0VxaWF1ZWl5VUNRZzBIRG1xS214SXY3SU5ZUmhm?=
 =?utf-8?B?by9OZGx0NkhTdEdtTXF6cXpOWSs1bEhiVWVBS2xVNWlyTkdPeVhST3RtYmNO?=
 =?utf-8?B?WU1IaHNHQTBoS0NXWWFJbmQzN3FMemsxRy9taEpwSFVxZGF4cXdaTk1HY081?=
 =?utf-8?B?TjBUK3hqc1lvVU9kYTFuTHdveWFLdE9IWm1qd2hwUDNEZG5jYUdnamFRTDBY?=
 =?utf-8?B?VjROM0JhemFDck03MllPYnB0RnAxRmMvcy9ma0RTbEhISE9XSm1SN3NCU2wy?=
 =?utf-8?B?YVZMZVhiVFFXNmM1Z1hwUEExSlR2cWZYOHBCc1pTVDg2WDdrNVg4aGoxRG1a?=
 =?utf-8?B?RGk3NWpPU2toNzFXbFlETWtHbkRQM2RiUTlKaG4yb0xqUG1JdGpxVHlKU1NJ?=
 =?utf-8?B?TE5GenhSakJ0OFB3MDhJb2FUSmU1YVhNalNaL1doL2M2MUxhQXE1bFFoaGo0?=
 =?utf-8?B?VWZxL2xCOE9iaTdWQmlQRnNJdXZGZEFibTl4MDVYU1hoNEpRcjI1alppamh0?=
 =?utf-8?B?RlRCeWp2WXlYa2RDa1ljcStoSkw1WkNHamtFcElKdkptK3hpekpQWk55NHYw?=
 =?utf-8?B?cVVGOXczTUJzaE9ybjdBa1E0WXNRPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6E51E1F95152D34EAFB128277AED6BDC@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?cXE4aEZMYlpKUTRVSEYwS1YybzFXenpyWkw3RDliWU5ERVF1azNSRUVVK1Jl?=
 =?utf-8?B?S2VyWngrZmVJbUVsUzFaZ05zNDJJbGhxWUpxR0haQzRKTWxlUzRxKzNLeXJz?=
 =?utf-8?B?NDFRQ0hRY1ZHcUcyTmxpWUl4c1NhWGYwbWEwQXFLbE5QeGhiK0prMDgvWERK?=
 =?utf-8?B?ZG0zTEN0S05xUkpBOXdBOG5yUVY4Q002N1VsbFZna0loOXRyY0RTamNuaU1J?=
 =?utf-8?B?eGdmL0dheG54Z3NmK2tmZDZ4SFZLT043VDR6Vmx3TlRqVHFpaC9GVHpTcVc4?=
 =?utf-8?B?alg4N09mckhDckFOU0FPbUdnTWVveXMyNkdUZUpPQS9BRk9weEZSM05ER0FU?=
 =?utf-8?B?RE1HMlJQK0Q1aU0vckp1WGpiWm9WU2tjeGNjdGc0TTJpdndIbWVNbElKdVEw?=
 =?utf-8?B?QUNvNThzRDVqYWR2WlhRVG8wR3lGQmZrbkVmOXhKVEZrNGpuSnlqVkVNeTN4?=
 =?utf-8?B?RW5Lc2l6OWMvaEJNTnhoRklsUnNOK2hEcVp3bVdOUmJoSjhYUU5PK1VhaFZt?=
 =?utf-8?B?cnhUcnp1a3BDU2wwbUkvcVBpbzVnZVNhRTNGaWVNdzlQU3dGSFN3TmNhTS92?=
 =?utf-8?B?NUZValVia1VKenNaN2Q1TFhOd0RxMFprRzZrNmlVTkd6bjJNMjNocTkrUEZz?=
 =?utf-8?B?UVgrNitBc3AxeDhDQ1FLanNpTDBLTDJaOXl4cmR2MCtKRXc5em9sQ1FudXMx?=
 =?utf-8?B?bFhVSENkQUxhaEhHd01NcjI1SHc3RGtLUHRqbVhBY1ZaalRNOEMrRmFmZ0tL?=
 =?utf-8?B?MnQ4aGx4eWpmOE0xeWtoMno4MXYzMGp5OGtIQnRrWXBmKzhib2ZPQ2h6OG92?=
 =?utf-8?B?ZEpHUC9iU2tjc0ovRU5mbUl4TXp2OWlibDg4WHljeEMwUGNtU0J2cHZOY1po?=
 =?utf-8?B?QXpwSTZ1R0dBQnVlSUxnWENnK3pBdXJNelhkeVBudHo1elp5eDUxU1pIVDly?=
 =?utf-8?B?K0JtT05Bd0h4QmcwYTJ6Rk8yUE5ETndmM0dFdk1xc2R1bk5JYXQ1V2lLRi9q?=
 =?utf-8?B?VVM1eENIZk5GQk8yTFJoYU1tMU1sTmpTaDkzSWs1VEJlSmNEUkRXVEZESmhu?=
 =?utf-8?B?R1NrMWwyMEJLM3JvYXJXMEpoaW51WFh5bEp3cDNoSVVBREVtYmhtRE5INDdZ?=
 =?utf-8?B?ZjhVVzVhM0F0ZktDU1UwYTZrMGljU3VodStoRFJnRXFNNXdybjZ0ak1vcG1v?=
 =?utf-8?B?dEszVGVuZFZGam9PY3cxVExPMGlMSzZTUVZMMk9MRnN3M1JTMkVEUTF4R0lL?=
 =?utf-8?B?ajZoN3ByTis4TEhzb1dnYmxpR2dHdmZFcHhpRWV1dWZwZ2JGcVIyR2UyMUpI?=
 =?utf-8?B?OGc2Z3I3d2pmY0JjUkJsckVkakdzU28rMUsrWGJkbHFxRFpMOTJDbnBQcjZn?=
 =?utf-8?B?L3VJWkJMZ0NwbmwwNzJmRmpMMFVjU2RPUXBsTncvaTZ6a2xYdlgwU1k0VzNM?=
 =?utf-8?B?cnNPQ3AxWmFQeVVRcmZMUjl6Y1FzTGNNdHROdWk2M1hCcTZvbG1TRGNrTWZs?=
 =?utf-8?B?TzNqTGoxbmVldUVjTVlxNnRFRkUzbWpXcytWU3ZON2tDeHVvS1hhb0F3Sk05?=
 =?utf-8?B?WDdlS05PSTcxUEEzRG5qU3lOT0ZOak5FVjc3SzJSOXF3eXZqMDNXeUdtdEpB?=
 =?utf-8?B?SG41dGVaOWM3Rm9teWZMOW9aSUFtWVRzSDFtRWt6bncyNCtVYWZSQlFCb2Fq?=
 =?utf-8?B?MXh6bjhxL3llajhVL1dPRjBadXk3WGJKekNLak1aSi9LNU5NR09SN0N3bXhR?=
 =?utf-8?B?TGxXWktmaGNldkFYMkdHdDc3WmZ1ZzRKOE1lMFpBM25DdEZRbDRjNDhsNi9Z?=
 =?utf-8?B?VzRjOXU1b0EzOW1OUWR3c2RGc2QzcUlGZ1E0UlBjWFdUa3hvL0M1TkpTQUE1?=
 =?utf-8?B?ZnIzcTluR2hHeGtZTTJ1TmpJc2tWQkc0NGk2MzhNZnRVeFZ3MXE5ZWZSaUZC?=
 =?utf-8?B?K1huQVpJZm12bzJHZGJoc1Q2cGpXUEV5MkczTGZZL0QxWVJZS0RBbHYvYW5v?=
 =?utf-8?B?MXdlTFBHajFrRTJuTHR4QjFINUFZNVhyR2x5aFhkL2o3VDlzSUtULzZJVi8y?=
 =?utf-8?B?dDhKbmxLRUVNbmNhTzZqbmFFUWM1a0loQVZZQT09?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb21410d-af7e-4ef2-5849-08db02c63b1d
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jan 2023 13:31:02.1147
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0DVlytwxF76RFwGjhCCAvW+MWnkzHxHpH7doogFwEawNiRgKIobc4FFkwl6EaVFGF/TrBKQyamqD7z9YRtWMDqQbN301IweKR7IWuGTcwPQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR04MB6951
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TG9va3MgZ29vZCwNClJldmlld2VkLWJ5OiBKb2hhbm5lcyBUaHVtc2hpcm4gPGpvaGFubmVzLnRo
dW1zaGlybkB3ZGMuY29tPg0K
