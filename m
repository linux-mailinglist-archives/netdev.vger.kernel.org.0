Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E5DD57CA3B
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 14:05:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233451AbiGUMFX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 08:05:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233440AbiGUMFW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 08:05:22 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2087.outbound.protection.outlook.com [40.107.244.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69DDBBC80;
        Thu, 21 Jul 2022 05:05:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l6auCYbu4+0MxyK6skxJ6EPk/ApM9kxGBdtLrShrCbZ8xCop0t+8waeU1YUC+6tL9ghsdXlBpG61lAG00b3MO0P0ZnokEM6IkSNtHeycUIB22NwAXdEH5MUmgQorOqYrbqAwcICvlPIOf/JuKDEzwOZB2PWkI86cRk+3w2IxzoxhWigURTkWaEFVcQHqjTxjM9thYoCHY9HmGev96JlWpsxg0kdkSgghhB/AkT34podru2vSWh81sNZzfxYrjOA1edcJ33AVxi4i8KStrwwqrakAgTnpg1beh9PLoFYyGpHc5HqiD3YbjKaXOk6SmlQofmSe+c3dfUH0HSvWny92wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q4wj5QxOqnya3nq5I26NiK+pwMToGk/vd1XWyAQP6qU=;
 b=lAltYJqnIt68+GKY+b4nl68h2o3O9k7Kb6otmN78XansYkq3feaY+Lto0FwaNzfsTwYf3ArUZG6jXuvTmAdHSjumBHA0e6NFGgLzcZou+XEqPL1vN/Rl+LBeBQ49ZV1hzv1u+RdLgQtN6TsEX1zRvsJXJ4rATR/yJRlbNAWGn5iuyG2/CLVTjBeePo/Jo6GUaO+g48IKsxH79kxvpPBFwKJvJAoSobQvc+Fu75rR8jn5lFZPgyzt8IruCvysQAIy451e4BODLv7wNbS2rY76IvoJsF5HVH50OxdbKZVQsZMtfX4iyk9Z/8VENbp9glU84Jvv6hEckwdTJCAVv4ONvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q4wj5QxOqnya3nq5I26NiK+pwMToGk/vd1XWyAQP6qU=;
 b=XOjHZLSY2SjVeCbeutQn5OP33f93uyYreTdDs1/9BfFV/FM9uC2GHlPgiqUzHIOaLZMhFMzco8Ysu0mrfvojyXgtEobqP3h1AOj9LZFtnBKhZj3K94zOwz96XspclcgqVKC82UgI5+lTTLh6vxzCaFn8/9ZH5bCU8GXWMJuWqD9l8mnkEEZNX2BBmXSR3EmptMJr2oUJ5ae03cfMWDvzEUj1XIKB3O0fBgrpS4dF+5W6JhkvDAjfPQAE52LAUHFXYlfjWXQCE+9jPDWra26TeZ1EfIkiM+MZhBcsRLDaqjcP3GhDsOz5Wl26wZPux02kFZ1En1gTYzJw+BAkkqcFNA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by SN6PR12MB2816.namprd12.prod.outlook.com (2603:10b6:805:75::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.17; Thu, 21 Jul
 2022 12:05:19 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ac35:7c4b:3282:abfb]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ac35:7c4b:3282:abfb%3]) with mapi id 15.20.5458.018; Thu, 21 Jul 2022
 12:05:19 +0000
Date:   Thu, 21 Jul 2022 09:05:18 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "saeedm@nvidia.com" <saeedm@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "Martins, Joao" <joao.m.martins@oracle.com>,
        "leonro@nvidia.com" <leonro@nvidia.com>,
        "maorg@nvidia.com" <maorg@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>
Subject: Re: [PATCH V2 vfio 03/11] vfio: Introduce DMA logging uAPIs
Message-ID: <20220721120518.GZ4609@nvidia.com>
References: <20220714081251.240584-1-yishaih@nvidia.com>
 <20220714081251.240584-4-yishaih@nvidia.com>
 <BN9PR11MB5276B26F76F409BE27E593758C919@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276B26F76F409BE27E593758C919@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: BL1P222CA0026.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:2c7::31) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dcddf148-e9bf-4826-7ed2-08da6b114839
X-MS-TrafficTypeDiagnostic: SN6PR12MB2816:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OLBbbPE2EHiMRsr4/iLgIbIJCFUDCRnd/eykvwIvHzEyna7lnnTqtUn+E2O04GRU+o2qyDxEfh4uXNZ1wGoY161BywtRys6c5S2peIPA1oa5gCyau5qM4uxH7q8VkzdcyO4XWvsmFiuyEAL6DGiFeh6q7+ZE08Cp8n3Ccawg6cXm7ewAYyloqQuzxWJbY3ucLyAPCvqL05UKgRniZnTdV0W+ITVs3z1+1qyOanNCBM76vd6SXooG2UqvV5hcZVTn6/a8XLPMklCiJ7YXLlQAr/EnGs2ElfskWHoFoSSAAcVRJEA9x2KidhKTFMx/KvGd8KStL+aUOOcYnrgH+Lz5MZp7ukjsGbJRGIQvaGXMZ1lG2uPDYKVJFbSsrmDeVFcez1qEKr8VonJ5c0lQ2Qqm21BMYEMiUA6Ytd4275epCsBwA47/Roksn3w14pbZ4FhsbH3NV0nv6tBEvFA+FBh7iaFI5ffbKstuEahQ1DJeywDkpiAQojWDJcL12GqD8xwjtXcWHNp7eGoNphDH8WNiewn3+N5QKJj1DucQ6wiAVUvLnHbtJdfK+QS+SNED+21NtQGvcvCIdLWV8VJ7Xr7/Xp107vFD/k9qpsr4Vn42gOSgjWb2x5BBQY+TVy/Y1YMcFair+oqpi0/vMPxJPctijMSPAwSVy2zrnRQfXM/0b6HXAsXVnCvdap4tBrYzLUyVHpq+o+cw/h44Kz778ljyZFSjm0YOFUbLWIhDAy7ObFiP3K0CdrKvLxdPNNlKCXkG
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(136003)(376002)(396003)(39860400002)(346002)(38100700002)(4744005)(316002)(66556008)(6512007)(8936002)(6862004)(5660300002)(2906002)(33656002)(54906003)(8676002)(4326008)(36756003)(41300700001)(6506007)(478600001)(86362001)(26005)(6486002)(66476007)(1076003)(66946007)(83380400001)(2616005)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IJzW+WCXqOgJmSeL72Sf0A+N2Xl9yybGuFCc1KNjz7+ghY7QogunRHz9Su2u?=
 =?us-ascii?Q?qlR2kpYpWf4ECrgUqpbuern0xjvj1Z94iA70E96+v2s402PiKd/JgMfXm1wg?=
 =?us-ascii?Q?NT4XKBeBrsARRBpU0lP4/HxnoDKhGQjOeYBLz5ZJy9PZGwwDvhCCSwi7Mt2S?=
 =?us-ascii?Q?dwAcjr/QrJSWi4Fio4or0PVISEXcUIvKFOi/KSaYqcX/FJySL9iL0Vcw5btR?=
 =?us-ascii?Q?Y8HKng3XMjkCo5D867HUvtZ/iOFAxORfBu1thmhBHlh8NgZh4XpAz0btAOeI?=
 =?us-ascii?Q?ilZ3PSxV57hhJfUjttTPaclPtqTG4MSymbicVGP4FbqwcCOs5SrKqlRzg98/?=
 =?us-ascii?Q?Ap0YaJZ8tIoEpGTduboAB0ZwDWxYCOcpe4GuUjvtNl2U4RZCJ2N3oIhihoeJ?=
 =?us-ascii?Q?WABCqie/PkpNp9vXsVj6kDwKs0bfL9ov/Ei5DDxkq2b79yPQgzVw8xYRG8sj?=
 =?us-ascii?Q?6kes4jykzmDuIqZHUCVMSATCrF6kDLNVARe56WEWnWzGwjvbYeAwSH+31qvM?=
 =?us-ascii?Q?/WXlFQe2S26Ru3fCFZPpHW992ESuTkVexXyg6cHBzXVYsn5m/rMLVrF4eM35?=
 =?us-ascii?Q?2VJz/CNQ4zM5pme6AeK8ya0XwldGyARAWN1+h9ntajPWCddqOrf1YbGmkHrJ?=
 =?us-ascii?Q?CrMj0/L2+XyMsg1W5oezihZxZeWSOKKY0vp94WEk8F7c4nz+AwybLh2t+0B2?=
 =?us-ascii?Q?t+VndsOfRuQZwoFlvQp8iDh3C6fjY0zLrJGSkFFujZIp0Vxi1uBj1vRzrT+e?=
 =?us-ascii?Q?Z/8EQBvL5No0UuBDiR599pqFln1HRl36CZUMDeuHcgYYRG3QvjHuK8/KT9qY?=
 =?us-ascii?Q?RtybFaufAFU1Ud4G30mcD+y0tlQWfeky/K6tCIkfDZhFPG5z06DUXFs33JPr?=
 =?us-ascii?Q?sC6GypnJzk2RSGqz41jZoP8b665gH0nkWLoGYuxGWYxvxgTLcKLH1T+C4aNf?=
 =?us-ascii?Q?q02zRpoQVlPwa7Kv+LIMOd2FKMFcmgvcZiaRRpwvC/7dzYhF8reyf/17q3Ai?=
 =?us-ascii?Q?NWwTqN0xburtLbtMJ/p8DwQm7FyN65o5fV7UyJQT8pRlCuCm11bgwaVqqSGs?=
 =?us-ascii?Q?i1obut7jQQZSPPok1Rh8N/4GnWVCNeD+MSnSi/ga7/71x24qjPkqSB0h81kW?=
 =?us-ascii?Q?Bo6Bk7N6kt7Tv8xrePR2x4VnK6DujuBQYr7Eta87cih+pEcd7hE8rJZvYlGL?=
 =?us-ascii?Q?fr8kSLepicuZtDXo2h76fXRvCcJqwmQ8Ackgsh/puQLGneaymBP4+YADReGj?=
 =?us-ascii?Q?l7rQwUduTOH5RxVBXlKfjnmqs7Ge/wdVq5ILIXLUHEPWaoTAX593PIaU0/cE?=
 =?us-ascii?Q?mMPD3b4GJ05aKoTtWpobvY6oN7+8sFOL7w9OwP448wYFlRiG49tn74PnOjhQ?=
 =?us-ascii?Q?+8GVRd2UEsJfUdgkgffEIFb22QJfFRUmfdSEjy28z69wF7xiKauqZtwX882U?=
 =?us-ascii?Q?Phlc1EUuE5cy0tM8HqAtqy8zOf/z8wdhQiOIi5cg861kBWy0nSKq6/5jNHAe?=
 =?us-ascii?Q?uFIPDmY/KoQudSMkelpwChYuUnF1yPSp6tqFpGiVeHkoi4yM7G7m878NJo5j?=
 =?us-ascii?Q?HENz9978+YrT3y0jUE18n3T/R2Xe+n8FCX3mKqHC?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dcddf148-e9bf-4826-7ed2-08da6b114839
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2022 12:05:19.7783
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8N5IBnb5ECso1PoMO/BO4vE0KhuZBm7nQ83GNJFTTzGWuMvpwWl14pPjQWZn0GqR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2816
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 21, 2022 at 08:45:10AM +0000, Tian, Kevin wrote:

> > + * will format its internal logging to match the reporting page size, possibly
> > + * by replicating bits if the internal page size is lower than requested.
> 
> what's the purpose of this? I didn't quite get why an user would want to
> start tracking in one page size and then read back the dirty bitmap in
> another page size...

There may be multiple kernel trackers that are working with different
underlying block sizes, so the concept is userspace decides what block
size it wants to work in and the kernel side transparently adapts. The
math is simple so putting it in the kernel is convenient.

Effectively the general vision is that qemu would allocate one
reporting buffer and then invoke these IOCTLs in parallel on all the
trackers then process the single bitmap. Forcing qemu to allocate
bitmaps per tracker page size is just inefficient.

Jason
