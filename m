Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01E415A4F67
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 16:37:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbiH2Ohh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 10:37:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbiH2Ohg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 10:37:36 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2046.outbound.protection.outlook.com [40.107.243.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA44E8E453;
        Mon, 29 Aug 2022 07:37:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NR3qKb5+LWaBQwJYeRCAGgTsTXeGsXBFZugzxd6Kvrp1EoKHwQ4rhzSlr3YrFacGoEufluXW5vs4k/XE9elwX7mZnjOLaBjAKcfBAppl3+YDdrqA6KdO9VaNyTKsst4oiEceTp/sQ2bMTqov1piny4yHsirJ0TXMIGryX6JaF1o+Bt5LvCrPOBX8OqDPUS+BQWh+CFEOpGHU89yWjkhD4KDAKt7npg0octoSdm4PZ9T+eDhN1Zrr9w5I00DbLaI1JRslh+mM5ncmGNmNbv0hNFm/h2itOnMlpbC7OKcTO+EeUWOLsazf/OyOMwCBqKmeS5mjVXneHnMaRNWk2U9HQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l8l6TR8xBhnzhS5VlzrmXIdXzbVUug9NrXTcRJL5RyU=;
 b=acNiJEQmp7QU6PU3oYdqYuYbOQoiWe1VcQ452T1IDyVKSupzFmw04umCyH83f9n7V+ldYWPkBkYvyfoCdRwsDAHzM6myCUCXSKjzKn7fa/IO6fsiejZmcASC4G59ybm+IqXMAWBjUelni+kJw0SzWdNKcfy35HJo0sn1wMimCL7cBJY2alznQNRzagcU2SnQScCYLaknRIfG0xRBMrzYnPVb1oqRU7wr8D1TFkXIS7espFkWKsQ0xU02H8zFJieZaLeeB7wfzpNvhnpGeUDQICOUX78fw+QcFEKoEdLpDvSJ4W2o6D5/MnmP60B++n8GtoK3TEMoFkN8d7H4e+P28g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l8l6TR8xBhnzhS5VlzrmXIdXzbVUug9NrXTcRJL5RyU=;
 b=dhHrcwDDi5l/BqF+3vXdW37qpZYc8jlNyqCvBsNvh96t9YJN3ejUzicysEDrLPaJICJ8zjD9AfL/2RFIlZsDcJebhGPx+3OZ+43FAbGhZMpgtGdEg2q6CCYb0UNfCngxfsr6SjTNYkhS7agJVFTtNu0W9QmT7KEL8ggBqQI+5j/U3809XpG2JkAVD64fVFbBqaprIJgSby1h6Flm5tmKTMXyJ0izVCOpcim8d6FXCFJm9dWT/UiW1nO+At/5nbDY2HJjSKIclFZ+1bH2I95gVUjm0GURdBosIlaLOFdqGa2SawrpnfyWS7LX9gxfx5nDJ3iZN4XTu6r7HwJ015CZTA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH7SPRMB0001.namprd12.prod.outlook.com (2603:10b6:510:13c::20)
 by SN6PR12MB2752.namprd12.prod.outlook.com (2603:10b6:805:78::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Mon, 29 Aug
 2022 14:37:33 +0000
Received: from PH7SPRMB0001.namprd12.prod.outlook.com
 ([fe80::3ca6:ba11:2893:980e]) by PH7SPRMB0001.namprd12.prod.outlook.com
 ([fe80::3ca6:ba11:2893:980e%6]) with mapi id 15.20.5504.025; Mon, 29 Aug 2022
 14:37:33 +0000
Date:   Mon, 29 Aug 2022 17:37:27 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@kapio-technology.com
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yuwei Wang <wangyuweihx@gmail.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v5 net-next 6/6] selftests: forwarding: add test of
 MAC-Auth Bypass to locked port tests
Message-ID: <YwzPJ2oCYJQHOsXD@shredder>
References: <20220826114538.705433-1-netdev@kapio-technology.com>
 <20220826114538.705433-7-netdev@kapio-technology.com>
 <YwpgvkojEdytzCAB@shredder>
 <7654860e4d7d43c15d482c6caeb6a773@kapio-technology.com>
 <YwxtVhlPjq+M9QMY@shredder>
 <2967ccc234bb672f5440a4b175b73768@kapio-technology.com>
 <Ywyj1VF1wlYqlHb6@shredder>
 <9e1a9eb218bbaa0d36cb98ff5d4b97d7@kapio-technology.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9e1a9eb218bbaa0d36cb98ff5d4b97d7@kapio-technology.com>
X-ClientProxiedBy: LO4P123CA0624.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:294::8) To PH7SPRMB0001.namprd12.prod.outlook.com
 (2603:10b6:510:13c::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b10561f2-253b-486e-bc76-08da89cc0237
X-MS-TrafficTypeDiagnostic: SN6PR12MB2752:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: p6nB0F+xvwI8uukmh78BkTXvvkpSojFGZdnkdP0O4hH9X34W+nHts7ZthzmCxrnm88eTHkbONzMtPWtT8dO8d5ZUrOSlwjkoLIkgn4P3+5u5+mYkyR73MQM9yfnr+DxK7K4Pu43NprqYgopac0qsVhDyYWsA6z89/T1y1otLLFjBRXtGbFR+Jfaxd03KbEIjJE1hBllpMLl89zmIMbkf6//KWjwl0ZEn9GF6UpBfB1q2TlXsAMdE2SfxKg7gnrurhruUQU8LqO1cjLp11xZY4dIJyN8h2zz78oIVqNorqph9GkismketjhnE1mlvhi6BaisN7OaxVTsPQJvhwkrM0eCgdeHsYloXzyBTXIRB1i+Lrp/KikBc02InXC6yRt5tZHZ9HurhsCfAyax8/rWZnKC368B+qnA1nSakebLhwJKCSDY5gfTmryq9Rzgtjo7Y3JiZ9nr+5dw3Ubp3XIq1HP6HODbyoBdiOEnfeT6l3pUEdGIdwp3On7EjlV+4WyUQBNa2bPMxMq2UPik/kpaOkNZpu/bPDXhxxuczWEZAOMwqwgznPI0tDr9RaYDdxuOvlhx4XQoTyqPr4eUCiCaPDnI0FGvMHRCwrwBleaFHNlJ7W9zLRlk2HGczUJbEArEKEN2NFZ9ETZn6nYBGQid7VVncKEg3UKtCenMtm9mo2QsgmObr4t59SiLF/TqreLp6+rvS/P9sm/tRCQrS5UDXJSn+K8mq8AMAOlsD2EcpLiShmN+Ab4Zl4KpM9QM00foSIt3i2QGOaZ3nV3rG/LAdQIs5TTmgkw3iR8gLQxwN70H09ayAVWawe4pPkNcOlcCQysChWRTRH+wVUEam0OhDXw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7SPRMB0001.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(346002)(39860400002)(376002)(136003)(366004)(396003)(186003)(6916009)(316002)(6512007)(26005)(2906002)(6666004)(6506007)(53546011)(83380400001)(9686003)(86362001)(33716001)(5660300002)(8936002)(966005)(478600001)(7416002)(41300700001)(7406005)(38100700002)(54906003)(6486002)(66556008)(66476007)(4326008)(8676002)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2m2rb9+Hht07reOtEB3sOo6JZDubAcYQcjGKalGmdUKkqZ7aGBmuQNlsK3lx?=
 =?us-ascii?Q?ezycNrFNQ1CUMl8p/gLFF4dH6jecDotzNc7joq9oSuW3lXDILL1+CJRRnpJg?=
 =?us-ascii?Q?I4rRGqnySQWScV/MlQGXgkwIRocDgHT29lBnu8s+NRcLsTF73CPqkq0M4a8q?=
 =?us-ascii?Q?355Pom1mu/EYZkVvaE7rESXdcKzatufAOAz1cN6msAHXQPWSlDav0G12o7Fd?=
 =?us-ascii?Q?mJuKvXsphgoUp/Qag7yFZKRxVGn1tWjmpXI3JOG9XlhKrWTtKk3/4yQFzJP4?=
 =?us-ascii?Q?2lFQpTQIaxPXulZsMNyPFzQ42FFpQYjVvKGONfRFTJkfUNjOMNsuSk4tr6Wx?=
 =?us-ascii?Q?Ebbdv8oxQLi/mRD7mv3zzs4HBeh988Je+6dspWsr2GY0NIkPeOL2VnqXzQ++?=
 =?us-ascii?Q?Wn8SwuUy9NUj25SygUVznp5O8ez7Eq7zopSEDmj4q0lnNY6rVQ9R5ktXkSmx?=
 =?us-ascii?Q?5+zRG7SerPobyTvhdAwym3MVNdwtBIyxHpDpKPNc42ArzeSMuiqFlcOkfUuE?=
 =?us-ascii?Q?qt+23XWxufJTWazx2e/0rUu+HfMyksy+hr1ZxPh7SCdlaLHUzalPEPwoQvoB?=
 =?us-ascii?Q?1jJ1FPbBNZehPLapbdUxmzQk2LpU4OFZQjCyIrCNQXJj8dkGEfFQeDOWhhup?=
 =?us-ascii?Q?gvFHySmyfwcMsNsPn2XZ3fhrVenHmvQ0FnFBpFUudn0CB+j97qb267l0i2ij?=
 =?us-ascii?Q?SEt7LVNZ6O3YHwPjDFu3nFeGObJlTzRFGv3bFM+iQ8lKKaDbuprqXeZs1ros?=
 =?us-ascii?Q?mdUBA99j2Wo9dCxT49GNtsi+LVPeTKk9CIAT5FXU/P4cstpgaAATWdQolHyz?=
 =?us-ascii?Q?87zMoL7ln/ej3U+1DYRXTMQI51B+NORp/mzUbDUy3CyGCXGAdcwNEIGTyIq/?=
 =?us-ascii?Q?p3MHgmHRsInLMk9l+NSKC5SMxUy4H/0KQJtm6f74cTorBDcbpMEWNzA8A3jO?=
 =?us-ascii?Q?J3ZNEXLWomyvBC1jSf0jFcGhR7NUlY89T+mCi4Xfsd3hHu+6km2a7I5drwKe?=
 =?us-ascii?Q?tVmHRzDICqJVCp1YMFx5DCEEo11yT30mAuAn0BBb8UycOm9JbTZuZr+ULY98?=
 =?us-ascii?Q?yhuw3QgAI0ntNVGlSyEWwm3kt3CYcLaLGbAl5fqIA1x2uYn/da+1TgrFAvTQ?=
 =?us-ascii?Q?h7PO5xXqcyc22RrIpSrITbWz9VuvJSddR0cT563p5go++FEeSYDJXhthH4Xa?=
 =?us-ascii?Q?oNOyM9lWViqS+1YrKV7DIRkZFimhxYv6sIDrzUEQJt9vZJ2pVhdrcUeSUhF8?=
 =?us-ascii?Q?C+yunzMoEWZe2J/3KrsNugiITO2YDlrA/xVUdYog8SdTf1EgLvHgbnlppHLm?=
 =?us-ascii?Q?mq7qlyiKvz7bBGtvUAIt0HWkuKmlsx1Ftg1A50AAfzVt22N9xaqSmzAZPAVa?=
 =?us-ascii?Q?/RfnzWngB2czh5FGC+lNenU+QnZdFrRKjWEKNkUcy1x3HNlc0FaTDb0QWIq2?=
 =?us-ascii?Q?p8dOrBPOmS7VjJwCZkXMgdp7TwIyjWQtM7jHt7nT56m+G4/tY8J44mvYSPXy?=
 =?us-ascii?Q?p5CEIW5AnaHAuFu2IQrpgXyIlAxi6AzazXQiabWmCJUf/22MB5STtcBrzmF5?=
 =?us-ascii?Q?lFFKXsc+5d4IB/Ve1g7wUMGlccjSsDA8CeS43w/h?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b10561f2-253b-486e-bc76-08da89cc0237
X-MS-Exchange-CrossTenant-AuthSource: PH7SPRMB0001.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2022 14:37:33.1137
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JJ0L7O1tTrrj77INHxE1e20LUM9123ryNZQX6FCCXYvd34KQgRWp3hSQSy5KAqSKKZsNiaJGCTtLtPNx0wuh6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2752
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 29, 2022 at 02:04:42PM +0200, netdev@kapio-technology.com wrote:
> On 2022-08-29 13:32, Ido Schimmel wrote:
> > > The final decision on this rests with you I would say.
> > 
> > If the requirement for this feature (with or without MAB) is to work
> > with dynamic entries (which is not what is currently implemented in the
> > selftests), then learning needs to be enabled for the sole reason of
> > refreshing the dynamic entries added by user space. That is, updating
> > 'fdb->updated' with current jiffies value.
> > 
> > So, is this the requirement? I checked the hostapd fork you posted some
> > time ago and I get the impression that the answer is yes [1], but I want
> > to verify I'm not missing something.
> > 
> > [1] https://github.com/westermo/hostapd/commit/95dc96f9e89131b2319f5eae8ae7ac99868b7cd0#diff-338b6fad34b4bdb015d7d96930974bd96796b754257473b6c91527789656d6edR11
> > 
> > 
> 
> I cannot say that it is a requirement with respect to the bridge
> implementation, but it is with the driver implementation. But you are right
> that it is to be used with dynamic entries.

OK, so it's a requirement for both since we need both data paths to act
the same.

[...]

> Port association is needed for MAB to work at all on mv88e6xxx, but for
> 802.1X port association is only needed for dynamic ATU entries.

Ageing of dynamic entries in the bridge requires learning to be on as
well, but in these test cases you are only using static entries and
there is no reason to enable learning in the bridge for that. I prefer
not to leak this mv88e6xxx implementation detail to user space and
instead have the driver enable port association based on whether
"learning" or "mab" is on.

[...]

> Oh yes, I meant in the iproute2 accompanying patch set to this one?

You can send it as a standalone patch to iproute2-next:
https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git

Subject prefix should be "[PATCH iproute2-next]". See this commit for
reference:
https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=d2eecb9d1d4823a04431debd990824a5d610bfcf
