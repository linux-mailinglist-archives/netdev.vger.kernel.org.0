Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 400FC2C0543
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 13:16:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729312AbgKWMNT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 07:13:19 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:14914 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726529AbgKWMNS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 07:13:18 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fbba7610001>; Mon, 23 Nov 2020 04:13:21 -0800
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 23 Nov
 2020 12:13:18 +0000
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.176)
 by HQMAIL111.nvidia.com (172.20.187.18) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Mon, 23 Nov 2020 12:13:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iR7qCahJrzN78ALzjLkfRAQBFhfunIdORVUGPjJw1C5OytJH6elSrj+cS9r4MQftljVA7nLsfByYmjYcseJqunjmiBJbPM6Hg8qiDYL0+syhNMnysSyT/DA50IQGf/BYoEi0YbPcQtF5Sa2uvJYNKk1PuuDPTpcx4gEqEL/fJJoxfBWRi3BvidrH50Cb+/FERWH7iEsWtUQox7IQbcqczROKjUF41PGubyr14roDwLv/BJrIhm+MVQ5QIPElJW29Y4Ee+rqgNGdCkbACK6otZRfvjTUPADUecnXr3ZnPy26X1QByFhCBgqVmHFx8EvRPjZHQ9uF6zycF5USiBIR3ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=assKlTHGSrMuc15JBKOkXkeURugvWW/FhSKlrr55HI0=;
 b=czRFiKhw0ZRtZ5PrbOYCgst/3foAY56LEvr3SDSJRqNT3Qx2+S7IFUP7mMN95B1DDnF7NuNbVWeyjG8y0ARBpDSFhNOsLXERADTcXslnRv/JWXesELkM159ZA1nx2hBqPZp/WxIB7C7UrydQC1exhaPZJI4cqEnWQBPMHZY6RNRWUMXsXviZlQsjpKi3f/nGd45BT5JLb27v6n+mlghjzNoXn0hj7y2LbHXaVhY81VXgPHGI5JCGy14pQ7OV7pjtbJpFniqknbL2T2GhUp34LFXmIFcSLacmp7nV+7pFlteUHNJbsT5xQTPjQlYWqo9kkOlQASHA13u2dNoDznFQyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM5PR12MB1356.namprd12.prod.outlook.com (2603:10b6:3:74::18) by
 DM6PR12MB4436.namprd12.prod.outlook.com (2603:10b6:5:2a3::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3589.22; Mon, 23 Nov 2020 12:13:17 +0000
Received: from DM5PR12MB1356.namprd12.prod.outlook.com
 ([fe80::3cc2:a2d6:2919:6a5a]) by DM5PR12MB1356.namprd12.prod.outlook.com
 ([fe80::3cc2:a2d6:2919:6a5a%6]) with mapi id 15.20.3589.028; Mon, 23 Nov 2020
 12:13:17 +0000
Subject: Re: [PATCH net-next] bridge: mrp: Implement LC mode for MRP
To:     Horatiu Vultur <horatiu.vultur@microchip.com>, <roopa@nvidia.com>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>, <netdev@vger.kernel.org>
References: <20201123111401.136952-1-horatiu.vultur@microchip.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <5ffa6f9f-d1f3-adc7-ddb8-e8107ea78da5@nvidia.com>
Date:   Mon, 23 Nov 2020 14:13:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
In-Reply-To: <20201123111401.136952-1-horatiu.vultur@microchip.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: ZRAP278CA0013.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:10::23) To DM5PR12MB1356.namprd12.prod.outlook.com
 (2603:10b6:3:74::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.241.83] (213.179.129.39) by ZRAP278CA0013.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:10::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20 via Frontend Transport; Mon, 23 Nov 2020 12:13:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d05dda96-d0d4-446c-0906-08d88fa928e7
X-MS-TrafficTypeDiagnostic: DM6PR12MB4436:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB44363EBFF8DFFA5A282E2F6ADFFC0@DM6PR12MB4436.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:972;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WD6C6xmgnI5Av3D+Y/skvIsItQaQ8ilXVGfhFJgBE3c1sof3tzsX4eNuwUDp5cY7jWGO5f5EMXTcNpPLZs1lNx7+/7eJhWQ/4NGU//mGvi20boqT2khYKwhSVZ2jPZ3gX0IRNKmv9iaZToLTsO3UD+2xT+x5JA6gjKGCjbCLIwQbfuAnMp/E33s8/EtFg6I5SMpvj+77vWrNjDRiUACfKyg+AOaOW6QyDvhDtAsTOSAiuDKKvrndjeVwqQqJoTIBwRFh2bosH7zQ5EV93WKbP2g7wAed9d/ke4XE9UyMpmDwL/xfzWZWbDDfUb/ZzA650pkVKB1+aMbkguRMsqW2tlO9IAiMEXAkcqpzv8A+zbSn5fywAnUU0Oac5j4OD1pa
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1356.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(346002)(39860400002)(396003)(376002)(66946007)(66556008)(5660300002)(86362001)(66476007)(83380400001)(8936002)(31696002)(36756003)(478600001)(956004)(6666004)(2616005)(16576012)(186003)(16526019)(316002)(2906002)(6486002)(31686004)(26005)(53546011)(8676002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: DlmLXfXq3p3GyR5ll7cMvO1IsjWrzK+Y0QhpzliArKoS+WcxcnzCW8hyoR0Obeied9wYqaArrVPT/O41pBuGg/gcZeN8lQ7V7HetzyWTQ0vkzdq6fXlSr0Wj8rOvNaijll8NS3T4KNvwYD1DP68akiyq9cPf4akg9GUfe179euMsY4u9q9x4VhzwOgt+/X6/Oc33qXfQuUMFZVXpN/XRaF73O2IicBjEg+0hTg0MT3C9gM7Z1zaKzqvHOrXsSOG3cW+1dD3ShFsIzrJl6kOH96NsO0N9kRK1641ta96aV5Hoa7+HkuU1LGjlpvLn1y3Q3jUv3IPi7voYFT1RtvSi9SNt6me6nauVF4iu+ofoEKoKj/6mxv3iwTT8/C0GBIFbWotfNq5UmOucaWTFDEedXtMGRzV4OjtT56hbXkDykU2UMqqMt75LGsxLgz4uJurT4tJGnFI+UkmSCIWgk3+8AuMvCay8Ja3eKBJezKwgzhmjek58d5ogAjv1IyW00RN5F6TYvt7wgroGiQtFrR3C6rni0WE4J9KwHBTkWjPUM87HF7+NlHFHBuYZdoRVtDc/3RtNpG9IL6+mr14NZNtrflIs7SzXKe3iAkI3nVJpKKwlHDTyz+mzLWtwrtV6snKHvrAIV5kSOCovxYgJKyPWfQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: d05dda96-d0d4-446c-0906-08d88fa928e7
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1356.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2020 12:13:17.2839
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OJjV5jg2+zvIwQC9HuBZwezPHmgM7dcr7PMLZhNp8uWEx7FM3HQtn+78zjjjR4tJk2wX9fVeQU1GmU5II1HbGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4436
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1606133601; bh=assKlTHGSrMuc15JBKOkXkeURugvWW/FhSKlrr55HI0=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:
         Authentication-Results:Subject:To:References:From:Message-ID:Date:
         User-Agent:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy:
         MIME-Version:X-MS-Exchange-MessageSentRepresentingType:
         X-MS-PublicTrafficType:X-MS-Office365-Filtering-Correlation-Id:
         X-MS-TrafficTypeDiagnostic:X-MS-Exchange-Transport-Forked:
         X-Microsoft-Antispam-PRVS:X-MS-Oob-TLC-OOBClassifiers:
         X-MS-Exchange-SenderADCheck:X-Microsoft-Antispam:
         X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
         X-MS-Exchange-AntiSpam-MessageData:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-OriginalArrivalTime:
         X-MS-Exchange-CrossTenant-FromEntityHeader:
         X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
         X-MS-Exchange-CrossTenant-UserPrincipalName:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=LBw+6vMdxI8YyetXwWJu2rZw5XN9kU0lX3nRDIMBXx3UKAaO78ZUJlRC7YbYWdur6
         bIJg0SDNxScmwXLGXGEuBnsa/JS7e0XFU0i2ijbKhFtPe8rEro0jb87blzMw0BILsB
         BtQv2VRCRlM5prk5asgxYy/TijYlTCUZPGqCNLfx2mwQ1k85oeiwwM8JTnV5lyTfq2
         Uef0pe+kmTzYbfFtDfWaKTcxck+6Pn7bm+KbanPqxxlHyOan0TTh1dz+t46c3tUeOZ
         S1o7G+cpS6FubhmTQuJXWWk2P5FR92BpImiOSGJsZLGwxfdzcqUYMfwgZ3cpSNuSp2
         M4veRyj3HE6JQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23/11/2020 13:14, Horatiu Vultur wrote:
> Extend MRP to support LC mode(link check) for the interconnect port.
> This applies only to the interconnect ring.
> 
> Opposite to RC mode(ring check) the LC mode is using CFM frames to
> detect when the link goes up or down and based on that the userspace
> will need to react.
> One advantage of the LC mode over RC mode is that there will be fewer
> frames in the normal rings. Because RC mode generates InTest on all
> ports while LC mode sends CFM frame only on the interconnect port.
> 
> All 4 nodes part of the interconnect ring needs to have the same mode.
> And it is not possible to have running LC and RC mode at the same time
> on a node.
> 
> Whenever the MIM starts it needs to detect the status of the other 3
> nodes in the interconnect ring so it would send a frame called
> InLinkStatus, on which the clients needs to reply with their link
> status.
> 
> This patch adds the frame header for the frame InLinkStatus and
> extends existing rules on how to forward this frame.
> 
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> ---
>  include/uapi/linux/mrp_bridge.h |  7 +++++++
>  net/bridge/br_mrp.c             | 18 +++++++++++++++---
>  2 files changed, 22 insertions(+), 3 deletions(-)
> 

Hi Horatiu,
The patch looks good overall, just one question below.

> diff --git a/include/uapi/linux/mrp_bridge.h b/include/uapi/linux/mrp_bridge.h
> index 6aeb13ef0b1e..450f6941a5a1 100644
> --- a/include/uapi/linux/mrp_bridge.h
> +++ b/include/uapi/linux/mrp_bridge.h
> @@ -61,6 +61,7 @@ enum br_mrp_tlv_header_type {
>  	BR_MRP_TLV_HEADER_IN_TOPO = 0x7,
>  	BR_MRP_TLV_HEADER_IN_LINK_DOWN = 0x8,
>  	BR_MRP_TLV_HEADER_IN_LINK_UP = 0x9,
> +	BR_MRP_TLV_HEADER_IN_LINK_STATUS = 0xa,
>  	BR_MRP_TLV_HEADER_OPTION = 0x7f,
>  };
>  
> @@ -156,4 +157,10 @@ struct br_mrp_in_link_hdr {
>  	__be16 interval;
>  };
>  
> +struct br_mrp_in_link_status_hdr {
> +	__u8 sa[ETH_ALEN];
> +	__be16 port_role;
> +	__be16 id;
> +};
> +

I didn't see this struct used anywhere, am I missing anything?

Cheers,
 Nik

>  #endif
> diff --git a/net/bridge/br_mrp.c b/net/bridge/br_mrp.c
> index bb12fbf9aaf2..cec2c4e4561d 100644
> --- a/net/bridge/br_mrp.c
> +++ b/net/bridge/br_mrp.c
> @@ -858,7 +858,8 @@ static bool br_mrp_in_frame(struct sk_buff *skb)
>  	if (hdr->type == BR_MRP_TLV_HEADER_IN_TEST ||
>  	    hdr->type == BR_MRP_TLV_HEADER_IN_TOPO ||
>  	    hdr->type == BR_MRP_TLV_HEADER_IN_LINK_DOWN ||
> -	    hdr->type == BR_MRP_TLV_HEADER_IN_LINK_UP)
> +	    hdr->type == BR_MRP_TLV_HEADER_IN_LINK_UP ||
> +	    hdr->type == BR_MRP_TLV_HEADER_IN_LINK_STATUS)
>  		return true;
>  
>  	return false;
> @@ -1126,9 +1127,9 @@ static int br_mrp_rcv(struct net_bridge_port *p,
>  						goto no_forward;
>  				}
>  			} else {
> -				/* MIM should forward IntLinkChange and
> +				/* MIM should forward IntLinkChange/Status and
>  				 * IntTopoChange between ring ports but MIM
> -				 * should not forward IntLinkChange and
> +				 * should not forward IntLinkChange/Status and
>  				 * IntTopoChange if the frame was received at
>  				 * the interconnect port
>  				 */
> @@ -1155,6 +1156,17 @@ static int br_mrp_rcv(struct net_bridge_port *p,
>  			     in_type == BR_MRP_TLV_HEADER_IN_LINK_DOWN))
>  				goto forward;
>  
> +			/* MIC should forward IntLinkStatus frames only to
> +			 * interconnect port if it was received on a ring port.
> +			 * If it is received on interconnect port then, it
> +			 * should be forward on both ring ports
> +			 */
> +			if (br_mrp_is_ring_port(p_port, s_port, p) &&
> +			    in_type == BR_MRP_TLV_HEADER_IN_LINK_STATUS) {
> +				p_dst = NULL;
> +				s_dst = NULL;
> +			}
> +
>  			/* Should forward the InTopo frames only between the
>  			 * ring ports
>  			 */
> 

