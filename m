Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBC1766DD9E
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 13:31:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236514AbjAQMbT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 07:31:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236318AbjAQMbS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 07:31:18 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2088.outbound.protection.outlook.com [40.107.93.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C815735264;
        Tue, 17 Jan 2023 04:31:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MDLO+b5x1QVCxdbtfAXsNld480Lw0bvSkvsRkAylziasKmekqH3/1r5Z13Ou9LE6s6luxXJke7Ih4MXZaxKqK7JvqbmDpGVbLyYR7769ztWKxuxKlmwrDrfEh/dlzl9HsOxcbP3Sjobee4vm2uAccxYGxxNhXD1/jQi35edVt7Ge11RBpy/a5xFQ9Ny8m6wG6Xe0enIWC958eQYIrIwmE4qurV6dOVFaohRzst86GzHcbER0GPSHsC4ZKZXoqJ4hX6dwtR5NTs7yPwZVM5Gf1vP9bLQaBXq6+lXgYxhpuWHM0M3xb6yheyO7D66gTXWmrsy6frH/v0am/DJ/HtpvXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u1MuoF+g/K4VBg7YtrVP1Txdnfnuoe9DP0q3fL3qTe0=;
 b=gCdla4ziD4l6kCATr+gsX9XJqkC1QGROdY5bMPek+MTW5y2s8Yix9ToAJZ7nFZlHp8b23v9SkUW9yxTFNjQUZq5GG6HJSToJc6BEXmO42xd/+rdGG3AB5a3eDW1RLWOduXp7cZqW2NSBv/ZAZr8K+ZJQwl4kwLGJhiNG6SIgBjeRh4aLNgQIJIJdJn81bVrOQB7+UhiwkiwTFHAKqjK3ngJgxkr6dHOLWjcpTq6ZhgcNtJKUKyorKTsJH9kZOpQRN2yCZNh0Kk427ay/mQVTMJdZV5TJ+2xsSHq6YKkJ4HFhA+iCFtqAXB5kF9ohRDUlc6y1H/7P+SqUiFgKlWI0iQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u1MuoF+g/K4VBg7YtrVP1Txdnfnuoe9DP0q3fL3qTe0=;
 b=XB2d3KVa0+DBMKDVxSTDyoR1a2O3xhDeOd5S3diAronG8XfIY6Ai+02fU0AA8uaG6QBs6JBWiaNBfsFzTVkvdFndefRqNqkuoygh4RREvarfJgJl8hy9a3d8v5t1ZUVyJ7DhrIIIS45mWQQyK8s/DWwe7HS/FAgB9qpbR9Ypah5x/Dd/iWcIyHxTteAfa+92Mq5tM/znE9ZLftr78AjKLj1ttRovLEP21g1JY0vR6QF+g2swpHjWT5WL29z2QYSzYoD9CAhR/eDV6jL5boCHxHaotvwr6NGh5ql/8sDJ0mb/3PzJ7oSZ3zu5i8hcfX7HvtgVeG34V8zTX5r8OY/Ilg==
Received: from DS7PR05CA0054.namprd05.prod.outlook.com (2603:10b6:8:2f::28) by
 SJ1PR12MB6170.namprd12.prod.outlook.com (2603:10b6:a03:45b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Tue, 17 Jan
 2023 12:31:15 +0000
Received: from DM6NAM11FT085.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:2f:cafe::9f) by DS7PR05CA0054.outlook.office365.com
 (2603:10b6:8:2f::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6023.12 via Frontend
 Transport; Tue, 17 Jan 2023 12:31:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT085.mail.protection.outlook.com (10.13.172.236) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.13 via Frontend Transport; Tue, 17 Jan 2023 12:31:14 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 17 Jan
 2023 04:31:05 -0800
Received: from localhost (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 17 Jan
 2023 04:31:04 -0800
Date:   Tue, 17 Jan 2023 14:31:01 +0200
From:   Leon Romanovsky <leonro@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Ajit Khaparde <ajit.khaparde@broadcom.com>,
        <andrew.gospodarek@broadcom.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <jgg@ziepe.ca>,
        <linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <michael.chan@broadcom.com>, <netdev@vger.kernel.org>,
        <pabeni@redhat.com>, <selvin.xavier@broadcom.com>
Subject: Re: [PATCH net-next v7 1/8] bnxt_en: Add auxiliary driver support
Message-ID: <Y8aVBTAVFQPPx47H@unreal>
References: <20230112202939.19562-1-ajit.khaparde@broadcom.com>
 <20230112202939.19562-2-ajit.khaparde@broadcom.com>
 <20230113221042.5d24bdde@kernel.org>
 <CACZ4nhuKo-h_dcSGuzAm4vJJuuxmnVo8jYO2scCxfqtktbCjfw@mail.gmail.com>
 <20230116205625.394596cc@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230116205625.394596cc@kernel.org>
X-Originating-IP: [10.126.230.37]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT085:EE_|SJ1PR12MB6170:EE_
X-MS-Office365-Filtering-Correlation-Id: a62142ac-fb29-460a-7060-08daf886b968
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: w8B9u529iUad3W/crFeQiImet7UHKTP6B0slagBmQojFQQzO7KPduq22dTZvNGLPwPG+Oa+wA11sXCmUpMsDYNT1oDO30YVZCMG4F8dhhkC5wOaHvQUyusr0PgTbROq+DxhVUTrO6KGt2NBFGeAiRzVF6ZP75RIqN1v1f0DNYmQ3ZGHtBkM6QM4XtqvKaVGLOyjBzhtxkyOREeTM75SCaonPCEGqmc1qd8cUwoOhzxQMPrCsr8KUwSx0ITEQaoegnFJOgSrpyb9yNH6k0h3jq1M2JNawo2Ruyr70yGc4DmlO89hS31knBadDOyZjfUde8JCH7l5uE+TwAGvnJDnboUQ4wPPuHHe2sj5lVndwehrNrso7xnncR4k9ZHE7Tu2+PmZd0q5ZsRaL/jWJ4oVilXA0tQBpY1OuPs81aw36KZT5CdLNGF32WOeKw07T97c/QbYVdYF3C4Ewe0wtLlfX7XTRM0yrN2XsfmfTk42oklIktXqF79UfR444wek2fNJ2yD/rP+vyI5IgM36b93b5KsEgwG26ZRpNl3s9YHCKDTuHnSkHr8bwBj6c0YB2RDXw9oInJ+hzSovsNZARowWRiG1cypWt9fpBxhhVaZr+XFmWqTFyE+Dl8QhlzAWBGSgz5GPCYZI8SG47Cn+OVTXtIOFIFLPojXN2ItaFoG1ZdR6fzYfPlBKxIy94pVt6pjUyB1G2qQXXLZpzFgdtJ5xhNQ==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(7916004)(376002)(136003)(396003)(39860400002)(346002)(451199015)(46966006)(36840700001)(40470700004)(426003)(82740400003)(47076005)(356005)(7636003)(41300700001)(478600001)(186003)(86362001)(316002)(54906003)(70586007)(33716001)(336012)(40460700003)(26005)(40480700001)(4326008)(70206006)(82310400005)(5660300002)(36860700001)(2906002)(7416002)(6666004)(9686003)(6916009)(16526019)(83380400001)(8936002)(8676002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2023 12:31:14.4719
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a62142ac-fb29-460a-7060-08daf886b968
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT085.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6170
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 16, 2023 at 08:56:25PM -0800, Jakub Kicinski wrote:
> On Sat, 14 Jan 2023 12:39:09 -0800 Ajit Khaparde wrote:
> > > > +static void bnxt_aux_dev_release(struct device *dev)
> > > > +{
> > > > +     struct bnxt_aux_dev *bnxt_adev =
> > > > +             container_of(dev, struct bnxt_aux_dev, aux_dev.dev);
> > > > +     struct bnxt *bp = netdev_priv(bnxt_adev->edev->net);
> > > > +
> > > > +     bnxt_adev->edev->en_ops = NULL;
> > > > +     kfree(bnxt_adev->edev);  
> > >
> > > And yet the reference counted "release" function accesses the bp->adev
> > > like it must exist.
> > >
> > > This seems odd to me - why do we need refcounting on devices at all
> > > if we can free them synchronously? To be clear - I'm not sure this is
> > > wrong, just seems odd.  
> > I followed the existing implementations in that regard. Thanks
> 
> Leon, could you take a look? Is there no problem in assuming bnxt_adev
> is still around in the release function?

You caught a real bug. The auxdev idea is very simple - it needs to
behave like driver core, but in the driver itself.

As such, bnxt_aux_dev_free() shouldn't be called after bnxt_rdma_aux_device_uninit().
Device will be released through auxiliary_device_uninit();

BTW, line 325 from below shouldn't exist too.

  312 void bnxt_rdma_aux_device_uninit(struct bnxt *bp)
  313 {
...
  325         if (bnxt_adev->id >= 0)
  326                 ida_free(&bnxt_aux_dev_ids, bnxt_adev->id);

And one line bnxt_aux_dev_alloc() needs to be deleted too.

Thanks
