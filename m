Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA49D3D6D7A
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 06:32:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234867AbhG0Ecj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 00:32:39 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:61544 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234841AbhG0Ech (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 00:32:37 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 16R4OgbK021012;
        Mon, 26 Jul 2021 21:32:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=I6DKU7DtMgVhds/Ly5bhJM6nK62/oK9EbPNn2pTGuoA=;
 b=B0Wg4z+va3SJI6kP/OZMjRmrOuVyesYQcHMA8ygwUAtHfKJQLLAaJKlUlcj5VhpY72Zu
 i5jX0TTDy4XAvOAVzy9bVhzQyRiDRYeGnR1atXb+BXChccarnsOVfTI/DmvZQsvoIrbd
 bLYyYa665WW1Z2DPjQNPfqb3zo32q+AON9o= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 3a23572evr-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 26 Jul 2021 21:32:22 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 26 Jul 2021 21:32:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UCd2gnIoQ3g7L1vXRj1mQ3xB6wKk9kojv0qa1YnWeHrO8dhqgEpZpqKuY+nBuGkXQ9y80JnMfazgBVJzRHfNIlmc5MUF3U/DcQnKX1IiKJeFd3kzhazT6SfxajvP4WY5SNIgxWyeDZlagOMyH5uLN2FIQlarfN8Wrdg1pvQNqSXJuOGOpEUMm6HC4zGLTlngL4gTt5PB2mK+SEn7lzghwHAW0amhFiIf5XZBk9E3wOB8CbgBmcHyiiFsIVdUm0PmUP6/elBgkuy1VTcAA3jfQ47zP6L71jAxjI7b25LHz5FtwEbqN2FNcUC0nt0R3Lq5dUWYh4URo2FGep8XgYZHXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I6DKU7DtMgVhds/Ly5bhJM6nK62/oK9EbPNn2pTGuoA=;
 b=oahcp4Ss/SMSurnWbQFJTdZOFcmCBh+OcJTljkfv9K7lIaW4yEZ0pVQoNwhxTYonEOrAupObOlJi8vc2ZBjNmBOl2ig2v5kW0TCTj/8I3ghhhwFcwNnvlQa7ycjwWs9fZT0TMhPM76ys9xGVSOd4GlGTI7O8O2poOYcsd4W9S5tvdh7GHQu/XjCDnsWLEeb64catCKSSR8c6CzbUhrfJPo1sPaLDDyWu2TtcuQWmfDfVnlwtiRkOXRsnhdNVEvvNP4hz/VFl8FkZe9z4uiXiHlzYGLl0lJNGtTs8uGJDKASjWl5069UMGVFxtNwoMQ/yEoN3zyR3xQXMgL8UHZtQFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SN7PR15MB4174.namprd15.prod.outlook.com (2603:10b6:806:101::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.25; Tue, 27 Jul
 2021 04:32:07 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::1b5:fa51:a2b9:28f]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::1b5:fa51:a2b9:28f%9]) with mapi id 15.20.4352.031; Tue, 27 Jul 2021
 04:32:07 +0000
Date:   Mon, 26 Jul 2021 21:32:05 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     John Fastabend <john.fastabend@gmail.com>
CC:     <jakub@cloudflare.com>, <daniel@iogearbox.net>,
        <xiyou.wangcong@gmail.com>, <alexei.starovoitov@gmail.com>,
        <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf v2 3/3] bpf, sockmap: fix memleak on ingress msg
 enqueue
Message-ID: <20210727043205.24ldyis5g5yvg4mm@kafai-mbp.dhcp.thefacebook.com>
References: <20210726165304.1443836-1-john.fastabend@gmail.com>
 <20210726165304.1443836-4-john.fastabend@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210726165304.1443836-4-john.fastabend@gmail.com>
X-ClientProxiedBy: SJ0PR03CA0202.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::27) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:5a67) by SJ0PR03CA0202.namprd03.prod.outlook.com (2603:10b6:a03:2ef::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.17 via Frontend Transport; Tue, 27 Jul 2021 04:32:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bc61986d-1c65-44ab-9e45-08d950b77df0
X-MS-TrafficTypeDiagnostic: SN7PR15MB4174:
X-Microsoft-Antispam-PRVS: <SN7PR15MB41749E14E2E6EEEC8714302ED5E99@SN7PR15MB4174.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:586;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /BYfcft+CktPqI62Kd2jtu/GhvAeUoJgm1k+6Ou/Fb/vAQ+srWGVutRwkKH+E9rq8Azt/Trd05KnmwRqeqmA4q1HOv2udlI1l/jYTZjpgdkz6oEUwl/NlgpQJHEPmD71xPWLxjxuC4nJB1f/YMyyRGVxBfbD8q8gtgopae0xGfK5A4iLSMFRXPSr9glA2Jhx6GtqTbdTIZpcoZrqqFAAicpEmSkUxh+b4MNC7JCEVge4IZEuuI6u1gCavP+DFbWWKzLzbcFYWAfah5S5yh4Rf1mUs4Ce8s24eP5rAGXYdkDO1byYg0ZNVF88MCYneF1d0SNb+tb4XDsy3diPDXXuLSc/2k8BvA+hmK0CcMGVuy5UP9r0Pqe4rPNerTSNsXZAz46S5piP2g91K8bI5Ocr3UfOUNt0fLXXV8Z15qPt0MpzdlMfz29qBChGhwWNlLiFiSwa5pAQbTn2B+dHqZMzfNADTA+5QVUxrKHwnGxOlOTio/s55UmqH+9GitabJzRdXwNbQ2M3srF97S8OKiMO7RCtZ6kJMreHkOdqsRAD2zMlqmATQMW51KE142K5Mg4ov8XI1UIg4VlMvx2mmLyONmOYU2ekPoDQ8jk3qAJk0fNPypYF4AiObsfbSvriT3/yuBsi76pQWrcRkL64t9MAYQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(1076003)(55016002)(186003)(86362001)(508600001)(316002)(38100700002)(6916009)(8676002)(5660300002)(8936002)(7696005)(52116002)(9686003)(66476007)(66556008)(6506007)(66946007)(4744005)(4326008)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JOjDhFqRagq56abPgE67gnfgcmiGtbOz1ErC6kkmsb0JZqbejZRK907fV6v4?=
 =?us-ascii?Q?SFSQzf+NJP4vOvSdvV/wnfTTHaeWWB4duRfW39R1IiqAaEavSO8yiutban2Z?=
 =?us-ascii?Q?sZJUZNLrtwFyxXIurjlUfNlu59tJXrzQQkvEPR7Ldif4uk90SKa3C0IX0AHu?=
 =?us-ascii?Q?wffj3sGAzpySJUR8uIpoBSsZ3yKKK37nToUYV3su5zx9tz2CLx/J1kCWxJGz?=
 =?us-ascii?Q?dI2qD3KW6gpvC14qIG5MLX20lTl/8yB/suEV2vf0nd2iBPlFJNpWRPU3/GLH?=
 =?us-ascii?Q?WB9lXfuA0+ioMVwqIBCOcRinLbIHlhSJnK1E1DjI/2YmvwkzDVKiyqRdiK/9?=
 =?us-ascii?Q?ko/e8ruOzJSc2T8QrvdK9mlXUtCE7FzT/8+M76hj59legW4pXvSeUCy0uxWh?=
 =?us-ascii?Q?d0xGrMYbn8sEr5jXQelc6b4C7pvAFjjgrAuUBVqzXTdOPnS9aYekq9slPOyr?=
 =?us-ascii?Q?tFFfbQy9r7Kc9NM4/9ij9M4egF1ebkXw7qPwSlx1u9d7qsdJDuMfaiviXIE5?=
 =?us-ascii?Q?XhBk9TwyP2bcCft9YmpYB4du4WhW9SQyq/uoXPJn9gZQKfPKSyY10dmtJRXQ?=
 =?us-ascii?Q?yEpp1AFJ9PxGsdAbRv1BFiCN/9gnP6F9Gurmu0pdBxJDUDch0XmdlD5IPWdm?=
 =?us-ascii?Q?xoYfxaaPpDtxYw8Ij2T+QCRXk7/zypvz2jSiJrJkB+VO3an2vzYMBnxyHJGh?=
 =?us-ascii?Q?r7DwFwjJ8Li7MIaT92vOwbT84bSSIn6WsgpswksgYy9GSNeD1zWm0n6u+jOY?=
 =?us-ascii?Q?A9zv0Tnhc1hQqd2N/XGlOfcki1BuOnJ8kKWkfzAzS7JFYdRL917vZMRK8DWM?=
 =?us-ascii?Q?z1dcctPmZGs/O8LXIboQYnHR3V5dKjAN7krC4pUIW9ox+OtcKgQOavXYfZ6Y?=
 =?us-ascii?Q?jFlELkl/sN4+0spvIEt3DFcnBuhU8o+Zuub+KRQAJRAM1LWYJr/Bx8A/SHcC?=
 =?us-ascii?Q?27J0qlkzJ3y+PRrFWA8C32Sa0QlxO1RT6gZSYHaosnKQ2i0T4piDg0bnwhRv?=
 =?us-ascii?Q?RuzEn3RPZP/6TrxvdLhXk+5Bm9sQ73XAb5irrtXrlWN4F5mbVsPH8M7fAol2?=
 =?us-ascii?Q?dMOGn+zgu5robf0l7m5rnQ79pWsWpJGjLVJatPSTyjOqjQ4VkpwFeaGn65IK?=
 =?us-ascii?Q?0WvroLwOnw02MLcCg9w18w7PvUWBArlkwO5AwvX2jbr17zmIpkY9GpEDErA7?=
 =?us-ascii?Q?kSt+/K7uKt2T+wVN15wBWSa0A+78szDzXa09eRPMzXyIQuwp0Sq7nvdz9/+A?=
 =?us-ascii?Q?/mfoBy0PluDwO45IpmmEKyUcabyykOaBqnzN2CkqiUOHa27ojD5h86I8D1b+?=
 =?us-ascii?Q?0wO5C/IU5mP8nIXp04lhmGKHrlQzxna7V0PLGpdZbPxrQw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bc61986d-1c65-44ab-9e45-08d950b77df0
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2021 04:32:07.4502
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: okuCsYI0hcmWh2D/KWoXSLLdtm2tLNAUp/pMS3/PJ6b6/JJRwQqgoOEvPGGK68X2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR15MB4174
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: mZS-eguFJ6pGa8D0034CQXhmkQOL65ZX
X-Proofpoint-ORIG-GUID: mZS-eguFJ6pGa8D0034CQXhmkQOL65ZX
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-27_03:2021-07-26,2021-07-27 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 adultscore=0 phishscore=0 lowpriorityscore=0 spamscore=0 mlxlogscore=745
 mlxscore=0 impostorscore=0 clxscore=1015 bulkscore=0 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107270024
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 26, 2021 at 09:53:04AM -0700, John Fastabend wrote:
> --- a/include/linux/skmsg.h
> +++ b/include/linux/skmsg.h
> @@ -285,11 +285,45 @@ static inline struct sk_psock *sk_psock(const struct sock *sk)
>  	return rcu_dereference_sk_user_data(sk);
>  }
>  
> +static inline void sk_psock_set_state(struct sk_psock *psock,
> +				      enum sk_psock_state_bits bit)
> +{
> +	set_bit(bit, &psock->state);
> +}
> +
> +static inline void sk_psock_clear_state(struct sk_psock *psock,
> +					enum sk_psock_state_bits bit)
> +{
> +	clear_bit(bit, &psock->state);
> +}
> +
> +static inline bool sk_psock_test_state(const struct sk_psock *psock,
> +				       enum sk_psock_state_bits bit)
> +{
> +	return test_bit(bit, &psock->state);
> +}
> +
> +static void sock_drop(struct sock *sk, struct sk_buff *skb)
inline

> +{
> +	sk_drops_add(sk, skb);
> +	kfree_skb(skb);
> +}
> +
