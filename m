Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE7CB494916
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 09:06:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239918AbiATIGR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 03:06:17 -0500
Received: from mail-bn8nam11on2069.outbound.protection.outlook.com ([40.107.236.69]:58273
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239452AbiATIGN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Jan 2022 03:06:13 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bU5mLR3wk5DSIFDaGAa6AvYdbi5Jk8iW+Xzoaod2oFLA8IK4u0CkN5K/NbYpKRS1yE0+JohEoK9TNMj7bnNgxDwlEMXrtSQ6YR3PrnlA9TSlUzK3fs/C2wGDsx5HTcHpa3uQviYA1mstypf8M6aWEYdiSpRfbOhhOthECu0bQ9e8o3zSZOmGH4WEm2sPTwJBWLcJdLFghf6uPJz4bEv7vmHGG5ngYkTLlvPyRp6CmHA+BN9UPKBPcSnp4aIPfL8Um7jQT8d6hg3pEKvBAbEWo1ly2chVZUdcTYO+R0oxzAcXQ/Vluf714F0NC92muunfuL6myrfMxaer7lY8o9vkIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=808HdCBLjlamDeZmLplovCbmaJGzd4W+UWuxn0UKf9U=;
 b=LGFyqkGXIrt5I5G7LA0xr3r1l6g72Hr7vkwYfLPeVjBFtr7TrlU2Uw0Y/VNEMkAGZKEuyDwmFoI6NM1stV7JuB4DH8RhXGhpn6qq9DhPfXX3nTDTyPrOdUSOaINw04xP8sk+KID5NQzpYnUpJ3Tv6o9GfvyaREEndmm/jfN4/fRXG4ouLIsLSa93i0w0fV9oZ2i5ycnJXYxBBRVXKYDtirKk5TMSU52H/XVm/muLn9zDpMo3ZiXyC2011zaSafH/RyIC3yFtpSOzTmUgdu7f52vdq+mjbvBscxath9QhmNCcJtRLcu8lIjgKd6P328ishUDjJgh+pInwJfBYOjjt0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=808HdCBLjlamDeZmLplovCbmaJGzd4W+UWuxn0UKf9U=;
 b=F1pc7amiM1KlMvkRNZ5SCwT2nz5ERJQYv85dnF96antyWcK6oNwlgApIwcq2bFcH5ycH70B3H4JIeF4z7agAWqdfLk/5+T3T5508AV9OieT8Dvnzonkk/0w9p0C7bXl2YkB6BGQHBp9sHtk3WWKVidu4FQlTDlUxHaDNEji2/D61OVrPGpnmi1mM2MmKqWR/KA4d3LVEZCD7eDTdOZocK0O9GnPk4knzHu+Du+AkPWY5JByc1KEpX5CGqBWs1UZw3v24Rv8lGAxfoBF6T14hmHFzD/1KX2anr+DC6TJSNchyiNr+n+vXRRazpfU+8jne4LaOpLSIOC14rOypnrtghA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB3527.namprd12.prod.outlook.com (2603:10b6:a03:13c::12)
 by MWHPR12MB1488.namprd12.prod.outlook.com (2603:10b6:301:f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.8; Thu, 20 Jan
 2022 08:06:11 +0000
Received: from BYAPR12MB3527.namprd12.prod.outlook.com
 ([fe80::3dfb:4df1:dcf1:4561]) by BYAPR12MB3527.namprd12.prod.outlook.com
 ([fe80::3dfb:4df1:dcf1:4561%5]) with mapi id 15.20.4888.014; Thu, 20 Jan 2022
 08:06:11 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        yoshfuji@linux-ipv6.org, vnuorval@tcs.hut.fi, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net] ipv6_tunnel: Rate limit warning messages
Date:   Thu, 20 Jan 2022 10:05:46 +0200
Message-Id: <20220120080546.1733332-1-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MR1P264CA0063.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:501:3e::30) To BYAPR12MB3527.namprd12.prod.outlook.com
 (2603:10b6:a03:13c::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 20b1e9aa-2d4a-49ef-f9b5-08d9dbebb899
X-MS-TrafficTypeDiagnostic: MWHPR12MB1488:EE_
X-Microsoft-Antispam-PRVS: <MWHPR12MB1488C91232BABAEF6BEE5A20B25A9@MWHPR12MB1488.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1284;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e1sJRk04lDjuiPlt5/RdvfyANPku7AU8dNc02h8GywhE4us+gzHPxkPlwUXi2LFw3X4jTnruaqe95JNN5gmZX4GFh4pJcBY1HKlj1/mmxqvK1/fWn+DmLF9surrC04X7VINelpA/lkZvFJN9pcjbLCi81DZEhqZHoKh8gAtB2b8BmTXIKzJR8Fv8OOY1C4W/G6GdbDkWk5NnWdx2EG8g2H4mi/LhlbC1cxsTWlO4LsbQL+PPHRWCeO+5uAYtSUaoeyO3HD0cv8gfXDNRzvXMZpD2aSWcoArpOjX3WMw84wP1b6pSOLkMP0vDNCfUj1irkZKfu+L38KT3+7j96kdjDX2FdUAJD4roLp0JUsG2o78aR5PGfeKhvkevAia8n4sMqKaYq/IHnQZKtjEM+y8xil4JfFQED0TKFWJSyCj+DaHNYLjq8VbGHUiBgcKJ6tdTzFFwl2/sTXLqlt/T90+xca7eK0fhb1JBuAV3JuL3a+hqb9R0aI+2/nMkglVyyLU1Vcrv+vX3jl8rRtABHFS4zCGAb+Pu93WDBpyY3GfIXXuFHmUEBL6Tim+lXmF1oxfnpjr91nM7T9hqsJOvNZwjNsKuFWgbYXIoyklynF+LInhe4Fn7gu80EtuKecXoz9uI5grPts2jkq4LZcEX8ecVyA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3527.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6916009)(66476007)(316002)(36756003)(107886003)(1076003)(5660300002)(83380400001)(4326008)(6506007)(6666004)(2906002)(38100700002)(15650500001)(2616005)(8936002)(86362001)(6486002)(508600001)(6512007)(26005)(66946007)(186003)(8676002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/XAvGKTQr8hkACKO15qHGczHMqRZelzAphNdOTAhlumStr+2WdKLz5LiLi5d?=
 =?us-ascii?Q?cFIY8OU+mt2MbGbu8GPCxXjtzFVlV6zVIEEvaSX+IDGnvDKqVLWMuAx7RSW+?=
 =?us-ascii?Q?effPaMazl595EaY6FWg2zHP+SeHME9yGk6f3qbPH3hKdB+6BHZtPkcbvrLBI?=
 =?us-ascii?Q?0CJ5lyEvaIz1jJyLzjsOyr0LjfbO318iLF55EoEYHwbcKfJw1p4YWGRj8k+1?=
 =?us-ascii?Q?jIpA4wIv7MzXhVzexu6T0JHcMwVZpZyyrTRzS+PEV12oG3osvnCtp33c4fM4?=
 =?us-ascii?Q?3V6elM6r3Vi65ZDRj3AhvbGaAe0fhPzRT7yeKUAPYQYIsRTH0Lzdw9SUJteQ?=
 =?us-ascii?Q?rxCD68QOCL/Q3KKOCWn73AGpawr73vYciKE5BviirqHwg0XrdeRhbaMNxFRV?=
 =?us-ascii?Q?lD7ihsiflbMeDFqThLArUvqRkTKcjemcVKtB6ZQlj9M4jsKLb3y870ICgOCC?=
 =?us-ascii?Q?xx9HQ140QRQZ49JnT7bVU5+m43VqZ2qJRdgx15hAeX7tNGgULFEUHNiWLcQf?=
 =?us-ascii?Q?k0rrSIrrBfX25CYLnPsnWSLk1fKPSRRcGv+5hlQ0JdUEn/tRKPrBh5eoV8Po?=
 =?us-ascii?Q?dYYmbGVbGFukk2Jr6JuvA4uLJDVqoJkTdyt07sxrfRxLls/dEmgZRovOkgEl?=
 =?us-ascii?Q?QxFvMZOMvw22jxx0Hlllaz80IE6tUs67dnhesUVDQl+Le/wnqfj6nWorqS9F?=
 =?us-ascii?Q?mMI4N7BGdhFPZKvXrR+dk/0dcKaM8Sor485lvHhWAeeFwnL4pFWdEWXHicKl?=
 =?us-ascii?Q?VtCjhrz0sQsAhUsOHryuDNSBq4li+sSwudndNmcGgIQrTARr1TTf8nzOsoq2?=
 =?us-ascii?Q?P3OBtBaPSFz1rqfUE+qpMp+NXCEmrJwlgj+Tz0UcspbDaJIUZa+WmqtHyWiR?=
 =?us-ascii?Q?NJHCM80KL5IFnxYfY6QzviAp8y3MdqXImSwkqgaBNrgZJZScAfTPR8+X2Uhf?=
 =?us-ascii?Q?6+HHRogmJnpdlqNtWd0xV5OBPrHdf9JMZ/rtKujTrr2TojojOmbDYuoKqBMO?=
 =?us-ascii?Q?VL9hVkxv1nIKj9Dt/OOEueuIWYJJA1ajHwWRu6dEMswKIng/F1GCpQ71KN1+?=
 =?us-ascii?Q?alGi0NSlCijg9wadVtJFHOrbimgri16e18GvEgOQjFjm/V0Q04xaSsBvl6sf?=
 =?us-ascii?Q?DKCOgI0RnxHRxnviXf/wlR4YdnVIQ1OlVNwr+gZ4jMDIcVtBK13UIHMURn03?=
 =?us-ascii?Q?h7e2G8QhIcgXG/Wp4E+jPi5Sg6i12iWxKbd/NTU3bphRVYBzPL9lR6brEjyj?=
 =?us-ascii?Q?cHI73/BmsVrldl2cczJYIvAJ6qA5cOuwnm+IX/PgOuld08VNo3fIwQttzDUN?=
 =?us-ascii?Q?ruJfghcsZctxoXEZmW1+C24obaxU06bDm57jRLcFIVwMcP9ngY1jsGdoMliG?=
 =?us-ascii?Q?vh05cDaGSJ/gvUEhJFYIdDnbpyoEor+c1TxVCBqhqRsP872m3ucCsbV3Nr2l?=
 =?us-ascii?Q?QzkupEvZFVrGRn4zb6qo5WdAgv8IugKTIq6U1esRV8CBy6QDR4hfSTbVt84P?=
 =?us-ascii?Q?yOWcRNQ8PrGchw9toiulGGMRca2ZLVgG/6QZWJW8Yit4FoZCmYhniaQ/4cvu?=
 =?us-ascii?Q?UnBrl0XehjoWVCNiBWmubMhUWJKYJT6Mszj3X4wuRfZ4e9D2hWXnMCJ5wt96?=
 =?us-ascii?Q?eeFDucs3KL/fDznM5mWObkE=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20b1e9aa-2d4a-49ef-f9b5-08d9dbebb899
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3527.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2022 08:06:11.2875
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: InGBis7/rL54joXIEhYn9DzkdLU3qj73nueoKCggxqfl0zTzTgLZW/XKTxw5RlzNE7hBvpBizcT8a5hR81Pr1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1488
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The warning messages can be invoked from the data path for every packet
transmitted through an ip6gre netdev, leading to high CPU utilization.

Fix that by rate limiting the messages.

Fixes: 09c6bbf090ec ("[IPV6]: Do mandatory IPv6 tunnel endpoint checks in realtime")
Reported-by: Maksym Yaremchuk <maksymy@nvidia.com>
Tested-by: Maksym Yaremchuk <maksymy@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Amit Cohen <amcohen@nvidia.com>
---
 net/ipv6/ip6_tunnel.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index fe786df4f849..97ade833f58c 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -1036,14 +1036,14 @@ int ip6_tnl_xmit_ctl(struct ip6_tnl *t,
 
 		if (unlikely(!ipv6_chk_addr_and_flags(net, laddr, ldev, false,
 						      0, IFA_F_TENTATIVE)))
-			pr_warn("%s xmit: Local address not yet configured!\n",
-				p->name);
+			pr_warn_ratelimited("%s xmit: Local address not yet configured!\n",
+					    p->name);
 		else if (!(p->flags & IP6_TNL_F_ALLOW_LOCAL_REMOTE) &&
 			 !ipv6_addr_is_multicast(raddr) &&
 			 unlikely(ipv6_chk_addr_and_flags(net, raddr, ldev,
 							  true, 0, IFA_F_TENTATIVE)))
-			pr_warn("%s xmit: Routing loop! Remote address found on this node!\n",
-				p->name);
+			pr_warn_ratelimited("%s xmit: Routing loop! Remote address found on this node!\n",
+					    p->name);
 		else
 			ret = 1;
 		rcu_read_unlock();
-- 
2.33.1

