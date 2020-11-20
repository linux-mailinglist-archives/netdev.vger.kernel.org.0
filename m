Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E6DB2BB8B3
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 23:13:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728377AbgKTWL3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 17:11:29 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:28076 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727838AbgKTWL2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 17:11:28 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AKLonWJ019406;
        Fri, 20 Nov 2020 14:11:14 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=Di/C6xqDixZw1558CZ30jQJvyuMrCLX+VUdjoU/Bma4=;
 b=KdfNqK1K1+EQJCHViGgaJmQJTAVkfl14x8h4V8DuEQh+v5t6laAQBZ6hsV3ENaIGnc+k
 5dK2b42B4zIhNmPr06k/MtPkCjPT8yQVcLlprWInqfezgMb/ZgyEq+xlYmwb0oL1pTAL
 pbBRAFzD+csnYMOCsGQDjKzLBsULhNTFi/A= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 34x5r8db2c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 20 Nov 2020 14:11:14 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 20 Nov 2020 14:11:12 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lrb9hdMC3hxX6wY4am//bZU5ESUSXwhmLBbTf+88esh7qTPrAEMO6Adnn8bHMlJTXjAKDvtRq0iQHy/sH57hkBtm1c1vheEzxxebkB4akAqKDocL6ZCft9RUoPn3KCpTVxlXnqkL9o64WyAYZIXEkG9uk0OqIPQxdjPtwr2NSMO4xd9Yqs2X9DM3IIYGI1I62x/GiXPiCa+KY4zBYhPU6nTe8SU+SflxVNKQ2ZR/GO2QxnXhTfUT4A0grE8eRw6hmFylRe09MzEgqxLAWaW/bFv1JBa9TUSoqCRRVtQ9SfG6cKNtQLJtv5DoFJpJgS3rsyu9WZKOVzzR72Df8Rpb1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Di/C6xqDixZw1558CZ30jQJvyuMrCLX+VUdjoU/Bma4=;
 b=KNeQDRfM8fLvsM0GuwTQqPt9hAbM1ibO5VUdKkyD6dJfJX0Nes/H9SDUb/hAkaAjfvdPYBPpuSA3K+fyxzO+UvJAJN2tFSXTT5tl3GvJOdkOU4UUMFo65u08cH2CZWkGQC89voiBGV8m2OqFVUeSoqNsCLiiDNyJAt8lgjbPPVQCg6mP+qCdRdY44+jN00ozxkSfUzAquu25yUHwn29Og66osM62sDu1/QlPZLe26Sv5pWToij65EhYTdomW6fA21aHWLxIsdlSUJZ+Pl8aOAnYwYtX4FWzyf/8DWRDuJTJV6V4Ke/RAqJ+gqDoMXrOEJSxvSgT2adScA/4NXHQKtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Di/C6xqDixZw1558CZ30jQJvyuMrCLX+VUdjoU/Bma4=;
 b=ZxN429QasH2BGAUrsEJOkFb2TzqD8vHxUB+1lQrEpvWJeoWFRzDV33HeKDIYBC4bxNnMtwxhgYVFyct+Au12axwX2yk7e30dqyMz5Jp3wTQon3Ds3dhiChnMZ0qBw19ugy2HjwTa8iKE9PRmmAibMLrAT6S7KqpYa2xMzKeE9/g=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.28; Fri, 20 Nov
 2020 22:11:11 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::bc1d:484f:cb1f:78ee]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::bc1d:484f:cb1f:78ee%4]) with mapi id 15.20.3564.034; Fri, 20 Nov 2020
 22:11:10 +0000
Date:   Fri, 20 Nov 2020 14:11:03 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Andrii Nakryiko <andrii@kernel.org>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 3/6] libbpf: refactor CO-RE relocs to not assume
 a single BTF object
Message-ID: <20201120221055.cjnb67kfsuaqhv4x@kafai-mbp.dhcp.thefacebook.com>
References: <20201119232244.2776720-1-andrii@kernel.org>
 <20201119232244.2776720-4-andrii@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201119232244.2776720-4-andrii@kernel.org>
X-Originating-IP: [2620:10d:c090:400::5:603e]
X-ClientProxiedBy: MW4PR03CA0220.namprd03.prod.outlook.com
 (2603:10b6:303:b9::15) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:603e) by MW4PR03CA0220.namprd03.prod.outlook.com (2603:10b6:303:b9::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20 via Frontend Transport; Fri, 20 Nov 2020 22:11:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4969f7c1-7859-4a49-a943-08d88da12f98
X-MS-TrafficTypeDiagnostic: BYAPR15MB4088:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB4088ACD82DF1BDAB40964044D5FF0@BYAPR15MB4088.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 85bjs9ASrw8HT4T5N5k+KQQY7fu5TMygLI8hbzrOppCYj99nalagaZUCIuY9tJvbATAgbSwg0bbIY6h2eGXtUgKKiLXPYhyVjkoeCDNv/ZkEzHuR9J5uhfl53YQjVNfZSspjU205qFhr3en302CY2FnHtK4WMNM6KDUOk3fXQQYMQj27iM2E73PGwpWhaTo2u5NXdDP95z3sPJ/C6kGy6vFV7OBER6vHA1qbzgsJTnccYBOrIcHO1mMJqs5TSyX0roDonUx1EQg9IMYnEMVEumihUvmzFwwsfR9vwkYDLWYSzAygWpM1nrHha97WBBmuaqDJD0ssK88x1eW/i6p44Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(136003)(39860400002)(366004)(396003)(316002)(7696005)(186003)(66946007)(16526019)(66476007)(6916009)(8936002)(66556008)(5660300002)(4326008)(4744005)(52116002)(6506007)(2906002)(478600001)(9686003)(86362001)(8676002)(6666004)(55016002)(1076003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: UJ8F2vupC2SbzW9Febi8lDds+m39CeZ+tEQJDH2Xoaql3DzmA4LvisG2b/Nd+XHwTs5PIpTmDgHzkQHqzT8RD9DRWTQagPi9cvkBecnqzAbvDmE0zDxTEpNBAy5T1G4qm3uviNIA4tu5+fQsqjQfwH4UiFRqvZDEE5n6DxsKHCikPjLBJSmURFpV07S2+HnSkz8o24yW2aVvDlAqkLIDVolem6+y30ZryKtvi11XG49a81k0Ls3CSbZg1uFISMMfqo0fsGXoi+MtTbkBJ3ZQia1so1ZmJ5Xld47VgrCVD/YCoq8csmejHSCfjFJAsoG+uHIsoYIq7c16B2iphIDBq9FOOOlQ5ohWsksB2LmI1pKkbZtey7xp39kJm5rCTBM3lAul4ianjXaJSPfbNVC77EJC76jP1/WauWt1ZQDqWy8ovmoLo5PgI4LZk3GkU7ajpgH2Xd5TxiWU/brcXOynPv0iYREmSdZ5Sr1rAe75IuJOvtafSj7vNmcWuUeOdMZNj261SrKC9jPckb7Op8Z9+UBNhLGwpvivyuNO0uTmMleD614INDFOc3Sv19A+tX/MWJ9BqCtlO/0Wm1MMiJIfdTPW0oleJ+2h9SXU7o86yQoLkW+1LTSzvglJLYM06LoBzlAqI9RJ96jfW6XJV56QwwqUMrmzawGWtdx2D+iIIemzBa3JOuAunvIp0pySQvxVowAYkkb10A6LYBc9k9m7cnXY4Qzdu9OHASNByO8A0zqOSSwmrto8R8F+M7E9/aS9gk8IaZppU+iXVNNfn63lDnaUSElBvTTkGHGSqCipYB1PBKtkMH33UGC+btjUrp5QQMi24fTHoklrWQDr49Wh5Z7+LJDEBpy5EZyJdauY2h+R3bRHg0iQ1dgWiZ5jcwpapARc5HujIAKyIvcHlGU/dQCUBfVwcnnu99bc6YL0cuUDbg7RLz9EtYcS6hECVu47
X-MS-Exchange-CrossTenant-Network-Message-Id: 4969f7c1-7859-4a49-a943-08d88da12f98
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2020 22:11:10.3468
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 223hcfE5h2cB0Gd06wdWxdZXT9LY38mke5wKj28hHSuEWlX31TENjpELXvECIWL9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB4088
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-20_16:2020-11-20,2020-11-20 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=582
 malwarescore=0 clxscore=1015 bulkscore=0 priorityscore=1501
 impostorscore=0 spamscore=0 lowpriorityscore=0 suspectscore=1 mlxscore=0
 adultscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011200144
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 19, 2020 at 03:22:41PM -0800, Andrii Nakryiko wrote:
> Refactor CO-RE relocation candidate search to not expect a single BTF, rather
> return all candidate types with their corresponding BTF objects. This will
> allow to extend CO-RE relocations to accommodate kernel module BTFs.
Acked-by: Martin KaFai Lau <kafai@fb.com>
