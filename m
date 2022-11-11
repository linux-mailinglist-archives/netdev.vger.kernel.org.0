Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5690625957
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 12:28:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233691AbiKKL20 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 06:28:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233518AbiKKL2R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 06:28:17 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2080.outbound.protection.outlook.com [40.107.92.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B28837374A;
        Fri, 11 Nov 2022 03:28:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IcEbYNQgmxfRNeH/1F28GRMlG9bs2ADPdcJSeB+kTOxnOMEFAALB3coxo9BYoMXHqONb8EvnbmY/Ys/hLnzILMd4RR/2SKOxsHhInw36PasdwhYkECz+Nk1I0MGS6GmyXJ6BTOrRVAD249Ivd7mcLbowjtKNUrVnkAfQfLeF4OcBUdKG8epZOrwbyZT43ZmvYlkS9U2/JutXWtEXATN0f5jh+OcOI2hQaPmsgwjJ4mYiufJSDWsnPWLs0OLswJv/eWrINGdy531skPL8ox4EujVLywxdyLV1ffNyQV4baSx/QnCJtol3smiETNoK9zXVJBAX3F2+Eq/JIl9vyRaLdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b0RqujRF09LAdJI744vQay36IkylUzCjrGS9WgbBUGQ=;
 b=bdjB7thTQ9rK/e1hPDvQS/fM3Nx3KUmcUbkeqmYNiYnBVfGdKTsSWV5QXg6JDNwet1MR5g76aeVA9NZ0QFK8yQPg/Zv1SH2KSeW+6GHdKSEv586/dakvN+uSEO6RBeoTwFF2oa8DP/r0wtIdxWlJa6CgGEJqxdpCdrCifsIDbvj6ItLKBzSLslRITW2cB8+HcvcZGsoHMfyMJ+m8FY5sghB88BfwwB0xoOoHqedbWcXTmFfV/gXw7FPlsB99087DoBY5bBa4NqLDU6BXBkz9mD0dFTv8NB0Vp3+3PTC9Z9n8a6/53NWQMiIFoyqt50gJmmB4uxXoUtMHimahRnIOAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b0RqujRF09LAdJI744vQay36IkylUzCjrGS9WgbBUGQ=;
 b=qCnuIGR2Jmkv0b3yXOteTju4S61jpDPYZ1i1OmggeY3ubtyK2iiTaswrBHET54WDPXfoFH/J4rnLsnG7gycbIATFrvs7xZ3/GE0pdKXBO0q5LCXBhMq46ABq9m5YxY8/e07FvO4Qri0l8yPfKDnxf5lxntBeArkPQB5vnaVXrcWKJ/HT8a2LC3EHD9qoqW/xGJOz7fcUP+p+35FJ11V5i7NmA01F/7MYAJ30fUdmMTWDKy78VjKhQ1ONHiPqjYx10KKNxd79rozu1MEfQcJKfXEpQp6pa6QkSBYESR75OwW9ErUr7m4lnvdqleSUYqLRGU2GuW0IOwsfPnxqB0JtXQ==
Received: from BN9PR03CA0183.namprd03.prod.outlook.com (2603:10b6:408:f9::8)
 by SN7PR12MB8027.namprd12.prod.outlook.com (2603:10b6:806:32a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.26; Fri, 11 Nov
 2022 11:28:04 +0000
Received: from BN8NAM11FT107.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f9:cafe::bd) by BN9PR03CA0183.outlook.office365.com
 (2603:10b6:408:f9::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.14 via Frontend
 Transport; Fri, 11 Nov 2022 11:28:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT107.mail.protection.outlook.com (10.13.176.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5813.12 via Frontend Transport; Fri, 11 Nov 2022 11:28:04 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Fri, 11 Nov
 2022 03:27:51 -0800
Received: from yaviefel (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 11 Nov
 2022 03:27:48 -0800
References: <20221110094623.3395670-1-daniel.machon@microchip.com>
 <87eduaoj8g.fsf@nvidia.com> <Y23x/PSlybLqaQIS@DEN-LT-70577>
User-agent: mu4e 1.6.6; emacs 28.1
From:   Petr Machata <petrm@nvidia.com>
To:     <Daniel.Machon@microchip.com>
CC:     <petrm@nvidia.com>, <netdev@vger.kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <joe@perches.com>, <vladimir.oltean@nxp.com>,
        <linux-kernel@vger.kernel.org>, <UNGLinuxDriver@microchip.com>,
        <lkp@intel.com>
Subject: Re: [PATCH net-next] net: dcb: move getapptrust to separate function
Date:   Fri, 11 Nov 2022 12:24:49 +0100
In-Reply-To: <Y23x/PSlybLqaQIS@DEN-LT-70577>
Message-ID: <8735apohn3.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT107:EE_|SN7PR12MB8027:EE_
X-MS-Office365-Filtering-Correlation-Id: 72ea3e6f-b1a4-47fe-aecc-08dac3d7cccd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pun6YTrwTfChpD5QnpF82QZL/u+C55ZcaAu6DIKNRjak5A1tQnTvxhbtgjA8hqUdsp/lLdIbk8gwvZX1tell58OWDA5I2FcfByjFDoKSSqGHDT1Z/aD3Hk9tGjJWv7E/ZUbVOdpa0oLh2UbzN2yn1ehks+LjOz98AJJzEUe37OIb3mVyVQUQy2x/nt59tKyhSPL3Otx0CbORZMfEpuDvZNnwy0nnE3EzqKFgUJHiE/kAOdplGXEtMCemkA2Fzvjb224WyhNTddbHjTbFiH1ENKhvdh1OE98OZkNS9lCK2UPrcqgKM50kgpVQZrzxhEAMtxs5WlLUQLNPczbXeaKqM5np+9Z32ScWMsZKFzaPbPW0qQSGjznbcCz4iLpzTr6FYkzNUEUe4+kXJEbiuiE7LPQGy9AFK4wKPcbdPejs7it/JK0/OiaRuxbBBaQJQItejYkGmBY4zGRu1hS21k07TXXaacmqB1Uuxw5kNTND0FC5xMxzPjPmWWnXh4C+QH3uT9BAkMDJIUF54FoRDY2ph/b4nq/KIk+KBVX5OxM0AUSf3I59iYviJdQG5zvItFl+8MnIuuLGI0h0IPf9zFlBQbj6WzXOi5xznsbsOgbt8Gam+bFaqx4KcYaji8pgTraVG0guBZp2KciKyzoQwyjz6L9hF0W7Y6LP2aBCNxrPkviPglOu6lzohv9lsvJttYGFf1emigEbVUTEXxVhVQZQrUoski2xOBlz8KfjawS8voAGhGB6M1H/3QLUCM6aCMaVbw68SLXrNIU9k2QFunWCPA==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(376002)(39860400002)(396003)(346002)(136003)(451199015)(40470700004)(46966006)(36840700001)(83380400001)(336012)(186003)(478600001)(26005)(16526019)(2906002)(47076005)(7636003)(7416002)(356005)(36860700001)(426003)(82740400003)(82310400005)(5660300002)(41300700001)(8936002)(2616005)(70586007)(86362001)(40460700003)(8676002)(40480700001)(4326008)(6916009)(54906003)(316002)(70206006)(36756003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2022 11:28:04.5732
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 72ea3e6f-b1a4-47fe-aecc-08dac3d7cccd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT107.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8027
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


<Daniel.Machon@microchip.com> writes:

> Den Thu, Nov 10, 2022 at 05:30:43PM +0100 skrev Petr Machata:
>> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
>> 
>> Daniel Machon <daniel.machon@microchip.com> writes:
>> 
>> > diff --git a/net/dcb/dcbnl.c b/net/dcb/dcbnl.c
>> > index cec0632f96db..3f4d88c1ec78 100644
>> > --- a/net/dcb/dcbnl.c
>> > +++ b/net/dcb/dcbnl.c
>> > @@ -1060,11 +1060,52 @@ static int dcbnl_build_peer_app(struct net_device *netdev, struct sk_buff* skb,
>> >       return err;
>> >  }
>> >
>> > +static int dcbnl_getapptrust(struct net_device *netdev, struct sk_buff *skb)
>> > +{
>> > +     const struct dcbnl_rtnl_ops *ops = netdev->dcbnl_ops;
>> > +     int nselectors, err;
>> > +     u8 *selectors;
>> > +
>> > +     selectors = kzalloc(IEEE_8021QAZ_APP_SEL_MAX + 1, GFP_KERNEL);
>> > +     if (!selectors)
>> > +             return -ENOMEM;
>> > +
>> > +     err = ops->dcbnl_getapptrust(netdev, selectors, &nselectors);
>> > +
>> > +     if (!err) {
>> > +             struct nlattr *apptrust;
>> > +             int i;
>> 
>> (Maybe consider moving these up to the function scope. This scope
>> business made sense in the generic function, IMHO is not as useful with
>> a focused function like this one.)
>
> I dont mind doing that, however, this 'scope business' is just staying true
> to the rest of the dcbnl code :-) - that said, I think I agree with your
> point.
>
>> 
>> > +
>> > +             err = -EMSGSIZE;
>> > +
>> > +             apptrust = nla_nest_start(skb, DCB_ATTR_DCB_APP_TRUST_TABLE);
>> > +             if (!apptrust)
>> > +                     goto nla_put_failure;
>> > +
>> > +             for (i = 0; i < nselectors; i++) {
>> > +                     enum ieee_attrs_app type =
>> > +                             dcbnl_app_attr_type_get(selectors[i]);
>> 
>> Doesn't checkpatch warn about this? There should be a blank line after
>> the variable declaration block. (Even if there wasn't one there in the
>> original code either.)
>
> Nope, no warning. And I think it has something to do with the way the line
> is split.

OK. I find the code readable just fine, so I'm fine with it as it
stands:

Reviewed-by: Petr Machata <petrm@nvidia.com>
