Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DF97577703
	for <lists+netdev@lfdr.de>; Sun, 17 Jul 2022 17:20:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233181AbiGQPU0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jul 2022 11:20:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233172AbiGQPUY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jul 2022 11:20:24 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2050.outbound.protection.outlook.com [40.107.96.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E389613F2D;
        Sun, 17 Jul 2022 08:20:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BbmjJjfVYHnMBMu7YuvAtsQ5ceCeaTPtTnIHEsH15ZwZUFqKheBOn9o/tSViE6d5/JGuz7fFxnytdSnLa+n60Nwws+ZgX7wMXZmgdaMmina89KM3o3PxEvRuYaOeoGRT7iM55qBG4STWc3tpf7SQwVgvb22a/YTSOag0hU6CxWiIu/gjI+L2HQiaC1c31YE+JNC6+S0tlqmVPWstv43Hybm+3ZphFhweunM13kCa6DQ7hVKOhJTY4XcUmvKjJiKkA6Qgk8RsJ5uS0uSyd1qw+rWy3RJ8DadgcEZvSRvK8ikENvRtsj0vlEU8QVcLi7aDOipuS3Bpd86odi9oKx61bA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EOZ8bUWibnWbrVg28gzxAL4UHOdXJaMEyH09R8fwuDg=;
 b=IOqfPGe3/6BPaw2Khk+heIBFOwPzlpFwFp+YPLeAJBNz8haOlw2h7TiWQKOi0P3t7p6Xe8BAIYMwL0slf7rSIFhVnr3alvHcxBQGagzRgC3T7Do1dSVSHYYdgOJ0YN7iSRCC4aAT4WBifoZicPi9VOQ1QmhVD5/3XfK4xAM0yEigt7QkNg9jBIPeTLkNpXzhbc7PYrhfgsFx7J33VSHflfw1BKtAv/jNv8xcBjV4286g8q68snv/vepWJdo/Jl7minWtyTdiMA4+ptmHonkr5uJXUjcD11+crZVcLWt47ZsjvdrBKWzZKS0Kzy5whZCjUH6m/GBn+/bGd0w2+rUd9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EOZ8bUWibnWbrVg28gzxAL4UHOdXJaMEyH09R8fwuDg=;
 b=XvVr6gGIEA8SF+D8A8uNnOHbhHDqofZF6R8PnXn3I+0kTJdeMFXCd3Hq7n0Xo01OiJxKfU+clXsvzDu4LzEeWjWlT9/ybDvTydEzeJ9FhkWe9IkfnlKuSXZqHKy/cK7r3fWO45UvpexO1gU3LZYAReOOrRuGU+UzvZNO8HGPcPl5HrjGSVgGwde5Wpan3IKGkKgLKOwQWiCReMt12adGMLhwoH3su58d4kNFVWZniwNpnRIT9SfclMl2JK+wmnWkpa6F5QWenR/RvULyV7prr12UEC2ChtJAqwbH8pWSbuGWYQkhmInI8qGnxph96tU7p+Az4A+4NGaIQXn0gfmnuw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by SA0PR12MB4382.namprd12.prod.outlook.com (2603:10b6:806:9a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.14; Sun, 17 Jul
 2022 15:20:22 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad%9]) with mapi id 15.20.5438.022; Sun, 17 Jul 2022
 15:20:22 +0000
Date:   Sun, 17 Jul 2022 18:20:17 +0300
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
Message-ID: <YtQosZV0exwyH6qo@shredder>
References: <20220708084904.33otb6x256huddps@skbuf>
 <e6f418705e19df370c8d644993aa9a6f@kapio-technology.com>
 <20220708091550.2qcu3tyqkhgiudjg@skbuf>
 <e3ea3c0d72c2417430e601a150c7f0dd@kapio-technology.com>
 <20220708115624.rrjzjtidlhcqczjv@skbuf>
 <723e2995314b41ff323272536ef27341@kapio-technology.com>
 <YsqPWK67U0+Iw2Ru@shredder>
 <d3f674dc6b4f92f2fda3601685c78ced@kapio-technology.com>
 <Ys69DiAwT0Md+6ai@shredder>
 <648ba6718813bf76e7b973150b73f028@kapio-technology.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <648ba6718813bf76e7b973150b73f028@kapio-technology.com>
X-ClientProxiedBy: LO4P123CA0681.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:351::15) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b5b23f0a-dd2a-4d5b-0c70-08da6807ddc3
X-MS-TrafficTypeDiagnostic: SA0PR12MB4382:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LBoJaYbbR1GyrPDRqfTKyhoF0kPQVn+QwReFtREhgsaMi+Oc7wS64XU+2nQAwS12gMM8JVOw0WnjYJd6YJNX7TGbtuwoyBwi1HfQ6v/B+DZXy1Nx8frDzDPX4njFLRzfO7Ndi5ZMon16dV17ahRk44+21RNM8VRqlB0BYNiHN8QDOLujSSbndx0OIPBl9iRodZvl5l0hLTh9/g/faVRX3FC9OC0eLBfMv7oX1zAc1pQgzighuvsizcBnhAghCAHABEawgXFeble+CyjC2BNJPajFE5ZghG7QPP+TimbXShPFTZqs6JgxY67Ok3+wXWxzurMzRKPi6IHhuPSDj6ADZJj+WeD37Qt2zgWZNbF6oRxfc9WAJpcLqqdTTf0t3rdFJK4i4ido15YsT14qLUKrXvnxQ5HshchuOnD3hVRNFFOS8vADekAUgaMAQNN8bfq8BxtZEYfAMEfkpdj4HiY6/3KsOs5Roz6oQrfdUZzJbEIia2YvIvdWL0n6g+d5Pjzb4INUZyJ3Z+LufA6A78tCDhyYBPAiqLgFra6kZZIudQtxYBODcmuUsDOiDK5JaeLBwwFS4MVNfJDs0ks2KkvIC00mN6iXMNUkTao+Cta2mq1vXOpgz9lIxk8tS29KDgg6eXrYirzh41rkjtWEb3D501J0L7zhXofrixDMPO69C6YKDJOxqx0HOlEo1pTVyEyFYDqUMSNibaTvvu87lKz9L8XchbF1L5EV9zpUX4pcJOWedpAzL+4wSSRHTK9XhFbBg21KN4mDZlpmI7S+goJW0w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(39860400002)(136003)(366004)(346002)(396003)(376002)(84040400005)(5660300002)(33716001)(7416002)(8936002)(2906002)(54906003)(86362001)(6916009)(4326008)(66476007)(66556008)(8676002)(316002)(478600001)(6512007)(41300700001)(26005)(9686003)(6506007)(83380400001)(38100700002)(6486002)(186003)(53546011)(6666004)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ELIqW9XRzpcEdq7sE28KHwUjRVz6cBhgIuBDPhs1TvnfEOb0ociHJQy9YxEx?=
 =?us-ascii?Q?5jBMHCMFvgi8empSZ3hx5j58tqsvY37bMkbIXcXeDCuUSPCeTEkmPWQQ9Mel?=
 =?us-ascii?Q?U9z8IHV/uW8I/SkQv3fvy2NJWO6YeYV8hS2ZDRKDavbXD7GKTYnXdLMLkSvY?=
 =?us-ascii?Q?bv8yY8dg2fepO5FsyWjzSnlwp9tAF7T/Z8MIqt/JpjT9r+OXEL9TbqY6wvDy?=
 =?us-ascii?Q?jE9VpjtZtbI2fN9vkQd2oe8kUF0/xq2g91NTctF5BGicXkUS7TU1ynupUIKX?=
 =?us-ascii?Q?sICNN3XC2PyNwrP1+SfL328gK6IZbwLfi7eBbHDj/frXd9utYqH4QXaSLeON?=
 =?us-ascii?Q?sDfryre3EgBClPFoRWCuOcVnek7a8KHD7rQietNI2BWd92CpWmux3EQwJsa6?=
 =?us-ascii?Q?ReeodxcZ6GfjQJ9RwzLeMwfRYFIyQpVCtkFRng/97ciVgCLnZL5pVDdzZCnD?=
 =?us-ascii?Q?6GFecMz94XrnKKsBj2r9g1wsxoqPBTczE32KgUauiU/hy6BBRPmeiu6vCyYP?=
 =?us-ascii?Q?e0IqCAw+DOTKNPTXiSgq9yjczFOWIyqHnC01KfO0r2obW7lr7wrOXe3CxWuI?=
 =?us-ascii?Q?BosHZSCCCf44RoZDr2UFisTwzTczOLymNi/TtEQcqzWlHQt7Ws044MgNNppI?=
 =?us-ascii?Q?XUEP5mfROjInAzQ8DDM1UUwOsB/fXlmAU306o0Kw834gZ590uQXm3PVOhfWT?=
 =?us-ascii?Q?nLi4cCUfI3gHCS7vhS6QvGH5GP6fKDc5zvvoF/KJixkiQtzb9+SgBhXL/VNE?=
 =?us-ascii?Q?WM3HKOVV+Fu40wp7T2fUdbl/juBNZbfQauCMWRbCMu+7WDsf641aUnQacr0P?=
 =?us-ascii?Q?YbQRDdrUhh0FjPyzdcyPbsThQJUlt6o8BY0jhFgtC6xIh1Ju29AdxHzlClLo?=
 =?us-ascii?Q?QkiapTyIvnUinVhtbt7jXUzEhcvXU6ViXkZhpCIbhy59BZaHNCmH2k3xf1p6?=
 =?us-ascii?Q?YvicDFFMJPedks05CvUqhmrblFodIAFfEvWAhJjMRw6Dpxyb0WwKbqmTF5vc?=
 =?us-ascii?Q?RXN4vpxXLA9WLnTJ7fPaXeKgdgrlXbfNh5Aj/qNGaR9C2ZHhJAZYwbbFyuvb?=
 =?us-ascii?Q?VQ8183xl4kBVS585C5nttk7ix33tvCRRQ2ZBZpVZ3++ddUtzmOyiaH6Eh4OD?=
 =?us-ascii?Q?+cfM5R88H7Hpiwi2o7LLzPMDSeX4h/uZo1LV+FNtFewrlJSBT7hJzAImMP2I?=
 =?us-ascii?Q?BTbLFCcx1ToMDK2FebAWb0J4YFL/88m+XPrabC70RXjRO05nPuoe5GUSTbrp?=
 =?us-ascii?Q?Ir94KooU6r3x9WynIx4vDO8G7Pzj37cqAxQGIggx+oklEMgVrnbvD+IDPKDr?=
 =?us-ascii?Q?a3CmVxRaP49QYsUExpedfKoCq9aO4A0BLoXyQkKnpvAdh4Lc5GQJ6FAnBwQk?=
 =?us-ascii?Q?ozZFlVeGHPck+w0CPomQ2orGb7Or+lQRSQvPy2C4tCTxw/52l3xN+GF1HaY0?=
 =?us-ascii?Q?+zW9eNEXFIDLD/VmlIm6yJzhk//B5qe18XXQHKP6Fs/Eu6Z2pkmeHMUusmKs?=
 =?us-ascii?Q?WSxqe/evFe/ryG3UNMTgXHiwY0KS6ADUgPoZK6gWQplJPbeSiq5TWMTT3dai?=
 =?us-ascii?Q?yQOjI+wbnFAyKNIhJCwBg+wzx9nUy8ktDfW7E5/o?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5b23f0a-dd2a-4d5b-0c70-08da6807ddc3
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2022 15:20:22.2203
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FHGG8y3cM6YEO8O01RsVbun7m62mKGlqYfEcePxc0mFiraQ8ZRmioIfNSu7WdNpdU5sbb4+AlYVqBVv5ewoIqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4382
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 17, 2022 at 02:21:47PM +0200, netdev@kapio-technology.com wrote:
> On 2022-07-13 14:39, Ido Schimmel wrote:
> > On Wed, Jul 13, 2022 at 09:09:58AM +0200, netdev@kapio-technology.com
> > wrote:
> 
> > 
> > What are "Storm Prevention" and "zero-DPV" FDB entries?
> 
> They are both FDB entries that at the HW level drops all packets having a
> specific SA, thus using minimum resources.
> (thus the name "Storm Prevention" aka, protection against DOS attacks. We
> must remember that we operate with CPU based learning.)
> 
> > 
> > There is no decision that I'm aware of. I'm simply trying to understand
> > how FDB entries that have 'BR_FDB_ENTRY_LOCKED' set are handled in
> > mv88e6xxx and other devices in this class. We have at least three
> > different implementations to consolidate:
> > 
> > 1. The bridge driver, pure software forwarding. The locked entry is
> > dynamically created by the bridge. Packets received via the locked port
> > with a SA corresponding to the locked entry will be dropped, but will
> > refresh the entry. On the other hand, packets with a DA corresponding to
> > the locked entry will be forwarded as known unicast through the locked
> > port.
> > 
> > 2. Hardware implementations like Spectrum that can be programmed to trap
> > packets that incurred an FDB miss. Like in the first case, the locked
> > entry is dynamically created by the bridge driver and also aged by it.
> > Unlike in the first case, since this entry is not present in hardware,
> > packets with a DA corresponding to the locked entry will be flooded as
> > unknown unicast.
> > 
> > 3. Hardware implementations like mv88e6xxx that fire an interrupt upon
> > FDB miss. Need your help to understand how the above works there and
> > why. Specifically, how locked entries are represented in hardware (if at
> > all) and what is the significance of not installing corresponding
> > entries in hardware.
> > 
> 
> With the mv88e6xxx, a miss violation with the SA occurs when there is no
> entry. If you then add a normal entry with the SA, the port is open for that
> SA of course.

Good

> The zero-DPV entry is an entry that ensures that there is no more miss
> violation interrupts from that SA, while dropping all entries with the
> SA.

Few questions:

1. Is it correct to think of this entry as an entry pointing to a
special /dev/null port?

2. After installing this entry, you no longer get miss violation
interrupts because packets with this SA incur a mismatch violation
(src_port != /dev/null) and therefore discarded in hardware?

3. What happens to packets with a DA matching the zero-DPV entry, are
they also discarded in hardware? If so, here we differ from the bridge
driver implementation where such packets will be forwarded according to
the locked entry and egress the locked port

4. The reason for installing this entry is to suppress further miss
violation interrupts?

5. If not replaced, will this entry always age out after the ageing
time? Not sure what can refresh it given that traffic does not ingress
from the /dev/null port.

Thanks
