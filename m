Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E21E1680D07
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 13:08:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236661AbjA3MIp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 07:08:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236596AbjA3MIa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 07:08:30 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA3C5EB4B;
        Mon, 30 Jan 2023 04:08:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1675080485; x=1706616485;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
  b=ktLGLgC6KLVX5Bvcbs1KQeLvLpDrSQkba2s469EVpDKtjE1hJBhM7q2i
   ILS5LLRnlzsHAo8m7p9P3Mzm1++8Zyp53Qaa2UdQRpmYB1BABEtFT/9S6
   kDkXtluvI/rNxmjz4diC3ohGfZVz21jC8UNyVzY6ksgLfpRz5XlHGgU45
   qXVJGLpL2clZSWEKbokxzyXW07WWcKgRX7+h/wAvQ9r2djIfl8fJz8ZnQ
   k15VYkExUlt+gc6UWgj0BFva4jbwk+h9Yzr9xPw7T4SV/WGAPX0CsERLy
   1NkwrD95lgdOGhxEypzYpC8VzB5I+SxnxYurTJedRbCx0H+2zGg0pfGdF
   Q==;
X-IronPort-AV: E=Sophos;i="5.97,257,1669046400"; 
   d="scan'208";a="221874514"
Received: from mail-dm6nam12lp2175.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.175])
  by ob1.hgst.iphmx.com with ESMTP; 30 Jan 2023 20:07:03 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K8nDSzvADkS6gY9YUJcSpNjk0yQtnh97UBxzNM5AOVNNxQ8RNVJRoDIdmBucq9u8jSSOtdCojUi1S11K3umRL1EZ8QXehge2qjsF3rfBFnFg88JZP3FJvVSFug5WYJy3dYHuo8EK+7cEVZoDPMzAfoPeFjcwaAo5wCHTjQ4mnmN7ZqYJD4myD+mS/UVoahx33D4kjeyScyngPfJZ6tW6Kqm52jZpfG+jXYGHlUREyds+0sKbZECBpOA2xrE8QhGyBAry9d4ozzIT4btLdPpfEOgrWsc648zjXgtleSX8CcikYyeFzf6YlN+KZkMA8rhZF7v8tPNk4Z4DT/SbmyHOHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=j1HcweD8e4e3CKgX04m9UTw2PmVb1ISKHhKhqYWH+9Lw5tF04AhK1gvalzFZK2YmfjjWRpknYmNw70YKD/cHfwJFhKz91buhzUiCYv+i29pluNB9c/k6NMGqcaLpwbrykNDk9s0TRQBPtQ5OQIu2li695pX+sgyD4OHmU/yYuIUtfiaQYt0Zlj//Gz/xfr9cBH0oGKYQzAEyLiC8O1YsTP9v5TScpg33egT1CRckM9KCVHSi3FKY+bT71+cFP/nh7rcWkuw8r4EZE+ICze72XB7NpbsKj1CZWQjo40LNGV0obrEAIGar9P1Xxg8GfD8+WTCc/6JT5xXD5p6utLHKQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=ZvZXHlWv4XRK6m2HC5KiuAh38yRtSdRsjph+iBRVeBkxWQAOS+rwICP1+tM+y9dXB6WGRVO+8Q35Ke1c6XTpMUkuG16kfsUN1PkpCR2ozb9UALtPfqf9J606CFI4TWgoAXyGlwa64r2TWkb/KNOuyGftqpIv3hukAcfDT0sVwUc=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by DM6PR04MB4428.namprd04.prod.outlook.com (2603:10b6:5:9b::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.21; Mon, 30 Jan
 2023 12:07:01 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::8ed8:3450:1525:c60a]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::8ed8:3450:1525:c60a%8]) with mapi id 15.20.6043.036; Mon, 30 Jan 2023
 12:07:01 +0000
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
Subject: Re: [PATCH 06/23] nvmet: use bvec_set_page to initialize bvecs
Thread-Topic: [PATCH 06/23] nvmet: use bvec_set_page to initialize bvecs
Thread-Index: AQHZNIzKYE5Gfnbby06cTcgNN6y6R6623ZwA
Date:   Mon, 30 Jan 2023 12:07:01 +0000
Message-ID: <ca9482ff-832f-5a7e-cc0a-95cb0f925a86@wdc.com>
References: <20230130092157.1759539-1-hch@lst.de>
 <20230130092157.1759539-7-hch@lst.de>
In-Reply-To: <20230130092157.1759539-7-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR04MB7416:EE_|DM6PR04MB4428:EE_
x-ms-office365-filtering-correlation-id: f0c2ca88-3e9c-41c8-a13f-08db02ba7eaa
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uzkejLSpvSo0bQeHNRc99jtLOkb2Xq36tT500bD12etLYHxx+dUiXJzGfYGb2sBAMeGQ23lXFAmOz0cqJpUM8inJQ/05BjWaUxR1DGC2qLrnwoP5e98r5pLhNjBlTEiHj/KvmcLvpesWB2XxayEVlAJcknGkY8aHGUfcVozCscetyinoztJy8xan4+2JE+YoZpKIRIof2PAt/GfJlxF76B/kvVfDB9EWcgNLcqbM/OOdm4lSpiFKO1KYXyVP2ZoIV2TTZgn2Wwg2csSH+6xVl9/ecPhYrtkVP7VGTLNlc5hTyDTW/K6kb/Qzn9eXTpbFRjxO4Om6M1FQeIP1mm/qMcuElUzRrs5eZ69/7rpFnmYnkR8jBD8xLHL4Lkfr0EYALhFp1ziY6tD2R2EUixcqhC2A5ttGNY0NibznHaahSxgjGXs+7MEt0yhOOMIxwMuxJjPVUwJ47FN6ctooHj7jBxZzvw4HAq+BvVS/0OWXUUCnFLZK4zT6C+Qi+HzkgABEupkK3uyALbWUOhQf++jD/oE1vmgH+YAsogpZjRHrSeFVIC2dMSLHLHPj11+dN9Lovt4GxFG9clftyBmxm1a9f6Udf3wBK/prO2i+O8Rt0fBV16NE+IMO/r66dlCqCt4v11Mn2BZ+xz4wFy7cOYgzD7oNPZq/VyLk5lxb1lyuDRfaNRZT0KsBCiarF/CxBP3RvKcQ7v+oXjWIzgjk4gq8n/w8k8fneEvtagV+MX38QfL9rVsNR+AHLL7dvEIzxk3DvLiNitIOncna31f3YWehJQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(376002)(346002)(39860400002)(136003)(396003)(451199018)(31696002)(558084003)(36756003)(71200400001)(8676002)(19618925003)(6506007)(6486002)(82960400001)(41300700001)(478600001)(66446008)(76116006)(66946007)(110136005)(2906002)(66556008)(66476007)(7406005)(4326008)(91956017)(316002)(8936002)(38070700005)(38100700002)(2616005)(6512007)(54906003)(5660300002)(86362001)(7416002)(4270600006)(122000001)(64756008)(186003)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?K3RXNnBESnBnOWNBUmFZak5QQlhnaUllL3E4Z3ljY2tTUU5NTlN1U0k1TXJw?=
 =?utf-8?B?RVZzZXRXKzRZTXp5R0N0MWNGOWJDdFY3R0QvaVR3M3dFc1VCa1lIYnVBMlZR?=
 =?utf-8?B?RWJoVGpyMndtZzgzWlZMNnp6YXZncmJyUWlWQWRaUjBKSHErcVBjTVZ3UGpn?=
 =?utf-8?B?M1FqaitQdWVqdUp0Mm5lM0k5WlRkL3BPTHJvNXBlWkdwSE1wTTlrdFRmV25p?=
 =?utf-8?B?TWxVenhxTHdvRlJZdENPdHJNOGwya1Y2SWR6ZTNZUmNXakFTeURCWmUwNUlJ?=
 =?utf-8?B?emd2N3pSV2ZTdEovTW5XWkNNaXN6dVd0MWp6MUNzcXNZaEpUUCtKMm02NXpT?=
 =?utf-8?B?OUxDR1BsV1ExZFhIU1lUUkRRMDNJeTJ3UWlvUitxYnh3WHRCNGZWVVNJQmwr?=
 =?utf-8?B?bFUvNzZMVDJlMmJKTDFNMDVENHdVb2NJRFJUUTI5RW1BWmR2ejMzZkpwOWxT?=
 =?utf-8?B?emU5bnovWWY5aFVxYXBaLzZPOUFuNVdXNThmdEdROFQ0Mi9vU3BoTkFSMnlr?=
 =?utf-8?B?WnBLM3hicFdIREZOQVFHM0wwSnBLNUVBcDliWXRFM0ZwYS9xTTFEWDNoN0Zs?=
 =?utf-8?B?QUxWKzdZQzZRT0ptMm10aVBLUnFRQUNQZGV0KyttUldOOU1sa0VjS0FZZEJa?=
 =?utf-8?B?dFhoMDlPalZIdy9Ga2JGYThGZWFudUdDaldpVGRUcnJwSlBxWXB5Tm5RdEpG?=
 =?utf-8?B?OHBtV0wzRDdoR25NMCtWM3VXQWlPRzE1U0RGbVo1VWo5T2JCT2QzRWVFYnEx?=
 =?utf-8?B?dStCVjM2a0RTRUN3d2d1MlRtOGdMUDdRdm1TMjU3V3E4Z3p4TjJyMmNEMkNP?=
 =?utf-8?B?TUZoT0hTcVUzZGF2Njl3TnQ5OXh1YkpZb1hpaU5qbkZIKzBEc0YzT0JYQmNM?=
 =?utf-8?B?TTJLUG9Nell3NC81MHhqQi9Lb0JQbDVEbHd3cllnSmV5M2ZZbU1Ud3Btcy9z?=
 =?utf-8?B?THF2azhyb3RKcnk0RGNQNHdIZmZ3RVJrbzNTRWRBckVSYVBibEszTUJMdnl3?=
 =?utf-8?B?ZHJ1dVkzVVNvSUNHdFhDeHVqQ3BlYWhUdmJJTy9nYkNMOWlhTHBTNk9UbTZF?=
 =?utf-8?B?aGNkTlM1UGZIeGxpbEtZMjhwZm9BckdmU0ZUVzZPZzFxM3dtRVAxaG55UFBL?=
 =?utf-8?B?Uk1OU28ycGRJRE5RSzA2Y0JLQlJ0UitreDVUWStkdzNSMVF2VkhCNEZVdVF4?=
 =?utf-8?B?dy9jZCt1Y1E2T2FyOUt5MTlZODRxN0tla0Z2TFdWMkNLMUNTR3hxekZoUlpI?=
 =?utf-8?B?bWhXaktFR3dCaFFIemk4WkhST3dObXloZ05ScnJwOVJKSFZzT3pFTTBGTFdT?=
 =?utf-8?B?R1R3WEsvT0ZKN0RPR2lZYTFXUU00cW9yRGtlZ2lTekZnRSs1YUJodktoWmcr?=
 =?utf-8?B?MWNhdGNsRlFZNzhXNnN0QVI3TVUwbnN2SENUZ2ZxWUpBTVAwQVhvK0tZaU8v?=
 =?utf-8?B?TXQ2Mk8yb1ppVWVkcmgxUlZHTHYybW9HdmUvSG1ZRWk1WjJFdzFhcThycHU1?=
 =?utf-8?B?Y25iK0JaK2U0S1pLQTRnRmVHM3cwZk13ZUdHc1p1cXNsTm84ckZuMTNFTmdp?=
 =?utf-8?B?V0NmNlFLWjRGM1lJWFVQOVhrVkFYSjNSSGxaMEFlNUZXcytTOWhoSjJiMTJD?=
 =?utf-8?B?NFFyZzFLOU85MmVuQllmVUtSS0RveEZmVE5XVWY4M1BlR1N6SVdFbEQ4TmZw?=
 =?utf-8?B?NW92TEVJNUR1bGRUZzNGZC9GNXNhREtHdG1NSHNkN1ZqNXN4UXlaNkh4SHVP?=
 =?utf-8?B?TE9MdlhMTFJVL2M1bVlHN1FXWmxpYWpIb3pmeEpnYmVFNXNZWnhDUzNuQzdK?=
 =?utf-8?B?djBZSTAwSFI3eU5MbVJ5QXdSRkVZWFgrcDdWc3lYMEhmVkJZMWQ2VGFaWjgx?=
 =?utf-8?B?czUwanlHeEI3VE9Lak82cENkYURDbTNMcVl4eklxelpPV0lZWWhhdGZzaU8v?=
 =?utf-8?B?NjE1UEVDcXhOc3ZWNktJMW5qRGE3V0E3MFdsZ0ZPWXJ5bkRDQUtXTHl6WlVV?=
 =?utf-8?B?bDFXbUJNcnB3dW1iMitFNGYwWVVXZlNCemNaaVczSWVLVndONlVHZityMU10?=
 =?utf-8?B?WkE0bXVjeUZTeVo1d1lmS2VCd0xCZldCTlh3L1hnWU9Kamk4OFhMWHFwMnlj?=
 =?utf-8?B?QTVuK3B0RFF0Zlk4Smtmam5IUUdCMXpWYzBTc2JVbXdGaGFrOERoV05wODJk?=
 =?utf-8?B?NjAvL0luOWJLMlowNXpKMFAvN0R6Y1FzWUw1a25mczNVcXh6ZDRzaUpZNUJ4?=
 =?utf-8?B?U3JIODFzSDJtSjR5V0MzdFFyQlJnPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A842A5F25BA75B4BA4EBECECD52DF60D@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?Q2ppL3ZyUENGVmp2Vk1pZzFMMzBmQzJ6WHN5TC9NcFNINittNGdVbUFXRmF5?=
 =?utf-8?B?ZnRZeTRlYjJ2MFN4czVZK1k5SXZMVlVwRGZES1FwQXk2bmc0T2lubFdhUG5k?=
 =?utf-8?B?bmVOeHcwT0UzVk9FZEd4OGsrb2Jna3duVEU0QUJ0Unp6Q040djg4TG8zSjhn?=
 =?utf-8?B?d2xNejNsMU5MVElHNVowVTJwQ2U5MVBDSUZkREdYV2ljeU1pay8vSkZOMXV4?=
 =?utf-8?B?YmRpYmtVaEhGVmZ4MkZFMlBpdUF0bG5nWTJ2bjAwaGo0MXVYQktEV0xsMXl0?=
 =?utf-8?B?WWV6TGJNcERrSXZIWGt0WE1sN1BqYjlKdmc3bjZPb1JBalBYNEpBdnprbUVP?=
 =?utf-8?B?RzJISUtwT0JUdi82NDBRbmpVd3NuZE9IZWd1WkRURDBuWlhHb3VTOEg2Ym1a?=
 =?utf-8?B?TzVNOGdTUGJqMWdOcWJHMm5XeUM1RkJYdEhDZkVJY1lPU1VZV0hWWXBtR1M3?=
 =?utf-8?B?cS9nM3htRzh1OUlCaFRIQ1h5RW83RWJZUmFYTVdhQ2JvL2RsTUdCOGx1SU44?=
 =?utf-8?B?KzJDOHN0VXZGWnpxQVVNNmpvRU5iUlNZZUYrR3pyQlAyZk0zWjVqQ3g1ZzVO?=
 =?utf-8?B?a1dnVDVRcTlFemFGRzV1N25vRjk2eWVEOEVITGRkYzVVbksrbnJiN1NtTCt4?=
 =?utf-8?B?RklMb3RPMG1ZVWdvbjJEWkl1cFlVaXRCRGhVMG1rQStzSWdCTHJnZHJsREdR?=
 =?utf-8?B?VTFQOHpzaWhMVGJhSGJKY3Q4VDdCbUV2cjFVTFluRkplQTY5eWxvejVXZFFX?=
 =?utf-8?B?L1g1dW9ranBUZnUrOWN0ejBsZk1acnVHUm42TSsxcUhOSEF4QmRxTVRhbUow?=
 =?utf-8?B?dmV3dklTWjU0ZFlCNUR0Q1ZNNDZyQkdJNlRQbzVta2JwTXVTWEZKeXRGRWlP?=
 =?utf-8?B?UFFIVVJiVm1qWExIVnpScGc3eVVkVnlidTcrSzR5ejZpOWxLTTF6SmpCWWxp?=
 =?utf-8?B?MGxMb3lSVHIrSjVJa1JNYzVOaUduSFpUbit4NitSYTZGTTFjTGdoVnEvUzJx?=
 =?utf-8?B?dXI0Q3ZBd0Z6Q0VHUGFCaklJWDRXdUNCazJKWnpLSVpScGxYTlMvMFVwbEpP?=
 =?utf-8?B?TUlONXVXeUEwYWlGYjZWSHFiQ3ZQNXBiMmRwdUZkQllBYnYxNHVrK2xadEF3?=
 =?utf-8?B?RURQZnkrM3pZKzByWXdORW1PM3BsaGYxZGVTWmZsMVJnMjV1YTFXZEZLQjM2?=
 =?utf-8?B?dC8vVkpCdnpQeVRRSUkreGs2UllCa0J6OEhUbHErWG9DSUFhSkVnOXJyUHhJ?=
 =?utf-8?B?eE10ZWxSK0NkWFhoL3pUM1BiWXFDTnA4cFFIdjQwTEJ5ekJNYWJmY3R4M2Ny?=
 =?utf-8?B?Y2k0T0sxK2VqU3N6eDlOamNLcjRWc2Q4VUdxVWRyQnJXSjNLd0g4bFpERmFs?=
 =?utf-8?B?K0taWWVwK0diMGQvaG5PNERpTzRSU3JDbHhrcXdQeWZJUFlENzlmc1BRbUdq?=
 =?utf-8?B?Z05SNm85T1pFMUNOVjlZMkw4c0crOFl3Ukt4U1hJWi9FaHJ6NHM2VkVpOXJs?=
 =?utf-8?B?d0h0cTZZakV2dW5ITk03dEMrNDV5NngwTGhnaFZoMDJCOHFJbmJSNGRIdDh1?=
 =?utf-8?B?am82aGVSa240cms4aDlmakJVV2NKWTVGcU1ob3NVUnJzSkpucSttNkRDbnVB?=
 =?utf-8?B?T3hqUzJ2ZFBENTFkdmd3MGdoQUZaN0U4ODk5TFd3QlJqYUVxMHhrZkhFZUJp?=
 =?utf-8?B?Z3VYUENOaHZpQ09XdmZEU0Z1Qkdmemk4S3FFUG80TmdOZDVaQ0JtY05oem94?=
 =?utf-8?B?MytWMUc0QnpXNEdiNVNoOWd3bjBxVXdWclhQS3dOSDJnRG1rMVlaVVA3QkJX?=
 =?utf-8?B?RmhrdktvUUhyMTdXQUxwWUwydTBYRTZPRGhGTStnak1LRjJ6c2J1aExzWFk0?=
 =?utf-8?B?R05xaVhsb05aUEd1YndjWjBhY1l3eXROWCtpTFl4SmR4a3pQNCtLVjk5NXZS?=
 =?utf-8?B?UkRvbm5GMGxrTzdUVzZ2c3FGbkpmTkQ5RHhyU24rOUNGQnRBekZJN1M0TnF4?=
 =?utf-8?B?Sk1PcmxrODJRMTJZSUh0OWM1ME9nekVnUEErSTdFek95dDA0Zkx3OVhLVCsy?=
 =?utf-8?B?d0hLSVdvdHhMMFlSckZiTkV5Y2VzWWVWVkVRdz09?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0c2ca88-3e9c-41c8-a13f-08db02ba7eaa
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jan 2023 12:07:01.4871
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: R3rBLgIbEAr2fF0ytva/juT/ZZg7pgFFMyJC08vX4cViSOp6Q2aPTRXbWWWhSdvV9tlv39iNYFdDA35MgSP/UGaosqKMg5BeXOa9q11qflU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB4428
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
