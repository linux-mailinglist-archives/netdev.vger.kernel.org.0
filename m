Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7342963EE7D
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 11:56:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230000AbiLAK4V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 05:56:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbiLAK4T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 05:56:19 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54A575F60;
        Thu,  1 Dec 2022 02:56:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1669892176; x=1701428176;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=tyB/mTg+9elS3Kb1bn2HomILDFfYyPldiD/AcVFQugM=;
  b=mCph0w/cjGoh2gfiSpc5uQZULu44I/UKNLQKwRrdIgC1SnY8Tn7BRwk2
   LhZ9CCDS1bDBvWPEzMcZZCNgtXMUYoviQNKrSlUGTia4wcLvz3SJojzHw
   vKk9kuCot8EChqHrpcK695pbCN66r3ZrWlkpNC56xr+AeW+1fXvVGjMFL
   tPCiAuERAKiIXcbiQ5y+VU6ZSg6ot1I4x+LmITvuTD2IOJVIDg8uvWTY0
   dyqIMUQYy/cALo2TG9E+yI4pYPNYmDEvya6IX4+RxgkGIXg+NAbjg2LKp
   jrDf2jScGucKVKQFou6Ujy2/R1LhJBLPBduGNsRT8gROeIFtg5dUa61wR
   w==;
X-IronPort-AV: E=Sophos;i="5.96,209,1665471600"; 
   d="scan'208";a="191275507"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Dec 2022 03:56:10 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Thu, 1 Dec 2022 03:56:10 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12 via Frontend Transport; Thu, 1 Dec 2022 03:56:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HTBEIyARf4tS7saGhYq8/RxJ+cSgYMZ4JhGAkxC1FYueHsRBQQA4J+TOKuubkMeLhMFXi2wwC+zoO2rq6m4FwnMm072OYb4xLipSATO4HYpJyYhbu30eBkte0K1RcR9namlbcNOkJL27RTvCRtvcVrlXeb4UKSm+XodXeDFkBEmVLQ6ubRW1J96jZfaCTpMf84tzfIt8C1PwRCYXs3LP0AxYukAHhUlQbfzOn//tB4s6G2+Lq3+u7fKRUxuES6G6xjsbNY/OGbn6e8y8AwuBXWypXw5W5lTa7pViykIeG2PG6M+mRjpscDzCrrNnYFd+UHNq55BVb5b1oIs9NEMdww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tyB/mTg+9elS3Kb1bn2HomILDFfYyPldiD/AcVFQugM=;
 b=jlU4DJGMF+uaUqWP1Uo088tTDqbdl70dcrLHzOpzPBEWo6PkmVOoHDL5RCRApMIfW59YzZ+vZlWrino3eqzamwcytdrAyH41E5vjucptyNJ/9aMU+b7o+bSKeywzQb+/hvE+Fonlx/I5mGeiUTzObIs8JhisaAh2Bhb9M84PcZDQUp4YSwxoSmiZ7bmvEfRxLhSC7ifdotNnMSnEA5pRf2axG2dm9OvgrziKyF/dx61FmCB25C5GwrW8vIolJeGM6OEjRY7DPeMjVykrxCft3c1O/FNpNukiSh2TXftB5QOPiyV734aXMlM2OAP1kfFfD8GQqhqS1FkH2Dmq8SZZAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tyB/mTg+9elS3Kb1bn2HomILDFfYyPldiD/AcVFQugM=;
 b=Z3cgWuaT6Ri5X062sx3zRrTNeXmWPdB14A7I+6CUuxrqvZtQd9k0DhveA/qzzhfJ2M5yu+x4pJXfTZBaqyr3CbN48YBgfEsWs0Ye2Lsw73AhN6eq/ikGa3DBXIoVancI6wZjf1VtIZGiKkiRFCjU9Q3Q93RQZZDnu++oKyUDTag=
Received: from DM5PR11MB0076.namprd11.prod.outlook.com (2603:10b6:4:6b::28) by
 SJ0PR11MB5679.namprd11.prod.outlook.com (2603:10b6:a03:303::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.8; Thu, 1 Dec
 2022 10:56:08 +0000
Received: from DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::9b7a:7604:7a30:1953]) by DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::9b7a:7604:7a30:1953%7]) with mapi id 15.20.5857.023; Thu, 1 Dec 2022
 10:56:08 +0000
From:   <Arun.Ramadoss@microchip.com>
To:     <olteanv@gmail.com>
CC:     <andrew@lunn.ch>, <linux-kernel@vger.kernel.org>,
        <UNGLinuxDriver@microchip.com>, <vivien.didelot@gmail.com>,
        <linux@armlinux.org.uk>, <ceggers@arri.de>,
        <Tristram.Ha@microchip.com>, <f.fainelli@gmail.com>,
        <kuba@kernel.org>, <edumazet@google.com>, <pabeni@redhat.com>,
        <richardcochran@gmail.com>, <netdev@vger.kernel.org>,
        <Woojung.Huh@microchip.com>, <davem@davemloft.net>
Subject: Re: [Patch net-next v1 03/12] net: dsa: microchip: ptp: add 4 bytes
 in tail tag when ptp enabled
Thread-Topic: [Patch net-next v1 03/12] net: dsa: microchip: ptp: add 4 bytes
 in tail tag when ptp enabled
Thread-Index: AQHZAxTuXWG2MzXHZ0ycYBiLLrBvaa5YOHIkgACoaIA=
Date:   Thu, 1 Dec 2022 10:56:07 +0000
Message-ID: <0b104470017034eaa970ec37a04e8624be9d0d57.camel@microchip.com>
References: <20221128103227.23171-1-arun.ramadoss@microchip.com>
         <20221128103227.23171-1-arun.ramadoss@microchip.com>
         <20221128103227.23171-4-arun.ramadoss@microchip.com>
         <20221128103227.23171-4-arun.ramadoss@microchip.com>
         <20221201005254.lcwwtscmdu6scnpv@skbuf>
In-Reply-To: <20221201005254.lcwwtscmdu6scnpv@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM5PR11MB0076:EE_|SJ0PR11MB5679:EE_
x-ms-office365-filtering-correlation-id: fa074f64-8d0b-4533-78af-08dad38aa694
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6AOHrTGcJviAW16Gu7+82M0de/SsHxtUD7TW1WcgsreGN+upTHjTtO94H5ogf3uqJXhfNDO2yC9E/e7a4M9GixpbduzC5rLzu160PvVY4JDM5qb0QfSZTLUw2UIjbqEuew9XpY+xBA70WkKPvJ25eeAFkBF30V3+zg0+RwdN8nSzQUE/57CU8N7lXWYdBFTdL3+tMf22wfLRhetTByKXYimAKNUJF5eYQH6Skac+nHLSOIKSkLcOUrBwr7fdLpHt4UR2nTSJ4lgLUE8nnqR5PLf2RcKl+pxMVPGLXQvw5ppeU4HLVYcCrbkpe1zranMW9lrk6bSMiGqIroLlEGeYw0lnz4OMHnvW/mllRun6dUAsMZPK/kk7ZZOBzWJ40bzjRjeUbmxdtb+4OYSaCIrPJZGXcUesN2jCZKJtignOKXhCfx9yNEjrpGCJzGNBMGU2d+JABqM5+Sbnw4JeN+tD/PxRifvXBwnFm4T/nwbFZe65gweHY3g1UQ2bVm4aXVejAb5rpxqyBAQzBVbz0Q4gYp8g+aolIor7TcVo7g9EdhBH3Eksd81o3ja+eET+lWZIJ8GOOdwhE2vDV0fuBjDsFijOU3s+KD0jxdf+8Ma490ILOVfcSrvpQBH5tMNDkAHoiIduWQc0by31WBefmC74qKJynw9j6ECWMOfoHH5jLa9ofO/2HZJ+9rmernIzkzVsSgNPKrtSYyBinv3/BuDE3KtGmicPYmgItRFsWRibreg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB0076.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(346002)(136003)(366004)(396003)(39860400002)(451199015)(71200400001)(91956017)(36756003)(66476007)(66556008)(66946007)(76116006)(8676002)(64756008)(66446008)(4326008)(54906003)(6916009)(316002)(83380400001)(38070700005)(38100700002)(122000001)(6506007)(478600001)(6486002)(2616005)(26005)(186003)(6512007)(86362001)(5660300002)(7416002)(2906002)(8936002)(41300700001)(66899015)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QVVyZ215dmVNSUI2OW52bmdXMlk1bExjdkxhaEJwaW9QUDU5U3cvV25zelRT?=
 =?utf-8?B?aEh6NkF5YmRvOWcwQmRoeFEwTUJudWltKy9zQTI5TkREYXkxY3JwU3NMZERq?=
 =?utf-8?B?eEM2Y3NYS3BzZThzaGJMc09KZVdJeWZWK1pHUkdob0FtQWtSYlhYdjhYMGtR?=
 =?utf-8?B?ME5RdGNvbHdIaHFOWDBMSXJTcHl6eFFSaXVGNFhDNTEySk1NUFBCMkFoaWUz?=
 =?utf-8?B?L3ZhMGZ6NG0vTGJZSHFpbmtqR1dpSjFFa0pLdDYyR2JUY1JnOW1TWXhFMDls?=
 =?utf-8?B?MDRBU0ZzN2dlOFpMMFhwR1N3a3RpcDd4ZUl6VVpxSzVHcUpINWpENUVDUlMv?=
 =?utf-8?B?NnB3RXJBR0xVSWRiYWdjcE9KZmxva0R2QjNkV09qQm9JakJBbjV6WlZ0ZVh3?=
 =?utf-8?B?OUV3czBiVVRIejd3bkFEN1hVeE9HU3FnTTJ0WFdTWHRVazVSckwwZjY2emUr?=
 =?utf-8?B?NDltN0pYZFJNSjdVdmJMTk4xV200MEJLZEZjY2lCNEExRGprYjBzTG4zeTN0?=
 =?utf-8?B?YjMrVXRRdFM3N0xwNE1ZSXkyRnpPemlIVUxnUE0za202VG9JN0FhR1JQTG9s?=
 =?utf-8?B?N2xscHJFMm1YcDlPQ1NHbHQ1NmxPSk9uV2ZCNGc1RlVabGI4aFpjTllqK0RI?=
 =?utf-8?B?WVY1blpEMW5FcTVLSTF1Q0dnMStSVTdmazhrZnBEaWFrUG5BWk92TDAyc2RU?=
 =?utf-8?B?ZlpMOTdqU0lMWVU2QXB6d2d4U3JMekJ6M3dVMFRLR1hvcmJBTnJoeGVlS0VG?=
 =?utf-8?B?S2NuMmJEa0JBRXRicWNURzVWa204NnJZSytXUEQvMHpIYVJOZzhkcmtCSnFp?=
 =?utf-8?B?RDB2ZzZEWS9PVVRudVRjWG9tVTNhRnJtWlN0eW53WjNBeVdWUVJ6ZE8yR09F?=
 =?utf-8?B?Z2IxSXBwcU5iTzdMUGpraExwUVIxTzhONGdlZXZ6ZjZEVFJNVHpaVnRiTW1k?=
 =?utf-8?B?c2VuamN4RDh0Z1ZBK29YSHR5M2xoV2R1NUlUUUxrdmE0bUJOWEo3SU94bUtt?=
 =?utf-8?B?U0hnUjhDZEF3UUxHMldueVRNWDAySXBFLzhCRm9RYm4rN2xMQVU1Z01iRWVB?=
 =?utf-8?B?WWY2MjFoN3lmbCtWNFpzVmwyd3plWEordU00RDdQUVR3UFNFajZyaWlTcGxR?=
 =?utf-8?B?QlpHalVqOUUwazdLckIwbzRCbUlqMDlZMnFHajhSRjQyTmU5WWNFWW1hSFla?=
 =?utf-8?B?Vm45OExIcTdsRkFkMzJHcisvZzBoam5hUE9LRmwwSDdYZnYydW9lRWc4Y1dq?=
 =?utf-8?B?UHJKOVRDdXpOUnVmc2JpS1NDREE2YzlZTGUzdE1LeTkrb29tQlBNM0lvUmtW?=
 =?utf-8?B?U1dvZHhjemZPRkp2R2xpRldTNXV2Q1ZDdWhJQWoyS1F0dFRHY1ZKYmpMaEtv?=
 =?utf-8?B?ZndjNDN4Mjk2ZzIxVlltZEFhMXlWL1FDMTlBeTB1cXowVjhCWm9zU3lUR3py?=
 =?utf-8?B?c2N2ZGJnWFdpVHU3R1UxTjVEeUMxTWtjVUtReTBTNCtTMGxXQnA3RXd4SW43?=
 =?utf-8?B?N3l3OE9oYUwxQWRqQTNpNk8rS0lXdkRDc1B3ZDBIM0NZaCtSYlloU24vcEZN?=
 =?utf-8?B?dGZIZk5UR0JDT1NGeXhON1BiempqcnlFcmNGSWFFZlBSbVhBSHhOdFpBbmdF?=
 =?utf-8?B?cU5CN3JiN3FUd1c3S1prWUVFYTdRZCsxakxqWXJ1NENSa2JJbVdnRUk4QWJx?=
 =?utf-8?B?Q3hBSkZNQUxxdUhEcU43UTYxRHQ5a1Jpbm9NNHFKUWZ1NVEzbWNBNUZaUm45?=
 =?utf-8?B?ZjZsVjFVK0tpWFBQeUpsVGlxRXdOaVJWcU1CdDZ4QWVtWWlISXdadHpLWStw?=
 =?utf-8?B?L0ZoOVZBR2JBbXNrUTN4VWJOM3RhUDh5VC9uZmhiNXJyN1ZNVTc1WTk2ZER2?=
 =?utf-8?B?RjkvS1ZZWFRnQnpzNlk5c3JOQmpXald3ZjkwRFMxWWd0SlYwUEJIeDczenJG?=
 =?utf-8?B?QjZVRzJ2eStJOVQ5ZHoxdFZsQ25YeGZXVjZtWEJQYzRrNmpyMlUwdGdkNjR5?=
 =?utf-8?B?N1ZVTHk2R3Ezay9zL0czK2lVejgycVhaMzRFUXNQS0N5N0RWbzRTT2twUTBt?=
 =?utf-8?B?Q0dJTHVma2w4TVErcVptcjREQmJpMWN4Zk53TGw3QnBBWC93aVRpd1dQY2tV?=
 =?utf-8?B?b3RraVF3VnFhQ2NKVzdNcnl6S1Z1Q04xMXFsYVg5dVB6TmU0UUtKenlVVXNy?=
 =?utf-8?Q?aH7BNE5WMvIIPjA5q4Bwgik=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <03DFEE71811762468E7F7A881C64618D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB0076.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa074f64-8d0b-4533-78af-08dad38aa694
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Dec 2022 10:56:07.9573
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ui4AtH/DNTyguUOPcV3sHXMV5XC1WV+pgJ74lnYxamO4MrBynCVzoi2DMPdrutYcjc/EMZjYtg8u9xhHDAwJKdPoW0FY5flpyMo8tSsWc10=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5679
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgVmxhZGltaXIsDQpPbiBUaHUsIDIwMjItMTItMDEgYXQgMDI6NTIgKzAyMDAsIFZsYWRpbWly
IE9sdGVhbiB3cm90ZToNCj4gRVhURVJOQUwgRU1BSUw6IERvIG5vdCBjbGljayBsaW5rcyBvciBv
cGVuIGF0dGFjaG1lbnRzIHVubGVzcyB5b3UNCj4ga25vdyB0aGUgY29udGVudCBpcyBzYWZlDQo+
IA0KPiBPbiBNb24sIE5vdiAyOCwgMjAyMiBhdCAwNDowMjoxOFBNICswNTMwLCBBcnVuIFJhbWFk
b3NzIHdyb3RlOg0KPiA+IElmIFBUUCBpcyBlbmFibGVkIGluIHRoZSBoYXJkd2FyZSwgdGhlbiA0
IGJ5dGVzIGFyZSBhZGRlZCBpbiB0aGUNCj4gPiB0YWlsDQo+ID4gdGFnLiBXaGVuIFBUUCBpcyBl
bmFibGVkIGFuZCA0IGJ5dGVzIGFyZSBub3QgYWRkZWQgdGhlbiBtZXNzYWdlcw0KPiA+IGFyZQ0K
PiA+IGNvcnJ1cHRlZC4NCj4gDQo+IENvbW1lbnQgaW4gdGhlIGNvZGUgcGxlYXNlLiBBbHNvLCBw
bGVhc2Ugc3BlbGwgaXQgb3V0IGV4cGxpY2l0bHkgdGhhdA0KPiB0aGUgdGFpbCB0YWcgc2l6ZSBj
aGFuZ2VzIGZvciBhbGwgVFggcGFja2V0cywgUFRQIG9yIG5vdCwgaWYgUFRQDQo+IHRpbWVzdGFt
cGluZyBpcyBlbmFibGVkLiBZb3VyIHBocmFzaW5nIGNhbiBiZSB1bmNsZWFyIGFuZCB0aGUgcmVh
ZGVyDQo+IG1heQ0KPiB0aGluayB0aGF0IG9ubHkgUFRQIHBhY2tldHMgcmVxdWlyZSBhIGxhcmdl
ciB0YWlsIHRhZy4NCg0KSSB3aWxsIGVsYWJvcmF0ZSB0aGUgY29tbWl0IGRlc2NyaXB0aW9uLCB3
aHkgdGhlIGFkZGl0aW9uYWwgNCBieXRlcyBhcmUNCnJlcXVpcmVkLg0KDQo+IA0KPiA+IA0KPiA+
IFNpZ25lZC1vZmYtYnk6IEFydW4gUmFtYWRvc3MgPGFydW4ucmFtYWRvc3NAbWljcm9jaGlwLmNv
bT4NCj4gPiAtLS0NCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZHNhL21pY3JvY2hpcC9r
c3pfY29tbW9uLmgNCj4gPiBiL2RyaXZlcnMvbmV0L2RzYS9taWNyb2NoaXAva3N6X2NvbW1vbi5o
DQo+ID4gaW5kZXggY2QyMGYzOWE1NjVmLi40YzViMzVhNzg4M2MgMTAwNjQ0DQo+ID4gLS0tIGEv
ZHJpdmVycy9uZXQvZHNhL21pY3JvY2hpcC9rc3pfY29tbW9uLmgNCj4gPiArKysgYi9kcml2ZXJz
L25ldC9kc2EvbWljcm9jaGlwL2tzel9jb21tb24uaA0KPiA+IEBAIC0xMDUsNyArMTA1LDYgQEAg
c3RydWN0IGtzel9wb3J0IHsNCj4gPiAgICAgICB1OCBudW07DQo+ID4gICNpZiBJU19FTkFCTEVE
KENPTkZJR19ORVRfRFNBX01JQ1JPQ0hJUF9LU1pfUFRQKQ0KPiA+ICAgICAgIHU4IGh3dHNfdHhf
ZW47DQo+ID4gLSAgICAgYm9vbCBod3RzX3J4X2VuOw0KPiA+ICAjZW5kaWYNCj4gPiAgfTsNCj4g
PiANCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZHNhL21pY3JvY2hpcC9rc3pfcHRwLmMN
Cj4gPiBiL2RyaXZlcnMvbmV0L2RzYS9taWNyb2NoaXAva3N6X3B0cC5jDQo+ID4gaW5kZXggYTQx
NDE4YzZhZGY2Li4xODRhYTU3YTg0ODkgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9uZXQvZHNh
L21pY3JvY2hpcC9rc3pfcHRwLmMNCj4gPiArKysgYi9kcml2ZXJzL25ldC9kc2EvbWljcm9jaGlw
L2tzel9wdHAuYw0KPiA+IEBAIC01NCw3ICs2Niw3IEBAIGludCBrc3pfaHd0c3RhbXBfZ2V0KHN0
cnVjdCBkc2Ffc3dpdGNoICpkcywgaW50DQo+ID4gcG9ydCwgc3RydWN0IGlmcmVxICppZnIpDQo+
ID4gDQo+ID4gICAgICAgY29uZmlnLnR4X3R5cGUgPSBkZXYtPnBvcnRzW3BvcnRdLmh3dHNfdHhf
ZW47DQo+ID4gDQo+ID4gLSAgICAgaWYgKGRldi0+cG9ydHNbcG9ydF0uaHd0c19yeF9lbikNCj4g
PiArICAgICBpZiAodGFnZ2VyX2RhdGEtPmh3dHN0YW1wX2dldF9zdGF0ZShkcykpDQo+IA0KPiBM
ZXQncyBiZSBjbGVhciwgaHd0c3RhbXBfZ2V0X3N0YXRlKCkgZGVhbHMgd2l0aCBUWCB0aW1lc3Rh
bXBpbmcsIGFuZA0KPiBjb25maWcucnhfZmlsdGVyIGRlYWxzIHdpdGggUlggdGltZXN0YW1waW5n
LiBEb24ndCBtaXggdGhlIHR3by4NCj4gVXNpbmcgY3VzdG9tIHByb2dyYW1zIGxpa2UgdGVzdHB0
cCwgeW91IGNhbiBlbmFibGUgUlggdGltZXN0YW1waW5nDQo+IGJ1dA0KPiBub3QgVFggdGltZXN0
YW1waW5nLCBvciB0aGUgb3RoZXIgd2F5IGFyb3VuZC4gWW91IGRvbid0IHdhbnQgdGhlDQo+IGRy
aXZlcg0KPiB0byBnZXQgY29uZnVzZWQuDQoNCkluaXRpYWxseSBJIHRob3VnaHQgbGlrZSB1c2lu
ZyBvbmUgdmFyaWFibGUgaW4gdGFnZ2VyX2RhdGEgdG8gY29udHJvbA0KdGhlIHdoZXRoZXIgdG8g
YWRkIDQgYnl0ZXMgaW4gdGFpbCB0YWcgb3Igbm90LiBBbmQgYW5vdGhlciB2YXJpYWJsZSBpbg0K
a3N6X3BvcnQgdG8gY2hlY2sgd2hldGhlciByeCB0aW1lc3RhbXBpbmcgZW5hYmxlZCBvciBub3Qu
IA0KVG8gYXZvaWQgdXNpbmcgdHdvIHZhcmlhYmxlcyB0byB0cmFjayB0aGUgdGltZXN0YW1waW5n
LCBJIHRob3VnaHQNCnJldXNpbmcgdGhlIHRhZ2dlciB2YXJpYWJsZSB0byBjaGVjayByeCB0aW1l
c3RhbXBpbmcgYXMgd2VsbCBhcyBQVFANCmVuYWJsZWQgaW4gaGFyZHdhcmUuDQoNCkkgbmVlZCB0
byBjaGFuZ2UgYWxnb3JpdGhtIHN1Y2ggYSB3YXkgdGhhdCwgDQotIFdoZW4gZWl0aGVyIFR4IHRp
bWVzdGFtcGluZyBvciBSeCB0aW1lc3RhbXBpbmcgZW5hYmxlZCBpbiBhbnkgb25lIG9mDQp0aGUg
cG9ydCwgZW5hYmxlIFBUUCBpbiBoYXJkd2FyZSBhbmQgYWRkIDQgYWRkaXRpb25hbCBieXRlcyBp
biB0YWlsDQp0YWcuDQotIEFkZCBod3RzdGFtcF9jb25maWcgdmFyaWFibGUgaW4ga3N6X3BvcnQs
IHRvIHNldCBhbmQgZ2V0IHRoZSBod3RzdGFtcA0KY29uZmlndXJhdGlvbi4NCg0KPiANCj4gPiAg
ICAgICAgICAgICAgIGNvbmZpZy5yeF9maWx0ZXIgPSBIV1RTVEFNUF9GSUxURVJfQUxMOw0KPiAN
Cj4gQ2FuIHRoZSBzd2l0Y2ggcHJvdmlkZSBSWCB0aW1lc3RhbXBzIGZvciBhbGwga2luZHMgb2Yg
RXRoZXJuZXQNCj4gcGFja2V0cywNCj4gbm90IGp1c3QgUFRQPyBJZiBub3QsIHRoZW4gcmVwb3J0
IGp1c3Qgd2hhdCBpdCBjYW4gdGltZXN0YW1wLg0KDQpPay4gSSB3aWxsIHVwZGF0ZSBpdC4NCg0K
PiANCj4gPiAgICAgICBlbHNlDQo+ID4gICAgICAgICAgICAgICBjb25maWcucnhfZmlsdGVyID0g
SFdUU1RBTVBfRklMVEVSX05PTkU7DQo+ID4gIGludCBrc3pfaHd0c3RhbXBfc2V0KHN0cnVjdCBk
c2Ffc3dpdGNoICpkcywgaW50IHBvcnQsIHN0cnVjdCBpZnJlcQ0KPiA+ICppZnIpDQo+ID4gZGlm
ZiAtLWdpdCBhL25ldC9kc2EvdGFnX2tzei5jIGIvbmV0L2RzYS90YWdfa3N6LmMNCj4gPiBpbmRl
eCAwZjZhZTE0M2FmYzkuLjgyOGFmMzhmMDU5OCAxMDA2NDQNCj4gPiAtLS0gYS9uZXQvZHNhL3Rh
Z19rc3ouYw0KPiA+ICsrKyBiL25ldC9kc2EvdGFnX2tzei5jDQo+ID4gQEAgLTQsNiArNCw3IEBA
DQo+ID4gICAqIENvcHlyaWdodCAoYykgMjAxNyBNaWNyb2NoaXAgVGVjaG5vbG9neQ0KPiA+ICAg
Ki8NCj4gPiANCj4gPiArI2luY2x1ZGUgPGxpbnV4L2RzYS9rc3pfY29tbW9uLmg+DQo+ID4gICNp
bmNsdWRlIDxsaW51eC9ldGhlcmRldmljZS5oPg0KPiA+ICAjaW5jbHVkZSA8bGludXgvbGlzdC5o
Pg0KPiA+ICAjaW5jbHVkZSA8bmV0L2RzYS5oPg0KPiA+IEBAIC0xNiw5ICsxNyw2NiBAQA0KPiA+
ICAjZGVmaW5lIExBTjkzN1hfTkFNRSAibGFuOTM3eCINCj4gPiANCj4gPiAgLyogVHlwaWNhbGx5
IG9ubHkgb25lIGJ5dGUgaXMgdXNlZCBmb3IgdGFpbCB0YWcuICovDQo+ID4gKyNkZWZpbmUgS1Na
X1BUUF9UQUdfTEVOICAgICAgICAgICAgICAgICAgICAgIDQNCj4gPiAgI2RlZmluZSBLU1pfRUdS
RVNTX1RBR19MRU4gICAgICAgICAgIDENCj4gPiAgI2RlZmluZSBLU1pfSU5HUkVTU19UQUdfTEVO
ICAgICAgICAgIDENCj4gPiANCj4gPiArI2RlZmluZSBLU1pfSFdUU19FTiAgMA0KPiA+ICsNCj4g
PiArc3RydWN0IGtzel90YWdnZXJfcHJpdmF0ZSB7DQo+ID4gKyAgICAgc3RydWN0IGtzel90YWdn
ZXJfZGF0YSBkYXRhOyAvKiBNdXN0IGJlIGZpcnN0ICovDQo+ID4gKyAgICAgdW5zaWduZWQgbG9u
ZyBzdGF0ZTsNCj4gPiArfTsNCj4gPiArDQo+ID4gK3N0YXRpYyBzdHJ1Y3Qga3N6X3RhZ2dlcl9w
cml2YXRlICoNCj4gPiAra3N6X3RhZ2dlcl9wcml2YXRlKHN0cnVjdCBkc2Ffc3dpdGNoICpkcykN
Cj4gPiArew0KPiA+ICsgICAgIHJldHVybiBkcy0+dGFnZ2VyX2RhdGE7DQo+ID4gK30NCj4gPiAr
DQo+ID4gK3N0YXRpYyBib29sIGtzel9od3RzdGFtcF9nZXRfc3RhdGUoc3RydWN0IGRzYV9zd2l0
Y2ggKmRzKQ0KPiA+ICt7DQo+ID4gKyAgICAgc3RydWN0IGtzel90YWdnZXJfcHJpdmF0ZSAqcHJp
diA9IGtzel90YWdnZXJfcHJpdmF0ZShkcyk7DQo+ID4gKw0KPiA+ICsgICAgIHJldHVybiB0ZXN0
X2JpdChLU1pfSFdUU19FTiwgJnByaXYtPnN0YXRlKTsNCj4gPiArfQ0KPiANCj4gQXMgZGlzY3Vz
c2VkLCBJIGRvbid0IHJlYWxseSB0aGluayB0aGVyZSBleGlzdHMgYSBjYXNlIGZvcg0KPiBod3Rz
dGFtcF9nZXRfc3RhdGUoKS4NCj4gRG9uJ3QgYWJ1c2UgdGhlIHRhZ2dlci1vd25lZCBzdG9yYWdl
Lg0KPiANCj4gPiArDQo+ID4gK3N0YXRpYyB2b2lkIGtzel9od3RzdGFtcF9zZXRfc3RhdGUoc3Ry
dWN0IGRzYV9zd2l0Y2ggKmRzLCBib29sIG9uKQ0KPiA+ICt7DQo+ID4gKyAgICAgc3RydWN0IGtz
el90YWdnZXJfcHJpdmF0ZSAqcHJpdiA9IGtzel90YWdnZXJfcHJpdmF0ZShkcyk7DQo+ID4gKw0K
PiA+ICsgICAgIGlmIChvbikNCj4gPiArICAgICAgICAgICAgIHNldF9iaXQoS1NaX0hXVFNfRU4s
ICZwcml2LT5zdGF0ZSk7DQo+ID4gKyAgICAgZWxzZQ0KPiA+ICsgICAgICAgICAgICAgY2xlYXJf
Yml0KEtTWl9IV1RTX0VOLCAmcHJpdi0+c3RhdGUpOw0KPiA+ICt9DQo+ID4gKw0KPiA+IA0KPiA+
ICBzdGF0aWMgc3RydWN0IHNrX2J1ZmYgKmtzel9jb21tb25fcmN2KHN0cnVjdCBza19idWZmICpz
a2IsDQo+ID4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgc3RydWN0IG5ldF9k
ZXZpY2UgKmRldiwNCj4gPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB1bnNp
Z25lZCBpbnQgcG9ydCwgdW5zaWduZWQgaW50DQo+ID4gbGVuKQ0KPiA+IEBAIC05MSwxMCArMTQ5
LDExIEBAIERTQV9UQUdfRFJJVkVSKGtzejg3OTVfbmV0ZGV2X29wcyk7DQo+ID4gIE1PRFVMRV9B
TElBU19EU0FfVEFHX0RSSVZFUihEU0FfVEFHX1BST1RPX0tTWjg3OTUsIEtTWjg3OTVfTkFNRSk7
DQo+ID4gDQo+ID4gIC8qDQo+ID4gLSAqIEZvciBJbmdyZXNzIChIb3N0IC0+IEtTWjk0NzcpLCAy
IGJ5dGVzIGFyZSBhZGRlZCBiZWZvcmUgRkNTLg0KPiA+ICsgKiBGb3IgSW5ncmVzcyAoSG9zdCAt
PiBLU1o5NDc3KSwgMi82IGJ5dGVzIGFyZSBhZGRlZCBiZWZvcmUgRkNTLg0KPiA+ICAgKiAtLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
DQo+ID4gLS0tLS0tLS0tLS0tLS0NCj4gPiAtICoNCj4gPiBEQSg2Ynl0ZXMpfFNBKDZieXRlcyl8
Li4uLnxEYXRhKG5ieXRlcyl8dGFnMCgxYnl0ZSl8dGFnMSgxYnl0ZSl8RkNTDQo+ID4gKDRieXRl
cykNCj4gPiArICoNCj4gPiBEQSg2Ynl0ZXMpfFNBKDZieXRlcyl8Li4uLnxEYXRhKG5ieXRlcyl8
dHMoNGJ5dGVzKXx0YWcwKDFieXRlKXx0YWcxDQo+ID4gKDFieXRlKXxGQ1MoNGJ5dGVzKQ0KPiA+
ICAgKiAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tDQo+ID4gLS0tLS0tLS0tLS0tLS0NCj4gPiArICogdHMgICA6IHRpbWUgc3RhbXAg
KFByZXNlbnQgb25seSBpZiBQVFAgaXMgZW5hYmxlZCBpbiB0aGUNCj4gPiBIYXJkd2FyZSkNCj4g
PiAgICogdGFnMCA6IFByaW9yaXRpemF0aW9uIChub3QgdXNlZCBub3cpDQo+ID4gICAqIHRhZzEg
OiBlYWNoIGJpdCByZXByZXNlbnRzIHBvcnQgKGVnLCAweDAxPXBvcnQxLCAweDAyPXBvcnQyLA0K
PiA+IDB4MTA9cG9ydDUpDQo+ID4gICAqDQo+ID4gQEAgLTExMyw2ICsxNzIsMTkgQEANCj4gPiBN
T0RVTEVfQUxJQVNfRFNBX1RBR19EUklWRVIoRFNBX1RBR19QUk9UT19LU1o4Nzk1LCBLU1o4Nzk1
X05BTUUpOw0KPiA+ICAjZGVmaW5lIEtTWjk0NzdfVEFJTF9UQUdfT1ZFUlJJREUgICAgQklUKDkp
DQo+ID4gICNkZWZpbmUgS1NaOTQ3N19UQUlMX1RBR19MT09LVVAgICAgICAgICAgICAgIEJJVCgx
MCkNCj4gPiANCj4gPiArLyogVGltZSBzdGFtcCB0YWcgaXMgb25seSBpbnNlcnRlZCBpZiBQVFAg
aXMgZW5hYmxlZCBpbiBoYXJkd2FyZS4NCj4gPiAqLw0KPiANCj4gU3Ryb25nZXIuIFRpbWUgc3Rh
bXAgdGFnICpuZWVkcyogdG8gYmUgaW5zZXJ0ZWQgaWYgUFRQIGlzIGVuYWJsZWQgaW4NCj4gaGFy
ZHdhcmUuDQo+IFJlZ2FyZGxlc3Mgb2Ygd2hldGhlciB0aGlzIGlzIGEgUFRQIGZyYW1lIG9yIG5v
dC4NCg0KT2suIEkgd2lsbCB1cGRhdGUgaXQuDQoNCj4gDQo+IEkgdGhpbmsgeW91IGRvbid0IHRo
aW5rIHRoaXMgaXMgY29uZnVzaW5nLiBCdXQgaXQgaXMgY29uZnVzaW5nLg0KPiAyIHllYXJzIGZy
b20gbm93LCB3aGVuIHRoaXMgcGF0Y2ggZ2V0cyBzdWJtaXR0ZWQgYWdhaW4gZm9yIGJlaW5nDQo+
IG1lcmdlZCwNCj4gSSBkb24ndCB3YW50IHRvIGFzayB0aGUgc2FtZSBxdWVzdGlvbnMgYWdhaW4u
DQo+IA0KPiA+ICtzdGF0aWMgdm9pZCBrc3pfeG1pdF90aW1lc3RhbXAoc3RydWN0IGRzYV9wb3J0
ICpkcCwgc3RydWN0IHNrX2J1ZmYNCj4gPiAqc2tiKQ0KPiA+ICt7DQo+ID4gKyAgICAgc3RydWN0
IGtzel90YWdnZXJfcHJpdmF0ZSAqcHJpdjsNCj4gPiArDQo+ID4gKyAgICAgcHJpdiA9IGtzel90
YWdnZXJfcHJpdmF0ZShkcC0+ZHMpOw0KPiA+ICsNCj4gPiArICAgICBpZiAoIXRlc3RfYml0KEtT
Wl9IV1RTX0VOLCAmcHJpdi0+c3RhdGUpKQ0KPiA+ICsgICAgICAgICAgICAgcmV0dXJuOw0KPiA+
ICsNCj4gPiArICAgICBwdXRfdW5hbGlnbmVkX2JlMzIoMCwgc2tiX3B1dChza2IsIEtTWl9QVFBf
VEFHX0xFTikpOw0KPiA+ICt9DQo=
