Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60C5B5AB971
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 22:25:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229932AbiIBUYs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 16:24:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229999AbiIBUYd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 16:24:33 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE888AE7F;
        Fri,  2 Sep 2022 13:24:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1662150268; x=1693686268;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=nkVa+16eMSYeqPoPfRZV+s2AaexWLNOgRvZusEbiZKY=;
  b=xiTMRhK6u9A7ZY3F9IZlF/B9OBu+nDjSmZmM0wVdIIVoAv+9hph+DDJ6
   R+7Hr5or9qYz/n8TgJJtEECoD1EIpuS4tQR76ip+UxGO5a+9KpBhDBaws
   h2beyUzLmZDuC/aCIHJTUS9LbWT/sh4s4KiYjMic+sW5IUgAIfs0Tovv5
   eW5lTdbUgeYy2BXAb7bnS3GeWSbgHdBshMr9g5IeoLSczNE+dDmVYJIgF
   ldfnTlEVoV1zfx0maagce598iUSwXtfFFgBnGcvGBQR5JXC49mGkVoDkZ
   HdBHpO1EHfrA9x3idlIZL76Qmu4Jwl4UlkO6p0JBhDl0jzMbUIaTIxEp7
   w==;
X-IronPort-AV: E=Sophos;i="5.93,285,1654585200"; 
   d="scan'208";a="178990148"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Sep 2022 13:24:23 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Fri, 2 Sep 2022 13:24:23 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.12 via Frontend
 Transport; Fri, 2 Sep 2022 13:24:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iH7DBS4Gn+8clTb0+tMjwOPKzcXUN7Sm0EyD9rR5rd0NzXjpdSUehZ0/21RVHE5MT2doJ05bHFXqzRamfGkfLxYudeUyMINrsQ78wAlUj0RfwBuTwBBlR30w+EgK5YLFZ9QF1B+yqROlaJUyz9PfZmGFyJtGTQEhRxijnBFA+O8rLLe5SMwxrofwpDqmAdVAcAT7oJmGJbKikd/EG9wYEN7XJyk8ktBj4I4hdTfVP1B29Otlxx13TJrIduocINRC0zkd84I2OL/y+82jPvwiOSU+Tpgl1/P/ft4CotMU5mw4GgQqDqmAX7zgx9BvptZo+6HtC3hyc3I/egKfoREIyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=81ECfSNGDQvddE/lWAJuKc5w3EpjGvAssZRrkLA41GA=;
 b=ZQUSJhdqjeztkPxcrk8qzEpfrnbcdWLJLayPMv6B1m+U8fGfNvPi2qskDcYiE/ZvxfuZdOhRds+TJBXt0RXKpC0OzZ+1gM0fB96dTufnvlVX01kCic2YbHqBwD2Vyd3Rn2z/5t2Ck0X1NbDdvjBPQWMMLCgO0OjIaSWPMoKSJe5iIwePXU1/A8yUreTH1qxvZwT83iJOoviB0msrvJDNpfCx1hMvetSAVaqk21nDlmcjbV9GEf7wZwrEKk4g7ccKgO3ygCErBJgcN1SigbY21eGVfQLPLmCcvstKZEOmoxNw0R1pb8GproZOfH3SNiSIZ3Vw/QRSB3xMtG40E1cz0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=81ECfSNGDQvddE/lWAJuKc5w3EpjGvAssZRrkLA41GA=;
 b=SWBORKe5Sv2iTmHqQnq+9k+RDxBhOF2jyX2LC2btrZ6gbkEE6aHFv0lwAnMIF4y1Pt3YgMeZOLlPkPjiIaKc+5d8l6/cqfA98LYcxmyPEqgCzPYR7avkEUb5J3eGuckawj82oKifa5tZpL28/1JsGXTyP1WlNXlC1Qki1wpow08=
Received: from MWHPR11MB1693.namprd11.prod.outlook.com (2603:10b6:300:2b::21)
 by BY5PR11MB4274.namprd11.prod.outlook.com (2603:10b6:a03:1c1::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Fri, 2 Sep
 2022 20:24:20 +0000
Received: from MWHPR11MB1693.namprd11.prod.outlook.com
 ([fe80::ccae:ffc6:d9f5:8535]) by MWHPR11MB1693.namprd11.prod.outlook.com
 ([fe80::ccae:ffc6:d9f5:8535%9]) with mapi id 15.20.5588.011; Fri, 2 Sep 2022
 20:24:19 +0000
From:   <Jerry.Ray@microchip.com>
To:     <andrew@lunn.ch>
CC:     <vivien.didelot@gmail.com>, <f.fainelli@gmail.com>,
        <olteanv@gmail.com>, <davem@davemloft.net>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 2/2] net: dsa: LAN9303: Add basic support for LAN9354
Thread-Topic: [PATCH 2/2] net: dsa: LAN9303: Add basic support for LAN9354
Thread-Index: AQHYu9FcWcp1m2N/pU+7PwCEJwtzQq3GQbAAgAZaRHA=
Date:   Fri, 2 Sep 2022 20:24:19 +0000
Message-ID: <MWHPR11MB169358E09B6F24D8E582CB09EF7A9@MWHPR11MB1693.namprd11.prod.outlook.com>
References: <20220829180037.31078-1-jerry.ray@microchip.com>
 <20220829180037.31078-2-jerry.ray@microchip.com> <Yw0R7u1qV9tLSCnu@lunn.ch>
In-Reply-To: <Yw0R7u1qV9tLSCnu@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fb1ffc76-bb15-4bdf-6d1a-08da8d211dbd
x-ms-traffictypediagnostic: BY5PR11MB4274:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 75WK8VrY/xis2w60JBsVWZVWRyvNI3a+P+grQQfuNFuiahMSNfOLkHfp9+iraDf8UrE9y112e40BPuD+3TJmM+iylsBV+7D8tQ/yGN7eEtw+gBfjD+OTCweee5hlkh1lIRcCl7qU82Lp7bafLsgX10Fn2EUXG+I3GAoqw13u2dYLxXLfNSr6/RpvsojccXmaNL9wSs2QTvvjfjm7PnJJi1W/KqxA1Sl0cSPfXF7fPWjLX9g88jyzYAmpEOrF7s4OXQdafWcbsvEzvEhm5SPaNmW3ov0eVJRBTwZHHijpxZrtpY/J5qQFNEomxSyquRhHi3dGhdzTIhTQIkRVC605/vEQDmc0iWy8Fx0GX/78gi4tEB0aOKFb1kbWAlaoo7sczpTWolVRB4CJouLWTMHBrTh3oU3pYJG/aA2BY4UNE2v3MUFJmdIq4KGxwWUTiNAcDEMkxO4N/JWkAeXDO5aC3/XnOgzK2z1eKcbdfHVbsmwK5isibcz39qUuDBm+D397DYulL7FOiLso2Hs/xNqQnNaILQEqgNCCFpKvETOI+VMD2GTol3COZTUPy/JX7UA41m9x5l9vLbJATOOVlxKUZhUvKZB7Rs+9R8b52s4Y2D4QEpF0ACOThU1Uw6vO4wAwkVrN8frLjKquMn2jgHRRl9o4KYUYDbBnBXqFIyaUsiou6mSPloekQGbhNuB05BW3ljpjHzW2rMlL8Nv2i7L6fBgSD9t5A39CTsu65ryHkRX2YuyoveD7d7UnvktU7NPfhJxs0ba0kP4vl87jydSEeQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1693.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(366004)(376002)(346002)(39860400002)(136003)(86362001)(41300700001)(122000001)(33656002)(6506007)(26005)(7696005)(9686003)(186003)(38100700002)(66946007)(55016003)(66556008)(71200400001)(64756008)(66446008)(66476007)(76116006)(316002)(4326008)(7416002)(38070700005)(8676002)(54906003)(5660300002)(478600001)(6916009)(2906002)(4744005)(8936002)(52536014);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?XLRm7EyqLdY921MiwtNq8ve2bf2CsiL/O6Iem6M+oBFgLr4sD730fBP9w0ft?=
 =?us-ascii?Q?wvD+wQooveAUuegHocCnE2HkCj7F572yrTAHk5+PBIfcTTpEl4+kjIIvZ66r?=
 =?us-ascii?Q?x22s6aSxeTOY88AprbuI/U5mmdWbw0LB2dvaMXT1d02cQYNho0jSRwpqK3p2?=
 =?us-ascii?Q?4QWsaIYMKX2y0fYyVYG/ARdaVQ/SRhAtIX0OidN5jFd6fYGhPZrkBRlXIPtD?=
 =?us-ascii?Q?URlaPhJfiddbfNFOhFJ/Y+85gZLglCVcT4KVrF9si24DdkbAM4m0ZAl6lUrQ?=
 =?us-ascii?Q?hGRha+6C6zDhtuSzvRvjiMbpopuvMtNrmBJ1mK7jTgrcaSIsfmFrCjHKUcd8?=
 =?us-ascii?Q?zowPp+QTcCwjUz9Bo4qRchhiwHSg+caqv0n0AOpGk4POIcu20Fvh/PPMM8kA?=
 =?us-ascii?Q?BuXhk2GgwXYI4mPv1RGUfjpf9CpYLIlhzVhuqldcFW2NGz+yVmNYAy8OBDcz?=
 =?us-ascii?Q?x6KLIWeKK+4EUCtHjeQA5mM3AFirSgyuML2MYpBcZ4PLgEMeaD0jAnEWwpL9?=
 =?us-ascii?Q?Fg0yDefaAjXCZYREK8LGDoKW1sPFBenQ75ZvcC2yAnzQefGwd9/x5tcbm5Tf?=
 =?us-ascii?Q?Gtf9+YJd+yZh4TNQPuEgfH7l3zTj76d0qqY1gf/I0zJ64ZwfOG6nGZxrLQEy?=
 =?us-ascii?Q?7fbepIa94FGj9Me0/dnFI2AIE0+7MyORlbvwqWj+BOadHSZTUb8z7iLB8MuL?=
 =?us-ascii?Q?OJvH+MmeG8txvCYa1Ya5hjBwcaNylO5xyTXoM45fm1IHdw3+P8uJFnCgI+/n?=
 =?us-ascii?Q?pxSVxTM+7zk9Y57qtCG0utLb5W+ZbUotzx4UHeLd8X8jul7W59OuwxvNeKuC?=
 =?us-ascii?Q?jV6/yhNZ+w1XUkajwMm+R37E3ASCj7Tv5fCVNu8zfdGJwrSbZkmsWYLt6XCv?=
 =?us-ascii?Q?0RT4W1smonGgkh7l1bLxj/SyM5Cu8Qq1F79VABIhK3lzK/k0OkfARh79ieOy?=
 =?us-ascii?Q?pWKgp0JD/SlnviFtFZq0tMYspZ89dRBKf/7ngNsScmrZWmauA9T73EHhnssE?=
 =?us-ascii?Q?eNMCsY8503vsUsbbT9F+4dPYK2h0xheFpZp3y5hc+B+zDKH45DX6lMvefUra?=
 =?us-ascii?Q?z+blQVpUoQJvhVS7+Q41nDomJWPufWGmoTJwHPvx0EoyLRCx+vsRBTYuTyEX?=
 =?us-ascii?Q?8XJlxL/xeDS3LUvGg8WiNXmTGcqgeCC8cRXrrgzXCQQJiPKJhrebKPwzzpWt?=
 =?us-ascii?Q?uoXVtvWKiEe4x6iBZgI/4z13N7NzZgmEYpp47EeO2MMrcvUQTcfsFc4wE9Q8?=
 =?us-ascii?Q?Iv1x6B8BeV0hQRoPxY+qHHb8VRThtVNKBjiMSIUwxl8oDTVww93V/thv0sbG?=
 =?us-ascii?Q?NvX7fxh9a4adHObM7SUz9g1cT5lR5q6/9IY7prqxZ1NGpDO3o0O5pjdx0quR?=
 =?us-ascii?Q?WLCtlZWqlqZJoRXRcuHPkZN3dO6cxWJmvy4wJ4Q9WjeQnO4z9tEmi273Twpw?=
 =?us-ascii?Q?N2lYLn07yXDdVtpIkM8crCkoiHHs0zknaqZzaVdffOcyhyQwEpnpQw1kMyhN?=
 =?us-ascii?Q?yCTtxtDXGvwtWMuf8oO2Md0R4N2Eu4E1pcB6CcfVhF7RRtuZtIiBFSlFQqq3?=
 =?us-ascii?Q?rB5hn+OIUATWE0SLZCXO7QTzPGZfS65rv8rlkwdO?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1693.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb1ffc76-bb15-4bdf-6d1a-08da8d211dbd
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Sep 2022 20:24:19.8268
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EEGUyhceaiHHipkdu9B1xUjCGv2z4ZdwlzhtJ3NY5JHel42bi/Gtk6f1h2B2g9ukwFy+4MO5mibjUBoxzYoczA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB4274
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>>  static const struct of_device_id lan9303_mdio_of_match[] =3D {
>>       { .compatible =3D "smsc,lan9303-mdio" },
>> +     { .compatible =3D "microchip,lan9354-mdio" },
>>       { /* sentinel */ },
>
>Please add this compatible to
>Documentation/devicetree/bindings/net/dsa/lan9303.txt. Better still, pleas=
e convert it to YAML.
>
>       Andrew
>

I was planning the conversion to YAML as a separate patch as I didn't want =
to delay this one.

Jerry.

