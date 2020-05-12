Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAA021CFB8A
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 19:03:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726367AbgELRD3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 13:03:29 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:36436 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725851AbgELRD2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 13:03:28 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 04CH2Vfs004299;
        Tue, 12 May 2020 10:03:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=94P58RatzIBe85TpLkpJQR3QQIQ+Y4lje8yAJ/qbOEM=;
 b=rWWy6w50Ll0TV4dyQWr0uZ4KParzND9epHKgBshlbIndEZ+GcxsWi0V4KJoeTVW1B32f
 EKFyPF0TY1Ynoj+Y4p7lDQyYqzlttP4aE/Yp38hsFBOhWNxIph14oMphxY6NU5sTeuWU
 JAmhHHHu0dzNSkB3c8UwWp2GuXE6XCfaJFE= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 30ws21h5jb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 12 May 2020 10:03:09 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Tue, 12 May 2020 10:03:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PxqXfMcRsykoetffEDEmxzQ6kVc2MGFVS2vwRrgNjpifycGMsMLIjj2799NtblohwqLbF7YT5u3gn/MXezXm+gNBJtT0Zl+Y5Its3exW0qtQpsav6mzsDXzjKTHKhchHQX4eprNZ5kMdT8H43RkGiji9Ez4RDS6V0OECUQI0hwLTFgHpAYxXwM9WevYV7M1v0RqJGvFXK0XTiFETSV11alDUMuR1HUF82aQ80L3SVxIjzovpzTukZqCWpVcxfUjRkfNKhZOuQRDDNuONJXCYeAMRv0STcggd+Y71OSjX3Pjvt46LuVzlmr5fo5scpHbXB038MLFtUOAL+CIqyDTJLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=94P58RatzIBe85TpLkpJQR3QQIQ+Y4lje8yAJ/qbOEM=;
 b=UtM0HerJ4s9f8DabjDzSsiA70c9lgp0uwCDOSpQt7NYqylU+dOU6fdOL8JA5OpNIkjHYCbnHQ7jPZwFKtl2Dtxis9f48rjkLFnNKhHsB7rdHPWvphs3n0iJUBiQxnbV9soTvv2Zbw053dhEYEjwatTITrHTT6VTjLhj0q8wFFt8oa7HKuuaBkg9dg4lCuxtWuh3A5HV4HtMYrjj1XH7oYIOJ7YWborfyt7lwEF9WU/AsWM90ptIBDUzdp9voLyK3etr6bQq9PPppDPRMbb1ld3J7OHsyyzXQPEW1vKLzYgEztl3NBVPKqooi4T7AyRjXQ80OnO3GYWH0rQU8h4Pr5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=94P58RatzIBe85TpLkpJQR3QQIQ+Y4lje8yAJ/qbOEM=;
 b=TqbbbJMAjZ5P86sxBWU7hlyorr8+L43ewbijCmmhL23TydXMctIZOc3GfiCnbxpLRC6YeXnXpNi/2sPWd2zPxPNeeMA1deJ1eBQf7ZYQJnMXwRstZd+uL+MXkgTuYOaBFIN3mEUR+3CIMHKS/2thPS5JzrNQdkmg8uccBRYVAQU=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB3109.namprd15.prod.outlook.com (2603:10b6:a03:ff::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.26; Tue, 12 May
 2020 17:03:08 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301%7]) with mapi id 15.20.2979.033; Tue, 12 May 2020
 17:03:08 +0000
Subject: Re: [PATCH bpf-next v2] samples/bpf: xdp_redirect_cpu: set MAX_CPUS
 according to NR_CPUS
To:     Lorenzo Bianconi <lorenzo@kernel.org>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>
CC:     <ast@kernel.org>, <davem@davemloft.net>, <brouer@redhat.com>,
        <daniel@iogearbox.net>, <lorenzo.bianconi@redhat.com>
References: <374472755001c260158c4e4b22f193bdd3c56fb7.1589300442.git.lorenzo@kernel.org>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <ae2f2aab-5099-0113-6ff1-fe759f8456b0@fb.com>
Date:   Tue, 12 May 2020 10:03:06 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
In-Reply-To: <374472755001c260158c4e4b22f193bdd3c56fb7.1589300442.git.lorenzo@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR05CA0107.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::48) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from macbook-pro-52.local.dhcp.thefacebook.com (2620:10d:c090:400::5:d0f0) by BYAPR05CA0107.namprd05.prod.outlook.com (2603:10b6:a03:e0::48) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.12 via Frontend Transport; Tue, 12 May 2020 17:03:07 +0000
X-Originating-IP: [2620:10d:c090:400::5:d0f0]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 201d61d4-58af-4f4c-1d75-08d7f69657f5
X-MS-TrafficTypeDiagnostic: BYAPR15MB3109:
X-Microsoft-Antispam-PRVS: <BYAPR15MB3109BB1571ECA605D50A01BED3BE0@BYAPR15MB3109.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:1060;
X-Forefront-PRVS: 0401647B7F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jHWmAAhLf87zZgwA4tnVRRsqckmQnw+wrIUKKjnDnHeAm9HfJhI6jd4OBtWn3dd5lTpkUZkYGb4/RDOvVVrVxc4WvqpXnsB0nMPsoE1+hBj6OrA9EPE+cYQffIST5FPAqE4u6xqjkx5jQSfs0cDohyp7sOtAdRpM6kwyFleZx3At0MZRUY5C3Ji4lTYIOsPJUpZnYlb23+E6Vpp/bKc4UvapWql4fNU0NAePZgY/jA+Y0BppSkB6iBU0hxyLQXBPsM1o8QHzVtQujEf4Fwc6sSeDAFY/I9gajoXd+IaLPkVwThZ9PBcLdLB0mS6yZTNmBqXznhP+nS3dGk8luiYp6r2Gjrpxydujnhi8e3YYm7WWEQmi6nk7ZWm2F3SgUdPFqcuwBJS9zfMKNMN3XeHB+xyaCJZEpcFnjrvlTvr/BNDGCQPMxxHcpNWYyTemn5w2bS5vspm7tCPY36ncwaLgXVQ6gcI4oWVkbVCEu7gQ9t83NfMPUjxh1HJh08PuWfIRymg/Tn0q259Vl7+H5RSSdeY1rb1evB+eRcawDm82LCDrNOGdxa7uq/5RcZqV/gbu
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(376002)(346002)(136003)(39860400002)(366004)(396003)(33430700001)(36756003)(16526019)(8936002)(4744005)(6512007)(8676002)(316002)(5660300002)(6506007)(186003)(53546011)(4326008)(52116002)(478600001)(2906002)(66946007)(2616005)(33440700001)(31696002)(86362001)(31686004)(66476007)(66556008)(6486002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 2bDW8vpcfNId1tJI/iM6ccBeISRn7FYVJrElvBACCy/9YvVne2ghtwK52Uw/iJnj/DoDMPgUCRJgobRb+9IR7Xwx+gaXvCfSJ+AXqsOp5hYvynNM5dKFdx5QB2Z+Kb7V+HDS6s0wADB0UNCGoAvwvzm1RsUfXKjh6VmlYAxiVty2u64cf6hXHKRl2xhHIqITKMv5d5BUEyDjwPztWHLxqHon6KL3viBGkuRb6vyROYSdSVI3HjNd/0MJ3HLxlArk7SpNyICrJCpBq1gdqCFYueGQEzP7IpG3dkr9aHubPW6VTe4YYSVIm4Bqu8BHpEfOah6AuoPd55gCbXHkL7zeznDzp3ffskM+sqP6bzdj86QUWPFAonIWMUCmvLgN5YMREM6Z6BgHzsGJ5ED5oAUuEPyD3DEz7bdDRfe0kOc4Kbp0rb8ajDqu4ASCprVuRxum9j/OdDummEVOxVgn2t7F/6fAjTNgXDyJ8hVSl354Cd+WW/34MpIjq02+uTDAvvmHv5zk8ZmDDkcAG99wZZUZeg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 201d61d4-58af-4f4c-1d75-08d7f69657f5
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2020 17:03:07.9592
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GIRMwcu6RAFxvULecSH9wEcUJiVL4Gu4iEPHgNdwu2JdiQp4b1jV1nVP2ByXOKBD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3109
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-12_05:2020-05-11,2020-05-12 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 mlxlogscore=999 priorityscore=1501 bulkscore=0 clxscore=1015 phishscore=0
 lowpriorityscore=0 spamscore=0 adultscore=0 malwarescore=0 impostorscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005120131
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/12/20 9:30 AM, Lorenzo Bianconi wrote:
> xdp_redirect_cpu is currently failing in bpf_prog_load_xattr()
> allocating cpu_map map if CONFIG_NR_CPUS is less than 64 since
> cpu_map_alloc() requires max_entries to be less than NR_CPUS.
> Set cpu_map max_entries according to NR_CPUS in xdp_redirect_cpu_kern.c
> and get currently running cpus in xdp_redirect_cpu_user.c
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>

Acked-by: Yonghong Song <yhs@fb.com>


