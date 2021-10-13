Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D9DE42B100
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 02:33:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236054AbhJMAf7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 20:35:59 -0400
Received: from mail-dm6nam12on2088.outbound.protection.outlook.com ([40.107.243.88]:3169
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235639AbhJMAf6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 20:35:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ig8dI72VJN687rZfhQiEI8I4bNcqkRvPb+wETi0Pxq2i1zqoblKpX22wZbGd7xHQnJePTXjfxzyDj0nAT5V8IpMe+lDKaJSHaqMtSCFCHhItfdwdMYq8q26HORMkUUzhovIbLQyOKQjQPHD0HxXiHwFNSpr6EPSWLoUWsamFLopb+HPhp3dxx9OsX70PlFFz+RwNmnGp80GgP9kMd0IAD722CGnnNy646k1zSHESfvOlpSajASFIYPuraLt5JGc3k9s2H2/KXzxJINXmo05VjkFVB45ykSxCX6P4K6bBoOBJmOaKu/vVnI4AJvdeGQvNxsJrqiDnG3Mp4zO3gAlzlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eskebt9OXqg1/M65O9ePEY4PohZuDo1PU17cYriiiZ8=;
 b=oQIsEyaJ4pghICdMdQt8SKHYE3rXJly5V0NEXtJ/3J+9QPZqmeJGESor6DbGG5enZXWrl/vDRzthudjH8web6g6O1VKcnhhRCruS0MwL/gh5j9NN04eqWBsUokZ4NViZ6CHmLxwwWwfIx/6jdgzCQp8ecSr0EwJUojz/+rJ8dCqifxl0b7eGu7ZR8cNzWUDwBLAGGwWPQEFyy/464Iwv2VN1pgjygiwrE2auZrYswetvuSWZQMqeGS2suGLc5ZMhlkKlcNhZJbiU5elXt6LBh7gETH4SaIi0UWcrvm8AMZMzW/UyA0qb0UCFV6iO7lqa6I4gt8pK5nVfMY9yf+xROg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eskebt9OXqg1/M65O9ePEY4PohZuDo1PU17cYriiiZ8=;
 b=lRwNOjC27kbDGtN8CZk9XNhwCMjSqbIWZ71YMwJ5foIQtyyvyymv39DnIlz8IcKBtj8cnvkwK3PZdPAtXdYTGmX0IMcQF0QtBgBxgUNbzYZvOCz4m1G5VmIDjT7cDPA67/lGjUL5iq0Ufpe9g+ppYOy1J+y5zfEI47tzJhDC+nipkg1OUg1OUHfaKav0aYZJPhhLF3fgwo+PUQDYE1FePD5sHIcnqZNCS9GWpXq13ndZiB6WSWDuGxAbIeZuN79INAS1Xsuiwwt+VSkTqTPkwtH8sUJ1dronp9QAcjf8djLQyM4Xt1TtfNffGPLSgk7KXKG36bUoB6V6X6srJjTxsg==
Received: from MW4PR04CA0369.namprd04.prod.outlook.com (2603:10b6:303:81::14)
 by BN6PR12MB1137.namprd12.prod.outlook.com (2603:10b6:404:1c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.26; Wed, 13 Oct
 2021 00:33:54 +0000
Received: from CO1NAM11FT033.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:81:cafe::e2) by MW4PR04CA0369.outlook.office365.com
 (2603:10b6:303:81::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.14 via Frontend
 Transport; Wed, 13 Oct 2021 00:33:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT033.mail.protection.outlook.com (10.13.174.247) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4608.15 via Frontend Transport; Wed, 13 Oct 2021 00:33:53 +0000
Received: from localhost (172.20.187.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 13 Oct
 2021 00:33:52 +0000
Date:   Wed, 13 Oct 2021 03:33:49 +0300
From:   Leon Romanovsky <leonro@nvidia.com>
To:     Shannon Nelson <snelson@pensando.io>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <drivers@pensando.io>
Subject: Re: [PATCH net-next] ionic: no devlink_unregister if not registered
Message-ID: <YWYpbScU1qT6CagV@unreal>
References: <20211012231520.72582-1-snelson@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20211012231520.72582-1-snelson@pensando.io>
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6816cc0d-fe51-4428-56fe-08d98de12292
X-MS-TrafficTypeDiagnostic: BN6PR12MB1137:
X-Microsoft-Antispam-PRVS: <BN6PR12MB113721D76F16A9D0C95AFAB3BDB79@BN6PR12MB1137.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: a+hozfeRTnzf30KQLMoKWV5zfj06UTUtO51eRXsXMAr08DOj11RyZIK55QibUvrrLZAsHbG5dD8PuZInBC0REmaKQyCDd7YKj0g+Urv9ItQQpoNJHMwbY+Adg09+eKyx7C/Ah02DYp2C3Q9PSe//mAgWn+9CW5M+jiM5roNcWM4Qe9pjugbzcjNTytWoia4hVfzXC2mbIXq9seH1F6eUnIGGnT2EctdmH+yZczwxl55xPMA2Twje9ztfftSLyIfXmhZ0H+kx8YvJ9dT9TiJy4c+raEpgNS7av+iOcLmLxcxIlC57UXaDwtcN/iJLtzzDOaxVYRoZKrtVMm3cKGzb8PDS37z1AETiZKZ3Stgp8ZKKDuwXWvVQOqAmzc3MITOPX09ku7Fr/PfQj8WFXvKow854kRs1DMfqHm+HrtqQnH2dp2Kov+azFthfywqarRZUzAOTY2p+uDbb9f3h/NWiFEbJvB1iHS7ynrOrIhpsJotFRJZJ9/zbix58rKsfYGI8lUbubIDS211Klb5XWQ1hAfSdjqtSd7aGrKqaCH7BJzMAg55C51nTrGyEFHWXg5xQS9qIpw8TVIrOI5nn0VBe7V3PndkJAvtRxRjM/PjqdqBfvsf+JMZvVsQ+KKLLBIQqlnBrzc7lxbXfQwP2JBJvcUh/vOufReO64/XsAIAZwKE1BxO9ctf59h88KcteijG91QzPcvzyDrH/VlskGpgNHg==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(7916004)(36840700001)(46966006)(508600001)(2906002)(6666004)(186003)(16526019)(336012)(36860700001)(4326008)(26005)(7636003)(82310400003)(54906003)(47076005)(316002)(70206006)(86362001)(4744005)(426003)(36906005)(6916009)(8676002)(33716001)(5660300002)(9686003)(70586007)(8936002)(356005)(83380400001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2021 00:33:53.5740
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6816cc0d-fe51-4428-56fe-08d98de12292
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT033.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1137
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 12, 2021 at 04:15:20PM -0700, Shannon Nelson wrote:
> Don't try to unregister the devlink if it hasn't been registered
> yet.  This bit of error cleanup code got missed in the recent
> devlink registration changes.
> 
> Fixes: 7911c8bd546f ("ionic: Move devlink registration to be last devlink command")
> Cc: Leon Romanovsky <leonro@nvidia.com>
> Signed-off-by: Shannon Nelson <snelson@pensando.io>
> ---
>  drivers/net/ethernet/pensando/ionic/ionic_devlink.c | 1 -
>  1 file changed, 1 deletion(-)

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
