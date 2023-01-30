Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03E50680C87
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 12:55:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236096AbjA3LzN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 06:55:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236669AbjA3LzI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 06:55:08 -0500
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 159FB16AE4;
        Mon, 30 Jan 2023 03:55:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1675079706; x=1706615706;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=7oTxDBV4xF9za/fFtA4gcHTnyZ+ByIJ3SIoxebESMak=;
  b=g4iutzAD9UQaJwB14RG8oXxIs9SoWr32vZRFTmwO5akOP97yNKUKGEH+
   cjVN8SN/kXDYc2dZPFmdUyBSTtfUnbRw8A0wk6DAe0KdRMnCUhaJajpCP
   xk7kw3OI3TA8wfkjmIaIAAIPC++rxcSmfe1lmrTzOn6XLrT6G27aGYyKW
   lfi1UlbPYNjRUIhGH4ZjmGFN1WgyluSxLPTWT/O4OH4uDfm6SNnCNsayl
   YxnB6wQk2qa+ScyKTR24pCDkNEUy4FBv+w4uAsHg+YBAyklZGdKjIHKCA
   NJgUleqXLT3R5DD5GY8qBaNVoiGoahjppXHadtF8DPwTdYy26FhrPaxmj
   A==;
X-IronPort-AV: E=Sophos;i="5.97,257,1669046400"; 
   d="scan'208";a="222131583"
Received: from mail-bn8nam11lp2168.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.168])
  by ob1.hgst.iphmx.com with ESMTP; 30 Jan 2023 19:55:02 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FxrUtFqOJYo5tfZfgLpn4okyvVik/+YgzQcThvjSJGEUuhzY3JbRqjj+5taACjie9U8EXIrvdqbB4UrqbqneJkGcfTNAvUr1LchLtX7rYdxHwdHx2cVKR2Fw4/WWKOfiUS0C+gSb/02wLrkkCsNTT2yACoOMNIGpyt2B1T9/ULFjDHCsFT+45h/sj+eJtSMXpJyXkb9vTvSeBF6DJPOvUCNnBL8pooMZDVra4fgP44oA6V2hKujBYB8ZV0kY1yggt/Gvf0bl3bGV9lVbyFL8SBoI5XxTfKf83JYb6+wdUGcF7p+LGdhqPKhgBvTQtEkQlq+nc/y28U0A720InFp85g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7oTxDBV4xF9za/fFtA4gcHTnyZ+ByIJ3SIoxebESMak=;
 b=KlgITHXmvMPegtcf5a3rTPLVjfC9Ysp/M1nIkjYVKHVS95/eXG/FQasQ5tvcn3It1LVAqfh/qveP49H3yAYo1Ca8ckz70WbN6N+bmu8arjBoQRuM7nHaX+YhqSPvNMuQvd0/pcYfdVtH2A/v3j0Rt1GBHfsmMaBrizhCP2j6NDs8Hv2mQyyEVnPxMUNwh/SM+WCAuDShJwQdRRDxqFQe4hxr5e/Otqt4Ot4CERw/9h7bxTugUEZ0ADmigKoN8Xaw0o63TUh4HzkVSf4udVM3KTR64Ye1btFmrcVpjlDAZNKNtvq/iePCr5Z5TyQ2B4h1zWLPztWYteb3FhTQHeJXsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7oTxDBV4xF9za/fFtA4gcHTnyZ+ByIJ3SIoxebESMak=;
 b=ISXGQ+1Yb+KOVqpSXKCm6MIU6jLltTXFlvSnqOR/fGvekpl7v/Vrs3l+EIEVVyYygZ3wc4S3IO7lkZ+EIFTapadQMGVggBod8+S8RU29vGOtHE8kUaqLTwGsl1c3gVJe3qd44N1k5U7ybXrZhtdbJlg43V+2mh/WOtLAXkLGM0U=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by BN0PR04MB8109.namprd04.prod.outlook.com (2603:10b6:408:15c::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.36; Mon, 30 Jan
 2023 11:54:59 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::8ed8:3450:1525:c60a]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::8ed8:3450:1525:c60a%8]) with mapi id 15.20.6043.036; Mon, 30 Jan 2023
 11:54:58 +0000
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
Subject: Re: [PATCH 02/23] block: add a bvec_set_folio helper
Thread-Topic: [PATCH 02/23] block: add a bvec_set_folio helper
Thread-Index: AQHZNIyyH3PJIjLSOECgloOafBVvG6622j+A
Date:   Mon, 30 Jan 2023 11:54:58 +0000
Message-ID: <f700b195-7a17-631f-3a04-508004f3b285@wdc.com>
References: <20230130092157.1759539-1-hch@lst.de>
 <20230130092157.1759539-3-hch@lst.de>
In-Reply-To: <20230130092157.1759539-3-hch@lst.de>
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
x-ms-office365-filtering-correlation-id: dc68604a-72a8-4ae0-41dd-08db02b8cfda
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ypLasC1IyT/sR1WX3dlHjRO6U/Gj1lljSfap+96ub0mBtKr5ylq7lm2UQvucYnsG4gc9qW4szJZNaRlqBNtfW1OM0YNPTuhEVV8qLVk8NFv6sm+fBBsuB2M9EwsHEp7MCt9CXuSVVHz/5K7CMJurwlhCQutpmFE/7SijypPIZtNLb+V9Hkck+1ah23dfwV/gZwyWl3OkPeUVdJO8wgiyHpGpuBAljktxq+YFQBpo/j6m+BVXGTe2h0Ybqvq6TG+QT3suUy3mZC3cC2orLreiizpVyhjoixOfRDF3Aa28BrKAOAoux/uy7C+Aewz6H4lFV96W4P8o97xoJUyvDE/gl/IFasjkMV6zlaE4xNEJpQ+LLlrPP0ye3Wqai+piVjXnFWrz9ZdR+yWilzb+Fk+FuBGzWh+8zmkS90tGx9qNkQNBP2d1drpWP17SZnGG9N8ANJsbF6yOP9k3w75b1nRQlnlUEcPICq25iWjKuGZNiT2cjppis/Rm1+CACiLusuzF76kw7LiVMqfSW5Pwnsx/VHNP2qW8pJ0YUj6z2zg0vKxqCeN6AmXgpcII/1XOgO4kpeYpAdNm+sCq8KYtVuMME5QtZdonb7JyrpPyZu83jN8vfTX/AUbLAULiG47u8vwqGFBrKLm1dQyZVvrKfbpKgmRO/9aw6Mdn19cDZiEy3NNhUNTpcbpc/jakHqSbYP5OX7oBHuUMKXXX5kKc7rxh/tKrbhaq104jRfNcVtKJGw5JljZaIGfq2soSaq5+nAYQKnO9NQAsLOwx2/ZPHF0fDg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(39860400002)(376002)(346002)(366004)(396003)(451199018)(31686004)(36756003)(110136005)(316002)(54906003)(7406005)(66946007)(64756008)(91956017)(8676002)(4326008)(76116006)(66556008)(66476007)(66446008)(8936002)(41300700001)(5660300002)(82960400001)(38100700002)(122000001)(86362001)(38070700005)(31696002)(71200400001)(186003)(6512007)(53546011)(6506007)(4744005)(7416002)(2906002)(478600001)(6486002)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TEh3TGQvbFNteUJ2amhRbFlib1FpYTBmUU12eU84bzhVNFJHc2FOVHhvVHNU?=
 =?utf-8?B?UFNoSFRkVkNSeHIyT3UyMWE0Y2FpMHVvd0dUNFYrSHd2S2xVYWdWTVV5S083?=
 =?utf-8?B?STJqWlRtbzZmcEVOTUtDTklDMmlkWjNYYjVkamNWNUJhWDhTcXZYdUtweU5r?=
 =?utf-8?B?YjFaZW9EZ2ZtcFVFck9Kd0ExU09odm4zc0kyK3BWazlXWXBFdy92REg2RHlO?=
 =?utf-8?B?MHd4WmNPMnZ0MFpzTUt6bWRZY3JrcFZDUzZFcUxDaHR5VFh1WWFMWWdJelpQ?=
 =?utf-8?B?SE9NcmxpUkppazA2Rjg0dEg2aFJFWGdpUkZHcVVqcGhabElEbUJReEY3Nmcx?=
 =?utf-8?B?SlI3OHUrMG1vZGt5eG85WloxbVJyeWVtVVBTUlJkRWxYTngzUGJ0QXJkQ01r?=
 =?utf-8?B?aDFnWGpFa2YyK29ORmhXcjNmRlUzaENQYmdBS3U2elF0cnR5Z0FlcFYrcWpF?=
 =?utf-8?B?TjlvUENVMjNNQVQyRFAyZktSdlltU281dnlsUWtWYUFiTFVud01ZZWtlU1Nt?=
 =?utf-8?B?YWJ4SWdNTnFvY1p0WDVWSHczZHRpMGVNdU5SZ0RIdlA5TTExVVIrVWRFOGpJ?=
 =?utf-8?B?MHFqdG1wQlhhK29vbXREcnEySzRkWXZ6Y0lqRTVWeHg0OTQ2WXdOUlFtbTZT?=
 =?utf-8?B?N3huVE5YYVl0bkd2c0QyZU02UVVnS1k4bVJRMVlwZlgrZ2lCa1hOZks1dW9D?=
 =?utf-8?B?QyttQThaU05sa1B6K01Yem5UYm9WaHpIdmduV3FzdkNacldFV3I5V0l0R3F6?=
 =?utf-8?B?L2wxdktjZkM0NW1GeHV6YmFxZzhaZXhySG9FT2hYZ1phZDA2QURnREhNSTdn?=
 =?utf-8?B?eEJNcXByL1AzbFlSWXU3NXdvOUpKOTgrK0lFbnpKTXF2bllDdkJlVHdKN2tQ?=
 =?utf-8?B?VEg2TGJMTEJraEdZWmg3K1VPaEhveU1jc3M1ZG9YOHJ1R2Rja2gvbUN6R2Uy?=
 =?utf-8?B?VDJ2TVBPL2Q4Vzc3REpma3pnbHRFMXRCVWdGNEQxRXRVYTZZaS9ESW5ZSFJV?=
 =?utf-8?B?Q1k5aXlpWlNDcithZXNVVi8rSjJhZTdRNEJZN0NHVmpWaU9tcHR1dzBIQU9z?=
 =?utf-8?B?ank3WSs4STNMM3REUDlHR3l0STEwMERHTVJ2T2JPV2xrQVZvU3JTd2ZEWDlX?=
 =?utf-8?B?TlYxTWwzQXZNbVNOejNjS0c3RFFhVXRBQ0VManNsdTIvYk9LS2wzMVFmcDhv?=
 =?utf-8?B?SWd2bVJEaUpTK2IxY0FaMzJoZ0xCQ1ZUS0dNMlJJMUtFQUQwM003L2NKbFRJ?=
 =?utf-8?B?aVNTc25LK1VkVGdyeEdEREZyYnJSVHZEQUpjbGNIdGlzRmVsR3lBZHVRNUVV?=
 =?utf-8?B?L0ZraEVPWVJIRjFRVlhYNmJqdnNmS08xTlN0aEdFWUIzaUhGdHdOVzFua3cz?=
 =?utf-8?B?d0txc3JwUGZrZFhnVi8vQ2c4UndScVVpMUFlZVU2V2x5K3ZTNUpvTjViWVho?=
 =?utf-8?B?K0R0LzRKSkJHZG9CU0hhSkFkWWRyMmt0SWhOY2lWMzdjbHdFa1htQ3JhRGZa?=
 =?utf-8?B?M3Nrakp1UHEvY1hzcVc0ek1NbTRDRWoxanRycTE4OTk4YWtpTm11OURxMTVw?=
 =?utf-8?B?OEs0UTd3MENodlRZaDF4UnIwSnAzYzdQN2xWczZlWDRSM0w5WGlTYmU1elpz?=
 =?utf-8?B?dk1pOG1WaDBVSUZIWWs4MTNNanVmSlRLa3dkVTh2eHpoWDZWSTZWZlppS1lm?=
 =?utf-8?B?NDZyckxrUTdHMjBMcmgrKy9YTURUUjZKVWxyK1JDU3dUZkF1Mkdnb2tkaGhL?=
 =?utf-8?B?NCtDV3piU1N4ZjNZN2VVSjZ1YTVqVFROOU5yV3lRamdCT2k5ZTcxTFNHUUh2?=
 =?utf-8?B?WmVnc1ZkQXd2Z1lUYy9ITUdRS2o2ZC9EMStsUysyVm9UZjdzWlRDYzdTRWlz?=
 =?utf-8?B?S1ROUzBlQ0xxanZpSEF4WTR0QXVkZHlxOEtiYWlDMGNSekh3c1hqVFJHV052?=
 =?utf-8?B?eVJxY3VrOEMwRlhRTVd6MGF4c2NCd2podUlFckRDNTM2clIxYVRheWk4eUdx?=
 =?utf-8?B?YmY4bVlRdG5sK3BVVVkyNk1kRVplRkE5UEpYQi9qZXpLT0kzcDhRMVBOTU9r?=
 =?utf-8?B?dmZwdW5IdVRnUU05VWh2c3k0K0xFeElmZUNOZEF1UUZ4elcwNjQ1d0wyRlBq?=
 =?utf-8?B?VG4ycXkvVVJBRE1DVGM0VHdPdXlqdktkcTM3ZWV0MUd4Q2krcWZVcWl3TG5a?=
 =?utf-8?B?UkUveVRHTUF6V3ZicFI1a0xUVC9UeW1BZW1PNFJobzE3S1hKckhWR25rQ3Bm?=
 =?utf-8?B?STExVXJCazZ1NXVPWjl2OWxBcXJBPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C5E43E89F0C7B449826B3E25C0974314@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?S1czcWNieGEwSFR5bGVrS3FNQ2NPN2t6b1drWGRVeVptSTFobE5vMy8vVWg0?=
 =?utf-8?B?UnY3cmdRcjlEckQyUVlUTUcxSUs4YVduSFhyV2RaZXRUSWF0V2dJZGFMR0pw?=
 =?utf-8?B?ZnZwcFpYcExMZUJUbzdDUDQ5VGpiYmwrZFR2eGVxV1Z6Wmh0aUhyOXpOZ3Rm?=
 =?utf-8?B?enp1eWp3RUZtYkVyQ1hCT0E4VHR0c3NvN09ia2hxdVNEVWsvbUpubGZSU1dW?=
 =?utf-8?B?WlZFQ1lMUnN4clMyOUhPSHVlRkxLT3JjMUpmR0taYitSTHJmRGk0T1JIZ0Vv?=
 =?utf-8?B?ZmNIc3RMQVlDVERyaGZSWmVZSFJ0dTFmenNLemh0bVpVK056RHRON1ZzK0ZI?=
 =?utf-8?B?REhzcWQzUkJMWEMwbk1IRVhZSGN3dmx1NW1jY2UxejM0Ym5sajlHSm9COEJs?=
 =?utf-8?B?OGQ2eXRNV05PaTdvOGYxbENpbzZIU2tqQWQ2MjNxajlRanJJcHNXS1Avb2ph?=
 =?utf-8?B?V2dvTmx3Tk9PVXZMZ3pjUjVuV0h1VnNNOTZHT3RRaXN0MHM4eDZ5aVVpSmcv?=
 =?utf-8?B?ZUw1RFR5SFJ3M0VWSmFhVEtQTlFZRXNOVXZWKys0MmY0UUtpZ2VMaG5kWS95?=
 =?utf-8?B?ZU1LK3ZUVlBmQzRubnpHZDdjYU1odGlwQlAzc2dzLzM2YWFzNlZtRTR4bUpJ?=
 =?utf-8?B?bFgzWHNXZG5mZi9wQ0tka3FKYTJObkVxbTFtbHpqbnNUUkRrMGhyQmFGdGNR?=
 =?utf-8?B?QlB0WUxoSVpsalkwOFRPWlpFS1Z0SmxoakQycFQrNE0zRXhMOXRwdExMaGJx?=
 =?utf-8?B?clNXTTlpU2gvcDdwa2NYMGpJZTV0dFZyMGpOeFlPVTRTWklDd2w5VmZseFFv?=
 =?utf-8?B?WERWQ1E3TDNNZHFhWXlRM1BESmY1dTVrbVlnOUl3WlcwTEE0dHpSTU9HVnNp?=
 =?utf-8?B?bFJLYjgzWndqWjBqaWg5SFlGSE5XMG0wR3YzKzZzMTNMaml2a29WVVE0WkZL?=
 =?utf-8?B?QjR0ek9BMkU1ZFQ0eE9iZEpBUThCUkFMUWRDeCt1cEZBeE4rbzN1ZmxadjZa?=
 =?utf-8?B?NytNbGo0WmxVWUpDTnRDMGlESm1sRzFzUk1idG1HalBwZGUrWjBYYmxBSDRt?=
 =?utf-8?B?V2dxWi9qS3NaSFBMSlVlTzYySXNSQzZKcjFhKzEvc21nUlEreHk0OG1SL1Bz?=
 =?utf-8?B?VkdaRjVVWnAvYzdMSnBLVlNUblVpa3ZDZ2g2YUlTeTZJQmRiY0JZTUJma2Z5?=
 =?utf-8?B?ek9zT2lkTjZQK09NM3Y5Q2ljNllZQmNKeDFFdmdSNVN5Z3V4OHVnZDBnRFRi?=
 =?utf-8?B?aE05bXJtSzB5YWNEd0dMaXFpL3NVdWdSaXZ3cnVUaUlWeFJSVEJzaE56eDZJ?=
 =?utf-8?B?Ykxma0s1Umh0czd5U3ZRbXEwV2hOZWF1enlwYjRRb0ZlMW9YcW9XYTYxOWhq?=
 =?utf-8?B?ZDJEeHNEcE9oalpINHMwR1F4WThFT0dPTFNVbjJiMXd0a0lIU1dkd2xLeTRy?=
 =?utf-8?B?TktxKzhIWXlRUlV5N05VTG9JVExjZFVRUDZGSVhWQkt1V2dvcS9DN1JaSVlH?=
 =?utf-8?B?SWp4MkljOWZmRVBDRzR4U2VJV2hLMkR2UjlTMENQSkd5ZXBNNE5WYlNzSDN3?=
 =?utf-8?B?Mm9KdUR3ZDZNZk0zUXMrY3hqZGhGMjFTVzhFanY1L0FGVHZCWTRaRVRLWk04?=
 =?utf-8?B?N01LL3VlczZkNGZ1bGxvQjFPN0pDRjdZNU9PdDZkOU01QWJ5Sm5kVnhNVnFw?=
 =?utf-8?B?aU9mVE4wUzJiQzk3cTF3MFFvaTBkbUVzVzhzbUgyMmJ0RGllU3ZmUTY0eHUv?=
 =?utf-8?B?Y2UrWUdiY0VMNk9MMEh6ZmwyVXNDOEVRN1ZYVk52VDU3R2I1ekRBSFpvYTM2?=
 =?utf-8?B?K2gxYXlHUXQ5Y3p1azNHeVRjT3ZDNVBGN1FnQTRYUDBKeWxObjA2SG52bFU0?=
 =?utf-8?B?a3ZQZXBibXdmekQwVnZNdzlFczMrcEtHOXpFT1kwcnN2MEh3eUxVZlB5MFFY?=
 =?utf-8?B?ejRBMXhKNFdpOC9lUStRNmVxdy9FQXU3WVlLaHB6MDNCMjBqWmJxemp6ekEv?=
 =?utf-8?B?UDAyL1FWZ201cVRzSFlHdkljaWNUSk43SXE1SklTa0FKVzhZMTFHWFBhRUJi?=
 =?utf-8?B?RlVWK01FaXk2MDRSaFVxUnpyWlV6Q2NvZlRvUT09?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc68604a-72a8-4ae0-41dd-08db02b8cfda
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jan 2023 11:54:58.6857
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dy4P0y4hECEWYSc8pA/+Y7yO2ZYhAxhImHxCGoVLN8C6aZwc2ZSBs5NXvuzuTk8Mh8eoItpykQYuhE5DyV9GAVt17mYkSli4REicddCKFxw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR04MB8109
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMzAuMDEuMjMgMTA6MjQsIENocmlzdG9waCBIZWxsd2lnIHdyb3RlOg0KDQo+ICsvKioNCj4g
KyAqIGJ2ZWNfc2V0X2ZvbGlvIC0gaW5pdGlhbGl6ZSBhIGJ2ZWMgYmFzZWQgb2ZmIGEgc3RydWN0
IGZvbGlvDQo+ICsgKiBAYnY6CQlidmVjIHRvIGluaXRpYWxpemUNCj4gKyAqIEBwYWdlOglmb2xp
byB0aGUgYnZlYyBzaG91bGQgcG9pbnQgdG8NCg0Kcy9wYWdlL2ZvbGlvDQoNCj4gKyAqIEBsZW46
CWxlbmd0aCBvZiB0aGUgYnZlYw0KPiArICogQG9mZnNldDoJb2Zmc2V0IGludG8gdGhlIGZvbGlv
DQo+ICsgKi8NCg0KT3RoZXJ3aXNlLA0KUmV2aWV3ZWQtYnk6IEpvaGFubmVzIFRodW1zaGlybiA8
am9oYW5uZXMudGh1bXNoaXJuQHdkYy5jb20+DQoNCg==
