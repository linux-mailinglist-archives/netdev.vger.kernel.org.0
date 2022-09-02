Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CD5C5AB963
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 22:22:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230318AbiIBUSl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 16:18:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230292AbiIBUSj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 16:18:39 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18675F076D;
        Fri,  2 Sep 2022 13:18:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1662149919; x=1693685919;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=W9PMYzanE7qUvrRwMfGNnnndhdZCDlWSK9Hy8Z9vR/M=;
  b=pxfTXTNyV/4ZSfT4wsMVbJmhkyM1mJTuGPYkXijw9kN4ku3XJjLbm7r5
   rTDve0KE7rEKGlcPRmSCCc+gnurbmU0yzyhjFr02rZYPM0GjmYEQq9Wmx
   +OkNMgnssz1bRD8SDo96gaanhf4qvqaFmKtrnIwtVc2kN01nzTjwk9P0w
   aB0TvnhlUY6L+zenRuKldQK9mNoHzqbAYcxK24PXinlddmtjjmVi3zocd
   0PNyMMzvFE89ZS0jn7CzI0/YjGpTQaOtiU+Cs/382PDIZxzJZyQLL+YkR
   hkqMSRF2GXUzz1Cfmz6FoBvA9S87XPBVTKQU/90c2yLXHW2JDcbkG7kqr
   Q==;
X-IronPort-AV: E=Sophos;i="5.93,285,1654585200"; 
   d="scan'208";a="178854229"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Sep 2022 13:18:38 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Fri, 2 Sep 2022 13:18:38 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12 via Frontend Transport; Fri, 2 Sep 2022 13:18:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nJ9VeDVO/UMyP7F+38ZayT70o6rkKtwVKghvOWa0RSm9XLO6Tm/LSx8y3AgCZb04gifZ5CZC3QT1w5N0TmsX2qgEYAalYk+kanztqHgPlmbH0AB4dMuRytc3HqtH/1uR+JW+BAksOUmhuBR6ThaqozKc7z493re1jjR1+JbJO6r21X3wP2lqGsgKSWbpP9jsL96B0oJ2mf1ATt9ipTev4KbgB7AsMCHsARy/YBGfw3MgRjHzlIrXcYnoBAjKTaO/JdNIDovJsO4aWGHifL5kwFvlu38vKzA5i9qjkaNd9jsofm9Xp3TMr3f3KJdCly82DSy5m8qLLPZw9zX320zHGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GV43VTPDIdDjxkhkLfmjDouhwTx25GH4XQKry6LFBhQ=;
 b=b2j/k1WCcXW7qBGM2OglV5L0UWd3qb0gSoks1wImREsiducp3RPziPgPGQ1DrI1JGyrpNDx+e9Ry5R2BQklENsvEwTUh6xtDEbSZRBsqasxIpSm94KB2TfGd4kXcwH6xhGlkGoKHQzHkhg/6O+Y+MzvL/TeGoRqpkF268v/RSjTem8c54qAWFOQl983CkinC4yIGmpvSri8ciWzVyAhIDRtwnRChhPQneKDjebxoaLD1m6/ZGVmC6J5onOQoI6GxzlVw6itn7JxGeG0tBLnF+EymCoxn50FgxkrDsizCSzUMko4KNRvBYC1ZEO2wF1IBn3PxDmAoURzohSK+3VaigA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GV43VTPDIdDjxkhkLfmjDouhwTx25GH4XQKry6LFBhQ=;
 b=Bl/AlHMxCEgXHHVMnVZiJMa/rQXlkkrJjDIgaq36rTPp/pXnqta8Srv4OWjSgeTjvi/S8JjuUiiwOHb2d1iQ2APutho0WPSusvusMRP+brhEqN7pZ5zqgrDUvb6eQfGiyRZJMUIVOQZy6pc7uFSx+W/trNaq8P+f2a2HQFVgtXU=
Received: from MWHPR11MB1693.namprd11.prod.outlook.com (2603:10b6:300:2b::21)
 by CY4PR11MB1848.namprd11.prod.outlook.com (2603:10b6:903:123::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.12; Fri, 2 Sep
 2022 20:18:32 +0000
Received: from MWHPR11MB1693.namprd11.prod.outlook.com
 ([fe80::ccae:ffc6:d9f5:8535]) by MWHPR11MB1693.namprd11.prod.outlook.com
 ([fe80::ccae:ffc6:d9f5:8535%9]) with mapi id 15.20.5588.011; Fri, 2 Sep 2022
 20:18:32 +0000
From:   <Jerry.Ray@microchip.com>
To:     <andrew@lunn.ch>
CC:     <vivien.didelot@gmail.com>, <f.fainelli@gmail.com>,
        <olteanv@gmail.com>, <davem@davemloft.net>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 2/2] net: dsa: LAN9303: Add basic support for LAN9354
Thread-Topic: [PATCH 2/2] net: dsa: LAN9303: Add basic support for LAN9354
Thread-Index: AQHYu9FcWcp1m2N/pU+7PwCEJwtzQq3GQSmAgAZZIHA=
Date:   Fri, 2 Sep 2022 20:18:32 +0000
Message-ID: <MWHPR11MB16938C27CC03D84BA2194DC3EF7A9@MWHPR11MB1693.namprd11.prod.outlook.com>
References: <20220829180037.31078-1-jerry.ray@microchip.com>
 <20220829180037.31078-2-jerry.ray@microchip.com> <Yw0RfRXGZKl+ZwOi@lunn.ch>
In-Reply-To: <Yw0RfRXGZKl+ZwOi@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 33d0fed5-3326-45af-1930-08da8d204ed0
x-ms-traffictypediagnostic: CY4PR11MB1848:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: m1fm5yr/9d4wjsxyEW0oUm7PfQlyFGlXriep4Sy/crNndlaGdXclglD+1d70I1qMO+pX2+m0VNlMC6KKUnAf9orf2bgXTD3tdzA62aJJQx+acZv6Xd9SGFLi7vLymt4CEY1fv1hFf/qHVHTim6p0U+/368OHkLD/ARjLHphXxri5kP8EwEsFfmx94OVfJedzwTD+N3tWyrZemhu+IssxsGZBIsMDPC9VXnnHkv9Nni4hjkTxdXz83GUG8itcdR1MTI9HePbvMnGqR8E02hRmxtGEOTztyLKGs+iJdEoYvgvaxMBWqJsCqixedbnbcZefsSbSWBZ/uMre5zbd2luNiBgxIUi9np3NfM3M0Pbq6IUkgEmphHs7XBTKYACUxZWNxbf8T684Q6WQ0xbssIVBiwW+ObbOx23SC+bxHMVjEJW67jTRvGQ6bVP9ulKMRfj+LmTDTHfETQ89+N4gNQGhfB7OzVjiOcllS9udzHab+Ui+jFbkTQDwsiKspVk72wV7b0oY0FcwgesEBr3hJCexVgm5gW3gJjwkYtb+dSHBNMIAsea+KRrKRwFjw1ncn2I9PsI6o6jY/NEjAlskU1Mu3WKoIM8SVzRR6Mb7KC1qibNEUK9A+ovKUs3MEjQdX6jT8fld7YykyA/T10S1yPbBRBETKV8LUUT2PeMuZNNfj9h7uGR0uWh1IR+jVLZVG7s1D2cPGKGeRQbpLqCFJKOGYyV9B3GQSNH2Y3HNj7wW7Uc/mOhpBLGgyjbsTWEI0VpcEw34rklQ02EGA+WOlcsxhw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1693.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(396003)(136003)(376002)(366004)(39860400002)(7416002)(66556008)(76116006)(5660300002)(122000001)(52536014)(186003)(8936002)(66946007)(66476007)(64756008)(4326008)(8676002)(66446008)(54906003)(316002)(6916009)(38070700005)(33656002)(55016003)(38100700002)(2906002)(26005)(9686003)(478600001)(7696005)(41300700001)(71200400001)(86362001)(83380400001)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?97yvWNMhWZdNI7WozGNdsP5fqFAeeF1FbzNcHfWIEvQbHiiXXnShN/qjVFSt?=
 =?us-ascii?Q?cL92BTS3Z4O07tf00RHXdrcU0BJJIBsYJN9znSqiuoAlPZvymBhwC1lBRbOD?=
 =?us-ascii?Q?QY6hTmmYKVcX04cZPb1LIN4Tg2YgSGyRWHsXFMNgUzGo0zqVrRO8k0Tel9n3?=
 =?us-ascii?Q?FH1rykgBe5IbRDeeEMG99nAZa00uw4ELalWf0EOJw21qWGc2boCzxheWIbyt?=
 =?us-ascii?Q?7TeXzWMF4mSdvoEbjwyl56Uwy7bXtIEsX3mRWesFnel7UG6M6FhcR4jQUj17?=
 =?us-ascii?Q?TSubEH29NRGf8ZjbIm5YJik9YVWscXidP9dEyBOeMkdKQ8V8DZELhOfO5/n/?=
 =?us-ascii?Q?iiAU4dskzle+wJMr6k0KwB+sGk1chx1i62LrrtvaRoeI87BZkbINwyWl2aqD?=
 =?us-ascii?Q?B2w/Vsme4g93jRJioWqea97vPZi4LVP8UE6X414CvlpDwU1anRZc7qrDCd78?=
 =?us-ascii?Q?qsaKWx8w9tBHGAlT0TzDcU8gEWwz3Y1QjaWWABFM2YfWskIE94naNyIamsCk?=
 =?us-ascii?Q?ZS/zySoVQPDLgtfu3J7qePyOmfVgizX8vwo/MmUmRahB0BiCqwrsbiGnyh3i?=
 =?us-ascii?Q?Y6zdBgHqPeDJsyQ8ra3uE01LjwMxy4+XudYgx/vRASytQALQOt5WzoAp5UAG?=
 =?us-ascii?Q?JRxNG4x/HmwMY2L4Zlc0G7JPEuVC6sYFmnmdiZuCNYgz+Yt93EflWLmAVB4Y?=
 =?us-ascii?Q?cE9VWdxkMB3xP33SpHUMKxLNAs8ScZ8750dtf7RXvtJZjBK8eHY8lujS/z+T?=
 =?us-ascii?Q?Z+13qee1BlDUfEIBehzpk8pTvN8rPb5kDZ+eMNiBqRc9Ph7OE9f4vtbpIoS6?=
 =?us-ascii?Q?nHMhNpdb79+rdgnjXRWybdZrEV6f77z7obWCeRm5lDrJiLAK98K4XVI2eStM?=
 =?us-ascii?Q?6mvyM71OaxIDAYBhckzDca4FE6sJ9wrd7YTchYdNOtUtsmf32wKEzVy1O0Lz?=
 =?us-ascii?Q?Ky4V76hpAKhKw5eimsG2nbgPNqG6MG+zZfc8tZK60+qGl9XfCdkwlNCVbK/O?=
 =?us-ascii?Q?SEE+XNsfPcMPEkIYBw+HLCBTi3028taZOX0lQp8tp4WqofeU+D1wteyK9MKM?=
 =?us-ascii?Q?p+3GBi/ARRWVsC/SDPx8vg8N8OupgOdsU2ISzI5p3r4XpOcTPObmUKtx2d0E?=
 =?us-ascii?Q?yRRw41lI8dv6ffdTjEYtREqQaVGVSO40IRuGDSg7mO/z4XjOxHx8Z/+o1K78?=
 =?us-ascii?Q?2kSy4j5TwjnhtfaQd5Utoi3O7+6m/lUBAVtpUTV8SyO4G1cmmls0zKeuC/04?=
 =?us-ascii?Q?f/NhbtKXLylMJGPWJEix+fXOeTkqGFCOlgyqWwvCwy/Svem7TFQU60xuhZQ2?=
 =?us-ascii?Q?NdfszGZR3LQsOomv06KwWCWkFwlofyccEj1KdsCgGp5lhotyKr0CXyYOd7wY?=
 =?us-ascii?Q?ki26kunwpoqI4YAA1PM6j/+z88B9b6aoNmEV6DDthdsNzgHhG3dKnPtQA8Az?=
 =?us-ascii?Q?fcl9Ff+IbREW2vaMgJZlsURI0eMH5A+8KyVlwSFHqSFPGfcnDbYNwvBJAR7z?=
 =?us-ascii?Q?2YoZqrHrWhVYewTgVKs0yXfIDz5HvvhI1sNGbNHx7XqX91C0GD04KwjaWnyK?=
 =?us-ascii?Q?0nc5bflpkNExJeZeEojR2ceWHc2KgihOvE94Uw0g?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1693.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33d0fed5-3326-45af-1930-08da8d204ed0
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Sep 2022 20:18:32.6608
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: I8fEuOERWoi8KtQ3HBQ0BG8x7uSvY1o4ShSFeDeL1s2MRQO10xaVY27o7ddzYOy4PueFxLzYU+zTAt3raWxNwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR11MB1848
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>> -     if ((reg >> 16) !=3D LAN9303_CHIP_ID) {
>> -             dev_err(chip->dev, "expecting LAN9303 chip, but found: %X\=
n",
>> +     if (((reg >> 16) !=3D LAN9303_CHIP_ID) &&
>> +         ((reg >> 16) !=3D LAN9354_CHIP_ID)) {
>> +             dev_err(chip->dev, "unexpected device found:=20
>> + LAN%4.4X\n",
>>                       reg >> 16);
>>               return -ENODEV;
>>       }
>> @@ -884,7 +889,7 @@ static int lan9303_check_device(struct lan9303 *chip=
)
>>       if (ret)
>>               dev_warn(chip->dev, "failed to disable switching %d\n",=20
>> ret);
>>
>> -     dev_info(chip->dev, "Found LAN9303 rev. %u\n", reg & 0xffff);
>> +     dev_info(chip->dev, "Found LAN%4.4X rev. %u\n", (reg >> 16), reg=20
>> + & 0xffff);
>>
>>       ret =3D lan9303_detect_phy_setup(chip);
>>       if (ret) {
>> diff --git a/drivers/net/dsa/lan9303_mdio.c=20
>> b/drivers/net/dsa/lan9303_mdio.c index bbb7032409ba..d12c55fdc811=20
>> 100644
>> --- a/drivers/net/dsa/lan9303_mdio.c
>> +++ b/drivers/net/dsa/lan9303_mdio.c
>> @@ -158,6 +158,7 @@ static void lan9303_mdio_shutdown(struct=20
>> mdio_device *mdiodev)
>>
>>  static const struct of_device_id lan9303_mdio_of_match[] =3D {
>>       { .compatible =3D "smsc,lan9303-mdio" },
>> +     { .compatible =3D "microchip,lan9354-mdio" },
>
>Please validate that what you find on the board actually is what the compa=
tible says it should be. If you don't validate it, there will be some DT bl=
obs that have the wrong value, but probe fine. But then you cannot actually=
 make use of the compatible string in the driver to do something different =
between the 9303 and the 9354 because some boards have the wrong compatible=
....
>
>     Andrew
>

At this time, the driver is meant to support both devices equally.  In the =
future, I will be adding content that only applies to the LAN9354.  That is=
 when I'm planning to add .data to the .compatible entries.

Jerry.
