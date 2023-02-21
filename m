Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6511869E081
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 13:36:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234426AbjBUMgD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 07:36:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233719AbjBUMgA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 07:36:00 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61F3D298FC;
        Tue, 21 Feb 2023 04:35:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676982958; x=1708518958;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=P/LPmwXYuKi1/A6a6QC5x8h3dU5uR7ljw9gg58/oMlM=;
  b=iznkMH3vl3z/klS19LkfVzus9KMJqGTmE2oPRydTEhzI65HwH9zlJ0Nb
   KGZYfrR2VoEtf+pKEsZ/5rJP1OFW0900FDYKDpgikzvriqNEqvmLiZSdO
   b/a1oTrEbEXgs+EVpNShwwG4IMnmFniAJNIPYqySMjZCQdrrVbWoMyH1D
   0CcC9vFB8l1GvY8Nm1WK91y3iEd0uedF/OgAkkDM/LXS5m1We3oUH6CrF
   Iiywbl2LGi5ruu0rm/ufECMiZ/IKtP/O8CvBo8lRN8Gnvxv1aV3JGvUpr
   Z6zrX67tQuw4N9g3wAcVvyfOhr8lII61R7s7ovxMobXmSWZNHEE9nJI5N
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10627"; a="312990145"
X-IronPort-AV: E=Sophos;i="5.97,315,1669104000"; 
   d="scan'208";a="312990145"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2023 04:35:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10627"; a="671631015"
X-IronPort-AV: E=Sophos;i="5.97,315,1669104000"; 
   d="scan'208";a="671631015"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga002.jf.intel.com with ESMTP; 21 Feb 2023 04:35:57 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 21 Feb 2023 04:35:57 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 21 Feb 2023 04:35:56 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 21 Feb 2023 04:35:56 -0800
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.43) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 21 Feb 2023 04:35:55 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oA4pkUJ7X5mhn0/mf1aCRrRGtUo3Zxq4F2VQM0e1cR4JilbTznqlaHNhSsLCsTxgfn1Zw9qP0inFVgZ/ZhDvBQKPPfQRPJidmYWmZ57kpype3bhIWDfQKHUhF4FFvdVq+vGnVZyYf2poLy30fE5cJUl6PqZEnlqicl9Ma1m+lTsqn9Gq4Xz5Ee2qWkjoo2YpDC6xTQtjAto8mZfzecZUbxzw84PR9SRT4vZlG2/SEP01SUhfboyrzEf8QUdm+6M0tF9xShl3B1iM06Ac8umnluw8aNiYMZ88eObWDkO3D939FMmMJmCyFyHToHXiAhMrYv8tGGazVYU4jaDsGE/n2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hLa52QY01C3YKaLO1VQ5nIH02f3Jhtp28krV7n5a0/0=;
 b=AJKDzRIVADCDjwkTGpypfy62nqDKavudj4DFlMGCWMIrUotv9sFwCo7jWXJfPW+7zZyCX5okp1wfMckNmPJh7y6ceXnM3MGHccTW4MqQR7RrrovKQVQxiyf+GnpRQoZrJd2crX2IVlWqCUiDtKz7DZ1aTs9wRKh9tCzsH2bqm9Y1DdLAgv4s/tvS3JSSPDGuTph3b5XX5BqhgPg8CApwMwo0uvp05v/RrhY1n7bsH0Os5ZEoD/M7dvg0Q7usQ0/lQDRnZMw/qtfUwixL7OpprsFbLMqbadyzBn0w00EhRI6kqJ0ytoequxj8CERZbEJWRgdHnmdad2gBXSTmR9uLSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by SN7PR11MB7116.namprd11.prod.outlook.com (2603:10b6:806:29b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.21; Tue, 21 Feb
 2023 12:35:49 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934%4]) with mapi id 15.20.6111.021; Tue, 21 Feb 2023
 12:35:49 +0000
Message-ID: <36538615-7768-bdea-7829-6349729ab7cc@intel.com>
Date:   Tue, 21 Feb 2023 13:35:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH bpf-next v5] bpf, test_run: fix &xdp_frame misplacement
 for LIVE_FRAMES
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "Martin KaFai Lau" <martin.lau@linux.dev>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Song Liu <song@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <martin.lau@kernel.org>
References: <20230220154627.72267-1-aleksander.lobakin@intel.com>
Content-Language: en-US
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <20230220154627.72267-1-aleksander.lobakin@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR2P281CA0126.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9d::20) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|SN7PR11MB7116:EE_
X-MS-Office365-Filtering-Correlation-Id: 3187e92e-5b5a-4f4a-f675-08db1408294a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: s5Tbe4e3jsGWbamz5N6yZYcaVl0QKoj+evftMmKIqfCFy7lyJsD5NMKwS2K4AVAJzWGEj5QBZSyeldGWDGh3MFTPdSzEpHsFQwsc+1mwtoCf9vi86Mp1CLMuIwnxupHRgYgV7vzzlecEOiz39EUB/rJabm9SjpAdhytu3rKbalFSEVkAn+CHKYvN+R9YwtaSDRaRAYCyyyyUdYNvdIkjPsH+NuDFmL8Ro/GPXZf2M2lp1y8JUxf14usA+6wPMFyw+DoPSU4t4uVMmjtGboDrEXu7hZKgjvV5UiZJO/jmI94W6DC13NBU4UDURmR+BPMnR4YEiQJenfLnWc0cxKghuNQiFNZqdAe486KyYJIXchSpR4DrBIOFJ/Cz1HJA3JLYHN+Ec5vlwLhTjcDBXtnOH8c7l5QDp+vG4uR8brWu06YJ/fGmR74q1vxWunSCnyks0xtSbCAvUQApiTHbMLPRttB74xszxLipd5WDi8A/XiEiDq4ECjItR9h5SuhvLyKnDrAVCVApx3c68BD3WveStXedT7XZ/Uo6oJdVP5a6l/+GpmDzni/Hgn1vlAA97M+2864f8ZQZ+eNd9YdtwLUpZ1esnh1Cd9oe9+mmVATdKCsoFA1JOfADpUcMJbqYQ6oYygRPDdRd5DysgWoJrV+KMSQqK71PtYrXn1tIlNNvdtW6Ujn0/SVSJ5Ui5aqoKAZVcOpl0Wga5Rs4r/c9I8fSbA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(39860400002)(376002)(346002)(396003)(136003)(451199018)(38100700002)(66946007)(8676002)(66476007)(66556008)(83380400001)(66574015)(6512007)(186003)(2616005)(6506007)(26005)(86362001)(31696002)(6666004)(54906003)(110136005)(478600001)(82960400001)(316002)(4326008)(966005)(6486002)(36756003)(41300700001)(2906002)(8936002)(7416002)(5660300002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VFJadEZDaksrTDduN2Zhbkk0aTJEQ1Z0ZmpFdExKUEloTmUvdEtCTEtaU3Ni?=
 =?utf-8?B?alRrSWxnR3NQNmtSc3dXUUNibVdFOUhhRUtSMGcyS0cxcXg1T0ZJNGNKem5a?=
 =?utf-8?B?a1VxMGw1M3NhcHNYM2xjWk5ZbGltc2pBNHVGenA0TWZaM2c1Ry9kOFR3OWt1?=
 =?utf-8?B?T0dQT1ZNdjNrZUFkbmhFcHdQRUtzQjU4d3pMU2dUdVFZRkpxa0J1V1Y5MlR5?=
 =?utf-8?B?cHFkYUZsWkpLbEtzVFIzTGZ1dkxJUkVaTW4zOVlpS0lDbEJ0T0JGSDIweFJi?=
 =?utf-8?B?cFFNWFpERkhVNGI4RjhTd0g5SEppd1hRTTBIdkZwK2xoZjhyNU5UZTJnMi9x?=
 =?utf-8?B?L0J5T2dhdW9tQ3B2TTRZZy8zMURLRkxxd1FNNWQyZS9xS1kxemZta0tLd05W?=
 =?utf-8?B?Z21qRHU4U0h2NDBQZC9OSjVqVjNvNi9KdXdHa2FhanlBcCtRRzhSVkxUTEEv?=
 =?utf-8?B?SGlOS2kxTUE2VUVGTW9TNC9RaXQvZjRPb2JhUWNZZmJOemZQWlZIV1lHQktT?=
 =?utf-8?B?dk56NXZpeDV3eWNxdWhOczI2cFBlM2RPSUR5eUhHSlQ5ekJVTFl2aUlZNGZ5?=
 =?utf-8?B?bDBHNHVNWERkNmtmQ1V5NEpJSnpDWktuSGRFZzdrS1dsQ3A5UWdraFFmQjh5?=
 =?utf-8?B?d0R4T1BOSGRlN2tsVlVjbHgzTEE3aFlXalpNemZBZ3hoWnIwMjl1RDR0MnNC?=
 =?utf-8?B?ZkNSTDNpK2FTTngvZkVqakp2R3FRNnZjU01LakFaY295VEIzblpsRHE2bHdY?=
 =?utf-8?B?cmFPTzVncnRQZmNNS0pXdkpPcWgxcnlpUXNCSVNJYXlvaHVGOHMzemZqbGov?=
 =?utf-8?B?S3ZOVjlFd3pjc1RPSFk3dXdPQ0ZySEFPUk5zTE9xVlRBbUVEVW9xZnNzdlRH?=
 =?utf-8?B?N0JDL0FDdlNrNTBLMzFEeE5kNDYydkJIZzdsRmJUMUk2cDZZV0dObE1LQ3Fk?=
 =?utf-8?B?U3FDd2tWZzByS0hiMnJaU1d2LzlkMUV1aHRrVjdLWkRDSDZIR0tSZHBIWmhk?=
 =?utf-8?B?STdTV2Y0d3h2eXdlRStPS1F1VExtcjFTL2JOWXo2U1ZQaWlRd1R5KzF2RjI5?=
 =?utf-8?B?Z0xiNFRXbU9jR0I5aHFCZXJJNXd4VHAvSnRpVGJJOHRjOGxGNkt2YTRDY2hP?=
 =?utf-8?B?Sm1GRGc4RHVjS25sSnE5cVVMN3BQTzJCMnBGUDlnNjAyY1Z5RVNIS1VZcUxv?=
 =?utf-8?B?S2dKQmIwZ21GTFNtODhZTFBhTmp0Zlk2NTBlTWtETGJUTTJxRGZXYW0xL3dv?=
 =?utf-8?B?Z2JDYzVYNlQ1S0pWTjFGWHlBOXZ3eTRzS0szZ0FqZnkvTkd0OW1YcUtMY25n?=
 =?utf-8?B?OVJkS1B6cm44Q1dvbkxKdWd2bGRaLzdKakxvcGp1ODhmdmUxSGxDOWZxcjB5?=
 =?utf-8?B?ZmtUWXZNT2xpeGJ4eG52UzBrS29lT2pFbUh1M3VwZFZycmV1RzV3cVArdTJx?=
 =?utf-8?B?NkNPZW0rZVBJeHBXZmg0VWw4dVlYMWp1NXZBcW9pMzRNTDh4ZEJsOXJNbTha?=
 =?utf-8?B?cWRDdEEzQXp5bzBRMDRPYi9MaHY5MU5yZk55WGNjU1BmYlJwSTV0ZGFuY2dy?=
 =?utf-8?B?UlA5N1pVaUJYRVorVEVYR0FOR3ZUSllWNWd2RUR5TGZEbnZXc21IM0gxZHUx?=
 =?utf-8?B?QjgxLzlUcDhRMEF3Rlcrbm5XTlE0dXhuQ2hwcWNFZnZWa1hQODROR1Bkc2Fq?=
 =?utf-8?B?dVpvZnVLcm1rKzIzcnFnZkZQUTYvamRJNHZxb3gyZVFMOStHZExUYlgrNVVG?=
 =?utf-8?B?a202cG95c1VZTW5NVUN4UTc4YlhpQStXVFJKbWVTK05jRUdJVXo5OHdDV0tW?=
 =?utf-8?B?Tk8xblNaTUdnVjdzVVBlUFRSVklmcnBrZWFLZFFRT3plWjJzK0xaWko4T1FQ?=
 =?utf-8?B?clFNaW1FbFFYYUJOMm9LL1p6UnpqU1ZSVk9NS2c1YUEvMXhIMWhMOEJXamNl?=
 =?utf-8?B?NWgyM1FjbjdPSXBqazhoSmdFMFpzKzQ1QUFrb2xySmZ6M05qWU9TNHR5L1I1?=
 =?utf-8?B?NjFGZlk0SWEzeVJEMlgyV1VFOWFKNk9WVis0UkNEeTcraVo4blR5dnFkMlI1?=
 =?utf-8?B?ZzF5VFdHYWRmSkk3aHd0T01YM2h1TWxnbWJoWjh3eDlXZlRic3ZWcG9Vbnpp?=
 =?utf-8?B?TkgyM082eGtHS1hnSnpWQzQ4OHF3Y0pOdWFweXY5bWJ1VXJDZXFSbWhUYTZJ?=
 =?utf-8?Q?Vrg5XQv60RFB/WjW0WXPWEM=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3187e92e-5b5a-4f4a-f675-08db1408294a
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2023 12:35:49.0473
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eldm3JR0NslRk9lE9D3iSwSTlkIFyKY0F7c6a2B8tp4vuCy1mUu1E/srqOLhi8eYuXQwqLShoLBAqCNE8DzD4wGMUM/9h9JfTgJDStFvkb4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7116
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Lobakin <aleksander.lobakin@intel.com>
Date: Mon, 20 Feb 2023 16:46:27 +0100

> &xdp_buff and &xdp_frame are bound in a way that
> 
> xdp_buff->data_hard_start == xdp_frame
> 
> It's always the case and e.g. xdp_convert_buff_to_frame() relies on
> this.
> IOW, the following:
> 
> 	for (u32 i = 0; i < 0xdead; i++) {
> 		xdpf = xdp_convert_buff_to_frame(&xdp);
> 		xdp_convert_frame_to_buff(xdpf, &xdp);
> 	}
> 
> shouldn't ever modify @xdpf's contents or the pointer itself.
> However, "live packet" code wrongly treats &xdp_frame as part of its
> context placed *before* the data_hard_start. With such flow,
> data_hard_start is sizeof(*xdpf) off to the right and no longer points
> to the XDP frame.
> 
> Instead of replacing `sizeof(ctx)` with `offsetof(ctx, xdpf)` in several
> places and praying that there are no more miscalcs left somewhere in the
> code, unionize ::frm with ::data in a flex array, so that both starts
> pointing to the actual data_hard_start and the XDP frame actually starts
> being a part of it, i.e. a part of the headroom, not the context.
> A nice side effect is that the maximum frame size for this mode gets
> increased by 40 bytes, as xdp_buff::frame_sz includes everything from
> data_hard_start (-> includes xdpf already) to the end of XDP/skb shared
> info.
> Also update %MAX_PKT_SIZE accordingly in the selftests code. Leave it
> hardcoded for 64 bit && 4k pages, it can be made more flexible later on.
> 
> Minor: align `&head->data` with how `head->frm` is assigned for
> consistency.
> Minor #2: rename 'frm' to 'frame' in &xdp_page_head while at it for
> clarity.
> 
> (was found while testing XDP traffic generator on ice, which calls
>  xdp_convert_frame_to_buff() for each XDP frame)

Sorry, maybe this could be taken directly to net-next while it's still
open? It was tested and then reverted from bpf-next only due to not 100%
compile-time assertion, which I removed in this version. No more
changes. I doubt there'll be a second PR from bpf and would like this to
hit mainline before RC1 :s

> 
> Fixes: b530e9e1063e ("bpf: Add "live packet" mode for XDP in BPF_PROG_RUN")
> Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>
> Signed-off-by: Alexander Lobakin <aleksander.lobakin@intel.com>
> Link: https://lore.kernel.org/r/20230215185440.4126672-1-aleksander.lobakin@intel.com
> Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
(>_< those two last tags are incorrect, lemme know if I should resubmit
 it without them or you could do it if ok with taking it now)

Thanks,
Olek
