Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D66874C20CF
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 01:50:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229947AbiBXAuN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 19:50:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229761AbiBXAuK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 19:50:10 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2062c.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5a::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06EA4113AF9;
        Wed, 23 Feb 2022 16:49:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dqHlz6PXR968fbaBoPKD1OgyZymIhNT41t/+EL6jai1weJ9y7V5mEvbzGCuNjrm8IdscJrBEttau/1lyYGcm6zGAg1alLo7PrOLX4ZgQuQ6Fhxt3smsppXYkIx/AVfqkUqrFxlSYJPV7QfbkGPpCmKlPaJoL2xT7GBpiRLBO0LHdn1wh2Lumzn4K3Ohwz93+iGWFXDmJAGNLRvvOFHb31GVbgqEYmFx3rNZblmE+wG5YaeY3cY9vA92UalfWKuvm3/2fI1p55qsInby+dW9G1JO8+zB0jhhV2VZZWbkZl/C8i4iUjFUElTenruEUd1InKZKTXGc/ItCfFB/DGUTfqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OrNMhVlCot70uziRI6pRt7xe4vKuYpkifY1Gf9t3f90=;
 b=ajn5mL/qFpQErEle+6AOw/vmxKlLZiH0WP09mV4FzgypekF5/UBeOMbWRL9lq7keprk5DEVCFC8xZqYfHtqP8EXH5dEQYwZ266gsFxjPyCYPoch5suYDgg+L5CtnSSsqCKg8iRDALeM8/gbxVlQNRzfwKZJpPDrQ2lQHBen6HxN/5wueMiQgN+cqvaoX7ffuikC3w2i7RB3tV9lgpfbF8Qoz6wQpcSCve5G9rV4tcBI+yA0+VimQBskchjv+QYmXzqEHS6uqbjb3KAAQPXjP25IDGFxNxhc1RxPePmYxEan+3GDCIhHvlz/sRLjdSykKECA0nsKfpHy0VWRlbJ/ptA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OrNMhVlCot70uziRI6pRt7xe4vKuYpkifY1Gf9t3f90=;
 b=hBI7YXXXWtbp2PP025zuR5Hd/1sclyYQHp4OL3OhpuyP4KAoGEhRx9+rcc0undLMv5iCeavLCDQ5pxjVJXL8iKv8sXiq93byieFvwx6MfKP3LAaVTcmAWyaN0Mung51r0Hk7qC8c0QNXk5edIYXo0eJWQK8wc5VNoZjUGd/gBk0kGfO5b5ePF/Ik8m4M02cTbpnHE+r/v9JawgbOOwoSHmzX/RhnbX0T+Kb2gAmalwFF3J+WYJDrhAT6ZQHxP80aYuU7HwMF+b01lSr8EIr2lZ95hxBxEe26B8/UVYejqXUc+J2A+K1QX/tanD4DgycsJBTYJ9J0JFQMgRmJrVMQ6Q==
Received: from MWHPR12MB1519.namprd12.prod.outlook.com (2603:10b6:301:d::22)
 by DM5PR1201MB0235.namprd12.prod.outlook.com (2603:10b6:4:4f::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.24; Thu, 24 Feb
 2022 00:47:26 +0000
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by MWHPR12MB1519.namprd12.prod.outlook.com (2603:10b6:301:d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.17; Thu, 24 Feb
 2022 00:47:19 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3%4]) with mapi id 15.20.5017.022; Thu, 24 Feb 2022
 00:47:19 +0000
Date:   Wed, 23 Feb 2022 20:47:18 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, bhelgaas@google.com,
        saeedm@nvidia.com, linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, leonro@nvidia.com,
        kwankhede@nvidia.com, mgurtovoy@nvidia.com, maorg@nvidia.com,
        cohuck@redhat.com, ashok.raj@intel.com, kevin.tian@intel.com,
        shameerali.kolothum.thodi@huawei.com
Subject: Re: [PATCH V8 mlx5-next 10/15] vfio: Extend the device migration
 protocol with RUNNING_P2P
Message-ID: <20220224004718.GE409228@nvidia.com>
References: <20220220095716.153757-1-yishaih@nvidia.com>
 <20220220095716.153757-11-yishaih@nvidia.com>
 <20220223104248.62b7ad12.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220223104248.62b7ad12.alex.williamson@redhat.com>
X-ClientProxiedBy: MN2PR14CA0026.namprd14.prod.outlook.com
 (2603:10b6:208:23e::31) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a6909408-d17c-44b2-26f5-08d9f72f3639
X-MS-TrafficTypeDiagnostic: MWHPR12MB1519:EE_|DM5PR1201MB0235:EE_
X-Microsoft-Antispam-PRVS: <MWHPR12MB151941209C072CF8C5CA7BEDC23D9@MWHPR12MB1519.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hXx5MhQVWAOvM28X1jfJr1vzXHdaaQaXqyl9JmpnzXDff0FQnC/9P3wgbYZutXOX7wOihK5ClFi3y6zNaI0vEl95BofsQDU11TPGOy51RLL8jAyoUiDVD4bc4K5WOaYo9e9+MmKwFqVr6rETI2sMunaKBwlmGytJDORWQUgeJ8jVCXIQ9nUWxnDORzfzVIM4Shh03GQ3uw0bBXR6HOhboz/91qaN6APt/++sUxf+P1MPUNGClhGQMz94xIHW/pbsE4GakjQniflei/YuO9Jg+HjttiuZxj5g7VY7NWXDIE/rHDXjM/CKuAWGaCV3yo44L5w377H/cLdgR/i6wpSYiCmCWamcqWStmjv+WYxKx95U0DvzdUFv+wnX+8ZQoAikj1X74jRy8Bm6VpI72uSvFEEEK89/g2RN4EjpTZJFweaVgYw3QfPUFXnY5tAuGozBDwcQd+1apgk9Q2BwftGI4wOS/Jjd4ytgMqfO0NtPGq352qWYJgSPNtEswpeWQ2a7X2hnPhzWMeNPpexGcmXDQN4GNhNUXwJeDitNWI7E0TfO0L8ssZDIasNP8WbAf/Dbearkska1R1kE2cMqLCV0MbGiJPNDfY7Ww9SfSnxC9c5Cat/aZPsxDiJ/G+Bztyz9Z5ZgN3UIIxxSBhrEKRdXnDpf1yKIojCAxbLTM+kQTUU+KOWjiRVMs3btBH4uUnoOPOUeOFMZjwKEY79HpQlrPQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR12MB1519.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8936002)(38100700002)(86362001)(7416002)(6916009)(6512007)(66556008)(316002)(66946007)(4326008)(66476007)(5660300002)(8676002)(6506007)(6486002)(33656002)(186003)(36756003)(4744005)(2616005)(1076003)(2906002)(508600001)(26005)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4TJaDNvLp0mM96fGRh98uyblpjKR0ND9tERCquNT5TO6DjU3/vB2uRwDZtDb?=
 =?us-ascii?Q?WIPanQWkXliXa13qBFVkoBJdOt/zshqD3f1Z64eIta2VZYA30wzoDiLokBly?=
 =?us-ascii?Q?/2FCajQGtTmZHLI0YYtEXt+m6grfPV4spfb+4bEwf7FFAEb2XqOwFu/wwvpQ?=
 =?us-ascii?Q?jJvhOotD/pYrdoR9qPfTtHvosUDbAilWfKJYXxTP5pl5GSfTWkTxDSs7JCpn?=
 =?us-ascii?Q?qWMgsaTfMwYkDh0DVeZ4Ro2DKZOa4vam1TbHWV7uGtLsKr0xmJVFXaVZo/G8?=
 =?us-ascii?Q?ZgPI56ghwBEtVnHKDxRdtIB62eX0i4yfSIxuFH11G4CG86N2JRNKXxaaqbE4?=
 =?us-ascii?Q?rwrWW3163I2ROUtDsUCon0grLI8xoUnEll+pY+LF79MmIg36DX4FfUO7aIoc?=
 =?us-ascii?Q?ys42PNe8LjP3rF9Tn3gdokaGV+ezQt7nIN/oTtMJLYeZhLHepJ/iMLnMh995?=
 =?us-ascii?Q?Aw/CoK5j2PCQrNxbTtYccWTUNaif0FEMWYERrSn67usXhh63XWyIaUGy/YFd?=
 =?us-ascii?Q?Rm1Cy/JXM0H6Gp8oGJfJ6KUL2SJGAECCYx7vbNeqdu9jT14oPiFDnelQDhT+?=
 =?us-ascii?Q?Kbmh+AuCu4+q3qM+t4+tytaIeBs354h88qhI+cFg2Z5TdQUKxgZGBoRPBV/M?=
 =?us-ascii?Q?LFBJnF0IT9cDEtLAgoQpeoqRSIo9p9fMTLGA9dHJCA/lyMAjg7hgta5kqwXw?=
 =?us-ascii?Q?5xPr1a/Jkm2B4A9GSH0YBlaNYtA6IFkZrbhLF/J3mVQ2Ni08aEW5Purha+Hf?=
 =?us-ascii?Q?obGY7d6CQ+2K9sziySqVG/xiXFjLwCd4duSP43goSGRtKSUj97WxkbTLCgwK?=
 =?us-ascii?Q?ezDshsppJLwmL1E9mDMUvkD4pT9nzgJqQwdFtyTnmmbnia0lPsGR3UbEySED?=
 =?us-ascii?Q?QX9MIREIe+49oaFRs+LYUyc5h1iEoP5dbPi48aV8WWpGBbrCy6aFLIm1F03z?=
 =?us-ascii?Q?kRYP3rTiE8vOFke3pqEV33Nw0o7iPngIF+aR0NF0uXcbkHmopItE0WffTKkB?=
 =?us-ascii?Q?n8T8qGdQoGXo+iA7xJbYCHYUTTlH7DZbO0359609Olj20u/B2NIZi3qNvOWw?=
 =?us-ascii?Q?CxwIyKrzfk6zjB1gX/C+zRKUm98cNThzlpO40OYfldWs5s5BYQWkwZUDYGsN?=
 =?us-ascii?Q?/QlbdF5f43uxAOWD2sy4nuyyl0PtjeJyY6A+qTWDBA/DKpiQ/WlR/WiU/omU?=
 =?us-ascii?Q?+J44WWXMgaXbl6d+ExB5mnDUyjZXEz8PeHYxMt6mJhQybW//+5V+6ekv4VBy?=
 =?us-ascii?Q?f28UIeqMaBbq+EYz4yl5p0u5XXBWCLoJ/1f1WRsf8NkqRx8wU+GwGSXpZJvb?=
 =?us-ascii?Q?U8SeoAi4OrJqj7tlcLvG7j7Dyc8WFlEZsFVL32lctf2w06FZc49yS8Ig7nal?=
 =?us-ascii?Q?LE7eKgWORgBeUJblUkQuHVR6UUNQL8rhDJ0gI3w9nJzROUeTOmtG/OM7+Hzn?=
 =?us-ascii?Q?9GR2K8tTIEhD/SwGRp3WvyXF1IJ86VMqRHsnOo6rsWsaFBW56IxDRB/+2fDS?=
 =?us-ascii?Q?wZb7AB87nh25ejOXenalws3W/GghBigzw1aTEmfzZUf/g2GFUYJRfVSWCcZz?=
 =?us-ascii?Q?6aT3U1vj5nyP8XwL9GE=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6909408-d17c-44b2-26f5-08d9f72f3639
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 00:47:19.6280
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uSCHc3DjK51Uft/LtjHKWYM576Zetz5Gf0lVrKTWZc1T1IshHkYnE/eaEE5ijpBR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0235
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 23, 2022 at 10:42:48AM -0700, Alex Williamson wrote:
> On Sun, 20 Feb 2022 11:57:11 +0200
> Yishai Hadas <yishaih@nvidia.com> wrote:
> > diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> > index 3bbadcdbc9c8..3176cb5d4464 100644
> > +++ b/include/linux/vfio.h
> > @@ -33,6 +33,7 @@ struct vfio_device {
> >  	struct vfio_group *group;
> >  	struct vfio_device_set *dev_set;
> >  	struct list_head dev_set_list;
> > +	unsigned int migration_flags;
> 
> Maybe paranoia, but should we sanity test this in __vfio_register_dev()
> to reinforce to driver authors that not all bit combinations are valid?
> Thanks,

I don't like sanity testing things that are easy to audit for..

Jason
