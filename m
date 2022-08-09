Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84EE258D657
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 11:21:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239090AbiHIJV2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 05:21:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241268AbiHIJVK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 05:21:10 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2068.outbound.protection.outlook.com [40.107.92.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3E9323174;
        Tue,  9 Aug 2022 02:21:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YqY1psh/eQ8q8PuUGJVsez6EwtJvkES6x4hS6ZltYuZuTCEe2a3SHw0xHzSoYl+dxz5sgTSKWh/6foV/Io6k7nqCqYgfH+UaHrlwfCtGM5RiyApFeK7le/JcDstwIidsWdt84PW/kc7ELEcWCAsbkToKxK09dPl4evSVkpSjHx3pCHdWP5bVbEIemjA6eT0TzGzCv7R/fyhcDyeMjjqybcXhiXxpEUed9ZGifQHnajo6EfRtXmSM3g03HCaoyfyXIZ/ac2oRoFDLfO7giVkcF+cUDjA6kqBRos82VuEWMuydlx93FxZXt3fggtx5tu0KNfeUjWZuozNiJ13NGN0o0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=43aqpcNIYFz3QzNCa4K6nZo4D8in/o5cheQZTbooLHo=;
 b=NJFw8GEBJi1ouDBz2IpXj209yxAMx2zFm1LD3XYj2mCBI1hBZvLoKmtTjCmr/T7MLe7LMkOI1vPTMcv8SpWxE9Y1u+T/prOlqU/adrcJRcqP8mLrtL8pAWXzlpjt5e1bzD04JaTUEShs6bAG53shQlc2ItWyOiJ5IDyQiBWz/W8LQSl2ScovBldlx7ftMWfEDnq1GCeOVKbl7pz8lFwNQiOhuCCT6QHeCP3pLbRV69xVrbh3qDpDK5twAVeLtdceXlIiSXAYuq0R7k2sPpDs0dnLTvF5gZetWCsDPqitzZsRlH2WB0ViyYvXVzRNlpYoLIpaVDHrkTkDcDcTUKx2Jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=43aqpcNIYFz3QzNCa4K6nZo4D8in/o5cheQZTbooLHo=;
 b=C1+7kppzrN6EqgnISDPR9x0DhXRADM+zSxEPPv4xLt/hFSOW8sjFHnyONWAc/3QcTPFvfMw6++AUHIEHeFh3olnzNifJj6SRDC3CnD8pjVY5PlHdcoVvw4IMssjeucKo1fAZORons1LhuhDeWELX+jXuP1s0XS905QzW4gcHo6ePO51JfQgkW7iFYsVQL0XLOISsDbLBAcCBpmmYxK5/FdeSgpUpLsuFkhwIpYv26dgK+EVn+PXPQgCYsfgPteCj+NsvjNi43v4tN2x/yM6ZXA7+ZZSi7qm+j0f27o7l15l/iMXiVumgVPs4bXkaLEXrCmmz7GgP0fPOnwk4OOAEhw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA1PR12MB6163.namprd12.prod.outlook.com (2603:10b6:208:3e9::22)
 by MN2PR12MB4110.namprd12.prod.outlook.com (2603:10b6:208:1dd::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Tue, 9 Aug
 2022 09:21:04 +0000
Received: from IA1PR12MB6163.namprd12.prod.outlook.com
 ([fe80::a52c:c6f5:f9f4:59cc]) by IA1PR12MB6163.namprd12.prod.outlook.com
 ([fe80::a52c:c6f5:f9f4:59cc%5]) with mapi id 15.20.5504.014; Tue, 9 Aug 2022
 09:21:03 +0000
Date:   Tue, 9 Aug 2022 12:20:56 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@kapio-technology.com
Cc:     Vladimir Oltean <olteanv@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v4 net-next 3/6] drivers: net: dsa: add locked fdb entry
 flag to drivers
Message-ID: <YvIm+OvXvxbH6POv@shredder>
References: <20220708084904.33otb6x256huddps@skbuf>
 <e6f418705e19df370c8d644993aa9a6f@kapio-technology.com>
 <20220708091550.2qcu3tyqkhgiudjg@skbuf>
 <e3ea3c0d72c2417430e601a150c7f0dd@kapio-technology.com>
 <20220708115624.rrjzjtidlhcqczjv@skbuf>
 <723e2995314b41ff323272536ef27341@kapio-technology.com>
 <YsqPWK67U0+Iw2Ru@shredder>
 <d3f674dc6b4f92f2fda3601685c78ced@kapio-technology.com>
 <Ys69DiAwT0Md+6ai@shredder>
 <79683d9cf122e22b66b5da3bbbb0ee1f@kapio-technology.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <79683d9cf122e22b66b5da3bbbb0ee1f@kapio-technology.com>
X-ClientProxiedBy: VI1PR0801CA0072.eurprd08.prod.outlook.com
 (2603:10a6:800:7d::16) To IA1PR12MB6163.namprd12.prod.outlook.com
 (2603:10b6:208:3e9::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 90da7f63-5caf-42af-b56f-08da79e87b69
X-MS-TrafficTypeDiagnostic: MN2PR12MB4110:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3MKIShftrPDRd4e/Pqt7xYVk/RvFIWXoWExU31Z7mA1UW/JH+tctg54qA01POJkDHig/aE3Yb1D3HXm5y9vUnA0QgxArehqVLEpccu55uYPE23rPIZPuuzxWWvZAkWtEziEH7kPKwiT5jJ/WwK51rPydejRjo0WjFZq1wwbAJBL+wjZtdQ/Z135uOn0M44c0vOojeZyKL9dH1gXCM+jVGMlMmiYVzMT6Qs/30MVdnmWvwn4YEembvB7y4yXtPuC0gSIHMrIr7U50QxEtTpmI5zh1W7OBAyT4YN0yMzDBp/IRhOTSTv/qd/Wpm2sTMEYZL2FO8SAbC8t+mxGR6CsZsI/TfEp+IYPWZLhOyh8uRe5wMyBu/4Xb3Z70yV/NGLIkcDH2WeUI5jMsu8Hcqog6NxWzKPHHK2PtpcmweS2EL1UbhWNC2XkUmXb8HeggrhzxtWg8KkagUrPFunNV4e6/hCZbNB2Ci5EGVqvFrvoIaxZ2CpSmL2O71CVJRsas4QT3Nh7L43Nb90P32EEx6udsD09laFqqSKAL6Ct7gGquX1Mk0kmN9yPMcnJDmG2ps8VBMADosyU/m0hWQ3XdxsrZ7iItghD7MCi+zgBRdWQQZpX/m5+rSZtcCFnGnbjuax18ZxDCSUv8AXHS4IOAgRQRkPGpwfHnLz/G6kDLuFtl9jr49fSwQnAT3Ig3rhIGf9WBgoNVYx/uY0UktkbuN19XWwqCnWFdR3FJS0eP96t7qZYZ29OuFjhsKRY3rHgMl3sCOf34EDl/mjxP9pA22XDhjh661slh2EY9pF45bsNI5ECwZeOVzvzjKx1C4whyKt6yIUZqYvylerMLzLfPaswtAo5Xg+qbd5szSN8qF8sBfamKq/BldLPeoy6qwGu2B+1F
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB6163.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(136003)(39860400002)(366004)(346002)(396003)(376002)(7416002)(5660300002)(2906002)(66946007)(966005)(6916009)(6486002)(478600001)(33716001)(316002)(54906003)(8936002)(41300700001)(38100700002)(9686003)(6512007)(6666004)(53546011)(6506007)(26005)(86362001)(4326008)(66476007)(8676002)(66556008)(186003)(83380400001)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GnDu9eizY+9urTKLzU4mANW0oW6ACfVZwTVmRpz+3cCZ7HyyXhLIWx++9153?=
 =?us-ascii?Q?4OWQctZt07QRUpbTXMnwzxEFQfh+mm0/QADepj8AVTeNFx6XilTrNSduGqmV?=
 =?us-ascii?Q?OUDPF1nnSPGIVem+p6Jjcs7ea5CB8VYa28UWDfovW3A6IOs0Xm/uJopdoo6v?=
 =?us-ascii?Q?ndvhAfxcZ+Beg6FKK0k6RMAKJz9nEkDLRPhMANfzFsu8UA+17nfWTKGVYQ8q?=
 =?us-ascii?Q?2lt2JnmjAiPQBSl4GtLSPm3YkEVQ5r1fK+yW5L2rZWGMPtwQ6UdZOvIh0lr9?=
 =?us-ascii?Q?4rs0YoInXYjzxq2Q/n8yJWukqdwFUZM9g2cbg90/IFN/2tKzkce+Dk2zgvNv?=
 =?us-ascii?Q?3XGdG4s7CL30XBghn8x6brKSaTa0h5ww8XsRyszepfrT2MEe6mRyh39/u4eM?=
 =?us-ascii?Q?slbZ2rSmzKarRCbUWyTTaj0Do8v8UbsqTUdysKt5Z5UVyK1Aosxk4T1uFhXJ?=
 =?us-ascii?Q?/vTWF+fdesUEwu0JRvOj7EJoR2w4BYY9RrJAXGbbvs41ymwGdOI0RpFe+rVO?=
 =?us-ascii?Q?oStnF4XqPE2k5MO142MFdCdf2rsMpF+NelqRKbtR+9EVZfHEQwri2S3VCS+x?=
 =?us-ascii?Q?xSA4JHTGcNkYunNPPnWMDbcsIxeeCUTlH/ypzrdxxaLDOfC1gFsdI2oNNaI4?=
 =?us-ascii?Q?YPsSAOOkJf5O17AA8c2UtNPFxIIEi/hIi5YnJ8a8tPyxQ0db0fNb4e0HYHLC?=
 =?us-ascii?Q?myQSHMAXp0Ofs6yGuwM5tB2LCVmmprGBwIcQwZ/r0bFuv1NejLyEboN2ogjc?=
 =?us-ascii?Q?npJVggtpFDB882gp/zFfjs4ZqRhFQ04V0dBE/qt1HblF3lwENc6etdVGqG40?=
 =?us-ascii?Q?mxteTLfTEVH5VZiJHlKormh9YfK5oojmPcFk/AMn9AoRAjzYxrE+IKQ2fimI?=
 =?us-ascii?Q?Btu9G45hnN/uJ67/fXCh3lAWH2eUAl8c7AwYxRrUpXo9T3oC5FqbduK9M/M3?=
 =?us-ascii?Q?rSNBLAvxOHI9dv85prxLs1ojLECrB0QSilQobg5UrFR/ba+qQJgPDoRBNNj0?=
 =?us-ascii?Q?SlfDCnrkSWdgE0si1SlmhMYhgu9WdfaxXcKBYCggV5W0dJdSWCx6Yo3lRcYO?=
 =?us-ascii?Q?UBirHf8LI9wSSeddTssPvDTDcaIietMyl6xOKTKK4lWZ/CPUDyTTQOKXEZoG?=
 =?us-ascii?Q?IAbv7EmITSvlD5UxSSlduMYnR6IRueWHjwrdm/08rtdaLp4aHtytXEKE0DG1?=
 =?us-ascii?Q?Y+d2sV6wDq9/dCU14Xs/YTfx7V6jMRzYjoKAijdGRgmM4tnhlm3TrjLMWsnl?=
 =?us-ascii?Q?RQtQZlIYmYstBTVAdq1TK9qCeuBPlaU6W/WJ3gB3V3k5o6QWe43cyZnL7B5U?=
 =?us-ascii?Q?hJYYIEtposA9cgTTwFAHStscfQlX0fkcxojYzDdRYTmuK3/x8GjYwQ6KWi5b?=
 =?us-ascii?Q?ErV01ySApqMxcU9VICzN05jyED+ef1OD6lZ+iqnEZ7r2+gfqAI9mkt9GN3AK?=
 =?us-ascii?Q?kstq7Cpf4ECNdeCaXVv1BP8f5ePBCZEVXR8LaVAEYQabQoNjlu4woLhkU4TU?=
 =?us-ascii?Q?mYpVOV6PO1WKjUU1BvpXOyBhbjeGMzwbEqESbimYDAX2k7hQ7Dvp5Ea8RTDI?=
 =?us-ascii?Q?zrRU94iTFfDNm35p3UKYsf/jAAWoNBhxFtUGkpew?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90da7f63-5caf-42af-b56f-08da79e87b69
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB6163.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2022 09:21:03.7807
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JGBmHNY1Dp6HsLyueHy1l0ubECG9TIqbL+nJxzSPnKyHjw7xGSC9ND0RRmB1JgflkEjtCxeXtSHgv9wBx4CzyA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4110
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 01, 2022 at 05:33:49PM +0200, netdev@kapio-technology.com wrote:
> On 2022-07-13 14:39, Ido Schimmel wrote:
> 
> > 
> > What are "Storm Prevention" and "zero-DPV" FDB entries?
> > 
> 
> For the zero-DPV entries, I can summarize:
> 
> Since a CPU can become saturated from constant SA Miss Violations from a
> denied source, source MAC address are masked by loading a zero-DPV
> (Destination Port Vector) entry in the ATU. As the address now appears in
> the database it will not cause more Miss Violations. ANY port trying to send
> a frame to this unauthorized address is discarded. Any locked port trying to
> use this unauthorized address has its frames discarded too (as the ports SA
> bit is not set in the ATU entry).

What happens to unlocked ports that have learning enabled and are trying
to use this address as SMAC? AFAICT, at least in the bridge driver, the
locked entry will roam, but will keep the "locked" flag, which is
probably not what we want. Let's see if we can agree on these semantics
for a "locked" entry:

1. It discards packets with matching DMAC, regardless of ingress port. I
read the document [1] you linked to in a different reply and could not
find anything against this approach, so this might be fine or at least
not very significant.

Note that this means that "locked" entries need to be notified to device
drivers so that they will install a matching entry in the HW FDB.

2. It is not refreshed and has ageing enabled. That is, after initial
installation it will be removed by the bridge driver after configured
ageing time unless converted to a regular (unlocked) entry.

I assume this allows you to remove the timer implementation from your
driver and let the bridge driver notify you about the removal of this
entry.

3. With regards to roaming, the entry cannot roam between locked ports
(they need to have learning disabled anyway), but can roam to an
unlocked port, in which case it becomes a regular entry that can roam
and age.

If we agree on these semantics, then I can try to verify that at least
Spectrum can support them (it seems mv88e6xxx can).

P.S. Sorry for the delay, I'm busy with other tasks at the moment.

[1] https://www.cisco.com/c/en/us/td/docs/solutions/Enterprise/Security/TrustSec_1-99/MAB/MAB_Dep_Guide.html#wp392522
