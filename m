Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 873A757C6F2
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 10:55:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232676AbiGUIz2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 04:55:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232667AbiGUIz1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 04:55:27 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2050.outbound.protection.outlook.com [40.107.237.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A21C22BE1;
        Thu, 21 Jul 2022 01:55:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ME38uiORfoNpePLJxkJXidOS2fFQtWL9A9OAHsJYp6cRc5u1d9LYBri2koWMbduwknFO6zMXSIAWiOnkhXEskTgOYczZxKH8tFo0Vmy9xI3/GQY2xhZ/K7PbuZ14V+MqiAnG3pCDxoY1PsNqy4ZTl+e1rit03VmRLt1Ek3IeOaQRGibijLuLQmFun7hLdsBSWT69rSJo6IHI+q+PLZIXjsRZqxji7801FwUdBEteXjPJo/Aycp0+9b5UbIaqGqnqJGXOYiS6fuqEIFjkgsYHVX90XZEIcYNk+yd2iO2dmN5zmXL2oQIuw872Z6F/tBO04K6+hwo2QVUK1GUkFNXHUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4Pxw1wXrW+Ah8mbFA7e/pX5ixAtVAf88g79HJakqDR0=;
 b=Jta1tzLNXHJyHWhM8Oo5hBDgD4i4ms79g23yw5mDxlwmWEc6nM2xU16xQ0lP4FPGPssyx87FmzZkcXDG6QmH1JNpfrs8mzuPDa/R9Ake+UFjjzbd33filYxnxFEntph1eezyan4alT3rgRFvPkoIzqiWExXM1pjvVy4tZayygKGEPJflyi40B4l+TiGiwspzf8QSMF3KxjELiOa9t5XQvm/1qhOgNZK1zVchU3Gqx22lWFBClF5l2jASHWmuAFmVipix5fVWqa46MH2jR8NTYpPoJV75LPx8c2Q8nUT/J+7aPJQPHjk7quTu8hXofSpEpKrQdvmXgpTR0+j3OFCwPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4Pxw1wXrW+Ah8mbFA7e/pX5ixAtVAf88g79HJakqDR0=;
 b=XqvWSK6Y+LzEOLWBhIsPYY6Y8p9utdMieQnaqObJIa11XMPO8vmPT2ds0nRfs6wksnu0rWqAI8yzeinPJY2ZH2bjsQ+1DMPAK/KsYBpcklUoyQVxGXQNtKWy4Txib2Zhg7u/3E+kLEdrGflrCGOS8cbpiBfAsawPiEiUdKAuZRPI9VZYDnbcS55sBY4s0PsNSfhTkP7CnhOWN1NE+rUWyEKGI9A/4BhSrteoftSQCLw0c3qG9i9zc2A4SlPXlcbWlMOhGHpWvWxHlC+U4Hz6CiotWLysscjIm/leIIYHvlmNz4x/UJKoj4Si3tOaLHw4uYkC8/gcUY5nwPT/P2jOCA==
Received: from MW4PR03CA0271.namprd03.prod.outlook.com (2603:10b6:303:b5::6)
 by MWHPR12MB1632.namprd12.prod.outlook.com (2603:10b6:301:10::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.14; Thu, 21 Jul
 2022 08:55:24 +0000
Received: from CO1NAM11FT019.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b5:cafe::cf) by MW4PR03CA0271.outlook.office365.com
 (2603:10b6:303:b5::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.18 via Frontend
 Transport; Thu, 21 Jul 2022 08:55:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 CO1NAM11FT019.mail.protection.outlook.com (10.13.175.57) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5458.17 via Frontend Transport; Thu, 21 Jul 2022 08:55:24 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Thu, 21 Jul
 2022 08:55:23 +0000
Received: from [172.27.14.243] (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Thu, 21 Jul
 2022 01:55:19 -0700
Message-ID: <99b6e349-7241-807a-1b00-9b783a9555bc@nvidia.com>
Date:   Thu, 21 Jul 2022 11:55:17 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH V2 vfio 00/11] Add device DMA logging support for mlx5
 driver
Content-Language: en-US
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "saeedm@nvidia.com" <saeedm@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "Martins, Joao" <joao.m.martins@oracle.com>,
        "leonro@nvidia.com" <leonro@nvidia.com>,
        "maorg@nvidia.com" <maorg@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>
References: <20220714081251.240584-1-yishaih@nvidia.com>
 <BN9PR11MB5276425A5FC37EEA1324A4318C919@BN9PR11MB5276.namprd11.prod.outlook.com>
From:   Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <BN9PR11MB5276425A5FC37EEA1324A4318C919@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7aa3add2-2644-4699-e2c0-08da6af6c005
X-MS-TrafficTypeDiagnostic: MWHPR12MB1632:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JR1hDueQV+gDpRrQAMXiLl4uiL+8kHE5WTiDEuVeoNM944dbDpj086ZZxkLDZu7Q3CzdAdBv+l0+QweK6KzuK6J4JMhf3K+nX5JbXpcr4NcZlVOI4rxNNBejRTt5DYgmwENWS0i4D2/pAlyFuFkbe53EqORdKMxtwM9ZhRNKzIF3YE8z0bkcc3JTCzGK8K1VQm6o0Pc+W/1v+RvdyxOoKQBCVdXfsV256K6YokePUKSSJvlG0PtbwQlvYDLcGbFql+tC+JoCULXu/diqCHiRGYAtgKCAu9fqJcpGTAjuTPDE0iBO02ujGozEsGAo5CKXPAh1u9HbsJhROMXvx8VTcSdKpzYMWq9pgLHX0ECGfeiSF5DAq+1+ZBmcbz54583fwcYIxQLQceJGGDeWhFKroi0rLRHrpSNTs3b5fZzhICo6QP+3LASjCFTJM5crJHi0zmTNLI7DenZgOdQe6fjGou+K2YNoB/yYGCi/Us5wI/QgMyw/6LxqEJh8u4GNdztf8axyZYdyl3r1MdtKf8HR04qGkt84kre0Gj8Ue1n4e+J4LTS4/IuJ6eU0zcOJGQ+7k/5RAlF/0JE1B35Uau+/ehV2UVVgKtuo5iS2Ap19k0gKcGpucu5SYwLNGpXlm3uX6cieEW9Ea9hLyHd6d60nIbFyN+ob318xeCWltnTbuxdiQDJ+ckHLcNX8fhLf2RCE+JMBtt5p/nVxWPkGZ/JR00f6Ljg52kXab44SGxPvV7Ajhxu1voG9EgkX2RDH7Ag1badU74bO7sMJtLBk+fxdlH7jzOcz7Ww9Lk79LQ8uxfBvDdxSyv+T1QOtTWa3GLTpLstnY/OGcTxUwchY7xCXafyQgTB+9wrVtl4cOlP+CccTlqhRCV/L5C2PmHERnlVW
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(376002)(136003)(346002)(39860400002)(396003)(40470700004)(36840700001)(46966006)(4744005)(336012)(2616005)(16526019)(82740400003)(186003)(31686004)(81166007)(47076005)(31696002)(426003)(40480700001)(8936002)(110136005)(5660300002)(316002)(356005)(2906002)(478600001)(53546011)(82310400005)(41300700001)(86362001)(40460700003)(54906003)(16576012)(6636002)(26005)(36860700001)(4326008)(36756003)(70206006)(70586007)(8676002)(36900700001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2022 08:55:24.1206
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7aa3add2-2644-4699-e2c0-08da6af6c005
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT019.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1632
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21/07/2022 11:26, Tian, Kevin wrote:
>> From: Yishai Hadas <yishaih@nvidia.com>
>> Sent: Thursday, July 14, 2022 4:13 PM
>>
>> It abstracts how an IOVA range is represented in a bitmap that is
>> granulated by a given page_size. So it translates all the lifting of
>> dealing with user pointers into its corresponding kernel addresses
>> backing said user memory into doing finally the bitmap ops to change
>> various bits.
>>
> Don't quite understand the last sentence...

It would come to say that this new functionality abstracts the 
complexity of user/kernel bitmap pointer usage and finally enables an 
easy way to set some bits.

I may rephrase as part of V3 to let it be clearer.

Yishai

