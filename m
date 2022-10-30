Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A8E4612AA1
	for <lists+netdev@lfdr.de>; Sun, 30 Oct 2022 14:00:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229841AbiJ3M74 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Oct 2022 08:59:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiJ3M7y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Oct 2022 08:59:54 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2044.outbound.protection.outlook.com [40.107.93.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8C1DE73
        for <netdev@vger.kernel.org>; Sun, 30 Oct 2022 05:59:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m8YLdi4VPt64AAiPQSoKrJg1+LN7l013OhGThTc9qd7EKmH+EUgHOddIbjGnWumbJ4Otu8AdYeg8AWhOtO4gBhRFVyhMAJm4UNesGNXacZg6mo429ugKgQnlIIXWaCfBhwy2zmDXzVY5YwFGaLOOxwpkVahj9gGpdUt186/Orn+b/8691D/zatprPsxYKj311yRAhXIl2OeWgxGvnnvWUYqfrGhAZrS2GiC2f0xkek5Iv/uVVLcdT7WsuVAFdjZVckvZXqn9gSVjHGeAFrWlVu2UOcis+vd3p8Cwuh4TB3qk6infXt0tGPhEfhidw+fyC6PtyJMY0+rFN4Jk89/rUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7ea2su9kifAvJKGZgu0DuQTwFiXnDPirrJJWIxqaH/U=;
 b=k57jnvkqe3VyFk/NRQ9gFxjXl3bUKjcU6ViYw1safHvr27eQhD+FuPtQovUS9Okn9FrO0Fyvs5AKPOGq8ffo7Fh1BDl0455BAWM2wPTJI4WSmlQ+8z0El4ZMSN+41oarlKkAtUvKzwqgytRBMPJ+Jili731IdC433A0ptmkNnxEc8Z4oNTPyJi86y6/ItpCu6WF1kepYvBF6xBrXZEEW75lIeQ222LhURBKviObDqjLaduZ/Gy35XdXzjseeNQDFuLTDn5UwRuxDBWKOZ4w2FQVT8tqKNWlxPIfnehwBgLLIP/Mzeh5xZbHsrGKj6SL0O+U8T5RxqIAY3SdgAlioIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7ea2su9kifAvJKGZgu0DuQTwFiXnDPirrJJWIxqaH/U=;
 b=DIY77jURE7mWRPNlFIPYHgaR26dZGVeyzHfux+50+9ZvIIQdCRvX8KIPDA/aGe/rBlLVmgf/6STvqyXK2p9S/XmvEui6IzYuT0ZUAVtFHXyE63dg5qlFacjEkx7iwbJJuN7xX91IHMAN4tsGVQ0VxxJlR3sZYwWFiKRKqjWTJc1SZnZi5J0KSqXxkaKyNYaEhkQM+NIYrTBajWPnQs2pA0afkJlqEND3WRcd6XSEXuvfCD6UWzhXEIjLWR2k8NrkTEgFjuehixWHoPF17bA4/eFQPP+iQFCxBhZ0jRW3qjxGsi/wFsb6EJ7Yw5qUQZ1tSGq3ZSMumvMFDd5y1KWWqw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by IA1PR12MB6331.namprd12.prod.outlook.com (2603:10b6:208:3e3::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.18; Sun, 30 Oct
 2022 12:59:51 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::3409:6c36:1a7f:846e]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::3409:6c36:1a7f:846e%4]) with mapi id 15.20.5769.019; Sun, 30 Oct 2022
 12:59:51 +0000
Date:   Sun, 30 Oct 2022 14:59:45 +0200
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@kapio-technology.com
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        jiri@nvidia.com, petrm@nvidia.com, ivecera@redhat.com,
        roopa@nvidia.com, razor@blackwall.org, mlxsw@nvidia.com
Subject: Re: [RFC PATCH net-next 01/16] bridge: Add MAC Authentication Bypass
 (MAB) support
Message-ID: <Y151QSN4sEbARPjN@shredder>
References: <20221025100024.1287157-1-idosch@nvidia.com>
 <20221025100024.1287157-2-idosch@nvidia.com>
 <20221027225832.2yg4ljivjymuj353@skbuf>
 <1a66212fdb43fb8d03fc1e4c7612ad1b@kapio-technology.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1a66212fdb43fb8d03fc1e4c7612ad1b@kapio-technology.com>
X-ClientProxiedBy: LO4P123CA0643.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:296::10) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|IA1PR12MB6331:EE_
X-MS-Office365-Filtering-Correlation-Id: af07c9af-8c69-410e-e8da-08daba76a1fa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YADZKUZ7I491VRU0roqfUlXjco0NO6xMJv+cCxy8RyzlKHc0RgV32Ihg6yJAOfOt/F0J46sdiEDCZRChi8gZoBm75cfFK/aDt8CRG5gNV2qIQNc/XsII9egc6Y91Nt7B6LpO7n2WcLbiXIssKvFAa0eoelllRjat+V/d6X6MMMz3n0e/pMYFeoF4b+wbUxxGRAkBNmir3n9ASi9oxdo5lyazaTbQP56QCFrhVsEj6g4iq9aoIY77yaRamTk0hSi1szjBBOmtPKrefkyEzywlEzF0QrbTkVFntRg+8oC8+DF1pFSqxpMlILcHNdKdd5qyTv9znIwUjLhJ8mxWWv9k/mIUjb7SNj/hrsZp3pdZzV39CY1uo/KtQ5ayvKAzdfJ3NtmZxTFVpLjmBOWSbDHgn7U+FuyO+mN1syoRycZ6vb9reMNKR7GQYmL80MCarqafTDZDlhKIxbBSVJrpHTf6JMkIZX24DzpOyL97lf9alf0KMTQqklbwuYj2TPT0yl0WrqiwxZ7Yj4HzCA5QueLVMocVdFyyupr5ZqCeW9pQiqucOQ10HjXb4+GIgRya3wMqev+ob6wszR/o8GVNMzeJgL1GlQsde78Qj7GOBK5HLZTmUFhv/TEErhSJr8KxF4rRf0oyKkGKS/iWOIj1wjDG2KmMohpXkZKiI+bBBSq0wTyld2dVVu248+F0mADyM9iQpOnWxpMhPWH3MSaOiUkSjw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(136003)(366004)(39860400002)(346002)(396003)(376002)(451199015)(5660300002)(7416002)(186003)(6486002)(478600001)(53546011)(6506007)(316002)(83380400001)(4326008)(8676002)(66476007)(66556008)(66946007)(6916009)(107886003)(6666004)(86362001)(8936002)(4001150100001)(2906002)(41300700001)(26005)(6512007)(9686003)(33716001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rQDAZ5ugsOXi5mBhjwJUA/OhJC+sMR7sNgypr/uy3IlcXv9mBf3tjEu+woZx?=
 =?us-ascii?Q?fvlf0NsTcnzDSksBbhug6pggdCmtSfSQ6ClT4570Bw5f05n6S4S/8qhTN4RX?=
 =?us-ascii?Q?jM2rjyPNu+kKP4xr0Vr8ELjsegIPw3cgg3Y0opJiuu3rkcHPnpJhSRNmax/i?=
 =?us-ascii?Q?KRCY5rw+P93Bh8nN0OcoQGyQcYnWyy7Lj9dBE5kZj/hADAFjHOpN80jzH9AT?=
 =?us-ascii?Q?Gwv/hwauBOTdP8EWF0VNo8ZzGyH7X17sHcOrOqSKWK/tpc/Q/6rF3ra2YGE3?=
 =?us-ascii?Q?erdBzTDDzAQyXhvVSlyzd6EZl4WqLGiXgAMJ7oZLHDGQ7C1H/nBe3pvSDqub?=
 =?us-ascii?Q?lZGrxZt5+GVWAZga1bmnOwrNIyD+zQI8WQe221CgtLRYvEd0RK3k6yBokwkU?=
 =?us-ascii?Q?+XFo+iLfFB9J9UWPwk/oXd0UgVyxCYEtSwXAyqmmSa1PxqcuShtbUurZtkjo?=
 =?us-ascii?Q?gDXILpJn+KZSuYkn2ez9Zu6c5otvNjQfUx6ek9QwqjKWvaK8r7pgxFAxcmel?=
 =?us-ascii?Q?SOvm+7QYz+mXSWrSBv7CBRpjV+85hENl0C7BWyBAdtSWBrL6/SCmkusWvgUB?=
 =?us-ascii?Q?gMxFBGVsGACInfsu91VAfHll5L0dmDrHyPrOAmz1Jfv+C7fZM9K0F2i/9CVv?=
 =?us-ascii?Q?ohHoUQjT7zmh6iCXD3XoMGRHbzRUC1/GpAj/88CAAtANZAo0R/VaUugucjAO?=
 =?us-ascii?Q?Zvx1b+H+Li5rvsY/119nWQG536ZsK0xVTUgQp+F8Em63bV2grrvcouxLT+w/?=
 =?us-ascii?Q?8EEMDzZEZeqo0p0H3QwRhLXXK9JCS14TrNZ4J7K4zd6dUyvL/a/qU4XKHLBs?=
 =?us-ascii?Q?OMBixG9fHkJRKB9qOgbtjokZY1Ut4RS5NEh919yKSX4s5/y1O4ci16HE9zgL?=
 =?us-ascii?Q?eGW1SRDsSleGdTPR1cXAKjs7N/UFuQx7FiZW2bhbUkFo1bnIsTVnvPPjCLVL?=
 =?us-ascii?Q?3M+869IhFC9mvhohGpd8MacAZMfgYH1PlVZjzr5VGpwC/OeDDAHTTZJt4bdQ?=
 =?us-ascii?Q?aobkOsstJK9NyvhU0/RS1A8StbZJaxz+hc5xNktzh5L2JZAHrfERT+AYazVW?=
 =?us-ascii?Q?n6faIx3m1QVzH12VezXs2ec8OhrYy4FZflkXpNaNTe/J5JZA0NfbgCEVh5sT?=
 =?us-ascii?Q?AuuAvZFi+I10wXeQSK4rhMiOIXokfcgNbxDz+CBkQ4/jjVQwwxJAjNM3/jyS?=
 =?us-ascii?Q?5/JGM+6j0t6eAXIWqFmtO0J+j16dOnKSoP0OWkGZEMvFxjdEP9AZ3/eZzkHC?=
 =?us-ascii?Q?4zurMR0G79SJwFkbug6vnF0/55VXoMjTWW1VXpXLV6S/l96VSwlB0iubtC9H?=
 =?us-ascii?Q?KlBf6UCQKxDYh14EoIaRdeM86BaR2GsHQO1hAf5Brh6MtIOnW2ZK4AoYy+iS?=
 =?us-ascii?Q?A6dPDvHt7xpIcBIGo6rGE+7nYJrr/MrqyLE10a2HEVi3R5euAoSNk5o60SFY?=
 =?us-ascii?Q?ZVOyxazhkX7D5E9aToafwinhgtdrW3xH+xAgwcIO8OL3/wXh/yImhn3Mwcxz?=
 =?us-ascii?Q?MMBrT83zKKBvFtN5mF0gx+NeqwVqFHyTvE2SOwY4ONT2hjUvBBmc77xELAf4?=
 =?us-ascii?Q?XPiNNNB6scdwXLIVO2AInxc6iIs0GraDHRPiE3qi?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af07c9af-8c69-410e-e8da-08daba76a1fa
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2022 12:59:51.4079
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MFK5z3cX4adhC7ajKBQh3bCGbToLnSpJVNTBVtYeUKDm1ohq1n/sXB8a5NNQM0604gxJuWGdkQbXMohXgM3I+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6331
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 28, 2022 at 09:45:52AM +0200, netdev@kapio-technology.com wrote:
> On 2022-10-28 00:58, Vladimir Oltean wrote:
> 
> > I was going to ask if we should bother to add code to prohibit packets
> > from being forwarded to an FDB entry that was learned as LOCKED, since
> > that FDB entry is more of a "ghost" and not something fully committed?
> 
> I think that it is a security flaw if there is any forwarding to
> BR_FDB_LOCKED
> entries. I can imagine a host behind a locked port with no credentials,
> that gets a BR_FDB_LOCKED entry and has a friend on another non-locked port
> who can now communicate uni-directional to the host with the BR_FDB_LOCKED
> entry. It should not be too hard to create a scheme using UDP packets or
> other for that.

User space knows that the MAC is not authorized (otherwise it would have
cleared the "locked" flag) and can choose to mitigate this corner case
(or not) by shutting down the port, installing flower filters or doing
something else entirely. I think it is best to defer such policy
decisions to user space instead of overloading the "locked" flag with
more meaning which will likely result in more checks in the fast path
for a corner case of a use case that is quite obscure to begin with.
