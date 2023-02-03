Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 301826891AC
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 09:11:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232634AbjBCIK7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 03:10:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231233AbjBCIKR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 03:10:17 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2113.outbound.protection.outlook.com [40.107.223.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18D2D945F8
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 00:09:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dyMOKyiVx7vRmveNLBuWTDapz7w3ipKS6lKXANkYWhAzEaybP4NoBAif32Oksfg8JooPFASoyzLXlnsTAVlMFTGM4y1J7m/6+rICz/u5E2r8AGxhnKpJ7P8zL44iFwc8TGiYmVNtn8/AEDa478+LZZQFhFONfgvbs6izGt+0TPiYo/up+ttx/5CKik8fKEYBeWrtR13W3/C5+c76oLNltJtkwfr9lEcF76P4eXdDnMvxn0WK//Qw9kb5xQg3Zm7Bhg1vG9lW3dbOA5ZbDWSlBgqEoH7R7SkoJovk3/0agQ492K+Kd1Zmo8jpKSoG7LEiStGQm/EW3V5DjWBLTKAMbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9N9r9nWe5cmzXJhhNegKL7GnRkRKOj8tcNR2ZLmBsJw=;
 b=RSt+UcdmeatW7J42mLazogmTWQm+0Ta91P/Xqha7EJBtukEHwiuT6NO5UQZ4UvxOu4iMySMbprRgA2lPYtcTlfPo9KizOi1dc3Aj7vx8wzKMGYiMBH0XWk9Jk+FeF71xfxekqCuVWcbjJqpCaRbZJxDStyQkDe752XPws0JUBR90i+NXgmVvHlZOkrFh/TEJe79SlJUJfwipfyqxfZKFLSQHLrYtwnkjlv6Yu8anK5+HGli5SDcBM0zmf/L4kFl62lW7M1gn9P02qKGf9twx9eTc3AtK3rZU5uLT1IjfWBZIORfQrsYAb893paXQucjnRCeViHa8nOgwmTQpCcVhTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9N9r9nWe5cmzXJhhNegKL7GnRkRKOj8tcNR2ZLmBsJw=;
 b=a9bFh0YYXZxeTw3ibeVLjFWkguJQEJH0hwVWjTtuttZVXxAqDKRIXOKK2+3n4vEfZTkGXjpJ+suttPrN+RXXjUXX6xrBmmP0M15oPEvXLd+Ti32rbmGgeEcV9qSpvEPvb07+K21HJSMFYqLhbUXVFTOdv+VVySyJsmkRoI+pDvw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA1PR13MB4845.namprd13.prod.outlook.com (2603:10b6:806:1a9::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.31; Fri, 3 Feb
 2023 08:09:30 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%5]) with mapi id 15.20.6064.027; Fri, 3 Feb 2023
 08:09:30 +0000
Date:   Fri, 3 Feb 2023 09:09:19 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Raju Rangoju <Raju.Rangoju@amd.com>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        Shyam-sundar.S-k@amd.com
Subject: Re: [PATCH net-next v2 2/2] amd-xgbe: add support for rx-adaptation
Message-ID: <Y9zBL/3GdBRRRh+i@corigine.com>
References: <20230201054932.212700-1-Raju.Rangoju@amd.com>
 <20230201054932.212700-3-Raju.Rangoju@amd.com>
 <Y9qdRsS5txwu3MND@corigine.com>
 <52212a21490af8e45588bd0e17ffc54655d44b87.camel@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52212a21490af8e45588bd0e17ffc54655d44b87.camel@redhat.com>
X-ClientProxiedBy: AM0PR01CA0074.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::15) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA1PR13MB4845:EE_
X-MS-Office365-Filtering-Correlation-Id: c07f042f-e0f5-4f51-f32a-08db05bdf9c1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 44ZVGUI9XLhDxd3EZxgkVE/bxHRsfCNXqAb/4kz3/xyO/LA2H+Y570pScV/sKPsu7BpFS5R/v8hgfULzXCDIhdGuSQ2qIcEbfYv/pYkbI7TH2lP7FQP/yFSg1liq9otp5xiDlDBsmaRF757OKxsHv+kbkH1rEmeyyxM3kEEwFMMez4Fq8i+pmNG8PBWO4k0n79N3JCGtCXp1ujyQlOxfxOLbPtUGMXYyOJsx+PcYGqNnDnZabFh7RkmtAeTXISs2fZoWYtwdlVcnLSDQeAFjBIi7bQsZ81pC8ebXeXEl9kWU0rJn5we3Dj3x6N6d9bi2/oTT7YyRA3ZU5Q3TrnDDUd9btmBk6hDc7wjqu2FjTsg/dvcqiuV4ZumCQ8hzk0mwd4g1IZ66TghlihlS2K3gUUDZByLrqQt/FXsNveEFtdNIYU+qR/gMOaLZbUEe5jz0DClfUGnk5eIdX8Md3iFsJfBJvV6z/eoh9UgAKapKsJ3J4rhG1CuvYmzwzjp90+DH02Ge10NT6uQPhrGosGFQ1alnkSXzXPt3hWS2Yy5I5dTab6R2TKPrrbBzOOqYQVdELfu1av71E+l2nqBhYRhDxtmwWtbwZdbu7GbMqroZFsxX4OOqmUjW/Kv//Jd0B4xSjvJ5yGXrPOqXDDYTV4Ck5e9pG8uQ8tj+fR/JVWPqirWKzAAgrB6yMgUNPvCXDJfk
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39840400004)(376002)(346002)(396003)(136003)(366004)(451199018)(6512007)(6506007)(186003)(44832011)(36756003)(2906002)(6486002)(6666004)(38100700002)(66556008)(66476007)(6916009)(66946007)(4326008)(2616005)(83380400001)(41300700001)(8936002)(478600001)(8676002)(86362001)(316002)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?edoMa7tOy7CQqSazKRpOe8V2rPtrETX4r3qKC/4GG3R4QQnwKLIU+9A4Ajsu?=
 =?us-ascii?Q?Ch+lqbhpxS9r8KS9P+RJLbvJT6DJfpP74Nz6WHW2jL6LzDFu6spXotLnUv3q?=
 =?us-ascii?Q?XhF3iH5ntB0zUuXSCIeTB1KhmCLMwSz5sbJbhZROT0xCvUfOKMJkVCvAsn2m?=
 =?us-ascii?Q?htVFnxguPM+J4MXLig8NebhVWVzW2w9ktfpQSxwkmhK/K4MgsZFKD+/sfr4a?=
 =?us-ascii?Q?BHcmoyHB6jTnaPx2ADw4hLrHXZ0yzjVQurjmRdvmpR3fMWOgOTvAH7Jyx76G?=
 =?us-ascii?Q?dwXDrALbjkp/pFpnTQEYs4IUyrzlG47FPSmKUrSTA48S07Eblumqs4DRmBWu?=
 =?us-ascii?Q?x9u6SIX9xhfhhQRWmF0+pWftptOUobYjRIgW7JTuUQxaBy/CMgy9Ge9asegW?=
 =?us-ascii?Q?+Tr++M8CBTVKVGTKLhz7n+fkymqUk9W8xJTxkiWUiQigNq6zebYbQ6v5kUZQ?=
 =?us-ascii?Q?t/XA4XcgM0qy4w+fftmJIwbRWEPuKry/dq+08MwmBh/n6o1Hi5AkLiLfqBKJ?=
 =?us-ascii?Q?63ziOeEKrDMckOGyBg2E+hWsE6Kj0OKyi0y8e+do11B2JtaW9O4Fd4PZLqYG?=
 =?us-ascii?Q?sRC3UBo0laB2XBY5bJGtyTHv+BZzVAgHMKUdSvqqiOkLl2s4dgCNw1BE2AqV?=
 =?us-ascii?Q?W/rCljdeY7AOMAkclNyCsPkPI/jcR6/B/oG6RD1xhgKOBUsxOQWrQpIY4p6p?=
 =?us-ascii?Q?bBLLUebjS6fqxcH0WQR4s/bHC57LOhOsHBvqhWUZO5jQbpiDZz+GxYuBQwZ0?=
 =?us-ascii?Q?ZKoKys5y/H8UZsPRWoO3AMTevV9D3AfgCxrjMVh7nxx9756R95aMbzU4pBAr?=
 =?us-ascii?Q?oiro38dJXrsCxkLcO0u6lNQDFnrHnpqDnZvSlM40o2lpT0HkfZjyc2pFCVLV?=
 =?us-ascii?Q?kypTOqMMNhZZumVGu3lxzzXjkbN4SX2fQ9FUxD/ntQvy3hVzdJE5SwuHsUcw?=
 =?us-ascii?Q?qadUoAS4kSP4fD2AB7F4prVqEPn1OxSmG5I5Xd2UeMfOo/uyPkndQ13YbqIH?=
 =?us-ascii?Q?LQGXZIWKm1d+Fwlt4CzbEyZkXdTaa9t5BBkyI1qwXbtqnYjDQUCmqEHoSnBV?=
 =?us-ascii?Q?hf81eXoyvrcd0NcMczl+NkkXioRUopPEQeXUOZbepL8hyJ/HDMp5yZHvJ+w0?=
 =?us-ascii?Q?6+T06I1Ezrp+NbB3tX0tEUKc3v4ciwBA2zRSa1zKnnrfeUmfb+nVw46TtIcI?=
 =?us-ascii?Q?jE0rQybbvYghxKnkAGqs1GZLO6AHUZlKEzp28CAiqq2NlTbyjnpDz6KpnMSc?=
 =?us-ascii?Q?oas7UGoOazli1OHAk66PwFMQwHvGwxTfyxHbBf9ThfA+FzNbgBIRzaHklMmX?=
 =?us-ascii?Q?m+myIBcAtyfwgpQ+lbK9az5dh4r8bUzJT26bGakva8TZX2EQA4zWfj1lUraG?=
 =?us-ascii?Q?ZpogLoap7byY5UiPVe2LwseqnUpNppINuZtrLCL9Z48MTwZZn8JXxzikI+Od?=
 =?us-ascii?Q?OJukbc3SJHal9CaODAJ6Uky3eT411u6+H5pN8uT6XLKq08HayNVxUE2Sps4U?=
 =?us-ascii?Q?sns0HWSx7bOhez61nMF2YWO0ebK4m3+slteEItt3OC6yNQLBaEQPGfMAIt7C?=
 =?us-ascii?Q?A+PSdHlB00lL9L8Ptn/fuHfUFESjn4hv3Uqa02osqZVJgh+SJkXTOH+edWwd?=
 =?us-ascii?Q?xuUOj1CqEc25kRB8x2DPmc2OcUVc9YUAgxWe3MpW9u/jgt181POkrCfitHqa?=
 =?us-ascii?Q?yNUGUg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c07f042f-e0f5-4f51-f32a-08db05bdf9c1
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2023 08:09:30.2127
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m4heaegPZqSVUrPFGYx+VcoXzWifDew0R2Zn8R1ORjwYe2EdJTeBbxHrqJYAUhs2zGPPZMJa6ZLvLNvyf2XuUF4WQquhRk3mqJSn6Rhny0w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR13MB4845
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 02, 2023 at 03:16:50PM +0100, Paolo Abeni wrote:
> On Wed, 2023-02-01 at 18:11 +0100, Simon Horman wrote:
> > On Wed, Feb 01, 2023 at 11:19:32AM +0530, Raju Rangoju wrote:
> > > The existing implementation for non-Autonegotiation 10G speed modes does
> > > not enable RX adaptation in the Driver and FW. The RX Equalization
> > > settings (AFE settings alone) are manually configured and the existing
> > > link-up sequence in the driver does not perform rx adaptation process as
> > > mentioned in the Synopsys databook. There's a customer request for 10G
> > > backplane mode without Auto-negotiation and for the DAC cables of more
> > > significant length that follow the non-Autonegotiation mode. These modes
> > > require PHY to perform RX Adaptation.
> > > 
> > > The proposed logic adds the necessary changes to Yellow Carp devices to
> > > ensure seamless RX Adaptation for 10G-SFI (LONG DAC) and 10G-KR without
> > > AN (CL72 not present). The RX adaptation core algorithm is executed by
> > > firmware, however, to achieve that a new mailbox sub-command is required
> > > to be sent by the driver.
> > > 
> > > Co-developed-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
> > > Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
> > > Signed-off-by: Raju Rangoju <Raju.Rangoju@amd.com>
> > 
> > ...
> > 
> > > diff --git a/drivers/net/ethernet/amd/xgbe/xgbe.h b/drivers/net/ethernet/amd/xgbe/xgbe.h
> > > index 16e73df3e9b9..ad136ed493ed 100644
> > > --- a/drivers/net/ethernet/amd/xgbe/xgbe.h
> > > +++ b/drivers/net/ethernet/amd/xgbe/xgbe.h
> > > @@ -625,6 +625,7 @@ enum xgbe_mb_cmd {
> > >  
> > >  enum xgbe_mb_subcmd {
> > >  	XGBE_MB_SUBCMD_NONE = 0,
> > > +	XGBE_MB_SUBCMD_RX_ADAP,
> > >  
> > >  	/* 10GbE SFP subcommands */
> > >  	XGBE_MB_SUBCMD_ACTIVE = 0,
> > > @@ -1316,6 +1317,10 @@ struct xgbe_prv_data {
> > >  
> > >  	bool debugfs_an_cdr_workaround;
> > >  	bool debugfs_an_cdr_track_early;
> > > +	bool en_rx_adap;
> > 
> > nit: there is a 1 byte hole here (on x86_64)
> 
> I think even in the current form is ok. The total size of the struct is
> not going to change, due to alignment, and the fields will sit in the
> same cacheline in both cases.
> 
> I guess the layout could be changed later if needed.

Ok, I did think it was worth mentioning.
But I agree that it doesn't need to be changed at this time.
