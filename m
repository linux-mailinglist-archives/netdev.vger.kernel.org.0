Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4ECC5F21BA
	for <lists+netdev@lfdr.de>; Sun,  2 Oct 2022 09:34:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229706AbiJBHea (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Oct 2022 03:34:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbiJBHe2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Oct 2022 03:34:28 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2080.outbound.protection.outlook.com [40.107.244.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4E8F4E86E;
        Sun,  2 Oct 2022 00:34:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gap3kEBemsS63zbopJ8Iwex8f2x2asHF18MF8WCfZKOk9WAUqXxvZPcHMGj0ZOJukSxI5OX67XAtpmmhetg+FMwdk6CPataRBHNy4Pq0/cze93SrenoomtMvtSpbI+EeONU0TYODdkCcgCn0xPWpUvEmhphYyDK4x85hSTC4EneeSNj4xu1b1siyX7spVsMtDF8fwLNFN9lvUeSLnUPly3J7THXlYqj4ACNtkpX/WxtHHlZhDNCzEnq24I+MV6Fz3liDu1wu3vwITDHL5fgFaYuvgGSEunHueFd6u3zjwG4HXs7fPtrguxn09NJcp/ig4L/1vHzUjARmpylGfQT8xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SFqMd4b/TP7ivjoTr5k0gJ7vPmOsDtXTKIF4G9bDt1c=;
 b=nOHFu/6gp0whL0jLBJNN/tI4bTwYUvP4jFNCdlcHDIc88LIwKsZP5iQTpn6wf55Iyj5ryEC0nulSRFc2jS6cea5LeiPKfpjIzz/ayRwLhiBw5lBAdUGKuYSl1HxrmTwrQT31G8FUXg17RCHZjt1RzQho8Bmrm2j+A1RQEqyZE4k7c9PPxMII6IpXenYp8kefE6eVBu+jX57gdWda/QPEHkmXZP0Y2CWVSUv1LFZlhhXBCVhLLD7OWZ2aPUhH/uiVcpY8wuKPqRBJ9qO+8Emh+ODvM0PvkiXsIPJPvlwAxgx5dzWcKV4u8vaLcvLrnskplAMxlBEroqKRu1xkPKJL6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SFqMd4b/TP7ivjoTr5k0gJ7vPmOsDtXTKIF4G9bDt1c=;
 b=IPJr+UbyEHDX4ZuieqcWqueJikP/vN7k5TRX+tucW06nulyXflBFSkUL2GvEaphwc7IJu3Kn9f5/spYFC2wQ4xh7b9MNeh32qNVhsd1GPsnShgoe+rBErvL6ESa1mHo6O+7NkABRJOOsO+QRKyw0pNfQ3Gs7LTNXQzkkH1OSOuhiW+yxgsLLnodZadFeRXaGNe3n0v1/W8r7If2KEW4ZSWSoxZPtoq/aWPDSrGlkO4+ZNdu2rYnqQVRiLcZUfiZuVMRgdok5KVFm6oKwvWYOyDPXf/Bj8/NZO6PDexZCgDTpVbYu0a5jSM0V7GuLFm6HokRmdK4RnSBecOElB5aDlg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by SA0PR12MB4352.namprd12.prod.outlook.com (2603:10b6:806:9c::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.28; Sun, 2 Oct
 2022 07:34:25 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::8f0b:1a79:520a:64c5]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::8f0b:1a79:520a:64c5%7]) with mapi id 15.20.5676.024; Sun, 2 Oct 2022
 07:34:25 +0000
Date:   Sun, 2 Oct 2022 10:34:18 +0300
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
        Russell King <linux@armlinux.org.uk>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yuwei Wang <wangyuweihx@gmail.com>,
        Petr Machata <petrm@nvidia.com>,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Hans Schultz <schultz.hans@gmail.com>,
        Joachim Wiberg <troglobit@gmail.com>,
        Amit Cohen <amcohen@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH iproute2-next 1/2] bridge: link: enable MacAuth/MAB
 feature
Message-ID: <Yzk++rArs1me+gJc@shredder>
References: <20220929152137.167626-1-netdev@kapio-technology.com>
 <YzhV0hU9v7oQ+g+K@shredder>
 <00f5b024d242b948e1e198dfe95d73bc@kapio-technology.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00f5b024d242b948e1e198dfe95d73bc@kapio-technology.com>
X-ClientProxiedBy: VI1PR08CA0249.eurprd08.prod.outlook.com
 (2603:10a6:803:dc::22) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|SA0PR12MB4352:EE_
X-MS-Office365-Filtering-Correlation-Id: 05d7dd20-bb7b-4970-bc94-08daa44887a4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WLuwYW9YHX9REVcQHk2qHTZl6vcWjhtUprtqdVHo9Rnf9VWMKDEzGDhbn1/df0vpYg9L122g97dBOzSjXqxtHJpj2Twvs+U5xQLteHzAItu4mGpuJFJeAjOB7uPXFDRLGgQOmvpXzPHqvbawJh9/HUa9FqjszTS6GxNpa7gWikNqkujTLAlLwwmR6IsO6qKCVsCRcI2GJx5MXaXiDY9qajFRZx1TVdVydzKMloUxFSiu6m7xk7QcCTZB4xAHGLxRuRfowxFSvhJcB+Xq7xClHSSKq8H0x7QpQvvionCQY40zDMbRlUhXYTd11umRflnYRITTZbZZYV4Ng+0BzUIFpYnWgwAvtHhnCa2pTw7UuS4Ke8sSfo87u/AYI7+R2bjZxKEMlft9w2SaMzzX7ZOLpOJEo/uBMNEFTWQgmOTvItYB3Whdiuysc0tLTpKcFy+0cd45AMJPnMc0zIz9RcwO7hysa4MCz2BdGT9jWzDAJ2j4bqF36Aj4szwzcz1Y+Of8Jt25pdHWMW9K/fh7SoDoT6qaihAY4YyW4KtrP+ze/7GhsFrxQw1whXcoLE3QoHA4voF0/w+/9Bceb6N6ox4AckF/p7RJFwEjIJTsCAMasPckbdcIafWHKFVrEdHt3z7lrfRxK04rvCQ+67YHVqAFYVsNnGPGPr4Q+8Fv+YaLGYugwUOoPjmWWW7LTAudrpInBRXYNYbr6rlXmGpL3b5B7g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(366004)(136003)(346002)(396003)(39860400002)(376002)(451199015)(66556008)(66476007)(66946007)(41300700001)(4326008)(6666004)(8676002)(38100700002)(186003)(2906002)(83380400001)(6506007)(53546011)(86362001)(8936002)(7406005)(7416002)(9686003)(6512007)(5660300002)(26005)(54906003)(33716001)(6916009)(478600001)(6486002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?b1mp+NkKE74io7JzANnmgrPeN+D9qIT2k7/ZCAfj5DkX4H9Hh+Rkccw60rtB?=
 =?us-ascii?Q?DwB0oWhUd9mC/m23B4MmPDz9ftuySRiOjm9G02p3vFrVFNXEv+AMARpxhpYw?=
 =?us-ascii?Q?JE0qt8nzVmHODMI+Mj0TkZ7l/tf6mFMuwoDmQIicRon9jtmOrOMfrQO1UHd0?=
 =?us-ascii?Q?gdENTyhaAgdoDh7uHBNnGyarp0Y31yBM0yNgnEnOSVWL+49pePK7cdhILv3h?=
 =?us-ascii?Q?RYDYCIHvPaPgv8gEqr0tFS9Edm2dapdFe60ReeYnbumPJ/a5yiAZ7KfYbU7Q?=
 =?us-ascii?Q?UxI4kQdWDNXKmCba68S22GoeT3cq9wPIj9dEk8gnHpj3qTSmpXtHrvim/Fk1?=
 =?us-ascii?Q?M0kULQnpCUKyUevZiI79RaMUKdJ9cRrbmq+ULiL57VV3AlLKvBAR7xXrIkwx?=
 =?us-ascii?Q?/PX+VSD1f5qJNNc6P7VvbplIP3IO+xJx0On8PoCqX2KWf80I2eozFIjbOOgZ?=
 =?us-ascii?Q?gqHzIv9FBpCl+96IejgCm7al9QKYzMuLxrmJkGK6QqmRnaAQ++TiXkl8v5aG?=
 =?us-ascii?Q?o8u7+RwQLzqwrGzTbu77pOP8yFoeOjrYRpSSYPC1yhXMEtBvnNIHCSSHGWhu?=
 =?us-ascii?Q?zh4RsIjZ7PQJHzeK6UP1vIkjT+mMp/NF/nZbZTXOmJwmmI5cS7IqlCEHjkTk?=
 =?us-ascii?Q?MqOa/LeE63GC9uW8htqBt0J7ML1qJy2o8w1VAbUx7ic0R8TpsEHwSvMlO4s/?=
 =?us-ascii?Q?IJt6sGNFFyZdQsFk37E3ehaGZ4/J3YdbMUQrGohNmjayZ+LUBFNwyjfLsYxS?=
 =?us-ascii?Q?CQG/neUvNmEhV5XVUCd5E8glB1hkU2Fxj41+hMfQZeMchaEnlJY7NN4W7QVi?=
 =?us-ascii?Q?rhjZYmE0MRqjzquwjMEkFqHOcQkrMnwtptDpGjs/1lf6kc3ornulcpeDNIie?=
 =?us-ascii?Q?8Ee77O7gbgrCHHNzkC5gmVsAUnIe5ct4cwpciAADbi6ESbgGaeYEh14M/hcl?=
 =?us-ascii?Q?DtgZpQowEcL7ormwyF6BR/wiFZAvnE4Ax6HNJyogYT6m7Y9e8OQF9uoAD6r6?=
 =?us-ascii?Q?q0HZb9+TkDK7zLOdAYzriu+H/FqZ6RMft7SrQxfbDcm9rNfy/ICqKpQ26Zr4?=
 =?us-ascii?Q?d2PSur0tm4qOHbp00U4JmLeWovHzhd72ZLaykKOSRobiL7+v1SXFirxFemiF?=
 =?us-ascii?Q?lDZWPk5pbyYCAmbBgzgyUwMHfeCIeOhet+nfpY+nI5EKp/D+s/BBO7y/X6rj?=
 =?us-ascii?Q?+NFh561o51AN7bHF2npIOi1qkVR6/1faq3/ZDztPjqhXu8WFw6tbhX1xw45a?=
 =?us-ascii?Q?ppa8kXGkRvTDilnx+q8pWXnNUkZ5MsR6irVVuqc0EhkEfm63sOV3mxN9EexH?=
 =?us-ascii?Q?AzOrbIhGfi2IQpcO1ArcdF6/qhonhzDfQZjwGGM4BTOLZGjgIVsIbGe6EZ/i?=
 =?us-ascii?Q?TbOAzWBHYVHngA2uyX8s4lyxv06aSA73y5iNiiHXfY4DZ5wnCh7zcK4HaSw+?=
 =?us-ascii?Q?+n6AuZVOAmvhMAVmJXI0ja1dKJ3By2SN8L2YATnjInhh6OgoS2fbwd97Bu5k?=
 =?us-ascii?Q?qdJe688vtXAAmJYWNj9U+Bs3zRuX61qYCundXkyxhgCxSDNNYd79tlV6GGOe?=
 =?us-ascii?Q?wV9fk1fNNUwj7A71qIBa56WquqD0ooqtHL+OWIBI?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05d7dd20-bb7b-4970-bc94-08daa44887a4
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2022 07:34:24.8542
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LOrfRwaLqX2gxDpInbgsLKFSWxIyacI/bI+aKH66AC+KTqxPa6D+SS0icjYGm3VEWlcKoQbv7/+OjUL+Pp7ahw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4352
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 01, 2022 at 11:32:52PM +0200, netdev@kapio-technology.com wrote:
> On 2022-10-01 16:59, Ido Schimmel wrote:
> > On Thu, Sep 29, 2022 at 05:21:36PM +0200, Hans Schultz wrote:
> > > The MAB feature can be enabled on a locked port with the command:
> > > bridge link set dev <DEV> mab on
> > 
> > Please provide regular and JSON output in the commit message.
> > 
> 
> How would the JSON version look like in this example?

$ bridge -d link show dev dummy10
558: dummy10: <BROADCAST,NOARP,UP,LOWER_UP> mtu 1500 master br0 state disabled priority 32 cost 100 
    hairpin off guard off root_block off fastleave off learning on flood on mcast_flood on mcast_to_unicast off neigh_suppress off vlan_tunnel off isolated off

$ bridge -d -j -p link show dev dummy10
[ {
        "ifindex": 558,
        "ifname": "dummy10",
        "flags": [ "BROADCAST","NOARP","UP","LOWER_UP" ],
        "mtu": 1500,
        "master": "br0",
        "state": "disabled",
        "priority": 32,
        "cost": 100,
        "hairpin": false,
        "guard": false,
        "root_block": false,
        "fastleave": false,
        "learning": true,
        "flood": true,
        "mcast_flood": true,
        "mcast_to_unicast": false,
        "neigh_suppress": false,
        "vlan_tunnel": false,
        "isolated": false
    } ]
