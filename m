Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 379A25B5D1F
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 17:30:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbiILPae (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 11:30:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbiILPad (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 11:30:33 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FEF92AF7
        for <netdev@vger.kernel.org>; Mon, 12 Sep 2022 08:30:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1662996631; x=1694532631;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Z7n1y9f7TSz2zHYyGGP8SKyz7TneUC0F0ipK0/T/eWs=;
  b=ORzZZVhrblBGSATrHqQCbO14iD415klzfBrADtkdKUjs0KCdRZEwbw7o
   eogJ3Wd+v45ZG/lAEfG1+fytgvGnZd6ShuU37dGNcVdsaUC8zglofPd6d
   F4YFGuKRqOxNbXNHOF09Ixb2PRQ4o4vsc4Gp8t9kxvEsTAPrZCEZ+qpgT
   xKqOoSQ/bgAvkIfyG0zZlAXgmEIs3TTpRP150YziLTfbqq3VlUQd2d/ev
   TLUAn4+7lV5Z9YIwI2WWWlJNn1chiGutC/Vb+P+waTdW9srCfKP1G5rzi
   AUgmo7/t+W4zJoNCV1VfDVSA0GiZnaT5c3P/32Yq+DTZwaFBYmhem/hAI
   A==;
X-IronPort-AV: E=Sophos;i="5.93,310,1654585200"; 
   d="scan'208";a="180047958"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Sep 2022 08:30:31 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Mon, 12 Sep 2022 08:30:29 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.12 via Frontend
 Transport; Mon, 12 Sep 2022 08:30:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fBe7Prxh7efOEO90oLO6Qw9tsgoTqS4Fc4qdUXftmTxCUnqIy4m75kocq5rr/WxUzoQRcPIbbalObzZaXD7YVwOxfP3omyq3GgPnaJ9frAIA0xjM6EziDWy0G8CGdDleeYCh8pZJo5U/M4vMVQnEruKYlEpC0afRMhgNvyeiV/i9qxQn/93mLyAvH0SJ/OatNn4nbhXTJgItGeikPzLyMm0Aodub8/ufvZmBWhRCoxxK7q63rPWytizZyPbm8tgkkgk2DbOSMQZc+SGSI7FS8LIKud0qNcRX/EbLTeo2is0lOZctxhbbipJ3/0Odyp1+Tgk92mw9/ljbo8Kb6keGMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z7n1y9f7TSz2zHYyGGP8SKyz7TneUC0F0ipK0/T/eWs=;
 b=Qz8vHIqsi1YNBPqPxDMRf+SM0x3+JI0NuPHuvg4Ih93zoQbkNemI+M2mcitMOGnPGY8dsrIHuoCx4xnRYWdPkb7buZ9ollkUKqOkvX4UTXzXUbjJiMXQmyBHParH0frEOx8Ck38WfT2Xy5PycVTejqtMTKgZtbJYtd1VKpr0SszFn7k5f1cQxhVTMummQSH9KgL5PKa5elYfnPg82EEX6AfqicqJpSsK7lbP0Zdv21BIKdGEBElwKJO3Kj9b4pSl9d9IiaYyvJ8WCFAgwTW5MgzphprIztKp6KWe4EIjc38m+RTvViuhBUt+2xOrR5F4SQMZd3CmEK3+LIFiphBcEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z7n1y9f7TSz2zHYyGGP8SKyz7TneUC0F0ipK0/T/eWs=;
 b=AZvRUbA0MiYCU6xJpLaI6ovoYRlnKiMhd+FnXCMfgdZPWYUbOBVupxY8XzQj0wEzkN1Gt00B1Ala0nHcl83RljTxQibNn8AkekPCz6trCEFYIm7A3S6ZeoIBq1Rg5ckHtfposWiK/kqwbmr5v19TGs4yvdMQ5dA6MUvQ2wy9AxA=
Received: from DM5PR11MB0076.namprd11.prod.outlook.com (2603:10b6:4:6b::28) by
 DS7PR11MB6062.namprd11.prod.outlook.com (2603:10b6:8:75::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5588.12; Mon, 12 Sep 2022 15:30:19 +0000
Received: from DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::3c5c:46c3:186b:d714]) by DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::3c5c:46c3:186b:d714%3]) with mapi id 15.20.5612.022; Mon, 12 Sep 2022
 15:30:18 +0000
From:   <Arun.Ramadoss@microchip.com>
To:     <vladimir.oltean@nxp.com>
CC:     <claudiu.manoil@nxp.com>, <UNGLinuxDriver@microchip.com>,
        <alexandre.belloni@bootlin.com>, <vivien.didelot@gmail.com>,
        <andrew@lunn.ch>, <idosch@nvidia.com>, <linux@rempel-privat.de>,
        <petrm@nvidia.com>, <f.fainelli@gmail.com>, <hauke@hauke-m.de>,
        <martin.blumenstingl@googlemail.com>, <xiaoliang.yang_1@nxp.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@google.com>,
        <netdev@vger.kernel.org>, <Woojung.Huh@microchip.com>,
        <davem@davemloft.net>
Subject: Re: [RFC PATCH net-next 3/3] net: dsa: never skip VLAN configuration
Thread-Topic: [RFC PATCH net-next 3/3] net: dsa: never skip VLAN configuration
Thread-Index: AQHYkJVA+iLppAy/uE2cW1NrBQONVa1xiwcAgAADhICAADWVAIABvUGAgADAlICAACQggIAArH6AgAiqEgCAAEpdAIABMNoAgABliACABKhtgIAAHsCAgAx97ICAACSgAIBLUNeA
Date:   Mon, 12 Sep 2022 15:30:18 +0000
Message-ID: <262ef822025a205b1b4975c967cc5e5bd07faa16.camel@microchip.com>
References: <CAFBinCB74dYJOni8-vZ+hNH6Q6E4rmr5EHR_o5KQSGogJzBhFA@mail.gmail.com>
         <20220708120950.54ga22nvy3ge5lio@skbuf>
         <CAFBinCCnn-DTBYh-vBGpGBCfnsQ-kSGPM2brwpN3G4RZQKO-Ug@mail.gmail.com>
         <f19a09b67d503fa149bd5a607a7fc880a980dccb.camel@microchip.com>
         <20220714151210.himfkljfrho57v6e@skbuf>
         <3527f7f04f97ff21f6243e14a97b342004600c06.camel@microchip.com>
         <20220715152640.srkhncx3cqfcn2vc@skbuf>
         <d7dc941bf816a6af97c84bdbb527bf9c0eb02730.camel@microchip.com>
         <20220718162434.72fqamkv4v274tny@skbuf>
         <5b5d8034f0fe7f95b04087ea01fc43acec2db942.camel@microchip.com>
         <20220726172128.tvxibakadwnf76cq@skbuf>
In-Reply-To: <20220726172128.tvxibakadwnf76cq@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM5PR11MB0076:EE_|DS7PR11MB6062:EE_
x-ms-office365-filtering-correlation-id: eeb43c47-abad-4dc9-9262-08da94d3b2fa
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xwACcDKCy8LINbcusBNU1Y1t8q18IIv5PHd+pMJCby/lz6B+5T3CmiaVVQnRfDQRZ8NITg/iB4MFzKqHRNLgF8D5XewQhljbSATl1IK7dGGqHOAAv4Him0i105vttaHqjYdUQXPS/gJubIf31uTlzFLqUZbMLfPUf9NyX5kqwSgW1CgQw64q2p6ZbO2r7qqTYUHL4DoAYseMcWYrBHGiKgXImlV5KkVRdOw3f7F+zxZNsk/I2u5Ard6atuq7V5VTtXIruXJA34ypGQKulcqRIrkqnwa21iB/iQiyp/DTFaeKCsA9jbchlzY4RicJCa6leiHCwEp6lOY3TkoGLcWZ6w0Hl+Bioc+vWd8OCLNVq72ya3AGXem2tL09nqlWs5akOWDTbwgJbZhyH/Du8hLRExRsMpu9vPLvaY9xDvybQnYp23bVaqdSalGcmTtOnBgmhLlH8X98kZXyaHl0GVF19mShswU1ON/a/zRcyoVIdYJC4qHFQgeAKCRvHxUkS1SiR7BNnxxVIGEv8YIV0HpjLgoSE+LMPDV6/wIOdOzAsnKymCT6DTzMhtmj4hf9jm3pwX4CVoM21B0JXhpqHOB+wK/FIlOlItR4e7+7T9vTynN9M+ZSWUSIxMkwq+VMgTVYHbk+xGcgE4TfHX+J8ZAv+drvgWWxszZurTrna1HAm9Jn9QUz/TukTKNVKjHRNKK9g9mMRTvtyJjLKQ5w8DSuww6g585ikHLwxi8UhLwPfntv40kGE3gDWXux++jd8vUUdBFCxarwjD78c6sAj9+y7Ai6Avvj9geQms86H9dypJA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB0076.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(396003)(136003)(39860400002)(376002)(366004)(66556008)(2616005)(38100700002)(6916009)(83380400001)(316002)(66446008)(4326008)(54906003)(64756008)(8676002)(66946007)(66476007)(76116006)(5660300002)(122000001)(478600001)(91956017)(71200400001)(36756003)(86362001)(6512007)(2906002)(6506007)(41300700001)(186003)(7416002)(8936002)(6486002)(38070700005)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dkxZekJ6VEZmK21kbzd6cU1WSndPaWdEZlZ2VWRrTWwzY3dtYk8rSmhlSXQ5?=
 =?utf-8?B?emtWQWUzeUV1eUxqa2s1dEV5QXpONEFPQWhPRHpYN3ZmSzRQT1kwZjlrTUh3?=
 =?utf-8?B?TVVXWkxrU1ZLZ3hmLzRXSWkrbXZFMkQ0bjJzR2ZSTjhZWnlQRHE3ZDIyT0tt?=
 =?utf-8?B?L1NwMUcrZ3B4dVlrOWZBanljWUdIalNDeEhNV3pndVk2MGZtdm8vS0p3UmFu?=
 =?utf-8?B?MlFwRGgvVkx4MngwNm4zQXhxYS9OVTBoLzJjSHk0WnlaZC9ER2l3YTdXdith?=
 =?utf-8?B?ZXBwYmhFOXpuSkoxQ2ltUklVTkhwSnN1KzNDWDhGR2xVdVZxSGFuQWlyWFBQ?=
 =?utf-8?B?MWZYVXJFQzV1WlpOVG5tV09sYzAvY1EyUVJiUHRoMGdod2VnN0pLdEZHRjZu?=
 =?utf-8?B?TEhDWlZobEFuQ0Q5a1IyRXJXNVBCdkNZMVRRWDRKajdUbWZvVTNQMWl3OXNT?=
 =?utf-8?B?UWtzYzVmdGRJZ2NEcUZ1eGdPMXN0VUlWSS9rVEhKaU4rN2xaVGNZeGVNVTND?=
 =?utf-8?B?eGgzTEhWcGdmTU5VYzlmSU5RQVA5WTVNKzVIYkFMTkk5azJHbWlCaDVOMnhQ?=
 =?utf-8?B?dVJhc1JCVVZ6eFZhV2padkhkU29BdTJrcVNTS2c0OGJHZGdTcmpOYy9SUjZv?=
 =?utf-8?B?YWZCUjVDTUJ1aHhsOWpEdEdsTkhiMGFKR2lFcmJGMGRBNUpSUEJwWFRidzdq?=
 =?utf-8?B?RFUwRWtBd0hGeFVEQnVZdUErVjFiOUQyL0dtbmpQTE9MQWxvdTZRWmhNV3F5?=
 =?utf-8?B?dmtKLzh6RnpOSU92SjV6cG5PZG91bGIwV3ZzR0hWckc4RDJOT1BmYUFoK3o1?=
 =?utf-8?B?aTVMNnIzSkZaZk5oRmJlODlYNnFQYUdYUElwaEtkWWZXajE4cUJPaEZ3Mkx2?=
 =?utf-8?B?elpLazFKb3Rub25vOUxVejI4STFCVzV6ZlFWUSs3b1IxYktkaFFEWitQYTJG?=
 =?utf-8?B?eE96UklZMW5VcVkrZGVsWGVmUzV4VHpGOW9HYnVNNXBCQlZnUDl2RkY0Y01C?=
 =?utf-8?B?Z1RnSTZ5d3MvMGc0bUtsMnZpcGpTQ21TTkUxanZLYVJhMFIzYXVMZXR3WjU4?=
 =?utf-8?B?cHd1Rm1jV0lsNzNxd1lxREJGMWIyQ0ovWFdFa2VHMTFlamZjSHQ5TkM5d3Uz?=
 =?utf-8?B?WTNtZ1J1SFVGSzdQbUFyT3llK3puNUJva2pPcUxLSnUrNkdlMTd0SzB4Ynk4?=
 =?utf-8?B?cDQyV2hsbnpiOHNOd3RBay9JZEZKUHFIL3N6TkRKMWlad2JHRnBCcnRQRS9r?=
 =?utf-8?B?ZHVvMkd2YTJMZ1NOMVIxWkQzckpIaFlJWmxCb2NLbVVnQXhmK1dvSURlbm9x?=
 =?utf-8?B?Y2JQaTFzTjBRWVN0NzVoaUNxbkl4eCtTWXB1MUVWL1ZtTUxSUjNFejFrOWtq?=
 =?utf-8?B?WTYvK0J1eHNYU1RHdVYvMjRGL0VBeTJCRWlOSGVrVzR1SEMvQnJPRlZaRnNh?=
 =?utf-8?B?NmhWY1E0RW0ydHA4QUFJMDJyTkRqS043VlhVNzNDOGszdElhbTJ1Wnd5Sm1o?=
 =?utf-8?B?VFFHMzNsYkhYeStQUVdiUmpIc3hwREp3Y0VFa3dhbDY1RlRWNVNmR1o4ME53?=
 =?utf-8?B?SXJOUklVYUF2b2dKWlNXbHZ6NUVWREpVV3hOZXVCMVVZWUp6VklSOFEvS3Y1?=
 =?utf-8?B?aFFXSDB3bEh3V0N0c1loSGIxNENGS2ZRbHZIampBNXJGaEZxaUo4aUt4bTVQ?=
 =?utf-8?B?R1Joazdack5wRUgrb3FmY3pJYjRsUGllOUtyTWdEYktab05vY1BXZThJVEE1?=
 =?utf-8?B?bmJ5MWJhRzBkbFFQb2ZudkhpV1VsUGw2YUNpay9BMEpZcXo4SmVwQk03MVZV?=
 =?utf-8?B?UHVqWFgwRXhobEo2SXZaOHVFbU1XVG9FVXVSY2Rjc3U3QXVXalNIREVlSjNt?=
 =?utf-8?B?TXlZWSsrV0tqRlY0MVV4cHBlYVc2QnlVbnI3NU12MjlGQmh4Uk9uajBLZmZD?=
 =?utf-8?B?RUlZV0xURTRLbHJlMm9vY3ZEUjkrbnpXVFBHWjJQQ3d5a0xMRFNmTE5YT0VU?=
 =?utf-8?B?WE9zREczS04rTTdhaVhmRGh6MVJlcVR1c0JtY01ScVVWOUQ5NU0zUndjM29M?=
 =?utf-8?B?eUIzUFBBSmQyZXFVTGRocFlQY05XNzFVU29hVi80S3RDR09OY1ZsY1l4UXo5?=
 =?utf-8?B?bDZRNGhTUmFZWE82TVZxRmtxeHVFNFl5VTlzZXY0ZzhrMlBRdzA5NExaM0U3?=
 =?utf-8?B?cEI1ckpuZktFaXE3bWQwK1JUcFR5YWNjeUJGU2dLRlgzcExxL2U3Z05UREF0?=
 =?utf-8?Q?Pme5dVVBousu6xZKxu3RKpco/i5YjT/5isxXEeIz/8=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <904A466BF5706C47A0682E7B260F9748@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB0076.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eeb43c47-abad-4dc9-9262-08da94d3b2fa
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Sep 2022 15:30:18.7497
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: roGJ+YJCnLJCxV1yfMLZAJxyW85y1vyzq1VTE9Fe/lb+VmXU6Mlaw2HU15iGX6TgcuBIofl/BzqEJgTYO+nGFHWPnHIC4cPZ7o5rnrmUbxA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6062
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIyLTA3LTI2IGF0IDE3OjIxICswMDAwLCBWbGFkaW1pciBPbHRlYW4gd3JvdGU6
DQo+IEVYVEVSTkFMIEVNQUlMOiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50
cyB1bmxlc3MgeW91DQo+IGtub3cgdGhlIGNvbnRlbnQgaXMgc2FmZQ0KSGkgVmxhZGltaXIsDQpJ
IGFtIHRyeWluZyB0byBicmluZ3VwIHRoZSBrc2VsZnRlc3QgZm9yIGJyaWRnZV92bGFuX2F3YXJl
LnNoLCBpbiB0aGF0DQpJIGFtIGZhY2luZyBwcm9ibGVtIGR1cmluZyB0aGUgcGluZyB0ZXN0IGFu
ZCBhbGwgdGhlIHRlc3RzIGFyZSBmYWlsaW5nLg0KDQojaXAgdnJmIGV4ZWMgdmxhbjEgcGluZyAx
OTIuMC4yLjINCkNhbm5vdCBvcGVuIG5ldHdvcmsgbmFtZXNwYWNlOiBObyBzdWNoIGZpbGUgb3Ig
ZGlyZWN0b3J5DQpGYWlsZWQgdG8gZ2V0IG5hbWUgb2YgbmV0d29yayBuYW1lc3BhY2U6IE5vIHN1
Y2ggZmlsZSBvciBkaXJlY3RvcnkNCg0KSXMgdGhlcmUgYW55IGNvbmZpZ3VyYXRpb25zIG5lZWQg
dG8gYmUgZW5hYmxlZCBpbiB0aGUgbGludXgga2VybmVsLCBjYW4NCnlvdSBzdWdnZXN0L2hlbHAg
bWUgb3V0IGluIHJlc29sdmluZyBpdC4NCg0KLS0NCkFydW4NCg0KDQo+IA0KPiBIaSBBcnVuLA0K
PiANCj4gT24gVHVlLCBKdWwgMjYsIDIwMjIgYXQgMDM6MTA6MjRQTSArMDAwMCwgQXJ1bi5SYW1h
ZG9zc0BtaWNyb2NoaXAuY29tDQo+ICB3cm90ZToNCj4gPiBJIHRyaWVkIHRvIHVwZGF0ZSB0aGUg
a3N6IGNvZGUgYW5kIHRlc3RlZCBhZnRlciBhcHBseWluZyB0aGlzIHBhdGNoDQo+ID4gc2VyaWVz
LiBGb2xsb3dpbmcgYXJlIHRoZSBvYnNlcnZhdGlvbiwNCj4gPiANCj4gDQo+ICguLi4pDQo+ID4g
SW4gc3VtbWFyeSwgb25seSBmb3IgcHZpZCAxIGJlbG93IHBhdGNoIGlzIHdvcmtpbmcuIEluaXRp
YWxseSBJDQo+ID4gdHJpZWQNCj4gPiB3aXRoIHB2aWQgMCwgMjEsIDQwOTUsIGl0IHdlcmUgbm90
IHdvcmtpbmcsIG9ubHkgZm9yIHB2aWQgMSBpdCBpcw0KPiA+IHdvcmtpbmcuIEtpbmRseSBzdWdn
ZXN0IHdoZXRoZXIgYW55IGNoYW5nZXMgdG8gYmUgZG9uZSBpbiBwYXRjaCBvcg0KPiA+IHRlc3Rp
bmcgbWV0aG9kb2xvZ3kuDQo+IA0KPiBXaGF0IGFyZSB5b3Ugc2F5aW5nIGV4YWN0bHkgdGhhdCB5
b3UgdHJpZWQgd2l0aCBwdmlkIDAsIDIxLCA0MDk1Pw0KPiBEbyB5b3UgbWVhbg0KPiAoYSkgeW91
IGNoYW5nZWQgdGhlIHZsYW5fZGVmYXVsdF9wdmlkIG9mIHRoZSBicmlkZ2UgdG8gdGhlc2UgdmFs
dWVzLA0KPiBvcg0KPiAoYikgeW91IGVkaXRlZCAidTE2IHB2aWQgPSAxIiBpbiBrc3pfY29tbWl0
X3B2aWQoKSB0byAidTE2IHB2aWQgPSAwIg0KPiAob3IgMjEsIDQwOTUgZXRjKT8NCj4gDQo+IEVp
dGhlciB3YXksIHRoZSBmdW5kYW1lbnRhbCByZWFzb24gd2h5IG5laXRoZXIgd2FzIGdvaW5nIHRv
IHdvcmsgaXMNCj4gdGhlDQo+IHNhbWUsIGFsdGhvdWdoIHRoZSBleHBsYW5hdGlvbiBpcyBnb2lu
ZyB0byBiZSBzbGlnaHRseSBkaWZmZXJlbnQuDQo+IA0KPiBXaGF0IHZsYW5fZGVmYXVsdF9wdmlk
IG1lYW5zIGlzIHdoYXQgdGhlIGJyaWRnZSBsYXllciB1c2VzIGFzIGEgcHZpZA0KPiB2YWx1ZSBm
b3IgVkxBTi1hd2FyZSBwb3J0cy4gVGhlIHZhbHVlIG9mIDAgaXMgc3BlY2lhbCBhbmQgaXQgbWVh
bnMNCj4gImRvbid0IGFkZCBhIFBWSUQgYXQgYWxsIi4gSXQncyB0aGUgc2FtZSBhcyBpZiB5b3Ug
Y29tcGlsZWQgeW91cg0KPiBrZXJuZWwNCj4gd2l0aCBDT05GSUdfQlJJREdFX1ZMQU5fRklMVEVS
SU5HPW4uDQo+IA0KPiBUaGUgcHJvYmxlbSBpcyB0aGF0IHlvdSdyZSBub3QgbWFraW5nIGEgZGlm
ZmVyZW5jZSBiZXR3ZWVuIHRoZSBicmlkZ2UNCj4gUFZJRCBhbmQgdGhlIGhhcmR3YXJlIFBWSUQu
DQo+IA0KPiBTZWUsIHRoaW5ncyBkb24ndCB3b3JrIGR1ZSB0byB0aGUgbGluZSBoaWdobGlnaHRl
ZCBiZWxvdzoNCj4gDQo+IHN0YXRpYyBpbnQga3N6X2NvbW1pdF9wdmlkKHN0cnVjdCBkc2Ffc3dp
dGNoICpkcywgaW50IHBvcnQpDQo+IHsNCj4gICAgICAgICBzdHJ1Y3QgZHNhX3BvcnQgKmRwID0g
ZHNhX3RvX3BvcnQoZHMsIHBvcnQpOw0KPiAgICAgICAgIHN0cnVjdCBuZXRfZGV2aWNlICpiciA9
IGRzYV9wb3J0X2JyaWRnZV9kZXZfZ2V0KGRwKTsNCj4gICAgICAgICBzdHJ1Y3Qga3N6X2Rldmlj
ZSAqZGV2ID0gZHMtPnByaXY7DQo+ICAgICAgICAgYm9vbCBkcm9wX3VudGFnZ2VkID0gZmFsc2U7
DQo+ICAgICAgICAgc3RydWN0IGtzel9wb3J0ICpwOw0KPiAgICAgICAgIHUxNiBwdmlkID0gMTsg
ICAgICAgLyogYnJpZGdlIHZsYW4gdW5hd2FyZSBwdmlkICovICAgPC0tLQ0KPiB0aGlzIGxpbmUN
Cj4gDQo+ICAgICAgICAgcCA9ICZkZXYtPnBvcnRzW3BvcnRdOw0KPiANCj4gICAgICAgICBpZiAo
YnIgJiYgYnJfdmxhbl9lbmFibGVkKGJyKSkgew0KPiAgICAgICAgICAgICAgICAgcHZpZCA9IHAt
PmJyaWRnZV9wdmlkLnZpZDsNCj4gICAgICAgICAgICAgICAgIGRyb3BfdW50YWdnZWQgPSAhcC0+
YnJpZGdlX3B2aWQudmFsaWQ7DQo+ICAgICAgICAgfQ0KPiANCj4gICAgICAgICBrc3pfc2V0X3B2
aWQoZGV2LCBwb3J0LCBwdmlkKTsNCj4gDQo+ICAgICAgICAgaWYgKGRldi0+ZGV2X29wcy0+ZHJv
cF91bnRhZ2dlZCkNCj4gICAgICAgICAgICAgICAgIGRldi0+ZGV2X29wcy0+ZHJvcF91bnRhZ2dl
ZChkZXYsIHBvcnQsDQo+IGRyb3BfdW50YWdnZWQpOw0KPiANCj4gICAgICAgICByZXR1cm4gMDsN
Cj4gfQ0KPiANCj4gDQo=
