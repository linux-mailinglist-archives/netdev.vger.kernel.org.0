Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E18782AB11B
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 07:14:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729535AbgKIGOL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 01:14:11 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:42676 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727077AbgKIGOK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 01:14:10 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A966cnC029805;
        Sun, 8 Nov 2020 22:13:57 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=H6doNJHPGNLoDZKV+MUbE/NJfSJz1WS53xPfiKv72ik=;
 b=CyGjjZuKxz0RkPoAPH1GREMXl0dcZQsVpYw5pqHgyQu3jff44IM91uv44nXPEBHRZOqJ
 /GaoR/lUun1JQtet6XM/Xn3Mit4tMyYHhwwPjbLvAjA0v470JXq3bj5PdA2UC7LLzuiF
 KJRA/o0zCYqlqLBY3509hYDD7oQOdJp7P/E= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 34pch9k01c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sun, 08 Nov 2020 22:13:56 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Sun, 8 Nov 2020 22:13:56 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FnonTw0oNU1VexCIZDZSYnK3V7THoVaTkzMNj4KcpQtmB7uIvuai4wj1DaQJOV+HXWXpdGfZX0+kD2ppDbtT4heztAVoe43IYJzf8S7RLdokQaZNkk5HrZZJXKIVsPV3pemQuOsaJWPEzSeOaTDBaVNTZA3Ft30ogqTxJla/btQOuFC+P0YnkXZAmkLvIC2W2F6vragkDznKhhVr66VL7JM2GO7/38Hbnrjkh/eXZY1EBuXYv+i3PRoopWxhVmla6fV01OuyFe3RVoTesbOj+vHL8jhCeZG9Tboiw7VWdjNBO9Py5C4FN8fqgHyPMn8cmBQbqmE8t6ns9xyASgUC1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H6doNJHPGNLoDZKV+MUbE/NJfSJz1WS53xPfiKv72ik=;
 b=BVwWn7YzI0OXLKimzD6KFYV3CQChszhFnb+mxLrCWhUkfVH0DmzDBmzqOwM6I/1+MmYIOvkP0KCWNG0kjK6ESxpYCeOhvH0cgdw95JClKkouFLcmdbq14iFIWtf48cvZR7RsMlhys+KysqSERuC6i5xiqgMgDmOfdIXM4UzBzU00rNlrKKKhfIfqYlJ6HLd7zJcWl7lGHiglTRK8h/Fl94rQLH5G/6ot0rHLSHJ3nJGtgdUr8M96FnBsdRmwE9ARRW9wFy3rh1djcaSrzBwU2b9Txg2DsVC5arS9mRgl49/86yz8HXcnK2PZ+HWDu553cgPf78l0quMLOYxrxXRG7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H6doNJHPGNLoDZKV+MUbE/NJfSJz1WS53xPfiKv72ik=;
 b=dNSrcI6m6GPQ0rg/scKfqXSj2CcV8t4jyqLqs6ArkO2FFddBasWGWHGG6eQHjXXwyGW8MhPCbFBTZL9PAVaGLl+r2XWPxfVri5CaQbwN/bNzCr23D8HFkKjHbYZwQV1eVu+KzOF0pOsOIevPs8PAM4fPgxof0kl7Tol2KOu+/TA=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by SJ0PR15MB4236.namprd15.prod.outlook.com (2603:10b6:a03:2cb::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21; Mon, 9 Nov
 2020 06:13:55 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8887:dd68:f497:ea42]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8887:dd68:f497:ea42%3]) with mapi id 15.20.3541.025; Mon, 9 Nov 2020
 06:13:55 +0000
Subject: Re: [PATCH bpf] libbpf: don't attempt to load unused subprog as an
 entry-point BPF program
To:     Andrii Nakryiko <andrii@kernel.org>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>
CC:     <kernel-team@fb.com>, Dmitrii Banshchikov <dbanschikov@fb.com>
References: <20201107000251.256821-1-andrii@kernel.org>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <67fdbee5-14ba-360b-269f-d7030bd7062a@fb.com>
Date:   Sun, 8 Nov 2020 22:13:52 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
In-Reply-To: <20201107000251.256821-1-andrii@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:788d]
X-ClientProxiedBy: MWHPR19CA0008.namprd19.prod.outlook.com
 (2603:10b6:300:d4::18) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21cf::1046] (2620:10d:c090:400::5:788d) by MWHPR19CA0008.namprd19.prod.outlook.com (2603:10b6:300:d4::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.19 via Frontend Transport; Mon, 9 Nov 2020 06:13:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d0f2cbc7-bdcd-4c84-4c3d-08d88476a327
X-MS-TrafficTypeDiagnostic: SJ0PR15MB4236:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SJ0PR15MB4236505F6E07C52F58C98396D3EA0@SJ0PR15MB4236.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ERRvLntKi3uqr+ksr/TgW5xO9D1XZA9f7xyMJbAXdVET58TDAEuvBIXuWbEGNOvt/2cD9GHgDJtoZYXySK/J6namp6ppDZXPg94Yr1yd7CnlZ67TEZ2BEBcgTTTJYGBwrVAYvXPqo5i3AkENoXss/zkd3N7C+AnwmOZh5oP2dE+0VAjevZT9qqKWuL7by1VRrZq2RNRwshxDUdaFDKSkp3JBEDy5MRHvor37BlQzrNGS00+nrWLzUD4yL9iZyGMWNoRr2UT8P4kWJKNK/WEUGLnVHZq0XGiB+/9H3BHtgIJs+PxHs3cm9MfXyfbnBYn5yW5769Pnyq8H+ClkMuOfWZDs7Nvdh5xiSBxk5gvhsdYjJIKzyej5oxTEzG3GnQS4
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(136003)(39860400002)(376002)(346002)(316002)(5660300002)(8936002)(4326008)(2906002)(36756003)(6486002)(66946007)(66476007)(66556008)(31696002)(83380400001)(8676002)(186003)(16526019)(4744005)(53546011)(2616005)(31686004)(478600001)(86362001)(52116002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: op78oae2dATKFfteU64L6AI+3xyVhrK2hSrUjgVnOq51OdfrfDHdl/4cuMbxf7ijiMX5XcJFXn4hkp/eBkrAB9mi+1a8wdBx5Hhmd/9hhpAYUDeLBKIpZNC+UGhG+Jejl5KDYPRwWXnhuWTScN+ItYpmbQalmASfotbeyDKDM67kIy2dtmCt8G8FmNYusU5e8B3/MON/0Ur2SiotNdThEIeBMYFZuFVWn4PGJyfeMv+5p3fYAnmt8v4/dwzn/KGMVPyphWRdZoLm+AsYCtOX7+QulS6aC3qqVJ1L0wBqTjVs8ETpk2TO+4gsAl68lHlnwJOHzwD8GzAHhpZ7Tdzl30t8jjx6O95ML2PIrz6e12YdKjWmY4CV2HyavQhQIw/XDAzFiLXLN7oqVN2y0CXc7IFaTxl4/Nx+lm+Qdj0A2sJbR3AVMe1jeUqWdhHNMJ6mARfbtgGLZgPd9gBheoumbQj7cpcx+IsuvbMGTZLu9Le6ECJZPOAyXJ4wUyi05rPJbhEDeg9D62FWIFnrlAlEEvkwzxmB8K1PamQuq4RJTACKZs36As/fYioV03wtKYBwKmaehEOz63TBA6WQc/DZ0VNRIW+8bTgv/zuuCEbe867k3bE5C6ax1Mx2GzZG2/V2aUZ0qmQRBjrC/tmgJq972Z4bVqChH6FpuMxM2wGteSfGKDLzTGSTDUcV1mrDEZwt
X-MS-Exchange-CrossTenant-Network-Message-Id: d0f2cbc7-bdcd-4c84-4c3d-08d88476a327
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2020 06:13:55.3592
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FUrFZN1+43+tI/++QtxJcunWwlI0kcW4AgdHdXLfWUePGDQ1dIyc9b1xWxp1dXgq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR15MB4236
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-09_01:2020-11-05,2020-11-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0 clxscore=1015
 suspectscore=0 lowpriorityscore=0 malwarescore=0 adultscore=0 phishscore=0
 bulkscore=0 mlxscore=0 priorityscore=1501 impostorscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011090039
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/6/20 4:02 PM, Andrii Nakryiko wrote:
> If BPF code contains unused BPF subprogram and there are no other subprogram
> calls (which can realistically happen in real-world applications given
> sufficiently smart Clang code optimizations), libbpf will erroneously assume
> that subprograms are entry-point programs and will attempt to load them with
> UNSPEC program type.
> 
> Fix by not relying on subcall instructions and rather detect it based on the
> structure of BPF object's sections.
> 
> Reported-by: Dmitrii Banshchikov <dbanschikov@fb.com>
> Fixes: 9a94f277c4fb ("tools: libbpf: restore the ability to load programs from .text section")
> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>

Acked-by: Yonghong Song <yhs@fb.com>
