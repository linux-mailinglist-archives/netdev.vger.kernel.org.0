Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E699C5147E6
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 13:17:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358219AbiD2LUQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 07:20:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355910AbiD2LUO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 07:20:14 -0400
Received: from GBR01-LO2-obe.outbound.protection.outlook.com (mail-lo2gbr01on2116.outbound.protection.outlook.com [40.107.10.116])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A5FC84EF7;
        Fri, 29 Apr 2022 04:16:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=davsG5IlG8HmRKK6KFDkiaAOl3j5uNxib1/g4qdAP9gTQUEyjs7Xo4sJCuu0zDZop8jF0kVAiQiJOOHrg/rx2cjzlJEgUZjx19OQ2gSxDtqvGcGpBVkSlhzUGAmwqEBJd9ZgSNlxto7GotT3u+HuzPcXdb4G2a7Zx8NV418bUfX20Ess49xOa4QzhY4bpPlpJ+DVJb2mItUby3ZDc7m0e5YfvdoSlI9SXk5d2Bdc/DzwGac42wU/AMglpa9WHQXoayUzCO38SfDmZ2OpjSMTEIZmEGEweNiSO8LGi407ZkAvfC683g4bEW46el2FPuqX6d2QK0nj4fYkKzRBsUbHnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5IBDE/Z+SU3/kyLzDqsYbGQrnv0m/JfVUUpZdxtPWhg=;
 b=baREddat82nTouSsR6wNcN4hi2jTuTczsqWoMIw4qtSVFGGMHim+QLUy+r9LZ1uMOureUhgRee2RwyVkl0jdiJ827rISb9kOncDuGpv//HpZdv5ZZRua20QaOr9C+sjt3F7jQasZer4T2ck+knTCcwK07wx4fM5Y/kea0WUxR57wBUvLmYU8KP+5S8m3kSle25NB4GRdPthJzGc3z8XPpqCAaR/xWm1lxyshBOKt1i3mweE7kKshGOtvVf7YW6Zsnljk6D9M26DRwHczzUDBJZ7pUpDBNhPHET7cl/rwsDA7r1ifWSDq0m+U+6jO4pc3t7wWdNZHrl2gXSzRsrUdiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=purelifi.com; dmarc=pass action=none header.from=purelifi.com;
 dkim=pass header.d=purelifi.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=purelifi.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5IBDE/Z+SU3/kyLzDqsYbGQrnv0m/JfVUUpZdxtPWhg=;
 b=cz5HOES7zQuHRG24eSTpdjCgp7TbN4HP8StflQhNzv9vH48nmW+fqtB2cQoi0htplu1wpo8BmjfJY1TVQzOqZUDzp8UBSclZGh6mge3QgmQXVc3FvI6hkB3gZC8d1/DH1OVWGmHD/XNUK3KR9YJp1Fdd7E62xXDfypOSqZhS+Dg=
Received: from CWLP265MB3217.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:bb::9) by
 LO6P265MB6205.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:2b6::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5186.14; Fri, 29 Apr 2022 11:16:54 +0000
Received: from CWLP265MB3217.GBRP265.PROD.OUTLOOK.COM
 ([fe80::9d97:7966:481:5c10]) by CWLP265MB3217.GBRP265.PROD.OUTLOOK.COM
 ([fe80::9d97:7966:481:5c10%7]) with mapi id 15.20.5186.026; Fri, 29 Apr 2022
 11:16:54 +0000
From:   Srinivasan Raju <srini.raju@purelifi.com>
CC:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "open list:NETWORKING DRIVERS (WIRELESS)" 
        <linux-wireless@vger.kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: [PATCH] [v3] plfxlc: fix le16_to_cpu warning for beacon_interval
Thread-Topic: [PATCH] [v3] plfxlc: fix le16_to_cpu warning for beacon_interval
Thread-Index: AQHYW7nEp2tiBE48nEyuZGXcJUt1PQ==
Date:   Fri, 29 Apr 2022 11:16:54 +0000
Message-ID: <CWLP265MB3217FDFE8E945E52492B002FE0FC9@CWLP265MB3217.GBRP265.PROD.OUTLOOK.COM>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=purelifi.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 14aca679-16ce-4cf3-712c-08da29d1c45e
x-ms-traffictypediagnostic: LO6P265MB6205:EE_
x-microsoft-antispam-prvs: <LO6P265MB6205DBAC39FDE1988D0F3293E0FC9@LO6P265MB6205.GBRP265.PROD.OUTLOOK.COM>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3ZV03G7TUW21jBVO+AwS61ATomSYCoYGABJcLED5EVZTstjeGPH1IBn7IeZcXCMU+Y7ZwvDmQpGnXoF6ek+sPn7AYzysoZuCWLH0HY88+eANUXXej+cGq2DCGZYVb/RwMcMU7p1s7MVm+VyZFFasyKgX/SWTWoVLkC312xWCEjF1J/wPz/vfByq5kROM2u8OU/NpFtg709Vgebi0Yb/asY4GoUmAAfsdQevZNhv3hGrV5hardqSnVYrbum8VHoTC7aeeEIAOzFgx6JOLz2HKiw7acIgm4XSdLPrfwmCUn2uLx4N7VqAVU3LLwtvsd2a2KX6qrWmLEc8KImC4LQQvbk/RQUAf7xYVr76psoqaIZJhN/Xrt0l+lCEzooG9cpHp0RibNM+Nt/XipcG5szzqj+L6BNZjXksKOYJ1C0Z9bDigph4Ym6ttxvxfSSjA8RbGoJsjvoB0UzhdVBCG+MiAbUYbHqXnP/Csq3fXtCTMlC6QKPTczhGDk5mg3kfZqwsxm2u+Y1s47u4v1w/poXWZjsc20kH2URDFtPXB7c+9MOdZFqqJWkoVmyQu/HX14MTXK6JtPS41H1c0+0wtLwQMCoQwB5L88qumbQYXQytBiBnpw7sm8KrRK0eTrFZsm7Ycy7oCq/qU2dcLgkLBX+KPfO58IU9QGNJkjP4RKwz4JnTzzwKxMRPMKZ65dcm0nAJQ5cyVgSy+LA9t/kt7EoGixA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP265MB3217.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(346002)(39830400003)(136003)(366004)(376002)(396003)(8676002)(66446008)(91956017)(66476007)(52536014)(4326008)(8936002)(109986005)(33656002)(64756008)(76116006)(66946007)(66556008)(508600001)(83380400001)(122000001)(6506007)(7696005)(86362001)(2906002)(9686003)(5660300002)(26005)(186003)(71200400001)(38100700002)(54906003)(316002)(55016003)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?J2frhi9111iQ1HOa5eTvHtxUr/NSP8kxS03Dx2iq6ZCXhAVtTFpMouBMbV?=
 =?iso-8859-1?Q?EZoSzLiuYWj5ZvK4o8j+c2c/R84uzsW/BySMDFx1E3n6Lc9gtLQQHOGnX+?=
 =?iso-8859-1?Q?FvLTtT6wZoWWzKt119LSZOOLIOddznPskW6uKMOdAeeC6jE2mmauOeefok?=
 =?iso-8859-1?Q?47lYzeLoNNXrnkENiz5woiSdef6ymTUzRp1kS49xF1wSbkk2X97seaTj3f?=
 =?iso-8859-1?Q?GRLLmNjJJ0NYNCczXgoht3jrsRLKBJDGgxYnWvs9PD26wK7ZquDxLBVfPv?=
 =?iso-8859-1?Q?nM39w82/5v2qIkNN33/HA9/3hSw/VJOI8llYkb7sfGaGnlPazdrWbLL6J8?=
 =?iso-8859-1?Q?nmHST93rUiBZT1+ABWI5b3hUm/uNxl+tDE927GrGyPNtpG3rEEHD/TpAmL?=
 =?iso-8859-1?Q?5VivgWtlCQFUCNt9UooaUdcT2IITzpyAYHfvJFZwctlv7OopUEtPJx6ZjF?=
 =?iso-8859-1?Q?ZhRaAvwGPuAus+qqyDm88uEEhS5xWpGJLDRR8m28UETqcktDzFln2M1Gin?=
 =?iso-8859-1?Q?jl3qtOzlE49NuCXhiVPg+43GkgZc09MzymQQxM28kGIGbh3wWZ4qEnqXa+?=
 =?iso-8859-1?Q?GCAlk6rGnUkvi2d2Aio3AJA9VsLuD7pv5lgMVA+MJ5Fm6tN148AKvcWgzl?=
 =?iso-8859-1?Q?+Zuvu4uk6PgjaLDaLVerOlyoTMEYYrBruZt/Mg8Hu5MyFonRYcBHUGbAAP?=
 =?iso-8859-1?Q?CHkCauO+WFuzBDhTQXOzhCN7ysxfO55gtjHrAT+fET9B0/jJGog9le8KGO?=
 =?iso-8859-1?Q?LoafxIL4pe667u327MXAZEK9O4WC6XK2HeSW4PjAc9oplDHCz8oENLg021?=
 =?iso-8859-1?Q?tNoPezjcRPBYtfz/b7AZ4TPWfLjxs4xzO/TxCfUIq+4UoWjRnGN9sQgYZl?=
 =?iso-8859-1?Q?hEiMpfOVoz2eCuFutnIY5Fr9/xgHLXE5uO8LKu6PHata2THMFBvC4pisqO?=
 =?iso-8859-1?Q?L0E8MyTOq7sfczv08jAOCsUBDHaiyiki7b0jjvEeTb9ItMrzwcDf4marXL?=
 =?iso-8859-1?Q?7gp7JL9eixW+W/rxgAlLuM68ySnqGFAh/OhZgtV09LwYmNCvLNM+b6uJKN?=
 =?iso-8859-1?Q?ymm0w3HLhtDoNtttwqd5xk81RmzfDTdbabR4NAaH8H6F62nJKwOTmw30s2?=
 =?iso-8859-1?Q?+H530ZvYV7ZAMWmWO//EQotSqaYUgSoLjEXx//f9/lWC3voivz3DAcXdOJ?=
 =?iso-8859-1?Q?tsnhkKfcTYaRbc6uSSJDaG7upK680pVnWZHNzkNuuRWHen/krHcWALwkhR?=
 =?iso-8859-1?Q?UdkWfKNeXe986FoPqwokdi0oZr/7vmC4BU74nUUPRJ1WoDttRMB8J16JFs?=
 =?iso-8859-1?Q?ap35j/+3wZWAhZd5ns3oF/pqACGOt4qb5Uy7RIPqJYgCApubpUegf7SrZB?=
 =?iso-8859-1?Q?qfehmbjePsNs3vbHujqVI+Cr6JFvpbPFp4BA59LnbgmWnmqIQkgKPA0mkf?=
 =?iso-8859-1?Q?1VPidfjBJD6uvvt2KgL28m7Z7CAhi0/tnRBdfc6OIrs7LtYVS/GpvNP0HH?=
 =?iso-8859-1?Q?ajIg54O593tsjPaagKsyfzryudYVJeLTtZdF3Ri0DucDynvZHIReXBa6oV?=
 =?iso-8859-1?Q?YVhzAl/KdbsoNeplzmp8Vl3euaNytAM6xwN+NcGEnSgC9nyaZwM3EpJsmr?=
 =?iso-8859-1?Q?7iRO6kwOp8i2p9B6qhBJ16N8CxkZOJNUYrflF3EEUF6CUQ7gmTVxyL75li?=
 =?iso-8859-1?Q?al52mlxkMRTgcmdDtp4fy50V+0eKRORpnV9I64lRPne9ew6d2KUQZW+y+n?=
 =?iso-8859-1?Q?GkPngq8d8+yK9fdWHVpCWaRHVvLbrZVfvWTtz93nzpyUEfDDMJYHi/qagy?=
 =?iso-8859-1?Q?Cayc7yLXpA=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: purelifi.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CWLP265MB3217.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 14aca679-16ce-4cf3-712c-08da29d1c45e
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Apr 2022 11:16:54.5137
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5cf4eba2-7b8f-4236-bed4-a2ac41f1a6dc
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BXITcGP8jaA2UiZpOao7qwu3jyUE23ABj7ldivfQoz3po9RRbEj+GTRVX4W2yNctw35582YFBJWmJNLd423OZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO6P265MB6205
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,MISSING_HEADERS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following sparse warnings:=0A=
drivers/net/wireless/purelifi/plfxlc/chip.c:36:31: sparse: expected unsigne=
d short [usertype] beacon_interval=0A=
drivers/net/wireless/purelifi/plfxlc/chip.c:36:31: sparse: got restricted _=
_le16 [usertype]=0A=
=0A=
Reported-by: kernel test robot <lkp@intel.com>=0A=
Signed-off-by: Srinivasan Raju <srini.raju@purelifi.com>=0A=
---=0A=
 drivers/net/wireless/purelifi/plfxlc/chip.c | 5 ++---=0A=
 1 file changed, 2 insertions(+), 3 deletions(-)=0A=
=0A=
diff --git a/drivers/net/wireless/purelifi/plfxlc/chip.c b/drivers/net/wire=
less/purelifi/plfxlc/chip.c=0A=
index a5ec10b66ed5..f4ef9ff97146 100644=0A=
--- a/drivers/net/wireless/purelifi/plfxlc/chip.c=0A=
+++ b/drivers/net/wireless/purelifi/plfxlc/chip.c=0A=
@@ -29,11 +29,10 @@ int plfxlc_set_beacon_interval(struct plfxlc_chip *chip=
, u16 interval,=0A=
                               u8 dtim_period, int type)=0A=
 {=0A=
        if (!interval ||=0A=
-           (chip->beacon_set &&=0A=
-            le16_to_cpu(chip->beacon_interval) =3D=3D interval))=0A=
+           (chip->beacon_set && chip->beacon_interval =3D=3D interval))=0A=
                return 0;=0A=
=0A=
-       chip->beacon_interval =3D cpu_to_le16(interval);=0A=
+       chip->beacon_interval =3D interval;=0A=
        chip->beacon_set =3D true;=0A=
        return plfxlc_usb_wreq(chip->usb.ez_usb,=0A=
                               &chip->beacon_interval,=0A=
-- =0A=
2.25.1=0A=
