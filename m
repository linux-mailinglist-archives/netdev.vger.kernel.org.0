Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73480195DE0
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 19:46:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727352AbgC0Sql (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 14:46:41 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:20860 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726540AbgC0Sqk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 14:46:40 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02RIkFsR032290;
        Fri, 27 Mar 2020 11:46:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=xXo763gIZmXy3APD25A+mrwTTzIOWbHsTp3HUClDDh4=;
 b=L9rl+rXxy/cE0chZBEOlTNBh/ekKeUvAaQltFR82lXnwNV5PfIvNUmXVqBBq/fa8Zx89
 9Nt7B47CuRVSY1AEIc27Utlq4ZRf51OuI4isNQxnzPZd0ZUgGiZ5TIQk+yBsjTbmkD3X
 6PrCEM75xrcUN2Nkyy02KdfcFXjinUTTov8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3013amn9bc-19
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 27 Mar 2020 11:46:27 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Fri, 27 Mar 2020 11:46:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=APe8GFcg6JhIpBY756iIvO7KJSkCUjHxPD+/rihNVHtdF0opuaDsalzg+0dV95T5yUHeKmTAY8sjkri9EWe6eK28r3m6xI1uci0IOIaM94RqOgZJsRCy5270TvsgDDUYvr2IHksbcYFje1e0/ewJEKSdH2unoS+I48j3W4DXwjAIcT+TEGrXQ8vLmtkabdidkxjSCj72hnEoFg1uMRVp5JT+NWxiMwZtkiINM6oPPiqF0cLETl7XLU47IPrKJwKEixx6WAbIhR4ITfjyIqEyGzF+1IcA0jysbBf08vPwr7qz5Havtc9tMdy2L4aPC3DDluauUqYoJ/SLWtrKhvGFhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xXo763gIZmXy3APD25A+mrwTTzIOWbHsTp3HUClDDh4=;
 b=nQWxE18gMnoL/VmRhYGEWl1ZbK2laM+QIXu7WMRtBBf7mXrNwUQH67+2jEkFCD4iKkhB2+qLgyWr7LSnBo1yb6oHDO75gWV7YqyHmYfw8xgpfgpZp8vDi4t3UMy7XJxNrzUGHiYI9tEFMlmVwXSG3aoo3Ur2Pa74NQP2PPmmWKBwurCtlncGS+4LarOIp5HCxuh7BGKkvnQ+CykopYrMbMRZDKOg0wc4CQA6iIZSvKxpdyfKEC1P7j7hx09dczyZPfhYP9sOsxkHDdN+2QBs9WiwshtvP5TmI9kNE9vNkc7eefshML7VkFBOJy8524Y3WgsqvthCmEEIN0cgdLd3pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xXo763gIZmXy3APD25A+mrwTTzIOWbHsTp3HUClDDh4=;
 b=j78mgYtld/KogGfwsXvZ4mG0vFC/EfzIGffnK3PzMdc50D3qq8o6ludg7KRlqIl4rcxHVXWy2Px9VMErpi3GM0JEUt/R5yB4yJHSo6W5Tl+T2nctYsN4/WwBJ4ypmiLTpqhwKrnQSCweLGydyzEOBydNlWonFqxHEQa062uMHL8=
Received: from MW2PR1501MB2171.namprd15.prod.outlook.com
 (2603:10b6:302:13::27) by MW2PR1501MB2172.namprd15.prod.outlook.com
 (2603:10b6:302:8::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.18; Fri, 27 Mar
 2020 18:46:24 +0000
Received: from MW2PR1501MB2171.namprd15.prod.outlook.com
 ([fe80::2ca6:83ae:1d87:a7d9]) by MW2PR1501MB2171.namprd15.prod.outlook.com
 ([fe80::2ca6:83ae:1d87:a7d9%7]) with mapi id 15.20.2835.025; Fri, 27 Mar 2020
 18:46:24 +0000
Date:   Fri, 27 Mar 2020 11:46:21 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Joe Stringer <joe@wand.net.nz>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <daniel@iogearbox.net>, <ast@kernel.org>, <eric.dumazet@gmail.com>,
        <lmb@cloudflare.com>
Subject: Re: [PATCHv3 bpf-next 0/5] Add bpf_sk_assign eBPF helper
Message-ID: <20200327184621.67324727o5rtu42p@kafai-mbp>
References: <20200327042556.11560-1-joe@wand.net.nz>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200327042556.11560-1-joe@wand.net.nz>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: CO2PR04CA0105.namprd04.prod.outlook.com
 (2603:10b6:104:6::31) To MW2PR1501MB2171.namprd15.prod.outlook.com
 (2603:10b6:302:13::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:1c15) by CO2PR04CA0105.namprd04.prod.outlook.com (2603:10b6:104:6::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.20 via Frontend Transport; Fri, 27 Mar 2020 18:46:23 +0000
X-Originating-IP: [2620:10d:c090:400::5:1c15]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: afbe3be7-762d-4834-15d5-08d7d27f2617
X-MS-TrafficTypeDiagnostic: MW2PR1501MB2172:
X-Microsoft-Antispam-PRVS: <MW2PR1501MB217202758522C359FFDD4308D5CC0@MW2PR1501MB2172.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 0355F3A3AE
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(346002)(39860400002)(396003)(136003)(376002)(366004)(66476007)(5660300002)(66946007)(81166006)(81156014)(66556008)(4326008)(8676002)(6496006)(8936002)(2906002)(52116002)(55016002)(1076003)(33716001)(86362001)(9686003)(478600001)(316002)(186003)(6916009)(16526019);DIR:OUT;SFP:1102;SCL:1;SRVR:MW2PR1501MB2172;H:MW2PR1501MB2171.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0/CcfQIVdMmL5JqjJpCm0uqzLJM59TLa0fhh+aVtTOj0FlopZWjRvqllD3HjPj6dmmSIu/JS6lDQ6GSPWuHclc2+uWfWZVczMlcEQuPYO0eIt+BxdUL56Wi9Q97ET+S4EiEvNEaz5IRzBlo9rDVh5VcdmlisP3JuzaudpiTSRM0psZJ9ilEhwl902QDWkRbud68Lrd3YmHhxYrBOJdrN4EiSLqmZII8AIGK63Z2FhOvsUuAocGmmK/xsBhl0Lha0Gok1xAyzIVgQmWEZ6EboMW5oQ9z9KOS0R5NIVoDOPiTzu+WrP7GRcnEIcwgO0xjvKQrFLEfxR9L7KjmYRV9GmoZ/RyM8gBvWu4Vsd6+Nx6Ol/DePVF3lWDp9gyL2vIlXjsYif8Id9uQHGP2OxXbSm9VF0lqQJU/F92ab0RyL3aj6rY8C7PlINlx1NhlGVtoM
X-MS-Exchange-AntiSpam-MessageData: 919Ns63HqawtpY2XnoVp0czaZAidw4USNccgk8aQe1LtUmdeFUnDqmKY1ltP2HA4+/JbyzW8Zn3VXiO2vw7lbuETBTesqoea2i8dDdSfLuHEUvxolJrxv7AqtCl8F4RZvdJOpiBPqwhyeBUJr0VZZKEbLvJ2yLZ+sUs2Yfi+cPeydhlZ/z/9TUVo26O1lQrR
X-MS-Exchange-CrossTenant-Network-Message-Id: afbe3be7-762d-4834-15d5-08d7d27f2617
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2020 18:46:24.0719
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0XUZYkVjalNwuSDaUIDxXOAy5lGVXw6nPxu0/hmnvZ1SJ/upy8A019+k7umk+9y4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR1501MB2172
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-27_06:2020-03-27,2020-03-27 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0 clxscore=1015
 mlxscore=0 malwarescore=0 adultscore=0 suspectscore=2 phishscore=0
 bulkscore=0 mlxlogscore=999 priorityscore=1501 impostorscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003270156
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 26, 2020 at 09:25:51PM -0700, Joe Stringer wrote:
> Introduce a new helper that allows assigning a previously-found socket
> to the skb as the packet is received towards the stack, to cause the
> stack to guide the packet towards that socket subject to local routing
> configuration. The intention is to support TProxy use cases more
> directly from eBPF programs attached at TC ingress, to simplify and
> streamline Linux stack configuration in scale environments with Cilium.
> 
> Normally in ip{,6}_rcv_core(), the skb will be orphaned, dropping any
> existing socket reference associated with the skb. Existing tproxy
> implementations in netfilter get around this restriction by running the
> tproxy logic after ip_rcv_core() in the PREROUTING table. However, this
> is not an option for TC-based logic (including eBPF programs attached at
> TC ingress).
> 
> This series introduces the BPF helper bpf_sk_assign() to associate the
> socket with the skb on the ingress path as the packet is passed up the
> stack. The initial patch in the series simply takes a reference on the
> socket to ensure safety, but later patches relax this for listen
> sockets.
> 
> To ensure delivery to the relevant socket, we still consult the routing
> table, for full examples of how to configure see the tests in patch #5;
> the simplest form of the route would look like this:
> 
>   $ ip route add local default dev lo
> 
> This series is laid out as follows:
> * Patch 1 extends the eBPF API to add sk_assign() and defines a new
>   socket free function to allow the later paths to understand when the
>   socket associated with the skb should be kept through receive.
> * Patches 2-3 optimize the receive path to avoid taking a reference on
>   listener sockets during receive.
> * Patches 4-5 extends the selftests with examples of the new
>   functionality and validation of correct behaviour.
> 
> Changes since v2:
> * Add selftests for UDP socket redirection
> * Drop the early demux optimization patch (defer for more testing)
> * Fix check for orphaning after TC act return
> * Tidy up the tests to clean up properly and be less noisy.
> 
> Changes since v1:
> * Replace the metadata_dst approach with using the skb->destructor to
>   determine whether the socket has been prefetched. This is much
>   simpler.
> * Avoid taking a reference on listener sockets during receive
> * Restrict assigning sockets across namespaces
> * Restrict assigning SO_REUSEPORT sockets
> * Fix cookie usage for socket dst check
> * Rebase the tests against test_progs infrastructure
> * Tidy up commit messages
lgtm.

Acked-by: Martin KaFai Lau <kafai@fb.com>
