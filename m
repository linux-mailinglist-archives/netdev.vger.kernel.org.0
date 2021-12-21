Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2046C47B9E6
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 07:17:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232627AbhLUGRA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 01:17:00 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:24660 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229698AbhLUGQ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 01:16:59 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1BL0mibh016443;
        Mon, 20 Dec 2021 22:16:58 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=V2RKlrD3Ltt8p49emqB5Y9DlK6LVLi+gCHi8ARF3PU4=;
 b=S5XIwy/oV3DdqqxUEDUFaY/ZjM7sLP9HiIbMtpNDq0eZMoxYNPwDICSe6Ugsdb3bDpXS
 5L+RTgawZ6tUi/fyAHHot68dqcj6a0h4wZmQbLfOfLi0S/uVQKx44kDWPQXNdghQ0yQz
 8o/3RTQr6jA2yTjNaIuls7Q5OYJDVI67yCM= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3d300e37v3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 20 Dec 2021 22:16:57 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.230) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 20 Dec 2021 22:16:56 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C0lXAePtQqZ/JbUZLxvaCJBpm7wlyo6Xqx/o1JyzUR+hV/qcsxw3juyOv5CodjzZkOiC9BXl5raqy2AgtPJaygKX+FdBmbB0pgA6EakT2h0zzXL5ezgkQfl7SOqtvIcU2TnUYjpXrYNJsfWMS1dIVPnYVAVPh+LLG3FZqz7JkcT0X+SsQ47InrszJfeG5snEh+jD1T9QWjP7c0fy1VK2Q94kCOWb5cRnhc27CfjIBZ4eDP1ObiMBes5ELZldmP4QFcbd8/eHeBYfXDQWK4eYcRC1700LKbC6+ys75MfuGAPoyF5Q66GBb8kwaSyZ4irBzIPGsOZxWoq627i/GP2JHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V2RKlrD3Ltt8p49emqB5Y9DlK6LVLi+gCHi8ARF3PU4=;
 b=YyYV7iFoJdAxdtJVhpBbjdvHs7BTZtUqTpVMMk/P9xXDAag3LhNTGRF3nBrcLY0OGGu+SG2meiwbe2ia7ghCVgRIQkLhfNRXSpFhrcAvM6f4PZd/ABWJRA1XYPMm2OkIBPzqRgu8B17ku8WwCHNmC1GlNQnBt1Xiraw1rIn3dFr4QPwfQIRvClv4hGJmmueEYtK8ezD4IeN1Tw9RrKvmh/q3oqES96FstobtlF0EW0EL64yg8YKDqB8eU3OZf1s67Q0kvK/zA8MAhS2iiCYNBBYW8Iy/yhTmgUr+rpZ/ZEWRt4uMoZUaw+7lReR2LT3Q6hyN9e8CW5uPWewE6ke13w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SN6PR1501MB2000.namprd15.prod.outlook.com (2603:10b6:805:10::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.20; Tue, 21 Dec
 2021 06:16:55 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::e589:cc2c:1c9c:8010]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::e589:cc2c:1c9c:8010%8]) with mapi id 15.20.4801.020; Tue, 21 Dec 2021
 06:16:55 +0000
Date:   Mon, 20 Dec 2021 22:16:52 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Tyler Wear <quic_twear@quicinc.com>
CC:     Yonghong Song <yhs@fb.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
Subject: Re: [PATCH] Bpf Helper Function BPF_FUNC_skb_change_dsfield
Message-ID: <20211221061652.n4f47xh67uxqq5p4@kafai-mbp.dhcp.thefacebook.com>
References: <20211220204034.24443-1-quic_twear@quicinc.com>
 <41e6f9da-a375-3e72-aed3-f3b76b134d9b@fb.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <41e6f9da-a375-3e72-aed3-f3b76b134d9b@fb.com>
X-ClientProxiedBy: MW4P220CA0020.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:303:115::25) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c062c64b-2420-4bce-20ff-08d9c4497cb5
X-MS-TrafficTypeDiagnostic: SN6PR1501MB2000:EE_
X-Microsoft-Antispam-PRVS: <SN6PR1501MB2000F98F9FC9CEC4EA8A825BD57C9@SN6PR1501MB2000.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WUKOWSOjoeRxWawLBc5ErGixGbStoGtiCbP6ZAxhcUH2I7g0FEZ8179ggGLRL4imJFhGfSgosgIMZKRV5viqgV0ko/l1omQykvcYbok6WrU8taGGg4HAVyC8BgPFMUBltsST34nAuF/pAp8+XZWBm83tbbzkxXCnr6sqCoBLICbTVzM78tP6Lajb3T1ivZWX9twsMPY0U4C/Yxj0ZnVFpAJVh8kjfYZn/fYHWJSnrEMAKp0hLy/4gaR5Zb1EXiJUPug47DZT7Wi4sMPO5uwsYwimnA6ZUcqOFb5DogrNGpsCvgo5HbP1QsHMYTcPuFcy8Q+02TESrWUJ5BoTM1XZ8iICuq/Rw8Ht+Ko/t+DL2ZyP53+Ozxh8LZXS2xuZkFWkhupZUX27cU62zxcoZxArj8QGkzByCJrOcAW39RBhCTAfQJEM3SOhLYgBOygypTDnc+nJqQas64Vnn+8xg8iFbRk0ZiJ/WQu3HmIiVczCy2Iuh9zhdpQf/brY/PJ+O7/Xj7c3KmudthgTBa/lr6+4OukbyZUwCXi3Gcgaq5KlqmSBDnnJV1pm7Xdc95Ac6roKnq5LQhpj7DA49V88nAaCIAALmZVozuFvokHHmhO9G5kr/aLc7rEn4DgZRL64X9Z1sYhoM+F5Pg7BtqW51I6RPg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(5660300002)(6506007)(53546011)(86362001)(66476007)(4326008)(6666004)(66946007)(1076003)(6512007)(66556008)(8936002)(38100700002)(6486002)(508600001)(316002)(2906002)(9686003)(52116002)(8676002)(6916009);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aDYnFtRopclGJWzvBSDw2cGugRrUKQaIpEuyWh7puM0c4qEDg6jdJaGzdykE?=
 =?us-ascii?Q?qLYJO5SGl8wc8BpI3OcmdjJMkqqtnB/nh6J6NQD5ywaBsU5b36nLfhDTxJWg?=
 =?us-ascii?Q?gX7CDHfvjXP5egz+cYbO83ADxxY4T0jACFmBJ/vMGxuwi9IC9r/AHRIE/KHs?=
 =?us-ascii?Q?7LE0zAi0E4xHgExzdzJ4HI9siFUeouOXPQb9CFhbNbKaN7JYfbwK9EfHlEx/?=
 =?us-ascii?Q?VlHJySpjJR5TEvf8/nokOhYTbuxG3Y1u0C0CcIuzP11OUeRUk+tO5DY4kBdc?=
 =?us-ascii?Q?bOK71GiY3E5lrY4+1p/+Twj58z/nlmrFVDxqK2ATIu4rw5KZ58qxHVI1KE7v?=
 =?us-ascii?Q?RfZ4oV3BF8lMWXz0DlgD2o+zT4VILKjMkn1qjL3WE68QyGTSqUr7Eg5F1PvC?=
 =?us-ascii?Q?/+4x8gFW8+LY0A6hYYfqSfoFFCLprpMZrWZy+MZHwN3Wgw8ardoW8o9VgOtK?=
 =?us-ascii?Q?EhsP+ex6tn6R2aKYccdVJaPUu3t3I5Db2J0brnCeXrZRiW82t9O6D+ey0tK7?=
 =?us-ascii?Q?3LDuRsYz1mjSsglAm7/X0PvLgPbv0dd3Om/UshoNm0UedP6u8/y1FUH6ectQ?=
 =?us-ascii?Q?IEco1octwaACGmiIXqnmOeltnJQ9h731N2a9Ah8UmQOvPyjkWkmWHY5O+8cP?=
 =?us-ascii?Q?dxqLfMNxecJ/4bED81urWuYSXKAs3VTrHL2PW12/uLvS73yGQ5qTEemlAw4s?=
 =?us-ascii?Q?XNykjCE+g2FOvVhYp2wQNW1ecfGIqTldUDox5NiRXATON7IgHZvcAcKIf2kC?=
 =?us-ascii?Q?/mar4tU1pzHAg3W9sS5lrNnKbp4w4bbdLh25s6T5d0HWEmMKEoHllJ8O76Wv?=
 =?us-ascii?Q?3GC6TGbWCCGLAI5Kny5npa+psvKJOQz/n9Xy49pGHY36Z2u6fXAH9Fel1NEZ?=
 =?us-ascii?Q?X7mwr881LX6OFI5E4Ar33kVUODP0hGYfa8+G1tTAPDyTkZDf7jfUrUEpcbOp?=
 =?us-ascii?Q?TJzKtgtWGtMJXmNViCMI2PLFOIVck6yifveInu24lo31AMRJfk530ls+wd2K?=
 =?us-ascii?Q?kOIoaFR41g438Kz5mgAlpTqxa5tmDbReY6wuVV4kXYomfTYF7MPVBNe8vKeX?=
 =?us-ascii?Q?Qq31o5PujNPYOyKIWQLACzq/j+wl/1OwQe6abCXXjGxTojGfTmwErwHb4kDN?=
 =?us-ascii?Q?YHxmxDwTSKwkk0U8yp9T/R48vPWPDJlnvXpqDkUNDTmycH1s0jRdQrqIEEQU?=
 =?us-ascii?Q?lFirIoj4VAbFIFbCYHypv+INlx41t84SV4TPUZaOFjjthnM6FUaLT1L3TZ5B?=
 =?us-ascii?Q?W2J0mawugPArhUsupgrZ5UOTkIPcKpsAl9BR6V1GOr3wPAsDzynVKlsUH/mo?=
 =?us-ascii?Q?WJCj/xtqYwCPZpdUPFznXTA+UWkx+bWoI9CUVwRP6E8GAwlPkK+LpznuFlvJ?=
 =?us-ascii?Q?1e9DdoN5WMMGD8XTfBC2nO0ydWfaCF3nmfvXEfRr0VqayYU5WTuNKqlevIR+?=
 =?us-ascii?Q?PG/mYULj02hQlwbP+zprr+8ohc5TN7aBG3O8UOjZ2KaX0SYNFUIQfBlJLlGr?=
 =?us-ascii?Q?QDcoyYdk5Eo5hFPVjUOFcnMT8JchBy3dVItI2Z2SG+wQxs7e1s5ADvN40fdA?=
 =?us-ascii?Q?wEfWXf6kHuRsLEgiErMxxlqqYup+vsepyKGagxvT?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c062c64b-2420-4bce-20ff-08d9c4497cb5
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Dec 2021 06:16:55.5698
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hpfrtS8aTxI62LWL04dfo6wZ6gxHx0naErRora3Hu9ST6pLahAml8TkOTMKIq16f
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR1501MB2000
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: nuyWi-9saem9cDxYhdVyCJo-2T2F2I4t
X-Proofpoint-GUID: nuyWi-9saem9cDxYhdVyCJo-2T2F2I4t
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-21_02,2021-12-21_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 clxscore=1011
 phishscore=0 priorityscore=1501 bulkscore=0 mlxlogscore=999
 impostorscore=0 mlxscore=0 adultscore=0 malwarescore=0 lowpriorityscore=0
 spamscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112210026
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 20, 2021 at 07:18:42PM -0800, Yonghong Song wrote:
> 
> 
> On 12/20/21 12:40 PM, Tyler Wear wrote:
> > New bpf helper function BPF_FUNC_skb_change_dsfield
> > "int bpf_skb_change_dsfield(struct sk_buff *skb, u8 mask, u8 value)".
> > BPF_PROG_TYPE_CGROUP_SKB typed bpf_prog which currently can
> > be attached to the ingress and egress path. The helper is needed
> > because this type of bpf_prog cannot modify the skb directly.
> > 
> > Used by a bpf_prog to specify DS field values on egress or
> > ingress.
> 
> Maybe you can expand a little bit here for your use case?
> I know DS field might help but a description of your actual
> use case will make adding this helper more compelling.
+1.  More details on the use case is needed.
Also, having an individual helper for each particular header field
is too specific.

For egress, there is bpf_setsockopt() for IP_TOS and IPV6_TCLASS
and it can be called in other cgroup hooks. e.g.
BPF_PROG_TYPE_SOCK_OPS during tcp ESTABLISHED event.
There is an example in tools/testing/selftests/bpf/progs/test_tcpbpf_kern.c.
Is it enough for egress?
