Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA3FB20ABF7
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 07:52:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728107AbgFZFwb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 01:52:31 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:42796 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728012AbgFZFwb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 01:52:31 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05Q5oPCj030397;
        Thu, 25 Jun 2020 22:52:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=YzK3jyTwhbIwU9wC3QehOV/RJ9Fwko5502SmOmBcI64=;
 b=pQ8NQ+kJWaoA/EWZrrThu+ABtk0X4gtf3yAG4XUDkGnGXI4CZxi47Tqk4HwE37GkHGEi
 Xp3jCiodMjsvFgYXCVCpIgFC2HuzwrhxwFzxdj2b2ZTEP63q61iWglgvUOSAajKkw+wO
 GS1HMofayRVR695xPoV2tHcfkWdrPgyxCbo= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 31w3w2hhcs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 25 Jun 2020 22:52:30 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 25 Jun 2020 22:52:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VdBeQhwWYZ1g29CivV1kMVizV1pOORvmHyVUQoTyODSLQ53MHiwa7g2G3R+giJh0I1zLgesDI/HQTYJDcl9AtqFpTSSCGgMvP7dDbUahuim0I7eBZs9wAhzPqxmS92Y1PP3sJ2gvBoveMmYPX/wAAFrtT1SVGEdmO/N9Yx47Rh/pTLphrSlsGujr2nG0jGyVVEresNyw3ArkmqjIxPKa7Rqsy4IasbGUkTWQVGlJsB0Mj+b5a8TGJO3nZ6oKgSmNsi6ccmlB1Mnml7l8rm8M3396HQQEaVHWHuCQR0ckQSHMG9W1XPh3cE2IAsecIPZt5wV7VwkqIsUbjvHBSpR43w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YzK3jyTwhbIwU9wC3QehOV/RJ9Fwko5502SmOmBcI64=;
 b=GHeVNOiN5wXXR/5r4BlfClgI8a1tSpoeL9jOwtC0mDFHtfF48xtvDjLwS77ExUsRAbQzUfrmNPrBcmKW54VgzBdQWt1TMBc8ILaoaQFg0Bbk0MkHThAUS8CP9m/WQp3doNfNJrFncaIDzMWmsdJb5SFIpzxEoLwEhUIJy2MGinn41zFZEnhulrTV1Pt6N+iGKlgHOfvExzAb6kVT3wpxVA/Dg4Mj0FD/OuigpzuFQEgAUvkVSne5MPJTjvvtECnv3LUPfuF6Zp5OATuLwgn9kOvHioI2YdBUL4vyc5P4QUVFQs/qJIP6Edz1vnCAIP7nAA26ZQ2vjmi8m4VXEzamSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YzK3jyTwhbIwU9wC3QehOV/RJ9Fwko5502SmOmBcI64=;
 b=IQOcOGu5S+CDZ9h9Jh3QETgCl0dYoiwX4FzIaX2XPZM8Q+J910B3M64cGXQEC4D4bBobiuTXMlfqvGFMUvSR8KCyLUSh89qT7S5xoy0YdwvAZTeWVE7mNvllC4IFj6iqCqF6/u5rm8RYcMOhbkBNzul7l7Gjedk7bS1ICFLD/r4=
Authentication-Results: cloudflare.com; dkim=none (message not signed)
 header.d=none;cloudflare.com; dmarc=none action=none header.from=fb.com;
Received: from DM6PR15MB3580.namprd15.prod.outlook.com (2603:10b6:5:1f9::10)
 by DM5PR15MB1209.namprd15.prod.outlook.com (2603:10b6:3:bf::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3131.20; Fri, 26 Jun 2020 05:52:26 +0000
Received: from DM6PR15MB3580.namprd15.prod.outlook.com
 ([fe80::c8f5:16eb:3f57:b3dc]) by DM6PR15MB3580.namprd15.prod.outlook.com
 ([fe80::c8f5:16eb:3f57:b3dc%5]) with mapi id 15.20.3131.021; Fri, 26 Jun 2020
 05:52:26 +0000
Date:   Thu, 25 Jun 2020 22:52:24 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <kernel-team@cloudflare.com>
Subject: Re: [PATCH bpf-next v3 4/4] selftests/bpf: Test updating
 flow_dissector link with same program
Message-ID: <20200626055224.ublxa7oxkpkhdwjp@kafai-mbp.dhcp.thefacebook.com>
References: <20200625141357.910330-1-jakub@cloudflare.com>
 <20200625141357.910330-5-jakub@cloudflare.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200625141357.910330-5-jakub@cloudflare.com>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: BY3PR04CA0004.namprd04.prod.outlook.com
 (2603:10b6:a03:217::9) To DM6PR15MB3580.namprd15.prod.outlook.com
 (2603:10b6:5:1f9::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:7d5a) by BY3PR04CA0004.namprd04.prod.outlook.com (2603:10b6:a03:217::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20 via Frontend Transport; Fri, 26 Jun 2020 05:52:25 +0000
X-Originating-IP: [2620:10d:c090:400::5:7d5a]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e144a7b5-0dd5-4fe5-51db-08d819951aa6
X-MS-TrafficTypeDiagnostic: DM5PR15MB1209:
X-Microsoft-Antispam-PRVS: <DM5PR15MB12094A7FA1C7C75F674FE113D5930@DM5PR15MB1209.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 0446F0FCE1
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nh5XySxc0USPcfYPmiwfS7FbfDRxGmHDjC+P2CX5/cArLSl4pEZEGDYClJcV6YiDUa3JPUjukxid7qtqS+O5Vb+LXqBdHABRA9N7ltiYTiP7t7Q40pJq/aslCGkiOjlHB+l5ZuJMn/iHnppvQ9ZwZcebrejBaXz+dDF/o7pGsjfvvjjZVKEojuPNttiarS8Bz6vprRgA0o5mkhdL3FNqJwTTk6O6lZiqeUuTtOLvJaq1YT1ZhhGO6Haj/SkQT1Or6wrUFMHCBftZwcWhmbz5yT9UasBhQiXwVsfDcJB6pG2MBqH69lp/4ptAB2zeWTly4IL2lnrIWIzWQSTXmz6nyQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR15MB3580.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39860400002)(396003)(136003)(346002)(376002)(366004)(316002)(186003)(16526019)(83380400001)(4744005)(1076003)(66476007)(66556008)(8676002)(8936002)(66946007)(5660300002)(6916009)(9686003)(6506007)(478600001)(86362001)(7696005)(2906002)(55016002)(52116002)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: im0tW2xQcvbMnMR+PECvUFWHRiUNLMhK36Dg0c8TeQrQGI8KQ+VlaQ211v5A107OipN0k1uQPNutfy6yVNRL5mrQPl+ybnzwbMNAOxoZ7/bWyJy+tGQMVKoiMFHdqLXiNdqcugRjB75+G1fsIjBt1zr8ZgIznWYTsqhgzSsCMOxkI6+pO0+rnCOO09NrU8Th6zZrsESmiU5Sa2x0v06uiOubwJlFpePfrFRcNfUb1v9IO6fXgPBsUOtqe914rzwATHbhCm4UeyztKgWnQsdimydB8wJ8wJeiBC+I7QRXOe0a4kmMmmLZA7W9YAC2PejsMgR1Hy49ujRwLiW4TyEqow+8r93SGLc3tLCyY7O+h7aBAKF6b3iA+SFlpe8cGLH4lnPuTfFvJcL3siBHmbWJauxf9KpiYDvDbbe7xC/j+foit6bBjanpnsMub0oTQZgaaZaNiGrhho4gisr4gI+euefqXPBocBWy1DrZhUuI/8vpFKjWVA8DZRNkTVXysooaJVGtgl/M8wQaMYM4Gwcoqg==
X-MS-Exchange-CrossTenant-Network-Message-Id: e144a7b5-0dd5-4fe5-51db-08d819951aa6
X-MS-Exchange-CrossTenant-AuthSource: DM6PR15MB3580.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2020 05:52:26.2883
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SVQ9lSxXnzvyl8gpqk3vAIES2lz0HyfU8oBi4zKB9jOIGPtuTQFk8OCSRazr5cyE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1209
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-26_01:2020-06-26,2020-06-26 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 priorityscore=1501 spamscore=0 bulkscore=0 adultscore=0 impostorscore=0
 lowpriorityscore=0 malwarescore=0 phishscore=0 clxscore=1015
 suspectscore=0 mlxlogscore=742 cotscore=-2147483648 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006260042
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 25, 2020 at 04:13:57PM +0200, Jakub Sitnicki wrote:
> This case, while not particularly useful, is worth covering because we
> expect the operation to succeed as opposed when re-attaching the same
> program directly with PROG_ATTACH.
> 
> While at it, update the tests summary that fell out of sync when tests
> extended to cover links.
Acked-by: Martin KaFai Lau <kafai@fb.com>
