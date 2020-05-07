Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E96881C8243
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 08:13:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726093AbgEGGNF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 02:13:05 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:53072 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725809AbgEGGNE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 02:13:04 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0476BrpX010744;
        Wed, 6 May 2020 23:12:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=4AWTFJ2wxF5fl97szQ9nb881iNtJmtnO63EnBkLM8ZA=;
 b=DoQ3Ncv3k3KgKvw1Cv4Doj3gFIiDerKyuvz9cRIwmE15QsJobrOD3iWnNJTf0EM4DAcW
 2moi4gyn0akkc4KXs0rOQ/ghjJKhL7RwZFYyh/FVmXxq0fgmlb2l4QwL6DKW1cj0t7bl
 44IJfbyDhGHq/HVh13RQXBQhH7wZ6PjmbPA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 30up69egs6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 06 May 2020 23:12:48 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 6 May 2020 23:12:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ARDgHuxvPgl1zck9v/YHuNXv166z536qAwqIfG6XRqSehxlxOvmVm5QWdA4i5r839Egv1EFeGIXCD5zRsgJYwOOhdknJ3hY/o6eiMJgU+201S8EHBQnloh9J4Fv5H12Y/qtXM71M4o5fuZyCSYBHs8o24xjEf3hYC8z4T0FgNLDzU5eNZNxev5NixmY3NXckW4mgvVvI9KcUBduy5ZHt1svmrAzMxTKwGi7Jlsf16jKJetEsJS88ej5rarcDU1mSMptpsn3JoKXVpNLgsrtoBiTvSK9Ql7bIJFX3l72zNshhjyhw2TbsbENhybQ2HC6OTP9lADnE+8bFbDMbjemLmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4AWTFJ2wxF5fl97szQ9nb881iNtJmtnO63EnBkLM8ZA=;
 b=BIrW4TkjSEP2X8cX/cZwWWYgPnR0QWZ41t13thcVrlb0jBO1WeMMh9XKx1Ya7WyDMr8VAn8aQtLr0qg58Y87uWx/fMJlizPKh6HVoQ2ZZBAzYMNksv2qnwsKlUAV1/bxgE6RkNUT7x3gGdShZGQApgKDGa6h7urRgQ0Fh2/ws8ic06Y1nqt9oyp+3FPmEYuTEDfM82nlwySpuU5kbECRCzTMQREI+0M7US0oEVE+AMc70J/9K3jM56zSqe/O6TNR8nyN+yH+wKKkFzU6Hj9N7HAUGya60x77V2flmWqWx7boY4O+nLUAbYUk5s35AwZzz0Vv6TgIq0sjAPodC5b68A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4AWTFJ2wxF5fl97szQ9nb881iNtJmtnO63EnBkLM8ZA=;
 b=ZcIaaPM0UslRSMpsCxrdgoWgo5RDgFg3RSjUYGy9R8EOGsMPulNrXJ/3RfDUyjJqe2bzSmR/xucDS7tWrMPfdlJxim6lbAmSNvQ6NR9CKwA08MhZtaZW8HKLH19G6V/hQ9DyBqXsiBu17ZLxJZGKOpgvuueAMWSCBiZTg6xoYiI=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fb.com;
Received: from MW3PR15MB4044.namprd15.prod.outlook.com (2603:10b6:303:4b::24)
 by MW3PR15MB3915.namprd15.prod.outlook.com (2603:10b6:303:4a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.30; Thu, 7 May
 2020 06:12:46 +0000
Received: from MW3PR15MB4044.namprd15.prod.outlook.com
 ([fe80::e5c5:aeff:ca99:aae0]) by MW3PR15MB4044.namprd15.prod.outlook.com
 ([fe80::e5c5:aeff:ca99:aae0%4]) with mapi id 15.20.2958.030; Thu, 7 May 2020
 06:12:46 +0000
Date:   Wed, 6 May 2020 23:12:44 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <davem@davemloft.net>, <ast@kernel.org>, <daniel@iogearbox.net>
Subject: Re: [PATCH bpf-next v3 3/5] selftests/bpf: move existing common
 networking parts into network_helpers
Message-ID: <20200507061244.63ztqtmiid64xptv@kafai-mbp>
References: <20200506223210.93595-1-sdf@google.com>
 <20200506223210.93595-4-sdf@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200506223210.93595-4-sdf@google.com>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: BY5PR20CA0030.namprd20.prod.outlook.com
 (2603:10b6:a03:1f4::43) To MW3PR15MB4044.namprd15.prod.outlook.com
 (2603:10b6:303:4b::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:bdb8) by BY5PR20CA0030.namprd20.prod.outlook.com (2603:10b6:a03:1f4::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.28 via Frontend Transport; Thu, 7 May 2020 06:12:45 +0000
X-Originating-IP: [2620:10d:c090:400::5:bdb8]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6af62b30-2288-4394-cdb4-08d7f24da911
X-MS-TrafficTypeDiagnostic: MW3PR15MB3915:
X-Microsoft-Antispam-PRVS: <MW3PR15MB3915116AEC96A58D5FEC6004D5A50@MW3PR15MB3915.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-Forefront-PRVS: 03965EFC76
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1xlbVJrDHCpk/VKKcMhFpf5VXxGVlNAoTwC+hob/QZ15LsnsLxS/x1OwKAnnLWwohNr9Lg3dkg9aM7caZuS02Gr7QXMGqzBGPyRqklwMoNt+/eE7ZR5y3LhBl6go/tEyEuLTcUml0DgsLjdqJ7vBCQlmyIzLt/13XBcNrEYiCmrT0ZrOQoxDyjw9SoBSOxxE2lfSKlqXSxQ8OE1mn+RgGknqWieCY12Vj/n9PiXqccRhn8coLFO1eR9SWby8kuPOreHsIev1TOhf5t1YsugBjFPoi+Iy+D4UX/rHd0KAZ+NBXpigOUQnrTkVIsKF3iqNNkrKTO0DVKk5uSTWD3eDI38LLaDF/FenFMqF0duo3/caKt9ayr6LUeMZKTof1iEW6hh9iKYWjihLaKpb9FcLEBhy1MDXotOgoXH9Q5pvgTzadBqLf0Oa2VR9y6g2r4wkyGne35m/1TWxwKBZ/znfHImJBb574dMKjK3IpXfuA2B1Cj4vvORP7dJ73tIH1shNjXEDYFRKnLup5AJeMCyWsg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR15MB4044.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(346002)(376002)(396003)(39860400002)(136003)(366004)(33430700001)(33440700001)(66556008)(478600001)(9686003)(1076003)(66476007)(8676002)(6496006)(55016002)(6916009)(66946007)(558084003)(8936002)(316002)(86362001)(5660300002)(52116002)(33716001)(2906002)(16526019)(4326008)(83320400001)(83280400001)(83300400001)(83310400001)(186003)(83290400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: IEYa2Vz0I3/c4fWpebeoBq1yPz20drBWG16iY49kmA8I9RVBhZ9hEiW0Ac5QDRMm7dF3sp2phinPYxDG445bWivqsgHFj5r5mwoNy8arlAmcgWm4zDOuSWJU4AoqGBQcoPkm5iWqEGlV2f1C5IfncwZnUoih2Nta22e8iIWETxmJOV7z7lC7b4qunOdP9jQTB1gd3HLOxpq/k675z6G5K5dZ6M8eQdG77yVLVvT93zGStotIfAc45qEY1M6wUbzLaLXJQHjat+NwjJPtc72j72Cp6gp9ngniKtqA0JkuuFNk/Lb2+zn0m2fgVdCbHlWW4dY4LwV6QreKXYXnBce7rEbcFcBdKCszJTGqgIlMz9yDZrJNkqBjnqSuGFiC3QRrOcyL9r4B5ucg0+WvdZQhkhIiiloaCddu9ZnvPcoUZH75mULhFFqk83eYU0W9CPpnB4qiI7FUyQtzYRrJftf0iBHrkYcMsQJdoPqqX6Aty9u15h9D/uIBWk7BM8h4D0rcGWsgRnko2r/zjar0QXMYsKLpjV4nwuSzW+fdWCSc6S24Lmv5fx5N+VSs/Q4hhUJEbrMS20azYmTWact6mVZqvcUWorvj23d9LM2GIaeZjBOQrYRtKrb1tvdvO/6sIxW3GrJpnMEpfcH2JT0NjJpZxD5KDbKQyBlA7zxTFKi5YZHmuZ2lTqokE8RB4cmQWAsd0+ElzBxzE1w5/ixd7GIKSM991LTP5w8WBCwFy+oX0RSqoLPHuVrCSwd7RCu9WBRc8k9ADXenTf91Uy838te//93ZjK/7eDaTbMh9+p9cuvM+C/DXq67Z/CdiBrHd3vOIMDWxNZSuqb0fn2eFeG/53A==
X-MS-Exchange-CrossTenant-Network-Message-Id: 6af62b30-2288-4394-cdb4-08d7f24da911
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 May 2020 06:12:46.0339
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X5cWeiB2/62KzHWyZE0Hc4W6Z2TrmoRs0M92wMHdbZmhMo50rczPDfOZv5JiKbaU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3915
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-07_02:2020-05-05,2020-05-07 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 clxscore=1015 bulkscore=0 impostorscore=0 adultscore=0 spamscore=0
 lowpriorityscore=0 phishscore=0 mlxscore=0 malwarescore=0 mlxlogscore=523
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005070049
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 06, 2020 at 03:32:08PM -0700, Stanislav Fomichev wrote:
> 1. Move pkt_v4 and pkt_v6 into network_helpers and adjust the users.
> 2. Copy-paste spin_lock_thread into two tests that use it.
Instead of copying it into two tests,
can spin_lock_thread be moved to network-helpers.c?
