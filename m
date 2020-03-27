Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4CAB195DDE
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 19:46:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727335AbgC0Sq3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 14:46:29 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:56992 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726540AbgC0Sq2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 14:46:28 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02RIkFs4032290;
        Fri, 27 Mar 2020 11:46:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=JoXqBgFCTidK55eFggkReO7XJ6nHSnLzK4EanHHPdKw=;
 b=RsWGnuz6i+kdhXf3SGO+LgVOg0sza5yDCOqJ3C36KptVrnbRfyv2Cb94OW5b51Ln2uRt
 i5Ct2r+KaeNlGdf8KHg5sOsQdRdRw4KORJ3tbaUlvWXgzRvpILLeUNezILwsbBTNYIJX
 OZ/DfF7DR+kfRd//9ZNNnZBgiySyuBRYyGQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3013amn9bc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 27 Mar 2020 11:46:15 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Fri, 27 Mar 2020 11:45:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hHDlEjNGcdqQhezHyLKIsp007prW6PFCLSiO2EWJFfYFAg2Dic17gaRw1R5sVNf+xeUCGEl/bLVf/x0OGHnAaeyZaJD+Z2SnnCoHp2nhdgCbtc4K7YYUNdzgmuQ+v+CVJg6UjLWTlZ9Pes5gW1FGiH8pum5420hMIApdGCsMklHuxTNz4XmN2NSMxKSoXA3WdjkVhm/+v9GOwZk4GFj75JzpMfRTfz7V71gmgNNwcww0A2B7xqLckHw+JrvHf9Cx1PQ0n65ko07PTnadxuItWgDjWD14KMwauoaXWWPTv7SV+1U/rW+O34Nr0ZbtSF7tH2rVAHzYdnIKI3W7txb6zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JoXqBgFCTidK55eFggkReO7XJ6nHSnLzK4EanHHPdKw=;
 b=UHT4K1+0DNxspwwlHGe7pmN1Jum0xGDLHpYe1zvayE3MVxCEDv6nfmhXH3Jl1seXsz+soog2o2WGxTME0Wa2frHsr+6YvaORGTXjMBn7RTkBRbOsjzGwmzqvxJaxssxq3uU39VB4yr9AHaSii9BO1Kqqbn9r25t/Ql33ATaldutyzKQizaUkUsfTW2qfeugZksw8ucPI70K1E12lCkdR024pK84/QEXYyoq+rn2xASq7CET8yvCuFAZdDwMNH0VdRnhtDaA/+72vVSCy3YdrAuzlRc5Azr6X7klNoZD/85CSsPB9iZzRmYTyoaPQ+a0U8GJh99ILjUf2MxJqinfG3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JoXqBgFCTidK55eFggkReO7XJ6nHSnLzK4EanHHPdKw=;
 b=UYbw+Sndg0BMFfiWu9FciV33jrKX1uin+IxrG9OP9poqwjnkNcxi8M7qvuD/bRmD1NVMg6R+rJrtWiFApVOxWWD7hNUu5BYBMrIj0+G5RcAavVALOLaDa6kRjP5CIc73xFN8c1IBQMx2mZsTPdle2SpOTV1JEh/J4JATVOy3HN8=
Received: from MW2PR1501MB2171.namprd15.prod.outlook.com
 (2603:10b6:302:13::27) by MW2PR1501MB2042.namprd15.prod.outlook.com
 (2603:10b6:302:13::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.20; Fri, 27 Mar
 2020 18:45:30 +0000
Received: from MW2PR1501MB2171.namprd15.prod.outlook.com
 ([fe80::2ca6:83ae:1d87:a7d9]) by MW2PR1501MB2171.namprd15.prod.outlook.com
 ([fe80::2ca6:83ae:1d87:a7d9%7]) with mapi id 15.20.2835.025; Fri, 27 Mar 2020
 18:45:30 +0000
Date:   Fri, 27 Mar 2020 11:45:28 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Joe Stringer <joe@wand.net.nz>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <daniel@iogearbox.net>, <ast@kernel.org>, <eric.dumazet@gmail.com>,
        <lmb@cloudflare.com>
Subject: Re: [PATCHv3 bpf-next 2/5] net: Track socket refcounts in
 skb_steal_sock()
Message-ID: <20200327184528.qwr3yzz5z452btm3@kafai-mbp>
References: <20200327042556.11560-1-joe@wand.net.nz>
 <20200327042556.11560-3-joe@wand.net.nz>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200327042556.11560-3-joe@wand.net.nz>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: MWHPR18CA0039.namprd18.prod.outlook.com
 (2603:10b6:320:31::25) To MW2PR1501MB2171.namprd15.prod.outlook.com
 (2603:10b6:302:13::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:1c15) by MWHPR18CA0039.namprd18.prod.outlook.com (2603:10b6:320:31::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.19 via Frontend Transport; Fri, 27 Mar 2020 18:45:29 +0000
X-Originating-IP: [2620:10d:c090:400::5:1c15]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1bd18781-6d44-4243-cbd5-08d7d27f061f
X-MS-TrafficTypeDiagnostic: MW2PR1501MB2042:
X-Microsoft-Antispam-PRVS: <MW2PR1501MB2042E1C6D415CEC6236FD0E2D5CC0@MW2PR1501MB2042.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 0355F3A3AE
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(376002)(366004)(396003)(39860400002)(136003)(346002)(86362001)(186003)(6496006)(16526019)(478600001)(66946007)(6916009)(4326008)(33716001)(66476007)(66556008)(9686003)(8676002)(8936002)(52116002)(55016002)(4744005)(2906002)(81166006)(5660300002)(81156014)(1076003)(316002);DIR:OUT;SFP:1102;SCL:1;SRVR:MW2PR1501MB2042;H:MW2PR1501MB2171.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dEF5n8TbSFjv1ZXdVJqJpLKhFGu/NOb2CvRH55eURwHZ33ZKdvOZShL8SUdzYcMf3p3bId1RetvLcAECUb2M1tCY4WHWQkSnmYA4HtTOGJI39XiVsdWRVP+NUWH+//krphk79m8N9srnv8PEUcPoFEB6de5mWD8EVwzJfn0Pm3W4xc6y5ZceJDDkzOiS2zREvhezrk7b/jAdDLCMhOYcNoBaOF2UvgMLfegfgHHGIK56h2f3U4Rdp6Nisn5AkE3XrU8hIVDnijrbzqW9V2t6ie6f2fXeUgEbMsPHbViib5Gn+J5Gx48HTEFQbw2KkGIQLx2tFj6QajHgZXVPynTcVnoNOkpZk1b8TGBSq3oaWWHdebTNNB5+9JTnEcybCPn7OrZOs1Z7lg1kIhXZHWwfqtO1aEUVO4oy5+CHS2HPEn8FzifwvlXIptj117ooIg9j
X-MS-Exchange-AntiSpam-MessageData: 8UwZjQbTwQsBSdRCaur/69Yi7jsUzUIlh09woriYja72DAQ8jrnOD8BFfFD9YL+vjomuDtwD0agt9vvai8k7UoAqcuQUfuSD96F6QrN15gN40I9xDXZDW1jYV53mRMpvIlPDxlp6ptLyofHiGZ5eYq+WA3hoqxPkXCbBu1DhePZkEZCADEBvJg/eteVt95Wh
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bd18781-6d44-4243-cbd5-08d7d27f061f
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2020 18:45:30.3979
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bQfX2jekExKXljW5OqUgqWan896cWEqunxbtuli4W+jh0WadyGHHop1/6OshZxeJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR1501MB2042
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-27_06:2020-03-27,2020-03-27 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0 clxscore=1015
 mlxscore=0 malwarescore=0 adultscore=0 suspectscore=0 phishscore=0
 bulkscore=0 mlxlogscore=576 priorityscore=1501 impostorscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003270156
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 26, 2020 at 09:25:53PM -0700, Joe Stringer wrote:
> Refactor the UDP/TCP handlers slightly to allow skb_steal_sock() to make
> the determination of whether the socket is reference counted in the case
> where it is prefetched by earlier logic such as early_demux or

> dst_sk_prefetch.
Left over comment from v1?
