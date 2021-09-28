Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9395D41A612
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 05:28:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238858AbhI1Dac (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 23:30:32 -0400
Received: from mail-dm6nam12on2046.outbound.protection.outlook.com ([40.107.243.46]:38773
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238805AbhI1Daa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Sep 2021 23:30:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cf6xnkJx+SWGfWBArWkGaVpxWQIb6vF4lRC8R19DaLHq5B/J2CbQYERtNxwsjJQgx/VuYBtL/MidvaBxrPeKngfpyFEvZXDXPZ6Y1G2S5E0dkR8SX1QHdXuupTmGMXQ+QOHLcaOCoW4AIDGvQf4jV4lWnmwvPT7cyfAlbYpM12hy4YuPBwzxvorO/0ntfSRpCEy6OfX56VBdg/xZm6A0wLnZHQRIqVaYSs19YCDKnoFBttKqewF/TivhJBurFyGif1Tp50DYDCUnLI6EwPfsPUfipfh+60AQCg2cyxV1HIgA5pZ1pV8+NV9O44emPwhQhMNh1KWxtRDWq/eCOpbuiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=EsQoe7aRpkfWuIWwHYp6iG+Jbm97mCmzPQUKS71lLu8=;
 b=ex4nADOJgG+5L4Q+xTwrRzKY1ApfSMzCv4HBlpKUHieeoYy01nkNjebVmWCZdrrklE6Y7MW9n426zi1C2aZZ/0COLwqKU3f658j9WiSGvS6eZG29lPisBSYDEDL73oCpVwDMTnzpZJ84ooOSDDs2Eq5D+VknydEMzdaH+iD6Gg3yD2O5JYX0NQawX1NJSy9u0sSXkK6+s1TCRB5Dk89h3PcvBioRoqb2TmrmIekOL2xQ+FhVytzWJe01gOzT9LHmHt7aLHMy7d5mwIXUi4CRaLV6qtcoMefdf//fd5SgOfVO6TT0ePH2CitsZgtLmEEn5yiUp+lczVsBRLW5vX4ADw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EsQoe7aRpkfWuIWwHYp6iG+Jbm97mCmzPQUKS71lLu8=;
 b=QvfyuODXpeTVP48fGG/v/lDh3mrgxVAX4beCaviLsOTYXUE1F7909mRGyhaIUtHZ+gWv94wYI2Hn7cQbcxGTpMeoIO82ry67rPtXgEynGSqDScHSojJd/EbL5R5ZSsNHJ/9yZAp4MIGkevSwd1rLJLLa2pfzKmaIh8UfM9sGidEyQ2oYp9op+tFvIrJe435L90psQ+Q3Ss6AIkRBxOHU/emmli25ujGQqNZKJdH8W2xpQB/AVmDpiaXTAOC+coSIAZPxG2mvewDVE423zVRVz8fDRPiQFXMFNCrt+fm820xdcYSeGI24FHiDTZERPjR8lV6Rki1mu6huwEWdp4Nubg==
Received: from MWHPR20CA0038.namprd20.prod.outlook.com (2603:10b6:300:ed::24)
 by CO6PR12MB5441.namprd12.prod.outlook.com (2603:10b6:303:13b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Tue, 28 Sep
 2021 03:28:50 +0000
Received: from CO1NAM11FT010.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:ed:cafe::89) by MWHPR20CA0038.outlook.office365.com
 (2603:10b6:300:ed::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.14 via Frontend
 Transport; Tue, 28 Sep 2021 03:28:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 CO1NAM11FT010.mail.protection.outlook.com (10.13.175.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4544.13 via Frontend Transport; Tue, 28 Sep 2021 03:28:49 +0000
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 27 Sep
 2021 20:28:49 -0700
Received: from [172.27.4.189] (172.20.187.5) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 28 Sep
 2021 03:28:42 +0000
Subject: Re: [PATCH rdma-next v1 04/11] RDMA/counter: Add an is_disabled field
 in struct rdma_hw_stats
To:     Jason Gunthorpe <jgg@nvidia.com>, Leon Romanovsky <leon@kernel.org>
CC:     Doug Ledford <dledford@redhat.com>,
        Aharon Landau <aharonl@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Gal Pressman <galpress@amazon.com>,
        Jakub Kicinski <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        Maor Gottlieb <maorg@nvidia.com>,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Mustafa Ismail <mustafa.ismail@intel.com>,
        Naresh Kumar PBS <nareshkumar.pbs@broadcom.com>,
        <netdev@vger.kernel.org>, Potnuri Bharat Teja <bharat@chelsio.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        "Yishai Hadas" <yishaih@nvidia.com>,
        Zhu Yanjun <zyjzyj2000@gmail.com>
References: <cover.1631660727.git.leonro@nvidia.com>
 <97ef07eab2b56b39f3c93e12364237d5aec2acb6.1631660727.git.leonro@nvidia.com>
 <20210927165352.GA1529966@nvidia.com>
From:   Mark Zhang <markzhang@nvidia.com>
Message-ID: <6c473b40-cd38-d5d7-78e7-b3f03142eee1@nvidia.com>
Date:   Tue, 28 Sep 2021 11:28:39 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20210927165352.GA1529966@nvidia.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 89f717b2-e2d5-4fd5-d90d-08d9823016a7
X-MS-TrafficTypeDiagnostic: CO6PR12MB5441:
X-Microsoft-Antispam-PRVS: <CO6PR12MB54410145779969D4105DBC3CC7A89@CO6PR12MB5441.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j8mjvlrcoqYIB2B82zNiRkrqVi6Z0nN5jaRGa2OoBM+GpDPwmCK/BS5RhhL3ulIf0wffAZupy791cLakGA5KQwCer4Pf2nZldgxGi/dMa2vk11e0GOOIYTopkbdbkuqpF4U4o1k8jaxkK56Lwe3jg1MzWn+CZXgD8FtrYYgasvSVRltaRdEv4BpcK3RZFgaVwcpHvf2rKuJvUjlnkw95Q6REq4y1elpbLAKMi8Kv2wA3ZhW6/CMDlmVs7Prxcf8uq+mCSJNRAWXYma5AuIuQlUrnsi23tZRP7kutHQ5MnsD1xUKcbVJSxFPqvzF90wmg6zgkJNuKK1ev6ooChNUCd+uGYrreMXf5LcQf/h76qjQdFwJ+PzdXK0bcsHPuUYUYn6vz3YEIhsNSZP1G5nrDw71mqPaqGDD+5sxp49oDIWox9JfEa92v8kNAS0e5GCd9yvNFkomeFXoSw8OeGnGVX3ZVG8HeHfX3hJ/f5kYggS8czjrpIjH3s5p7CxpwlbK5uxnXkcia0ESNHWLLe2cdl+riFoj6CehStGSkqQNQshCOVYyV8KudNbe9I5SPo/3cGKs5F5sMnDHoZqc7oYyMG1Q+GwI6jiBd3dds9rlctyr22KDGkPxoCgYcbh+o+gZ2VWiRp8i4Bm9fNk7akHxCOXBh1ZU2iAm7mscGyF3KLH0BUPRP3hXN64k24OUznRpJohSOUz5WGqsylb9oF0Kx9dmBTFVVM6hY9/UvZoF2SiU=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(2906002)(70206006)(82310400003)(7636003)(6666004)(186003)(426003)(16526019)(26005)(316002)(8936002)(70586007)(86362001)(36756003)(36860700001)(4326008)(31696002)(53546011)(7416002)(5660300002)(356005)(336012)(110136005)(47076005)(54906003)(8676002)(508600001)(2616005)(31686004)(83380400001)(16576012)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2021 03:28:49.8576
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 89f717b2-e2d5-4fd5-d90d-08d9823016a7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT010.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR12MB5441
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/28/2021 12:53 AM, Jason Gunthorpe wrote:
> On Wed, Sep 15, 2021 at 02:07:23AM +0300, Leon Romanovsky wrote:
> 
>> diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
>> index 3f6b98a87566..67519730b1ac 100644
>> +++ b/drivers/infiniband/core/nldev.c
>> @@ -968,15 +968,21 @@ static int fill_stat_counter_hwcounters(struct sk_buff *msg,
>>   	if (!table_attr)
>>   		return -EMSGSIZE;
>> @@ -601,11 +604,20 @@ static inline struct rdma_hw_stats *rdma_alloc_hw_stats_struct(
>>   	if (!stats)
>>   		return NULL;
>>   
>> +	stats->is_disabled = kcalloc(BITS_TO_LONGS(num_counters),
>> +				      sizeof(long), GFP_KERNEL);
>> +	if (!stats->is_disabled)
>> +		goto err;
>> +
> 
> Please de-inline this function and make a rdma_free_hw_stats_struct()
> call to pair with it. The hw_stats_data kfree should be in there. If
> you do this as a precursor patch this patch will be much smaller.
> 
> Also, the
> 
>          stats = kzalloc(sizeof(*stats) + num_counters * sizeof(u64),
>                          GFP_KERNEL);
> 
> Should be using array_size
Maybe use struct_size:
   stats = kzalloc(struct_size(stats, value, num_counters), GFP_KERNEL);
