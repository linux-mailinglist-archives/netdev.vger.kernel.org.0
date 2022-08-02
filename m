Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49A5A587E42
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 16:40:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236553AbiHBOk0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 10:40:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234025AbiHBOkY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 10:40:24 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8A84637B;
        Tue,  2 Aug 2022 07:40:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1659451224; x=1690987224;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=acrZiGBdYXIAiesqDZSWyyG6E7oMwbTmgaVuNzqzxio=;
  b=haz3N+jUickZbbhgLbPjqk9AIDKVE1WmOx3ZhfHyH+xJ0qyWKEUt62tw
   eLTKEFX4drF/rebeP9MtE3KJSbFK/+mUOnHzM/dRgIRk5Nn9CO3EG7rUc
   tc2OkAP6VSt/P5pJNJM5dOwrjYVkgat/Juc9uELzHdKxB8nIXRi5p/3Yx
   Ivvsk+1tBRazs46QG0ZUwNRPbrZcwvAxjzACRNQUVizk6/lqNO1+ilmHf
   ZvvQl6qHNSKmGAUFJdZjMPud5MRj/9exHVEgfPtBVnojjmlazCJx8fQa9
   UsCIVdkI950ewcx3OpUms4t2c0xB1yeprLwAdcAyrTusbmLrRnBVEMLfR
   Q==;
X-IronPort-AV: E=Sophos;i="5.93,211,1654585200"; 
   d="scan'208";a="167468136"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Aug 2022 07:40:22 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 2 Aug 2022 07:40:21 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17 via Frontend
 Transport; Tue, 2 Aug 2022 07:40:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Abg6/rBmEmU3hBoIVVb9z8+TrJOznucD5GPkwWy9C/NgJvwl2nGlekTNXTxBkrAfeN/rkEBJOWXlnTbvJjRWiAkf7QVeTcGbtMmNHD51wjb2gngXy/ssJKDQLk0H+Epuvxwy4SWDMdkLPT+SDebZBCICzbghmz5d4rXxLFqm2q7qWGqZlnqwResMwNPEtlbYKsHe/8WOWRZA9XPZZ9CL8PNZv1rwhoktHHiegzaHWHGOMSyRHQWJiHKf4F6HzkGGZQrBmgsak/VjBU2imX5aG1WJ1DjK0wl7kozoCggWjW7/SW9TOze0+txxoOBo6c66ugSp8Gfqu3L1sB6VupZtqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=acrZiGBdYXIAiesqDZSWyyG6E7oMwbTmgaVuNzqzxio=;
 b=eQh2rSJYvRjU6RPni5Ta5ByjRKIISy2xK0H4salASqaAGvmrnxOtSpBcrhIjEr6YdAG7q12iKOxisxM2JjkSF/q7Tp3I7DperuW8J8APaKngyKmBnbS6a/3uk26Cvaa5uAbNUN5MuyPAXXDK3L7dCpim51Z8SDy3zAgjTlNygORxWrr53nzTQQfMB/gmVxQ8gM3vS2ZChW9XegDHO54otJ4z5LbTv2vUhNRJshLVf1ceOic193f75p4m8kBfyEkSmHejJFddi0GkD3ZEuCSQtOeJv2yADjSFG5PCO8+a3P+zMhndkldridGSOaz8qynn621EjFaZKKq0eAjPIRotjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=acrZiGBdYXIAiesqDZSWyyG6E7oMwbTmgaVuNzqzxio=;
 b=SRTCDtLMEBNB2jWZQlNvKkbvEiZ3Q2A/hpRni8eoqwUNZIi2mtIMPJbIE72nB739sSsyd5ooxpE1Q+N13L8OZfrlnHcjqFxQzLI8xCBnTJ3V/R7d3DjafIqBzDdozWoHKAYwVk3l34xDn1FOoAkW6iCtz8386lxPT5q9z6fYqp8=
Received: from DM5PR11MB0076.namprd11.prod.outlook.com (2603:10b6:4:6b::28) by
 MWHPR11MB1488.namprd11.prod.outlook.com (2603:10b6:301:c::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5482.14; Tue, 2 Aug 2022 14:40:09 +0000
Received: from DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::945f:fc90:5ca3:d69a]) by DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::945f:fc90:5ca3:d69a%6]) with mapi id 15.20.5482.016; Tue, 2 Aug 2022
 14:40:09 +0000
From:   <Arun.Ramadoss@microchip.com>
To:     <olteanv@gmail.com>
CC:     <andrew@lunn.ch>, <linux-kernel@vger.kernel.org>,
        <UNGLinuxDriver@microchip.com>, <vivien.didelot@gmail.com>,
        <linux@armlinux.org.uk>, <f.fainelli@gmail.com>, <kuba@kernel.org>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <Woojung.Huh@microchip.com>,
        <davem@davemloft.net>
Subject: Re: [Patch RFC net-next 4/4] net: dsa: microchip: use private pvid
 for bridge_vlan_unwaware
Thread-Topic: [Patch RFC net-next 4/4] net: dsa: microchip: use private pvid
 for bridge_vlan_unwaware
Thread-Index: AQHYo16i5OwaIBSN6UuhTptF+k0JEK2bd1lSgAA9bwA=
Date:   Tue, 2 Aug 2022 14:40:09 +0000
Message-ID: <365b35f48b4a6c2003b67a4ee0c287b8172fa262.camel@microchip.com>
References: <20220729151733.6032-1-arun.ramadoss@microchip.com>
         <20220729151733.6032-1-arun.ramadoss@microchip.com>
         <20220729151733.6032-5-arun.ramadoss@microchip.com>
         <20220729151733.6032-5-arun.ramadoss@microchip.com>
         <20220802105935.gjjc3ft6zf35xrhr@skbuf>
In-Reply-To: <20220802105935.gjjc3ft6zf35xrhr@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f91ab262-03e5-4578-b15e-08da7494e623
x-ms-traffictypediagnostic: MWHPR11MB1488:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ML3fiYltpfYHBKI0dX14GCAl+Y85D+sYeoh8DTACg9kxgdAEElVh8KTUJ0/UKpmFI++iU7xBqejAYNy2egZ+XA+i2MIdxeU8lkXb/SY/aP0Hi3nP6SF3Hyh13tZp9c9KZ0EjJiPQXkxh6eI2Dd8ns82OVx8Zde5gGBopDKb0qSWc/lEXW215fHHCVfZsRCyDYobDcgMwSGK4/3NHl6n+vfILguRs9VZ0xKjHHeIbfZyaGnaqWXT1LZ2D4CTTgBaek0Dn/S3l5QU5HIP45w5rKRjYjh9Zdx18eRd/8zTDe1EB+Wjt3f2syNAXxMlLCXl3s7Vv+m0Lbo6XH3drXZcxYsFSV5a+rUeCx3YTAXg0LwUaa1p24ObA7Aku9n9JiCBs5Qt8uK3ZPPlItfW6H6x+EbaLzM0eBLFr3eTV3lSKC9lmamK6P9ZT1kfBo+Gt76CNgNWy+veg+IMwKas8QEWD+YHmHODQ3rlBlvxgfx4sOfoS8qJX5qEAkZ+kMud+q5H/DVh6aep+Q8krXtMWZUDpQPXmKpqvUuwEkC0je8E/KSZ2gPSKqLg/mRl7sc7hl8ZG8XZyPBb4O19lVz2dLnAMV5yGGXJA/uZDbia3j35EB4wr/Yuk+Q9Ko8FEXFXzb+MSzg3cawhsgLaumT9eEGRoxDoOqv7nSiQJ/hufdWEFoQNxceEaroDwE05EuGj+E9lFiKC2B/C3MOk7fjm+TTEl2Fpg51AyX6M+EiWX2tws72a7fEeYKjY+cqumQe0RnqsE31dCxNrdHbD91r/gY0B1YdGFv9lW+eQ5ajNXdgC3F36cpLp23T0xRElWuvptVuPp5ybj6qxIloI55+7kE19KniFO4raGyubsHwP0tQb745g=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB0076.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(39860400002)(396003)(376002)(366004)(346002)(7416002)(5660300002)(2906002)(41300700001)(2616005)(186003)(38100700002)(6506007)(122000001)(38070700005)(6512007)(316002)(6916009)(54906003)(71200400001)(86362001)(478600001)(966005)(6486002)(83380400001)(36756003)(8936002)(64756008)(4326008)(66946007)(91956017)(66556008)(8676002)(66476007)(66446008)(76116006)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UGdlTisyOWpWN0hxdDFIamNXV25DZGNEalE0cXM0eHJoWlMyRmZtMWdBU2I1?=
 =?utf-8?B?N2pBaGRlQ1dsZnNaWkVTbGlnZTlQbEtyRk1STXVzSFJRZDZYSTFLQTE1a3Zs?=
 =?utf-8?B?YVNyVzA0N2NRNVJWdG52VE9Kbi95L3hIRkdnUXgwc25VRERHc2tHSUNDb1ky?=
 =?utf-8?B?TUVKU1NKSFd5OWplT3dmdEtpbFNyVFhnUUora2RzVlMxOHQ3WVZlNHY3SWJi?=
 =?utf-8?B?T3l5Wk5rNjM3VHJERGVQajVBRTdERUZOVCtHVVpZdzZUWjVUalNxT3NQdmFO?=
 =?utf-8?B?RHY5TmJZRjYyTFFQeGhRcnpKZXlzNk5mZ3NrZFdtVG5TWUVWYjBGeHFRVlM2?=
 =?utf-8?B?eDFQWTNwb1lOeXBLTnJlc3NUZ2MxMkpzQW5ZUzdoRi9SQitFcXk1TDNwT2pD?=
 =?utf-8?B?TzZaRS9HOWtFbWVNbjIwRCtLSGNUb1pIOVNnTm5SOU5UODdxakhnYmxxL05O?=
 =?utf-8?B?VldNU2RDditjUnYzUWNmSktOY2QyczFxNkNDaFZRQnYySWliQXp3MTVUdTlH?=
 =?utf-8?B?MjF5UlBmNXhhTERjaVBJeGtLYlpyTXpuTWpEOU9BOHBRaU9Ia1RFQlNzaHZI?=
 =?utf-8?B?YUg0MHI0bTNMQ0dSclBGWUlMTWE0Z29xeEFlZEdvQWdEcnloOHZvWWtGaUhW?=
 =?utf-8?B?ejRDQ01pYkdLSXE2TUJZY1RSazJLOVNNMXpRUThkNWR2YjNFWWR2V05zdDE1?=
 =?utf-8?B?dzhQc05lOEVGb08vNlJEWXgxOG8ydzI1am1YaXljTFU0QzUrMGJrMUxoV1pK?=
 =?utf-8?B?enBiSDZ4RUZyL2RobDZVQ1U2MGdVQ3hVUUVqVlVaWWlsVk41V0E1cXhKaUw0?=
 =?utf-8?B?S0ovb1pBa2g0b2ZkQmZrd2srYkVNUkdiakYxQllZR1BaMCtYYzQrWXBNb00x?=
 =?utf-8?B?MmRuajhNRHd1UnR4cDkzSTE4bmMwTEhPZ2pPSFB6ckZLYkxCVXlVN3ZJQ2Vk?=
 =?utf-8?B?NDNoQThvQXNsMnU3TkFWeEVqZlRXY2F0SzZuVldTVitGUEh2aTFJck4zV3dT?=
 =?utf-8?B?RXM4clA5MWVnRVBwZC96RnQvSmE5TC85ZVFBZGVSSXdvcUZpam1oOVc5Y0Qx?=
 =?utf-8?B?cjZ4SGNja2xpdTcwVkNhUzVEbkFUVnU4c245NWVqUityWmUyUXlMVVVieXA5?=
 =?utf-8?B?OTJWTUhTdUJNTnpHSkNYOFk3RncwY0g5Vkg2dmdCZTBnUkcxMHFMeVN1UDlu?=
 =?utf-8?B?b05wY1JHVjJ2TzI3eXJVd0pkaW9KM0tUQlFPNjRQTHFBRVVOa1NZZGVzQXRC?=
 =?utf-8?B?N0dQemh2YlI2Tlg0K0tENGROVklpMEk5cjRGUzg5SzVhYzZVNUZ2K2lMYWl6?=
 =?utf-8?B?V3R1WmpLd2VVVVFDbmwvRGNCVU5mY3B4dTQwM0hpZlVUOWF5QzJZOE1DVHVl?=
 =?utf-8?B?ZlNYWlRmKzBjYjRxNWY0dHNxMTJ1TjZyNlRrSUlYeHdBMFdUQlBObVorTnF5?=
 =?utf-8?B?NmNWUUUycU54STdnZzV6dStmWHpYRVBocWZVejVRZGlFbWRhM0FoaWVicU94?=
 =?utf-8?B?cmhYMGNpNDdjK0c0VnR0L2hWK09nTksrR0V4cnExQnlocUhtUWd3VjMwVWxR?=
 =?utf-8?B?bnZuN3hzVEIyWDhoMDc4a1l3RVBHMVhERUtVMnVaVXlPSUhCNE5qVHNsWGdZ?=
 =?utf-8?B?alZjU2Nqc3Q3eEsySXhxdURTaWYyREd3emx2SzhKUWwxTE9wWmRLeXAzM1h0?=
 =?utf-8?B?WlZSMVlzbG52RFUrY2VlSG1yaVRTdldnS3QxMXdQRTI3empmRmIxMjhuK0JT?=
 =?utf-8?B?bURETlg0UUtQY0ZaeUI5T2w5NE5OZ2Z3OWh5SkxNMHRXb25yekdCVERicFlu?=
 =?utf-8?B?NWEzVEJCbjBhRWNHZWtQVVk1U25TLzl4U3RxcW5tNmtwUGxmVnRYK2FIbm9w?=
 =?utf-8?B?Mm1DRkZRb0Ezdk1VY3Z2OHZRWmZTdVlUeXBXN09PcnBYbEV2L1hUcnozbWlm?=
 =?utf-8?B?bFVNcmpTbXNjbU5HRWx1cGxOYkdNZk5YYTNNa2lGZnhWWTAwT045dGtJcWFY?=
 =?utf-8?B?VWtUd3pIYVRLdjdCRFdwb0xEdXREQm9nZzd3SjNqRUVrRmhFOWFIbjRvWGd2?=
 =?utf-8?B?VkNkaHR2QzljMUV6emhiU2VDQ0JObStvSWovV0ZaeUV4TzNTclJVdVJwQjBC?=
 =?utf-8?B?a1dpUXNJS1crTzEyYTBNUGI4bWdUZUswZmF4V2w0dllhY1lxSUpTeU1RZ1Jn?=
 =?utf-8?B?SGt6bXArM3RHWloycDYvaU9PWXlpVFF5UlU2MEwwUkVkOW0xaWdzL0YwQzZO?=
 =?utf-8?Q?y2JdMSzhbsfsH6F69Y43tMhHUaE4hATo42eErHkPEY=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <292FFA8AB3585F48A0F60501AEF9103A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB0076.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f91ab262-03e5-4578-b15e-08da7494e623
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Aug 2022 14:40:09.0958
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lXclqlQeX0PNGSyQrGL/bvM5XsJjYOxHu3ID8q3oU7gGUPnaH56sEI2ilmUCvfrjxYBeZqvNvA6vZ86KuU9/d3sKgZbHdmWY3s4uVmMHr58=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1488
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIyLTA4LTAyIGF0IDEzOjU5ICswMzAwLCBWbGFkaW1pciBPbHRlYW4gd3JvdGU6
DQo+IEVYVEVSTkFMIEVNQUlMOiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50
cyB1bmxlc3MgeW91DQo+IGtub3cgdGhlIGNvbnRlbnQgaXMgc2FmZQ0KPiANCj4gT24gRnJpLCBK
dWwgMjksIDIwMjIgYXQgMDg6NDc6MzNQTSArMDUzMCwgQXJ1biBSYW1hZG9zcyB3cm90ZToNCj4g
PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZHNhL21pY3JvY2hpcC9rc3pfY29tbW9uLmMNCj4g
PiBiL2RyaXZlcnMvbmV0L2RzYS9taWNyb2NoaXAva3N6X2NvbW1vbi5jDQo+ID4gaW5kZXggNTE2
ZmI5ZDM1Yzg3Li44YTU1ODNiMWYyZjQgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9uZXQvZHNh
L21pY3JvY2hpcC9rc3pfY29tbW9uLmMNCj4gPiArKysgYi9kcml2ZXJzL25ldC9kc2EvbWljcm9j
aGlwL2tzel9jb21tb24uYw0KPiA+IEBAIC0xNjEsNiArMTYxLDcgQEAgc3RhdGljIGNvbnN0IHN0
cnVjdCBrc3pfZGV2X29wcyBrc3o4X2Rldl9vcHMgPQ0KPiA+IHsNCj4gPiAgICAgICAudmxhbl9m
aWx0ZXJpbmcgPSBrc3o4X3BvcnRfdmxhbl9maWx0ZXJpbmcsDQo+ID4gICAgICAgLnZsYW5fYWRk
ID0ga3N6OF9wb3J0X3ZsYW5fYWRkLA0KPiA+ICAgICAgIC52bGFuX2RlbCA9IGtzejhfcG9ydF92
bGFuX2RlbCwNCj4gPiArICAgICAuZHJvcF91bnRhZ2dlZCA9IGtzejhfcG9ydF9lbmFibGVfcHZp
ZCwNCj4gDQo+IFlvdSdsbCBoYXZlIHRvIGV4cGxhaW4gdGhpcyBvbmUuIFdoYXQgaW1wYWN0IGRv
ZXMgUFZJRCBpbnNlcnRpb24gb24NCj4gS1NaOA0KPiBoYXZlIHVwb24gZHJvcHBpbmcvbm90IGRy
b3BwaW5nIHVudGFnZ2VkIHBhY2tldHM/IFRoaXMgcGF0Y2ggaXMNCj4gc2F5aW5nDQo+IHRoYXQg
d2hlbiB1bnRhZ2dlZCBwYWNrZXRzIHNob3VsZCBiZSBkcm9wcGVkLCBQVklEIGluc2VydGlvbiBz
aG91bGQNCj4gYmUNCj4gZW5hYmxlZCwgYW5kIHdoZW4gdW50YWdnZWQgcGFja2V0cyBzaG91bGQg
YmUgYWNjZXB0ZWQsIFBWSUQgaW5zZXJ0aW9uDQo+IHNob3VsZCBiZSBkaXNhYmxlZC4gSG93IGNv
bWU/DQoNCkl0cyBteSBtaXN0YWtlLiBJIHJlZmVycmVkIEtTWjg3eHggZGF0YXNoZWV0IGJ1dCBJ
IGNvdWxkbid0IGZpbmQgdGhlDQpyZWdpc3RlciBmb3IgdGhlIGRyb3BwaW5nIHRoZSB1bnRhZ2dl
ZCBwYWNrZXQuIElmIHRoYXQgaXMgdGhlIGNhc2UsDQpzaGFsbCBJIHJlbW92ZSB0aGUgZHJvcHBp
bmcgb2YgdW50YWdnZWQgcGFja2V0IGZlYXR1cmUgZnJvbSB0aGUga3N6OA0Kc3dpdGNoZXM/DQoN
Cj4gDQo+ID4gICAgICAgLm1pcnJvcl9hZGQgPSBrc3o4X3BvcnRfbWlycm9yX2FkZCwNCj4gPiAg
ICAgICAubWlycm9yX2RlbCA9IGtzejhfcG9ydF9taXJyb3JfZGVsLA0KPiA+ICAgICAgIC5nZXRf
Y2FwcyA9IGtzejhfZ2V0X2NhcHMsDQo+ID4gQEAgLTE4Nyw2ICsxODgsNyBAQCBzdGF0aWMgY29u
c3Qgc3RydWN0IGtzel9kZXZfb3BzIGtzejk0NzdfZGV2X29wcw0KPiA+ID0gew0KPiA+ICAgICAg
IC52bGFuX2ZpbHRlcmluZyA9IGtzejk0NzdfcG9ydF92bGFuX2ZpbHRlcmluZywNCj4gPiAgICAg
ICAudmxhbl9hZGQgPSBrc3o5NDc3X3BvcnRfdmxhbl9hZGQsDQo+ID4gICAgICAgLnZsYW5fZGVs
ID0ga3N6OTQ3N19wb3J0X3ZsYW5fZGVsLA0KPiA+ICsgICAgIC5kcm9wX3VudGFnZ2VkID0ga3N6
OTQ3N19wb3J0X2Ryb3BfdW50YWdnZWQsDQo+ID4gICAgICAgLm1pcnJvcl9hZGQgPSBrc3o5NDc3
X3BvcnRfbWlycm9yX2FkZCwNCj4gPiAgICAgICAubWlycm9yX2RlbCA9IGtzejk0NzdfcG9ydF9t
aXJyb3JfZGVsLA0KPiA+ICAgICAgIC5nZXRfY2FwcyA9IGtzejk0NzdfZ2V0X2NhcHMsDQo+ID4g
QEAgLTIyMCw2ICsyMjIsNyBAQCBzdGF0aWMgY29uc3Qgc3RydWN0IGtzel9kZXZfb3BzIGxhbjkz
N3hfZGV2X29wcw0KPiA+ID0gew0KPiA+ICAgICAgIC52bGFuX2ZpbHRlcmluZyA9IGtzejk0Nzdf
cG9ydF92bGFuX2ZpbHRlcmluZywNCj4gPiAgICAgICAudmxhbl9hZGQgPSBrc3o5NDc3X3BvcnRf
dmxhbl9hZGQsDQo+ID4gICAgICAgLnZsYW5fZGVsID0ga3N6OTQ3N19wb3J0X3ZsYW5fZGVsLA0K
PiA+ICsgICAgIC5kcm9wX3VudGFnZ2VkID0ga3N6OTQ3N19wb3J0X2Ryb3BfdW50YWdnZWQsDQo+
ID4gICAgICAgLm1pcnJvcl9hZGQgPSBrc3o5NDc3X3BvcnRfbWlycm9yX2FkZCwNCj4gPiAgICAg
ICAubWlycm9yX2RlbCA9IGtzejk0NzdfcG9ydF9taXJyb3JfZGVsLA0KPiA+ICAgICAgIC5nZXRf
Y2FwcyA9IGxhbjkzN3hfcGh5bGlua19nZXRfY2FwcywNCj4gPiBAQCAtMTI1NCw2ICsxMjU3LDkg
QEAgc3RhdGljIGludCBrc3pfZW5hYmxlX3BvcnQoc3RydWN0IGRzYV9zd2l0Y2gNCj4gPiAqZHMs
IGludCBwb3J0LA0KPiA+ICB7DQo+ID4gICAgICAgc3RydWN0IGtzel9kZXZpY2UgKmRldiA9IGRz
LT5wcml2Ow0KPiA+IA0KPiA+ICsgICAgIGRldi0+ZGV2X29wcy0+dmxhbl9hZGQoZGV2LCBwb3J0
LCBLU1pfREVGQVVMVF9WTEFOLA0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgQlJJ
REdFX1ZMQU5fSU5GT19VTlRBR0dFRCk7DQo+ID4gKw0KPiANCj4gSG93IG1hbnkgdGltZXMgY2Fu
IHRoaXMgYmUgZXhlY3V0ZWQgYmVmb3JlIHRoZSBWTEFOIGFkZCBvcGVyYXRpb24NCj4gZmFpbHMN
Cj4gZHVlIHRvIHRoZSBWTEFOIGFscmVhZHkgYmVpbmcgcHJlc2VudCBvbiB0aGUgcG9ydD8gSSBu
b3RpY2UgeW91J3JlDQo+IGlnbm9yaW5nIHRoZSByZXR1cm4gY29kZS4gV291bGRuJ3QgaXQgYmUg
YmV0dGVyIHRvIGRvIHRoaXMgYXQNCj4gcG9ydF9zZXR1cCgpIHRpbWUgaW5zdGVhZD8NCj4gDQo+
IChzaWRlIG5vdGUsIHRoZSBQVklEIGZvciBzdGFuZGFsb25lIG1vZGUgY2FuIGJlIGFkZGVkIGF0
IHBvcnRfc2V0dXANCj4gdGltZS4gVGhlIFBWSUQgdG8gdXNlIGZvciBicmlkZ2VzIGluIFZMQU4t
dW5hd2FyZSBtb2RlIGNhbiBiZQ0KPiBhbGxvY2F0ZWQNCj4gYXQgcG9ydF9icmlkZ2Vfam9pbiB0
aW1lKQ0KDQpPay4gSSB3aWxsIGFkZCBpbiBwb3J0X2JyaWRnZV9qb2luIGZ1bmN0aW9uIGZvciBi
cmlkZ2Ugdmxhbl9hd2FyZQ0KcG9ydHMuDQoNCj4gDQo+ID4gICAgICAgaWYgKCFkc2FfaXNfdXNl
cl9wb3J0KGRzLCBwb3J0KSkNCj4gPiAgICAgICAgICAgICAgIHJldHVybiAwOw0KPiA+IA0KPiA+
ICtzdGF0aWMgaW50IGtzel9jb21taXRfcHZpZChzdHJ1Y3QgZHNhX3N3aXRjaCAqZHMsIGludCBw
b3J0KQ0KPiA+ICt7DQo+ID4gKyAgICAgc3RydWN0IGRzYV9wb3J0ICpkcCA9IGRzYV90b19wb3J0
KGRzLCBwb3J0KTsNCj4gPiArICAgICBzdHJ1Y3QgbmV0X2RldmljZSAqYnIgPSBkc2FfcG9ydF9i
cmlkZ2VfZGV2X2dldChkcCk7DQo+ID4gKyAgICAgc3RydWN0IGtzel9kZXZpY2UgKmRldiA9IGRz
LT5wcml2Ow0KPiA+ICsgICAgIHUxNiBwdmlkID0gS1NaX0RFRkFVTFRfVkxBTjsNCj4gPiArICAg
ICBib29sIGRyb3BfdW50YWdnZWQgPSBmYWxzZTsNCj4gPiArICAgICBzdHJ1Y3Qga3N6X3BvcnQg
KnA7DQo+ID4gKw0KPiA+ICsgICAgIHAgPSAmZGV2LT5wb3J0c1twb3J0XTsNCj4gPiArDQo+ID4g
KyAgICAgaWYgKGJyICYmIGJyX3ZsYW5fZW5hYmxlZChicikpIHsNCj4gPiArICAgICAgICAgICAg
IHB2aWQgPSBwLT5icmlkZ2VfcHZpZC52aWQ7DQo+ID4gKyAgICAgICAgICAgICBkcm9wX3VudGFn
Z2VkID0gIXAtPmJyaWRnZV9wdmlkLnZhbGlkOw0KPiA+ICsgICAgIH0NCj4gDQo+IFRoaXMgaXMg
YmV0dGVyIGluIHRoZSBzZW5zZSB0aGF0IGl0IHJlc29sdmVzIHRoZSBuZWVkIGZvciB0aGUNCj4g
Y29uZmlndXJlX3ZsYW5fd2hpbGVfbm90X2ZpbHRlcmluZyBoYWNrLiBCdXQgc3RhbmRhbG9uZSBh
bmQgVkxBTi0NCj4gdW5hd2FyZQ0KPiBicmlkZ2UgcG9ydHMgc3RpbGwgc2hhcmUgdGhlIHNhbWUg
UFZJRC4gRXZlbiBtb3JlIHNvLCBzdGFuZGFsb25lDQo+IHBvcnRzDQo+IGhhdmUgYWRkcmVzcyBs
ZWFybmluZyBlbmFibGVkLCB3aGljaCB3aWxsIHBvaXNvbiB0aGUgYWRkcmVzcyBkYXRhYmFzZQ0K
PiBvZg0KPiBWTEFOLXVuYXdhcmUgYnJpZGdlIHBvcnRzIChhbmQgb2Ygb3RoZXIgc3RhbmRhbG9u
ZSBwb3J0cyk6DQo+IA0KaHR0cHM6Ly9wYXRjaHdvcmsua2VybmVsLm9yZy9wcm9qZWN0L25ldGRl
dmJwZi9wYXRjaC8yMDIyMDgwMjAwMjYzNi4zOTYzMDI1LTEtdmxhZGltaXIub2x0ZWFuQG54cC5j
b20vDQo+IA0KPiBBcmUgeW91IGdvaW5nIHRvIGRvIGZ1cnRoZXIgd29yayBpbiB0aGlzIGFyZWE/
DQoNCkZvciBub3csIEkgdGhvdWdodCBJIGNhbiBmaXggdGhlIGlzc3VlIGZvciBicmlkZ2Ugdmxh
biB1bmF3YXJlIHBvcnQuIEkNCmhhdmUgZmV3IG90aGVyIHBhdGNoIHNlcmllcyB0byBiZSBzdWJt
aXR0ZWQgbGlrZSBnUFRQLCB0YyBjb21tYW5kcy4gSWYNCnN0YW5kYWxvbmUgcG9ydCBmaXggYWxz
byBuZWVkZWQgZm9yIHlvdXIgcGF0Y2ggc2VyaWVzIEkgY2FuIHdvcmsgb24gaXQNCm90aGVyd2lz
ZSBJIGNhbiB0YWtlIHVwIGxhdGVyIHN0YWdlLg0KDQoNCj4gDQo+ID4gKw0KPiA+ICsgICAgIGtz
el9zZXRfcHZpZChkZXYsIHBvcnQsIHB2aWQpOw0KPiA+ICsNCj4gPiArICAgICBpZiAoZGV2LT5k
ZXZfb3BzLT5kcm9wX3VudGFnZ2VkKQ0KPiA+ICsgICAgICAgICAgICAgZGV2LT5kZXZfb3BzLT5k
cm9wX3VudGFnZ2VkKGRldiwgcG9ydCwNCj4gPiBkcm9wX3VudGFnZ2VkKTsNCj4gPiArDQo+ID4g
KyAgICAgcmV0dXJuIDA7DQo+ID4gK30NCg==
