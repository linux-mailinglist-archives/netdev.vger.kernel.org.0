Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5ED985ED418
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 07:07:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231787AbiI1FG6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 01:06:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229661AbiI1FG4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 01:06:56 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ED6EE9CDA;
        Tue, 27 Sep 2022 22:06:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1664341615; x=1695877615;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=dYR0UQknZj5gBkFxpcgbsnDzg2OoYiuGoY/nj1/K2QE=;
  b=T/AGf/zjdAwadQnJ5Xtny7a7ArkBkrxXqlUiSP6D+PoWJ8Tu3FkAgKXv
   MG8GA7eziKFNvWve1AKhD7V1bksr+Gc5PJpx9wwE398FlEGdJbIF9A+iU
   JE621J89Os0wHDMLPi/RUCorm7hFAfORJJFxah20JHJtW+c2ExUZc6geQ
   HdJdkb/mdy4iNaFfDK2Kv6gmmK6rC8rwPCKwGoBITZBjOuWDubcMye0ga
   bVYE0aB2ftkD+CAwyO7M9Fsm9S6esJNUCXoglOBSDb/UqqzpFKSqbNEBy
   ZoZfAKCEKohz60aT7qzVkWhgfrxvppi5GgXfOd0pgAgWlZxveTgA++o04
   Q==;
X-IronPort-AV: E=Sophos;i="5.93,351,1654585200"; 
   d="scan'208";a="115752959"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Sep 2022 22:06:53 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 27 Sep 2022 22:06:51 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.12 via Frontend
 Transport; Tue, 27 Sep 2022 22:06:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CenHkCONtdPUgs7jSgS8bwKHgd8HlbMiwirgF4oiqp5zYQ95U90/2dKzffylnMDH6rx5OeLHpDpLXDaG23vT+2+786vChBudxpAVKv+orGJW1JEcNgrB7S0+JNzJ56S39cXzaGk2rwlCM4h9HGg2/vLzn/zuzjJdCjCgnm80HlwVGwzSarhF0Ca3Aan//Mi7V1CduxBNun7TWweQltbGQH7sSGTdYWDuQTxMa1vowIEMGqcjgAojffuX/PXugYn5LEPySKf9lOUNXvhxmXee+yhjrz0R+aXV/yipjc6sxs1Ab6tTFUpocsfqT/UFu6unZRf/J+9GsQRTK5+CHuahHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OaLOJZ69vqsne36wvghge1uUNqOmIMlFr8b6hJvpuFU=;
 b=nDIWDvT55pxkwUN7uZNkMbPQ1q6a4QSsX6CYhhGGiyPqQcGzCr4MyiEkOh8WLtRYjJSS8qH9+TmL+fS/QGsPEuxdOSZ3fJsuevYPQvDuCqk8BO86/iw8ashNMOe1xxVIrz/ZBz23QwadIet5nEyNmgk0Q6s7bk0/s93FOZxlBFdBamu8Mqk5okCL06JhdCEg8GreqFFlCUeTrUPRZT2ZQ9bBiiSeoIlUoseMkFhqeJcpF49MiCjbIKb/b97yUZM7BjvDb64pOONSQ9O0k4fVjgf6cjM108ua6yFXt6zCT4CnccyiUvZgXxguONZGmmZme2Qeq+PQ2pnSPjH3rH1NJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OaLOJZ69vqsne36wvghge1uUNqOmIMlFr8b6hJvpuFU=;
 b=LcsI28K9d7BoE1hlAGBFUTQbUXrJFdaN9I5Us3Gib/DDDkTwDsxx78OZbt7pJaLsckmWk729pwJ69bNuS+h+iHBemFMcA6P2yFuBfY3DcSXNifCxhdr6p8An6SbjpWMif85uWI6kgsXt9+lBOYwsS0cwvUsMjOk6cnBOGeTuxOI=
Received: from BYAPR11MB3366.namprd11.prod.outlook.com (2603:10b6:a03:7f::20)
 by DM4PR11MB5994.namprd11.prod.outlook.com (2603:10b6:8:5d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.22; Wed, 28 Sep
 2022 05:06:50 +0000
Received: from BYAPR11MB3366.namprd11.prod.outlook.com
 ([fe80::48dd:cc88:c68d:9481]) by BYAPR11MB3366.namprd11.prod.outlook.com
 ([fe80::48dd:cc88:c68d:9481%5]) with mapi id 15.20.5654.026; Wed, 28 Sep 2022
 05:06:49 +0000
From:   <Raju.Lakkaraju@microchip.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <Bryan.Whitehead@microchip.com>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        <UNGLinuxDriver@microchip.com>
Subject: RE: [PATCH net V3] eth: lan743x: reject extts for non-pci11x1x
 devices
Thread-Topic: [PATCH net V3] eth: lan743x: reject extts for non-pci11x1x
 devices
Thread-Index: AQHY0ugp3CL9QYg8yk27N/OV0GDHoa30SaiA
Date:   Wed, 28 Sep 2022 05:06:49 +0000
Message-ID: <BYAPR11MB336659F1711CCC21DF9076629F549@BYAPR11MB3366.namprd11.prod.outlook.com>
References: <20220928031128.123926-1-Raju.Lakkaraju@microchip.com>
In-Reply-To: <20220928031128.123926-1-Raju.Lakkaraju@microchip.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR11MB3366:EE_|DM4PR11MB5994:EE_
x-ms-office365-filtering-correlation-id: de242fd5-901a-45af-1b02-08daa10f4021
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2N8qzbb/wc8y66jqA+SepdUf6mNQJdaVmaoC/JQeaYfpPHw4CwF3F92NimgyX5fYmGeHUFxeWUqQRjvBa9tHwLsD5uBFzkFbNhOVm/ouEMTYLA8JREVacHLSr18BAL4GglZXpfL2JxWilqapjlXW18QgBVbhetsVoMjEkLjbJXHfWAwqy86PZWyaKpFsIQL4tQOkTPkRkwzpEkJQziq0elEahUyarJeJahj0HnRp5zXTIQ2YP1XhPkJ7XBeAd5M8I8MElCtSZuuuzCFVFR/ComrbkGGKG0jU31pQ5z7WPhkZgoh4BJJj43Pv/6VO0QDRYM7EF04Y7hbUKdGo/BtNUbVAGfV0HTV0tthyWxrrdb49YzcVIxEskEAzMNg754Th2Om/7vpqTcgVp3mVZNkYYD6/+ZsoXuHGniXoc8eCajRlUsEPrZ5jOjiyIplm3fVZmUptTImitWnQi1ZmzNMXw6XQWFWcDKlrCxDikMU5sAh+c9c763X/VY+AOj43abtIQQugDAEnR7oOGqLV9VeMEUadd0xvo+hPplWFtlpT7CICU7pvV7oWrUdvTa3Y9wVjzHKV5LNDWG2Sa6s0C+s4RpeqlhqCy5RMuI/WLk8qXK3q+h5PN2mcX3Ou8oOSd1RxlbaXN23tbl7rUt19uNdzaCjWyQ0g/zW4ajhak8UmC7ehsxe3zh5MNWFwIHkoGbB0m75ULbAqBIpVXDDUG9Ajxf8ISNvvFWcO6BaRPwPPLx24zTFAHzabvND2lWRMBxvXKfHxD5BBFlja1Eby5qc+Bw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3366.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(366004)(136003)(376002)(396003)(39860400002)(451199015)(66476007)(66446008)(316002)(55016003)(52536014)(66556008)(8936002)(41300700001)(64756008)(4326008)(5660300002)(107886003)(66946007)(53546011)(478600001)(71200400001)(9686003)(86362001)(7696005)(54906003)(6506007)(26005)(83380400001)(186003)(76116006)(6916009)(8676002)(33656002)(38100700002)(38070700005)(122000001)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?fCm2vlt83TwgI2wotiPnqan/Vt6IKfDEUDtJ1CRHGl7m/S9Lwt6Ifg2CNClE?=
 =?us-ascii?Q?lYs7AmFb4mTotOGrw2RH+BRhlHHOl9D/DGxSAvyrA+fU1x+F5ipeMYoa/E+0?=
 =?us-ascii?Q?SgZhvcBZ3gXgACxKwVA5CL3Ae4SyXBz3mbFXHOhQsqcOwss7VOY3mv8+Ch9w?=
 =?us-ascii?Q?armQmMBZwPvA2DzHYTG3PRfvDkaT8+9YZmUB3aq2SdiHnO4JzD/HLqDRVbKH?=
 =?us-ascii?Q?eRvBH+G6Tu0CDCgO0Of3bXxYOS5NEbHhB6PYYEkxiygZHgIBWhLKUQZgYCNe?=
 =?us-ascii?Q?O/fmKmKGFPiJcLrHN3c/EbHqgZzZHMBqf8BLeIzDqkzGt4cfAXJlokwAeudM?=
 =?us-ascii?Q?Ypmc7WXL3HafyTTW/AdGAP8YyBoowiNEBwsr5ozfJfUSv5hHsFq6yJ8NGCLI?=
 =?us-ascii?Q?CbpSvt9iuJVDKH7mKRyJavnG+gPk4Aaono1nRSFApcvjW3abByN1U0P3PxI4?=
 =?us-ascii?Q?V9YR/S0dUlYBwQtiZ8/z/6jAvUpoC348+1k7SYjxPiHGQPf/MAo94SHnzhTL?=
 =?us-ascii?Q?sCZsviyjjBg86cFFQ5woYPNUfIHkrwDJjwrPy4kGRy6bHHXLH8VuBQJw8c3X?=
 =?us-ascii?Q?D8mviL+BcvpdzaYSlua4VztGdVL1+d7u2eaTIeSH75AIwKQE0wwytQVvNnPf?=
 =?us-ascii?Q?v0B8KcUuWA9pjj04wSV/lTuiWNOwT7ZejOSC06qWJstIt3bUg5myyLNeCAfO?=
 =?us-ascii?Q?feXlwLyt0sNaYkJegCosYZZhIgsgNok4R3vuIhLL6X9PtRV5BAhwA8BN9Os5?=
 =?us-ascii?Q?2x4wJQw5PaK4A1qBnOPdr3bHFXUVb9kMTaFCKaCGVqRA/2yns/Suvd6L0qf0?=
 =?us-ascii?Q?igqfmd0Dsx8C8CCrIqaY8vpn5/d/x7GcWu5g2/A/oBhw9dv1hKHyn6YA9Zig?=
 =?us-ascii?Q?UgWuZ/DEroHMd+XkHFI6v1YUREKEO0uzuPefiXER+texkGWRxSrTkwTjEULv?=
 =?us-ascii?Q?4DfGlsRVqSySJSHEamD0fudhTrgVIQDJSrwS9lar2tV+6toLGQEV6Sfjlo4+?=
 =?us-ascii?Q?eLmHEjjm+AntjlE16pS0KOippnSeAOook6nJ884s7e3h5O0l82B2GPAwpOJo?=
 =?us-ascii?Q?w3ZvUlqEmc7puwuEUTOc/cNxiMCnNGrRCoJgRB6L8AK2rqkAu/EPz3e0OEn5?=
 =?us-ascii?Q?PI23bOUYrOnBMo592oTPWFP49Egw7vjHDsxEm4RART4w0oRNBlA15ZqufhbT?=
 =?us-ascii?Q?11ZyZd6DyZjoo8eKke1RcXF5Yb1q11NvffogyG4djLzZnM2j+SbGphJGjR14?=
 =?us-ascii?Q?+vHTTUJAWWK61xPXIOysI211+JKTiKSGesQOW+wdnjWgeTiAEUN+bqwsjDXK?=
 =?us-ascii?Q?dt0iSCRDUiLZo2KgAd9DynZlIQ15nrW3vGR1xk33C+4I+w8cbOFkF+RMBoFt?=
 =?us-ascii?Q?fvkQYs0M+3jpukSdTl7ytYBLIHBIyNscVcO/KXhyj7TisyPVcBM79D/5K7ui?=
 =?us-ascii?Q?vNHDxD+h+3jY5v45iCackig72qftlfNtVKpSu4O4cbM5k4XdVsOydbfqzt6P?=
 =?us-ascii?Q?8x8skvXuSCakGu+VGcYaCAUM1vk98F8LBb9zdhLss4KzsBqjH69VDbWTexRX?=
 =?us-ascii?Q?5MkW+S49+5MFFr2r2/8Mj6mV7yXK6yrgmqOpPZTRaNBJUnSGBNOe9d/e9iX2?=
 =?us-ascii?Q?Tg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3366.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de242fd5-901a-45af-1b02-08daa10f4021
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Sep 2022 05:06:49.8526
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ak6IKY3/L8uJ5uQ1ppei1amQUvUszG5rQCNEkc9m+Zz0IwZndXkr9Ltw/QqCI0jV8kqPQsCfM+QDA4nx8cQjm0SidrzO+ok4IQdnn1xZAVM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5994
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Generate the patch on "net-next" branch
Please ignore this patch.

Thanks,
Raju

-----Original Message-----
From: Raju Lakkaraju <Raju.Lakkaraju@microchip.com>=20
Sent: 28 September 2022 08:41 AM
To: netdev@vger.kernel.org
Cc: davem@davemloft.net; kuba@kernel.org; linux-kernel@vger.kernel.org; Bry=
an Whitehead - C21958 <Bryan.Whitehead@microchip.com>; edumazet@google.com;=
 pabeni@redhat.com; UNGLinuxDriver <UNGLinuxDriver@microchip.com>
Subject: [PATCH net V3] eth: lan743x: reject extts for non-pci11x1x devices

Remove PTP_PF_EXTTS support for non-PCI11x1x devices since they do not supp=
ort the PTP-IO Input event triggered timestamping mechanisms added

Fixes: 60942c397af6 ("Add support for PTP-IO Event Input External  Timestam=
p
 (extts)")

Signed-off-by: Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
---
Changes:                                                                   =
    =20
=3D=3D=3D=3D=3D=3D=3D=3D                                                   =
                    =20
V2 -> V3:
 - Correct the Fixes tag

V1 -> V2:                                                                  =
    =20
 - Repost against net with a Fixes tag=20

 drivers/net/ethernet/microchip/lan743x_ptp.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/microchip/lan743x_ptp.c b/drivers/net/eth=
ernet/microchip/lan743x_ptp.c
index 6a11e2ceb013..da3ea905adbb 100644
--- a/drivers/net/ethernet/microchip/lan743x_ptp.c
+++ b/drivers/net/ethernet/microchip/lan743x_ptp.c
@@ -1049,6 +1049,10 @@ static int lan743x_ptpci_verify_pin_config(struct pt=
p_clock_info *ptp,
 					   enum ptp_pin_function func,
 					   unsigned int chan)
 {
+	struct lan743x_ptp *lan_ptp =3D
+		container_of(ptp, struct lan743x_ptp, ptp_clock_info);
+	struct lan743x_adapter *adapter =3D
+		container_of(lan_ptp, struct lan743x_adapter, ptp);
 	int result =3D 0;
=20
 	/* Confirm the requested function is supported. Parameter @@ -1057,7 +106=
1,10 @@ static int lan743x_ptpci_verify_pin_config(struct ptp_clock_info *p=
tp,
 	switch (func) {
 	case PTP_PF_NONE:
 	case PTP_PF_PEROUT:
+		break;
 	case PTP_PF_EXTTS:
+		if (!adapter->is_pci11x1x)
+			result =3D -1;
 		break;
 	case PTP_PF_PHYSYNC:
 	default:
--
2.25.1

