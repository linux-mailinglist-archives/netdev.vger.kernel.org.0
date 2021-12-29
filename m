Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F4EE48122D
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 12:46:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236067AbhL2Lqu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 06:46:50 -0500
Received: from mail-bn1nam07on2066.outbound.protection.outlook.com ([40.107.212.66]:25614
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231320AbhL2Lqr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Dec 2021 06:46:47 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B27YtRPqSyXqyRZRYuySzTjQukpDdk28Idw4NFLbtRJo6lq7C3QBPJz7idPXz7mnb3cU+Y5VVqu4LOdBAaBF/psU9bKH0y2/fGcWVks1KtHTB9cqtnP9sdJ3uk5akntflU8jscUVedb9Ey62HZdyuVps5H8zCZ5y8tRa3y4Pr5Oli9TvnIvFlQta/OgoWFhT67wy5NYRp0/aZMOXKwAUl7BqK0p6PryVr/MRd9zOB+wFv8LYO/mnRLTq8xp3XKIjS5MsDBGALg8di3+q5B5vYeraCn5lGoH7PpVE/Stlr1jKb8UJSxlWlOe/T0EfZiifwDoeqrKUDDzNDua3SDvSew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h4Nym9iSieGcRP9Mc66kiluCyjNY8rcebbwh7mTxWaw=;
 b=Nzq1/WgcMPNyC75otVRhD2RjzMfSPu9AiIbPp8avy1E4wO0qynUHLlo2hzTZudAcCt8NpvNvjvdjQAdpmUYECp1BOZrT/KfjWOp31U0UAuewOr2wTE9eeEX16WHqsKv/wKkRMTJ0vOPqF1c83DSS5W2W7nn5Vhag1CI0/pj8JmOwnVjKOjZOBpV7CEPqumVsprnYCB1Y562l65y74D68tGIFZSNlj9s8xNFNi2NniNiiE+jt198O5VglP5su4ga0Bx+4+x7I9ut1Bw/MrnDuCvfwU18TQSO2gq0WHOGwysD7zJOvGsNuBAFsLgIAg89MmoZTKcwy9G1+/QJtsymLGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=pengutronix.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h4Nym9iSieGcRP9Mc66kiluCyjNY8rcebbwh7mTxWaw=;
 b=XC/M3TZKS/h18UtS9kKeIzXFvrGIZAjXiMXIWJm4sWr976CNfhU0zEUEX/R/LFQMMb5RvoBLcsn6mD3DbHrTbQcg9AH4fb4esQ7utkAUE5LtUFYl6mUmDM7s6Z0q7RWCa0MasfYFORmA2kK3ZiRrtzkTJwuyUzBvQQNfWrvLDTLNK2iKsHRMCYgS8ox4/gAGDxxgUyqlf+nbMqPSzse/dtAMKlkxd8uvNx2RwtHQXyoEVmCAeCmIl6v3W5f7dvgWCd2ASnxoQlPhbcFiO7La9MVLuHILWjk8b4UXXPQqQrXa/lwrHG09PWd2VJbjqybd5pYk1qVSOuZnJlAsp3KKGw==
Received: from DS7PR06CA0021.namprd06.prod.outlook.com (2603:10b6:8:2a::23) by
 BN9PR12MB5276.namprd12.prod.outlook.com (2603:10b6:408:101::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.17; Wed, 29 Dec
 2021 11:46:44 +0000
Received: from DM6NAM11FT027.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:2a:cafe::86) by DS7PR06CA0021.outlook.office365.com
 (2603:10b6:8:2a::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.14 via Frontend
 Transport; Wed, 29 Dec 2021 11:46:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 DM6NAM11FT027.mail.protection.outlook.com (10.13.172.205) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4844.14 via Frontend Transport; Wed, 29 Dec 2021 11:46:44 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 29 Dec
 2021 11:46:43 +0000
Received: from [172.27.12.139] (172.20.187.5) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.986.9; Wed, 29 Dec 2021
 03:46:18 -0800
Message-ID: <081437ff-a69d-faf5-0981-389156a90668@nvidia.com>
Date:   Wed, 29 Dec 2021 13:46:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH bpf-next v2] net: don't include filter.h from net/sock.h
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>, <marcel@holtmann.org>,
        <johan.hedberg@gmail.com>, <luiz.dentz@gmail.com>,
        <dledford@redhat.com>, <jgg@ziepe.ca>, <mustafa.ismail@intel.com>,
        <shiraz.saleem@intel.com>, <leon@kernel.org>, <ap420073@gmail.com>,
        <wg@grandegger.com>, <woojung.huh@microchip.com>, <andrew@lunn.ch>,
        <vivien.didelot@gmail.com>, <f.fainelli@gmail.com>,
        <olteanv@gmail.com>, <george.mccollister@gmail.com>,
        <michael.chan@broadcom.com>, <jesse.brandeburg@intel.com>,
        <anthony.l.nguyen@intel.com>, <hawk@kernel.org>,
        <john.fastabend@gmail.com>, <tariqt@nvidia.com>,
        <saeedm@nvidia.com>, <ecree.xilinx@gmail.com>,
        <habetsm.xilinx@gmail.com>, <jreuter@yaina.de>,
        <dsahern@kernel.org>, <kvalo@codeaurora.org>, <pkshih@realtek.com>,
        <trond.myklebust@hammerspace.com>, <anna.schumaker@netapp.com>,
        <viro@zeniv.linux.org.uk>, <andrii@kernel.org>,
        <mcgrof@kernel.org>, <keescook@chromium.org>, <yzaikin@google.com>,
        <jiri@nvidia.com>, <wintera@linux.ibm.com>, <wenjia@linux.ibm.com>,
        <pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>,
        <ralf@linux-mips.org>, <jhs@mojatatu.com>,
        <xiyou.wangcong@gmail.com>, <kgraul@linux.ibm.com>,
        <sgarzare@redhat.com>, <steffen.klassert@secunet.com>,
        <herbert@gondor.apana.org.au>, <arnd@arndb.de>,
        <linux-bluetooth@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <linux-can@vger.kernel.org>, <intel-wired-lan@lists.osuosl.org>,
        <linux-hams@vger.kernel.org>, <ath11k@lists.infradead.org>,
        <linux-wireless@vger.kernel.org>, <linux-nfs@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>,
        <linux-decnet-user@lists.sourceforge.net>,
        <linux-s390@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
        <coreteam@netfilter.org>,
        <virtualization@lists.linux-foundation.org>
References: <20211229004913.513372-1-kuba@kernel.org>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
In-Reply-To: <20211229004913.513372-1-kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b8c542b6-9062-40bb-7c97-08d9cac0e325
X-MS-TrafficTypeDiagnostic: BN9PR12MB5276:EE_
X-Microsoft-Antispam-PRVS: <BN9PR12MB527648D3B3FBFB4ED3D895B8DF449@BN9PR12MB5276.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CHm9/2IYfUvVN7VgvWnjrJ/+tPBB8AURqCy6xtk6DQUt5CVGCBFPaym5DNTG0w2xcqnuI4Va4jvuNVJbSrVurSR93fU6t7ghCyRB+QPJHjAoQewDCndULQ4RAWxs2UJCidmRhHWckKiUqjO9CvF4xoV0P9aSn+wkcOy6orWJenx6XQRUeoa5DIkUuos6+WG00eze6M+Ml+1KgTamt1XLZ3qBY5UONBguDhIpZIieWpEDSq3g2/JEzRH0HhHhnH2KW0LfMKSKQg44rArOLJ7Wo4ml9frCBrBcUsX2Rkd7PSrq2W7k+kt/fxCMyPT/IQScI/EWxp+VhMRnTmo4LSQ/XQPDGJGI7lUKTjZqUrKhhPp/EhuF+1e+nxvj+oetKwZzuaRfqIM9xOqM1ahz8ieX7S5X4x6OUXzPv2BI1eWLlP/Z6y/SsCfzCqKss7w7+syKDPEowp/ViBNDCIQlddptXu2i9fRyG0h336IhkjxRyhEi3LWnq0flD/E/d7DmyDcnOvHfxDtSy4Wgd651Qm8hgb5StB7KE6XnghNYfAHxSwIfA3BUkeJlIZYCP7AWN6BuFXc2JeDzCpXaOImxezIqoxZhEumxaLjJJhbAdj0L+WTWlICT6U6XTI6I0WvF1HfdGgHEJRuUAsForvDjMiv37lsIxdhCGGgpUpJI/I+jdzu3CbwE3aXpZvLsCrFYGKGf8ximQHcC2aBkvdTUuRrbzcwu+i906bsr/P3mqloN6A4vtqVrMQGJUuZ3LC8RpwAETjC0QOKJalvNL9KFdK6RPfezi2a5sGId2vJNDxlRT/ESFvjrpzVWtmuBR2OiaUS6f8c2Totgzxw1J9vEGsN11ZQRhhhCIJhSTv7kfsMWluu1ODu2+uTVP0dQTiLzurNGAzOeqNn2UkhaZb/i/2mMdfmYIn4QI/thXDIuTsamMyM=
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(46966006)(40470700002)(36840700001)(426003)(966005)(36860700001)(508600001)(4326008)(36756003)(356005)(2906002)(8676002)(316002)(81166007)(7406005)(336012)(2616005)(53546011)(31686004)(40460700001)(70206006)(110136005)(6666004)(86362001)(47076005)(26005)(82310400004)(83380400001)(186003)(16526019)(54906003)(31696002)(5660300002)(7416002)(7366002)(8936002)(16576012)(70586007)(36900700001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Dec 2021 11:46:44.2114
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b8c542b6-9062-40bb-7c97-08d9cac0e325
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT027.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5276
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29/12/2021 02:49, Jakub Kicinski wrote:
> sock.h is pretty heavily used (5k objects rebuilt on x86 after
> it's touched). We can drop the include of filter.h from it and
> add a forward declaration of struct sk_filter instead.
> This decreases the number of rebuilt objects when bpf.h
> is touched from ~5k to ~1k.
> 
> There's a lot of missing includes this was masking. Primarily
> in networking tho, this time.
> 
> Acked-by: Marc Kleine-Budde <mkl@pengutronix.de>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> v2: https://lore.kernel.org/all/20211228192519.386913-1-kuba@kernel.org/
>  - fix build in bond on ia64
>  - fix build in ip6_fib with randconfig
> 
> CC: marcel@holtmann.org
> CC: johan.hedberg@gmail.com
> CC: luiz.dentz@gmail.com
> CC: dledford@redhat.com
> CC: jgg@ziepe.ca
> CC: mustafa.ismail@intel.com
> CC: shiraz.saleem@intel.com
> CC: leon@kernel.org
> CC: ap420073@gmail.com
> CC: wg@grandegger.com
> CC: woojung.huh@microchip.com
> CC: andrew@lunn.ch
> CC: vivien.didelot@gmail.com
> CC: f.fainelli@gmail.com
> CC: olteanv@gmail.com
> CC: george.mccollister@gmail.com
> CC: michael.chan@broadcom.com
> CC: jesse.brandeburg@intel.com
> CC: anthony.l.nguyen@intel.com
> CC: ast@kernel.org
> CC: daniel@iogearbox.net
> CC: hawk@kernel.org
> CC: john.fastabend@gmail.com
> CC: tariqt@nvidia.com
> CC: saeedm@nvidia.com
> CC: ecree.xilinx@gmail.com
> CC: habetsm.xilinx@gmail.com
> CC: jreuter@yaina.de
> CC: dsahern@kernel.org
> CC: kvalo@codeaurora.org
> CC: pkshih@realtek.com
> CC: trond.myklebust@hammerspace.com
> CC: anna.schumaker@netapp.com
> CC: viro@zeniv.linux.org.uk
> CC: andrii@kernel.org
> CC: mcgrof@kernel.org
> CC: keescook@chromium.org
> CC: yzaikin@google.com
> CC: nikolay@nvidia.com
> CC: jiri@nvidia.com
> CC: wintera@linux.ibm.com
> CC: wenjia@linux.ibm.com
> CC: pablo@netfilter.org
> CC: kadlec@netfilter.org
> CC: fw@strlen.de
> CC: ralf@linux-mips.org
> CC: jhs@mojatatu.com
> CC: xiyou.wangcong@gmail.com
> CC: kgraul@linux.ibm.com
> CC: sgarzare@redhat.com
> CC: steffen.klassert@secunet.com
> CC: herbert@gondor.apana.org.au
> CC: arnd@arndb.de
> CC: linux-bluetooth@vger.kernel.org
> CC: linux-rdma@vger.kernel.org
> CC: linux-can@vger.kernel.org
> CC: intel-wired-lan@lists.osuosl.org
> CC: bpf@vger.kernel.org
> CC: linux-hams@vger.kernel.org
> CC: ath11k@lists.infradead.org
> CC: linux-wireless@vger.kernel.org
> CC: linux-nfs@vger.kernel.org
> CC: linux-fsdevel@vger.kernel.org
> CC: bridge@lists.linux-foundation.org
> CC: linux-decnet-user@lists.sourceforge.net
> CC: linux-s390@vger.kernel.org
> CC: netfilter-devel@vger.kernel.org
> CC: coreteam@netfilter.org
> CC: virtualization@lists.linux-foundation.org
> ---
[snip]
>  net/bridge/br_ioctl.c                             | 1 +
[snip
>  70 files changed, 80 insertions(+), 1 deletion(-)
> 

For the bridge:
Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>


