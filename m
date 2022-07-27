Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56FBA5828DA
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 16:45:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233748AbiG0Oo7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 10:44:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbiG0Oo5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 10:44:57 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2061.outbound.protection.outlook.com [40.107.100.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBB812AE14
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 07:44:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B/aml/vZF27+YGQxdqy4EAgAy2hh1Uru7qmx72ZzPD4tHstdLEgfrRZIBaPbIywqZSIkkv5SXCCfwgVbAXH/CbOGlpu+rzN1+Cp/uCVDGA8X/6frzhDfuLMF35IR4wSx1V/8Z6S5cA2WPKnksubGLIzK8JOAjHPAqLGUxWx6o529TIvyr6K9okcDirYe0aMePxBC9JTGfd+hgxHkCWdIapB9YMSbaDFfvC4YVEWffsZkW9lNJ7/Z7qyq/Bbef0PxgQbvP42avQkUqK3IScADlp/PJkrQDfeJdn9MRAK5EaM0pYy8ockrWNIuEer6llPuJzQPNTEvux/yqQJAouwAyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YfMnrW9mm2GsFPJVJS/juhmTlVKmL8arKS8oOZG0wvU=;
 b=Xy7toAJIJN3QH6CjvKF2Tyv4BaHwkB5nbLau0DMVglJOzk1qnGZisMF/Vaw6MCi4/2Tg0Np8i3mjXMtG07lPeLQLyzrg6HsEQ2ZaGSPPqJti9o4RxZzUu1UglRrOyE9ySRvvvz8hg3+YJeeoAEcpwOnrVHMr1uk2uj5NpTVIuggrVUU4OW2sNdhxAOennOFwqMEPr+l23Lgexc58CQBuP+VV0puaagtwhJa/+BLTu7NAL/6EGJCNvx3CGYXNMzGREmSFvJB2wTrB0oYrmb+yn2aBn4YSXP3lQW0JcLfSu2nKzuBz0os5RLA6UH79HecIxO4oxVOoNTBT+MJcrrNlCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YfMnrW9mm2GsFPJVJS/juhmTlVKmL8arKS8oOZG0wvU=;
 b=dmXHAR8/dmz1TMWbnWQtkhu3kkLB3VlsRgnkFwIXzWpHpHwdakK50ZtFA/f+da2PQ+uL1s9Ue6csH+KJs/2ZFNkWpDK0F5YxicwkzBrPjvs6I+igh2HQTss/icox8S2dfIhIdSXGVek7cxxLgu6FM0lVpTEGb5N8dGiBPDDBSLERJmeD62dZ29c67/0bN7FBx9MzsaSYmkVQKqb/sF21Lmac6ZBeQtHbMhRo3TuSMQ1+BbgVO5Y4JomCYUqHsRc6cBjqNDktUJAP+lUsmrbmJ0oqez36PA/qAusGAltlbL2Hz4qPgJQizel8SUMTj0o96TmeVW87U4+MiUFMfmaQUA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by SJ1PR12MB6026.namprd12.prod.outlook.com (2603:10b6:a03:48b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.25; Wed, 27 Jul
 2022 14:44:54 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad%9]) with mapi id 15.20.5458.025; Wed, 27 Jul 2022
 14:44:54 +0000
Date:   Wed, 27 Jul 2022 17:44:49 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, petrm@nvidia.com,
        amcohen@nvidia.com, danieller@nvidia.com, mlxsw@nvidia.com
Subject: Re: [PATCH net-next 0/9] mlxsw: Add PTP support for Spectrum-2 and
 newer ASICs
Message-ID: <YuFPYS10iXdco5rM@shredder>
References: <20220727062328.3134613-1-idosch@nvidia.com>
 <YuFIvxvB2AxKt9PV@hoboy.vegasvil.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YuFIvxvB2AxKt9PV@hoboy.vegasvil.org>
X-ClientProxiedBy: VI1P193CA0011.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:800:bd::21) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ccfc5e34-1810-4d05-8e4a-08da6fde91c0
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6026:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PITBw9nh9cPSRQVq4ZY+waOhBK/dHeWWpv/4qgYPnju+2AswDeZJHnfAnyHDDmMm4CTCDWZFHZ+NLNvY0NYceR7Paj3BXsz2Kgni3Y589ZZNY/y6NQ9cAQ+IEJ85UO9G80c6GPP+1LKAB4WSz2zB2TnnK4QfThZvgdRC0sLSTklryz4QuiSjfvoCMxMfioT4J+4/WiPGDYWIWnKbMWKELobk0WYt7YLnLVffghR+jdmKgPw4UbJre77pn8LZ760j/pn/tw7CZVTD0dvJFUyFSdOP4GjL4gd34ENCDZvrCf+RLgVC2mkve1TU0u2+6XEzqRL4l4TaD8e79H1IfDxw+5W192LHdUjfKBN9gP/sxNFWZGY3trzyzZGlRkrMwgt+36tslyYYyDxxYAR369nQOoWBW45YK0B9WsGKT87wvZ9v6Yjea9C4Hnt2mmPhpvD9QdtkxHtOkTFS6NrxaUR1gH0w+slWt+KAGT+0kKHSEX0J7mFjO5FoEOJJbQuX2mFUHs2PgnDWez2vryVZibw/7ZXK4GBvyZEH0pvvWu0QBwrDrgvB/rkT2TmduRaIzw98zFwz/zY4NBihtxq2dPOaN0B5AG0c4yeU9jADi6LH34HN//V63+ZfMwtJIWdQByVQjywDHyBs93UL+3/NjlCsPI1zloP3UG4DTv3dsSgqQx3ZY3rINTCWMaRSqpeppGmd0pq40+8pOui2Q4hOThlcoNDJplf5wL07HoWmOisJOtjpt4S3zE5qiLeuXYxkEDYj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(39860400002)(366004)(396003)(346002)(376002)(136003)(9686003)(107886003)(186003)(6916009)(4326008)(66946007)(66476007)(8936002)(66556008)(8676002)(6506007)(83380400001)(26005)(2906002)(41300700001)(6666004)(6512007)(33716001)(6486002)(316002)(5660300002)(86362001)(478600001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iElWAM5Zyj8qtqo/cYrw8D5HTGcxwMZso2Tts3YSQsrFlQMF6dua3CzXUU2m?=
 =?us-ascii?Q?Ks1wpbxRSYGywmyp4tTfN9GDGaxYRjVBA948nhGmb6vqijbrvULGZJtj5sF8?=
 =?us-ascii?Q?B+GTZ08k/0Q/5Vgo5xB1l+/G9TvoVRst1DiWyxeZFuQfGJSC5C4fMH0uqJNm?=
 =?us-ascii?Q?r/5uUoaReSmFjdEI1kGO+RlaJW9etARzUCSZoxIW5NxbTjCwCSuz/m4MPE8R?=
 =?us-ascii?Q?MjOWjw8Gf6IcKHamITfX0PeSGJ3D5JL3z92W6MrlDFS7jFjyuiboPGkJ2Z7K?=
 =?us-ascii?Q?QAhJAAtQ2KVoKlc0R/TfaG/64AyGcF911bUH7cgHbWwH1zKDXW8+2158dn+D?=
 =?us-ascii?Q?AHYLO7BirrPMIt+JyxrxwaYg3EfiXCpwUp2uAIME7AvfOeK6f3kx2s2PXwov?=
 =?us-ascii?Q?LwolLzt/P4R730jrasOUB6OwCjAJIFU0W2KJSOL0voAqC2MLLu7ZWdHMyRLR?=
 =?us-ascii?Q?S/3h9eLvrHyK8y6qk3/goj4AchpYO3Mr2MQGnoxwroyzREBe+fi7yMNdDI1s?=
 =?us-ascii?Q?wANhyuUnc4OO0M+PMuZhWa/qnFrZ7IXeQRm9RwkOK1c1Q2Cflows51F1KHsj?=
 =?us-ascii?Q?JIU8C5+xRyrEqws7YJfqB/r3Wm2Gm6b7V0azRcw865YGlRTuLOOrhqzpzyIG?=
 =?us-ascii?Q?7TyipfZkFkIrC9PtvVDI1mlxAKk0Zxio+JH5ZODSdByAISxlf3dGHu+I9LIQ?=
 =?us-ascii?Q?Dq23ovlYl8kinK3hu60fNd3pyOnZ6g1VP9Bt8fl9zauKiUZgJxE3C/YnR1Rr?=
 =?us-ascii?Q?4kDK87DXCHaiWjLSs0lHE0aZBx5+ZDPzKe0/mHqokg4baAitHWrVZSHkFBej?=
 =?us-ascii?Q?IuKQ8MsITsK+j5QdbMxULIwfAHqX2RyYBhzsppDtlZnobRTHhNjMzTUeWExb?=
 =?us-ascii?Q?YG8435GSaZ67PnEIdhuPT3GleMzUve0UvYF8bLzaqP5Zj9azKHrKjk8LSNGC?=
 =?us-ascii?Q?cz1ntTIDIlkvpZeLy4oX0P5NJ2SfEpd2LOVlt/XzFbN/Qp3uJDqSAgrkpW6k?=
 =?us-ascii?Q?MOrVT2AhqebHU0/VYV55M7zWuLw78Y3+vwLo/IvWyemY0+QhDQRW+7QAPhvo?=
 =?us-ascii?Q?qsDzq9Bo1s94ydRgqPOMppHzRUCtVhHfAVMFIbnDiwN0VrKsOEf7me4IPWmX?=
 =?us-ascii?Q?apsT0rC1e8OXzQ3KOqk6bkPi7ik8/cgPunkF2CI4e+K2LgzGjbS+6AV+BLgb?=
 =?us-ascii?Q?7mhwoWJ2XrxdZFZLbd4M6QPITS4fdKZSkb49deOF/1XGqK6HRFh82jMTcxp8?=
 =?us-ascii?Q?rsySfeQeef2SsKlszoQeY/XTUCW+tj9vZfsveo/hvsugHv44BegyZu0nZ5kY?=
 =?us-ascii?Q?X6qOBLfDDBXU7IWGwHWbQFFzFBgd3OH567Y2pH3CuILLY4XoOirwMamPkbqO?=
 =?us-ascii?Q?VKoOJIuR/BiEGT/7da7l3/sWaLMctPY37Z8WekMotUkLB9zqsGf4PxXje4SH?=
 =?us-ascii?Q?xsldkJIITad+VJpX7jaN4Gq0F53FTh3wi+n4LU78V3Y3mJLyo9r0ygDyglSQ?=
 =?us-ascii?Q?HXhbk6juyACadaMy9gTiqrfXgku5PEGCt4NZEemSqS2SmqZadH2vfmCs7Of1?=
 =?us-ascii?Q?/QZN8XHEmkc3wv56lpMKi3eWFKVjUfROraOsYCk1?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ccfc5e34-1810-4d05-8e4a-08da6fde91c0
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2022 14:44:54.6803
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Cx/2kFneEkiYym1qwQIlSVQLnRqHbL4AIFquxMbn9IFtAmLlSDL2W8voG7Ew3V3MsnUDwQWDfJgmb16PyF0Omw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6026
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 27, 2022 at 07:16:31AM -0700, Richard Cochran wrote:
> On Wed, Jul 27, 2022 at 09:23:19AM +0300, Ido Schimmel wrote:
> 
> > Specifically, the hardware will subtract the current time stamp from the
> > correction field at the ingress port and will add the current time stamp
> > to the correction field at the egress port.
> 
> Doing this in pure HW TC mode, the time scale of the switch's clock
> does not matter at all.  It can be a free running counter.

It is done in hardware.

> 
> > For the purpose of an
> > ordinary or boundary clock (this patchset), the correction field will
> > always be adjusted between the CPU port and one of the front panel
> > ports, but never between two front panel ports.
> 
> To clarify, the only reason why you say "never between two front panel
> ports" is because the switch will configured not to forward PTP frames
> over the front panel ports, for BC mode.  For TC operation, the switch
> will apply the correction, right?

Right. The hardware can support a TC operation, but I did not find any
Linux interfaces to configure it (did I miss something?) nor got any
requirements to support it at the moment.
