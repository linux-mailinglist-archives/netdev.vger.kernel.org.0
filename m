Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39B94423356
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 00:18:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236826AbhJEWUL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 18:20:11 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:12284 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231658AbhJEWUI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 18:20:08 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 195M65K0020365;
        Tue, 5 Oct 2021 15:18:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=npEujcpnOizu3bd0gufEBfretasZtrnQzl5pO+OWLiI=;
 b=Xt1TwdJPMbF22C+9AaEwyrJE/P22lcwQVW6KW1MKEgXtIcg4ZaR6VXPkyZHXsSTZZ8G1
 gpNmZIlsvpENy+bmXA4ynesmZDiLc0/cVdvHS7M8yMoG+Ioibuvxjm2Xef2M8h3c3FtT
 oMGePLWetZJgf5P7debZ08Y/ruBoNpXQLXA= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3bgy72g2j1-19
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 05 Oct 2021 15:18:17 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Tue, 5 Oct 2021 15:17:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g7zQrAa10Pg54qKei7bht0Ky9YZJa2xBlE9sgSAlB0xz4pxOSD/TZmwVOgGHbF7iAJqRf0JaUNm45igjMpQaWCeuTaOGT7E5F20GsmujwzXA/B1iDvaGmZQclQi5kj68m1K7y2WfJuBfXgM78LLL+hXn9X8ZIuSOpqnbQWM9wMDRaNZCxPQwClhC+2liybd/LOeIhpbQh9BQzQmURavJqQEmzPYhHx0BIbMxGLW5nMrYi4Irx5+rbr6zfiW6rXlnzYqhnnUGN1gy9uB943Dta5Wkd1ExTtqBtlupvopYJH/lzduTPeuR3kXeU3csyMkbSoLZTxy5Pv8IAtT/Lhcj7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=npEujcpnOizu3bd0gufEBfretasZtrnQzl5pO+OWLiI=;
 b=Pe6JWSbBjxGbDY6F298QhEqM24yKa08JYam+YkdXXOxCW+WRe/dodV6VSyzzYXLzv66ttIZTas9fuQpJoeTBBYfsveVCzvzZFjhnKV/bNc4HVe3YbzwwDGq0kAnNiXU9e5MDG5I50wD7+5bNp8uxqJcYqecLFCPXn+gCGG9ltJMjQLI9y1z5ugsarGPMAwPgRknpo+1f5UMTaYxq97vVbX4eASln8YVSgnwjLWLbp9eHUBqkZ1GT8f2ae4amuhfm11K3owARYj0u/q4Rqpvl3Xip97AVGinu9OteH3WLYIoEXlNilYLpK6XioJclLJCZuMwHXXImZvmC1A3asADFmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by SA1PR15MB5096.namprd15.prod.outlook.com (2603:10b6:806:1df::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14; Tue, 5 Oct
 2021 22:17:38 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::7d66:9b36:b482:af0f]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::7d66:9b36:b482:af0f%8]) with mapi id 15.20.4566.022; Tue, 5 Oct 2021
 22:17:37 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Casey Schaufler <casey@schaufler-ca.com>
CC:     Jiang Wang <jiang.wang@bytedance.com>, bpf <bpf@vger.kernel.org>,
        "Cong Wang" <cong.wang@bytedance.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "Martin Lau" <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Eric Dumazet <edumazet@google.com>,
        "Christian Brauner" <christian.brauner@ubuntu.com>,
        Rao Shoaib <Rao.Shoaib@oracle.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH bpf v1] unix: fix an issue in unix_shutdown causing the
 other end read/write failures
Thread-Topic: [PATCH bpf v1] unix: fix an issue in unix_shutdown causing the
 other end read/write failures
Thread-Index: AQHXuXcwLuslzx76qEe92GzLgt4utKvDhi0AgAF0f4A=
Date:   Tue, 5 Oct 2021 22:17:37 +0000
Message-ID: <774AADB0-5AF7-413E-8046-B863826565CB@fb.com>
References: <20211004232530.2377085-1-jiang.wang@bytedance.com>
 <f7338e3e-8798-478f-bac9-a86e247e3a13@schaufler-ca.com>
In-Reply-To: <f7338e3e-8798-478f-bac9-a86e247e3a13@schaufler-ca.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
authentication-results: schaufler-ca.com; dkim=none (message not signed)
 header.d=none;schaufler-ca.com; dmarc=none action=none header.from=fb.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2cc56ef4-1cfc-4c54-543f-08d9884df097
x-ms-traffictypediagnostic: SA1PR15MB5096:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA1PR15MB5096CE73E057F80A4BA7BFA4B3AF9@SA1PR15MB5096.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iETgWxP/eMJDcpdUVnjFiZcLiPwHwkZcaPzMa8XPed54xzmiRMl9sDX7y1xaKiD6mMtH6QsHCnqI/lzaGKMd5taB3XgrXhXTtql3wK4co7lMYHvOB5o0DFRAsokakqq0spXqIEn74yLYcWxaDtfK+inJSvUOhTRDLHE6oDB+PTARbz5Ll2AlYrjqEwR17xyne8WyEEnd0etGvsgQtT2HjKDvlC6HpHaHJbdZ5gJ21ZVoxUbNSXFkuGZ3Qmwvo/V+zR4aG63CmReN8eV7QuBrfEt+fYHvEiUCxOnWyBioVK4a/Louwae/8KoxfET5aUNV5ZCENoJbdGG+nsuDCjd4EjCxQhXfrvHbrP0UymgbeNQ1Brq6xP6SglnU4iAIqr9wBd4oP/VNX/kQL4EWlkGhRXbJQ+u8HbwTFPKA/exdRceCcHtDTF7RZHjvCt1MoutmMxCIvrWtcKPwrFuzwONvYdxC7ACGjwSChc15Juy+BBCp/VFtJ1XSDto+XnxyW54mo5/Fq4VRpKP6Y9GZmS9RG8sFcVwFj9cQpaZEXf42FLnekj334A4ufLl6VCjTDzN/SloWVtaaM48/YvWn+pO5nG1/wyycJZSeinLtC8cdZ+ukASB6f6ThWPzlZlF74kaTUEs6YnuwJ6P+5RaLGob4f+H3wfMBW+vEFWXs8/3L3r0rTfIJptW5fUOr+xliRsRKCObuYpqbWAKCBRCbX7gXAbYS2aDYuGdGEKMFHt6AzxgZKSRd4ssovaqSQbIBiuiI
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8936002)(83380400001)(8676002)(4326008)(36756003)(122000001)(6916009)(76116006)(38070700005)(86362001)(91956017)(5660300002)(2616005)(38100700002)(66556008)(64756008)(33656002)(66476007)(66446008)(54906003)(2906002)(508600001)(71200400001)(7416002)(6512007)(6486002)(186003)(316002)(66946007)(53546011)(6506007)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?lh7QjTNFAanZoT/5zracdvp9QQC4z+wDuTEcg2jpqELtL2m9wwTFoqtezBx7?=
 =?us-ascii?Q?LCSbIVfB0qS6yXQEtCjjlrDQN0NmfkDnkBBCVIWAywzKO0F7ne50SC4fIsko?=
 =?us-ascii?Q?QItaqMpT8XuC+cotO6pVfOyehL0UqalwN4da+EnzrR8LcwQg3Du2L+hFlEwW?=
 =?us-ascii?Q?Mqe5Z1Gnz6eLFbILxgsfW4zVkoekeFu9tFezUBpFOBjZ7Z2ZsRystaLF5ZCo?=
 =?us-ascii?Q?v6bJzxZ/9iJCJVVzjSFKUhDqCs0zjMy7lIqDPs/Jcqs1LqSb9c1lFphg1j07?=
 =?us-ascii?Q?vWjHJMr31+aFvWSDX0aj8HMROLC3R87V55ydk+7tbqWjJGnyAhIhE5g5XTbC?=
 =?us-ascii?Q?/panAzMnjyBn7dtqmAyH2BzRILl1kVQsMuiqLKB9IxRlIOIAfaMUmvJ33D3D?=
 =?us-ascii?Q?6F+bNfY+W1jFQnU0fPKmebxQS3fwk4BUr4jYcbRMce7RZcAplzA6xaRXWRaB?=
 =?us-ascii?Q?GVr+Y9l36P/ZNjQL/LvgE1Qf4TyUARxIqeH9lKoGMIXYJJZNMyWT9D9zCvd1?=
 =?us-ascii?Q?svisFIrPb+WvpmTFh4k+Q3WFO3YZF/4KSxUEbzgzAbM3IWIZuYNlZ862zS/y?=
 =?us-ascii?Q?GvM6ggUA/1qzTfe/SX+uNROekQHRR1B7pGHyiMj3A956hvFA9KzW1EJC18KB?=
 =?us-ascii?Q?wiH4ChAxPFQTT0he7TGl3D/xA+3L2BO6H4F8aPvQzC/9BIhV9NHFinBkWxBK?=
 =?us-ascii?Q?g8JAepPdHUKcH+dsmUU3dWOxz/FJb0pUFxQhbwiWtZTSudN8AoYwc09Aa9ta?=
 =?us-ascii?Q?K267axp0L5r4ct/NV+fIF7G54sSy3cCN8ru2wycmd4mz1RntIKYxysd/ZWv7?=
 =?us-ascii?Q?gFjW7E9W302oSpv3erCk9c2eAg0gJWb3SQUQhmaXWaDwF5MOLhGGJVnemgpI?=
 =?us-ascii?Q?7AT18Q6RpkPcYD6XaU27Nw83ReW7y3Q6HQlwoIp9o2cviHMOROv43p4nF91L?=
 =?us-ascii?Q?tacUczIYl05EwqEY0kZ/IDd2WP370GfHSY+NBUWN9aO0ejZ4RXHpWnP/Qvfa?=
 =?us-ascii?Q?xTWiq4By8diQHNFZQgOtoJ2nBokIvd1LqPA1JEm6grk3UysTIMn50vVQqOJv?=
 =?us-ascii?Q?G4jmaKLZFDGa6yHiWH71fmf63Hc0vBO2RQb9NvDibqIt821cuyDVgggdLx+b?=
 =?us-ascii?Q?LimsShXKLUbd7trOdDCGhdcuZRNDFx5YKc2ShPC/wqAv1hhQk2ielJ+FY4Mk?=
 =?us-ascii?Q?M/2VNPmeJ+EgqxCr2d6iVWNRLTE4iSbOolIJbZCs80fSYgxc2QYjnKB3lWIh?=
 =?us-ascii?Q?CmZKTVXAJlf3wrhjHMBtOGyHgjRETVyjoj0viINY0OPxY3cEgYppHz051ykl?=
 =?us-ascii?Q?Fd2O4pvHaf5d1g/ndF9ch6D1RjZ/C/kIjgCBmd86eFRKFulZGiPFpQ6qPlt8?=
 =?us-ascii?Q?nV7Av6Q=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <766CB2C0EFCB344EAE83048E12FD4CCD@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2cc56ef4-1cfc-4c54-543f-08d9884df097
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Oct 2021 22:17:37.8361
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QOSPmwpX1VgFTWh0X/SCPeFlBDXDk7BC6chA5YCCi9Bcui6AvQKKnYZrDSNl9cD02A5GvUoO0LcxCa/BmamOEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB5096
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: uUmL3nHGPJyh6MppsXC6S79XgRZm_i6_
X-Proofpoint-ORIG-GUID: uUmL3nHGPJyh6MppsXC6S79XgRZm_i6_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-05_04,2021-10-04_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 priorityscore=1501 suspectscore=0
 impostorscore=0 phishscore=0 adultscore=0 clxscore=1015 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110050131
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Oct 4, 2021, at 5:04 PM, Casey Schaufler <casey@schaufler-ca.com> wrote:
> 
> On 10/4/2021 4:25 PM, Jiang Wang wrote:
>> Commit 94531cfcbe79 ("af_unix: Add unix_stream_proto for sockmap")
>> sets unix domain socket peer state to TCP_CLOSE
>> in unix_shutdown. This could happen when the local end is shutdown
>> but the other end is not. Then the other end will get read or write
>> failures which is not expected.
>> 
>> Fix the issue by setting the local state to shutdown.
>> 
>> Fixes: 94531cfcbe79 (af_unix: Add unix_stream_proto for sockmap)
>> Suggested-by: Cong Wang <cong.wang@bytedance.com>
>> Reported-by: Casey Schaufler <casey@schaufler-ca.com>
>> Signed-off-by: Jiang Wang <jiang.wang@bytedance.com>
> 
> This patch looks like it has fixed the problem. My test cases
> are now getting expected results consistently. Please add any
> or all of:
> 
> Tested-by: Casey Schaufler <casey@schaufler-ca.com>
> Reviewed-by: Casey Schaufler <casey@schaufler-ca.com>

Acked-by: Song Liu <songliubraving@fb.com>

> 
>> ---
>> net/unix/af_unix.c | 9 +++++----
>> 1 file changed, 5 insertions(+), 4 deletions(-)
>> 
>> diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
>> index efac5989edb5..0878ab86597b 100644
>> --- a/net/unix/af_unix.c
>> +++ b/net/unix/af_unix.c
>> @@ -2882,6 +2882,9 @@ static int unix_shutdown(struct socket *sock, int mode)
>> 
>> 	unix_state_lock(sk);
>> 	sk->sk_shutdown |= mode;
>> +	if ((sk->sk_type == SOCK_STREAM || sk->sk_type == SOCK_SEQPACKET) &&
>> +	    mode == SHUTDOWN_MASK)
>> +		sk->sk_state = TCP_CLOSE;
>> 	other = unix_peer(sk);
>> 	if (other)
>> 		sock_hold(other);
>> @@ -2904,12 +2907,10 @@ static int unix_shutdown(struct socket *sock, int mode)
>> 		other->sk_shutdown |= peer_mode;
>> 		unix_state_unlock(other);
>> 		other->sk_state_change(other);
>> -		if (peer_mode == SHUTDOWN_MASK) {
>> +		if (peer_mode == SHUTDOWN_MASK)
>> 			sk_wake_async(other, SOCK_WAKE_WAITD, POLL_HUP);
>> -			other->sk_state = TCP_CLOSE;
>> -		} else if (peer_mode & RCV_SHUTDOWN) {
>> +		else if (peer_mode & RCV_SHUTDOWN)
>> 			sk_wake_async(other, SOCK_WAKE_WAITD, POLL_IN);
>> -		}
>> 	}
>> 	if (other)
>> 		sock_put(other);

