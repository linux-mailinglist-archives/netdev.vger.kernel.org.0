Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0F8E66E4B8
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 18:20:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235224AbjAQRUA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 12:20:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229673AbjAQRTU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 12:19:20 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2058.outbound.protection.outlook.com [40.107.237.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E369E23C50;
        Tue, 17 Jan 2023 09:18:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SwYguFxe6rMLU3FpRlSC+hF+sHkvDsrYLG5JJwoqb2fLIakVxCNI3K+52KTSFRlemTsa0CDPas9eoMn0U2Gu1tOlBJ3dH0BUhRO+1LcXrEamS/eqbTSgPvln8xFlHeHkYoV5RPqWomiGlo1DgI5r10X9g62wuD2CXnJLPpdXlDFFyNnv0WufgMl/jViiCWLg202nq2u3KENT31XZTsbGcuk9E6WjQLqnGXD9TXQx3SFfbv5zfsBTJ8ByZATJ7H8jvMbZ/MQSu3aA4zBLs1orVhtySePZJrCd/Ayvt46ErqrgBDqg/GVW9XtcJtAutA27qtPH/d0WS7yeDamyzMbdyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NSUSoeqiT74nyvLYlss4Ps/L6AlUxLGSFvK7cK+1Va0=;
 b=VSHKoiJrsmPHu1QEJjkK05L2SQCxQ7QBxocGyso5hkVfJWYnC6HCmNzjGB/Dsw0mlpaJZJhi2RRvbrKkrL3LjQVaJkDRKOOWWvqtW6mPaeYz2hfwKtWca7KlsKcDZtgEDLKbpU+dX4HWi07HLA21Qi0oOcBTcMAn//hx3fmk5CzSMQsIU0nOA+Jm+dQegHQxiOdJMHhgghomTTfCNBZ/IaQ65WvWybVfLmncCQRvNvYGfaDYxK64kyCxQ0lxSM2QdSLwdomG4QeFMY+2048Ks3c+fU+3PUOLIpyZv2LP2awiE9tZ4Pk1zx3aQ0p0uJpceNrQPNH5XvmnnUHJCE4cZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NSUSoeqiT74nyvLYlss4Ps/L6AlUxLGSFvK7cK+1Va0=;
 b=e/EafRU/JHSh6QvhWd3BXSEbDASzx8OIjeKEL0Cc161uIy916ci6YHGN4+t/6Lj4XEf55UcgiuVQQAPL97Hgmo1hjw4Pnst/RHVDCJ4leg8Ya5ZkSBD3WQl4XJCdCFiPaVdjC7q06xU+iTy4ESv4rUJ6qcm/WvBJaea0PdlYElLVpfs/2QU5sHkIU4/K4Q/AnzM3igolpDfMBG4xk+RhqlGsis/2npgo0LnLKiII8KrjRFxPKhtjvsB/2be3r6fdw+fr8yAueyztTEeJ8TZ2Hk2Mmz5RbDQxhWALW7iEdIckWb73o8PNEMEMp/lmJwkPbGHRQjSWoaX5Dp91FM79Ww==
Received: from DM6PR03CA0089.namprd03.prod.outlook.com (2603:10b6:5:333::22)
 by SA0PR12MB4429.namprd12.prod.outlook.com (2603:10b6:806:73::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Tue, 17 Jan
 2023 17:18:37 +0000
Received: from DM6NAM11FT106.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:333:cafe::1a) by DM6PR03CA0089.outlook.office365.com
 (2603:10b6:5:333::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.19 via Frontend
 Transport; Tue, 17 Jan 2023 17:18:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT106.mail.protection.outlook.com (10.13.172.229) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.13 via Frontend Transport; Tue, 17 Jan 2023 17:18:36 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 17 Jan
 2023 09:18:27 -0800
Received: from localhost (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 17 Jan
 2023 09:18:26 -0800
Date:   Tue, 17 Jan 2023 19:18:20 +0200
From:   Leon Romanovsky <leonro@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Ajit Khaparde <ajit.khaparde@broadcom.com>,
        <andrew.gospodarek@broadcom.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <jgg@ziepe.ca>,
        <linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <michael.chan@broadcom.com>, <netdev@vger.kernel.org>,
        <pabeni@redhat.com>, <selvin.xavier@broadcom.com>
Subject: Re: [PATCH net-next v7 1/8] bnxt_en: Add auxiliary driver support
Message-ID: <Y8bYXDjDHvGDLCbO@unreal>
References: <20230112202939.19562-1-ajit.khaparde@broadcom.com>
 <20230112202939.19562-2-ajit.khaparde@broadcom.com>
 <20230113221042.5d24bdde@kernel.org>
 <CACZ4nhuKo-h_dcSGuzAm4vJJuuxmnVo8jYO2scCxfqtktbCjfw@mail.gmail.com>
 <20230116205625.394596cc@kernel.org>
 <Y8aVBTAVFQPPx47H@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Y8aVBTAVFQPPx47H@unreal>
X-Originating-IP: [10.126.230.37]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT106:EE_|SA0PR12MB4429:EE_
X-MS-Office365-Filtering-Correlation-Id: 3e78e05b-967e-49d8-d465-08daf8aede7f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0/JJlnMk2D46uM2bhAmox3+fM7uznYfGgzAQkQV4orJEQk7WGXrT1aXF7PtbFBl5K0AoawJmBy2Fan9UbUohsIr/EuJOSL/P57aHaHUqm/uiyz9MHFn5KdJr78HKhhAsBSAJKlFKXghkmeWg/+sjJhgiXMyWZ6Snk5q6qJxnIfAIz/VlOLxuzrRhEgC4mf9cmV5FgEBo5qcgVkYHuAlAgE8cthNFlS7QXoFwrTozeGQYnAb+7fI8OdrLNoKkaanmPd7egXEwdvv2BaGhZK7Vo6DP/XEwRMPocGRAiovJ9xxjGv1E9RThRTnYbrLKgJsgwo1tUZXPxygk5zfXCsg3wnwv3fePlQ0Fi6ULLzMY7D7b2Yc+2je5wbKP3eXytUyNg+UwYdtoVk8JZ0J1bpKAMdf04JQ0KwZUSy4KEh1KXcq0kU/FzvOZdSWDK6/Y0V7UnD79rbeFwwl9xbzA7s6amFjCWWrkFhACEEbEa7Dh7h0QapVoG3LT5UVlwyKKXqv2i2E9WOtM9rJhSP/QROjfE/kcFZ4jQTg42FfI2+TygmiWkGsvmCrydGIJv3fxq7uGbKSNb+ShlTvZqKfvH9xKjRRBWU2qqkmAVm9hOIp+64gZttQk0PTyxBoccnY+eCOMwZsLbf7/mIWvsQiZssMN5F6bOPu5SgvzT6uSA/r7fHYXEdqP+ZTIiPlj1BXxQAvpTnIYNy44faEZiFrX1mTuIg==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(7916004)(396003)(346002)(39860400002)(136003)(376002)(451199015)(46966006)(36840700001)(40470700004)(33716001)(83380400001)(82310400005)(40460700003)(54906003)(9686003)(16526019)(478600001)(40480700001)(186003)(7636003)(356005)(36860700001)(47076005)(82740400003)(86362001)(336012)(426003)(41300700001)(2906002)(26005)(6666004)(70206006)(8936002)(70586007)(6916009)(8676002)(4326008)(7416002)(316002)(5660300002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2023 17:18:36.5701
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e78e05b-967e-49d8-d465-08daf8aede7f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT106.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4429
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 17, 2023 at 02:31:01PM +0200, Leon Romanovsky wrote:
> On Mon, Jan 16, 2023 at 08:56:25PM -0800, Jakub Kicinski wrote:
> > On Sat, 14 Jan 2023 12:39:09 -0800 Ajit Khaparde wrote:
> > > > > +static void bnxt_aux_dev_release(struct device *dev)
> > > > > +{
> > > > > +     struct bnxt_aux_dev *bnxt_adev =
> > > > > +             container_of(dev, struct bnxt_aux_dev, aux_dev.dev);
> > > > > +     struct bnxt *bp = netdev_priv(bnxt_adev->edev->net);
> > > > > +
> > > > > +     bnxt_adev->edev->en_ops = NULL;
> > > > > +     kfree(bnxt_adev->edev);  
> > > >
> > > > And yet the reference counted "release" function accesses the bp->adev
> > > > like it must exist.
> > > >
> > > > This seems odd to me - why do we need refcounting on devices at all
> > > > if we can free them synchronously? To be clear - I'm not sure this is
> > > > wrong, just seems odd.  
> > > I followed the existing implementations in that regard. Thanks
> > 
> > Leon, could you take a look? Is there no problem in assuming bnxt_adev
> > is still around in the release function?
> 
> You caught a real bug. The auxdev idea is very simple - it needs to
> behave like driver core, but in the driver itself.

BTW, this can be classic example why assigning NULL pointers after
release is bad practice. It hides this class of errors.

+void bnxt_aux_dev_free(struct bnxt *bp)
+{
+       kfree(bp->aux_dev);
+       bp->aux_dev = NULL;
+}

Thanks
