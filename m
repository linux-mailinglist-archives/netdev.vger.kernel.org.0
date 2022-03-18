Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D33B34DD9C0
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 13:31:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236254AbiCRMcO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 08:32:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236266AbiCRMcL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 08:32:11 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51AD62E518C
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 05:30:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1647606650; x=1679142650;
  h=from:to:cc:subject:date:message-id:content-id:
   content-transfer-encoding:mime-version;
  bh=k90mwmM57+qze7T3j4wXqXLE9EpoOrRVTlodtOgJcEg=;
  b=xQunAqSRqdy/JXG5zQspPZDLA0ElqUPhSAzjUzYU4UZJgZ9qJUK/UOkO
   q78v9nKltuXW0CZFzbJSkBiJC+Lb3ot18j9WnDJmRYZ//ALsDaENQYQlb
   nkHuGbcdoa4LlzoF4E/rb6WXXqm572QrwvhYUWfJ4yCF7sXZgiv/L2qzx
   oalrGPLzL2zwYnXbtbHQbOwDteAbP+e2ef72ySBl4pxEl5q/kWROv2ZiG
   kDkDyZ1Wt5lup/wHcHZMWwgznpFFSHT188/5yQuDisyQnuQ1BHtKHqBc4
   DAH6xgLnHVNr7jvcjPi+djZjXp3mZTmgCeoO8MVAu1MqwncoKXA9Kcj76
   Q==;
X-IronPort-AV: E=Sophos;i="5.90,192,1643698800"; 
   d="scan'208";a="89388978"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 18 Mar 2022 05:30:49 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 18 Mar 2022 05:30:49 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17 via Frontend Transport; Fri, 18 Mar 2022 05:30:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O6fThhGWdCk+TKxh6LAPlI+umL4x2eZ6O9pAJecgkdxSrQZJouq0eEul0JeScGlJmabVSyOp8unkLkqkVDh3zHI2s1XPCTrKf180VAPHrs/3NwrMEmpRQenQMnuaNxa/0xDfO152TunHXE7Y41550qxpRWQJVuiygddPmXASbVPmiti5SOnLE5ux1uv7rzpsuYuCXffdMOhcjatFranVEfXbkFVJqyTjrWG2cUrYYMLVQdB8zbDZv3eTb0mNpDgsrSxKIQGyRkWFFZFg3IixH21RdLeRz3MGEjTSIfGoSjgU1XpqAA7Fyp1emLyCtHKyHLm1+oY8nsbsF6Y8klAq9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k90mwmM57+qze7T3j4wXqXLE9EpoOrRVTlodtOgJcEg=;
 b=MUiXV9OKh7gE2pXr9P9CRsHULGNSzFfJr+uee7VNa+KkV146taMsp/WM8i5UU//GDmGsImH2ed+an86JwdgTXxBPV/YPdL3TGzF9V0g9VHiZsttkYa/4LvCb+4S2W3E2RMcjOn4/w2Sz8wI3xgHfOUM7JPn1wnGxIj2Xs1JOLrh9iD1iDaConejp1pYMSnQKdRWkOGHLI0zXXczZNDRyFfYqkj970gmcIg7Y6JUFQRKN8mtQJ2oVAfrKA2m6DQ/6olqMrXcx5XJfWk20S1ikBgB0wkF+2M8MbUsQQfY+f3Rb5TkGP5i1crEajfiEp81yoZS3WJBl9u6AkiCkclwThQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k90mwmM57+qze7T3j4wXqXLE9EpoOrRVTlodtOgJcEg=;
 b=oFbQahoT5wg8FkoygO3tpsajpAjyfiu4yUFlg/r6Oj4Co14D8g2KziKM0nKMzEucA8w++a7DcBl1WGgDpQZJYTkWRItBEPbsTrnTmeOS/Pk9qOe7hZnHPScv+8C8vW6fLBFtrR/ZMPe1VsjPa7SI96oLPkR57Ozi5LGOsbAXJjk=
Received: from DM6PR11MB3532.namprd11.prod.outlook.com (2603:10b6:5:70::25) by
 SN6PR11MB2846.namprd11.prod.outlook.com (2603:10b6:805:5b::25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5081.15; Fri, 18 Mar 2022 12:30:47 +0000
Received: from DM6PR11MB3532.namprd11.prod.outlook.com
 ([fe80::80a4:33d5:2eda:d10c]) by DM6PR11MB3532.namprd11.prod.outlook.com
 ([fe80::80a4:33d5:2eda:d10c%5]) with mapi id 15.20.5081.017; Fri, 18 Mar 2022
 12:30:47 +0000
From:   <Parthiban.Veerasooran@microchip.com>
To:     <netdev@vger.kernel.org>
CC:     <Jan.Huber@microchip.com>, <Thorsten.Kummermehr@microchip.com>
Subject: Clarification on user configurable parameters implementation in PHY
 driver
Thread-Topic: Clarification on user configurable parameters implementation in
 PHY driver
Thread-Index: AQHYOsP+ZXEHwSVBmkCpZ7WDGPG+8A==
Date:   Fri, 18 Mar 2022 12:30:47 +0000
Message-ID: <e8521999-7f3a-8aa9-4e63-a81c6175c088@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a3308800-9c8f-449c-e50f-08da08db2123
x-ms-traffictypediagnostic: SN6PR11MB2846:EE_
x-microsoft-antispam-prvs: <SN6PR11MB2846D2C47B734AD7451E8FF2E3139@SN6PR11MB2846.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tip4+wYnOyeu5Nh+vtKiPDNiAwZ8M1uckDThBshSc5082GbvIeIuJfmFKZ+MI4AyNssi/ooteJj82ttwzE2qikv63pgY7OgVZHpr0dKV9nhQt7W3Wvp5Lt4LjUXSvoTA340viCxjM4rbYH6YRD8i98O10zdvT9FXiSKm5kHDk5hY913Qv90IwqyWNB+sIxXDP6eHlLBWcfNsYYWrGYbMLNGwrMgYP7dMFtDc596LkEtTq2u+CcK9Q25S8sIPFUIKujJnnFdpGv848eUi8ZXcEBBIQ5tuILroBJY/R2ydc5RKW6NS6Ty8AuGPcu9Y0gnF8i7zHD5GBEb9ThWq1sQ+x9E2sj4q8Y/N1DctMk+NqKDphb5B/CnSYrkj6mTtuF96bR5G/YdO9GCdjxd46xlHbEEQNT++yvY4sRhxeRpPK3pzAAkq+YStF24QO9d94Is+pb3ySsmDqPK2vWyyGDDgh+szFmnMg5I7Qc7yKtAZBdH8IbJyHEStMR8HHO292A1zJNCUdVHDlCyquIb29gtHICsNhZdHVJ+DZf7rpiGcVKDP4geeErH1sIDjSBSchGqwhUBBxwICyLSyiMLoOqBpCYw8kueZfHmwTEjWO0FB6AHck2hOn56Z50EvgYRqPRnsowcnyj6trHii4Qi+kOoxTlkRZfnIYBaBXWKBH7YvQLzmRmEME/OFftaonqPBQgM66JwF6g21OVOcMrqNVcJ6drJDU7Hsm5WtHI/W7tLOSlpZQ4rAL1sksEhkyTgwBD743L/hn0ZvlkEXhg+jKqiWHw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3532.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(76116006)(8676002)(91956017)(66476007)(64756008)(4326008)(66446008)(66556008)(26005)(186003)(31686004)(2616005)(36756003)(2906002)(86362001)(66946007)(31696002)(107886003)(6916009)(5660300002)(6512007)(122000001)(38070700005)(54906003)(71200400001)(38100700002)(6486002)(316002)(6506007)(508600001)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?L3p4aTQ5Ujl6VTNQRy91Nis4TDg5QTgzZm5LQ2tBQ2FjbG5jKzVUNzNkTXRi?=
 =?utf-8?B?RU1mOEg1K2tNOHEyU1QxU1NmR3VQNmtVNnJ2M1MxcWJRbjVMVFpxTzB5WElr?=
 =?utf-8?B?OUU1N0J3NkE1OG9KYlRSNzkzWWg2dDNNU2RiNjczY3R3dGFQMkE5MWxCZFNl?=
 =?utf-8?B?QURFaGduTWR2VjZURU5FZnplS2JSYnZNampTK0JJcTl3VUdFTWtGQ1lQVzF5?=
 =?utf-8?B?K2dWK1ZIRVd0MFpqWjV4cUtqcXk3azgrcFNoU3ZhWU9oT0x4dzlpQVRmZUQw?=
 =?utf-8?B?WjVGV0Q3amJJa1hzdVhrQ0VSeU41emJuSnhhSlNKZGEyUWtOUU5xbUpnTEFP?=
 =?utf-8?B?OHhuQlVYbU8rVFkzYXMrbEJiR3RncTJvTzQ1YWQxbERxV1oraVBrWjRBZzgx?=
 =?utf-8?B?cW9mWUczTXNXTGFCcWlUc2REbGF5YVdYbDZCaGptQjR4NWJpSUs3eTNZcnk5?=
 =?utf-8?B?VEJJU1I0WUs1L3RTM05GYjhwK2s1OVZOeHJMWXMyZWFBZXJTb1VWcEtsdGhJ?=
 =?utf-8?B?T2VibUtqdFlrcFV4UzlXejRPOWRvTmsrbTFCVnFnVmtZWWdFR2kraWJRZ2Fk?=
 =?utf-8?B?dXZ2SjNRWEJPNU5SVFl5cUwrVnJGRWpyamNraytLTjJZdW0rb09wQ09ZVjJi?=
 =?utf-8?B?S3pDWGhRZlRIWFNGcWxNVTRBcVZCUUpsRTZQQmNLeGhxeVNMcU5LUFBORHB5?=
 =?utf-8?B?d1c1VWJLQzRhcnF3RXRyNHdHVi9yekR5Z0ZTc0J2Qnoya2Vad3VQMG15NWl1?=
 =?utf-8?B?Zm05QVN0UTZUekFMb0kvSnk1NG5UZlRaMDQrYmFoTnF3SVMzUEZTYnRVbndT?=
 =?utf-8?B?bzBjWUdvR2x2MzltNlU2NlA2elB4clRpMlJhY0NGWU56dkNhUEZVSmI5ZVlZ?=
 =?utf-8?B?SjhFbnNoWEZ0K2tzMXYxT1NPZ2IrdC9XSVRITGpyUmxWa0ZabkFoS2JwbnhI?=
 =?utf-8?B?d0tMdG5Ncit5Uyt0OWZLdHNsdmtsZWVzekVyaE01M1FHWGpsdFQ2eXhjUHRK?=
 =?utf-8?B?d1NlQ3pLbUNja0RDaE9hRFRGaVB6WDhDSDhJVk5ENDN0ZDhZZzJTdm5PK1pP?=
 =?utf-8?B?R0FhL3F6QmRDbG9udE5XM09HU1QwaWdvbEtEVXd6MjFCYVI5QUJLMUY1aXpT?=
 =?utf-8?B?UmtSZ1JDZjlLUTd4Vm9IV0hXTzhvZlo4Zjc4dG5wZk03cEF4NFBUL1ppNnFj?=
 =?utf-8?B?c0tzdlJwMXFOdHpzTmlsdEFHWmtraitac1BEdUFUT3kyUUFXMjd2ZlRuT3BU?=
 =?utf-8?B?NE5uREFvalh1dDgwTXl3dmFyU3d1U0h3UllHSEIrL0pZVC8zL1dtU3JTOW9s?=
 =?utf-8?B?cVhOQSt2QUhCOGNTUlNvRVZMS3hsaFp1MUhUZ3BSaGZNTkJGdTk2aFRUUGwr?=
 =?utf-8?B?VDZzbmtMZVZSR0ZRR0QxNzM5UjJKUWRXL0xlMGRGa2dHRThoSTJNajJmd2pr?=
 =?utf-8?B?L1VqYTZzU091eW4zM0JtTk5kd0gvRWxGVDUybmhqOURjTlFpMGwrcmY3VEtu?=
 =?utf-8?B?RFdjaUlhUS85aWVnYU5PcktVOGg4VHQxYUlOM2gxQWlTNHZZUko5bEUrL1JE?=
 =?utf-8?B?U0hzTDROa0hWU3krVGVic2U4REhzMzhONkpGVEZQY1VudFNzbXkyVEpFZTly?=
 =?utf-8?B?WEljVFlXVk5GU1B2QzRQL1pDckpUZ3dRbEhVSFlOUExKRElpNFhkS0NIT2dI?=
 =?utf-8?B?WkJBeTFKU3VDamhKVHJLSGp3VUtqdFo2T1p6K0R6Z0lPZHFxejVhVlNldmtE?=
 =?utf-8?B?Wm12WmxScGkrMzBDNjVoajdaUXBzKytlWTRydlAxQ3JEeG1nY3ZKU1V6TTRZ?=
 =?utf-8?B?OHliZlVBelNRN1FCeWhCbG5CSlY0SmVpcFhYZzJhU1gvcStacUl4MkdYY21P?=
 =?utf-8?B?R0kycXNtUlpOUmwyckhUbHRCdHZXcWY0RW96ZExKMzFRY0VqWTZMRWVlZmJM?=
 =?utf-8?B?blhtb1JpNmJKQzJSZU9xbGZjUEVrYjg5NzJnZUttVE9SN1A2TkJKbEhsQ0pp?=
 =?utf-8?Q?uUCxY5bDnz7W5Mhg89E+bgAsmHyetc=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <270DBBCEB03D9F4791D0A1E525EACA59@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3532.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3308800-9c8f-449c-e50f-08da08db2123
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Mar 2022 12:30:47.2582
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /72e9zJhGQfe4IQh+37u/RTzzzu5aPi5xfxKsD7uYvx/P8aMfqw3LKNFVxfz3cgNo6/Z5jplxi6csnisO5OkwkoejUsDsDAM0uL0GZs1vWtLVpZRXUsIPs8+2DcwWg3c
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2846
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE,
        T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgQWxsLA0KDQpNaWNyb2NoaXAgTEFOODY3MCBpcyBhIGhpZ2gtcGVyZm9ybWFuY2UgMTBCQVNF
LVQxUyBzaW5nbGUtcGFpciBFdGhlcm5ldCANClBIWSB0cmFuc2NlaXZlciBmb3IgMTAgTWJpdC9z
IGhhbGYtZHVwbGV4IG5ldHdvcmtpbmcgb3ZlciBhIHNpbmdsZSBwYWlyIA0Kb2YgY29uZHVjdG9y
cy4gVGhlIExBTjg2NzAgaXMgZGVzaWduZWQgZm9yIHVzZSBpbiBoaWdoLXJlbGlhYmlsaXR5IGNv
c3QgDQpzZW5zaXRpdmUgaW5kdXN0cmlhbCwgYmFjayBwbGFuZSwgYW5kIGJ1aWxkaW5nIGF1dG9t
YXRpb24gDQpzZW5zb3IvYWN0dWF0b3IgYXBwbGljYXRpb25zLg0KDQpQaHlzaWNhbCBMYXllciBD
b2xsaXNpb24gQXZvaWRhbmNlIChQTENBKSBpcyBvbmUgb2YgdGhlIGZlYXR1cmVzIGluIHRoaXMg
DQpQSFkgd2hpY2ggYWxsb3dzIGZvciBoaWdoIGJhbmR3aWR0aCB1dGlsaXphdGlvbiBieSBhdm9p
ZGluZyBjb2xsaXNpb25zIA0Kb24gdGhlIHBoeXNpY2FsIGxheWVyIGFuZCBidXJzdCBtb2RlIGZv
ciB0cmFuc21pc3Npb24gb2YgbXVsdGlwbGUgDQpwYWNrZXRzIGZvciBoaWdoIHBhY2tldCByYXRl
IGxhdGVuY3ktc2Vuc2l0aXZlIGFwcGxpY2F0aW9ucy4gVGhpcyBQTENBIA0KZmVhdHVyZSB1c2Vz
IHRoZSBmb2xsb3dpbmcgdXNlciBjb25maWd1cmFibGUgcGFyYW1ldGVycyB0byBiZSBjb25maWd1
cmVkIA0KdGhyb3VnaCBQSFkgZHJpdmVyLg0KDQogwqDCoCDCoDEuIFBMQ0Egbm9kZSBpZA0KIMKg
wqAgwqAyLiBQTENBIG5vZGUgY291bnQNCiDCoMKgIMKgMy4gUExDQSB0cmFuc21pdCBvcHBvcnR1
bml0eSB0aW1lDQogwqDCoCDCoDQuIFBMQ0EgbWF4IGJ1cnN0IGNvdW50DQogwqDCoCDCoDUuIFBM
Q0EgbWF4IGJ1cnN0IHRpbWUNCiDCoMKgIMKgNi4gUExDQSBlbmFibGUvZGlzYWJsZQ0KDQpJbiB0
aGUgZXhpc3RpbmcgUEhZIGZyYW1lIHdvcmssIEkgZG9uJ3Qgc2VlIGFueSBpbnRlcmZhY2UgdG8g
ZXhwb3NlIHRoZSANCnVzZXIgY29uZmlndXJhYmxlIHBhcmFtZXRlcnMgdG8gdXNlciBzcGFjZSBm
cm9tIFBIWSBkcml2ZXIuIEkgZGlkIGV2ZW4gDQpyZWZlciBzb21lIFBIWSBkcml2ZXJzIGluIHRo
ZSBrZXJuZWwgc291cmNlIGFuZCB0aGV5IGFyZSBoYXJkIGNvZGVkIHRoZSANCmNvbmZpZ3VyYWJs
ZSB2YWx1ZXMgaW4gdGhlIGRyaXZlciBhbmQgb2YgY291cnNlIHRoZXkgYXJlIG5vdCBuZWVkZWQg
dG8gDQpiZSBjb25maWd1cmVkIGJ5IHVzZXIuDQoNCkJ1dCBpbiBvdXIgY2FzZSwgdGhlIGFib3Zl
IHBhcmFtZXRlcnMgYXJlIHVzZXIgY29uZmlndXJhYmxlIGZvciANCmRpZmZlcmVudCBub2RlcyAo
RXRoZXJuZXQgaW50ZXJmYWNlcykgaW4gdGhlIG5ldHdvcmsuDQoNCkNvdWxkIHlvdSBwbGVhc2Ug
cHJvcG9zZSBhIHJpZ2h0IGFwcHJvYWNoIHRvIGltcGxlbWVudCB0aGUgYWJvdmUgDQpyZXF1aXJl
bWVudCA/DQoNClRoYW5rcyAmIFJlZ2FyZHMsDQpQYXJ0aGliYW4gVg0KTWljcm9jaGlwIFRlY2hu
b2xvZ3kgSW5jLg0KDQo=
