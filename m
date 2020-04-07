Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DF551A166A
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 22:02:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727666AbgDGUCa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Apr 2020 16:02:30 -0400
Received: from mx0b-00183b01.pphosted.com ([67.231.157.42]:48584 "EHLO
        mx0a-00183b01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727109AbgDGUC3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Apr 2020 16:02:29 -0400
X-Greylist: delayed 809 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 Apr 2020 16:02:28 EDT
Received: from pps.filterd (m0059811.ppops.net [127.0.0.1])
        by mx0b-00183b01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 037JbQK5019294;
        Tue, 7 Apr 2020 13:48:54 -0600
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2104.outbound.protection.outlook.com [104.47.55.104])
        by mx0b-00183b01.pphosted.com with ESMTP id 306mruf642-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Apr 2020 13:48:53 -0600
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b1EtLp0TH80X03l9k+oXTTzYtkvLzhyAL0qSr+CVhVPemdth3DhSC3FWMuFQgFC+H8qQ3QRrayYqyM/hvQ1cRpLYIuVri8ABBeJ8EAw4DtUxPLCD0boF8PiKPBvRYDV2h03Qk/DxoBJk22WZSUDcUJ+/uXWTCotfpy+lpAFnQh9nUzbDb0DghIDf4pD7c2Tbl3zG999yiBgGUg5k5AWTNQyu17iHapj8G69Kk2rlZbEAUwg/RXoyE765FwW8alLvQ3MHvxJKOQhXglq1BOusMmelpVlVMOBszuJRB4KGYXfmrt54MmzbJEzJ//tm/owlV2k4faWWBpkrMn0A2fga6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W0UK76TzFgOA2iUOqqcPQ4wXkAo1pJXh80+LEJ7aalo=;
 b=GZDKnilbWEOuO9RIMn/kpLQBAuUGsaNPHBh94eSnwu6T0+cX49U9fXqrVPr92RlahUF+SIaGuZIn4vQYtb0meV3Pz3mpmwt+cDMUIjGUVzK2TKwbTbHEuPbqgBEqExHddnZY82pIz/NscTOUhAclBTG7DZMf5NeF+hx0QSRsbE/71kmQ64k2HsC0ebD3ilQav0/ii39NelTyzWTbcZghs+Uvk+mcUr+SamZdqhAK0MJ3ubvQO6G1rSQKRvnOSnB24y9R1gFwNpUkVAH1AtvGYD5DKvUvYiSQkgCYUjEGp4JjrP2HJrCTmUGFS+BPYIlJan/4SuY13vPdYS+ib2V08g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=quantenna.com; dmarc=pass action=none
 header.from=quantenna.com; dkim=pass header.d=quantenna.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W0UK76TzFgOA2iUOqqcPQ4wXkAo1pJXh80+LEJ7aalo=;
 b=AJrvRgyVN1cj20kl4NI3Cpueq7/VvIvaB1fnXwMVnL6YdHxhgKp6FwUbpOnfrOsukvfX/BfF7WoeEqSPDiAYF6As/I+4z8Et32TzOEUW/h7Khki1iQ6wH4KAKPma6UMUsj9H3f+63IK9pU4gSx3/a81htssGgdwRYGCpvtblRcc=
Received: from BN3PR05MB2641.namprd05.prod.outlook.com
 (2a01:111:e400:7bb9::24) by BN3PR05MB2658.namprd05.prod.outlook.com
 (2a01:111:e400:7bb5::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.13; Tue, 7 Apr
 2020 19:48:52 +0000
Received: from BN3PR05MB2641.namprd05.prod.outlook.com
 ([fe80::a0b8:50f4:2701:4ecf]) by BN3PR05MB2641.namprd05.prod.outlook.com
 ([fe80::a0b8:50f4:2701:4ecf%4]) with mapi id 15.20.2900.012; Tue, 7 Apr 2020
 19:48:52 +0000
Received: from CY4PR05MB3558.namprd05.prod.outlook.com (2603:10b6:910:53::39)
 by CY4PR05MB3046.namprd05.prod.outlook.com (2603:10b6:903:f3::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.13; Tue, 7 Apr
 2020 19:48:20 +0000
Received: from CY4PR05MB3558.namprd05.prod.outlook.com
 ([fe80::c886:d658:a1c4:1f6a]) by CY4PR05MB3558.namprd05.prod.outlook.com
 ([fe80::c886:d658:a1c4:1f6a%7]) with mapi id 15.20.2900.012; Tue, 7 Apr 2020
 19:48:20 +0000
Date:   Tue, 7 Apr 2020 22:48:13 +0300
From:   Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
CC:     imitsyanko@quantenna.com, avinashp@quantenna.com,
        smatyukevich@quantenna.com, kvalo@codeaurora.org,
        davem@davemloft.net, huangfq.daxian@gmail.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] qtnfmac: Simplify code in _attach functions
Message-ID: <20200407194812.aziu2hedsfkwh7lg@bars>
Mail-Followup-To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        imitsyanko@quantenna.com, avinashp@quantenna.com,
        smatyukevich@quantenna.com, kvalo@codeaurora.org,
        davem@davemloft.net, huangfq.daxian@gmail.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <20200407193233.9439-1-christophe.jaillet@wanadoo.fr>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200407193233.9439-1-christophe.jaillet@wanadoo.fr>
User-Agent: NeoMutt/20170113 (1.7.2)
X-ClientProxiedBy: AM6P194CA0086.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:209:8f::27) To CY4PR05MB3558.namprd05.prod.outlook.com
 (2603:10b6:910:53::39)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from bars (195.182.157.78) by AM6P194CA0086.EURP194.PROD.OUTLOOK.COM (2603:10a6:209:8f::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.16 via Frontend Transport; Tue, 7 Apr 2020 19:48:17 +0000
X-Originating-IP: [195.182.157.78]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 12bfffd6-f00f-4ec0-c110-08d7db2c9fce
X-MS-TrafficTypeDiagnostic: CY4PR05MB3046:|BN3PR05MB2658:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR05MB3046DCAA18E799701E5FB7FAA3C30@CY4PR05MB3046.namprd05.prod.outlook.com>
X-Moderation-Data: 4/7/2020 7:48:49 PM
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-Forefront-PRVS: 036614DD9C
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN3PR05MB2641.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(366004)(6666004)(9576002)(66556008)(66946007)(5660300002)(9686003)(66476007)(956004)(4326008)(2906002)(33716001)(52116002)(1076003)(6496006)(6916009)(26005)(81166006)(8936002)(498600001)(81156014)(186003)(8676002)(16526019)(558084003)(55016002)(86362001);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9mRMJKhpJ5OqXETYBMKnc3FwU6jgMZdIB/OT12E362akRA7E+6zfS9zPX+UXZDVu5fvoMY/6jA2n4BXzxZ8mOnB2Ff/6uN3RrRnCEH9SQQqCSHYoC5VSwS32tl9mDL9OSBYCF+UflH6vRh7Y1qwiC6U2btLRRrCgPHUtAccmQGrglf1ROG6kOltaftNsJsg3n50ao0E6oVSjJDQj9I935pG2DiOz7btlK/bP9dX6UqEr7hNkrQRdT2v9xFYmDXr5VTQxIBmGOKePKjdr7ynpXICljKkWJbw5YSWN41X91lHii/Kr4M+ygDy+hai8ZP43gD0IWkG3cY+KdHSWgu5BCGgVIRPzXlpBRwgqloeJYBhn3Cv8bg/zlGZmYLFGOuImye7fWYn2u8rv3pWk8GyLwb++I5ewNd+4WoHqXQGFzq9CnBiWf/4ldUIRNMQAN9uq
X-MS-Exchange-AntiSpam-MessageData: HR8qq6/QVcm/qmySwRKP4tPZBvkn1MpzdJgZxRbMU+HIfPnMxRSHIvXjN1UGdP5+DltmOyOXDItnyfG7Ddi6Uv7CZsuNTGhSwd90aohYu0wGglXh0lUiwPW/S8bRn+t3BrkO2PpqkY9sDViCS819/Q==
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12bfffd6-f00f-4ec0-c110-08d7db2c9fce
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j55ykmrFdXdXGxdm4Ug+8N8CAiQ7Nv+7Xsx9kdH8MsoFsPZxetfrwxB9ucWzPWh6Fm1s38nH2q0K7BNIpL4xBmgmgJCBQgkfb3d7X2XfxR06oKACtqwxEeKyltR8OsakpTDZonFQ+Fz7ulIXDBTOXJR2gjo9cs1vH01lx82pY9ivoQgpAskAvhDee5bksNWYoryRTMEYm2qtLjQaVgYBeg==
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2020 19:48:52.0354
 (UTC)
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN3PR05MB2658
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-07_08:2020-04-07,2020-04-07 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=653
 phishscore=0 spamscore=0 bulkscore=0 clxscore=1011 mlxscore=0
 lowpriorityscore=0 malwarescore=0 priorityscore=1501 suspectscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004070158
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hello Christophe,

> There is no need to re-implement 'netdev_alloc_skb_ip_align()' here.
> Keep the code simple.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Thanks for cleaning this up!

Reviewed-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>

Regards,
Sergey
