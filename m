Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC7B9191622
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 17:20:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728624AbgCXQUb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 12:20:31 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:44120 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727444AbgCXQUb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 12:20:31 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02OGCPNh010844;
        Tue, 24 Mar 2020 09:20:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=aen/2FTYFOpp3rvFE/OB8BmIjjjVmfc0IMKoeaD5gQQ=;
 b=WIlKLYjMjr1anpveb12Y2yWei3B/Q7qSTlhJYJS7yqeKW/8NJOoAEPOGPQf/AiAur0j4
 EutAK2j0bhXMtcCBZP+FtrJ0c9vSL3MAOW1rExaBHzydQGDBC7vJW94TPUyjcsQzPVvU
 /bW/LeAwAikR6iSfhF9m02smZp47goWXkvQ= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2yx2r4uavx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 24 Mar 2020 09:20:14 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Tue, 24 Mar 2020 09:20:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CM4r1RNxfspVplFYoLWQ6StieIu8VKONqRA3yPtrwX+M8HHdNRKXn0CBCiBQGqxOdd99JKYrqoTzaJmrqERGxSHfTGJikBSl5YmtRhdMnblA2WrdRrzza4hTfu8Qgb7tEIyu6OTl9rLHPcVa6sQC3vtPvXq7Bddi7N+yvH0xZ5KULuYMqvZY3b9nWI99TWd0mCu9BhjnXec0gZWyA47kylnwT5TxWFo8ER5JZRCzeLqKEtqC/9ugExGBTpfPwiWneI4rTd2fupIcOXF6DFwpVa/uF7s/oORTJToa05EBQxAP5t8LEZMgC9Pc+WTDrofjbeVnM8Wrn965okz0E2Licw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aen/2FTYFOpp3rvFE/OB8BmIjjjVmfc0IMKoeaD5gQQ=;
 b=hjX6epugWzMKInGYF8u6VTuA16YXQaY+ZO4s4u8e62bqzzBluL56BxLFH1qIvo0SXi2+wHpm0HJwcxI1SpZFhOTEknkr6moSEpvNJh5mYbLZ3tmM3Q2oR/pSovu758PPr4tMkDgR23Cbx4TxqQFmMhBXreWB9FsunF9RJs5/MgJiMdrkulVswAbr6+5Wn5hFB+0W73sbcwNUJjNRMj5mpTcG/UXpU08SpkvsuZZRaD331N1dGFtY7xT0sCuOEzVE28jWyKkGT14JldvlRORlzx0TwNas0ArHARQm3SNyB7QqfMRk/H+9QIQvzuKFc6bBpV8AZTFkG5NFZPwXk42FcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aen/2FTYFOpp3rvFE/OB8BmIjjjVmfc0IMKoeaD5gQQ=;
 b=VDj7fRWZOAIs3fvJ/UK55EHvBjP6r50WXA0no55RGdoSBsrS1mhu7Hf3RmVb74os6TMfjbID6M6KzbgJU3AJgFMFBUNKJwAsrLSZ7HlR3z/21usnAKtUL3uR+ZizOpUFuZATQqJnANjmn2VmytMatMjaReBdyBUdoaE3LQAvsIE=
Received: from MW3PR15MB3883.namprd15.prod.outlook.com (2603:10b6:303:51::22)
 by MW3PR15MB4025.namprd15.prod.outlook.com (2603:10b6:303:46::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.22; Tue, 24 Mar
 2020 16:20:12 +0000
Received: from MW3PR15MB3883.namprd15.prod.outlook.com
 ([fe80::a49b:8546:912f:dd98]) by MW3PR15MB3883.namprd15.prod.outlook.com
 ([fe80::a49b:8546:912f:dd98%5]) with mapi id 15.20.2835.023; Tue, 24 Mar 2020
 16:20:12 +0000
Subject: Re: [PATCH v2] bpf: fix build warning - missing prototype
To:     Jean-Philippe Menil <jpmenil@gmail.com>
CC:     <kernel-janitors@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <7c27e51f-6a64-7374-b705-450cad42146c@fb.com>
 <20200324072231.5780-1-jpmenil@gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <993c9ee8-86b4-5aa0-ce96-ae0621f7ed22@fb.com>
Date:   Tue, 24 Mar 2020 09:19:54 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.6.0
In-Reply-To: <20200324072231.5780-1-jpmenil@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR1701CA0009.namprd17.prod.outlook.com
 (2603:10b6:301:14::19) To MW3PR15MB3883.namprd15.prod.outlook.com
 (2603:10b6:303:51::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from MacBook-Pro-52.local (2620:10d:c090:400::5:1af3) by MWHPR1701CA0009.namprd17.prod.outlook.com (2603:10b6:301:14::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.20 via Frontend Transport; Tue, 24 Mar 2020 16:20:10 +0000
X-Originating-IP: [2620:10d:c090:400::5:1af3]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dc7c9090-757a-445c-8d9b-08d7d00f3a5d
X-MS-TrafficTypeDiagnostic: MW3PR15MB4025:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MW3PR15MB4025967558BAC7084CA91509D3F10@MW3PR15MB4025.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:751;
X-Forefront-PRVS: 03524FBD26
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(136003)(396003)(366004)(376002)(346002)(39860400002)(2616005)(478600001)(31686004)(53546011)(66556008)(4326008)(316002)(54906003)(2906002)(4744005)(86362001)(6916009)(5660300002)(16526019)(6506007)(52116002)(6512007)(8936002)(66946007)(66476007)(31696002)(186003)(81156014)(81166006)(8676002)(6666004)(36756003)(6486002);DIR:OUT;SFP:1102;SCL:1;SRVR:MW3PR15MB4025;H:MW3PR15MB3883.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7Nr1lbrS8vzJBA5MoKFIJE16HrCXO6jm6jqLKBtRKXn11hZQCwSYst46q7LmCyeBHvMatFQEt/WZfhuxIa+hRpcXvyXzfnNloQ82XVxdGq9VMnRQYxXUcle0GgYQiXbc7PBvcul3dRdJ0g8r49FSBMGXbfRPRW49KQZ6/oqLcxoeWAONA2/DkgL6zwCMZq46S83CEJzlESgPvigZkkvcFufx7C/hliGFhcIKlpX6P0qI1MJHVlEAqQeEVuAgeFGuDN27C//f0gMv32Bh6F7EqyExeUjMToIjzUdqlD6WO4U/Y08hpizAjpPWXQaQFK0dWPPmBdxOkoXMNqJTpnpSLYUe6He/gJiIhj2h57xSdK5N6hV1RCssvJ+3oNTGkIvu3moZE8UvHbaDtTmNZpx7lhj2qXOjGBUNR8ywmuWdsD4L8bJmz0+Lr8VFIAD3iOJO
X-MS-Exchange-AntiSpam-MessageData: UYZeLfr4TJPXl/T+tiAs6D0O9tEJr4riWswLSRBUHvZvWw9EGwyvpTHQGirdz+poupA+k/DbbjTmrZZh1E5BkUR2r2PUlHADjfsQXSHUb+HDjy2zJWRTJIULDdFlCnEMIYOmR6EI67rJHxh4yc9ET8yKF+RBdjeaz2ik3R3XHn11c/BOvjQrw5+cOUpZMmsr
X-MS-Exchange-CrossTenant-Network-Message-Id: dc7c9090-757a-445c-8d9b-08d7d00f3a5d
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2020 16:20:12.0970
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3gpg8rZlq+YWOuWUHMXQEefzhuY+e7EQp1OZnF59fxSZwI+lCSs+3QNE4ejRrCuz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB4025
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-24_05:2020-03-23,2020-03-24 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 adultscore=0 mlxscore=0 phishscore=0 lowpriorityscore=0 spamscore=0
 priorityscore=1501 clxscore=1015 impostorscore=0 suspectscore=0
 mlxlogscore=919 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2003240087
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/24/20 12:22 AM, Jean-Philippe Menil wrote:
> Fix build warnings when building net/bpf/test_run.o with W=1 due
> to missing prototype for bpf_fentry_test{1..6}.
> 
> Declare prototypes in order to silence warnings.
> 
> Signed-off-by: Jean-Philippe Menil <jpmenil@gmail.com>

Acked-by: Yonghong Song <yhs@fb.com>
