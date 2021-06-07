Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F6C739E6E9
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 20:53:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231288AbhFGSzI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 14:55:08 -0400
Received: from mail-bn8nam12on2075.outbound.protection.outlook.com ([40.107.237.75]:62241
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230500AbhFGSzG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 14:55:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bca+t1Y0CEr/ghn7QYHkiU73W5aY92W93HoVzz1S7i3Ou5WfpVz/GBGj19QeOVtuoP+Vja7OnwJgs4Yea47pSzSEXkkeiJY/CVzSihlkAV0fJdwIKOusRf41ETYlj0jDqykSfYO0f+ovUjn1+IWH5T9aFzbnx2O9eTnjPT97RXusPbdKwBGWY1oU3YdM1zipVL6cs8AsxVVGMwoEaGu7wZ29ylOJsjB88ldFEVi8VTixmGzsS7irUjgsYXyp3u4IAhdvaa3M4MqCcvawP8Zfoo2O/SngWT2cLg101HGKTwUk0AY0QnLhjQYqRae1eu0+LOpXV1Hc7BfdvPXk5z/z0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R8ZdvvpLeGiCbQ92TUyMnO87JTkkbbvPobXpd7/due4=;
 b=CyFc1TlBxitanMFzzbxpsf+QNsoGY3T1SybhYo5emGbr5kkPBERJQ4JxZr0oI5exjgnDQcVSG5MFVM7QricAdFrVZjlLGGiyu/Qs3EB5kyhb/7rkr9dM8NTUYJ1y0dpKwfm+fDv1BKwp+r0+iyPcOJEWDgQ2WNHVf15PTQoNPTD6GhqrrOOPU+zmE4JyE6R+ybmpECLxe+IQyMj5qk3Alozp7u+tXsDCPazoTLAt5vXoR97WJqx/Ft/kGHbziug/qxNqxNS/pZz4jpF/34I6Lh23ks0eZwgx3Nc9CRhGumJRybkrIxXEIguxj4GUoSIOBftt1Ka+zJS89mpdOLbeNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R8ZdvvpLeGiCbQ92TUyMnO87JTkkbbvPobXpd7/due4=;
 b=n7YycJZrvnv910uIFn3hEy9tYVdVrsK8P9Cbi9/+QbY47dXmb5TzZBK1EH6DNkJP13hJh/uRJszGJGKUcs8inRA9e/FIQj+2njMtgFDVnXbLnQRf8RNyQG7gvGkfbc8cfpbRk0rsXTVVPJCB+/WdxWF1LJhRurL+25jsLDaaIQGSHDf59oGktO11qnGCHOg7dQvrRGQnuEXrELC/PsEGIZ7MxEmlDilp5PHEubdxzV9ionDqqsMOkyIAMTc0UEAj4XIik4l8T3Iwz0b+08wjzl8ux4EsdoKigOEuzNTuGPe+qNrtMEmNzGxxP4bRxwXXexk7vteWljer6sI+2G6C1A==
Received: from DM5PR18CA0095.namprd18.prod.outlook.com (2603:10b6:3:3::33) by
 BN9PR12MB5241.namprd12.prod.outlook.com (2603:10b6:408:11e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.24; Mon, 7 Jun
 2021 18:53:14 +0000
Received: from DM6NAM11FT020.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:3:cafe::14) by DM5PR18CA0095.outlook.office365.com
 (2603:10b6:3:3::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.21 via Frontend
 Transport; Mon, 7 Jun 2021 18:53:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT020.mail.protection.outlook.com (10.13.172.224) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4195.22 via Frontend Transport; Mon, 7 Jun 2021 18:53:14 +0000
Received: from [10.2.55.16] (172.20.187.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 7 Jun
 2021 18:53:13 +0000
Subject: Re: [PATCH net] neighbour: allow NUD_NOARP entries to be forced GCed
To:     David Ahern <dsahern@kernel.org>, <netdev@vger.kernel.org>,
        <kuba@kernel.org>, <davem@davemloft.net>
CC:     Kasper Dupont <kasperd@gjkwv.06.feb.2021.kasperd.net>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
References: <20210607173530.46493-1-dsahern@kernel.org>
From:   Roopa Prabhu <roopa@nvidia.com>
Message-ID: <c704333a-e326-57ba-78e7-1e7111f1e79c@nvidia.com>
Date:   Mon, 7 Jun 2021 11:53:09 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210607173530.46493-1-dsahern@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fc7bb240-b6c3-4af7-a664-08d929e58140
X-MS-TrafficTypeDiagnostic: BN9PR12MB5241:
X-Microsoft-Antispam-PRVS: <BN9PR12MB5241A6BC284BB0126F57E3ECCB389@BN9PR12MB5241.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:565;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VaCHPE6LnkZat4H3wKxfn7xCikXQgytcn31rvkKqRIvk1FThVv8+DnD/++bv/Pl6bmKaPf33Q+W8B9BWSVyb2TqyL/i5mbRa8vY4uFcoEa559P5J80PCixJs30OEeJAPS6r1PDQAY6edaHj6A6O3Y42MhUC2hgySIYIwOs8TzbCow7hY0zka9H2KmQKLiiagSbtH7pd4MHE5Y8TmsEEuKb6GVJM+tNWBUQlOsP+lD6W93nCeGSaRslnp/52KC/7XJEdjrB2a7ZurY7SW/NbOLC600DG3zKyuy5jYOXW0WBUXji+gYy/E+O0snTJfbgD34w7m7UfWdiJ+gczGEUj6wkFrUP0Yq37gIMWJzSuD2c9EHnKhFp2WprrbslSTjmT61CKHEDncBc6tRdvlJoBHfYZCfF9l6QQV1Q8SDMT61YWrLEJHq+lGi9vaspg4kFxnkKm8rLV2jg6UhgKd5Z8KsFQZ96dhKIrAsSEUGbbS9B809gjzpvtbfeWyHZey6RPlQfsRecBE+pozFm2A9iO+fvRNDVfhyeBmBXV8HBxoEiYjhEFgxKnWpz3B2EK9CkbLEg2h5wtDhLxeU780CVVEu56gBknpnDXV9MSQk4n63XXz4l/o992d5BcuLNuqPkwhXxO6N6tMUPRYQ1APMYVRYzFRFOgqMGQfa1vlCHtQqrWAm3lmg/bBwTCxmbtOaNo+
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(376002)(396003)(39860400002)(136003)(46966006)(36840700001)(70586007)(83380400001)(86362001)(186003)(70206006)(16526019)(2616005)(36756003)(6666004)(47076005)(31686004)(31696002)(478600001)(8676002)(110136005)(8936002)(7636003)(2906002)(82740400003)(82310400003)(5660300002)(54906003)(53546011)(36860700001)(336012)(4326008)(426003)(316002)(36906005)(356005)(26005)(16576012)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2021 18:53:14.1333
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fc7bb240-b6c3-4af7-a664-08d929e58140
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT020.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5241
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 6/7/21 10:35 AM, David Ahern wrote:
> IFF_POINTOPOINT interfaces use NUD_NOARP entries for IPv6. It's possible to
> fill up the neighbour table with enough entries that it will overflow for
> valid connections after that.
>
> This behaviour is more prevalent after commit 58956317c8de ("neighbor:
> Improve garbage collection") is applied, as it prevents removal from
> entries that are not NUD_FAILED, unless they are more than 5s old.
>
> Fixes: 58956317c8de (neighbor: Improve garbage collection)
> Reported-by: Kasper Dupont <kasperd@gjkwv.06.feb.2021.kasperd.net>
> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
> Signed-off-by: David Ahern <dsahern@kernel.org>
> ---
> rebased to net tree


There are other use-cases  that use NUD_NOARP as static neighbour 
entries which should be exempt from forced gc.

for example when qualified by NTF_EXT_LEARNED for the E-VPN use-case.

The check in your patch below should exclude NTF_EXT_LEARNED entries.


(unrelated to the neighbour code ,  but bridge driver also uses 
NUD_NOARP for static entries)


>
>   net/core/neighbour.c | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/net/core/neighbour.c b/net/core/neighbour.c
> index 98f20efbfadf..bf774575ad71 100644
> --- a/net/core/neighbour.c
> +++ b/net/core/neighbour.c
> @@ -238,6 +238,7 @@ static int neigh_forced_gc(struct neigh_table *tbl)
>   
>   			write_lock(&n->lock);
>   			if ((n->nud_state == NUD_FAILED) ||
> +			    (n->nud_state == NUD_NOARP) ||
>   			    (tbl->is_multicast &&
>   			     tbl->is_multicast(n->primary_key)) ||
>   			    time_after(tref, n->updated))
