Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D937F2B9E62
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 00:37:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726504AbgKSXcN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 18:32:13 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:53548 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725890AbgKSXcN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 18:32:13 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AJNQN2l006103;
        Thu, 19 Nov 2020 15:31:54 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=3+OTaXk70jTD2A91N+tLzEAfFhoiQOCQzygMd8PWFYo=;
 b=aWFDqQlZe70pDjDp9Jr8SvvGB3W13/vvyK6c9bwQfvUXPYlCUI2wTQB9WQaAsICvCxqB
 +PRXtzMS0tbxrDQXJsu55niyjbZadfATLNsZ6hteq3seVr1T2eIHzeYnKTI+8QYxcdIC
 bpHbwj58TnJa0OHwI9XFRWbPwFBTgphgmqA= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 34wx1shqc5-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 19 Nov 2020 15:31:54 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 19 Nov 2020 15:31:52 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rtywz7aAeiHMhcHhPx1qOoY+slbp0NP1eVXzyXnJvHO6EdCnlgkKrcmnY5TIkUelaf7W7SSW2qqxOKO9+S/cxjOPJS4jl70wCHUZ3xh/GtoKaMTKRtz20gdtX9vdWLgT2r4BL46dwZ9zV+AUYzTnRCpaG27gIWm6Rafwo9Soc3+8ZvGu+ttstWeBXKkjagAIx9NVuTO8Q5PFWpzhVUJHxbf06hMJ4hQbqjKGa5cJ0X9jYoMpEJ1XAnTFkBZaSnhUpPuu5R80wZ9Sl2eOELsfiVVvOutxXdP68MDWkgf+MRyTci+LJ8NHYujiKPDt45mzAytvdn97kTzLZjApRtcASQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3+OTaXk70jTD2A91N+tLzEAfFhoiQOCQzygMd8PWFYo=;
 b=AFv+FkddO6B+pyILvMtOies2wd9/WYDhYElnzxKOAcrdadKONJbScZbe+DncO4ykUiZ2g3LEMRmajh1ssmf2Ag7GIt9A3tWJrtjuunBndPxJ8uSPcbdNjKsRZ1EO4LefLfJAo57kcgGVtjnJqJlZZ0DwPHyh3WcDxXdCqhvz51GDQVYlvzw2aCbsP6bJFZUKmBnVQx7zTNUfrpx9pXfAcZ+K0ooguAjk6OOVmZ+c7FOt4scE+6uIIKDcmHQxge6/r3vVzO3CnQ1KAH5aJ82cMH4DYSgPlMYu967fqqoiWrGXLl03xYBe8QrxOWPALpfhWywptkfrf6+CSQgUfI341Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3+OTaXk70jTD2A91N+tLzEAfFhoiQOCQzygMd8PWFYo=;
 b=JIyjmdZ5PL1JlFO2zP1UdqeoCBYhpgfyphb0BZFmmmOoKY5b3y46tr8n67M4qBgrux/LdtRn+Id4kWm+dI6md8gZ5W0t7aWdB3n5UHQtqsCi3LviYiJNYf5xG4YxxYk+ZP5erh61xZbwZWuPldl6tJJOhXysSTyx1OAgiDqTYKg=
Authentication-Results: chromium.org; dkim=none (message not signed)
 header.d=none;chromium.org; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BY5PR15MB3668.namprd15.prod.outlook.com (2603:10b6:a03:1fb::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.22; Thu, 19 Nov
 2020 23:31:52 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::bc1d:484f:cb1f:78ee]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::bc1d:484f:cb1f:78ee%4]) with mapi id 15.20.3564.034; Thu, 19 Nov 2020
 23:31:52 +0000
Date:   Thu, 19 Nov 2020 15:31:44 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Florent Revest <revest@chromium.org>
CC:     <bpf@vger.kernel.org>, <viro@zeniv.linux.org.uk>,
        <davem@davemloft.net>, <kuba@kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <yhs@fb.com>, <andrii@kernel.org>,
        <kpsingh@chromium.org>, <revest@google.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 2/5] bpf: Add a bpf_sock_from_file helper
Message-ID: <20201119233127.pvaisojjos75tpo2@kafai-mbp.dhcp.thefacebook.com>
References: <20201119162654.2410685-1-revest@chromium.org>
 <20201119162654.2410685-2-revest@chromium.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201119162654.2410685-2-revest@chromium.org>
X-Originating-IP: [2620:10d:c090:400::5:603e]
X-ClientProxiedBy: MWHPR02CA0014.namprd02.prod.outlook.com
 (2603:10b6:300:4b::24) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:603e) by MWHPR02CA0014.namprd02.prod.outlook.com (2603:10b6:300:4b::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20 via Frontend Transport; Thu, 19 Nov 2020 23:31:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0bc868e0-db9d-4c2b-2d30-08d88ce34ad5
X-MS-TrafficTypeDiagnostic: BY5PR15MB3668:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR15MB366860330AA30CE298FA405AD5E00@BY5PR15MB3668.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Bp6GORzVFYieHxjUXGSvTogbEQAQmOhcKCpZvlXN40QFP89pzlCYzoFkw1p/O+FwqkNyuKq1F9VZaKA5t2Pn68WhEZIn09BrFnl2nQ3SDhD1J7vE9QbMUxE8vjkAa7uafQg8S2c3uPtIxuz4FwqFmW+5qMuGFtSHWjKhvtKAWX5i8ezsla9r6VuW3CjnQmb9lnInC49xrlOnrEl4T0TUyqqZ/smYrgNG7LPWE6cvpca2xtlXvOezkZOFKXsT9uLp4JlJBff+0EM2kkaDzWK/zNvZao9LcGAppq8JKYAW0ABBD0l+j9iS3vI9rbR1kbHNFG3OFsV0Gev5SbtWst/K7g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(376002)(396003)(39860400002)(366004)(1076003)(8676002)(7416002)(66556008)(7696005)(52116002)(6666004)(4326008)(55016002)(5660300002)(66476007)(66946007)(86362001)(2906002)(83380400001)(478600001)(8936002)(6916009)(316002)(9686003)(4744005)(16526019)(186003)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 8u+ZJQ+Df9PnSgyuHWjMaIb18w8KVsREJ3agcBgHmazC5VTQhF69hx1Ks0nGCibjvFwQkyWmFakdliG5/CxfVdbZB+6UqkV5w2p4SczClZZz1+XhAr0S8tUP62qkNE7uyZ3eNYvPDa9J7pnnnEK9FUvMCFvAqc2D31q26eIPrf9RnMaMMI6z4+HmlNV93hXFV9n3w37O8kOCq5GfpnvrxaWl2K0kDFJI0f7QQYNcY9DgyqNMMVKqmPUlBuHcA+56fNn5HbckqAknIFJNCvG0Q+AEsJ0N0McSEz9iKxAfAcoEK9YLnAFMgZUAO/EJY6i/k86FvePwTu7Q1pyWHhaqg04WT7lqcGIovZb3GemEHJR69zhh48lZ8/QaAU+1418RoMyFJ7uvRdwm7l2nuhrUMdcGeTDIZG0+IVbB8sDC7jWe3e1l3EUse6Dl2VmO+X1Z3DjelIK2+/J5J3K+me8I7JK/kxTRVZT+EWK9Cx6s2f+x2m9AdKYCZK5qhugIiPR/u0jSuETZ4iIN3WeKm+gQZoEeAc11GjD6s8xBMKNKVO6P0dgXULWHr1BnvwDg6shJUZFPiWwIlYKwLzlGkYsRL4wOIuvOmS+S4sHETMGpMikFTiYjFm745s5E2CnknGGh4KJByqbA7Mue4Yd/Mx54ssVwmXDsVszb+ufhtTy44qkg8x27GpIwGP9QodWzfDCxYI2QgpAggxkiNNrIvfRU63ZYxpl2bwy6pOECl2aMbAVzbXMO7LbMCuMFoV6/xJKLs1LskfxVYKynKM+YBsNxtlXiWw35aztNNCRIG6XfXvOwcMKgChoU4j/40z75v00AU1bDGusoMERAoC1pueMqHNoPNO5VMLYPdtKoDzS4gQhsTmOIfbzjgB0D7tnFamxJGzc6yptyKwpNHG/ESn6CsBpqAXP41MRkLu2XkKH0KGI=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0bc868e0-db9d-4c2b-2d30-08d88ce34ad5
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2020 23:31:51.9321
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SmtjJ6tMqB2XbmfPhyniT/zxeHiPI95F97T1wjpfiV8BNuruaLTYlRys+FO7dWm4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3668
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-19_14:2020-11-19,2020-11-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 priorityscore=1501 mlxlogscore=581 spamscore=0 impostorscore=0 mlxscore=0
 suspectscore=1 malwarescore=0 adultscore=0 clxscore=1011 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011190161
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 19, 2020 at 05:26:51PM +0100, Florent Revest wrote:
> From: Florent Revest <revest@google.com>
> 
> While eBPF programs can check whether a file is a socket by file->f_op
> == &socket_file_ops, they cannot convert the void private_data pointer
> to a struct socket BTF pointer. In order to do this a new helper
> wrapping sock_from_file is added.
> 
> This is useful to tracing programs but also other program types
> inheriting this set of helpers such as iterators or LSM programs.
Acked-by: Martin KaFai Lau <kafai@fb.com>
