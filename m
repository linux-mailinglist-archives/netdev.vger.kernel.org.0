Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D497D15806B
	for <lists+netdev@lfdr.de>; Mon, 10 Feb 2020 18:04:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727911AbgBJRE1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Feb 2020 12:04:27 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:57202 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727003AbgBJRE1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Feb 2020 12:04:27 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01AH2FJV011091;
        Mon, 10 Feb 2020 09:04:09 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=Cmi8kc5A22TouVHWhDyAuir6eNaOJjY69HoZ2KYp2iE=;
 b=hpkBTAwsZ+jCTh/pYTYI91OnOY/Pgv4ynQ8ycZ3whIK4xYaSTHvElB23Ra83OWPAf6Ci
 FVK1QuEAzDqa9zjonrPjQ8aGi3/htm5FXvT2yTcHUkk8pEWa/zbAIafckCczLcu8m15+
 U0xinz4KcTxVLCQJPHx6dQPDQUxKBbHAVb8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2y2deunen9-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 10 Feb 2020 09:04:09 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Mon, 10 Feb 2020 09:04:07 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ayDgEoLyjCcsrmu8+zMHdr6ByfpC+Cqk1+Mr9mooz83BmsOlZG3+UBtIZ3fJyRXPVhbgnZSxR42wUr73O1iyqr3djDG9zLWg20aVvaLoyLmkYiDsPEgNlrS6RLtY2Vkc0dcnoa4taDXg055fTZ5BvYrnrbaox+Ap3u/W5qfh+rbOnkijDEOOP+pJIO9MxkWRS0VKVztZRxJ0NXTkO8RjJa3h7H058YYObfBe8nNXz8f58H9FFq7lGJNWgmakhw5iSOGOwzciMh3sMpl8dRruhQ/jrV+cdYHexa5EoVNXqOoh+beAho0Fcxi4Uf2xEWHXLAYsVpiQ43q4AsfK87Ff4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cmi8kc5A22TouVHWhDyAuir6eNaOJjY69HoZ2KYp2iE=;
 b=Yxck/7pnQOS1AW5Z2D4rF22GDkePKOqFWaYkqwmkU3BUJSBfWMyE82mNaBXXJ9t8XHHp0h16wbzF6JfbowX8yu+bTTp8Y3rGsOQhNsm17rzpg/hLy2i6z7Q3bPTV9a3owiuzQqnRLM1JLjCMVAxKo/CUwFEMBDSlzhvfuStWC5ZXtz8gVbCag2XFbGMfM24fsvUTCmirMmZi0Mbq5v8Gx+1agscSzyum6XdTFueL5IxpWt+LMlrHdsYlq2Fl2BaeTqQL+1vHOL983DayQDvaIrvvwhAh/jnrg8roUpIXKc9qszZvfQ4Upvqy8hJ08ERLZzRRoOgMKzT8pYnG0KS5Cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cmi8kc5A22TouVHWhDyAuir6eNaOJjY69HoZ2KYp2iE=;
 b=UPRBRo+4gVL92O1FtutwBOOy1vW6Juy2M1mCfetET8rV2FvspLl8IQKQDoSTW6mhQdLhoHKcY3Sh/kG2cLst/J7JDvER1kr/dUSxPanvDGDxkFOUmTh7g9YMTgYPfOV69buHx9a6H0ppHfPtTPLYVp3+6ib5dVrwZ6L0Ycigzbo=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB2717.namprd15.prod.outlook.com (20.179.146.224) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2707.21; Mon, 10 Feb 2020 17:04:06 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::acf4:f398:385a:1fcf]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::acf4:f398:385a:1fcf%7]) with mapi id 15.20.2707.030; Mon, 10 Feb 2020
 17:04:06 +0000
Date:   Mon, 10 Feb 2020 09:03:58 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     David Binderman <dcb314@hotmail.com>
CC:     "shuah@kernel.org" <shuah@kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "songliubraving@fb.com" <songliubraving@fb.com>,
        "yhs@fb.com" <yhs@fb.com>, "andriin@fb.com" <andriin@fb.com>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re:
 linux-5.6-rc1/tools/testing/selftests/bpf/prog_tests/select_reuseport.cc
 :826: possible cut-n-paste error ?
Message-ID: <20200210170358.a46i2nklxfcf5t54@kafai-mbp.dhcp.thefacebook.com>
References: <DB7PR08MB3801805D869B8A37A53B98719C190@DB7PR08MB3801.eurprd08.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DB7PR08MB3801805D869B8A37A53B98719C190@DB7PR08MB3801.eurprd08.prod.outlook.com>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: MWHPR1701CA0020.namprd17.prod.outlook.com
 (2603:10b6:301:14::30) To MN2PR15MB3213.namprd15.prod.outlook.com
 (2603:10b6:208:3d::12)
MIME-Version: 1.0
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:200::2:29b0) by MWHPR1701CA0020.namprd17.prod.outlook.com (2603:10b6:301:14::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2707.21 via Frontend Transport; Mon, 10 Feb 2020 17:04:04 +0000
X-Originating-IP: [2620:10d:c090:200::2:29b0]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1c604df5-a8b6-4c01-6360-08d7ae4b3c9a
X-MS-TrafficTypeDiagnostic: MN2PR15MB2717:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR15MB2717852D7ADBD6055AB69C42D5190@MN2PR15MB2717.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-Forefront-PRVS: 03094A4065
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(136003)(39860400002)(346002)(376002)(396003)(366004)(199004)(189003)(1076003)(16526019)(478600001)(7696005)(52116002)(6506007)(86362001)(4326008)(186003)(81156014)(54906003)(8676002)(316002)(81166006)(8936002)(6666004)(2906002)(66556008)(9686003)(6916009)(66476007)(66946007)(4744005)(55016002)(5660300002);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB2717;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sT1heazrPSchJDZE+AUKMZl3M+E0SwUHznnawpwLCt/KalMYlM3UNqq+yS3vgpMezSfdSYsJNo+9uLXJiAysS6DFU+3qwdXJfCyOA1D5Pcslb2uPMBhiVDv/C5tqNvlIjX1N90zsllVAMc87Q9KlRDYu+zAVtcgc7RwB+NdtZKJ4dJUG4VA/Z0HJOCqyJA1ty9pwyUucdINqPDAmtnor6FAkvmrjgQK0wzC3J13U4qaW/EMhGe7AYla6a6UGngMsN3PuUriJ+29SFSezeOYagHZAIneoH8P22vZB9HRlk5r6QsPN558Uk42lgJDDA0rU+svCoV48nelAjisIPV9MPH2JHBqk2blzSXohFFyXi52JN23VY24eP7+AgZ0zidawUX2qbmULnAi+XmTabaHIL6dHwrjBKb2WKgM9xvBQISfUIzoChs4R6AZDiznLXHZ0
X-MS-Exchange-AntiSpam-MessageData: bwpwCpbXzqx1onQajinw61ey5PiwErwi3BkS7gUENzA3A5bnD61STkUadnPtQxk9TDlusNgfVWveJRAtKkyp+H0eTXwFr20FBW+eeT2GhfCfNbnwE1LNT5p8HW5h3oh+vH+6Wj0W3Mh2U/jfFg6c8QDuWUdWVIjYQD8SWtfY0cbVMOzOGjCJNwvvZXp9mWRU
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c604df5-a8b6-4c01-6360-08d7ae4b3c9a
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2020 17:04:06.0704
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s/YZfShysnS33YV9A1ce7kO4zZpe8/TFzwdHLXr0lWXXgZ1K55BM6L9L5BoG5i5a
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB2717
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-10_06:2020-02-10,2020-02-10 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 phishscore=0 priorityscore=1501 adultscore=0 mlxlogscore=705
 lowpriorityscore=0 mlxscore=0 bulkscore=0 spamscore=0 clxscore=1011
 impostorscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2001150001 definitions=main-2002100128
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 10, 2020 at 01:42:45PM +0000, David Binderman wrote:
> Hello there,
> 
>     saved_tcp_fo = read_int_sysctl(TCP_FO_SYSCTL);
>     saved_tcp_syncookie = read_int_sysctl(TCP_SYNCOOKIE_SYSCTL);
>     if (saved_tcp_syncookie < 0 || saved_tcp_syncookie < 0)
>         goto out;
> 
> Maybe better code
> 
>     saved_tcp_fo = read_int_sysctl(TCP_FO_SYSCTL);
>     saved_tcp_syncookie = read_int_sysctl(TCP_SYNCOOKIE_SYSCTL);
>     if (saved_tcp_fo < 0 || saved_tcp_syncookie < 0)
Thanks for the report.  I will post a fix.
