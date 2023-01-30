Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1B0E680C91
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 12:55:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234620AbjA3LzX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 06:55:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236100AbjA3LzQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 06:55:16 -0500
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FDA317CF2;
        Mon, 30 Jan 2023 03:55:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1675079714; x=1706615714;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
  b=GNvH+XrwwM4AKt+bm+OejCfYSyupZpgggIsK8lxA+TBcivmaSifFcCY5
   fi2qlRK1Yug1NNTDOI8TjLAgCCYQdup77X1uA1O2Vj5Ynx3k0rE2bebpO
   AsDR9B/Okw6v56KFe1mzWydgJ/TPH68K/36QZyHts08k2Pa/ocVGCiRC9
   h/ayahku2JKQkxxe6DNHkK5JgEcdRpm6/1tt+ZEPRaZeoSaUvDwT3ntgb
   O7+32pJyd3naYjoddhwUeKHEKBKqSQLLo6pW/PY+2CDnixG375MobWj6V
   q1O7enDzJKjmolVieJTPs0w7lV8UTkyFL9K2jM2rv/SyJN0M2smWVMAN0
   w==;
X-IronPort-AV: E=Sophos;i="5.97,257,1669046400"; 
   d="scan'208";a="222131592"
Received: from mail-bn8nam11lp2169.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.169])
  by ob1.hgst.iphmx.com with ESMTP; 30 Jan 2023 19:55:11 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FSM0mCKSwFtKTc0RooTzSwDnAQiuRGzw25exaUxgfhxWpnk0x8yAUsMYfJXD/nMGsCiq4u9+GMbTPmxTKWi60ju5bF2MED5wA1edZNPD2GiZOgFSSYmipPat0wet8dOt9eX0dyLhLrN9+zaSbt67xMi+i/AhuyyUKj2etyxtnaEbxKWAizuljbPdRT6D5KO2pBIsly7Ex6HYL81iorUXfQr38nm0Ov7JmYvJbVIZFyqQs7+HFMTchMCyHx152qk9qVIxD2iFmJceghhL7vCTCcK2VS60zLBb6BdQoGCRwMB9+otCgwK8n/uTOg49xm48QdyXwuy63ra+qVBO0+HjBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=UVS/HkN9+Ka7Omx0SD0AXKDPdT3YDfM2Oab0rix/dqwdnSseGzYUR3Xt/k9dZSXnl9BR35smfro+Gw8Mcr83aKwdmhYFz5i4Rir/dw605dZ0pznyfU0LmsubyR8w6z5HTst5s0QfSw5+C4P1NT91ZgtQ2MXm4A2Grih3B0f6QEBdM/WPNw8B1zCnXZVROgf2FHDhiSd0hqwarjiU+OTigpzTbHo08JN2+xbTGZTsIM6/7W7caOzaSAXO+4YNC445QnBYU3W2Lyoz3cVPoqk0ni4dEkx7peFrQo5a5BxJzJ/nZNm3XvU91FyXJqOrzELdlzcy6n4PC9+Ff92J42n3BA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=XoPrhzk4fTY1F+86XE0DoX/ziVThMu3/FHJHsEIx9wsaVAaj72nc+x9MR61ire/Z7sQjQSC5aOj5HhKe7BENzVChdBy0IyhALXMiJG32LkdknU18oVuOzY87m5Nocvfl4vbn1Zxdq5mabb15UBir9Tw5PsAqfWmv8OERA6vIe68=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by BN0PR04MB8109.namprd04.prod.outlook.com (2603:10b6:408:15c::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.36; Mon, 30 Jan
 2023 11:55:09 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::8ed8:3450:1525:c60a]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::8ed8:3450:1525:c60a%8]) with mapi id 15.20.6043.036; Mon, 30 Jan 2023
 11:55:09 +0000
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
Subject: Re: [PATCH 01/23] block: factor out a bvec_set_page helper
Thread-Topic: [PATCH 01/23] block: factor out a bvec_set_page helper
Thread-Index: AQHZNIyS8XT4mIkTHUe8e58VIiX42q622kwA
Date:   Mon, 30 Jan 2023 11:55:09 +0000
Message-ID: <203baca2-6c5f-2017-aebc-c4d01211e5b6@wdc.com>
References: <20230130092157.1759539-1-hch@lst.de>
 <20230130092157.1759539-2-hch@lst.de>
In-Reply-To: <20230130092157.1759539-2-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR04MB7416:EE_|BN0PR04MB8109:EE_
x-ms-office365-filtering-correlation-id: ebe51aad-4de7-4252-e6bd-08db02b8d61c
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mV1lspBegEP32UIAMvJONYIq50BC+gMWMya7hEgh0VLTrog6uPdmIdiXu5RMvEmmQYGa7YewnuJcRqgXh9sf+O8lmlKqzH3P6Q610eWiw+6t6TyxWZRMvu2y19/eL+OMzFZbzUPZKuAocw3mBQYzIJltwjjYSp91vB3Nv/1G343nITdxUBwWKPP22sGRxTff0alfjqdVzlQBjWbr3ynwJkR6zsd0/guqrX7ExsqO03m/DmLz4f4/wq3f1N2vg2U76EU8PBe1ioRs9M9takP4xv57BND+FZrRGM0rSiLfIEVWKDUMsy12Leh+hHq+T5hv0C+pTr+S2UuVwJInpTinNXtnDhWHipnE4+++w239w46EUAAwcYJWFft/lx385D3SDBaA9xOHrCaTZweYIuE5hx6AevNPk7YJweFTLsGY07D1WpYEJisreAF8mst/ctG3RYTQCNcaTwIZutORNGlPni3uXdwhU6NkjCBpP+kChcDoUifWNIyZ7EXYMFGfxjhtwgNnJUxEvYbIgLvk40yn8tZqDkHN+VMUge0H2jfEr6DMLNuJfqKGl0rpuwoMgUil1PQahNKcUi6j1Rtq0Nb6RvR+pm6/SgQ89e3nZ9aoiFhl1FXl4Q/iZS7pF/4WAuNoIQwFAWoDGUOxKKMlmaO+2wMvGmRmhXR7KXbeRhJ7ouvTEhyM/fc/yQuLVOzGuvCKhJGcwtLZynKgOBm8gOW1af5S1ZN+0mvwyPnQ4eIUXJRDV9pu+9a2BO08ZyP+RoYXwGL8zB5m10GQP0Q3JDy80Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(39860400002)(376002)(346002)(366004)(396003)(451199018)(31686004)(36756003)(110136005)(316002)(54906003)(7406005)(66946007)(64756008)(91956017)(8676002)(4326008)(76116006)(66556008)(66476007)(66446008)(8936002)(41300700001)(5660300002)(82960400001)(38100700002)(122000001)(86362001)(38070700005)(558084003)(31696002)(71200400001)(186003)(6512007)(6506007)(19618925003)(7416002)(2906002)(478600001)(6486002)(4270600006)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NWdxVTVCYTVQVU8rUnVEOFlhQkl5djJHYU84ODdDaGJPTC91WlZrTEVtK2du?=
 =?utf-8?B?enlNQXF1TlE1L09yc1lhcW5wVUdOazE5WmhIaVNIdzd2Tmk3Umd2a25hYnlJ?=
 =?utf-8?B?QlBCZGF6M3lOSEhNSU4zRTlCUm9ZOVhlbXJydmtNU1BIdWtQL1FWT2hHcXpK?=
 =?utf-8?B?dHY2T3RMZ3lhaUxzOWxUTlkxSElnR3VvNFd1QVM2KzlJaVlTNjZqM0NvTTFZ?=
 =?utf-8?B?UmhMSm9MRlNXYWZJdGFQdFhKZ0VDWjRpUGcrS0lIMFJVMFgzbWpHRTVnaWE3?=
 =?utf-8?B?eFpsNHR0RUVzVU1Rc3VURWpYSW5iMjhYeTc0elZBY2wxL1ZMTWs1RVBVdEQy?=
 =?utf-8?B?SHZXOGYwV1ZtS2JVWVRPN0hOSWFuQjFvSi9mendqcjNFL1ZGWW9CZHhxV2s0?=
 =?utf-8?B?UE0yRHBDdFBIeUdtNnA3K1dGSTJxbUZHeUd5ek1PWGUzMmVOSWFHQ2FzenZw?=
 =?utf-8?B?L21tbUdiT0NvelluL2hEUzNYanhjUnFRK0hteDdHaUVZaG00cEEyL3Z6UE44?=
 =?utf-8?B?dEZFMjIxU3BDcUZxVDRBbldiSDQyYzRVZzRkU0J2d0VSWDk4WDQraVhLcWdr?=
 =?utf-8?B?bk1VcUJUdkVQNm4xdStIVmFwcjBiNllyY3NWblZxSGNzWDFoM3NrY0dOT0ZI?=
 =?utf-8?B?bTlXRVBOUUx3WjFpdjBmQ3JZMjJDend4V0FpZjFhNVBNYXladllUODE4WFJY?=
 =?utf-8?B?aTkvRzRnVXJiMjJDQXphaXRyYkNudHM2aXJLVmFDUHM5bFdxY3pIUFluVDNY?=
 =?utf-8?B?MUYzMVZkWjg2YmR6aGJyTms2a3hPY3VUK1hUYWtZTUs1MGsyb29Wd0lrRjNM?=
 =?utf-8?B?bmpmMXB4MGYvc3RTMjNiYkFYSU16QWRqTDRNTzhEQXZuWVcxQWl4aFIyN1lX?=
 =?utf-8?B?Ym92ajAxMzFDelVveTJNRmFBUkM4YkZ0bVF0anRtd1VScC80RzRqVktaQmNT?=
 =?utf-8?B?TW9McHdzaEhtV0tZKzdpVi9IQ0lQZjV0WGVCQ2ZOZUs1a0tWNzlBYmpmZmMx?=
 =?utf-8?B?RUs1V1FKVmN1eDRzdmdsa0VoUHBHS0FhdEZScEFqVVYzbXl2YVVGOHNPMGlF?=
 =?utf-8?B?NUZJYis4TjZHWnZpWUtXTGxSMkEvSmRxOEk1ZVpTZ2IxK0FldzlVSHlYdVRG?=
 =?utf-8?B?VWlQRkxUSEwvMG9WZ0ExR1lOaWZMTEgxMWMyUTVQbGR6SzhNZHJWK3dQS0Vl?=
 =?utf-8?B?ODVjVHhKTDltNEQvN1pxVmpHZFE0Q3V6SlFydGlOanY5N1lNOVFNNVQ2cWF3?=
 =?utf-8?B?R2NHN25qOGw0Z2Z1Y0l2MjhEelB1bnZ3elFhTFg1QVFtY2MxaG1saDdxaG1o?=
 =?utf-8?B?NTRjUTR5cys1U1lwcWszYksxOTIyWk5RVTZ3T0VmMS82eGJua0ZqR0llQzZH?=
 =?utf-8?B?VHdSdWxDd0dTZ2VmRjV3SHN6c3lJc1A4VlVPY0ZWbnBoTjZmODZrV0JQQVIw?=
 =?utf-8?B?QWxoQzJKbjdSNmNRZ3BHbkJUaEJTdGZLUk5Hak1CazFqbDRTWkhJTE5SRnNP?=
 =?utf-8?B?VFFEUXcyZjVieEQ5a0RndzdEZHh0WG90cU9mdXdPQzliNE5ZRUtOalppZGtB?=
 =?utf-8?B?a2hwbzJrZERCeUhTVzB1T1BheVlFS0ZqSERIR3JsVGpub09xS3ZsbkNTOVdX?=
 =?utf-8?B?aXhSZTRoWWZHZDRXam1OSmJIM1diajVyV2FsZ2xsWU5KM0k1R2MxTnpkeHZv?=
 =?utf-8?B?SkUwWmtiVkYvUTROVUJkQ2lLRWo1a0NpT0x3RU5BRHh2VUM4RG1xeGVyVDFX?=
 =?utf-8?B?bkFab0dZNFpOa05RVm1xc1haM2dXMFJ2NkswQldBRGdwSjZjb0NEL3hYd1d6?=
 =?utf-8?B?WFlEUkZvZ3h4WUlxbDB0TU0raFdwUU4wUktuUXAwbURGb1R1UXJ6NE8zaGpP?=
 =?utf-8?B?NXdxWXZjWFk1elZ5R2RRYzRsaXdrbUpwa1ZESnRMOGwzWGVUSlJVNFdRT1pO?=
 =?utf-8?B?QXdXM3IzNjBGVmUwa1huWmtpc0hjMnlUTkwzbG9oa1Y1T2l5akRtMFhIV1VT?=
 =?utf-8?B?eHFKRFJTN2ZMdGZJM0pvdWM4Tkd3U1owK3lrd3Nyb3pvVnlFTjZCZEF4MmFY?=
 =?utf-8?B?a0NoQlpiRGFEbVEzRW5wcUkvZEowNXE2RXYrNnJPendvTEF2ZHhLWEE4a3B1?=
 =?utf-8?B?SGRGRXNhN2IrTWxDNmphSk55MTMvR1RSSUs0M0c0YlpJbHFCWEpFTXdRUUk5?=
 =?utf-8?B?UUk5YUZHV2oyNFc0TFdQZ2lPSGRuSVNnT3FublFaSUFSUHNZcHVFem1WM1JZ?=
 =?utf-8?B?ZThlWDB3Y1FGVENTT1RjRWEyWEFBPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9A7E5946410CF44C8BFC3D38AD1F19CC@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?MU1GRjVwTmRiMUVmVkozZDFpOU9RZmM3M25pT281T2pMMWcyVkV2cFVzY3hx?=
 =?utf-8?B?T3RTZ3VTZlM1dkE1aW82ajBoM0pzRlp3TkJkcUEySEZIN1VtS3pocW1FMXNK?=
 =?utf-8?B?cmVvNnl2cHdxb2VHMHNudUNlNzZHOGVKRHc3OGFPeFd5bXpSNTQvUGRlQzJw?=
 =?utf-8?B?ZFRNdE9ndWpQYWtTSEVxVXVpUWxXVThKdms1Vy9TZmNkcFlkejlqQlJIa3pN?=
 =?utf-8?B?MjJQb1djSmppZVlCUGJKK0s5aExzQXQxT2FPenQrL1gyQzNFdUwzaGdlU0pB?=
 =?utf-8?B?TVlZaUt3RVdKM0o3ayswbGNCSm5IQjNWU2dXVlpicnVSdWJUSEU5RVFmL2RM?=
 =?utf-8?B?NEJKRTQxM285THp1Y3luWktZZENkRGhMUnkwM09CWEZrOWloOXgvRmpRUGlL?=
 =?utf-8?B?UlBqaFdXNW9vN01oNC9iQ2tCdmFjRTN3M2toaThxUEJQeTZTUWVhVm1IdXlz?=
 =?utf-8?B?RzFpUzNFMG0xYXJoYXB5Wmo1VWR5R2FvVHhmVEhqQVlqaitaeUp2UUYzUFhR?=
 =?utf-8?B?ZHFIc2s4M1dQV1ZaL0RTaGhmemZuU05PQnlRTElsWEFZNGZrcjhaa0FZenl2?=
 =?utf-8?B?MjFIbndja0Q0N2p1cUZ0blFBMEpUTXNpRHNHU0JpOVlNaXVKVEwwZklHY3lV?=
 =?utf-8?B?SXhFZlNiVVZwQUE5V2RQa3VxVnJVai9keW5KaG5naDlwOFFaNnQ0dW5hS1Zu?=
 =?utf-8?B?a2VyVzI4bkt3NVBPU2ZwVjZkU0k4RjhJcDUrdmgxd1EyWUxtZWZmK1lNazNH?=
 =?utf-8?B?NkREZUVyYlY1d1hvOEd1Z0syOTlPUHVYdGZKbVM0ZUU4eDIvdHIrTFdxTTQ1?=
 =?utf-8?B?dVI1NURRTDZYbXZlNzhJZkVlMzdzK3YxUkZQbVIzRkwxdjFwdDV1Ym5nUC8w?=
 =?utf-8?B?OUx6NzdZWlhjODM5RGFOeklHSEVEbjZ4M05PaTUrcWIzSmFUUkhPZFFaUTZS?=
 =?utf-8?B?MzVGVmh3dWpnWnZUZXBsQzhLdkJ1dzdqeU1xTHJ2RnZYc2taYnZBMk5YK0N5?=
 =?utf-8?B?dG1VVy9xQnNNaFhEU25vQ085ZjdPVXI3MjJRVDFLODRGMkg0VGttSW54ai9Q?=
 =?utf-8?B?NFFrVzNYU0RiU2JENTdZUXltM1BhZWZZNmhseXc4UlQycDNVNUErQ1g0eE9v?=
 =?utf-8?B?b1YxWndpZWV1SnVhaWJoa0ZFS2l2Q0NwU3FZWnBVK3VjRGVqYS9oUjRqQm5n?=
 =?utf-8?B?OVF4RGtaS3huRnAzUUJMV1JrN1BZc2NCNWZnYkl0WW80czJpU01ENHFRbDdG?=
 =?utf-8?B?OVJ5dTRYbEljTVNMUEYrUk5CRnJrUXl0ZEIxbnVMRVZWNWZkb1Z6UFFqUjcy?=
 =?utf-8?B?OVFvUHNFcmdOSDZaeGtuMmlHS2lESnVrcnViSzZyK3ZTMHlTbzE0YWI1Z0Vn?=
 =?utf-8?B?cDVlVzNHSzNzQ3p2dXUybFRVUkxGeTVpVmJ6Vnp5QXMxMkM5NDQ1KzZwY1Nm?=
 =?utf-8?B?ODkvWlh1bEFVWVNEZWJUQ0JndkVXYWh5WHE0NFZlWkhGRmZnWDJ1ZlU1WXAy?=
 =?utf-8?B?d3p0WnY4MHNVQXM4djhMLzZaRVRqemtTai9WMG9kL2VoK1ByMzVDb2xWTnpL?=
 =?utf-8?B?cUNJRTN1TkJUQmpTOFRxbjBzckVwc1E0OTlETHN4dldGb1dtL1BDd1N3ZW11?=
 =?utf-8?B?TW4xa1pRZTRlbUlYM0VxQi9DemxQRlN4ZVBFMjc1WXVkdFdITkhSdDZyc2M1?=
 =?utf-8?B?S2Z4Tm5VbEZSZmhObmNTQ3lCckZhajRsc1BuZ2pKZjB2OVdXUmN1ODFnNmJx?=
 =?utf-8?B?YXhmTDJ2TU5FODQraG45SFM5R2NLK2VsZDNrUU1ycWZwRXdGZUhrMC8zOER1?=
 =?utf-8?B?T1F2cWtmdUVCVmF3Qnd6YW9PQkhTR05CdjhlVmI0Mis5eXRSd3FacVNJK05q?=
 =?utf-8?B?Kzd0THNUU1E0aEJySXZhdXFYbS8vc3dtbHQyNFJUVlc5MWVNYkNRSm5WMTZC?=
 =?utf-8?B?MmxWa3FsbkxReDBjTU5LVkx0Qkp6T2lZRFBNdnRFNUI5S25FQldJV2FRcmZ4?=
 =?utf-8?B?UXFheURaenNIV3B5dWM0V1g5YW54V21MTW9Xd3dQV1BWNWEwZGFYdUVOdEFn?=
 =?utf-8?B?VlhNWTl3R2dYaWVPSytnYnlrS3llTExHTjdlQT09?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ebe51aad-4de7-4252-e6bd-08db02b8d61c
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jan 2023 11:55:09.2201
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: G/Q1fy/LArVXlB5n2daUZrlck/peZQZf80k2oHDsSzRDHmvtuIRYWwtsp6tr5CXKoqod84PuHmDYm38UjnxjaCpd7SP+c7jMvpWeyS7UMdY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR04MB8109
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
