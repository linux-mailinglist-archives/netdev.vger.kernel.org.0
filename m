Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A38D5652E9
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 13:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234103AbiGDLAL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 07:00:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233059AbiGDLAH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 07:00:07 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2087.outbound.protection.outlook.com [40.107.93.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6565101C9;
        Mon,  4 Jul 2022 04:00:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nl+4A4aHVO9Yh/n9iIGywYZ141BLFmFV9Xib5ry9MRF7rPR/qK3oWfcwF6ix2eNoSJq+tAKCLBeEfoueB9qbEUvWZI4GkhSg4eHbxRQrIEqaXE39GsKSgimhr44CABdBEJDuMtU+zU9YXC3BbH5BOT+tCGeX7x4JeqdtlD+shQrcNPMgo0UE8OTH288Ijpc/itPZUqiic/aw6+d+2IVDxJm8XhLRyYbW1d2ztUmM2K+3hbuJF+WBJcwUYtHpCKk0dJGg413AoF1QDvsEw/BLoiapveOFkXy7W7VR7jrVRQspnCJuqfaKDF/ayoFolzMF7cL/Rsw1A3253g63/hv41Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HXWeMDzGZMD5k9QEdKbeaMDKulx9A8NNCN+tUfbNMT0=;
 b=OBgUU2P9UF/PWYyB+Y1Y3fxmbLBukxRPZ3a+vYd5oTCwjiwa67JtV54TJFXGGaWWQRBeKss6qprJWP8BpukSiwWLjBZpcNhx61PrBfCScXQoEXUukajabbuvl21b/W6lqSqvJj03cdr8IVBknNadUUDOmbfJNxTvepBxL46oWu8/84pRfUIEkaui5RNYsfMoNnBICwSZRX2TcRyVURdrAG45zlzhnsuKyoosvG78Xw33eTPAIt61boLYnuUK4r6GPQLoO+6gjyZcsOq4TDMNhQjJ6vYbB0zu1+bQ2HS5iw9YyzqfxxxvbycB+iWlBUkCVefdISn6Gd2cR0Prg24W3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HXWeMDzGZMD5k9QEdKbeaMDKulx9A8NNCN+tUfbNMT0=;
 b=UGYmOp/l4iwHK2BXkLpxGI4Px8ehAAK08Z+bWKhmTh09mAFMOeHZSQRnDdZaYaIQAsRqxCmYroxhPFi9RUQw/DKfD+mQmnIW59fvP83+em1p80NlKfubVeDs9aG+pIVyD+PUxqjvK13X8/B+QCgrKTS5cvHdT/Lq1x8vp0sP/8FV9v5IB/vRf0IUM+/jwyOAJmw4x4uF1qctH7PfYpatG6PIesWIw3XRWTGm3joq3VOzx11QnVzSv1sZPgfbfdP3lKlUDYEbye65M5FyLi7GnPSKR2aOE4jRdNslskDrEIeZ1cKpm9qw9wR9syCGz7+HT0RtZjTC50JVBERPHfqMCg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by BL3PR12MB6380.namprd12.prod.outlook.com (2603:10b6:208:3b3::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.21; Mon, 4 Jul
 2022 11:00:03 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34%7]) with mapi id 15.20.5395.021; Mon, 4 Jul 2022
 11:00:02 +0000
Date:   Mon, 4 Jul 2022 13:59:56 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Hans S <schultz.hans@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Hans Schultz <schultz.hans+netdev@gmail.com>,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH net-next v1 1/1] net: bridge: ensure that link-local
 traffic cannot unlock a locked port
Message-ID: <YsLILMpLI3alAj+1@shredder>
References: <20220630111634.610320-1-hans@kapio-technology.com>
 <Yr2LFI1dx6Oc7QBo@shredder>
 <CAKUejP6LTFuw7d_1C18VvxXDuYaboD-PvSkk_ANSFjjfhyDGkg@mail.gmail.com>
 <Yr778K/7L7Wqwws2@shredder>
 <CAKUejP5w0Dn8y9gyDryNYy7LOUytqZsG+qqqC8JhRcvyC13=hQ@mail.gmail.com>
 <Yr8oPba83rpJE3GV@shredder>
 <CAKUejP4_05E0hfFp-ceXLgPuid=MwrAoHyQ-nYE3qx3Tisb4uA@mail.gmail.com>
 <YsE+hreRa0REAG3g@shredder>
 <CAKUejP4H4yKu6LaLUUUWypt7EPuYDK-5UdUDHPF8F2U5hGnzOQ@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKUejP4H4yKu6LaLUUUWypt7EPuYDK-5UdUDHPF8F2U5hGnzOQ@mail.gmail.com>
X-ClientProxiedBy: MR1P264CA0022.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:501:2f::9) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2ee9df5a-4c42-423e-ee29-08da5dac5860
X-MS-TrafficTypeDiagnostic: BL3PR12MB6380:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /vv4aosI52laHDdMMVbR5izayq6BGQZ0odjrckG6aOATzBPHlbie2fY7sa+R3VFmrGpzIelNC1J30fvyXR314lB6Lar+QDVGSvWs0T9bPurZDLU+gX8aoa0jFhjY4pD6YyVDC21GzJWXn/BRqePfaEKUFBA4xryknsYbyYgVz9qSa0Sc4ijDUGbswWlU5F76aTYjsMkRr7NBp//VuKG/o7k4CqtMCLsFn6RmiK/8XBBrR0uMjgtYAOf4+WIOA5O1qFrlKSPLG9qCbzUJ5Pt+IGpLIs7R05KZPvCK+iMfRwg+XiE+1Ugy0+3srcNlAayAsCzmKkgKHN6kLyjiaRlMXhb4rlNmUMCaCauI6n399tXUosvbB9dx3et3n+g/87p/Zq+Z/kjqaxiYfngxXo4tin0cNzk7S7/oKLPI00/71VMeMAjoZi/fNE0FSR7a3j7FyGwlFlq2XKNcpUD3PTNd6vDwpqR0wyyRPDMSKfycphQh4qJqJ3Q+BgcodTSS3BgnHs7NZqYrXbSjlGLO2LfFgPLNL6qz5Gx3DjqfH2EN5W9u/VS0qXtVm060SDSk8jLYu+RUlL1Gr5TIkoUAUuK4RnGAj2UHPWbXvGcvrrI4zjJJSU57TyQpmgksZe1fEwB9zsWeZoRA2TqSGhzCqG90s0KYG6aaI7s8HBOJZ60GYdwIcFe3QCWeYJp26yePwDzi23mxdEWku4NC7lBfNhGJyuvLWO2VzwX6Mv514WnRJjCxVyaTZpclW/clXNOv2dF41rfHh3JCUWeQ3/cG/pTDEUtE1xHqrrmnAlNnxrQ5W3B1oD9O8wPiRgw5EBoichWH
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(136003)(366004)(39860400002)(376002)(346002)(396003)(6486002)(33716001)(5660300002)(478600001)(7416002)(9686003)(6512007)(186003)(8936002)(26005)(6506007)(86362001)(2906002)(83380400001)(6666004)(41300700001)(38100700002)(8676002)(4326008)(316002)(54906003)(66946007)(66556008)(66476007)(6916009)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?z+dFrlbfnTvQOTsVdODlB8qQ+614+MFVshg9wBZ1eY+JhhQ0m49KCg+KuJ+4?=
 =?us-ascii?Q?QSsva7Im0PwwS9ctpiEZQ6r4Gmrsr6f7/Y5GAvb2zsRGefUX/pqgu5dG2V7+?=
 =?us-ascii?Q?nKDHmeZVsJr8cxKWDHS60qxrLLt6YoxfkhZs0MZpbNKEGmWyZfbKSchVRuqO?=
 =?us-ascii?Q?aANEC2+w4zZW2V0CuMD3hNsYzyBhHO/UgEDh37s1kKJTJA9rmns1A0Csmcex?=
 =?us-ascii?Q?2Zp8vaBGOFnKyjFapoy/nuE9aqeLLvEzvbRAiqNpvYDhxIm5pNFGSi9B+u4D?=
 =?us-ascii?Q?GHihnPYgnEKyLjl0U8XRsxGJrE5iMkAyq31gF5vW5xNWw2LkZTvK5FPNDj5l?=
 =?us-ascii?Q?skY/Sjadm3o8nmIuKQF/akgf4SkolMrCwNQcFLmFmAQH7R4GVPmrwy+acbt7?=
 =?us-ascii?Q?r16t6pr24UqvJnZboZYN5CzBgm4oRdWNsCYRwgHgS8Bzz0dn59cnVX2O5gzi?=
 =?us-ascii?Q?ZQQcFcaYo9c570UJKBoAkc8B0JtCtABM9BfcYLcMQiqD6ePi2EMA2H8dh2DF?=
 =?us-ascii?Q?qacURi5j+wUXN9ntQnl9uENiFNoaOZ2JizJbRhSSGuOAcn7RwZNS0oQaYyyU?=
 =?us-ascii?Q?bzaflWLQy27FIWe5UDjJ88e1XB74j9NKb1QdNP/1w7NNqzJzR6W7FGsOVilI?=
 =?us-ascii?Q?DoNjuhxjSCronedh0tTzGFTj67R9CXkOY7IWvNiM1qaSETHgZIhw+VLQvF8B?=
 =?us-ascii?Q?FPi1uU7QmVB+hQsZP+I1/JfYqoUlpfHzO6NPi/PAKRpniEPRYYAhIFicFLyg?=
 =?us-ascii?Q?3TjrNm5Q7dXb8+X1u8s3lt/Iu6VyEIkYxlmRyycDgUNmYYeH6r55uPIBh98D?=
 =?us-ascii?Q?Ca7LBPimPcBupwZfnDmL9DH1mBzDmsVrnUqZCCljAirPMkuSVmlqCCUhy9Z+?=
 =?us-ascii?Q?VkNodj9ddZhu/t5Rdds7X1rW+nLWEpGibUqGXoEQuehyPPXuZVMHbYAharBI?=
 =?us-ascii?Q?LOrTv2RPNWbzRlen/ixKl3yf07RVN/9sUXpR5LZLdB+FRLWGCmvPGzPBDN1F?=
 =?us-ascii?Q?4kzZ7wxcwM5DdrDb+/1bVLJpfX30JD+aihRGKRuOjpM7XgSbtNhu7initoB+?=
 =?us-ascii?Q?RNiljqN4BNF59yJ4FYOM9qoX0Nz05Dg2XpTvrC1WxJYNkFAv/Q6rVbVhsjIh?=
 =?us-ascii?Q?eKhRRtV30GI7Um6QtJLftEl6nfoEFURzH8stlzoq3TZYAil0WhnyMjEBe0+J?=
 =?us-ascii?Q?ZrFZ392Z2BXfzCsSt2dnQT84uo2M14OxH5Rth/fk+SWhKNQe4HXBd0lgbRE1?=
 =?us-ascii?Q?UgNjxzIQV/6FFhmZb/bWhMJwpRH1TfYI/32v/Y8l+OufpTOset05FgtPfzWi?=
 =?us-ascii?Q?20c12gY/rot7GXu6zCD3Z7b2ThvbhO99kxrTvsckhAjCVmjzG8t1UGtDiGcT?=
 =?us-ascii?Q?wAJWlgWFV7SPlb8C3R/jZ4VPBfaqCeO5rb+LW0I0BoeY36DgfEl7Tr3B1m5u?=
 =?us-ascii?Q?cz40CXI+fYetlGaLNpXDCZjV5tmQC9VAGGmXRlJMsVxf2+/10TvQm8jrEzDC?=
 =?us-ascii?Q?+Sbbs6wAOt84X3Merk75mZqI5QQqTkTm4OR7JjR5pFXFbMZG2ybaIX9O/DR0?=
 =?us-ascii?Q?/WxscvLbeTPvVjjcGMiFgKQFrAe1ID0M6TGbj3DZ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ee9df5a-4c42-423e-ee29-08da5dac5860
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jul 2022 11:00:02.7351
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gjICZc1gutzCgHLZv3s7WVUXuYTpyHuPrWZuNBouNUXZvBb+0sp7b17cUUHES2BlkVcBm0XlhmIDNu9qKacBMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6380
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 04, 2022 at 09:54:31AM +0200, Hans S wrote:
> >
> > IIUC, with mv88e6xxx, when the port is locked and learning is disabled:
> >
> > 1. You do not get miss violation interrupts. Meaning, you can't report
> > 'locked' entries to the bridge driver.
> >
> > 2. You do not get aged-out interrupts. Meaning, you can't tell the
> > bridge driver to remove aged-out entries.
> >
> > My point is that this should happen regardless if learning is enabled on
> > the bridge driver or not. Just make sure it is always enabled in
> > mv88e6xxx when the port is locked. Learning in the bridge driver itself
> > can be off, thereby eliminating the need to disable learning from
> > link-local packets.
> 
> So you suggest that we enable learning in the driver when locking the
> port and document that learning should be turned off from user space
> before locking the port?

Yes. Ideally, the bridge driver would reject configurations where
learning is enabled and the port is locked, but it might be too late for
that. It would be good to add a note in the man page that learning
should be disabled when the port is locked to avoid "unlocking" the port
by accident.
