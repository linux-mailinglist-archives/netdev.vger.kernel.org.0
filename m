Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CF1F461718
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 14:55:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235890AbhK2N6n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 08:58:43 -0500
Received: from dispatch1-eu1.ppe-hosted.com ([185.183.29.34]:53094 "EHLO
        dispatch1-eu1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238735AbhK2N4g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 08:56:36 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04lp2053.outbound.protection.outlook.com [104.47.14.53])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-eu1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id A43C44C006C;
        Mon, 29 Nov 2021 13:53:16 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NCBA1VGACs4K/nlpqZXCuQd6ewUO34vqZ4gEd/Y8yzoh5GnkuMoJnMy2yFIckNDfuGugliHboY7McfMCdIjIiM7JyTAAXilB1TNJY04qZrH9a/PTfJlgpfRtb7DorNlpB4TFFzxKkDah2d45ddgsdAVaFGZGXxUPWrLrmD1w48DU9hv9sxL4cqp+SKvwCETJZemp7JQuDH3YjbsvdI++lDMfqyjlosSCE/9w2UM6zDWQPzNNcPwmNYhy9yEsKqAA3cGlciNQo3vS8LhsVpC0FS8V8EAARO0y/NFeAxlmL1A4G5A5W5IBW222tpUoO3b76eHIlZAdYwg9Pe5ZCfypFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cj5JUYEoNVnUqHyVY8E58vizfZ5oNf4MJjUHzt4dhHI=;
 b=YM7IV/+1cSdhg4fdyN5GYA3uNWyjCs/a4b9K5oTgLIWBlumFbXRLh0chZqIJi8QNlPdW6U14wHcHjgSf2VbVP0Q+G0YTE5v6Sthl6F+n/xfOoGrZlQnBU4xHStGunqJ+ffZoY18Zb0j7FRiP2hlgdinyEfR1lLcW2J9tXLqsgz4pUyxreT3DvqVlG9rXZjPdD60W2qEyQTfdX7anh9I4sKIlPuJ4BexkvKcG0jJKXxpivKWkgE1w3SK7I8G0PP9rgx9JO9KPkYnh84oC6vJ0YTPOL0dR1cfboEa28QXckbr4c60P017EzYVuv/ExgXVJ1/0g5JrzV4IN4G097EY1cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=drivenets.com; dmarc=pass action=none
 header.from=drivenets.com; dkim=pass header.d=drivenets.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=drivenets.onmicrosoft.com; s=selector2-drivenets-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cj5JUYEoNVnUqHyVY8E58vizfZ5oNf4MJjUHzt4dhHI=;
 b=esiNnlczmxl6cRb4JcK/9IyC9fa1qtgOgBtTQx8B3o3I5cKmz6ZQTllbOAEgDjuilLpbAhTcFyqUDr6Zrr9OgBe4sNSpvFvsDaGZRxj6fASaDBLD6D98FVNoEYQCe14r7Bm6rr/qA9mbAxeeQsnR57vTIwrlCO6eLktIEdM4ODU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=drivenets.com;
Received: from VI1PR08MB3518.eurprd08.prod.outlook.com (2603:10a6:803:7a::23)
 by VI1PR08MB3518.eurprd08.prod.outlook.com (2603:10a6:803:7a::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Mon, 29 Nov
 2021 13:53:14 +0000
Received: from VI1PR08MB3518.eurprd08.prod.outlook.com
 ([fe80::28b3:9174:b581:3037]) by VI1PR08MB3518.eurprd08.prod.outlook.com
 ([fe80::28b3:9174:b581:3037%5]) with mapi id 15.20.4734.024; Mon, 29 Nov 2021
 13:53:14 +0000
Date:   Mon, 29 Nov 2021 15:53:08 +0200
From:   Lahav Schlesinger <lschlesinger@drivenets.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     Leon Romanovsky <leon@kernel.org>, netdev@vger.kernel.org,
        kuba@kernel.org
Subject: Re: [PATCH net-next v3] rtnetlink: Support fine-grained netdevice
 bulk deletion
Message-ID: <20211129135307.mxtfw6j7v4hdex4f@kgollan-pc>
References: <20211125165146.21298-1-lschlesinger@drivenets.com>
 <YaMwrajs8D5OJ3yS@unreal>
 <20211128111313.hjywmtmnipg4ul4f@kgollan-pc>
 <YaNrd6+9V18ku+Vk@unreal>
 <09296394-a69a-ee66-0897-c9018185cfde@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <09296394-a69a-ee66-0897-c9018185cfde@gmail.com>
User-Agent: NeoMutt/20171215
X-ClientProxiedBy: AS9PR06CA0280.eurprd06.prod.outlook.com
 (2603:10a6:20b:45a::17) To VI1PR08MB3518.eurprd08.prod.outlook.com
 (2603:10a6:803:7a::23)
MIME-Version: 1.0
Received: from kgollan-pc (199.203.244.232) by AS9PR06CA0280.eurprd06.prod.outlook.com (2603:10a6:20b:45a::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.20 via Frontend Transport; Mon, 29 Nov 2021 13:53:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 89c766c8-ded9-4569-9daa-08d9b33f96ac
X-MS-TrafficTypeDiagnostic: VI1PR08MB3518:
X-Microsoft-Antispam-PRVS: <VI1PR08MB3518AF679DC0EE57B9D3AF11CC669@VI1PR08MB3518.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6FaRe41PeQBtKyafLJF46EldgT2oSrKMNVki1jr2RmdJaPCz2T+Wd4vc4hyERKwVOlmrNY3qc4FolwVtuLId6vq2ufshGJWFTPIxYw7aVSipZfscY6x19i0QzqVxmMTXupVHklutFDwIfiKgLBXs8Z0uMZNuYw/LQzTVO1dKa0PLRLg1V1JlwEqddrYKlGukgXbpzk1qeh8QwwBfQ2sFn6zXNcBZ3Z83lDI8Fl/VgYKPCFiu37mE+YbnqN+HB/g3aqSD5ZvhPPmYLcKNVAh+OzOsg/rORTA25A/2J4S6IBTzRIfqftRyIp90D8+FNMN1gB796Avhi5JAx79FxMoIUh3GU+VG7Lb910gJcuwhE8ZW9k7PPON03Mip5o5VqB0n0Rnsto7CZw2P7aQD6LvdVu6QnYkfTS0mutm/jHAIFcKAxxg/yFvwchJ7CzGaDjrLEMXD24w3iGZFHlfPkztVWTRGwSwM0Yt0WsQAJ6Gdfher0SdcGIwlC45xTuV9qpytp0HV3mf8rpR/EenHU00uXtDKAACh00j9dLPpO0CLVI/V11VM+F0BZJdIwK64h64eI/WVfHYZqeFvB4G/78Rd64f/WIhgu/u6Axm6ZtAjNO8GhI3Cw0BIDaqdjNi/erDHlJD95sL6fC0qSw1WosluLAR9M52jNDNoVqnQIkRobbI3Mm7Jba0y3HG/wziBAvBH1T+Ln2chvvOSIJQO81a+1VpgNYYrzXiKnv9kiCA6O1U=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3518.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6666004)(1076003)(52116002)(6496006)(2906002)(38350700002)(9686003)(6916009)(5660300002)(33716001)(55016003)(26005)(956004)(4326008)(8936002)(8676002)(66946007)(66476007)(66556008)(316002)(508600001)(38100700002)(186003)(53546011)(83380400001)(86362001)(16060500005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OjqmYfs7xGzJNTM69n+lYQ37QjLEZhsvJFrS+rB+VwniOt9R+1yQuiWzICiP?=
 =?us-ascii?Q?hFqmtULlkwiYcBiH/Rr7b7iAMXvoM8F/WaZPJDvA0giIGk1cHDD1tL5yz5j7?=
 =?us-ascii?Q?zt7Ld3huSq9wzSDx6VqFWa5o7s5PUPBr7N6/EYRSsXYkLdp3nZkDBHOVWIPY?=
 =?us-ascii?Q?t9s74PJp12DhTCuu8PkFwh2/EEm0PeTiaWR2W2XMY1fLWC0tsDtIKK7IYUbp?=
 =?us-ascii?Q?D2XP6+xOsx9nVxCBU6UDQVqK77wXZxA3lpdGzaXh49f+Yq8nrde1cTqX1TwK?=
 =?us-ascii?Q?0Gazg7RC4gp8xSKP/Nu/YPZJfo0KVkMBPv7Pj8saEywRJfbq7JoPMaXdwarr?=
 =?us-ascii?Q?68im36pFcnAjRyEJMkK7c6TbnfjEgGww297HxiKoxaa2j4itE23t+R92DT9M?=
 =?us-ascii?Q?Yj/A3ICYqr1QhNrOf7JhZBzJ3CbSWnc6xEK5BIkJRvV4XN0LQFmZ2ZGSHotH?=
 =?us-ascii?Q?++YBW3JimlK1BXvMsqI9Md2LCEH9M5AI3RthL58nodfcYFIIYJbPfb/Fny9b?=
 =?us-ascii?Q?ogwART53oZn+yJZAiFYFfAbOA0h4U2qEsEPLfvVYmQN8rpfLUW3/jW6OezsY?=
 =?us-ascii?Q?NE7yU6D/7pZeat5Rg/IpUVqYpFb/1o1VF/xUorB+DFjbV9a2LaBlQbONGy5Y?=
 =?us-ascii?Q?iIp766/bPETIFefEms3++4rIBWZPJamKF9OnVfsQWh0QVdFUOnQUKWO7fVF8?=
 =?us-ascii?Q?R2WcRA7aDf4MabmS6f3pled4qSSs6zfmU5CT5fIWQ8gPLRn2YBP+dgX8v+dm?=
 =?us-ascii?Q?eXYoKJd+/KpPm7wl+vEBcmMNUH8B7IrpwG+2CYOTtMFvS3CWJGM65LinAmK6?=
 =?us-ascii?Q?Ocd2nhTo4ryUnbyRhfnBHPr5IATq9yD4BXoLb2KeiIurxjrDFXYEAPX2/1El?=
 =?us-ascii?Q?hMcfX1FNMNM2FiZjSmE6M4/RWOc70f+0sSTAmF4LpxdVOxr1hKuOMuXtJz35?=
 =?us-ascii?Q?8gDrNpEkiV2ewYQzXXOsG+WACPAZGhmkDqh9Jfu4dbknveiU2fsVBlwuEpve?=
 =?us-ascii?Q?FceebsL2cL4bhxiUmczhETLaICkRmaqQYa2UxnXgtd5bd8g+4u8IEQPmsr8O?=
 =?us-ascii?Q?vEjNaf8lp/dJ2k5awUXnzP+b8vYzLYPTPkC+l2TQDALw/zkNjcNQYE5PAgGK?=
 =?us-ascii?Q?06MEdYVYCUfw5vZFH95KtYT1EIjx5QaPYyZh+rACR+WKgXM69h8i8V0kiriX?=
 =?us-ascii?Q?D5OlGpfv/2l5p1hRb5TualsTggvZJYun1peqHfaYY5WgfQ2k3YKZP6wvxxQY?=
 =?us-ascii?Q?1+rvXZdp4YjZ0GG3QEdinH5yb1uCl8BHTmIVNntNZnp7iGqrdp/i4dG/1YfP?=
 =?us-ascii?Q?Zcn8k54r3x5QoceT7tz66S+eHyJ2osGQgGgdqeNpcV6HKHOVV+DrOz0esTfI?=
 =?us-ascii?Q?Vxge5mdQ4S7QagFPDqFpU/wtW+DUmhoDj5e5yYn6oXpVmaxAtDGqY1t03pb6?=
 =?us-ascii?Q?YdV0v3SA5RgNsep7Fu41m/WRXFDoGO3aRlOrJVNeJrvQzFcnVO8OVcRMTpBM?=
 =?us-ascii?Q?h/YA3UvGstt9zIR3UTlDA0Afd1qxB7lc1pkglWcoO1Lqqj2AJPNukA6jOvf/?=
 =?us-ascii?Q?uIrR8SFDkJwW4ypu+Wc/3IjYWR1a0AJV3Ukg3shusBfIqwCJiwfD/AXNSpM1?=
 =?us-ascii?Q?sFA5Ag+hIt9ZapecN7NO/wrlsb6FdCXXcd+RfNpqiyV13+Dhvr5TQiNFdp6O?=
 =?us-ascii?Q?7I/n9p1WAKfyBMey28/MhxQ6/xo=3D?=
X-OriginatorOrg: drivenets.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89c766c8-ded9-4569-9daa-08d9b33f96ac
X-MS-Exchange-CrossTenant-AuthSource: VI1PR08MB3518.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2021 13:53:14.3431
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 662f82da-cf45-4bdf-b295-33b083f5d229
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FfLVN9Wd4tIUVnnSBpjMR1LNI8ZmzNiUhGesoON5L8Ev8oZb7ztJCGEJFa1G17WTAZOXhIJy2hWT8aWViZbcF1N/HF0WME2Grg4FMbw1Ru8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB3518
X-MDID: 1638193997-2uNzyxtwHYq9
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 28, 2021 at 12:17:30PM -0700, David Ahern wrote:
> CAUTION: External E-Mail - Use caution with links and attachments
>
>
> On 11/28/21 4:43 AM, Leon Romanovsky wrote:
> >>>> +static int rtnl_list_dellink(struct net *net, int *ifindices, int size)
> >>>> +{
> >>>> +     const int num_devices = size / sizeof(int);
> >>>> +     struct net_device **dev_list;
> >>>> +     LIST_HEAD(list_kill);
> >>>> +     int i, ret;
> >>>> +
> >>>> +     if (size <= 0 || size % sizeof(int))
> >>>> +             return -EINVAL;
> >>>> +
> >>>> +     dev_list = kmalloc_array(num_devices, sizeof(*dev_list), GFP_KERNEL);
> >>>> +     if (!dev_list)
> >>>> +             return -ENOMEM;
> >>>> +
> >>>> +     for (i = 0; i < num_devices; i++) {
> >>>> +             const struct rtnl_link_ops *ops;
> >>>> +             struct net_device *dev;
> >>>> +
> >>>> +             ret = -ENODEV;
> >>>> +             dev = __dev_get_by_index(net, ifindices[i]);
> >>>> +             if (!dev)
> >>>> +                     goto out_free;
> >>>> +
> >>>> +             ret = -EOPNOTSUPP;
> >>>> +             ops = dev->rtnl_link_ops;
> >>>> +             if (!ops || !ops->dellink)
> >>>> +                     goto out_free;
> >>>
> >>> I'm just curious, how does user know that specific device doesn't
> >>> have ->delink implementation? It is important to know because you
> >>> are failing whole batch deletion. At least for single delink, users
> >>> have chance to skip "failed" one and continue.
> >>>
> >>> Thanks
> >>
> >> Hi Leon, I don't see any immediate way users can get this information.
> >> I do think that failing the whole request is better than silently
> >> ignoring such devices.
> >
> > I don't have any preference here, probably "fail all" is the easiest
> > solution here.
>
> Since there is no API to say which devices can not be deleted failing
> the group delete because 1 is say a physical device is going to be
> frustrating for users. I think the better approach is to delete what you
> can and set extack message to 'Some devices can not be deleted.'
>

Hi David, while I also don't have any strong preference here, my
reasoning for failing the whole request if one device can't be deleted
was so it will share the behaviour we currently have with group deletion.
If you're okay with this asymmetry I'll send a V4.
