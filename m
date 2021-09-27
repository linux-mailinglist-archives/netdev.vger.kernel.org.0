Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2613C4193ED
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 14:16:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234258AbhI0MR3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 08:17:29 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:56248 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234226AbhI0MRC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Sep 2021 08:17:02 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18RB5P4B006250;
        Mon, 27 Sep 2021 12:14:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=no1VvsnjrkV40KibK2nYPhCZAuC8N9xnMom+tqxJyzc=;
 b=FtodYyVA3H6RU0egGGWXj/1prBwwJmfcvOb//RBP/dCYYmpZijLHAEwQJfrNtQhZWZF8
 94qMoFKYFlA5bpiX11s9VxmG8sYzB2VyUZIGL4rHXrO+cgdKEHrp69cuULYTlj1wTiLj
 xi6sLwusp7z3zLNXbnqko/Dzf6a9YOVFHEV83Qx8y1FZA5/NdjD9lWw/xXmL5Tjf36Ht
 2fWuCvakT/xAS2A/RAcLiMdJK3/TyItN+G3hSS36hB3AMA4369h94GrhPdAeRQCYZuQt
 YL2lP0FpS6UGg5OEh2UAoTGQk0byipH9cOR6hWm3Y7kis52tD1EySQ6XXy7dvv8oMZ7k bQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3banr744kh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Sep 2021 12:14:53 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18RC5Hkb049530;
        Mon, 27 Sep 2021 12:14:52 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2170.outbound.protection.outlook.com [104.47.58.170])
        by aserp3030.oracle.com with ESMTP id 3b9stce1w6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Sep 2021 12:14:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J2p9/MUJLeRZLzPWoMF/5mZdkGIf/j+iWopgZklZbZUcGEV10BK3Wy6hlHfvaNSqDtuCqCYc7rmihzrzVOHOmITdRxtdiExjeOIWLgYaPdIAH4ZmbmXpfevUDNXo5E/8V53z49sJRHPSqO+Iyfv5zZ8Xbbs8qKUFUlY3nTocHrdM6B7wrESNOx7XfBOLElJfRjoXTCfb86P8/cBRl8rIFzAcRe05zAduOlhidvU21jpH5x+DTXB23jOMgq1RBBRvb3qGepIwy+HAak0qznRQ6G7A3z5PB8d7IQ06d9EHuzdbj6/K3tjlWilENIAFYVG2Dq56OQZ+ta10RD+AlXBDNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=no1VvsnjrkV40KibK2nYPhCZAuC8N9xnMom+tqxJyzc=;
 b=OXO7Yxb0p9gCMCUZre3fxuRpXtqOT9zBoW2IqjTkGr0gMcjqWoTNV2xp9JGmQTsBHysD3FaaeDDlNp8jXxwnFuFSVBlmmYLtZ09+fGTJNFpRIxIJ+aOAFXS0iyxh8ltGtpt/ZYPxKENnXxqzUKccaozqCga0z3wbIdBYyLMQXstGvpFWMMkmhUXTOgdUX+bvp6XAtf2KxtKKwDub5Cq3LyxPuZZmej64maABvkPwbYw3thRd6q64Co9G3u9iqF8i7kRvQFkhlj06AuWQJRHdhzJU9CEe6POhlTXRUjdZAq0o7sRzN8XaHdM9r/ZVl/mleOILSnyDPiAOqAk0iKdhfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=no1VvsnjrkV40KibK2nYPhCZAuC8N9xnMom+tqxJyzc=;
 b=kOxh9FhVSY67hanWEfRzR15kwWDNlgdK+02Adahx1Li7lHSU0jNi3c+G9UMrRBDvUByhfaOT4Wx9Hc0rfFLuw/PWMFulSkySNmToSoDK1pZ5ftEYT8qRH0WtedURZ2ab8NhNzFwuf2ZyPcbyMtvpSpGcrqOFAC4qfGm06q7Wz5Y=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR10MB1294.namprd10.prod.outlook.com
 (2603:10b6:300:20::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.18; Mon, 27 Sep
 2021 12:14:50 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9%5]) with mapi id 15.20.4544.021; Mon, 27 Sep 2021
 12:14:50 +0000
Date:   Mon, 27 Sep 2021 15:14:27 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net] nfc: avoid potential race condition
Message-ID: <20210927121427.GE2048@kadam>
References: <20210923065051.GA25122@kili>
 <3760c70c-299c-89bf-5a4a-22e8d564ef92@canonical.com>
 <20210923122220.GB2083@kadam>
 <47358bea-e761-b823-dfbd-cd8e0a2a69a6@canonical.com>
 <20210924131441.6598ba3a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210924131441.6598ba3a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JN2P275CA0016.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:3::28)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kadam (62.8.83.99) by JN2P275CA0016.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:3::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13 via Frontend Transport; Mon, 27 Sep 2021 12:14:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a43e9f35-62a3-4647-7281-08d981b0675f
X-MS-TrafficTypeDiagnostic: MWHPR10MB1294:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB1294F129D95753737F51CB628EA79@MWHPR10MB1294.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8nx5Lo1ikQLRaPVheGhLsxKIaRVBx9IsSJN2E9hbRVAF3E/Madir0x5RYWHoSYmPK6J+FWDjNPMT8Ka6adttv7etg48zSj77IzL7Y5H2JcF8kTfqTUlsXTNMtY6vdru8wCcYj/E+UhMrECcWb3bpj1K5IkAoiHCsfzNuVeMxrUAaCh3ezbl8IFYHyVx1iuxQq0fw0NGAgi5kH1CuuuRv9EQsNCnnAn0Wf/xBqqsAOZ2tYkQ+iMlPT0rWSlKKVD2U0nCUWGHp+S0Brjsonse5lNsotXOUoCkQxUQxtf1Kb/W2q8HPLyziJy8IWvAsmxAvg6nhuvjJrGZ4HddASX3YMkOg/PJTj5T8cYFmlDuz2iBtOefiBJCVX9NGmEl93i4YM6QooB8jIfBjgnQPqI/fT6arVghG/PQkjDnZm1th0RRROAUeAt9vDBKefeRwnLtYIUX1pAzSWKTQsJyjp65Ij+4aqPn1Q3KxfdkPFcID3awljPejzDeufKsn64zoGd6bYkYtP2k5pZ7YdG8DzsfHjAq0rUsajFOYMAAkb4dQXxFlvowLx30DV/EanoQZO/SmszTSmI3Q5u7DNNCljAao9J6SpfM252pkOKz65QrERaTqM+2ApQsp8nVDAtXJCPiibV8ZYIDlSmJbNN+vxFzLRb5pXYK7MVKhBbticFLEiheX5JU7f6EkBqp427gfdYktWRK+mm/M/RHdo9MIhzS2tw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(9576002)(1076003)(4326008)(6666004)(44832011)(86362001)(2906002)(8676002)(316002)(8936002)(5660300002)(38100700002)(38350700002)(54906003)(52116002)(508600001)(956004)(9686003)(66476007)(66556008)(186003)(6496006)(53546011)(33656002)(6916009)(26005)(66946007)(33716001)(55016002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?X8uB9RzsSp4FZywONpzNhomPq+DjD6EIpqd8d1Xx+PWy/LqmJ5F7iQcpi6jc?=
 =?us-ascii?Q?ln9qCRPQF+4z61aZAHGEIpqzvgQfE+DncWWZOzv69y//kKYyEpiTcAZr1xY5?=
 =?us-ascii?Q?dBWaabnXjavjDQQKKbmdVGrSzSmbcspBnBhvu9osoBFFHVNKqrJJzuN54InZ?=
 =?us-ascii?Q?+MHYBATlbk7haSPn+oYMZNCkQzT3zfKdEE5gKMmUSReBK42rEK65dhvSJXb7?=
 =?us-ascii?Q?D0FjDLmQlLpeTTcuejwjkAWgaDuAITLh9yDYs0Yrg5PrnlDPqflmIHX+6s7C?=
 =?us-ascii?Q?tc27IULQrZSm9mXzuAtbDsS1rZ7KMIWY++08hh7PqVAE3ngp/dgs02pIJnnJ?=
 =?us-ascii?Q?WcA5gbBpbZkkDNC3x4wv41mv/H7hMAwQPpAwz1hSM5Xo7IL0taWC5ZLTiq0a?=
 =?us-ascii?Q?21cpSsuAL3Yh3J1AHxTpGboxGQEefWgRDuDF+usY64v+0+5/13qV2UtEGZdA?=
 =?us-ascii?Q?K/y1n1oYed2GTb/XfOGH/+FT4tYGLpd0TXbcVMGAt9Db7rgQ260ExSt/Qo8v?=
 =?us-ascii?Q?lrfibTwQv5qW2R/PZXiNORpZRfux2ERgOcgF6464ukh/lFC85yt+SJxYRT1+?=
 =?us-ascii?Q?wqulmk7tH5I4PNYeiuU4GXTV3dwSrhO//nnqhMFoB/VyEOsxo3s3RRY/5fps?=
 =?us-ascii?Q?KrMGOHoTA2AhdFMWQPevNpZHM/5FLF1ZomdoLb92p7oJO8GRKFCOk+KVs2vF?=
 =?us-ascii?Q?yyF8ba3dMKzmbzkCAMgUJCABJ0e7dRtU03meEGLwDxWeiOvzKooY10FhNhII?=
 =?us-ascii?Q?O0DT0WotGcQLRE3jCNZs50ZUTYNJ9GU72SGwjVkaMrrGIzeOwhU98pILuOp/?=
 =?us-ascii?Q?l8sczKJTMER9yTMt2FNO5zktFVLW6VHojEQXIWXwepz3XqsWz4+mydpIteG7?=
 =?us-ascii?Q?+mHd3nvbgtejDuJ3iU21MHBHSDrLoZ3Fcd9b13jiBNwhGaTKLktugesmxtta?=
 =?us-ascii?Q?y8aj8C22Qdd6VMO8kOffJfN+XzMEJrGfPanxMzczntZv9MhV+uFVPF18OdkX?=
 =?us-ascii?Q?S4uhMY65h4jwt/DPIGwOndmVwj8UdySzA1qgsFCpj0IsjYZovurtaf23GyGT?=
 =?us-ascii?Q?lq9hHdDETxwkVG3oTC6abVrktbBKSyjQRkOANG6GvDkuNYhrZvDbRagvQXe3?=
 =?us-ascii?Q?TKhGp3wKZbQz6EZcTN6uE6ysJ/s97DMSEBDu0tveHbcI/C3jgmD+pN2//riw?=
 =?us-ascii?Q?3uVQGvWHNGf2ayq0woHGmsnP6TcHonO4nTAUb0oWfd4B58dRlNxy5npVh4qC?=
 =?us-ascii?Q?e/eV71WaD6jewY+9H2xodH57wF9uiCI/pPkP0yLn0gRayXhECWJVMDEiAr2K?=
 =?us-ascii?Q?8eT8gXgDXs2K6dydycgHKFyi?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a43e9f35-62a3-4647-7281-08d981b0675f
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2021 12:14:50.2898
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2++0bl7HlgoQhIsjCzammwae+UphHSR6KQ5y3O83Dt5ifTYl6ychjAPmZ+Ky/rLpwimWhiOci3l6l/y3tVP8aVQQWheZBmEB+hP/JGRRKNQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1294
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10119 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 mlxscore=0
 malwarescore=0 spamscore=0 phishscore=0 bulkscore=0 mlxlogscore=901
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2109270084
X-Proofpoint-ORIG-GUID: dDz3ELSdJ_YInj7EyW3RM56CcodwiSJK
X-Proofpoint-GUID: dDz3ELSdJ_YInj7EyW3RM56CcodwiSJK
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 24, 2021 at 01:14:41PM -0700, Jakub Kicinski wrote:
> On Fri, 24 Sep 2021 10:21:33 +0200 Krzysztof Kozlowski wrote:
> > On 23/09/2021 14:22, Dan Carpenter wrote:
> > > On Thu, Sep 23, 2021 at 09:26:51AM +0200, Krzysztof Kozlowski wrote:  
> > >> On 23/09/2021 08:50, Dan Carpenter wrote:  
> >  [...]  
> > >>
> > >> I think the difference between this llcp_sock code and above transport,
> > >> is lack of writer to llcp_sock->local with whom you could race.
> > >>
> > >> Commits c0cfa2d8a788fcf4 and 6a2c0962105ae8ce causing the
> > >> multi-transport race show nicely assigns to vsk->transport when module
> > >> is unloaded.
> > >>
> > >> Here however there is no writer to llcp_sock->local, except bind and
> > >> connect and their error paths. The readers which you modify here, have
> > >> to happen after bind/connect. You cannot have getsockopt() or release()
> > >> before bind/connect, can you? Unless you mean here the bind error path,
> > >> where someone calls getsockopt() in the middle of bind()? Is it even
> > >> possible?
> > >>  
> > > 
> > > I don't know if this is a real issue either.
> > > 
> > > Racing with bind would be harmless.  The local pointer would be NULL and
> > > it would return harmlessly.  You would have to race with release and
> > > have a third trying to release local devices.  (Again that might be
> > > wild imagination.  It may not be possible).  
> > 
> > Indeed. The code looks reasonable, though, so even if race is not really
> > reproducible:
> > 
> > Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
> 
> Would you mind making a call if this is net (which will mean stable) or
> net-next material (without the Fixes tags) and reposting? Thanks! :)

This should be ported to stable.  The race is condition is real because
->release() can race with itself.  I don't know if expliotable or not
beyond just a denial of service.

regards,
dan carpenter
