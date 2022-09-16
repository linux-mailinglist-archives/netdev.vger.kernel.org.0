Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC8C95BB1B7
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 19:45:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229507AbiIPRpF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 13:45:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbiIPRpE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 13:45:04 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2129.outbound.protection.outlook.com [40.107.220.129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CDCA2B268;
        Fri, 16 Sep 2022 10:45:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZJ2f02iqwRGXsueP8Ky2A8W2lzzVWtqNBNG0ZunTOknN8tHVqMYKj8z/2OApL7WIvIpfiw1spdk6ROpP5p8UAv9qW0tw6wG2coaKv3efrs5wAHbs6wf8e6syZCD25sxSHzl5vKOJbb0kqimDXSuGdgXdkueEIkAfUMnLF6mYV4g1ZusK6VNcZdTBKZ5uNc24f/NQAs/bJ3NnO211ZMUA1U9dn0kNZ6xPoE48Iwh3FBnqn0Rki68Bg3uckstFBJtdO4fT02VwNam2YftqrADNkklEj7QSLzEeiRlh+TBlRmHm71FsDp+KFgJ0uAtHmqwTAIbOOIUJveg8zPKK8swVJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XuUa3By/D310LXSGkf2KyyjkN8xPdXGkxp27frlS5GY=;
 b=YquxfLb00pzKTygrJY0tRnmKjWrclPwGPbKQaqUt7MwwxzYyA0O5Saw9Xa9QI/BrvTHweLJBDrXDS8emB9mcQ5jlAUtNWlX4WFKcEnZdMK87SCZTILmD326Aj+TFNgH7H0JriIKU1c432cupUWOXnf0zNAh0Bnl7GG9rB/bc534l9ZG5nPtrnXXX1EWhKQli2wjtqkoRtZUdE14SPHEACChHmbB9ZbY/dWG/T7AYAUeOOmD55i5FVOnCLRLqSZJL8vTiTqUJJFo2GUnH0bE0asJaUCCHr+ibLCbXntW2R1aRzod1Qvr+C/VhU6PVD8Ca4iXVP1Q04UwQNtk702KpGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XuUa3By/D310LXSGkf2KyyjkN8xPdXGkxp27frlS5GY=;
 b=o5h2z7cLfCImryE2FydmMoosD19xUOCdlfRO8BTHJfo4x4QuBI24jtt8j1kj/sH6FDcSElgfTlpyJOhvI4+lfTTgKmbZc9Y7PKypzd2uFkmEp6XJWA70cvUYrpMfMS6mfYOjHpU/F10viwGd/QFXUmgam4PhDh3OCXCaEa9QYDM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CH0PR10MB5228.namprd10.prod.outlook.com
 (2603:10b6:610:db::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.17; Fri, 16 Sep
 2022 17:45:00 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::dcf2:ddbd:b18d:bb49]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::dcf2:ddbd:b18d:bb49%3]) with mapi id 15.20.5632.015; Fri, 16 Sep 2022
 17:45:00 +0000
Date:   Fri, 16 Sep 2022 10:44:56 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Lee Jones <lee@kernel.org>
Subject: Re: [RFC v1 net-next 2/8] net: mscc: ocelot: expose regfield
 definition to be used by other drivers
Message-ID: <YyS2GHqAxczc73f+@euler>
References: <20220911200244.549029-1-colin.foster@in-advantage.com>
 <20220911200244.549029-1-colin.foster@in-advantage.com>
 <20220911200244.549029-3-colin.foster@in-advantage.com>
 <20220911200244.549029-3-colin.foster@in-advantage.com>
 <20220912154715.lrt4ynyhsfvdbyno@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220912154715.lrt4ynyhsfvdbyno@skbuf>
X-ClientProxiedBy: SJ0PR03CA0251.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::16) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|CH0PR10MB5228:EE_
X-MS-Office365-Filtering-Correlation-Id: 9d0b6953-5476-4bf4-f5d0-08da980b2d9e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E2sLfARqrGENjq5Sy+mIfjUUv2R7CvgSuMplhkkUuoTdX7mLdrrh9IA4HvmvKSclRumIh2ze3nyzDEJgbOtAbz1VWTgkG/kEPrbb+Ew/qsAyYJTTsxQy7HnDQhwCIyEwqvikqAc+k1twX35A2/GEBOIkIG27qwUYS38iC4NjDVqmDQ22wecyASo/GMiDEUXokKq43kNMdYDvhXYNsC1zc4ZlZVSYZ5CmtFeB/rAGZ9DSLA/2QrKgJ9kNmGFqhAMryCA1qUGUQ0LBvEb9Xe8acLs9rjbByYr6Y8o4nndyZlrpPoUqvkZEtMr+sxNFsxBNS43yK2vJp8UWQQ4oBdhTqZPnYpTLUKh63i/KI0pTNkJqjYFvUKjcbDSRUom99ZDjdZD8EiQSxotZiFsR5+er0UO15AMboo/LkGUzcSYY1e/0W5vH2+WUS6uun982i4b7oCvlgnsjWRNzfdC7Jax46Wmctn5Im3nOqYBSF0IrFpptuicwq1g+cCSBQz1MqC8rytxMHD6UgPuPMGDe1NfOR7MH7fV6HGqCNtVS5FT73FLBsIMwnBnrfrnR1tS96X2Uu0+x4yt9TIir1I8BgBisJjg760UdFI7xnYEjvolnFMa9aMYvQp4ij/Sqs1+aHxiagTa6/cJQZFNVmSBWL3MMBGMd2uqVjUyXji/glUaZ9AVIVD5LYCsSh7C1IvBJa7SZNbNjEMN6U6egQxoE6eE5HQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(346002)(136003)(396003)(376002)(39840400004)(366004)(451199015)(7416002)(4744005)(44832011)(41300700001)(5660300002)(8936002)(4326008)(66556008)(66476007)(66946007)(6916009)(316002)(54906003)(8676002)(2906002)(6506007)(6666004)(186003)(33716001)(9686003)(26005)(6512007)(6486002)(86362001)(478600001)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?djpS3l/PZUv8rfHIEUTqFBc+GSk0rUDwQ53i401N2wst8NWFm7+nYq30Yt55?=
 =?us-ascii?Q?Nz57N6WG2Hjquwwy8AqMUEflbQSoJn10yzPhM4WK4OZhrFv4RQZ2IsGUeM4X?=
 =?us-ascii?Q?rZTVSIiIhAuUhZ3A1IxDHwBSDtJvyCbnVlQ6iVlLCWe14XmtNc1q3TGZ8B9p?=
 =?us-ascii?Q?8QhzOYAxqFYAKLeLofH+a+ngGIt3RbypKKKpaLAVakICTAtNNXJ9H+nhnoII?=
 =?us-ascii?Q?18LbEdL5A+aZ0GpNFES4AmY5DgQZSvQ6N6+gTchqAKZToXoUDuK6zSiQpJ2m?=
 =?us-ascii?Q?O0sJwRirEXSTWR841y0ZjZkMnDdZbwiqLKaBLxYaz8k1HxZCK4nrRBgbf0bw?=
 =?us-ascii?Q?vcguP1YwnF+IdxrpQk9rjrA4JOw4XahxGK9Pyykc/p9gibQLx0z4MHzM8ioD?=
 =?us-ascii?Q?4A3YeeYWiwi4NuaO+gpx4hae9Pr1gDhGSNRSaWHpcf6Xn+S41aLeMWR9zlps?=
 =?us-ascii?Q?YeR98GIZHE8VNFYxI8/wdxRN1wtioulmxJWlX8VL142fncOsdFdA78EV2N5Q?=
 =?us-ascii?Q?ywjvChI5vBjprIqhnB0LI3fzEdJUDHWpe/sxT3QMlGR9jvu8Jsb2beWAj/9X?=
 =?us-ascii?Q?zsfNLBouMKnLrl02xwqL+tVKezZM/7aC2W+aIBQrH/pqziqAld9uXUf0KKap?=
 =?us-ascii?Q?cCiRhzFc0jpHzNDUmFTJ3cLgq0gm/yXx3FHP8Xyg46v7WnlXO8IX8wq7Bq+8?=
 =?us-ascii?Q?D1phfl2SUjnqOxlTFBAK7H1zo0ZbgYuvFmZ8TqlutcGmBsiomn42fIgKFS1G?=
 =?us-ascii?Q?WhBr1rZAGkpECKoIOGVI77V5kPdzemPdOvpm5sRIo+eGqRZlZZXuF6SqYPlu?=
 =?us-ascii?Q?iPhw/CkOAhOdrKieedTV71RK41OI9Qyg1WDoDU17SYGH4kblFmokOSV7TCC6?=
 =?us-ascii?Q?UjtKnro/NoeaxCU9CeFt86Jfdj9mqj2IcfznGMK90nCwJSE/AwZnTRdNMQHy?=
 =?us-ascii?Q?eNCiBHkzhd+NVHkX+yr3kqtRuMN8XITyVLpEJmfHpjtenISP8a/hJ1Ifayph?=
 =?us-ascii?Q?Bugv4pUvssYvOuyWa9Q8/d8NxkIZF2ih1e/8lBPZNZdzKCH7boREg2RcbB87?=
 =?us-ascii?Q?9a8UQedWFoN1em8NEEAZgiuzCUNl/lwLOlAsVFjOXBU43LDBXR79kFK5DNuj?=
 =?us-ascii?Q?7hOWvAZZPK8VUBAuueHGinrvhDxVYGxc//L6zngsX7556ufgf9ybOa5WqyS4?=
 =?us-ascii?Q?gVUVenGIF/7lM8YgC5ScCSMlokj/zlafBG96kmnmljj1XYlC+/ejv3ZiCAZ2?=
 =?us-ascii?Q?P6cJFtwQ+IZfGktXKfkW79PbOmmsyqd871IEfQzZBwKCX32OW1XMVoiS+0n1?=
 =?us-ascii?Q?7V1/G8riS3rms/uj0zXlpzNQ4OycOSsrHiEGAmMeX2viYeolOefLUz8U8Fd7?=
 =?us-ascii?Q?Jx/sTn1nlXk20S0s+iy7uR37iq70XTwUVPfc0qMfk0XV6foWUDAvWCZ3YzGE?=
 =?us-ascii?Q?jUYjhzLTzQbcnyHK/kwaEIbPhM7mmzQxSnuvqyJDd+f3Bzb7TCWZmd7yTR0R?=
 =?us-ascii?Q?vT9skw/REpX7CNvYj/ABmrpZVz1mkH+G9hRgKgDht094ZWihKvZzLP40Wflp?=
 =?us-ascii?Q?229keYg7F6KitJ+HWhfGEWPZWkorCp5Kr0LIaP9iy6YU0hXLge52nStooHMH?=
 =?us-ascii?Q?3g=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d0b6953-5476-4bf4-f5d0-08da980b2d9e
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2022 17:45:00.5675
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +E0VZ9rJIKUqtWFf3JeiE9jmYOBrRRJrf/GrBAoP2VWufyVZwB/Jgj+iuHq+QRT4nm99DYUzs0ytMaZqeGPoXm2gHeP6yoI0DPyq3s4o1TM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5228
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 12, 2022 at 03:47:15PM +0000, Vladimir Oltean wrote:
> On Sun, Sep 11, 2022 at 01:02:38PM -0700, Colin Foster wrote:
> > The ocelot_regfields struct is common between several different chips, some
> > of which can only be controlled externally. Export this structure so it
> > doesn't have to be duplicated in these other drivers.
> > 
> > Rename the structure as well, to follow the conventions of other shared
> > resources.
> > 
> > Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> > ---
> 
> Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>

I'm assuming you'll agree with my a-ha moment regarding ocelot_reset()
being in the ocelot_lib.

There might be a few others as well. Should I add them as more "export
function X" commits, or squash them (and these already-reviewed commits)
in a larger "export a bunch of resources and symbols" type commit to
keep the patch count low?
