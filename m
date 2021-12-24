Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97C9647F019
	for <lists+netdev@lfdr.de>; Fri, 24 Dec 2021 17:21:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344001AbhLXQVF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Dec 2021 11:21:05 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:26492 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230213AbhLXQVE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Dec 2021 11:21:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1640362865; x=1671898865;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=oh3UbPOOUC1FU1QLh3SyCsaEStERdl1W8jKTrwPbYU0=;
  b=oaPW7rV4CbWDM2F/85yOS3SittUgNtxmGiUbvOtWInrfyXo8ug9CH0D8
   ltuAmUPso3Y+WbuTe7aAcdJtyg/udn7cJZymcIVERtJ9CkYFVxhLCx83R
   gxBqDcm2bBALm2oujtLIspJyEO83J6rdas2vZHnk34O7kTaQ213ZLDXuO
   XzgnRjKvAvN/EswtdYiHavMVozPZf+upPj7vuTncCJbPKPvi5n/9zTMJS
   7iUGlEgon9dy/uR94FrFdj3FDqjbXIQqZIyaUp4RXVA7CJSTEYtoC0vY6
   13rSIrduSNLuf9G4jhAcWYEnO1zmXIZwwBzX6VLetIFw4Jpl364l11n9x
   Q==;
IronPort-SDR: 3VCP9NqSa85Ebkka/V1M1RNfwkoA1ZZZa5eQZR9XL2rdrflDLz9Qhm6c9s9/L39DLiBOsqW3QL
 4tpKiaFLHwziLO+Fo7LwyvX4p6yWW9ACISMSEccFtIXd1N0LCXUlBneIv0FZGyAbi+uTErtPjy
 QtlK9rvbBp7L5PS+49I9QIQ0tyV8iyQBjbSdcUFjkjeNN8Sri14/JJuGmbvE9fOcsFCyMsO/Yh
 9yF85DbF9MA4Ca1XjvUVlAsBJ2EL0v2KRmcosaGqp/rwBy49LjqJCLOE8GNeUIL64CFiRH2Ir4
 t1BayRYZI66n0RuHTlzW8wTB
X-IronPort-AV: E=Sophos;i="5.88,233,1635231600"; 
   d="scan'208";a="147709838"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 Dec 2021 09:21:04 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 24 Dec 2021 09:21:01 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17 via Frontend Transport; Fri, 24 Dec 2021 09:21:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dw+QSb55JxqrAzJ/ZeunlT/sZhbCiXIzV1y+3ypAjqz2DRkqVPZ72AKJEH0QNX1OnF8868Zn4+ZqPC9bOnJpXiXktYw4pmCauZhXIe09wdhacwM7mU9+mVfTqzLFw/Virb5Ujf53R9F5pjottFKOFBJ5YQF2T8n/hldYyhIHCAyUyPFz8cdzkJDOPJR1nfBjccxyYWrIk+AgfuOvmU8qS03BjzNz0C36reMDZ/rc5sUs4tKQCcvOvi+nirBWsLtiZ8CFbMBQgBGSmCosVTdgfN3KwLg5ShZOON0A5LNRqGklczfmEEXUUDUvjtE5FptChsdhVaseefuTKtr6erZEtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oh3UbPOOUC1FU1QLh3SyCsaEStERdl1W8jKTrwPbYU0=;
 b=V0Y9YVs/Mtu8lbrkf5SDn9cxr0TyrAVUXGjjkDyKkmWJshVQu/XqmMhNMQ6MmZpGGernUpiQhKP+VCad/W/vwKanhXCjmM805NOfUMhW1s/x1rN5DR5FpRzB9Z00L/yX2T8ZAvwa2joc15ICFXz8HfB8A1kgOvKgSc+R3NAK0t94dD7C7V6rOgmDED7cT80HQ0T9o5eoczFq2/wfSM6W96oUnpoC/v+JyTtL33zronrxYCSnBrXdmURYSUCVW7jr2gHI+pVz3hUFpx7YecWRqw7caQiUScj/UfC1a2MVbFbTgS7H7xQvrHpDPmYiBIgqq716+hbBycAA/m8qpbWjkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oh3UbPOOUC1FU1QLh3SyCsaEStERdl1W8jKTrwPbYU0=;
 b=j2cQmpzuQNHMCeComlFxt/9lBu3wovhytEQmiEE01cPIScFr78MQMUjH6WmOg575uOmqArQd+sKnw2gpoeKvm54GxbK+Nxj7VlUQ2YrplRl1Gy5BSrxY4rmXti/mSkUW8xnfKCxJCrOodJB2xp/kQitW/bMow+o3EexJqF762tM=
Received: from SJ0PR11MB4943.namprd11.prod.outlook.com (2603:10b6:a03:2ad::17)
 by SJ0PR11MB5055.namprd11.prod.outlook.com (2603:10b6:a03:2d9::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.19; Fri, 24 Dec
 2021 16:20:50 +0000
Received: from SJ0PR11MB4943.namprd11.prod.outlook.com
 ([fe80::b481:2fde:536c:20a0]) by SJ0PR11MB4943.namprd11.prod.outlook.com
 ([fe80::b481:2fde:536c:20a0%7]) with mapi id 15.20.4823.021; Fri, 24 Dec 2021
 16:20:50 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <davidm@egauge.net>
CC:     <Claudiu.Beznea@microchip.com>, <kvalo@codeaurora.org>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] wilc1000: Allow setting power_save before driver is
 initialized
Thread-Topic: [PATCH] wilc1000: Allow setting power_save before driver is
 initialized
Thread-Index: AQHX7vY41SO9kv5AqUyGJ0KZeSsN26wvXkCAgAQrkYCAARZfgIAAe9uAgAApvQCACue4gIAAM9oAgAGFJwA=
Date:   Fri, 24 Dec 2021 16:20:50 +0000
Message-ID: <9272b86e-61ab-1c25-0efb-3cdd2c590db8@microchip.com>
References: <20211212011835.3719001-1-davidm@egauge.net>
 <6fc9f00aa0b0867029fb6406a55c1e72d4c13af6.camel@egauge.net>
 <5378e756-8173-4c63-1f0d-e5836b235a48@microchip.com>
 <31d5e7447e4574d0fcfc46019d7ca96a3db4ecb6.camel@egauge.net>
 <49a5456d-6a63-652e-d356-9678f6a9b266@microchip.com>
 <523698d845e0b235e4cbb2a0f3cfaa0f5ed98ec0.camel@egauge.net>
 <122f79b7-7936-325c-b2d9-e15db6642d0f@microchip.com>
 <be3c95c8310504222e88c602a937b7f05cc01286.camel@egauge.net>
In-Reply-To: <be3c95c8310504222e88c602a937b7f05cc01286.camel@egauge.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 867b34b9-db4f-4601-f34f-08d9c6f959d1
x-ms-traffictypediagnostic: SJ0PR11MB5055:EE_
x-microsoft-antispam-prvs: <SJ0PR11MB5055476CA6115072D8511C91E37F9@SJ0PR11MB5055.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Mp/Z32HJdQ4yQrvmWWT6AfsQtc1oaEb+A37x5apHAv8CB8W7LTlH0jBrRCbtTdpqvhT4PDVvBgigdotSG4wm+TBnlN4vSIMZXYrxITHDN3huwx4vbQ3ej9wiCqmi3gEvwiA9pYau/7/BcB7Oq5RiWbzvlqxLj7EN/YRSbkvu9H339XhmPbN9Gy9ON4lr8+L506T2x3Y90BjFCoGbacHI7AAdo2vOpswF9+BxCGHUi5YEZ7ffMlCTMU9IrdQuzOhuchIlmSKzuBh9gjuWFMGDIG5MfDtAloiD/qPOQ9izwDXWHGgl0eGd/v4pYCYg+qTXiSM6Bhjwi/gbBOJPdW6rNxJeDvIGm23pjsMvE8STvtw8vmZLargSMutzuMU7A81240XvgGJ/rbaaIIJ5bH4uoLoR0jxrBLNxog65qR+aysQU3SXyoRy0YxyulNQ120fUa89q5/3mHo69XvnIg/f11ZpY/vwTOWlSyxhu58H091pMzfMiikQ7Yz0ZMBK4fKa7+Raxq4RzwqSDnPICV9tFBLK5qbY4mze1n3DcO+lKUjMXplqXQnfnH4KPqwrug2q2RfSQ8pPE+ksLjfzPqHDqmJDEOrBxNr+DG2nV7RbxgyhcG7q/JEdWPQvGOQ10uqtHTN9UfeqdZ0x9lFJbAi+lrytHTURP/R2CV0ssDWrd8g+k7B7cutbAYQ5Nymy1WXAUeB37aeWvdr7C80NhO2kY9RRU5BTNAyBTyL8yO0GSrpNje1nFQpeH3Q5R7H/13K6e4rma/SITv1L3YZQazshRxcpsm+tbsA1KLGrBWIReSQrZeSnCvgqwjGqG3Fi8R82swHWp2sEnaXEinropMhUleONaIl03FXxNtKM5OHt/ZOQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB4943.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(186003)(66476007)(6486002)(8676002)(36756003)(53546011)(6506007)(2616005)(55236004)(26005)(66946007)(76116006)(86362001)(91956017)(966005)(66446008)(64756008)(66556008)(71200400001)(31686004)(6916009)(508600001)(316002)(4326008)(6512007)(54906003)(66574015)(83380400001)(5660300002)(38100700002)(122000001)(8936002)(31696002)(2906002)(4001150100001)(38070700005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Qm9NT20zcFpHdXdiVS9JSVV5MXRTanBtemoyQVI3bEpLdkwzdXVDc0hwOUVM?=
 =?utf-8?B?T1N4Tzh2eUo4K1BSQU1Ia0NRY3lSUmdNekV0TlNpdXhDQnA5b0dxT0xtSDJH?=
 =?utf-8?B?S0l2MTIwUjMyalNnUXJ2VFJnNGh3UElOa2I0TVZlOUpEb2E0cEVNNVVZYnFK?=
 =?utf-8?B?SGtzalpUTFFFdWFMenVGYnRIYlRreTlPVjhIV1lnNi8yMjZUMmRyUkxxTnVZ?=
 =?utf-8?B?enJlczFLZVBBNDcrUTBoSDAyOS81dURTMTUySGkxNWxwU0tSYnBsNmRGVmM4?=
 =?utf-8?B?ZkJMbTF2b0EranNtd08yTDZTTk9nWVZMaTlQNkF1ZzRwa2MxQnVvdEthT1A3?=
 =?utf-8?B?c3NXY3I2eEpqTXhqVnFhemd0Yko3aWdtTkxyU2RNZzRtSlN0cUN1T2doU0Fy?=
 =?utf-8?B?YjAwaDJVR2MyZ3V5RGd2cFpSMkY1WFRwTTF2Rk94QlFXOURPR3FuVmVHcklE?=
 =?utf-8?B?ejhEaEVBbzJCdkF1WDVrZFBSRjBmYk9EVjBVTVlBaGNDUHhZamttT2l1WVl5?=
 =?utf-8?B?c1lzYjZ2L044NXlIVWk2d2ZUdGZoU0FEYlhYZ2w4eU5hRFBlRGxpMlNWaTNG?=
 =?utf-8?B?dXlXMGNtamFjcnVnT0ozRXF6cjBvYkJWbTNPc2tZTmlwUDc2U2hvTzMvU0pr?=
 =?utf-8?B?YXBiVmhtTi9CUTFSTVVaMDBINFNWbXluaDlOcklCd1g2OExwWTd6cU51UFR3?=
 =?utf-8?B?K3dSczlyM2ZqYWVNaUYwYTNxdG12N1JyaDJJek83Z0MySFRmSTNoY24zTmR2?=
 =?utf-8?B?MGR6V1ZDK0lVQURUVGhjRkFHeFZRa3l6L1E5N2ZWZWdCK1ExL05nZ0E1Ri8r?=
 =?utf-8?B?WWFRT1hybytDSWd3Zk1NZXJBSzRqbEROK2tQVk1JWXBvcmRYQlRYTjVhNVlU?=
 =?utf-8?B?MUQ1V05pdGJNZnNHVkZJd2VrSkZkR3VhSnlOWXVPb1JWSDJ0bisxL0RPME1x?=
 =?utf-8?B?ekJ5SmtVbm1Mb2tRWjV0NWp5amM2ZGN3Uis0VUp5VjBGQVhxRHFDdmFPK0lG?=
 =?utf-8?B?NmRFVlkvRHpvNXdTaVBRU2lRRXVHVCtrU0hyU2xCaUtFdExTbjBSaUNNQ096?=
 =?utf-8?B?VjdxS1o1UCtmY2ZzZ3FObWFwRGs0VGt6VFZQR0d5MHM0am1QZ2l5RytGL042?=
 =?utf-8?B?TFRCZm1DeGZ3cDF5ZERuOGloTURlcnhYV1VSRjZpUEVCN0RROS9KK1h3TGdI?=
 =?utf-8?B?VzQ1WUFwZ2h1YWRRRGFRazBwdk5GNHJUa1pYYkFYV2tBV09FOTU5Kzc5V0hr?=
 =?utf-8?B?RUNGbnp2TXBDZ1NweExzUEgwai83MFB2RVhvNVpab045VVVhMjRnaW9YeUdv?=
 =?utf-8?B?SzM3dHlhU28ySlhjbTAzZTdUd21SWGE3QWlkSXNvK2RlMnM5YisrWmRTMjdp?=
 =?utf-8?B?OXlnT0syaGhsUmo4UW9tZ0hXRHdCVnVMT2tWZWFVYlcvZHNwc09nZy9LNHVX?=
 =?utf-8?B?eUZmZWUzeGIweVVhSGRMdnJ3QnFtNExVZk45SEJOTjVVaW5ZZi9JWndEQzA2?=
 =?utf-8?B?MFIwZFNXYjBxaW92NmlUUlRRRjk5cFlUYUZ2RzV3ZzNLUGJjcEY1Sm5sVDdk?=
 =?utf-8?B?emwvTTJ1OGZQdlQ0OSttaE82R2UvaW1VUDdHUTM4OVR5U29lWWVyVGtPQWNr?=
 =?utf-8?B?VVdaclAxa3dFdFZFS3Z6am5LQk1jUUZ4R2VROHNsZU5XYzhYK0dIb0FJcmZv?=
 =?utf-8?B?ci9GaUNBTW5PS05DN1h1eGtWTUo0L1pUdmpmcGJyVGh3RzBkNHBRM1dXQ0FP?=
 =?utf-8?B?WW5GNVQxN2pvTWdta2wzT2pXeVlDOHVnOUNXUkpMa1FVZytaTUYrQzA2L1Bm?=
 =?utf-8?B?NlpaMlVrTm53NkJkOCs2bXIrTjc2NG1vRlJDems2bHA0VWxRWFNrc0pYYVpN?=
 =?utf-8?B?bUF2S3BnYThCSjR5SzJqYWNoNHJmdzQ1Q1ZaNG9WQUxWQm5PMmZ5L0RaY2ln?=
 =?utf-8?B?YUt1T1RUemFWSXNkbWQvVUVNV1BXUkVzRTVMdGhFUkwvWDNXT1BkM3J4Ulp5?=
 =?utf-8?B?c3NHbVRTVHNzc3VERGtqNUV1R0FxZWpUVnErUTRUVFoxZVhWWGFaVWh4NjVk?=
 =?utf-8?B?ejB4TEp6QmpJNUJRU1k5UjhRSURabzRTTnJwN2RLS2o3V3NBRWp3MkNhRldv?=
 =?utf-8?B?dzVLbGhlSnFzNHNhbWJlQUlzQk9pbDcwQzM0MEZOSXBuc2FXMEN4Zk5ORTFG?=
 =?utf-8?B?bWZ5enFaS1JlWno4MVpIV1VpR09IdXhqSDNaUmJ1NElxVkRISmptRzhvUldM?=
 =?utf-8?B?akVPSkgyczZrOVZlZXZjTkVJSGlBPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B97223559EBDA74A98B027B1A857884D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB4943.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 867b34b9-db4f-4601-f34f-08d9c6f959d1
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Dec 2021 16:20:50.4708
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0ffwWgAQZNBNi+enJLDwv02h1omY5ND9LD2zxuw9IJJMs0g1kmAU/LTga3aXKcoZTqT5s/Ht97XF2nSpTtMQFui9yio75r++H+wiaz3qvrs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5055
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiAyMy8xMi8yMSAyMjozOCwgRGF2aWQgTW9zYmVyZ2VyLVRhbmcgd3JvdGU6DQo+IEVYVEVS
TkFMIEVNQUlMOiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1bmxlc3Mg
eW91IGtub3cgdGhlIGNvbnRlbnQgaXMgc2FmZQ0KPg0KPiBPbiBUaHUsIDIwMjEtMTItMjMgYXQg
MTQ6MDIgKzAwMDAsIEFqYXkuS2F0aGF0QG1pY3JvY2hpcC5jb20gd3JvdGU6DQo+PiBJIHZlcmlm
aWVkIHdpdGggd3BhX3N1cHBsaWNhbnQgYW5kIGl0IHNlZW1zIHRoZSBwb3dlciBzYXZlIG1vZGUg
aXMNCj4+IHdvcmtpbmcgZmluZS4gVGVzdGVkIG11bHRpcGxlIHRpbWVzIHdpdGggd3BhX3N1cHBs
aWNhbnQgcnVubmluZy4gSQ0KPj4gZGlkbid0IG9ic2VydmUgYW55IGlzc3VlIGluIGVudGVyaW5n
IG9yIGV4aXRpbmcgdGhlIHBvd2VyLXNhdmUgbW9kZSB3aXRoDQo+PiB3cGFfc3VwcGxpY2FudC4N
Cj4+DQo+PiBUcnkgdG8gdmVyaWZ5IHdpdGhvdXQgd3BhX3N1cHBsaWNhbnQgaW4geW91ciBzZXR1
cCB0byBvYnNlcnZlIGlmIHdlIGFyZQ0KPj4gc2VlaW5nIHRoaXMgc2FtZSByZXN1bHRzIGluIHRo
YXQgY2FzZS4NCj4gSXQgZG9lc24ndCBoZWxwIG1lIGlmIGl0IHdvcmtzIHdpdGhvdXQgd3BhX3N1
cHBsaWNhbnQuICBJIG5lZWQgYQ0KPiByZWxpYWJsZSB3YXkgdG8gaGF2ZSBwb3dlci1zYXZpbmdz
IG1vZGUgaW4gZWZmZWN0IHdoZW4gdXNpbmcNCj4gd3BhX3N1cHBsaWNhbnQuDQoNCg0KT2theS4g
SW4gbXkgc2V0dXAsIEkgb2JzZXJ2ZWQgdGhhdCBQUyBtb2RlIHdvcmtzIHdpdGggYW5kIHdpdGhv
dXQgDQp3cGFfc3VwcGxpY2FudC4gTm93IHRlc3RlZCBieSBmb2xsb3dpbmcgeW91ciBjb21tYW5k
IHNlcXVlbmNlLg0KDQoNCj4+IFdpdGggd3BhX3N1cHBsaWNhbnQsIHRoZSBjdXJyZW50IGNvbnN1
bXB0aW9uIGlzIGxlc3Mgd2hlbiBQUyBtb2RlIGlzDQo+PiBlbmFibGVkIGJ1dCBpdCB3b3VsZCBi
ZSBtb3JlIGNvbXBhcmVkIHRvIHdpdGhvdXQgd3BhX3N1cHBsaWNhbnQuDQo+IFRoYXQncyBub3Qg
d2hhdCBJJ20gdGFsa2luZyBhYm91dCB0aG91Z2guICBUaGUgcHJvYmxlbSBpcyB0aGF0IGl0IHNl
ZW1zDQo+IHRvIGJlIHJhdGhlciBlcnJhdGljIHdoZXRoZXIgaXNzdWluZyB0aGUgaXcgcG93ZXJf
c2F2ZSBjb21tYW5kIG1ha2VzIGENCj4gZGlmZmVyZW5jZSBpbiBwb3dlci1jb25zdW1wdGlvbi4N
Cj4NCj4gSSBmaXhlZCBteSBzZXR1cCBzbyBJIGNhbiBkaXJlY3RseSBtZWFzdXJlIHBvd2VyIGNv
bnN1bWVkIHJhdGhlciB0aGFuDQo+IGp1c3QgY3VycmVudCAocG93ZXIgZmFjdG9yIG1hdHRlcnMp
LiAgQWdhaW4sIHRoaXMgaXMgZm9yIHRoZSBlbnRpcmUNCj4gZGV2aWNlIChub3QganVzdCBXSUxD
MTAwMCkuDQo+DQo+IFdoYXQgSSBmaW5kIHRoYXQgd2hlbiBwb3dlci1zYXZpbmcgbW9kZSBpcyB3
b3JraW5nIGFzIGV4cGVjdGVkLCB0aGUNCj4gZGV2aWNlIHVzZXMgYW4gYXZlcmFnZSBvZiAxLjFX
LiAgV2hlbiBwb3dlci1zYXZpbmcgbW9kZSBpcyBub3Qgd29ya2luZywNCj4gcG93ZXIgY29uc3Vt
cHRpb24gaXMgYWJvdXQgMS40Vywgb3IgYWJvdXQgMzAwbVcgaGlnaGVyLg0KPg0KPiBJIHRyaWVk
IGFnYWluICp3aXRob3V0KiB0aGUgcGF0Y2ggYXBwbGllZCBhbmQsIGFzIGV4cGVjdGVkLCB0aGUg
cGF0Y2gNCj4gZG9lc24ndCByZWFsbHkgYWZmZWN0IHRoaXMgYmVoYXZpb3IuDQo+DQo+IEFmdGVy
IHBsYXlpbmcgd2l0aCB0aGlzIGZvciBhIHdoaWxlLCBJIHRoaW5rIEkgZm91bmQgdHdvIHNlcXVl
bmNlcyB0aGF0DQo+IHJlbGlhYmx5IHJlcHJvZHVjZSB0aGUgZGlmZmVyZW5jZS4NCj4NCj4gRmly
c3QsIG9uIGEgZnJlc2hseSBib290ZWQgc3lzdGVtIGFuZCB3aXRoIHdpbGMxMDAwLXNwaSBhdXRv
bG9hZGVkIGJ5DQo+IHRoZSBrZXJuZWwsIHRyeSB0aGlzIHNlcXVlbmNlIChjb3B5ICYgcGFzdGUg
dGhlIGNvbW1hbmRzKToNCj4NCj4gICAgIC91c3Ivc2Jpbi93cGFfc3VwcGxpY2FudCAtQnMgLWl3
bGFuMCAtYy9ldGMvd3BhX3N1cHBsaWNhbnQuY29uZg0KPiAgICAgc2xlZXAgMTANCj4gICAgIGl3
IGRldiB3bGFuMCBzZXQgcG93ZXJfc2F2ZSBvbg0KPg0KPiBUaGUgYWJvdmUgeWllbGRzIGEgcG93
ZXIgY29uc3VtcHRpb24gb2YgMS40VyByZWxpYWJseS4gIFRoZSAic2xlZXAgMTAiDQo+IGRvZXNu
J3QgbWF0dGVyIGhlcmU7IHRoZSBiZWhhdmlvciBpcyB0aGUgc2FtZSB3aXRoIG9yIHdpdGhvdXQg
aXQuICBJDQo+IHRyaWVkIHdhaXRpbmcgdXAgdG8gMTIwIHNlY29uZHMgd2l0aCBubyBkaWZmZXJl
bmNlLg0KDQoNCkkgaGF2ZSB0ZXN0ZWQgYnkgbWFraW5nIHRoZSBXSUxDIGFzIGJ1aWxkLWluIG1v
ZHVsZSB0byBpbnNlcnQgZHJpdmVyIA0KYXV0b21hdGljYWxseSBhdCBib290LXVwLiBJIGhvcGUg
aXQgc2hvdWxkIGJlIGZpbmUuIEJlY2F1c2UgSSBoYXZlIA0KYWxyZWFkeSB0ZXN0ZWQgYXMgbG9h
ZGFibGUgbW9kdWxlIGVhcmxpZXIuDQoNCkJlbG93IGFyZSB0aGUgbnVtYmVyIG9ic2VydmVkDQot
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0gLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0N
Ci0gYmVmb3JlIHN0YXJ0aW5nIHdwYV9zdXBwbGljYW50IMKgIMKgwqDCoCDCoCDCoMKgwqAgOiB+
MTYuMyBtQQ0KLSB3cGFfc3VwcGxpY2FudCBzdGFydGVkwqDCoMKgwqAgwqDCoMKgIMKgwqDCoCDC
oMKgwqAgwqDCoMKgIMKgwqDCoCA6IH40MCBtQQ0KLSBQU00gb27CoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgwqDCoMKgIMKgwqDCoCDCoMKgwqAgwqDCoMKgIMKgwqDC
oCDCoMKgwqAgwqDCoMKgIDrCoCB+NiBtQQ0KDQoNClRoZSAnc2xlZXAgMTAnIHdvdWxkIGhhdmUg
bm8gaW1wYWN0IGluIG15IHNldHVwIGJlY2F1c2UgSSBoYXZlIG1lYXN1cmVkIA0KdGhlIGN1cnJl
bnQgY29uc3VtcHRpb24gZm9yIHdpbGMxMDAwIGNoaXAuDQoNCkkgaGF2ZSBzaGFyZWQgdGhlIHNj
cmVlbnNob3QgYXQgaHR0cHM6Ly9wb3N0aW1nLmNjLzY3UzQxZGtiDQoNCg0KPiBTZWNvbmQsIG9u
IGEgZnJlc2hseSBib290ZWQgc3lzdGVtIGFuZCB3aXRoIHdpbGMxMDAwLXNwaSBhdXRvbG9hZGVk
IGJ5DQo+IHRoZSBrZXJuZWwsIHRyeSB0aGlzIHNlcXVlbmNlIChjb3B5ICYgcGFzdGUgdGhlIGNv
bW1hbmRzKToNCj4NCj4gICAgIC91c3Ivc2Jpbi93cGFfc3VwcGxpY2FudCAtQnMgLWl3bGFuMCAt
Yy9ldGMvd3BhX3N1cHBsaWNhbnQuY29uZg0KPiAgICAgc2xlZXAgMTANCj4gICAgIHJtbW9kIHdp
bGMxMDAwLXNwaQ0KPiAgICAgbW9kcHJvYmUgd2lsYzEwMDAtc3BpDQo+ICAgICBzbGVlcCAxMA0K
PiAgICAgaXcgZGV2IHdsYW4wIHNldCBwb3dlcl9zYXZlIG9uDQo+DQo+IFRoZSBhYm92ZSB5aWVs
ZHMgYSBwb3dlciBjb25zdW1wdGlvbiBvZiAxLjFXIHJlbGlhYmx5Lg0KPg0KPiBDYW4geW91IHJl
cHJvZHVjZSB0aGlzLCBvciwgaWYgbm90LCBzaGFyZSB0aGUgcG93ZXIgY29uc3VtcHRpb24geW91
IHNlZQ0KPiBmb3IgdGhlIHR3byBjYXNlcz8NCg0KDQpTZWNvbmQgY2FzZSB3YXMgdmVyaWZpZWQg
ZWFybGllciBhbmQgYWxzbyB0ZXN0ZWQgYnkgdG9nZ2xlIHBvd2VyX3NhdmUgDQptb2RlIG9uL29m
ZiBtYW55IHRpbWVzIGFuZCBJIG9ic2VydmUgdGhlIG51bWJlcnMgYXJlIGluIHNhbWUgcmFuZ2Ug
Zm9yIA0KYm90aCBjYXNlcy4NCg0KUmVnYXJkcywNCkFqYXkNCg0K
