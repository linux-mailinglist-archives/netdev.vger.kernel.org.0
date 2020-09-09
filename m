Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E7E4263682
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 21:15:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727010AbgIITPJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 15:15:09 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:1329 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725772AbgIITPH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 15:15:07 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f59298f0000>; Wed, 09 Sep 2020 12:14:23 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Wed, 09 Sep 2020 12:15:06 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Wed, 09 Sep 2020 12:15:06 -0700
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 9 Sep
 2020 19:15:04 +0000
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.104)
 by HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 9 Sep 2020 19:15:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QPzt/dJJogvoRjuZuxVvYpaybKoTWij0VzMbVzXHVrkLcdamPxrfI78E+DBhSwi+Sa7FMP+cu9VkYjYuJk1Oi2B3685Hql8keEHcOeMjcMWQMHEBlfYcch4FE8hZ0rEejvwnHNW2xK2xSF7r2bF6p5s5Xqrz5TbuYQ30r9X/eNsMfuDWh5q+eifaHHx/wdowjmN2xEO3imiXnMDy+5lw77AiVQsUFJCqYgLPRPdgdscL1lMVeA/Gr9g3IQjYHE43AuFUPhlvVtaPkHYVWsimNxlMBcsjHfejATJbLoBgaOeVu6Gom3BvFiH+cUdIR7YPIom5PAdSGXRRILIx7FyGfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8t+gybYb7VHdY200YxfB53gPz6RNXc19IShTYm/FeHA=;
 b=EKhb4nibNBZbVbcHPwHJx+HwjSEEiWJwd065EGv7XTFZJjiSIRtu3Rc1w1Wyp3UNGOfEWD3L4ITnCLz39/ik4FZVGUla055v/FNf6bkZvKU+lcrogjQaB7lGY7iWO5ObuVCQQIQHDVHv6s+UBft+cf+Dwy2Gcgx7XzkthwtIMkHsHkaxno2ZcUuk03p3Mo024PzsrLwHn9EEFh/+KsV1jgOiCa8D/oPoOlrr/CXPVUIl7nehVgAaE1js2N0/J/ibUe1nhjHRTn+SV3URTHq/b1u2zH7riGnE1aR1Gb+5XCYU0UpDwpzksIhxf8UXvP9Fop8N9CXYIUlIZQ0Q/nV7mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Authentication-Results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB3212.namprd12.prod.outlook.com (2603:10b6:5:186::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.16; Wed, 9 Sep
 2020 19:15:03 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78%7]) with mapi id 15.20.3370.016; Wed, 9 Sep 2020
 19:15:03 +0000
Date:   Wed, 9 Sep 2020 16:15:01 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Michal Kalderon <michal.kalderon@marvell.com>
CC:     <mkalderon@marvell.com>, <aelior@marvell.com>,
        <dledford@redhat.com>, <davem@davemloft.net>,
        <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH rdma-next 0/8] RDMA/qedr: various fixes
Message-ID: <20200909191501.GA972634@nvidia.com>
References: <20200902165741.8355-1-michal.kalderon@marvell.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200902165741.8355-1-michal.kalderon@marvell.com>
X-ClientProxiedBy: BL0PR01CA0015.prod.exchangelabs.com (2603:10b6:208:71::28)
 To DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by BL0PR01CA0015.prod.exchangelabs.com (2603:10b6:208:71::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Wed, 9 Sep 2020 19:15:02 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1kG5Yb-004532-NL; Wed, 09 Sep 2020 16:15:01 -0300
X-Originating-IP: [156.34.48.30]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0a479ddc-6673-41e5-de7b-08d854f4a75f
X-MS-TrafficTypeDiagnostic: DM6PR12MB3212:
X-Microsoft-Antispam-PRVS: <DM6PR12MB321212390E2CEF0944A4A119C2260@DM6PR12MB3212.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0CcWaPuaYISBzMnziSXmRBdti8PeUJ2PmcBNqGCuz3OLC4KrIZM2iMxZzLUxloYxcLfu8qoJEtmDpfqEjEEaHtqd/RHjjNzgJ7wvGtP5BRuVjtCww9Q/6iemg6X10EdW+PP/dC16PDye48R/oJ0kwhjbAfjoRjMeKkp7Ly7v48kVoLA3IZFs2JFglKDAx4j4Ddz07BT2h4+6waQs3h2RU/2xeMz0RAz0MplppLUf+oHY1VceQx6zQzGmKs16JyvVHDBT+JbrwoxZhgmN1YJJEDPNNJdpT1CXhhJwjI2EAnFWzLolXwwK/mg9fqRaVYNqL4T/3c9vjfhQKgm/bi70ibtyrmDkJDwNBseQyzL84WdVLSEoZPfcZz6Hn5QZGucr
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(136003)(39860400002)(366004)(346002)(5660300002)(9786002)(8676002)(9746002)(8936002)(36756003)(186003)(2616005)(26005)(86362001)(33656002)(66946007)(478600001)(66476007)(66556008)(426003)(6916009)(4744005)(4326008)(316002)(1076003)(2906002)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: QxPNKjxMUoCce9inYPq1Nto0f0vW0bDguUBaU53tW2nTueA4wrzAg0aMo2N6eo9ntY8iNdxHwDPiXliLnRiZNvEehwJPOQOgxnVE081+JBwl/bXHQtOzR+6U7igHh+gnuoBLTNpokAySChZfigjv819RgXDp86TYdNNtm+GBwikwPMo0CrfvxQhePcOF+fKYnEhlSqMehG+XdAvYSfcViyCgslhUyIGhwOrVDZrfJWmbUB0D49ev00B4RgP0ra67R58wXwZFj86wb6V01bJOgWugjHILMvaYjcfw+M5MPhkPSffBgvKKjEX9vyr80YktIAgXo/Zj49bhaC2r3BJ8ehTmPgs+WSDDBRF4G9tGaM1ytYdrREFnwCIqSU/aco4YOzK4QsI6LXMcNUMJ1m5qqyLkvDVAbXUaYc2WDwuShYfQM5rFIaWL8X5JBirSvhPmZU60u/qmoi2mI0cnzMKx06D89YjbbB5+byQv7AhftaL5hHfcxcOXKAxrdTDJ82n6G8KUTqThI6l8xqtKGhvPmNilGc0Bgei81rMTDJLWWXS+qnzyuenZzh0dAg1bK8suAYfBRn2FAS+nPFfpwFH1L6wUHkixhRx13D64VDMW0Y8CBuzxGWZFvlQs17UTAXljnxmpOnTu7wFyS49Khdty2w==
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a479ddc-6673-41e5-de7b-08d854f4a75f
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2020 19:15:03.4254
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qDqsieC1rn8RdAdPoimSP2U+SFsHl7mBfd8NGmGQucxH/Y9cCF/OiGiT/Amn/l9+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3212
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1599678863; bh=8t+gybYb7VHdY200YxfB53gPz6RNXc19IShTYm/FeHA=;
        h=X-PGP-Universal:ARC-Seal:ARC-Message-Signature:
         ARC-Authentication-Results:Authentication-Results:Date:From:To:CC:
         Subject:Message-ID:References:Content-Type:Content-Disposition:
         In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-Originating-IP:
         X-MS-PublicTrafficType:X-MS-Office365-Filtering-Correlation-Id:
         X-MS-TrafficTypeDiagnostic:X-Microsoft-Antispam-PRVS:
         X-MS-Oob-TLC-OOBClassifiers:X-MS-Exchange-SenderADCheck:
         X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
         X-Forefront-Antispam-Report:X-MS-Exchange-AntiSpam-MessageData:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-OriginalArrivalTime:
         X-MS-Exchange-CrossTenant-FromEntityHeader:
         X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
         X-MS-Exchange-CrossTenant-UserPrincipalName:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=imvxpDSeXZ3NK845u85wSR/30OQy2+r1+XpjQQR9YP8ToTJJYuPMMbpKovB8gcx10
         rfmTObJZV95rDJaYyBnhouiRblJDR5jflbcBwgosw0Qgc+blpdGCl5eMq8lfG5O77M
         42JBy3xU26r6qlLgzQr3fc+vdXq+Kv6gmshveXHTOQZbWp2AzdGQGHzbRP0adKKdNg
         t10X58RnKWcN0LzwVtr9pWth6k1oJNZlUbWnIYF5UrwCmQJLx+UK98snY2N2kVsWqy
         MLP9ZI+Su5P/+rPQpXnXEeZL7jP0KDD4bEOd4yzVhfCgluA0E7crCL6fFmk1QFZf06
         dnh0OqCv3uuRQ==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 02, 2020 at 07:57:33PM +0300, Michal Kalderon wrote:
> This set addresses several issues that were observed
> and reproduced on different test and production configurations.
> 
> Dave, Jason,
> There is one qede patch which is related to the mtu change notify.
> This is a small change and required for the qede_rdma.h interface
> change. Please consider applying this to rdma tree.

Ok, it is up to Marvell to ensure no conflicting patches land in net..

> Michal Kalderon (8):
>   RDMA/qedr: Fix qp structure memory leak
>   RDMA/qedr: Fix doorbell setting
>   RDMA/qedr: Fix use of uninitialized field
>   RDMA/qedr: Fix return code if accept is called on a destroyed qp
>   qede: Notify qedr when mtu has changed
>   RDMA/qedr: Fix iWARP active mtu display
>   RDMA/qedr: Fix inline size returned for iWARP
>   RDMA/qedr: Fix function prototype parameters alignment

Applied to rdma for-next, thanks

Jason
