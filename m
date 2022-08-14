Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E697592045
	for <lists+netdev@lfdr.de>; Sun, 14 Aug 2022 16:55:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229828AbiHNOzu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Aug 2022 10:55:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbiHNOzs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Aug 2022 10:55:48 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2083.outbound.protection.outlook.com [40.107.93.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9F4C167CD;
        Sun, 14 Aug 2022 07:55:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cr1FaX03hnWxQ2qnhq3BqufnTgUttYb3VF3+XD48Z4FJlmdWtTRdhhsUrFEOcRHY4COS5ZXRmtlyZ4nLUFhBxBLnGh6L3TJV50GErD/DcCF4ZUQzijA0nVswoltyI1Rd5ysNa3nN6CC5ovAuMFEog709nR9he8bOnwCAuI/CWMEQdlBy/NfB+HzMnYf0p5howK6boGLjb2uzasib/Wjl1ETCXI1Dop6X6ZTiYlx2qfOuiM5TtlBYDE/w8hIbJvghWIIGTbk97P1tuzkQMfzCIqe0PFcjSTSgZT2LIi9Xml1h/t+PZe6H623KWyprbXETBwAyeCneKl0hDmCmA/DtJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qSs9O9Rbz5JLZaL+NI0ohyYc2eRUtBZI3X6assqEvas=;
 b=gVv0LKEQhws9lGF+cXbZtvJ+CwM3sR23VXZGab4koJkIpDgvZrkN1CjUyofBtyG2rGTcFkwByJ/QHTGMCwpZLxIA/PaK1KvYoOmFlVhjchxwVgEILUspLZFVkU6/jMQJ6WGaACFZp3aX7/nBBCw/jnITH1DHUYL5qbLJDRKQ3t3wy4jJ7h0CXdn2/0gTQzXuwGjJRp0A74LP/8+wY1zFEmLwmdo/uPGQbbsXR/W1xysueVv9O6kqoXmwfOs1+JLiuyBgIxZvWy05CoSXhCGQnFOaayBUBW3LVdhNONLt6cBA5zaisjtf4Ob3fSYTkp31UBFqPNTaoZh5VbC5ApCmBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qSs9O9Rbz5JLZaL+NI0ohyYc2eRUtBZI3X6assqEvas=;
 b=s5PsTHpbDoe8oSq3ktOdaC18l9TY9FW82h77JYX3wlCp0fvmf8I2UB3y6k3YDAPhCNcJ03HKN02cr9p+MhK2FH6xyvdt+LFvKFLTSgxbHX8jenS+0Im3Wro+YVcpSF3NY9SUfw60CO/zs5OB+NU0kek3NlYStmsaAmUNGli2VYbbDaqxebRMb/hT8g+ZPyW6Fzk+IgRnvRpOXfTLurICUIPVA/P7iqWuZGF5oFVhPoe3zPeaiIM7RwLfOPSuLHaHrd2v0uCZOxAg+VRYMWlQjoqDXBbyknfBPtd1CwLFBAveomwpnqiOMtZMeoiPGjr0bmOOt8vatO0w/BGlL6oF8w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA1PR12MB6163.namprd12.prod.outlook.com (2603:10b6:208:3e9::22)
 by MN2PR12MB4173.namprd12.prod.outlook.com (2603:10b6:208:1d8::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Sun, 14 Aug
 2022 14:55:46 +0000
Received: from IA1PR12MB6163.namprd12.prod.outlook.com
 ([fe80::a52c:c6f5:f9f4:59cc]) by IA1PR12MB6163.namprd12.prod.outlook.com
 ([fe80::a52c:c6f5:f9f4:59cc%5]) with mapi id 15.20.5504.027; Sun, 14 Aug 2022
 14:55:46 +0000
Date:   Sun, 14 Aug 2022 17:55:41 +0300
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
Message-ID: <YvkM7UJ0SX+jkts2@shredder>
References: <5a4cfc6246f621d006af69d4d1f61ed1@kapio-technology.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5a4cfc6246f621d006af69d4d1f61ed1@kapio-technology.com>
X-ClientProxiedBy: LO4P123CA0059.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:153::10) To IA1PR12MB6163.namprd12.prod.outlook.com
 (2603:10b6:208:3e9::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9666e62b-3e40-4a94-478d-08da7e05115e
X-MS-TrafficTypeDiagnostic: MN2PR12MB4173:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vxHZwjz4iJF1nj9XtoKyg9e9334sYojw4HvMXN7RXOrxWKhN009wMeBsZy8netIBHw6Y8T1eKqb5RmpmDZZJAaXxCiI7qBFZLrJaUV8puNA9X2zClhWcMHlD/3vxBpYejD9bzJrtsU+lEEx1Iaq/BYQrfVweR/aIAYlyCMDsP49HJWEDasMWQSaZEb2NgR7Rp7a2iLYPU4ZGJ81X5PUzTAMFQ7Mj5VRD0I3oM1JTEqyjrfP8gALELdq3lwq8EFT6nERXmADz3pfRofBtJR21POqzBwXQAhs5JZuSNZuOGAz2Mn/YLvwMWRO5/trWko9/oH07kmNWLAAv+gR0Nfa+YdWhVYKRcMTyul7q2k6x/qkUMzIbRJeXnqQS+ZfJQWN6/JRaUyZhaBm/QLcDYnj4dVd4ZqnZhIPlF/kSrW+4VTx9XDyfOBRdORJCStfgw5rX6SwDkQ+C3lUGSH98DsT5jGEP0ISxapJs/qEWZNlFiSfQVhftwZd9HUF6BioeuH2eRGjs1514KZYFM8Cg22u6y4VPQkfbMUwUDJtaEMM3jOw7Y8QQez3aA7Qe45xyzhSoRvRB8Qyfu6wLNNn24K7/rryiYdhwCFvQMwCKL3jO/FxQO3EaMFmAhhQEmiDPd/Vb3xo9ZAxpYj9f5jZi7kEmKn9iHMmpP3A3iKFOfoii+yrC43kmNfGNMp4Mvv/wRLnBuBYW4WnfKXkNvlsITl/8akXuUJ8GZOpTpVmCPMW/qYwrpCpGC2rzCMZWl4YD2xijNz5TY7d6RzRZeVqjDWof+UyItuFSQkwkktDLMh2tatY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB6163.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(346002)(366004)(396003)(39860400002)(376002)(136003)(6916009)(7416002)(316002)(8936002)(8676002)(4326008)(66476007)(86362001)(5660300002)(66946007)(33716001)(66556008)(54906003)(83380400001)(186003)(6666004)(41300700001)(38100700002)(478600001)(6486002)(9686003)(6506007)(53546011)(2906002)(26005)(6512007)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CTyWg0XVPSOL9hoS45+sGp81hECZhuf8sPlWISQSMEcUMckno5AzDq7RGw17?=
 =?us-ascii?Q?GazPI2D9t4a7H/CDhi0j+ZO23Mwi55jw5W+rIkDVKrnXBvBOXKfi5t8Quhbz?=
 =?us-ascii?Q?xs/IVwaSBgVGqSUG3iflSN5MzN+STUFE7Q3WS/1N/TPoc8klm7u+GzO702y8?=
 =?us-ascii?Q?qkCAeBujMpcf3e3znmG7c8f5oQFM1zR/sfSwtskANerVIux8GAGYGFL7T31t?=
 =?us-ascii?Q?cxtEVJZunXoZRSrxqzFNOxDmCcefk5Wapo91WxDP7GfkLH0VEULE/War96mO?=
 =?us-ascii?Q?zuAp8J+0ozSaDputDq72vsrb66pNp3CGyOkecoSKphpB+7BvvgIdltD4epIu?=
 =?us-ascii?Q?gV9UbIypigPPcGs5l7v4w7MLiQWJsb3GWuBVCPI7AyHKSM6oVwnLiXhR7auX?=
 =?us-ascii?Q?LKdQouOOmyrxFX+YDQaE6fgucDwkViOszHqP37YFmRMtIWQrCvkBm9yfp6id?=
 =?us-ascii?Q?JYJoPC6BTujPy5DslF/yIdELUU147iWDpbJ3EGB/+UPS0C+FcW0NNuq1wq6x?=
 =?us-ascii?Q?oFNgOixfDEiTZbL0jqetnNi0MNarIxSTFekisqQANaPLTammlV+wbNGQ2uSG?=
 =?us-ascii?Q?HRcncXarEbnhzPcuGtW5VRZsUa19w2phGHD+dJrJiaEYbA/m97oVrLCiY2WK?=
 =?us-ascii?Q?kO/xZOV7Zx2ocKoanI3Bn5Y2Z/gDZz+XbskkBcR6o4wMK1TpHFJDneYdnJLt?=
 =?us-ascii?Q?Szy+c6gkNSvuIGqCijoNb5JgW35HgaAIxUy3Dv9lc2jx/LflPzJUq04p5POZ?=
 =?us-ascii?Q?nO+e/5gqmCdysFGKiKiro8r48Zy8Jctfar72bfDYk/B2OLSkX7VBkmDn+bvx?=
 =?us-ascii?Q?i6j0ud20UuOPaD4OtcjO57YQTq3Hf1XsKw1l8viE1iFqLeuw52j6WJLOrNxU?=
 =?us-ascii?Q?Nr7s4kEECYGZD6UN4ukwaa3ArVhZRSYEW7FJkLC4sJ0tYCjZmjZmFIaEnLu/?=
 =?us-ascii?Q?IiakBiwhaXmOOQTkUwDwrZQFO+11x2F0JhQ40t+Eh90BqC++7gG5CxHZML7M?=
 =?us-ascii?Q?tPhWOZgX0ERALQBfPAXNEz4tweDH01I4GcPAbs2DngaRvFK/ORw3fDVe7knU?=
 =?us-ascii?Q?Nle8mw1VPw1+6udQ6mNMtZrLnK+B23ZCHZYfFHUlN/FRfOYZvYOh3KlmT4+Z?=
 =?us-ascii?Q?YI/Gel7KqIzCwZu3gRx3pBpKl+x9o7H+IR+M0Sb6dwlTJTrK8EZ2Kot6KDmk?=
 =?us-ascii?Q?eV9rk7IGuqsKKd/azqsivaGaPlJl2+LUw7CF1DxfbRFjlRjs6c4BIDF0dHJ0?=
 =?us-ascii?Q?BJp8fvGAf631s1TTckdStIPEkACjFFEQn8nPYdzapgKO2f24423w99eB1B52?=
 =?us-ascii?Q?4WIRPc95DlvneMmfk+AccgKMmnCNXo8bNxOFVLwzU6/lD2AzIq9qYgEEADyX?=
 =?us-ascii?Q?OgI1ASLaLBml7xlXNGrWT/d+p4l1AknzjT13cMyXKaT1mJUC8QZWAk/U1d4L?=
 =?us-ascii?Q?B4vvRJ7qa28S66f5p5vgMnQibOi++yUVa2Y3EhAajcMXrlRMadY+o8S68+Sb?=
 =?us-ascii?Q?zm0KekP+d3kU46czDWBolYZ/PeKJH4TwNQgK0yix/HF+1UVZcErWhRVtVV4N?=
 =?us-ascii?Q?7FooDESJ+O69HcauiRhRSir8k49pOT/stlTGkwgR?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9666e62b-3e40-4a94-478d-08da7e05115e
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB6163.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2022 14:55:45.9392
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G6AHHd/RJNvdQFuS0XD7grywphoL9HsPZY4z5EwjDFnCjI2eGF39jHbc5Sa2KCnkZYnhLfhRRov1wWEqQMUClw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4173
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 12, 2022 at 02:29:48PM +0200, netdev@kapio-technology.com wrote:
> On 2022-08-11 13:28, Ido Schimmel wrote:
> 
> > > > I'm talking about roaming, not forwarding. Let's say you have a locked
> > > > entry with MAC X pointing to port Y. Now you get a packet with SMAC X
> > > > from port Z which is unlocked. Will the FDB entry roam to port Z? I
> > > > think it should, but at least in current implementation it seems that
> > > > the "locked" flag will not be reset and having locked entries pointing
> > > > to an unlocked port looks like a bug.
> > > >
> > > 
> 
> In general I have been thinking that the said setup is a network
> configuration error as I was arguing in an earlier conversation with
> Vladimir. In this setup we must remember that SMAC X becomes DMAC X in the
> return traffic on the open port. But the question arises to me why MAC X
> would be behind the locked port without getting authed while being behind an
> open port too?
> In a real life setup, I don't think you would want random hosts behind a
> locked port in the MAB case, but only the hosts you will let through. Other
> hosts should be regarded as intruders.
> 
> If we are talking about a station move, then the locked entry will age out
> and MAC X will function normally on the open port after the timeout, which
> was a case that was taken up in earlier discussions.
> 
> But I will anyhow do some testing with this 'edge case' (of being behind
> both a locked and an unlocked port) if I may call it so, and see to that the
> offloaded and non-offloaded cases correspond to each other, and will work
> satisfactory.

It would be best to implement these as additional test cases in the
current selftest. Then you can easily test with both veth pairs and
loopbacks and see that the hardware and software data paths behave the
same.

> 
> I think it will be good to have a flag to enable the mac-auth/MAB feature,
> and I suggest just calling the flag 'mab', as it is short.

Fine by me, but I'm not sure everyone agrees.

> 
> Otherwise I don't see any major issues with the whole feature as it is.

Will review and test the next version.

Thanks
