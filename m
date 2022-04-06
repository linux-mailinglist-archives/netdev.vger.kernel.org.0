Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78E8C4F5E0F
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 14:46:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbiDFMh0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 08:37:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232106AbiDFMe4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 08:34:56 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5475D39AA
        for <netdev@vger.kernel.org>; Wed,  6 Apr 2022 01:36:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1649234214; x=1680770214;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=8zfq12voq0eaWTaA+BiwgraD8wVI3rpjkLEJztfK6b0=;
  b=IWepBj553NBNhGIPPr3XNTk9x4Zqy+/ZiEmDFYUtyxGUVwv7cvMRB6Mc
   IbwvoBO0tdqdqS/dKxRsBcmDZ0oFIM+iEB2FtDPDPUq9rlA9YARW6Ddtc
   TyY1TgFfbV3+gsY/m2lYOetRK/1bAIadAF6cb79rbl2/p+4vDlBM8smr0
   iz73ghgPPwSOWkQHkOuTd1eRsLxVk4TDlwntiHdAirYlc+HXzTPw7L5Be
   mNDwVSXUf6RkFvQWxwJAClE9eXMdMZvYf6gqVmrKagvfg99wJho/3RsTJ
   dzvE4GMoSuqvKseVPJNz+96Ml0yRLlGkP8XBQyBLXzJmdj4RJsS19PZUA
   Q==;
X-IronPort-AV: E=Sophos;i="5.90,239,1643698800"; 
   d="scan'208";a="168601095"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Apr 2022 01:36:53 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 6 Apr 2022 01:36:53 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17 via Frontend Transport; Wed, 6 Apr 2022 01:36:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XogyX1V0wmICecLITnDoLil+g/8B6nw8ahuQKcVzsY/UYmS2ABPukt2z+K5BZx2mKJiOxeAA6anrBVZ5RtcXTvkuwQZsNSEHSwGq50x2yz0wKhUOPaPFrdWc2fnvqE+f8sRHWVMYv7yCpaFGw3oOO048cHSnUy5ftpqYMEKVGZjLlgCvJoEfPmqQukrelfAnWH2kGRjIYpGwB6a1YczTlhMG9KbQGZUbWNROLdr5cRWK9agGhYcpGNdwrjfddpvkOwe9kKHg7GaGE+kF6Snnbys77BbHxbvBkzOHcf+/1NDh5nVMRzumtGCerLq1FujEbPsRb6234dy0Tt60iQeqYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8zfq12voq0eaWTaA+BiwgraD8wVI3rpjkLEJztfK6b0=;
 b=fsIf21irUbSrBhMSI1LGj6bAlf4EjwY9AxGX461E58H5UcJPY22dWBXjxOBkQKk59AlQiEJ+nKWkkJtxd0uxaPIEKGo8sd3WKrGlx55hov3NX1haYzMR+dUTKowGH9iSv1s9itaP4ozyrDH+IpXoloL3vZFTd71l2HH+R5+/Oxm2bm37gxFy1uxhdxjLF0pwt4w39aDUmRNXWZVjzXV8+x2M7NLtYSuoLmqk0ss++Rf5ybHfqu56wL1iTyXLzjxV29chg712IzFyHzQQe+lIfGEsjmtsUVVd0BeHxtjSXW4p4ZJO1sZoi73+t2RfqF/PvRz7A714glH9q3cGt8eC5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8zfq12voq0eaWTaA+BiwgraD8wVI3rpjkLEJztfK6b0=;
 b=ajzGavr7yckwDVXjjsxMftN+KxfUJVeq+s36j6W1kdKQOx4tRsHwAVtVFfwBAFTQ+peeP47bkV2AuL7UEUr9jtAWwDhR7v1KL+/pYvj05HZClGfaUzdqDT4qzckABUQh3+PfG6YEUgHgLTEBglEzU9ggdLWB7U5uPLU+S13Sr8I=
Received: from CO1PR11MB5154.namprd11.prod.outlook.com (2603:10b6:303:95::7)
 by DS7PR11MB5990.namprd11.prod.outlook.com (2603:10b6:8:71::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5123.31; Wed, 6 Apr 2022 08:36:49 +0000
Received: from CO1PR11MB5154.namprd11.prod.outlook.com
 ([fe80::dc95:437b:6564:f220]) by CO1PR11MB5154.namprd11.prod.outlook.com
 ([fe80::dc95:437b:6564:f220%8]) with mapi id 15.20.5123.031; Wed, 6 Apr 2022
 08:36:49 +0000
From:   <Conor.Dooley@microchip.com>
To:     <andrew@lunn.ch>
CC:     <palmer@rivosinc.com>, <apatel@ventanamicro.com>,
        <netdev@vger.kernel.org>, <Nicolas.Ferre@microchip.com>,
        <Claudiu.Beznea@microchip.com>, <linux@armlinux.org.uk>,
        <hkallweit1@gmail.com>, <linux-riscv@lists.infradead.org>
Subject: Re: riscv defconfig CONFIG_PM/macb/generic PHY regression in
 v5.18-rc1
Thread-Topic: riscv defconfig CONFIG_PM/macb/generic PHY regression in
 v5.18-rc1
Thread-Index: AQHYSO3IJSdXwoud5UqKTAwCCAurg6zhaxYAgAEl3QA=
Date:   Wed, 6 Apr 2022 08:36:49 +0000
Message-ID: <dd69c92d-dcb9-48e3-8ff5-078ea041769a@microchip.com>
References: <9f4b057d-1985-5fd3-65c0-f944161c7792@microchip.com>
 <YkxaiEbHwduhS2+p@lunn.ch>
In-Reply-To: <YkxaiEbHwduhS2+p@lunn.ch>
Accept-Language: en-IE, en-US
Content-Language: en-IE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2fbd530e-7460-468b-28a8-08da17a8979f
x-ms-traffictypediagnostic: DS7PR11MB5990:EE_
x-microsoft-antispam-prvs: <DS7PR11MB59905893EB9C9C6EDAE5621098E79@DS7PR11MB5990.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: k/N0vZVfY0zca77OEBI8t7rmjo+LYp/7oabWhb9rE/vspj3d7pshiCSLHuSFfFbLSQeHtAHeBxNI2lOZRcJg9PKCJ9bzzM2qTdSnHmmeyTfmLVLwafr6JIxBWU/5jbJmC+86a+Rke9gMoHfmxD1z6IJVnAlsgPejq+PgoTQ8Vu2oEZ5jCNCn9AumH+4YOZyvAs+UPKObEJFv6W6DsJXlUbsyAnWDCN5FAYCWeOx3T4LSSDn3gthCMq8kv28KGjwSrc8RLGRmtLH+LSQbKg0dWZ9l3greGutmaqZUN4Mtm3QxtgC3vUlZHFZtnH5cDGXNe6G9XXsh9G+QUNTtfjvxKvccpZwa7VrgDBgJ1Er5ggXnIE3/1Ghus4/eRYdBfDHDbhrkNeReg+r0qIlDQ5KMK12gxqg0TwUJdbwPb+RQdgrVEGhxLblHec6k4fjd4HppRO2kxe6O2HAucyeVL3k9++c4ssRW1jVj3t+mqiJE/dWIHDYjka4yo91cr8ALBpcQP1MAa/rDvEYjXQBME32K/isL35KNxz10yxxIW8asSmbGFKYdgQnglGp6G7zFmzS1SzsIrbxMEkJYjMSkvezxnErImp67D0kvuP5Ywp3yVH+V1AVHskKRlkF7yhsTunoKh8tNgedVuuczFiHWiIcl86NzLGAFtKxWjdOH0Az9YjKgYeFNs5b1IzwISCMNjOs+UWAdTaob7HS3lUjSakwFhqm1geBUQt0QXoFhnubv5pPoyldg5o42rUEm8fkGI87yDJlW+xPcKqJH3KSDMlODffAHH+aLh0esRz1RhMxZB9s=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5154.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(31686004)(2616005)(2906002)(5660300002)(6486002)(71200400001)(83380400001)(36756003)(508600001)(8936002)(26005)(38070700005)(38100700002)(91956017)(66446008)(64756008)(66946007)(8676002)(4326008)(53546011)(66556008)(316002)(31696002)(54906003)(76116006)(66476007)(6506007)(86362001)(6512007)(186003)(122000001)(6916009)(41533002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Yjh0L1RGNzNMWXFERDE4SU4zOGg0Q2RqYllOYXpzUW5tTGZKSm8vWGlSc2xT?=
 =?utf-8?B?SHNDODdZN2dPdXFucXZzeXdQN045bUhFb29QbFlqaFkxK3hrS2VUbm4yNkIw?=
 =?utf-8?B?K1UyVlVSZFJNT2hIUnpNUFNYejhqRTI2SG1FU2d3UEdlU2tvdzZVYkJVY1A4?=
 =?utf-8?B?b0V3bitCNWVESWhXTnhyN214cHJabnFRWXN5WVBRaXJKTFQ0Ykd3OXQvbkZ2?=
 =?utf-8?B?UnFoRndyaENONUJabDR2VVNoWmdBSGlkN09mM2pjNm5hZ2I3WWJVSm9vSTEv?=
 =?utf-8?B?WldJTGg5dnpmaEJwWkM3b040YVJrRGMxV085aFpFazRXUnNEVEErNUZEVzEx?=
 =?utf-8?B?ZjA3b2tkeTVpOWJQZG9Panc2VGwxSlVxd3ovWG4xeThZZFA1dmZaNWMrR29Q?=
 =?utf-8?B?WTg3UGVyTUFaS1g2Z2JCS09MTFFaSisweEI1bkw3NDY0TzBsTWFuMTdLcmVN?=
 =?utf-8?B?L3BLTUQ3U0ZlbDVNSmVzTjZjR3V2enhEVnJmUWtxa2duRDVhMEZYRHpTMWx5?=
 =?utf-8?B?ODRCa2NsdFhUc0p5eEtUaE9XbC9nK21BMlA4Zi8yN0dCcVI5akJDVDlJaGwx?=
 =?utf-8?B?RlZJOGZpTGliN1Joc2F5SWlDNU5CYVBEdjJrTkJlOHhqYzBydElZL0JMVlht?=
 =?utf-8?B?MVcyeU4vQjZsVHdpVnhEL3FmTldNcWVBRC9BY3REV1dNQmpvckpFTTQ2WTRV?=
 =?utf-8?B?RUM3WmNtRmVHQmZYMlBtVk5HTVdBN1RaeVZ1Sm9DZ2ZPaisxRHhycDZUZE9k?=
 =?utf-8?B?UFAzNTE1WXRrU0RMRHlESnZNRHJZQ2VkVGZ0VkRPdVBsZUk5Y3BROFUzZGZD?=
 =?utf-8?B?S3lTbndWemoyY3hvUWtsSlh4SW1kZXY3SzVodFVYeStKSTNSL2gwUU5XSENm?=
 =?utf-8?B?YTFCdzVJRUE2WkRmamV6aFNUYkVaQ2I1S3dsM2ZTOEZ4L2JPWkZhWmU0Sy9B?=
 =?utf-8?B?aGEvZXFobjdNTklEK1Fxc1RwWHl6THhhVGk3c1dSTmdiQWNMT0czaDJtdjVV?=
 =?utf-8?B?anlqNDlyMGU3QWJma01CRWxkZFNFcWs5UVlKRmlpWm9keERFYzlCS1NHMWpG?=
 =?utf-8?B?c1dyMk9yb1lWTm03SlJ5KysrVWJPUFpGU29MNkRVRmQzVGNOWDJZeVNTOG9T?=
 =?utf-8?B?T1B0dkVmenFJV2tta1RDM3ZzblFXc0g1a0ZaWXcrTHpVTStxSFVtN25DS2lj?=
 =?utf-8?B?c3RmWDZGRWJSQTZpSVNUam14ZXhTYk91M1dFeFM3RmJkTUt0TzV3Zk9JZnRr?=
 =?utf-8?B?Ymd2K1pac0Zac2lWb2h4djZLMFhybHQ5cWFNQS95aFljdzJ5aWt3aWYveHov?=
 =?utf-8?B?NGx6SENvZ1Qxb3NYWGcxeVFySHRURll6Y2l0ZE1Bbmg0WCtZbkRMUWxva21S?=
 =?utf-8?B?MjBmRTdLUmpvOHMyd3I3UWJrb2RsUll1ZlB0aGNEbWJqV3ZIYXB3NFZpdk5Q?=
 =?utf-8?B?dndOVS9Fa0k1T2Q4Njh1NCtSUk96bjd3cGNQakxacUYrNHVwY3BvVnBmRDdm?=
 =?utf-8?B?TXhnY0JETTRybHorWDZhc3BLNTdOeFhESDhKQzdlMDRKbFdaQkZZaWJ1OUlR?=
 =?utf-8?B?UG1keU8ycWtqVUViYmUwWGNXbHVIdEQ3eVFiYmNHZi9USXk4ZlpHQ2s3WFNY?=
 =?utf-8?B?KzV3UDF0QnZwZzlqYVkxNmxRYms2V2svbURxSmMzc1ZtWUZqZjRZVzgrQmNB?=
 =?utf-8?B?NVZ2U2NhT3d6NFNWbU5EVWdUWk90NDNKWExXazl2cG1LVlBkTDQveFg0Q0VL?=
 =?utf-8?B?bEpEOExYR3d2S280QUFvK3Bsd3FqSjBPOVRJMXl4UnZZcmhaREplNmRWOVJH?=
 =?utf-8?B?ZGc0RUljTm5objZ2K1RwZldUam9RanR3bjdtZlVuVG1FUUx6SFFONjQyeWpP?=
 =?utf-8?B?QkFJRGVsZVUxaDdRZjVOOVB5Mm11L3hlVVlJM254NTZ2NTBUYUZaQ3JMcng2?=
 =?utf-8?B?cnI5UnN6d2dvKytzZnExUG4xWUtnOXd4OFJrYTlGWjFqMUEvSDIwZS9Wdi9J?=
 =?utf-8?B?OHc3YlFDdTVWeVFFT1hTRFdLdzVYUUFLTmFyWit6UWlkVmJqajRpdHdTNW9J?=
 =?utf-8?B?b3dONmp5OHlIb0xhQ3dGei9tZHVVUVdYMmJ1ZVQwNC9FSis4YUZLSWNMMncr?=
 =?utf-8?B?YkR3U2g2NHI2UEp2Mm5LSGJqcTNmM2U3UG9JMDNIM01VZXdQQURSeGtkb1dr?=
 =?utf-8?B?bmpBUVdubURBYm9VN1E1VkRFS0ZVa0MvWndsaHBwb0RHb0dZbmxpdEZPOUhR?=
 =?utf-8?B?anNvSU5PL01lYWR1ZkVVdk8zdXpNL3V3OUwzLy9MRndiajZZYy9QRGhhSnM5?=
 =?utf-8?B?cW0vVTJhQm1STHRZQXJEU3dJUkd4c2hnRGlqZEpTSXZ6MTAyTDc5UT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DC7F8F09E5D325479225C8C6C42C00D4@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5154.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fbd530e-7460-468b-28a8-08da17a8979f
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Apr 2022 08:36:49.1457
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6zZez2ouOgQpppcxbARuk9YCy6LzLbh5f2zLyh5YQ/ffDdmyT2YjWFRSdathH6Zy6DzZCpicFDJYBfTXocvcCTUza1OgJcWMNHQ8Wtx0REI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB5990
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMDUvMDQvMjAyMiAxNTowNCwgQW5kcmV3IEx1bm4gd3JvdGU6DQo+IEVYVEVSTkFMIEVNQUlM
OiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1bmxlc3MgeW91IGtub3cg
dGhlIGNvbnRlbnQgaXMgc2FmZQ0KPiANCj4+IFsgMi44MTg4OTRdIG1hY2IgMjAxMTIwMDAuZXRo
ZXJuZXQgZXRoMDogUEhZIFsyMDExMjAwMC5ldGhlcm5ldC1mZmZmZmZmZjowOV0gZHJpdmVyIFtH
ZW5lcmljIFBIWV0gKGlycT1QT0xMKQ0KPj4gWyAyLjgyODkxNV0gbWFjYiAyMDExMjAwMC5ldGhl
cm5ldCBldGgwOiBjb25maWd1cmluZyBmb3IgcGh5L3NnbWlpIGxpbmsgbW9kZQ0KPj4gWzExLjA0
NTQxMV0gbWFjYiAyMDExMjAwMC5ldGhlcm5ldCBldGgwOiBMaW5rIGlzIFVwIC0gMUdicHMvRnVs
bCAtIGZsb3cgY29udHJvbCBvZmYNCj4+IFsxMS4wNTMyNDddIElQdjY6IEFERFJDT05GKE5FVERF
Vl9DSEFOR0UpOiBldGgwOiBsaW5rIGJlY29tZXMgcmVhZHkNCj4gDQo+IFlvdSBoYXZlIGEgbXVs
dGktcGFydCBsaW5rLiBZb3UgbmVlZCB0aGF0IHRoZSBQSFkgcmVwb3J0cyB0aGUgbGluZQ0KPiBz
aWRlIGlzIHVwLiBQdXQgc29tZSBwcmludGsgaW4gZ2VucGh5X3VwZGF0ZV9saW5rKCkgYW5kIGxv
b2sgYXQNCj4gcGh5ZGV2LT5saW5rLiBZb3UgYWxzbyBuZWVkIHRoYXQgdGhlIFNHTUlJIGxpbmsg
YmV0d2VlbiB0aGUgUEhZIGFuZA0KPiB0aGUgU29DIGlzIHVwLiBUaGF0IGlzIGEgYml0IGhhcmRl
ciB0byBzZWUsIGJ1dCB0cnkgYWRkaW5nICNkZWZpbmUNCj4gREVCVUcgYXQgdGhlIHRvcCBvZiBw
aHlsaW5rLmMgYW5kIHBoeS5jIHNvIHlvdSBnZXQgYWRkaXRpb25hbCBkZWJ1Zw0KPiBwcmludHMg
Zm9yIHRoZSBzdGF0ZSBtYWNoaW5lcy4NCg0KVHJhY2tlZCB0aGUgc3RhdGUgb2YgcGh5ZGV2LT5s
aW5rIGluIGdlbnBoeV91cGRhdGVfbGluaywgbmV2ZXIgc2F3IGENCnZhbHVlIG90aGVyIHRoYW4g
MC4NCg0KVXNpbmcgdGhlIGRlYnVnIHByaW50cyBpbiBwaHlsaW5rLmMgSSBnb3QgdGhlIGZvbGxv
d2luZzoNClsgICAgMy4yMzAzNjRdIG1hY2IgMjAxMTIwMDAuZXRoZXJuZXQgZXRoMDogUEhZIFsy
MDExMjAwMC5ldGhlcm5ldC1mZmZmZmZmZjowOV0gZHJpdmVyIFtWaXRlc3NlIFZTQzg2NjJdIChp
cnE9UE9MTCkNClsgICAgMy4yNDA2ODJdIG1hY2IgMjAxMTIwMDAuZXRoZXJuZXQgZXRoMDogcGh5
OiBzZ21paSBzZXR0aW5nIHN1cHBvcnRlZCAwMDAwMDAwLDAwMDAwMDAwLDAwMDA0MmZmIGFkdmVy
dGlzaW5nIDAwMDAwMDAsMDAwMDAwMDAsMDAwMDQyZmYNClsgICAgMy4yNTI3ODNdIG1hY2IgMjAx
MTIwMDAuZXRoZXJuZXQgZXRoMDogY29uZmlndXJpbmcgZm9yIHBoeS9zZ21paSBsaW5rIG1vZGUN
ClsgICAgMy4yNTk4OTJdIG1hY2IgMjAxMTIwMDAuZXRoZXJuZXQgZXRoMDogbWFqb3IgY29uZmln
IHNnbWlpDQpbICAgIDMuMjY1NTI2XSBtYWNiIDIwMTEyMDAwLmV0aGVybmV0IGV0aDA6IHBoeWxp
bmtfbWFjX2NvbmZpZzogbW9kZT1waHkvc2dtaWkvVW5rbm93bi9Vbmtub3duIGFkdj0wMDAwMDAw
LDAwMDAwMDAwLDAwMDAwMDAwIHBhdXNlPTAwIGxpbms9MCBhbj0wDQpbICAgIDMuMjc5MjQ5XSBt
YWNiIDIwMTEyMDAwLmV0aGVybmV0IGV0aDA6IHBoeSBsaW5rIGRvd24gc2dtaWkvVW5rbm93bi9V
bmtub3duL29mZg0KDQpJIGNvdWxkbid0IHNlZSBhbnkgcHJpbnRzIG91dCBvZiBwaHkuYw0KDQpU
aGFua3MsDQpDb25vci4NCg0K
