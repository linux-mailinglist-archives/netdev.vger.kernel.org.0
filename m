Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 547F66C7667
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 04:58:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230335AbjCXD63 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 23:58:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbjCXD62 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 23:58:28 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A593616327;
        Thu, 23 Mar 2023 20:58:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1679630307; x=1711166307;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=a6C4fnPvmUuRpnUmcEIy8os0zLhZy0nCJGfjKBje04Y=;
  b=NhmabiL3aOJiCkIGczqCXFOS+RgCA81Kxs5pBmpxDrPXd6XDQJqfk1Rm
   uaEm4ZaFKG4AJ617+VdYVpolFaAY2z2yITPq9jWrlaIN5mFIibxlEFWlH
   JOGTk0yzYmdqXoZJjRK0UNfbU6znKAsEw8WtdirwX9Dj8zieMx05BVb9s
   u1qwCv96Hq1v+uIk4/2eqHj+SZbCe0usW8kHnNUMPmENN3nVnyXxykjFZ
   Bqnl/uuAcTG9Mb2lvzHhbGcmHCVY3o+Hd6wF+PuZCBbZVqUJ8v0g/gS1e
   K9UCX36wnIbcy7jW1adWkffW47lerHpcNmCSSYR8EXDJ7vq1cE+JO53Wy
   Q==;
X-IronPort-AV: E=Sophos;i="5.98,286,1673938800"; 
   d="scan'208";a="206143195"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 23 Mar 2023 20:58:24 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 23 Mar 2023 20:58:23 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Thu, 23 Mar 2023 20:58:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QbF0auTv2mHwKf4NOXupbeeHVx5rUtodiWaFRTW5VbPn4vO4A8E1z/seD/0jn2wNyP7Kw5Qa3tp+kobH9Sv/lh254yEcxxMiadrDuUdTNgz7KamBmN0QybUQ4ChhcHPDmReHQJRPXJCemUnxpV8/vLau4YZWE+o1Kxge1QbzN0J5uDVDDvltss3y/BqBifqysCDtVaGCAF4dfojIJAWItD4bp916O3ugyoRx29WuLfTayPRU4vWhSvU+54o5KvTNyZ9c1m/wUf3tti8VCFlA6cFdE0XTuHi5lK6ctvuCG35D1d5/FW8P3NrYYD8rgFcZaHeWeNUb3jrYpJ65m9RNKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a6C4fnPvmUuRpnUmcEIy8os0zLhZy0nCJGfjKBje04Y=;
 b=Orc7bwdATbCn68KvrcgoTKIFUiIxnce8by3qZ1BK/Y7NxWjtg4VLNAN9OASd+pR9nVQGC7MoxRiNtbL9xrX2femWbZIazW1V7cv9j7kDRH3S2J4oyT+qoLwzloJcjpf7qkl5LcC3jPNgqYvXaZpguXAhMpUcQC9yeFCe7R0up33dwGdpu1BP8DyGhOVXMrCzOo95fb7Qrdf3xYJgPiLMFE39TEmeGHSb9W+iAHrpl/6Vd48jkvjEEGXRFYe+KFYot6EKcNVbic7Ri2nd7TeLh1k+YZGOBWaFpAPL9zVA/cgBWZ60tigmdxNYgOx9T7vfB28GmLLPE6tKFJzEEhyYng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a6C4fnPvmUuRpnUmcEIy8os0zLhZy0nCJGfjKBje04Y=;
 b=Dn17Fp3+44Usn4hrRu0MxJ4orZfYtcnFGunzpOFLyOepR4xlDFv1UggJKToSBJAuGbDb8NuY9khXrEENy5w0t8ecI7CP6KoRpsS8jdnnNclHRkzCLTbnttuAldp/MfZNo19MHmk+8uZWKmENQMB2TJjYma3mV+uNMj3xQIgLaRI=
Received: from DM5PR11MB0076.namprd11.prod.outlook.com (2603:10b6:4:6b::28) by
 DS7PR11MB6038.namprd11.prod.outlook.com (2603:10b6:8:75::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.38; Fri, 24 Mar 2023 03:58:20 +0000
Received: from DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::cbd2:3e6c:cad1:1a00]) by DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::cbd2:3e6c:cad1:1a00%3]) with mapi id 15.20.6178.037; Fri, 24 Mar 2023
 03:58:20 +0000
From:   <Arun.Ramadoss@microchip.com>
To:     <olteanv@gmail.com>, <andrew@lunn.ch>, <f.fainelli@gmail.com>,
        <kuba@kernel.org>, <edumazet@google.com>, <pabeni@redhat.com>,
        <o.rempel@pengutronix.de>, <Woojung.Huh@microchip.com>,
        <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <UNGLinuxDriver@microchip.com>, <kernel@pengutronix.de>
Subject: Re: [PATCH net v1 3/6] net: dsa: microchip: ksz8: fix offset for the
 timestamp filed
Thread-Topic: [PATCH net v1 3/6] net: dsa: microchip: ksz8: fix offset for the
 timestamp filed
Thread-Index: AQHZXMs8vdViPF0dQkm4M1YtwYHAOq8JUCUA
Date:   Fri, 24 Mar 2023 03:58:20 +0000
Message-ID: <47e5a49ed1d09a529945e4c39be5da2c6cee86ed.camel@microchip.com>
References: <20230322143130.1432106-1-o.rempel@pengutronix.de>
         <20230322143130.1432106-4-o.rempel@pengutronix.de>
In-Reply-To: <20230322143130.1432106-4-o.rempel@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM5PR11MB0076:EE_|DS7PR11MB6038:EE_
x-ms-office365-filtering-correlation-id: a69f842d-6a17-4bb8-6fff-08db2c1c0210
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5Z/4ZnURiLqHsvsZVjQCMzXbwrZop1spA8E2Y957xw3cjXM7Szmhi7AtNNMm72JNrZH9AiAgXVxgVb0kV0dE6msurxudrdlz/cC5CqmGsqyfh+SBrSR7l2hGeZfgMyv0Z46Y/TMf6dB7Ajob3LeF8acr///QA7PYBBBbJgsZjm0Fk7WKi7y9Ng2rSfkNp0dx2ny+bk3aoqcSBOtOnpSilzx4w4YyhjWUK417QFjLWEufYzQLF70Cf4pT31Li3W8jOu5Ge6aPjM6DCAG8pbHHL/TlBbN/Q5FIqtLJBjIb+I1CwFYrkP7kY6YXlu+6h1jZrp0nklmwCMcXbVb63EYvy2o+433XRcezXyrtE7tXiOUMojWAGM2pGh8TOVic+hjO5HnwsolVOSZ8jZmwCp2Brs4f7MY6om0RgV4uSx+oD6c8eI5aGmLwXLIW/nXkAZa33ora2ir5SkfcOqxUUGMkxNF/1MM71l2xWlrPjRLH/lyge+6u7f5xMIU+4xqfubxHsbzVfhEMKFbOQNJA0YOjrM3WMMD/+JzhMa/I5LQj1KljC0XG4RQYN68mCcDd1US3SuR7zhBlCW065Dhf4gSeJglyld1ZCLm0E3Afw/rvVDupkorFHV98w9wlqmgesD1lfrCy6u22/oIaaO3qqiiCP4FmXeZjMPxFNPemtYqexCLbSCwFFtiNUXkI5mMu0/w9X1R8PCIoUVFDM7H2MqFNROcC4V5rZCd3JWiEce9g9M0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB0076.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(366004)(346002)(39860400002)(136003)(396003)(451199018)(38100700002)(38070700005)(2906002)(36756003)(83380400001)(2616005)(6486002)(71200400001)(186003)(478600001)(86362001)(110136005)(91956017)(66556008)(66446008)(66946007)(8676002)(66476007)(64756008)(4326008)(76116006)(54906003)(8936002)(316002)(6512007)(6506007)(26005)(122000001)(7416002)(41300700001)(5660300002)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?N1BYb3JibnVQbGJPcCsyMGNBUjBJazdvdENYVDlNMUpUOGxRRWlIQmFCYitP?=
 =?utf-8?B?U1JGYSs3T052SEc5U0h4MUsvTmtOOTdOYmhVdjZJckpaaUkyT1AzVTNlL3Za?=
 =?utf-8?B?U1laV0ErcW1WTnNiQlFKa1VkeGhReGZwRzBBZ3F3Uyt5dG5jNlU1eGtlWTBw?=
 =?utf-8?B?MEFBSURzWjhteC9JVVNqSURTTHNvTWt6VkxVYmlPUTRaMlMrMmJ4Tlp2ZExh?=
 =?utf-8?B?cFErUCs5c25URFFUeHBUNFRnNEVvdFRVeHlvRm92WmFWVVRFR0taU2RjNEtO?=
 =?utf-8?B?bFJoV25NdmVIaFFkdEthVmhjT2RlcG4rTHQvZXF4b05wNVc1MWhkMzBvR2Qr?=
 =?utf-8?B?Z3cxb0tLUnIySmZhdGFkays4M2ZuaG9aeGpqSmhpajBvWXJZUFlQd0YyZWtk?=
 =?utf-8?B?cS9kaWQ2ODJTN3VlVzllK3pKN3BqVVN4L01sVU5WemZMVnlFeWRzV1NPUHc5?=
 =?utf-8?B?UW5HZHBzMXpsOVFwYkVOejVBamFRWmM2MjNweW40dllnNGtOTHZ3Y0pGKzEz?=
 =?utf-8?B?aDc5QVFZWmE0YVpiT0NJaGJkMGlxOU9GbVVYQ04vdEpIcGRvTCthc3gybDFX?=
 =?utf-8?B?dE5FZjh4WmpJd2cxYi9IZ2pRbDZLUVhwZTVvaVU5M1FlNjE2aGFVQ2tFWkNL?=
 =?utf-8?B?TDVxU1VTcGlCUE5SVFd2U3RvSWY2N0JrbU1HMDhNTXU2OFR5cXV5ZkRUT2pq?=
 =?utf-8?B?RHlZK05HKzBPNEFJbFFSbmVodWtGdTI5V0RzR0Nhd29JUmJsMlhXbHo3bFRN?=
 =?utf-8?B?NW01QlZtL05hSmpNQVhmOUwxSjU1V1diZU5WempkTXMwSGwxU3VNOXRpQU1Z?=
 =?utf-8?B?N2l5djE3WHpKeVlDM0dDR3o0Njl0dk9HUUFYVVN6emxuUjNaT01vbHVLUzRY?=
 =?utf-8?B?RTI0UGRjdmdON0JsT252KzNJSnlCdXIrd2ZBUk9nUlR6bUtVY3FNK2dIN1pG?=
 =?utf-8?B?ZlluWWR0TFhpdW1mZjdJaE1Jcmc1S0RQSDVCYzk3c0NoRlowZzlhdkNhbVdL?=
 =?utf-8?B?a1dTQUZjcVNtM2tndldJQjBsU0piak9TYTV4MjAxVzBmVmRIL2pYc0YzQ25s?=
 =?utf-8?B?dGtHTDgyMDJiVFp3MTkvN01KSjlNZk42RzMwNE1RNjNxS0FVQ1ZuOHFGUzdn?=
 =?utf-8?B?N080MHQ0UDFZcmxpTjhwTWNic0c5TSt3NW4xM3BnVmUvU0JlSzIrcVQ4c2ZK?=
 =?utf-8?B?QVlPbEk4Y2U2QS9NVDc1U2ZJVlh0aWYyVlRBamxveWl3VHM3aW1Gd011Z3dX?=
 =?utf-8?B?RVRvUUNQdDZrMzhrSVZvL0tGcEh1T0N2YTZ0V1NsNnI1RS9aTHBCL0FqeGhq?=
 =?utf-8?B?R3pIWS94bjNyZWk0aFBVOGFtNHBXeUVCNyttczg2bDFxYmJxK1d6MDcxSjFD?=
 =?utf-8?B?eGxzc29VQnVLa29LOGZYRlZoTG9EcVBwSy9DeDZab1Vuc0cxcjJLMFczRUlG?=
 =?utf-8?B?cWVaaXB0d0hSd2lEa0dpYnJQOHR5bERrMlNCWkNsVHhGWlgrM1ovQXZrNlNI?=
 =?utf-8?B?eTR1a1NIYXRZczhraXRaaG1OODRnSEY4Qkx0WGwyMDNBMVZxZUE4UUxZa2NW?=
 =?utf-8?B?ekJPdzN0SUJjcGg3Q1ZZVTRaOUpVV3ppVkhiRjR5UyswNzRwTURTTnE4OUdS?=
 =?utf-8?B?eVBrZ0h6bzNWT1ZqQWlJSUxnR0dZaElIM0pVVmpPb3dDMHliMGg3YXhjaTM5?=
 =?utf-8?B?cWROcmFuaWhld0d4aklGdGZJOG1Eakp3V1E0ZHNrRTZCdEo5dVphQlVjd280?=
 =?utf-8?B?c2ZVNzFCODEwNE1MZVJFZE11eWVNZlFZNG94ZncwVVZqb3VwaUhBeUczYVJ1?=
 =?utf-8?B?ZEp2WW42WHNla0VhWXN2S0FreERtOXBHaHROVTQ4alk0V3Z5ZnJJcnZxOVg0?=
 =?utf-8?B?MUpJZ0E2VitKRUZHOURjbUFjQWNDVjFFSUhqT1RDRWNQRldBUmFRb3I4czF4?=
 =?utf-8?B?NjRoRGxYRTE5aWV6Rm1NYitUbTdOdFNTd2JnVEVxUTVGUG5JbU5EcUwwKzAr?=
 =?utf-8?B?bmhlUitHTzd2eUkwR0JYVmJBSy9PU1M1Tk8rNXg2Mk1lendMUU1oa3VabE5x?=
 =?utf-8?B?OUFQOFBQbWxWSGVKNFBoaDUxc0Q3NWg1UkZlS0xXM3czR3hpSlREZ09Zdm16?=
 =?utf-8?B?bkVxelBld3hHS0lUNUhwemRrQWxXMUpoUzZmS0hEcnFZK0FESHR6RmxWZHF2?=
 =?utf-8?Q?EKc/mV/O54vwWF9dF+SSSYE=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DFAA3F6D936B2B4A9BA1F0026F8630C2@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB0076.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a69f842d-6a17-4bb8-6fff-08db2c1c0210
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Mar 2023 03:58:20.7926
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: S/Wm4Rk1ulasPa/I8YPyrPjCV3Ia6WHkkCKlKGxAl5hwA+On1dpWxaE83xeCKMU8pV2b8U616QjLVDSag1Afw0UMIsAMmM6bJ+BAPpXW19U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6038
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgT2xla3NpaiwNCg0KT24gV2VkLCAyMDIzLTAzLTIyIGF0IDE1OjMxICswMTAwLCBPbGVrc2lq
IFJlbXBlbCB3cm90ZToNCj4gRVhURVJOQUwgRU1BSUw6IERvIG5vdCBjbGljayBsaW5rcyBvciBv
cGVuIGF0dGFjaG1lbnRzIHVubGVzcyB5b3UNCj4ga25vdyB0aGUgY29udGVudCBpcyBzYWZlDQo+
IA0KPiBXZSBhcmUgdXNpbmcgd3Jvbmcgb2Zmc2V0LCBzbyB3ZSB3aWxsIGdldCBub3QgYSB0aW1l
c3RhbXAuDQo+IA0KPiBGaXhlczogZDIzYTVlMTg2MDZjICgibmV0OiBkc2E6IG1pY3JvY2hpcDog
bW92ZSBrc3o4LT5tYXNrcyB0bw0KPiBrc3pfY29tbW9uIikNCj4gU2lnbmVkLW9mZi1ieTogT2xl
a3NpaiBSZW1wZWwgPG8ucmVtcGVsQHBlbmd1dHJvbml4LmRlPg0KPiAtLS0NCj4gIGRyaXZlcnMv
bmV0L2RzYS9taWNyb2NoaXAva3N6X2NvbW1vbi5jIHwgMiArLQ0KPiAgMSBmaWxlIGNoYW5nZWQs
IDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVy
cy9uZXQvZHNhL21pY3JvY2hpcC9rc3pfY29tbW9uLmMNCj4gYi9kcml2ZXJzL25ldC9kc2EvbWlj
cm9jaGlwL2tzel9jb21tb24uYw0KPiBpbmRleCAzYTFhZmM5ZjQ2MjEuLmM5MTQ0NDk2NDVjYSAx
MDA2NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQvZHNhL21pY3JvY2hpcC9rc3pfY29tbW9uLmMNCj4g
KysrIGIvZHJpdmVycy9uZXQvZHNhL21pY3JvY2hpcC9rc3pfY29tbW9uLmMNCj4gQEAgLTQyMyw3
ICs0MjMsNyBAQCBzdGF0aWMgdTgga3N6ODg2M19zaGlmdHNbXSA9IHsNCj4gICAgICAgICBbRFlO
QU1JQ19NQUNfRU5UUklFU19IXSAgICAgICAgID0gOCwNCj4gICAgICAgICBbRFlOQU1JQ19NQUNf
RU5UUklFU10gICAgICAgICAgID0gMjQsDQo+ICAgICAgICAgW0RZTkFNSUNfTUFDX0ZJRF0gICAg
ICAgICAgICAgICA9IDE2LA0KPiAtICAgICAgIFtEWU5BTUlDX01BQ19USU1FU1RBTVBdICAgICAg
ICAgPSAyNCwNCj4gKyAgICAgICBbRFlOQU1JQ19NQUNfVElNRVNUQU1QXSAgICAgICAgID0gMjIs
DQoNCkNyb3NzIHZlcmlmaWVkIHRoZSBiaXQgbWFzayB3aXRoIGRhdGFzaGVldC4gDQpQYXRjaCBs
b29rcyBnb29kIHRvIG1lLg0KDQpBY2tlZC1ieTogQXJ1biBSYW1hZG9zcyA8YXJ1bi5yYW1hZG9z
c0BtaWNyb2NoaXAuY29tPg0KDQo+ICAgICAgICAgW0RZTkFNSUNfTUFDX1NSQ19QT1JUXSAgICAg
ICAgICA9IDIwLA0KPiAgfTsNCj4gDQo+IC0tDQo+IDIuMzAuMg0KPiANCg==
