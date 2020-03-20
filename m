Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4509418D784
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 19:43:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726902AbgCTSnQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 14:43:16 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:19442 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726801AbgCTSnQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 14:43:16 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02KISXL9025079;
        Fri, 20 Mar 2020 11:43:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=+IzP/3NuQCxXGx0jVuoDFNUrTIYhiGjvJECKwUltrJI=;
 b=hM9bhWxIeg0x2mjyJIz+eNQRw1HaoksqA0y4o6gSlVl0eOc9ZPVM+DjUeIOJadaWin49
 +spDgQAX1T3BevOe6BDIIWlOEugTADJWotBmhZnsEdsY4LydBcKVFTtdj7RCoR7vALC2
 4WgFfYdlWWPFOo6OuvI2/4ckV+WKUdjQVlE= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2yu9avygbw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 20 Mar 2020 11:43:02 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Fri, 20 Mar 2020 11:43:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HiAMGx0+TUONDQxNlSKsrXO+quXhR3BP6O1gWHW/QmGMzQ3rwJaWsVfWMNepVbUyvFqcnLbr8hyAA02jE9gk7Bu4fckUg4obFPwXWkeRP3ku3Psjm+H/Iuy/kpKLSf8YICDIPs4kQwES+trZAvQTICk3ZDQ9JmFwo4BO25AfaUtbp9l25mQsdJzLM5EsW3q4srpAekXpg4718gYbohH9+ipy9uJa5Ph3G5Ti8iSrG/oeaNVjK3/IpoqKeTMhz5TeO3OmiR4IppasF3HDI+YaZDGNkmOc41DgvI5qpcK5LQAMqnAhSj17r0YKp3Klle1Ndf3kHRHcWNmZK4nErB+ohQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+IzP/3NuQCxXGx0jVuoDFNUrTIYhiGjvJECKwUltrJI=;
 b=GTXMzk7wYG4cXe+OxkijZ9bSpIph0/RRekHDFA8AjlYsRtHHfAK+yuJiHp2oy6bn2ZbuGuKj3t1tLyvlBZaMLlVUU6ae6ss8psqpHqxQqOo73UCFuDC39LQh86OMhmdhnd2TVbbwLn+qZ3cKocKiM/gEdXJvwRTLhtBOjsZEVlEAFmGShSbq4+Nds1G1MfvXVklryQ7JsK5hJXxLVNxRdYyVK5hWiuvr49Szowre7goT3wpWHslt7abrZceEDJP1ZAbtB1Cq8Z/Ar3FBx9HfVVxf/cpfimN62Qo5uiheOvcldpvYWGmrDb93HaF+PKh/5MSILqd48P8DfQ3pUz+iqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+IzP/3NuQCxXGx0jVuoDFNUrTIYhiGjvJECKwUltrJI=;
 b=PdeSJRCGCYVJjWnDZKmzYmZShE9Jlb4QOF0WONxBx/pBe7enyqltlRms/NEzcBcRnI3XQTkAbA4FakNxkb1LF62u0oBMYoLOd7GFRpWOJyWQSgzwxdMRsB3gNowk2Z9q6hC97/M23xEJBSzYyvz5ch5xBWx3f/iga5IWsN002fE=
Received: from MW3PR15MB3883.namprd15.prod.outlook.com (2603:10b6:303:51::22)
 by MW3PR15MB3818.namprd15.prod.outlook.com (2603:10b6:303:47::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.19; Fri, 20 Mar
 2020 18:42:59 +0000
Received: from MW3PR15MB3883.namprd15.prod.outlook.com
 ([fe80::a49b:8546:912f:dd98]) by MW3PR15MB3883.namprd15.prod.outlook.com
 ([fe80::a49b:8546:912f:dd98%5]) with mapi id 15.20.2835.017; Fri, 20 Mar 2020
 18:42:59 +0000
Subject: Re: [PATCH v2 bpf-next 2/2] bpf: Add tests for bpf_sk_storage to
 bpf_tcp_ca
To:     Martin KaFai Lau <kafai@fb.com>, <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
References: <20200320152055.2169341-1-kafai@fb.com>
 <20200320152107.2169904-1-kafai@fb.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <27a881b5-b991-ec53-ae24-1d24ed6e46c5@fb.com>
Date:   Fri, 20 Mar 2020 11:42:56 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.6.0
In-Reply-To: <20200320152107.2169904-1-kafai@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR02CA0019.namprd02.prod.outlook.com
 (2603:10b6:300:4b::29) To MW3PR15MB3883.namprd15.prod.outlook.com
 (2603:10b6:303:51::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from macbook-pro-52.local.dhcp.thefacebook.com (2620:10d:c090:400::5:a280) by MWHPR02CA0019.namprd02.prod.outlook.com (2603:10b6:300:4b::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.19 via Frontend Transport; Fri, 20 Mar 2020 18:42:58 +0000
X-Originating-IP: [2620:10d:c090:400::5:a280]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5cc651a3-bf60-43fa-f91a-08d7ccfe8324
X-MS-TrafficTypeDiagnostic: MW3PR15MB3818:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MW3PR15MB381815FE34CD593E0BB6391ED3F50@MW3PR15MB3818.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:1013;
X-Forefront-PRVS: 03484C0ABF
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(366004)(199004)(31696002)(5660300002)(6486002)(16526019)(186003)(66476007)(6512007)(66946007)(498600001)(66556008)(2906002)(31686004)(4744005)(36756003)(8936002)(81156014)(81166006)(53546011)(6506007)(8676002)(52116002)(86362001)(2616005)(54906003)(4326008);DIR:OUT;SFP:1102;SCL:1;SRVR:MW3PR15MB3818;H:MW3PR15MB3883.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fH68n0kdcTfLOoKOEYZtbQHnfEUrlNyA+QZvkXOROLZRpKtWzvtm3vnC/WkRrZ7kV/ovXp3P8cTM3XVUpaC/pxEdvnKKQs8PMKGHyqTpyAsS5x4DUIVp5c6nzjfBSA3li4zZ+u60SZLAAvy/5GoTQbcjh/8q5WEv/O4ID2/sKzbJVuGsoZSET8SM0wJgHmcVDJqqAQVxV1c7LdexpawfXoUWemPB3iNvOXWYl3UMRTY/fkpKyMeGKuqFtti/3zF0sLOS7HlPeuOx9r+QiuhsEporLlmmVITWOk/i4KxZEDdaUW2NJn2QRZodj7R5GCBtrGeb5i89jBjn1bRvD1ICdxJF1i8Xaxwe8eCmvegO2fNE3NIloFUxvvB8g6jBokceV8iZizBR9b1xoVnByq/SlZdbDqj7lkjx0FxBHQu2oyUWkvdQAwPgIC+eYVZ4bxkk
X-MS-Exchange-AntiSpam-MessageData: pOH7YYYmP4Wrfo2ZPAWMTaHizTStp5NFokQwChrDbNTnvgVLdJuTaSZiKiXYk/r0eWO5SwuoYTiKhd5CX6etPhXwNN/ELKyelW8l+T+v3KtvGcc94aGz26o7GnpFRM/6xppvlg0yLOU/r/G9hpgsBKXiLqY0oNDNEqV7TRLaljIo5tJsJRxbjPM4lGZNmJU4
X-MS-Exchange-CrossTenant-Network-Message-Id: 5cc651a3-bf60-43fa-f91a-08d7ccfe8324
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2020 18:42:59.1785
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sFnQjd+0IadUN/6lrtshQywTrVRMKhxVh241HJpan78fZZpTiMhlxulxco7hPfL0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3818
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-20_06:2020-03-20,2020-03-20 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 bulkscore=0 mlxscore=0 malwarescore=0 clxscore=1015 adultscore=0
 suspectscore=0 impostorscore=0 spamscore=0 priorityscore=1501
 mlxlogscore=867 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2003200074
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/20/20 8:21 AM, Martin KaFai Lau wrote:
> This patch adds test to exercise the bpf_sk_storage_get()
> and bpf_sk_storage_delete() helper from the bpf_dctcp.c.
> 
> The setup and check on the sk_storage is done immediately
> before and after the connect().
> 
> This patch also takes this chance to move the pthread_create()
> after the connect() has been done.  That will remove the need of
> the "wait_thread" label.
> 
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>

Acked-by: Yonghong Song <yhs@fb.com>
