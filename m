Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00A7D4BE54E
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 19:00:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353293AbiBUK30 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 05:29:26 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354479AbiBUK3L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 05:29:11 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2041.outbound.protection.outlook.com [40.107.93.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9D8166AE4
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 01:51:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cc7OZf3m2nJFw+WPl2j8x1QtWnwGyM3S9uweYsOFoXd1e6X2OxV1NWx90HJWWowfgcZFODMDTM3fRh0+l0Ah9lqkVN/QYUrkN9ZjJ87ShIo9WLZZ7UyiQnDvSenOGHoZnRPpjckgk5y8hUtgeqto16eIx9WsZoYRVpVIdHDg1rgE6zPGsFHaArlOtjb9RVwEF0Ty7Br30Chlle7/51dNtVFNFmDTd0I+1fSn9ijwUFdhZOtW0hVYEBEJT7vOlslQJWnHKPDaXeYgGGCDSya40CwDPMIhxo/CQFv+jm/W/OQ2N+8l5jwZsY+zMzMD68HSgPzvk/6TU39rW4DuTseJLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4SYxTd92NGhT7Mts/VbcUVdC+xc6gRINV2xj+oFznsU=;
 b=XBjhpSatY/YvsCaeviQik6mSwEYMmwY0Fro8520xryrXz6JXpqUxkm6BqdN82hs91XsThJi9flY7WBW4ve/WBB0JhTDFJ5JNiVMO1dninpMQHllT91+BQ/RihrBNyJIGg+sbolaqtEykcxNiHLDrN6rw8uNskMvsoUbM+FscQgXyTcslvuSVMXfLHa217Qyl9H5wQpqoQI1nIBv6IREyjDsII84epWuQJdqKaZ6fF6oqd9FMDixJ+upLOZCF1tzvUThYqGYvKzyVN/Ml7UP8rQIEWgxMMojbLCWOzPMR6+f65Gakv2qOtjluotrX6EuI7B+XeG063VrQmq1NERSvdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4SYxTd92NGhT7Mts/VbcUVdC+xc6gRINV2xj+oFznsU=;
 b=GG+31mER58I50UvKKtEEKCqfM9d6/4aPeh6OnArUPH/J6IUJ42GI+bKKmGPsKA747J1b0zeETn+l1KqSq+xQthftunE/rzRjbIMZdm4/cH8IDt3TXYp+VS4tqpXA89AljCFH0SaaerZR9RR9A9ynove70RVm8B8jCM4wiSw5zp9o/CLlaYpxCj9h1/7CD+ZmjcWvB+ltJGitbGN5moXVYv79bLbZ0jWCuXZiVwfOjetZslJRhXFiJL3Eoy9aLpNlWoxDdl4Km5cpzBDQW5kieM453t0uocSo+N8MSI5t0z6ZpEFBfsMYMXTVPwXuK/O+5L2ZckE+6KHj42TmXrHabg==
Received: from DM3PR11CA0014.namprd11.prod.outlook.com (2603:10b6:0:54::24) by
 MN0PR12MB5977.namprd12.prod.outlook.com (2603:10b6:208:37c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.24; Mon, 21 Feb
 2022 09:50:37 +0000
Received: from DM6NAM11FT016.eop-nam11.prod.protection.outlook.com
 (2603:10b6:0:54:cafe::ff) by DM3PR11CA0014.outlook.office365.com
 (2603:10b6:0:54::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.14 via Frontend
 Transport; Mon, 21 Feb 2022 09:50:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT016.mail.protection.outlook.com (10.13.173.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4995.15 via Frontend Transport; Mon, 21 Feb 2022 09:50:36 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 21 Feb
 2022 09:50:35 +0000
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.126.231.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9;
 Mon, 21 Feb 2022 01:50:31 -0800
Date:   Mon, 21 Feb 2022 11:50:22 +0200
From:   Paul Blakey <paulb@nvidia.com>
To:     David Laight <David.Laight@ACULAB.COM>
CC:     "dev@openvswitch.org" <dev@openvswitch.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "Pravin B Shelar" <pshelar@ovn.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Eelco Chaudron <echaudro@redhat.com>,
        Oz Shlomo <ozsh@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Roi Dayan <roid@nvidia.com>,
        Ariel Levkovich <lariel@nvidia.com>
Subject: RE: [PATCH net v4 1/1] openvswitch: Fix setting ipv6 fields causing
 hw csum failure
In-Reply-To: <6dad3593d88d4afcae331b1225888884@AcuMS.aculab.com>
Message-ID: <52b4dbf5-8bd1-d9c7-f672-e7405a91b050@nvidia.com>
References: <20220220132114.18989-1-paulb@nvidia.com> <6dad3593d88d4afcae331b1225888884@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 80c65104-4218-45ae-e739-08d9f51f9c4d
X-MS-TrafficTypeDiagnostic: MN0PR12MB5977:EE_
X-Microsoft-Antispam-PRVS: <MN0PR12MB5977946C3A4AF4A3B83DBCECC23A9@MN0PR12MB5977.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Y2xU86bEb6+i9EJsokAatIrmAShJEaTpl9fyxNepoXEP9dBFBfRqoqbl+IT5VyKu/BA2EO/Qovp4QBlPhuKma+HDGNmVv4PiRjJpibAL7Xx8M28p8h96A9OSd8elh7Gtw88ow0EjXftASCx+neZJB9bTQpAHFYwQarq1IZGeD/34r2IQXeOgTs4hrzMfRMdNr1AE8OkPI7z1bK/lqk8UfM8x964jWezTN3WusoODq9totwq9tJa1nbRjKPoABuNztl4ExDFi0NRJYDXjg2ySdUxLyCKPsaX8ZK3zDPh8CiBwywj9dk/sO9KtLAHzjPGeWJFzg7hsqAlM8WsCV4PkF1D3ovN1gUdRNBXu/C5/3jsR6EU6+KDrbO4/OMUeCLMHVNIA4OYTsnyItwl7sKqsar8EDRxoBk+nim+rSZXzRmNdpM5uFWNeLqWEB4yqHz/EVHFdX/6NyV+CSFPS5xFOs0V3fMmjC59kItcKIfo7xz19qK+o2MJkwoM6uONPQDYmq0SiyVAzpasMXziE1wUwT5x8rPg/D24W0I2SRk5pUOWz4w+3FHX/C+5BrRwq5nqLt8NCMevyWwIu89r511l35LtTyz6FFDgaqBEonaURla/UOwpAMi40WRkvWhIqgBzxxh1k9idfqaqbdvWfIREH1IVivXizdcs7stYhCiRhduXneI6zGqp4YfY007gvDNjO0NDCi8jZfvWnQ3/hhsTG+w==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(8676002)(81166007)(4326008)(6666004)(31696002)(508600001)(86362001)(70586007)(356005)(70206006)(82310400004)(54906003)(6916009)(316002)(186003)(2616005)(16526019)(26005)(31686004)(107886003)(2906002)(36860700001)(40460700003)(336012)(36756003)(8936002)(83380400001)(47076005)(5660300002)(426003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2022 09:50:36.3528
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 80c65104-4218-45ae-e739-08d9f51f9c4d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT016.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5977
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org




On Sun, 20 Feb 2022, David Laight wrote:

> From: Paul Blakey
> > Sent: 20 February 2022 13:21
> > 
> > Ipv6 ttl, label and tos fields are modified without first
> > pulling/pushing the ipv6 header, which would have updated
> > the hw csum (if available). This might cause csum validation
> > when sending the packet to the stack, as can be seen in
> > the trace below.
> > 
> > Fix this by updating skb->csum if available.
> ...
> > +static inline __wsum
> > +csum_block_replace(__wsum csum, __wsum old, __wsum new, int offset)
> > +{
> > +	return csum_block_add(csum_block_sub(csum, old, offset), new, offset);
> > +}
> 
> That look computationally OTT for sub 32bit adjustments.
> 
> It ought to be enough to do:
> 	return csum_add(old_csum, 0xf0000fff + new - old);
> 
> Although it will need 'tweaking' for odd aligned 24bit values.
> 
> 	David
> 
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)
> 
> 

I'm not comfortable with manually implementing some low-level
bit fideling checksum calculation, while covering all cases.
And as you said it also doesnt have the offset param (odd aligned).
The same could be said about csum_block_add()/sub(), replace()
just uses them. I think the csum operations are more readable and
should  be inlined/optimize, so can we do it the readable way,
and then,  if needed, optimize it?
