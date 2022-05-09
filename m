Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09AE05205E9
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 22:31:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbiEIUel (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 16:34:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbiEIUeO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 16:34:14 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F08147554;
        Mon,  9 May 2022 13:25:07 -0700 (PDT)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 249ILjm2027032;
        Mon, 9 May 2022 13:24:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=X6cbIz/BIHmlMPxGu+PhZCmzZ9WAryrUMSw8jWUuQ7c=;
 b=k+gwpBDcmDQn1PyyrYijJHrwZWnsVbv9rrFcYNs3Xzzi4aZ/0WfcrQH9AScQp2jIrOXR
 WSY2TOUCcxyoNfDbcMylphYk9EMwG2EJN1pOGoneTuRQACKUq2O8CvEd5VNT1IRCDSTT
 9GauWF3kh9igEA8ukziLlWX0hT6E2kXLi3s= 
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2177.outbound.protection.outlook.com [104.47.59.177])
        by m0001303.ppops.net (PPS) with ESMTPS id 3fwn14bgvk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 May 2022 13:24:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TA6EIfhF7+3bmQtwt6vv26HBu4IafT65Si4T3Ha0fwxNNoOtR+/CR2PzodsyRuzNFJRHF1HqaN8dx159qRr4MBXJifMjEymjXmeijzRwh2o0wFYwIPLf1MbKSV0xiVJw9OY4KPL5Rs29ZQVStkGofSBSL/TN75BNR2RAxYGUXc//ijBOjekhPmm8n2U72Xw+9C8KSfI7dsYbGR25Ia5F4xBJSANAUc4TQeSTOL+FHglhD+Eg3l7rLrAGTK7Y2FgIqvPJgrfDItwZT5i2bZ3BL7Ucwhdf4q2UmwjE/wFJ53oYALdSzO7sKct9CEyArdrvIGS5iMflgZGVQCJCJXNDYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X6cbIz/BIHmlMPxGu+PhZCmzZ9WAryrUMSw8jWUuQ7c=;
 b=Uq5m5pi8qTBSc24qHnEZH8CjjVKFCN27f0MOEryaq29pyTBn6OD6cBpx1B5vhdcwvL9cQM/09VAxSiOXC/F2n+kTrSt2Sm1ZaYsf82hq40fSNciM7BhMqL6DFnh9dk3f1jtYbCKmG1GRm+TziMAfWOVgXtg5SFlJI0ZvFYMP/TFDbM+dJ6aghFJv40MTTksMYZ/f0BsNioWnh+YyeGwH14tdsvNbcvRsH62pfoXr9KjmO5Pf3/7BVbAC5fWwe3W1c6sSdzDipXB7Fw25Bk/OA5F07fMYDMRbFvk+vYmodgGW+48Bbw8sBVX1Gi93eVdjjfh36JKgxxhZ5gdjiZ7W+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by DM6PR15MB4794.namprd15.prod.outlook.com (2603:10b6:5:1f8::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.23; Mon, 9 May
 2022 20:24:44 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::fd7d:7e89:37f4:1714]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::fd7d:7e89:37f4:1714%5]) with mapi id 15.20.5227.023; Mon, 9 May 2022
 20:24:44 +0000
Date:   Mon, 9 May 2022 13:24:41 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Wille Kuutti <wille.kuutti@kuutti.com>
Cc:     'Alexei Starovoitov' <ast@kernel.org>,
        'Daniel Borkmann' <daniel@iogearbox.net>,
        'Andrii Nakryiko' <andrii@kernel.org>,
        'Song Liu' <songliubraving@fb.com>,
        'Yonghong Song' <yhs@fb.com>,
        'John Fastabend' <john.fastabend@gmail.com>,
        'KP Singh' <kpsingh@kernel.org>,
        "'David S. Miller'" <davem@davemloft.net>,
        'Eric Dumazet' <edumazet@google.com>,
        'Jakub Kicinski' <kuba@kernel.org>,
        'Paolo Abeni' <pabeni@redhat.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/core: Make bpf_skb_adjust_room BPF helper available
 for packets with non IPv4 or IPv6 payload
Message-ID: <20220509202441.l7jv5hnsfggpt2rg@kafai-mbp.dhcp.thefacebook.com>
References: <00fd01d860cc$59d5fa60$0d81ef20$@kuutti.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00fd01d860cc$59d5fa60$0d81ef20$@kuutti.com>
X-ClientProxiedBy: SJ0PR05CA0148.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::33) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4b546fbb-c20b-48be-df97-08da31f9f413
X-MS-TrafficTypeDiagnostic: DM6PR15MB4794:EE_
X-Microsoft-Antispam-PRVS: <DM6PR15MB47941BD520A715979F175D48D5C69@DM6PR15MB4794.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VAU9WWjAA65T9eLxilz4HVIHe34dcr7SShLy019I94bECjMWN8JgmhZl3wqnbdylYvPt+2Yu+fYDfmcpez8t4C/uQlBMcpwYiySuOLMt6b/yBwA1kjAoh+IfxVPV8Uac4Uh4kad4DLPUhl1qNMXZHf54ReHTFhKN+PWW1CS52Wq8eEOuvdMr42l1EsR3Px7ltBMkGSQ3no9RMTdSBJ1RyxdeTte2IIhbJqeVC0xaShr1ZAvsuDwQwdDEo2f6jFTownbg1N25tK9Jj2cB3BwSlHgn+/ZO9033v9xTMvgxtk2gmIWctxQbPcX+YKLXL15dViRfxquUWHUUYg8QlaanNX06ocf6uq5zaNscw45qOCy8gaxy+pYRxOt8kM9ByTpE62biM8Glt1fntmSDnH63KVf1aru8s+fwaW9bEB+JEtw3sBPC205nmJ9Dn5pAE+lQ7RuIOUph6Qll0+Sfnzvrevgez7bwlZUpKbMWrlgeVYT7WrAktcCpoyy4d+s5PGbjWrgCD9afzgbRCjE7/dyrzomCXTYqEfDTN6NBWxXyd5z8lEE+upJ9jZxPsUQ7BA+4xUl0Q/lJLlALv8n7r3vAtGKebKlLOjKTJ0IlGCcJQKuMMbAe0T1OlheEK9Aak+R0MpsD+ndqTqiPkQ+YQ4sLaQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6486002)(316002)(508600001)(38100700002)(6916009)(54906003)(86362001)(4326008)(66946007)(8676002)(66476007)(6512007)(6666004)(7416002)(9686003)(83380400001)(6506007)(52116002)(1076003)(186003)(2906002)(5660300002)(8936002)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cpDSwWNAVExOtZc6wW7tnwaHVWibJv1zsFPWba/PHqdX2oMB6VWa5MFflh0X?=
 =?us-ascii?Q?EZkJ1ZM0HTS9ejaHPhhgDRZgoEyzXpAqHrCCbXkwItFHCakX8Z8vGuxYvzjo?=
 =?us-ascii?Q?6SxYDUXYHcxhUYCq2sZKKyjBKh0avS9WY+5Yu4TC/LYAhuGeZbzzFdD743W1?=
 =?us-ascii?Q?mOYGVFJN8CvFXpjBfImFN+aYH/alfmAbZ6YeQz53CWZD0cMazd2oNUMiL8O3?=
 =?us-ascii?Q?5KZkEik6/YdSM4OZRgXdYrpTVhbxXiCW4YI0PqAZd/XEXswdvMPqE60sAHVN?=
 =?us-ascii?Q?qyc0lm08FM7+g+86EOcfFqFOaOfJH2qdwnxIaa5EC36LCp6cVwKbfwVPsWuA?=
 =?us-ascii?Q?4vXOlbHLoypmM8W98TitTxrarhU7OajGg/eFEFgHxOP3uZF4qWu0iuC/hRBl?=
 =?us-ascii?Q?0h0lomRu6amJmg2X6gTzFPT5NqUTrdvTIjE91hioL/HFnup0fAMV1dy1Qk+U?=
 =?us-ascii?Q?FlQaGP2Ukdiu5netkRuH9l0g0EqVvutJd3o+NeTM31tt4X/UmBF2d/XKq7iD?=
 =?us-ascii?Q?M0ygZWYO/6Shtq/3HO/uIax9fuZBFfw7hiGQ51JRA0iG4F75xs4a3UAJVMMn?=
 =?us-ascii?Q?ckDg3zxpokPM+cc8BrEZ7uZFrwTUnj9xM0nkSbHhTn3/w2X44PG62Uh1ThvT?=
 =?us-ascii?Q?cEZ5LDqHHqOUczMnSJPq9cDLHnakOQ/xt9ZYYdU6zOkuT5ULVR9xccVtLsoC?=
 =?us-ascii?Q?WSSB35Pm4ICqOgVHJhgBSG4kQBQdandFzyqiqJ54ytLudO+WrZXqVnrFNwQN?=
 =?us-ascii?Q?oxD3MUWccFMMTdJMuuzWhJliWe0CNiHZLGFyLwi99xz4WwFMAdZMYWkknyvE?=
 =?us-ascii?Q?SgpLQNpncYDmP4IkNWft45ovYuFrIiYtvtBD6UvD+12rVwGQFOrX2tz3//cT?=
 =?us-ascii?Q?e1r7F+9GYXfQxmRmpNKQGmvgpdNclTeqtMF5ecO+ytI8EO7IatdszzwkGctO?=
 =?us-ascii?Q?eN2PhchKrMfnt1fPUAQ8u3/PfCGqkASCpuVDDSyk+pyArtG9p0f54PTHW7nE?=
 =?us-ascii?Q?URxqNywv7tzYhDNd6x/V1e/lnAVS/pPK0oemMjcsWhu4wSNngt1AaTLMdkrw?=
 =?us-ascii?Q?9fqrLg4IDXxFJnIGtYR2TBs1FCDeKj4ajhz/vIkQvI2ieObq1wITVft3rqjU?=
 =?us-ascii?Q?0RjyuuK2gRaGdkZuBKI7EFZxNnFJ6WQ2xrX9jskrd4tODLDB/YgqcbQiNYaS?=
 =?us-ascii?Q?OALAB9EOoWMaXOMY7il67guLEaQIHLVh4jbJDLDqKhs4oEk4Av5mmlA4azHH?=
 =?us-ascii?Q?01XJKzq/F7OB+Y209Higarn5ISOwKzRqAQKkz0Of1e7ye4Ybb+M4G7pF2w+R?=
 =?us-ascii?Q?ONyjCCz7+jjRSRCfx7aBZ4hQnTnmIm6zF3kQ32JZg4sOnxSbVQzvfMWjsHxF?=
 =?us-ascii?Q?p6APLY9Mo0cmvEIzGvavxEN0AU0rFI7qq3xlsqpxlxrHuoAw9k13X/nnpka0?=
 =?us-ascii?Q?BB1N/YTOF8tq915nxvoTZZhnT9WWA/N87aEVRdJqkn2ICCM1+wjyVZVFkcnb?=
 =?us-ascii?Q?fPz9dDSIwRXQ8CE92VfNGUNHPTfu0Ez8PZljWbKKP0LxuWDPXKtw2dXOH1PX?=
 =?us-ascii?Q?ituwzBA8g8bJGVP0jBwnfbAX2ThPuWFFAJpdGEaO4azFRE5Q9JpnZ9b8137+?=
 =?us-ascii?Q?vEVm2rgQfyhJ7WlEqhFSYW7Sfvj4E6rYruW1kblwnRo30AHaSjiJ8dQjmQdu?=
 =?us-ascii?Q?axRvHr8yBdwr35t+bIAZ8FbaGfrW8aTgvroyI7qKt6bq9M/ExBn2mwwuT7Iw?=
 =?us-ascii?Q?yWrR2+ensfjrncpZ/JNotimi8byBL4w=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b546fbb-c20b-48be-df97-08da31f9f413
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2022 20:24:44.1512
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KcaS6JeFaaK8mGSUld8WFGDyiEtmwAh6ZwXXA5unLDdUg/ZmMqHTX4mtwAwQNmyW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB4794
X-Proofpoint-GUID: Zg6VV8I3iFsz-p21TK106IVW3EwotT77
X-Proofpoint-ORIG-GUID: Zg6VV8I3iFsz-p21TK106IVW3EwotT77
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-09_05,2022-05-09_02,2022-02-23_01
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 06, 2022 at 01:06:20AM +0300, Wille Kuutti wrote:
> Network traffic is not limited to only IPv4 and IPv6 protocols, but several
> other L3 networking protocols are in common use in several
> applications and deployment scenarios which also could utilize BPF. This
> change enables the bpf_skb_adjust_room BPF helper to adjust the
> room after the MAC header using BPF_ADJ_ROOM_MAC option for packets with any
> L3 payload. For BPF_ADJ_ROOM_NET option only IPv4 and IPv6 are
> still supported as each L3 protocol would need it's own logic to determine
> the length of the L3 header to enable adjustment after the L3
> headers.
What are the non IPv4/6 use cases ? selftests are required for at least
some of these use cases.

Please tag the 'Subject' with bpf-next.

> Signed-off-by: Wille Kuutti <wille.kuutti@kuutti.com>
> ---
> net/core/filter.c | 5 +++--
> 1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 64470a727ef7..c6790a763c9b 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -3362,7 +3362,7 @@ static u32 bpf_skb_net_base_len(const struct sk_buff
> *skb)
>         case htons(ETH_P_IPV6):
>                 return sizeof(struct ipv6hdr);
>         default:
> -               return ~0U;
> +               return 0U;
Does it affect the len_min test in bpf_skb_adjust_room ?

>         }
> }
> 
> @@ -3582,7 +3582,8 @@ BPF_CALL_4(bpf_skb_adjust_room, struct sk_buff *, skb,
> s32, len_diff,
>         if (unlikely(len_diff_abs > 0xfffU))
>                 return -EFAULT;
>         if (unlikely(proto != htons(ETH_P_IP) &&
> -                    proto != htons(ETH_P_IPV6)))
> +                       proto != htons(ETH_P_IPV6) &&
> +                       mode != BPF_ADJ_ROOM_MAC))
>                 return -ENOTSUPP;
> 
>         off = skb_mac_header_len(skb);
> --
> 2.32.0
> 
> 
