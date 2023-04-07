Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98C5A6DB5EF
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 23:53:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231202AbjDGVxK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 17:53:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbjDGVxI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 17:53:08 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-he1eur01on2087.outbound.protection.outlook.com [40.107.13.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68C31C66D;
        Fri,  7 Apr 2023 14:52:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TOTeGdph2SoW6cSsVjon+KrDmdgToWd6JnlPmlfCeOEgLKB2SZ3LjKzwta2JIskL0SimlUsms2/X8Xnsw0LUnsJXn98m4rY22ncmS0lvRpSKPlyls6wApnyu2j/eiEpKGcT3NEDYEVa5xEx1QOjEDr+lYwn9vHIQuwW9hONvBpUSUv3oLmT5Y0Rbc58MW0N4vxZpHpljmzEsNyFSo8KqPeBrA8A4rg0IOdzxyS8dHwIO83Z6pYVqcg1jSOGVRCltMJA9IkjHtN5v/eQsL/XtVAo8myVUiMS0OgG7PWJAzFkjrPLtKBWrBv4FA1pDn+co3GRU5qwwmvv2XUO68EKKBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sLQav9PiK85+lIjaaqZVkIph1y+RyBiesr/ppQCnJeM=;
 b=Karw1pZaorbKQbTvknvjq/KZ5qweQOOsKB2+8rIwhieQRT+OU6Eg4B2d6o3NtTJGkcpYVGPGF13oZEGItR0H3DRcv7ZDvhS42ZYSF2bPOw10aSJxPaYef/ULs5kvTxMnK6C06kP4OHQ7p8FOaDlGCrOJYE5kaxGwyifkL/cgo6vhs04teEY8zjeAfy8iAvjL7LJOJBecZg2w9S46HgxFTcbA9eRwIi/S29oxq2xQcv8x4o5jtWpIj6OhVRzSfpEMp+YqaRA1gKvYhgEUndelB4dTnmgKHZBcX5sl72VQ1q978B4/0hvR0lCYvHIIUC5ggYOSBnG2it+ftuKpPB7+6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sLQav9PiK85+lIjaaqZVkIph1y+RyBiesr/ppQCnJeM=;
 b=aETiQlP1ZFUqmCX9Ho8ykS2My1CWBssnIoLbUR0sTMI2z7OnzOC5hLtLRbeWlDvvKmsIHMNE2MTcx0genrcDU1CtxxPjyflT0QNyiD3iBVokNbkjdcfK63mpsf0n5pYu+7IXgryI+SnXEQtjn7DmOztb5rd+yrC8gkfRyFcIwLc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by DB9PR04MB9962.eurprd04.prod.outlook.com (2603:10a6:10:4c4::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Fri, 7 Apr
 2023 21:52:56 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b%5]) with mapi id 15.20.6277.033; Fri, 7 Apr 2023
 21:52:56 +0000
Date:   Sat, 8 Apr 2023 00:52:52 +0300
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Amritha Nambiar <amritha.nambiar@intel.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Roger Quadros <rogerq@kernel.org>,
        Pranavi Somisetty <pranavi.somisetty@amd.com>,
        Harini Katakam <harini.katakam@amd.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Jacob Keller <jacob.e.keller@intel.com>,
        linux-kernel@vger.kernel.org, Ferenc Fejes <fejes@inf.elte.hu>,
        Simon Horman <simon.horman@corigine.com>
Subject: Re: [PATCH v4 net-next 6/9] net/sched: mqprio: allow per-TC user
 input of FP adminStatus
Message-ID: <20230407215252.x3lwkhfp4u6vptxl@skbuf>
References: <20230403103440.2895683-1-vladimir.oltean@nxp.com>
 <20230403103440.2895683-7-vladimir.oltean@nxp.com>
 <CAM0EoMn9iwTBUW-OaK2sDtTS-PO2_nGLuvGmrqY5n8HYEdt7XQ@mail.gmail.com>
 <20230407164103.vstxn2fmswno3ker@skbuf>
 <CAM0EoM=go4RNohHpt6Z9wFk0AU81gJY3puBTUOC6F0xMocJouQ@mail.gmail.com>
 <20230407193056.3rklegrgmn2yecuu@skbuf>
 <CAM0EoM=miaB=xjp1vyPSfxLO3dBmBq4Loo7Mb=RZ5KuxHrwQaA@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM0EoM=miaB=xjp1vyPSfxLO3dBmBq4Loo7Mb=RZ5KuxHrwQaA@mail.gmail.com>
X-ClientProxiedBy: AS4P190CA0037.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d1::18) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|DB9PR04MB9962:EE_
X-MS-Office365-Filtering-Correlation-Id: 25c74c38-13d3-4948-c4ab-08db37b27203
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yyaeHw+7l37+IrgRq+CGcMIVJZcN+6kTBlEDNlxw9xRHDTm6+aI1LpjlNxCSDKul4SNoqqqT3xWL+2rhbv78fk3CLjFpUcDLXGGgVDxJ6djaKlCvU1PMJniDbUO3M7Yf6urQKwaMGFs55rFV5Gnik/UxPlQf8TNqDLQEZXkYu47XkfeGL8gTG2UNLmH6Nh7yi1vhvuY7E7kXUfanJ0YmyIhEZUy7H2eZiRqf0+aTskSKjauPKDYYdJNbToXIC5zx0VdxhW1dz4bEWqocp/FTR1MzmmtERnXTZ9ZuW4wIjuV+jkVEnFON+8XZMaK3UrOL1DfRmouxJGhjVzZvEdsLST5+eXcDBxx8rKirnm5LiaqqiIq9ls6mZ6SpgxFHMWOuWMj0EF8r39NOQHiLLpUPrgQyEhdLrB8cKJAju28jm98n6MuhXn7lRGa2kBULIInAbxPsO5YU9P1hQzLkGrSVZkwZZv4E4asR0O0TBl5vZiAbRzn4e8H/aUxcAw2O3SwmsWJJNfFp1vUKry7fVPbP1eWgfYfrOkbVN0x0pBg+XvtbZjPh3TVIFnz0a0KHZpyn
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(7916004)(376002)(366004)(39860400002)(396003)(346002)(136003)(451199021)(66946007)(478600001)(54906003)(44832011)(316002)(5660300002)(8936002)(86362001)(8676002)(33716001)(4326008)(2906002)(7416002)(6916009)(66556008)(41300700001)(1076003)(6666004)(6512007)(9686003)(6486002)(83380400001)(26005)(186003)(6506007)(66476007)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WqbwqGErpOJ1DZ8zHAfG+9huLkz0MyNgvQtg2ZIVyrw9a9+LQPo+Wvja6fCQ?=
 =?us-ascii?Q?GAub6tobGRxKaFAehEyIH+rPy5H+soQ1iE0yDGvFf10ar/DtT+ScozG8PPih?=
 =?us-ascii?Q?avDrxsXZ70jRLHKE+rh4VWuddG4dJN+pnSkE/kyDLs0dngaHXqDMij8+ZGJ5?=
 =?us-ascii?Q?VBTJcF/AQkI9723LnQz4htdJLtH0akxlkJ0V+0lKO9i2BtFdLwZaORlUY67O?=
 =?us-ascii?Q?UF9arnOwos07I7J0NBK753jKxbS912qjvvrdOCGCdJ3q4kYJSBGeQA+bzm0O?=
 =?us-ascii?Q?SGUC0iIi/AEAvH0pvqFv5185G/8hqwpO8MG08PGiAf22cvT9N7QkljqPiYXg?=
 =?us-ascii?Q?RSKyUAgMvzA5FoDl1eZVihUgpRjWb+0k6nDATdRj2gfyH3GM5Os934kY7px6?=
 =?us-ascii?Q?XUqSfySQc2wEqSbmIJzhxaFX9/Rl0+sNeW+owQQJ6/9Yr0rvxmkAOEqvlUis?=
 =?us-ascii?Q?FPlTJOO5iYH3G+FtJSYvdq0ilNlpaezccppophkm2xZeWCwq3xwRq1P+mfIg?=
 =?us-ascii?Q?ixAluwPyMQFnY6G9uWJoovZ7jlgpojlg6DkiimC5KV+Oyc3onG5dIIMolpcA?=
 =?us-ascii?Q?dYzF3qa147jowtEhiHRJ+2jWC0OvfN44fGZbfMOm9ATFJzo0jyBkSZdjqd3g?=
 =?us-ascii?Q?NIyDG5xleiUAgrnyg80SWlYH3y2zj7UbaD8O0l/wypDTMvADi2cGUUQStRX2?=
 =?us-ascii?Q?ZJdB7Yh5CFaegF3rJU1hVD4sIJ9q0+Rw9jCMRLvod+Z1cxwTwDdSY4JmSsWq?=
 =?us-ascii?Q?w5aUvPh27L0MEECH1BuSssOVbgSJYCCfX3hbviF26fEJRC9n4DYkMx74DvX4?=
 =?us-ascii?Q?uOoR5a/jB3K2q5DkJ7Tu+8G76VVjme5GuNAC+7Prh88Z4RB6CPwczSQOajVC?=
 =?us-ascii?Q?7YdJ+O7N19KQEpiHJWj0LHCE8vLzgS5vG419YNY60AZGdn2CsxUirMCeDRj3?=
 =?us-ascii?Q?ajEgFeD+HUgVjoiyXoua0ZYtDd+FGUbPX/zro4k60NfP+uwKCXSg8L6EQTE4?=
 =?us-ascii?Q?o9vrTCDP35/ZsmEsOS0JTq8zB3pgYqmq8UT16z2UOn5PAuhdvPgvwIqdCQps?=
 =?us-ascii?Q?vwOC2y7o2H6NMaOGmaDCw9xGBNXq5UgUm5g8mr3/pHwA54osr0+YsCHOxWED?=
 =?us-ascii?Q?UiW5WZoTZlh5fw5yLXzW0clv/SWho2uFbxpgO7BB+/Th8EQMKTy/pYv0JBt2?=
 =?us-ascii?Q?clWV/CCeQgty2VNfSutf0nWsnWsrhlDoEPCbH+JmF1mHo39VCgt1qKaJ0LH3?=
 =?us-ascii?Q?oXvWVh/i8eswPioeQDaBXKkW8ZKS1YIEuwsWGzRC2f6L3h5wnpphEUnzC/ay?=
 =?us-ascii?Q?ShumxagpnptLXONbC4IRtCcnC0pnbnO/zEZPUmRGmUceco+NWh4+8G2yoCfT?=
 =?us-ascii?Q?gMzrEsD1XiP3F7qM4IYniuD35RQhhq+ifUh7ggn0LIdnLwwlrODEl5e1Byke?=
 =?us-ascii?Q?kV5BupCpNdpJe3vHYkfYG+RnnYDgyoLqHcpynesD98e5c5STqxwzctQ5CPfB?=
 =?us-ascii?Q?yldLICNlybVrMk58AGro+Lp/glTMqW16HukRoxNjkE98SkbdScDEOiWWp+/r?=
 =?us-ascii?Q?j8q0/uh4WkkBGovDK4scvqPch9nbpvFQlXTItT0PuD4wvJPH9yN+8vtyXTTk?=
 =?us-ascii?Q?OA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25c74c38-13d3-4948-c4ab-08db37b27203
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2023 21:52:56.2955
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z6rryA8fIbLd8/ktJZjU2XuqacHqxDRN2QnvxCkz81PwhWMaAuooPT7GYcwnznEq3xKOB+GPneS8EGgiiezLug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB9962
X-Spam-Status: No, score=1.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        RCVD_IN_VALIDITY_RPBL,SPF_HELO_PASS,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 07, 2023 at 05:40:20PM -0400, Jamal Hadi Salim wrote:
> Yes, it is minor (and usually minor things generate the most emails;->).
> I may be misunderstanding what you mean by "doesnt justify exporting
> something to UAPI"  - those definitions are part of uapi and are
> already being exported.

In my proposed patch set there isn't any TC_FP_MAX. I'm saying it
doesn't help user space, and so, it just pollutes the name space of C
programs with no good reason.

> > The changed MAX value is only a
> > property of the kernel headers that the application is compiled with -
> > it doesn't give the capability of the running kernel.
> 
> Maybe I am missing something or not communicating effectively. What i
> am suggesting is something very trivial:
> 
> enum {
> TC_FP_EXPRESS = 1,
> TC_FP_PREEMPTIBLE = 2,
> TC_FP_MAX
> };
> 
>  [TCA_MQPRIO_TC_ENTRY_FP] = NLA_POLICY_RANGE(NLA_U32,
>     TC_FP_EXPRESS,
>     TC_FP_MAX),
> 
> And in a newer revision with TC_FP_PREEMPTIBLE_WITH_STRIPES:
> 
> enum {
> TC_FP_EXPRESS = 1,
> TC_FP_PREEMPTIBLE = 2,
> TC_FP_PREEMPTIBLE_WITH_STRIPES = 3,
> TC_FP_MAX
> };
> etc.
> 
> Saves you one line in a patch for when TC_FP_PREEMPTIBLE_WITH_STRIPES shows up.

Right, and I don't think that saving me one line in a kernel patch is a
good enough reason to add TC_FP_MAX to include/uapi/, when I can't find
a reason why user space would be interested in TC_FP_MAX anyway.

> > If you think it's valuable to change the type of preemptible_tcs from
> > unsigned long to u16 and that's a more "proper" type, I can do so.
> 
> No, no, it is a matter of taste and opinion. You may have noticed,
> trivial stuff like this gets the most comments and reviews normally(we
> just spent like 4-5 emails on this?). Poteto/potato: IOW, if i was to
> do it i would have used a u16 or u32 because i feel it would be more
> readable. I would have used NLA_U8 because i felt it is more fitting
> and i would have used a max value because it would save me one line in
> a patch in the future. I think weve spent enough electrons on this - I
> defer to you.

Ok, I won't change preemptible_tcs from unsigned long to u32.
Things like for_each_set_bit() take unsigned long, and so, I got used
to using that consistently for small bitfield types.

If there's a second opinion stating that I should prefer the smallest
netlink attribute type that fits the estimated data, then I'll transition
from NLA_U32 to NLA_U8. Otherwise, I won't :) since I would need to
change iproute2 too, and I'd have to re-test more thoroughly to make
sure I don't introduce stupid bugs.
