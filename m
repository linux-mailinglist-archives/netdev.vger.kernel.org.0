Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 546403C80F5
	for <lists+netdev@lfdr.de>; Wed, 14 Jul 2021 11:06:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238250AbhGNJIz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 05:08:55 -0400
Received: from mga04.intel.com ([192.55.52.120]:62697 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238206AbhGNJIy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Jul 2021 05:08:54 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10044"; a="208496919"
X-IronPort-AV: E=Sophos;i="5.84,238,1620716400"; 
   d="scan'208";a="208496919"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2021 02:06:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,238,1620716400"; 
   d="scan'208";a="466029942"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga008.fm.intel.com with ESMTP; 14 Jul 2021 02:06:01 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Wed, 14 Jul 2021 02:06:00 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Wed, 14 Jul 2021 02:06:00 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Wed, 14 Jul 2021 02:06:00 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.175)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Wed, 14 Jul 2021 02:06:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ioWIqrGrco5zh3thAJ6AaQoBi6Ai+CNf9vn4LXmmvGBUpdJ2U2Mi6/z/8J17Udfm5MqbWntq49+U9rpO4zInEyg83fGYaILdTYIn+WNf4s5AIPMDVk6HAcm4YaeJU+CZ8XjFKiViIRC4q3CGof3cIyNgJ0XvTC9S8xK/PjcAJ8LGnC0bWuMQ0zePmR2XIPiXXtCSm9rsK25H2FkHL+q1Q5uxEp49QTXXulJHtuOtzhYTSHhUaoLTUsDwXv9dGctMHFLG4MYVgfupufnmlLhjJj+PXXUR6zY4I5shyk+9KyBqEHp/crlq7ClckwkCj6JLCGW7WBoQiZod5WO7/BAxIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RdJL6c3wbn2cpFT++P4j/WDHageavgRiekpG9bZhzkw=;
 b=YTMu+3bChpPw0wt4+FLwxx5vVqwyGxuG2PNNGdZ2IIFaruVwsAJp5AyK5jClN9xIVc0MN1MYDkvvh4Yw5zP609vBTyYN21FE0u3UR1KNCw/fGV5dlQtb+HYPagjEnPujbzSotT55lni3uCHe1CJSb2EtcFnuVmOom6qrA3Sn82O0vU91sCNbapup/8aaU9vS8UR5j+Sps8Vg8SGnnyJF/TxdFjfIYia07DPct8mkpe4atC6V+GDrW06aIWsSGJ8fTfnEMzTH4C/eZlUfAE09j01CDUJu2GVQrc95OXo7BBGNjcBbDnOA5qO4su05tEt2V/76hs9u/SJl4fGQn/JmOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RdJL6c3wbn2cpFT++P4j/WDHageavgRiekpG9bZhzkw=;
 b=mETxJGYL8XQddB0kpEC2Si6UOeQa4wbsF8PYMqLmEz+ReXgRNRvVcTLEQqKpyPrOoYwoK5hcvN11Te2Y+JUNPvl00e6lZ0Rp1R0l4t5+F5IxpkiqbzBFu109KLZel7Wh+yFxYUthEc3gLqpQC0af+/P7YXXS+tXiRJr3ki430B8=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3162.namprd11.prod.outlook.com (2603:10b6:5:55::27) by
 DM6PR11MB3561.namprd11.prod.outlook.com (2603:10b6:5:136::31) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4331.21; Wed, 14 Jul 2021 09:05:58 +0000
Received: from DM6PR11MB3162.namprd11.prod.outlook.com
 ([fe80::10e7:c9b:7541:aa95]) by DM6PR11MB3162.namprd11.prod.outlook.com
 ([fe80::10e7:c9b:7541:aa95%7]) with mapi id 15.20.4308.027; Wed, 14 Jul 2021
 09:05:58 +0000
Subject: Re: [Intel-wired-lan] [PATCH 2/3] e1000e: Make mei_me active when
 e1000e is in use
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Sasha Neftin <sasha.neftin@intel.com>
CC:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "AceLan Kao" <acelan.kao@canonical.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "moderated list:INTEL ETHERNET DRIVERS" 
        <intel-wired-lan@lists.osuosl.org>,
        "David S. Miller" <davem@davemloft.net>,
        <devora.fuxbrumer@intel.com>, <alexander.usyskin@intel.com>
References: <20210712133500.1126371-1-kai.heng.feng@canonical.com>
 <20210712133500.1126371-2-kai.heng.feng@canonical.com>
 <3947d70a-58d0-df93-24f1-1899fd567534@intel.com>
 <CAAd53p79BwxPGRECYGrpCQbSJz8NY2WrG+AJCuaj89XNqCy59Q@mail.gmail.com>
From:   "Ruinskiy, Dima" <dima.ruinskiy@intel.com>
Message-ID: <16e188d5-f06e-23dc-2f71-c935240dd3b4@intel.com>
Date:   Wed, 14 Jul 2021 12:05:51 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <CAAd53p79BwxPGRECYGrpCQbSJz8NY2WrG+AJCuaj89XNqCy59Q@mail.gmail.com>
Content-Language: en-US
X-ClientProxiedBy: MR2P264CA0130.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:500:30::22) To DM6PR11MB3162.namprd11.prod.outlook.com
 (2603:10b6:5:55::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.126.210] (109.226.49.158) by MR2P264CA0130.FRAP264.PROD.OUTLOOK.COM (2603:10a6:500:30::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend Transport; Wed, 14 Jul 2021 09:05:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 46d6dfc3-3e24-44d0-b25b-08d946a69870
X-MS-TrafficTypeDiagnostic: DM6PR11MB3561:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR11MB356159E5C2FBCCA8B73BFDF8E8139@DM6PR11MB3561.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HxXRK7OV6U8xW5MD2uFdEVrBVo+WnN0LH8JXm6WoZyVkUdgBVYsb2f82NMZQnhZ0QOA5xb6tXmKscJ6YxLr2UR1PKsF5UyIMKXEbuOpkPFScKWmd7mNdccMpt6Mp+YNHdRBlHb2f7tvAiG4E3+pGL6ygoGWVEmkAWi7fNmzPRVkI+IYB0OTb3Kxuv79icTvn0oNHKkGzrGDgQrDBLUKlxCMbGWVr1r+jD3spSr2Zj908MAHZ7D5Tn4Wg53SnpkK5wN+T4AsT67SUmGdb9v1vy3t9HcKamNoRZKsb/Oavi+fTPFgyTjx5vT+YsY+AfTt9pJnQ/5udQZRGwfUkruddyQxvMsJ1uwwFoTftC0ccyv24RnqiQBinWTGGgZNGte3l+CBrDq71s+UQLMHNEuWLdo04LYaRbiBWlq4Qrdr+h2B00q1spCmUkf0irTiuEN75fVMk6NKdlMHIuAqSvSVe7nU/Y9oiXERT1BfEqdjYnNa+aMaFC3Uxzc9jlb/uShIyvaNwMT1X07jFR0y9rZ0s3aKnAqv6yjyPxlB7zf9ghD0Pu5KW9eC6h7f29dGPG5kXrl9pXDDsVJJ0LZSKqwAyWToMpUFgos4G+eDM9cmtD3oqsqGVc21oAXND6VylkwwXLcSpPrzEMCF2BKipg93vzHqYB8zuU6Lyzj4P+fFmZXtJtSWWZ/hn8f5lPGFB6FAwAzdUz45jttV62jMiRBEDbruzfZ/rOaFDnQck7Uje47YnPp2XQDiVF8etdtNivgoV
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3162.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(136003)(396003)(346002)(366004)(31686004)(6666004)(4744005)(86362001)(36756003)(5660300002)(6486002)(478600001)(6636002)(4326008)(107886003)(110136005)(956004)(54906003)(186003)(38100700002)(2616005)(8936002)(26005)(31696002)(2906002)(66946007)(16576012)(316002)(8676002)(66556008)(53546011)(66476007)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Z0Z0MkpKcm1iWXFjK29taEcrY0pISHpTMmJwS0lIbzhxdnFUZ3duSnFwOG1T?=
 =?utf-8?B?ekdScjNoWUt4ZmpiODlvclM4czJOSGZhcFRqL0ZnYWNPR1VDdnVMRjNSTVBF?=
 =?utf-8?B?a3FaMnVqVHU4dDNqeWlYMGVQS2xZam1nYkNFUDZaM204NXFHdkFDWnRadkc3?=
 =?utf-8?B?YUdBOEFJSlVodVJnMkQrNFVPM3dnQmprT3V4MldFUHVXUU5rTWFvWFdXRnVG?=
 =?utf-8?B?WUtSYkJaR0F3NW8vYlhvODJicWFYUFlhRmdqR21iU3lyZGM4dWFDYjg2V3hV?=
 =?utf-8?B?Y3Z1bUhJS3NrZlo5WVJ4MHo1azlxS3gzVHBBUDdhTGY0K0tnMVRsZGJMOFcy?=
 =?utf-8?B?b3BZS25GNFozU1I1WjFvbG0yWVJpaXJya2FNS2hDMjZhQWVWU3dlTFhUbGlN?=
 =?utf-8?B?NDhMMCt6TmxzS2pRT3VaOTBId0FLZkhsM0cvaUl0YnJpWGlmZ1hxRXhPSHR2?=
 =?utf-8?B?dFpwazFpaGszbUk4SFJORk5RN0FoODhDVzA1aG41a3VDcTVqczJKZy90Snd6?=
 =?utf-8?B?QkxWRGU3MStTcnBrVEc2Q3BGSGJSN2RZOXBaUEV5dGI4cGR3UkxpejROMmFP?=
 =?utf-8?B?eHRSVlNJMFY3TXlmdGUyalA5L1NrcllDcDFEcjM2VCtVYW9kNStDb3hGZGNo?=
 =?utf-8?B?S0ljNEFoL2FvRDJhYUxXNW5yWWZYa3dOenV2ZDRqTXY3SWtnTC9CWGN3ZkZK?=
 =?utf-8?B?b293TWw0aVJsRUZTeVFrQVgzdzdEMmc3dmxOQTZ3K29aUitXSXYrQVBMWUox?=
 =?utf-8?B?dGpNcjh6RjMrQUN2NHVmYUVjK08xeUpuZ1gvWmJLaURGNGl0QVNoK2pZQVJo?=
 =?utf-8?B?RDdNenFlbmgxSGlheFRpTjNxQWdxSURTcm45clFYOGhjYWtGN1cxbTg0b3Bs?=
 =?utf-8?B?QjFaSnNZS0RhM0VwTmI3elFkeHRGRm1JTUN0bHZDTFhXM3FXOGNES3ZKS1Bt?=
 =?utf-8?B?bk1qM1V5NHVQNDNBdmlqZkJDdFFPS2MveEl6OUJSdzJHakVyd3EyRy9iNVlm?=
 =?utf-8?B?UkQ3OUNmMFpzMUx5UXhVLytQMjRDUWRFYUpvUEo3Z1BuOUk3cGpWUnV2TGJi?=
 =?utf-8?B?TUlwelZ6T04xMTh6MHgrUVN3ZW9abnF2L2FUTjZLU2dLRjdra1Jldng2V3E5?=
 =?utf-8?B?NVdKT2xCNzlTYUNScDdQNy9MbU16NjgrcHljQkVmNjBYb3IvUUNuM1FQalZN?=
 =?utf-8?B?NHpMak5EcDdyTU9WNk1DTVFYUDI0ZmEwbmNLMkdJT0dhcGVIaVZNV2xRbTIv?=
 =?utf-8?B?cWlXWWtaUVdzQ0hXVEFjclNsVXU3U0NrcU1kUHVHWEdUZ0x4UENISDNTSVhM?=
 =?utf-8?B?NHZZbGNudGV6amorSXAyUkhIeCtUVExVa0loMlIzaTJIZDJnc2Z2N2k0eU54?=
 =?utf-8?B?Y1ZXWDFmVTdJTStmVXI3ZHc0SG9lbEQ1LzlGbGpKNEhMZVpKQ2R4dXg3T0NM?=
 =?utf-8?B?eHZwL3VZWHYxRzhkdldvaWcxMC9HTHFHbFl4NHZBQ0xpWkNVbGJOL0RHdHZJ?=
 =?utf-8?B?WU1DM2o2aEtkc01FQm5ONEVRbEZ6NGQxMmVZNmtIdFd3RTk1cWU4NVRQdEoz?=
 =?utf-8?B?emhiZnM0U0FEZmQ2YXRuV0MyajBFOGRpYUFuR3NrN01xV2JRQ0hnRVlIL2Ix?=
 =?utf-8?B?SUJETWdWRWJoWTcreThTakFRbmc5NnBtUGJVS29mbXR1KzI5TnRjQmZOcHor?=
 =?utf-8?B?NFdSTGp0Q2p3VEthMnRQV3BWMWpoTGhmOWU5OHhMTVNiNndIL3FlRGovMTVr?=
 =?utf-8?Q?Z7HMS/6I8DVdfeFA1H7Zz4HQO7iryfWjr8X3C3M?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 46d6dfc3-3e24-44d0-b25b-08d946a69870
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3162.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2021 09:05:58.8042
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5QiuuEBWvA8t3cgEwGCRAiZcL7ERwHbtwi1fjh50QBRyqI1ImLU0phrmlUW2aBoJcSXFRKWhfCOQGD1PqHXPWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3561
X-OriginatorOrg: intel.com
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTQvMDcvMjAyMSA5OjI4LCBLYWktSGVuZyBGZW5nIHdyb3RlOgo+PiBJIGRvIG5vdCBrbm93
IGhvdyBNRUkgZHJpdmVyIGFmZmVjdCAxR2JlIGRyaXZlciAtIHNvLCBJIHdvdWxkIHN1Z2dlc3Qg
dG8KPj4gaW52b2x2ZSBvdXIgQ1NNRSBlbmdpbmVlciAoYWxleGFuZGVyLnVzeXNraW5AaW50ZWwu
Y29tKSBhbmQgdHJ5IHRvCj4+IGludmVzdGlnYXRlIHRoaXMgcHJvYmxlbS4KPj4gRG9lcyB0aGlz
IHByb2JsZW0gb2JzZXJ2ZWQgb24gRGVsbCBzeXN0ZW1zPyBBcyBJIGhlYXJkIG5vIHJlcHJvZHVj
dGlvbgo+PiBvbiBJbnRlbCdzIFJWUCBwbGF0Zm9ybS4KPj4gQW5vdGhlciBxdWVzdGlvbjogZG9l
cyBkaXNhYmxlIG1laV9tZSBydW5wbSBzb2x2ZSB5b3VyIHByb2JsZW0/Cj4gCj4gWWVzLCBkaXNh
YmxpbmcgcnVucG0gb24gbWVpX21lIGNhbiB3b3JrYXJvdW5kIHRoZSBpc3N1ZSwgYW5kIHRoYXQn
cwo+IGVzc2VudGlhbGx5IHdoYXQgdGhpcyBwYXRjaCBkb2VzIGJ5IGFkZGluZyBETF9GTEFHX1BN
X1JVTlRJTUUgfAo+IERMX0ZMQUdfUlBNX0FDVElWRSBmbGFnLgo+IAo+IEthaS1IZW5nCkhpLCBL
YWktSGVuZywKCklmIHRoZSBnb2FsIG9mIHRoZSBwYXRjaCBpcyB0byBlc3NlbnRpYWxseSBkaXNh
YmxlIHJ1bnBtIG9uIG1laV9tZSwgdGhlbiAKd2h5IGlzIHRoZSBwYXRjaCB0b3VjaGluZyBjb2Rl
IGluIHRoZSBlMTAwMGUgZHJpdmVyPwoKSSBhZ3JlZSB3aXRoIFNhc2hhIE5lZnRpbjsgaXQgc2Vl
bXMgbGlrZSB0aGUgd3JvbmcgbG9jYXRpb24sIGFuZCB0aGUgCndyb25nIHdheSB0byBkbyBpdCwg
ZXZlbiBpZiBpdCBjdXJyZW50bHkgd29ya3MuIFdlIG5lZWQgdG8gdW5kZXJzdGFuZCAKd2hhdCBj
YXVzZXMgcnVucG0gb2YgbWVpX21lIHRvIGFkdmVyc2VseSBhZmZlY3QgTEFOIFJ4LCBhbmQgZm9y
IHRoaXMgd2UgCm5lZWQgdGhlIGludm9sdmVtZW50IG9mIG1laV9tZSBvd25lcnMuCgotLURpbWEK
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tCkludGVsIElzcmFlbCAoNzQpIExpbWl0ZWQKClRoaXMgZS1tYWlsIGFuZCBh
bnkgYXR0YWNobWVudHMgbWF5IGNvbnRhaW4gY29uZmlkZW50aWFsIG1hdGVyaWFsIGZvcgp0aGUg
c29sZSB1c2Ugb2YgdGhlIGludGVuZGVkIHJlY2lwaWVudChzKS4gQW55IHJldmlldyBvciBkaXN0
cmlidXRpb24KYnkgb3RoZXJzIGlzIHN0cmljdGx5IHByb2hpYml0ZWQuIElmIHlvdSBhcmUgbm90
IHRoZSBpbnRlbmRlZApyZWNpcGllbnQsIHBsZWFzZSBjb250YWN0IHRoZSBzZW5kZXIgYW5kIGRl
bGV0ZSBhbGwgY29waWVzLgo=

