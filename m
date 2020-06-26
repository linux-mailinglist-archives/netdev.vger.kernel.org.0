Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 166BE20AC2B
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 08:14:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728277AbgFZGOf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 02:14:35 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:26432 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725306AbgFZGOe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 02:14:34 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05Q6C21U028481;
        Thu, 25 Jun 2020 23:14:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=3rOHS/Zb+NYr+VeFc7nF1GiAVnXWDonNbJvWrwsG+Sk=;
 b=ro9yHhoGskgGIejg3Bsk5Wb8wWPE6QqXo7eihwyRECSNOt5p1i3hMq63o6KJlwPl5IAV
 j9I2cXGM165VJ8y3Qhr93wW6jpUMa8M3tY4rMtt6Z2iB5z3Shaj7+eXG6js0dx5jF8uC
 JsHAyHxweXfm4uIoRXxRaGy+wrCtkGvkqIQ= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 31ux0qbwv1-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 25 Jun 2020 23:14:21 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 25 Jun 2020 23:14:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GoYH9YGxbIN502b1L4Vr6QU/F3JXnxP4I3FIWCYy25bVM/ufubB4N4knK9g3kXNoJA5O8AC0MmczpNO5dBD7AlUKCYIRouxAiC3jZtBfVBJTiHmHwVae9hujPMkfO9i4wt6c5F/WCnaZWPGeXdn0QzqkonyZHlAdCEuLjBokiGe3076DZrMw36hdyiUW+g4oSshBKYDMAL2FWgIehV+3BLCgtpywYxsvWbhPhKSNpHKpIRUgJCu5tURCEQG7ZtaTdKXFHn0y1ohetdw293Lsobhe3hRlclytOYxt0cSheukwgH++qUvuzjcCWgiM4c7jKWhE2WsLBSP/VLmLvgdptQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3rOHS/Zb+NYr+VeFc7nF1GiAVnXWDonNbJvWrwsG+Sk=;
 b=mYBpR0A8bADvV9fbhY4mNlczIryVx25a2BcsUjxJtP06OKLQ8Kj+DMXDlcw5Ykkj1IpbOiIIzi1cD8iXuD+93mh2dBmwh0KwPBS6IH7r8SCXan4o1mZmMVUBwIR6TEoMCKDk0B36GVZQf/UQnk2UaNA2Vc6tWdIUSXzK3gjubI5XyCiz4YciEzjYRJjsIatwagZcRsUIfjjzN/fTo4gxUG8vM5lcwhsJHLD/NkZFWG/gab1BOwr20bl4ZEhknJftpJVomg8TUw+2Ge/6sdUDAnyB42eubaihN5yoK3gf1rJmSl4STb0NS54v67E8gI4eG/xaCIKSKsJ1qq/uH97zBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3rOHS/Zb+NYr+VeFc7nF1GiAVnXWDonNbJvWrwsG+Sk=;
 b=iVZF/ywjnEBC1pMSh3QcDmimub4nZdtx5BvYQaL9TOifUNQE0WNL3nGqOuded1e6n2ADVagca5TQ0gPZgY7JAwUWQLZ9Zfo5sbHqkWIo7SCAQ0r7/9yDakexX1x2sHLL52N3OwveZDc35esUT2MayzSPUW8ZmR2UjDKU5xPUT80=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from DM6PR15MB3580.namprd15.prod.outlook.com (2603:10b6:5:1f9::10)
 by DM6PR15MB3273.namprd15.prod.outlook.com (2603:10b6:5:164::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21; Fri, 26 Jun
 2020 06:14:17 +0000
Received: from DM6PR15MB3580.namprd15.prod.outlook.com
 ([fe80::c8f5:16eb:3f57:b3dc]) by DM6PR15MB3580.namprd15.prod.outlook.com
 ([fe80::c8f5:16eb:3f57:b3dc%5]) with mapi id 15.20.3131.021; Fri, 26 Jun 2020
 06:14:17 +0000
Date:   Thu, 25 Jun 2020 23:14:14 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     John Fastabend <john.fastabend@gmail.com>
CC:     <jakub@cloudflare.com>, <daniel@iogearbox.net>, <ast@kernel.org>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
Subject: Re: [bpf PATCH v2 3/3] bpf, sockmap: Add ingres skb tests that
 utilize merge skbs
Message-ID: <20200626061414.xisj55tsh6hqxhjt@kafai-mbp.dhcp.thefacebook.com>
References: <159312606846.18340.6821004346409614051.stgit@john-XPS-13-9370>
 <159312681884.18340.4922800172600252370.stgit@john-XPS-13-9370>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159312681884.18340.4922800172600252370.stgit@john-XPS-13-9370>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: BY3PR10CA0004.namprd10.prod.outlook.com
 (2603:10b6:a03:255::9) To DM6PR15MB3580.namprd15.prod.outlook.com
 (2603:10b6:5:1f9::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:7d5a) by BY3PR10CA0004.namprd10.prod.outlook.com (2603:10b6:a03:255::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20 via Frontend Transport; Fri, 26 Jun 2020 06:14:16 +0000
X-Originating-IP: [2620:10d:c090:400::5:7d5a]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f219f711-9477-4d7e-fcad-08d8199827e2
X-MS-TrafficTypeDiagnostic: DM6PR15MB3273:
X-Microsoft-Antispam-PRVS: <DM6PR15MB327394061603955719D2255FD5930@DM6PR15MB3273.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:2582;
X-Forefront-PRVS: 0446F0FCE1
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 764eNrgviD/P3/1eXSRfyLvq9ciHnpcvcNyQdwk0vhlE0SVfau3srAp6tb/BSWIJ4o3xyyFmpE+cCP9i+Pro/mM+stmawHzl9OKXfYihT6wONlVr9XDLARWPLJftrfDv1RScKNcNhievLjARgN83/PFXKMjxlPizqbCseiZ6nE5FzAFFzegHHGBBxfB4mzksxsKXOFXlaibg/0CMI7amfEKMAr2EUlbspk4GYPxyMFHLq9uxWrOecY6T68c+SfVX9PhUDKBkcfeLnxfwo6WErcoCtdqUMEK8W1UuKtanszwz7vyrJRsU4a0OyjPsv/CN+j8H/OanPoe9UaRi28EGkA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR15MB3580.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(346002)(376002)(366004)(136003)(39860400002)(396003)(8676002)(478600001)(66946007)(5660300002)(66476007)(2906002)(66556008)(55016002)(9686003)(4326008)(1076003)(6916009)(7696005)(558084003)(316002)(86362001)(186003)(16526019)(6506007)(8936002)(52116002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: GormQQXtfODnJSqUvDyrvPx3Or+dLtwDVTfIFw3DrIj0PABJjbdlV0jr6S6Z0vRqwtinpM5TK5yhWIDVONhTns+flO9orSdHaBoy9ube2sE+FSK1LZqaeXhPGwESmfM+FTPkiX0SwWcxAGk4nVAa6EcJ2ByIoDCgOOdLbUnRTt7mojZ3vbVHMpjv9YmlCHfOzVgjI8g+r2VjI1m6T2YSmFgqDLbtRSHNZbjp6MOKVMAIBiLQtbihdkyYGK0MVfu9l/KbJ65DgkYt4+w9ynQ/ksiLqpZ0DdGMe3GubaV6T1adaoYQM81RnWVDf98OTgelm6NDri66yndpbxgix/dLskHaoBJaloKZ+85TEPxb/CUR1BFbOZW6zNXSVOlHrkvps2FmWrl6Edwcsa0pf/AnkFL+06aVDmM9Edk7hzVr7vDkAsHUOPk41xc3gVgkQFJKuUVytcYbiwj8NwQP8WnSCWkXVsPqGDhkNsev4deZtFD8aiFwJ+rDggUay3MXiyNBwZs+lJ+DLqHMdV4YPweTwg==
X-MS-Exchange-CrossTenant-Network-Message-Id: f219f711-9477-4d7e-fcad-08d8199827e2
X-MS-Exchange-CrossTenant-AuthSource: DM6PR15MB3580.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2020 06:14:16.9065
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CeWZK4WPl2ZNqOcGULHOmTPTFrDRiF0lhKXIoAP5vkYqd/UgIHq3rGB7VosUBqzU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB3273
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-26_01:2020-06-26,2020-06-26 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 lowpriorityscore=0 mlxscore=0 adultscore=0 malwarescore=0 impostorscore=0
 priorityscore=1501 suspectscore=0 phishscore=0 clxscore=1015
 cotscore=-2147483648 mlxlogscore=613 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006260045
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 25, 2020 at 04:13:38PM -0700, John Fastabend wrote:
> Add a test to check strparser merging skbs is working.
Acked-by: Martin KaFai Lau <kafai@fb.com>
