Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6FEF6AEC4C
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 18:53:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230224AbjCGRxw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 12:53:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229885AbjCGRxe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 12:53:34 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D060303F3;
        Tue,  7 Mar 2023 09:48:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678211289; x=1709747289;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=CseGsboymzeRp0eTjTdXNQMvYr/oAqXs/xDFdB+CdIs=;
  b=C7xMfMiNnB7zKMwKTB5wQJF64b7Y+wiUdHyptFXCY1teNK1KE6gCSt0T
   yO4/nEzFY23ItSkjRBmqFe/cO/dpw7voNNpsQNDZhn+MtrUwgn2RmRQJF
   TinABp349wC80a1fKCUV34X1vJTgW/wiYryhhi45ci/Gqzl/JhYQbUArR
   2osbOXE47p/HdCpfl/NmIFmMI6KVN53UzDr8Ecep82j+jEHpS3XF0UAro
   gAkhUaADGQIKokXOL8OLWwo0prrOSXx9jq3KY6U5rU65/KyfJvheGRiYl
   eyTwXYjRBzOoFt3SB7w3sQhkBcZ4WiM33Nrbbv+pOeevC/47PidpWh0DU
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10642"; a="398500884"
X-IronPort-AV: E=Sophos;i="5.98,241,1673942400"; 
   d="scan'208";a="398500884"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2023 09:48:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10642"; a="786774620"
X-IronPort-AV: E=Sophos;i="5.98,241,1673942400"; 
   d="scan'208";a="786774620"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga002.fm.intel.com with ESMTP; 07 Mar 2023 09:48:08 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 7 Mar 2023 09:48:08 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 7 Mar 2023 09:48:07 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 7 Mar 2023 09:48:07 -0800
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.41) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 7 Mar 2023 09:48:07 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YzJCUJftO8SgFUcEzc/YmFmXgr9J80Yt6pDI9PwpMQzq4Fx6RbHg7QV3R0ESzn1NVrSCJGSgZ4zEkpaQp9Pz8Jz+tnagVfUiDT+9z94B/sGP9BCcrF7KR3zH9XEaiJJnLO0UAO47khWMs705CqBb02joX7QfrIymK2PoWWrNoWvtVi0TRjj5CFeSHnnA7zpY/JNEub6XnBy9mz+h10iJTzUROmUdZa7CboqtlVH7w0IQlSe1lJX9bTTqvkaIzzqKLKNcRM/9FAB2ZpZWkHVe5ySh22AwS8fErYKGbUTCIMNnSkX5jVxxE3JMFF4kue0QZ5IW74M+nyzn60YGApJmag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ThrXkA+N7rjNut62oiJqq8WtB31JGrZV6lIBwxqxO0w=;
 b=kHmMn9I0HiLZEiIGfJAJbrsSyUGnxBb/2wkE5emnpFaCKjeMnmtzfSZhREY1P875+IYdAVn5y5hnDiVmCzHTiDbKIiIuVgRK/HJu6OYovMD1SE/319tQzWpkMGVNerkJy939x3CWc6f/NsUe9VbfPCHfSFL3zGB7zT7tfWHDkrZahPaa3Hemq7jetLEQ5bSGbmKM9F7tw7VJmBDUIu2SffLQDNv6qGdKVi24fdHjtfx1ICePUfO5XyoTrbHdhDY6VEGL0KbUYr2wJiIM1X3uzq4f1kelouNwTLShr2SQBBZYTFlGkONfK5+918eBMrY1vbkoRwjn5rdU/WThzfdp0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by BN9PR11MB5513.namprd11.prod.outlook.com (2603:10b6:408:102::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.19; Tue, 7 Mar
 2023 17:48:05 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934%4]) with mapi id 15.20.6156.029; Tue, 7 Mar 2023
 17:48:05 +0000
Message-ID: <ee0aa756-4a9c-1d7a-4179-78024e41d37e@intel.com>
Date:   Tue, 7 Mar 2023 18:47:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH] xsk: Add missing overflow check in xdp_umem_reg
Content-Language: en-US
To:     Kal Conley <kal.conley@dectris.com>
CC:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Alexei Starovoitov" <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20230307172306.786657-1-kal.conley@dectris.com>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <20230307172306.786657-1-kal.conley@dectris.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0151.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:98::14) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|BN9PR11MB5513:EE_
X-MS-Office365-Filtering-Correlation-Id: ed10018b-5ddf-4962-2a18-08db1f341aa7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3rbXXFEV89yNS/FhzBIvUC9nQlM9RnVDcJIanNRQ7e8MTmH03ta7sCfaIjnyyFJBP4CkoYBvNRZjVfDw9pzwQwSPkkBtFyiwcf4BcVFWBh7hfNDnpvloDZ57gyNVwrTkKBWKx2qP08K20sfLlhyw9h8xCul4JSKm4PQwqnwdYV1R3pZs4l/i9wmrWcUWvSVeKkX4lqIt8cURuHNHjy+1iqSNcIEwPr+Mjv6M2jhNYZGczOqkIjlw4P5mAjT7tC2tBAyIvQalXmEkWiShjHfV2ljvfoQFThk9GEvD632vESdJ/yVrWM0VpelUhp8ST0Ttu+tZ5y/1ZVwCuaqUdarGnYA9orISMnL0/I3iZAMXVKSag6aG0hYIEzjpekHP9uHIcdoh2fNnZq2Co3mCPEkfwhotalCeNBbP4oVXDmgUuUij+d1ya3Zc27xo1foLhP0NRYgUwxWxXlJEpzWI/mvynhl/7cCV4h7wv606yA0wNkQJnUO7vBWWDQQkCrXX8DNZmyp9P5UBPl/5kmj+G+zlOlm897YtX6LlQetrZ4v2E8uVKyIPQCRPk0+njNfT31q86La3MsmBh3zujxeMrAwU/PG9PAg0JD8S2PBT/PdUZVbbiGlvzTy53WYh80grleZsQB0AxAYGpS+/j5EDsv78HNffyydFFI09iISio6cjYBAqTDWhNQnChB8DBezipJcVUoegwLGt2a8qw0zEbIp2yBObAlKP/IfrQGkJ68pl24Q=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(376002)(346002)(366004)(396003)(39860400002)(451199018)(4326008)(66556008)(6916009)(83380400001)(66476007)(66946007)(8676002)(6486002)(36756003)(54906003)(478600001)(316002)(86362001)(31696002)(41300700001)(6666004)(2616005)(26005)(186003)(6512007)(6506007)(31686004)(2906002)(5660300002)(8936002)(7416002)(38100700002)(82960400001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NkV3amNnVHFPSit1eWNVLzd0NTZpT3Y4algrZE9GekF3OWd5N1lZVnV5QjFi?=
 =?utf-8?B?UCtSdkdKd0o4V2xyUW8wK2FnVWpuaUtqdzJIOUM3YkMzYkt0MTM1T3ptNVE2?=
 =?utf-8?B?YWtzbnhJTnRsNkk3SW1LK0o2MnRGczdhTHlqN2dtQklGRUhqc3cvVFVFOEJC?=
 =?utf-8?B?Rm1yc1VmUmhXWmhkZ0dweldMTzZ4K0cyTkZkdEtZSmZ6N0NyKzNZc2l1SXdQ?=
 =?utf-8?B?RENjaTZCSktSbVg1MTlZM3JLTElLM3BZVTNIRlFySEhRdXNZRWUxVE9GR2NE?=
 =?utf-8?B?bzNYQXFYOVdLckVIMzBpZHVVb3dSY2tBcS81dWEwNk5URnN4SUI3Y3NmOXY1?=
 =?utf-8?B?UDN5a2JBemE1UW5IS25BM3pPUnVSdEtPTGdXQ3R3SEpqaXdybGtKeVVFK2ox?=
 =?utf-8?B?aGJmMklTekx0b1I2eDRXUmNZVVJvNHBWaXlLUlFaR0JIaSs3QWpCVTlEcTM4?=
 =?utf-8?B?dDh4VlM4SUhoWnFWZURFZ2gybjhzVytJV0ZsSmtabmd2NUp3WHA4N3A2cDRK?=
 =?utf-8?B?ZWpvSG1BdDZDYmFVRlJ4Um9SSWJPdVFDSjhaNGZycG9YbVVoU1I1aWk4L1NX?=
 =?utf-8?B?aHBFamVoQjBZSmh5MHRxSm1wbHRaWk01TlU4SlIrcXovZUlyUDNRK1JXMlpH?=
 =?utf-8?B?Mnc3Nnd1YUdLVW0zakZ1R2hOTDlVbTU2NmVoeHhuUEZxSDdzYytjYUtSRFBS?=
 =?utf-8?B?WUpzdTBxbUhUWjNOTmlNdHkvaVA2ZkRvMkRtMjNZejdUZEovWFpjbUEreVZ6?=
 =?utf-8?B?Q2dLYjVVaHQ3b2JyS1FYcHdGNlpEOEIxY2lwTXF6RExaOFVENXBZektDTnYw?=
 =?utf-8?B?bUhEb1RwcXlqU2tiaUZXMnRxamhTV1JBUGJxdmNIQkFEQXcvRnVZRlB5N011?=
 =?utf-8?B?TVZRRDBWVEhrc0Y5d0MzVFZyNmJwUFVsNjlySWx2TUovK0FNSDZZcXF6bXZR?=
 =?utf-8?B?M1ZjZ0dJcm5ZNm8xcnV0L28xUmVuV1ErQ3huNmE0TkRsRUo1K05hNk5pQVBs?=
 =?utf-8?B?VCtURWR3U2QyamlzdVMwOWR5a3EzTWRrVmNvSGFBV0dhU05MdWZ6Zm40N0pt?=
 =?utf-8?B?a2V1d2VmVndDZFZPMUIzZ1lCYWpwWEdHcWVCenNHL011VzZYQURtVDBJSTZD?=
 =?utf-8?B?dDVjTy9BMjB5K1dmZmtON1hGRE45bHplM2RQd2pKUzhIVnRRTlhxZ1dCQ0pK?=
 =?utf-8?B?TFBQejIyZHJpdVNhSFN6cjlqYWY1dTJvcitmVWUyZHVvUUQrMGMxOU1XVE1h?=
 =?utf-8?B?VmNMZ1RJWUpQV0Z3dzBTQlhndm0xdjBKa0x0YW9GODZiYlp1all2ZmViNmd0?=
 =?utf-8?B?VHlUQVZ2S09FQ3llMGpYcnpqVm9Hck1VMFdBcDU0QVR6QU1ORlBjODlYQzZH?=
 =?utf-8?B?WmxHZUJ5V3VvWlppZWg5alR1eisrVHdGZjhxNFNOemRzNDY3d1J4ckFvNE9w?=
 =?utf-8?B?cUpDaTI3b1J2RDRQa1QyYWs3YURucndyWkRBSk9IQnFYb2k4VjRTQmtSbjFr?=
 =?utf-8?B?L3FUbXlONGo5aUsyR0Jtd0pucDRldmlTWk5qN0Fqa3JmamNFNWtNWlltVWZj?=
 =?utf-8?B?RXpzbElqVHFRZ0FrMU1VVFdTOEh6WVJPRXpGM0QvVGsxWUtMdVllZzhsUTBz?=
 =?utf-8?B?MGgxY25rcHJIK1gvQjhCaVZPZzVPVndodkhqZ2tYVHk4ZFcyZm1Jb1k2djNZ?=
 =?utf-8?B?QzJ1UEFSY3JNMjBTelRxbGxQWEZiTUlOYzJqSkk4bktMSXhDVEM2bng1b2pF?=
 =?utf-8?B?cUllVEVsbUNDa0JUS1lKNkRLYi8ybFhldHVzSnBOUXo3TEhxUTdjRDlHaHAv?=
 =?utf-8?B?VUlnakRXMnVqLzYyRjN3TUllK3pUTmw5TGp3UDBIQThYcU92cEtNbUUyNGdZ?=
 =?utf-8?B?V3hkUmFPODFqUUlXYWI1Um1kYktLeTBCSlRXaGpEM1VpY2RoeHppclUyL2Zn?=
 =?utf-8?B?ZWdERlVYcUU1WCtTL09Dc1JmTUs5QUpGdFBmQnBaNGhpY1haQnAxWDE0YzVw?=
 =?utf-8?B?RTZYeG1HUXNNRHd3YmtGZG5SU0EwNDNRckZzNytXK21YUUVxSm1RTnp5bWsv?=
 =?utf-8?B?L3lPaUlrd1E2TFpsY2R4NkNuUzY3TE12RlgwQzBVbVVqUXIwa0hsWTlEdkdT?=
 =?utf-8?B?S21yU2ZmNGN1TlAvRjBtMERuR0JHZUIrd1p6TysrWVRDNFZVS243bytoblFW?=
 =?utf-8?Q?KfxbUFYycqnUE8ENqPO7ZWo=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ed10018b-5ddf-4962-2a18-08db1f341aa7
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2023 17:48:05.1324
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3zDpeyR2RkhbExCygpt4xz7OV/etL4vTGatOs4F4cNZR4JASnduC/SXA+07DvcuFxqLVIoaNKaIt3lxYK5t1uHmV4WQ2SRbj8jufEkU5ch0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5513
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kal Conley <kal.conley@dectris.com>
Date: Tue,  7 Mar 2023 18:23:06 +0100

> The number of chunks can overflow u32. Make sure to return -EINVAL on
> overflow.
> 
> Fixes: bbff2f321a86 ("xsk: new descriptor addressing scheme")
> Signed-off-by: Kal Conley <kal.conley@dectris.com>
> ---
>  net/xdp/xdp_umem.c | 13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
> index 4681e8e8ad94..f1aa79018ce8 100644
> --- a/net/xdp/xdp_umem.c
> +++ b/net/xdp/xdp_umem.c
> @@ -150,10 +150,11 @@ static int xdp_umem_account_pages(struct xdp_umem *umem)
>  
>  static int xdp_umem_reg(struct xdp_umem *umem, struct xdp_umem_reg *mr)
>  {
> -	u32 npgs_rem, chunk_size = mr->chunk_size, headroom = mr->headroom;
> +	u32 chunk_size = mr->chunk_size, headroom = mr->headroom;
>  	bool unaligned_chunks = mr->flags & XDP_UMEM_UNALIGNED_CHUNK_FLAG;
> -	u64 npgs, addr = mr->addr, size = mr->len;
> -	unsigned int chunks, chunks_rem;
> +	u64 addr = mr->addr, size = mr->len;
> +	u64 chunks, npgs;
> +	u32 chunks_rem, npgs_rem;

The RCT declaration style is messed up in the whole block. Please move
lines around, there's nothing wrong in that.

>  	int err;
>  
>  	if (chunk_size < XDP_UMEM_MIN_CHUNK_SIZE || chunk_size > PAGE_SIZE) {
> @@ -188,8 +189,8 @@ static int xdp_umem_reg(struct xdp_umem *umem, struct xdp_umem_reg *mr)
>  	if (npgs > U32_MAX)
>  		return -EINVAL;
>  
> -	chunks = (unsigned int)div_u64_rem(size, chunk_size, &chunks_rem);
> -	if (chunks == 0)
> +	chunks = div_u64_rem(size, chunk_size, &chunks_rem);
> +	if (chunks == 0 || chunks > U32_MAX)

You can change the first cond to `!chunks` while at it, it's more
preferred than `== 0`.

>  		return -EINVAL;

Do you have any particular bugs that the current code leads to? Or it's
just something that might hypothetically happen?

>  
>  	if (!unaligned_chunks && chunks_rem)
> @@ -201,7 +202,7 @@ static int xdp_umem_reg(struct xdp_umem *umem, struct xdp_umem_reg *mr)
>  	umem->size = size;
>  	umem->headroom = headroom;
>  	umem->chunk_size = chunk_size;
> -	umem->chunks = chunks;
> +	umem->chunks = (u32)chunks;

You already checked @chunks fits into 32 bits, so the cast can be
omitted here, it's redundant.

>  	umem->npgs = (u32)npgs;
>  	umem->pgs = NULL;
>  	umem->user = NULL;

Thanks,
Olek
