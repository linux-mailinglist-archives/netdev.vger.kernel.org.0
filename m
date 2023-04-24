Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EAB16ED1AC
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 17:47:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232093AbjDXPrI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 11:47:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231740AbjDXPrH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 11:47:07 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2057.outbound.protection.outlook.com [40.107.244.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D81A114
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 08:47:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C07aSi0dFHWqYCvBccxo9DeG18lr0b+f1ZJ8uvk+Yj4RzZocKEnaNAWhrtcOr08ZJfoLP7z+cVDxCsvu+CC7ppXkYcqGBMV7Yb6gAhtPpv7Fwkay0DDTSF5HzphGNa+NtpDMbVhDVomm315KG6mxpgfeQsD2ihv9m2ZWxEkeDqYERsOZjsuA/TFt+lIvNPervcOcwOIb795E6fSsLULjKegju6EC3xHZzVJujmg6aPwf6QOBjP890+79wg/8fKafn7NvFv8E9/STFQ1liZj9QtsqAC9r66GZ/TC59ZMweT0HVw65q3Lxop4KPer/cUElOi26KejUTWlPO9j5zs2/og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yJK4EkO7fWWh/YqKcNLoLvILD47QCm8kUErkkX7J1TM=;
 b=SdK1BSXiuJa5ancUW38wYdVnQf9Lvmigd0PrMN8aQNmMO/w1wnG1XFjeG8r1kGmfftGvUJ65qvZGj9svrIMO4P+pXjuLx5Kf2mwsjwvep4qhMkfZ8SEuGQ5VgvZAIsiRKHwEygkaByp70GP3DQIdyK+SioJyf6ITJ+AwKqWa/BBaw/X16jPUQ8vAlY0FPohqOrr1Yl5YjH9A4Q29g25PjB9Rr+9ejjY2aHK8obYw9tLG6iHk1lbaHtWYr+KYeNFDRI7tDth+Wt+Bargbg4JHfmhGk5CMNDzyOa9cG28mg3DaA0nU1E9F+TAdp9GTGta0dtwoNXI9HsKslkZ9cTTJIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yJK4EkO7fWWh/YqKcNLoLvILD47QCm8kUErkkX7J1TM=;
 b=I+i/vpFcpJiJow74wHAAzp8XD95WpF4XuXStIXiN6k8u78eDxEauRPg7+jWlKBLd/Xf5THyaGdtYpN2etAFXVb/xaCTshodzyUPIPTjB2/2wyaAx+1+rfSKxzq8wWyT3dDwKgBbAEZFLS0e23sqRJGbjBASu+1LhoOnyn1ModGA2alzggSalNaM4+Fc/4XhXglHaBnNiHC9yiqE5Hna4I3CoDmGXdl79FRFcBAOZu3r5N0q8ZgJaEhVaAEIhI0HnGNSi/i23G/U107JoKZi90ulDiRxGrEnNtKsfJ/oR0FvK2MlfS4VAIPj1qE632xP9XnSFX6448KDIibtZPgtXCA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by PH7PR12MB6611.namprd12.prod.outlook.com (2603:10b6:510:211::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.33; Mon, 24 Apr
 2023 15:47:00 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::66d8:40d2:14ed:7697]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::66d8:40d2:14ed:7697%3]) with mapi id 15.20.6319.033; Mon, 24 Apr 2023
 15:47:00 +0000
Date:   Mon, 24 Apr 2023 18:46:53 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        bridge@lists.linux-foundation.org
Subject: Re: [Question] Any plan to write/update the bridge doc?
Message-ID: <ZEakbR71vNuLnEFp@shredder>
References: <ZEZK9AkChoOF3Lys@Laptop-X1>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZEZK9AkChoOF3Lys@Laptop-X1>
X-ClientProxiedBy: LO3P123CA0028.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:388::20) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|PH7PR12MB6611:EE_
X-MS-Office365-Filtering-Correlation-Id: 4be6c4a0-1808-4967-ac61-08db44db2447
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GPSvMCJJQJiNQ+3HTlBbCLM2CAGN5gLbSTbbkBFyQZ/qMNYSDQFw7xdfED8Pm3XmBI2fz5AbknAa9cpVAnPFMhdWl5JYP2MCQcsY3nHWO6zzz4+24IdZ7rXT/6sIFfbplVdvSP1+LWpe4bfrS1WOJMfvdXp2BwR2AlppjdEZVey8+BzN44ZFKeS4TJ6LSouT8zRnSdTLp4xj0qX4fNph5lE5qBqYOr6tV+ucsR7MWEv+LdF2Gsu0SphmJmlEQdiunDhh5BsuB2iDfqfwZ6ys7lA7C1CVOocV/EVYIq1bVGFc/jLYlm7AQN2AKXOVbI14MlWwU700Eh/+ueYuamj3XA4gPBYjLukKee2DYCKzw0aTLQzCOK0xgtP1C8+gbEkleDA2Tjfyf1ktNBd52gx6WbZe28Re4I0/W5NCYGoHRKJDOFtBI3Uj/Q/bXvcaq14F6hrfdBfuTGSbwBQHyM+/wvUbQSFpUQhgWc492sNyekd39nhInJlTCN4T9r2suVffXwHBZU2FUG8+DsFZiCa3ZKuMXjZdqrxyYOLB2ApuoZjWSqhwNmv8QOgVBYVuJX8V7jESTc3JZujop4AWmeSvTXG8Te1yEqKSyV+235FRZI2D4xGSsnCVqGBDn5u4MF+b+fEKAKVZwKupt60/nuOaXA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(396003)(136003)(39860400002)(376002)(366004)(346002)(451199021)(966005)(9686003)(6506007)(26005)(6512007)(33716001)(186003)(38100700002)(66946007)(478600001)(86362001)(6916009)(66556008)(66476007)(8936002)(8676002)(54906003)(5660300002)(6486002)(41300700001)(2906002)(4326008)(6666004)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gndnrFme0cufULWhdrtUAzakEE/dQAMdhoagOiIKiPvPNyG0uALIq5JR+tRj?=
 =?us-ascii?Q?K9IJttdPeCCKNTVXkYbqs8ok8Y1OwQBBYgBEuRCIDKSs4hxs/ts8gv3cHXNm?=
 =?us-ascii?Q?zLWdHt0sylJxu2euomaYOb602TpRiWsaauDjIIVLyL9WQWtMxZmj8wzTVUkh?=
 =?us-ascii?Q?Oui2u+8w0eINJdUHQPj6utZDDMdggFbKABE3fJ2ZWIHirI51IBD9uRI0Y9Wb?=
 =?us-ascii?Q?R9ep+1sPr7WdKGIwNxVorrPeNwKaksJZugddMytIsPIC/e4l5vSZVb5av8I8?=
 =?us-ascii?Q?aW5ht9cTrXjgZiZ5zEwdSzA1f4FK01BPnTvMrwZjOHnMzzyDW5FVZRj/VinC?=
 =?us-ascii?Q?ygO51qqiuugrpgecwqN/czOM2n4RpyKNeq18lY4Ttd2FY7p8hofXoy80Xe/L?=
 =?us-ascii?Q?8uA3fDJhdcSGOjZoSh5c5vpVgdfnny1jjhY8ZcsavsBFMjw3MiiK9bYlU5/3?=
 =?us-ascii?Q?LtG05qHVlZDEVb82DYX650hecwbb6wC9vC+zs2JeD5h1JSg/GDyEbUzvrnqK?=
 =?us-ascii?Q?eiBVaIKxpYnnU+CUi/kjM9+P+jGwVca9MNTOo3oyHSuz5119WA77Ecm8RHOW?=
 =?us-ascii?Q?3pf5iAWoJu0TDj9Vd7QJtgResIa/2V+lReODJ7J8oKPQ96ynmPGxf6OIiXqF?=
 =?us-ascii?Q?sQdkwARskJEh/E05C5JSQh30+KLWpEgs9Et1CfpwdEvkX9jKwCdwRj+wAXHD?=
 =?us-ascii?Q?LjJ449dvmz2TUxiVyP+6nV/pM7e4Y0adr2Yiof3x++ZKSLWEyt+Y4H0ybMZN?=
 =?us-ascii?Q?xq5/e+bap8hXQYuYr8Uo8DrHKd+XzM0a4CwgZ14lE4Kaf3hl7J61DW3bAxTP?=
 =?us-ascii?Q?4krl/IOifxgLKOAzjHN52L20ytLe5ovdpOF+v6jxaeipDGfUaCXMgklPjWHL?=
 =?us-ascii?Q?SfLjLaDfjQ3e9uYMcHx6st3VgN+MqBSyRo+mIsOLlL5rxmdtzPQqKBPBZvy2?=
 =?us-ascii?Q?HgmN7YfflD9NpgvhZsirAAIhs9PP+YoeFsh9n7l3xGa63ccxKRQE0mP3SUAZ?=
 =?us-ascii?Q?kSUdcTvM6v3pt995f5jG+UQGh+cNuly51YlxlFLNRmDXXRo4H5IsYmE3ri98?=
 =?us-ascii?Q?QDYDYJlOK93g4t7P8B44nymjDmjSPBMf9Loknav81hcjGO3pHZSKvGqUelqo?=
 =?us-ascii?Q?hhsHSq9akLrpUx0FFcdIAoxxiax7Pw2RxNhdU0ybJ507kaFNNEEQJBTeH1dd?=
 =?us-ascii?Q?9Fkp9rZOhhJB8IUI1ufc+JDEgLJ7H710g1hp++5lZm1UFdpr5Bj/iBg05ctK?=
 =?us-ascii?Q?LpvonXJJ9uxxPXCMI42apURyLZkFZU1TFqxHK/GWAFNhvaVkZmGPDFqvn1LX?=
 =?us-ascii?Q?G89fgRmAgshUnJaZ9glXL76cT2YAcNCvADbONaK1oOCOjpDgjwR0WQGhJKcm?=
 =?us-ascii?Q?LsMPtewFsRKBajJV7BsmefMpM2InZ2tp7a6FFL/7PtVDOAuI7Iui7DDw9Bob?=
 =?us-ascii?Q?OZznggSCsnUlup9kFdnSY4xNcomomKAgQfki5wkMZOOxhc/JP6pPO7hmAPWc?=
 =?us-ascii?Q?d3nloDfbVIq19jNYeiuVBMZo48sB9y5+6YzmEj2ZNCP7ge3RmPhm8SFvWCHL?=
 =?us-ascii?Q?xCNQ2VnHv2LzgKLc80r5pbE4wXtREMyG61UL5pBf?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4be6c4a0-1808-4967-ac61-08db44db2447
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2023 15:47:00.6222
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Txs8cer69us5O9UMIUDg3pfKp0Cl3ok8PKg/jbgkp3TmEa8rU142DZbG4c7h0gamSARuEYzjlb3BmnG0TDEmgg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6611
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 24, 2023 at 05:25:08PM +0800, Hangbin Liu wrote:
> Hi,
> 
> Maybe someone already has asked. The only official Linux bridge document I
> got is a very ancient wiki page[1] or the ip link man page[2][3]. As there are
> many bridge stp/vlan/multicast paramegers. Should we add a detailed kernel
> document about each parameter? The parameter showed in ip link page seems
> a little brief.

I suggest improving the man pages instead of adding kernel
documentation. The man pages are the most up to date resource and
therefore the one users probably refer to the most. Also, it's already
quite annoying to patch both "ip-link" and "bridge" man pages when
adding bridge port options. Adding a third document and making sure all
three resources are patched would be a nightmare...

> 
> I'd like to help do this work. But apparently neither my English nor my
> understanding of the code is good enough. Anyway, if you want, I can help
> write a draft version first and you (bridge maintainers) keep working on this.

I can help reviewing man page patches if you want. I'm going to send
some soon. Will copy you.

> 
> [1] https://wiki.linuxfoundation.org/networking/bridge
> [2] https://man7.org/linux/man-pages/man8/bridge.8.html
> [3] https://man7.org/linux/man-pages/man8/ip-link.8.html
> 
> Thanks
> Hangbin
