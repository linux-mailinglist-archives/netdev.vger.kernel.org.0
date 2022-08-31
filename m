Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 859235A7532
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 06:36:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231801AbiHaEgv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 00:36:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbiHaEgu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 00:36:50 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2061.outbound.protection.outlook.com [40.107.94.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB81FA926D;
        Tue, 30 Aug 2022 21:36:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mzmlPZsYIiHsCcPOH85Lzp4F4uQy+qiRs3MWth0FYQS7KQZvaJLYXabvvVOGxQCszMjCntykAfjir/qOQa20Jxhj5PAbeFwtyPQj919tTBgkQbRsQZRerC/5q2wRoHdwgN89mApiutk8W0idUJ3pnD0MILIFCC7GlP/RhsOQvw/qKiWx+AhTr+GfYrx9hYOZmbB+QJO9+RsUxE2AdqanAP6OQwuBT3M+uC8yIv4+T9Qad08BVgPxQU1ux4b4W6KRdsNt7+ysbQywaxAEg0NL9fwXdQxVxO81WewoSMHsPRvAi2jRRnG60Geh67odnarvk58z+EeA8z432jJMqnjtOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+OzHKPNx/sV3yc1NZLWd+K9tWWqX99vCYcOdHRcVJvY=;
 b=IN5OIEik4fM9CnCIZFsREsBVPc3WEvZMsy3PcG9CRjq1sSOabsj6OHMElV95YJCRmYf75VFAvQIBy3cbdEJJzD+vehpBn3Vr1s+jxYgwNPsz7xJwSY4/nW1LZ/3Us+v4eGHbkd8OO6Nym0Fr7uhfnvc9Qbjw7qQYUm8TfAYaunUSzzEcbFyVZlaGgKSXti6hqVA/Q2mx0//XpScK2EtSCs9CApYCQWzAlc/zYIQXKQiHdDvgvQrPXpP/hhRWVJ9pikW7lWBVB5GzZC7Jv3+c9hzbeuH54HLJtV8FnvbSmWEm32XhtenYipWy7aksEjvoCA9oatPNBfJURSTlaCkl9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+OzHKPNx/sV3yc1NZLWd+K9tWWqX99vCYcOdHRcVJvY=;
 b=Jec9dnd7wc1/RCYqkBuVNAfZZvFM2Xx9lQ/5S7cscjjQ6RH0XQ3WnuCbZ+G0FvJ/jM+mh7oQBkOFCQjmhUL7iA99nBAflrLPK9q58Oukib453oB16wFfptdAgWj2sA9vRQsVrYwv7oXsl53MqJlBCByXHPzitXpMCmTw27jdm4sfYtDVHPdQRVNPPBePNRKi+AS5tkorGa/QEvYkaeAm3JhOrnn5tT6ubZn1uvmDxDIU1cQooaHABiKZV2rQYyidymbMP/nbG2wiwt2wLWljRvhZSJxvUZvW2h5maLFm/xjYe3cnpf7SM7QY+N3KZj1IEW9aHnJURDC+CEZMDenkSw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4373.namprd12.prod.outlook.com (2603:10b6:208:261::8)
 by SJ1PR12MB6267.namprd12.prod.outlook.com (2603:10b6:a03:456::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Wed, 31 Aug
 2022 04:36:47 +0000
Received: from MN2PR12MB4373.namprd12.prod.outlook.com
 ([fe80::51f3:15f4:a31a:7406]) by MN2PR12MB4373.namprd12.prod.outlook.com
 ([fe80::51f3:15f4:a31a:7406%5]) with mapi id 15.20.5588.010; Wed, 31 Aug 2022
 04:36:47 +0000
Date:   Wed, 31 Aug 2022 13:36:42 +0900
From:   Benjamin Poirier <bpoirier@nvidia.com>
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     netdev@vger.kernel.org, Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Shuah Khan <shuah@kernel.org>,
        Jonathan Toppins <jtoppins@redhat.com>,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH net 1/3] net: bonding: Unsync device addresses on ndo_stop
Message-ID: <Yw7lWrDODpu5pwDR@d3>
References: <20220831025836.207070-1-bpoirier@nvidia.com>
 <20220831025836.207070-2-bpoirier@nvidia.com>
 <195900.1661916353@nyx>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <195900.1661916353@nyx>
X-ClientProxiedBy: TYBP286CA0006.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:404:ce::18) To MN2PR12MB4373.namprd12.prod.outlook.com
 (2603:10b6:208:261::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 62f019e8-19ce-4e7b-8067-08da8b0a69fd
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6267:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CqSqVof37I9lOK38wyWPpbpKBC90eSG80foeOTwx+jvjRQWeLge6KqiPdhz3THNycl3A9zcYUaoCiD2Trescel407qxbBZDuh7UWx0UFVk/NixS8cskQHxh1sz3p4aY574x5TBoKRpe1vDCQy20LJTRusLPmkCou9I0ktmZXEsTUwmWlXkeiN3E3VQW87I8QccaCXEgYdZdxSusI6IZoSGhRRz7zqiUujxG4FyobH9ijrI0SJHad/CToO+LOxXZha8XbyHmEmudu15YGwLMcgS+EUwve/hkV/Sj6tCw7ZedEBjHFagJlGeqisj7iLRzTJ0HfRLNtYdnCqxPRRd9Ok3c4PEBjeeQG0wMO8B8GNvmjxaKhnBeZFt3ZZyFTprHgOfG403VFRh1v4CVyQP27W/546LNhG2Atqm2Dn92Zefm76D+esuKKtVX15aziQ3CAQFOPc1PSzPXJVqJAvfqINR2BC6sqi6Wv56BpV5BZpXJdU8bEwRgOeq8rzItjX+FjVgpoJMwAA1iqE+1uP8FtfxiI70UCvIqR/3QwsgjNRghl/z519GZQGOgNWm+0+Be2naQK4karjww32z0mswSK940erPRbQd0UaxXlV7fhQ/5Gpj7a0dtWpR8vy2vpICXV/uTAR4UetV4o6qzmVNC7WEKPqMqm38lfIrgm4EPbw6iqZk2kM6JieE2ATcSrcoUN3Y1s1mdjQwrphDvEVofZ8Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4373.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(376002)(346002)(136003)(366004)(396003)(39860400002)(186003)(33716001)(4326008)(8676002)(6916009)(2906002)(86362001)(54906003)(316002)(38100700002)(66476007)(66556008)(66946007)(5660300002)(83380400001)(7416002)(8936002)(6486002)(53546011)(6666004)(6506007)(478600001)(41300700001)(26005)(6512007)(9686003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?80V9gWji4d3OjLEUZ+VR9Ey8oPjIr9XStVhjPwljfM2z7MDadVOzmaZep+qA?=
 =?us-ascii?Q?DcHakm91pA8+15Abx3914GpYvVmvZ2xQfsWyqdUTx+D0y6GPHbpndG8HySvw?=
 =?us-ascii?Q?9iwv2ZKb8giY/7bZ2vAjQS7213DMkjd1SW+TTccUq/iXQruyy09nFp9DZZht?=
 =?us-ascii?Q?FggCBB3BSPU+dw9KbX0FwxzAHhEGW6priekF5L97mxxX6IC3NJKg8exRFtrU?=
 =?us-ascii?Q?MHGjDb405LQ0QCkXYnYr38/WJs+AV2dCS/0dpyiajtrUbjVvotEHFlV3g+Ui?=
 =?us-ascii?Q?0gMyUFd2p3N5rr45/k4XsTUVDxMqRw34I0aRhAcmYUQlyOVnNu+87jRC45k8?=
 =?us-ascii?Q?JKhJfQwltGJKehUS5gyOoAD6Fg6hPLH7bIEdb+IXmd0moh4EdKKC54VG7/w0?=
 =?us-ascii?Q?YwMBUCiAJ4Mcp+gsXz6fVeVpJmI06fpVU5x3kqOjSLDTrfv+y5g0AKkyUwLT?=
 =?us-ascii?Q?2HscNxUB9dxotXFNUERjrK/kiq6PE1kTGH/Pu4NkgZEcnJyS3bqWk3hY2Brv?=
 =?us-ascii?Q?OajJImAyRrSSipwhHgeWzLwPXM0ltn7eqhJkRoVhQoNfSkOrPGuafTt4i04C?=
 =?us-ascii?Q?kZ9bjFl4SW/GASw7mWKjP/MREAyUdEcsH32+ckwjspYFhgNwWkkM/Ev3thJz?=
 =?us-ascii?Q?h+x7dZLvA65ZhQdx8ly1nG53sUcX05HcIv27Dk+4tET3BAPrVb/X55CXrUy1?=
 =?us-ascii?Q?DB9FrfWfAmvI+q9/4EpiVW1548WxjVQAzPZNqq83+tOElUSFxUiLKrI+pJOe?=
 =?us-ascii?Q?evcH6yd9RsHRzEn8D6HVVtpfj7H9xSC5rfZQKuEEbBKHrnVfFYOYPBQeiBvg?=
 =?us-ascii?Q?63DW4cyjNp+CUI3wEovfSgP4zpHAVG0hjCEe+3LvzVzioK7tQ7+S/OAvkVe8?=
 =?us-ascii?Q?MWQnWZ35w4R+1TV6nN1N4hMOOB+VcEsSuoyk1Nyuo8ItBBcYsf0M4UE+yAWU?=
 =?us-ascii?Q?5Kj03M4KaeXqHyyMkTvNNVNAei+C8eysiUtvBIxjDemKdqVkjs0x5I1pJpbC?=
 =?us-ascii?Q?loYtHY2yO6p6YaMIeM41+Q6STLOPuQe/AlOGtOOjHDuwICKC/O2X1o8q3Q9j?=
 =?us-ascii?Q?OmYoJyu9WAzvc1y9RVI4QqoU1Cvvakr7BPB6DJa7oWUxBI24cSyZqYrr+IQd?=
 =?us-ascii?Q?xWB8dd1ObJjEUCw2JaSg/FYi5B/LD5D0i+Yx5qifLv3YP99FShKUu7CzRiNh?=
 =?us-ascii?Q?uC7JdRbUZs1Lrs/et0BWFZ+k+adbveT42BjQWiZ60dhDQQoKPVwlN+ZPRpPN?=
 =?us-ascii?Q?ef1kZpR5gJA+bbVoKqdEFJekrU0chv+soRnHu7mCDqY/S+GTckrTN6sApv73?=
 =?us-ascii?Q?Y0LaABNeVLcuKFVrfiYk392zN781whVuPkXyQUJ1VeMaG/+eYJU3uRV/jz1d?=
 =?us-ascii?Q?nCaYE0BNQQvjsy7KNKci78HVTG0BvXFnlown/3flyMgjeuVqjjcFGl74Mqzj?=
 =?us-ascii?Q?dRUTUW2en0lwuP3PHIX2cKKQgiCdlRQOGhLWVx6JlVdhI0BSJhrfC6jiVEN0?=
 =?us-ascii?Q?iw6tIf0GN95D+nnXRpJzd+grbFeoOJYjFYx/qlFIq7LzwpYQf20jRSmqTWZn?=
 =?us-ascii?Q?9yGHLIBbRj33zL+ycVw1NixLqdMI0nOIan3aP/umcpO/6NR/888byq34OoYY?=
 =?us-ascii?Q?Yg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62f019e8-19ce-4e7b-8067-08da8b0a69fd
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4373.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2022 04:36:47.1751
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TBXL9T/QctEO3vtsle5CmZXud03OshMz1Z4uVhDcbBpOEu3e+Qsc2/hCkU+VKhYxm33wcuzLj8l0+vaZKX47QA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6267
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-08-30 20:25 -0700, Jay Vosburgh wrote:
> Benjamin Poirier <bpoirier@nvidia.com> wrote:
> 
> >Netdev drivers are expected to call dev_{uc,mc}_sync() in their
> >ndo_set_rx_mode method and dev_{uc,mc}_unsync() in their ndo_stop method.
> >This is mentioned in the kerneldoc for those dev_* functions.
> >
> >The bonding driver calls dev_{uc,mc}_unsync() during ndo_uninit instead of
> >ndo_stop. This is ineffective because address lists (dev->{uc,mc}) have
> >already been emptied in unregister_netdevice_many() before ndo_uninit is
> >called. This mistake can result in addresses being leftover on former bond
> >slaves after a bond has been deleted; see test_LAG_cleanup() in the last
> >patch in this series.
> >
> >Add unsync calls, via bond_hw_addr_flush(), at their expected location,
> >bond_close().
> >Add dev_mc_add() call to bond_open() to match the above change.
> >The existing call __bond_release_one->bond_hw_addr_flush is left in place
> >because there are other call chains that lead to __bond_release_one(), not
> >just ndo_uninit.
> >
> >Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> 
> 	I'm just going from memory here, so I'm probably wrong, but
> didn't the sync/unsync stuff for HW addresses happen several years after
> the git transition?

Yes, you're right. The bonding driver was converted to dev addr list
functions in commit 303d1cbf610e ("bonding: Convert hw addr handling to
sync/unsync, support ucast addresses", v3.11-rc1). However, the problem
fixed by this patch ("addresses being leftover on former bond slaves
after a bond has been deleted") was present before the conversion (at
least for mc, uc was not handled at all before the conversion). Since
the problem was not introduced by 303d1cbf610e, that's why I chose
1da177e4c3f4 for the Fixes tag. Does that make sense?
