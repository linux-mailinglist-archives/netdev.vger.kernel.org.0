Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFAA95828ED
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 16:48:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234171AbiG0Oss (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 10:48:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234212AbiG0Osp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 10:48:45 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2064.outbound.protection.outlook.com [40.107.102.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7950F3FA16
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 07:48:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JGogrPzR94spL2U++cJSQ26g4LdM6GHvbcrzzhmJzaCIpkoEQct70U0VTpBBpkpyUQr+PQHPuFB9vxGn57e49pvh36zxymZZH5YC4U3VJlFW+cUbGHbtbe4E/qTyRB9PjDuywaAJoKZ4oKDl5WC1ODS22c5/cLVjleTHBKTfXfEIuO1x7vbbZEjr0vYLUsL6bE2xRYRJ9pWsg+sfnbWmkSE3Zbza/gYLdVw2TJfXTQQB0n5vBf6rd562CV+3RXhTqAm3TGPG+iazhWVTDEBdtUWDUKT7W7/P+23maGMYzPFqo9hxefH+VjtTqGfwUEzJ/eZmKYntgB2/FiGMAmSnkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7x8Ocj6ghZkiJ6vr+dSJPTFEOf/9LVxKMf1CVaCqV/w=;
 b=MJsU2CeFHfkVYQP6YGU/osMVSRsvBK3cntpacVF1pnOcqYXxxwJeBlewBz8KiJuj75pV5qbETNw81gDwUQgQFJNwb+wyDBE2x6SkGja5djWN90d2/2nMw9nJTRJAgUixMlrDAmVtLehpQHkreBzeONPBv9/TvRpOGDrk4cshZTLvG8CQ6zkKZ7n8uJfjE+ZomxOXFwSYwB38dLV9+1PfpMZAGe6YGfgU28As27RTEfaCR8OgXntsLINYzVb6rXdI/Elq1jOLqL4V1xIGgMu07ArDjeBYDlfCET8v35kosJtC5YcMyxMuSYt0Wnt/dzuXcOv2LC60M/ag7MC+QjgwUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7x8Ocj6ghZkiJ6vr+dSJPTFEOf/9LVxKMf1CVaCqV/w=;
 b=ZxZDMK3XYwdZhaooGosjnYdpz172JHrUOgm6vTtLFwwU5rCuFdbxuRt1M0GAGNKK5oY+6GcjCrLLCK6Y/mnHIzwRRzVbRXlwax76WWjOYos9E+p2cnlxBdJwjrS45qL6obKzUSUCmKkh9pxniNQ5z59aSkDHJ7XJI+BxGXLX/ue7Dj1xObgVblANn+z4W7i/gW8zMVVo6O08AY2YCXoS2vvX9VqvM5EzeC9m/bwUOKkp7vGSqHHOkI2/uj0wCzDIXc8gXgdJMEQcbr0LJBvvqKUKmPa4XHZx6kGLj4UhKnCb0xf3YWUFZzGMJQ39qep+mlwEWlPxuFdlpb4imk8VFw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by CY4PR12MB1879.namprd12.prod.outlook.com (2603:10b6:903:125::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.20; Wed, 27 Jul
 2022 14:48:43 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad%9]) with mapi id 15.20.5458.025; Wed, 27 Jul 2022
 14:48:43 +0000
Date:   Wed, 27 Jul 2022 17:48:36 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, petrm@nvidia.com,
        amcohen@nvidia.com, danieller@nvidia.com, mlxsw@nvidia.com
Subject: Re: [PATCH net-next 0/9] mlxsw: Add PTP support for Spectrum-2 and
 newer ASICs
Message-ID: <YuFQRKIy9AxLcSz8@shredder>
References: <20220727062328.3134613-1-idosch@nvidia.com>
 <YuFGN/WBzVgae/cf@hoboy.vegasvil.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YuFGN/WBzVgae/cf@hoboy.vegasvil.org>
X-ClientProxiedBy: VI1PR08CA0264.eurprd08.prod.outlook.com
 (2603:10a6:803:dc::37) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e9559c0b-e4c7-4221-3f11-08da6fdf19e0
X-MS-TrafficTypeDiagnostic: CY4PR12MB1879:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: epxWb9ChgRfLiKEuooQ3tx5YOR7Wxb6jAykmZRFGxwnwjMXz3bPXyCJ4W4BMeEuTPUujaoHfHUinaXsAMHlGVeVJLAV5hPPvlrPG7LKAP8S2xkFEvL3nE14tdOoOGkSiOGj3h/rzZk+VnsFKT6/A0CVhlT6JDUIrCxN8xFLQSMIX1SeZWsrE1no6MVcQFPqZsPVbtHiVP62Rky7mSR4dox+XQYLz4emtlOB/MQr4Y5fGPoRJztSher3gaEDXxS1NYGbTOSTInFkIDfTmmc56jldJ0FEzcgPKhWLTenJ9017/BbOIhouatKiyd+AVRKxtfSpXHfsYVwFurNES5T84gF75LFCvhC2EZpqSIS+XZJE2jJqKhssYB9DzyRyPlVz8a9+2urMAftukzIDRm5nYpjd92LhKO73GHmVQ+cFXtG36rv8DapQDN17vCOnS6UBpFMisd2T0dvwOCRD/Vk2O31Vvco7aH1OZeQWEhhz5vmCI3rLOE9KSe7oDRfHmyiV676UtXAfQ7q+oY/0gTMx1wnonmrO6FF6yMiYSd5/G65qiqdEgA9bJlh3mwnYmGV66OxCLgUUkLdJ9VaUbdwGf7O2COoV1W0QZUtsli4Sr8mZCbGzUq0tTKWocUIjARVw6vXwYyxy1LjlbHKYT0ZI67tFB91dDbnEro+C1sUvp7FHEfddfgsRKJBWz1m0MZnnqYd9D1ghRONMP+M9/jbDPvgYgtalwOt1CP7n0BAx9+62VLhOOafsRxNmEcWBzSClm
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(396003)(366004)(39860400002)(346002)(376002)(136003)(4744005)(8676002)(6916009)(66476007)(66556008)(6486002)(66946007)(107886003)(478600001)(6666004)(4326008)(26005)(9686003)(2906002)(6512007)(316002)(33716001)(8936002)(6506007)(83380400001)(5660300002)(186003)(86362001)(38100700002)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GomZV/afG7cBZzl5ydRYHIdzCaCimoG/20zAJF7BQvFBTSaMPrwAL9svNapk?=
 =?us-ascii?Q?vBKoPn+3O8shLedeQGA+p5YdAIpNa756PAa+3a/wqBdkwO2tO233MoEw6xAX?=
 =?us-ascii?Q?CA++m4BOqo9AZLBTKBb2HOnEMuTIoJP/SC5jy89ElDYwCL9QQb0K5in1lqva?=
 =?us-ascii?Q?tsYHLumqpbykwrOkRdDfwRIPR7BWHjv9OVUrDLXX3WQpRpHa99WrM6ZJmKA3?=
 =?us-ascii?Q?6KbjpJnM4XRmiIylCwm4A2rbWAv5/FKZk/uKpZS1lpDyI5vMOkSt3ThpUgk+?=
 =?us-ascii?Q?hexLUADXqLLLT2LNwaIp9yzLTvrku0BmTEUOlrjypuvJYTNkV+/XbHnY/QIy?=
 =?us-ascii?Q?GnUUPNC7bpXwqTUeZM7rgtlqs7phmXNJWst0/c5knFh1xanLVtGta7G01x++?=
 =?us-ascii?Q?zUXpqRtNxt9mkw+KUtMnCN5RoIJjGso3MgVFzXzRnTuy/2q5l1wfxKdkeGP9?=
 =?us-ascii?Q?qAG34xZj6RKD6WJJSFDjk0TYBYZWNmsnc5RnMuMYefaPizQliF/a5URsjIpD?=
 =?us-ascii?Q?HpGj68+Tcz0fQbXSvmC5r4QhO70Jiie6c0HzEL0QqEr6hkhAbeb9wcAfUTwY?=
 =?us-ascii?Q?TW7BRH50OqPFcXhFK+8ptxCngFoOkRTR5JQkOQMnohmyzggdvTwZmk+U/m9K?=
 =?us-ascii?Q?yMqCG/Pql89F1U/EaPF0+ZmUfTi0L2N3Nhaqk5ZAtEqIR6akPaHTQ/Yf1Mac?=
 =?us-ascii?Q?ldY+GViM2wU4rIaTu+5FO8HvMSrlrJf+3FvrxGbgw62/y9SW4UMXa2gqTWuz?=
 =?us-ascii?Q?WlRFbnXV04OxYvwnJ0N8fWbgQfvTO99IeA179wNu4xQax2HEA1f7SVV+C+x8?=
 =?us-ascii?Q?92v9oGByiJVBGzQHLJ3ZUELj18ZzYnQBckivHhJIXtTPI6uZlYEGRAnUdZfj?=
 =?us-ascii?Q?5185PWuP+4nK7YTwQxqEV7RcPD+CqMx5iMauq5RKVwpKxv4SRsgHKvPlaFOy?=
 =?us-ascii?Q?cY0qciK2ExZHzO1yjcFOx7bCyopD+I53PIo1JduKC4mNbYepuyPp0alsMFnm?=
 =?us-ascii?Q?03k26+oJms9vUld/Fiv7ksYJHWCPAsHKSP+LFLIp8ljTjD9Gc29LpefuSey+?=
 =?us-ascii?Q?On9s7c7YelcA1XduMsE/p0fT7GESwsaFpbrjf15ndRkwz3jvfHu6WiHy2pyQ?=
 =?us-ascii?Q?ycZRc1DQ/R26wPrt1glESNKbq88VDjGwLWhDV03HrY1TZG2kPZcoju+JuOck?=
 =?us-ascii?Q?X4vhi2BF6bBxcf8uKGQ/Iwd0SfVb20QrVHm0KT+z/CExk0U7GovYXmVGSbkj?=
 =?us-ascii?Q?s5USrQyNdzqSo6/BPMGrfs+hFuADtX7Vxp51LQj5P9t8jaN0T9goCdGi00el?=
 =?us-ascii?Q?Uzr2SioXyQc3Pt/stkcVr7EHoP9IGFnHJpVR9M5l1EQPjmVyCgcYQeoAU/M4?=
 =?us-ascii?Q?DsHCBE6h+Gc9BgrBvntLhv3bltsLC1YEqn5XktoToH6ojs3yc08sj3u9eoPX?=
 =?us-ascii?Q?24gG9tEg7IRRH85oTRPr9Y7J4s7NINeZZ5huQdbyC8V4CLkeUFnILLbNvsw+?=
 =?us-ascii?Q?UW2eSq5MPGIGUN10yjz5ucomlvCmEwNvLmgfYzBhUGZUDHEWVfaboChQbyib?=
 =?us-ascii?Q?38Pbwt5IAjXOMDQAPwjbOaw7tMflZrOeGYeAKQQU?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9559c0b-e4c7-4221-3f11-08da6fdf19e0
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2022 14:48:42.9956
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sutWye0tcYa2s+14Ph2wYkRXLIxtBDvM+H9R5v30zDL6DKMWhGSK8QHGcTXv/vvqelzPEZQD62KkNeYIlY4tfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1879
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 27, 2022 at 07:05:43AM -0700, Richard Cochran wrote:
> On Wed, Jul 27, 2022 at 09:23:19AM +0300, Ido Schimmel wrote:
> 
> > Spectrum-2 and newer ASICs essentially implement a transparent clock
> > between all the switch ports, including the CPU port. The hardware will
> > generate the UTC time stamp for transmitted / received packets at the
> 
> The PTP time scale is TAI, not UTC.
> 
> > CPU port, but will compensate for forwarding delays in the ASIC by
> > adjusting the correction field in the PTP header (for PTP events) at the
> > ingress and egress ports.
> 
> If the switch adjusts this automatcally, then the time scale in use is
> not relevant.

It is adjusted automatically by hardware. Software only needs to enable
it.
