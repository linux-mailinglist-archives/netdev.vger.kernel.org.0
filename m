Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6203845DEAE
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 17:40:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237354AbhKYQnN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 11:43:13 -0500
Received: from dispatch1-eu1.ppe-hosted.com ([185.183.29.33]:37312 "EHLO
        dispatch1-eu1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237317AbhKYQlL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Nov 2021 11:41:11 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04lp2051.outbound.protection.outlook.com [104.47.14.51])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-eu1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 98C9F4C0069;
        Thu, 25 Nov 2021 16:37:56 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A1qYHteBBuA2KB4OwDjdT7A9D8gaAwQlDaOs9WHiUGT3Lya9L1eBwHflKKWXK/SMaIK5s8m516dzcRPBm7gug1MDi56SMu5W8MP5PRnTyRS/OQEVtotx9yKVxWq6bzUKQ1kClvC+fevv6XT+EV5QA8bqTeYJxWQj0158IpD7InW2N3ErymDAmAImmFg9HYVoSq1gdjlvRcNgfbhPA9vNMMAXeZr2hHm9f3PTjy5DSOjT68Q5uc0NWshuWBreGtq2rsPh5+CKLqf8jxpfQ7ix5/gIHck6AOkhBmnYzouPFJK2r2AZQvoiXljKxOAi158VvIhLlJfgVTwzornvbRInrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CNFbw6czACdhuuv91oULql/Kt18elBL8zI3IoMJhqgA=;
 b=PRaAjw4VpDOofyhlklbBB+kj2pVK7pTBo1uABuHXlW2IDw4GJxX1U7rGjcWGKVU27C/kL4feA3iOo5yCDPs7t6sa1ex3BP76sBVmL9ci7w7wY4NYSiYMgVm+vtmIRTRD0frOJON5HKmWaozOW0pIo1qBycz5iNhD0PnixU4zwGOVwioAYvY0vJBqPmrKiD/qbeunrC9uaTmwGHbneM/SDa7n0FX9kDr1L8b+1UxjL7a/o9dWdExaZ0grnrG23CbV0uI69KAxbbWC7TkrFIi5Viv3M3Df0ctuOJJuksu+bly1IQVRuzTvrMFqv76jBJCFvJEpyqvBgBJcN5L4s66Rqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=drivenets.com; dmarc=pass action=none
 header.from=drivenets.com; dkim=pass header.d=drivenets.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=drivenets.onmicrosoft.com; s=selector2-drivenets-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CNFbw6czACdhuuv91oULql/Kt18elBL8zI3IoMJhqgA=;
 b=vEXI/nVN80eng780VHvzp+11JonmhjE9FycZfNIGz8AvWM5nbyX0HoPaug7m+2lwTlg4n4YqGgqxLWoBJyIvDOt2WLCDmw9hqQHGm7rp+iAnU28OBakCpks5pL2EmKB3018eoix7TKAPYCXjO1WWEJaLXezRHBKNkspQ5oJD3Zo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=drivenets.com;
Received: from VI1PR08MB3518.eurprd08.prod.outlook.com (2603:10a6:803:7a::23)
 by VI1PR08MB5503.eurprd08.prod.outlook.com (2603:10a6:803:137::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.22; Thu, 25 Nov
 2021 16:37:54 +0000
Received: from VI1PR08MB3518.eurprd08.prod.outlook.com
 ([fe80::7484:9ec:6c6e:752d]) by VI1PR08MB3518.eurprd08.prod.outlook.com
 ([fe80::7484:9ec:6c6e:752d%6]) with mapi id 15.20.4713.027; Thu, 25 Nov 2021
 16:37:54 +0000
Date:   Thu, 25 Nov 2021 18:37:48 +0200
From:   Lahav Schlesinger <lschlesinger@drivenets.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com
Subject: Re: [PATCH net-next v2] rtnetlink: Support fine-grained netdevice
 bulk deletion
Message-ID: <20211125163747.im7tnfziatyllixb@kgollan-pc>
References: <20211125124713.9410-1-lschlesinger@drivenets.com>
 <20211125080638.33f02773@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211125080638.33f02773@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: NeoMutt/20171215
X-ClientProxiedBy: LO2P265CA0490.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:13a::15) To VI1PR08MB3518.eurprd08.prod.outlook.com
 (2603:10a6:803:7a::23)
MIME-Version: 1.0
Received: from kgollan-pc (199.203.244.232) by LO2P265CA0490.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:13a::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.20 via Frontend Transport; Thu, 25 Nov 2021 16:37:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 97f701cd-93da-4282-04ee-08d9b031eddd
X-MS-TrafficTypeDiagnostic: VI1PR08MB5503:
X-Microsoft-Antispam-PRVS: <VI1PR08MB55035F9DB8B7B512934DAAA0CC629@VI1PR08MB5503.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1923;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Cb5XRS9q1ZFZPbkQkJoQKSNWoDQZSQuLIm/9rUIzQDXa2fWZxWruMoa7rBatcfWSXetv54f8BZDgkBwLuaHRWN8VADSwYRU6g7hHTt2CRqA/76n5z5bfxqIdAW06r/kowL0YPVAyfRBj46gTTKK8Gy/9Yh0oDwnxpYjseDX6ss+QXfzNeKzGj494F9vBkh3Qmo9Y3thcXD8y65RE1RpC/+DV/pP0202IGbHCEka8zi+v/fbbkTQlRTRWKLaw4PJ3IRuL+AIp4TJZtU1DtpNkFCxsmwgXroDQwECAmpegpBlxdQSUZLnWXP4MfwxLqCjpkr3UHL4WOuXKfUhAr9W8TSaNq7JZUrGjpIdPg7ZMwIz6c19KVjtEho+pfQLlfO2DgwnBASqHlJb5N4e61EnEzAE60kB9pGy/8QG6ViiTRpP1wyS5dL2Dm1I1eyOryyULAX7e6ZWVCpeGdwP5hZ/3QCHmH2otNgFPU8fra9eXpMsgQWZ36KmJIZc9hvGEqq5UUA8g8d/cyvOUcNu88LcoEwaY+SVlRKUm/6YGF7RzOYkwMEPE145FUuzGhEA72pKtr1hUa8p1Ca4DN+4Qwsf2L4SHBdcb2uTYv6RjfSbWJ/oIWwGSdX30Oa/z2Awi9Xydv37+w8rCTeWiG/fE7RehAF6dHUhWCvKxK+SBJ2UVzzQew/tOabUwOJKg21OdRPgpUnpg5K1YOw6uUocFGQqmijScVp7zYitfgvgykrKcv2E=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3518.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8676002)(956004)(52116002)(66946007)(6916009)(66556008)(55016003)(33716001)(2906002)(9686003)(508600001)(8936002)(6666004)(6496006)(5660300002)(316002)(4326008)(38100700002)(186003)(1076003)(26005)(86362001)(38350700002)(66476007)(16060500005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?S4xEpCe/bGboZMpYdMvoxWloGntoMNOEg2Ax2V6OivXSzRDnjDQlnCMhTzGc?=
 =?us-ascii?Q?7kA9u10PsxZ1ohXnfQnFK+g72rQrQ7sWVGoz4ske2TcDOmhvL9GCtHsCL+C7?=
 =?us-ascii?Q?vdB16uT/DzcZ+046gTR3Q5xSHWo1NzTsvOYM/jhEcvW/m8rGRSTlm416S881?=
 =?us-ascii?Q?qckna9B8tlLlvxZuJ7YzxoQVpKx6c9i+dGRWXWhagdJfglwmuGWd3j3A6HvT?=
 =?us-ascii?Q?DHta8b6E+Hc1agTfiiH/+6Q3+ctUGjYRvG4EpxWipUCYAKSkgrUbj3ufNXoh?=
 =?us-ascii?Q?aeFkYBOBE9tBvmAnXx5tvrSzmeVcs3YShvaWrJ+k9oa4dNkAtlYYZmcMI1bQ?=
 =?us-ascii?Q?g3U5uupgPe9wBCj/IDymE6oXBlNonahV89AX/dz4+y3cBvpEFmSBBN217DuD?=
 =?us-ascii?Q?zJsMKQEr5+VnEo61rBBYuJ/xV2JYolPWCvkEbrIxsnlmE6cnXqjoK02OU6zl?=
 =?us-ascii?Q?vyyudo5g4BwXbD54OBrAjTMI8BXOCMJsXE+frT1tDrcoi4kROIXgUv8e707L?=
 =?us-ascii?Q?CEoqKY5OKXEISuHSJ3DI8qP/rCxDYcyouWilahDu9QX36cw2GKhiEwL8jFjc?=
 =?us-ascii?Q?lCeIwuHrXZOid8aZobeKNjJirBJxH4b+o1mp7c/IRKWiGQKueo1GgnJwEzui?=
 =?us-ascii?Q?mk2bHoEY/GqA+pvIraIn7NykhJwJ4lvGQqywN0YhEySxCJeSbGmnCNPE25zg?=
 =?us-ascii?Q?WXNYcMDRwluVQssinKULwg5RrdWrLdgIWZVG2X7TuVy+ZS8pfHh2BFHg7zSy?=
 =?us-ascii?Q?l/uNY5aGcHJ9fYOT+exMLDetzL42fFiXGOHcQPQ88gCXzz2mrOfYdT2NQw8C?=
 =?us-ascii?Q?cRn2oQwrJfGPMx6xLWyPF8gy1bgbVQFjCBRmFdW2Ntp8fIEieYVDDhKe04g9?=
 =?us-ascii?Q?Xk7A90LwuASChZtEeHv2wIn2E0zT4vtcSHkNQUQIdU7q+ISwcYnVnvPj+Ab1?=
 =?us-ascii?Q?er1wgREyHicp4y8RtVxoQ4Z5BhOTLO8+UhqPvMv2rmuvLx9BZNbtPz1QVdgw?=
 =?us-ascii?Q?hWHKcvv02hKXZcDCyYCCzR4tilAG4AqUw9cwojp0MouE+21B5kq1eLRu1Z7R?=
 =?us-ascii?Q?Bquo+7iDaVczJRzLIGFlLWVPs3H1wpO5SXm3twQxuHolveuPlZPdbeKdhvIC?=
 =?us-ascii?Q?TN3dGRu7bt6DvpmV1XVn5NohC9NvYjXS+YYK01mIgI30xSe2qnYTh05ZNuCV?=
 =?us-ascii?Q?CV1NiA3Bx5eeV/sJMtcoAwQaKkmTpBglRwc86sPaWd/afexXQKG9sB6+z8Pv?=
 =?us-ascii?Q?1FT4yF76wdSYbrrG2PFZ3wA7+XqJTVS+cqxGXRH/bldX9d4MLmDZTXzfykHJ?=
 =?us-ascii?Q?XTOa5v1pyGeT7yIUPnNeCe+1wtuSfVG9uHeCWAufeOb9VYv/YnrvzwKOih0Y?=
 =?us-ascii?Q?cxxDdn/cDSpJ9fhFjClSVSHTTa4OsdeBFbP5CcyEKxnXTrgt0TBOBhIQxryl?=
 =?us-ascii?Q?1SjJflC3r12rztwNjQ2pUQ93BnsC45cu5tw6aSdl7BBd+VYgYoCG7VkVtyFz?=
 =?us-ascii?Q?7X0gJ7qzHcQpo7TCP/ZE5Rc5DR2ETAjOom5RiS64AYfHO4pBWi8ZCQq3UbDg?=
 =?us-ascii?Q?y07FSmbg3FLQ7KTz2U9CN0tlG+NeSP5UEVFL+5N2t7cLj+SlIJIUXhNuvIko?=
 =?us-ascii?Q?KkNH87D1n6DeddtT6cIPrwRws1Dm3q2kt24T5clLS1VkxI97OPY6/oSoY8my?=
 =?us-ascii?Q?+omUigSawUU3L7RTc7ht3lG1Qbg=3D?=
X-OriginatorOrg: drivenets.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 97f701cd-93da-4282-04ee-08d9b031eddd
X-MS-Exchange-CrossTenant-AuthSource: VI1PR08MB3518.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2021 16:37:54.1196
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 662f82da-cf45-4bdf-b295-33b083f5d229
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bBfE6jPZT8cEVeOAm70Pf+GkRPyJo5y2QpxbqC9qaq6wDwl4QjO/jrtNkekGGqWvB0o1HYCBSoCnfCAwjJfJWTuISuQbKa6J0z9c2plQXvk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB5503
X-MDID: 1637858277-NaZoHWEEAngO
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 25, 2021 at 08:06:38AM -0800, Jakub Kicinski wrote:
> CAUTION: External E-Mail - Use caution with links and attachments
>
>
> On Thu, 25 Nov 2021 14:47:13 +0200 Lahav Schlesinger wrote:
> > +static int rtnl_list_dellink(struct net *net, void *ifindex_list, int size)
>
> s/ifindex_list/ifindices/ ? it's not really a list
>
> Can we make it an int pointer so we don't have to cast it later?
>
> > +{
> > +     const int num_devices = size / sizeof(int);
> > +     struct net_device **dev_list;
> > +     LIST_HEAD(list_kill);
> > +     int i, ret;
> > +
> > +     if (size < 0 || size % sizeof(int))
>
> Does core reject size == 0? It won't be valid either.
>
> > +             return -EINVAL;
> > +
> > +     dev_list = kmalloc_array(num_devices, sizeof(*dev_list), GFP_KERNEL);
> > +     if (!dev_list)
> > +             return -ENOMEM;
> > +
> > +     for (i = 0; i < num_devices; i++) {
> > +             const struct rtnl_link_ops *ops;
> > +             struct net_device *dev;
> > +
> > +             ret = -ENODEV;
> > +             dev = __dev_get_by_index(net, ((int *)ifindex_list)[i]);
> > +             if (!dev)
> > +                     goto out_free;
> > +
> > +             ret = -EOPNOTSUPP;
> > +             ops = dev->rtnl_link_ops;
> > +             if (!ops || !ops->dellink)
> > +                     goto out_free;
> > +
> > +             dev_list[i] = dev;
> > +     }
> > +
> > +     for (i = 0; i < num_devices; i++) {
> > +             const struct rtnl_link_ops *ops;
> > +             struct net_device *dev;
>
> the temp variables are unnecessary here, the whole thing comfortably
> fits on a line:
>
>                 dev->rtnl_link_ops->dellink(dev_list[i], &list_kill);
>
> > +             dev = dev_list[i];
> > +             ops = dev->rtnl_link_ops;
> > +             ops->dellink(dev, &list_kill);
> > +     }
> > +
> > +     unregister_netdevice_many(&list_kill);
> > +
> > +     ret = 0;
> > +
> > +out_free:
> > +     kfree(dev_list);
> > +     return ret;
> > +}

Thanks for the feedback Jakub, I'll send a V3 with your proposed
changes.
