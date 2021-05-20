Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9CD2389DDA
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 08:27:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230284AbhETG2e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 02:28:34 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:16276 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229534AbhETG2d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 02:28:33 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14K695nh025565;
        Wed, 19 May 2021 23:26:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=k1y37GS8jMTbWqaQVpjxqs16vOj1deH+SyjSuCpgpcM=;
 b=Zl9e+YjZ6IbjclH+zquesms1IR4nqAVAtQbcJBZTHaAIfChv6V7iLB1KPluZXQPgU6QG
 /rBlZp6NOFnAqpBQrR2BFHKmli1Lw0FqaeN0DpYS+dp3ejjq7Htqggd8FtqIUmVdnNwe
 GEhtLM8iLryuNFjhWpvWuDXUUyRpMikfoNQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 38n979jqr4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 19 May 2021 23:26:54 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 19 May 2021 23:26:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cH5nLHCUoo6hJqiw7UYYxFLijP2FODsfV5mlKdSnQyRdyzmaJJtBr3y1/PRMNZnzdDTNTnscESBKTpYMVwsW9d/NGKXHaqbf/bpE0lB3WGDNXN+ut4zdqU8/yqmMbgZ3DS0J/iokG/x4EIF0zqHUPPoackWjTPXTFPurgnpfVv8vZzbW3MrqIHIR+QzkpXixmDUCXd0pfMDUbjB55v3O0ykWLwrgtSPSIWsfTjAKfF3c4IiiyRCPqUxnQ53uNhQBWl0opG4KUbgOf3WiXrPb2liUEU4BU1c5fanNF0Kc2gxmh2ywMnBbAo+pESQSKzmerMLd0u1rcl5+VFYaQByzEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k1y37GS8jMTbWqaQVpjxqs16vOj1deH+SyjSuCpgpcM=;
 b=HodBQ329ZPwqyJbg3sRXEKe8BFdzSeUwqPSdQO1H9QQ+vQqGRTzMG6QX5v8NFLJOK+2u5GRapVjOYC9gBXf4jmCSUOayPUIqvTzTyPqKhBdxYrd3hZR/b3f6dRB+baR+xWj00RefGEXdZ2DbR7hoi+U4p1pODac0Z54kY7hFGs/NgRM1+Usn+IsjfV2RFR/QxikM3sOAsgWhjlddkPyGsB7PE25qRgIPAgsBJsyeMiYx62lPx++bbgcBWyqxaFnmgU9b8W+R5dXOTugjTy9HQTOzQCYVtHyDvMdBdfFwC40/E/VKZfiTPKlw/pDNJLf2EOVqBDov8gEEjGTDBAP3GQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: amazon.co.jp; dkim=none (message not signed)
 header.d=none;amazon.co.jp; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2455.namprd15.prod.outlook.com (2603:10b6:a02:90::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.27; Thu, 20 May
 2021 06:26:52 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::718a:4142:4c92:732f]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::718a:4142:4c92:732f%6]) with mapi id 15.20.4129.034; Thu, 20 May 2021
 06:26:52 +0000
Date:   Wed, 19 May 2021 23:26:48 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 bpf-next 03/11] tcp: Keep TCP_CLOSE sockets in the
 reuseport group.
Message-ID: <20210520062648.ejqufb6m5wr6z7k2@kafai-mbp.dhcp.thefacebook.com>
References: <20210517002258.75019-1-kuniyu@amazon.co.jp>
 <20210517002258.75019-4-kuniyu@amazon.co.jp>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210517002258.75019-4-kuniyu@amazon.co.jp>
X-Originating-IP: [2620:10d:c090:400::5:1f3d]
X-ClientProxiedBy: MW4PR03CA0260.namprd03.prod.outlook.com
 (2603:10b6:303:b4::25) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:1f3d) by MW4PR03CA0260.namprd03.prod.outlook.com (2603:10b6:303:b4::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25 via Frontend Transport; Thu, 20 May 2021 06:26:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cce4ff6a-7fcc-40fe-8039-08d91b58416c
X-MS-TrafficTypeDiagnostic: BYAPR15MB2455:
X-Microsoft-Antispam-PRVS: <BYAPR15MB245561528FBB70C7BD48A3C3D52A9@BYAPR15MB2455.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AuhJ73OfKn97gmOxRt5se0eN+thtrBJuBdZtOJ2R2MYb2BoNHf/BfcjXt3R2UtjmDg0/i21rwQymBHpZFwAC0yCy39Ltryt5RpzO904UJ25XfocLbXORsagpkyy5L4p0Uj6Oh+0Q4B5jFkkZiMzOmvnSrczfbcJvJIskE4KJmLOzb8mtqKSM2kb2vD2F4gbQtZBcVvqCn9QsrXlaM9KOrtJHlmLOCaQbHxAU7vDT+EtLG82lCl9wUjUtbgDpPdbfJWl/byBxYxUwfCbV9lan0MuwlZUtXhciTbuzvXYxaSscpjbOw6EyWQf4UPVARkx8Ez5BzYbu+L3Ek9HkybzeqDMKnaxR5Yd0aK1NFpN8XJuVfkfMoq5V0j1oreS8mcjp9XGUswcrX9aso4lGHWDxhr7AbBc3bpBk1ze/t0Jx+S6/e/GKY9pqYw+KiCc0QxAQ1u+MS2RQCzBX6HFgzsJe5hcddQugmFMYUVv4tSwSoNf3knA6sc83qJt/28yDRHN4rzYZoyXY3OP/u0EdZh+msCMSXIrhgAhWmREo4x6W3Rza0hpCIEHBByMcjJh0AH4XydG2Vo+SLZkZKNoyfTGygwRKEW6y+SSZAhhdx0ohXaA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(39860400002)(366004)(346002)(136003)(83380400001)(2906002)(316002)(6916009)(38100700002)(54906003)(66946007)(7416002)(66556008)(66476007)(55016002)(7696005)(52116002)(8936002)(86362001)(1076003)(6506007)(186003)(16526019)(9686003)(4326008)(8676002)(5660300002)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: qwHDB3+Vzw5EJPibqdoJDvlQ+GxZS87E3lLuusWaHFmx16RM+4GWTm3xRTmWMJCguwJsRCvd155+p1gWvRawSpVin1eVSfBBUUQuqJN+cNq88cIkoc7KjdgqWn5/UJBko9+q4TeimaC0b2ph7LY+9hVA4THrehjmBx3bYkNnORvItBTF9E/jJQ0XPYtAYuw5uXjhQIuc4/BDbN1KMjOzxuTBc5Hye3hxBeFH4kfkE2zOoWN021RsPnFQKwTnUUqxQD7Nqo7YBfbXKVFN6zhl9pIKfT+4LXl8aZU2r4CYaLl/RffUFq7uJASYweWlMflqxo5FcBgUt1cPS/eqkxhzlbzFQpcsfnhjNFUlFQyPVmwe2nKf+PlUwed4FYzDa/U53nJIzwJqrbSRBorngMhRmsgq24NAioACLK7JS0mOSBP4rUxGph4wyBsORkR0ZujIgU/jX3rD28gTbwAQpCAUEYFbnIBoCqqfym057ZYl1myc5cmV6FZCwsdPjTd8GUe/hwilLMayJBcML1Q1ntsKWqWLF8T6NRjVgAZZOZ69mQEbXnkphOJ20MknEy2Iv9Pz768IYIPHh8I0wi1C+fxyObjrsQ8YYGUSULdEGX54fVNSIH1bfSNa6Ik59NjVVuvVlzm5KmW0Kb30H3ygIfkX6MD1aeWPhi9oVhws0VDo1TgWosXG4SFEZ7dbCmxuXlTXM86WwOA0okspAXzVs+bad1co7h0edBLUKaFuzoMKS9WRg2C7aEP4RR75SEt6p4I+lawr1GgJv/bjuKs9xxVDMQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: cce4ff6a-7fcc-40fe-8039-08d91b58416c
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2021 06:26:52.1215
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2cpfhkoFr3hmzgmRCCYUANzF6x0AMi1EOhovyyasmFfUeq+IHV4SzRMxepRO11y8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2455
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: FlVLX34j4wOv0Y2GhGlRMeVVz4vvtI3_
X-Proofpoint-GUID: FlVLX34j4wOv0Y2GhGlRMeVVz4vvtI3_
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-19_10:2021-05-19,2021-05-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 phishscore=0
 mlxlogscore=915 impostorscore=0 lowpriorityscore=0 adultscore=0
 malwarescore=0 suspectscore=0 clxscore=1015 priorityscore=1501 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105200051
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 17, 2021 at 09:22:50AM +0900, Kuniyuki Iwashima wrote:

> +static int reuseport_resurrect(struct sock *sk, struct sock_reuseport *old_reuse,
> +			       struct sock_reuseport *reuse, bool bind_inany)
> +{
> +	if (old_reuse == reuse) {
> +		/* If sk was in the same reuseport group, just pop sk out of
> +		 * the closed section and push sk into the listening section.
> +		 */
> +		__reuseport_detach_closed_sock(sk, old_reuse);
> +		__reuseport_add_sock(sk, old_reuse);
> +		return 0;
> +	}
> +
> +	if (!reuse) {
> +		/* In bind()/listen() path, we cannot carry over the eBPF prog
> +		 * for the shutdown()ed socket. In setsockopt() path, we should
> +		 * not change the eBPF prog of listening sockets by attaching a
> +		 * prog to the shutdown()ed socket. Thus, we will allocate a new
> +		 * reuseport group and detach sk from the old group.
> +		 */
For the reuseport_attach_prog() path, I think it needs to consider
the reuse->num_closed_socks != 0 case also and that should belong
to the resurrect case.  For example, when
sk_unhashed(sk) but sk->sk_reuseport == 0.
