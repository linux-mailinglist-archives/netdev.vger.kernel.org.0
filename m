Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8760B41DCA2
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 16:46:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351645AbhI3Ose (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 10:48:34 -0400
Received: from mail-dm3nam07on2090.outbound.protection.outlook.com ([40.107.95.90]:57994
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1351934AbhI3OsY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Sep 2021 10:48:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DIH6tP7DXi2LTB4Q9rp2bZE2jxxN4ZC5kq26TbFM5rC9vjxt9X7jHPDwZ336LfbRXW4IH8576ISfXvKtQ25K5anIDd7lBLdAUR8r117aTms2gC8nQCWZIyE1BBrXq4zfqxCx0sZ09Xr/aQ1ySi11zbwfp1Q4lj6NvC+A59ZMI+MCH3V2DqoXNxVNqr0rbNgr0IswbtluFP/xvXrBkJxRm2iscGakFgOiM0v5VV4ZV7G3GfhbnS6UbrirFHbvKaDGdnBZDsNh8PGjpJg+A02iQSI1OzaZYsgP1B8XQ/mqXr8mraP7iOyvVQTgYqjGdGEGyE0edBFp1dgfNQHMP5Mt3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JqABVKMelV93d9uR2vqUgKcgNWNt+pcFjHDQR77ASnE=;
 b=LTbci0o2Qys0P7CrhVHAfn1spuC0m7aJ9kmxEW56IxujVLXCVWLr6Pq56uz2YrFqEZsP3rqhz9gpUADNOSftbZjvNnqPHWWTojUq6jwM4pW+ZsDv61D0NOIBKT2wgDln6pyTRG8jO/F15VkfMFV138ixy0f0Qi3qreJ8jdpqpzPnMqVT1Hsc9hkNxGevHPSFZNRGOQKZXqHcXRH+Ux+/T0vDxdbyksBCloHXd4s7I6N8RICsaBzq6V6shO0V96t/Q53AMLXJNUxmCPfsy2JzNPx3z6yjteFHGpj+zoAaNCNyGZgBb7tyqtmabRgzepGNept6zep4+sUOXT3/vFBhfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JqABVKMelV93d9uR2vqUgKcgNWNt+pcFjHDQR77ASnE=;
 b=UH885eG33DpD8K0BfW6+clqZgXIz1ha2IMzqPOI0t4G0QRYC0br7VX7VaP9R4VR4mC9KNro6pogQWKdeAArMPQCVvnHawaV9iOxt3wFQKx/bD1OhCPw1GBwd/QcZcX9waMjedb8XpAWUx03OyWewshMEzX/nobeYYAJmfNnDQzA=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=corigine.com;
Received: from DM6PR13MB4431.namprd13.prod.outlook.com (2603:10b6:5:1bb::21)
 by DS7PR13MB4751.namprd13.prod.outlook.com (2603:10b6:5:38c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.9; Thu, 30 Sep
 2021 14:46:40 +0000
Received: from DM6PR13MB4431.namprd13.prod.outlook.com
 ([fe80::b40c:9bd9:dfcd:7ff0]) by DM6PR13MB4431.namprd13.prod.outlook.com
 ([fe80::b40c:9bd9:dfcd:7ff0%5]) with mapi id 15.20.4587.008; Thu, 30 Sep 2021
 14:46:40 +0000
Date:   Thu, 30 Sep 2021 16:46:34 +0200
From:   Niklas =?iso-8859-1?Q?S=F6derlund?= 
        <niklas.soderlund@corigine.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Simon Horman <simon.horman@corigine.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Yu Xiao <yu.xiao@corigine.com>,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Louis Peens <louis.peens@corigine.com>
Subject: Re: [PATCH net] nfp: bpf: Add an MTU check before offloading BPF
Message-ID: <YVXNype34MW7Swu3@bismarck.dyn.berto.se>
References: <20210929152421.5232-1-simon.horman@corigine.com>
 <20210929114748.545f7328@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210929114748.545f7328@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-ClientProxiedBy: AS9PR06CA0118.eurprd06.prod.outlook.com
 (2603:10a6:20b:465::20) To DM6PR13MB4431.namprd13.prod.outlook.com
 (2603:10b6:5:1bb::21)
MIME-Version: 1.0
Received: from bismarck.dyn.berto.se (84.172.88.146) by AS9PR06CA0118.eurprd06.prod.outlook.com (2603:10a6:20b:465::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.13 via Frontend Transport; Thu, 30 Sep 2021 14:46:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3a8f58ca-759c-4a57-34c7-08d984211cbd
X-MS-TrafficTypeDiagnostic: DS7PR13MB4751:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DS7PR13MB47517F941C4BB5515D405A80E7AA9@DS7PR13MB4751.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: acMwjS6FR5c/svvcAsDtxwFntKwO0A7kjsWd4DEALKvRB8EQcwk5VLCRYWNHhrL2O9FPuTXr1X0yusH1Fkr6s/uwPMnKgY4zATASva3ITqFSGSqWjOwj2xNxFQiAQWXCzrKH97PO6PvNz2+Ul6JU2f27uKujzR7u20PkvH2IqYRX2wV5Wk0Rwk81dNYCEJCK3oro9mreef5tDtFg+cWgxKCsNhYl/UpQNqZRKnj27CX1PbmRkFVjw1ISLvoEMh3beucu9cTDoTtD4ro9NK9TWi6RB+fjrZoZAAn4YnXtM9OowpNk5r9Q4rqK98MypHrS/BpNJgXCL5AyHMjloL50BcOvJLKZtnM0bshqiGp24fhXqKj0PLwanjQFZLs485IfaAsbrsyHr52Aiyt0n1ZTLFXB4fUiZBqlO6CmssvSM/XaH7TU//gKCfbCPSPlPezogXMBmPnWuIFcHOU1Cwv65s2GkDgSMLKKM1X2WxosO477pIfxxbRjaB3nT62mvXSwRFxJLnRcsAyijzq0mHKo3yeJvpFIQvG6G9r/pjzE/PtJK9GxACvkYR0Bb1cBLLWgVKQiyzjvmN3T9FQU/h0Pjp7+z0xXFpXxFIE6BnE7ZjAPICebxokctqqIMnT5aC5st8E5vtMDqqUhOVNfWbgkBO6OdNMh4O5+45E3Oa8AJidgrIPWo9beVeEqatQvt+x74EQDD9aZIMVNs8/51t+qdw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR13MB4431.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(346002)(366004)(376002)(39830400003)(9686003)(55016002)(8936002)(956004)(83380400001)(26005)(66574015)(316002)(66476007)(38350700002)(38100700002)(66556008)(107886003)(8676002)(5660300002)(66946007)(86362001)(6666004)(6506007)(2906002)(4326008)(53546011)(508600001)(7696005)(52116002)(6916009)(186003)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?mjOc0cwouRbI/yBt70Caujoq3DMFE22NFFlO/hf6oFR4ZyHG+K4fw77MCl?=
 =?iso-8859-1?Q?+GHKUHeG6FnNsxB6A/hfOSBPzZp0CQ+g1Te/+hPvoPfuyIyqY70X0FumCC?=
 =?iso-8859-1?Q?pAw0Z+H1c7vE5x8o3IjtZZaXRtHYSvO1ndGzCLt3wRsz8MNpVuJZKmCWjj?=
 =?iso-8859-1?Q?JU8v0cermBI9dJCbv5gcuS8lA4xNY3C9rTwevYjUpQyO600gmmoJsE5rDe?=
 =?iso-8859-1?Q?B8Cl81HZ4fQC+brdtt3a5IHUcVzRksWDuX88th3SHDPoqR3qg6pLNNczsT?=
 =?iso-8859-1?Q?XUz15IDsYyHHtXSSPJp7dJ/11OipsBC/Fgli5l0kpMOFOpm1LRPsv3Pe8H?=
 =?iso-8859-1?Q?EDtT64c17IOMXaNbSXk9UXp7JszfzABm8fBzCEQ7GqDA10yst2+/zMychH?=
 =?iso-8859-1?Q?mFCIdeNF5mqZoCH5Eh6StBwFaK/WABtmRqpjt2EvWOeHIaAtORuZRXx7m1?=
 =?iso-8859-1?Q?oR79ua+Oh2V5gq/2GrvJnvBui3cN62itMWgX3i597kDhayvte13OrALcDW?=
 =?iso-8859-1?Q?kPQjeH0e7MgQTL6K1Tn1w1x9Eje93I0czNKtqhukL20IiJ3pcSfJ+2SYau?=
 =?iso-8859-1?Q?LIhLIysqd3MZK3F89I6wT/eQMlJOcyBwSbMmtKN6Q+KtLQ25qAbbUGB49t?=
 =?iso-8859-1?Q?1gBM2euM4BPZOf9rndjEerVuXbLBNTObGKdoyY0tdlqAkIuVWzvKVyWYIE?=
 =?iso-8859-1?Q?tgBsC5NcIPou73Vh+BHKg0IhkeV2SntPrazO3RWSYhzcchc2ktb2yzs9lw?=
 =?iso-8859-1?Q?qoYJ2zPdwwK+eU1vjNX24g+q3Np2SnXrSXuElcoiX1+Hb5pBmNNyHwWrtB?=
 =?iso-8859-1?Q?LjQ4FUVUJn8QPvW8CQPUBLzT+ZycHUzYUOzWVT0DNykeA5kM5NvhRXRL4e?=
 =?iso-8859-1?Q?CtJSesJcUq0Lkt5nDWSLztd2geE0G4JDz/yR7cahrDk4d0E9AjmL8sYo+I?=
 =?iso-8859-1?Q?fhm07WJlQm257MPJjOB3Lrd9hzJi1vzZVFBg1gxL4I8UzhTrjHTo3AwKxZ?=
 =?iso-8859-1?Q?9kehPxyxwUF2UQm1GNO0pKRK6k7O/Ls8RLqHLtmuK7DHH2LuwPFpCyL5Gm?=
 =?iso-8859-1?Q?prngl+/Lvljv04GLfe4mXZWlatK131x2uXMzaqdwi9gz7dUqDP9XixsW2c?=
 =?iso-8859-1?Q?4OLUegB7tYYFse1eMBpQxgQthukW/wx6I7G6q1xfTxiNdLBu+VzeirHA1r?=
 =?iso-8859-1?Q?4rZKfjIbXR9z9DJFloBxVfY5BR+tttHKWjg7sAQs2aOx3JCMEOOvi5LVP2?=
 =?iso-8859-1?Q?IzZ4x/gGowMlHAskIMthNCH7RRJnyn+nXb0pU/1PS5X4h4p5HIvO765ocx?=
 =?iso-8859-1?Q?MbRktRD9b06JXmXCX4tNo3Y81JM7oNMQYzH9IwvEZ4TQBCW3w8ph4pCYl8?=
 =?iso-8859-1?Q?r0GBsEAjSD?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a8f58ca-759c-4a57-34c7-08d984211cbd
X-MS-Exchange-CrossTenant-AuthSource: DM6PR13MB4431.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2021 14:46:40.4597
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 48J4WmOMoyGQx4DsTnuQI/LVGFo5Qz37xxKQC4/vkt/3DSiw3IEkVWTSZkK0nw1P9xDeDH9ey82oxUgAIsSmbWxVnHhzzXz093S1CYfI230=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR13MB4751
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Jackub,

Thanks for your feedback.

On 2021-09-29 11:47:48 -0700, Jakub Kicinski wrote:
> On Wed, 29 Sep 2021 17:24:21 +0200 Simon Horman wrote:
> > From: Yu Xiao <yu.xiao@corigine.com>
> > 
> > There is a bug during xdpoffloading. When MTU is bigger than the
> > max MTU of BFP (1888), it can still be added xdpoffloading.
> > 
> > Therefore, add an MTU check to ensure that xdpoffloading cannot be
> > loaded when MTU is larger than a max MTU of 1888.
> 
> There is a check in nfp_net_bpf_load(). TC or XDP, doesn't matter,
> we can't offload either with large MTU since the FW helper (used to be) 
> able to only access CTM. So the check is on the generic path, adding
> an XDP-specific check seems wrong.

I understand your point and it make sens. The check in 
nfp_net_bpf_load() in the generic path do indeed check for this, but in 
a slightly different way. It verifies that the BPF program don't access 
any data that is not in CMT.

The original problem this patch tried to address was to align the 
behavior that the MTU is verified differently when the BPF program is 
loaded and when the MTU is changed once the program is loaded.

Without this patch we had the following behavior,

    # ip link set ens5np0 mtu 9000
    # ip link set dev ens5np0 xdpoffload obj bpf_prog.o sec testcase
    # ip link show dev ens5np0
    11: ens5np0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 9000 xdpoffload qdisc mq state UP mode DEFAULT group default qlen 1000
	link/ether 00:15:4d:13:61:91 brd ff:ff:ff:ff:ff:ff
	prog/xdp id 48 tag 57cd311f2e27366b jited
    # ip link set ens5np0 mtu 1500
    # ip link set ens5np0 mtu 9000
    RTNETLINK answers: Device or resource busy
    # ip link set ens5np0 mtu 1888
    # ip link show dev ens5np0
    11: ens5np0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1888 xdpoffload qdisc mq state UP mode DEFAULT group default qlen 1000
        link/ether 00:15:4d:13:61:91 brd ff:ff:ff:ff:ff:ff
        prog/xdp id 48 tag 57cd311f2e27366b jited 

When the MTU is changed after the program is offloaded the check in 
nfp_bpf_check_mtu() is consulted and as it checks the MTU differently 
and fails the change. Maybe we should align this the other way around 
and update the check in nfp_bpf_check_mtu() to match the one in 
nfp_net_bpf_load()?

On a side note the check in nfp_net_bpf_load() allows for BPF programs 
to be offloaded that do access data beyond the CMT size limit provided 
the MTU is set below the CMT threshold value. There should be no real 
harm in this as the verifier forces bounds check so with a MTU small 
enough it should never happen. But maybe we should add a check for this 
too to prevent such a program to be loaded in the first place.

Thanks again for your input.

-- 
Regards,
Niklas Söderlund
