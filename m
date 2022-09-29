Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 071325EFEC1
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 22:39:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbiI2Ujt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 16:39:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbiI2Ujq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 16:39:46 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2106.outbound.protection.outlook.com [40.107.212.106])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42B3123158;
        Thu, 29 Sep 2022 13:39:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D/SB3uZXdpEhotOoleW1DVFuvHvFPREz1u3qeLEPqSJPfanyjRxXEuB9bK4PSTGxzZRYJjnaU+d2aJy8+aIBiRkv+aRETHThnudhiF7J4GKU47Fppy88geBpVmN6/wc+lxv9r53uRr5wKsyU51uksh77/fTB9T8D6K1D4QzhzXUCo0g21+n4HW0IndT9gi6iaPqEgEFJS+9JUz+fwr7yf+LzNfe5BWKxP4o73yE/izX2XtgqiZw9j/Gi+4k/4c0Cd0Z524XJoWUfDTYe1Ox9dvd1kTz+sQCaAvH8apWkIuuG6INfr8KWNZalfdphB5Zb+QuhLZlQbRAzoAnGqCDodg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lSHRRed0nfv8oJm21tW+xtG9eLgyQwL3UR8PFSmMjAI=;
 b=noR+F+wnJcziJ09MdYCXcf2c0UeB84TzQy7M4MUynmR2UTukxhJ58s7Hrqrcng+bb3Gesy4IlttqnN9wz6ilzhSQZGTvSlKjMEnyTAn3V3O0pVA8T1ozpgx2nES+DWskaipEyaEFJwysfm4QGSwtws/nrnd4qp+uyDwCCdHy4FX0zdyP5Z18Y1SBf8Bwj7rxQX+/9OjH35pUpr3Vc29TsCkZnZGyExjcaB1G8cGSOEVxL93Qrmg0Xg31hbTJkhzdYBWvDffVYO9xL0cdWxLpO2qN/vovhz1X4COGKei3imQ4QHYAWyMfLK5rtqOLWTQxOtjmOlprslduEeUFF5APHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lSHRRed0nfv8oJm21tW+xtG9eLgyQwL3UR8PFSmMjAI=;
 b=IUXADuB3lGnDFSIpFfTzyPavqMYjme2VknpHbW99g3Ini8dkbfYKrG4qdbVNv5cUlv34s/8slylHbR2q3MPdVP8bp4bKd5BStkwhfTDxcaDS/WTCrTCoIv6//f1zp7+sQWtRD/LhG+KxYrNFE2UbpJWXEf1BIeA7PST8WLcVNlo=
Received: from BL1PR21MB3113.namprd21.prod.outlook.com (2603:10b6:208:391::14)
 by DS7PR21MB3503.namprd21.prod.outlook.com (2603:10b6:8:90::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5709.1; Thu, 29 Sep 2022 20:39:42 +0000
Received: from BL1PR21MB3113.namprd21.prod.outlook.com
 ([fe80::e662:d0b7:93bf:619b]) by BL1PR21MB3113.namprd21.prod.outlook.com
 ([fe80::e662:d0b7:93bf:619b%7]) with mapi id 15.20.5709.001; Thu, 29 Sep 2022
 20:39:42 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     Gaurav Kohli <gauravkohli@linux.microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH net] hv_netvsc: Fix race between VF offering and VF
 association message from host
Thread-Topic: [PATCH net] hv_netvsc: Fix race between VF offering and VF
 association message from host
Thread-Index: AQHY00EEpavH7b+Xk0qDFQ72IrNakK3234qA
Date:   Thu, 29 Sep 2022 20:39:42 +0000
Message-ID: <BL1PR21MB3113EF290DA5CE84A350D6BDCA579@BL1PR21MB3113.namprd21.prod.outlook.com>
References: <1664372913-26140-1-git-send-email-gauravkohli@linux.microsoft.com>
In-Reply-To: <1664372913-26140-1-git-send-email-gauravkohli@linux.microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=1ac951a9-e996-447e-b217-58dd1163c49e;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-09-29T20:35:34Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR21MB3113:EE_|DS7PR21MB3503:EE_
x-ms-office365-filtering-correlation-id: 9ebc8e95-ded6-4bda-ef46-08daa25abc8f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: D9Whl9+omwzrrd9UiKqxQGlkE7gEN6gubRzzRfbecxxUvJf+n0B4cD37BgmOGCBwf1+YzvxNC3GiT96EF/uLk8YpsPNWXJuSJGfD17qYPmDDL/84+KW6oscnl7ar4VPdkImV+tTyfZGGsrb7tFemCaXj15Jpn46v1r6XuT9Iu96LteNSq+dhDlcLuO/YfQnxpQ7YiB7hl53kNj6GY3GKP47KO8qz/IB9Y+c42j1j4Bn0yJVUzgQ7Z8gPKk1Z2mPOOiEYU7EXGTceMCgb1IWcTXcz+ix3XQDLy/2M7/0xPl2oivsHQ2xH30UqPUDkSXdecQyVtgxD8DKNNu+5XBXKZipKKbQ6tCIcWkpSjZlr6z5Ea6gnPpjcpzX/ef2Ji8BMZuwHvTPRi5b2EDW2lpr3+Kw9fqEF/pC+kTg4S+CURehH/AQ7dymu0K2EicyiZiMObYKWdQXFJ+kuybCv3m0+HOhGEDMDZBOfnCqBg0cOz4M4S2bd9GCxmOfPe93jPaH6xpQcYRKwU+Temb7zB9RBTSadA5HHkGNH9rXITM66P0UBe7l7+AJQ8lFxJkwpXQ+wugBALQ7722jpnHxnLHcqM85ffiBc8RgpqVQz7yOE/1uljsPpUIizr3Y0oDjCcze5dXnol7C+trv3sJ++v8cdvaVCSIyYP99PFkx0HdprGNL3/RJXgDkc8i9E07FBiFyH6vq1mnZiI+jWbSJfeqsFQQDBzA6fmzqOUwmY58dkxko5LQ8nr4bMCvfpHWUvHKsWk9EvJxeb9o/PSd4C3hE1FAh2S2wbVufUd1q5stnPBZ97E4IwpWzZl+0KzQ+3nMnD
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR21MB3113.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(366004)(346002)(376002)(39860400002)(136003)(451199015)(4744005)(5660300002)(52536014)(8936002)(66899015)(83380400001)(66556008)(33656002)(76116006)(41300700001)(4326008)(66446008)(66946007)(2906002)(64756008)(66476007)(8676002)(110136005)(53546011)(316002)(186003)(15650500001)(8990500004)(10290500003)(26005)(9686003)(55016003)(6506007)(38070700005)(478600001)(71200400001)(86362001)(82960400001)(82950400001)(38100700002)(7696005)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?FynKz9sfXB0jXwvWBB3tQc3lKzMWuM3VCVy2yOFlrRlxc0B8XkeBHL8KqAfc?=
 =?us-ascii?Q?mqFpI+zXc8GI2KCmXrGQ+QuK/xn4NpIvjMoTRqMTbezDjgRjnSd7OQlT2XjT?=
 =?us-ascii?Q?WW1UHHDFOUqy2nZGbT1uRQiC3YjwXw3qn63buKVBMm1MTthCg0Y1Tqbv6f6J?=
 =?us-ascii?Q?mXTDUGLchft2qwPzfKhidMfej8DWXdqeOylLSwIRMc85GVPrS53pQTavrAM4?=
 =?us-ascii?Q?kwjlrAMD22HlRwWwcYPf9hnzSpJYLeVom+0/2rg/TGoYrsCdY8RFhZnw6ICl?=
 =?us-ascii?Q?pkzYHd8W2iwAdkDx5qXs2c1Q210GC0S0gTRBXh3j8hZdgZielgWt4tSuiUc6?=
 =?us-ascii?Q?txA1RWdBJBlT8Se8WHEWVA7KIz3osfCIzb+pQ3oRfEoP5Iv7qm8qXg+YAWCH?=
 =?us-ascii?Q?4pL2vEFyKH9ZamFdssrY1uikE5yQ1tfn6hBd2dYi9lcqFdFsLct8OhnHH55H?=
 =?us-ascii?Q?KPh9f0kxEHiHY8rlPOJvwRftz/uQ2TYEB0LzjdjAiPnJKSz3NDmNOlZJxdhv?=
 =?us-ascii?Q?Gyj4CHCohkQrZ//pz6HU12V8hl628cENq8IXmiKBHCqi7DabZrvlYkVhj2pn?=
 =?us-ascii?Q?GqwP7Ld3GpKzlDw5R8gbfmZLIfUY9KdZCuhJ3KU/Mhv63akiGd8+hf490I+p?=
 =?us-ascii?Q?eRLxMWoc7ccv7/FbKRokY8XhafEBeez/euGC4qIyoAx5CMcOoBBeiqpFqGrj?=
 =?us-ascii?Q?W003M9+ZCRdAqOVSuL2LdniRq0aSSECAJDSK1VXtVzwMSJOhCuKE5gc4lEOg?=
 =?us-ascii?Q?2txVptRWOASxTiKU+LCX+rpHl89SPap++Wt/hWUl4nx8+y8Nd/YQXAlt5nJB?=
 =?us-ascii?Q?PZKlD4gStsjRcMDxPJa3xWe7tzfv2/Fy+Eue+vi5FQizfpde6t3TJ8HWymOf?=
 =?us-ascii?Q?N/BSKgehXAK2U99WN83sGXbbREaGbfCgaFi2+3q8HAA0gUP7onm6pHk5/mMi?=
 =?us-ascii?Q?ZEUq8meSiKeftdgGR9xQ/hFtcpH6Dayf9G/30yxBrcdm4XIuZbtRk1/9DQvh?=
 =?us-ascii?Q?vrAdxBIghxFqeo3AgXdAyNpWfdFTLtRfvdYeFUPdZq+4UY+m7uJKiFO28UZi?=
 =?us-ascii?Q?RjeCL0tN+6pYnyicaYd+1+VMGYdlvSEzmCmLcQW+JFL1am93cG4ThNDu/bCM?=
 =?us-ascii?Q?zMJ+zl/Vy7Cjr2Gz91aTPx8LOFhSovhMcPc9rDY6nhgbXjr3Gy279Jr8VSLq?=
 =?us-ascii?Q?Os2Z05OnKCSTYag9dFpr9w5qxrcU8vU8MaAGPFqk9pODD4ct7CiGlp/V6tuD?=
 =?us-ascii?Q?Miauq0y+NWjYQJ7BfR3R5nu1iAVGNmCtasDYPUAGR0CAis6WZ8m+f50Espp7?=
 =?us-ascii?Q?k3kC/1xT8srdkh62Xi6Uj1Ebozz8PgwVCPgAOgYsYZWZqiwKw0mBcxRnSxmM?=
 =?us-ascii?Q?VU+wwn4J/Jq4tvHU2ptw7pl2gobGVn8Dn/rJMM1qkbVHc4QaP7qOJtoNFDCu?=
 =?us-ascii?Q?b2smA4Wyw/Ppfxb7tuLVC53KBGtq1Axh6xFPqvVPhWXHrU3s1L8vGBxh35Xp?=
 =?us-ascii?Q?hycKfFYqO0W20MeovfG16Gzov3xTRSAOhQjA1wmNDGtrK5/lGn2B0QeTTXTG?=
 =?us-ascii?Q?RVmvUegp49S8pFQ+Y+HCr4Rv3+ObizWdFGZiloBn?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR21MB3113.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ebc8e95-ded6-4bda-ef46-08daa25abc8f
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Sep 2022 20:39:42.0183
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ltPRRNMGtOE4TfSrwU2ExJ8ctvZsAtHMJBDXjRg1G4fBmVS0zh2atuT7qXABElXuBvCV/lxLpSbu/NlmjSauLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR21MB3503
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Gaurav Kohli <gauravkohli@linux.microsoft.com>
> Sent: Wednesday, September 28, 2022 9:49 AM
> To: KY Srinivasan <kys@microsoft.com>; Haiyang Zhang
> <haiyangz@microsoft.com>; Stephen Hemminger
> <sthemmin@microsoft.com>; wei.liu@kernel.org; Dexuan Cui
> <decui@microsoft.com>; linux-hyperv@vger.kernel.org;
> netdev@vger.kernel.org
> Subject: [PATCH net] hv_netvsc: Fix race between VF offering and VF
> association message from host
>=20
> During vm boot, there might be possibility that vf registration
> call comes before the vf association from host to vm.
>=20
> And this might break netvsc vf path, To prevent the same block
> vf registration until vf bind message comes from host.
>=20
> Cc: stable@vger.kernel.org
> Fixes: 00d7ddba11436 ("hv_netvsc: pair VF based on serial number")
> Signed-off-by: Gaurav Kohli <gauravkohli@linux.microsoft.com>

Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>

By the way, did you use "git send-email"? I didn't see the stable@vger.kern=
el.org cc-ed in your original email.


