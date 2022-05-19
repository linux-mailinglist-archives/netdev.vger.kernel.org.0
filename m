Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D047D52CEBF
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 10:55:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235688AbiESIy2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 04:54:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232518AbiESIy1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 04:54:27 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B2EE9CF65;
        Thu, 19 May 2022 01:54:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1652950465; x=1684486465;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=b6Pc3FI9lD7AsOD28WlmOj4anUqONl9xhZyPw5crlmY=;
  b=h/eeOMw6JMY6lVZYCDoG/zfWPmwvDKWYNkEckyGMFmYF5+VSGzABc3no
   3vXL+Ehqk4WJBZwgZ/mqcRhs7lX0tppqkfgJMXipgTZf+UOP3mlfYPweg
   duwRNMbUVLanopN9wOHEsQyAJCFF8bfY5I9xZ1ntXSEi8S+brH4z9kj3S
   ZC7riKmhvaHq7qpGfC6JdeVJz1OdgAcCNIXx6AhMYFyt4++shi3IBcMDE
   P9GqYAcdxZ/rqbAnIWl/UeWqUeKeIUftrYvWKS4yANPgyfWFxymyQ4fDq
   By/QH189Bpb/rzLbW14MfpNlNIlOWkPpJr6b0Tq+wiyLG739ySYWlLmFi
   A==;
X-IronPort-AV: E=Sophos;i="5.91,237,1647327600"; 
   d="scan'208";a="96436132"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 19 May 2022 01:54:24 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 19 May 2022 01:54:24 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17 via Frontend Transport; Thu, 19 May 2022 01:54:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JldhhbN9Fc23wYz4we9Xk2bqKr6Z2Co8fvrOV2BBRrve2+LIf2Q08ODF27p+j1pGiK2M3y6tl9H3/cSlngZJQkZhWfXzlj6OAp22dQwnKUXBbV9KcTvUZ9ivY77O43ILoPyx3tH4n9OgNnAENCoyQGVFF3HXT//xKARiiP4+2xLaFOnLl/+F7vRJQpPOg8PrsJ56MU44Fwcmff6nOwZ2bBVKjhgcX8lnqWSGh6NYZYoTZJLFs1v829zVvYqmhGxbQgoroHxHs40LFfXyeTjprGr882GfXqRAMSNtpBW00ylFDXlp9qmk8fruMf4R9+KpGJPytHDgvwAoA8AjnaZ7Fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b6Pc3FI9lD7AsOD28WlmOj4anUqONl9xhZyPw5crlmY=;
 b=Srctdyp/QrIKJN8Y2jjKMYh3X4fNVGfNMXYsftel7gO38TvmDtJ1/NKbkMmmJ8vgcCYSs2MY6VnrIq+HfDz4z4XQOmamgdUAV8pjT7gDOlSXEUrH80nucFT/z3ufGTXK821Yc1TqVjd8v7jAiZj6/NmU0plcI5XfyzE9tcm1LoB7Hwb2qXK9Spt54TzZcCCAkLWRwEitZvoFaXCnzEkwiN/78sm796SFQafs/hFzJhdmjdQ5KapBI4abe25sbmt4V8NdrkM5aRoerj+003l68xxzmMVSvXrdZozpG2VUOuwT9QTROISrE9s9eiC+XHmhc17mc1w9UsPE0cM7HpsvjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b6Pc3FI9lD7AsOD28WlmOj4anUqONl9xhZyPw5crlmY=;
 b=qc4Yt0WJ2W0PuFKt3nrQLf4FH3uo8eT4BbDvaEyd5o8XBnbNFFFB42EHCP2YJy5iQyDI3Eb/VhMU+t8GC8oULjoN/wLj21xQLHxsBEJqj8OY/vEF0bGGvyBhczzX+jD7mXw9ywXK0uGeZxjCL4q5/pvpC9GjF7h6WkRLu5LAi2A=
Received: from CY4PR11MB1960.namprd11.prod.outlook.com (2603:10b6:903:11d::21)
 by SA2PR11MB4889.namprd11.prod.outlook.com (2603:10b6:806:110::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.15; Thu, 19 May
 2022 08:54:19 +0000
Received: from CY4PR11MB1960.namprd11.prod.outlook.com
 ([fe80::31fc:2c57:1ac8:8241]) by CY4PR11MB1960.namprd11.prod.outlook.com
 ([fe80::31fc:2c57:1ac8:8241%2]) with mapi id 15.20.5250.018; Thu, 19 May 2022
 08:54:19 +0000
From:   <Claudiu.Beznea@microchip.com>
To:     <harini.katakam@xilinx.com>, <Nicolas.Ferre@microchip.com>,
        <davem@davemloft.net>, <richardcochran@gmail.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <michal.simek@xilinx.com>, <harinikatakamlinux@gmail.com>,
        <radhey.shyam.pandey@xilinx.com>
Subject: Re: [PATCH 2/3] net: macb: Enable PTP unicast
Thread-Topic: [PATCH 2/3] net: macb: Enable PTP unicast
Thread-Index: AQHYa14Gx1NTl1iZSk2A5VSlxFe1Ew==
Date:   Thu, 19 May 2022 08:54:19 +0000
Message-ID: <ca4c97c9-1117-a465-5202-e1bf276fe75b@microchip.com>
References: <20220517073259.23476-1-harini.katakam@xilinx.com>
 <20220517073259.23476-3-harini.katakam@xilinx.com>
In-Reply-To: <20220517073259.23476-3-harini.katakam@xilinx.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 56c75de7-3787-4654-3334-08da39752933
x-ms-traffictypediagnostic: SA2PR11MB4889:EE_
x-microsoft-antispam-prvs: <SA2PR11MB488944B393735BB1CEA11CAD87D09@SA2PR11MB4889.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yUkj0J6plGmqHLMCxHxRLADooq1It5fKeQzK/D3iKrVq91QpMNQFWEvZy6TuOyX8+oNpEmVQrynstFpHkFo7FeJlENQD8QKc5cvvlXQbX0OenEwhZOmReykNTFADmIlw00Qj6OdKuHt1lqmLWQ6GKYqc2TacxXrmXG01sje/fBzqXnc7WNTGf2cS/vlWCpzBNqMcrpqnEhoF89usOGYpMWe0knKMAvVNi84OK189eCqoDzNuXInDwza5VateseRe5gHYEpG0yXF9Zs8rwg4Bg1w6kzGF9rqSC2URM/izbrbjsDg2UQun+NoFxfiviPw9KK/gMwYhJfe63Bg0Wrbifhx4sORfO/Q8Bv+xPrrivhNQuODblhQA6E5xBIqgzcUkbaqUPjTB+m73v9s22IhxXXalG8/lujjOCs/4zy+uPsBKSKnZtNozaO0bi+7jvInkpyGu5x2C/GAUdu19tUkBrtjWN3Tz/WnZrqxzGh9ZZ+jFXQDxz93xMr31HIOxErod/8aAd6VzXEefU1NQqma5YM1dm604Ysf1DxHx4HOSiqOgkA9IFg9eRl371Y3jHegNgt3fFVWzdD11qMRfiwPDsL+ML7Pje04Au9P9uFRm6rzm5XOJ9wnjTrxsHPkxuQP1Ftw5wAlMijh4RG7s15wVVlBaGAjdhLqWCrkGtKF6HRIXw4H/2hyorkYQLH2k5doAltyF3cF4ZWWLnEa/pqtnHqyU3jlOgHmhcfxtwWQato30KqxaLTtGUpFhLIkI9+87VJiEb2HkbmLzRhPk58gnoQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR11MB1960.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38070700005)(38100700002)(2906002)(31696002)(6486002)(508600001)(86362001)(71200400001)(7416002)(54906003)(110136005)(316002)(5660300002)(8936002)(6512007)(26005)(91956017)(66446008)(8676002)(64756008)(66946007)(122000001)(66476007)(66556008)(31686004)(76116006)(6506007)(53546011)(83380400001)(36756003)(2616005)(4326008)(186003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WGhOcnNSVFhpeEJkUEVBK052TEt0eHp6SEJ2RFZielk4cHFlRSswRFJWbDgz?=
 =?utf-8?B?OHNXM3N6N0VOSkVrVU1RS0ZOUHZ4dTZ1RU9vV2VleTQ5cDN3ZzdiNnQveERi?=
 =?utf-8?B?MzQ4Y1l1QUNIYTR1SEI4eU0zYUhzamtvWVh6dHk0L2ZKNlpEeWM2MlNybER1?=
 =?utf-8?B?NTZuTWZQWFR4cmpxaWVVRGoyM1h1Q1cyMmtTYVF3eDRPTldCOENHRGNWVENQ?=
 =?utf-8?B?NVlTRDN1akx2bVZUQnJISUgvYnhhNW9meElKYmwvaVUvV0pjLzc5RmhlLzZQ?=
 =?utf-8?B?NG5vWDMwNHkybGZjdldsRnRXV3FNZUkyZ2ZZZGZVN0xVODgrUG54WU0yaEQv?=
 =?utf-8?B?SXNVRzhMSFJOeU13bDNsNld0L2U0bkxHQ1NyNlZjVHA2ZmNZZGwwQ0RHcktE?=
 =?utf-8?B?R1FVUm1FS3VxZEN4VElUa1Y2RS9WNWxJMVBCZlFFdmNoSXZqbnQ0Vzl3SlNz?=
 =?utf-8?B?cGxRTDVBKzQyWFI3ckhmQ284STFBN2tWZnZPK09RZTRKdGFrbjZrQ0hmcFUy?=
 =?utf-8?B?V2ZMN1ZaOFVNanBwQWg5M2ZUeFVMWkFpUm9SUVRMT2hlbU54aktvK0dqR2k5?=
 =?utf-8?B?dk16NnB5Nkt0Y0NGcjl2ME96OE51TEZFS3pNT051L3MzVHVXV3lacnM5ZlBu?=
 =?utf-8?B?MHlFSTFKbDBSRU0zaHdOTTVySVppR0RiS2JvUEFMeCtldTRlcG5LUUxpcU1S?=
 =?utf-8?B?MWxtWWIrZk0vUGQ1YU9UeGNGSEVqVGY0S0ltaEFwWWRrc3o0dWtIUk1TcTZh?=
 =?utf-8?B?SllIUTQ5ZWpraWVPRyswNXBoV2dGSWI4R3dIeHZQdlZ4U0VIdzRZSlo0TG1m?=
 =?utf-8?B?MDBMVnRFVERzTWx5eFVUS3Z1ZkNlQ2dCN2NBUzFQWTZMMGJ3QS8vTUtNc1ll?=
 =?utf-8?B?Z1NEZmRIektkU0JVVXZhdytoUEpCNm9mZUlDZm83UGdVV0plOEJqK1pNQUVP?=
 =?utf-8?B?QUZHWWxtV21DOWE2ek00eC9QY2Y3UnBndDZVemFycm1wdUZsRkZGdTlOblZR?=
 =?utf-8?B?MEsxdVZ4NzFCZTB0Qzk3UStSWkR5dFBjbXhIc2x4R3JnaUdVWlU4RkhvU3hQ?=
 =?utf-8?B?Ym9QWW5YZTZ2cDQ3cHpicGJvN2hxRDFKQmJwdUhIUXlUeWVpM1Z3cUttc1NH?=
 =?utf-8?B?bkV0RnZ6UTl5U1RFeVBqVFlBL0szMk1TdlVXMFhPbk0wemtOSVlMSDFzT1lS?=
 =?utf-8?B?TUJWT0hVaUJQQlBRQVRjQitsRjRTS25SbExQdnJjWDhxTjdqbkRWWTJyVkIr?=
 =?utf-8?B?Z0ZDZGkxa0tjWXpBVUZDMmEzbVkwa2haWndaa1liVERwOW43WUJoSXJTYUQv?=
 =?utf-8?B?WDR3L1Nmdmh1L0RKOVR4YVhzb2lzN2l4OGNpd01YLzNZYVlYd2E1TzZxbHZV?=
 =?utf-8?B?NWd2UVc3QmljU3JqQjE3NHMwdHk3c1I0RmI3QWllV3A0aE5yRnIrcTJhcSt2?=
 =?utf-8?B?eitCQ3BuWk82N0xYTTQvUHYrLzBReXdMSDRMZ2E0SHJ5cUxsUVFOa0JNZTh6?=
 =?utf-8?B?TmVGcXBJMGN4dnJkYkNpZitLcFJtMTQ5UmR3U2pyVjFqOTNKa29SY1dkemkz?=
 =?utf-8?B?Z0ZHUXNkdVEzVzhyVWFPZGVRSGVIaWNaMnJyMmgyZ09Jb2xuS3BQWm5KZUhI?=
 =?utf-8?B?RlNrUXlrYXBVelRjUzl1clhKVHRPMUFURkJzdGlZTUREMWIzZTdDcXRxN0lR?=
 =?utf-8?B?WGg2OXExR28xa1FzQ2V4aEtqR3JYbE04Y2w0NGc5eGZRcnVqVzRYaTlkbkdJ?=
 =?utf-8?B?RGJIb0U1TmhqLy94WTRTMExvNDNNZ1VQTkpnVytyL0xENnpqb3AxaXRHSUdQ?=
 =?utf-8?B?YW1OdGQwc1pmTmszK09iU29Tend1YWNwL3hFMWxKREgxSnNMbWZLTjVzOXdn?=
 =?utf-8?B?UVBBRFh1N1RoVzUydnFxc3pOQzZzY21EMmZCU0RQTEw3aHZiQ1hFeTRyaXUz?=
 =?utf-8?B?aFpFN0JESHVldWI4U3dGZkpDVlpFS1k1enM3MjlSZXgrRVczNkN4ZTNjNDFF?=
 =?utf-8?B?Ty9GajZwb1FnYTdJTTFvaFVMcXpKM1ExbTkzOW1XcjZ6REZYRklCTUNnQ1dO?=
 =?utf-8?B?Zm9yd2I0bEN6ZnBRSWpVOHNhS3pBSERxK1NHSWdVcFUrTHZoaXFjVVNFd0lq?=
 =?utf-8?B?b0xMbTdmaHdab2liVTJPTkxWdUxYQ2pjQ3ZsckthV2JzNUp3WW52UFd1MzRK?=
 =?utf-8?B?ZFY4T2NieVloUGZkWlpJWWtDU2NvUFhxZjNOU3hIT0lHdXd4M1hSNU54akhu?=
 =?utf-8?B?WXJ5R2U0RDFRSUQzVWJOOEtrTkJhVk1DMkdDMFZsQXd1Nm8vTDRWcHBndVoy?=
 =?utf-8?B?cEJKMkhBbmwvMTRFam91RVU5TGpwZEtBMXhmcXdsa3FkM0xvVFpBMWxuRG1N?=
 =?utf-8?Q?TlgL64k5dcGt7J3Q=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9D6E9CB7691F074F9EDB0BFE12A7A5F6@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR11MB1960.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56c75de7-3787-4654-3334-08da39752933
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 May 2022 08:54:19.0899
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ccHnQm69H102ECFvgd6lRm6QwSGQP7jbHOjm/4hRUlZv+oLkXi4JIsPXhciAqVeLJno6ZB9qNzXF28ihiLAi2y85PfiGtcojEQVkProL17U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4889
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGksIEhhcmluaSwNCg0KT24gMTcuMDUuMjAyMiAxMDozMiwgSGFyaW5pIEthdGFrYW0gd3JvdGU6
DQo+IEVYVEVSTkFMIEVNQUlMOiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50
cyB1bmxlc3MgeW91IGtub3cgdGhlIGNvbnRlbnQgaXMgc2FmZQ0KPiANCj4gRW5hYmxlIHRyYW5z
bWlzc2lvbiBhbmQgcmVjZXB0aW9uIG9mIFBUUCB1bmljYXN0IHBhY2tldHMgYnkNCj4gdXBkYXRp
bmcgUFRQIHVuaWNhc3QgY29uZmlnIGJpdCBhbmQgc2V0dGluZyBjdXJyZW50IEhXIG1hYw0KPiBh
ZGRyZXNzIGFzIGFsbG93ZWQgYWRkcmVzcyBpbiBQVFAgdW5pY2FzdCBmaWx0ZXIgcmVnaXN0ZXJz
Lg0KPiANCj4gU2lnbmVkLW9mZi1ieTogSGFyaW5pIEthdGFrYW0gPGhhcmluaS5rYXRha2FtQHhp
bGlueC5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IE1pY2hhbCBTaW1layA8bWljaGFsLnNpbWVrQHhp
bGlueC5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IFJhZGhleSBTaHlhbSBQYW5kZXkgPHJhZGhleS5z
aHlhbS5wYW5kZXlAeGlsaW54LmNvbT4NCj4gLS0tDQo+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9j
YWRlbmNlL21hY2IuaCAgICAgIHwgNCArKysrDQo+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9jYWRl
bmNlL21hY2JfbWFpbi5jIHwgNyArKysrKy0tDQo+ICAyIGZpbGVzIGNoYW5nZWQsIDkgaW5zZXJ0
aW9ucygrKSwgMiBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9l
dGhlcm5ldC9jYWRlbmNlL21hY2IuaCBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2NhZGVuY2UvbWFj
Yi5oDQo+IGluZGV4IDdjYTA3N2I2NWVhYS4uZDI0NWZkNzhlYzUxIDEwMDY0NA0KPiAtLS0gYS9k
cml2ZXJzL25ldC9ldGhlcm5ldC9jYWRlbmNlL21hY2IuaA0KPiArKysgYi9kcml2ZXJzL25ldC9l
dGhlcm5ldC9jYWRlbmNlL21hY2IuaA0KPiBAQCAtOTUsNiArOTUsOCBAQA0KPiAgI2RlZmluZSBH
RU1fU0E0QiAgICAgICAgICAgICAgIDB4MDBBMCAvKiBTcGVjaWZpYzQgQm90dG9tICovDQo+ICAj
ZGVmaW5lIEdFTV9TQTRUICAgICAgICAgICAgICAgMHgwMEE0IC8qIFNwZWNpZmljNCBUb3AgKi8N
Cj4gICNkZWZpbmUgR0VNX1dPTCAgICAgICAgICAgICAgICAgICAgICAgIDB4MDBiOCAvKiBXYWtl
IG9uIExBTiAqLw0KPiArI2RlZmluZSBHRU1fUlhQVFBVTkkgICAgICAgICAgIDB4MDBENCAvKiBQ
VFAgUlggVW5pY2FzdCBhZGRyZXNzICovDQo+ICsjZGVmaW5lIEdFTV9UWFBUUFVOSSAgICAgICAg
ICAgMHgwMEQ4IC8qIFBUUCBUWCBVbmljYXN0IGFkZHJlc3MgKi8NCj4gICNkZWZpbmUgR0VNX0VG
VFNIICAgICAgICAgICAgICAweDAwZTggLyogUFRQIEV2ZW50IEZyYW1lIFRyYW5zbWl0dGVkIFNl
Y29uZHMgUmVnaXN0ZXIgNDc6MzIgKi8NCj4gICNkZWZpbmUgR0VNX0VGUlNIICAgICAgICAgICAg
ICAweDAwZWMgLyogUFRQIEV2ZW50IEZyYW1lIFJlY2VpdmVkIFNlY29uZHMgUmVnaXN0ZXIgNDc6
MzIgKi8NCj4gICNkZWZpbmUgR0VNX1BFRlRTSCAgICAgICAgICAgICAweDAwZjAgLyogUFRQIFBl
ZXIgRXZlbnQgRnJhbWUgVHJhbnNtaXR0ZWQgU2Vjb25kcyBSZWdpc3RlciA0NzozMiAqLw0KPiBA
QCAtMjQ1LDYgKzI0Nyw4IEBADQo+ICAjZGVmaW5lIE1BQ0JfVFpRX09GRlNFVCAgICAgICAgICAg
ICAgICAxMiAvKiBUcmFuc21pdCB6ZXJvIHF1YW50dW0gcGF1c2UgZnJhbWUgKi8NCj4gICNkZWZp
bmUgTUFDQl9UWlFfU0laRSAgICAgICAgICAxDQo+ICAjZGVmaW5lIE1BQ0JfU1JUU01fT0ZGU0VU
ICAgICAgMTUgLyogU3RvcmUgUmVjZWl2ZSBUaW1lc3RhbXAgdG8gTWVtb3J5ICovDQo+ICsjZGVm
aW5lIE1BQ0JfUFRQVU5JX09GRlNFVCAgICAgMjAgLyogUFRQIFVuaWNhc3QgcGFja2V0IGVuYWJs
ZSAqLw0KPiArI2RlZmluZSBNQUNCX1BUUFVOSV9TSVpFICAgICAgIDENCj4gICNkZWZpbmUgTUFD
Ql9PU1NNT0RFX09GRlNFVCAgICAyNCAvKiBFbmFibGUgT25lIFN0ZXAgU3luY2hybyBNb2RlICov
DQo+ICAjZGVmaW5lIE1BQ0JfT1NTTU9ERV9TSVpFICAgICAgMQ0KPiAgI2RlZmluZSBNQUNCX01J
SU9OUkdNSUlfT0ZGU0VUIDI4IC8qIE1JSSBVc2FnZSBvbiBSR01JSSBJbnRlcmZhY2UgKi8NCj4g
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2NhZGVuY2UvbWFjYl9tYWluLmMgYi9k
cml2ZXJzL25ldC9ldGhlcm5ldC9jYWRlbmNlL21hY2JfbWFpbi5jDQo+IGluZGV4IGUyM2EwM2U4
YmFkZi4uMTkyNzY1ODM4MTFlIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9j
YWRlbmNlL21hY2JfbWFpbi5jDQo+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2NhZGVuY2Uv
bWFjYl9tYWluLmMNCj4gQEAgLTI5MCw2ICsyOTAsOSBAQCBzdGF0aWMgdm9pZCBtYWNiX3NldF9o
d2FkZHIoc3RydWN0IG1hY2IgKmJwKQ0KPiAgICAgICAgIHRvcCA9IGNwdV90b19sZTE2KCooKHUx
NiAqKShicC0+ZGV2LT5kZXZfYWRkciArIDQpKSk7DQo+ICAgICAgICAgbWFjYl9vcl9nZW1fd3Jp
dGVsKGJwLCBTQTFULCB0b3ApOw0KPiANCj4gKyAgICAgICBnZW1fd3JpdGVsKGJwLCBSWFBUUFVO
SSwgYm90dG9tKTsNCj4gKyAgICAgICBnZW1fd3JpdGVsKGJwLCBUWFBUUFVOSSwgYm90dG9tKTsN
Cg0KUGxlYXNlIGNhbGwgdGhlc2Ugb25seSBpZiBnZW1faGFzX3B0cCgpIHJldHVybnMgdHJ1ZSBh
cyBtYWNiX3NldF9od2FkZHIoKQ0KaXMgY2FsbGVkIGVpdGhlciBvbiBlbWFjLCBnZW0gdmFyaWFu
dHMgb3IgZ2VtIHZhcmlhbnRzIHcvbyBwdHAgc3VwcG9ydCBvcg0Kdy9vIHB0cCBzdXBwb3J0IGVu
YWJsZWQuDQoNCj4gKw0KPiAgICAgICAgIC8qIENsZWFyIHVudXNlZCBhZGRyZXNzIHJlZ2lzdGVy
IHNldHMgKi8NCj4gICAgICAgICBtYWNiX29yX2dlbV93cml0ZWwoYnAsIFNBMkIsIDApOw0KPiAg
ICAgICAgIG1hY2Jfb3JfZ2VtX3dyaXRlbChicCwgU0EyVCwgMCk7DQo+IEBAIC03MjMsOCArNzI2
LDggQEAgc3RhdGljIHZvaWQgbWFjYl9tYWNfbGlua191cChzdHJ1Y3QgcGh5bGlua19jb25maWcg
KmNvbmZpZywNCj4gDQo+ICAgICAgICAgc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmYnAtPmxvY2ss
IGZsYWdzKTsNCj4gDQo+IC0gICAgICAgLyogRW5hYmxlIFJ4IGFuZCBUeCAqLw0KPiAtICAgICAg
IG1hY2Jfd3JpdGVsKGJwLCBOQ1IsIG1hY2JfcmVhZGwoYnAsIE5DUikgfCBNQUNCX0JJVChSRSkg
fCBNQUNCX0JJVChURSkpOw0KPiArICAgICAgIC8qIEVuYWJsZSBSeCBhbmQgVHg7IEVuYWJsZSBQ
VFAgdW5pY2FzdCAqLw0KPiArICAgICAgIG1hY2Jfd3JpdGVsKGJwLCBOQ1IsIG1hY2JfcmVhZGwo
YnAsIE5DUikgfCBNQUNCX0JJVChSRSkgfCBNQUNCX0JJVChURSkgfCBNQUNCX0JJVChQVFBVTkkp
KTsNCg0KU2FtZSBoZXJlLg0KDQo+IA0KPiAgICAgICAgIG5ldGlmX3R4X3dha2VfYWxsX3F1ZXVl
cyhuZGV2KTsNCj4gIH0NCj4gLS0NCj4gMi4xNy4xDQo+IA0KDQo=
