Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F51A59FA39
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 14:46:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236609AbiHXMqS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 08:46:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237008AbiHXMqO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 08:46:14 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6264D8E4E0;
        Wed, 24 Aug 2022 05:46:13 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27O9N6m5022881;
        Wed, 24 Aug 2022 05:46:03 -0700
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2040.outbound.protection.outlook.com [104.47.57.40])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3j4x5h59xf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 24 Aug 2022 05:46:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ym2+gYu0AQprZdakpV1q8nWeBrg14yQGoxUtJPFataiOSC/SHjB0lgn0zAMT8q2EVYU6L8VTHGuQA2U7n0YKsV1X7ORr8mGLpApaRi6bmcthJd47VXAtD7yZdtu9kvChh7pH/F1/5Y3vXYvB/MWDvjkuKrn0q603faFEhbU/k3IhaCvPE64hwUifvyXAI28dG0mJTV8xzXWvvV2EAQmB8bkt7qRHUiEBkp06UosI8K+zspak7Z7tgsibuo5XldPuNXJIdk/HyUsbZUYMS/+7OIDs/DsGIOtB+nRy+T6tUpfy5QruUWkIqbPATmf1bosAjHhA8E0WyeFe7KLkTUE2DA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aBVz84ZndM/ZNVw/K7XTfKC5/fc0Aa6QFo3maBue0Q0=;
 b=XhLCzieQs/7ympYlmqtAEIqXq5VP5KP6DX8DQJoyaxhsjrMxO4Tu4MPqbmRBsh9BHZ59VeCRSpDqxCfowcJq8hMDTSiDKH7Ivnx2CEW++a++aaNqXM04iDoUn6X5/r7n/7ckWzdJBjIRMxpK/JsGhIHr6q1fiqMSa3U2Mtczl8CPtLZrfRtfp4JilzlbI354RDZ8X7WYJ1B8XvBDRUCCrTghxFDfBL4f2xJHFC87QJR/mcjTV0+VKyMuXUqVlB64sB/GG++gklK8zeKGp7BSjwTDukLDqzlSdZT3wXuyHmbIUQy7RQyz7UjE/uN51eGMkqjd9fW26IOslEfcdEMcnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aBVz84ZndM/ZNVw/K7XTfKC5/fc0Aa6QFo3maBue0Q0=;
 b=Welo3mPOw73I1JFlgynkREcxWwZkM8SExjeY6idveg9HKNJ/WPHCyUpzbl+b+3W6JGaW8x0SnPZu40GO3vQjIwSjGx8ykkjLcKzBue1NGz05X54P0KwkPwkPFmUyVuKIWWUjiWnu0WM2uOz1ChvK4EN20vOJ4yxWvkY35Fr/ag8=
Received: from SJ0PR18MB5216.namprd18.prod.outlook.com (2603:10b6:a03:430::6)
 by CH0PR18MB4162.namprd18.prod.outlook.com (2603:10b6:610:e1::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Wed, 24 Aug
 2022 12:46:01 +0000
Received: from SJ0PR18MB5216.namprd18.prod.outlook.com
 ([fe80::a0cb:528f:3593:e24]) by SJ0PR18MB5216.namprd18.prod.outlook.com
 ([fe80::a0cb:528f:3593:e24%7]) with mapi id 15.20.5566.014; Wed, 24 Aug 2022
 12:46:01 +0000
From:   Suman Ghosh <sumang@marvell.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        Jerin Jacob Kollanukkaran <jerinj@marvell.com>,
        Hariprasad Kelam <hkelam@marvell.com>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [EXT] Re: [PATCH] octeontx2-pf: Add egress PFC support
Thread-Topic: [EXT] Re: [PATCH] octeontx2-pf: Add egress PFC support
Thread-Index: AQHYtr3HeGi5pSU58kec6ewncZP3f628or2AgADq/hCAAHBBAIAAAysg
Date:   Wed, 24 Aug 2022 12:46:00 +0000
Message-ID: <SJ0PR18MB52162B8D21B4F3037822901ADB739@SJ0PR18MB5216.namprd18.prod.outlook.com>
References: <20220823065829.1060339-1-sumang@marvell.com>
 <YwT3V6A4xrS3jAqf@lunn.ch>
 <SJ0PR18MB52165D5FA51E433CAD0E8CBBDB739@SJ0PR18MB5216.namprd18.prod.outlook.com>
 <YwYaoqiS/0+N1TU0@lunn.ch>
In-Reply-To: <YwYaoqiS/0+N1TU0@lunn.ch>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3e0f2882-540a-483c-6569-08da85ce9967
x-ms-traffictypediagnostic: CH0PR18MB4162:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zNVmp2OSInpwtrnQv2D9oFQwuYpKKv1sdsKmS8saxeQLoBASaCuunUc4ZbOfX73NGYyCHABqkwzj4GyI9cgTB/Z8g3GaT/SoG9NOhnhsBhtI2B8fzaB2gCLG4hbQRJTmDH+OkRyF/pa+d3vlgpgDwYIiY+1GelT+vR57oxqaMK6QADkJPz5nmIuLLmQyIWACcjxqm/LsyEXIlsfpE6tLkAEOIm/JVS6K2HIi78ZCe+We748AjNNk+3xvE/P1Gx2CBwMVK2bM8TeHjXeGrHyKJkFAGgiK5Wh9YWT7GsllWZ8SisQN0zC3yO1/tCD2n1kO6RLuJV1WyKleeWnovnoFIIZzpLG2d8K/CmON2jy5wDK3DsqVsnS55eWgXVravDi1518mxGSNmCiLJ8zgYk4638hvJ0ztEaWXmd/ZeIUwkFVG8OYl3ujEX60A+HuW2NdYBeJ+dKWHTc5pzSoB7KTWo8NCr4vu/+pNnDc4oqWbrH8MMlo5653m72kZ6nSZH5cQx9vOzND6wF1hcf3KM1rUowEuJbTCzNiyOBdnzqMobWjKf+sXzAp+evm1t+MLRT0R1whwQ4XyGHJssZdRRdG1uIf6mPQg2woR6WZFF4YMERMBhKl921sBh8oabQDb1pfn8DmDK5GrjOQBDuyo7M8p1ATZoSs8qOxQrremzZ1FUGCFwveBg6A0t7R5RI1zB6E5qLkeFysNJ/kEZy8RfEfepYxmySh+ziyfeJcSPLgHlm7bVd9k0biWlNxBO0aOfuocMmvXbDXpQZnDRn4gRy3dPg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR18MB5216.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(346002)(136003)(376002)(39860400002)(366004)(41300700001)(6506007)(7696005)(26005)(86362001)(33656002)(38070700005)(83380400001)(186003)(9686003)(478600001)(71200400001)(52536014)(55016003)(76116006)(66946007)(66556008)(64756008)(4326008)(8676002)(66446008)(66476007)(316002)(54906003)(6916009)(38100700002)(122000001)(8936002)(4744005)(5660300002)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?JIgV0VstcOUqxBCCsT13l3VhsbUl+L7rJEQ8e9OMZfd01EqylRp/tG+WXW7T?=
 =?us-ascii?Q?yDCU55cnr5bMkOpWywoK3AzO3J3jzkoaXj6POgEvIYSnMshB6rh51kv44f52?=
 =?us-ascii?Q?RpmF5IkQOzrAZKqL3wL9I+5CLQVlV6S4CDY/grpVlGXHNer2ubAcAQUwb1A9?=
 =?us-ascii?Q?vcHfaPGUJBs4kxPRwEEz4oN9cajEnYMOcyP4TMuYBgPwZVsaOYWW4MtY+vqS?=
 =?us-ascii?Q?z6KTaMa2RIcZ1npCwP9JsxXClq8A8vlQnaOG6aQJ6YuO0+6DG4HeThtpHR1z?=
 =?us-ascii?Q?11j82KY7L75D76g+Eck/JTElrq+TKcADzTRHhEmqVuq0wPcQggjBIJdNf8LK?=
 =?us-ascii?Q?a1xNTXiKf1Qo8N3HCXp0Gx22LdQZOjkK0LTF30FFLMHOCFIWSolojzD8NK1s?=
 =?us-ascii?Q?75kXRG86USifWZbINJ5sorF0ugcnzHe29AsO+zawSjPW1TUWQtBUJfe/GZRr?=
 =?us-ascii?Q?kkc4iVOSg1D+OYGKjhKWn4feUfIAyC0XZgGjl26o6lkwY/+eVigQImkBqPJZ?=
 =?us-ascii?Q?J/yhqNxMqRAG7OSCu2JIe45K6PHpqBH/NIMEXfV4kEi+W8/MppN1L1i8XKM3?=
 =?us-ascii?Q?WRjCSzlFfG/XB0zq6DkkDKyONvB3PYycWEZgjOJX9PPoR8A2bARDbc/Gk8kq?=
 =?us-ascii?Q?Iaa4pxqm0KaqrUnWZ2ydGav+sP12M+a3dQBOdxpWHUnFoybjOTU/7k+wAmCA?=
 =?us-ascii?Q?lxmjEEyrqKScjP0hF8RBa34RcoQIO7mNMNkhEyIpckhjmLKecT68VXFF2MgJ?=
 =?us-ascii?Q?g4pBK7R6bQJ+GNzMJIP+ZbI8g2Jj/tz8g7uS15MQ38pJgkkpH4Kk9C8BzRIx?=
 =?us-ascii?Q?cwUMgpp2DnrWd4t0+NQeGT/owhQHSNo9FvHEZKAA7Yd94tJQW/UxbHSoQLnB?=
 =?us-ascii?Q?xcXTm/pleWVFDIF6udxLj6uUAzpwWrpLnxEQNGUczIfkMxJYgZX+ac//Osb+?=
 =?us-ascii?Q?EKp9zK9BYqQda2bLaDQ4ZSEjOUZd8Pw7sQ1u9+Uaapfx9+QE0EEHBlEcGKPi?=
 =?us-ascii?Q?WKStBsAFGPoU72jHaw6+uLCePzToazp1PZvW3DGGW3NpGqyH9BYpH3h2rKOw?=
 =?us-ascii?Q?JUtXRbSpwDbOIKDbFcAG5iOUujJ3FDnji/jfcAEk/3I6hX55BBE0uiDtmu2y?=
 =?us-ascii?Q?sRN3IdEkwWLyRGPchDBL1cjJsSFk0GSTWMs6NCPOu/XFeK/0c6bkhPbTnDor?=
 =?us-ascii?Q?1H3b1tI0zcAYlfLyr07zLdW7G8I9WLg7wIFgbpoAuEnBHEW1tnf3Ywfgyk+0?=
 =?us-ascii?Q?KTLzG3u1Y7utFkDZyfWx3/n4SiZ+q9PLCacA4hgIIDtcCe/dRPqp3SkWWt2/?=
 =?us-ascii?Q?knn4R6tas535bxf5RpS32QpWobtgObn6JG7CEhyYWFaEY326WEZufh1iVm1n?=
 =?us-ascii?Q?Ir1M2LE1m3MPoZNs/Zc1glJR19R6Fbb95kdegylXvOrk3C75kGV+DFMAViMV?=
 =?us-ascii?Q?uOiSSNIR9Vnt2ymbX1DO7r3wpELAbmkHy92iKAVqq3wFuWuPGZ/gaYnqB3DM?=
 =?us-ascii?Q?mni9hwjwhMCalutu3M28a1iDah+U3U+tLDoVXeBz4CCrhvvqHpXrjP87rGCV?=
 =?us-ascii?Q?IWTS1zDv2LD2SafNBpSCf4tIWNtGzUoKb+Dbimse?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR18MB5216.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e0f2882-540a-483c-6569-08da85ce9967
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Aug 2022 12:46:00.9481
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Wm43pYEe68vVbj0xJ2L+8W0hQDBJLoaFWrI8ZpLerKJMDbMMS3Bv0lMk8de0yHyJJEYMMc+HmD0bNesa0A7L4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR18MB4162
X-Proofpoint-ORIG-GUID: 6Qaa2gNkeOuoJgQW4rlpFFTGTlTojRUu
X-Proofpoint-GUID: 6Qaa2gNkeOuoJgQW4rlpFFTGTlTojRUu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-24_06,2022-08-22_02,2022-06-22_01
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>> >> -	schq =3D hw->txschq_list[lvl][0];
>> >> +#ifdef CONFIG_DCB
>> >> +	if (txschq_for_pfc)
>> >> +		schq =3D pfvf->pfc_schq_list[lvl][prio];
>> >> +	else
>> >> +#endif
>> >
>> >Please could you try to remove as many of these #ifdef CONFIG_DCB as
>> >possible. It makes build testing less efficient at finding build
>> >problems. Can you do:
>> >
>> >> +	if (IS_ENABLED(CONFIG_DCB) && txschq_for_pfc)
>> >> +		schq =3D pfvf->pfc_schq_list[lvl][prio];
>> >
>> [Suman] I will restructured the code. But we cannot use
>> pfvf->pfc_schq_list outside #ifdef CONFIG_DCB as these are defined
>> under the macro in otx2_common.h
>
>So maybe add a getter and setter in otx2_common.h, which returns -
>EOPNOTSUPP or similar when CONFIG_DCB is disabled?
>
>	    Andrew
[Suman] I have updated the patch and using CONFIG_DCB only once in the func=
tion. Can you please check if that should be okay?
