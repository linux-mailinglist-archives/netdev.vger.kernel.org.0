Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39DD06131BE
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 09:32:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbiJaIcR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 04:32:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbiJaIcQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 04:32:16 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2089.outbound.protection.outlook.com [40.107.92.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 822637665
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 01:32:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XXt4VJH8Jsq8m1u3TdH+r9RWpIsQaLiXTYM5GWQuzghMOyi7gfOMb+f5/hABBGAPfLCaRgt/Ck10zC+AzQ0AJc1oHxL4h5CpNacValj3YMCKf8LMrM8TE//L94qbOC8r4GAnzmm/qFZNliTLtVshdQ14/vhc2IBaIJdkld0xBZsfxB5FLcSpSFSEjEvRN+XIPDnP33amsjGzjAmb8BqR7qAZ+584ekPcu9Cyl+/4tSPaKwZqUg7WJYfnLl7hxWWyq9PT6utqdgBqGatWF6Xg2ZdtwRVlClExOPQNrvTCZ62TwIyT/DvPCg5RQ1/IDm4HIKS2FyTJNWMyAEL2Wjh8rA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OavcDgppTlSN1TV89NC4IQ0O4viUjpnVfXYVsjwF0bg=;
 b=UP0BryebIb06LObTBiBUWsJcWndc0grv+DDKcabA1ambzD+j9sq1ijPwDD2SGg5eCmz9JgsTWJImxbU3vv2k4/K5/JMm9jktWj8wCcCnOc9u5eGLyFolZNMUkTkSk3jFmhp9NVtFsuVnTlqF0A6gzTt7ZdJFw3PMXhn5Hsz5MXHp+wPrl8R+DpoPtRifSTU3YTtAWbmS8RTf2itE7S2jw2ECuQf0vsUUbBLUwSrggALaSqqaQeHHNrU1cBr8LEf+J297UaQXLKDUFsr/X4Emcg8nO/sCuUbEU/8DdcEEDmtPph40EfWUHkIQsZwoOTMzvFNytUi4M3zZz3eyUjM9eQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OavcDgppTlSN1TV89NC4IQ0O4viUjpnVfXYVsjwF0bg=;
 b=f2qMAmoruUsa0qL9NwmZaIZ5tuh8M2JGGF1B+MFmVGYpEtvHIXRW4A9PEp9lV4/cwm/7nJh36AEw43S+DK8o+jcDlydSt48mqDhy4CLK1INq3Rc5jDjjMaPtU0bJZJR6iCu5mgM4n7KNRFUaN9JQVmrNGReJ8v53JZrGzEgYyAgS0iwmyV1n1BVjZC+VhKmKx34J15ZiiE3dQjduS0dPR9NgiO0Q6jAm1BAchJtCXb4WVjbBU95e9nEuzmDLCvDUMivklFddQtiZ8i7EQXhxrtglD2Gey82ssXohnbcjsxt+IKsmZ+RCLlCpSniSoiQtgdRl+rEn3g3bRrcrqsmGWg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by CH2PR12MB4907.namprd12.prod.outlook.com (2603:10b6:610:68::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.19; Mon, 31 Oct
 2022 08:32:10 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::3409:6c36:1a7f:846e]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::3409:6c36:1a7f:846e%4]) with mapi id 15.20.5769.019; Mon, 31 Oct 2022
 08:32:10 +0000
Date:   Mon, 31 Oct 2022 10:32:04 +0200
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, jiri@resnulli.us, vladimir.oltean@nxp.com,
        netdev@kapio-technology.com, mlxsw@nvidia.com
Subject: Re: [PATCH net-next] rocker: Explicitly mark learned FDB entries as
 offloaded
Message-ID: <Y1+IBAoSHj3kLQIA@shredder>
References: <20221031075922.1717163-1-idosch@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221031075922.1717163-1-idosch@nvidia.com>
X-ClientProxiedBy: VI1P194CA0003.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:800:be::13) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|CH2PR12MB4907:EE_
X-MS-Office365-Filtering-Correlation-Id: d7e88f61-35d4-45d0-c507-08dabb1a6763
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZZwNcmXd2YXKz3p8Hz3y3+ZWh2LxZ81n9+jkxtvqa3/nvIGf/h9BMoN+a0rPtLlOPUMTB2GDrPpkTdw5Ul/AcghJ5KN14Nl98Eyqmwree1YFcqYe9kJrbQNtM1HnKZFJdFAT13KhW33tVCaxg18tbwjZtZjYxY5FzhfgRT+WyYnkNrWGbE2ECKSZcYuA/XGOelx37kBWCkaFrK3UV0+YPHeEkrWkx0TKrQyJqaJTicom+8l32/H40ZL0vzsH4u2JVu44XtzSp1JTB4OYeAcfQVzMaPqRoQDrNVpLBKvisTV85K5HKqa7d9ACcyw1QVEJd+0filY86khKHk4rXGv5MHFlGDYqsaZZ/W7wllqpe/reqEvBIYHoSYX4sbztd75cNry2Sdla9Z4Nxi3I+jqOQHFU1Bwg4RS8wm6Qp2UD7zjtoPOyBl3AQ9Ld5vEkDMMWe2zg0YbEePTmHOkGpk+SZV4UDdDKXJGrGXsWlkFulnnUkYZzE/n68bfJo3Ze87KNvtnSkPWtToIQJVdHsDj7T0+8EXLUP1P/SddgB8dZ7r30AkvNcegtFVz/4WRsaIAsuVk8CL32D3CyG6m+zpP2dn8EHYHCyxQeK7Eoyc9xSnR7a3wczvnVfLHDqA6M/D68FRUmHT3awNgwhIedtTSh5wsLZk9MkSmhv0pElxZubV915S19Z/N/Qy3t4IkehECc5DeXXDTEJeJp6WSYtGlZhOUrzq9mSKdsXPsvfI7/mR4QK7TJ1BSTxmCodk7QmNmkoeAHmeWeJticpkvbeCDLuw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(366004)(376002)(396003)(39860400002)(346002)(136003)(451199015)(86362001)(38100700002)(33716001)(2906002)(6486002)(107886003)(6666004)(478600001)(4326008)(316002)(66476007)(66556008)(66946007)(8676002)(8936002)(5660300002)(6916009)(6506007)(41300700001)(186003)(9686003)(6512007)(26005)(83380400001)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xevaoybWnbrQpNk7Ap7jon11/YYZqSHATmO83pbw9ukWfDc8gkWoclIC1Qbk?=
 =?us-ascii?Q?jQcipIJYMHOW/Dotwa2sQ1KD/zz9p8grA/GZb5iifgoN+ks+RCr8GbQd9jG7?=
 =?us-ascii?Q?xFxuFNcfpJlYulteooGusbiW2NMycbO/4o1zQflW38G3RMV1IJQcGkNpcruZ?=
 =?us-ascii?Q?IKkpjJKsh6Uc6Bt8PZdIe+2vyH+DJ7rNYGmYsTvbJhD6Qy1nnwQPPyEetyOO?=
 =?us-ascii?Q?pxfGc8Ks0wSOpZErLgiVc7Ot69yV6yoUohpvKDTBORzXsZYV+6eh+4sWJYbV?=
 =?us-ascii?Q?RlIKg/YKeNmigmoJfGfTQXIzqU+Xr98KoHDOVjcLYXqDpqx1/LoQYk/nV51l?=
 =?us-ascii?Q?iR/DOTcF3ONNDkT+tf6p68kGrITq1kW3bqcu1YUwO+pIv1RA1OsZin4mLaeH?=
 =?us-ascii?Q?Njb/YxzCJzyB6AXnNhx08Xzjt88AbZ2jzSYBNSMe3ITj4NKJgVi6VSjcg1vw?=
 =?us-ascii?Q?Ejmus3goucBXMLaa1+3HN7DV6KwaRNqsZTcla7FXZagHnkx1sZlRtCk8gAiw?=
 =?us-ascii?Q?b8wNXsfJnjPZN6ac3wsDdUYRI8Zq3BfL32Cv8vErwxlJcOSYwJp502Nt8bzg?=
 =?us-ascii?Q?VaMZN/rNNH/C3T1mlYVKgszwrxQKlKNha732VGm85IHZTtWA7nSVPGx42FOC?=
 =?us-ascii?Q?F4Fx3YXwTiD+jXqAGOZOHMHX5fe7Wdr/fzjgRhVLKK5egI0dthFpxfxkvrjP?=
 =?us-ascii?Q?5K5qjjoabUXfTaRXp15OUHH+9snOJjXPCXP2Fm7vi5v0U/IG3x7cLwIu4tvV?=
 =?us-ascii?Q?RT31TNPXSXUSo900GKYQTNsa7gjXOxdCYTnCLelku8Y1MWos3C2qy/3fC1B5?=
 =?us-ascii?Q?oAOy+ajGmSE+zSsOGXjarbeUGxezmIiNhj9g+BWyO5uniB1dTbj4VGx/HyRI?=
 =?us-ascii?Q?LYFLCzmILkLKCLgiJhdyNuOtEcoRm0/vDkCmSLHLgMdzuJ0/ybxyu7H6pBgq?=
 =?us-ascii?Q?EyMIBwC9htJ3QKQgj8eKbFsU4p8A7AfJ7wKNTk63UXShBWiL30kpK15o6jo0?=
 =?us-ascii?Q?ZC3tjP/DmKAMgZl8G/E6oxDPJcm49eB3QiwCgtXl+ER1gITRF2a6aeV25vRp?=
 =?us-ascii?Q?EoCZXPjXPkY7mtqQHOn8GNodi5WkQmZcXcBymd1Mo1mrz39Zju+9QT3t1GM5?=
 =?us-ascii?Q?fxqZsOnLaullRKjCk1qpeekMxPD7WO4atAjbZNwnrOs1fYdEsqZ7wMFhj2YV?=
 =?us-ascii?Q?0HujPMZyU4Ugl5OzhfZKdqgenZjvnBCb8NfmgaEHzf8iKPnhWQ4ujI38bDBU?=
 =?us-ascii?Q?r8JIJ5XkEtyMPMFx1+d3IAnI8caqhSpB3evzUUhwyJvBe6UgVwKZmuD7Q3NA?=
 =?us-ascii?Q?t6XhGmwuVcrADAXAblikXW/9oN+EMljs9ZsYrKh5h1W2fESP8jHbjVLIOJLm?=
 =?us-ascii?Q?zFDlXdADYtN6buaCtGu3N367/P0JPEzXznqsxDI3aMFS5Vq1URf1XsJK0vY4?=
 =?us-ascii?Q?vy6fMfVKCXUi8OOI7Kro3oMnCYCCD2xW+6dK0FqvKjETrN3W7exIBm8lSUZ1?=
 =?us-ascii?Q?51upGzjC0QMOi0rQx/tIHBDPCmx7cayKocKxOpBAbCLFuObztXdJRNymigFj?=
 =?us-ascii?Q?2l5Wkewn89M5qHJ3MA7OrjouRBTwVrbDUtvEOVil?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7e88f61-35d4-45d0-c507-08dabb1a6763
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2022 08:32:10.5419
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nUqtcKgUGC+eCqRxL0WIcG8wURUCPj6YXVCNUM1fPIpes5beLNnJTlDobpzcltc7iAljos9PEg1uR1Hzs5GDMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4907
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 31, 2022 at 09:59:22AM +0200, Ido Schimmel wrote:
> diff --git a/drivers/net/ethernet/rocker/rocker_ofdpa.c b/drivers/net/ethernet/rocker/rocker_ofdpa.c
> index 58cf7cc54f40..f5880d0053da 100644
> --- a/drivers/net/ethernet/rocker/rocker_ofdpa.c
> +++ b/drivers/net/ethernet/rocker/rocker_ofdpa.c
> @@ -1828,12 +1828,14 @@ static void ofdpa_port_fdb_learn_work(struct work_struct *work)
>  	info.vid = lw->vid;
>  
>  	rtnl_lock();
> -	if (learned && removing)
> +	if (learned && removing) {
>  		call_switchdev_notifiers(SWITCHDEV_FDB_DEL_TO_BRIDGE,
>  					 lw->ofdpa_port->dev, &info.info, NULL);
> -	else if (learned && !removing)
> +	} else if (learned && !removing) {
> +		info.offloaded = true;
>  		call_switchdev_notifiers(SWITCHDEV_FDB_ADD_TO_BRIDGE,
>  					 lw->ofdpa_port->dev, &info.info, NULL);
> +	}
>  	rtnl_unlock();
>  
>  	kfree(work);

Looking at it again, this is better:

diff --git a/drivers/net/ethernet/rocker/rocker_ofdpa.c b/drivers/net/ethernet/rocker/rocker_ofdpa.c
index 58cf7cc54f40..4d17ae18ea61 100644
--- a/drivers/net/ethernet/rocker/rocker_ofdpa.c
+++ b/drivers/net/ethernet/rocker/rocker_ofdpa.c
@@ -1826,6 +1826,7 @@ static void ofdpa_port_fdb_learn_work(struct work_struct *work)
 
        info.addr = lw->addr;
        info.vid = lw->vid;
+       info.offloaded = learned && !removing;
 
        rtnl_lock();
        if (learned && removing)

Will send another version tomorrow assuming no other comments.
