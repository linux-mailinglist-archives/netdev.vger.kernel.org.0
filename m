Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83C2F486AB4
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 20:55:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243492AbiAFTzD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 14:55:03 -0500
Received: from dispatch1-eu1.ppe-hosted.com ([185.132.181.6]:52240 "EHLO
        dispatch1-eu1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233979AbiAFTzC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 14:55:02 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04lp2052.outbound.protection.outlook.com [104.47.14.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-eu1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 1E6FE74007C;
        Thu,  6 Jan 2022 19:54:43 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fK1RXofn40TLqV4HcOnrlT1pVPaZVl6iSugge755ilAIY3pXeJJ7cHvG1rjJMh+MWh7F1BtwCU4ZdFJhkSD9VZ44zd4k2xhJLCiNULVMc8Yau05e02t43+5s7egQPbAsE6Qpb+BzD9Xpa9G56AtB8smJ802cvFpS7t4oSUtUFGvztjNT7QpClZeXl84HWX2Tu6O8/bW+u2P9znRsdhyvKsu2G+6YgZpljWCD9TSaZ1L1XRPlW5YjYd6jjX7FYnGfa89Vo5uSjdVStui6pgGweWz2N9MsKYipLmciFnYndDcOKZ1dSYNHaMW3dq4EkoMsIpwU+xanykJ6mwJ1K3/3mA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G09Bj3DffpxZi2xMXOGIx1V1njZOJNxg8pk5bkawBQ8=;
 b=DS7n8TkcrTc8sRuzaCFSmA5MfI/tKVsace3zGy4ox85J0xFh6K1tZtRoc89pLlATr2bijScnvbfE7JgpWOz2221b8P+aapq1TD2tOh1rLrQBy62/EPJG2Dx6gC1tWMtE8L1l2JgXx2pUSOdsInnB8u47mLRcveprXfRHZK7R1ySr9epPLcuwPfJIP3Mrn4T6LXEkm6bpI7pPy4qgx1jnwIB8JFV7BQXrUJ3kFTh1E+7ffo7K/iiL6UebpbTGq5RZoX6oA45yWh0ZM0PjNRebLqX33yGDj3dIdHdKbC7CGCR6HtwjVsNDN8S0wft6QNDU55cLPbSASMCxCYIYJO2ehQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=drivenets.com; dmarc=pass action=none
 header.from=drivenets.com; dkim=pass header.d=drivenets.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=drivenets.onmicrosoft.com; s=selector2-drivenets-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G09Bj3DffpxZi2xMXOGIx1V1njZOJNxg8pk5bkawBQ8=;
 b=iu8UaDQSTUF9TFtLTKGMfCJ4DRuVufAYUdelp0yjXCTL/9B1/N/8gjZ1CuawITHHuBVm80YRj93v+anWoLwOE11LcIBI85ijwEPNYe2a7rdUGQIdz0d4t7QS9Ni7nS2i2KAWwHE6waE/7pzTSix6+I7HAv7mo08swai2X3+raYg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=drivenets.com;
Received: from VI1PR08MB3518.eurprd08.prod.outlook.com (20.177.58.151) by
 VI1PR08MB3248.eurprd08.prod.outlook.com (10.171.183.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4867.7; Thu, 6 Jan 2022 19:54:42 +0000
Received: from VI1PR08MB3518.eurprd08.prod.outlook.com
 ([fe80::28b3:9174:b581:3037]) by VI1PR08MB3518.eurprd08.prod.outlook.com
 ([fe80::28b3:9174:b581:3037%6]) with mapi id 15.20.4867.009; Thu, 6 Jan 2022
 19:54:42 +0000
Date:   Thu, 6 Jan 2022 21:54:36 +0200
From:   Lahav Schlesinger <lschlesinger@drivenets.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org,
        kuba@kernel.org, idosch@idosch.org, nicolas.dichtel@6wind.com,
        nikolay@nvidia.com
Subject: Re: [PATCH net-next v6] rtnetlink: Support fine-grained netdevice
 bulk deletion
Message-ID: <20220106195435.odlagzlkikgasmwd@kgollan-pc>
References: <20220104081053.33416-1-lschlesinger@drivenets.com>
 <66d3e40c-4889-9eed-e5af-8aed296498e5@gmail.com>
 <20220104204033.rq4467r3kaaowczj@kgollan-pc>
 <df31afed-13a2-a02b-a5f8-4b76c57631d3@gmail.com>
 <269e52cd-2d84-3bca-2045-b49806ba6501@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <269e52cd-2d84-3bca-2045-b49806ba6501@gmail.com>
User-Agent: NeoMutt/20171215
X-ClientProxiedBy: AM6P195CA0016.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:209:81::29) To VI1PR08MB3518.eurprd08.prod.outlook.com
 (2603:10a6:803:7a::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d785328f-a65e-45ad-16f8-08d9d14e6139
X-MS-TrafficTypeDiagnostic: VI1PR08MB3248:EE_
X-Microsoft-Antispam-PRVS: <VI1PR08MB32484C9041085A146D1279B4CC4C9@VI1PR08MB3248.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AQWFqYMJelzKk96NXLogL85UFBzd5q9SiVsf0v+0t91GqKUfNnyqEFoUBHl3GyFovJMqVlJsrKbdfCkW/XbZ3XpAExbxHR9KN08LoEDjKCEltzVtH36wOf6nQO/t8RMIVmpIjTfgXv3pFWPCPLPlyKdBSlRI9JM4XRA7qkdfCuFPxBQpu3MtDNvKxXK02S7+N4b97TNLew1DQgaJQ/BnckfuZ/umjDQ5qHePLb0Thc+1XJd1klMADsXT9eV1d7mLj+IUXMrzoaGJSlVsaAJnvA2azy0HUedAp+N2YErbZbEX44RiVkm8mbOQ77R0aqHq+nIHGHqB+eiwwz0X5YU28kZMWKEhsnKPUIMHLcOloP1/+m41x0Ob0S0nFwfY5QWUnLK6GxoNpRiiswQbEkbjP2Gs3pkfkrjL3PJ7I25ltNr3fbXfCWz69FyR7zk7VZlGbEZ7eASSuTC601HcmbTa7ipkv9vlaBViFhqSYopeFOM77ML0MgYODrIWuxtPnGElyvaCFh6KhQCJloDVvhzYI0Eg8ZTp6PRBj2OwHTk/SfmLEFt2RP1SPe+JwHBTrSqzLFRnhpRaGnxJ32yorwhy5AzSlLHmxzeJWTf3GjaDnUo4OQCIRSSF8XHeFcWpXdKwEXF7GZZyJ49dNrZfCLzmUj51uxmHqkbdlQUNKO0Ey2YVqLypO+SUfEz1BP6iNoy4YeDxwuO015lXOnF8J1zzLQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3518.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(316002)(66476007)(4326008)(66556008)(66946007)(1076003)(2906002)(38100700002)(5660300002)(6666004)(38350700002)(8676002)(6486002)(86362001)(3716004)(26005)(186003)(33716001)(53546011)(6916009)(52116002)(6506007)(9686003)(8936002)(83380400001)(6512007)(508600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TBt9qjGzFu1RTb7YJEcRyfKlIjQKXUCfkqLRnX/LlAy7fjz4EyFyJNiF/nhO?=
 =?us-ascii?Q?7pHV8KPLCSBI1FiQSa9Y+WBZMOVeHxlZqCWIlmGciGpUiMttpCoBDMqxHtAt?=
 =?us-ascii?Q?m8yVY5a/U4ypktCfF9YhLxM0u/y10NKpt8+LG+isDWsXN0w803Qlc5c1wgkF?=
 =?us-ascii?Q?kUUYIkJk1b66hWaYaU8pMvpqM2gcuFrdqe4kC2WMH1PZVQnONTtvh7y/bRpz?=
 =?us-ascii?Q?apMKu3lE/N46rVlHTHTo+1KUYMqKwJzV7647SAWdAN+Yk4v525thHQnE9kmc?=
 =?us-ascii?Q?LMK13RsFEg5nDJw+UPtZI5m1lYrZ5MMyKXhKi+dBOAxgDzd6YRBS0D1lIvJS?=
 =?us-ascii?Q?oiCWXDV3VxHnh8hL+xCTVeGsZywVYV8xzczLLe9T6gSg2Kf4f9noMEamxSjE?=
 =?us-ascii?Q?ztP4x39N5MAeaVY1VcIlkCLTYF8RMZuzmBCigUqVPlnp1uqcv5rTtvHSWIEP?=
 =?us-ascii?Q?z7WOAtafYktjt51l/OKBDiQhYN3TOekR7P4rdkV5dG6d7U8cD3QXf+91aBpU?=
 =?us-ascii?Q?PmScAryxNZ2czw/d6D33kFPQFQsHJQ4lUXkSw0Ht83I3ydbG9c9rCZOPzewj?=
 =?us-ascii?Q?MMHDXEeRBtDIdqJahvufptuf32LkHCDCTmrJCB8aWcv1eBmN/2uHCwLajSBW?=
 =?us-ascii?Q?MM50TICa9oYqLGqcWB4AjtAen13o7wVdhUGcxqwFBw3SjqQzMd2jXYpuNPLT?=
 =?us-ascii?Q?N2eCLbe7ZTQ2AmuW34q9u4b/J7wJcJU/LhdvMRLxeme8LqZ8nhK34QST+odq?=
 =?us-ascii?Q?VI063wKpeFD+tAWzxIk/A/JkoK7f38yB20VGt8cKejWwmqUlSwb7KISqve+7?=
 =?us-ascii?Q?Mai9qYySrKjko32AC/XIHx+dPifYSLPcDdmh3pGrSC5uYca7cCJb5CHkJ417?=
 =?us-ascii?Q?2SALeDtDvRqdfH49gUHLd6d8Muaih7UbPcO8bB3QVn9sDR4Ic+PTpUFER6pa?=
 =?us-ascii?Q?+0GMbys19jlPz1CMy8G7qphMIvRB1AU0ul8r1nAnDInrC6TyECsgoAjAPUuc?=
 =?us-ascii?Q?8JLpVnuVuCgX8DE4yp3koLbpxaa+3tDnjgPwY3/rh1IbjyBUG5Xcz84wdy26?=
 =?us-ascii?Q?kaE7GSe3WTKQoU/SGNM6tFY8egp1WhRGtorpw6eVox+GgYUeqRYYygRdDYnK?=
 =?us-ascii?Q?I9VpHrFPP96mXFmK7cYgL+tufYmlVQJlfU9YS+9lYlVDSWhU7bwaNxvg+yha?=
 =?us-ascii?Q?pc0zNPKp/rk0vdXdEHoF+aek3lGcQO9c1sgbUdKbWN7jIpSDhn/IyfrPJLnx?=
 =?us-ascii?Q?Y2tWj45ZZXOHSfsbRDhoHBFY298NFvaZmN+mKP8eqHc4kMovYSNTJfzL+wYM?=
 =?us-ascii?Q?cyzocz9Fi2SBLJpsbUjd88otw0cyA/piupxPaWLDzWLCgVDq75/k7q5O3ebf?=
 =?us-ascii?Q?ihGHWa7HDx9F9noRM0BEacwhE+yU4r0OifCPZwKDI0TyNo/B3mCsTHuawQcr?=
 =?us-ascii?Q?xyTR6fTX+UL4W6n/H1hSxU2199eJ8UGZqwcRuKVNru8eBvveF+7PgrH/uQ4H?=
 =?us-ascii?Q?prla08IhYli6wy2okCp2L2J4trIUIJCTCDy6b/gmno7MwJ87tkbzmS0hBLYb?=
 =?us-ascii?Q?huLbDUXfjUxicdSUbCljVkPcdrIVWF71whSJS5jaosgsoDeCbY9kaLJ4RBp/?=
 =?us-ascii?Q?0INLz9T0xMKC0+1wnQEtUxro/ZRbku2ExInm+qsDG1/dZTfxi6ySli6DlgXp?=
 =?us-ascii?Q?mrIMy7laZTLkRURxfvCUyFpQAgY=3D?=
X-OriginatorOrg: drivenets.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d785328f-a65e-45ad-16f8-08d9d14e6139
X-MS-Exchange-CrossTenant-AuthSource: VI1PR08MB3518.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2022 19:54:41.9620
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 662f82da-cf45-4bdf-b295-33b083f5d229
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sZukNG/5sHKJAXoJ9aM9cs1Kis+Dax6CkmoEXeFedGP81qii+MZW/7FpT39mXOLW6XTbq/Fxk3Tuv8Z0/pZ5n7qinekkbQ0DS+Y/64KzeQ8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB3248
X-MDID: 1641498900-BYU-x5CW2j7T
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 05, 2022 at 09:09:34AM -0700, David Ahern wrote:
> CAUTION: External E-Mail - Use caution with links and attachments
>
>
> On 1/4/22 5:18 PM, David Ahern wrote:
> > On 1/4/22 1:40 PM, Lahav Schlesinger wrote:
> >> I tried using dev->unreg_list but it doesn't work e.g. for veth pairs
> >> where ->dellink() of a veth automatically adds the peer. Therefore if
> >> @ifindices contains both peers then the first ->dellink() will remove
> >> the next device from @list_kill. This caused a page fault when
> >> @list_kill was further iterated on.
> >
> > make sure you add a selftest for the bulk delete and cover cases with
> > veth, vlan, vrf, dummy, bridge, ...
> >
>
> BTW, delete of a netdev clears out neighbor entries, network addresses,
> routes, hardware updates, etc. with lots of notifications to userspace.
> Bulk delete of 1000s of netdevs is going to end up holding the rtnl for
> a "long" time. It would be good for the selftests to include a cases
> with lots of neighbor entries, routes, addresses.

Ack. I'll add such tests to v7. What numbers you have in mind for the
number of routes/neighbours etc? I suppose we don't want the tests to
run for extremely long times.
