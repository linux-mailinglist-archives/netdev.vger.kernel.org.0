Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 353754B08E7
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 09:53:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238004AbiBJIxk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 03:53:40 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238001AbiBJIxj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 03:53:39 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2087.outbound.protection.outlook.com [40.107.93.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14506E7A
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 00:53:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UtCui2tnqlHYsYR64eDIt6nQ00i/McbXoJODvjMb16U9ezR7ksOY+4a6iX02T6v6W4G/AMzJnG2lK//3LT+zY9aZ4dIPS7f0Ice/Iq+YyUAJ5ksn+6/fJyj0DUcaCIZ4jODkcCac7j7SnIz+mSv+V62g9/TnIyvoIY4MO85TvZjs717je8ESYtV8AIQZSMtP4ZMAtnXfAe8qOuBZUBpA2qtlHXUo51caXcSRfg0S0pAARtP3RJML0u1PsybdBZPuuhcOBaIIzygpsG4iYuZxaG1J73Zz7vOLFHwyf4RtTJVactEHakOUIIuFrMOte4YgTp1pykDfwMXKbVgBJRk2Wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sb5r6l6nilXF2hle6sDyu0viogtDoH+gdg94znp1g2I=;
 b=ll2+HCvucCna7dgB9aX2RP9yWhVcD+S6rNDrUQbsDEad2aWJ8i259GuWXzJVyAO2qaTLZgd+Ysmq2X3Y4OL3EpNN+NqaxA0GIO6plWQqnhXpv9hY3JZqlH/0fhNI38eD7C1wzCuHxA18SpksDdFqZAKo/z1f2N9sdqkwFkNH9HSEYRwf/3PSnNM9XDMsvezXb63jE1TIRAM+Ktl9zNxf37xd2gQgsPou/MheVX9jed8HLlfxuhP2hkbwhSsvbMD6U4wxDXcB9qA3MoSwMXg1Jt52TDuAkYzLzUOb235uQnVkOexKjdd3M17/z9h5sEqXY2j2nklf1h13fgmwyQaB8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=ovn.org smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sb5r6l6nilXF2hle6sDyu0viogtDoH+gdg94znp1g2I=;
 b=Cge4zNl7gn6/qkIbTA4NRzOkiOsBk1gDeXE3WbfTftlaFYCaQpCdepb+FaZXCx+hAxhaCTG20sLaOAdscqw+0HPT6dkMlVx6rFdopYwDEBDZmlgKLk7+++jTpy4y2GIUYmQTM4U7kwmQy85mNqyM2O8ayEvHtQudqiGMDxF++vz7Te6n8Q8pL6+AK8OWeMhkaSgztzxQOhllCRsbZr/rWzBe86VChb3jIUlQ7qJdT8OqW2/vKakukCRYrDC8SS7eM1cEBLTmWQ5CDF0WpdtYi6l3/Sga3RolQaasniTE3L6UEdplbrpj74UubEh4OKX8x7KhFYrc7bA1B/izqUeQnw==
Received: from DM6PR02CA0072.namprd02.prod.outlook.com (2603:10b6:5:177::49)
 by MWHPR12MB1407.namprd12.prod.outlook.com (2603:10b6:300:15::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.18; Thu, 10 Feb
 2022 08:53:38 +0000
Received: from DM6NAM11FT065.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:177:cafe::7e) by DM6PR02CA0072.outlook.office365.com
 (2603:10b6:5:177::49) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12 via Frontend
 Transport; Thu, 10 Feb 2022 08:53:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 DM6NAM11FT065.mail.protection.outlook.com (10.13.172.109) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4975.11 via Frontend Transport; Thu, 10 Feb 2022 08:53:38 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 10 Feb
 2022 08:53:36 +0000
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.126.231.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9;
 Thu, 10 Feb 2022 00:53:33 -0800
Date:   Thu, 10 Feb 2022 10:53:24 +0200
From:   Paul Blakey <paulb@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <dev@openvswitch.org>, <netdev@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Pravin B Shelar <pshelar@ovn.org>, <davem@davemloft.net>,
        Eelco Chaudron <echaudro@redhat.com>,
        Oz Shlomo <ozsh@nvidia.com>, "Vlad Buslov" <vladbu@nvidia.com>,
        Roi Dayan <roid@nvidia.com>,
        Ariel Levkovich <lariel@nvidia.com>
Subject: Re: [PATCH net 1/1] openvswitch: Fix setting ipv6 fields causing hw
 csum failure
In-Reply-To: <20220208201155.7cc582cf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Message-ID: <5ee3304d-162a-e5b2-f8e9-5a4d52c71216@nvidia.com>
References: <20220207144101.17200-1-paulb@nvidia.com> <20220208201155.7cc582cf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 797f51dc-1327-4e31-15f7-08d9ec72d469
X-MS-TrafficTypeDiagnostic: MWHPR12MB1407:EE_
X-Microsoft-Antispam-PRVS: <MWHPR12MB1407830B2EC05FE1AA0CFB66C22F9@MWHPR12MB1407.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DXybZA/y+TH9/v3vmboRJXIDKtMw2bzyqh+qANAHUBmUgc4BFcT6Szi3FD9dxHFh317uxD1B7oRRUgmZc4POaRtKRI+nuH6pwqfLk1qZTr9yRQgyyhiAV5EVwWoWPwED5/ekQQuqyQq+93XlDkyRghiqInsc8/W9W6B70E7wv/kGeokKSEqAsLd90/3ZptWO9M7yaiIx9jXm24MNwGKJinEKraFdl+koSkkBYuUadg+NunV7j1tYgf7ic4WlfDNlXIoh33q+sdy5fSsY0uH3jJ9o0pCmy9rqM9vD69Bnon5O2rA3bsxqeKsTaEqiuUUtseIiJZmptiV82gEbFwCcAvbjghmj2aBgKp9u343oJF5dSJ43+PtCvBHZYgjBDjbGI9nRNir+OUAhIt1EuvU0cZRrUnPUgpIGv28EULLUvB3lxCccCCT4J66ADwm4JROOsU8eRZUTAv7nBGWI7Szyyjg7eqqwFs13LlVJQIW3ZT7uyemAPfMJjBoqkyOAnCdgapYywOdhjVbo4S7A7NcXb52zQYdFIoi6V0LjOrKOw/DNJFYhEYudNMJUKJUarQcCe9+tEtciv8aGBg90AQYHHIN/UFi6rc06yoDYcb3x1CjmrxiGtqaMcmo1MsS3TOFzcRNVKGD1kdvzdKnd2oeS1A/14/KFCJk9pdT+NV6oSxpnv7CHo08Lq4XbTYh+Ln1+dG9COQxnl+H6GPpXjBNBEA==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(36756003)(40460700003)(47076005)(8676002)(81166007)(2906002)(6666004)(356005)(508600001)(31686004)(54906003)(316002)(83380400001)(26005)(82310400004)(426003)(336012)(5660300002)(2616005)(107886003)(186003)(4326008)(8936002)(70206006)(6916009)(36860700001)(16526019)(86362001)(70586007)(31696002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2022 08:53:38.2469
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 797f51dc-1327-4e31-15f7-08d9ec72d469
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT065.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1407
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On Wed, 9 Feb 2022, Jakub Kicinski wrote:

> On Mon, 7 Feb 2022 16:41:01 +0200 Paul Blakey wrote:
> > Ipv6 ttl, label and tos fields are modified without first
> > pulling/pushing the ipv6 header, which would have updated
> > the hw csum (if available). This might cause csum validation
> > when sending the packet to the stack, as can be seen in
> > the trace below.
> > 
> > Fix this by calling postpush/postpull checksum calculation
> > which will update the hw csum if needed.
> 
> > -static void set_ipv6_fl(struct ipv6hdr *nh, u32 fl, u32 mask)
> > +static void set_ipv6_dsfield(struct sk_buff *skb, struct ipv6hdr *nh, __u8 ipv6_tclass, __u8 mask)
> >  {
> > +	skb_postpull_rcsum(skb, nh, 4);
> > +
> > +	ipv6_change_dsfield(nh, ~mask, ipv6_tclass);
> > +
> > +	skb_postpush_rcsum(skb, nh, 4);
> > +}
> 
> The calls seem a little heavy for single byte replacements.
> Can you instead add a helper based on csum_replace4() maybe?
> 
> BTW doesn't pedit have the same problem?
> 


I don't think they are heavier then csum_replace4, but they are more
bulletproof in my opinion, since they handle both the COMPLETE and PARTIAL
csum cases (in __skb_postpull_rcsum()) and resemble what editing of the 
packet should have done - pull the header, edit, and then push it back.

RE pedit, not really the issue here, but i guess pedit should be followed 
by act_csum with the relevant checksum fields (as we do when offloading 
ovs set() action to tc pedit + csum actions).
