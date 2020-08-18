Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8229D248AF1
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 18:02:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726810AbgHRQBx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 12:01:53 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:56600 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726735AbgHRQBN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 12:01:13 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07IFju7i001419;
        Tue, 18 Aug 2020 09:00:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=3TlHtdu0VPW7Q+tCp6MKl8LpHM6cQIKSaFDmR8S/32I=;
 b=Jbj46uAiyA0F+mZ8euIzo2CnRenaiGIwO+m51zncswcvFmoUAJB/5uQyx2E6fZzVamob
 xcZWPu2q4kea2ld8JulkASrw/us63cepabrc6mjZjhWI5b/QSGsanl3XcbKtO2ith4jj
 Q2IXudoiORkKomxjJYJJEbEkKw5abuF2eCY= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3304nxkdgf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 18 Aug 2020 09:00:50 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 18 Aug 2020 09:00:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZzVjNfb8CBUkTnD2oRCBnX+pnEeqM2eAMg0B/R5KnqXcmkb8nPoGgEQo6BOqD3ta7vM0ylkckuTCrJjDclwCE8l9+HBsbqpy4BOrFalFap+FbYxY2Oc/ZpuubzsbRkSPeNlSEkzvg8/TnEmh45TKqhba6X7RCSyIT2NPuRVJcbiXRgBtSLGN/igcehMux4iYy2llhwuFHb2lsw4Ebf0e/MbjCBES2d7+244xJL85whMpVVH68u1kAD9OThPuLpF13IyBSj29gJfjhcDJYwh38jBzGf/MZF+LF/hBGRY+x9c6oQrKNSi5yC8XJdZmBNPEDbOxQFeMUOsVxDDmA1XnQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3TlHtdu0VPW7Q+tCp6MKl8LpHM6cQIKSaFDmR8S/32I=;
 b=Z7GnPeysuF+4UPDQP89SlOPVdqExP5SDV4kyv0Tf1Ge06MWjo7cfBRjbxONYy0zTF1k1xWOBcYgwRhzctvEdHwceebvXF6tLSX3cq0p5MVCWqc3uNBtKyCxocextBzpLIZh7ZMXC4GML7p+nx+rsG9Z7XeNzcSXmtPpZi/ucRg3QxmSF2G3qiTLx+mA0B9ePSzFl0Ik/qJxOq+YGjK/zZhN5KcrxoU6Nj5+wU2VomnsjBQba5IYdw1X3g1/eCmAjki2GXXkvlneusYlbjDY+tLbvGDrClPbf9XznDekNqJwQpIvqhKSbbH7BjvF3KjkuaPXDGpbXUv1MPPTtpss3JQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3TlHtdu0VPW7Q+tCp6MKl8LpHM6cQIKSaFDmR8S/32I=;
 b=aUeUi2+DYawQWWkRMX0zbHEBE4F8abXcSi61H87EMVd5v/C67yIy3jgiVzXkZe2Z08x9Nezg94u3Xj80NOaMTHIVFCspMKSUs5hlbDWEXasTBG5swVwN735LlI08r4FScTJTxfLWTAww8Hk0ZSVkIpxUamX9wnAUOde+C3q7/XI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB3368.namprd15.prod.outlook.com (2603:10b6:a03:102::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.15; Tue, 18 Aug
 2020 16:00:47 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80%7]) with mapi id 15.20.3283.028; Tue, 18 Aug 2020
 16:00:47 +0000
Subject: Re: [PATCH bpf-next] samples: bpf: Fix broken bpf programs due to
 removed symbol
To:     "Daniel T. Lee" <danieltimlee@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
References: <20200818051641.21724-1-danieltimlee@gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <d68b548d-ed68-5ff1-5db7-1cebe0d19180@fb.com>
Date:   Tue, 18 Aug 2020 09:00:43 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
In-Reply-To: <20200818051641.21724-1-danieltimlee@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR01CA0056.prod.exchangelabs.com (2603:10b6:208:23f::25)
 To BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c0a8:11e8::10d3] (2620:10d:c091:480::1:a06c) by MN2PR01CA0056.prod.exchangelabs.com (2603:10b6:208:23f::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.16 via Frontend Transport; Tue, 18 Aug 2020 16:00:46 +0000
X-Originating-IP: [2620:10d:c091:480::1:a06c]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b29ab86d-3578-4dd1-eb25-08d8438fdeee
X-MS-TrafficTypeDiagnostic: BYAPR15MB3368:
X-Microsoft-Antispam-PRVS: <BYAPR15MB336845761A9065C8CF2D72ECD35C0@BYAPR15MB3368.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:154;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YFvZpwJym1MMRmXl0AKnq6BUJpiltTWsUgfSFQEo4sga+4LI4INzthg1/6ZlvqoejROJvKsbjtmYmmaAKPTwyyEhD5rbZygj4N7jyvgvz3Avt+5DvcPqgU70kKRgJgUVNFGxyzBBs/Baty/sSg0SIVyrLqB6MtkUvU2kpSejc2A+fTbFFnhOgKweckX1pgiqRzWZrI7VSCZb2aA458MB68Ap5Smuc0lqSjyNjSj0ZSygj87R/Ba/1zsLj4JpPNeCCjOD7xxf/E2D9df1kGNlBHeEIS257MK5RjhTzWFzzeAvSB7OXi+gwPCuikVywwzeLsT9m8kKuvxHt9i8MiClId4HhoH6qxPBquXpsGfhTo3Sxmn9g9AdfmtGL4BY2NAB
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(39860400002)(346002)(366004)(136003)(8676002)(86362001)(31696002)(83380400001)(2906002)(110136005)(6486002)(478600001)(31686004)(316002)(36756003)(2616005)(52116002)(186003)(16526019)(53546011)(4326008)(66556008)(8936002)(5660300002)(66476007)(4744005)(66946007)(6666004)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 9fiVsdhMp1Ko4YWQd1cgVVHnCMz5Zvj09BjI3CvjVuRT9svCnvk4wwPda5i6JUZceIisX/Khk/FQA8KzK9X1z27C/Ese3VmJv6dBbDBA/4q9krDIH8AusyPXrKO2UtAaJII0lEome/vgamANjV0twhDIrOP2dq30k1MPVOErtdJFNt+z1lLJaxoVAmYq5kGipHkYUCcFy4ce9C2UgQaw6ktGd4lEiC1lAEm9ZlXo+rcQQ5ue55SAdiJ6M6oLgibYahvmO5UhxL5rr9NK+UjQto7/gD0afIHyS3ERlY6OeW1GpeEgFItlVS4NsXfui7uyHm2nlw8h4UKxs6121Ws2SISemj5VSWWTyr+It4XGKQzH5eo7i9WVa1ThZicHA5AFLAUEZUGH1rrqER76Kp2d21m4xb4LFtjKSekdqWg5RNHCRNO7U/5rULZcsdLnv9ZsBGopJ1s3RNCW7ykcxmBMc1QiDuevJ7uYkssCwiXSNJDog0zXgaHeSHRlVuRJqgl5EkPDvYd1AHKTZFrSVC9uC/9fIDw1ux334cG5/p8Sf2i71nzdjh+DkOp/8QLk5Q8dWG0cr1mCipk3zsIt/DrFkU4lbKf6lOAqF/m1Av8pHZRJfwbxjEIFiP01ndU+2GqSmtJjwi80hfbBpvEp/r3qhFxYVG17lbOocsVIxv/U8bKlBNwzNNrz/oKakrB83lSw
X-MS-Exchange-CrossTenant-Network-Message-Id: b29ab86d-3578-4dd1-eb25-08d8438fdeee
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2020 16:00:47.6187
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aiuxB0ODZnvL0TFhmCIb1GGeWtpAchBS/8lUehcEZYaEZLqIt6JXxY8AZDMULIHE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3368
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-18_10:2020-08-18,2020-08-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 impostorscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 clxscore=1015
 priorityscore=1501 malwarescore=0 lowpriorityscore=0 suspectscore=0
 mlxscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008180113
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/17/20 10:16 PM, Daniel T. Lee wrote:
>  From commit f1394b798814 ("block: mark blk_account_io_completion
> static") symbol blk_account_io_completion() has been marked as static,
> which makes it no longer possible to attach kprobe to this event.
> Currently, there are broken samples due to this reason.
> 
> As a solution to this, attach kprobe events to blk_account_io_done()
> to modify them to perform the same behavior as before.
> 
> Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>

Acked-by: Yonghong Song <yhs@fb.com>
