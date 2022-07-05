Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18D755668AE
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 12:54:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232858AbiGEKyt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 06:54:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232098AbiGEKyN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 06:54:13 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2066.outbound.protection.outlook.com [40.107.101.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AAC2BF44;
        Tue,  5 Jul 2022 03:53:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OVNpo21wlejsWDNfpDBwV5ZnpKIGCje+bWxRdiVI24L8o5Aj6J8chUcU7Vro+gr0Vnj7FETonxGhWszd9k9CaARU9zANq1KuTw2ymljbWQvMm/FqJeS0pEgugJw5Em7TbvgDnTHQM78GgPv+DMcWagThT/AW8MNpfsU8OK8KgbUFV8gFbZV9fETxuNCP7UQsA+J+OlvfeY7D9ISvB/2JfmZds3hz64rCUowAI9k0TAl31y89zXsmopVStUP7H+OibzmLAO0saEWwtbydLbul82hz2vfPygbnZezvrC8lmU/R4Gx2qQKEh378TkukFi5Neoi3JYAimeuQi5LN0EZodw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lBQBrhz++joxqgzrUQcfMu8iuhZOzwr9XKqzzet0pZY=;
 b=muXWn3C8L3ExWRJ7L5hq+qnBdUQjvXAO/FsNhuM4KUo5w8eY5n+O9+HjS2QRWi34ZUELKb5k8/Q3GKWhovB31uS4kunuVTL0vOf8Fsxe7/Fv8OAbi58/ewaz8VypatJ6tVATLkQ/Nykrgg3wjUrAc4TvevtaGX8g0NPSo1hLxR2ikx10NATk8poc4S4faVBcvq2UM9CFz2R3Lz9834TYPQrMK5RlXfoRvXohIrN3MfLI5dl6/EMuEjVQ/CL9e2I3OM+dVU9mBc+vIXTioFzWiVn9qlfQX0+s6IfvlsKq9jmTK9XUdywtcCFgdaJhz71WTzHt84w1bAJBNSNseiXufQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lBQBrhz++joxqgzrUQcfMu8iuhZOzwr9XKqzzet0pZY=;
 b=VQnO00TdvZH4BWWQP9y0+TGXnGQ32Uske9UYvI4gYIlZns5WVdo6Gra1lt+BfhQjylkaWDd2Gbzq8IV9RZZ2OFOHzB2h1Oz6UQEl4tBeTRN+mlwLqZ2wRTe5vg0rjH/7wDw6U6CDDDogd1GC617e22qgZutiNo5Z/HFwuM7hWDMxPzgKaDMeydMRVMZK80fIR8P8O4i/oRZslYOBJTLcRoP4Yu0hbbf0YZJkGGx9Rw4Fdh20pYSZNbIsErjBZTRScR5JXjLETFuUrl2dfHCvHkBJq4PZ1Qef9J5JDMOIqE/83PpdCSedQWR3ikFb2HCDGi26bXukDgieRkaO7N8L2w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by MN2PR12MB4189.namprd12.prod.outlook.com (2603:10b6:208:1d8::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14; Tue, 5 Jul
 2022 10:53:30 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34%7]) with mapi id 15.20.5395.021; Tue, 5 Jul 2022
 10:53:30 +0000
Date:   Tue, 5 Jul 2022 13:53:24 +0300
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
Message-ID: <YsQYJElDK8DBHYz8@shredder>
References: <Yr2LFI1dx6Oc7QBo@shredder>
 <CAKUejP6LTFuw7d_1C18VvxXDuYaboD-PvSkk_ANSFjjfhyDGkg@mail.gmail.com>
 <Yr778K/7L7Wqwws2@shredder>
 <CAKUejP5w0Dn8y9gyDryNYy7LOUytqZsG+qqqC8JhRcvyC13=hQ@mail.gmail.com>
 <Yr8oPba83rpJE3GV@shredder>
 <CAKUejP4_05E0hfFp-ceXLgPuid=MwrAoHyQ-nYE3qx3Tisb4uA@mail.gmail.com>
 <YsE+hreRa0REAG3g@shredder>
 <CAKUejP4H4yKu6LaLUUUWypt7EPuYDK-5UdUDHPF8F2U5hGnzOQ@mail.gmail.com>
 <YsLILMpLI3alAj+1@shredder>
 <CAKUejP5=eNyAso=MW2nb2o=OKMaysmWUJ-zqLcerPg6EzsQVYQ@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKUejP5=eNyAso=MW2nb2o=OKMaysmWUJ-zqLcerPg6EzsQVYQ@mail.gmail.com>
X-ClientProxiedBy: LO2P265CA0035.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:61::23) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8c8230df-bf3d-4dfe-72e2-08da5e7498c6
X-MS-TrafficTypeDiagnostic: MN2PR12MB4189:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: z/Pln/pCxH3B96pH4hl1YU1AXgj2K+VHdM0VCFjfIMplDReoHuR9UJ++KW6vvR216Gk+rf24o65uVQn9675DYlhNvGq3qfNKuLlh+/2Rp/uvBgUZ7W4sXrXZFlahz09CtDbflPKEt5OAmiAbwu9B0RY287rMpFsefRIdl0Xc+9DXicZLB4wWF0Hobl2d3oq+Ec1sBwues4aVVirw9gOcVUEvhmNQET1B3k6ZbMXiomHKytj47n2tgx17gfGwJdWPoR8dYKIRz28DACKCYMI9rrwaCbrFWMOXRV9COOanc2u3/UyTuOFUY80EmOBnMjyJ6XwcoyYBxef0PbmxMJE2jInk9l7w1lQTQTaunaxDgwr0Zbac4l//dP7JCjmN0aJpS7USq4+ITFxTQb2qK4F1Grogoet7w9elr2Pb8Dejbtj1vVIDcZlQHzSzjrDWFhPU2NDvOWOkPI85mhiiv8ohhaIbNgwkXN3X3Q7IJq1xqZdjvWTyhMubTR/Ee86+fW8AZHd3YXnpTS0FMbrY2LZ5WMcmYhCdOSNcDcJqpsKnqtLV6P2c9USwgeSroOU6MDMKlNpTnoce5H7ulOlkLw96LClLHyhp3EPPbG8wwI5J5ViM1R3YixeytLQv24bNYne0f+1uyMKkBorBOhzqh+flwInTULE2fp4lHOyXdZ52dAQKEkRvA2FXmBQ5c/eHtPhqpnOnBmrSeUGes1KLmXjSjVEtoh8+QKMfcaiyO4ed6CUV/ccypVG9ypMms4zghO1b
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(136003)(366004)(396003)(376002)(346002)(39860400002)(83380400001)(186003)(66946007)(66556008)(66476007)(8676002)(4326008)(478600001)(86362001)(6486002)(7416002)(8936002)(5660300002)(26005)(9686003)(6512007)(38100700002)(6666004)(41300700001)(53546011)(2906002)(6506007)(33716001)(54906003)(6916009)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZryG6fiRt66xlCvk9PO1OlcwSG4P7ZU3hcHmbZlhXoD18ky3fJatdl5jxRTI?=
 =?us-ascii?Q?/1XcBviQ7LhcE4kmrvAeYpn85rZ+dbsDQuytD/Jt1xPFA+WYiZqz4QkpxLz4?=
 =?us-ascii?Q?iEnWGpHTY748GXysDdEJFj0i86UQgrUmsdjvIhj07N48rmWBLepsnEsMW1+Q?=
 =?us-ascii?Q?JBoxlMUiQ6w6huwK0lzw0/O111ocIHzk9Xo2NB1iyJD63BYiLkZFXzCyhgPZ?=
 =?us-ascii?Q?cG8dN/g/pgjf70dyObcpudzsi5KwuOj5fDNUNowSusXBmOVg3nc4en5tbZAi?=
 =?us-ascii?Q?r9+a6MJTti/HQLDuOBVo+DLd+ovF4Y/LX95ZfScHRef3VvFaDWP4h+s5nt2F?=
 =?us-ascii?Q?ITZKOWg73FvOrvpwVaXjLM3o488CUGy3AqYjjIXrU8bqDLUWhKUTC/ausM04?=
 =?us-ascii?Q?/mwkSUPzZpldpj56fO9G3JFBNvlRNSiv+T3pXmZTAEb8p1GA83ZX1KMJ8HQS?=
 =?us-ascii?Q?ayt/YXCn7DygkGHEG3Eb8gBKqHTGU3jl05K+5K2HeyldFf8nXwkmogAbY0jE?=
 =?us-ascii?Q?TlCfRl3kmj+BaLHzPGaGtqR1SrSasCTKEknGNBIoTCgWSIqeroQeK93bQ3ci?=
 =?us-ascii?Q?YJKfVMEchKdsMXEM/zvx5MRjdKxZe3uLRsMRyhoDy8sMjCziBguiI2kCWVxf?=
 =?us-ascii?Q?I8p4QFEv1GWXL4kwlJ3TX07XV9YrLdHv0hfYe5NbVn/Y5kLrOaSkZGbXkcLW?=
 =?us-ascii?Q?PzYF3aLcsDnsQo0rSCOGiujPtNPoQd4tw/09SvfDuT45rWlQvkOBOz/6ZqUp?=
 =?us-ascii?Q?oFn4zb3HArtYxNcah678lHkdwIjVJ6ic8SNYEemjAHqvLFQsIcumrq/oWPgp?=
 =?us-ascii?Q?CgeS1zZi7dIN+2dkxkNNbYO704WWD4om75t0G1IQXkK+6T7rWF6tlpVUl2ya?=
 =?us-ascii?Q?znMOg4wJLhDhO88uovfbjzXY7oF7DkmYCr5D/kbx77I58nueCYLdt0JBEoYU?=
 =?us-ascii?Q?6eaLqE8PnKeiBaneiF/iTUfehnUPdiqkTMpw5W7jrNuqt+QNSepZ3jNes9Ea?=
 =?us-ascii?Q?QQAsX+ZClAJibby2aGq7yaBvbTrogC0K9VeMSajcstMSqjCBPfNVrPw1fYGd?=
 =?us-ascii?Q?MWz1OOmMtB6wF3m6c3vkf3jofT9+asdk/W92yZDAtPFI4qJxsT0gqr/ZJP71?=
 =?us-ascii?Q?rZXSO/WFy+slmlPTaIGZI1YgOFKe32Xamrz/d+oJQL5eqg6JpSR0Zmm9zoZB?=
 =?us-ascii?Q?WCPONQHgxofsLoy5eeojxr4ieB5i4FXDyP7pMqO4YoE2i9iS+VFdpdpqxnF4?=
 =?us-ascii?Q?vT/rqXoi2DIV6fnCkm5IL5LcfTufYXC2qun5omFecV2xo9/CYTw2YskeRT+l?=
 =?us-ascii?Q?yVErXwZ/Kz4xOhfJYZJ2M4TCXIY73MGpBPsSC1kaqbb0rlEdB5X02oyyCb/N?=
 =?us-ascii?Q?Ngc2/iutwfFzjlN96UUHGpfSqXwI6qFzqG5DNxTida9U9A04gBjCa8oq86oL?=
 =?us-ascii?Q?wBJv3g/NqLLTptU+zmJLcc5AA5zbxZW7KXA/hpL+7aOSxZnzucM6aO6niIu4?=
 =?us-ascii?Q?Bqf9eKAdrZMPR/KFHnj+vYgIdzWY23NTSyGDvlZ9w6Ielo4wvb05cE/ER8Ba?=
 =?us-ascii?Q?iJV99FG6eqEpjG0WCfhGhtzbhph9UuxcxqR2Z1W4?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c8230df-bf3d-4dfe-72e2-08da5e7498c6
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jul 2022 10:53:30.2454
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Rgf2Nuf4PqWKNfiD6LAAZsstYbx3XaL0FMqb9XCcVDjs0Rq88Jqs+8h7eZOWvxt3icf+/uFlcY3X9pXwZE9XYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4189
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 04, 2022 at 04:36:12PM +0200, Hans S wrote:
> On Mon, Jul 4, 2022 at 1:00 PM Ido Schimmel <idosch@nvidia.com> wrote:
> >
> > On Mon, Jul 04, 2022 at 09:54:31AM +0200, Hans S wrote:
> > > >
> > > > IIUC, with mv88e6xxx, when the port is locked and learning is disabled:
> > > >
> > > > 1. You do not get miss violation interrupts. Meaning, you can't report
> > > > 'locked' entries to the bridge driver.
> > > >
> > > > 2. You do not get aged-out interrupts. Meaning, you can't tell the
> > > > bridge driver to remove aged-out entries.
> > > >
> > > > My point is that this should happen regardless if learning is enabled on
> > > > the bridge driver or not. Just make sure it is always enabled in
> > > > mv88e6xxx when the port is locked. Learning in the bridge driver itself
> > > > can be off, thereby eliminating the need to disable learning from
> > > > link-local packets.
> > >
> > > So you suggest that we enable learning in the driver when locking the
> > > port and document that learning should be turned off from user space
> > > before locking the port?
> >
> > Yes. Ideally, the bridge driver would reject configurations where
> > learning is enabled and the port is locked, but it might be too late for
> > that. It would be good to add a note in the man page that learning
> > should be disabled when the port is locked to avoid "unlocking" the port
> > by accident.
> 
> Well you cannot unlock the port by either enabling or disabling
> learning after the port is locked, but Mac-Auth and refreshing might
> not work. I clarify just so that no-one gets confused.

I was referring to the fact that if learning is enabled, a host can
populate the FDB with whatever MAC it wants by crafting a link-local
packet with this MAC as SA. Subsequent packets with this MAC as SA will
pass the locking check in the bridge driver.

> I can do so that the driver returns -EINVAL if learning is on when
> locking the port, but that would of course only be for mv88e6xxx...

Working around this issue in the mv88e6xxx driver is the correct thing
to do, IMO. We avoid leaking this implementation detail (i.e., forcing
learning to be enabled) to user space, which in turn helps us avoid
working around issues created by it (this patch, for example).
