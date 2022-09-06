Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9347B5AE61E
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 13:01:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239634AbiIFLBK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 07:01:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233778AbiIFLBI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 07:01:08 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F386AD118
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 04:01:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1662462066; x=1693998066;
  h=from:to:subject:date:message-id:content-id:
   content-transfer-encoding:mime-version;
  bh=Fed6hPCaDvJvhcsLn+4F7y/10pyPfezb7chxBOvu51c=;
  b=YDIXdj1IqGtJZuTuJGK2EfSE82LI71+D4mtnkTpz73avWux3zC68ESYy
   4kPWRwaa7dltRywVxeQISBA/9ZM0dE/uxdret7cS30LIDMF5VHgRzin3Y
   t/gFoYTRGGnCV7aRYSiNKm07pfXhfybq/HUPLBDrUYIfWd978MVnko892
   s1eymCZltNyCm7PqJ8JW7EnpYnWbfosjBFUyb3l1v4aM7dJwk4NMVNNue
   0xUxpA3L1TAhpqpLXN/YO3FMA2M++euu0LLekicv7XBrB64sCjlYk/qJH
   1mvHUErn05XbgKNtQSEA7i/RjldAWBSjuckkLPli8HIS8mmVZaWi3CxVk
   g==;
X-IronPort-AV: E=Sophos;i="5.93,294,1654585200"; 
   d="scan'208";a="179316649"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Sep 2022 04:01:06 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 6 Sep 2022 04:01:06 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.12 via Frontend
 Transport; Tue, 6 Sep 2022 04:01:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=avPeAAi/LNEyMuJ6h7paDvutFr4NVA7LCRVcwjiUK8JvnpPsF7bU4Bk9OysNBrkQvscFBKpwPaU1Pd6D8IMS+xp2BZpN0r1Nsd/tSHuHYc29VQ7CWh/ShLIQiCEuQ5sMaQ5FP0VE9j/ltNCHhU7vKq8+Boz2YeuHe/PeVU2sQy8BkDlM7Gq1P/12jQu9Ki+TdpgpMM3Log3E8xY0bCkFyOB2Qow8LLdeo8Bcb/TFQk41G3pLUzgO9sdEVIuYz9gtBIDBrZhTuKDYGO7qIQ3Z3MPOQY46hYpGpq7XcVUKTWCWV/AhhRdRL0vn8LQBlppULlpefGEhaoDQzt/wUuSmSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fed6hPCaDvJvhcsLn+4F7y/10pyPfezb7chxBOvu51c=;
 b=RBljKq1jcDTg6W9sPEJG6GB+r2Y80l35ow24pkxYZfTCy4m7PayYypf1sZkICdA4v1kTf54faMIZQdBFizj8nY3nIOzZQg2YfmB3NhrJP/p7nX7KfRi+71sZf65E/YsNnFEwQvrerH1lpJf4dufXtFdfyV6Zrqj3ubKd5L06Fm1yVl4Jup2qRx4eZX7+WKjDxODlDkHxNSgxBwqKHiqk5oYWO1Cg8H5VQnSKJbHfDoIPieJmgpoa6nyP1osRDSSbxjTt9OlOefRKfZPNLQ7Ao+JcZ8fmtVO0uDfwJBT2nTeUE5MJBt0isO2vKwn/dPiVTl2Oi1Xh24YlH3ccAwVIjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fed6hPCaDvJvhcsLn+4F7y/10pyPfezb7chxBOvu51c=;
 b=I8/o52ZgsclGih/McisJbRbAh744wejxo8u3960AnmQadC+CO/dGfUH2AaKVZ1+F+Wb0wa+tv4c9mtMMaf9qIrsxtMrr2T22FoeiA/LP3PW3dX4EbxxZemJSR9S4bB1w6MQbZapUfn84Gih6ZJtSX3nkuy+YOaYwuptTOdZxQrQ=
Received: from DM5PR11MB0076.namprd11.prod.outlook.com (2603:10b6:4:6b::28) by
 CY4PR11MB1446.namprd11.prod.outlook.com (2603:10b6:910:a::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5588.16; Tue, 6 Sep 2022 11:01:04 +0000
Received: from DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::3c5c:46c3:186b:d714]) by DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::3c5c:46c3:186b:d714%3]) with mapi id 15.20.5588.015; Tue, 6 Sep 2022
 11:01:04 +0000
From:   <Arun.Ramadoss@microchip.com>
To:     <netdev@vger.kernel.org>
Subject: Testing set_ageing_time in net: dsa
Thread-Topic: Testing set_ageing_time in net: dsa
Thread-Index: AQHYwd/1I/zNzKEfN0iedThtBy5WuA==
Date:   Tue, 6 Sep 2022 11:01:04 +0000
Message-ID: <335b537bb55064a508cafdcfcadecb03c806a867.camel@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b860655e-343e-42b4-2c7e-08da8ff71793
x-ms-traffictypediagnostic: CY4PR11MB1446:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EfmHWV78myCrA1wtutQUwBK4Gx+p03fYZf1p3b0g6+Yicx+ccccxrczvv0KUq1xFtEeLdaAEP7+AL2dDxjfqJ0k8M/xKG72fF7cWP9cSqVB4sbEmAOoEaRC251anCNDBdVkJdIcZZfOIZnzUwHsd04YYtIDishz/to9S0fDNEVn8N5Y5WuBy7eIT7OnzIpK97ni8Agi5W/Y6yGI2W4LqfpXN9nVeoBZ0+GUal8hZKbcdoa2nHE+ck2moVPQ88sjAou2zqgtX+wT9zS1caWMm4N1qRyrKFVnikwWuId1E9P4AloGYqAwHFXJcQ8bs8Di/+KOnzR4XKii4i90IbC2mxdQzabAkAT63Epf6kWSM+JYQ+mrlSpUz+aurAnUSP9qwmR/KYWsECYoHmo0QQLHx203F2ll4yNHuGUVT3YHMyaHbFCfxsKR4l3ZUUAAGiexO8ENjkF4c3xjsmAlbXLz7g11jE4BD+75vBK3u8PdwRLWJ0KUQzoYnh2Z5RjWZUKMzTwp7iHwm0tnTsUnBPki680G0utAvz5ywUNTrHtW8LR/Mq1w28l3qe2DvP0wbs5f8VXcCJ0k+FTz4ZOPmKWqyoxRLUDh714kHQFEg9YuLmEhOfrYxU2li628ShvqhBh8+AQc5kl/oUyg+x7iamRUXB45sC2zWLMdtgsxJLt5Ag+CR3Je4Bb2nykrZaH1+ZZW/c3f6ySkoB+XMKVb/G56H+w2yFvmcjLGoaPPX6dV9k4jlehG2H/lx6HLL/8SNSVuc+9VQn4aCtzUXA8AS/9+qX3mG8Zn8QJo5aDQpWdiQwTY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB0076.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(39860400002)(376002)(346002)(136003)(366004)(5660300002)(41300700001)(86362001)(6506007)(2906002)(26005)(478600001)(6512007)(8936002)(38100700002)(71200400001)(122000001)(4744005)(38070700005)(6916009)(2616005)(186003)(91956017)(8676002)(36756003)(66946007)(64756008)(6486002)(76116006)(66556008)(316002)(66446008)(66476007)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZDhDYU5Rdzc0ZzFTMlExYUpyd1FuT1Q4ay9EdzlMdUd1eUNERHN3bWhSOXlN?=
 =?utf-8?B?aU0vWmZGcEJ2L0tWaVZYaE0wdjN5TTFkTXlaejM3dWczSURJb21mY0Y4WTMy?=
 =?utf-8?B?N0J5N1NCcG1TeU5IQmJzd0NqU01LUkVEdnpjc2dEWHlHTFgveEloc29jTEFo?=
 =?utf-8?B?bXhNUzR6K21LcHJ2bmZjamxsQnR5Z3l4ZFAxS1N3bFVRUkNlUUh1SzdJbFdu?=
 =?utf-8?B?Ui9ZRHdvSytDOWFmWWJWUXJxMDJ2bjBpU1BFL0R4ZlN6RHNQZ0VjSkhwc0pl?=
 =?utf-8?B?ZmtGSERXc2hic0NYNUJSWDFhOC8yNjhLL0tsdmhHNWlRT2FZVFZjZWZtRG1m?=
 =?utf-8?B?eDZRQUJQSDJNamVFZVRoWnhXNlVVdkMyVy9aZStFcUpoUlBSdTFubnU3T0tW?=
 =?utf-8?B?VmlRcTBtdjBPUE5rVjZTczN3RlFEcmlvNHpvUlpjSWFZSnB1cVNXdHZlUjVa?=
 =?utf-8?B?dU9CVVNyOVVNeTU0M0RPUFM2U0tBS21kR2x2ZGdYOGs0eHl5SnYwaFN2eVdw?=
 =?utf-8?B?djFYZjFHcU9uYUJ3d2JWNmR0VTMwQUJoL0xJcktxUmg3bzNBbDR4b3lOa0sr?=
 =?utf-8?B?OTZVS2xWbDVvS2dVbng5UmpPM2lnWFdKcTFtVG9xL2lEWkNyQWtrWVBDUzNK?=
 =?utf-8?B?ckJFcHBRQ2p2VlBTOXlSZzlUb0ZUVzhSTGFEb3ZLMXVkdjJTSjNJaEsvaGZC?=
 =?utf-8?B?T0tSS2k5Y2lndVgvcEZJMGZPWFdzclZnMWhyOXlIYm5raEFuVHBONE80TWk4?=
 =?utf-8?B?d0tleGQ1Vmd2TllkNTlaUzYzd0dSTGNWemNsZGZHZnRBdkRFcGZXN3BhZVhW?=
 =?utf-8?B?ZG8vTDBoVTkzMzk3TWVQQWs1Z1JyKzJZMm5OUEczaFoxcmJWaDJkU1NBWUww?=
 =?utf-8?B?Umx0QUxtQVpFS0FNQWo4T29KM1pTaXBPV2x0aVloUWhWUFArV0ZtYTJsck5Z?=
 =?utf-8?B?bFJRMnFiUy9vZzN4OWIxRW1hUTl2VkRTWWdMT2xwRmd6QmNubWV2cm1YT0dG?=
 =?utf-8?B?RjhHb1BTNVFtS0JnNGRSTnJuOE1SZk1GSEUzVkNHR3FWZFFualY5YWxqak1I?=
 =?utf-8?B?UFdQbDVDcjQwQW1TR1E3d25hMzNFZWhhTEhNK01DaUtQTllIeWFVN0dEd1V2?=
 =?utf-8?B?QS9oc2VNdHErUUxKOWUvTVFzdkI0QkV2RGV3QS9vdVh4S0ZMODVIQStIMGM0?=
 =?utf-8?B?VFZXWGUyWThtcXlEV01MQ25EOVdDNi85aFJpZUh2L2ZIeU9GbTE3WlhsOEw5?=
 =?utf-8?B?eTZ5MFlKdlA1VTloY09RalZyeDQxMG0rc20zT0Jyejl3Nm1NUHV0eDROMnpE?=
 =?utf-8?B?Zjk5TzRJMWhkVmY1R1prQjV6TUtzMFBVNHZ2WUFHT3VGd0ptdkNnMjdERHpJ?=
 =?utf-8?B?WXlod2wzRGQzTk1uWTZWdzE1NDVmZzhXclJPem4xNXNESllQVWZnOEZMbjVO?=
 =?utf-8?B?Wks4ME5hSVZaYzExWWxTbmU2RmhNNGJ4eGNTUGpHRkNneXBFNDFHVmdDTW1B?=
 =?utf-8?B?Rnl0N0dsWXBsbS92ZnViTGZuRyt1b002UlZrVEpld3VFcUliNjRjckF3U0ZJ?=
 =?utf-8?B?SlVtRTMrOUliWUNqbG1iN1FWYW9sNGtmVXZmejF5b3pDMUxMVks2K0JhL1N1?=
 =?utf-8?B?TEIyVTIvUWF2dmlJelZFZlRqVkFYQXpWN0RzWjJyTkpUUjBBZlk3WXVMR0FQ?=
 =?utf-8?B?c3RLRmtHbDdsa2twdkt2T3haNFZlS0xBODR6bnMvdThUVVlzTUZLUEIwbGVY?=
 =?utf-8?B?cHJOUmFzZWJSejdHS3lYVUJSakxWUms2NVlzZmYvYU5Ld0FPU1BndmFQMHM1?=
 =?utf-8?B?WU9abEJ4VmcxUUdBd3ZRTms1TzhlWWhxaWRwSSszaVJ5dnlEOTFNMTVkYnVO?=
 =?utf-8?B?eEJzck14a1Nab2tQRDJVYzBGQVN3N2VuSXIwTjFIR09NZGZDTkpnRUcvd0Ew?=
 =?utf-8?B?cERSbUFqcU9wWFpzUTFhQjJDR1lKWk1wVzFIcUFVdkt6Rmh2VWZSME82U0lH?=
 =?utf-8?B?c0FybmhxM056Z3MyRGJzeGlZN2lxM0xsWHlRR2gxaFgzZDBXbFROQUFuYnVj?=
 =?utf-8?B?WmtFOGY3bDluZDFFYjBESHhNS3YxWFl5bmk2dXdpY1lpUjB6OWM5Y1lKUTdt?=
 =?utf-8?B?NUI5a3h0NVdrSmN1N0N0OEU3TUFQbVFWcU9UQnZhZjVMaVdvd2FSekwzeGRP?=
 =?utf-8?Q?rJkEcGEM+TCIeUUccvurNBk=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B8CB7421586AF44C93B2E49B66EB829D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB0076.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b860655e-343e-42b4-2c7e-08da8ff71793
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Sep 2022 11:01:04.1249
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Hl+3+IqQOTpNK+mPGv8jObi8DgK5PklGEFtndpDQhz4eZbUuQot4dqZ23+Eq1zKBg3lmQ2B9u96/zYNi9vNnERAwFnkHSWxoAU299QB9wbI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR11MB1446
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGksDQpJIGFtIGltcGxlbWVudGluZyB0aGUgc2V0X2FnZWluZ190aW1lIGhvb2sgZm9yIHRoZSBs
YW45Mzd4IGFuZCBrc3o5NDc3DQpzd2l0Y2hlcy4gRHVyaW5nIHRlc3RpbmcgdGhlIGZ1bmN0aW9u
YWxpdHkgdXNpbmcgdGhlIHVzZXIgc3BhY2UNCmNvbW1hbmRzLCBmb3VuZCBzb21lIGRpZmZlcmVu
Y2VzLiBJIGFtIHRyeWluZyB0byBzZXQgdGhlIGFnZWluZyB0aW1lIHRvDQoxMCBzZWNvbmRzLg0K
MS4gYnJjdGwgc2V0YWdlaW5nIGJyMCAxMCAtIEl0IGlzIHdvcmtpbmcgYXMgZXhwZWN0ZWQuIG1z
ZWNzIHBhcmFtZXRlcg0KaW4gdGhlIGFnZWluZyB0aW1lIGlzIHJlY2VpdmVkIGFzIDEwMDAgKDEw
ICogMTAwMCkuDQoyLiBpcCBsaW5rIHNldCBkZXYgYnIwIHR5cGUgYnJpZGdlIGFnZWluZ190aW1l
IDEwDQoJLSBJdCBzZXRzIHRoZSBhZ2VpbmcgdGltZSBhcyAwLiBXaGVuIEkgZGVidWdnZWQgYW5k
IHByaW50ZWQgdGhlDQp2YWx1ZSBpbiBsYW45Mzd4X3NldF9hZ2VpbmdfdGltZSwgd2hlcmUgSSBn
ZXQgdGhlIG1zZWNzIHBhcmFtZXRlciBhcw0KMTAwIGluc3RlYWQgb2YgMTAwMDAuIFRoZSB2YWx1
ZSBpcyBvbmx5IG11bHRpcGxlcyBvZiAxMCBpbnN0ZWFkIG9mIDEwMDANCmR1cmluZyBzZWMgdG8g
bXNlY3MgY29udmVyc2F0aW9uLg0KDQpJcyB0aGVyZSBhbnkgZGlmZmVyZW5jZSBpbiB0aGUgdXNl
ciBzcGFjZSBjb21tYW5kIGltcGxlbWVudGF0aW9uDQpiZXR3ZWVuIGJyY3RsIGFuZCBpcD8uIEFu
ZCB3aGljaCBjb21tYW5kIG5lZWRzIHRvIGJlIHVzZWQgZm9yIHRlc3RpbmcuDQpJIGJhc2NpYWxs
eSBpbXBsZW1lbnRpbmcgaXQsIGlzIHRvIHRlc3QgdGhlIGtzZWxmdGVzdCBmb3INCmJyaWRnZV92
bGFuX2F3YXJlLnNoIGluIGtzZWxmdGVzdC9uZXQvZm9yd2FyZGluZyB3aGVyZSB0aGUgbGVhcm5p
bmcNCnRlc3QgY2FzZXMgYXJlIGZhaWxpbmcuIEFueSBoZWxwIGlzIG11Y2ggYXBwcmVjaWF0ZWQu
DQoNClRoYW5rcw0KQXJ1biANCg==
