Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5ACB6CB7C1
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 09:13:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbjC1HNL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 03:13:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbjC1HNJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 03:13:09 -0400
Received: from FRA01-PR2-obe.outbound.protection.outlook.com (mail-pr2fra01on2119.outbound.protection.outlook.com [40.107.12.119])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48EFC2118;
        Tue, 28 Mar 2023 00:13:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oV22Tth7vG3zKfITh8KFdlxF980/wiDi3PYq2IFdLXOkF64in5TEkuAE1dFEzhm0gv0lKcuuYWQLaPEbXj9cmGTvew/ubvfPa5EUq5m3UGZns7j6PZBhm6LTw1cIRSAki7Ohz6vLRA7mF3PAA+CtbKdTl9WvHmnZE05l9hvB70XvLLJnuEwEnU9JW1Ot1CG3nTJIBW6ZwvBsFChNzpiruOBI8S0yj8v4OZiolzoaRQvZ5tVhmrQBdpC4v/goRgZ2Yar0N1ipCtb4WRhzAAgLeQvr0v4W7GDkx6xZdfQRxPOYB77vW9XPUwqQyY7UzMF9yv+0q6lJpzBfEEddY2LcTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x9FfItd+DLXFZSqGiR2UnfW+z/bzFoKQnLUVKojVyRo=;
 b=QCV5eSwxytZ1+Rua/QEsN7BgcOUhDbplqPSNBMBYs+zOQ8Sfm2lcT1DIfBzffsMOOpa65igo6wKW4G6TotR5ctTQlaf2AKTQYmZdnAzXIL+FYvDmv+PewGdIbSP0e5LMI4omvk/q4XC4XbG2+8fsO/D10gsH8UCQaV0PnC0q0vwlpv1LD9b2ZVfkL1JJ15AwoziraMXA33YbpnbOb2DknZHAXTnV4jPTRdNrolTqTT6h/g9pZ1X8uVqBBhZ5P5vXoJP3Gf6bmyvFW8lhB+rDxoxA4ojgy4he80aqjJ0wQmdlcJ0CXgf2qeSXxATMeUdS+v0Lv2vX4v/r53Tex3BCrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ekinops.com; dmarc=pass action=none header.from=ekinops.com;
 dkim=pass header.d=ekinops.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ekinops.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x9FfItd+DLXFZSqGiR2UnfW+z/bzFoKQnLUVKojVyRo=;
 b=csJMv48x5jd7VSz6bkplKe9iXds0/AfYUHobjuuZHfcyMY8kixsbO3HefqQuXTfev5sWNr1F8UbsSVa1VKRGaMebx7ykqr2hEVJrnoaCt+dKco91tG/8xX5y12reCyQ2P1YDhllP+R+01wXSEr5on/fl7FpOfnNUVOizlWVq32Y=
Received: from PAZP264MB4064.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:141::6)
 by PAZP264MB3288.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:128::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.33; Tue, 28 Mar
 2023 07:13:05 +0000
Received: from PAZP264MB4064.FRAP264.PROD.OUTLOOK.COM
 ([fe80::e04e:6ad:dfd3:3bd7]) by PAZP264MB4064.FRAP264.PROD.OUTLOOK.COM
 ([fe80::e04e:6ad:dfd3:3bd7%6]) with mapi id 15.20.6222.033; Tue, 28 Mar 2023
 07:13:03 +0000
From:   Ganesh Babu <ganesh.babu@ekinops.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     Ganesh Babu <ganesh.babu@ekinops.com>
Subject: [PATCH] net: mroute6.h: change type of mif6c_pifi to __u32
Thread-Topic: [PATCH] net: mroute6.h: change type of mif6c_pifi to __u32
Thread-Index: AQHZYUP13XlrMpW17Ue8ZSjM0wOOKw==
Date:   Tue, 28 Mar 2023 07:13:03 +0000
Message-ID: <PAZP264MB4064279CBAB0D7672726F4A1FC889@PAZP264MB4064.FRAP264.PROD.OUTLOOK.COM>
Accept-Language: en-IN, en-US
Content-Language: en-IN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ekinops.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PAZP264MB4064:EE_|PAZP264MB3288:EE_
x-ms-office365-filtering-correlation-id: a47166bd-f6c9-424f-b9ff-08db2f5bdee0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: U13CFu2+Y4d3niwTAjzJKsz+D3tfk53A1LJWkg6i9s1pqALnrbkIg5lFr2OSIembMMvlrU+dHtoHw4+ZmzlqBQVHNr96chv6V9aozuQXJ5Yl6GdEhkAVL+ZAc8yBj16hn/FxYyvdvZlRZGTRBoAUFIMfTxYZhBfVDMlPbGWZTeoYKbQ5/Q2z6OlKiqnceN6cd33fseNJ0aljvW7eOECHXExV6LeWFbK+8/CGNN2NakQRj95y0a3O0A8OOs45UCek9t/NUtsqicpSMRt9KPAtwbJKH2nhKCrQpYZrGPQTAWaPlcJKISMm/h6q/R+sdlHJaFOCjjqI6klpE1sG1t5LAgfxe9/KmcegqytUmrkqZpCSKaW7cvX1l6FjGeAo+LEO0efgzwhYzUQZAZtTP/v6mvCIBAEq8dLUu594FxS1LvtDncAdAWl177G7OTh7YKp6elr/Q9CAAeJGWmezM5xnXzSc5OoQm1Zj2ba7gyBwpgoBgpGr2cXJaIwJp0lNCYAtscW2NhgrzTaeX+dKZDaH5HtgI34Y+LmCm38kWCtJEKGqKZ2IVD3H7nJ9xF3+kDAaHzVcWREqumDSVCzzSuPEkfoweEQltU4rRZ76z6pSNh0hPByvcSOv9oU8TkD9RYsH
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAZP264MB4064.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230028)(376002)(346002)(136003)(396003)(39850400004)(366004)(451199021)(2906002)(71200400001)(7696005)(44832011)(38100700002)(478600001)(86362001)(107886003)(38070700005)(450100002)(316002)(110136005)(122000001)(5660300002)(66556008)(41300700001)(66446008)(64756008)(8676002)(4326008)(52536014)(76116006)(66476007)(91956017)(66946007)(8936002)(55016003)(186003)(33656002)(55236004)(6506007)(53546011)(9686003)(26005)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?Yipj2eRJGFBJPGksw8AaLiWqvIJ50PJypR8hUQtrAtIHNuPmFaidTiYugz?=
 =?iso-8859-1?Q?GT8jVk67UG0dIKQejNweXZebPAFVk2s4VzkT3eE9yjBn7YDwJUGXZJO5Be?=
 =?iso-8859-1?Q?wNnoTyaeFZKj3B4c0f5jOa/u0pxQ2bQpDri8n2sqj1iVX5L/kzgCajp8ZV?=
 =?iso-8859-1?Q?+7zKEsYC9ybU7FTHrPaJGB4NTuL+6IGresXIwyMI1UjBvN9xLxA3BqC9+v?=
 =?iso-8859-1?Q?P2WWoI3lIxoI/zEL2QRrwg+WAS9Y0oWSeNwWjrXYe99FbRf8fJaiSMPRuI?=
 =?iso-8859-1?Q?lh3ZkhuuR7SxRm46yP8R/e+rOUeRkDnB3YGLpeyq6di9cx4t6ApafBbigI?=
 =?iso-8859-1?Q?991itgwQcem6OdO2nWhOB8QLlyAEsIqs7vkCebrXYIrrXtrF8IJoOaYvGD?=
 =?iso-8859-1?Q?Nb8f311Gc725ChOv+APTPSsOcEXrrb2kCKG6IqxEB/0mDh35f++TABZo6o?=
 =?iso-8859-1?Q?wSuVKXGrLoNvRQ4z3XKHupB3KxJck2l7+ACp+snFm9IQi2fc0Hna8eKRqG?=
 =?iso-8859-1?Q?G6OuluwZZ4pDaAmLK1SEzizqn13pmJSyLfT8yPGkfi52FbOVGTaooH6Mbl?=
 =?iso-8859-1?Q?FkpS+c70YVnbCx9mxSFGf157WdajDjOD4PBfyMYs8rjT87RkvNjTzHTFzE?=
 =?iso-8859-1?Q?88SJWLg4bSZ2EIgTyjfYB49CTacqlrn/JaFsPnfUK7R/aSThOw69Cwz33C?=
 =?iso-8859-1?Q?iXnHLRF2AnG0bmksyOrKTBvAqOcSLxxGljSzNQc6G9DomUB1Om7OqlZ5xl?=
 =?iso-8859-1?Q?xNYMiSMhSa3A0nk9BkR/KCS6bKCBmwgdm48nJbs+6ASc1j4kshRds02DEI?=
 =?iso-8859-1?Q?N71RfygljeMU5uYUIUnAxgR9x23twnFtuyq7jZRKZIgWjHGlQcJp5LdUgv?=
 =?iso-8859-1?Q?qzv89e/Vpt7AOrzVSrzPPw0uOCMAz9tZP6+Z6cXF8sDz4ozpo6UZMdLToI?=
 =?iso-8859-1?Q?GBW9p6SKwr8M7wN9QfEWIHLQ6gPbZIvAkWhKEO8DPsDmJzcFGiT4rD5uPj?=
 =?iso-8859-1?Q?IAS7sd03cSYpMfwrvIp7eH5YwBwDzu42iWdkaDLV96yJ6L7MFFvVFfV044?=
 =?iso-8859-1?Q?b1u4YdcDZ0KTyk6fce8qtfixMBjmyvS44kuA8k2eHdvroP0VT95tyfGYea?=
 =?iso-8859-1?Q?BQYsrK9s78Jgqz9xb8IcJb7wf49w2RiAVEsKuKTk3+FGZcgdlwpDMfCQ0D?=
 =?iso-8859-1?Q?OIyEmoFS8t6zqGznzWfPgXQ+ZE5BZA/Wm20by8Jn1px1VIEtBrsOiOPO6P?=
 =?iso-8859-1?Q?B7c2TlkSuZkXi0NnGO4XFxu1trRgrWlNRDR/bqj3l4LnVT35Bc3sLDAGTs?=
 =?iso-8859-1?Q?BaQgD2l3UXncw2Vhhb8nBtuHEPVWtiw/UZchEQdJZZ82Wq46LRz6zOxvke?=
 =?iso-8859-1?Q?Pn2rQ3/L8kn5mRuHWKRcz+pWki1a97blmiVaGdqIE/M+sNw3WyWflAQhpk?=
 =?iso-8859-1?Q?lMLIcep7L+mwDdDr7eEQY5NrjGLehuqMqvypdlSlXDJPJU/40lvN1e17Wc?=
 =?iso-8859-1?Q?7pwjxFlBGbXL0qEjnaY1O86gHdn9Syegl6qG5XL2WKK63v8b0lvwKjAyQb?=
 =?iso-8859-1?Q?or+Oj2pW5qxbdE+WpojB9jcDCa1YSS7zDkf6SEg8L6QHJIzOY4nAMT20Aw?=
 =?iso-8859-1?Q?5f4EtpsRk9OaTMMJkN58IdLgBvbICqbyNH?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: ekinops.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PAZP264MB4064.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: a47166bd-f6c9-424f-b9ff-08db2f5bdee0
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Mar 2023 07:13:03.0241
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f57b78a6-c654-4771-a72f-837275f46179
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Brk1haTMeJtpxUKoz0doilpyhgQ2XRTI0HP96xfdXPV09RCipdf8Cf1G0BHoI/foRTpdxnNeA9ufD/cwq4QmGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAZP264MB3288
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From a91f11fe060729d0009a3271e3a92cead88e2656 Mon Sep 17 00:00:00 2001=0A=
From: "Ganesh Babu" <ganesh.babu@ekinops.com>=0A=
Date: Wed, 15 Mar 2023 15:01:39 +0530=0A=
Subject: [PATCH] net: mroute6.h: change type of mif6c_pifi to __u32=0A=
=0A=
Increase mif6c_pifi field in mif6ctl struct=0A=
from 16 to 32 bits to support 32-bit ifindices.=0A=
The field stores the physical interface (ifindex) for a multicast group.=0A=
Passing a 32-bit ifindex via MRT6_ADD_MIF socket option=0A=
from user space can cause unpredictable behavior in PIM6.=0A=
Changing mif6c_pifi to __u32 allows kernel to handle=0A=
32-bit ifindex values without issues.=0A=
=0A=
---=0A=
=A0include/uapi/linux/mroute6.h | 2 +-=0A=
=A01 file changed, 1 insertion(+), 1 deletion(-)=0A=
=0A=
diff --git a/include/uapi/linux/mroute6.h b/include/uapi/linux/mroute6.h=0A=
index 1d90c21a6251..90e6e771beab 100644=0A=
--- a/include/uapi/linux/mroute6.h=0A=
+++ b/include/uapi/linux/mroute6.h=0A=
@@ -75,7 +75,7 @@ struct mif6ctl {=0A=
=A0 =A0 =A0 =A0 mifi_t =A0mif6c_mifi; =A0 =A0 =A0 =A0 =A0 =A0 /* Index of M=
IF */=0A=
=A0 =A0 =A0 =A0 unsigned char mif6c_flags; =A0 =A0 =A0/* MIFF_ flags */=0A=
=A0 =A0 =A0 =A0 unsigned char vifc_threshold; =A0 /* ttl limit */=0A=
- =A0 =A0 =A0 __u16 =A0 =A0mif6c_pifi; =A0 =A0 =A0 =A0 =A0 =A0/* the index =
of the physical IF */=0A=
+ =A0 =A0 =A0 __u32 =A0 =A0mif6c_pifi; =A0 =A0 =A0 =A0 =A0 =A0/* the index =
of the physical IF */=0A=
=A0 =A0 =A0 =A0 unsigned int vifc_rate_limit; =A0 /* Rate limiter values (N=
I) */=0A=
=A0};=0A=
=0A=
--=0A=
2.11.0=0A=
=0A=
Signed-off-by: Ganesh Babu <ganesh.babu@ekinops.com>=0A=
---=0A=
