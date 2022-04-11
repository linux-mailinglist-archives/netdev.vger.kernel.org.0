Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 859374FB653
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 10:49:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233675AbiDKIvg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 04:51:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231551AbiDKIvd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 04:51:33 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FBE02FB;
        Mon, 11 Apr 2022 01:49:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1649666958; x=1681202958;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=jUtsiD+dLo+EUK2Ytzy13SlEXBaY3ZBGSL1rNBLDxkY=;
  b=Fk1ChSE3vpRw4dCzfx03wr2bHCMSYgqT0WA70GagYAC1qOjvozIW/Jib
   qWGfDWDeBbdthuQEfuQ2Wr11zjWq2IcDm/bKYyy+UsOhmcrn8RgefN4vC
   qZIsxE83x0eHJxiTOwoSHNtF9J2+cOkoEkkz/2T1WcUQ/axEqs4qoGPMv
   eAIjG5tqEYHJQo36m36oy2wwcWqmiNksRQnEqrU4F/fq4/c3j6CNXy5l8
   7gswWfu9zRTpKbsZKy2OTlgG6AJ4PdAuDvYIol0VFBPq1ksB/Be/QGXVf
   7igj5NSwJgE4n/rPMVI3wawQqO0KpB9FBTJAbEORZ0TQNii9RMOzUJ2eI
   w==;
X-IronPort-AV: E=Sophos;i="5.90,251,1643698800"; 
   d="scan'208";a="169149063"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 11 Apr 2022 01:49:18 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 11 Apr 2022 01:49:19 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17 via Frontend Transport; Mon, 11 Apr 2022 01:49:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fy5DIlcZOG/us5AwZKA2RFL+GriI9PNImR64EU2zXEPuB24yhPnUvytw9QnZfc8v0VY/Auts6ihMn3iiBj7Ib2L4jOJHQjkl61zC9GPcnev07iQQCUNeFHs9bYIomiMUHLlo6UuE1aK9A/sNTGJkd+dL15WHSEiWLhK8RtLKnpslPCOTb77vcLBePe1VO2pdMGrM21IWjGFZnw6zZ/ZfjZKWVZk6izcopQIxNkm5s+DIr+hy0f3QOrOhWRIb35F1U+eCzDxYj57NbkADmVWRVrN7oWeENJ51Zb1BRMsSkW+zBriDoZC1Ok5He6dfVab4+t8iNX2K+6PW8ngY7mlC0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jUtsiD+dLo+EUK2Ytzy13SlEXBaY3ZBGSL1rNBLDxkY=;
 b=Kji4BIX4WrmvS2mVL2NeSpteSCdY030JeAjykqU+FdHBk5pYoZtAKfSn88/XOgy1UXB/WQHOlBaEUu1scq7shJop7u0Q1SQPEoTHw/Df78HYk73Plm6hwcDUsAvn3AsvGfn+KokflHf/44i3lYWuXT62eD7ITD/VJNqiFt3KGi07heLJjLSFDzLZKu3VFltdlGCUqQxxFNZ2fY/i2gScy1JrbrZZp9KI0uAbWPySBMLPGisqdOunKj4NIuEM9yIU1HbyjlIZ9mTRoUYETGhaAtNAwfplG1pcwyk/OQJiNiyAlu8xu8PfIExlmgZv5XQ+UFgruV8HTyn3JOXU50uwjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jUtsiD+dLo+EUK2Ytzy13SlEXBaY3ZBGSL1rNBLDxkY=;
 b=EhksiI2LLuAOQr7u9yZEDoEPe3cLu7VlWC8UrwCbuHLlq69NRHA4oKEvKx0IFpydPo5THDN1qIvBzYQxF9st2Nt2YtfUcbFZMUCFVeEFpar7mU9yshydxK+eLZbPYxoN8RjDqie+aA6Id8VOsH1ZXzLRtulCStjdZvDKD9lBmVE=
Received: from CO1PR11MB4769.namprd11.prod.outlook.com (2603:10b6:303:91::21)
 by SJ0PR11MB5071.namprd11.prod.outlook.com (2603:10b6:a03:2d7::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Mon, 11 Apr
 2022 08:49:15 +0000
Received: from CO1PR11MB4769.namprd11.prod.outlook.com
 ([fe80::6d66:3f1d:7b05:660b]) by CO1PR11MB4769.namprd11.prod.outlook.com
 ([fe80::6d66:3f1d:7b05:660b%7]) with mapi id 15.20.5144.029; Mon, 11 Apr 2022
 08:49:15 +0000
From:   <Claudiu.Beznea@microchip.com>
To:     <cgel.zte@gmail.com>, <Nicolas.Ferre@microchip.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <chi.minghao@zte.com.cn>, <zealci@zte.com.cn>
Subject: Re: [PATCH] net/cadence: using pm_runtime_resume_and_get instead of
 pm_runtime_get_sync
Thread-Topic: [PATCH] net/cadence: using pm_runtime_resume_and_get instead of
 pm_runtime_get_sync
Thread-Index: AQHYTYEFxygaIkuiYU2BmqtwKPlZCA==
Date:   Mon, 11 Apr 2022 08:49:15 +0000
Message-ID: <8c0dfbb6-978b-2d57-ba7d-c891a617558a@microchip.com>
References: <20220411013812.2517212-1-chi.minghao@zte.com.cn>
In-Reply-To: <20220411013812.2517212-1-chi.minghao@zte.com.cn>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: eb1d60ca-fb6a-4c3d-bf51-08da1b98284d
x-ms-traffictypediagnostic: SJ0PR11MB5071:EE_
x-microsoft-antispam-prvs: <SJ0PR11MB5071BFD91B3F4AB7FB87A65887EA9@SJ0PR11MB5071.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sr0ZtMXATCAerbt2O7lzByOkg3bSgjssIMMbeplY+Ej91PzM7ZrkXJ6rj4Xw1d5lBIVqL2ZxWMB4P27icYC/bCh1eZWmoNJazxO+I/gJGgaxCtJYUdqmY0XuI47mc9KJcGiz4zBPJUs2mE3+y5KnwoO0aW13D2XoZV1z63CsWDPxAnmBPtoGtfXuaiX8PWmzTPDZER93w+9uMyEPHoVCn1X9wo+iqsOptiKfYKzQSaSLyu24e5WeOiJOQRVNuarioR6cSPZL7KKnGHmoWwGvrTs7lPpY3aH9XPuxthppjwJabXtnldC5Ksbv2IiW81E5SZevjhnLjnqEPa6cx2mIFM8xob5HdwbRmaQ4qT/o19pnnw9mHQTDWFINNjVypcPu590Ex3i8TTAi8ucBj2O5j6tKelxYFJhrAmYb3CauqsB2SRGJferebbcndEO4fptx6UZZW/NCPSH8bxcrydJ7qISMu80piD2Ud/J7vIVH6JAJJukaFmNHXudY4uNFL78B0j6zuArRMpZyXypaLTzW1LlC+BoK2aIC9l8YPANfn0k3qGMH+UVdGG/fzGKkMyDGzSN6FwUbLq7gtH7sVw9mXZQlCFSriaJaUi37vkIWh7ZCE6wqCW/IymGDPXHj/gsfCm8v2oV/FDQQR+eaaO0HB83Ed9iROXihflFoXqQeQDj6E9bRGqyG6SeFnX2HY9vusH//I4fWctk6lm77mj9UEhHAenDw4jeWArF4NU8TCfoA7/FnbDbKBoV9cOqOF+SsmjjB7KDan3qONWcYOpJZoQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4769.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(186003)(83380400001)(26005)(31696002)(86362001)(31686004)(2906002)(2616005)(8936002)(36756003)(53546011)(6512007)(6506007)(8676002)(5660300002)(6486002)(71200400001)(38070700005)(66946007)(91956017)(66446008)(76116006)(4326008)(38100700002)(316002)(6636002)(122000001)(64756008)(66476007)(66556008)(54906003)(110136005)(508600001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?U01OQzRLeCtEQnRJa2I3M005ZXBTVEFhMW53eVV0QVpsVzE3TEJCNElocjY5?=
 =?utf-8?B?YnoydFVObHFENFZKeHV3c2tKb3hSZ3VCK0IvVlhUYzg1Zlk2WHluTjM1SU9Q?=
 =?utf-8?B?RUkyOWNtVVBtUzhWSEsvditWQi9nNS91OE1zTXlOUG8rWmhmeHZzZkdyODg1?=
 =?utf-8?B?NzhsUENISUpFQlNPTkRVYlM4a0hFdy9YZFBjeUEwMXgyNmN4bVg3ZCt5SG9S?=
 =?utf-8?B?ZUdiWExrMjFvbVpkZHpTOFQ5bi9GTmNCWFJPMTZkYWo1ZXEyVkh0ZVAwS3VJ?=
 =?utf-8?B?V3lmcTV1SzhFVTA2Qk93WEtEck5uUzZucGRjT1d4ZEJzMEtiNlFLa284Q0Uv?=
 =?utf-8?B?ejk4bUZnR2FUaUcyYzFCVGw0RVphZWpIdXZyc2JrOHd1QkU0bjF3OGVuakJH?=
 =?utf-8?B?bENWaWU5VHpLRVRoRWl2OG5OTWw4M1FOUTRBRnVZOFh0ZDVJak1hRTNrRFFH?=
 =?utf-8?B?djBDYWprOGoxc2hxWm5PQm9wYmsvV21IdWUwRmZNVmRuTGh5aTlXN3QyZmxs?=
 =?utf-8?B?YlE1SWUvLzFPMTY4aEUxdWZyYy95TDYxd3prMkVSOEpxak1XNS9ieVhrbEd5?=
 =?utf-8?B?aVFtUmtlcUxjQmtjdmZEeEpJN21jZG1BQStwSDI3eDN6TXF4a3kyQnhSclVV?=
 =?utf-8?B?RElYWTBMVTVCMk5TRkVLczcvdi9Vdzl0eVFlRjFrMWlwNlJOMG5Hc3RKczA1?=
 =?utf-8?B?MlVZdUhCbzhLYUtHb1JPN0Q1ZmtqbHhPbk9XMzFKblVtYm1VaVFLMDlQQzlE?=
 =?utf-8?B?Wm02VC9jK3A2WVhhL2JQc0VTV0hwK2FaTWFNNkpmemd3VUc0Mk9temtYc1lH?=
 =?utf-8?B?SHhvcW02QnN1OWhGelA5VTJneDBnWVRhbEs3MkVWaENaTHRVWnAzWTdiQmha?=
 =?utf-8?B?RVoyUkFsMlZKdDhyUHpNN0dlWXN0YXcvWlZmV1d0YWFzbnpOVkZxd1Boc1BH?=
 =?utf-8?B?cGpwUklNZGliVEtXKzJlaytBZkRxSHBBeW5LU2kwTUthbDlLTzFVclFCRkQ3?=
 =?utf-8?B?MXVkMHNadmlxU0lVUVYzbDNMV0U1eHNwN3hQcTlPS1BVVTQ4bWd5UmRkYXhm?=
 =?utf-8?B?YjMyRVdFcTVFbXJHZ1pDVW13R2U1WnQzNFF4WUlPTWtiRFJQY3hGTk4rN3hD?=
 =?utf-8?B?U3dnd0J2TUVjWXhNNVJqbm1lc3BJSlpLeWZYMlgzbEFYS1dSaXhRV0h4K3Rx?=
 =?utf-8?B?UUp2d3NnMWljejBxWUdzbmdGU001UXVXa25GaGlQQ0NJcDJyRVdab0ZDbjlE?=
 =?utf-8?B?M3hqemtQTmtvcG1oUzJyVldCem50MkR6aG53c3RXbGhXK000ZEdTekI2WlZ3?=
 =?utf-8?B?dVBIejBMSGVIYXRSUmlDM3hKdFNPOXUvOGhXaTIzZnFaUDVEdy96blV5TXFO?=
 =?utf-8?B?MzN4SG4wcUxiRVd4SmVNZXlrbDFTNE52NlFmQklrOGhzN1pYdkIzM29aRGZ2?=
 =?utf-8?B?RnZKWUZVdU9rdUthYVFrLzh4OEV5aEwxdE5JQ0RBNWVZZTdHcFpyVW5pS3FU?=
 =?utf-8?B?YjJPdVI1b3JRbE4wRGd1VUI5Slo0RkhKYzZtOTlremFDQU85aXh2RUJ2SFhL?=
 =?utf-8?B?eXQzdTNkN243UmVsZ1c4R25iclppTWJpOGNzT1JDWGZ1aEFCL3k4QjQ4UHlv?=
 =?utf-8?B?MnBnQ2JtK2NhZEhkdkVwazg3cm9NZ1dsMUU5cHQrbjFSVGVIQWc2Q1RScmEr?=
 =?utf-8?B?cmRUK0hLSVJyOG1TYmpKVnlpenI3VDBLSVlxVCttSVR3elJjSHpyZzM3L2FH?=
 =?utf-8?B?Qk80b2k0OGszM1kzWURHendkbUdzRTVoZW81SHJWMDJySFFISnNSTXJxa0Uv?=
 =?utf-8?B?WjgyejdXUlN3a1hEZ0tsOTZndndIYTdCZ09JRFNqei9zUHM0TnVnRUd5OU04?=
 =?utf-8?B?K0h2akdlMG80OVpOZ2k5NTFuSi9xZTg3K1pzNXplQ21DRUc2a3NCOWNBQzVN?=
 =?utf-8?B?MDE4bzdUNklHeUNWUUpHaW9Gc09FbHhMMkd5akR5cXJSdUlia2hFOGQrb1Rj?=
 =?utf-8?B?L1NiMWpHOHluODJObnlYTjZndmNRTWYyTHZRc3drdVZzOWR0M2NYNFcrZHhu?=
 =?utf-8?B?b0xla2k2eWJva0Vaa1BhcVFhSWpZWnlJUzZrR1NTNC90d1N0UVJ1SDdtd3Rw?=
 =?utf-8?B?YWpVVXBKZ3YxbTE2aWlwWkFKYk10QXBUWXVONStrZXhScHF2Qlc4ckJZSmxE?=
 =?utf-8?B?RXQ5ZFBWQzhOOEJwL05OMXE2OFFtMVJ4TllyZkRic0RPOXcwSFF3U1dIbEVs?=
 =?utf-8?B?cTlNS1d1UnBPMnZZZEQzV3c4c2lXOTZ1NTFKbS9qa2Zmc0JYNC9XSXlSOTNJ?=
 =?utf-8?B?c294UVdldFZMbUc0OUxMN09ib0ViVWd6R25yMFhab3Q5NGdISVVwRTB5cC85?=
 =?utf-8?Q?VvVflj29MVX58YIA=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <84BE30CB5DA9AF46B64D0B8CE1FADBAF@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4769.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb1d60ca-fb6a-4c3d-bf51-08da1b98284d
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Apr 2022 08:49:15.0873
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nvKZ5N4T/iZfiQAsRqnTixSixk2jnmpd9r15+mZEHZ6RVBY+lFf0TJVvgan6vUfvigIyTrR4/99PgFfCHAyg+03waP6xVmkWsQ1iohuk2YM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5071
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTEuMDQuMjAyMiAwNDozOCwgY2dlbC56dGVAZ21haWwuY29tIHdyb3RlOg0KPiBFWFRFUk5B
TCBFTUFJTDogRG8gbm90IGNsaWNrIGxpbmtzIG9yIG9wZW4gYXR0YWNobWVudHMgdW5sZXNzIHlv
dSBrbm93IHRoZSBjb250ZW50IGlzIHNhZmUNCj4gDQo+IEZyb206IE1pbmdoYW8gQ2hpIDxjaGku
bWluZ2hhb0B6dGUuY29tLmNuPg0KPiANCj4gVXNpbmcgcG1fcnVudGltZV9yZXN1bWVfYW5kX2dl
dCBpcyBtb3JlIGFwcHJvcHJpYXRlDQo+IGZvciBzaW1wbGlmaW5nIGNvZGUNCj4gDQo+IFJlcG9y
dGVkLWJ5OiBaZWFsIFJvYm90IDx6ZWFsY2lAenRlLmNvbS5jbj4NCj4gU2lnbmVkLW9mZi1ieTog
TWluZ2hhbyBDaGkgPGNoaS5taW5naGFvQHp0ZS5jb20uY24+DQoNClJldmlld2VkLWJ5OiBDbGF1
ZGl1IEJlem5lYSA8Y2xhdWRpdS5iZXpuZWFAbWljcm9jaGlwLmNvbT4NCg0KDQo+IC0tLQ0KPiAg
ZHJpdmVycy9uZXQvZXRoZXJuZXQvY2FkZW5jZS9tYWNiX21haW4uYyB8IDIyICsrKysrKysrLS0t
LS0tLS0tLS0tLS0NCj4gIDEgZmlsZSBjaGFuZ2VkLCA4IGluc2VydGlvbnMoKyksIDE0IGRlbGV0
aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2NhZGVuY2Uv
bWFjYl9tYWluLmMgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9jYWRlbmNlL21hY2JfbWFpbi5jDQo+
IGluZGV4IDgwMGQ1Y2VkNTgwMC4uNTU1NWRhZWU2ZjEzIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJz
L25ldC9ldGhlcm5ldC9jYWRlbmNlL21hY2JfbWFpbi5jDQo+ICsrKyBiL2RyaXZlcnMvbmV0L2V0
aGVybmV0L2NhZGVuY2UvbWFjYl9tYWluLmMNCj4gQEAgLTMzNywxMSArMzM3LDkgQEAgc3RhdGlj
IGludCBtYWNiX21kaW9fcmVhZChzdHJ1Y3QgbWlpX2J1cyAqYnVzLCBpbnQgbWlpX2lkLCBpbnQg
cmVnbnVtKQ0KPiAgICAgICAgIHN0cnVjdCBtYWNiICpicCA9IGJ1cy0+cHJpdjsNCj4gICAgICAg
ICBpbnQgc3RhdHVzOw0KPiANCj4gLSAgICAgICBzdGF0dXMgPSBwbV9ydW50aW1lX2dldF9zeW5j
KCZicC0+cGRldi0+ZGV2KTsNCj4gLSAgICAgICBpZiAoc3RhdHVzIDwgMCkgew0KPiAtICAgICAg
ICAgICAgICAgcG1fcnVudGltZV9wdXRfbm9pZGxlKCZicC0+cGRldi0+ZGV2KTsNCj4gKyAgICAg
ICBzdGF0dXMgPSBwbV9ydW50aW1lX3Jlc3VtZV9hbmRfZ2V0KCZicC0+cGRldi0+ZGV2KTsNCj4g
KyAgICAgICBpZiAoc3RhdHVzIDwgMCkNCj4gICAgICAgICAgICAgICAgIGdvdG8gbWRpb19wbV9l
eGl0Ow0KPiAtICAgICAgIH0NCj4gDQo+ICAgICAgICAgc3RhdHVzID0gbWFjYl9tZGlvX3dhaXRf
Zm9yX2lkbGUoYnApOw0KPiAgICAgICAgIGlmIChzdGF0dXMgPCAwKQ0KPiBAQCAtMzkxLDExICsz
ODksOSBAQCBzdGF0aWMgaW50IG1hY2JfbWRpb193cml0ZShzdHJ1Y3QgbWlpX2J1cyAqYnVzLCBp
bnQgbWlpX2lkLCBpbnQgcmVnbnVtLA0KPiAgICAgICAgIHN0cnVjdCBtYWNiICpicCA9IGJ1cy0+
cHJpdjsNCj4gICAgICAgICBpbnQgc3RhdHVzOw0KPiANCj4gLSAgICAgICBzdGF0dXMgPSBwbV9y
dW50aW1lX2dldF9zeW5jKCZicC0+cGRldi0+ZGV2KTsNCj4gLSAgICAgICBpZiAoc3RhdHVzIDwg
MCkgew0KPiAtICAgICAgICAgICAgICAgcG1fcnVudGltZV9wdXRfbm9pZGxlKCZicC0+cGRldi0+
ZGV2KTsNCj4gKyAgICAgICBzdGF0dXMgPSBwbV9ydW50aW1lX3Jlc3VtZV9hbmRfZ2V0KCZicC0+
cGRldi0+ZGV2KTsNCj4gKyAgICAgICBpZiAoc3RhdHVzIDwgMCkNCj4gICAgICAgICAgICAgICAg
IGdvdG8gbWRpb19wbV9leGl0Ow0KPiAtICAgICAgIH0NCj4gDQo+ICAgICAgICAgc3RhdHVzID0g
bWFjYl9tZGlvX3dhaXRfZm9yX2lkbGUoYnApOw0KPiAgICAgICAgIGlmIChzdGF0dXMgPCAwKQ0K
PiBAQCAtMjc0NSw5ICsyNzQxLDkgQEAgc3RhdGljIGludCBtYWNiX29wZW4oc3RydWN0IG5ldF9k
ZXZpY2UgKmRldikNCj4gDQo+ICAgICAgICAgbmV0ZGV2X2RiZyhicC0+ZGV2LCAib3BlblxuIik7
DQo+IA0KPiAtICAgICAgIGVyciA9IHBtX3J1bnRpbWVfZ2V0X3N5bmMoJmJwLT5wZGV2LT5kZXYp
Ow0KPiArICAgICAgIGVyciA9IHBtX3J1bnRpbWVfcmVzdW1lX2FuZF9nZXQoJmJwLT5wZGV2LT5k
ZXYpOw0KPiAgICAgICAgIGlmIChlcnIgPCAwKQ0KPiAtICAgICAgICAgICAgICAgZ290byBwbV9l
eGl0Ow0KPiArICAgICAgICAgICAgICAgcmV0dXJuIGVycjsNCj4gDQo+ICAgICAgICAgLyogUlgg
YnVmZmVycyBpbml0aWFsaXphdGlvbiAqLw0KPiAgICAgICAgIG1hY2JfaW5pdF9yeF9idWZmZXJf
c2l6ZShicCwgYnVmc3opOw0KPiBAQCAtNDEzNCwxMSArNDEzMCw5IEBAIHN0YXRpYyBpbnQgYXQ5
MWV0aGVyX29wZW4oc3RydWN0IG5ldF9kZXZpY2UgKmRldikNCj4gICAgICAgICB1MzIgY3RsOw0K
PiAgICAgICAgIGludCByZXQ7DQo+IA0KPiAtICAgICAgIHJldCA9IHBtX3J1bnRpbWVfZ2V0X3N5
bmMoJmxwLT5wZGV2LT5kZXYpOw0KPiAtICAgICAgIGlmIChyZXQgPCAwKSB7DQo+IC0gICAgICAg
ICAgICAgICBwbV9ydW50aW1lX3B1dF9ub2lkbGUoJmxwLT5wZGV2LT5kZXYpOw0KPiArICAgICAg
IHJldCA9IHBtX3J1bnRpbWVfcmVzdW1lX2FuZF9nZXQoJmxwLT5wZGV2LT5kZXYpOw0KPiArICAg
ICAgIGlmIChyZXQgPCAwKQ0KPiAgICAgICAgICAgICAgICAgcmV0dXJuIHJldDsNCj4gLSAgICAg
ICB9DQo+IA0KPiAgICAgICAgIC8qIENsZWFyIGludGVybmFsIHN0YXRpc3RpY3MgKi8NCj4gICAg
ICAgICBjdGwgPSBtYWNiX3JlYWRsKGxwLCBOQ1IpOw0KPiAtLQ0KPiAyLjI1LjENCj4gDQoNCg==
