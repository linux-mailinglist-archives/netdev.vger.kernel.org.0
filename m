Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EB46563860
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 19:01:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230180AbiGARA6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 13:00:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiGARAy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 13:00:54 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2077.outbound.protection.outlook.com [40.107.220.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AF4711C13;
        Fri,  1 Jul 2022 10:00:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m5PywVwWaHOvDOdByGpds8R1wgrApeyBijjF4+RN3qiJtBcDbjbGLGkV/6leHoojCEOE9793M2SY+E7RcySRs0fEUJXcB8/REug4L9ULShrpMqyfNUZPN8hOb8GxKQ32tQEDHnqMpybkKHosRGi2Ftv+ElrN9Rkfy5uJdj8bhp8VNwQJZAD34wpNtQlhkivH2FxVlp07vp0jpudHGb40X7lnyzAKHwtT52kih4M/d8FY71axX9SDYXhpfyrLkyeAH3rGqcpdODcFHvYrF7k8FMHlESGSehscb3wv2xEh/RGiBhHzz2mirhTeLV1FuvPFLlEWtee3qfTaH5At0Xyqlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PCjr+f7uZ5DC0YbdbPOnjOwPt+ZQMquVRpoMqubuKm4=;
 b=bLj20C8j1NF24Q5ZJpx4zOlTPaaJ5txVLkFcNlAMJ4ChzYacznjS6y5nzdJy7a4ZB6S6Mvbmp+WJAQ1QwcPa7kzCZdCWxUdEbtXgsHXRgsywMx7Ruhjw5B+5aw5Pov22N7UG5xYGB2aeccQReyKg+MfXPuKFJhfP/Hl3vmlJcDPmxaiRIiY5VwQE4t66QroltB+VZ1SyMWgkMI42hIh3ecZwuOadCnO3ofEeXanXFPCa8XB7lyl31OAmYnJm93LIrG5NOwzyyuUTxcq3ijXb1jVvE1PGKUtuT46JADreTmvOOa9KhucW5UO9M9GEJ4yTbkhARHH72hbTqjqV9nxyCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PCjr+f7uZ5DC0YbdbPOnjOwPt+ZQMquVRpoMqubuKm4=;
 b=c+yZzSDubRBaYytIWeW4oJ58SPnAfbo44YoInD0HB91t1XXNSq9GT8hH0zbzhnuEYBI2C3f7Y+wpxTxFDxC5MdJUvekxIt5EbvCXn3+/PxfDlb5+5YuJ1NLerN8iH1f7T7I8BUutwQ8n/ugx+vSl9EcOy1LydocMEiiGJGIlsT7cRJXmyKgNHF8uRjZRgQyzSsrbIqjgFQU0RHwjWhwcJI9ZUK6Ho7bZAr8HA2TgpN6i2wWKOZoEa4AjyLTvr+WJa38qpvRhlcHOhHMrS4lL4X0qfvoVsDR9T3XsEUmMJ8627wKyZ2BwnRXF/SDNnYMOCceQ5nbuFcOGZ/WM2E62gA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by MWHPR1201MB0269.namprd12.prod.outlook.com (2603:10b6:301:5b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14; Fri, 1 Jul
 2022 17:00:51 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34%5]) with mapi id 15.20.5395.014; Fri, 1 Jul 2022
 17:00:51 +0000
Date:   Fri, 1 Jul 2022 20:00:45 +0300
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
Message-ID: <Yr8oPba83rpJE3GV@shredder>
References: <20220630111634.610320-1-hans@kapio-technology.com>
 <Yr2LFI1dx6Oc7QBo@shredder>
 <CAKUejP6LTFuw7d_1C18VvxXDuYaboD-PvSkk_ANSFjjfhyDGkg@mail.gmail.com>
 <Yr778K/7L7Wqwws2@shredder>
 <CAKUejP5w0Dn8y9gyDryNYy7LOUytqZsG+qqqC8JhRcvyC13=hQ@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKUejP5w0Dn8y9gyDryNYy7LOUytqZsG+qqqC8JhRcvyC13=hQ@mail.gmail.com>
X-ClientProxiedBy: VI1PR0701CA0029.eurprd07.prod.outlook.com
 (2603:10a6:800:90::15) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7f10eb30-b7f4-4bb1-5ade-08da5b8340fa
X-MS-TrafficTypeDiagnostic: MWHPR1201MB0269:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ApHyOAD34mGSuogm7Lu2qAijb0jMoDoYBNoe6fD0Hejnif4rhAfceA9Kcn1U1MJRBIzBDBCOcNYq+1tppZiKLIpCF3SPtRpB8qSjwvKeZTweKQcxl6Bzy/VPL9DMs+/mqXgxAQ2xIOmhufop0We+NpDPRj6zPf6bqe1YFcAgCMVQ+sRF8a1NkEbLc+NDnrw16TBCHm3D+6PDPb/uAjTLQJek+rao9UL9DPZjQYuB+wwnvBboSD/Fu9dsF9Hg6q/IuNcS1NkPHXcbEHdvVE8po2jsJoq7j+H9fTeScRAJe1qGA30p9wpRU9a6fOcA7wS8UWiZLOBcQHmgLcgjrv1+xmoQ1MPa/71HirXgjdWf0iDwiNyopwnaMJp20itDesyqYOfyqvb3PrWWLErVHOC5saYH4fA7waxRbaEjUNe8Lj0CjUcmTe7CDneSltf4rmLgmPHFhNWkYGo24uRgZ0Y7x6MnNKPsP1mxd24snjQbeagS0URCLB5CyIWlSzYgPW5g+KFakf9D/w/+GMT6A2ZAT+prpu2S7L3ttozT847+R6jvGmFSl5Hc/Kyp9oPLA1nR3H5wd95hHvn0dIhMqGJDB7mc0vkKYDYVSDdmJkcVPJKmE0xeAzUVkPM9OUJFi+ia3FmWYkKLymGOlc3u606pY5W9FTFeOZ6py2dX6SJ0Lz9FZRG2GxTf//tsccy/QwIlkAw3GrQjYQZUp7PY8AkiL+DConGyc4A8ip9jJ2s1uDkQU4IrcQk9PHnItzvVr07ERMfqKkJXGHjKfaEPMqR6pA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(366004)(376002)(39860400002)(346002)(396003)(136003)(33716001)(186003)(83380400001)(2906002)(41300700001)(5660300002)(38100700002)(66946007)(6916009)(66476007)(66556008)(9686003)(7416002)(26005)(6506007)(8936002)(6512007)(4326008)(316002)(6666004)(86362001)(478600001)(8676002)(6486002)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KEETqChD9kLiaO0Ir4QSHO/aWBf6Qagw8mhbMuJHlSxanbZ2bS1SD+m8Q1Gv?=
 =?us-ascii?Q?AvPYZ1a8pyO0QLwh4EAPilKjL6FIZ83+ncO3nrU8WDsqitylfUO7RtUmURFC?=
 =?us-ascii?Q?MMWy+WLMpd4m0zN+7SAzDsX7pdkSPLvOn0dm+J4CSUxifAG64wrZ2drWqNky?=
 =?us-ascii?Q?1sStBhQDnRi/9QGDvr0w83AceIBk27RpRf4ViK1bvfDn0OLet2IzbKUg6COa?=
 =?us-ascii?Q?d09HiQEIGeIkjcGuvlEIzw8QcgvuiEomIGABfbUoCxfFVyJG9BKBbET/Q6Q2?=
 =?us-ascii?Q?1gitwqtFWVUMcgovpsbbXryokRs5oxd2oTjbaAq8QNBLzIV5jaDYp7bTAxqj?=
 =?us-ascii?Q?3apgxsPwYWXU76AeuXkc6/lYbrhn62GuKgpjhfkYBRlbWGZ0PHmXW0WvXyZ4?=
 =?us-ascii?Q?7hQ9xUKhgEytAmPY4m+K+Z0e3Qy2S+W7UvQ8qwJZspoR60ewO5RKBmlzfJXv?=
 =?us-ascii?Q?6qhp8Udgt0Vh3OFDF8Uk5RDQJVPoR5cowGPOAg/Qb8BdUiiY9mex8K/8MdDn?=
 =?us-ascii?Q?I1i3g9FFwWRHCxEdfmyz16460LdY596scSTPTFtAIqWmrz/tAMCg9dpQLf2D?=
 =?us-ascii?Q?UVJOtnzV5e5ugm+7V03HuEWihi5pRDZoTAmy2f8YcxzUqD7656xZpphADhKO?=
 =?us-ascii?Q?6FMyiesY0T1tsJPzSmkF5ndxaGdc+biRfi21F5F8nRw3N21OS8a2ImltsEuH?=
 =?us-ascii?Q?YxWQ0Bd8UrDEXRA2fmdoJCeSur8y0bUI7oMByxZX0WkCfOc2Afk6H+MnBKUe?=
 =?us-ascii?Q?+xnGYzm4AMLJYiftmV8zuNxxDmoC+QkZnFLDjJK04eqSdxM22tCx3OjG3HIE?=
 =?us-ascii?Q?vvloWk4lf8ACm68N34c3Blyl6Nkcv/tZgpjDdchCu6GlNoLiCG65GvpQa1ia?=
 =?us-ascii?Q?s0I6OAyaiD2GeD+m+CPcEPtoenOhPHz0ceszr2k9c6y8MJGUKV/g6g84zAgt?=
 =?us-ascii?Q?XaV/M6NR3BG55/6JIJrBh2XcyY+xYc2uSCwmrEzscIWuT0KC6CwvVWndTM1y?=
 =?us-ascii?Q?tre9krqSXQdvocRBOrbw1HwVLwpqMP2+OHjjfdvDPm83GyOawVI8DH/8KvXb?=
 =?us-ascii?Q?PgM0K0fE1Te92U7v7ig0goNk9resdRdIpVX7llp0D0WdIrXDbzg3rvZ90Za/?=
 =?us-ascii?Q?v6ZBfxjHnJB8bTbic610cggjakx4r55AgdVa6Q/HrNywVTUI6Uy5z/Js2C8G?=
 =?us-ascii?Q?MsHVdTCbaG6TbjYtPXvwNsPmFKQ64xum/yKxUfsMMwyWEBWFPcdXN9NYgiBu?=
 =?us-ascii?Q?FCnT4CAHtT8g093nr7ZOu3w4Pn+OjvO8Yds4zwY2atNGivdkbUyjlucSRkhA?=
 =?us-ascii?Q?3Wu4mLHhVGDTYEMl7Ciwu7IReD8V5p1NikT9C+TOQND+ashqHzuPb3IWqKMR?=
 =?us-ascii?Q?kdOaLBKMtPd8LZh8O9eGVK4biHPjJBe/k0U+V/LccPOgqBlIqh+kA6GL6WFS?=
 =?us-ascii?Q?Y09WOfYa/Qjvdd6nNh+Z5I0N8i5ecr3oSeJHgvZMuC1Q1weFMd/9wOainy+V?=
 =?us-ascii?Q?MIi+YCvx9Eul89guOhQEaC+wBeqoHQstKtesh1CwH52s8JbftYnVDFhCF5/g?=
 =?us-ascii?Q?9qWZ0apoAFvH07Y1htyHQloPb2QASklQHJm5uHKy?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f10eb30-b7f4-4bb1-5ade-08da5b8340fa
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2022 17:00:51.6275
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9goAaIZEA2EmTm5kHX3gsk+CT6kkflWRN3cWK1q0w0sKcMs/W9nwFfV5CkXGTIUkka5HkmB9E1KrpjwMItF7VQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1201MB0269
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 01, 2022 at 06:07:10PM +0200, Hans S wrote:
> There is several issues when learning is turned off with the mv88e6xxx driver:

Please don't top-post...

> 
> Mac-Auth requires learning turned on, otherwise there will be no miss
> violation interrupts afair.
> Refreshing of ATU entries does not work with learning turn off, as the
> PAV is set to zero when learning is turned off.
> This then further eliminates the use of the HoldAt1 feature and
> age-out interrupts.
> 
> With dynamic ATU entries (an upcoming patch set), an authorized unit
> gets a dynamic ATU entry, and if it goes quiet for 5 minutes, it's
> entry will age out and thus get removed.
> That also solves the port relocation issue as if a device relocates to
> another port it will be able to get access again after 5 minutes.

You assume I'm familiar with mv88e6xxx, when in fact I'm not. Here is
what I think you are saying:

1. When a port is locked and a packet is received with a SA that is not
in the FDB, it will only generate a miss violation if learning is
enabled. In which case, you will notify the bridge driver about this
entry as externally learned and locked entry.

2. When a port is locked and a packet is received with a SA that matches
a different port, it will be dropped regardless if learning is enabled
or not.

3. From the above I conclude that the HW will not auto-populate its FDB
when a port is locked.

4. FDB entries that point to a port that does not have learning enabled
are not subject to ageing (why?).

Assuming the above is correct, in order for mv88e6xxx to work correctly,
it needs to enable learning on all locked ports, but it should happen
regardless of the bridge driver learning configuration let alone impose
any limitations on it. In fact, hostapd must disable learning for all
locked ports.
