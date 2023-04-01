Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CB636D33AF
	for <lists+netdev@lfdr.de>; Sat,  1 Apr 2023 21:58:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbjDAT65 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Apr 2023 15:58:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbjDAT6z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Apr 2023 15:58:55 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C265AF26;
        Sat,  1 Apr 2023 12:58:51 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 331IoKVj009125;
        Sat, 1 Apr 2023 19:58:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=u6BE1w2Sc5icdRwB2DLzWkxI8s425g7P/R0Nw6ZP1+Y=;
 b=bXS0//ZU0LRIBVm7Fr0cANTzLaI5zTDmaAtjaPeKXwldOyXtA1iUY+0WXH5RQkODEHDR
 yE7Tw7VFjjtkX9dacsokpkWJaYnBu8vCnRxWPnBrpQZSH8iaT3pc4XstR0HN9OUllKSX
 Qp1ulNBUxecmuc1/7dJhiWokHNLN9rUjUNfyvfOIEKthaqKYIfT3GAGME+m2zxLLXZsj
 w5xk6gub0vjlDq0wk37x7AM2qW4kk5e81/LJiitwqI30hOAwvR6IPmzBw2lU2ruPthuN
 64b199uI1LOwUhneTnAk2lX/bl4QQQAm8/2Wuw+GkLC7qHRPKZ7PSkLYCZoJiIvGC2kM Gw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ppbd3rupe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 01 Apr 2023 19:58:35 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 331JK7Ut017934;
        Sat, 1 Apr 2023 19:58:34 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3pptp38s5y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 01 Apr 2023 19:58:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fAfeHWQcl3CnIy3fWriSSGdzPNeI7pRsosZ7lytTqe0+dEeFtrqY2eYnm9RGHkAzyRyV07feTw6uUOLUaJJM9cUWjICg6UfNwi5iPlSR7cIjTOU9/ky/uJuGQ176AS9+iAnprYIdbN2ECAS7uUTFBwbKmJawL/YMTZyJxfjagjZIGRsgcEO2lkByBlW/4p33JRL5ZpB8YsfDFX63lcS2E/8bw/NZ5dz4nRVAtNFqzXSJzf/97+Klp4Km5Shes8Fvk9dSLW5VilZ+WAhJsogFtjoBjy8zumE6EqRESjGzz4rqWQBN0epo5iGB4DJyLCViVuH79+kELja90AOhvXD9pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u6BE1w2Sc5icdRwB2DLzWkxI8s425g7P/R0Nw6ZP1+Y=;
 b=NWanrOrvD0IyKDfT4AjPDn+llVJc0PhzTeVPYIGNjvHM+kKMIX6XonLLohnEn2prkRLDexJ4N54NL7P9peFe2R8nRODM1GNOt9X3WRGleL/c3eLTAMp8x2+ghoU4lcICPo/5Uamwj47GjBsJ3lo/uTYso50JSxXdMP3PNDqVocT1j37PEhsmw87tlYHpw0TMzFiWzSU7iNf/4QzNpJERGiqsXhjChR6Yd56Y+mPHq1x/K0aMywfmLnLunn0xEzobDMaa2XQcJSE03SGDX0n2G8hnpbuAO3y7PxOoE1nt5cO7vUvM2dTAIWtSjzikXtmv0Ju2YY0W9q6pssn0gCsnRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u6BE1w2Sc5icdRwB2DLzWkxI8s425g7P/R0Nw6ZP1+Y=;
 b=OQVMIhs8k15r1y2EZZsy8kS4FNAdx4YjRTAWtA3km1/SDHtu8Yh3758zd1FTqRZ5ovyLCTKDlusW7G5AEE+K5hvNyjTPsXNcLfp2tFLQlJore7dOK8DadxeiWLtvFWVH3vh1T+vApwJpqnnEmqxJaTO19ZnCR/t1lCS7IZLVAYA=
Received: from BY5PR10MB4129.namprd10.prod.outlook.com (2603:10b6:a03:210::21)
 by PH0PR10MB6983.namprd10.prod.outlook.com (2603:10b6:510:286::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.24; Sat, 1 Apr
 2023 19:58:32 +0000
Received: from BY5PR10MB4129.namprd10.prod.outlook.com
 ([fe80::311:f22:99b6:7db7]) by BY5PR10MB4129.namprd10.prod.outlook.com
 ([fe80::311:f22:99b6:7db7%3]) with mapi id 15.20.6254.028; Sat, 1 Apr 2023
 19:58:32 +0000
From:   Anjali Kulkarni <anjali.k.kulkarni@oracle.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "zbr@ioremap.net" <zbr@ioremap.net>,
        "brauner@kernel.org" <brauner@kernel.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "ecree.xilinx@gmail.com" <ecree.xilinx@gmail.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "socketcan@hartkopp.net" <socketcan@hartkopp.net>,
        "petrm@nvidia.com" <petrm@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v4 1/6] netlink: Reverse the patch which removed filtering
Thread-Topic: [PATCH v4 1/6] netlink: Reverse the patch which removed
 filtering
Thread-Index: AQHZZCxJt7hHR9OT2UmzMPODBe2VMK8V1x8AgADu1gCAAA1sAIAADO8A
Date:   Sat, 1 Apr 2023 19:58:31 +0000
Message-ID: <82F9EDF5-9D7E-4FFC-9150-A978A36F26B9@oracle.com>
References: <20230331235528.1106675-1-anjali.k.kulkarni@oracle.com>
 <20230331235528.1106675-2-anjali.k.kulkarni@oracle.com>
 <20230331210920.399e3483@kernel.org>
 <88FD5EFE-6946-42C4-881B-329C3FE01D26@oracle.com>
 <20230401121212.454abf11@kernel.org>
In-Reply-To: <20230401121212.454abf11@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY5PR10MB4129:EE_|PH0PR10MB6983:EE_
x-ms-office365-filtering-correlation-id: e420e2fb-0d7d-4171-641a-08db32eb783f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: S1DBOfMoNIFZ8G8QDBaKnaW7vB1fDdF2ISP7z2/Djp2e59P90B+jJJh+sBWRn19J+hWa8GrZiUwZRF40eCp2vhQfRFDOPZdfdHYX4PbOIi3Ywv815oLDCmaqj5HEP4XvDozSYtcEJ2SSCJwiaYioHoWECWWXE0YmOBy0zMuLBqIgArS8M8A/0GxvaNFMoJbcqtotNbLxN4XHp1wvQzs8eO0DChweaSfsUWDviiuyhzUeCoapwhtgjJyUQtCBNXukJsDEBI/BMnZ2uTQNzYBVssGRzegaiTOfTJpP8MxOU6rWo6vda1VYZZsGIChQZK5btu6jwavyE+KFG+YwJTj6n/6vBwbAhiRofMAKpCmqSRyx7O2pb2gpGlNzuO/igmR7Fmd3P8xH2T3evLDJJl4isbnFv20MeadGKeJSXzGrevBgJprsDVwxDaTUOxg7DcCXd0jqU+n7X+HUiwuvZHiC97JwC0ViSmFqTxNQ4jiYlwO07mjKeWor7OPVn40Ut3xZk7UOAL2xSj5MBJfjsSKF6C6VA/DQL7lGbq3GVzaPUgJVtjcB80Q77vDhIXvxEytj7oo3ZRmCgxmeX9C7aHkjuYkX5apueyR/8A4JAvLeCXREuUcz6r6/WSh1gbHGcG9gnAROkj3aaxpQDT3nPOjGvQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4129.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(39860400002)(136003)(366004)(376002)(346002)(451199021)(36756003)(83380400001)(2616005)(186003)(66476007)(33656002)(53546011)(6512007)(6506007)(6486002)(71200400001)(64756008)(478600001)(54906003)(66556008)(6916009)(4326008)(8676002)(76116006)(91956017)(316002)(66946007)(66446008)(122000001)(5660300002)(7416002)(8936002)(41300700001)(86362001)(2906002)(38100700002)(38070700005)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?i7QOPwutXP2lRFYjWYmRsc2gpK5xKwSjhRAq5uYOg9xS7JSojoegrDdVqTue?=
 =?us-ascii?Q?+Ur/6azmYEidD39oDN5M5uZYRQ/RqXEdls9c+yTTSqr6XkoEBqhtjSvn4eqN?=
 =?us-ascii?Q?SjBYV00RbU0BZl0DzGyatenv+FFOUDvow3b+M5oZXNfrUGvyyI85tU/zlckV?=
 =?us-ascii?Q?wIjAABJKAul71Alz7N+RtvlClPdtaWWnR8u/McIWPIuaIQQtQNAl4Z6BLMR9?=
 =?us-ascii?Q?Aqsz6xCffIc6nVGdqAAQBhzzYCPJ/FwEXxIPlcAe+t8c4J6pbYGxHdEtsehc?=
 =?us-ascii?Q?BtRUliCZDsb0wzlCJeNZLzft7Uqf3NZx1oR7/UhTyCDUYIwKk73Nkl40hx2L?=
 =?us-ascii?Q?LC3hBSvx0ixcQfaH7jaGRnH8Uy6TrBK/7yDnafyp6PZxldgApASb2/dnhobV?=
 =?us-ascii?Q?/NCsot20yR138Q/o4yE90P48gZJXo+q/y0qqrgByd3i7LoxM+LDPvT24jAA6?=
 =?us-ascii?Q?IWHCpd/sFxoM3ri+YcTrrD3az97yW/MujpzgRZvzgjMnSAms2qGw9hfP4ojb?=
 =?us-ascii?Q?m1kzqHY4q44vrx5bmrVgVFGATsSKhFpdH6HAX/6LnBy6dSHu6bjMYjjlb7CV?=
 =?us-ascii?Q?I9b34pvBXepaskoSqSgOhC70+LEpG3Mq1I0tfRtp9tJEf2816U6JTShe5Iq8?=
 =?us-ascii?Q?uU1ZJk2XOnGf/gaj08uCANPIMd2pD4OExDuDRcZ3s/EfLjbMykB/KAmJE2JL?=
 =?us-ascii?Q?ZRz0Lt3UIowaHWN2VYyL6rjD4OgJWeAKqjinFxxPSzprTskIRTLcu+gb7TFd?=
 =?us-ascii?Q?6RvxRi5TckfInc7ufyprsE/ZflWw8alDXzQuxBrXPojLOc0/R9zzTkgxv7zF?=
 =?us-ascii?Q?1dqzRoKWd/Y/QFUGfh4rj7ApHmlMul8Fgk8URH86QjSUQP431GKfzAyAiuyT?=
 =?us-ascii?Q?NWR9XyddqUtHxFQUWv8gXbCzgTAjQGvVD2cMoVsthdjm1UwGcMfyzEwEiwFs?=
 =?us-ascii?Q?+iFdexPCFB3n1GFKjBcdRz6Uww0A1o9dbnjGEgPAdCbC8fEKoQBpxySXTDV8?=
 =?us-ascii?Q?RbDwT3/l1RmVxT0zCxcXWN/QnzxZonY66u8zqGANZUZgNyElfqBv+5IXroRE?=
 =?us-ascii?Q?5IZY7G/8+R3vixJDY1MNlPlHv0zFGTuEiji3ZRhGuO/kjwO6awG7kjiJdH7O?=
 =?us-ascii?Q?vX25bsW/QKGOvWslBhnooBcFSpIUzk8sCFFcR5uOfWj/C8XGr4hZnSh8Oe4o?=
 =?us-ascii?Q?nI+d610i0SzxI+9CybF1E0KeuLjehGSWSnrn8TSH4e+qkF35U1t5mcyCqXYW?=
 =?us-ascii?Q?v4y8QIF0Hgv+9ZsuMsYQgd66dRvzEA1TZivHGpZ7zQf8aUTSfLypNEmyaIJ6?=
 =?us-ascii?Q?KgDyIq/qJPd0ZkrGlupqfBiLg7wcVJsp6blkyHTXR1ZefUs+gCgCVv9TQHRT?=
 =?us-ascii?Q?DknfAywEcry26Ftu+fcZWFkXf5dORqx98cGOC6AnpIrCUEa9RSS7z+NUU7aq?=
 =?us-ascii?Q?fJOYQpbt3xRcoVbo6zVs5KhvGvkGvTkxOScYdZJYRgwZdw5nXFFPPlpOU2xy?=
 =?us-ascii?Q?fWFIIyvW1U89HRjotaK6KYwvE0rjgPXYmm8IY1u3OGjKnzeeobXhpwPSnTAV?=
 =?us-ascii?Q?tMfyy6a1sJEYp60h3PerGmupacJKMgSJsnog42GaP4lFP7LrSE2uBs13nebp?=
 =?us-ascii?Q?A6xksVqVZIeMTYYWB7hARn9JYoifax1lGk0EHTpzbiZK?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <996063E2CD0F354BB95FAD69499003BE@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?OrGOSAFDx8yz+SB9hVuRpeYdERWeemIRIAD7WdHj1+g6srTaPj4xajMS3lj9?=
 =?us-ascii?Q?fG/S7Po4SAcZvLaFYe+JrT/9/iUwMGPfZ37/QXYzbXYJkxBmtQz8enQtBz9v?=
 =?us-ascii?Q?UqgXPrjx3FV928tWyeto1xp/mp+BM88ZHwBaZEmqtZHZHSSBEXqE/d9+2Nhn?=
 =?us-ascii?Q?DAy/3YCWhNo6SKfdOVscmxlnFfzKDUFqAaLnA6ThWcMLuWJaaGIWpddjuXhj?=
 =?us-ascii?Q?Uq4AEjp3mXNGxan3PlWlnW1mxFcjqu3tB6wUJ0lUhrG7RY7wrlLMRhb85kBj?=
 =?us-ascii?Q?kxSqxtE/TVTmSe45WNyuraylrWe6cxQMEF/rKLXAgM4An2DDJ5zSd7zqb4BC?=
 =?us-ascii?Q?QgzKCmgvJ70tPsqqgPjOC6i8q+Mk4DMd1nz3RPTHTgESiAD5bxRvKfxhafxK?=
 =?us-ascii?Q?qWXgh87me97n22Kp5Xo7e0+H1NAUsj4ZCQgdOu8O/GwvnZ0kDmj2DCiHAF9F?=
 =?us-ascii?Q?Yq9JfXbXboz2fnK+m3fPruKaJJLK3naXnEssR/i95VsUXKy26IvLuQPjoK0O?=
 =?us-ascii?Q?4KqtqeNNXlFThVyQePDNzLORNUAH57bd969+jnVSbKsq/y0Y6eBjD1z2TXJT?=
 =?us-ascii?Q?/6sqqk2BRZT/0H97JLUaEvHVxBxEConOz8oEjK6j1/UiaGw50tpbLJpfuQwx?=
 =?us-ascii?Q?iPRs9eUPBtqRwMChQrxV1iMyguJxSEAlckJlPi2OCEYWXypMVpIcE6qAKx8B?=
 =?us-ascii?Q?deLn4tp1N0LC2aiWTgcd8HBdWf6F6NA1cYYtLrLgxskR81NU8C+tP7XfvhOq?=
 =?us-ascii?Q?0qNCTW5pHTngX274w7jLpmDgY46GphY2/Rds52O3oZ7iUfkeK65d3xoGEzzq?=
 =?us-ascii?Q?shwGr/hpFw7zmqyNFTV4n8WQQdoFbdqr+T2VprDi7cq7KEj5/upSYue+PRrG?=
 =?us-ascii?Q?6spQI4sPM5avPfd7OPvDsUYVYGxgLAIvnpDVFvCrYc730REPhWTK9yXSUKl+?=
 =?us-ascii?Q?sZGDic92TRZVj+ScAZlP5eX40I6Y5naz0V1W21ERo0kv02ByufbItCvbOtOj?=
 =?us-ascii?Q?gbsJVbT2Noosm/Hblbc0TufZJuWSxpex580vau9B5XUyK2+h+nFtxo1UC603?=
 =?us-ascii?Q?SGK4UHHzUazg1ZiTql9qvaWPktqMqA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4129.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e420e2fb-0d7d-4171-641a-08db32eb783f
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Apr 2023 19:58:31.9083
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UxpaDVBEHR2DriKuG3feE712jhSpjDV0wVJ9qydqKDIsLnIqxQFqU/vEiycp/sxTq6Vz9FgmOdDne3V7qtdOJIWAvxA83N4SKmo4khtHBI4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB6983
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-31_07,2023-03-31_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 mlxscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304010183
X-Proofpoint-ORIG-GUID: 72H8U_1ZjzdkgyCjUU6mOLR8qV2F5ncf
X-Proofpoint-GUID: 72H8U_1ZjzdkgyCjUU6mOLR8qV2F5ncf
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Apr 1, 2023, at 12:12 PM, Jakub Kicinski <kuba@kernel.org> wrote:
>=20
> On Sat, 1 Apr 2023 18:24:11 +0000 Anjali Kulkarni wrote:
>>> nit: slight divergence between __u32 and u32 types, something to clean
>>> up if you post v5 =20
>>=20
>> Thanks so much! Will do. Any comments on the connector patches?
>=20
> patch 3 looks fine as far as I can read thru the ugly in place casts
Thanks for reviewing!
> patch 5 looks a bit connector specific, no idea :S
> patch 6 does seem to lift the NET_ADMIN for group 0
>        and from &init_user_ns, CAP_NET_ADMIN to net->user_ns, CAP_NET_ADM=
IN
>        whether that's right or not I have no idea :(
I can move this back to &init_user_ns, and will look at group 0 too.=20
>=20
> Also, BTW, on the coding level:
>=20
> +static int cn_bind(struct net *net, int group)
> +{
> +	unsigned long groups =3D 0;
> +	groups =3D (unsigned long) group;
> +
> +	if (test_bit(CN_IDX_PROC - 1, &groups))
>=20
> Why not just
>=20
> +static int cn_bind(struct net *net, int group)
> +{
> +	if (group =3D=3D CN_IDX_PROC)
>=20
> ?
Will change this.
>=20
> Who are you hoping will merge this?
I am not sure. Whom should I contact to move this forward?

