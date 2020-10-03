Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A425528218D
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 07:20:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725763AbgJCFUi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Oct 2020 01:20:38 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:17596 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725446AbgJCFUi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Oct 2020 01:20:38 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 0935G3Y8023189;
        Fri, 2 Oct 2020 22:20:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : references
 : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=EqBZ2NKzU3fKN70lrcFi4mjvCh4MEQZv8tvEjWQBiig=;
 b=loVNz4FndObb3N9NmYYwsZq/EH0ZQp4Hwj54ODnUsCGwPeHbIeFIDDPLkEPJyj6nBuep
 DCCI6gtlPjiOB/a7XPPFh31utflm2xo3W7DG9nDE3S8ynvRhrH7Ze7pSVQoMClF9wS66
 ZnGalKpZQCwANvyQnxl2OK0dNMKT0b7ldZQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 33w05ne410-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 02 Oct 2020 22:20:34 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 2 Oct 2020 22:20:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NEiCZUMsdDOxcSns4hhGCxiHYUixSX63DA24guXol6FUt5/CeOmL4hycK451FTKIGJydDFXsIuoiu9mHs2j0rfCVqwM5BnSXdqlJ0XGyrxfKaUSObakJDVOkRJT1kf8QhRQHcBUlB9whXik+CLlLTSRnlgOyi6ibG4Nc5dSZ0O02nAnu4NLNURSqKgQI+gLg3JWw30PNpby1xvMUq1EwVzSVnTyUgjd9v6xWsZ8ExYGkcE4byO5FtbYz9m/2B0GHzX1JEhWX8Lf2JQh5c4JCC5D6V9Tv4zGXAUUEqCNt9I/NUh4JQNhDrUdj58Suh9Z36R07BUH3/LvSVUer6Psiug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EqBZ2NKzU3fKN70lrcFi4mjvCh4MEQZv8tvEjWQBiig=;
 b=R/rU4POYsqZnFrPnUZBI9HVo1IX/0GbVjz5U3I9gX8VUMC9iWX4R672ohd2Gz8w9jJDeWr6IPYRHeNmYYkt3xHyoLvCP2SQYFB8MBCjTf/xRSjNw8Y2+7qayOkvid/VBcrAXtMTbTTxnMARAHLDL7ehCxVfMzD8Fj0CoXiyRb3SIzBtZyenmoorW7czaxc9XfKpaE0zl/ri60+ZgKhQdHVeD0HFBuB/xfCBVQgUeF49xrI5UHg/WeC3GztOhTgNhU3EXiGTlIjTgbsDyXvpcxeScxzsOFXBv3QpVuIJMEPE4SmToVJtBMg1M8fJh5WSYJf7W9Eo85uotMJgUkjGvig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EqBZ2NKzU3fKN70lrcFi4mjvCh4MEQZv8tvEjWQBiig=;
 b=NKjs4hpiFSKadb3qLjILGbmLgaCnwoEHAl9V1+raYlVR7eFCN2nUYGsF1tleBdoQ/ttwszVSJY0vrApSTUrRYBsdcxZccVy1uWEA3JWG3DLZCQMDYsIu6C1e8hPFWrzb29bB3L0PmJOV4EWTMt3ofP1zX+QqR6St8AELKqNOEFc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2727.namprd15.prod.outlook.com (2603:10b6:a03:15b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.25; Sat, 3 Oct
 2020 05:20:18 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8887:dd68:f497:ea42]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8887:dd68:f497:ea42%3]) with mapi id 15.20.3433.039; Sat, 3 Oct 2020
 05:20:18 +0000
Subject: Re: [PATCH bpf-next 2/3] samples: bpf: count syscalls in xdpsock
To:     Ciara Loftus <ciara.loftus@intel.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>
References: <20201002133612.31536-1-ciara.loftus@intel.com>
 <20201002133612.31536-2-ciara.loftus@intel.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <2291a6f7-a39f-cc97-5548-9a8029a1f36a@fb.com>
Date:   Fri, 2 Oct 2020 22:20:15 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
In-Reply-To: <20201002133612.31536-2-ciara.loftus@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:a7b6]
X-ClientProxiedBy: MWHPR22CA0060.namprd22.prod.outlook.com
 (2603:10b6:300:12a::22) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e8::1836] (2620:10d:c090:400::5:a7b6) by MWHPR22CA0060.namprd22.prod.outlook.com (2603:10b6:300:12a::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.14 via Frontend Transport; Sat, 3 Oct 2020 05:20:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e9e80ed0-e5b0-45cc-6e71-08d8675c0458
X-MS-TrafficTypeDiagnostic: BYAPR15MB2727:
X-Microsoft-Antispam-PRVS: <BYAPR15MB27271FF8FB4A38FAE01EA6C8D30E0@BYAPR15MB2727.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1Yjj7EL9ifRowOkrbb4a0G9ldpsaKgdtcmKLW3D0DawI4saxb/wqGrWqQBtiBd96Z+EW6GxLKtWZsTr+ydpuwTQ4KvSonuLJXxGiopfgArufBUh1/Fs7zLk0C2c5dkaWNxEGPr3X9VtAwlAYnvjiC//TwEqlvbcAmu5o250z+mmfZ/3FWbuD9uaz3+Pxnjm2NFKdyyqIkG/wMDMpf1dBMFSCRVkebJ9vNcMolxYhzNHj7Ol8Gjh/H+Lgq1hO+gMfkAGCVEA6rn1pOX7cAnQqIh3RhUKC+LIFlaOTs5aDdBQl7XCZ0m7RGkpX4+GKUsY0fraEEjJF/LViJtN0HJlAe6STe7ZuV4AlgNkDJpOBr/SWuW1o8UzaBgHEZXlGrmjC1C+MvlsIROQ4qx7v33M76nyZ6AkyZJhWVSxlCKuV8AVsgYCVyIoU8PS0CwMLQoKM
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(396003)(39860400002)(376002)(366004)(4744005)(31696002)(66946007)(86362001)(5660300002)(478600001)(66476007)(8676002)(186003)(8936002)(16526019)(316002)(66556008)(36756003)(53546011)(2906002)(52116002)(31686004)(2616005)(6486002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: VZb6YPQtSFjlzBWHwQiIbukNHg/AW5tDdPMZfCcJVww+RDPZ66laaOGLzayb2T94dQHxqhu5leuhb81cmvGjucZ3IVsGrjg8fHNMfZFkB5RJ9tFKEpEJI8eHXV+wRSc4cyCsScxqupXZ0Ce4E4Vmhm19+QzgNrs9QVuIAh1igjL6OTd2OG/VL4jSwdr6rEsgiFeFjeItI9wI90n6JVK5/Q4rOQ8QUY9gVfzBLL37EatGJgLDxhyo9nj7X4BfO7rMfEV4HnaR3WzaSUgnpdZgzVftsYpWlqSM8Bqa3cBCtrG3UiP4VaH4lmD2qOOm7BT71EswtMRPAB8fnO2og8v2CQQzWR83HnA2cp3M3jKbniWLiQvxkkv9Zuya/EEmNcb+eXm2mE5bBHTJHA2JkewlXXJAiY3UGUz8tyJwhVPd5Sp06TeZj1DZJWxk8Ss/lKu9RSqgDZ0Pvnejz3Rw5XCRk6tiNBlDyU6INw6Cvk/PbgL7ZVnG++XSZCYGV5QXzMmA9RQzjZfwAUGYYWr8yqcQ9ZkkatMDq0IoLyPT9n013s9NoLhP2tgHtVsPUxZMqX6YK2YvQ17qiy0S2JlnWkDriwCbUbiCGr6B0Wjj3Vmmn4dAsLLjTJAiW91GPYweMPSx4H8yKhkfVpya1EXwYQgd5a3dViqBzdq7vkuuOgyirJ0=
X-MS-Exchange-CrossTenant-Network-Message-Id: e9e80ed0-e5b0-45cc-6e71-08d8675c0458
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2020 05:20:18.2370
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GX4QJvw1nseVNHzuf2hhXYXOCI28rNSRGW3DO4U33uSd/zi3bHls8FWYeIiK+5ff
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2727
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-03_01:2020-10-02,2020-10-03 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 priorityscore=1501 mlxlogscore=725 impostorscore=0 spamscore=0 bulkscore=0
 lowpriorityscore=0 clxscore=1015 mlxscore=0 malwarescore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010030044
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/2/20 6:36 AM, Ciara Loftus wrote:
> Categorise and record syscalls issued in the xdpsock sample app. The
> categories recorded are:
> 
>    rx_empty_polls:    polls when the rx ring is empty
>    fill_fail_polls:   polls when failed to get addr from fill ring
>    copy_tx_sendtos:   sendtos issued for tx when copy mode enabled
>    tx_wakeup_sendtos: sendtos issued when tx ring needs waking up
>    opt_polls:         polls issued since the '-p' flag is set
> 
> Print the stats using '-a' on the xdpsock command line.
> 
> Signed-off-by: Ciara Loftus <ciara.loftus@intel.com>

I am not a xdp expert and cannot really judge whether such additional
stats will be useful or not. Beyond that the patch looks good to me.

Acked-by: Yonghong Song <yhs@fb.com>
