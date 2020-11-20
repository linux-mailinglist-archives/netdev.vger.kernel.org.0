Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69A9B2BB253
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 19:21:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728522AbgKTSUp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 13:20:45 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:49032 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726739AbgKTSUp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 13:20:45 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AKIA9xV025515;
        Fri, 20 Nov 2020 10:20:30 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=jaezUN3453V84uhygZN8LYWvo4lF0aonyTjOhhAmVXM=;
 b=Ak9do0sxshyWuoDbbBZR7FHx5cKZJfynOtyt8HWeDT3c/rw/ts0Qttjh+raIBpSP+Jnp
 a0S8p6OaOdlWDMLQDBtFvmsyQq249PpQhZODJT/latFMAc//Cm8Lh3q9J707EcNTj0N5
 0zeVzcVBuwM+dHKQfN5f4+uVDUx7qpIKDXE= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 34xat42q15-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 20 Nov 2020 10:20:30 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 20 Nov 2020 10:20:29 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QX5viV/d9bIEuhVkvYJVYSy8h6L98FKQWeuMMKY+dnS2j7kNlzsRbudhTRgdrO1wn2TyE9KK9F4EnPTixpKtLoTADir6V/ChPCxQzJDzDjWABh0DlHUrBS5ieJzIDwiQFWgp0iAtXr7ZIfi4yUr7CizREesYY/a4anIx61epHfgTq2DKHVZ8CvhdHLukwmaKk9VVZsET/WIuOYqhN1+tnV+BdD+HAv+8R/8/5wJP2fGUGBOmVzfi/4kd2GuysCkBatDr/NSKoSCOGPUXjRkt6uoxazEUO1GvOnw6BghYPIcdzXUkwtB9vaDKrV/aSGeHrnpWEg4OrEe+BwY4VCH3TQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jaezUN3453V84uhygZN8LYWvo4lF0aonyTjOhhAmVXM=;
 b=C/moJtgWTFMDg+44QrbQBP6ciu7WEsoL+p1t1g5WwyNTihSfubHmNff/Lz0ePeI/dA43yntaVlOtmdxmwM4psdO6BLjGEbzIBN8AuHy8HwMPUpmEC0M0iZxUf9DA2c7jirUFIvC11EGJqt2heb0Th240AN66Xrgj0FqImrSkX2ZNmwL2gmwzvhOx+N/vKjh9LGf4sHxjkm3TP0qee25UOtGhJZinz0gY+ZCjr8L4c3jUaeEnNaDSQFO44o7AfaaEeRZRPgkL7xlf4CeMxhtsG6IG6LpuVKcWBSRLwimbBempxs+TB3T01Mvkw/Kjci+e4dssL1oTv06nb/V47Dn7jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jaezUN3453V84uhygZN8LYWvo4lF0aonyTjOhhAmVXM=;
 b=iJfTsRk3ttrJ52/lZ7dQ33ux8jTK8wQQdbIFgb2KfLMCIuFjw7V/ZOaF1fzPc0WpImdNEgAmV7d6OVA3oFRyyxlh1VslO1l7AeLVm+VxoxgjLx/r4nGqtpJ1SuM4NX0lhZ4UZ4onoLLk3zxXsXr3lO9wAcAM04lvBUgL7WjAqqg=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2406.namprd15.prod.outlook.com (2603:10b6:a02:84::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.25; Fri, 20 Nov
 2020 18:20:25 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::bc1d:484f:cb1f:78ee]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::bc1d:484f:cb1f:78ee%4]) with mapi id 15.20.3564.034; Fri, 20 Nov 2020
 18:20:25 +0000
Date:   Fri, 20 Nov 2020 10:20:19 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Andrii Nakryiko <andrii@kernel.org>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 2/6] libbpf: add internal helper to load BTF
 data by FD
Message-ID: <20201120182019.zlzmntlnaewcc5ue@kafai-mbp.dhcp.thefacebook.com>
References: <20201119232244.2776720-1-andrii@kernel.org>
 <20201119232244.2776720-3-andrii@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201119232244.2776720-3-andrii@kernel.org>
X-Originating-IP: [2620:10d:c090:400::5:603e]
X-ClientProxiedBy: CO1PR15CA0088.namprd15.prod.outlook.com
 (2603:10b6:101:20::32) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:603e) by CO1PR15CA0088.namprd15.prod.outlook.com (2603:10b6:101:20::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20 via Frontend Transport; Fri, 20 Nov 2020 18:20:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b3ff3575-04d1-4288-094e-08d88d80f349
X-MS-TrafficTypeDiagnostic: BYAPR15MB2406:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB24065FA70F7C7B4D850339A8D5FF0@BYAPR15MB2406.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:873;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Sro266YSz6NxOwT/Qv7EpWSw108mK1YWDm6pmXosGFuYyRTe1FQXvEgdEkzxM4eF/xNmPmRL/grL1T1xufFgOBF0f9qpmugiWmLhdM1sN+3O+TiDzamI9G7S/pH9TDkQWUJe5S0ISSby/LObp1ghkr4UBk/DI07srT0Qs7HwXLY1x2ofbGrYye7OiewM1FeOJXKRThm/+AnFBQPxVsdJG2CUVipkfYOpC4gPmHsHbhfvTPUEXvsw8sUrmkzjfTjAcXgZNtCZRZR8ZDDon0Wf56KrFKQwtbiy9P2Mq/1mjWwEActu1B/PGOO8d+Oyu4YmLURBcYkJjqZ/X8WTvc1rVg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(136003)(366004)(39860400002)(396003)(6916009)(66556008)(8936002)(83380400001)(6506007)(7696005)(4326008)(8676002)(2906002)(52116002)(55016002)(478600001)(4744005)(66946007)(5660300002)(66476007)(86362001)(9686003)(1076003)(186003)(6666004)(316002)(16526019);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: Y2Wcpq6MBWrbwDf8FjFg4jeXg3YYK6jVQq9yMCRr66c0bD0fLWDbZDEH0nLNrHLuOl4QqueVoytJtjh99zmmCVmqoiO57AGRVd4IPQWLlaHoeN+qM7SjHpqf0UOhCQG9K1DO6E/LmU3M2JMOldeDooS4gFSghs0eubhtk85FeguKXlce/DJPv6VulDHSV5poe8WbRsRK5zJ3sA517KFz3HRi+OxvLrhW+L37CmuG8eH+wc84EKUer+KZzfThiaPG45tpqPsQtwr4goXIMeUYhncdDZOG7qashcNkhQfrCYjgST6TNTkzNgmllfT/wwFzR/nNMVVwtX3VI25/vISrguL36QnspfLfhLrnEW/ZmbbUvHkiTCzqTJGezJB6Fi5uUU41RiYeSbLWNiO9fiSXCiKpxXseFStd6ostsWfJwIp38kVFpWPnOzK49cjGv1wLxNVrrk2F/6ojFAtokMdEIo/cS1mBfzx6iSXI9hGEgPbjzOtJDNn7IiZ/IH6XSOK5qr5yemZanhETQacSIAFefsP3fk0WO//B0IpOnCgO1xJbbmxsMLEVfP9ZJ1PuoWfnmA8wZtX4WVaIhMdUms2L01XUzLPsuJs1k3uxpn60su6TrSHlDB0a82O23UhvRk2PIHLWD7ILJLcRYf2QXu3ZD4ftbzOuYzfuS/bRtQvPvP5j9TeatkT4PMfPJmjYa6Blk8pZQRhlsEYipDTRyb4Gs57vOMRG+6/3cMNiMmROvhVBfoe2I8U09tq6nUNBKXBqVUsBxExtWVS1LlZXmGIjkmCDdkjZmG9vrAsKXnM3mRpkH1cBUYsi9wCtKNMeVABb0QMZqCoxt8SXaTn76/BDt8/hOP48Tvm1TGG1jicEqpuFRQ5NdIB1lYVKGETcrFFdRUsI8xEhzDdzobDscMVlqZ2OneWQLIZGPWUjf6i0pa0=
X-MS-Exchange-CrossTenant-Network-Message-Id: b3ff3575-04d1-4288-094e-08d88d80f349
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2020 18:20:25.2144
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iopqjT9gasWO5gmTV+lVRiH3/h9O5X+wjDups7AmaDKEJdQARxTDQJusZVr5r6yC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2406
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-20_12:2020-11-20,2020-11-20 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 impostorscore=0 mlxscore=0 adultscore=0 malwarescore=0 bulkscore=0
 suspectscore=1 lowpriorityscore=0 phishscore=0 clxscore=1015 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011200125
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 19, 2020 at 03:22:40PM -0800, Andrii Nakryiko wrote:
[ ... ]

> +int btf__get_from_id(__u32 id, struct btf **btf)
> +{
> +	struct btf *res;
> +	int btf_fd;
> +
> +	*btf = NULL;
> +	btf_fd = bpf_btf_get_fd_by_id(id);
> +	if (btf_fd < 0)
> +		return 0;
It should return an error.

> +
> +	res = btf_get_from_fd(btf_fd, NULL);
> +	close(btf_fd);
> +	if (IS_ERR(res))
> +		return PTR_ERR(res);
> +
> +	*btf = res;
> +	return 0;
>  }
>  
