Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EFD449ADFB
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 09:27:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1450291AbiAYI0m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 03:26:42 -0500
Received: from mail-mw2nam12on2046.outbound.protection.outlook.com ([40.107.244.46]:18765
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1450174AbiAYIYn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Jan 2022 03:24:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oO3wkx+4Y0/0wJ6LoPt8xWprRfSDBRruDLQucnQuYHMKAdX0YPV+qXTn6IqDikpbRFlloUvzdztkGyZaT9y5WmRnfSOucTXAEg0wwnDty/4dU93Ewm5XI8pdldMLMDJl55uXT2+IOLYzqhqNXhsn4+RJQ9yVgrCqgA8bg6T7V/4d5Jt756DxdlDBtZT3yZ7eP+uQFSgpULEuIXyTTL1MrHMBWA/Ak6vupFsA3V5pWMtXkFTAYNEosliDYFCGM6fQpidjFG/r36LM8zpKFpoCj3FEFVVL8YfMutMtHy6NX0uGR3hWRcLm40Wza6itE8YGhoo7+OsmiQpjiKzs4XhijA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gufT/iK2lf7MJPAxfpUWJWhox9wRZHztZlXZ+kirlIM=;
 b=bXRrKT15nMEE9f2ZMdcH86lh6xzXgtv5gWp/R72BEBMb5OTab0+WR36cl42IJLx8s8ng/QQboZXwPpmklmRJdYuRqNKZ0P5OJSSico9EPT49H880bOCjC07900tuBNHRHlvrleJr7tGBHM9kqzpANkDF1ncaefD9qiXgUCoJiqPwb5AaDC7QSzeu4MPK0mSBF4Gkj1qThpg67ABDaUzMRYILWWA6cypIhml3YddEsZo65CndWs066XwfucrUKYVALhAhfT3b1AaMULKFdseQoU7nqE76wLNDF2OE3XAH1D1oaHCyoLu9XkjSuTYXAr4gvlf8ltFVu/Y8v44INRYnBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=lists.linux-foundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gufT/iK2lf7MJPAxfpUWJWhox9wRZHztZlXZ+kirlIM=;
 b=nXxAqfusQZ0BdiepXsv78EwHaIByek2G+pPM6JcYQs97KD8He8W8vfctnPm96w+D8HqttVrlY3MW9B+X2kj5INSy/yoDhBT6PYg39vWEUrck4lMO9PBXWS0FDwpsXRvE6Jgg9jA05G4IBSKRepdKq5b75qdS5Aic4lUQDUAvwd9mbxRufDfFi+cBkGT4pKCQRdx9l3Qm7OZPDp2UZTKk9Z1QhMDaAMIwgJq2babh5bfkQ/3xvm/YMYL+JWOcQX+MeIB1xO2drN9pSKffCkNCPfJoJbS4SES0YNXu0jYxlC1EMTZiIzWvnIvxmel/jQSDV6kyXWXaQ16cMDs484GfmQ==
Received: from BN6PR1201CA0009.namprd12.prod.outlook.com
 (2603:10b6:405:4c::19) by BYAPR12MB2952.namprd12.prod.outlook.com
 (2603:10b6:a03:13b::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.13; Tue, 25 Jan
 2022 08:24:41 +0000
Received: from BN8NAM11FT058.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:4c:cafe::cb) by BN6PR1201CA0009.outlook.office365.com
 (2603:10b6:405:4c::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.7 via Frontend
 Transport; Tue, 25 Jan 2022 08:24:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 BN8NAM11FT058.mail.protection.outlook.com (10.13.177.58) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4909.7 via Frontend Transport; Tue, 25 Jan 2022 08:24:40 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 25 Jan
 2022 08:24:39 +0000
Received: from [172.27.12.100] (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Tue, 25 Jan 2022
 00:24:36 -0800
Message-ID: <cc425efa-1e20-286a-ba96-bc9555142c9c@nvidia.com>
Date:   Tue, 25 Jan 2022 10:24:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH net] net: bridge: vlan: Fix dumping with ifindex
Content-Language: en-US
To:     Benjamin Poirier <bpoirier@nvidia.com>
CC:     Roopa Prabhu <roopa@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        <bridge@lists.linux-foundation.org>, <netdev@vger.kernel.org>
References: <20220125061903.714509-1-bpoirier@nvidia.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
In-Reply-To: <20220125061903.714509-1-bpoirier@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: drhqmail201.nvidia.com (10.126.190.180) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cbd5def3-810d-4ed6-1ef6-08d9dfdc2244
X-MS-TrafficTypeDiagnostic: BYAPR12MB2952:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB2952840DFB04DD78884F6ED0DF5F9@BYAPR12MB2952.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:635;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DwLYZ47Wp8uqegtVI1uIJ7spVW8QSpq2G3AyO51yVbp51ttn3rurgnBlcLT+q+Rm0F5YJNgd55gbrIxwf+CR9lOljNrj+79mPIbTbtOAxftLlABvFsGglehtnU7Vue3c3N7MCUKizXDq58/rVuJgkM8ubALGZ1BfcrXs8aOBWS6phbdUezEh+hfwnbsv84knN94NjFztZPvct+9E4ND10Q0+5nixn/jGTAdg6uF1Tvt9MVUk8txV9gNllcdlVqBKgZ7/IRjMMOAxedqPlLnCwAyLDjz1FSuLTNH13p7mRKHjSDSnkbxngAPYhTjPQw2mBH7bDd/z/is7gg6Qt07QQWDvpG5cZKCqIBsMmJGUCwfBvZHZrYn7Mz/Jc3zuyYw4RVKt6AKwJEsqQd5OD5//Uv6Z/UPNm/dxqqud5d4siU8H7O7khZsmhxcqu0lW1qR5m2N6inKbd7FSqRDvIPqGkhvA38zbyT4BWt6TyNIecpToLkyW+M6Yhl474hXpOAeAsGPPXEZx+Qnqq4kftGVAypNt9UB02orY54CSPIy/z4TX9FGKf5C/ckEg8MLDovktfpYuMfULgig3TYnfZzHcriAjN0OrWgu4GsSzBCnpAkROhBpAmCN0zo+d9J1pA9BnZI7Loysqr6adt6hn9rF5PGGXUWBMYKWKKpmcvQ5Mea5vhFUHPPrkS+3UhLqkpS4b36VZ8/pQmInkOD8isRrjhzyXZSdwgZxe2SurX1AmHsiZYMIQ7i6g6wNXqSgPyMxCARvTszJ5/JLYaq/VL5imuuP9pxGMhRCl4e2OQedifvzeCBdZalEuvtunsu36Dm+9Qwnl2WJVT4I0BN6stKoKtA==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(40470700004)(70586007)(83380400001)(37006003)(16576012)(316002)(2616005)(6862004)(54906003)(31696002)(8936002)(2906002)(36860700001)(6666004)(426003)(47076005)(8676002)(186003)(36756003)(16526019)(4326008)(336012)(86362001)(6636002)(40460700003)(31686004)(508600001)(82310400004)(53546011)(70206006)(5660300002)(26005)(81166007)(356005)(36900700001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2022 08:24:40.8449
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cbd5def3-810d-4ed6-1ef6-08d9dfdc2244
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT058.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2952
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25/01/2022 08:19, Benjamin Poirier wrote:
> Specifying ifindex in a RTM_GETVLAN dump leads to an infinite repetition
> of the same entries. netlink_dump() normally calls the dump function
> repeatedly until it returns 0 which br_vlan_rtm_dump() never does in
> that case.
> 
> Fixes: 8dcea187088b ("net: bridge: vlan: add rtm definitions and dump support")
> Signed-off-by: Benjamin Poirier <bpoirier@nvidia.com>
> ---
>  net/bridge/br_vlan.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
[snip]
> 
> diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
> index 84ba456a78cc..2e606f2b9a4d 100644
> --- a/net/bridge/br_vlan.c
> +++ b/net/bridge/br_vlan.c
> @@ -2013,7 +2013,7 @@ static int br_vlan_rtm_dump(struct sk_buff *skb, struct netlink_callback *cb)
>  		dump_flags = nla_get_u32(dtb[BRIDGE_VLANDB_DUMP_FLAGS]);
>  
>  	rcu_read_lock();
> -	if (bvm->ifindex) {
> +	if (bvm->ifindex && !s_idx) {
>  		dev = dev_get_by_index_rcu(net, bvm->ifindex);
>  		if (!dev) {
>  			err = -ENODEV;
> @@ -2022,7 +2022,9 @@ static int br_vlan_rtm_dump(struct sk_buff *skb, struct netlink_callback *cb)
>  		err = br_vlan_dump_dev(dev, skb, cb, dump_flags);
>  		if (err && err != -EMSGSIZE)
>  			goto out_err;
> -	} else {
> +		else if (!err)
> +			idx++;
> +	} else if (!bvm->ifindex) {
>  		for_each_netdev_rcu(net, dev) {
>  			if (idx < s_idx)
>  				goto skip;

Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>
