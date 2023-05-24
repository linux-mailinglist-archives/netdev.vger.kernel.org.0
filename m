Return-Path: <netdev+bounces-5046-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8EA2870F879
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 16:18:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4410C28129B
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 14:18:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79A3718C05;
	Wed, 24 May 2023 14:18:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 636C717ACE
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 14:18:17 +0000 (UTC)
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B488119;
	Wed, 24 May 2023 07:18:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684937892; x=1716473892;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=1iQCpw/J8b4ow6an4aBxEQoU1oA43ahwT/M6UCw7OWE=;
  b=Ew7FXCXxoqv/5j14NfkBBEXit2o5PiEfyyODbJTMQiLpC7Fyk9hMKLhE
   hc7Ech4d4RLgDjNJTpR0dCrdguX7XOD9za8KjCvvDg53u8xJrhZFpgO00
   JZfmD/jZhWDSETOFMDP1Bu1l4dKnNrqFilVSbsv4YHvXheFjT3rXNH+mv
   HzMazH/tMMjxnuSpHpDBLUK8nJ0e/Jbipjj3cGiI4OBJ9qrAD1ma6+1vx
   9EVWaTWoWQuXv/b3kyqUAyy98Z8tH1gKhqGccc4aqCK2OZa/C+Sh5qoI/
   bM+ONrsWu3WpwRgDRGA/qGTNeG/JBhzTITI/la93Sx7OeG8J2e1tFUrxh
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10720"; a="352420982"
X-IronPort-AV: E=Sophos;i="6.00,189,1681196400"; 
   d="scan'208";a="352420982"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2023 07:18:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10720"; a="698559507"
X-IronPort-AV: E=Sophos;i="6.00,189,1681196400"; 
   d="scan'208";a="698559507"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga007.jf.intel.com with ESMTP; 24 May 2023 07:18:09 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 24 May 2023 07:18:09 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 24 May 2023 07:18:09 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.42) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 24 May 2023 07:18:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PWw+ZDfzY1vCfbIHcubKXGJU/7vJ+dPdK3G60/gg4hVK8Cy0OROKLaP8EWQ8RRsWZFhCVv6ScTW+3K3q35icAcz0pUWtFKJ9W4H9vMu1VKBiCBe2i6zlgDV7fhxoKOPzBKQZgBQyqgqToqia5RjgJmpB3TC22cevUholMN9d5IsnxCaHiXwYdRnvfKq9JGiLakwjC76Nu/zqpVkIeLyDG6yMk5epeUnxNsHrHN+tGgn7OjoJiWaKhqQLYkJRbckJhiKgcu2JnD+t+nIU+xis5OaJvvkcEz8rZTqHwTlv+yy/eKLEfE/ZXz4meTAMdAZybzb+WzeC3bUoZwkkyyT2Ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nrse2M0wULZCNNRDOF5wLry+2/KouMeyxl4dOth/qRQ=;
 b=fSCvH2GEG14Mb+DOPLyNBHCpfhGYqXKiXBYMIpTOOFNmXzwNl/nB57ABu+WKamcT1D64SGAZbLRLguqKck4I+OXi6UGjVtHuNrKae45WxmPV/Xe9Ilc8gYpihb5CVkDIZK5r74ZQcdxInGsa6RCN8x2sNpW5AvSyE9Thn9WgSZdxUgn/tyG0RGX5zzRW+6i8j/tshiJ5OxvvNNRlMHwP+ohrmjjbJUIFIm/YWOzs+U8TSMKusHWTbWZoafT0ygFz/5da8rdbk0NfPjjTSTXH/MAuOOpJxUmbx90KdCUrsrKw/qSSTRR3foIm6FrFo3HLAZgFbLf+cSMTAw50Uz+B4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by SA2PR11MB5130.namprd11.prod.outlook.com (2603:10b6:806:11d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Wed, 24 May
 2023 14:18:07 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::64d9:76b5:5b43:1590]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::64d9:76b5:5b43:1590%2]) with mapi id 15.20.6411.028; Wed, 24 May 2023
 14:18:07 +0000
Message-ID: <1d909989-5418-17ca-f161-67b4c05c6fb2@intel.com>
Date: Wed, 24 May 2023 16:17:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [Intel-wired-lan] [PATCH] overflow: Add struct_size_t() helper
Content-Language: en-US
To: Jakub Kicinski <kuba@kernel.org>, Kees Cook <keescook@chromium.org>
CC: "Darrick J. Wong" <djwong@kernel.org>, Daniel Latypov
	<dlatypov@google.com>, <storagedev@microchip.com>,
	<linux-nvme@lists.infradead.org>, James Smart <james.smart@broadcom.com>,
	"Guo Xuenan" <guoxuenan@huawei.com>, Eric Dumazet <edumazet@google.com>,
	"Tony Nguyen" <anthony.l.nguyen@intel.com>,
	<linux-hardening@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Sagi
 Grimberg <sagi@grimberg.me>, <linux-scsi@vger.kernel.org>, Jesse Brandeburg
	<jesse.brandeburg@intel.com>, Kashyap Desai <kashyap.desai@broadcom.com>,
	Christoph Hellwig <hch@infradead.org>, <intel-wired-lan@lists.osuosl.org>,
	Paolo Abeni <pabeni@redhat.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>,
	"Gwan-gyeong Mun" <gwan-gyeong.mun@intel.com>, Dave Chinner
	<dchinner@redhat.com>, "Keith Busch" <kbusch@kernel.org>, HighPoint Linux
 Team <linux@highpoint-tech.com>, <megaraidlinux.pdl@broadcom.com>, Jens Axboe
	<axboe@kernel.dk>, "Martin K. Petersen" <martin.petersen@oracle.com>,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
	<netdev@vger.kernel.org>, "Nick Desaulniers" <ndesaulniers@google.com>,
	<linux-kernel@vger.kernel.org>, <linux-xfs@vger.kernel.org>, Sumit Saxena
	<sumit.saxena@broadcom.com>, "Tales Aparecida" <tales.aparecida@gmail.com>,
	Don Brace <don.brace@microchip.com>, "David S. Miller" <davem@davemloft.net>
References: <20230522211810.never.421-kees@kernel.org>
 <20230523205354.06b147c6@kernel.org>
From: Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <20230523205354.06b147c6@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0176.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9f::14) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|SA2PR11MB5130:EE_
X-MS-Office365-Filtering-Correlation-Id: 1aa4a62a-49b5-4d7d-a5bd-08db5c61b1a7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oibmwHQLyesMT4J0kfOdL+xf6ve6FBoCQY5O8bMauI6ODC3cwO4fseuBLTzgnMuOKrTrxRHC0w/Q6V85iRQ1DwEOEAKxJ3MOf2WoxBDjXnEisTLaKkV6DbNDXJZoVfgS/7CnrHs2aYbnOkAFwAhP57koLQza8ciJfKGNw2k2Lso0pGULCZ6w61VKbFCOzCZlWrZLBdH+yxjz4B6SWT1KTbH40Ewbs1kW36YskAsHX9p3yvjsDFfwituMNe38o5YMsqTzuHQzfiL2EELFfsS9iPdPRW0VaX+ZCbJU1G0SRy2CTnS6aKbp/eiYeiA15VzbKe97mBeOWcj1R8iqn5l5DzVWGBeXYamvxCYhX3Ayau0rhMGQfRU3Nq4qnbbvt8gltbLJxvvpz4DVyWUE/CERgsAb61qYr9gkQ3M8pdtHl/QGsXH66ZIjPBnsMHltNN2/C0sjqcp4V/aRZmQc1lno8DpRD1YYnP1lg/vWB+2zT79lUOXqAfSds/mW1lHgucHck2JQNynpc8yRIREpV+SWTTsSG8J4FBXjC1B4tgmFAuxUZM4YRVoU6ISCOzmMbwHufX4romIgAoIjTbCKiGIeRd7vCuJL6dQnOUtASCSm4dW6Rfwu+S3jWHm5IgXylKqU0bLbGAPXHzhYq7CkVAaAqw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(376002)(346002)(366004)(39860400002)(396003)(451199021)(82960400001)(186003)(6512007)(6506007)(26005)(38100700002)(7406005)(7416002)(2616005)(36756003)(2906002)(316002)(6666004)(4326008)(66476007)(66946007)(66556008)(41300700001)(6486002)(54906003)(110136005)(31696002)(86362001)(478600001)(31686004)(8676002)(8936002)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SWRTVnliVkJET2RBQ2ZvOVlWcGdaUWl3dTF2clQzL0N5OU5LeGJISG4vU1lS?=
 =?utf-8?B?dkt1ZDhyZWdYSmJ3VTV3WUlBWmY0czR5RUxXMkRKNDNVMXRPNTkxRzk5Y05F?=
 =?utf-8?B?TG5qd1NsS0NReS81L28rell1QWUwSTRnQUVCcVpsYm5mcWdlZUZQeW9LMU80?=
 =?utf-8?B?YVkyUWJDVTI4S3FUdythMmZHZHVMTzFwYjFBSFM4UEdxTUMrWU4vaEo4dUNi?=
 =?utf-8?B?Y3NqdXU4WVFMRkMzUms2ZGNFckNRN3QyZEhoM2Zyd1d1SEF3b0Q0WThrK3hj?=
 =?utf-8?B?Nm81dnhraWRoZEgvemI4eG9va0wzay9aSm43NUxJN09SR1pRaFpmWE1NYzhS?=
 =?utf-8?B?cTVrakdad0VJNDV6Y1FIK25jSnNNUlNBY1I3OVNwTTJXaEh0U2pSeXlWeDJs?=
 =?utf-8?B?a3hKUUZYcjlqUDZHZ0E1K3N1YzdweWtEZVM5VVk5STVRRGZIUkZUVWgvdmhM?=
 =?utf-8?B?K1dMSHljVHRQcWRqN2kyYldKWWZ3RHpDeUY0RzFTTmpCWUJGcTNVU0xxVE5s?=
 =?utf-8?B?MUhHNDFNUXBtS2RGQzBCaXRROVZ0NnlydEVwbzdxL3R2MWNReWdyalhKTVpN?=
 =?utf-8?B?NS9vMXBpNFZOZ3QzOGc3enpzNEF4NVBGRTRqaklmUjB0TzFQaThCSmtJZ1gw?=
 =?utf-8?B?WXBMOFB1UVd5L0ZRQ1p6WTg5cXVRSFJNTklIRXQ3aWpKRVZNRnQxQWZsVnBX?=
 =?utf-8?B?NklOdHBrV2JEL01ncXMzS0x0a2M2Vm8rcEFNbmhxU0V1Ukl6cUlldXBFSnJa?=
 =?utf-8?B?Zi9GZi9nMERGQ1N1SHJ2dTZjNnRxcVdQODFiZVYvb1NMUW5NOWZ5emkxbGg1?=
 =?utf-8?B?QjdTV2hPNGh3NHp6dnN4SEJ6S0hEUFF6azVVV0gyS1drVGprVlNTL09wY0lL?=
 =?utf-8?B?ZEE3NmlrVERSZ0h4ZjVXZ1JNaUlZRnR6SGJzRkQ4Ylk5R2o3empjYUs5VDVv?=
 =?utf-8?B?YVBwQ29ZS3FHK0R3SUMrWUIzVUJzdGtNWkI3UU1qcDRwRHNZYjA5eDdydnJn?=
 =?utf-8?B?RDFBejRjN21wUWttM0liaUdLNEYvanlqRDZyNDVKTTROQXpNaFN2bkcyMU9t?=
 =?utf-8?B?Y1lBaEU3aVR6TmVxT09iMDJ4WE4zcndtSEIzYUJWb2tEbDZZbDN4YWZJU2NP?=
 =?utf-8?B?RDlEc1VubDdLMEk4a3JqWlFlWVZiU3g0NFJPK2xhYVBsTkdrWTFDYU13Y3Ez?=
 =?utf-8?B?aXcrZkdGTVFIYXpPVEphNHZrZnltOUwwQkpjQVNzOTU4c0QzOGpvUXo3WmNP?=
 =?utf-8?B?Q1RJczBVbVlGYWhPbTdGRVI4SE15L1JiV2Fac3dZNFV1SVhneXRXTUxPYkox?=
 =?utf-8?B?UjBlUVpyOUtGNGpweVpwdWFzSXk1NlowN0pjZTdLQ0RDMlM5Uk1FZU1wKys3?=
 =?utf-8?B?TzRWeVp2eVFoTXpPNzJJK01KUWYwZ1NDN2pCUUYzU3ZzdTRVSVVoOTE5QnB4?=
 =?utf-8?B?SmJpSUNMK3AyUHkrVjM5bUQwQlZVZWhCVGdiVHNKUVhWc1lSdE5hamZjcHUw?=
 =?utf-8?B?UDdIMzVxK0d5T0c4L3FhcndHTkVxY3RKek9sOXdwa1QrUWxPYVhqRExtU1Mr?=
 =?utf-8?B?VjFnUVJRQ2txelhQdXJxeXNWQ2xKeE8rMnk1NzFpK3dQYUk5L2VZWE54M25Y?=
 =?utf-8?B?WnRkVUpsVHF2blRHOUhSN1RLdmRHN1ZDUUhjUUNhd3VzTUV5V2FPc3pRZXZm?=
 =?utf-8?B?RGU3VUtqU05CRGJQM2RXZnNVcEhUUVdrYWxpY2ZFVWw4RTNST2JlRFM3Mkow?=
 =?utf-8?B?YTNKWEZRVTRKS0orWkZYbXZNak1iOVdSMTlFbEQ1TUl5RmVMZCtRV2htS2N1?=
 =?utf-8?B?UDR0dm1waTFLS1luaUZlWWdadVZDZlQ0d3JTTGlLZm9wMVRoem9aYlBvdUhz?=
 =?utf-8?B?TVYrdStFanNja2hoWXBYR3djRnF3NzJFdUVacklycFU4RkNBa2ZvVm1DUlNh?=
 =?utf-8?B?ZUlNNkpkZHU4QlBWamYyQWx0Q3BRV0tFdzBHSFYwNS9pZlpUMVE1aXhEck5p?=
 =?utf-8?B?SHZGNVpUTUJwaUljUzRoNWsvT2RRd1E4VVAwL0pTUlVMTWxXWVNrakREMG4y?=
 =?utf-8?B?VHpleFBUczNzOENmZmlTVm5oUTlkeVFSN2RSbFJkTkhZaGhBQzdiR3dER0s2?=
 =?utf-8?B?Vlc4Tnczc0d3dUUxdm9jOGI2bU56bjFtVUVSb1Zac1IyRmZCQlhXdGdXQ2JP?=
 =?utf-8?B?Mnc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1aa4a62a-49b5-4d7d-a5bd-08db5c61b1a7
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2023 14:18:06.9803
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GZa5YNCGdC90BUrBWM/DzmXUbTnNDU+ZXAdAeZoy0SROq5ZD9krLJCDsKxsXraoFDiyS1Piq1hjK7ODBEHE18NPqjU2YXDIosBY9exOEkOE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5130
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Jakub Kicinski <kuba@kernel.org>
Date: Tue, 23 May 2023 20:53:54 -0700

> On Mon, 22 May 2023 14:18:13 -0700 Kees Cook wrote:
>> diff --git a/drivers/net/ethernet/intel/ice/ice_ddp.h b/drivers/net/ethernet/intel/ice/ice_ddp.h
>> index 37eadb3d27a8..41acfe26df1c 100644
>> --- a/drivers/net/ethernet/intel/ice/ice_ddp.h
>> +++ b/drivers/net/ethernet/intel/ice/ice_ddp.h
>> @@ -185,7 +185,7 @@ struct ice_buf_hdr {
>>  
>>  #define ICE_MAX_ENTRIES_IN_BUF(hd_sz, ent_sz)                                 \
>>  	((ICE_PKG_BUF_SIZE -                                                  \
>> -	  struct_size((struct ice_buf_hdr *)0, section_entry, 1) - (hd_sz)) / \
>> +	  struct_size_t(struct ice_buf_hdr,  section_entry, 1) - (hd_sz)) / \
>>  	 (ent_sz))
>>  
>>  /* ice package section IDs */
>> @@ -297,7 +297,7 @@ struct ice_label_section {
>>  };
>>  
>>  #define ICE_MAX_LABELS_IN_BUF                                             \
>> -	ICE_MAX_ENTRIES_IN_BUF(struct_size((struct ice_label_section *)0, \
>> +	ICE_MAX_ENTRIES_IN_BUF(struct_size_t(struct ice_label_section,  \
>>  					   label, 1) -                    \
>>  				       sizeof(struct ice_label),          \
>>  			       sizeof(struct ice_label))
>> @@ -352,7 +352,7 @@ struct ice_boost_tcam_section {
>>  };
>>  
>>  #define ICE_MAX_BST_TCAMS_IN_BUF                                               \
>> -	ICE_MAX_ENTRIES_IN_BUF(struct_size((struct ice_boost_tcam_section *)0, \
>> +	ICE_MAX_ENTRIES_IN_BUF(struct_size_t(struct ice_boost_tcam_section,  \
>>  					   tcam, 1) -                          \
>>  				       sizeof(struct ice_boost_tcam_entry),    \
>>  			       sizeof(struct ice_boost_tcam_entry))
>> @@ -372,8 +372,7 @@ struct ice_marker_ptype_tcam_section {
>>  };
>>  
>>  #define ICE_MAX_MARKER_PTYPE_TCAMS_IN_BUF                                    \
>> -	ICE_MAX_ENTRIES_IN_BUF(                                              \
>> -		struct_size((struct ice_marker_ptype_tcam_section *)0, tcam, \
>> +	ICE_MAX_ENTRIES_IN_BUF(struct_size_t(struct ice_marker_ptype_tcam_section,  tcam, \
>>  			    1) -                                             \
>>  			sizeof(struct ice_marker_ptype_tcam_entry),          \
>>  		sizeof(struct ice_marker_ptype_tcam_entry))
> 
> Acked-by: Jakub Kicinski <kuba@kernel.org>
> 
> but Intel ICE folks please speak up if this has a high chance of
> conflicts, I think I've seen some ICE DDP patches flying around :(

I haven't found anything that would conflict with this, esp. since it
implies no functional changes.
I agree it's been much needed, great, thanks!

Reviewed-by: Alexander Lobakin <aleksander.lobakin@intel.com>

Olek

