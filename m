Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F973680D3B
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 13:11:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236518AbjA3MLR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 07:11:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236813AbjA3MKt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 07:10:49 -0500
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08EF637F19;
        Mon, 30 Jan 2023 04:09:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1675080581; x=1706616581;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
  b=ZcRx/o+Nedzl8kIT9FdhP1GVEmJ+DWu00iwX5FpYGq9+vPO3P8amrKR1
   4IDA+z+Hc58nr8nLZnopQtmPl6jdscInRHxFh8S5bGKlda2JsjI7UEFQ4
   G0muR0qJU/kOnSFRYNk5Icv7QX1e4XMWFZPo2gs0jrRkZsnhsTYjBO3uF
   m/W8N2U+kkZccG9RllS5fhRK1Yz3ZQ6D+NH03kXidhx81hqAtYgbRJlV3
   6jYGWbF6k0ChystZ4PupxFXX8ykDz/ZHYdl6OPLZLXcN+J6uH18K8ghy1
   whrrfq5z4IKrkVa6KimM3zgmFfQ+Rf9QTguXemF2Qb3U461g64zrHvNCo
   w==;
X-IronPort-AV: E=Sophos;i="5.97,257,1669046400"; 
   d="scan'208";a="334041963"
Received: from mail-mw2nam12lp2042.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.42])
  by ob1.hgst.iphmx.com with ESMTP; 30 Jan 2023 20:09:19 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hQd7OeWmedEDfhxMf6vlCoZaDeHnyVSDEmN/t9Z+bkPXSNvFoQ2nWLRQf4ynfDt8AREP+eVy1TikPH6K1e683R3704rpAiDRIOJlJkj4pE2KbF8lbL0YpxJjcB9i1BSV0eOrdiY/3He1lsgMN5KdShhLDpV7PeC8Va5qiyTHNNuMfXjD8i5ItZDvBsKCUnVBbL97+dd7+9gCWsAd/i5ZZojI0KgKfaG8wBXdgN6DoK4AnqSJu2/UvxTPieSDPDvkYQh2wr9mHhVXZ7Vf5S7Uf72+srZP2oGDyhJ5kadLx6jRfp9fLVGXCGKB4L8bT+j0RnVpRnsjgZZghmij7NWvng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=bwEUUpTr6MRSvFJ6o+hiaDpEnndEGQ1Pas8vGrasUoahK5HuQqQh5BE7/u+mzOkWrtvZgsm3wlKQU8oCbifGh+MPKhafSaUWNSfA5kCxqgNc4rABQ0tRqHSo9haXy9FoWQ1akHPZKLMPGg3zoEjU6ngVdBizbLulNkGw0KLbKmcol++mwDUCnhDcrdev92zZS6RjP77geNgj9Iv0NZcaEZB0VPkqYpAYEWsv+/z58PiGWDgkiTP+HN+ToLGU0jickyrKppmu84bSZgzUkw22HiUCN9hDyPxkRSSH5KZYdUEbxL68lrr4uqWj5JNBamPZ9V+cWMXhWSBVk1nSefkwsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=EVWK/ueKpbjh/BhmGoJNT8tXU/RoFXoXtzhyo28DA2otHImTsZ9LKH294f7rxE5AkeyVrVE4GsVjWNzEDVVkYbETfCpbc+l2NX9dVkH9zy/7AjihWVSMmT+LkVR7qGBfuSJouDonG2MqwEalhTibRT0IGOdfKxAba/abg/CKPVk=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by DM6PR04MB4428.namprd04.prod.outlook.com (2603:10b6:5:9b::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.21; Mon, 30 Jan
 2023 12:09:17 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::8ed8:3450:1525:c60a]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::8ed8:3450:1525:c60a%8]) with mapi id 15.20.6043.036; Mon, 30 Jan 2023
 12:09:17 +0000
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
Subject: Re: [PATCH 07/23] nvme: use bvec_set_virt to initialize special_vec
Thread-Topic: [PATCH 07/23] nvme: use bvec_set_virt to initialize special_vec
Thread-Index: AQHZNIyr44PhMajjgkiKLfNZTQomFK623j8A
Date:   Mon, 30 Jan 2023 12:09:17 +0000
Message-ID: <83252514-fc00-5948-0b3c-9e9daff75c55@wdc.com>
References: <20230130092157.1759539-1-hch@lst.de>
 <20230130092157.1759539-8-hch@lst.de>
In-Reply-To: <20230130092157.1759539-8-hch@lst.de>
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
x-ms-office365-filtering-correlation-id: 6b14c62e-c797-449f-3be7-08db02bacf88
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NrEW0t7OhVJJWDnDay4Yrle6ho02rPDkO+wrAbmJej2yMs3752c25K3M9PSWVg1S1Ndml66kQ1Mh5ul5TcXUnzDut/Lr1v5nf5ifpiNlQAdrKWDpvjvdJ13pDhn2Szbj50pr4QMeqljxr+oTe03PdLisMIGSIG6OPiZHge94Y7SBKmTFQ/ayU/ArkQv3tz+Q4Z9ysusKqogMbo09JuQrERyiYB6YVs3mfw84Hmg7n95RbVG1xehlriWhHrUcIFzC+WwkWn18X3iDGH4dX4OvNdcY5IQ5y4N4P0cJqUqHXI8i/MaZins+8Z/cu9sH4lun/byDmY5yCK+YJ66MP99okf8QXXGXPPLsVdCyMjk+/NIzz64gcFac+pqoHHgPusuix6aVSBjarpYF41UdISKZ+eWLUcSS/ntu0RoroAprT9+VMTBlkMTUmpJDK1HsMOpK6JsWEoGTpHliTj9steMeMiaPUJ7Gq6x87lIT0rscUwIWGIL5p7zLOB+/5m4AyJGkTZlbgHLDCXMnCbdYRwcYfYw633lW8c5C/pPB/Ky9Ihic/Pftviv+sYSw8vhX+9T1KMBH3RxUGUvOo0kSm8HWgeXwtQxZGlhBKOYqAlpD2FmrPn/srG+GlRQw9UtDIit/7HdyX0Y1KCs8ppylGA7QslR31Qd5DPFxhEkDJzW7r2tBF+synSFDlaJSOjSGmXNyGnv4kMWDDGHUf5ejWAj73F/ceD1xMMMa2Dhw61R0xix0bMeBWaMgnSfDyCKgMx9K0INe2xENY+pTIG+R0S4d5Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(376002)(346002)(39860400002)(136003)(396003)(451199018)(31696002)(558084003)(36756003)(71200400001)(8676002)(19618925003)(6506007)(6486002)(82960400001)(41300700001)(478600001)(66446008)(76116006)(66946007)(110136005)(2906002)(66556008)(66476007)(7406005)(4326008)(91956017)(316002)(8936002)(38070700005)(38100700002)(2616005)(6512007)(54906003)(5660300002)(86362001)(7416002)(4270600006)(122000001)(64756008)(186003)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dmowTlVFRXNUQVF4VXpJRmJZYmYrcHNSb1VBMFZNaUUvWWJkWFMyc3RrSWhs?=
 =?utf-8?B?NVlxQ0tvNVFEN3pTejRhclordVdVT1d1eS9FUTdzRmlLRWdrUHpvM21OcG9M?=
 =?utf-8?B?dTVUaTVYMHMrVEFWZmNRbE1PV2VxQm9LbmpYQ3lDaWN4R3RPRmlFVjVDVEtB?=
 =?utf-8?B?bXlKODZkNGhxQXZ0dXFNdmZhK1BieDRaL2ZMZ2t1UTJmYys0ejJTMkFpb1BH?=
 =?utf-8?B?dThaVGcyckpKZGtvUFBna0lUWUo0VzFkUUp1RWVYZythK1RWTENWYS9zb0V3?=
 =?utf-8?B?YWxha05vVERVUlJUVVVDaERQVTBiS2pmenVlbkFvb1lkZ2JVaitiUHkvMXU1?=
 =?utf-8?B?MzVEdlQ1SFp4cURaV29tdFdyVENhUVN6aDNsVEwvdWxPdVNnbFNhLzhySk5J?=
 =?utf-8?B?MjNvcGlERUVEWTdHNHFRVmlVeVpOWDNzUDJTQm5qRFFoOUxpMGpvNUR1QkpE?=
 =?utf-8?B?bGNYQ2g4dXZiWjFQM2tWR0k2dllRZUlyWFdZRjlNKzdTL1Z2KytaYTI2aENz?=
 =?utf-8?B?NWpoMnp4aFNzT2dPaWFjcmtRWDNXaDFwaFZBU2pCcXlXcFdLT1FXQ2krWG1M?=
 =?utf-8?B?YW1KK2VEZE9LV1dPMFZjbVlHTytkQlpsTDVMQ0ZjRXB3aEl1a3lOdUp2K2M5?=
 =?utf-8?B?aldqM01LMHdJU2xnMlBWa0VYZVEwWG9wQTBrMkJNQnlQZkVmNTFWRWlsRVk4?=
 =?utf-8?B?aFRUQjZwWEVGU3Vhck1lNnhwOFBCc3FCMlBMQ0ozVnI5eDA0ZUZtMWs2QUlq?=
 =?utf-8?B?WlZ1VjNoV3VXRVRnc2dCSDh1aWhpMWlvSlNIai9BOVZnVlU3WHo4Y01BWm1t?=
 =?utf-8?B?ZkVWRlhkRGQwWXpJWDV3ZS9ZNGh6Zmprc2thUDFVM0I4SlIxV25LNkRRaUE3?=
 =?utf-8?B?K005eDIxdjRJTmxHRTY3dm81eksxUytSM1hXdG9wQi9vR1p5RFh2Q1lLT0F0?=
 =?utf-8?B?alVhREZWekJzekZET2JJbFBxeHl3VUZvZVFoSXUzVWNuOGNPUUI1TEpCS1ph?=
 =?utf-8?B?L1RIT1BOMDRiWUN2bkpPZW5zaU9YSnNmRlZwdzV6enRhOE5kY3NQMlRLRk9X?=
 =?utf-8?B?SWxpcEQrdnhNK1pneGJkdVp3bEZ3NWhwaGlHUjI4aFNRZEJDVHJGYVkyd3ZL?=
 =?utf-8?B?UU9CS3dIWFZieGdwdWhTdWpTV0MxcXRONVlIdHhTUCtmRngrNUNLTW8rcEFI?=
 =?utf-8?B?endvVEZGRzVmcHM3R1dRRUhSeEVyV2NlTlNTek1xRXk1Ny92MWNjd1h0Snc0?=
 =?utf-8?B?YkhQcHIzQldnNFhDVjB4ZEZTeWhVSFZxOThGZHNkamNNSWw4ZTlKMlVudzhS?=
 =?utf-8?B?N3RuZTV6KzdRMzVWWHd6QTdhUmdNbE1DdEtMSjRZaTVNZ2ZuakR6aFZIR0VM?=
 =?utf-8?B?UkFIRVZMVlhRUzg3UzNPY05Tc09oT2M4Njc1NmpyNkNMTHRmNEtFR2kzVWpX?=
 =?utf-8?B?SjBYNVFJR2pjVS9FejhGcUVBNlgraVYwN09EZnFxZ0V4cnJvSElQVS8ycXV3?=
 =?utf-8?B?bjVaWVEzc3JzQ08ycWdCZEVQUzUvRU1DR2dMa0RleFBvWlE1bGZnMTdYSlk5?=
 =?utf-8?B?dHhFdVhteTUrc2RkTzAzdHMwdGdzNWt6WG5ZT0d2NXBNRXNtS05nY2xLOEpB?=
 =?utf-8?B?cE5TVThrZjhTWC85bEd2eENDQkJSUjYycDh1WUE4dHNOdkUvMnNzM2VoMW1a?=
 =?utf-8?B?V2xYUzZXblBlMGJ3cjgzVUk3SWxvQWtZVzF6T1BhNityT1RWeFljU1Rxbjlk?=
 =?utf-8?B?YnljZDNLWVB4MVpFaVBrNUowN1lWaWpMSUdkVkRETDdqVmpZbk9MRUxoNEpZ?=
 =?utf-8?B?Q3hqazhUTDl0ajZCT2lRWFNzempYSko1RlMrV01HdmFHOW9vL3F6MTEvZldX?=
 =?utf-8?B?OXBoTjZhQVBCcC85ZG4rT0NPQVhyZnZTS3pNUEs0c0l0c0F6V1hoZGRsbWwv?=
 =?utf-8?B?Ynlza1lWaXNNUlcyWFE1MytHRUxPMERjV0V3SlpjcCs1TmIwT0ladjBqc0RT?=
 =?utf-8?B?NUtzYkcxQytEcGFzZUxBNGFQWGNWdlg0UE5sWW5pTndyOE11cUh4dDBRRWVU?=
 =?utf-8?B?UEVCbkhOcUMyUnRBUHpNY3kyVzFZbDJIdHIzUGNjRGE3a3JjQ2hHVksyMDNJ?=
 =?utf-8?B?M0hRUmFTeG1veFdNczg4dlNrNDdCd3AyWFk1SytmU21Fem8zVFRDcTZyOTNY?=
 =?utf-8?B?aVltK3FIZ0R6Qm5KVmx3RHlvR1R2WVV6MjFxUXovbE0wWGRFaFhwaHloc3I4?=
 =?utf-8?B?ZVhhTjVicTJaQjdXR2ZEWmFPOS9BPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <082B9FB59D5EC949BB009F0E9834C4AB@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?c2dtRDBMODVsVHcxSDAzZEx0dVlWcXU2QTdXZVR2NkE5UzBYa1gzc2FLUWFW?=
 =?utf-8?B?RkpsU25kSmpEd0RkYjBWaHMwWHlDczArM3k0Q0p5RnBrT0IybUVheFFFRHYv?=
 =?utf-8?B?a1doTXA4RVNGNnBkQm44WnJhWE5LTE9FNVJxd0tBYktYbWtqeTdKUlB2cXlK?=
 =?utf-8?B?YXgzbndWL3ErNXdzKzV2ZU5lR2tudkVqQ0Rvak55Q3lMMUVvT0tVQm9IbDF2?=
 =?utf-8?B?NnQxKys1aFd3NUdscFZlS1dOWGFHT1FUazUzam9mVVdMS3diTnhhSHpUMEo3?=
 =?utf-8?B?dDdsdGswWXV3OEZYUC9wNmJ1UzBHby9zZmdrMURlWVBzblY5SDdzWGovVFZ5?=
 =?utf-8?B?dnpYMlNRSldQVjlKcFJ3VFNLaVZJRUFNZTltMmtQY2NqUWpwVW1Ib1dVaVYx?=
 =?utf-8?B?OXRuN1ZkNTNhRUlaeEpZNUZXZUtMUjUrTitYampkRWJYWEZTZjFCaUtaUWQw?=
 =?utf-8?B?cWJoZHZOTnE1blF3MnRON2lyN2lsSDY5dFFTdHRLeXc5b0k3Tko0akE3VjNO?=
 =?utf-8?B?cEhaaHkrOEJIWVg1Ym1hYm9vUEMxbTZucWhOUkN0ZkNlRkltZzhSams5Zy91?=
 =?utf-8?B?NG5jNzJrb3lIVWxHdnFucllPb01OWGMvbEZycGJyKy9QQUM0aEx3a0EzTjNk?=
 =?utf-8?B?ZUFmMDd3MDdMSXZHNlRxc1dqb2hzaGVYS2EvVlpRS282TkVVODRUbThQSnFs?=
 =?utf-8?B?NVZZTVNrNVZhenJCS0dwRFAzcnlnYVRXQkJsTHI0RnpYYzBEaFF2QXA1cksr?=
 =?utf-8?B?YmdOU0prcU5FamhlZ21WY2NDQTJCbnNlWExiaEdKbEp3b0t1dUdsMjVJN3I3?=
 =?utf-8?B?K0UxRmlNNzJqVHpzcVg2dU9NbmlEdlcyZTlYVDJPd1hWQjVuRXVHZFRxRWlz?=
 =?utf-8?B?WnFDVlpDNlNvbTkzYm1lZHF1RGswbVBwYWtXTGVqdVhtdEhLVnd5YitDZFBj?=
 =?utf-8?B?WHR2WG10cVJyMDgvUGFVa0hRWWRvNWcyWTZBVUJnU3BDK1Jqd3pSdUVzVHVR?=
 =?utf-8?B?cHY5M1Q2blBLWjk0MVhVa3FURzhsZDFwNWhLY2JaeERRNEJFQnJ1bUl5bHE4?=
 =?utf-8?B?dGpJRHdBK1ZTNGt0dUNsVDRUcWZVc1pnaGl0WmowNytrQzBTNW5MbVg0ald4?=
 =?utf-8?B?VHV0VGFtZXJrWnl5SWJrMUV1eVJDQ2tqQ09FUnhOMWNrM05pNEE4TnNLdWVq?=
 =?utf-8?B?Zmc5aURGSVVQbHdUUXVSelNNc1E4NVBTb2FBd2RHL1ZvdENPRFRLbTJZQ0Nh?=
 =?utf-8?B?eDd0d1RYUGo4MVdINWR3ekd4TklIeUFjOXZ0Y0thdmdrdHBnSXZsSzBGWFM2?=
 =?utf-8?B?MUdQdWk1WnBjQWQ2ZkIzV3ZrUWJnazdaT1MzV0VYckxCUWxuRXJhYmRGekJy?=
 =?utf-8?B?SysrdEx6UkZmdk5DbzhkWGxibCt3WG05Wkxhb2NQa1ZxVXIyOFdQczNWZUpB?=
 =?utf-8?B?b0dtRVhuRG9tLzRHNVFMR3ZaNlFTYUxTbk5paTY0REpRR0VTczd0ZC9scUlG?=
 =?utf-8?B?YmVOdGZ3dGlSSXN3RDVYd2hZK2JvMUQxUXNRR0ZXN0VsVGhxN0dVQ1NhU3BD?=
 =?utf-8?B?eEF6N3RYOU9GMlRXb2VpNzNZdVMyVjRxcDFWSXN0Z3JMckV6aXpPc2VpV0VF?=
 =?utf-8?B?djliN1BIYVUrMFcrL0p1UGRhZVczNUJDMzRicjFya2tiNEYray9QdHRRU1ls?=
 =?utf-8?B?ZXhxK1o1NVFFdmsyVVo0LzJURTVZTU5STHNpak1GelE5d1B3eUdTeHlpK0pE?=
 =?utf-8?B?ZjhIb2JyZkZnOGx5M0JGMW9kOUJINnJSWDRYUDlnWXJRUFJJQzJJRHAyekxn?=
 =?utf-8?B?K1ZjaXVicUpZRHEwcFVjVkRDaGt2L3hoLzlhb091OElkSmtmK2JySmxpRGdL?=
 =?utf-8?B?ckQvc3hlcldTek1UUWdOYmFzcTdDbkR5akpNODJva2RMemd2VEt0MVozS2JB?=
 =?utf-8?B?eGwzUll0bHlSYmVzb1BLeFZwVmcvRVlrY1NvdHZGZ2xnSXcreTJrM2VhZ2pj?=
 =?utf-8?B?NHlycmYzcnRXbXFvQ1ZobjA0TjlXeTA0aHFDRzd0b3p3WjhVKzZmd3lqdklw?=
 =?utf-8?B?aFprM1U1RnJqbUJkUmtwUllGeHJpNGVqSmUxUT09?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b14c62e-c797-449f-3be7-08db02bacf88
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jan 2023 12:09:17.1885
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bKe/7IYhFC6GPbOW8I/0alAOlXBkf5iG6R9yZqGik/cefv8ZUUvo7QhzSN6Su0ErHOkLbn18/FJl379zlMjdPixd17YY8XhiwA4E7h7Z8BQ=
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
