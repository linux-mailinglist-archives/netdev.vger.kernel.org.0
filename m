Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C59334A4D9A
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 18:55:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347596AbiAaRzz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 12:55:55 -0500
Received: from mail-dm6nam12on2051.outbound.protection.outlook.com ([40.107.243.51]:63027
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231383AbiAaRzx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 Jan 2022 12:55:53 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PlH5eDsZzQoEpvQtnzTs8/L3HRKai78YLPQwsKBfO3RvGOSlC35YLAOPpHKWIZD+MTHOBGjfVBNy5kMjUGEY5dUtnO/Dm3IWb8T8Z0pg5d28ST2nGCdxobX0wA0rFpVyIVVUKY7i+4cRi9uZTvG+Sz9fvp/RE5kVOF9PE5ACNKqHrfSq1dpQpLnfTUJSLiIvTehfEN1PNtM/bWQEoPicvHf0Ub3OTfPDf/v1HSHUMLqT8pxlbKsg03sYSYs6z728uWYDUBYj+No7LjxUmzp29VOAEphnhNpqL0QctJIXtEKxW0M+SpQH1qjEvLvTGaT+5avWq+tKEVgwvE1B6qsX5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TELq2PTzXz2s4EcYqdQDOR3OD21sCdTW6lHcOpjYtfA=;
 b=JC4ZYCm0wprC4CHRAN6/hf3J3LFQ/GVS0h5rP87g+UQiG2vqeTHBHqDh4/7DasowZVMO9wGqGQLUYrRreBm8S+az93sKKK8GWZpoZx0kXjO+82/rBYR+07+xK029r9dkT7WqT5IbYeRwsJxuZUkfYIxw7wVpVlt1wYrNyBLRwNhN09RdIsVEVBtyH72ha+rlqmVFDhsCS2UCJa2Z++04zzbW4xhwvj7LLL3/2hvFlKvDjRqodE5W125zifdfYP58rEcr+kv/E1OpPSi6egKgESnR5zAIOQuGrWc/ZcLCWJm2oC4aaE9/+1wHQKW/Aw2sIGY/i1GT/YKa4nu6YpR2UA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TELq2PTzXz2s4EcYqdQDOR3OD21sCdTW6lHcOpjYtfA=;
 b=sJyz/9BPgqKSLmoSNs5Acfs6lTl7SD7D3QDKS9UkGI71L1IZZJqIrW7xOewwPfrOq+kL0366Augj11ibl87mZZofXTOd3jz9PdOciJaJkom7qlvkZHHfbIjXC2D7WqjXO6DVCFshe68LBlus5kYojZSFLzW1uO3fYIoKSEkiPcRfJ5yg3gUumFQXXJB7rm0+rihezLcVhqx+afwXsnHbrGeF35Rc8G5POmP1f09Oe2QWMSlllNePkJCnkdN0Id84cAS7df5jwXGtwq+8+/c5sxVH0kyZr3OqXIlI83u8VSTucVuHbAyN7W6yvxvRpGa2o/PRuFtSLiYimYy/ID7fjg==
Received: from MWHPR13CA0022.namprd13.prod.outlook.com (2603:10b6:300:16::32)
 by DM5PR12MB1801.namprd12.prod.outlook.com (2603:10b6:3:113::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.19; Mon, 31 Jan
 2022 17:55:51 +0000
Received: from CO1NAM11FT008.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:16:cafe::27) by MWHPR13CA0022.outlook.office365.com
 (2603:10b6:300:16::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.5 via Frontend
 Transport; Mon, 31 Jan 2022 17:55:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 CO1NAM11FT008.mail.protection.outlook.com (10.13.175.191) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4930.15 via Frontend Transport; Mon, 31 Jan 2022 17:55:50 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 31 Jan
 2022 17:55:50 +0000
Received: from localhost.localdomain.nvidia.com (10.126.231.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9;
 Mon, 31 Jan 2022 09:55:47 -0800
References: <20210325153533.770125-1-atenart@kernel.org>
 <20210325153533.770125-2-atenart@kernel.org> <ygnhh79yluw2.fsf@nvidia.com>
 <164267447125.4497.8151505359440130213@kwain>
 <ygnhee52lg2d.fsf@nvidia.com>
 <164338929382.4461.13062562289533632448@kwain>
 <ygnhsft4p2mg.fsf@nvidia.com>
 <164363560725.4133.7633393991691247425@kwain>
User-agent: mu4e 1.4.15; emacs 27.2
From:   Vlad Buslov <vladbu@nvidia.com>
To:     Antoine Tenart <atenart@kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <echaudro@redhat.com>,
        <sbrivio@redhat.com>, <netdev@vger.kernel.org>, <pshelar@ovn.org>
Subject: Re: [PATCH net 1/2] vxlan: do not modify the shared tunnel info
 when PMTU triggers an ICMP reply
In-Reply-To: <164363560725.4133.7633393991691247425@kwain>
Message-ID: <ygnhiltzpz6n.fsf@nvidia.com>
Date:   Mon, 31 Jan 2022 19:55:44 +0200
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: drhqmail201.nvidia.com (10.126.190.180) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d5d0dc58-9ca7-4581-4a31-08d9e4e2eae6
X-MS-TrafficTypeDiagnostic: DM5PR12MB1801:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB1801CDF66EF719640A07BE3BA0259@DM5PR12MB1801.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZRH+oMqqG7RMYv2dyl/qU6pdEbo6PgqokxKr9xR+pzJU/I5+wpyH5ZXYHgcIi3B+7YjlrCO66kgYsu0Qe6OlPIgjuP/dOV8at1WxGjVJFm+W6XbptlJCFbjV+RuSIv0pZLuHE3t8Xx8t4DPriQXvXv1XU/F2/Wy3fOGi2xgKrBP04Q7EGpHS+zqAtRp8s7ckZP0oIHkZr1LNe7xBiAI6zq1sRUFoKeTUcsrpU+Mw7pdfNcHp9hvqpDacVNJcC84tCrKbKgFks82US3bGjUJNmY/D8+7ae1qnNOt71JKJbwMI5tD5SFL5Ku/40cU7RqRIE9IN1FN0/zNL4GN6P3gqcGPGRfnkA9xIMfXasAlIxbPh1vGWGsXu6ZyUYicox01hUcjbW++bbfRbiTxCB/5P6JAaccbjebLohzyRZBJ9+drAMGw2P9CSeV5nlbjQ1cxoLsv5jDtjHigph6z1K0PuZPmJlJqz6WzvI9TnraEuroUAChrSjDNiou7TDJ5POOVvnfD8MKdSfF+hP2VHtSg9b4QQYTF0NdfN9/sRF+qa+X7XCFf8T1r7gbLs3l4KnpEqXFb/G+RZpsAGlR4yasKimdtNtDD8obh7mTQW/fjDG32keFd/7PcBWNtaMEDUXpH0Weev5DDwsufSLheJKEF9187T8oIZmm65x4NBuymWCzzIXF48+vsP11cSsJqUROMQFkZH8zVpQf/l+Q5CLCCOilxHQmHHnITtburEp0JAS/uPUeXTPftHtYSNlkXC9iwutBiMI6XzSkt7HCGmiPMBzWaCnQXC8RdI99O4nidCkZY=
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(316002)(4326008)(70586007)(70206006)(36860700001)(8676002)(8936002)(6666004)(47076005)(966005)(82310400004)(508600001)(86362001)(6916009)(7696005)(54906003)(336012)(36756003)(81166007)(2616005)(356005)(5660300002)(426003)(40460700003)(186003)(16526019)(2906002)(26005)(36900700001)(20210929001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2022 17:55:50.3244
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d5d0dc58-9ca7-4581-4a31-08d9e4e2eae6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT008.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1801
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon 31 Jan 2022 at 15:26, Antoine Tenart <atenart@kernel.org> wrote:
> Quoting Vlad Buslov (2022-01-31 12:26:47)
>> On Fri 28 Jan 2022 at 19:01, Antoine Tenart <atenart@kernel.org> wrote:
>> >
>> > I finally had some time to look at this. Does the diff below fix your
>> > issue?
>> 
>> Yes, with the patch applied I'm no longer able to reproduce memory leak.
>> Thanks for fixing this!
>
> Thanks for testing. I'll send a formal patch, can I add your Tested-by?

Sure!

Reported-by: Vlad Buslov <vladbu@nvidia.com>
Tested-by: Vlad Buslov <vladbu@nvidia.com>

>
> Also, do you know how to trigger the following code path in OVS
> https://elixir.bootlin.com/linux/latest/source/net/openvswitch/actions.c#L944
> ? Would be good (not required) to test it, to ensure the fix doesn't
> break it.

Sorry, I don't. We mostly concentrate on testing hardware
offload-specific code paths (e.g. TC).

>
> Thanks,
> Antoine
>
>> > diff --git a/include/net/dst_metadata.h b/include/net/dst_metadata.h
>> > index 14efa0ded75d..90a7a4daea9c 100644
>> > --- a/include/net/dst_metadata.h
>> > +++ b/include/net/dst_metadata.h
>> > @@ -110,8 +110,8 @@ static inline struct metadata_dst *tun_rx_dst(int md_size)
>> >  static inline struct metadata_dst *tun_dst_unclone(struct sk_buff *skb)
>> >  {
>> >         struct metadata_dst *md_dst = skb_metadata_dst(skb);
>> > -       int md_size;
>> >         struct metadata_dst *new_md;
>> > +       int md_size, ret;
>> >  
>> >         if (!md_dst || md_dst->type != METADATA_IP_TUNNEL)
>> >                 return ERR_PTR(-EINVAL);
>> > @@ -123,8 +123,15 @@ static inline struct metadata_dst *tun_dst_unclone(struct sk_buff *skb)
>> >  
>> >         memcpy(&new_md->u.tun_info, &md_dst->u.tun_info,
>> >                sizeof(struct ip_tunnel_info) + md_size);
>> > +#ifdef CONFIG_DST_CACHE
>> > +       ret = dst_cache_init(&new_md->u.tun_info.dst_cache, GFP_ATOMIC);
>> > +       if (ret) {
>> > +               metadata_dst_free(new_md);
>> > +               return ERR_PTR(ret);
>> > +       }
>> > +#endif
>> > +
>> >         skb_dst_drop(skb);
>> > -       dst_hold(&new_md->dst);
>> >         skb_dst_set(skb, &new_md->dst);
>> >         return new_md;
>> >  }

