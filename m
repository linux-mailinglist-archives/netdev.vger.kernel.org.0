Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1686176093
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 17:58:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727209AbgCBQ6s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 11:58:48 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:20636 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727111AbgCBQ6s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 11:58:48 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 022Gtfaw022570;
        Mon, 2 Mar 2020 08:58:35 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=facebook;
 bh=J+1t0EuxVXPgw115HNREkX+xQPtLFwPG1rE6B8X0+Vs=;
 b=biT6xy6EPa88fKQxVO7dTd1uPB1hXI0w/6VBaFLCsFID7gXgxxL/4lD8hlux4e4MyGha
 vrTnA01SuVslfpG13i6Nh4XBTFGwgZT8GvRQlsd2NuDnfVuo89E0JGhMX6D7LBLKpKCk
 sJ7//8DSPWp1/S11IeXgrclQMKGNkDgapbY= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2yfpnqrkrp-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 02 Mar 2020 08:58:35 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Mon, 2 Mar 2020 08:58:34 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GP2UakKLd/bG50mcj4LzkHQ+tsgaIAgGE8+yjhr4H3tJ88vo2p8DDVXj701bpj+dY/YJWDR43AUpYnjCpKO8iYDAotje72HPiotr1Sw2RhJcF1xl24y/UZwzDZLfnz1jMNob2DRAC2t7HcE713MieKF0mqoIFzZB++lsOyIx44F12Mh4xDdtX2zAWaz+GK8v21tuJSlOkVqhCorbXtGSrNHiChAyihteVDK+S+s0fydcihv1Cf4dPf/XqQ3DdcMC/akdloG1JpOFtL+kiDFr58xia+dg7pz+bTlfGRcz5Y/qbjTk3iipQHRzDp/B5a6aARYsUq6kCSybd4oSw9beDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J+1t0EuxVXPgw115HNREkX+xQPtLFwPG1rE6B8X0+Vs=;
 b=lmeQItuWASfwkmuAbXCRupvHuPQWJ2Lki6ZJykAqFOT48Sst1kiut9w+HrW5Ioj8e69Z50WUZH4a1fPfHF8cYlvKBTu65/Xgf1Nku8WDBKCPGz+/pYoXfYvYyH7ydTbm5gQg/6Cx4IEGSOczfN3lc/OqPNhjX8x38lovLM8RfBblTuNo1e9ktDjGaw3utcIKKN/HcUWiWABlAoohNWi+4oKji7gzhk4XCmF7U2KqWPHW2WOhQVA8DGa9U0PnU2GkgStilYcBx7vsQRXWIEnIovj5oibFG3pVZDUcPm2DJ5YhybiuNGk1N1tHa5x75uuctnhPhvnyQVbNv7+ERxP67Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J+1t0EuxVXPgw115HNREkX+xQPtLFwPG1rE6B8X0+Vs=;
 b=djkxNxQC56gT9YjjXN6BJMfUsoNrMUJPtKI681w/Vb6SNRHAufE2wDq/+jDjdlwTb3WLEoEA1LL20S4lE5QNbTpXfwP3UYGuKSwc+KrBE4YZM6KxXbywPjn6sVgle1I7G2Xc9pB6MsLYjrpUVgRAst+pIVU6bW6s98+aO05EoGw=
Received: from MWHPR15MB1294.namprd15.prod.outlook.com (2603:10b6:320:25::22)
 by MWHPR15MB1407.namprd15.prod.outlook.com (2603:10b6:300:bf::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.15; Mon, 2 Mar
 2020 16:58:33 +0000
Received: from MWHPR15MB1294.namprd15.prod.outlook.com
 ([fe80::b47a:a4d2:b9dd:eb1e]) by MWHPR15MB1294.namprd15.prod.outlook.com
 ([fe80::b47a:a4d2:b9dd:eb1e%5]) with mapi id 15.20.2772.019; Mon, 2 Mar 2020
 16:58:33 +0000
Date:   Mon, 2 Mar 2020 08:58:31 -0800
From:   Andrey Ignatov <rdna@fb.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
CC:     <daniel@iogearbox.net>, <ast@fb.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf] selftests/bpf: Declare bpf_log_buf variables as
 static
Message-ID: <20200302165831.GA84713@rdna-mbp>
References: <20200302145348.559177-1-toke@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200302145348.559177-1-toke@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-ClientProxiedBy: MWHPR12CA0034.namprd12.prod.outlook.com
 (2603:10b6:301:2::20) To MWHPR15MB1294.namprd15.prod.outlook.com
 (2603:10b6:320:25::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2620:10d:c090:500::7:61d8) by MWHPR12CA0034.namprd12.prod.outlook.com (2603:10b6:301:2::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.16 via Frontend Transport; Mon, 2 Mar 2020 16:58:32 +0000
X-Originating-IP: [2620:10d:c090:500::7:61d8]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f0236b6b-cb71-4da5-e645-08d7becaf09f
X-MS-TrafficTypeDiagnostic: MWHPR15MB1407:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR15MB140715ECF6CF224608736AD1A8E70@MWHPR15MB1407.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:2512;
X-Forefront-PRVS: 033054F29A
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(7916004)(136003)(39860400002)(366004)(346002)(396003)(376002)(189003)(199004)(2906002)(9686003)(6916009)(81156014)(81166006)(186003)(33656002)(8936002)(52116002)(6486002)(33716001)(5660300002)(16526019)(6496006)(4326008)(66946007)(478600001)(66476007)(66556008)(316002)(8676002)(86362001)(1076003);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1407;H:MWHPR15MB1294.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3zUEtHsrQ/IQgVbZnemuibO8j4x2sZBaw+/Kw8leWj6oSlPV15Lg4DlvE7pRbMCzLJKnk9zWOjKge9s/fc5hkn9ilMBSZXQSv7XBRtVZIWbfCR8qp40h5+2AfwmvChgKiR0DUv+u01ZXQyL8dYS9GIWrN/6NRIM/9IR5Evz67e55dabMiCT3ZH+K6q9jC1UObXu/q98BaTotDSft43OpGSifqxmcnNqBzcE8uuQ8QxNdfFRiv6ocbZ5VpIST4UAWcwxrltlbvjkVJ93QyDrIRJky8laodAkYqFYqUJAN5ogcPT2xcQ8V7PK4vsbnH2K+oBsxSEqkYsDyl5JT+TJq4cGHAnyRuo8ZetoBi0HJZttYsTA0EUzAEOILRwZUO/VCKa0VID021qNXd7iiGLWvLZss0wR1dqBI51xbkglH+030q/+1XCdCLEil4sY0k5Ie
X-MS-Exchange-AntiSpam-MessageData: Olntz6AdRMh+gdPaSBhL8BKvkMOjaj7ufh4Mjh4rGkCuUEaCqPyUbo23LhTmGImmIQW/GEwZci3ikiDlEMDVfxk7b4zHM9u6svBNI+MXEQFR3jD7NavRZpZY/3TINHXxe9KWSILZ6pi6UIpjRCYOsB2uU4UvGr1EMVoQDBNV2pQW26xJ2hMtge9rlpO+AM24
X-MS-Exchange-CrossTenant-Network-Message-Id: f0236b6b-cb71-4da5-e645-08d7becaf09f
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2020 16:58:32.9085
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aSO248PErZ977j4Z7ECghRMGzQ8kXf48mV3Tu3rYqPoC96G5vMAZwNRFIwG74VTl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1407
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-02_06:2020-03-02,2020-03-02 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 clxscore=1015
 lowpriorityscore=0 priorityscore=1501 suspectscore=0 spamscore=0
 malwarescore=0 impostorscore=0 mlxlogscore=986 bulkscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003020115
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Toke Høiland-Jørgensen <toke@redhat.com> [Mon, 2020-03-02 06:54 -0800]:
> The cgroup selftests did not declare the bpf_log_buf variable as static, leading
> to a linker error with GCC 10 (which defaults to -fno-common). Fix this by
> adding the missing static declarations.
> 
> Fixes: 257c88559f36 ("selftests/bpf: Convert test_cgroup_attach to prog_tests")

Hi Toke,

Thanks for the fix.

My 257c88559f36 commit was just a split that simply moved this
bpf_log_buf from tools/testing/selftests/bpf/test_cgroup_attach.c to all
new three files as is among many other things. Before that it was moved
as is from samples/ in
ba0c0cc05dda ("selftests/bpf: convert test_cgrp2_attach2 example into kselftest")
and before that it was introduced in
d40fc181ebec ("samples/bpf: Make samples more libbpf-centric")

Though since these are new files I guess having just 257c88559f36 in the
tag should be fine(?) so:

Acked-by: Andrey Ignatov <rdna@fb.com>


> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
> ---
>  .../testing/selftests/bpf/prog_tests/cgroup_attach_autodetach.c | 2 +-
>  tools/testing/selftests/bpf/prog_tests/cgroup_attach_multi.c    | 2 +-
>  tools/testing/selftests/bpf/prog_tests/cgroup_attach_override.c | 2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/testing/selftests/bpf/prog_tests/cgroup_attach_autodetach.c b/tools/testing/selftests/bpf/prog_tests/cgroup_attach_autodetach.c
> index 5b13f2c6c402..70e94e783070 100644
> --- a/tools/testing/selftests/bpf/prog_tests/cgroup_attach_autodetach.c
> +++ b/tools/testing/selftests/bpf/prog_tests/cgroup_attach_autodetach.c
> @@ -6,7 +6,7 @@
>  
>  #define PING_CMD	"ping -q -c1 -w1 127.0.0.1 > /dev/null"
>  
> -char bpf_log_buf[BPF_LOG_BUF_SIZE];
> +static char bpf_log_buf[BPF_LOG_BUF_SIZE];
>  
>  static int prog_load(void)
>  {
> diff --git a/tools/testing/selftests/bpf/prog_tests/cgroup_attach_multi.c b/tools/testing/selftests/bpf/prog_tests/cgroup_attach_multi.c
> index 2ff21dbce179..139f8e82c7c6 100644
> --- a/tools/testing/selftests/bpf/prog_tests/cgroup_attach_multi.c
> +++ b/tools/testing/selftests/bpf/prog_tests/cgroup_attach_multi.c
> @@ -6,7 +6,7 @@
>  
>  #define PING_CMD	"ping -q -c1 -w1 127.0.0.1 > /dev/null"
>  
> -char bpf_log_buf[BPF_LOG_BUF_SIZE];
> +static char bpf_log_buf[BPF_LOG_BUF_SIZE];
>  
>  static int map_fd = -1;
>  
> diff --git a/tools/testing/selftests/bpf/prog_tests/cgroup_attach_override.c b/tools/testing/selftests/bpf/prog_tests/cgroup_attach_override.c
> index 9d8cb48b99de..9e96f8d87fea 100644
> --- a/tools/testing/selftests/bpf/prog_tests/cgroup_attach_override.c
> +++ b/tools/testing/selftests/bpf/prog_tests/cgroup_attach_override.c
> @@ -8,7 +8,7 @@
>  #define BAR		"/foo/bar/"
>  #define PING_CMD	"ping -q -c1 -w1 127.0.0.1 > /dev/null"
>  
> -char bpf_log_buf[BPF_LOG_BUF_SIZE];
> +static char bpf_log_buf[BPF_LOG_BUF_SIZE];
>  
>  static int prog_load(int verdict)
>  {
> -- 
> 2.25.1
> 

-- 
Andrey Ignatov
