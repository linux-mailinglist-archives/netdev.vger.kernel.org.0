Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A88DE5AB92F
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 22:11:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229779AbiIBUK6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 16:10:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbiIBUK5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 16:10:57 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98DA3D6335;
        Fri,  2 Sep 2022 13:10:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1662149455; x=1693685455;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=sjtOTefyoth7+dqznuT1erytym3OrDWyBQVCOnvZbgg=;
  b=iR/n9cSkCKD6czNogRk41QCHecl9FWS+krPAkdVtfiQt6oSu/UUAfRo+
   C3OXyve6NfGKjWm88hcEa9rYsBmFUMlIzEfcny630A03qUcHkLiTDeqDd
   bxYD9Ho+xDeqSXn5fuZZdAtO/bGMeKQU95mguKHcf2ufeOpdXzbKJv/0H
   t3m87iW1o0tKe295gBKuyAWpQh48w8xxWYRfN9JQOmQB+knAPtu55AZCY
   OCwsSbpAiukxVeXli5dEHDld9AXVLF9aeYxZ9DW3WHbxkGqPiy3IY1X4F
   mkynQF294TNYMDc0e6o2uIEZE0e8ip6UyFSGdIg4f2UDuLVY+/p7Rmj1j
   A==;
X-IronPort-AV: E=Sophos;i="5.93,285,1654585200"; 
   d="scan'208";a="178852894"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Sep 2022 13:10:55 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Fri, 2 Sep 2022 13:10:52 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12 via Frontend Transport; Fri, 2 Sep 2022 13:10:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aduNh251R3LoFlIIm/fre+yTqo0VhT300Qfp3U9l904a7jWMcdD/DnXhcwmyv4jYcB6RERzzHk8gOhnYyfDgrV2GzFy6Q2B8JwSgbJV3UnAYFV1fBLr7VmSMbUDI1eOg0CuFVwtEgbniuMBKPqboMt/sCMdBMfCij23jmKoiaCMOACyUvkHfj7fzbMf54JArNZ5FMjVTTqfTlm8z3OL1q6U+tNFk/chzEVUI9Ff6MhPfCTr3tMiTHDeBQfmZ2CBFIbtCnJdaFjQBZ98L8VCaCCbxf4qmtBPI9r9zXf/BQDN5I9TD8qQbwLu9KrNDVEB3xdiE3k90sB9JXuZ11iPPXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SocYs+dCF7I+s/AnOmVPRvfyMp/BS0+dI3V9vmpXiBQ=;
 b=TEibtAYdkDmyHa7PEkHy84PrbgIQ3bNWPdlbPfauxN+VUhTBbEkSja46ymFmvHC9pSpZlkXRDU3NIS8zKXLtWYVvCiNUmq+UNzRzFyHZjUhvIDgO1cdzI3f6WWfZ/bzlh9w09JPUFj3mEebYaONLUQkycEd/2zABmJtFWn4sF/CAFPizOcjoKxnIC9bubopid5SIL5tywBFjxxb1UZUm/2mdSm+GQ2P6BZc5FkCxzqGot7EamdojV8SCFBJKDtvsH86CzrT5WtLKceSDmHsYgOQeiSk1bz8/OxMou0uFECApHFwVgVZkiFSoje8B9fIJ6yZEAyX/0tASM+ehqwN0MQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SocYs+dCF7I+s/AnOmVPRvfyMp/BS0+dI3V9vmpXiBQ=;
 b=Nkt4/1KXrcgdqgZRTH2bB50AMnF5FebZsSPq35mFM4vmKyW3GXRnVzeVwoh0xeeq84XXCT/jvQpbS28632Kln8ombZ1JY02ZZFnBYosC9xTeJftsdjI9/OuZeMPR0cdEv4KtZdAHu3RuxQdHnLVbckys1SkB4nfEw2H6uC87U1Q=
Received: from MWHPR11MB1693.namprd11.prod.outlook.com (2603:10b6:300:2b::21)
 by SA1PR11MB6805.namprd11.prod.outlook.com (2603:10b6:806:24c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.11; Fri, 2 Sep
 2022 20:10:46 +0000
Received: from MWHPR11MB1693.namprd11.prod.outlook.com
 ([fe80::ccae:ffc6:d9f5:8535]) by MWHPR11MB1693.namprd11.prod.outlook.com
 ([fe80::ccae:ffc6:d9f5:8535%9]) with mapi id 15.20.5588.011; Fri, 2 Sep 2022
 20:10:46 +0000
From:   <Jerry.Ray@microchip.com>
To:     <olteanv@gmail.com>
CC:     <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/2] net: dsa: LAN9303: Add basic support for LAN9354
Thread-Topic: [PATCH 1/2] net: dsa: LAN9303: Add basic support for LAN9354
Thread-Index: AQHYu9FZPa9+/Wmd806ISn/Vxl3m2K3HQE0AgAVXz2A=
Date:   Fri, 2 Sep 2022 20:10:46 +0000
Message-ID: <MWHPR11MB16939B94E6A64234CA14167DEF7A9@MWHPR11MB1693.namprd11.prod.outlook.com>
References: <20220829180037.31078-1-jerry.ray@microchip.com>
 <20220830103340.bqgzmcztb57m7jgd@skbuf>
In-Reply-To: <20220830103340.bqgzmcztb57m7jgd@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5a333c62-defb-43f7-1654-08da8d1f38f1
x-ms-traffictypediagnostic: SA1PR11MB6805:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VHuPDtEG2QriUluBUsFdyU8GznZGsPPmDzU8Xe4Yrz0Hfmb2yEWaUhi8AK8I/3mfIi6WWzP3+nE0z4wPURxP7xU6/II3pnLOTVdJD5xxw612l6qBAzNiqEsDcw9t+6p2FD/0S9iTiRs8LjbwSzwMpGVhLJLno4gTdziKGLnM1+NqVY6xPGgDfw97145yvTmYXJxOV7RyPOhU37KxM+Ix3hid67Rmj/sR5sa1Zk/vxW8B1vegaVOT7YWFUcGqYVF+6SeNpbsPqOCchOdAdl18UOXbcp/nAJf/Kj1qxyu4o/PX+bhT5n8H8W2AXn6mZqySgAMDbt8Y1Qv83jx/qTnjcU15MADqVSQVkl3K9ZiKW5zTaxtRPnTCs1s/nydSIvbCNRbNBq2pr8YkaLzHPWKbB7uzjFmfu4fOO9spB7ZHoUE+oyJQ70l3s0rAL1nnQ55vdpJY9dBwsDzT30RnbonsbMA+0EErS+W6vbzNTJ3uzbw1+3SBdqFy2y2V8PmCGtPlu0EWGsXwFE/OqGBYgFDlXKKkQR33zZBlJP/4k3i9RrPRhAoS5GEjKPRyX1ekij1jF5fsvVec5mNQDhyXk7GlrKbFRLFUZqnn1iebdHCXCduTI8r+Q0872BRNBxj+//+/G2daVEMIqvgP7JxPtocB9wRyWliJI/FHvhI/yveGWh9xl0g2Bre2gNs7ZbPz+QubjWiuA7aO2go8IbUGyw7bMQxVlRgBvSLIbZa/5FG6F00pMMODMFb1YNzF1RM9kMCPEU88I/z1hLIMhUStuCV10A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1693.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(376002)(346002)(136003)(39860400002)(396003)(54906003)(66946007)(64756008)(66556008)(66446008)(55016003)(6916009)(66476007)(76116006)(8936002)(4326008)(52536014)(33656002)(8676002)(5660300002)(7416002)(71200400001)(316002)(2906002)(478600001)(83380400001)(6506007)(7696005)(41300700001)(26005)(9686003)(86362001)(38070700005)(186003)(122000001)(38100700002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?jW7nkl8nKz+nSijC2Bic3M1gOJHoBXalTWQkI5+a0Ok5iuLXimUj+ZMRBcXA?=
 =?us-ascii?Q?KMfooA5KfPPekkI1o3NF2TPE7nkwi04co5SWJbH/jRFeIgIlA2zVCTdK8dWg?=
 =?us-ascii?Q?iAHOwpV8KM19mnYV2Kj8wjwZLaYDoC8gc0ctT3iZXqmt/i+7HgjFElL6ez23?=
 =?us-ascii?Q?rvKWU017CQzcz3KgtxHbsLIF+r6UcnEttemLvEAndeg2++9/nap+osXqnj0K?=
 =?us-ascii?Q?N5UmAG/tFVRMAbtd1bJkmn1ET0rfKm48jCiJMNPrpCQmbXnJ9n2ZqDvNxBFP?=
 =?us-ascii?Q?nbD7IjM3Noy0GmdHzxloFL5RAHcXgUSx/7UFA6F5Fghe+bMc71kWdeRNf/Ec?=
 =?us-ascii?Q?T1Z/d3ZRzoPXNxusFYyIWEvFDM/d9pR7Y9p66/ekDbYOaCAJqGF48iZdJLI7?=
 =?us-ascii?Q?mW8zLP7hNFqXJ6f2ckquRfCJb/k1nO37OD+pxb5l8I80E7PblLpP1X2QyWDX?=
 =?us-ascii?Q?2V10sMqY2OO4BA0bs2tQOac9zuIA9kp7CpwrXGljmEhXY7wPwQxJwefQCMNZ?=
 =?us-ascii?Q?9J9frG7IkPcjxgLGZKogVHZl5fqFgzJYfGItpkB/CDiypOpuTRB6vI1/5i/q?=
 =?us-ascii?Q?Up6mEcAb7T+lx6FZzb2bf/gniI9HRrVk1RKQEVJCPsx/FC55WeqjoOfqeDhR?=
 =?us-ascii?Q?V1lcqZ8K7/mAHo6ilEc+TnhCY4r/2ZNPS+IRA6fVSAxQg/HwwLUFe6oX3y6Z?=
 =?us-ascii?Q?ZwFkBrgX5HYCq22JZpIs/AP+Xf/+R0CXZqJR0mjq8/asjacDVTC9xNz24v7T?=
 =?us-ascii?Q?rLP5DZ08ZDQPJLORpjxyNFLD670fnJvek6BBZBWfxiUDkC3DQW2ycF4S5QhD?=
 =?us-ascii?Q?K4W+dpYb4GlTSYaq4eOn9uTYEdhRymvliHW3QH2BdY75iIIJhAxyXIJTLcCI?=
 =?us-ascii?Q?7tymRnGvL4UBfhbjm2fL8gD/LkdRlsi4xFpLXx6NUd5V3ARYuhnPVcixk8vQ?=
 =?us-ascii?Q?VvpdD/M74DqkqmyOf9bhtNQBwAFnU/TTdPKei2cyfATapfCQ9ko3by/Y/Mmw?=
 =?us-ascii?Q?xVwx3VkWhO1jtRqSuOy5pDJk63D9nV/Yawe039O/CdjZgBNMuhZdhzKtO0VP?=
 =?us-ascii?Q?0NAPfFwmV47xAQXQJyoPUt7TeM4t6DmRe8EsET4ryXvjhuRZq/rcq8GBUfRp?=
 =?us-ascii?Q?Krryc8uCxavW6nTyJZnLBHrE63KzpjzLiMHcF8vWtl2NeOlM9H3QTBo6pIdO?=
 =?us-ascii?Q?RMSpYOjEtCBKMh3+4las3hO+B2Jsv3YRwMZjW8Fg4C8eEKvexT8EnEcrnAFi?=
 =?us-ascii?Q?uUZoQs0I27NE+L5j78DpQv9P5t59f7qQuV9nO98pZxSIaJybNC6XjHpjxZOi?=
 =?us-ascii?Q?F9K5sNhinGFwX++dlRAERj3F+G4fP3aBzVERaiSSDA7EinFeZi6bDqAJlFnd?=
 =?us-ascii?Q?/+pWvDu8lJib1/ma4QslrlvI2r6voX5hmqaMxOw3Id2PEbQinHTjFRDVVLW7?=
 =?us-ascii?Q?ucgCj4nWAhvVnA9ghoC0qNt4Ri5GJu6eECIgscx8fwgQMlNC2xfOBXKuVies?=
 =?us-ascii?Q?X84S780ADVZn2iZuiyKvdSBzx1NAUXgOcmvVJ7M/4K+ujUxTyWDy5ZFt4i6h?=
 =?us-ascii?Q?mQQUbaG18e3aa9W0+JCjnKI8JjtWTiw3e+YYx6UI?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1693.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a333c62-defb-43f7-1654-08da8d1f38f1
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Sep 2022 20:10:46.4548
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zF5Wgcq7gZcp1uVCa9lCJ4fqw1RDbynATxSWVMy6VL+M0EO76BKnRHCBGRwUCob4zjaVZawFd/PE2trYtCZ+HA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6805
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>On Mon, Aug 29, 2022 at 01:00:36PM -0500, Jerry Ray wrote:
>> Add initial BYTE_ORDER read to sync to improve driver robustness
>
>Please don't post 2 different patches with the same commit message.
>I think here, the first paragraph is what the commit message should actual=
ly be.
>

Understood.

>>
>> The lan9303 expects two mdio read transactions back-to-back to read a=20
>> 32-bit register. The first read transaction causes the other half of=20
>> the 32-bit register to get latched.  The subsequent read returns the=20
>> latched second half of the 32-bit read. The BYTE_ORDER register is an=20
>> exception to this rule. As it is a constant value, there is no need to=20
>> latch the second half. We read this register first in case there were=20
>> reads during the boot loader process that might have occurred prior to=20
>> this driver taking over ownership of accessing this device.
>>
>> This patch has been tested on the SAMA5D3-EDS with a LAN9303 RMII=20
>> daughter card.
>
>Is this patch fixing a problem for any existing platforms supported by thi=
s driver?
>

This patch is fixing a problem I ran into that probably doesn't occur under
normal use case conditions.  I was probing around on the mdio bus within
u-boot, then booting linux.  This change makes the linux driver more robust
(tolerant) to this situation.

>>
>> Signed-off-by: Jerry Ray <jerry.ray@microchip.com>
>> ---
>>  drivers/net/dsa/lan9303-core.c | 13 +++++++++++--
>>  1 file changed, 11 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/dsa/lan9303-core.c=20
>> b/drivers/net/dsa/lan9303-core.c index e03ff1f267bb..17ae02a56bfe=20
>> 100644
>> --- a/drivers/net/dsa/lan9303-core.c
>> +++ b/drivers/net/dsa/lan9303-core.c
>> @@ -32,6 +32,7 @@
>>  #define LAN9303_INT_EN 0x17
>>  # define LAN9303_INT_EN_PHY_INT2_EN BIT(27)  # define=20
>> LAN9303_INT_EN_PHY_INT1_EN BIT(26)
>> +#define LAN9303_BYTE_ORDER 0x19
>>  #define LAN9303_HW_CFG 0x1D
>>  # define LAN9303_HW_CFG_READY BIT(27)  # define=20
>> LAN9303_HW_CFG_AMDX_EN_PORT2 BIT(26) @@ -847,9 +848,10 @@ static int=20
>> lan9303_check_device(struct lan9303 *chip)
>>       int ret;
>>       u32 reg;
>>
>> -     ret =3D lan9303_read(chip->regmap, LAN9303_CHIP_REV, &reg);
>> +     // Dummy read to ensure MDIO access is in 32-bit sync.
>
>C-style comments /* */ are more typical in the Linux kernel coding style.
>

Understood.

>> +     ret =3D lan9303_read(chip->regmap, LAN9303_BYTE_ORDER, &reg);
>
>Pretty strange to see the dummy read in lan9303_check_device().
>Bootloader leaving things in a messy state is only a problem if we don't h=
ave a reset GPIO, right?
>
>How about introducing the logic here, right in lan9303_probe():
>
>        lan9303_handle_reset(chip);
>
>        if (!chip->reset_gpio) {
>                /* Dummy read to ensure MDIO access is in 32-bit sync. */
>                ret =3D lan9303_read(chip->regmap, LAN9303_BYTE_ORDER, &re=
g);
>                if (ret) {
>                        dev_err(chip->dev, "failed to access the device: %=
pe\n",
>                                ERR_PTR(ret));
>                        return ret;
>                }
>        }
>
>        ret =3D lan9303_check_device(chip);
>

I'll look to move it.

>>       if (ret) {
>> -             dev_err(chip->dev, "failed to read chip revision register:=
 %d\n",
>> +             dev_err(chip->dev, "failed to access the device: %d\n",
>>                       ret);
>>               if (!chip->reset_gpio) {
>>                       dev_dbg(chip->dev,
>
>The context here reads:
>                if (!chip->reset_gpio) {
>                        dev_dbg(chip->dev,
>                                "hint: maybe failed due to missing reset G=
PIO\n");
>                }
>
>Is the comment still accurate after the change, or do you feel that it can=
 be removed? Looks like you are fixing a known issue.
>

The 'hint' message applies to the first chip access, which has now changed =
to the BYTE_ORDER read.

>> @@ -858,6 +860,13 @@ static int lan9303_check_device(struct lan9303 *chi=
p)
>>               return ret;
>>       }
>>
>> +     ret =3D lan9303_read(chip->regmap, LAN9303_CHIP_REV, &reg);
>> +     if (ret) {
>> +             dev_err(chip->dev, "failed to read chip revision register:=
 %d\n",
>> +                     ret);
>> +             return ret;
>> +     }
>> +
>>       if ((reg >> 16) !=3D LAN9303_CHIP_ID) {
>>               dev_err(chip->dev, "expecting LAN9303 chip, but found: %X\=
n",
>>                       reg >> 16);
>> --
>> 2.17.1
>>

Thanks,
Jerry.
