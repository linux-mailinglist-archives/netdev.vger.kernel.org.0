Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A34BF281DCE
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 23:46:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725792AbgJBVqK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 17:46:10 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:27132 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725379AbgJBVqJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 17:46:09 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 092LeVMs006913;
        Fri, 2 Oct 2020 14:45:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=f/yxOXRP4AOJAeXGADs6pppLmy/3B9LT371oZmnUkCk=;
 b=X3oRAkZyTAM94RMrO4SUMIpyYGDDB9y0IoRfADcLG6KZU+pTead7F+xH+50+V0d4g9kC
 yWE6uSGOfIhmZP7ex8A9J/MB6xhUiqoQuSr+Z3JyrWFfsp4mwn/KHQo/ybByJ499pQwg
 PhS0UOQAy/8oJoEArScE03srI+Df40l+hcM= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 33x7781tfy-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 02 Oct 2020 14:45:52 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 2 Oct 2020 14:45:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UvGKcFSio14w8n9a6u0e6R59nLE3tjkwpvvNdDamDUd9m47m9x8Q49V5YCQYAeDT4RLN19CAteD0KT7CucrUoJtq68yoeNHMRILQxZ9yWcnIfktf9l/UWhUsgv0s8iX58X39hojiJsS/Z2LKLVw3bRolVNHrH+nVXtgrymCOY103c/MhrkihGCXzBDYKuIXDqJkUFVUlz3te6EV0QbyclLKANZiaLdqLbUbMnUrZIZ5NlbG8FLE/UPWt3SDLNSRp8lngwRnRXRMFLbiGEfA/wiZU9sMeFg2kaSEp50HllzQSmz1gPhr0juNoI2wt10ndIJw28VjdWSMJ/6yUL36Z1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f/yxOXRP4AOJAeXGADs6pppLmy/3B9LT371oZmnUkCk=;
 b=jo1gP9qSQyAZ5sB46KDXHs6tsxVkj9rpensA3GFYQAsecgSM1KSnGcdkqVLYuCB0jmGtmYEjmc3jYfM/WPk0YWyGRX2L87sK+cbAO2jOeWnpvpRPt4twoQUIoOOAF1HxTvv1go7j9MuY6QJck5uEHscq8JTvsr2C1CgiwsrgbEL8EDBA1bQUkEJuQLgxNC4HTaSFHepjBvuGJKGoSD+xZ1rx6Ze4HlhAEO+VtUXDkIC1B04CUNRFp5TXDHXNKAoSo0RPIZC9xooC3VRpoBRmptuDxtFG/2MtGZPPqQm5OjzwGJkjzFYa80Xq3FrHe2kyN3Gbaamvm4Ggic6HnWCPEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f/yxOXRP4AOJAeXGADs6pppLmy/3B9LT371oZmnUkCk=;
 b=QCyD+B8UPOGbq/qGtFQPoYcKHcRAF1+h07qR0PmBg6T+z8wuz0ZvP7/MIgZbUI5cLGkArsaYVZwEEsnlKb6k8rgL89NS0YdVaYixm/XJ0K4qFRSwtDv3v2YX5EdgqdpfuXMkm03anZGMtloaJU7tMJDG+N3twno8CR+GeMaPGLU=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2581.namprd15.prod.outlook.com (2603:10b6:a03:15a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.35; Fri, 2 Oct
 2020 21:45:43 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::c13c:fca9:5e04:9bfb]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::c13c:fca9:5e04:9bfb%3]) with mapi id 15.20.3412.029; Fri, 2 Oct 2020
 21:45:43 +0000
Date:   Fri, 2 Oct 2020 14:45:37 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     John Fastabend <john.fastabend@gmail.com>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <jakub@cloudflare.com>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
Subject: Re: [bpf-next PATCH v2 0/2] Add skb_adjust_room() for SK_SKB
Message-ID: <20201002214537.lmc6ej4d47cr7tvm@kafai-mbp.dhcp.thefacebook.com>
References: <160160094764.7052.2711632803258461907.stgit@john-Precision-5820-Tower>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160160094764.7052.2711632803258461907.stgit@john-Precision-5820-Tower>
X-Originating-IP: [2620:10d:c090:400::5:a8b0]
X-ClientProxiedBy: MWHPR15CA0030.namprd15.prod.outlook.com
 (2603:10b6:300:ad::16) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:a8b0) by MWHPR15CA0030.namprd15.prod.outlook.com (2603:10b6:300:ad::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.14 via Frontend Transport; Fri, 2 Oct 2020 21:45:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4f328d4f-d20b-46bb-e0ac-08d8671c832f
X-MS-TrafficTypeDiagnostic: BYAPR15MB2581:
X-Microsoft-Antispam-PRVS: <BYAPR15MB2581259D1BE914506043553CD5310@BYAPR15MB2581.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: d806ooAeU4IU6p3Kg7xCq0FQrRvW6bGAm/u5wuua8nZeyL7XFAvKr3JtMEKEYoSd0/2OgUNU6wJucbHgOtTyIaLyzIeIxaytUXh5o9c0TSOoqm7rEM0STAGkDx+bzij/7XS7QZYS8vTqmMhjcI5IJSVuIf6Rd3KKfsaDl/Eg4hvUwkZnQXkjIrITLEUVZkim+HCo0n0f8w8yvzzNErgfczEaXiFbHQdrYbOFzvC7IwHCMYbAhvH0J8EbXm7p6cwcfgnXgjeEnx8qVzBb55s92NfC7Z7O5dVzxomLbjxzb89SlEmNQ6RtwzBJ7OnBRQzYoq7wbQ8aaPtaG/YH+GEIhA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(366004)(376002)(396003)(346002)(1076003)(4744005)(7696005)(52116002)(86362001)(83380400001)(6916009)(2906002)(4326008)(186003)(316002)(6506007)(8676002)(478600001)(66946007)(8936002)(66556008)(66476007)(55016002)(16526019)(5660300002)(9686003)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: D+Uto2IWFsXA7nWzRjddlj60yGLl9S8nnlw7ESxfsq7Bhn++qwwzczDb8H9gssn34lT49OEgTX6avwM156UkfA1qUh4zk8U9xS6P+KYW6ufCOYKkpwYHOAzFoLxlvi+gqsrscCU/+TE//+XDKmszg8bMhmA/JU1njIdsXL6zbKZyiYVC7Q3AErALXtMK5gw/lmoiQMJg5KW5Nsl8cTX/DriA5EIvggY/+yx0T8NrM8khebE9oOlSNy89Br8qJqMZD37OmMKr6FkTFqfZ0ZJIpG72BJtD0BAzIl7hdi+MdQM7Mbv2xlcdb2LB/2vDodt89np3Motp9e7FtQOJHfTPUOLXL2I2727VgaSbsI1gf73zo6BmtzPAdgvQ4MZkEEqGtW9MH/cNxTrd1jx8oKGIRkKTyBEQtO3UG4RDIPFVyvkgWc5iBSFqch6qZEeOxdBNa/u1+MVslrOqTyESKtzGgKXP8tfaNkQLI/gJhYMyx0WOrZUsJpZxz82FOTeUIQMzVjDhT50KVJJl4eu84NRdEfpCWBMYaFqWUEBCQYFAmtG3GG8AWsW7Bis2s2dFpy9pM5Jr9sUpvp0kTO9Jz/zIqAL7STKZ2BXULTCJSJ31Kj+KjMPsyNUJbsa9wQpVcAD7ok/2CwDTEHN2qMHNNm2/N2xGT04aocDe6zALkWheHZA=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f328d4f-d20b-46bb-e0ac-08d8671c832f
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2020 21:45:43.7709
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LTIluRsOkmQygVvR0flfevbSQPal9RRW0Juf8b6O+kfjNdbZWXtlrPDYW4N57zI9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2581
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-02_14:2020-10-02,2020-10-02 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 suspectscore=1 mlxscore=0 bulkscore=0 clxscore=1015 phishscore=0
 malwarescore=0 priorityscore=1501 impostorscore=0 mlxlogscore=632
 spamscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010020162
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 01, 2020 at 06:09:34PM -0700, John Fastabend wrote:
> This implements the helper skb_adjust_room() for BPF_SKS_SK_STREAM_VERDICT
> programs so we can push/pop headers from the data on recieve. One use
> case is to pop TLS headers off kTLS packets.
> 
> The first patch implements the helper and the second updates test_sockmap
> to use it removing some case handling we had to do earlier to account for
> the TLS headers in the kTLS tests.
> 
> v1->v2:
>  Fix error path for TLS case (Daniel)
>  check mode input is 0 because we don't use it now (Daniel)
>  Remove incorrect/misleading comment (Lorenz)
Acked-by: Martin KaFai Lau <kafai@fb.com>
