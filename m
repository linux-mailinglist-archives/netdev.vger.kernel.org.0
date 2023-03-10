Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6047A6B5222
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 21:48:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230453AbjCJUsZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 15:48:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229958AbjCJUsX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 15:48:23 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D0F824728;
        Fri, 10 Mar 2023 12:48:19 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32AKE9NM008924;
        Fri, 10 Mar 2023 20:48:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=vlIbrP0GKTFNpnRvKZY0a+CSHtXCsIU/3iI1rcD2RbQ=;
 b=IoGC+Pfvx1Z1FmDtwiOTNuVoYSTOi5SUrRM0oaMwNTfeOLmPd6gTeJ1NaE1iWYSykZVs
 9tuE7uzqTJI14yFkkjPc4kIbDM740yAy/QUHCZpY9OEm1QMFDENMLa4auTIWKXFzBP1O
 ydw8ewtkwxmsmDIHgY8IP78gxx3+fZ9dE8g3TRx/mLfKxzweDDi2+UqW6z0icSJCY7de
 cN6tqhrIApTp6HysLdVGqop956zZSm1oYhYVevgR2lB6OGpxaf6JEOmNO0hQay2FKvan
 IfweZMCpxOrYUNYDAq6cM5cMxLStzFMfT7TMF9rWBHtQEt8TllglrqkDfDMcvnrhWT1c xQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p7v3w1v3n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Mar 2023 20:48:00 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32AJWrEg015471;
        Fri, 10 Mar 2023 20:47:59 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2042.outbound.protection.outlook.com [104.47.56.42])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3p6g9x3ysk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Mar 2023 20:47:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cKs0GwlHf1jH+FLtjRTMSzVMWHFputTZPqtkyrmj/kgMctAVRUDqLq2ebWP/orio38xsVi2fZPiA5jtRJKMA9JXMXCORx/sHBuwoh2MPGh0xgWMuSU4x931tw1IJEsYkFBUp0MKGByRkJXRL0gws6+Yx933XIwDOQgDSplDH2U2GcIuvu58I/W8fAGLnwaEVVQDQlG+nUxbVM60/3e4ELfs4vI1yDtX4EJXofrdcK22Wd6xClClw5aS528DZHIfQkFaj8FAbnwwQSWQngIyfI9zBaEOsRep8xFfU2DhF5GC1JJ1Wrb2xGeLAXI5zbd/XDmRIpXKeDd2eygZzhnU2bQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vlIbrP0GKTFNpnRvKZY0a+CSHtXCsIU/3iI1rcD2RbQ=;
 b=IaxoEX0BpIRfwbgwr29nonxN1nqdhKt65CUEYWsDrU/wmouqHRbjiWY+cyb9l7Q1Mf6hI5r45IEoeFxdfUpZUx4g0fUbdP/YpTmI6x/Sn4rdBGPdstpIYaT9LiS+6ir/fKjftJilR2ZMo1hgboMpCHy08lKk4T5neYNLzTdEI+khp23rtb9QXgSoASwnNeo1tuEgRtu8IWy/knswNNlh0rZ19pM4bpmO8ttv83A8aCfi472+w0DXRcaS56Qy71jKz3afmyFviajO34i+l7NtUFXGw8HHhT4LBjiKetAG574PUHdnqwyOpmlIry26YOPNNWVD9kmR1X2DUQQgmIhnzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vlIbrP0GKTFNpnRvKZY0a+CSHtXCsIU/3iI1rcD2RbQ=;
 b=nm8FUWxDuJP03e0VLmxSp9pW95YLtFY1gqLX+ngkQYNsLBV/lHo257Ss+kmRO7gkKpP+0NU7qH3tL5Yp5p07XSJfhfSt19Rw9n43Se38heUIfXHftC07ErQjy5oOKqYX8/o43hWi+eHZ8PbGmm0klQfOTTJhh9vG804iruo7sec=
Received: from BY5PR10MB4129.namprd10.prod.outlook.com (2603:10b6:a03:210::21)
 by CH0PR10MB7533.namprd10.prod.outlook.com (2603:10b6:610:183::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.19; Fri, 10 Mar
 2023 20:47:56 +0000
Received: from BY5PR10MB4129.namprd10.prod.outlook.com
 ([fe80::311:f22:99b6:7db7]) by BY5PR10MB4129.namprd10.prod.outlook.com
 ([fe80::311:f22:99b6:7db7%3]) with mapi id 15.20.6178.019; Fri, 10 Mar 2023
 20:47:56 +0000
From:   Anjali Kulkarni <anjali.k.kulkarni@oracle.com>
To:     Christian Brauner <brauner@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "zbr@ioremap.net" <zbr@ioremap.net>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "ecree.xilinx@gmail.com" <ecree.xilinx@gmail.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "socketcan@hartkopp.net" <socketcan@hartkopp.net>,
        "petrm@nvidia.com" <petrm@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Anjali Kulkarni <anjali.k.kulkarni@oracle.com>
Subject: Re: [PATCH 4/5] connector/cn_proc: Allow non-root users access
Thread-Topic: [PATCH 4/5] connector/cn_proc: Allow non-root users access
Thread-Index: AQHZUjeyrMgn8OBC9kmPq73sfHhYva7yr1+AgAHN+tw=
Date:   Fri, 10 Mar 2023 20:47:56 +0000
Message-ID: <BY5PR10MB41292A8AD879B726CC3D91DAC4BA9@BY5PR10MB4129.namprd10.prod.outlook.com>
References: <20230309031953.2350213-1-anjali.k.kulkarni@oracle.com>
 <20230309031953.2350213-5-anjali.k.kulkarni@oracle.com>
 <20230309170927.jzeksgqwstd6vunp@wittgenstein>
In-Reply-To: <20230309170927.jzeksgqwstd6vunp@wittgenstein>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY5PR10MB4129:EE_|CH0PR10MB7533:EE_
x-ms-office365-filtering-correlation-id: d0d35126-0bed-447b-20bd-08db21a8ba14
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: g8M9Fn0IU4RHCECPtiHZTqaYgAAqKtVgvjahojsR6zFXmBmZ5PAG6DN5WbxohNQsTYPUt/aQ403o5NBd1bkwwL6cv2Nd9LenjlgTi8Iw41Mef2OtBKbSunu3rYmas0KPgQmnSMjLbwEbyg/pAozH5Ljptiyoc1Gmq5F1wmRHUI6StjfExX3Kqw34rijPNFe0gSG8cxLz22LXNboh2iSE5SvXTy3CnxA58SVd4EtlZURojNfZyey4yb4TdREjnzseTmg1SO5KERcMPT/ZceevYHXijwjiCTkvuRZBUQrvw8slDgXf79+9c9GelIyjYpzZiqM5Web4r6E9eqbDz99qVDXCvDT2S/KcXKHbBLZpS8HIoBcr1olWIk7ozzj6BtC2G37U0F22zgayiBDkCeUetaXFWHdJEHXrwRXFEDB8rtbieRnl3fFvsucR8ZOKhg6Vt3C9NWofBa83silMEmEe4gJKIjQxdY/YypEjhMZrjmMWJbY7kqqOuPyF5DJyagXsvmf0OxUV7pZSl+RE6IC4GOsCG1Bo/vXXPJL7Yj7mfJqUUhpqIY1RFKlYbyrWCrg43RZ4FFkprK1Tguw8DUHbLzww+pX6+8MuUeuKI5zvTauG6rdQFTEseyJBF4asbFqjx30xAbZT7vQtLlaKKaHkLzs7PPiS+K5+ApGXvf3iX6qmIw00ctLsnKBr2uPsixx1YCNsLdSXR3fKlIaTzfDauqGtj8nzV5dgHA6skaCQ5e4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4129.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(396003)(366004)(376002)(346002)(136003)(451199018)(76116006)(8676002)(66446008)(91956017)(64756008)(66946007)(4326008)(66476007)(6916009)(66556008)(41300700001)(316002)(54906003)(71200400001)(7696005)(5660300002)(966005)(2906002)(7416002)(53546011)(6506007)(107886003)(9686003)(186003)(8936002)(478600001)(52536014)(122000001)(33656002)(38070700005)(86362001)(55016003)(83380400001)(38100700002)(586874003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?W4NUzcVjRkh4UcUk4kPP1B6IfmGMMHJ5VgqFhiYO30TxuxcqZkUYxEsaV3?=
 =?iso-8859-1?Q?yeItiJbWBIwGUzzY+AiRpcdDzFRg2Btc19q9joTE6KVaYz4fs4LT3yhD83?=
 =?iso-8859-1?Q?Aye9DNjC4lSDbiZ8ZBxsrE5JAI7eMRur2HA2GPL48uJNWHAyAeUiXR7Lff?=
 =?iso-8859-1?Q?TZFmGJe5o+gekvLwRTynH0cD+Ldmu3WA/BKiTAJs1uUO7urN3cUd8Xq+A2?=
 =?iso-8859-1?Q?FPmBdNQOUgkzAwAtAanFF+mXP038ZuncVr1Hl45AXJPJBGbQ2K5nePiYFB?=
 =?iso-8859-1?Q?UCCyLRpa5Q9vft4+MK1hyK24qeSm3lMv2Z62fftPXYpCeQAXE2cPAlPUaN?=
 =?iso-8859-1?Q?L8Na/Bp4Uw29YvQ8JRdbHOuQxDR9KUSAYiDGrh3WAofS0ZZFPUt7drni9/?=
 =?iso-8859-1?Q?mRrkALPxpXjzj6K8NFf07zzbcCdNZ7NzocnuLi8p1l8RSr5X7N2Ziv1ULN?=
 =?iso-8859-1?Q?b3lm2W4x6/yIvRkVOZoDw61xv+uf0mZ2MOld5pyigfQjszbd3+kejjjhY4?=
 =?iso-8859-1?Q?o2/XB3fRNGXvD+kgI2/syB0ipP69wWTRVSGIZkz8nxqquuGgiPuQxgbk+z?=
 =?iso-8859-1?Q?ZlnbMYN765I1yXTIP8Z0UtXB8zt17RbCC0k1ykPSrINg4rWa9Rm1he2d/S?=
 =?iso-8859-1?Q?Xw5LxGX+rKDVcw4Ox/HwOScXjchqN/mIjKpsPZOTjeZPDBlM9NQaRNV5Y+?=
 =?iso-8859-1?Q?5VZMT4gQTde1ABaBJEwhKsLq2Xm+klUB3c6V4H7v1gGC2dfrKtSiNipLgj?=
 =?iso-8859-1?Q?l5TgQauETQ88Bdl6iMaJ1SHy7W7cOSk8kaqaA16xBDgZ1q0FDS0JMl3zfX?=
 =?iso-8859-1?Q?c/4wz/+n2JKH0NiYZjuOyhfnmy2rR5OgHsZJDQy+ZDdDgaw8O5K1djwdPC?=
 =?iso-8859-1?Q?oSgY6byVj/3RILzBqvZZU36A3Qh6yKTCBQ2LNAHUmgDxJZUr0uOhFO5Afx?=
 =?iso-8859-1?Q?Txiy/iiAoaeGQ/i7lLYU3awBTweZ8yjd2Cbbg09ZeyVB2Qaotx0HIIx+kf?=
 =?iso-8859-1?Q?7knwzfmBEQyiRF0rtSM0wqA59yx/W9v03MZT80vtZjqxZjZhHl4UypUKpR?=
 =?iso-8859-1?Q?eWJygEmlnFqdHWWvX2h7MQpw1NfIlEKBKVUXitsr0RKd8G3rFxT3GeXJYt?=
 =?iso-8859-1?Q?WPOcUoFonjFtwoE68OVY3afKrivy3d9BC1I4+CqOLAij1aiTILmpqRjG/2?=
 =?iso-8859-1?Q?TnkGcVupCax1U3YKaIGTx+5b63NQWqYuAokh5+VNedJAbQLrsN7QmASBt8?=
 =?iso-8859-1?Q?o3NUUTmdOyBvhQGNGQ8omPWeSR1ee6QxO9LbA5gXgi9M6/lYEfFeERLtXS?=
 =?iso-8859-1?Q?vw53QUF0tLcSxBL9OtRA4w2U6XVlNzRkKAjdAfmTdv0cJHaGpIMRMTolOn?=
 =?iso-8859-1?Q?KNcA7+Kpw411L3mGmvYlDKLalyKtJm0A4USoMumV+fPClLjoRmVbQJrz8M?=
 =?iso-8859-1?Q?fT07a4mvoSF78Qbtdjnuq2C3VHSvLE2Z9elkx8cLmfckl2bA34TQj0n9YK?=
 =?iso-8859-1?Q?+nsNfnMQerGQ8mgHVHB1u/GbFJVatiJOcWl9Ha1pt7QjfHW909XW1wdu5I?=
 =?iso-8859-1?Q?z98YxwNIJcblEtnINQB3sIJ48KSTwOGT7ao2+wlEqy4GKFzvnnBjtEiE3B?=
 =?iso-8859-1?Q?9405DCcrSklvvESl5D0f0l5Gx6OGYQrKj5O28z8hsMWp9HvfGvKuB55qmx?=
 =?iso-8859-1?Q?q77ZwNUNi3dq+rLxQp4=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?iso-8859-1?Q?kFnaMo1ouwQbEoBvq+JRSd6+flamf5L6OTZ6/iFmA5MipPByiGjxoJqQMm?=
 =?iso-8859-1?Q?alnAp6RzZxd7cs2IdpQKhmRg6ACrhp8gsSo/njHmYCOY+N/jJpYQBk2zSf?=
 =?iso-8859-1?Q?qYKIWD8ZVfxOY0n6XEcOpmK1t+uHsrME5+2myaE8IoKlVnuXVVyhqsVGDw?=
 =?iso-8859-1?Q?ZQG+BiQLxtIKJOVKNvCpJLNeONlChNI+oZ7kPMQ/59VKt/Ufrr/rVCs8xw?=
 =?iso-8859-1?Q?M416jEMU7T/Rq9EOFCiQm71QnLbknCiz7E8YPI3sp5qagfdQu8EPs4MqLb?=
 =?iso-8859-1?Q?q1nHNWlsO5NKNQWf31A2+EAqFtLm+bjBoBUy1un/UW20Y3B/ZFRgPm8O+m?=
 =?iso-8859-1?Q?LIA5Oq4TV8n28EZAPDNIFpCbvYVbADRTQQOhnz/x/7m2K8W4jvd61WHGfa?=
 =?iso-8859-1?Q?PxDvT+P71iZJ3qXmzCTusPvc6BHOAMUDXk14C1d7acC1vU/FqGrsSxLWYd?=
 =?iso-8859-1?Q?Tk/QM6WmomhAuFAiE+jvg+aO8zCHVM0zLjlX5B2R0iZ5kTwlqTwqXq8Qb+?=
 =?iso-8859-1?Q?fFXatBHqah5w3mtsCOAckzL9FEzggCirxb0v5+tUBZY+iOWk/H3dNAgLC+?=
 =?iso-8859-1?Q?lqFuARWf8/wTEJHF/QqfbkMG14tfDfQ6xPi/cERrU9sOJzqx6fgWaDlgI4?=
 =?iso-8859-1?Q?mJSMgz7Tmr3/CXo0PEcaunp+7qz2dBaUn+kL6T8N56JJ9/96InpRGrzQGN?=
 =?iso-8859-1?Q?rreUAdsSH1haVU8O8jqf38+TbX/N0qYvTxPl/mTts4AY8TTj8BEbYbEtY4?=
 =?iso-8859-1?Q?sV2nRpmLoJKj2j367OvBprjzYmzDRS62fEDLeUFHOX99Siu1o8RTVBvx2e?=
 =?iso-8859-1?Q?MQxEr/rn7YnnzUMKAxat33ukpwfb9UqE+fz+jS1ZChEw4vmR7fGzTjkM/5?=
 =?iso-8859-1?Q?zp/UkfKv0o0weRzZ/daLphag9NM4jZBdE1bt4sEaGUC96efSrawevG4dWT?=
 =?iso-8859-1?Q?cR6iaoPK7tjNKszbTKLYNhXGvWnAhfIV/+jnP1HhrVtk7Z9FyW7GaaLPrm?=
 =?iso-8859-1?Q?BfCcgodzOmsoNYIBBRzjPIfjOztcWPNc1e7JgqheI9Uc1gvY+0i5rC7DfR?=
 =?iso-8859-1?Q?FSpVi2TbEhrjqqsWmYzorZCM1l7tyA2iTyNuCRwec5qQ8GRcuOTH7xyZiD?=
 =?iso-8859-1?Q?Tv74iYBw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4129.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0d35126-0bed-447b-20bd-08db21a8ba14
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Mar 2023 20:47:56.2692
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: INTx0qtIK2GiUHyEHn+rlFjEgtqw0eRDyxIX31aTUbaggIC4PRiW3yMCmva+e0w5gdK3R5/LC9FIAK+BA/ove35JAPKqB+xij2SYLfRfVBs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB7533
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-10_10,2023-03-10_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 adultscore=0 bulkscore=0 spamscore=0 malwarescore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303100166
X-Proofpoint-ORIG-GUID: 0LY5biPop7QH_FysS9K3lKXBhJmrtkNa
X-Proofpoint-GUID: 0LY5biPop7QH_FysS9K3lKXBhJmrtkNa
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

=0A=
=0A=
________________________________________=0A=
From: Christian Brauner <brauner@kernel.org>=0A=
Sent: Thursday, March 9, 2023 9:09 AM=0A=
To: Anjali Kulkarni=0A=
Cc: davem@davemloft.net; edumazet@google.com; kuba@kernel.org; pabeni@redha=
t.com; zbr@ioremap.net; johannes@sipsolutions.net; ecree.xilinx@gmail.com; =
leon@kernel.org; keescook@chromium.org; socketcan@hartkopp.net; petrm@nvidi=
a.com; linux-kernel@vger.kernel.org; netdev@vger.kernel.org=0A=
Subject: Re: [PATCH 4/5] connector/cn_proc: Allow non-root users access=0A=
=0A=
On Wed, Mar 08, 2023 at 07:19:52PM -0800, Anjali Kulkarni wrote:=0A=
> The patch allows non-root users to receive cn proc connector=0A=
> notifications, as anyone can normally get process start/exit status from=
=0A=
> /proc. The reason for not allowing non-root users to receive multicast=0A=
> messages is long gone, as described in this thread:=0A=
> https://urldefense.com/v3/__https://linux-kernel.vger.kernel.narkive.com/=
CpJFcnra/multicast-netlink-for-non-root-process__;!!ACWV5N9M2RV99hQ!NKjh44Q=
y5cy18bhIbdhHlHeA1w_i-N5u2PdbQPRTobAEUYW8ZiQ8hkOxaojiLWmq3POJ2k4DaD3CtyC9-C=
3Cnoo$=0A=
=0A=
Sorry that thread is kinda convoluted. Could you please provide a=0A=
summary in the commit message and explain why this isn't an issue=0A=
anymore?=0A=
=0A=
ANJALI> Looking into this some more, I think that instead of adding non-roo=
t access for all NETLINK_CONNECTOR users by including the flag NL_CFG_F_NON=
ROOT_RECV, we could make this change at an even more fine grained level tha=
n protocol level. So I will add a check to enable non-root access only for =
event notification (cn_proc) user of NETLINK_CONNECTOR, based on the multic=
ast group. Since CONNECTOR is very generic and could be used for varied pur=
poses, a more fine grained approach may be required here. I will send the n=
ext patch series with this change.=0A=
=0A=
