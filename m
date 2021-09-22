Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62307414F84
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 20:00:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236994AbhIVSCG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 14:02:06 -0400
Received: from mail-mw2nam10on2093.outbound.protection.outlook.com ([40.107.94.93]:21729
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236995AbhIVSCC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Sep 2021 14:02:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lWggEtdWTTWaiqelUoPxenkUWjZB1HNSLCyKTvrcFSmj0MJzMlT5keW/ifEtehyXAPr0jC3InXn2PRUfLSBL5Sm3bdxQAEmkgYKgsg2ceJw4ZJklB6706UmdwvF94nG71Dr/zUecV6NgSx+njCvvZphzhXI/m1K+Tr/ym5BhCMWxo+TorsWKrnzIqzGEmWeS4m/NuZwy/5npb9itHz5K/i7pKW8lDNaCaPX6UM1ezrhbIIV3JgEoQfk2ocgkzoKl2PMYMB9LC2/43C4LlHUEr8V16esBZmPdqQ6NtrO1ragAvowzwV+xA9BeSF4XcvSmuGdjNaNxdeLKR9/1j8MtLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=qlM0d1wAiatEqRSkA2PA//PEeKJH6FKckZ3R0jwaL/0=;
 b=YIkVxHpezZHjt+cGz1286Jn8fhJvApZ0wjLLuecs22kG0t0FlA8VIr/Yiv6psHGOWWh6B88H4zwu6kTN0kHzadGZZw4EiRRUQrtySpP/H4RiQzYbBT68B1J/wO49B8OMh+szJqTYbg0benz9OIzhxW+utPzjDnEjTx9cV6ZPP4zVSroGPh1QAFelkhxo1FabN/w+3XY34hY2CNZXO1ek5PbJxf8TnH+wFtqWiQhkbZfdaaC3c5XrUmLz7e9XZzIMj36lPi0Tn0TA2FamCXOG/vV9P0uUEOtJ9st5FhuPy5F0fK0EZKE0kdKOtT5teFiwPRWYPxOAmzildbqmMnryeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qlM0d1wAiatEqRSkA2PA//PEeKJH6FKckZ3R0jwaL/0=;
 b=U0Tu68cdkHpYtcz9vJ/r+uJqpq/WeQgrzDgl1mL6TadExzjiScDZLSUmIx4Zu7ZGO0ghDbgg0YlFKjgMbnw2wxdhI5GnAP4QNYx4xuoWTLC+b6O5PIbGL468GzjNwnQF8xeVajdVaFe0AIPTRMRPhTTiJNkRENKAXGeOAG0Hiks=
Authentication-Results: sipanda.io; dkim=none (message not signed)
 header.d=none;sipanda.io; dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4905.namprd13.prod.outlook.com (2603:10b6:510:77::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.6; Wed, 22 Sep
 2021 18:00:30 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::e1d9:64d0:cb4f:3e90]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::e1d9:64d0:cb4f:3e90%9]) with mapi id 15.20.4544.013; Wed, 22 Sep 2021
 18:00:30 +0000
Date:   Wed, 22 Sep 2021 20:00:22 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Tom Herbert <tom@sipanda.io>
Cc:     Jiri Pirko <jiri@resnulli.us>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Felipe Magno de Almeida <felipe@sipanda.io>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Boris Sukholitko <boris.sukholitko@broadcom.com>,
        Vadym Kochan <vadym.kochan@plvision.eu>,
        Ilya Lifshits <ilya.lifshits@broadcom.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Ido Schimmel <idosch@idosch.org>, paulb@nvidia.com,
        Davide Caratti <dcaratti@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Amritha Nambiar <amritha.nambiar@intel.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        Pedro Tammela <pctammela@mojatatu.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH RFC net-next 0/2] net:sched: Introduce tc flower2
 classifier based on PANDA parser in kernel
Message-ID: <20210922180022.GA2168@corigine.com>
References: <20210916200041.810-1-felipe@expertise.dev>
 <CAM_iQpUkdz_EjiuPRF_qKBp_ZHok_c8+pr4skCWGs_QTeLWpwA@mail.gmail.com>
 <YUq1Ez1g8nBvA8Ad@nanopsycho>
 <CAOuuhY8KA99mV7qBHwX79xP31tqtc9EggSNZ-=j4Z+awJUosdQ@mail.gmail.com>
 <20210922154929.GA31100@corigine.com>
 <CAOuuhY9NPy+cEkBx3B=74A6ef0xfT_YFLASEOB4uvRn=W-tB5A@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOuuhY9NPy+cEkBx3B=74A6ef0xfT_YFLASEOB4uvRn=W-tB5A@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: AM3PR07CA0073.eurprd07.prod.outlook.com
 (2603:10a6:207:4::31) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
Received: from corigine.com (2001:982:7ed1:403:201:8eff:fe22:8fea) by AM3PR07CA0073.eurprd07.prod.outlook.com (2603:10a6:207:4::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13 via Frontend Transport; Wed, 22 Sep 2021 18:00:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5b8d84bb-364d-4a3d-3df1-08d97df2dd99
X-MS-TrafficTypeDiagnostic: PH0PR13MB4905:
X-Microsoft-Antispam-PRVS: <PH0PR13MB49055A0897FAC3C3377C0085E8A29@PH0PR13MB4905.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZDbo+O02Wbb1LlKvquvnTnGKW2P7oqhQy6zbiNh5AJJnnaLvT3lY5vi6sT+dq3Smd2y33tx1iCpMrOCm1KVrm7rXNHAPb/rJAwR9o+WGHz8jqHSH81P55vX17TZsfGCBms/GqoFxX0URBXs3rY1isS5mPY/kvCKmpyo9cNpoOntQ/Jn7iSFvSxxs0nA5piWPQfkcXQdbnuvcEQW1RYfjdx4jWPEUSVQwIKllhYtmNkyXO1flUmbesF2EBXAwrz6H6x0n6jmZqFQPkoxx1YOaM8Ctco6H7lBenqMDzU6NAuV6tPMJgPIaE25q1GLPAdmfTYA4V7+Qh2q3C6tE0I04hVeIhyFLCrGVfy8iAXhcgigBc5KZiijVONviM9qd2Gg6FVNS5YcEYrm5FBh63740HgYCxvZmF9gRqWNqSr+AO2R7b+SOvYeLBxfHSiXuddnmcx+4fnBHJYLF8NwqciqXQgULTunPqKeCs7UJ77KrjvmJcadqU9CIk2OgezfzcJzxNwAEBcOnXPPjPnXCS+WDnZiblAeleQDBXRZP51AcCXVUf7sseiykNxt3AZuqmUjwcM6m3ixwIVfv8I5KWEEsHyt8OSaT7ioLXHhHYrU/LvH8v/2lcKAlydVNC6hU4Sx7LMr9JzWhkjS1uG9OXlnZItrD6WzBVb97yTgDzTCyKMGfzPsfzE8eE1Onv3uX8MAYQPHxSUvSZd0++VWDIBLbu7Chl733PlEIRebXEV8rSp0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(346002)(396003)(39840400004)(136003)(66556008)(8936002)(52116002)(2616005)(66476007)(83380400001)(38100700002)(966005)(316002)(66946007)(1076003)(5660300002)(8676002)(33656002)(53546011)(54906003)(6666004)(4326008)(6916009)(86362001)(2906002)(8886007)(186003)(55016002)(36756003)(7416002)(7696005)(44832011)(508600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?X01Kig2zwCndQyRyCGDfdlbb+xx+reLLkiX4FU0jXGF0cgd8AL1Hff2Scczu?=
 =?us-ascii?Q?Mnri/eqHti+MuHKOpgZHzOqIS9Vn7WVlQqeXY3F+4NSWeAWJ89JYldqT2OJi?=
 =?us-ascii?Q?IeEa9ZNx7uPa98UJSu7LKdNzzj4QUDfCNFkYKDRZGgqYWTzM/5+Gr5iHI2YH?=
 =?us-ascii?Q?L6R08AGOwaS06642Bqdmt3Ni1PpzmrrdEkZ8AYKzEIksHvgKhbvJACoekiRM?=
 =?us-ascii?Q?suVOf0Esx15Ry9TWMN12QY7aQBia2YFXXuwv9QOVxvIz9flATgEq7chqXY0Z?=
 =?us-ascii?Q?9+iN5F0t5qjfg3v/loTBJOW44Wrp9285cM64fHxTYUziXFyFZMJQi804Xmf9?=
 =?us-ascii?Q?gxzsfob4Zrj2y1e9AkP6zMkJdB/kNI0CnVTCO8UMGrkpAsNYyZMMShzWRqc+?=
 =?us-ascii?Q?taPYReTythfZ20JCyEgwuRMUD40LXqxZqLFm2wy++vNNFeBRA7B0D5+raBlf?=
 =?us-ascii?Q?FNvfSo+r3jyqojd6DE6ojbQjmqC7ex2axzVHqi7kbOUVmtUtMSodms7mAmBn?=
 =?us-ascii?Q?EUCpTZzfwNyj1tOi+WCOUtl9x1kbuGg+YO1lE7SAF22+f8KhphutlCNKtNDf?=
 =?us-ascii?Q?CQH5nBnJzs2xYC7CueaabevS6s0tTKYcLsuqVczNxsj3JZZU+jtKn9Z/TZT0?=
 =?us-ascii?Q?kFOftC8dIgUObQdaj5fwC+C67+D4EppHv7WrA9KJZzxHANR36aXjODhRFcmO?=
 =?us-ascii?Q?Q3nKKbawGuq0wjcxOM3F6jK5pWoN6TW3ezakme756ZC+UZLg8jCMaXzNjmkc?=
 =?us-ascii?Q?p95VIoEcR8oHMrXQ6K92PhL6XvF/qQJqzgpeStacxvwT6/2nB5D9JYd7SkHe?=
 =?us-ascii?Q?Xa+yH3H64QPaMgsGeHn+hTV0fs4ozwHg/tUaQqukJ7tpH6NORxJM4UJvt+PY?=
 =?us-ascii?Q?ZDNYNU23opITTuDo6/WlEIWvsWw3NguS+WzccyvmGxz6qV+OiTgThWLQIiGb?=
 =?us-ascii?Q?pLFyFmK7v867d5m982kvxUw9dlCU/pSz7v+ANrlkKhYm4GdPQZwV3iC4eBpj?=
 =?us-ascii?Q?Sw4SBnDgvSJGE4VAYhMUM0HvEfIFpan4MWeNGlHlhyQJAD6vb1eDaoVQVLk0?=
 =?us-ascii?Q?K8Hwi+7SPrpwspD5c1SzLjAVWuE1bVkvL+6qHXjVZylv/1ln4vI+816zj9Vp?=
 =?us-ascii?Q?ankiGoWZwahojegCTp+oHUj77n8pOWWRwJ50N5D49GaN80AzEJpWM+7ADtgP?=
 =?us-ascii?Q?oyEqlZs/D1HUkOXBbTqjh4y8EJ3fPIN1g34onvJrGiPko4NKWPngCryblolk?=
 =?us-ascii?Q?bMbQSoM7fZx9y+KUV1YVLtz9//gR9pTuZLT9zujLj0iCSZHrv8qbLxLGwUTk?=
 =?us-ascii?Q?UUmJ9i0a4qbpjNMrfoVGr0vsS4+c5yQJ1t9096LfnSM5laQabxXrLn4R2pzj?=
 =?us-ascii?Q?qKetyAZqC/Aft4s+FiqRF21Ud87H?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b8d84bb-364d-4a3d-3df1-08d97df2dd99
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2021 18:00:30.4355
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Qm6jLYQApjJ7BAZZX7UqaJEEXb10h4UrUdVlCgNEWPXJRI0smcsqJrTs7q1rKsoKZ70J8pVarq4Rji2v3+VLsL1m6yiWKs2hfvybIORADFs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4905
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 22, 2021 at 10:28:41AM -0700, Tom Herbert wrote:
> On Wed, Sep 22, 2021 at 8:49 AM Simon Horman <simon.horman@corigine.com> wrote:
> >
> > On Wed, Sep 22, 2021 at 07:42:58AM -0700, Tom Herbert wrote:
> > > On Tue, Sep 21, 2021 at 9:46 PM Jiri Pirko <jiri@resnulli.us> wrote:
> > > >
> > > > Wed, Sep 22, 2021 at 06:38:20AM CEST, xiyou.wangcong@gmail.com wrote:
> > > > >On Thu, Sep 16, 2021 at 1:02 PM Felipe Magno de Almeida
> > > > ><felipe@sipanda.io> wrote:
> > > > >>
> > > > >> The PANDA parser, introduced in [1], addresses most of these problems
> > > > >> and introduces a developer friendly highly maintainable approach to
> > > > >> adding extensions to the parser. This RFC patch takes a known consumer
> > > > >> of flow dissector - tc flower - and  shows how it could make use of
> > > > >> the PANDA Parser by mostly cutnpaste of the flower code. The new
> > > > >> classifier is called "flower2". The control semantics of flower are
> > > > >> maintained but the flow dissector parser is replaced with a PANDA
> > > > >> Parser. The iproute2 patch is sent separately - but you'll notice
> > > > >> other than replacing the user space tc commands with "flower2"  the
> > > > >> syntax is exactly the same. To illustrate the flexibility of PANDA we
> > > > >> show a simple use case of the issues described in [2] when flower
> > > > >> consumes PANDA. The PANDA Parser is part of the PANDA programming
> > > > >> model for network datapaths, this is described in
> > > > >> https://github.com/panda-net/panda.
> > > > >
> > > > >My only concern is that is there any way to reuse flower code instead
> > > > >of duplicating most of them? Especially when you specifically mentioned
> > > > >flower2 has the same user-space syntax as flower, this makes code
> > > > >reusing more reasonable.
> > > >
> > > > Exactly. I believe it is wrong to introduce new classifier which would
> > > > basically behave exacly the same as flower, only has different parser
> > > > implementation under the hood.
> > > >
> > > > Could you please explore the possibility to replace flow_dissector by
> > > > your dissector optionally at first (kernel config for example)? And I'm
> > > > not talking only about flower, but about the rest of the flow_dissector
> > > > users too.
> >
> > +1
> >
> > > Hi Jiri,
> > >
> > > Yes, the intent is to replace flow dissector with a parser that is
> > > more extensible, more manageable and can be accelerated in hardware
> > > (good luck trying to HW accelerate flow dissector as is ;-) ). I did a
> > > presentation on this topic at the last Netdev conf:
> > > https://www.youtube.com/watch?v=zVnmVDSEoXc. FIrst introducing this
> > > with a kernel config is a good idea.
> >
> > Can we drop hyperbole? There are several examples of hardware that
> > offload (a subset of) flower. That the current kernel implementation has
> > the properties you describe is pretty much irrelevant for current hw
> > offload use-cases.
> 
> Simon,
> 
> "current hw offload use-cases" is the problem; these models offer no
> extensibility. For instance, if a new protocol appears or a user wants
> to support their own custom protocol in things like tc-flower there is
> no feasible way to do this. Unfortunately, as of today it seems, we
> are still bound by the marketing department at hardware vendors that
> pick and choose the protocols that they think their customers want and
> are willing to invest in-- we need to get past this once and for all!
> IMO, what we need is a common way to extend the kernel, tc, and other
> applications for new protocols and features, but also be able to apply
> that method to extend to the hardware which is _offloading_ kernel
> functionality which in this case is flow dissector. The technology is
> there to do this as programmable NICs for instance are the rage, but
> we do need to create common APIs to be able to do that. Note this
> isn't just tc, but a whole space of features; for instance, XDP hints
> is nice idea for the NIC to provide information about protocols in a
> packet, but unless/until there is a way to program the device to pull
> out arbitrary information that the user cares about like something
> from their custom protocol, then it's very limited utility...

... the NIC could run a BPF program if its programmable to that extent.

But ok, I accept your point that it would be good to facilitate
more flexible use in both sw and hw.
