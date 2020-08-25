Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1846B250DD1
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 02:49:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728239AbgHYAtV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 20:49:21 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:64664 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726090AbgHYAtT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Aug 2020 20:49:19 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07P0mIR9023311;
        Mon, 24 Aug 2020 17:48:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : references
 : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=6xDut9XV7YV1nMAotCx213KU/NDHlcDysnT1Iaefg8Y=;
 b=rMZV70z54+HqUte6Ht9YUuaTwHE48iaLehgCOArSuCitgrwvwYXnl2Fa24q7Jvl9ItKs
 WuKBnmmO0sScP93VMhL+wvtcXJePkwE2k7LeDxgARBUC+9F9sriNNZd2nyDP5WLsTFxE
 L/lQKNsO2XnhY3dPkeFxRP36LpxTpcQ6ONA= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 333kmmyya0-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 24 Aug 2020 17:48:51 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 24 Aug 2020 17:48:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ImJkV+zY1VC7TY0EJJobxpkAdj7ff82urtdkPxHwYifXXZ3zqLNWZuH8N3rUbzsDDPU3U1U0GkKy7+qy6IZCZpTtdFN8n19R6ydV7eKMohbU6QwT+XCOn1SiHggqnna0G9Ucl9xVsOT/UWoffjixM4JgEoKeN3ntMAAmZIyHj0IyToKB4seezxB5piTjd4EzBYrmxYt9IrMMfPtmpB8k9OX8e6utSRkhxSxPkZ9QvHn/3sZ9Yl7LeuKKKo4YaqS6tCew889PVUyQ5c3d1Elnbj0fMhskBRFoVm6Fs4C6s9E9GAw5IFtKnJbQP/EAbLToWoJyZ6oVCHP9QNOjdsWHdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6xDut9XV7YV1nMAotCx213KU/NDHlcDysnT1Iaefg8Y=;
 b=NSnQaX0MN3wfhR5LcRaMqT+UA6qaoa6QHD7yc9/qmXkB7ETACKkboy1yqSHxJXvgZpT/YpHRvP4fdUujx9/eiXmA8yjiXduqSHIpr9V+P1MfmScdrx+truZv53y8l3SC8UcODkq1g4f7/4SNe3pKLOEeSqroJJPovX6nBo7NsMHs+vR8BvzuBbgDwqRs422yz0CkhO/mD/cLOlQA8XuugRfW/1R5Ds+W/kXyPBeGut8taRyLJuGHQy76fUKk0kF9lyIr9A80am2tPbBJAwG69fYkZWjxzyYEXwJk+4I/AbOR7T/+0JE/8obPw9XYcyp1dFW8JClMNhp/QgPVlgiC4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6xDut9XV7YV1nMAotCx213KU/NDHlcDysnT1Iaefg8Y=;
 b=kunirWA54TxVS7S7QXkePc3bQCNc0BPpsYQ71FhQMk1qrqmh0V3geNzk7KP/VAxTLjd06ge5URGp5qXjaC3pvCe9lQpe0+tPTC/jGVg2s3RfLWgAkSug74sIpqrMgxX2Bpc/l+uvNEVF60E6hMQmaXqOPcoye0Oi08hpyeVYLSU=
Authentication-Results: googlegroups.com; dkim=none (message not signed)
 header.d=none;googlegroups.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2775.namprd15.prod.outlook.com (2603:10b6:a03:15a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.24; Tue, 25 Aug
 2020 00:48:30 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80%7]) with mapi id 15.20.3305.026; Tue, 25 Aug 2020
 00:48:30 +0000
Subject: Re: general protection fault in security_inode_getattr
To:     syzbot <syzbot+f07cc9be8d1d226947ed@syzkaller.appspotmail.com>,
        <andriin@fb.com>, <ast@kernel.org>, <bpf@vger.kernel.org>,
        <daniel@iogearbox.net>, <jmorris@namei.org>,
        <john.fastabend@gmail.com>, <kafai@fb.com>, <kpsingh@chromium.org>,
        <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-security-module@vger.kernel.org>,
        <linux-unionfs@vger.kernel.org>, <miklos@szeredi.hu>,
        <netdev@vger.kernel.org>, <omosnace@redhat.com>,
        <serge@hallyn.com>, <songliubraving@fb.com>,
        <syzkaller-bugs@googlegroups.com>
References: <00000000000020e49105ada8d598@google.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <516ee4af-0db1-9069-bb06-e89216ab49c8@fb.com>
Date:   Mon, 24 Aug 2020 17:48:24 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
In-Reply-To: <00000000000020e49105ada8d598@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL0PR05CA0003.namprd05.prod.outlook.com
 (2603:10b6:208:91::13) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from 255.255.255.255 (255.255.255.255) by BL0PR05CA0003.namprd05.prod.outlook.com (2603:10b6:208:91::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.10 via Frontend Transport; Tue, 25 Aug 2020 00:48:26 +0000
X-Originating-IP: [2620:10d:c091:480::1:75df]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b62a3b81-b2d7-4edd-20e9-08d8489095c2
X-MS-TrafficTypeDiagnostic: BYAPR15MB2775:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB27755F4260C83BCDE3D05921D3570@BYAPR15MB2775.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:58;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9rmRSjtikEwQY3aru6OwJ83jkeEyo453IqvoEa95uRYcsCKTrdhlgZi9CTpS8/mRnyHHnewiGUl52Iq5yMea6I/4MUCAUHfcLLZ1/eq0nOjTzcamNXDwuOfS7v9SEhG/IK3KQATacXMTOXaeIZHVOYTLm8Wz3S80iq5qiHIeB3QGqbsl/SttfHcQnwTkB1J4HZpO7u6HnMPZwI1035QIW2TOTLSTUnQRnQjn4lrqCCpkyaBRoeV1jqivqEreV+ENDXjPFrPDiQqmykFSFf6s6aZQJ+GkBzNazgD+CLZE2194q5sLpBX2wiKToNfxFbPRLlhWQ3+mWf2fk2yomispohzp/Y82jSJ1bM7a7Im65ctLi1u6OGsPJxVdCpjHWNMumN/EdCMTu80tPwgc3vpvGUtWeoUsrlfNmArWOuDsEYhCSoTUwA0cNhEBGAEEXgfLFGgln4GrExy6Ve7kZWVRtsxI1cbpgmVLtqmh9N5IL3+9o4PqYjknDuGwH2fSts2C
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(366004)(136003)(346002)(376002)(2616005)(7416002)(86362001)(66556008)(66946007)(66476007)(956004)(16576012)(6486002)(31696002)(83080400001)(5660300002)(966005)(478600001)(8936002)(8676002)(52116002)(53546011)(31686004)(2906002)(36756003)(316002)(186003)(921003)(99710200001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: iNXkBy8ktslwOEqk92Caj777xhqeSxZOqgSUmyj17B/oVIqCfqQomcPoBhuorUSKDcTXg7xwWyO3AaMZ+ruU0kj+x7DfXbqvZ6+lFMui5BUkFTNNU/+tR+zO7QJ29QiTC6ZcQ4Dq3G0fVnMh8JT6flGC3st77azY6Si/dhPdNphFQiZ281WAijrPavLIQwWFPMMO8yO1Kj96Qu6QclhmDvIL41vvbT85io92TnGJIZm65B6rFmbTEoxu3nVxN5ao52R/BxwUoIdca9W7NJ63s2rb+F3vIGKuptfYByX+DBnhMYN5jsnvbTMuGUOQEt7QkbRhDEArRyq2aIG/IBGHw5Gdd4hjCZlk472Zx7YwA0YK7N1rJeGSeW5fCmlrMyy7M87fGQ0COTc23JMOR4KFao0mUC2l8yCpppTyDPZcb+LNcFs4xWhdxvnDM7BI4hOkZXWfuwypJ/Bm03uwOE7/8j/kZZ3xTFuhcFyeR+WzK5C9E/QSeqG77q/Jkpeawv01USAwDY4c0i2Z2iK+FLBPAV7+Rp00OllZzIhWs22i4B7oh/HioaiBA73yOOKoE6CY3pxAksdw42RiGDXwyLNLnpV0w6NHAjrxms+mBfOznl2PC+BU6npBw4Npt2OF6yq7AVLReXPHzTBM59TkcQGrF9Wc8FDsx8sVQybXOEWN/nstFv1tnmfmHHkO4MZE60bc
X-MS-Exchange-CrossTenant-Network-Message-Id: b62a3b81-b2d7-4edd-20e9-08d8489095c2
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2020 00:48:30.0481
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9zNy4Cdlu9+SPXzI++uI49f73bCMis3EVu9n2yEtvdzczkNn8FF3+S61EhPsc8tQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2775
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-24_12:2020-08-24,2020-08-24 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 adultscore=0
 bulkscore=0 lowpriorityscore=0 impostorscore=0 malwarescore=0
 mlxlogscore=623 phishscore=0 clxscore=1011 spamscore=0 suspectscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008250004
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/24/20 5:32 PM, syzbot wrote:
> syzbot has bisected this issue to:
> 
> commit 35697c12d7ffd31a56d3c9604066a166b75d0169
> Author: Yonghong Song <yhs@fb.com>
> Date:   Thu Jan 16 17:40:04 2020 +0000
> 
>      selftests/bpf: Fix test_progs send_signal flakiness with nmi mode

The above patch changed file:
     tools/testing/selftests/bpf/prog_tests/send_signal.c
It is unlikely it caused the issue.

> 
> bisection log:  https://urldefense.proofpoint.com/v2/url?u=https-3A__syzkaller.appspot.com_x_bisect.txt-3Fx-3D13032139900000&d=DwIBaQ&c=5VD0RTtNlTh3ycd41b3MUw&r=DA8e1B5r073vIqRrFz7MRA&m=854z77F3pbTpgGUCFUwM1OSEUj4NbiNIZsaad0Xg4qc&s=Le6D_jfzkec28_qNhbUwMesaUeBGaKEG6RLN3ZCzE1s&e=
> start commit:   d012a719 Linux 5.9-rc2
> git tree:       upstream
> final oops:     https://urldefense.proofpoint.com/v2/url?u=https-3A__syzkaller.appspot.com_x_report.txt-3Fx-3D10832139900000&d=DwIBaQ&c=5VD0RTtNlTh3ycd41b3MUw&r=DA8e1B5r073vIqRrFz7MRA&m=854z77F3pbTpgGUCFUwM1OSEUj4NbiNIZsaad0Xg4qc&s=VbLXb22TgxAtiPQTEq0t5r0WgNDiFwstWKnme0tWBLE&e=
> console output: https://urldefense.proofpoint.com/v2/url?u=https-3A__syzkaller.appspot.com_x_log.txt-3Fx-3D17032139900000&d=DwIBaQ&c=5VD0RTtNlTh3ycd41b3MUw&r=DA8e1B5r073vIqRrFz7MRA&m=854z77F3pbTpgGUCFUwM1OSEUj4NbiNIZsaad0Xg4qc&s=yu72HnqjHzOTtJ5dyD7q0QW9sOwEO6pPHjeYTTutKdc&e=
> kernel config:  https://urldefense.proofpoint.com/v2/url?u=https-3A__syzkaller.appspot.com_x_.config-3Fx-3D891ca5711a9f1650&d=DwIBaQ&c=5VD0RTtNlTh3ycd41b3MUw&r=DA8e1B5r073vIqRrFz7MRA&m=854z77F3pbTpgGUCFUwM1OSEUj4NbiNIZsaad0Xg4qc&s=6cylIRBZjHQmgkJQoofuLN2XSifb-13qrrj58PQpBYs&e=
> dashboard link: https://urldefense.proofpoint.com/v2/url?u=https-3A__syzkaller.appspot.com_bug-3Fextid-3Df07cc9be8d1d226947ed&d=DwIBaQ&c=5VD0RTtNlTh3ycd41b3MUw&r=DA8e1B5r073vIqRrFz7MRA&m=854z77F3pbTpgGUCFUwM1OSEUj4NbiNIZsaad0Xg4qc&s=siCrm2aO-fzR3Nym_zaPQQnmxMlJo0bRj87zgm7o5mY&e=
> syz repro:      https://urldefense.proofpoint.com/v2/url?u=https-3A__syzkaller.appspot.com_x_repro.syz-3Fx-3D104a650e900000&d=DwIBaQ&c=5VD0RTtNlTh3ycd41b3MUw&r=DA8e1B5r073vIqRrFz7MRA&m=854z77F3pbTpgGUCFUwM1OSEUj4NbiNIZsaad0Xg4qc&s=yNEvyRe2bO4AKgq2UuJc32katp4k4UGKwMUDEBlhM7E&e=
> 
> Reported-by: syzbot+f07cc9be8d1d226947ed@syzkaller.appspotmail.com
> Fixes: 35697c12d7ff ("selftests/bpf: Fix test_progs send_signal flakiness with nmi mode")
> 
> For information about bisection process see: https://urldefense.proofpoint.com/v2/url?u=https-3A__goo.gl_tpsmEJ-23bisection&d=DwIBaQ&c=5VD0RTtNlTh3ycd41b3MUw&r=DA8e1B5r073vIqRrFz7MRA&m=854z77F3pbTpgGUCFUwM1OSEUj4NbiNIZsaad0Xg4qc&s=K4KdZK8rBgxDv4M9uwEndkCB4mCatTH-opwefN-0b-M&e=
> 
