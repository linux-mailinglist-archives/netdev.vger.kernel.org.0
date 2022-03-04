Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B09264CD52E
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 14:32:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234701AbiCDNct (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 08:32:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237573AbiCDNcp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 08:32:45 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCD9D1A8CB3;
        Fri,  4 Mar 2022 05:31:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1646400716; x=1677936716;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=mZuWpGzxOqgHxVc71Whah+1zYwhk2JhGOekhBQOkdEA=;
  b=rCWPpqZqfBjffHs5HH1ps0qntUymokRbHm4WD7buAqEcbU67wWluHrsE
   HbY1EeUSwpuIJOPGb/sqUvOeFYDQ/xOR3RXSq2+ByGVw0FYQpX6WfTl2v
   hBXTCZgzquiy1xReffP8ux+cpFwXRqCy+PI2rMup4LLBhfLYme4cNotnv
   FzrlGlyDMKNJmzm3WOJyAoK6cg9UPsBGPIuQO2jn7Xdcvwp/iWVBlnyEq
   kBe5BJL1WweMQMbQbMg4PzVWEq+PfFeDv67MOhi+cupMSJ7AwQt5zMeda
   TsG7kLQpTxQc6yUsBPOOKZNlUzHMyWZjFa8+Q5TDLIikz84zpx731BJcA
   g==;
X-IronPort-AV: E=Sophos;i="5.90,155,1643698800"; 
   d="scan'208";a="87833621"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Mar 2022 06:31:55 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 4 Mar 2022 06:31:55 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17 via Frontend Transport; Fri, 4 Mar 2022 06:31:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gGugi43jgyEfLUAMLwPWLPOREc/RajTxziVs0qvJHy44R1llVe43cNfuMvBHEVlnEljVAQxcJGWIwAZ6Z5lfzpwH7a9u3998CN/71ouM/vh6oyuKq9V2NVoYhMA/fdBMP1ttO662ySFYjLVST8mV/7DNk2yJ/LMLm66ywDGn0qKEj2AeiYXsWFayM7P7vgAoIPxvYfh9ljclZ2w/e27GlSK/cTLI2l0WNIoOSG3HuLet7kJMA9F+vZQOcArWD16kf1CERmRXS3rgC1Wvat7dQBz4L3kD5nmhAzsj/NQX1fVdYagt9DYZagdwd624+mvAjwYzkyYHHUPhlajVOul5lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mZuWpGzxOqgHxVc71Whah+1zYwhk2JhGOekhBQOkdEA=;
 b=nrOQSwa48mekMQJDU6zmu7InrfJjD1YuqYdBC1qIMHRmPFSAW2QP+Ynmazh1skWRHpOUkqXdh8DwNg8enP3tEW0UW0Yi5s/22EekFccwxTsvK9ekCXJLsqHgIw43ngtU/WNLgzgUiNQmIIceQYDEBDqU5jF0UR8g5FKmy06gu1Eel0iqDVskoBU1OWSTLMDqt7lCepNqr3R9qKXSpzA7ntXrZEYJ8wXVOGq8wUzd3EX8R8GPXeHQepo+dP0uJvf1thY6EREK42bAZN532fXg4r8JgZkDXCq4I2udXsAGts7OAwQvQHEpxw72Y83mNuMVBYGMUoVvDtjZ5Mwcx5NbrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mZuWpGzxOqgHxVc71Whah+1zYwhk2JhGOekhBQOkdEA=;
 b=Zuqa6zPk2AoRWDgtTLMuc1dZ1ijwnweKov+8i/yjArka5e7Ngfn+UY5vVXeMX7IT0ydOagpoteZyoW40Kco5E7IdRCLuRpjhPvsUgx/5j09xXYEuAvVw5dtwYF1Zk0TyDNo1XfPRqT8T5oLwiLodEUPmVhVhF/fJSLqiEAHQyPg=
Received: from DM5PR11MB0076.namprd11.prod.outlook.com (2603:10b6:4:6b::28) by
 DM5PR11MB1356.namprd11.prod.outlook.com (2603:10b6:3:14::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5038.15; Fri, 4 Mar 2022 13:31:51 +0000
Received: from DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::29b9:feba:d632:55d7]) by DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::29b9:feba:d632:55d7%3]) with mapi id 15.20.5038.014; Fri, 4 Mar 2022
 13:31:50 +0000
From:   <Arun.Ramadoss@microchip.com>
To:     <andrew@lunn.ch>
CC:     <linux@armlinux.org.uk>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <davem@davemloft.net>,
        <hkallweit1@gmail.com>, <UNGLinuxDriver@microchip.com>,
        <kuba@kernel.org>
Subject: Re: [PATCH net-next 6/6] net: phy: added ethtool master-slave
 configuration support
Thread-Topic: [PATCH net-next 6/6] net: phy: added ethtool master-slave
 configuration support
Thread-Index: AQHYL6yerVlTUyMP4UCMdA+m7eSbmKyvM/OAgAAFGQA=
Date:   Fri, 4 Mar 2022 13:31:50 +0000
Message-ID: <69bfebc2a8a5cef56a4b064e32d00fcbd78f54c3.camel@microchip.com>
References: <20220304094401.31375-1-arun.ramadoss@microchip.com>
         <20220304094401.31375-7-arun.ramadoss@microchip.com>
         <YiIQfcKccbjtfPJo@lunn.ch>
In-Reply-To: <YiIQfcKccbjtfPJo@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2eea0b43-0a7d-4c58-309c-08d9fde35703
x-ms-traffictypediagnostic: DM5PR11MB1356:EE_
x-microsoft-antispam-prvs: <DM5PR11MB1356BEB5F496651F8DB4E5D0EF059@DM5PR11MB1356.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZuCcA9EcHMmSx7ah1BpJFLuC2//UdDx+F+pp8aa/DLwwviN8IyuS92SDlB0c3I6BE786ey7ZyoVlZjfWJj2OemW+HpyBshzpD3S5DV1Dw3C1N+yrGdLg1o39gNCkcCZr+TQsgJ8cDhxu8bkVC34/sr/HorTpqJ4w+A4WaUYoQ8FZ1I13e9xwL0GxUpzBvmMsarcPGrS7OKOlFyMYfC1nlqo37TE2WKSPY+OTBfvmfoSnwnc9uOC+/MpeuY9mZqAdd5vTMyBj3fuvwHRTlRSusTxCmGtxr+xHATfqaPXfMYI1odDzrMmRxfMEJvBfQzq1aum+XLOScwSTMv8GJ8stMSMUj28V06c6fj9njAmNSytmKmI6fjS9G0Te2oumBuc1nTR4G9JIu/v3kJMfOmKcpWBxfOouJXLcU5Oh6jQYzY55XtdX5/J15ZeLRlsaEYKbjpIK/0vjBYbRg4ryywvcr4aHBc84J4nAP9lC7WqqqUdhlYK3N7nXcCbT39bBh+l0/RH3DChiH6VEaZ7dYqnYtznNyYzYs9AAfFkowOTu7AmUgbKjtr/xl5jpZMvh2/nLqPDD5g+d/hvNpnmjtAzxo3NaZT93ExwWqOMHhOoYhUE+NVF7OSCCz8i+FY6hLVgxRkV/p4p9iRKHkualsv6D6LyEFmRdW1Ub1aQrIaTlXvCoBQneMw2NtYsoZcOFcxKIPuEnoqgsj2T810YHNwfICLeo8YH1MuV55YU9xScPlJ4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB0076.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(26005)(186003)(122000001)(38100700002)(2906002)(6486002)(36756003)(54906003)(6916009)(6512007)(316002)(508600001)(86362001)(6506007)(55236004)(91956017)(66556008)(66446008)(5660300002)(38070700005)(4326008)(2616005)(66946007)(8676002)(64756008)(66476007)(71200400001)(8936002)(76116006)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?b204VC8ycnY5ZU91OXhjZ1pQS2NoazNpb1UvQ0lHUjRnc29zUVQvbWRNV1BI?=
 =?utf-8?B?Z1M0TUVwWm9oRjhQVG9WTzRWdWoxWk05TTlOdk1XQzFZS3BzeGM4a1krYTIv?=
 =?utf-8?B?akdwNWRLVGxjQy9ldGlBV0hSeVViRzNKWVJ1Zm5EbVJhVXp2YWY4a21aWmZn?=
 =?utf-8?B?Tjl1NkcvNTlFVXJUQmp6THlGdmppSjdHZm8rbXFYVmxtYm5HOGxGcGxuajhL?=
 =?utf-8?B?alEybGRIOG40R01EL0xrUCsvNHJhTlZySmRkTUtuSVROVEFGcnRVMkV4MVFW?=
 =?utf-8?B?U1dVZElVTkFMaUFmQnBVMys5K3p3SWlVYldlaFVWalFwaVVZQWZHNFVUZGxs?=
 =?utf-8?B?NWdSQm9zVnM2QTIwRkVFZ0xLOTJ5T05vMFlZOWw1d0syMDM5NzB0SnlucWZi?=
 =?utf-8?B?NnMxV0RYUnkrVVl1RU5BYWtYWE9oY3RwRU5TS2FPTFlNT1dhYVY1bWIzaXBD?=
 =?utf-8?B?R3NRWFI0dzUxUkhMWVhEcFVzajVQTGtnSkJTMVNZdi81d0NlNHFDL1pkQmZi?=
 =?utf-8?B?S29xdjgrUGtaZnlORGlKeTkvVXhzYzlVcTk0U0NMUVVpSjJXcEpSdjAybE1s?=
 =?utf-8?B?Q09UVE1OSFN4TTZMVnpER1V6d1FuUE81S25PYy9FdGdqbTFiRi8zVlBlajdO?=
 =?utf-8?B?ejRreUhFUWtkL0JHUnRLVk44S0U4Y2gxZWRmd3Y5OGhSM1JuNXA5b1piV0Rl?=
 =?utf-8?B?SnlsVG1rN0xVdDhvZHZDU05JQkhaSkNoWHErTlc3bzlQMmNjaUVwejYyeHZs?=
 =?utf-8?B?TzFJcmJqRjNDSXhaOTNiUklUNWZrdGh5aTNRU2xnSjJ1K2crQTlydHgzMjBB?=
 =?utf-8?B?VzIrdzllbDVvdWlwZG9RQXBuQ2Q2eDExYmJxWFJJK0VOMm92UzBHck1DaE9I?=
 =?utf-8?B?clNVYm00ZTdDb0dSdkNjSXg3QlNKUWVsbkxQYW1FNG5aYzExS3F2aU9iakg5?=
 =?utf-8?B?bUFDUzVDYUplZysxeVRSbUFVZ3RtUVZFZERzYy9WUUhFVnVnYThaa05YSmpq?=
 =?utf-8?B?WnNSa1N0Z01aT3BxS3RTQXR6MHlZZ3BNcWIxYlk5aXQrZlBEZ0FuVUxGSE0w?=
 =?utf-8?B?eUY0aWJ2cXFhUXJLMHBvc2NLZXhPa1BYcTV2QzhEUk5aSUZDRW5ZSDh0OTh4?=
 =?utf-8?B?cXR5ZUEyZ0U3MS9RVmdmcFY3enJTVWQxM3VMNnVWMXNIbjJ1bHVJK3ErVHdO?=
 =?utf-8?B?NkxtUURLR1pFTDFFRk8rNDJWOThaQ0NLZEFhZzZpK3NzNlk4cm9sWkYzUnJG?=
 =?utf-8?B?Uncwa2U5UWF1UzVLVTJjN2YrbEVKUlE0TzFjMWNlNC9vVHlrQzhWWGhCUjdq?=
 =?utf-8?B?MEZ1cEZWaUhISlNwZ3ZTWmlxZmRCa2R2Kzc3MHZYb2d6NXNFeUtibEdiQ1hD?=
 =?utf-8?B?cStLOVlRM0NhdTM0ZXBoN09tcElvRkd5ZHkrbk9xVjNnTUd5MTNiWW95cEds?=
 =?utf-8?B?SGtOV2pSbi9JcWZhTGlBUE9LTGJiTkd0RmZaU0JwOExCd2J0cjlCYWc2emdp?=
 =?utf-8?B?eEJ1bGsySUdjcC82c1M3RWtYVFA0b3RjbmJYRS9VdGlyZEdFZERuakt6QVV4?=
 =?utf-8?B?RWMrNEVSOEVxMHlxQUo5aWJ0Vm1pU05MOGlwNHFoOURZN3Fjc3BqTElvSkNk?=
 =?utf-8?B?dytiNkJieWVTMXM2K2xPbks1NDRhaklQS0J3VkhyVm9SN0U2emlPWFdsZ08v?=
 =?utf-8?B?Q1hCQ0p2eTh5R2Y3SlkvaDRVd2VabDNYQXlkdG9BTko3K3ZHNGNOWGY2YmdD?=
 =?utf-8?B?cjc4WWRQVWo4MlBEdmRnK3YwWk1WZXpNdnRJdzIxM3pTandGYUlQZFVMdEJH?=
 =?utf-8?B?R2pheGZxMTlUa3BCKzBNTGY3VGlFV1BEQVBKWG1jMHYyUHFmNTJLRGtocFNU?=
 =?utf-8?B?bllvbEFvYVhlZS81cG56MjNKblRHM0tLMzdDVHhrU0Ewc2ZBSEpJMTZnVkt2?=
 =?utf-8?B?YUlvdm9VdDRZNUp0UW1mdTZQb0dCNi9nbnB4ZVhxZWNsSEQ5K2lmYVA2ZFNw?=
 =?utf-8?B?VndjM1lHQVhtdzdFVFg4clpMMWRmMnVFNnlZekY0dHNkb2V1RFdQRW1vTEll?=
 =?utf-8?B?M1NjdWU1Q05BaTBDV3RVQTROdjNtNzh0SVR5bWFBWk00M2NocmsxWWkzdDN6?=
 =?utf-8?B?L1RsdHM1cmdFUis5ckRobjVNTThjN1psUzF6dGNORzRrM1IrcHB1Q1I4a2No?=
 =?utf-8?B?cmhsQitBYzhXbVEyeVNKNGpHdEdjS0d0TkFJSWxQNDlaR3MwZm85UDVGd1Y5?=
 =?utf-8?Q?Mcmv2kXvdZg/3fPcH7mDNgpNSnkcQXUVsANcWk1E6o=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9E4A756A6284F34583E65E594C72A366@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB0076.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2eea0b43-0a7d-4c58-309c-08d9fde35703
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Mar 2022 13:31:50.7772
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nxkdY6UFOlPVeVUnfO3Mvzyaf1qE4Dm3zo6GoVLWV1mytlPPiradTz0jBGQm77hYWJ3Dm/ZHpsa8jEcPpIPXn0px7GipLPzfsDK2oNHIVlU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1356
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE,
        T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgQW5kcmV3LA0KDQpPbiBGcmksIDIwMjItMDMtMDQgYXQgMTQ6MTMgKzAxMDAsIEFuZHJldyBM
dW5uIHdyb3RlOg0KPiBFWFRFUk5BTCBFTUFJTDogRG8gbm90IGNsaWNrIGxpbmtzIG9yIG9wZW4g
YXR0YWNobWVudHMgdW5sZXNzIHlvdQ0KPiBrbm93IHRoZSBjb250ZW50IGlzIHNhZmUNCj4gDQo+
ID4gK3N0YXRpYyBpbnQgbGFuODd4eF9yZWFkX21hc3Rlcl9zbGF2ZShzdHJ1Y3QgcGh5X2Rldmlj
ZSAqcGh5ZGV2KQ0KPiA+ICt7DQo+ID4gKyAgICAgaW50IHJjID0gMDsNCj4gPiArDQo+ID4gKyAg
ICAgcGh5ZGV2LT5tYXN0ZXJfc2xhdmVfZ2V0ID0gTUFTVEVSX1NMQVZFX0NGR19VTktOT1dOOw0K
PiA+ICsgICAgIHBoeWRldi0+bWFzdGVyX3NsYXZlX3N0YXRlID0gTUFTVEVSX1NMQVZFX1NUQVRF
X1VOS05PV047DQo+ID4gKw0KPiA+ICsgICAgIHJjID0gcGh5X3JlYWQocGh5ZGV2LCBNSUlfQ1RS
TDEwMDApOw0KPiA+ICsgICAgIGlmIChyYyA8IDApDQo+ID4gKyAgICAgICAgICAgICByZXR1cm4g
cmM7DQo+ID4gKw0KPiA+ICsgICAgIGlmIChyYyAmIENUTDEwMDBfQVNfTUFTVEVSKQ0KPiA+ICsg
ICAgICAgICAgICAgcGh5ZGV2LT5tYXN0ZXJfc2xhdmVfZ2V0ID0NCj4gPiBNQVNURVJfU0xBVkVf
Q0ZHX01BU1RFUl9GT1JDRTsNCj4gPiArICAgICBlbHNlDQo+ID4gKyAgICAgICAgICAgICBwaHlk
ZXYtPm1hc3Rlcl9zbGF2ZV9nZXQgPQ0KPiA+IE1BU1RFUl9TTEFWRV9DRkdfU0xBVkVfRk9SQ0U7
DQo+ID4gKw0KPiA+ICsgICAgIHJjID0gcGh5X3JlYWQocGh5ZGV2LCBNSUlfU1RBVDEwMDApOw0K
PiA+ICsgICAgIGlmIChyYyA8IDApDQo+ID4gKyAgICAgICAgICAgICByZXR1cm4gcmM7DQo+ID4g
Kw0KPiA+ICsgICAgIGlmIChyYyAmIExQQV8xMDAwTVNSRVMpDQo+ID4gKyAgICAgICAgICAgICBw
aHlkZXYtPm1hc3Rlcl9zbGF2ZV9zdGF0ZSA9DQo+ID4gTUFTVEVSX1NMQVZFX1NUQVRFX01BU1RF
UjsNCj4gPiArICAgICBlbHNlDQo+ID4gKyAgICAgICAgICAgICBwaHlkZXYtPm1hc3Rlcl9zbGF2
ZV9zdGF0ZSA9DQo+ID4gTUFTVEVSX1NMQVZFX1NUQVRFX1NMQVZFOw0KPiA+ICsNCj4gPiArICAg
ICByZXR1cm4gcmM7DQo+ID4gK30NCj4gDQo+IEl0IGxvb2tzIGxpa2UgeW91IGNhbiBqdXN0IGNh
bGwgZ2VucGh5X3JlYWRfbWFzdGVyX3NsYXZlKCk/IE9yIGFtIGkNCj4gbWlzc2luZyBzb21lIHN1
YnRsZSBkaWZmZXJlbmNlPw0KDQpUaGFua3MgZm9yIHRoZSBjb21tZW50Lg0KDQpnZW5waHlfcmVh
ZF9tYXN0ZXJfc2xhdmUoKSBhbmQgZ2VucGh5X3NldHVwX21hc3Rlcl9zbGF2ZSgpIGZ1bmN0aW9u
cw0KZmlyc3QgY2hlY2sgZm9yIHdoZXRoZXIgcGh5IGlzIGdpZ2FiaXQgY2FwYWJsZS4gSWYgbm8s
IGl0IHJldHVybnMuDQpMQU44N1hYIGlzIG5vdCBnaWdhYml0IGNhcGFibGUsIHNvIEkgcmVwbGlj
YXRlZCB0aGUgZ2VucGh5IGZ1bmN0aW9uIGFuZA0KcmVtb3ZlZCBvbmx5IHRoZSBnaWdhYml0IGNh
cGFibGUgY2hlY2suIEkgdG9vayBueHAtdGphMTF4eCBjb2RlIGFzDQpyZWZlcmVuY2UsIHdoaWNo
IGhhcyBzaW1pbGFyIGltcGxlbWVudGF0aW9uLg0KDQo+IA0KPiA+ICtzdGF0aWMgaW50IGxhbjg3
eHhfY29uZmlnX2FuZWcoc3RydWN0IHBoeV9kZXZpY2UgKnBoeWRldikNCj4gPiArew0KPiA+ICsg
ICAgIHUxNiBjdGwgPSAwOw0KPiA+ICsgICAgIGludCByYzsNCj4gPiArDQo+ID4gKyAgICAgc3dp
dGNoIChwaHlkZXYtPm1hc3Rlcl9zbGF2ZV9zZXQpIHsNCj4gPiArICAgICBjYXNlIE1BU1RFUl9T
TEFWRV9DRkdfTUFTVEVSX0ZPUkNFOg0KPiA+ICsgICAgICAgICAgICAgY3RsIHw9IENUTDEwMDBf
QVNfTUFTVEVSOw0KPiA+ICsgICAgICAgICAgICAgYnJlYWs7DQo+ID4gKyAgICAgY2FzZSBNQVNU
RVJfU0xBVkVfQ0ZHX1NMQVZFX0ZPUkNFOg0KPiA+ICsgICAgICAgICAgICAgYnJlYWs7DQo+ID4g
KyAgICAgY2FzZSBNQVNURVJfU0xBVkVfQ0ZHX1VOS05PV046DQo+ID4gKyAgICAgY2FzZSBNQVNU
RVJfU0xBVkVfQ0ZHX1VOU1VQUE9SVEVEOg0KPiA+ICsgICAgICAgICAgICAgcmV0dXJuIDA7DQo+
ID4gKyAgICAgZGVmYXVsdDoNCj4gPiArICAgICAgICAgICAgIHBoeWRldl93YXJuKHBoeWRldiwg
IlVuc3VwcG9ydGVkIE1hc3Rlci9TbGF2ZQ0KPiA+IG1vZGVcbiIpOw0KPiA+ICsgICAgICAgICAg
ICAgcmV0dXJuIC1FT1BOT1RTVVBQOw0KPiA+ICsgICAgIH0NCj4gPiArDQo+ID4gKyAgICAgcmMg
PSBwaHlfbW9kaWZ5X2NoYW5nZWQocGh5ZGV2LCBNSUlfQ1RSTDEwMDAsDQo+ID4gQ1RMMTAwMF9B
U19NQVNURVIsIGN0bCk7DQo+ID4gKyAgICAgaWYgKHJjID09IDEpDQo+ID4gKyAgICAgICAgICAg
ICByYyA9IGdlbnBoeV9zb2Z0X3Jlc2V0KHBoeWRldik7DQo+ID4gKw0KPiA+ICsgICAgIHJldHVy
biByYzsNCj4gPiArfQ0KPiANCj4gUGxlYXNlIHVzZSBnZW5waHlfc2V0dXBfbWFzdGVyX3NsYXZl
KCkNCj4gDQo+ICAgICAgICBBbmRyZXcNCg==
