Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54C33389DF1
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 08:30:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230315AbhETGcO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 02:32:14 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:52112 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229534AbhETGcN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 02:32:13 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14K6Ob6D019394;
        Wed, 19 May 2021 23:30:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=a629EcM/2HD3ECiwzJ3JDru7BLEAhd8j5txkwfKPH7E=;
 b=YsAvruTkX+thE/bsE03LcRKNN0eelhnsnHWLdnWRIMnlQfVa/jD5y9dnjLkjmPNr38Dp
 QmgezOEuWkOPtJF+u/OErpVkpfq66C2dMDVf/mDhnEdhbn0ilXWhEQzpQiJpnOzIFOiE
 IsNy+TXox6zCuVoC86fD8m+E2P3EADcx53Q= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 38n85633yq-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 19 May 2021 23:30:36 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 19 May 2021 23:30:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mbKskATdkt1xaSDsS1noDEGBE5hVIoSxdBtaNSXShmE4/JC6bRABmwwit8oT9w7hE+2cXxeTsmGv9f8fqmaHZ7VA3ewhUBnfgdsu7iAkZ4UwADzbYFSPNlRMizJQuCh6SvOrJHTMYSeg9aQ52bwtDro8SMKxUdEeu9L3XL391FrpGVsEvSC86PrwSRhIgWcglGoUOd0dmBs1zAtUbwvRXvz0NqwzDHdmSn4nfCH2ou0cs8BEcJOew2+aY0qqYf9HVytOZi0TJTX0T3ucfaseQ2WI7ltUunNJcYh17yWz3c0pBM/gxIK5EJfWZsOtWS6T7aZhXvjiQ4YVIwcto19TLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TIYRPxVRi0MFbP1P1tEDWCx3rHZQxbE6MAAlt78laN8=;
 b=Iaa7j9uwUoiEq9OeKP/CVcfQKDnZHP+L1eAY6KDxDohCF+ZWmt5Nk8MY3BpeOARffSy+Hib2oPEm0k1gTY/Rw9NAfCLlyPuCj1+E6TqnPBKxKLTJWq52UJ496hM2ARpSAMqGRYzDpCEsWVAKhi+tQiOTLQmZ8BTU2g2KyEZsHb3Brj4i0THpvEVg8rceTiORsOu3OXaLBAXKPiE05OJYefHnUbURBJ9ciGGmJBCdQITJaUWMyzy3glWyDfGtUF582mEnLdxcG2bB7xeENp0Ae5HvI6J0RSAFS4CoICvFsApPFx3dZjxtrDFTAotVTPLqm1nEz0pxk6pLK85AWlLa1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: amazon.co.jp; dkim=none (message not signed)
 header.d=none;amazon.co.jp; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BY3PR15MB4898.namprd15.prod.outlook.com (2603:10b6:a03:3c1::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.27; Thu, 20 May
 2021 06:30:32 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::718a:4142:4c92:732f]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::718a:4142:4c92:732f%6]) with mapi id 15.20.4129.034; Thu, 20 May 2021
 06:30:32 +0000
Date:   Wed, 19 May 2021 23:30:29 -0700
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
Subject: Re: [PATCH v6 bpf-next 00/11] Socket migration for SO_REUSEPORT.
Message-ID: <20210520063029.vrnv5eld6w4glea6@kafai-mbp.dhcp.thefacebook.com>
References: <20210517002258.75019-1-kuniyu@amazon.co.jp>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210517002258.75019-1-kuniyu@amazon.co.jp>
X-Originating-IP: [2620:10d:c090:400::5:1f3d]
X-ClientProxiedBy: MW3PR05CA0029.namprd05.prod.outlook.com
 (2603:10b6:303:2b::34) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:1f3d) by MW3PR05CA0029.namprd05.prod.outlook.com (2603:10b6:303:2b::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.11 via Frontend Transport; Thu, 20 May 2021 06:30:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f5e1e190-2ed9-4915-3293-08d91b58c503
X-MS-TrafficTypeDiagnostic: BY3PR15MB4898:
X-Microsoft-Antispam-PRVS: <BY3PR15MB4898F71493B52242570AFC2ED52A9@BY3PR15MB4898.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:143;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HDJY0PQdGVSHEBl/jglgfRUwcT56Czv0pWEBQPuEdz02KEYkiT7wttptLLuFiKrARyocMkNbJuXbJMzJfJ7jUCHUUCIr5FqgTYvtkWfn1o72FjuzA8w5HlF2GdJOOcPncWiI9K+xpNiqE9fmPaIl4GDGR0ibHWEyalQsT+Wlqq5H5BbFdNKKwMaoloxGzmwWgjm1eYIXI+mfLgEpnCgqdWzT0ITpqm3++afODwLoY9Cr8tf8Usp/cjK1D7RA/GrDisCcJZDvzydPSLSTREiIN40ytn5iMEKbS4ZWqF/BhKHHCuG6qIKWMvaHtXpPEwYrkOR3s2ZcfclUTyf5RzmUKZzk2TCjuqbLGkiNUQq9hVPNyv8QTVVjJz5YJh1kgL7VmuL1edUItJSz9NdC6W4/4XHv7YsvVCquW87srPakETPJRr3hL5DBBavHCK55K1tnXSawKyhqGIYwS4eNwGsOWfBwsSPpMxyWGW0lwCUyb/w+AVjYBsLlCMOr76icQCEopHgjbt3AH4X0RmtxZjjTjH1J+mcOJjeBz6rfBxu1/4sRHo/4PHD8BeFrB9r5bNlIvft9BYyGy3QC5yvxnAEmOlPn4pN6FnBPBfk4b+3cN0cd32Nhj5Hb7ZLHkLidIoztORozI22h787pIw8RCZu4P8n29Yd2OgT8sV8wDTQY0idGlAGIIo3ig7RloGN4xjtX
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(366004)(136003)(39850400004)(396003)(5660300002)(6916009)(52116002)(7696005)(7416002)(86362001)(66946007)(6506007)(478600001)(2906002)(966005)(16526019)(9686003)(316002)(8676002)(55016002)(8936002)(66556008)(66476007)(186003)(83380400001)(54906003)(1076003)(4326008)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: NN6UrYFnQFNQ/7n+LPLfXBenmBNU+AlOrgmxo7fAGvgRJZvhkK1fmTbiuqUZ5D7xxMkHl9BQyiQqxptBD4+dviBOSFvEVJ8l9gNifeBn11hRLTaWmn1dLkcTfgslsAaRIcs2brFEg+d6HBaz9BL7hMJXQ1VyhAxUSZuITCmiSDhBLUsDBKqakmEvVQ2vcOrffPkhCBIQUltGnyPjfd8xO/8AMWVdjzN4RfxUDQKNTuqZ4KHg9zUGHz7YNxWWqt8+JomRxFV9ok0P1tjmUfHE9/23MgrZjCKw/wZyFidbtfQTzU+pfoCeZqbK3+/DbxPzwsSkmxICFHDKotOycm3qNSgtXVf5YJ25+aGjeTsw0agmiYzSrB+Vbk9dbShqDgsJOuOpB2D0RKaxack16chjvZBEG9TaQAiQnptEcPSywUSBDMoLeNd0Y2Nzo6oEdUmDAaNydPnnslda5sCDdPx2ly2SrWdlfdEZ3NwK5C3TT3hnQcf+cfIADp3J1BTDQkiNF1ptkFtgJ10lIe8RbWYB7EyzQjSKI1XqgkRVMLXGnsl6pyA9md3bz76wTgIYaisE0MPsZRrtmromn8Mq7tQHQ8YPyU95ABEEu4k3+aj0FL5FD3Q6rD8YzxlKFGNsP71OoFp5KVut3RgpQJKVAOV6a9lhZPXgV4H4idOReAtR4IIQ0qlb/STut5qWIIeC8UK/6eh+NJT0bmqOBj2J0q8SsfdF1wCzIr241v9QR0ZPLVc5kSziq6o56CtjdHO5NiIg0N+rG6+y/jFpXVHzPPfDzg==
X-MS-Exchange-CrossTenant-Network-Message-Id: f5e1e190-2ed9-4915-3293-08d91b58c503
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2021 06:30:32.8587
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +eIJ36HoeJ7oHoqrEg+WiWnZZeTCX9kxAovWTAL8wwGCcv/u5f4b+R6xXvSt7um3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR15MB4898
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: DJhpelUcKud_4czImDwoxfU-u7WBvo_C
X-Proofpoint-GUID: DJhpelUcKud_4czImDwoxfU-u7WBvo_C
X-Proofpoint-UnRewURL: 1 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-19_10:2021-05-19,2021-05-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 adultscore=0
 spamscore=0 priorityscore=1501 impostorscore=0 malwarescore=0
 lowpriorityscore=0 phishscore=0 bulkscore=0 mlxlogscore=999 clxscore=1015
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105200052
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 17, 2021 at 09:22:47AM +0900, Kuniyuki Iwashima wrote:
> The SO_REUSEPORT option allows sockets to listen on the same port and to
> accept connections evenly. However, there is a defect in the current
> implementation [1]. When a SYN packet is received, the connection is tied
> to a listening socket. Accordingly, when the listener is closed, in-flight
> requests during the three-way handshake and child sockets in the accept
> queue are dropped even if other listeners on the same port could accept
> such connections.
> 
> This situation can happen when various server management tools restart
> server (such as nginx) processes. For instance, when we change nginx
> configurations and restart it, it spins up new workers that respect the new
> configuration and closes all listeners on the old workers, resulting in the
> in-flight ACK of 3WHS is responded by RST.
> 
> To avoid such a situation, users have to know deeply how the kernel handles
> SYN packets and implement connection draining by eBPF [2]:
> 
>   1. Stop routing SYN packets to the listener by eBPF.
>   2. Wait for all timers to expire to complete requests
>   3. Accept connections until EAGAIN, then close the listener.
> 
>   or
> 
>   1. Start counting SYN packets and accept syscalls using the eBPF map.
>   2. Stop routing SYN packets.
>   3. Accept connections up to the count, then close the listener.
> 
> In either way, we cannot close a listener immediately. However, ideally,
> the application need not drain the not yet accepted sockets because 3WHS
> and tying a connection to a listener are just the kernel behaviour. The
> root cause is within the kernel, so the issue should be addressed in kernel
> space and should not be visible to user space. This patchset fixes it so
> that users need not take care of kernel implementation and connection
> draining. With this patchset, the kernel redistributes requests and
> connections from a listener to the others in the same reuseport group
> at/after close or shutdown syscalls.
> 
> Although some software does connection draining, there are still merits in
> migration. For some security reasons, such as replacing TLS certificates,
> we may want to apply new settings as soon as possible and/or we may not be
> able to wait for connection draining. The sockets in the accept queue have
> not started application sessions yet. So, if we do not drain such sockets,
> they can be handled by the newer listeners and could have a longer
> lifetime. It is difficult to drain all connections in every case, but we
> can decrease such aborted connections by migration. In that sense,
> migration is always better than draining. 
> 
> Moreover, auto-migration simplifies user space logic and also works well in
> a case where we cannot modify and build a server program to implement the
> workaround.
> 
> Note that the source and destination listeners MUST have the same settings
> at the socket API level; otherwise, applications may face inconsistency and
> cause errors. In such a case, we have to use the eBPF program to select a
> specific listener or to cancel migration.
> 
> Special thanks to Martin KaFai Lau for bouncing ideas and exchanging code
> snippets along the way.
> 
> 
> Link:
>  [1] The SO_REUSEPORT socket option
>  https://lwn.net/Articles/542629/ 
> 
>  [2] Re: [PATCH 1/1] net: Add SO_REUSEPORT_LISTEN_OFF socket option as drain mode
>  https://lore.kernel.org/netdev/1458828813.10868.65.camel@edumazet-glaptop3.roam.corp.google.com/
> 
> 
> Changelog:
>  v6:
>   * Change description in ip-sysctl.rst
>   * Test IPPROTO_TCP before reading tfo_listener
>   * Move reqsk_clone() to inet_connection_sock.c and rename to
>     inet_reqsk_clone()
>   * Pass req->rsk_listener to inet_csk_reqsk_queue_drop() and
>     reqsk_queue_removed() in the migration path of receiving ACK
>   * s/ARG_PTR_TO_SOCKET/PTR_TO_SOCKET/ in sk_reuseport_is_valid_access()
>   * In selftest, use atomic ops to increment global vars, drop ACK by XDP,
>     enable force fastopen, use "skel->bss" instead of "skel->data"
Some commit messages need to be updated: s/reqsk_clone/inet_reqsk_clone/

One thing needs to be addressed in patch 3.

Others lgtm.

Acked-by: Martin KaFai Lau <kafai@fb.com>
