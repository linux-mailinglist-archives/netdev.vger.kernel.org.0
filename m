Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3962955CC08
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:00:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234402AbiF0LGH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 07:06:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234300AbiF0LGF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 07:06:05 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B32464CE;
        Mon, 27 Jun 2022 04:06:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1656327963; x=1687863963;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ODkG9qhwFtcBDqHTqXkcwy3GHf67GzBIK2XChF8NSAY=;
  b=EWC84qlqBW7j7Ngio8hFBIiuuLXcSZOV57cZRm9GbbE/wSvP33DQZ4bu
   kUXw8wT/0cl/45rzE0nxFQkVHO+aE0TDK+zM19KL/jwqnZ5ekRRa1sVx1
   bw1z12G9twzqryif2/2VMHXueXGzwHsewTExKTsHCpQA+sJXH6KyPNAzW
   HyexEEbQdWHxTWQcPSqVm7WXhF6HtnIYxboWDKsUAKD2xk1iOgAupTdxy
   A+qMN6DRjlYer1y6Z7Oujas562uAjY8cO6MisFYS9jQrm4yL0hEQd+DLR
   sGulFQPSpdL2WiBsJS5YH5ibvnXcaFP0Ew6gUSQ1W/DsXagu2TFCf5UQS
   Q==;
X-IronPort-AV: E=Sophos;i="5.92,226,1650956400"; 
   d="scan'208";a="101875531"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Jun 2022 04:06:02 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 27 Jun 2022 04:06:02 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17 via Frontend Transport; Mon, 27 Jun 2022 04:06:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I5gLiTYcpAM8LxieNa1WAaJp2RSX3GYFXKoFDpf90erelI57M2AOchHn5UBOs3PZ9Aq0U0KMVuD5jKq9nGCi9fkhAmVEBiTZLhDVMeNEmm5izzhcJg0adXdxC/xvnBt3BzhqDvgoncYXYWPaqpXXyhLGjjqg4rNQDiTW8jmoW4sv4o6RxcEG3l9rfPFhfkBL4qGK4/ng1vBtcjmOINWnycvrLchYarWtRrmdQZ4Ju+abTZ2olTboEAS3x1iJvAqWiGECtDRL8Eqv1eP5JT5V2SXbbjPOGTqT22ve3WYPrfkDC5BfbMxsxeXLrYDb08xmj/0vvB7R6lKzhjt7pQXyJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ODkG9qhwFtcBDqHTqXkcwy3GHf67GzBIK2XChF8NSAY=;
 b=L0UxpaqjwATYDkg8YQJxtw4tSgzTiZg9TYbZ+ELwM0j+6HQQNjti2cxT8OBnV611BlLOglXyOv7ywnmn97rJR+FIR1Kbln/p7YCxPro64m7FZPhfbpFC8X/t9/JYSEB7qM3pzAt0pfwWqqEsNpajP44H9HVyKeQWxTfwqYNrun6jf6x994LQtOizzpbtYpd9vqkWu6WFIHjG98CF0O8vTDCH6tzFMpQhr4+Xv8OorhNUeelpWzz+ZBE5nwA+IVFkpNJj7YZO+029Jp52tJ28hAG0CKl8QdSEm6OtXTxcPdTW6my+A5R+1BHvNmMXA6ijxZpfJeS78RbBRuzabqRtMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ODkG9qhwFtcBDqHTqXkcwy3GHf67GzBIK2XChF8NSAY=;
 b=ACyuRQQqR4NIyjT920xPD+APX2vpE9Ck8BYWgDDPkRKsMOKgTgN/LZqSh4B8AcZ0P3h2jQCVEt17pZi94GPRoT/dMXjGjg4J8Wt/Y3VjkUqeAe/9KMoWi9JvLFiKrgikupVEowyuqlYvOlHbPVD3E5zxV6yKPDPinS6Niz0KBgQ=
Received: from CO1PR11MB5154.namprd11.prod.outlook.com (2603:10b6:303:99::15)
 by MN2PR11MB4677.namprd11.prod.outlook.com (2603:10b6:208:24e::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.17; Mon, 27 Jun
 2022 11:05:57 +0000
Received: from CO1PR11MB5154.namprd11.prod.outlook.com
 ([fe80::699b:5c23:de4f:2bfa]) by CO1PR11MB5154.namprd11.prod.outlook.com
 ([fe80::699b:5c23:de4f:2bfa%4]) with mapi id 15.20.5373.018; Mon, 27 Jun 2022
 11:05:57 +0000
From:   <Conor.Dooley@microchip.com>
To:     <mkl@pengutronix.de>, <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-can@vger.kernel.org>, <kernel@pengutronix.de>,
        <robh@kernel.org>
Subject: Re: [PATCH net-next 15/22] dt-bindings: can: mpfs: document the mpfs
 CAN controller
Thread-Topic: [PATCH net-next 15/22] dt-bindings: can: mpfs: document the mpfs
 CAN controller
Thread-Index: AQHYiIwzyz+HU9QtV0CbrfT52GL95q1jGp8A
Date:   Mon, 27 Jun 2022 11:05:57 +0000
Message-ID: <1197ba57-b1f0-69d7-aafd-a6ccb0244b9f@microchip.com>
References: <20220625120335.324697-1-mkl@pengutronix.de>
 <20220625120335.324697-16-mkl@pengutronix.de>
In-Reply-To: <20220625120335.324697-16-mkl@pengutronix.de>
Accept-Language: en-IE, en-US
Content-Language: en-IE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f543ecbb-08b2-4269-b827-08da582d02fa
x-ms-traffictypediagnostic: MN2PR11MB4677:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xZJNiZMHvQOan8teoPEdJ77Y/Y5uPw0FxvA0zr4NPRTrMaI7DlWuJvf6xQbeA553Cp9dbaOp+n2Xnxp4Id+4CA1xJOZJlOEE6CCloIjClKmNn00gRrIzsdFslosYCxIRVe5EwhJWiPeWJQRBaSV30xIZmv2dOyRt9/j3n5s/I9KKgPYJQYlSlNfroYgBmLUEBre6kRsIZjjP8pBqUhGMj2f3fYp/nR0udJkxtpCkih79icEXScA2ssQWi2+jEmGUgiAIUYfoe8sPrVV13NCwu6htjbtJ1o/D1LPbp3w296dPO9SdfWq5oY29GqFPmNqkVjqvNCYU2+xDSXyCGZVxCmvfRAD1zSs7td9y8BIdH5tMZRmK42Zxz0JRMpIZeLoc1eqLVeui7LjsJSAVaSefgqtiqVLv+xdBYJl9O2iPj3HaVYpzrKdZIQa+m1TU5UzV7WfFSfYpzo+AVxqfUFzbgP5b9V2kNnSuc2NT/qk79qJAzm0/AOcI4UdXVmsA/qgaU1tEGN1tjDihhyiHYiXuU7kjK1fLvCX6+9/rT2e4sAMnvWVNiYxFxCnVXl08Y5Jlh3nl84uaU7EWTKZC90Q9D/wpQEGGkA7Lr5Jib3lEH4NiXQ3FMYMa74TXG1padY6+rLoaHks/6qsrhwhcB8B9CEuQDcysTmfY+bN4Jzsh3nk92lF+mQxHJluWO8hzDA7hwpOwpJv41e/bDSUM1nKcmGQkFc0fXogcVU17jJMDOpAQSJRe6wR+8QSUPKxq5eKbDhTGSYaODMolrc98Mgznx9NX/JlCB+lM3GoABP9iEAAgBETeXMhur/yUa4kgqsWI8/+B9PZmU4WVGfWqnEnZgEMfSbupG9D96eeeIQ1RM3hAoEdwdPRClQDa3HYF+mDXDPE5yx0iFNjL5p0NMrGftJgus/S8NFB2R/zEkz1wvw0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5154.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(346002)(376002)(396003)(136003)(39860400002)(6512007)(6506007)(110136005)(38070700005)(31686004)(38100700002)(53546011)(83380400001)(316002)(41300700001)(36756003)(26005)(478600001)(31696002)(54906003)(2906002)(66446008)(8676002)(4326008)(71200400001)(76116006)(64756008)(66476007)(2616005)(6486002)(122000001)(86362001)(8936002)(966005)(91956017)(186003)(66556008)(66946007)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cDdqUXZvUFlsQzllT3VwMFZXUlU3NlcrY2orRlBVbUc1eU1xcGRwb0tRM1pY?=
 =?utf-8?B?WVpqNkV0aFE1WFcxM0VVMTR0cXlaeTljTmd3RjBRdW45YXlUZHhlTjA5eUph?=
 =?utf-8?B?VXhRRlVIdEF6MGxWa3BWbVBXeWdkMHNYL2IrRVlNODdYai9aS0xSNXRad1d3?=
 =?utf-8?B?dVRwV2pkcXpRb2ZZcnVHanJYUjBOUTdqeHp6TWVhWHQ1UE05cFJ5RWhHQm5J?=
 =?utf-8?B?emc0c0dOOXVXQlpTL3VSUFpnd1RXWCs0RUFYSXNDYThOMlVBWFQrS2ZlQkk1?=
 =?utf-8?B?RXkzSXc1elJXWDUwVDU0RVM1VlZlS3RmWWpVV2pmTFF2bTJFR3paaEJOS2RC?=
 =?utf-8?B?UElqcHhNdURNNGVFOUw3WTJtUWFlSXFYc2p1ZVZWbHpjaVF6cCtPUlE4MDZG?=
 =?utf-8?B?YW02YkR1UENza0srRXVSeHFKbklGRnlCTHU0NzVBQXRpN25Ec0dZcTRUM2FL?=
 =?utf-8?B?RGYwVFZaMXY3TVcrTmpSZ0ZKYVFaL0ZPT1hyUUR5Y1BXK1NNZEZzNU5tZFJ3?=
 =?utf-8?B?d3BQZk13ek42SXJVVm1lNlpmaGlKcTNaZzhhNW91MGY0czE0dzlraldKTnRu?=
 =?utf-8?B?RDlRWXZGaFFNN0tXUUkzTXdRZ3dxM3ZUbWNnZTgzUVlVK1YwYXhOZnFnSUtm?=
 =?utf-8?B?cUdyS0hua1VaMHI4UDVTUDNmd1hzQmJSSGZlUkhiRlhibmQ3cDZwYUZUZFhs?=
 =?utf-8?B?cGVyRzJtZ3RFWVlJNkFhQ3ZuUWV3SDk4Tzc1WWdUUDViV3BaU3E2TzdrTmt5?=
 =?utf-8?B?KzFidXoraEJGcWNOMWJuT0JGV2VFL1JhZkZUWmtrWFB3UmRYbHZ6ZS9FYUpE?=
 =?utf-8?B?RWtWUERRa1NsVFdrcXVDWExIdEFmU1lqM2xrbmhIenFTMlJWaVZiS2NoU2I3?=
 =?utf-8?B?MWxWRzlOcDJ4ekxhUmM1VXhNTkwwTUJLbXVtTll1bDlIbGd5L3owcXROT2hv?=
 =?utf-8?B?MC9acVJVVGg5SStNdjN0emVLRE03NW81NWlpUmdvVHJJZmp5YzByamY0RU5Z?=
 =?utf-8?B?V1FDaVNubGliWVZhc2tqT0c3a2dYNzlNYXJ5d2E2dFBGSTIwckNtazg3dkJM?=
 =?utf-8?B?WFNaR1NIdmZ4aVk4ZjBnNGZVTjlMc0RaSkRmSUtSSlVEMkFtRTc5L0xlVHNJ?=
 =?utf-8?B?MTdQWEI3SXhGNWUrekYyK2Z3VmpMZVBsVmRwUjdFdVRza2d2QjVwMk9ONFBx?=
 =?utf-8?B?VjA0cytlVm5OOXQwblF0ZEJSTXpqYVJZWnhBdWVzb2c0bzBFMlhtRVNvUkQw?=
 =?utf-8?B?KzlaTVFwZ1pZbVZGa1BuVThEYUcvdWEzYzdUaytNUWs5WjZBMG5aa0R6YWZl?=
 =?utf-8?B?cVA2eHRQQmN2T3c5WkI1Q3hERzRCVmh0TkJRS0xaeWlNMDJqS0FyODZVK0VG?=
 =?utf-8?B?N2l6RmxhSXlpTE9zUDcxUzVibnIwSGZMYkFUUXR1WFQ2b0VVRTJ5NHZnbjFD?=
 =?utf-8?B?OHprVUVad0d6NVJuaERiUXFSU2ZESDdaMXkvMHBhVU1za05wdUcwaHprcWsy?=
 =?utf-8?B?K0E2K3IyV0dQbnJzVENUVTJSeEV4UHk0MzliRERpelNIazBJS3ZaMWpycEl6?=
 =?utf-8?B?Mk1QdEcxZmpVejV1bnBrVms3U3pUaU0zYjdQblZ4ak00dHdYWk5ZeTVDcGU0?=
 =?utf-8?B?Vkx2VENqNGw2UkRsSWRpTEJTV3JaSWxOWExoZWRkYWt4UVhnclZuVkFuQTQy?=
 =?utf-8?B?VVJQNHZBMmYvTU1WZURrR251d1pPOTFFK1dTcEJaOTJFNWlPVDVjb0FzUVpB?=
 =?utf-8?B?RWNUM2tXZVVCanR5d2Y1bkpTcm5yMEdUZ1hURGV5ZHZDVGxzU29TSE1QelYz?=
 =?utf-8?B?R1pWUXhieG9ZVXNuQjYrY1UweksrcDRrajdQUXp0UWdRRGx2NU9iQUhxb3p6?=
 =?utf-8?B?aHV5NVpFTUl1UUpSQjhreVNSckdhdkpGOFdEeG9HOFhxVjNIYUhGQ3hRakN1?=
 =?utf-8?B?bkhvek9GTld4eEpSaGlpVVRTUndBK3hveVIrMzU0eExjNEloV2NvR1dCSGZp?=
 =?utf-8?B?VXJpdXkzbGpQazBjOERUQkxqTE04Z3lyMk5mOU4vZXpRQnlKaXA0aDRsRE43?=
 =?utf-8?B?YnJzcDdWOTBacHduZDJZZEhQWDB6UEdER1NmM3h0MmVxMS9YSVB0bnNHOGwx?=
 =?utf-8?Q?KlecaZj/lumENAFVF3BknuXFK?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <87E49204C239584F9CD51AF2FA395840@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5154.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f543ecbb-08b2-4269-b827-08da582d02fa
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jun 2022 11:05:57.2792
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yQgYZFi/RmsRRqX1rsGVFSuPjwB5MoxUy9XjYOlUoYVvBYsarJmLnIgPXDt3g/eIYL9i16qTuMBd+h3h+/JY9J7GTL8F8hVdpFYl1rfzNlI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4677
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMjUvMDYvMjAyMiAxMzowMywgTWFyYyBLbGVpbmUtQnVkZGUgd3JvdGU6DQo+IEVYVEVSTkFM
IEVNQUlMOiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1bmxlc3MgeW91
IGtub3cgdGhlIGNvbnRlbnQgaXMgc2FmZQ0KPiANCj4gRnJvbTogQ29ub3IgRG9vbGV5IDxjb25v
ci5kb29sZXlAbWljcm9jaGlwLmNvbT4NCj4gDQo+IEFkZCBhIGJpbmRpbmcgZm9yIHRoZSBDQU4g
Y29udHJvbGxlciBvbiBQb2xhckZpcmUgU29DIChNUEZTKS4NCj4gDQo+IEEgZGF0YSBzaGVldCBh
bmQgYSByZWdpc3RlciBtYXAgY2FuIGJlIGRvd25sb2FkZWQgYXQ6DQo+IA0KPiB8IGh0dHBzOi8v
d3d3Lm1pY3Jvc2VtaS5jb20vZG9jdW1lbnQtcG9ydGFsL2RvY19kb3dubG9hZC8xMjQ1NzI1LXBv
bGFyZmlyZS1zb2MtZnBnYS1tc3MtdGVjaG5pY2FsLXJlZmVyZW5jZS1tYW51YWwNCj4gfCBodHRw
czovL3d3dy5taWNyb3NlbWkuY29tL2RvY3VtZW50LXBvcnRhbC9kb2NfZG93bmxvYWQvMTI0NDU4
MS1wb2xhcmZpcmUtc29jLXJlZ2lzdGVyLW1hcA0KPiANCj4gQW4gYWx0ZXJuYXRpdmUgbG9jYXRp
b24gZm9yIHRoZSByZWdpc3RlciBtYXAgaXM6DQo+IA0KPiB8IGh0dHA6Ly93ZWIuYXJjaGl2ZS5v
cmcvd2ViLzIwMjIwNDAzMDMwMjE0L2h0dHBzOi8vd3d3Lm1pY3Jvc2VtaS5jb20vZG9jdW1lbnQt
cG9ydGFsL2RvY19kb3dubG9hZC8xMjQ0NTgxLXBvbGFyZmlyZS1zb2MtcmVnaXN0ZXItbWFwDQoN
CkZydXN0cmF0aW5nbHksIGl0IGhhcyBub3QgYmVlbiBwb3NzaWJsZSB0byBnZXQgdGhlIG9sZCBV
UkwgdXBkYXRlZC4NClRoZSBuZXcgVVJMIGZvciB0aGUgcmVnaXN0ZXIgbWFwIGlzOg0KaHR0cHM6
Ly93dzEubWljcm9jaGlwLmNvbS9kb3dubG9hZHMvYWVtRG9jdW1lbnRzL2RvY3VtZW50cy9GUEdB
L1Byb2R1Y3REb2N1bWVudHMvU3VwcG9ydGluZ0NvbGxhdGVyYWwvVjFfNF9SZWdpc3Rlcl9NYXAu
emlwDQoNCkFwb2xvZ2llcyBmb3IgdGhlIGluY29udmVuaWVuY2UuLi4NCkNvbm9yLg0KDQo+IA0K
PiBMaW5rOiBodHRwczovL2xvcmUua2VybmVsLm9yZy9hbGwvMjAyMjA2MDcwNjU0NTkuMjAzNTc0
Ni0yLWNvbm9yLmRvb2xleUBtaWNyb2NoaXAuY29tDQo+IFNpZ25lZC1vZmYtYnk6IENvbm9yIERv
b2xleSA8Y29ub3IuZG9vbGV5QG1pY3JvY2hpcC5jb20+DQo+IFJldmlld2VkLWJ5OiBSb2IgSGVy
cmluZyA8cm9iaEBrZXJuZWwub3JnPg0KPiBbbWtsOiBhZGQgbGluayB0byBkYXRhIHNoZWV0IGFu
ZCByZWdpc3RlciBtYXBdDQo+IFNpZ25lZC1vZmYtYnk6IE1hcmMgS2xlaW5lLUJ1ZGRlIDxta2xA
cGVuZ3V0cm9uaXguZGU+DQo+IC0tLQ0KPiAgIC4uLi9iaW5kaW5ncy9uZXQvY2FuL21pY3JvY2hp
cCxtcGZzLWNhbi55YW1sICB8IDQ1ICsrKysrKysrKysrKysrKysrKysNCj4gICAxIGZpbGUgY2hh
bmdlZCwgNDUgaW5zZXJ0aW9ucygrKQ0KPiAgIGNyZWF0ZSBtb2RlIDEwMDY0NCBEb2N1bWVudGF0
aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbmV0L2Nhbi9taWNyb2NoaXAsbXBmcy1jYW4ueWFtbA0K
PiANCj4gZGlmZiAtLWdpdCBhL0RvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQv
Y2FuL21pY3JvY2hpcCxtcGZzLWNhbi55YW1sIGIvRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2Jp
bmRpbmdzL25ldC9jYW4vbWljcm9jaGlwLG1wZnMtY2FuLnlhbWwNCj4gbmV3IGZpbGUgbW9kZSAx
MDA2NDQNCj4gaW5kZXggMDAwMDAwMDAwMDAwLi40NWFhM2RlN2NmMDENCj4gLS0tIC9kZXYvbnVs
bA0KPiArKysgYi9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbmV0L2Nhbi9taWNy
b2NoaXAsbXBmcy1jYW4ueWFtbA0KPiBAQCAtMCwwICsxLDQ1IEBADQo+ICsjIFNQRFgtTGljZW5z
ZS1JZGVudGlmaWVyOiAoR1BMLTIuMC1vbmx5IE9SIEJTRC0yLUNsYXVzZSkNCj4gKyVZQU1MIDEu
Mg0KPiArLS0tDQo+ICskaWQ6IGh0dHA6Ly9kZXZpY2V0cmVlLm9yZy9zY2hlbWFzL25ldC9jYW4v
bWljcm9jaGlwLG1wZnMtY2FuLnlhbWwjDQo+ICskc2NoZW1hOiBodHRwOi8vZGV2aWNldHJlZS5v
cmcvbWV0YS1zY2hlbWFzL2NvcmUueWFtbCMNCj4gKw0KPiArdGl0bGU6DQo+ICsgIE1pY3JvY2hp
cCBQb2xhckZpcmUgU29DIChNUEZTKSBjYW4gY29udHJvbGxlcg0KPiArDQo+ICttYWludGFpbmVy
czoNCj4gKyAgLSBDb25vciBEb29sZXkgPGNvbm9yLmRvb2xleUBtaWNyb2NoaXAuY29tPg0KPiAr
DQo+ICthbGxPZjoNCj4gKyAgLSAkcmVmOiBjYW4tY29udHJvbGxlci55YW1sIw0KPiArDQo+ICtw
cm9wZXJ0aWVzOg0KPiArICBjb21wYXRpYmxlOg0KPiArICAgIGNvbnN0OiBtaWNyb2NoaXAsbXBm
cy1jYW4NCj4gKw0KPiArICByZWc6DQo+ICsgICAgbWF4SXRlbXM6IDENCj4gKw0KPiArICBpbnRl
cnJ1cHRzOg0KPiArICAgIG1heEl0ZW1zOiAxDQo+ICsNCj4gKyAgY2xvY2tzOg0KPiArICAgIG1h
eEl0ZW1zOiAxDQo+ICsNCj4gK3JlcXVpcmVkOg0KPiArICAtIGNvbXBhdGlibGUNCj4gKyAgLSBy
ZWcNCj4gKyAgLSBpbnRlcnJ1cHRzDQo+ICsgIC0gY2xvY2tzDQo+ICsNCj4gK2FkZGl0aW9uYWxQ
cm9wZXJ0aWVzOiBmYWxzZQ0KPiArDQo+ICtleGFtcGxlczoNCj4gKyAgLSB8DQo+ICsgICAgY2Fu
QDIwMTBjMDAwIHsNCj4gKyAgICAgICAgY29tcGF0aWJsZSA9ICJtaWNyb2NoaXAsbXBmcy1jYW4i
Ow0KPiArICAgICAgICByZWcgPSA8MHgyMDEwYzAwMCAweDEwMDA+Ow0KPiArICAgICAgICBjbG9j
a3MgPSA8JmNsa2NmZyAxNz47DQo+ICsgICAgICAgIGludGVycnVwdC1wYXJlbnQgPSA8JnBsaWM+
Ow0KPiArICAgICAgICBpbnRlcnJ1cHRzID0gPDU2PjsNCj4gKyAgICB9Ow0KPiAtLQ0KPiAyLjM1
LjENCj4gDQo+IA0KDQo=
