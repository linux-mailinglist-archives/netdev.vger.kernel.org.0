Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7B2124C07F
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 16:22:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727793AbgHTOWc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 10:22:32 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:57596 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725916AbgHTOWa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 10:22:30 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 07KEMHlR014758;
        Thu, 20 Aug 2020 07:22:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=oAkMnc4sqdzdMROxrrGp2eXXYGWfO78bknASwbYRryU=;
 b=qGARQb5MfCSG6TNrtRHkqUZh11HHNPI4QL2CZmi6raJDqHmKnEWWZa5tgUtWS4MGyOjb
 6Y2JwbisgIXJZneZHxDAE+3dE3qkD08WfoJTW35tjixFew63rVPDtcEA6EGShMcWFlLB
 wO99hVUagdmFe2dYzT5d/2eM3qpIpXnAGps= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 3304jjecpd-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 20 Aug 2020 07:22:17 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 20 Aug 2020 07:22:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z2qSCr/p1at5qdtXgfrh/+UHwFRZ65TZBAFOoRNzkgH3HNPokXh47HWMQLwOOgaTVGzLfYXE0ZAxr3jM/IPMSTSdeVOTTigfvPTbeS6y6mdFjVsrK6RjLUo0P0/3YL1iZcKySk5LikktYfMnIgeM7UWF8acszLR8EuFPXqVKHV0g9YAP0VhVutWneVrFyV4nzB1Iq81T7T8+2H7HNoEs9suXYxkXQAQanYby1srk0dNpO4V5pO6cmnod6qAc4S0PFfaVWJOX7K0uDCGIMMJ/Mgo+WxUGtIWHmVXIhVvNNLpKod3iqHmS/UunHQUw/oulPCLxS4YeaVldukaLnfHBIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oAkMnc4sqdzdMROxrrGp2eXXYGWfO78bknASwbYRryU=;
 b=cOae8NlKWBzGvOCgy1/9QB/dNsECmEAa2vUsK0SiDbZ634m2KH6krwnzdi6Cek1BBqIl9Wejc+WnFqSYlkka4jwa9PsAunoofUHm1FwIZpMNOar7RrTujntDI/jZqX4kPOAlVO4QD7W2qvy4359Qeq/TNdFOZGvcq8WNqCYy/NsrrQPZlpI4Oh9maXqUm5wI9bIo4JNDEZohyZfyBFYusa/4+2umF6dmuwvD9zAFjQoxumqfGNwWew/ZRzfaE6G+PARtnbBhuiX+OzmltBsPSxfRFm6CUSPTtQtBdNGTGZyh/FwC8Cr8R4JUYPFa9b7uTQoVK4VJcvr3XaNX26FM/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oAkMnc4sqdzdMROxrrGp2eXXYGWfO78bknASwbYRryU=;
 b=lZ5NYu7zRZ6qPD+WhJGi1t7vpAbyeTSbBjgo+o7K1pMYV89d7mulhjxDF+Enm/mj2kjNpaWRsPBEf90DER0yuGECwFNdGA2ZxCBKxRJTmEFbdGQF+tO4Nn3GrBnOhfWRNm4/Z74rFFz/6x4t7HoY0VzPdrlw7gvyuPXPbHe1LB0=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2648.namprd15.prod.outlook.com (2603:10b6:a03:150::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.25; Thu, 20 Aug
 2020 14:21:53 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80%7]) with mapi id 15.20.3305.026; Thu, 20 Aug 2020
 14:21:53 +0000
Subject: Re: [PATCH bpf-next 3/4] selftests/bpf: fix two minor compilation
 warnings reported by GCC 4.9
To:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>
References: <20200820061411.1755905-1-andriin@fb.com>
 <20200820061411.1755905-3-andriin@fb.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <1501d8d9-c301-3941-aa59-43665ce6f898@fb.com>
Date:   Thu, 20 Aug 2020 07:21:49 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
In-Reply-To: <20200820061411.1755905-3-andriin@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR04CA0025.namprd04.prod.outlook.com
 (2603:10b6:208:d4::38) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from 255.255.255.255 (255.255.255.255) by MN2PR04CA0025.namprd04.prod.outlook.com (2603:10b6:208:d4::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.25 via Frontend Transport; Thu, 20 Aug 2020 14:21:51 +0000
X-Originating-IP: [2620:10d:c091:480::1:7ec1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2a289ca2-f5ef-4b81-957c-08d845146293
X-MS-TrafficTypeDiagnostic: BYAPR15MB2648:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2648341CD2D27A6CF54B2599D35A0@BYAPR15MB2648.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7LsxmITv7Q7DPt4RQZlaKUWwzBnA7p/gcqKf7+lFmLHkvtqu4ePMF67wv2HDY2jTaKBQxLkswbnUdQrXqcddevKABZgrbxxsKDm6QU3xlxccUc0hQ9wbX1xh4ubbEkQ/g//lnrA0EM8lEzj5SJrQqXxt3NQ0g5llYGI/hdreX80JT18btC2jseVlBjm/11HHLv/ZZC9da1LumnTPa1aTRt3yeKAtuwRdttHyhApQDVk3DakubDMsfWmfY8UikF97PQKrAaPbSByAXnqwhnJCy1rHV60bnLW5c7oDFueRblwu1ivEiBDmohkte/lQ8R3OwXbF9a3RnslYZr3EEwX8jhKftv9ObQGX4Bb/ePj+E07ebAqw3GJmd2uK8lZBjdEk8paa9Jw/lysA+RLvSlBgww==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(346002)(396003)(39860400002)(376002)(6486002)(4326008)(2906002)(8936002)(8676002)(316002)(31686004)(110011004)(4744005)(5660300002)(52116002)(66476007)(66946007)(66556008)(186003)(31696002)(16576012)(478600001)(2616005)(36756003)(86362001)(53546011)(956004)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 7Snn4Oc5acsuI0yBhlD5c49cVnVBCHMu8ceqluX1/aCXm5I53uZcSKivtaK0sSP5Kdp0cYEk7/vf+OqhTppKDdzcIflsgWKqfwmiFTY/bKl56bgLyVg9VJsa9xqbRL3PaXmt9tbVT+Dam3eg7whY5y8xToHhMEKu6s7XNHNW3cpEuKqrWaPfkSnpggeUdwZ8cYndhOTO+hlQXI7Ved/Gf3d6jHFlp58r7qNyR8YTm4Zo2o205IPFK/krTT+ntDXJ+oodPhz42qzf+hPhiY1dLvxaJdx1QL4ejdc1+xnXSlzG5dbRyRQ5mMBSeRsscdrapN6Nz8pW5+6IzKuLNXzX+WKHK6vwOWAVx1shRdVLCEUqTyuvHf9WDG3f1ebvZOxyb19hIWu8NTYdUdhlJGZ32EOq1sJ9Sk01X1SqrmgWZY8njuyjYkm5e22hrkaBisDvlpqe8teQnwj1BYOB05I6NVOuBqCUmme8+p85n62hmB18EIKljTDJGAk0duncCyS0stxw7PSZJCBTutbONW2yyudzePi3EEe8OQGlu9/GNSA5ACbvOsYPLhVpciRmv765ri9zzC8zJbE3RdAqoa798gZrCkDLYBWAupKp1JBY2C1HXHqTvd1odXoI+YCghwEAo0kmJvL39eU3YJePFe8sKyqEOf+RGvpWw1QPZRJKkpkAuOl8HUqe1I8jbL1cz21u
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a289ca2-f5ef-4b81-957c-08d845146293
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2020 14:21:53.0545
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gGyhG+QnO0e9Cxn0jFvak0W4EF26YvyPDOyCVfhgBerVtAnV1rJJqUstjco10CnE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2648
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-20_03:2020-08-19,2020-08-20 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 lowpriorityscore=0 priorityscore=1501 malwarescore=0 spamscore=0
 impostorscore=0 bulkscore=0 mlxlogscore=999 phishscore=0 mlxscore=0
 clxscore=1015 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008200120
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/19/20 11:14 PM, Andrii Nakryiko wrote:
> GCC 4.9 seems to be more strict in some regards. Fix two minor issue it
> reported.
> 
> Fixes: 1c1052e0140a ("tools/testing/selftests/bpf: Add self-tests for new helper bpf_get_ns_current_pid_tgid.")
> Fixes: 2d7824ffd25c ("selftests: bpf: Add test for sk_assign")
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Acked-by: Yonghong Song <yhs@fb.com>
