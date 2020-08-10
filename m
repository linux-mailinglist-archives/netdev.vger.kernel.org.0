Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D3B8240C7A
	for <lists+netdev@lfdr.de>; Mon, 10 Aug 2020 19:57:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728018AbgHJR46 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Aug 2020 13:56:58 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:18200 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726820AbgHJR46 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Aug 2020 13:56:58 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07AHswQM025142;
        Mon, 10 Aug 2020 10:56:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=CnUH8wFbRH3D+x8tqc+88oybqYHc36iotQkG9C3ikb0=;
 b=QzEP54XzoX92uHMBw5QAlHt2bZtjeFXUK+02D7Ojdon20PtcDPLsKecHN0MsLNZFZU1y
 TGuqbL30iRaeY+J/es9tNXKqTSI1yvEY4bja4ADt1FUCREdU3ILct49kT0PSpkiy0o6O
 1pFYzwSgxR+M+EBwZgfp3pbWNhFcynrJp0Y= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 32ssjk8e0r-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 10 Aug 2020 10:56:36 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 10 Aug 2020 10:56:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aFsU39TyngPX0BrUj+rxedqHWYw1ySC+mV3pbS+Y0aTsjug/WmqhWuP/7Of0V9osLMFowD6DbJP2exF/vF3eh5I/eSmxiDsd85kfvKG+Cp8CCN8n5LnyMojqHRqveSP1eiBZeK/55GIYm4yDOZNXzXqCZ4lehiVqFP+HgeJMqc45NqLd3t3oh9fMM/O2fGyZNL5kYk4v4KF29HIqlul3fwtLcwiFiZR2sa9/MitPyYqkSSxh/3TU469BkZW2+fuzFMS9RaGJbB01sLvgpH99Z8yrzHgAOd2r2CdcKnAQwoFfZR0wCw1OtIQyXokilktktTpVYPmVIdb7wZ12RCNWaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CnUH8wFbRH3D+x8tqc+88oybqYHc36iotQkG9C3ikb0=;
 b=gZMhdLKe61H5LdYAlpa+ZgUdcu71luHB7ntAbtKs2PgaLW9LxmqCDba4HRYkqxDgr3fY+nQa9/Ow4frMjcjo+v8JiJAdASManVjo2h/ZzRlKdW8KWsLpEhP7r97oKox+uZuI0UFpWydx/p7YKvlG+4xt10aI1yOaAQgQaIQ+A1WDVeVtqucyxj24+Yh7F7yX5/Vy+SB+QHvaGbe+eXDbNlQXmxcK7NBpA3g+8mQ2RE8bE2NLsJCkhUucZHJKPWwGivivK8Nzry9k05QpKrtOsSyKwN2Z3L8CBTfWOVQR20mmMMiOcQTmDedvHD5alTdrNIl0B3bDFamaCMLAdlnvRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CnUH8wFbRH3D+x8tqc+88oybqYHc36iotQkG9C3ikb0=;
 b=Jiqk9UNVG8L3SeMfQTbokmxerh5A6L4AYXG8v+92UUrhNn/FSBl+gC7oZdg54RrdjepYacpOAs+MDmLB6SUdxNyj6sSiBMYW+XH65GjNuyb2c508eFA9T5fbtBYGVdwA6pyMbzeW62jKckTfTA6JK0mW0LhIpSrbPAYXtFNQ9so=
Authentication-Results: vivo.com; dkim=none (message not signed)
 header.d=none;vivo.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB3301.namprd15.prod.outlook.com (2603:10b6:a03:101::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.19; Mon, 10 Aug
 2020 17:56:20 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::d489:8f7f:614e:1b99]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::d489:8f7f:614e:1b99%7]) with mapi id 15.20.3261.024; Mon, 10 Aug 2020
 17:56:20 +0000
Date:   Mon, 10 Aug 2020 10:56:14 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Jiang Yu <jyu.jiang@vivo.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        zhanglin <zhang.lin16@zte.com.cn>,
        Kees Cook <keescook@chromium.org>,
        Andrey Ignatov <rdna@fb.com>,
        Quentin Monnet <quentin@isovalent.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bpf@vger.kernel.org>, <opensource.kernel@vivo.com>
Subject: Re: [PATCH] bpf: Add bpf_skb_get_sock_comm() helper
Message-ID: <20200810175529.qdsbziyoo6myw2dr@kafai-mbp.dhcp.thefacebook.com>
References: <20200810131014.12057-1-jyu.jiang@vivo.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200810131014.12057-1-jyu.jiang@vivo.com>
X-ClientProxiedBy: BYAPR06CA0017.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::30) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:458c) by BYAPR06CA0017.namprd06.prod.outlook.com (2603:10b6:a03:d4::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.19 via Frontend Transport; Mon, 10 Aug 2020 17:56:20 +0000
X-Originating-IP: [2620:10d:c090:400::5:458c]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b1879d0e-368a-437f-b12e-08d83d56b026
X-MS-TrafficTypeDiagnostic: BYAPR15MB3301:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB330177B58F4AB38DC3A629F4D5440@BYAPR15MB3301.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: L+0j7ybD4OBBmOnpwB/Dx+m1zVjnNZThkj78JVaFgyazH4xvrbcNJbA/QxMuezOdIAhYRfpBneqVWpw0xJ+lTKqQAKAuhlSkzKj4nCD8UhdFFkGQrY92XlXBKhzDaWdU2F0FPcbsDKaypa1yaPXbSTHH9HTnR2YWcLpqSf/QF/kDzXaiYJ2TSd0BbZFs3ruILAI9OhAG2Ba/R01RAP2H2L9ffFFLR4j07ajONXtQI60s49U5YXp687kJeYUSF54Zp0G1OwwkhBlWF6Ca21QLSagULRRRYr6S+j8jW87j3PiRhsmHc7LCAUI4lhYaB2azVIPF6OzBgQR+NCSn0EjQtg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(376002)(39860400002)(346002)(396003)(136003)(366004)(5660300002)(4326008)(55016002)(8676002)(6916009)(6506007)(186003)(86362001)(2906002)(16526019)(478600001)(7416002)(52116002)(7696005)(66556008)(83380400001)(66476007)(9686003)(8936002)(54906003)(66946007)(6666004)(316002)(1076003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: FSWSai3Av/zpWNzopHDWTFwyScCNNrpdDmpSh0wVCrRTaqNvOfrtMJMplV7H92XeOUwrXaGUyjLKacZmIqOcMGKxUGsq43T9f9vDCoa0Pshq7WEtClujUePbYO1ps60Dj+Y7Uktir/0B9ZCH/F8vyksKKLWbtXq8GcBa4vqEZiYCD6WRxK72pS1OGKX+jiTgXHuOT/7gXeUPtfnfT0j1jMqYxe+dipR8ejh1gdkDXfLX4moAr77mKY7ZhUV5YChA2Z0CNLDeHc6M9uheCOPS2zPNRCNjnkEGjjBR7i8Xck/ubLkEAX87P9TvokLb5gg5VhScmXwypKahR9C2E6//VeDe/q7u45uKCzFOz8XO1q+UX7SFFJvMI5Lx/XXm54cOzZYp2Aw9beL9IAPRqqUQTk0D+RLvro93dN3OmW/oaojsBwXe/kiJUPB4PntoL+cy+EGXHcD0GDz9qZvLm66IPXtbzdDkyPL6O4Xil5Kl+CWQdWgM24Orzlg7Dow+XeZTNuGVn8zSVJjjAPKdSmJRl3l2zHco2EPVtBqmZuLaZw4rOeNcJDeAdPsCrFIXzbPRJ6seMydCtJ2iQdX3rVEE09Jad2sYCYxmsowmeNI/GeGCICv56yAJxCeGbmu3RY6YIKwmU0sAFZCMM36mE6GBRU+jzBvIGKb9d8I2BTZLsKw=
X-MS-Exchange-CrossTenant-Network-Message-Id: b1879d0e-368a-437f-b12e-08d83d56b026
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2020 17:56:20.7321
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wcwQKB9ataZsoRA//wUtFANEb+rPRIN8KG6+xIDaryD71o8JkOMDjuH/U3ILPeA0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3301
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-10_15:2020-08-06,2020-08-10 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1011
 phishscore=0 suspectscore=1 bulkscore=0 adultscore=0 priorityscore=1501
 malwarescore=0 lowpriorityscore=0 impostorscore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008100126
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 10, 2020 at 06:09:48AM -0700, Jiang Yu wrote:
> skb distinguished by uid can only recorded to user who consume them.
> in many case, skb should been recorded more specific to process who
> consume them. E.g, the unexpected large data traffic of illegal process
> in metered network.
> 
> this helper is used in tracing task comm of the sock to which a skb
> belongs.
> 
> Signed-off-by: Jiang Yu <jyu.jiang@vivo.com>
> ---
>  include/net/sock.h             |  1 +
>  include/uapi/linux/bpf.h       |  1 +
>  net/core/filter.c              | 32 ++++++++++++++++++++++++++++++++
>  net/core/sock.c                | 20 ++++++++++++++++++++
>  tools/include/uapi/linux/bpf.h |  1 +
>  5 files changed, 55 insertions(+)
> 
> diff --git a/include/net/sock.h b/include/net/sock.h
> index 064637d1ddf6..9c6e8e61940f 100644
> --- a/include/net/sock.h
> +++ b/include/net/sock.h
> @@ -519,6 +519,7 @@ struct sock {
>  #ifdef CONFIG_BPF_SYSCALL
>  	struct bpf_sk_storage __rcu	*sk_bpf_storage;
>  #endif
> +	char sk_task_com[TASK_COMM_LEN];
One possibility is to use the "sk_bpf_storage" member immediately above
instead of adding "sk_task_com[]".

It is an extensible sk storage for bpf.  There are examples in selftests,
e.g tools/testing/selftests/bpf/progs/udp_limits.c which creates sk storage
at socket creation time.  Another hook point option could be "connect()"
for tcp, i.e. "cgroup/connect[46]".

Search "BPF_MAP_TYPE_SK_STORAGE" under the selftests/bpf for other examples.

It seems there is already a "bpf_get_current_comm()" helper which
could be used to initialize the task comm string in the bpf sk storage.

btw, bpf-next is still closed.
