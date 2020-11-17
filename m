Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B28302B5841
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 04:44:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727904AbgKQDmr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 22:42:47 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:8772 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727892AbgKQDmp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 22:42:45 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 0AH3cZtO024957;
        Mon, 16 Nov 2020 19:42:30 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=9mYTdJZ0Rj3C/ChWgVaJ68z21aCoWI08mwu76njSMac=;
 b=MZVOfyaPTCYE3yimo2XSrXyMyCBt5ZEvdXRyzApe+A7xz/mJ2tmoBAIdIIW8ty6kDu9S
 1sFy4HMQcVEwHbfI21F92wRNn+eLieBNu8FjDtscdHSlCvW3yXBGFIjhW5L0tJYiuley
 ji/64AnIZlN8eIYP1qNcXI9QPnhI5Dht8U4= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 34tbssbtcg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 16 Nov 2020 19:42:30 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 16 Nov 2020 19:42:29 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iHy2FmZZek1kyrUCL+ajAOQS0uDPwWOlo7yo+Dxb778zgdN+PKug+zRIYPMSU1UNh45xFRWcRAFQBxMeplwU+oiHg3oFzkLV+dYL/whdDqthjjOq5ya0lBrGXdYg4K11sEAw5VG1P47FAMmV3L5hogKY7JAyeWVruu1B+oMkGyeKXCpfGA2WlhdkAC7y0/d9N+Cp/kRz+yOY8ia/aMY5fxK7wxWNamKpzQQodnWZdcjjG50ZetUBz2G+FasVHeVUbixIPzBwTMljhvLwooqgcUcfmdQlN9xvZYzpzySeagtLb1mt1Ou4OafDjHg4nlaKCxnXlhcF7feax63PJt/aGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9mYTdJZ0Rj3C/ChWgVaJ68z21aCoWI08mwu76njSMac=;
 b=KnupwChqoJhW4MXDvoMYL+SeSXHEicdAH5CapUkGzy4V1A8pNDSlXMIfk5PZNUtGX0dxhX+GmaLuhvDo31KD1fho0nyrXgkCOalCQygjf+UW0Uq7ky3EeITdArBcockoKADcfnUl2JcYiqAvhCmkzjtxmWZAt9D/Ew40cCIOw8iBpURet/HcYmUpOSUQDvZc9HLHBHiGmh6qMqACXc+9zsO1QaKdNxHZ3aOoNcw3p0msmpfkWexcU8+YiMuqlNkb6oIe014+ZmAickbDdTj+JyiJgWiSn8vfh1neBgD8aepO/soDYb6vr6fVD58UmyZLE4TA0KzTpWUsVhJNnY2PMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9mYTdJZ0Rj3C/ChWgVaJ68z21aCoWI08mwu76njSMac=;
 b=IdMD0xxF+xO3Va5LfTJkNGsCBcvCpL5uaF6X1cRdtVE5bOJnO48xZNe0lYKUaRJ7UhHvfLYcoDkeCBR6iA2t0WCgflX5bDGN7As/GmsSorDMili9FnwkepscyuwsBopLJzi8lOYEFDEPIJj9Gl2iTT5XSQa/pbiO3OMfrUA58Rc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4136.namprd15.prod.outlook.com (2603:10b6:a03:96::24)
 by BYAPR15MB2661.namprd15.prod.outlook.com (2603:10b6:a03:15b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.28; Tue, 17 Nov
 2020 03:42:26 +0000
Received: from BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::3925:e1f9:4c6a:9396]) by BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::3925:e1f9:4c6a:9396%6]) with mapi id 15.20.3564.025; Tue, 17 Nov 2020
 03:42:25 +0000
Date:   Mon, 16 Nov 2020 19:42:20 -0800
From:   Roman Gushchin <guro@fb.com>
To:     <bpf@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <andrii@kernel.org>, <akpm@linux-foundation.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <kernel-team@fb.com>
Subject: Re: [PATCH v6 00/34] bpf: switch to memcg-based memory accounting
Message-ID: <20201117034220.GA109785@carbon.dhcp.thefacebook.com>
References: <20201117025529.1034387-1-guro@fb.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201117025529.1034387-1-guro@fb.com>
X-Originating-IP: [2620:10d:c090:400::5:1580]
X-ClientProxiedBy: MWHPR01CA0033.prod.exchangelabs.com (2603:10b6:300:101::19)
 To BYAPR15MB4136.namprd15.prod.outlook.com (2603:10b6:a03:96::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from carbon.dhcp.thefacebook.com (2620:10d:c090:400::5:1580) by MWHPR01CA0033.prod.exchangelabs.com (2603:10b6:300:101::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.25 via Frontend Transport; Tue, 17 Nov 2020 03:42:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9b017e6b-7496-4d1c-e1dd-08d88aaacca1
X-MS-TrafficTypeDiagnostic: BYAPR15MB2661:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2661E4FCD11E994BBED4D5D2BEE20@BYAPR15MB2661.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vfK7fgrEGBW3bwcH9yTdGPqNu3r+Lj6m+7ltaegOc7I+llDUZEikqXCGJ40xdo1metj9u2vHB/iuWPVg7dDZpYZkFTlSVCeX8ysDurmiF89bmrD8sbDfrevvsjV0f6iBL1zynP/Gg7FjCdiQ3Iucq/bI4LvVIjqObsv5V/TPwwfJBnoxn9ZPerr5+hhmMthFVQK2aQTBrITdEZ5o6ptA5ECnGLPCP+fzCx8Wg17ViwY91UDNSbv1GCLSYLYwSeQ+FcEhlMpIDuCeHqSeXOtAVjciknYcWVaHisOdhVntbbT780kq4tdCLr8WtcP4WqvBUFPvieMVaWeNq81oljWFdQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4136.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(396003)(136003)(376002)(39860400002)(6506007)(16526019)(8676002)(52116002)(7696005)(1076003)(4744005)(66946007)(66476007)(66556008)(86362001)(5660300002)(2906002)(316002)(15650500001)(478600001)(55016002)(9686003)(4326008)(83380400001)(8936002)(6666004)(6916009)(33656002)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: XzymWl1+Ht7sVYUyZQn22KekkO6P37wtBVNEY07ytEiIwRIZdwLxIRIOT1MZ2GXfu4/ATQ3Wvr1Eb2aJ/PBhoq+C0J8A18Em3GkYr4pA4xuOAh9DyP/1cyMYDMyan5eZ37mLxCSktbGxXYGfvR3whzH8AGwTCXUvbIEHHFnAhJYFAYzB/R4vAtdAC/HlEWvyUmubSIZpGFQZH1aoFqzpyGkksyjXAkkYguKCdiFm5W4JoIODcvcoWxMSXM52Kpkppmgdw/8rzKBk4YhD+klldoZGrp5Joto4l2LL1GJmVFb4RrtZaQbBpvRuCuBccgDWmPcJRmeTqiP9SvgTiC4ABkqLPyW6tfIpAUKS/HNfqMnvDVrmNH1V1CI6eEErfWRryCBaza2hhTQYWwmwWhIe3vK2UAYcHqnc32THC5zWyvy+hfAfKKVZ/lG7Qdg3pSetKfEIm4/c3oN15Uty96NIJO7lLM5QUG5miGJ9GkHdGMGia+X6kySOgn5pEf/TRmVe4gaJ3w18t5VTVGQu8p+8FDVJZo7yxtWLHL7QyU64bVUZnlF7i4J7lOL8dbs7/sJixriSWXjEu91Wc+tM+fiFa0hGcPqt9sVvw/ZoBA2cZnwbOyV41RHQOF4+9kZVbZFHA95u9JyqnOAZoSs5Iko1r+5GMvMEA7/o/9oTxCFb0y1DvjwBazWwXSgtJUI02ZRM
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b017e6b-7496-4d1c-e1dd-08d88aaacca1
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4136.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2020 03:42:25.7458
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n1A5XNiIE6d/emhAQUCsKjeo9HCI6FZCTlF1vj7e2laQcdtZZvPyiH/O/TezuiEv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2661
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-17_01:2020-11-13,2020-11-17 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 suspectscore=34 impostorscore=0 adultscore=0 priorityscore=1501
 phishscore=0 lowpriorityscore=0 spamscore=0 bulkscore=0 mlxlogscore=812
 malwarescore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2011170027
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 16, 2020 at 06:54:55PM -0800, Roman Gushchin wrote:
> Currently bpf is using the memlock rlimit for the memory accounting.
> This approach has its downsides and over time has created a significant
> amount of problems:
> 

I'm sorry, I've missed the "bpf-next" prefix in the subject.
Resending.

Thanks!
