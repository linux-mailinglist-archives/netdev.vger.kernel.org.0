Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 481B4337F37
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 21:44:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230372AbhCKUnr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 15:43:47 -0500
Received: from mail-dm6nam10on2084.outbound.protection.outlook.com ([40.107.93.84]:58368
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229688AbhCKUnc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 15:43:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NTRSgvOCTSF78mSYEvIJq/nArzWC43Qw7++YnOpn+MVtjamt+Xwdgqd5A8Itf7dADXRmsA0vFj/9q8oxcAh1ZkpNvUJmsvmeuBJNGjeCgUkcjcyo8u0ZIlC2uOF1mNGvQkFV0tsdHH7mvt7zTiY4xrvY6CszQNXXJvb1FjkqQCxpJC2+fj8iJe29wM+9SX1za84+Xta2M9QPZ1/aOcAmChnHyjSP5Q3Tm0lH9KfFQzO0q7rgP2FAYF0J4ELn0Ej93VqAtGVv1z86UbKJnltdkigOne8JlHoeAANwnsh6jje5wqwf19XpWAcSuI40+do2tZjhfggN1ZGkK/n969KTIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WF9Ih/wNRmcrCIKckK1a3hy/Ckkw8FvYOkmrVGL9TeA=;
 b=VbXlBcQRatYB1b36Kol1APh51a2y0FcLdwzPooXLZwUpjMeyRQJ/5N2zMK1wei6vr0duygWeaeor1JoXFEJBo4hkKHd4Tlk7O66cWFzA0jHbqIonQZSZcxitHjaOuABe1mYu+zdwjBob++gv5KCy7Uop8Z+oaoy0ORVnZ5H1WPxJKdZLVYe0tQoNFN3EbMqke835FbqTEQz+undXt58FEegl/gFEHiZpOwCwR9+EM31Hfc98WYhIcilfmwtz52L29uZ/xB4WyfoLOexqFVEkwH1r7nWwRJDKIZgpJWP2hBK/zXrr0+wDyP22gyPGyVKfjgdw2OqAYn2sdtnH7gjNNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WF9Ih/wNRmcrCIKckK1a3hy/Ckkw8FvYOkmrVGL9TeA=;
 b=UlI6mRJOjq2rhvRuctIwwJK68o1ucfV8lORcnG0SjbMOabKPmcBcKXTa0bEbNET08oh7cmxy5EjsM6YFpuHHhR3dGkU+yzYXzG4LDQkfuE88DtF7N19/KCZcwc7cFQDLfj3FnzsMevPaAqx++Vi4v9BAMMZoyGa3814bRwOY1faRXuYFFK65d6gFqoFsJ1Se7xD1hkAE9VWWEP4SrEjLgftX5emHSaGgQ4T0chAsJ38M2ELJ8Lq7UVl4lOv68OtzIDup/WwLd0t0J2uMpj7v8ZSEcevEu8sv9A+jjqEpW0SS+Ppl/D2oZhTJeQGpAsUQ0l9rckBbLgiP+QWxCMKrAw==
Received: from BN9PR03CA0024.namprd03.prod.outlook.com (2603:10b6:408:fa::29)
 by BYAPR12MB3542.namprd12.prod.outlook.com (2603:10b6:a03:135::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.26; Thu, 11 Mar
 2021 20:43:31 +0000
Received: from BN8NAM11FT023.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:fa:cafe::7) by BN9PR03CA0024.outlook.office365.com
 (2603:10b6:408:fa::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend
 Transport; Thu, 11 Mar 2021 20:43:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT023.mail.protection.outlook.com (10.13.177.103) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3933.31 via Frontend Transport; Thu, 11 Mar 2021 20:43:30 +0000
Received: from [10.26.74.119] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 11 Mar
 2021 20:43:28 +0000
Subject: Re: [PATCH mlx5-next 6/9] RDMA/mlx5: Use represntor E-Switch when
 getting netdev and metadata
To:     Jason Gunthorpe <jgg@nvidia.com>, Saeed Mahameed <saeed@kernel.org>
CC:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>, <netdev@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>
References: <20210311070915.321814-1-saeed@kernel.org>
 <20210311070915.321814-7-saeed@kernel.org>
 <20210311173335.GA2710053@nvidia.com>
From:   Mark Bloch <mbloch@nvidia.com>
Message-ID: <9996b4ad-f92e-e088-fcb7-0babbe223237@nvidia.com>
Date:   Thu, 11 Mar 2021 22:43:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210311173335.GA2710053@nvidia.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 13bd62e5-c5aa-484f-b6ab-08d8e4ce54b8
X-MS-TrafficTypeDiagnostic: BYAPR12MB3542:
X-Microsoft-Antispam-PRVS: <BYAPR12MB35424499594EC1B39902E463AF909@BYAPR12MB3542.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4zP6XBk+rmRefXqFA7vISfwfJF8Fm58fK/8ooUYGF0/jzAuKkpPAvia40lhmNHxqq9uUuTJi/Q4Z8FhLJAyNxT7ccdly/dZXompEFeoIByevbhDmpkR6hJH6vnI2YFHIQwVRFeT1gNMIzMoBZwnpOjulwvoBJq2g/5yHbtDDeDy9oLR1o+z3wOeEC7foqD/6rgbkfes0pUulZA2iXtELVCaDAOMoUrAYWEVT1LIcX76nYRdmmyryRmM9WQtqXgeYVmuAR6ow833Gcrm7LSBCzSlAi6fr3HYksFxDkWIs7hOKTPlzT6e7QbQ5jdq41rwH55IEu1WKniPMeH9OjVa5jCoDzYa6GJYrX2FT3QVsi25cKsLDVO7FtgQin931n4lPKGPHF1ypeJJC8Wd7HfQUVSYVQdZWa7cKNPaXQfeQ1BSFtE4ggv1fFsr3HFcHEW/m8HY162W5a9QBNz9AgJtUcozn8U/SL0qGXuLXgOdDX04q3fPVG5fTa5O4wW48F9KE6SF2vBqfHnl8D/KJbFf4e37HAvY+LT8vgY6b4j6WEkZx2zHhtv95gKqtGNnnrWnxYY348hFLnihpl/W5TCuNByNmDBLzYhYEt9O9rHiYfCRTDSv2El1sThXvDbgYTQ4DyBeFVCTZbr7NYcD0Z8tyAWlaxjwFOBr2vQuM+8Zrx4pipesqeui+zTSJfilQgsfiLz22FNuxOyFJc3Z0g8sep9gazIF/8XW0D9hbWD7CnJw=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(396003)(376002)(136003)(346002)(46966006)(36840700001)(47076005)(36860700001)(70206006)(36906005)(70586007)(82310400003)(16576012)(82740400003)(5660300002)(83380400001)(110136005)(7636003)(54906003)(36756003)(356005)(86362001)(34020700004)(316002)(31696002)(6666004)(4326008)(8676002)(2616005)(426003)(478600001)(2906002)(26005)(8936002)(186003)(16526019)(336012)(31686004)(53546011)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2021 20:43:30.7093
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 13bd62e5-c5aa-484f-b6ab-08d8e4ce54b8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT023.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3542
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/11/21 7:33 PM, Jason Gunthorpe wrote:
> On Wed, Mar 10, 2021 at 11:09:12PM -0800, Saeed Mahameed wrote:
>> From: Mark Bloch <mbloch@nvidia.com>
>>
>> Now that a pointer to the managing E-Switch is stored in the representor
>> use it.
>>
>> Signed-off-by: Mark Bloch <mbloch@nvidia.com>
>> Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
>> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
>> ---
>>  drivers/infiniband/hw/mlx5/fs.c     | 2 +-
>>  drivers/infiniband/hw/mlx5/ib_rep.c | 2 +-
>>  drivers/infiniband/hw/mlx5/main.c   | 3 +--
>>  3 files changed, 3 insertions(+), 4 deletions(-)
> 
> Spelling error in the subject
> 
>  
>> diff --git a/drivers/infiniband/hw/mlx5/fs.c b/drivers/infiniband/hw/mlx5/fs.c
>> index 25da0b05b4e2..01370d9a871a 100644
>> --- a/drivers/infiniband/hw/mlx5/fs.c
>> +++ b/drivers/infiniband/hw/mlx5/fs.c
>> @@ -879,7 +879,7 @@ static void mlx5_ib_set_rule_source_port(struct mlx5_ib_dev *dev,
>>  				    misc_parameters_2);
>>  
>>  		MLX5_SET(fte_match_set_misc2, misc, metadata_reg_c_0,
>> -			 mlx5_eswitch_get_vport_metadata_for_match(esw,
>> +			 mlx5_eswitch_get_vport_metadata_for_match(rep->esw,
>>  								   rep->vport));
> 
> Why not change the esw reference above too?

The if that checks if metadata is enabled uses the eswitch that rule is going to be inserted to.
The representor has a pointer to the eswitch it was created on.

Mark

> 
> Seems Ok otherwise
> 
> Acked-by: Jason Gunthorpe <jgg@nvidia.com>
> 
> Jason
> 

