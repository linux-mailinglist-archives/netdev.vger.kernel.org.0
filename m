Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B4B91CE594
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 22:32:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731652AbgEKUce (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 16:32:34 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:51810 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729517AbgEKUce (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 16:32:34 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04BKVEkt007501;
        Mon, 11 May 2020 13:32:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=bx4LY6G6nJlkmqstEEk1mLsJHjOTD1FXyyrTYaxmjq0=;
 b=WQzNszmncK7X86QMNqe5V/8WZ4GTEdXFSfL1vZYI4fLVifJ9RwRHps8IjofaYExiRECK
 6fl7pPo9sKgofzu44DuOXTieGzYha+f5CMIm4zlFCPamxaFthBmx0oEyJ3DLgul0Nnap
 LEi/verU/Bkf0nn2zbm4XmYMyB7K8kWGK60= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 30xc7e08x6-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 11 May 2020 13:32:22 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Mon, 11 May 2020 13:32:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nPZYHIKC0yP0t4EAKohAfYhNOxIl6pNSZsticwgLZfzLevtkZwHYQcObtmPWXmBDAm9SapCCnVPB7PxEHWphpnUcohEerURoV2c3jWclO5QTMnL4YlbBnDU+KQEWhL+2VQ3+uZuNgcJJ9THfzOzVc/WOcu9a6onYr0OXYjB3Sy/Usk9AAc9fN3bvNK6bdwI6jH5POE181lWHK/62N2o5gjPKdkUB0uH5ZNK26r8JQjNJ5o/HY/K7S9hQzx0nCGwIYqfczs32QDT/Luv7/VMpW1omPsvLyxGEMoYkVripeMhDayQHsD4und5hvRoHv/HQyUGPRYMyeBNXnJHkB9aR8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bx4LY6G6nJlkmqstEEk1mLsJHjOTD1FXyyrTYaxmjq0=;
 b=GNJcOI1i4wwownTWG41mhk0TnOHFJB1iyX+3MdcmOU5L5F1MazZBdYQ1uS5dJQO2s0TAblVafj09e1NvadCY/updA31h4CO/Vq7Qw0v6DrTHxdh8aaYDby4lLkIbXYQE2iIHU/Y/UbpIXeNJLDq+KiDUoZtArafDUUQ4d4aWM4aRqaoTf1Se9VJh1EdTTDJtxUzCsd4E2/8R6UcX7tAgC/vldnV/SJHN5owrsOiIxSAXLwrw4LR1hPaxe2eBgV1QHZfj6jm+TyrA0HWEY/sWAM2okly/weOrXSi+oTelzjWXX9mRpceWSeeMdGi+sA6Xdlg+tKrAIaFyixWAOxo3ZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bx4LY6G6nJlkmqstEEk1mLsJHjOTD1FXyyrTYaxmjq0=;
 b=Vcg2xovu47aPM88RvrSywGjFxbuEIiA7MqaBZUo8YkCXbec24N5A339y5PGpVq9ZwcxbF32EgrcmMgRfZvLs5idinrTXPqiNZsR4GjEQSVIYXrpJ4d7x9HaYLGD29Z/pJcow82hUog0tfYhxZ42n8NbWTI+sk8YI+EPA2lhIBVY=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2760.namprd15.prod.outlook.com (2603:10b6:a03:159::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.34; Mon, 11 May
 2020 20:32:20 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301%7]) with mapi id 15.20.2979.033; Mon, 11 May 2020
 20:32:20 +0000
Subject: Re: [PATCH bpf] samples: bpf: fix build error
To:     Matteo Croce <mcroce@redhat.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Joe Stringer <joe@ovn.org>, Jakub Kicinski <kuba@kernel.org>
References: <20200511113234.80722-1-mcroce@redhat.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <0dd7c40b-c80b-9149-f022-d8113b77558a@fb.com>
Date:   Mon, 11 May 2020 13:32:05 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
In-Reply-To: <20200511113234.80722-1-mcroce@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR10CA0024.namprd10.prod.outlook.com
 (2603:10b6:a03:255::29) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from macbook-pro-52.local.dhcp.thefacebook.com (2620:10d:c090:400::5:3585) by BY3PR10CA0024.namprd10.prod.outlook.com (2603:10b6:a03:255::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.28 via Frontend Transport; Mon, 11 May 2020 20:32:19 +0000
X-Originating-IP: [2620:10d:c090:400::5:3585]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: af8a0372-f898-4b95-ec5b-08d7f5ea6713
X-MS-TrafficTypeDiagnostic: BYAPR15MB2760:
X-Microsoft-Antispam-PRVS: <BYAPR15MB2760E1BF200D5830E77540A3D3A10@BYAPR15MB2760.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:293;
X-Forefront-PRVS: 04004D94E2
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fOGwj1I+ISGl9P+PtWPlYZtlm+UX0P8NtFpqEfywZLUiV2LatwPJIl9Evhhh0bTj2uH5APz7CqQlaljeyJLNs2KVnoqN3lYGW9Ry76RB11/gF861eyn4ZtLrnl8WMBvIlupzPTm0Injz5vws8RtNM6EMpGIpLv43YwTCOvlVgr/FD6NwrQfDPtxiJyBr25Y8/JURkTfjfdwEFk+i1qe1M3BzYP+HdTnJ6jeWN09+1Wl75UO2rBY95RfujztvvTlxOqHS7yT22+Un5ytHsva8cU3D2OCM6lew6u9QfGEM9Zun+2udJCchddLSISNoMPj1BZZe7dfCyuAFFWalJvBAkKE1/SNWEkNQGyjYN+LFMpR/F9/LVGGFWkkHo+u+/yparikn2WPWHjFekpecbDKkR6uX52oE2WEFwIMikChyX1ePChi8s4ob87S5upBU6qz0Cju3DZl01ybgSey7It6D9MPoQAY+ZrARukiKnHsHoBpVsiBuPHIo+V1DuXjB4i1oI7Us1q5AAcAyeTupjnm+3sM+tcL9iFBhehiIf5Z1utl/VK4BBn10W2SWOZe3hfiX
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(376002)(346002)(39860400002)(396003)(366004)(136003)(33430700001)(4326008)(31686004)(2616005)(4744005)(66946007)(86362001)(66556008)(2906002)(6666004)(31696002)(478600001)(6486002)(66476007)(8676002)(6512007)(8936002)(186003)(316002)(5660300002)(53546011)(54906003)(33440700001)(6506007)(52116002)(36756003)(16526019)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: FoPrCzB6PtDLfBAjWj68f9+ODydIqzms9/AcPPr+TMtu07TXtujU1BZHFTHj6sAPE0sqEUufbPvHwVVLk9ny3jvfNrfuOwtQnt4FwtP4l8dWxsW9NK8n39JODoKYLxD6gECCqBOHiO12B7Oyi/Kx8N0DIa2I31eBR+2p0usv3eBogi/h646aSxJ7+EdPY1T2hHgVXynDXww42MtoU6u4S/3K2gAv0K7ko8R9QC3vqS+dY5qB7IKtapKuTTPYnB8G31Knzli7FuccuaGz78zvrTGOivwzLb5GH8KPtlAceJwHB07ZouhTos7IM/GnvzxDGxs9m2UPFjXS6Gu2QNJe3j8UckVnsO5qBiDD88KJHjNsrPM8oM5pN41CFxWE0MYb6jx2Ii9xDYS9tpFc8Mz0sZel9nCi3X9SmafniMDDxpC9p7XnP43+7KQN0UTVO9XVfk24TIGL3fUJgvnZS0t3m1kQcZmiNRhDGEBflVuNxBmCsAzuGZLZnu3gTOUYVqNa0ai89yWCQJ99gTaCBpRqjg==
X-MS-Exchange-CrossTenant-Network-Message-Id: af8a0372-f898-4b95-ec5b-08d7f5ea6713
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2020 20:32:19.9154
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QQOvorZmp8HlDlG9ag3Ho3GGZuQ/UPIZOIZT5Nx//gmbooVottPGT08h0tHZnNvy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2760
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-11_10:2020-05-11,2020-05-11 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1011
 mlxlogscore=825 priorityscore=1501 lowpriorityscore=0 suspectscore=0
 adultscore=0 impostorscore=0 malwarescore=0 bulkscore=0 spamscore=0
 mlxscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005110156
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/11/20 4:32 AM, Matteo Croce wrote:
> GCC 10 is very strict about symbol clash, and lwt_len_hist_user contains
> a symbol which clashes with libbpf:
> 
> /usr/bin/ld: samples/bpf/lwt_len_hist_user.o:(.bss+0x0): multiple definition of `bpf_log_buf'; samples/bpf/bpf_load.o:(.bss+0x8c0): first defined here
> collect2: error: ld returned 1 exit status
> 
> bpf_log_buf here seems to be a leftover, so removing it.
> 
> Signed-off-by: Matteo Croce <mcroce@redhat.com>

Acked-by: Yonghong Song <yhs@fb.com>
