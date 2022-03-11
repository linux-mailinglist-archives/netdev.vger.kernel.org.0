Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 274A74D680B
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 18:49:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346517AbiCKRuu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 12:50:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242355AbiCKRut (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 12:50:49 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2064.outbound.protection.outlook.com [40.107.96.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 572381D3DAE
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 09:49:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P3v/HcKzyX3x94ge334HgHxyKB/rGTj++FUXxxpsqYhJUKemveOt4phMYyU7tTeabBsPtRmpszyHOvZd5quQiwKxwlf7rMFLxJvSGWEdyXpu8hIFmAEyYUI9Kqkdmym4azJTh7CUW85tJe+PBBdPUVL4rYPRei49Rb24WNYnNrphbxYQysAawZ0QTTk/wrKcf6ChgCRRSx+uVz4wJG8Q93xGJ2YJVpGwyiDzN/r7Z/ESqjoIt08i1b9VFScHNCcr4OKJCst13Hg96CI8aacRXNU7esOY24W03qQP70/VDOmg6DiiJTaMsTRrVnfLWmkt0m2lIlm4rGPUzc8kTXLXCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zjI4HSbGyxG1DqgH+FmXwgjqsPSNikfddpHb64f4l80=;
 b=Is/WOx+Hn+O2M6y9G6WhL5ze0QPo2O0l5K3KzhrlT3G8Ziy1bZA0G58ztipIfxdtmRS3R2LkoUcysjMabzutAWRDeCOskQUrKU6xTmtmMM5pKDo+9OBi41IVFoieIwrL/ggqMQnZlq6KaMVlN6UXVNxRRfUZ57cYjfYxCoMhs1/Crhz2OAtxiFsIgh2Zt2aJoRXs6X8vlDFjs1uAKpX74PRHPKYp9v0C37gz+pVA5CJvxX6fqkv90jrXWXExgv78iRkcUjevJK1Kw1tskN8LCB9VRiNvvgL30ydNCAqJXmeIqIi6qxkqaDOAcP2/KVgjkHm9CvAnonhU+JtoYVqF8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zjI4HSbGyxG1DqgH+FmXwgjqsPSNikfddpHb64f4l80=;
 b=bYr7RUSvbWlXpINVRW4PKNIf7E7hOjOfZQRsvEa3dawYQh3A8gCxxESdoNnmScXQn7la/BKHcJlGYQUW/7VrVYDBdWmxQd9YW8IU57+CFJiqUN8HJ9plLyO6909/RUj6zUmOUQsNXJp4unmsqsGi6DM17PdZXYxC7BGa1mac+2z3qUb9OrPxCuzndZUfZnEhXVkKeN3P/GB7k+qAysZOB4q+JtemfuPUT+xmDrpob6JeRXhoUlaCN2UB2TrL2qrsMnYCbb+Fe0IQ95iWSP1mOADa5bOkGXPNMcQZk1mx/GIUp6+KnKWIKGeMiGJTXWClS0Nou5jr/s/MYUv3bpr98A==
Received: from BN0PR07CA0004.namprd07.prod.outlook.com (2603:10b6:408:141::22)
 by PH7PR12MB5880.namprd12.prod.outlook.com (2603:10b6:510:1d8::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.16; Fri, 11 Mar
 2022 17:49:44 +0000
Received: from BN8NAM11FT028.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:141:cafe::cb) by BN0PR07CA0004.outlook.office365.com
 (2603:10b6:408:141::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.21 via Frontend
 Transport; Fri, 11 Mar 2022 17:49:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT028.mail.protection.outlook.com (10.13.176.225) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5061.22 via Frontend Transport; Fri, 11 Mar 2022 17:49:44 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Fri, 11 Mar
 2022 17:49:41 +0000
Received: from localhost (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Fri, 11 Mar
 2022 09:49:39 -0800
Date:   Fri, 11 Mar 2022 19:49:36 +0200
From:   Leon Romanovsky <leonro@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <idosch@nvidia.com>, <petrm@nvidia.com>,
        <simon.horman@corigine.com>, <netdev@vger.kernel.org>,
        <jiri@resnulli.us>
Subject: Re: [RFT net-next 1/6] devlink: expose instance locking and add
 locked port registering
Message-ID: <YiuLsDa4jej7bVEz@unreal>
References: <20220310001632.470337-1-kuba@kernel.org>
 <20220310001632.470337-2-kuba@kernel.org>
 <Yit0QFjt7HAHFNnq@unreal>
 <20220311082611.5bca7d5c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <Yit/f9MQWusTmsJW@unreal>
 <20220311093913.60694baf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220311093913.60694baf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0b47949b-8dc4-4168-d04d-08da038786b4
X-MS-TrafficTypeDiagnostic: PH7PR12MB5880:EE_
X-Microsoft-Antispam-PRVS: <PH7PR12MB58807BFE87ACEE385A69A420BD0C9@PH7PR12MB5880.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yPAmV4xtPnveqlKT2NVZ0QRYA6AkKygGM2fFKhWHtcBv2DtrATUWafRZRZucy4Y/FUlMizVcpiaFNNCPxfUEVN0iK5ATEVoXT6/SVkKgUQGqmGEzGG/6UGqonwrgirlNfWqM6lj6qMt8ZZu7PjKYlHFZK3wabLTNXFaPNC1exfY2zU/mepsOe6AA04CGNsFfuy2Cjoef6tMSbo8y2pH9XyHfZ9F2O8TaOjtOiD4VfJxLdnuxREC4oHX/8x6/H0zCQvxtqeU/WNBbdpSFPeYrtaZTr9Sl3j4aGcqq91AEhaZIHAg+lbSmeXL0oT6CV2Y0bGSK72LR4DWlFnlRPz4SFkoTcg5unA3AtjVMIn/VdcO8RhZsMRubeZjyFsFpJ3al1tKosrgdG67QTq17CNs04hklH5kRhyiE8oV/C6dFBOqHCym45Ps92a0UPHp2ImPO2LxYhQAlUSEi1SKy4MqgIWN9WQs2WY84n+q2/222JD3lBrSZucjmGiajReU5RGve3/DS52k1bxKvqaKNXwRA8+x2UHPpc3EELPlblbARuUaTgr9GCo2F/7IYDRDlw+4LXkjDgAdXHC8WpHfEby2os/MML0butSpo4A363AFA+8I4cLR6RzNrm3dBeFZnIbhkEoGCoYvufHOAyNSvGIrGQwWbgvNnQgEDFEFUsSM/IgW9B6dJ4W3HXkSRjHhRX1xYGf3hMiYspDkuJidjs3lCEw==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(7916004)(46966006)(36840700001)(40470700004)(426003)(8676002)(316002)(83380400001)(36860700001)(82310400004)(81166007)(70586007)(4326008)(70206006)(16526019)(508600001)(356005)(86362001)(54906003)(6916009)(6666004)(26005)(186003)(33716001)(9686003)(47076005)(336012)(5660300002)(2906002)(8936002)(40460700003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2022 17:49:44.0092
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b47949b-8dc4-4168-d04d-08da038786b4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT028.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5880
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 11, 2022 at 09:39:13AM -0800, Jakub Kicinski wrote:
> On Fri, 11 Mar 2022 18:57:35 +0200 Leon Romanovsky wrote:
> > On Fri, Mar 11, 2022 at 08:26:11AM -0800, Jakub Kicinski wrote:
> > > On Fri, 11 Mar 2022 18:09:36 +0200 Leon Romanovsky wrote:  
> > > > What about this?  
> > > 
> > > Is it better?   
> > 
> > I think so. It doesn't create shadow dependency on LOCKDEP.
> > In your variant, all users of this call will generate WARN
> > in production systems that run without lockdep.
> 
> No, no, that function is mostly for rcu dereference checking.
> The calls should be eliminated as dead code on production systems.

On systems without LOCKDEP, the devl_lock_is_held function will be
generated to be like this:
bool devl_lock_is_held(struct devlink *devlink)
{
	return WARN_ON_ONCE(true);
}
EXPORT_SYMBOL_GPL(devl_lock_is_held);

> 
> > So if you want the "eliminate" thing like you wrote in the comment,
> > the ifdef is a common solution.
> 
> I think these days people try to use IS_ENABLED() whenever possible.

I'm one of such people, but here you put always WARN if LOCKDEP is not
enabled.

> 
> > > Can do it you prefer, but I'd lean towards a version
> > > without an ifdef myself.  
> > 
> > So you need to add CONFIG_LOCKDEP dependency in devlink Kconfig.
> 
> I don't see why.

Because of WARN_ON_ONCE.

Thanks
