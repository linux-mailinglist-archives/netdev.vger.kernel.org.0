Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6257F269DEA
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 07:37:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726219AbgIOFhe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 01:37:34 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:20024 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726102AbgIOFhb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 01:37:31 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08F5USZI023154;
        Mon, 14 Sep 2020 22:37:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=ZhnxjwdK//YUCKxGCuMzXBjqpsGS1PPXtxOas48IMg4=;
 b=rBUMau3Kb0ba6Xa1Biu4kV26xWBGNrUgZOyt3e3e2A58+Un67cguODHA9oTmcV0Dppj1
 zV87FLRK36g4Odj11eM8+bzYowzQHNKcplsfZxRPsG6hHK0NjBBIcFxTSbLcZErsLXDg
 mlLK/yluByD47oG5AIgsv342ziea8nrRv1o= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 33hduba66n-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 14 Sep 2020 22:37:18 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 14 Sep 2020 22:37:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TkcKRTpNOLtpCEOYslyg3iVlW+8qz8vCHwVPuCHqn0XKRsjv3tVx9TPp9PHn0dPB1z6P5c1Ta69ywNiRurzDdrliWhw7fLE4bKwQzee1s0eHp/4vPIQtTVImF5F/8WjHKkAvzV5xw3xbuEW8/Vg9Qwbuy7kXjI53JvQf/KOtju6nfZ3VCoV2+KRuxGXFOQ4benLppLI7M9M11UUwoeikNgqKn+Y27NrvEMan9I5UsotocCbEZanpkhYt9m9LfQiRAbqcrnQ/K9VQ7IWRtvdhNWH8a+Oexgcd0tHqZV1lRBHItHdxd53rBWf3VU6HWB8lLlXvf9H0T56uv/F2tKNXTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZhnxjwdK//YUCKxGCuMzXBjqpsGS1PPXtxOas48IMg4=;
 b=MPDqF7+feJhRUz6htKyXADLjPI8TXmEWtRU57ViJR36/6kE697gM2y/mwVRBNYMzw1CiILxmAcPKwmPcny3YYV3CmouPOiM8N4Aw5+yifavyfHMXwZYtUoUACuuJcetfPbvDmZpVLwuLfx79BH+6r/5dcp3RbELfx3cd83A5elo30lY9a/WY83FIjaDp1nxKutkmgeqPIjhuIUDAEZ8aQXTxYaID8wD5zZ3y1KWCgz8g7JkJzFBqQ3Xe7JvSTxc0b1oCUGTuUL5EzfM6Qapzj7VcIOI9xLrTpPZeNBgLWYvI/PBP+Qha8hFx+NwwrrdeoTIMgrDTnw6LxFXwnGG0OA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZhnxjwdK//YUCKxGCuMzXBjqpsGS1PPXtxOas48IMg4=;
 b=gA2Zo1HYO34mRuEWGjeDt4mL9zbtE0Cd252s8VNNYiuXcFT7zst/VTjdBSwuDyyctdVprQNpQSvkFQXNXFpWhhL/VNYlO97G2ozPTlS05WCSH6X22E+M7NUKlqu4eNaVrs3W0DYh2Y/BsULWyiQdel0z7qRZwoziRRy0r8G9Q30=
Authentication-Results: cloudflare.com; dkim=none (message not signed)
 header.d=none;cloudflare.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2407.namprd15.prod.outlook.com (2603:10b6:a02:8d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Tue, 15 Sep
 2020 05:36:55 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::c13c:fca9:5e04:9bfb]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::c13c:fca9:5e04:9bfb%3]) with mapi id 15.20.3370.019; Tue, 15 Sep 2020
 05:36:54 +0000
Date:   Mon, 14 Sep 2020 22:36:47 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Lorenz Bauer <lmb@cloudflare.com>
CC:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>, Yonghong Song <yhs@fb.com>
Subject: Re: [PATCH RFC bpf-next 2/2] bpf: Enable bpf_skc_to_* sock casting
 helper to networking prog type
Message-ID: <20200915053556.jvunz3rvlnlu46jp@kafai-mbp.dhcp.thefacebook.com>
0;95;0cTo: Lorenz Bauer <lmb@cloudflare.com>
References: <20200912045917.2992578-1-kafai@fb.com>
 <20200912045930.2993219-1-kafai@fb.com>
 <CACAyw9-rirpChioEaSKiYC5+fLGzL38OawcBvE8Mv+16vNApZA@mail.gmail.com>
 <20200914194304.4ccb6n5sdcfkzxcp@kafai-mbp>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200914194304.4ccb6n5sdcfkzxcp@kafai-mbp>
X-ClientProxiedBy: MWHPR20CA0034.namprd20.prod.outlook.com
 (2603:10b6:300:ed::20) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:3342) by MWHPR20CA0034.namprd20.prod.outlook.com (2603:10b6:300:ed::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Tue, 15 Sep 2020 05:36:53 +0000
X-Originating-IP: [2620:10d:c090:400::5:3342]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6c87af3d-f682-4b80-0378-08d859395acd
X-MS-TrafficTypeDiagnostic: BYAPR15MB2407:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB240778F99B8B9130A3318C9FD5200@BYAPR15MB2407.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6ah+9TsqOg/Pel8viIoc5iWT9t4WQ5dWgoNq9GEyLiZNmoLS4KeVUgxuX47c0AMEJl65ohEHeUoVhTWm271aFbOBuOQFwOjf/OSHXCEh01+GlxTAGlexDHEQU/jdecZiywhZe7JmMdXS+qj3pl7hOLTxBMkwxe1Fvx73OUKTOBoU17ACIzxExg3c1iPjm46x7+VaRrznASHgv4XETc7sxa3gveW+Ot8qZ8vBG75NCPzZFJ1udOvd7v0JyjU6edXDSirIDzQdh22mFXpkhMaCaE2oQ/nwGQkOBPvyWTxJ8kyLHAEzn17UbQHii0cW366xZd/tD3lm/FtYuQJ34kV5kQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(396003)(346002)(366004)(136003)(478600001)(16526019)(7696005)(52116002)(6506007)(186003)(4326008)(9686003)(6916009)(55016002)(2906002)(316002)(8676002)(66476007)(8936002)(86362001)(66556008)(66946007)(54906003)(83380400001)(6666004)(4744005)(5660300002)(1076003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: ieyyg2aO0U88DsaOevWGRwMPYpt97bWuajQnBh0VZ7pdIcKY8zODIyvw8n+qaBJGcyO9pFIPq/Y3mfFDDRdBbmlRHndNhxPFl4bz1X07yVRc0Fi7CncN0YIKKJPLNBb1r2J5MXfQ1UI7Zan534pKvWzq03VxaqId004YRXLtoV4Hf6PX1IOk9lJorbnFI7gvYtE4+1TrhEyu4fGZMJtlG0vymVl6vR3h/HWtoKfbEM0pPuVK8leH6Yf7BtidvQciBhUmHnVw79h2EuZCwivbQacjYUWgI/sJIq4dsJB1h5i6zIq/8hLSmVFevlneRrcWtuBzHB7ehPszJMEpPKkCI6wti4m7hET4dpo0OJP1ncYUMFOo8m4EARkh4SCwmmyb31ecKTKHH1uAuNpaZG7jEOu/56KjouTsPPfh1sqA1WNylZZVlZr/9WzNy3hSQkLt2LwjYFBdybxz53MLRhhHxNOG3wS6uWRykpn5eIEEdoadmZLPLSxaGlOgsH3wPGAjU9JAF7rfu1em577ryz8NKbffCEnaDU3cYXf5Hl8etXlj8CQQ0T3KUSxgRK23TeIJ+FWjoBu+TEQm51zHyB7HIBwMn7S2bVw+mjZL//GfWtXUX8xFdMi8exQZ2zpyFS1O9u/RsBhID9aPvmfhaFQ3WgmnzizhT1eew1WRVMqAWZQ=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c87af3d-f682-4b80-0378-08d859395acd
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2020 05:36:54.7936
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JN64DjpvxB/4Hen8b3HuH6VNNSkSqSq3U+YsPJFOqpqL5l8BUhnOIjdAtg4Cxq+d
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2407
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-15_04:2020-09-15,2020-09-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 lowpriorityscore=0 suspectscore=1 spamscore=0 impostorscore=0 bulkscore=0
 priorityscore=1501 adultscore=0 phishscore=0 mlxlogscore=876
 malwarescore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009150052
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 14, 2020 at 12:43:04PM -0700, Martin KaFai Lau wrote:
> For other ARG_PTR_TO_SOCK_COMMON helpers, they are not available to
> the tracing prog type.  Hence, they are fine to accept PTR_TO_BTF_ID
> as ARG_PTR_TO_SOCK_COMMON since the only way for non tracing prog to
> get a PTR_TO_BTF_ID is from casting helpers bpf_skc_to_* and
> the NULL check on return value must be done first.
After looking more, it may not work well.  For example, reading
request_sock->sk.

Need to think a bit.  May try out another idea tomorrow or consider adding
the OR_NULL arg as you mentioned.
