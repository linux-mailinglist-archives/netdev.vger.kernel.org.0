Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BB681C699E
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 09:00:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728292AbgEFHAr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 03:00:47 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:62960 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728244AbgEFHAq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 03:00:46 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0466tPLd015817;
        Wed, 6 May 2020 00:00:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=LT0rTJD2S4X/isDir1xCmDnQSYlfWmK4+4zQPkJIeBQ=;
 b=pJ3C07w2n5B/3iCovl2qZazhEl5s4zjsHK0KGK5tso5J5WT8Tz5rv0fHjcUrYqeZlLtq
 ZnCJ4aZJFiRhIgSNZIf+5I3pnYXN+HPr+fMFwOCUfq8v8Gn8PKeqvi2XRS3/CBQc4s7o
 h5x9hedOqn/X1dH4dQ2MZDyO3a10yYN0qto= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 30srvq7kty-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 06 May 2020 00:00:30 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 6 May 2020 00:00:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VHoagIeOZ2MhR4Jovp5xSTD5yolYPZ9Jh9hTdJYmm9qU8o6ClmpBWIKW9eZbORLNxHGgq0w5YEfU/ei5i5qLIZyThS8/ttk0EVZaaNp/ryUnm9+Zu0mn8BQGIxyBqEDjaCVq0iY8TMu0f+LUWCMPnPQq7i+2eYSK2pKnq8GkJ3egbq2fi8OTLuJkEtc6kcTd0K/QTRjecmBJWOETS7tEbKRxhscitiL84dXSYGU0BOW1LDonpv52nZtD9uzYiTLhrp/RFVR0S7IpdWrqEQtsFUiK2l7nDD1nKn6NaiYD0kkFRTKRbEMIC3zM5FRnDCnFaourSpHw/T8obaVjWpAWsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LT0rTJD2S4X/isDir1xCmDnQSYlfWmK4+4zQPkJIeBQ=;
 b=Kd5s3uvmC4PM205p/brqohdvu1nZAjcmVFI24bNtkU6ycKajuwUkSlIDVR33PHRx8mjIYMt2GU+5Gy/Kj6CbYOy5alGVh9kTxMHAvnMzxWzt3cBNgKLsUuZhwaTh6nb79wWhjLPmBSp0qgTsXDDQLgjDZBpq3hZCqBiUbKvLOsrINgksljt4UF/EQnBatf5OMMasL/OeTeweS+9ZnXggfc49XDZhP1Dx/y+4fJKco0lob1Inh2MtmeGj+zlAS/JeDEONVLCGjAxNsWxQZQw3A93or3Zwv8IJK3m87T/clHN1BE0dypZ2WplwSGsZvFy4rrLABN19X340TKC+6Sn0kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LT0rTJD2S4X/isDir1xCmDnQSYlfWmK4+4zQPkJIeBQ=;
 b=DT4OdtCxnt76X6a2w6MOqisyFTzXntw2/MQlyHKrlAdVbwxiDXn9jJyU77f8Nte6vhFdGwF/++JRAjLc2xZUAFotM1frjEbrVtjReRYwaU2VSEsi4c5+YH++PzTd5e+5PblqPUvl6eVmlsjsrWdT95MKXdwOLsXdrEWZH06R9RM=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fb.com;
Received: from MW3PR15MB4044.namprd15.prod.outlook.com (2603:10b6:303:4b::24)
 by MW3PR15MB3900.namprd15.prod.outlook.com (2603:10b6:303:4f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.27; Wed, 6 May
 2020 07:00:28 +0000
Received: from MW3PR15MB4044.namprd15.prod.outlook.com
 ([fe80::e5c5:aeff:ca99:aae0]) by MW3PR15MB4044.namprd15.prod.outlook.com
 ([fe80::e5c5:aeff:ca99:aae0%4]) with mapi id 15.20.2958.030; Wed, 6 May 2020
 07:00:28 +0000
Date:   Wed, 6 May 2020 00:00:25 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <davem@davemloft.net>, <ast@kernel.org>, <daniel@iogearbox.net>,
        Andrey Ignatov <rdna@fb.com>
Subject: Re: [PATCH bpf-next v2 1/5] selftests/bpf: generalize helpers to
 control background listener
Message-ID: <20200506070025.kidlrs7ngtaue2nu@kafai-mbp>
References: <20200505202730.70489-1-sdf@google.com>
 <20200505202730.70489-2-sdf@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200505202730.70489-2-sdf@google.com>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: BYAPR06CA0018.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::31) To MW3PR15MB4044.namprd15.prod.outlook.com
 (2603:10b6:303:4b::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:2b23) by BYAPR06CA0018.namprd06.prod.outlook.com (2603:10b6:a03:d4::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.28 via Frontend Transport; Wed, 6 May 2020 07:00:27 +0000
X-Originating-IP: [2620:10d:c090:400::5:2b23]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5e6c913e-9eeb-44d2-e86e-08d7f18b2878
X-MS-TrafficTypeDiagnostic: MW3PR15MB3900:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MW3PR15MB390033B010D75DEBC0A67B3DD5A40@MW3PR15MB3900.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:972;
X-Forefront-PRVS: 03950F25EC
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZAun1x8gR92BHdhU0i8jJ9iR4aGdTAg7grgKbcJN+mUFuT1SyscXyjZDANkxXF6tnng+Tw0BNGgPpZco5K9dAkvmS+HayPRauCuouiBnwKWT7V2D2/ILSgi4ZfHM6pdAxLwzNAu4A9+6AhLvgEmTlgcFJrQ8WX9TLB+3KL3APbpqz3phATKX3VV26lSLCI1PNrKSKJqtoLLi/rhFPH6Ag8IP15RdDxtxKjKO+ZjguNL1aXzWZ+9G1o5wT3SASsmfj6LGokvPnGnBsKz807zSxjfDDS0G7utjVMED6/XLPeTNf0rkby8BBBKcAj2JyOYKzdf+lJbDra+v7qcXS+jqzOUzZkxsEwroc1gt+D1JdxbbsLxZCgQFgM31QOo/3RG0Z2TOt2/xPk69D87G+egvthAzLmDEa0zGLBHC+821y3eq8PRKrSS5AIK0j9HRRpF0ljogcJgCJTx0t2xEzq4wvyjpO5v9VAoKoBKUhdGoY/3TBKKrswhZOxS+EJU05Qd5ggllAkpFEVQbQ4n+UGujlg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR15MB4044.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(376002)(39860400002)(136003)(346002)(366004)(396003)(33430700001)(6916009)(86362001)(1076003)(4326008)(33440700001)(316002)(6496006)(2906002)(9686003)(52116002)(4744005)(33716001)(5660300002)(186003)(66476007)(55016002)(66946007)(16526019)(66556008)(8676002)(478600001)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: kOiaMaWqqB2xCjhkfs3YnIey4EJf++VOTmFLdPJLp7C6vbSsL72JC9V7lqnTRnepPxOwKhLyw5hCZyvQJ+jYjHJxKxIl7R7331trhHS/ibG1HK7zYh+iUoOF/Lmf37jMIbuBhk3DtymkA+w2rPdHHZRW60xctHZUcfsAgpJ3maHP44Fj5XWZipA2AXgvSIUcCzoOzx+kfA7JA/Fa/pTxP7ji8TCv9m8VAQrcXuEPnWXIBzFOugGHQ9p/KPNh5fVRWPtUmwT94weZ+leg1SUXbHT4Ke74gG/QW1fWkk8eoQBynG/jB+16OUSthoON7pLApL4+GY70G1Esd6sdWs4vlm0abZKWBUz0N5WpnXYWjgvHfy9lF2TxMr8mZH3C3f9zlNzkdtnS2BawVCSbGrWhH6rbcGtRVfydPjgQyeQ+cI2bI0WlSwSuV6OHueC3ssfhD0Z0DnPXpvprqFeY0iLrBiB1i40SnYE1LtTmMtOh5Uq7PRvAhy3I5RruSmvtgDtQf/FArFPxp+Z84DhhIH7oaYHdZJkh9qzD1x9olHe4gabz2IxAm4ik7eefQQRDbdeqS04ptqNNwhdAoKaZ4vlwaTyP9ue9HQkMZ9m0sywuEZpUOsiAEEk13+6OCbZERNcQBTRDM6mEj4rpeV4BhrdOz7aO+4Lh++loiUMDTsr9D4YQbsUhHflqxsFo4KF0o/qpWLfr6u92vy7XGY2Hp8gM11AbyshZ8WNAYWZavnW1ceOa68H/BNneBwHCu+UBZ/KZ83BTPa3ZKM1ptM9WDEj1vLibj/c9UvGWu/XAeWUFFyfRiYkYD5BUWxoZByaqRARqEM4Ytj96PDYFyOr/KP/YyQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e6c913e-9eeb-44d2-e86e-08d7f18b2878
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2020 07:00:28.2286
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vh5Je24GUZ0O45/EvcLKBl5e3/xDEmGtN/6Se7gv2DA51i/PZMKfgD1cdYomULiJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3900
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-06_02:2020-05-04,2020-05-06 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 adultscore=0
 spamscore=0 phishscore=0 mlxlogscore=669 bulkscore=0 clxscore=1015
 malwarescore=0 lowpriorityscore=0 priorityscore=1501 suspectscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005060052
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 05, 2020 at 01:27:26PM -0700, Stanislav Fomichev wrote:
> Move the following routines that let us start a background listener
> thread and connect to a server by fd to the test_prog:
> * start_server_thread - start background INADDR_ANY thread
> * stop_server_thread - stop the thread
> * connect_to_fd - connect to the server identified by fd
> 
> These will be used in the next commit.
The refactoring itself looks fine.

If I read it correctly, it is a simple connect() test.
I am not sure a thread is even needed.  accept() is also unnecessary.
Can all be done in one thread?
