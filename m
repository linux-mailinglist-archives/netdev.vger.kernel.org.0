Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A60B327DDB8
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 03:24:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729617AbgI3BYf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 21:24:35 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:52170 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728149AbgI3BYf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 21:24:35 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08U1OIuo001534;
        Tue, 29 Sep 2020 18:24:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=W38YY2tbpZpbwA2nrMq5emzSn3m9ZM9HoByh0Oy2Apc=;
 b=elG0t9JeKg9tl/kEXJmC+XCuVN67Bth3nmHrDQmiYu0SzBAp4rLCzfLFr/UHgXwQ+btB
 heRi0DlzFE5vcIqF7lq3PXHiye/+tmVNbMK5L+0SU9q/UI++r/3uz8enVvJ5sIDiKZU5
 3L3ymQOZtPcL48Pv5B5ElXziRytV2mLfVjc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 33t3fhgfu0-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 29 Sep 2020 18:24:20 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 29 Sep 2020 18:24:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=it/cZrHMUwjfdb+sNDbZhktfiWikHuRdMoAX4ScCEa/YtC5JRUJkSiEXaMCE3hFgMKCcAqJ0D2UgZ7osoqd67ivERjPNKF598Er6TjPGUZF7/Koq8fdl2IHFOvOQgQh8d0FdGObsVCWmalKqTJjB1W3BWMeuab1O3w75IDFYtC+uiMUs72tbuy4x28fJCmliLG7phst9mRZS6uzxvOELKBbZL+SOU6/Qnvco2ZyoSofgMfb11XtH2fSTcH1Gixc+lXfZ6yadbEEuRbpzcfx4pIbz2+OHQ4vrf3nvEaS59rWo/FEPI+MW9f+FDnwsRY1P5ndVQU/mYSiDxO9R9vlLmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W38YY2tbpZpbwA2nrMq5emzSn3m9ZM9HoByh0Oy2Apc=;
 b=D0zW0xk1MiKXo1wrv/t98Rk3JpVxjDyaXEPW6DDyYKDpDtCW91O5Pdmi8z5zZGH5G1Q5H6yFj3Ifnx1z09ZovaI902jr/mi5QLo7gApsm7rw2N4q/D36Sl0IpcHOdVGTA1w6sWn/iZVKpcQK4cMCx+AnDT5Fnyx79DsSC0MqulD7dzKQUUNIzHjkIWk6gzu6YEooPJtdlgtyM6shbEXfhaGm8hDU/ubAG4t1OFUjXLjnDoki7Dc/9cLEchsKduci3zbMewKk/H39iF8dUeDraV4IPhWsys7fkZYBjFVs7AQlNS8zk7AQP3E63xf54u3bYwUZ9PLwNW9adnVLt9gjDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W38YY2tbpZpbwA2nrMq5emzSn3m9ZM9HoByh0Oy2Apc=;
 b=bYXh9wyYuMUS+tt3wxsJawohM+XixbwxExELLjw4nr4CoQpCvBceeYTlugHETVQ+VFkSRozXX0Qclu+aWeeXjOb9dXboSt5o3BslcQBHJDG2HYtWM38pJE5Ua7aeeXFv5H2Bxc4RQ7kaRCFzeJzmhvbUszhCVmHLroVQEQzu+vM=
Authentication-Results: iogearbox.net; dkim=none (message not signed)
 header.d=none;iogearbox.net; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB4085.namprd15.prod.outlook.com (2603:10b6:a02:bf::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.26; Wed, 30 Sep
 2020 01:24:13 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::c13c:fca9:5e04:9bfb]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::c13c:fca9:5e04:9bfb%3]) with mapi id 15.20.3412.029; Wed, 30 Sep 2020
 01:24:13 +0000
Date:   Tue, 29 Sep 2020 18:24:07 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
CC:     <ast@kernel.org>, <john.fastabend@gmail.com>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next v3 1/6] bpf: add classid helper only based on
 skb->sk
Message-ID: <20200930012407.cokrgx7lyxriwn7n@kafai-mbp.dhcp.thefacebook.com>
References: <cover.1601414174.git.daniel@iogearbox.net>
 <8fcdb28a1c5ee50dcac70414a7095cefe2305a7c.1601414174.git.daniel@iogearbox.net>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8fcdb28a1c5ee50dcac70414a7095cefe2305a7c.1601414174.git.daniel@iogearbox.net>
X-Originating-IP: [2620:10d:c090:400::5:f2d3]
X-ClientProxiedBy: CO2PR06CA0073.namprd06.prod.outlook.com
 (2603:10b6:104:3::31) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:f2d3) by CO2PR06CA0073.namprd06.prod.outlook.com (2603:10b6:104:3::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.14 via Frontend Transport; Wed, 30 Sep 2020 01:24:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5059e04b-52f6-4d1c-3aec-08d864df8a5e
X-MS-TrafficTypeDiagnostic: BYAPR15MB4085:
X-Microsoft-Antispam-PRVS: <BYAPR15MB4085AA34930878E88DC05434D5330@BYAPR15MB4085.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: luWKjNyojU8L3A5IoMKhy0zDrXG48ehUyEwj/TORp1UR4eSNpB0VDGnnLOTUlqm8lQtyNZx7wjRgeDNwOSVm2IJ/JttDzHC5N33irDHx7nHFxBddlSIpbdyziHDaqKdECukxYyyZtJJeq1U/7GnaU8f6stocmoHB/tzhxFvubXLTNsNcFibM/2olbeJVozVxMyWgVtosia8MeVkzpDedvIgl09WtfR4AFP8BAV90OZ1AaxcqHOiFbbL7WVNEC9+SmHz5qpo8H3HeGmT10vooX9BKI/5CIagEeeXezhIpv2qgl4hO/LmYNgOSGf3C7AviPoYkfN0JO5KMLohcbZkyTA48tOE1cWW+RtPmffKVa4a6ph01LEef3dXEPXc/DvMa
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(366004)(136003)(396003)(39860400002)(5660300002)(4744005)(6666004)(1076003)(8676002)(9686003)(4326008)(6916009)(8936002)(55016002)(6506007)(16526019)(316002)(2906002)(186003)(478600001)(66476007)(86362001)(66556008)(52116002)(7696005)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: LB8WCU2zcr/hP3RsNySOY7K0Do8U9WtVFhVoFFQLPlCh0d6foJ2ZhnDukUMogF2BeD40PtWrUE3eqpnELGGtTD0N6it7gv0PpE+sQdkHxUkhQcacqLTjqYtPx3j1saYTRZBXLIvvJcvikp03O/QEnu08ay6j4kLWRbe9kXfdBP1X31fik6by56Q+QLD8tE14TkMUpsJ9CAyQVCrHa9ozdp4LJO7EZRUwUKHYnsSNYxHZXIU8hbHOLibL6LHv5oaqXJx5HpHQsGrUWmOvxHqulhresEEoDB5Adt17MYxCDNmPHaWJLs/wiEefSfal75N+ZMsllILa4PdRDjonPtt/35eaCikrtbuoORs9ARy/gclEuzsxS2xf6jlS/Ht/2DJC7Y6+k1SIerSyHEoglaTTU53L//yTlzNgBxAtBIdIZ+KjxEqZ18d+ZzFky6KwWq5UqRGTZiXECroj6EEDYfvKt/W80QNqqTypWSLUDN7pn984lqCC+7hUkRwPWCQ1vp1pO+9hB4vg2uX2smHoUJFRN1X5s7v7bSRRY6Fr5iJymlG+DYAFhAqqxoyvHLRRns9yTjikqMfbWQ4C2KqQ7lTZVH63zS8jzrzHrBZXwb7a/J/Q/bC8Z91OhV/zKpK+57DtzTuKU3fc2OXq6mX/XTx/2+qcx8DX5gDJcwB2ZgutMXc=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5059e04b-52f6-4d1c-3aec-08d864df8a5e
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2020 01:24:13.7469
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k6g4pDyXM/THcTwdpcAil6fpYGHqn3dOQJKJUbcqbRW4NX40fP1Tq00d2nfzVcXe
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB4085
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-29_14:2020-09-29,2020-09-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 spamscore=0 mlxscore=0 malwarescore=0 bulkscore=0 lowpriorityscore=0
 phishscore=0 adultscore=0 clxscore=1015 priorityscore=1501 mlxlogscore=867
 suspectscore=1 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009300005
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 29, 2020 at 11:23:01PM +0200, Daniel Borkmann wrote:
> Similarly to 5a52ae4e32a6 ("bpf: Allow to retrieve cgroup v1 classid
> from v2 hooks"), add a helper to retrieve cgroup v1 classid solely
> based on the skb->sk, so it can be used as key as part of BPF map
> lookups out of tc from host ns, in particular given the skb->sk is
> retained these days when crossing net ns thanks to 9c4c325252c5
> ("skbuff: preserve sock reference when scrubbing the skb."). This
> is similar to bpf_skb_cgroup_id() which implements the same for v2.
> Kubernetes ecosystem is still operating on v1 however, hence net_cls
> needs to be used there until this can be dropped in with the v2
> helper of bpf_skb_cgroup_id().
Acked-by: Martin KaFai Lau <kafai@fb.com>
