Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50D253EA707
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 17:01:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238246AbhHLPCJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 11:02:09 -0400
Received: from mail-mw2nam12on2064.outbound.protection.outlook.com ([40.107.244.64]:34305
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234287AbhHLPCH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Aug 2021 11:02:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ikOifk+MWObhpiF9sF8RB8FKIE46ZuD29nXvNku0SjPq0FIgvwqH1Sd6BadfMsj3QIwn4sxVEMCI6vr4qe3E8Y8uTP9oz2+1mq9t2dYFLFjVDRTJ/B2wXcCziQ06UkZehs7szDLL6czSn6b11n0tFv313hNksv2BHlJ25+PGqtwnugl9NWA0le8XDAcMY/19y3HozjlBO7kgWLm4sqTjIs/3uZpr+agUddQ/jJD751TuvNq4isw1bCfApixOQu+SnTdL6euqrRuBizgOE0c74a77uUlnFByyP5R03S1++ACfKsY0Imnu1DOsBrztA2H6/+Aji2d+/BEe7KR8irtA1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h1hMY7DJorKWNbyaFQgdQ+ACl8U8BT+xMKrFWUGblyI=;
 b=Ic7gmv0BAqhBgDNahDTgnUvSxMS+9VXGbDV6YUu6tUYz2ywY9jLNNMJYL+5EU57QdA/vYvFRJ8YTL7KD8HzxeSU3cC1GfCii/OBMpIU5eQOBPvJ+jy7TN6U/JLPVOW+fqFtblTbw4bif9ulsEXduycH7Ci3SQszaEeScRvbWtew6syqYPuo5JeH6Tu/+H+/wxrGisBCrhiR+A5iOkmH8MYNOT/mU/Q/pc2PvcBpMxlo3taIbFnF4qhS3yem6aXQxT2rLI58mkuiXAi3AsXSOTS/f5DQTiiWVU8T7aIppJMs7ms9q5Clpt08G5747K2K53nL5Skt/3pn4dsQSBjyveA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h1hMY7DJorKWNbyaFQgdQ+ACl8U8BT+xMKrFWUGblyI=;
 b=ewqQ+y0kKm9MN3Rx2/B04sg163zMvNdUbijIszQ3gv3XRi3/XbovHuQyxBM8l2Aj3Ii6vegPQlv7V3xPwSBvK+COBc7bYdLkkvFwYbhHJqBtHji5J5VW3PpmcFD+dz680Bgh1zpByY67FZmfFyBW7QiGeuB+mFurX3zZsV+TIYHD3y1IvdTnjGZJ7e9WDB55Sn+3Y4LSqsHmPGiqYHrKnAqPK5TSiOo71jZy31nF/iYxZQ+TCSLZ5Vs1PLfRwPgcQQ3IHTArL10Gj2pdwAoHZUiOp6odrRBRgBIjXM5b/5NEVpID2dCSyRa/cIZTD4LKR/Eblh02VulV+TY5MmOXuw==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM8PR12MB5400.namprd12.prod.outlook.com (2603:10b6:8:3b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.17; Thu, 12 Aug
 2021 15:01:41 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::c170:83a0:720d:6287]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::c170:83a0:720d:6287%6]) with mapi id 15.20.4415.018; Thu, 12 Aug 2021
 15:01:41 +0000
Subject: Re: [PATCH net-next] net, bonding: Disallow vlan+srcmac with XDP
To:     Jussi Maki <joamaki@gmail.com>, netdev@vger.kernel.org
Cc:     jtoppins@redhat.com
References: <20210812145241.12449-1-joamaki@gmail.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <d741b3f0-2c42-274a-21af-5bb55a1d9a1b@nvidia.com>
Date:   Thu, 12 Aug 2021 18:01:34 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <20210812145241.12449-1-joamaki@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZR0P278CA0119.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:20::16) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.241.235] (213.179.129.39) by ZR0P278CA0119.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:20::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.13 via Frontend Transport; Thu, 12 Aug 2021 15:01:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0c335b67-999a-4b94-f6a9-08d95da2178a
X-MS-TrafficTypeDiagnostic: DM8PR12MB5400:
X-Microsoft-Antispam-PRVS: <DM8PR12MB540093F7239D6777448CA6B2DFF99@DM8PR12MB5400.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n2gS0mHkvhUYz304WwCgTQbA4WFgzzIGz9gC79P0GaHg3r9wV34wen3k3EK8tqRZh/+ilzERdP9DyP7ONp9Tggu3Ljk0QeqKPml+0Hx+0sw3rPQ00rbqn/jr4wQyIzWUdz70z/hoprFyBSxHY3wrMJMgEjBlAWayXobuLOl4ZJd0ggfXQUP7GsLjV+TRpbqBGywbR3Fd7+YzCAP/OXmFzryuqEi58wRIjNVp5x03FKXY+13D7K2k5XAgypCkSFnoIbe2tUd+edh0AtwqnjFZTUmH0enp21/Fz8NzAdDmpjEZbmpsDjrrezC2xVmksWAG6Z5I+f/DePphpQKmvdichVepgrwZVXK33UQGsAXfDaxL+9lcKwHzqNvtP2EZtpOGiAZH7kuFN4XihHwVsXnbxQ1TnoqoM1SM23ir6YbPw5JHzOB0wHohq4XLwV8/eUWZFF5Dd26a+r5NpqQa94RA/mQMDarOCP7APCN2iKzRYDkqJbDr7HiABHh4QUGUDrULk7fYi7RIEPicChwE8g78djjFAEtPghDFFatUkAO0ovLKC84rgQV2F0QvgTEDYjNQqfdA6kHmvamUihvHDwvGTABjTcOxlG1iRBAjW21CoJTB9PGYvlnj1z0Mlv3O8iCRFA17iJPd3viuiA0oawyO3p00ig74Ikveh6GCPf1zhGS2wjJZCazZVOxw1Po11UsDwxhgZuzyr+YMqQIf/9ij9bUnTd1Klijbm1BnAWK17Eo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(4326008)(53546011)(86362001)(16576012)(26005)(316002)(8936002)(6666004)(508600001)(31696002)(8676002)(36756003)(66946007)(38100700002)(66476007)(66556008)(186003)(2616005)(956004)(2906002)(5660300002)(4744005)(31686004)(6486002)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QXJyOTVUUk1tWmZXSUhyTkJMdlp2ZzdQam81L2hEVTdwbElsQXRXVDg0M21C?=
 =?utf-8?B?MndDTlNuTVBoM1JoN2t6RkZNZmFxSWE5R2p1dlV1Zy8zU2VHUytNYnh2Nkk4?=
 =?utf-8?B?NmdwRkRqeUp1Y0lUYXNiOCsrNXVDc2lRbkRTU3lHclZSdmpmY01sZ0ZBNE5l?=
 =?utf-8?B?dmMyN29TcHphWGJ4TFNwSHlFNTlGRmlicWViNXkwL3lhb0N2WmViWHBGMExN?=
 =?utf-8?B?MDhQQm15dWZ6TUVHUjk4a25lM01mTzJNemt6eHZQS1YyR2E0aENPTGhGQ1I4?=
 =?utf-8?B?ZnBGUUY0Nk5WSk9xTjIxb3Y5clRuZ2l0ZCtJekpOUElkSzZwOE41QVZ4Tkdl?=
 =?utf-8?B?d0xNaUhnUUJadjd4ZlhuQ0M3UkR6cFBUR1cxZldCY2xjMTdiWFRZa3F6RWRi?=
 =?utf-8?B?VjRzdGo0NDh6c2hqUmgrR29KbElrV0VWQTR3WW9CZVNUSmVyK0JxSGxoN294?=
 =?utf-8?B?OTlDM1U5QlJzZmM3ZUtUem9pem8vSy9YbjFERkNRbWU4RDUwVGM3V1ZzM3dy?=
 =?utf-8?B?c3BUb3lZNldjNTdob2NYVHNrK3NWbVZhWUpiM2Z3YnZFTzk4NkViQUJqUGJQ?=
 =?utf-8?B?aDllQlc0VVNrRUpmWVo3VFB6RUJNN2ZmSytWUXNTMTJXOUdxT25aZjlvVEE2?=
 =?utf-8?B?VTlvV3JEcjF0Lyt0WlA1YlB2UFc2Vjd4Q3R0bTlFcmZnUjM2RzJHNi9yRFBw?=
 =?utf-8?B?R2luL3F0S0UrcmZyS0ZLclJ4MWhXNXpVVjZKRUFDN1ZoKzd5bTVmQUtoalda?=
 =?utf-8?B?M2ZIbTJsNlNnaTlteSt1OWNYcUtFSVJ1c2dPOHZMNHovalRESXZkTlVDWnFQ?=
 =?utf-8?B?bTNVbTFGbDJ6L2RJL2l4SGRjbUt5ci9ieTNpQmlLT3JWT2VQaW5VVEk0YXd0?=
 =?utf-8?B?Ui9PMFB3MURnYjlSL05DVmVtbWE1WDNvUFpnd0F2alljWjA0ZTZvYnorVm4r?=
 =?utf-8?B?MFN5WWJUVktXdENSKzFRcWNpczA4NWkvZ2FhdDIzNDF3bXQ4dTlnckhId2FK?=
 =?utf-8?B?YmJQb003VG9jRW54YjlUTTQ2L284VDArVVM4bnk2elU0eE5OUXBDRGhmVUpt?=
 =?utf-8?B?Vjl1aDlLaHk2cGg5QkQwak96Vy9KRlpiRTlUYmxPNXpmRURNdldvaS94U3dt?=
 =?utf-8?B?R3hYaXJ1STJucDJZekVhSThNYUFBRUpNQ1dEVEtUQVgrVzF6NU14azlDS1RU?=
 =?utf-8?B?b1BIT0dsVTRmalBrZzNqR2o2d3hpcXg4U3BLb1RQc0dpVkN4Q0lWSy9xNkd2?=
 =?utf-8?B?R0ZtRDU4YlBkRVdwNzNjN211eTBHc3M3WmVpV3JRTDB4QmFkWU5mRktuK3JW?=
 =?utf-8?B?clZEclh6THM0Y09XSGJMVWdheXNrL2FrTHAzd1lFR3M3YWpzZUdNUnBrRVBB?=
 =?utf-8?B?N1JSd09OdVI1ejhoYkNndXNLU29zZnRpem54MEVNdWc0djN5NUhKZjV1RERL?=
 =?utf-8?B?UVRWZG9IUGJYS25iUitFSm5ZOGRsc1R2dnVhT3dQNnYvbjJ6SUpWVW1nbE90?=
 =?utf-8?B?WnMvRzBkc3FvZU9VT3p5VGJJSkRsZHR5eDcxSVJzbWlVSFlvTkxTaldwQ0Rj?=
 =?utf-8?B?dXFSR3J3b2Y5N1FBQmlPN2ttSkRxTUtrSzJnZWdoMStYVGFWK3BVSkdSd3Uz?=
 =?utf-8?B?YVlRTzByNDhtOGtiVkRkU0ZnRGh6YnM4eWo2VnhRN0E2ZFpsMVdjOFRVMnoz?=
 =?utf-8?B?elBhc1JHVGRweEpkeWphRGdGTUYzdjR4QXpuNng0L2tHbmlneVRHNjY2bWtK?=
 =?utf-8?Q?4f8MUVy+V+q7XYqP9YifBsSWwlVWsnDJfBoWCwC?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c335b67-999a-4b94-f6a9-08d95da2178a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2021 15:01:41.3442
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ElTpIPKbga0igvXZY4VeTdgJAmy99o4NKe1+FCFziPH0LbphrsacNPQwkB6Pr5cQLSvDu8ESTwwpCpdrkjo79g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5400
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/08/2021 17:52, Jussi Maki wrote:
> The new vlan+srcmac xmit policy is not implementable with XDP since
> in many cases the 802.1Q payload is not present in the packet. This
> can be for example due to hardware offload or in the case of veth
> due to use of skbuffs internally.
> 
> This also fixes the NULL deref with the vlan+srcmac xmit policy
> reported by Jonathan Toppins by additionally checking the skb
> pointer.
> 
> Fixes: a815bde56b15 ("net, bonding: Refactor bond_xmit_hash for use with xdp_buff")
> Reported-by: Jonathan Toppins <jtoppins@redhat.com>
> Signed-off-by: Jussi Maki <joamaki@gmail.com>
> ---
>  drivers/net/bonding/bond_main.c | 18 +++++++++++-------
>  1 file changed, 11 insertions(+), 7 deletions(-)
> 

Hi Jussi,
Could you please share the null ptr deref trace?
I'm curious how we can get a null skb at that point.

Also how are the xdp and null ptr deref changes related ?

Thanks,
 Nik
