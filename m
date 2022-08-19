Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E011599733
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 10:35:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347717AbiHSIUC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 04:20:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347625AbiHSITm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 04:19:42 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34C81E86A1;
        Fri, 19 Aug 2022 01:19:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1660897154; x=1692433154;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ynxHJ8ohDNbT8DP2UxRK7Zg9rr6mjtIfPQ1xHJEPxpY=;
  b=cGqCkqFy/lu7YLhjwb+ERIaouN5++6jYJsVSqLQNExl9iJjBnA2/JpXD
   Po3RBCBKSiJBSGo3gZf8urlHZ14cCTnLngfKHmldjDjRvUENCSJiSxgnq
   dIurcNUM4bSKED+ruLHIozshEaJy8II2SxWipUXbvAgoxoxDGAdIYTdG+
   18RLBmdVTDQVHgpxAbO9lNe4C2arSqbKZ4dVvPVBN6/H21Dc8dR/HaTIr
   HK0g0QQfrgMCsgOoAPYm9fAdWLRLeH7i7Q44pyIcc5SbZWyWXAFT2/18p
   vvnl+HWcft00Lwac5awYWQGqdExK+MWCXdpn5Z37z/agef3tUcQumYkRh
   A==;
X-IronPort-AV: E=Sophos;i="5.93,247,1654585200"; 
   d="scan'208";a="109759283"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 19 Aug 2022 01:19:13 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Fri, 19 Aug 2022 01:19:13 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12 via Frontend Transport; Fri, 19 Aug 2022 01:19:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hBma0rPVsE7FhA6zuxfFMU/aJeOf0KsPUNXzln1MhUyJyi44NfESiAS+1VIFuBjl2zfTFcxGe2qBOTe/xb3pY1SlkNQsM8RLASpoVG6MyjwB3tQE3uTU9RLMQykAGUcKxr+ljKfkrZ+4CGnFUYrpQncLrvQNgo0Q0UiPBQVJvip/SdJ+lyMbJ66HIF16j28wRNCnMGt76+6/jVq6XlyClm7lHtVYMiP5ZP8U8hZLnAmAclHu7T68I91+Fs/zU0jhgh7F0t3h7NXnlCDvnqmBVk5P1CsfXJKniEuwPAer1B0qyj7//+qLhYzMnxY5tg8Nbkig4tHdHXGwNKPx2y+LOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ynxHJ8ohDNbT8DP2UxRK7Zg9rr6mjtIfPQ1xHJEPxpY=;
 b=heOFViqSCFCdiMIOtbW77mvejgaOBXCX6zt5zJvHxcCIgvxNhAmma8UGIv3ipDBkD8jCFXNmPnMsPrGGlayyO3EyRREN/2TbTWoYt2HEu01M2mRQU7q0omUxhI1Jk89mZgusWpHF83RTCp00dNp6AvmIfQzRRtcqjW+FQTNJoO/OltJ8P3HcBmtU8o8tz4IM0uLXdEteO/wcVCfhoSiRkVGbzY+sCrSkSSFwAJxNLhHAmiR2YqGGdYy7Y7gBGYudg8IUgnzRIvnZ8g30w0wH27aNqQLbEHmTlgzZeyPxrV8k/WsiW2ZVVx7YG6X3JLO8b933Vp86JWlNgeImW7AtIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ynxHJ8ohDNbT8DP2UxRK7Zg9rr6mjtIfPQ1xHJEPxpY=;
 b=rkNDTifv/Qowky3xKcRC/PpxlMEhcwA6gOj1nXhOlBK87Z+UWt8+ZmaMv7hDRaLFtgf69MjCKvd+Vpf4gbVNgVCnJ58eUq24YfHxxQX+dcyokmlCl//RaZ/jY/KtE7JBZbMdksg7YkuiMqQSoHLrWj1rkX1YEfyCD8mE/E1B/J0=
Received: from BN6PR11MB1953.namprd11.prod.outlook.com (2603:10b6:404:105::14)
 by DM5PR11MB1706.namprd11.prod.outlook.com (2603:10b6:3:b::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5546.18; Fri, 19 Aug 2022 08:19:11 +0000
Received: from BN6PR11MB1953.namprd11.prod.outlook.com
 ([fe80::7c6d:be4a:3377:7c4a]) by BN6PR11MB1953.namprd11.prod.outlook.com
 ([fe80::7c6d:be4a:3377:7c4a%5]) with mapi id 15.20.5525.011; Fri, 19 Aug 2022
 08:19:11 +0000
From:   <Claudiu.Beznea@microchip.com>
To:     <harini.katakam@amd.com>, <Nicolas.Ferre@microchip.com>,
        <davem@davemloft.net>, <richardcochran@gmail.com>,
        <andrei.pistirica@microchip.com>, <kuba@kernel.org>,
        <edumazet@google.com>, <pabeni@redhat.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <michal.simek@xilinx.com>, <harinikatakamlinux@gmail.com>,
        <harini.katakam@xilinx.com>, <michal.simek@amd.com>,
        <radhey.shyam.pandey@amd.com>
Subject: Re: [RESEND PATCH 1/2] net: macb: Enable PTP unicast
Thread-Topic: [RESEND PATCH 1/2] net: macb: Enable PTP unicast
Thread-Index: AQHYs6RcvNDn7p/lGEWNNw8o7+Cxuw==
Date:   Fri, 19 Aug 2022 08:19:11 +0000
Message-ID: <ef4bbe5b-fcf7-3ca1-8c51-5402299131f5@microchip.com>
References: <20220816115500.353-1-harini.katakam@amd.com>
 <20220816115500.353-2-harini.katakam@amd.com>
In-Reply-To: <20220816115500.353-2-harini.katakam@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2312c021-94ce-4f7e-f3d3-08da81bb7f25
x-ms-traffictypediagnostic: DM5PR11MB1706:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: y65NGXvMGHOPn6KRK/i3Qnabuf/qRaSzWLqMFH/xru2is0akJUS1IwXwVnPwb+VkhOHWXsXNsLEElQ9i1PrQUedy2+WocemsIrlVKEEPJEla/xVCIx577jeNZkX2CJwjsDFMTb8p/+ZnJxq6VbCEgV54m+xRk/w1DnCgAMoCoXO90vn8kzz/KVRpXKLs91avqo23uW/ru+1T5IhItarHwHVhFhGvTDnrhvKPdEt7FDs27jIiHmUJcunMfqQJhP+IzkRXFwZ4BMG9XNxwI4QThPwqgOhrm1y+dDMi2+E5ePKdy5Aora3w9DoDtLLDtWgREk8wKgPPyOVMX99UXL4zORcF1aGsAWa2zV9u7ldEtRElgY5d5YMCoBAX0tyUgJnHh9MC7NYvaVFMB/qsMdEDyj1HKU6FffkCgfqmSn0FXtzCWMNJQzq8qDQe5xJhn7ySX6ExCTn89EN9dRK8wNBs6+Gwbe24qxs3xebq9sXiIAEWfTl4XrDJ+oIIOUl+hobgUl48aQodFtew+t90x9aVD4+5LsPavYZZSnT7iyBki/NdoNqvUbjO9haeLcu4y2h6p+SRIts53K95MzyxP3pwv6IowGpkoPoTZ6irS1IAF7tOjOFZYY4aqI2WAVg5h0OW62DRsEqeHAU0yupzXvIw+cVstXGGGscSPOgMZJu8qGqWsEixNKzbYag/qE88uyMKsNgEy5eJHuM4Uo23wYzRU0b3ZoOmkDTeofN3rZCQ/hlwzNLG/EFh55PC5uVbtwVSSJ53gpML2O4CBW9DzVEVNPDqFGGb62HO+d0nAGu275/V1tegI9YyK8pUQgrtdjg3ovgG2EoyU5XeIRo4wCEOPA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR11MB1953.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(376002)(346002)(136003)(39860400002)(366004)(83380400001)(38070700005)(122000001)(38100700002)(316002)(478600001)(6486002)(7416002)(41300700001)(54906003)(8936002)(110136005)(5660300002)(2616005)(71200400001)(186003)(2906002)(6506007)(53546011)(6512007)(26005)(8676002)(76116006)(4326008)(66446008)(31686004)(66476007)(66556008)(86362001)(31696002)(66946007)(91956017)(64756008)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TWtJTWFDYlB0N25iV0Z6VjZ2UHBIRG1XL1kvUlM5VVhFSDdQb0hPOTIrRzB2?=
 =?utf-8?B?MGx2WFl3RzlLMUdZZ3oyZHZCaFpFTUhrbVRUVGcxUy9SM0Q1VkRDRlpaWVZs?=
 =?utf-8?B?NUlFd1llSVN3QjJVaVZEMU9LVE5sNDlWNVdaZCtwMlhmNTU4TW56QVJVNnB1?=
 =?utf-8?B?QjNreFhuTUdWL3ZucUdHT2dMcDFqLzVkYjJMeXY5ZHBzNzB4Ymd5aWFvM3Y4?=
 =?utf-8?B?ekg4VEcwcmI1c1ZqZm9yVVh5b1czYkdybkp3bVdjSEgxWDVBYVdvZ01uWWVv?=
 =?utf-8?B?M0RJR0ZnbFdPNExZWWJkaFVlVWMwSGVIRE9WNHhBMy9SUWhpWDZMd0h4ZWlI?=
 =?utf-8?B?WlVrTXpHYytaN1dHVkN1dksxQ1E2VldseTRaUXpmdlV1TVBMTDBLa21lWnpC?=
 =?utf-8?B?QkZDQTZxOGhXRzBydjllem8xb2hTN2E2bkhWMUZMTkFmUHBwWWoxaFZzVmhB?=
 =?utf-8?B?R0pwMG93c2lhOCtGRExkdlBZTURIOEFuKzhJMng5SHZITHhRZlY0OXF5c01N?=
 =?utf-8?B?aWVNRklWU2xmNTlLTWxQK3J6OTZISjNvK2ZyQUtNZWx5eS9MMzErbGR0NEVz?=
 =?utf-8?B?d0t2S0M1WS9xaUg2K0JxZnh0YkxoNHVEMG5NRlRhQXJkZGwxZmFGaGdUd1Ny?=
 =?utf-8?B?em9oRjhJcmc4S0pnZUJ4cmNERHVQcWk3UXowVXJYekpPbE9RTHBOeWVYWklI?=
 =?utf-8?B?L2N1ekJQbFdkOE1jSXd5by9iUVpFelFrZFNjNW04TGJyWlNtMnU1UTRLYzli?=
 =?utf-8?B?WTVZaTVCRzVkMVhEKzhpc3lqQW9FcXZCOWxjR0swSjlkR3pYVnZmaStsd0l4?=
 =?utf-8?B?YUdndU9NMUxsWkE3eXdEKzdEMFhkQUVqWjBWOEhyWEREYkhWdzRidTVCV0Zn?=
 =?utf-8?B?MW53Q1RDVTdISDdNWUdLQnN1ZTE3WHVSQlpxVEs3cnNVa29uRlcreWkvNk54?=
 =?utf-8?B?NTIranZOcnBoL0R2cFQ1WnRGbmh1eTJFVVZmYWVsMXV6dHF0cjRrdXlHT1B4?=
 =?utf-8?B?d0M3dWpaUTF4dG0yTXpXV1VNR0c4bTIwZElUUmdKNzFJNVpGbm9tWTdBK1pW?=
 =?utf-8?B?ZVhvWWVadVF6Uk5hOStJWGt2QUV0Z1VUN2VtRTBWZXJpSDhrdHhNaUpRblpM?=
 =?utf-8?B?Ny9qbjhRY3hsVHdtSFNYVUF3Nm14UU5OaDlndUJLbGtiazZiMWVKUUpXZCtO?=
 =?utf-8?B?N2VmRnRYRUFreG1scXBZUllZWFRVWHZFVWgzYlJOdkN0b1JLYVJEZXV1Y0Nx?=
 =?utf-8?B?QmlpMXN4MS9HTmxId3ZiQVZBY0NRWVV1TVVsVDgrQkZWMHMyWktLS0IwbjdO?=
 =?utf-8?B?bTd1byt5YmdYZ3FPMmFwQlRMMGlpTHVVcXRWcmlmSTNkN2tXZyt5ZmgvSEdZ?=
 =?utf-8?B?YXdsWTh2WmY4STg5enR1T2YzcmVHTlFydGkrNWQ4Y1YxS1NZZWllUm9CazdM?=
 =?utf-8?B?NDN2REs1NVNhVXV3TmM2QjVZZXM2Sk5pRkpZaWp1N2E0NGZKRGpZbnZqbzJR?=
 =?utf-8?B?SU1wZC8xLzNzU3pKQ05vb0drNjFLRUlRd1grMWx5S0VOZjZ5M1AwV09iSzBN?=
 =?utf-8?B?TFYwQWh1UGZ2N05aVVIvcCt3ekFsc055NFJnQXIwdmVmRDBlWWZHQm1ZaTly?=
 =?utf-8?B?c0FhT2xsTkZsdmtvN0s4YkJ4R2ZINU5pK1hWS2laV3cvb3lGZ0MxM0xobnhT?=
 =?utf-8?B?d0wvd0Zkb2dYOUFBSjMxVFYrdTlLZk9CSEFxSVVVYjd3dS9hOHBVSDlCUk9n?=
 =?utf-8?B?TXZ1c3NKS29LV09HZmN1VDlydk13eWszd1JYWnU1QVMxRDdoM1paRWpBT0Ez?=
 =?utf-8?B?QlJIR0dQNm8rNFRwaUw5WCsvUEg0SkZJa3JreXlZcEZhTEhZV0VYRCtrT0xX?=
 =?utf-8?B?T011eFp0NzRMUEpEQVYxdzgxaDJjbmdCNVNhc0xTQjVMM2FpSm9JeGNoYlZC?=
 =?utf-8?B?NDhBTTlPYnhZcFo3WHNEdnEvTHBmc0R5bCtNeDFBRU5zZUVxeGlCemQyUEJT?=
 =?utf-8?B?enl2U3ZHYW5aUHFVUTFod2pCSEcrejA1TTE1ck1SNlkrOTg2aDZURmJjMkxU?=
 =?utf-8?B?Zzc2K1NVdFc4SW9zRFJ0ZGhnNlFnUFhXQXA2VzhMYnd4dWIwRUhYK3JYMTJw?=
 =?utf-8?Q?EfIdArqFobeoBCv7nw0+xydK7?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F62E0B08B762784BAC68C05CA60D23C3@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR11MB1953.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2312c021-94ce-4f7e-f3d3-08da81bb7f25
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Aug 2022 08:19:11.7782
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rxTSnkLYOti4IclyCGXmow4McjzbONeD6g/I6WsCxVD0NkStu5zjTfdaaOQHPplLx72CzSlZY0rLV4SUWPos/7N3bB1QtF94sqLCQYwyMdY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1706
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTYuMDguMjAyMiAxNDo1NCwgSGFyaW5pIEthdGFrYW0gd3JvdGU6DQo+IEVYVEVSTkFMIEVN
QUlMOiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1bmxlc3MgeW91IGtu
b3cgdGhlIGNvbnRlbnQgaXMgc2FmZQ0KPiANCj4gRnJvbTogSGFyaW5pIEthdGFrYW0gPGhhcmlu
aS5rYXRha2FtQHhpbGlueC5jb20+DQo+IA0KPiBFbmFibGUgdHJhbnNtaXNzaW9uIGFuZCByZWNl
cHRpb24gb2YgUFRQIHVuaWNhc3QgcGFja2V0cyBieQ0KPiB1cGRhdGluZyBQVFAgdW5pY2FzdCBj
b25maWcgYml0IGFuZCBzZXR0aW5nIGN1cnJlbnQgSFcgbWFjDQo+IGFkZHJlc3MgYXMgYWxsb3dl
ZCBhZGRyZXNzIGluIFBUUCB1bmljYXN0IGZpbHRlciByZWdpc3RlcnMuDQo+IA0KPiBTaWduZWQt
b2ZmLWJ5OiBIYXJpbmkgS2F0YWthbSA8aGFyaW5pLmthdGFrYW1AeGlsaW54LmNvbT4NCj4gU2ln
bmVkLW9mZi1ieTogTWljaGFsIFNpbWVrIDxtaWNoYWwuc2ltZWtAeGlsaW54LmNvbT4NCj4gU2ln
bmVkLW9mZi1ieTogUmFkaGV5IFNoeWFtIFBhbmRleSA8cmFkaGV5LnNoeWFtLnBhbmRleUB4aWxp
bnguY29tPg0KPiAtLS0NCj4gQWRkZWQgY2hlY2sgZm9yIGdlbV9oYXNfcHRwIGFzIHBlciBDbGF1
ZGl1J3MgY29tbWVudHMuDQo+IA0KPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvY2FkZW5jZS9tYWNi
LmggICAgICB8ICA0ICsrKysNCj4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L2NhZGVuY2UvbWFjYl9t
YWluLmMgfCAxMyArKysrKysrKysrKystDQo+ICAyIGZpbGVzIGNoYW5nZWQsIDE2IGluc2VydGlv
bnMoKyksIDEgZGVsZXRpb24oLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhl
cm5ldC9jYWRlbmNlL21hY2IuaCBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2NhZGVuY2UvbWFjYi5o
DQo+IGluZGV4IDljNDEwZjkzYTEwMy4uMWFhNTc4YzFjYTRhIDEwMDY0NA0KPiAtLS0gYS9kcml2
ZXJzL25ldC9ldGhlcm5ldC9jYWRlbmNlL21hY2IuaA0KPiArKysgYi9kcml2ZXJzL25ldC9ldGhl
cm5ldC9jYWRlbmNlL21hY2IuaA0KPiBAQCAtOTUsNiArOTUsOCBAQA0KPiAgI2RlZmluZSBHRU1f
U0E0QiAgICAgICAgICAgICAgIDB4MDBBMCAvKiBTcGVjaWZpYzQgQm90dG9tICovDQo+ICAjZGVm
aW5lIEdFTV9TQTRUICAgICAgICAgICAgICAgMHgwMEE0IC8qIFNwZWNpZmljNCBUb3AgKi8NCj4g
ICNkZWZpbmUgR0VNX1dPTCAgICAgICAgICAgICAgICAgICAgICAgIDB4MDBiOCAvKiBXYWtlIG9u
IExBTiAqLw0KPiArI2RlZmluZSBHRU1fUlhQVFBVTkkgICAgICAgICAgIDB4MDBENCAvKiBQVFAg
UlggVW5pY2FzdCBhZGRyZXNzICovDQo+ICsjZGVmaW5lIEdFTV9UWFBUUFVOSSAgICAgICAgICAg
MHgwMEQ4IC8qIFBUUCBUWCBVbmljYXN0IGFkZHJlc3MgKi8NCj4gICNkZWZpbmUgR0VNX0VGVFNI
ICAgICAgICAgICAgICAweDAwZTggLyogUFRQIEV2ZW50IEZyYW1lIFRyYW5zbWl0dGVkIFNlY29u
ZHMgUmVnaXN0ZXIgNDc6MzIgKi8NCj4gICNkZWZpbmUgR0VNX0VGUlNIICAgICAgICAgICAgICAw
eDAwZWMgLyogUFRQIEV2ZW50IEZyYW1lIFJlY2VpdmVkIFNlY29uZHMgUmVnaXN0ZXIgNDc6MzIg
Ki8NCj4gICNkZWZpbmUgR0VNX1BFRlRTSCAgICAgICAgICAgICAweDAwZjAgLyogUFRQIFBlZXIg
RXZlbnQgRnJhbWUgVHJhbnNtaXR0ZWQgU2Vjb25kcyBSZWdpc3RlciA0NzozMiAqLw0KPiBAQCAt
MjQ1LDYgKzI0Nyw4IEBADQo+ICAjZGVmaW5lIE1BQ0JfVFpRX09GRlNFVCAgICAgICAgICAgICAg
ICAxMiAvKiBUcmFuc21pdCB6ZXJvIHF1YW50dW0gcGF1c2UgZnJhbWUgKi8NCj4gICNkZWZpbmUg
TUFDQl9UWlFfU0laRSAgICAgICAgICAxDQo+ICAjZGVmaW5lIE1BQ0JfU1JUU01fT0ZGU0VUICAg
ICAgMTUgLyogU3RvcmUgUmVjZWl2ZSBUaW1lc3RhbXAgdG8gTWVtb3J5ICovDQo+ICsjZGVmaW5l
IE1BQ0JfUFRQVU5JX09GRlNFVCAgICAgMjAgLyogUFRQIFVuaWNhc3QgcGFja2V0IGVuYWJsZSAq
Lw0KPiArI2RlZmluZSBNQUNCX1BUUFVOSV9TSVpFICAgICAgIDENCj4gICNkZWZpbmUgTUFDQl9P
U1NNT0RFX09GRlNFVCAgICAyNCAvKiBFbmFibGUgT25lIFN0ZXAgU3luY2hybyBNb2RlICovDQo+
ICAjZGVmaW5lIE1BQ0JfT1NTTU9ERV9TSVpFICAgICAgMQ0KPiAgI2RlZmluZSBNQUNCX01JSU9O
UkdNSUlfT0ZGU0VUIDI4IC8qIE1JSSBVc2FnZSBvbiBSR01JSSBJbnRlcmZhY2UgKi8NCj4gZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2NhZGVuY2UvbWFjYl9tYWluLmMgYi9kcml2
ZXJzL25ldC9ldGhlcm5ldC9jYWRlbmNlL21hY2JfbWFpbi5jDQo+IGluZGV4IDQ5NGZlOTYxYTQ5
ZC4uNDY5OTY5OWExNTkzIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9jYWRl
bmNlL21hY2JfbWFpbi5jDQo+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2NhZGVuY2UvbWFj
Yl9tYWluLmMNCj4gQEAgLTI4Nyw2ICsyODcsMTMgQEAgc3RhdGljIHZvaWQgbWFjYl9zZXRfaHdh
ZGRyKHN0cnVjdCBtYWNiICpicCkNCj4gICAgICAgICB0b3AgPSBjcHVfdG9fbGUxNigqKCh1MTYg
KikoYnAtPmRldi0+ZGV2X2FkZHIgKyA0KSkpOw0KPiAgICAgICAgIG1hY2Jfb3JfZ2VtX3dyaXRl
bChicCwgU0ExVCwgdG9wKTsNCj4gDQo+ICsjaWZkZWYgQ09ORklHX01BQ0JfVVNFX0hXU1RBTVAN
Cj4gKyAgICAgICBpZiAoZ2VtX2hhc19wdHAoYnApKSB7DQo+ICsgICAgICAgICAgICAgICBnZW1f
d3JpdGVsKGJwLCBSWFBUUFVOSSwgYm90dG9tKTsNCj4gKyAgICAgICAgICAgICAgIGdlbV93cml0
ZWwoYnAsIFRYUFRQVU5JLCBib3R0b20pOw0KPiArICAgICAgIH0NCj4gKyNlbmRpZg0KPiArDQo+
ICAgICAgICAgLyogQ2xlYXIgdW51c2VkIGFkZHJlc3MgcmVnaXN0ZXIgc2V0cyAqLw0KPiAgICAg
ICAgIG1hY2Jfb3JfZ2VtX3dyaXRlbChicCwgU0EyQiwgMCk7DQo+ICAgICAgICAgbWFjYl9vcl9n
ZW1fd3JpdGVsKGJwLCBTQTJULCAwKTsNCj4gQEAgLTcyMCw3ICs3MjcsMTEgQEAgc3RhdGljIHZv
aWQgbWFjYl9tYWNfbGlua191cChzdHJ1Y3QgcGh5bGlua19jb25maWcgKmNvbmZpZywNCj4gDQo+
ICAgICAgICAgc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmYnAtPmxvY2ssIGZsYWdzKTsNCj4gDQo+
IC0gICAgICAgLyogRW5hYmxlIFJ4IGFuZCBUeCAqLw0KPiArICAgICAgIC8qIEVuYWJsZSBSeCBh
bmQgVHg7IEVuYWJsZSBQVFAgdW5pY2FzdCAqLw0KPiArI2lmZGVmIENPTkZJR19NQUNCX1VTRV9I
V1NUQU1QDQo+ICsgICAgICAgaWYgKGdlbV9oYXNfcHRwKGJwKSkNCj4gKyAgICAgICAgICAgICAg
IG1hY2Jfd3JpdGVsKGJwLCBOQ1IsIG1hY2JfcmVhZGwoYnAsIE5DUikgfCBNQUNCX0JJVChQVFBV
TkkpKTsNCj4gKyNlbmRpZg0KPiAgICAgICAgIG1hY2Jfd3JpdGVsKGJwLCBOQ1IsIG1hY2JfcmVh
ZGwoYnAsIE5DUikgfCBNQUNCX0JJVChSRSkgfCBNQUNCX0JJVChURSkpOw0KDQpDYW4geW91IHVz
ZSBhIHNpbmdsZSByZWFkIGFuZCBzaW5nbGUgd3JpdGUgaGVyZT8gc29tZXRoaW5nIGxpa2U6DQoN
CgkvKiBFbmFibGUgUnggYW5kIFR4OyBFbmFibGUgUFRQIHVuaWNhc3QgKi8NCgljdHJsID0gbWFj
Yl9yZWFkbChicCwgTkNSKTsNCglpZiAoSVNfRU5BQkxFRChDT05GSUdfTUFDQl9VU0VfSFdTVEFN
UCkgJiYgZ2VtX2hhc19wdHAoYnApKQ0KCQljdHJsIHw9IE1BQ0JfQklUKFBUUFVOSSk7DQoJbWFj
Yl93cml0ZWwoYnAsIE5DUiwgY3RybCB8IE1BQ0JfQklUKFJFKSB8IE1BQ0JfQklUKFRFKSk7DQoN
ClRoYW5rIHlvdSwNCkNsYXVkaXUgQmV6bmVhDQoNCj4gDQo+ICAgICAgICAgbmV0aWZfdHhfd2Fr
ZV9hbGxfcXVldWVzKG5kZXYpOw0KPiAtLQ0KPiAyLjE3LjENCj4gDQoNCg==
