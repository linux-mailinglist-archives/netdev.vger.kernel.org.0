Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64E91595EE5
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 17:20:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235921AbiHPPUW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 11:20:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235857AbiHPPUU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 11:20:20 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2098.outbound.protection.outlook.com [40.107.244.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC0273BC;
        Tue, 16 Aug 2022 08:20:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GEkpcMhSWtP21mJmyT+drCw3HI6MHdHpTtgon/2+tXIT1/VKyf8u19GW0XTMIDIU1Qi4X+irJl5wHdfvx1r5HxEqqKT7TlwiC3v4PfN0z6gYbAN+kpUItLjCcVEFecpmAcQXwozq+IUhPyoDGofpVzTPqBwq53KTpzgS7fQbA9mQ1L979JdekhM1va5+ISYYfY1DS2qg+91k7q22MngVkDwZ8DD60999MZnN2deBP/Mhs09C7Sn9l7uJOMqITJaeZSkoZcQCdk1BfN9e3aVfwMosAOovoVdu7283IUBEL2t/eU8fVl8l9vtoXAXjDAZJKoFLpzXJuXleAecO7ghHZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cn2hjlKSvNOv6PQq5KWRuzMwaO44AFNNd9ytEJxi0kI=;
 b=A9vT6L5/Q29EE6H+on7aGAZsq3K5ldCQtQ6ynABfPtv1MqytoCDoyY3CdOPul1UC/RxDM/EoSFfU+0smXJQHzpf7X5yN7+YShQPRRAuZivArhcM2jhEEkcTz559hKTyXhhJ7CVpDo/U9X+Fq83a96pQxEbzs5dkhyE/yI9e4OReWjy/8nxFrOPD+i/56npSOQShBMwrCEkbrV1INQGFlDBz6lSbHyhCXg8ecBNqYhIZNzcmIiRybRaDWwpJ4pvNh8hLuvPMdTCT7C+DioUY23erYy+O6UuZT+UToHFF/wo4ahheUTSUqlXgsXskGp6V+J+eKdD6AXLzuxzibHynblA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cn2hjlKSvNOv6PQq5KWRuzMwaO44AFNNd9ytEJxi0kI=;
 b=nM6f/JDDg1pCtYeyRyCVQJUB1y3WrOR/dgh9x8j++cETwdP0bpgwxbcl5CkDSb9Q9cGl6k3gyv0llqE3EmQfSovRcdcspq5yN2sM20Fawof10MmvO4T54vmn3caZShLkzfdsGoetco62nT0dnjn+0NYx1qWqJH0wO333yJndxv0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by BLAPR10MB4994.namprd10.prod.outlook.com
 (2603:10b6:208:30d::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.10; Tue, 16 Aug
 2022 15:20:15 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b869:6c52:7a8d:ddee]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b869:6c52:7a8d:ddee%4]) with mapi id 15.20.5504.027; Tue, 16 Aug 2022
 15:20:15 +0000
Date:   Tue, 16 Aug 2022 08:20:10 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     Ido Schimmel <idosch@idosch.org>,
        Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <ukleinek@debian.org>,
        linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        Terry Bowman <terry.bowman@amd.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Wolfram Sang <wsa@kernel.org>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        katie.morris@in-advantage.com,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Lee Jones <lee@kernel.org>
Subject: Re: [PATCH v16 mfd 8/8] mfd: ocelot: add support for the vsc7512
 chip via spi
Message-ID: <Yvu1qvslHI9HIqKh@colin-ia-desktop>
References: <20220815005553.1450359-1-colin.foster@in-advantage.com>
 <20220815005553.1450359-9-colin.foster@in-advantage.com>
 <YvpV4cvwE0IQOax7@euler>
 <YvpZoIN+5htY9Z1o@shredder>
 <CAHp75VeH_Gx4t+FSqH4LrTHNcwqGxDxRUF26kj3A=CopS=XkgQ@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75VeH_Gx4t+FSqH4LrTHNcwqGxDxRUF26kj3A=CopS=XkgQ@mail.gmail.com>
X-ClientProxiedBy: SJ0PR05CA0036.namprd05.prod.outlook.com
 (2603:10b6:a03:33f::11) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b999a858-1869-45c1-e125-08da7f9ad1ee
X-MS-TrafficTypeDiagnostic: BLAPR10MB4994:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tKxCloctvN9ejTXR7yRvQ0YICAMZ5UbmJlleJptUhqQIZt7qWlv9uShAbuxpHq++91I6Due5Fy8Hs3YMQUPEwvxjV3yGGzqArP9Lj0caXjv+XQxeASOLMRPCF7Nz9apTVA5nA9CDtSIdy3GNJCZwJ7CP7/oQyFhEIw/0VZ+GkgOvjCrztRbdotSkzck+u3KPDGaiLSPcKnk88EEZsZVNN8EvTSgr4lHOj1fofDP8f+ioG3moYirkQR8iIr5VfimuBw97XWUl+mpG9Mj9XVrzp8uoMDSZKc3Dk7NIPsmUcprXNJU+snbN5es458s/274DB3NBhv73hFp/7/wlFdxqsrb1qOEGd3EzhvthNaFI/+4FnwzhAgOPWibl5jtqp1PG6qPD8O25Oj1KtOXZ0TVEuf0al1GibTZthMXgjYBMWI7sahsU5Yr2dthLQMVhGoIqxHVJ3iwkNnH6CJlz0zOf/uE2RCpIlU/pDKZTisr+grVisuRVAcyYOPSM9uhtBbPA3bVYhW7thDF7p6E4QDwCukrYwy71t0w1+WmVN4G/1MhMTUCRsdhKEDxiHWykJT6jYokgQO3TXjCoJB2R+BulI5PyDIKhc/cPrbeoJZiSURROJOX62fYKxV63p3vYZp5VkgHC7/CKtxisja2PuqpA+3tG6lO7806VFtK3YU7eSFEzTqn6IY2SW1f+xjtuMVxU/jkcNyD76zmodj4Vb/2HOYW/1+FnBXPayHxJFMV5aLK0PAKkpOp1e9UBktQhJaNzhj5AuBzzp6jtN6jfkwxZKA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(39830400003)(366004)(346002)(396003)(136003)(376002)(9686003)(38100700002)(26005)(7416002)(966005)(5660300002)(66476007)(6512007)(86362001)(6506007)(478600001)(8936002)(6486002)(53546011)(41300700001)(6666004)(8676002)(83380400001)(2906002)(4326008)(6916009)(44832011)(66946007)(66556008)(316002)(54906003)(186003)(33716001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8j6Vl7MTgiJcE46O+rrkmIo2lCEUl3ykKT9N7MqJHWF6UrodMuVQfDhR0sxE?=
 =?us-ascii?Q?i6c/75XVb3whfMtz9WwP2agf5/bbrgNKDseDuWnLoHZhVYFQxwf4gUOd/GIL?=
 =?us-ascii?Q?Fytr6LMiAdVQf9bS90NDU4bLi9dTOtG1De/CAsOItlNfUyEvz6RNSw4oHVAo?=
 =?us-ascii?Q?/ejFBgl+61cCd3BTIm5n0XKukWOEQPxfhkuxioJA/Qtrw1Yc3H6ClvGF3DLG?=
 =?us-ascii?Q?AGh+LRxLlxC6WkRTPrfGW7lf4TnupCdSSHrZ5Ps0DH6Wl7Ef89eaNj/i+KCh?=
 =?us-ascii?Q?Zux8InMT1yqZdf4GvuZBHOePf3/joKC+5AG9okJKXERAKwvY4MLcFbAc2vQR?=
 =?us-ascii?Q?kQ13GmID4iXWZc+0pEbaudwLxE8XBvqbKQq5GUjvpShAwg+4BiDhSOcGPS5U?=
 =?us-ascii?Q?lC1ESFpWV+j45EKy6bMXIO7Q/pEvEKon5iRbUULmsNpMysW1zx9z1zwMV22v?=
 =?us-ascii?Q?sssNiSBEw8S5yA+DVVWGheP83nlggpclcSm7Q8QOlye4+G77gicmHp/j8bOr?=
 =?us-ascii?Q?rs4PfqYaMt/6M7GvfKRpZlDAAx8NUpF2OM7Cg7KQislYWkLPoXSgR1w1h433?=
 =?us-ascii?Q?nwC4yjj5QtEta7i0lGJG8AdHAquXXWMSAoe5Nfu4aBoIRjp+uT9G8FY4+Mx/?=
 =?us-ascii?Q?iNrGBmBWB7qv9335sMznrglJ1jEXWorGSuUXNsuHMpo52Suc8UqaQK9Lxa7D?=
 =?us-ascii?Q?KcYWaXviuTP+pDz7EOBn8PZYbG50HCV4Y31gNrbGwgkKbt6mbpVBguK1Lmeu?=
 =?us-ascii?Q?dXcueYVJk5JpCQ8jBJctQSdh1m9oqslBNBsOBU3MUFyfYxqi/9wOPH5ad8JX?=
 =?us-ascii?Q?kzGbXVGbcjyzSmfbPiqpHV6MWMmel/Uh+eLHuW+cWh2erwQigBoNWOSRXaOY?=
 =?us-ascii?Q?sJMsMN/J2KQlOsU9RgApEOWBtjzKJa8oltZKWdPpu+KnkAmhA75/J2AHIXSO?=
 =?us-ascii?Q?C31f0mC3xvd187XD+fRarG4sTSwwDfhRhZdcPVI3nzJ5WMKXk8NvRLeHFvaV?=
 =?us-ascii?Q?KSEDHD/d8HtMMFA4MGlL2dBO6Bpc0SBjUsx7LaDvR4A5uMnHOgnQVYCpGSN8?=
 =?us-ascii?Q?GQWlKrWC+C4Q4yeOSwicl0LMTjNVBayjvemQKRbBP/6U9u1h93tFLo3BmMF9?=
 =?us-ascii?Q?UGTiYtx9CKOQAHTF4rNDacVhkjYY0TKpaobQqNOvaOokszjhBQLj8JM1PsZ2?=
 =?us-ascii?Q?aCiBkMIf+tyOvApjgGhBToIWhQ5NAM1qCVxh8a/O9JS1PW5fZH0ed7nDQLd+?=
 =?us-ascii?Q?vRpnh+bEPX+7PHeWqIZh/A86A4QpPhty0m3c4ZAELDi1s1Jj2rvz5bY9oKtw?=
 =?us-ascii?Q?DdX5zdy3nS04QXnDkaeOrFcgs2aZYiX8pMr2G8GrFD/OexWYjsw0jv7SwOXE?=
 =?us-ascii?Q?So1ymR7KIYR8pO8IJDF1Fqr6paIDOjst/apZmovPKz/C1HDux+eF8cB0+ma9?=
 =?us-ascii?Q?o9ufQC/f48Lgu14E62NYituxKLxFu4Iml7raWeqNHTNBN4+3ZuhWpdSyw8xO?=
 =?us-ascii?Q?2/3dOvCgcFArYEBc17/9c4Orc96VDenWEjWh/8gRh5d4cWxf8cldg/uzDUPg?=
 =?us-ascii?Q?WF92ECO4ZeJOfAjhFiiDzbjkDdljJUxRF1qX9ya7VB90JgtMhwbl5SC0qc7q?=
 =?us-ascii?Q?/A=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b999a858-1869-45c1-e125-08da7f9ad1ee
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2022 15:20:15.4349
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: osholmrSZhtng+YIJdykvXMpAABkld8RpJD4L6B5Y1O2f7b/onlSuewPKxjj5AY6wFWDB2LAPmLu9AYVv2dDXfhAsf2gkUQ7cSGW6tZ/sbc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4994
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 16, 2022 at 11:52:53AM +0300, Andy Shevchenko wrote:
> On Mon, Aug 15, 2022 at 5:35 PM Ido Schimmel <idosch@idosch.org> wrote:
> >
> > On Mon, Aug 15, 2022 at 07:19:13AM -0700, Colin Foster wrote:
> > > Something is going on that I don't fully understand with <asm/byteorder.h>.
> > > I don't quite see how ocelot-core is throwing all sorts of errors in x86
> > > builds now:
> > >
> > > https://patchwork.hopto.org/static/nipa/667471/12942993/build_allmodconfig_warn/stderr
> > >
> > > Snippet from there:
> > >
> > > /home/nipa/nipa/tests/patch/build_32bit/build_32bit.sh: line 21: ccache gcc: command not found
> > > ../drivers/mfd/ocelot-spi.c: note: in included file (through ../include/linux/bitops.h, ../include/linux/kernel.h, ../arch/x86/include/asm/percpu.h, ../arch/x86/include/asm/current.h, ../include/linux/sched.h, ...):
> > > ../arch/x86/include/asm/bitops.h:66:1: warning: unreplaced symbol 'return'
> > > ../drivers/mfd/ocelot-spi.c: note: in included file (through ../include/linux/bitops.h, ../include/linux/kernel.h, ../arch/x86/include/asm/percpu.h, ../arch/x86/include/asm/current.h, ../include/linux/sched.h, ...):
> > > ../include/asm-generic/bitops/generic-non-atomic.h:29:9: warning: unreplaced symbol 'mask'
> > > ../include/asm-generic/bitops/generic-non-atomic.h:30:9: warning: unreplaced symbol 'p'
> > > ../include/asm-generic/bitops/generic-non-atomic.h:32:10: warning: unreplaced symbol 'p'
> > > ../include/asm-generic/bitops/generic-non-atomic.h:32:16: warning: unreplaced symbol 'mask'
> > > ../include/asm-generic/bitops/generic-non-atomic.h:27:1: warning: unreplaced symbol 'return'
> > > ../drivers/mfd/ocelot-spi.c: note: in included file (through ../arch/x86/include/asm/bitops.h, ../include/linux/bitops.h, ../include/linux/kernel.h, ../arch/x86/include/asm/percpu.h, ../arch/x86/include/asm/current.h, ...):
> > > ../include/asm-generic/bitops/instrumented-non-atomic.h:26:1: warning: unreplaced symbol 'return'
> > >
> > >
> > > <asm/byteorder.h> was included in both drivers/mfd/ocelot-spi.c and
> > > drivers/mfd/ocelot.h previously, though Andy pointed out there didn't
> > > seem to be any users... and I didn't either. I'm sure there's something
> > > I must be missing.
> >
> > I got similar errors in our internal CI yesterday. Fixed by compiling
> > sparse from git:
> > https://git.kernel.org/pub/scm/devel/sparse/sparse.git/commit/?id=0e1aae55e49cad7ea43848af5b58ff0f57e7af99
> >
> > The update is also available in the "testing" repo in case you are
> > running Fedora 35 / 36:
> > https://bodhi.fedoraproject.org/updates/FEDORA-2022-c58b53730f
> > https://bodhi.fedoraproject.org/updates/FEDORA-2022-2bc333ccac
> 
> Debian still produces the same errors which makes sparse useless.

I haven't jumped into this one yet. But everything seems to be compiling
and running in ARM.

Do you think this is a false positive / unrelated to this patch? Or do
you think this is a true error that I did wrong? I haven't been around
for too many releases, so I'm not sure if this is common after an -rc1.

> 
> -- 
> With Best Regards,
> Andy Shevchenko
