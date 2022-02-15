Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E86C94B6D1E
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 14:13:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236624AbiBONOA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 08:14:00 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232319AbiBONN7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 08:13:59 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2084.outbound.protection.outlook.com [40.107.220.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE289D0075;
        Tue, 15 Feb 2022 05:13:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EoaH1MDhbt0Ix79j7rOVjnnu2FXmSYl+E6Oiymt8OpZOYqyVerULRU6M5nIS6QZ3W6Thk1zuMbKPiWqo1pE38A+ub2iFGf7JaLpLjtTfz1bXfRcaA9ov2ybotkfmQgaIhHbEkSg7ZhxIOQzypawbslDZroRAkhTckJUEYVcPppiu5fTYoEAInwW8j6Bmgxu8zPDaZZ7kXkJw57iDY88GDsakGgKbJGCdz6+Oghnu9vlUg82HPBH7A3ne2XM6LzE/w0uwkZBdWk9Ot/7xm2kWa4cXh8MUX2WP953fl3gV1OKRvRKG6cp5pY/IymTYimgXtsNXn3tEob/olyPvoO7trg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h0jYvJlYqNibWhWt5vFpAcet031fgHvJFsW4+USeezY=;
 b=AuTsjP8Skn90Ss2DgyUPgkPhWOPZbF4eDyJgY+JTXtJE50TmjTQcRMHPAel1GG8rfDiNNO9t2hxsWITNy0c/sF+HPNDYBUBibaSJ3DNxeuyoBImLzVOAhznWOKrE/bXfqzATGqYWo2WFQdcGO9ki//rrfdDUYiNalcw0FSaBh1HsjTkhm9QiFKbAXY5c2bOjO1LNSyjPoSbbtm7RDA8MSMut4AMLb7g/DNfNMGyR+vtFrT1HKG9q2rtf/6UuIsLAKsAn66KzqSiBeko97fFPQhAFnLW76/fkv9TAdxd37Wdvhtj+gcPoZ5nEWtJPinyomK8++CJ1aYAvNsQ2G8ecPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h0jYvJlYqNibWhWt5vFpAcet031fgHvJFsW4+USeezY=;
 b=WH+YwVkc/u5sy5jKf9Vu7wNOmHlQKjKF1nqlAEGY2lt9ELEzzVGgEec0qm/2lzw8cfE8JRQ5CqsmmgIcDPjnKlJz8qLudyMh0dGKNrAcHvKbszlvLgGvNnwh9wu0abTpyblneE04fjMcakJEEag/hqVwSiCrrzDt2bHzK+8LGviOg8LgZthNObIdfZKvbaOO6BwwETrwo0TqJLSJ6XPzizsKRMiCQ2zAZYnSw0N8pzPu3qRSOMcZ2ZbfJ5bKvRNq7NrEqtG0xWyGeZWV+vEIcYw50nWHiF5perL4juJSmK7Fi906QquvaHQYQyXaTVo8G+Li0TD/zEPtkLCMKbHt4w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH2PR12MB4181.namprd12.prod.outlook.com (2603:10b6:610:a8::16)
 by BY5PR12MB4801.namprd12.prod.outlook.com (2603:10b6:a03:1b1::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.14; Tue, 15 Feb
 2022 13:13:47 +0000
Received: from CH2PR12MB4181.namprd12.prod.outlook.com
 ([fe80::287d:b5f6:ed76:64ba]) by CH2PR12MB4181.namprd12.prod.outlook.com
 ([fe80::287d:b5f6:ed76:64ba%4]) with mapi id 15.20.4975.019; Tue, 15 Feb 2022
 13:13:47 +0000
Date:   Tue, 15 Feb 2022 09:13:46 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "saeedm@nvidia.com" <saeedm@nvidia.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "leonro@nvidia.com" <leonro@nvidia.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        "maorg@nvidia.com" <maorg@nvidia.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH V7 mlx5-next 08/15] vfio: Define device migration
 protocol v2
Message-ID: <20220215131346.GM4160@nvidia.com>
References: <20220207172216.206415-1-yishaih@nvidia.com>
 <20220207172216.206415-9-yishaih@nvidia.com>
 <20220208170754.01d05a1d.alex.williamson@redhat.com>
 <20220209023645.GN4160@nvidia.com>
 <BN9PR11MB5276C361E686DCAFA8A078788C349@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BN9PR11MB5276C361E686DCAFA8A078788C349@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: BL0PR02CA0060.namprd02.prod.outlook.com
 (2603:10b6:207:3d::37) To CH2PR12MB4181.namprd12.prod.outlook.com
 (2603:10b6:610:a8::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: faa853dc-7fff-4b00-adc8-08d9f085002e
X-MS-TrafficTypeDiagnostic: BY5PR12MB4801:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB480188E89A56C8F44F680D96C2349@BY5PR12MB4801.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E1IufAhPv9fGUeYuNQZ3E2XkGidPMGg3LMW1KJ+d+5Kc1luwehFxMQgD0gSS2HB+Z/NmolbJ42DM1WMmB8Qo+luWxF/KmPkYTJwq1P93n8gJaswwx/fhbXB2qa50qk1tWbOLuvk4Nxu0LkQN2B9GrJYbcsbk3Orjz3IFyt/7Io9d5qeNDUAcEvW2+IIDE7JL3uoCEMQQqIf4j1GlRgZJoTyZ8a4hlgCuPD7y6QXjtPtfIunXl3NPSkdNvKQ+/s0hrr/EyLA/YMxWCz90Xe0QHRAs9PZ+SD1C5gVa0aR+0GU2MipGcQAQ2yi5Bc3R/s1j+AdOIdql8CNJgGPulidhrhTpFIX11nmYv0f3kM5327fXWdkfMBaIsc3+P/IeJnIZLDvpKdMNGa6tK/txDzf0oVLYmIFIA+Vcz5VkFO8Oiq8AzbjANaICroi/KLUXvYVjE5Hsw0pTlAiOJprcVfKsy1M91ilAg2ev26OCgUSZMIMWkTWMo3xU1gexFVepDZcVFC84UqvA900ZBVn218wuulKRYFNEGsXV1f7t3lXWPQDZhbOKy/YptyuIpGHAnzwQ6F8V8tWCQtBTmPIwXcbRuWCj4agz5QBU82EhKzskiA7XcXK6+W4xQQ9rvUNJLTFITL54LgX+QPRfSSJ/3pGRmA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB4181.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(1076003)(4326008)(2906002)(2616005)(66946007)(6916009)(66476007)(66556008)(8676002)(316002)(26005)(186003)(54906003)(86362001)(36756003)(6512007)(33656002)(6506007)(38100700002)(83380400001)(6486002)(508600001)(5660300002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZWdRNStvS3QxaXg4c1RVTFphcDFQajNQU01QaTFLMi81YzU5eFpHcEl1clZM?=
 =?utf-8?B?N3FOc2gxUWJmQkZJVjNiUEdFSHZhWDVRRnBqWmI1emFqRkVYQmNwZnZrcEhq?=
 =?utf-8?B?VHhXNDVTWlhqVUZaZHFqQTI0Z2VLQXk5NENwT2drU1hJYUJjejBJQlJjbHpT?=
 =?utf-8?B?d2lhMXp4NGN0cFdLbXJ1M0luT0ZCT1YwZlBDV1M4MWlDd1UvS0xaam9hY1Zv?=
 =?utf-8?B?WjI0c0QzNWVvMGQrRTZnOW1zU1NZZ21aVldsem80WE1EZVpXbEtpK3VUVnho?=
 =?utf-8?B?b3N2MGEwMmo5bFZDMlc1MmpsZGM1UzAxSXZYdXJqbzlpV21sZW9pMnpMeURw?=
 =?utf-8?B?Q0dvbzY4VksrN2pVOHZSUHlUeGk2VEhEZWxIdE00WTNpUzNFTkhaWFcxUVpX?=
 =?utf-8?B?aEx6NmgwbS8zVEVTZHZheEpFZ2JEdXFaQjJQL0JPN1NBRkw2VzgrQkM4RVVG?=
 =?utf-8?B?TW5kUS9ZcUdoNTh6dHJYZEJQK29keWM5RFZmS0pLaFpiUVFyQlZzQ3VHL1dv?=
 =?utf-8?B?Q3pDQ1UyNFVOZzlpOHZIVDFaeGNwS1JzMmVNd2dkZjF0UUtOTjFNU2d5a2M2?=
 =?utf-8?B?TUUvZkNrRDhaZGxZTkFlVGdCUyt3QXc4RkhnMjlLRHZNU1JPUkhiTzF1eWRG?=
 =?utf-8?B?Nit1L0RIeUJZUDdsdWxweGlpdFNyeXBleW9JYllsV3NSMGNaeHRSVzZCTi9n?=
 =?utf-8?B?SCt2SkhFSzdwbUwxbkJYSy9BUW1MVGNLcUtjOHRkQmVvdVdNY3FrR0grTUhp?=
 =?utf-8?B?TnlIajZrT1BMWlh5YzhEQU9MRHkyRnc2Snlzd0NVeUNqTGEyWkN5WEpZVFZY?=
 =?utf-8?B?N0VpWmpFeXpYbFp0dE5WZ2hiaDZZMm1jT2dTaFMxdVNiV1RVNjFPVE5HVXUr?=
 =?utf-8?B?YS81ZXN1bVJ6bFVlVWhqV1pCQ3B2TlJXQzAyVGIyeXk1Rm5iano3Uk5QTnNq?=
 =?utf-8?B?VkhqNU5XWjN5V3l5eFlVRHRDTWJsaEJHcG5pYmhSc1NYMHpRYUxnN2JzZ1dP?=
 =?utf-8?B?YXFiT3lqbmNHdG9Sa05Od0hXK0FjVTkxWVB2ZUE0Y2c3ZUhiZXVra3VjazZQ?=
 =?utf-8?B?Mkwxc2dwcVExREtDY25OOVZZU0dySVZCdGdPL0tTZ0E0RktreGZiZFJ5a294?=
 =?utf-8?B?b0U1VzBxa2FZKzAyaVFnR0EvalNzR3Vqc2l4ZkNZK1JrUWFXS0wrNWQ2N3Jl?=
 =?utf-8?B?ckx6MUdZaVpRbHluMEZIMWk2d0lVMVVVdDMzMjRNaWxnbEIzQmZBRWI1R283?=
 =?utf-8?B?dUJBR2tBVlhnN3JaaFRPQVRaV0lXMTJjQjh3alAvbzJSdGNJYi9Sa2t4blgr?=
 =?utf-8?B?cWNaMXo2UjFpY3cxTGNCRm9CRG4yRWdBRWNNY0V2RWZZNm1Vc2JOYm1ZMEFK?=
 =?utf-8?B?QWFQME9mRzdLQzF4cWZ4SlJhVE9VejVYSmhyMTFjTXJFZ25RczFaZ0VoS0NE?=
 =?utf-8?B?VXIvZ2s4c1k3cW9DQjRqZW5kdDFlMnFoS28xYnY3bnJLOEcxT2tnMkZZWGI1?=
 =?utf-8?B?UW1YSThyY3dlVDBvU3dSODhaVkZLd0ZvWW9LRUtldUxYV20wdEVwUnNlWGky?=
 =?utf-8?B?bXpLZFlNU0FzVTZpN2o0c21leEdTQVMwc2JQL25LTWNGMzhOZEIwOENDNllS?=
 =?utf-8?B?LzhmYlp3RDB5aEc3VnFxQ2JFZGxMN3NGaFhLMlMwd21JTWg3RkZWanpJZS95?=
 =?utf-8?B?MTZqbkh6eTBNb0NEWVpqeUZrT3l1d2Q1Vnl2d2RNbXhqZGNMaXRCQUhERnFV?=
 =?utf-8?B?UnVjNnRlZndOdWNadTR6YmRac05DcE93ZDBFY0lobU8zUUxzQkMrZXp1djdL?=
 =?utf-8?B?bHBwczl3QXRkN2NxRnhOUUtwNWtPNFlFTWtyenRlUHZ2Qzk1a2VQd0VUZHBW?=
 =?utf-8?B?ZklUM3FXQzliNFVZQ0o0V1l4dSs5aGdtT2p5RmU5K3d3QmZOVTdFUW1tTERw?=
 =?utf-8?B?dXJOQm1QejFMUHdCcXN2TWlVYzA3ZzhlQ3RIeDFXaitPWUpVRW9hSjhSQytI?=
 =?utf-8?B?aGpxQ1duQTBCdmRpRDVGVU5KZ29UZUZBcmZESVI3UFhlTFZtV3FNMWsxYktN?=
 =?utf-8?B?cmsxcG5kNVdWSmxyaGtzODdWK0l0N2xLVlk3c1daTm91djIvOFdNMmxpVkdU?=
 =?utf-8?Q?X7pk=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: faa853dc-7fff-4b00-adc8-08d9f085002e
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB4181.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2022 13:13:47.5886
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fAWJYmA4GpFSRW8kwbPhU0J6jDegUcQ8cXOmK/SmFl+/iWHFcUzKEzEVbZ4BLmOe
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4801
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 15, 2022 at 10:58:58AM +0000, Tian, Kevin wrote:

> > Another interesting thing (not an immediate concern on this series)
> > is how to handle devices which may have long time (e.g. due to
> > draining outstanding requests, even w/o vPRI) to enter the STOP
> > state. that time is not as deterministic as pending bytes thus cannot
> > be reported back to the user before the operation is actually done.
> > 
> > Similarly to what we discussed for vPRI an eventfd will be beneficial
> > so the user can timeout-wait on it, but it also needs an arc to create
> > the eventfd between RUNNING->STOP...
> > 
> 
> type too fast. it doesn’t need a new arc. Just a new capability to say
> that STOP returns an event fd for the user to wait for completion,
> when supporting such devices is required. 😊

I think it is better to add a new arc rather than radically redefine
the behavior of existing ones:

  RUNNING -> RUNNING_PRI_DRAIN

Should return the event fd and allow the async sleep. Then you
alter the FSM so that RUNNING -> STOP is not allowed anymore and
userspace has to accomodate this new behavior.

Overall it will be some extension like the PRE_COPY and P2P, though
probably not transparently backwards compatabile..

Jason
