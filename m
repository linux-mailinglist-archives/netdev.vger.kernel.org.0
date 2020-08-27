Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC376254470
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 13:40:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728782AbgH0LkB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 07:40:01 -0400
Received: from nat-hk.nvidia.com ([203.18.50.4]:17362 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728778AbgH0Lic (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Aug 2020 07:38:32 -0400
Received: from hkpgpgate102.nvidia.com (Not Verified[10.18.92.100]) by nat-hk.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f479b160000>; Thu, 27 Aug 2020 19:37:58 +0800
Received: from HKMAIL101.nvidia.com ([10.18.16.10])
  by hkpgpgate102.nvidia.com (PGP Universal service);
  Thu, 27 Aug 2020 04:37:58 -0700
X-PGP-Universal: processed;
        by hkpgpgate102.nvidia.com on Thu, 27 Aug 2020 04:37:58 -0700
Received: from HKMAIL103.nvidia.com (10.18.16.12) by HKMAIL101.nvidia.com
 (10.18.16.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 27 Aug
 2020 11:37:58 +0000
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.173)
 by HKMAIL103.nvidia.com (10.18.16.12) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Thu, 27 Aug 2020 11:37:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hP8BQVpoWGO9wLjX4ENeE2ipo4yTDWocziJQWLsu/WrJslTBOCXpfB9B+tpDx+c84iEyxD1LCeogQyFuXde6zIvSdnSCdQLYrkY8BlHLEDOQspq2R9JIjxBN9B8hgGIfST2C3nBF7+ewEgfbqknurFsFpsZ72IqCrXdrx6FYJmVT3JFQ/UkC5tu7p2YrrhSFnk/3hDO2pgHxXCOs2yE1TJ20Cp9L1qsJu00PsjdYRsfHrYCP73EnBrp1/FuKjHcgwCPk12q+tufnaFvUxb+jtYYvmfyUTdl40oq7WkIM09MMn7fGHsvDFOUcVNYl+B9v2YpEnusxC2F5rIh2ktpXgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z056gHRpSVsc1+GXEuuZQPfRDXRXHFqLIpb0xKJq0uM=;
 b=lmEg6XlwLf3UruIdLjWmndnYQSR/kTnW6Pxy4LF/ilhOJD7+a2SeXeN4qBa/rz36syTEfjgEj/joiT1yNFvvsiTBrEaqV1org1cQ0AEaMS/x7psOGwA1OzL0ZGic0idLynueCtVE+JCfayysKyMB7FhuDHDRq82UyEoTdWF9IEF0303nTI8R+jD2ymVNGCk1NsSCVZjilwK9wmiGtqHUiQg4jwOj9Zn/DO7ZOIjWp/vY8n26DgaSY3ex26e7pZk7HwqPhyYZVoQWSP8ciiCoTkPyhhF1ZsdsVnkUwQj7o1G3CSdmOyLntP3/ukvBu92Qaw99iqAOiPk5WUvchpRPww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB3514.namprd12.prod.outlook.com (2603:10b6:5:183::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.24; Thu, 27 Aug
 2020 11:37:55 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::2d79:7f96:6406:6c76]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::2d79:7f96:6406:6c76%3]) with mapi id 15.20.3305.032; Thu, 27 Aug 2020
 11:37:55 +0000
Date:   Thu, 27 Aug 2020 08:37:53 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     Doug Ledford <dledford@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        <linux-rdma@vger.kernel.org>, Maor Gottlieb <maorg@mellanox.com>,
        Mark Zhang <markz@mellanox.com>, <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH mlx5-next 0/2] Add DC RoCE LAG support
Message-ID: <20200827113753.GA3991134@nvidia.com>
References: <20200818115245.700581-1-leon@kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200818115245.700581-1-leon@kernel.org>
X-ClientProxiedBy: BL0PR1501CA0027.namprd15.prod.outlook.com
 (2603:10b6:207:17::40) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from 255.255.255.255 (255.255.255.255) by BL0PR1501CA0027.namprd15.prod.outlook.com (2603:10b6:207:17::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.19 via Frontend Transport; Thu, 27 Aug 2020 11:37:55 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1kBGE5-00GkHq-SV; Thu, 27 Aug 2020 08:37:53 -0300
X-Originating-IP: [156.34.48.30]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7b35dd94-3e9c-4d09-fe8f-08d84a7da3db
X-MS-TrafficTypeDiagnostic: DM6PR12MB3514:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB351497E382388B09F6635E2BC2550@DM6PR12MB3514.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LBR+zCyza/S0RlqjaDGOvagL1Tu2ARdsaSKGGS4gnGnKvYkC74EmjLo81vgtRlBV5PjfQW9dV8+pSkYIfxmWY29t/ESyY29SPRm2cIYFgoVcHio2d4iBwvfsIr5PusgCfaIiLfr/o7wbNF1bNeK5i1niI8O/5z6tPAqA0C0RmR6jLS9YJGCc509zlYz3F9dk8MkqUSIaPkB7/l5haoHjdEaZ3EHIFgfUiMYQzCkuErKBro/V9gt+ksMlR2i/AMuhyAP1x/cbGHcHp1308GVxinzs1BlLyaQn279xabnQDQ1aN+xv9SAE+0Av3WQ4uz8dVeUf24lgSrCAx8sJHcdTRw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(376002)(366004)(346002)(39860400002)(66476007)(186003)(8936002)(426003)(2616005)(26005)(86362001)(2906002)(8676002)(9786002)(9746002)(478600001)(54906003)(36756003)(1076003)(4744005)(33656002)(316002)(107886003)(4326008)(5660300002)(6916009)(66946007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: /NNo3cP4d8osXOTZfNLJLoh9Q9826GxG6LE7wy4ZREn8QxZFmWWttnSPHYVf8vX3knQ1NjwUPaoxlzMVGh9LGOxabOag3OufQJJFg4laPbWNKxx/zbXQsKRPtx++iGUMMlkG/qVnr7MSyGHFEtdZzWcCayQYfT218+ZD95G+fkru2K5V+6Zp7EvBNrC4fSP4pbI43piTDK/NirllSa1BbmXJ4GBSCxssI8jGs+pY55gHF0l/5fSkpKi3ZswQcY5ak8RhqKkXUQk/UMUGc/FqptOmNio4hDOsYUroT/DcALjRQ4SXGySHGZ4AR/BJhTiy5QGto9XQASN4euvLlXXmACYNYUtAuNABbtXbAtpNP6Ta/vObR/jDBeU8XtkNdLxTboFX5r/J21a6DOh/ExvXVRoIyfw2SFxdzvpO+HvnbeSfdJvxg8K7QyvRuqTn1BWf+6flw4qmbpcPTI46NcW4wV17bME4nMhb3AnRk/7r+6/WaSx2zxOLjdVEtYe2lVfKj6z7D6aIQ950RegdJUGoZMjbNn1ouQl2QzUar4wn7oUVu1bLDVrGX7SZzOinDleG55vDqoXO2dINFFMfwpiAk0KDFAeNANZDqmBIiAO6tkHn90+hjlHsYdsuJIRrjptcmhg5Tg0dKhOO4e/hcEtFhA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b35dd94-3e9c-4d09-fe8f-08d84a7da3db
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2020 11:37:55.5805
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9hVhZkqltUGOAaht9nrX5Li5h3XGJFMh3+v9huSNuE1b81PPZxPuN2qo+VKRYOlM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3514
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1598528278; bh=z056gHRpSVsc1+GXEuuZQPfRDXRXHFqLIpb0xKJq0uM=;
        h=X-PGP-Universal:ARC-Seal:ARC-Message-Signature:
         ARC-Authentication-Results:Authentication-Results:Date:From:To:CC:
         Subject:Message-ID:References:Content-Type:Content-Disposition:
         In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-Originating-IP:
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
        b=hFddPBPprhsoCDneJTCpYfpTQ6DkqnNdTkdZLvdsxoRGM7KkNrOzIsoUPrQPFOVub
         9E9qtDfJzeKKFPgU7rhsOc6a3q+j7Ub/maj9BgwtE7UADYlfI4R3F5RXR52rXz1lsI
         wVHM5OA4SI6kqPpw1XSmpy5zU2x7e8IOVRPu7+J88LPShOufpaj6JN2/9UXagUniPs
         pd/ZKIM6pT3s2HoMmL3TgGzAuvmPu1D5DhYC9W+XKS142IVmIydBp45y2vTlKf6oAy
         S0vwhoWadufXZT9OrHCIv3GlnBoZ9u/XbXESkzlA42OHgIpI9Nmv7qh5FFa9ZGmMxF
         IYxupkE+uTjwQ==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 18, 2020 at 02:52:43PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Hi,
> 
> Two extremely short patches to enable DC RoCE LAG support.
> 
> Thanks
> 
> Mark Zhang (2):
>   IB/mlx5: Add tx_affinity support for DCI QP
>   IB/mlx5: Add DCT RoCE LAG support

Applied to for-next, thanks

Jason
