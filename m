Return-Path: <netdev+bounces-4344-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EDD0170C25E
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 17:30:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9CC22280FC3
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 15:30:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8D2514AA9;
	Mon, 22 May 2023 15:29:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEF52C2F6;
	Mon, 22 May 2023 15:29:59 +0000 (UTC)
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75A87A1;
	Mon, 22 May 2023 08:29:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684769398; x=1716305398;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=nYM2QpiK9TnrpkFqjVVcsaUjUwidNLDJuLNFKat3ub0=;
  b=mh6njRNulqAWRavgKUNKrcpgYlaHNshRSP4yPzXbTmo2OXqm3c/F3Lxb
   7p8kxNpAoQzfEWuJ/heO6lg57uGgmlBRn2XuNJbG4oDWc05R+0lYpjRyp
   IZ0hLIu6UiKSdraWwq+oWG/tSAhD5Ufk/PSjXTfYQkt6drTZjypxTSL3n
   f1ucnL1PWwW1VXSeUdTHObMw3IapT/Dd9Fh76lAw6CSS0d8MZ4dXOQduS
   /28cNlTGDrDHYwcHuiCkA/EjJ5w4eus6vkxenTMfREKR09+pfzKmZO2QQ
   dS6zecvtFrxTUVJ4PPT2Z2rZ1P5gYRi4+RywQ9nfXq4G0hdWfhvZwEkyV
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10718"; a="351801016"
X-IronPort-AV: E=Sophos;i="6.00,184,1681196400"; 
   d="scan'208";a="351801016"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2023 08:29:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10718"; a="1033657899"
X-IronPort-AV: E=Sophos;i="6.00,184,1681196400"; 
   d="scan'208";a="1033657899"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga005.fm.intel.com with ESMTP; 22 May 2023 08:29:55 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 22 May 2023 08:29:55 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 22 May 2023 08:29:55 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 22 May 2023 08:29:55 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.40) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 22 May 2023 08:29:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PPHvu8cjXNNENaqxx5z5pgwU8e/B+ElXd0355vMXDhOtLNQ5Rz/S4916mufWnpL4utvkENSCNcYZjK7BbmCvsu5TndLVhsq6gSrowOXzinL+qmoRE+Kyw0oPCmZo8vnQEx8I58/Knp3p2BFUTFUdf9QS5oTJqH/7ZSXhOXZPaLbSbv902z1mFkzTxWSX5AoCfD3gtVmL50RS2O36k8QMblz5pEhgDmWr9BYEHfhrG/OyoL1/pxDGK/zBuAQ19fAZcM3QyBnJg/i+u9IHYf73a+KCZDhsNZ+sTa3d2Qh+WH9MW7MxWhWPRvRII8BQKTc3171RXw09iMJWJSY6rJhAwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xriRpxwNZ7Pod7zmj/WfgoCLkOTXcmCoI3rY5jMuJWY=;
 b=nefh1lyb400gWO/Ui1e3lxKA0rbLdyO0aYA3O+M12a/qL6U+DQoW0w7WPxcH7iIiVsDBKfDIKLkHYdGno5x+pjm1NNHwepYPVoUK/G4IKrBJaKw9h6ggQLJkWfWz5+8HlV0ZNJ9CsSzSQW+ADSnkJrw6rv477nxBFbYZHiy48bqaRMvHacyEnZ9peSbxY3VbAVq1WeSInZFOKhNhX+ja65g4+H0RSHpHpLvwDG8tJay0YDQOv+B0iEWBxqcsAVkkEO1/nRGODQlbiziotZNyUlEFCuYL+bWyCLdRn7YAF6h6ZQ46B1iXYJ3T4bvNBj3H1DpP9l3rBQfVyIEXRjbmUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by CY5PR11MB6413.namprd11.prod.outlook.com (2603:10b6:930:37::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Mon, 22 May
 2023 15:29:52 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::64d9:76b5:5b43:1590]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::64d9:76b5:5b43:1590%2]) with mapi id 15.20.6411.028; Mon, 22 May 2023
 15:29:49 +0000
Message-ID: <d53f0150-d74b-7cf6-8fe7-324131b43982@intel.com>
Date: Mon, 22 May 2023 17:28:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH RESEND bpf-next 14/15] net, xdp: allow metadata > 32
Content-Language: en-US
To: Jesper Dangaard Brouer <jbrouer@redhat.com>, Daniel Borkmann
	<daniel@iogearbox.net>
CC: <brouer@redhat.com>, Larysa Zaremba <larysa.zaremba@intel.com>,
	<bpf@vger.kernel.org>, Stanislav Fomichev <sdf@google.com>, "Alexei
 Starovoitov" <ast@kernel.org>, Andrii Nakryiko <andrii@kernel.org>, "Jakub
 Kicinski" <kuba@kernel.org>, Martin KaFai Lau <martin.lau@linux.dev>, "Song
 Liu" <song@kernel.org>, Yonghong Song <yhs@fb.com>, John Fastabend
	<john.fastabend@gmail.com>, KP Singh <kpsingh@kernel.org>, Jiri Olsa
	<jolsa@kernel.org>, Jesse Brandeburg <jesse.brandeburg@intel.com>, "Tony
 Nguyen" <anthony.l.nguyen@intel.com>, Anatoly Burakov
	<anatoly.burakov@intel.com>, Alexander Lobakin <alexandr.lobakin@intel.com>,
	Magnus Karlsson <magnus.karlsson@gmail.com>, Maryam Tahhan
	<mtahhan@redhat.com>, <xdp-hints@xdp-project.net>, <netdev@vger.kernel.org>,
	<intel-wired-lan@lists.osuosl.org>, <linux-kernel@vger.kernel.org>
References: <20230512152607.992209-1-larysa.zaremba@intel.com>
 <20230512152607.992209-15-larysa.zaremba@intel.com>
 <ee1ad4f2-34ab-4377-14d5-532cb0687180@redhat.com> <ZGJnFxzDTV2qE4zZ@lincoln>
 <b9a879b2-bb62-ba18-0bdd-5c126a1086a9@intel.com>
 <a37db72f-2e83-c838-7c81-8f01a5a0df32@redhat.com>
 <5b817d49-eefa-51c9-3b51-01f1dba17d42@intel.com>
 <fed6ef09-0f5b-8c3d-0484-bb0995d09282@redhat.com>
From: Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <fed6ef09-0f5b-8c3d-0484-bb0995d09282@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR3P281CA0057.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:4b::8) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|CY5PR11MB6413:EE_
X-MS-Office365-Filtering-Correlation-Id: 20d2f506-f26a-4980-4cbc-08db5ad96155
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PneZLpMmsPTGRPd/fqY17PwZp1X3nzpw4Y9FbDs79N2K2to6hhVa8JBLxTk1Kyv3GjsCI5iZtUAtFf3VeTJ1Sit0p7C1gGeNhbHAoFyGFiPwZhTU0USo+lCigkAm0YGk0VYrWWAMcPKo6lFx6AOfr2SkL5t3rzS4xoKvmSKl2bQQOkL3kG9vbQiQeztlkXrjfYs4kO6XysvdsHZbGLob/Jw3uUtHmDVaAFqVSYMga4BZX68ztU0O9WeKyJ2QLVj4sUMRi8QSukUb/RtbGy1YV9JjvcwV9VCnTWy2E9O8iRwlU1tqQK5KWtQfFpAR8CVMNJk+ljc/ej7VuqcfSYt2khz4iROsfgzyzPN9EfB/lQACYG50nPhYpWC8Tj1Ujm6cYIHzP36Hu3zzrb/fhIQsGcQhAWXJl9DR/H6vuP8Bi7zOpSAIcHppa5Yoi93mCWMXJiZF5+sGCWcxHOjkXbQsLI8FvG277aUfWYusLZl2kEH+MRhU7jwXBMEmTrRce/2dR8JKs3PmpFFXieCafPCn2tfQi4TTHUiTs5ct4EYX8priOAN9XJjMbxMJaWb/0/Z5MD1klTEhqIwzLgx811WkCGJtGseQa8bSzI9qw88x2StMLLlfUgNU0o57r3vYTKocLbRb/QgaIds3zVx/CW9MMw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(396003)(39860400002)(376002)(346002)(366004)(451199021)(7416002)(5660300002)(8676002)(36756003)(186003)(2906002)(83380400001)(86362001)(2616005)(82960400001)(38100700002)(31696002)(8936002)(26005)(6512007)(6506007)(41300700001)(478600001)(6666004)(316002)(4326008)(66476007)(66556008)(66946007)(31686004)(6486002)(54906003)(110136005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c25LMW5ZRDlTcFZzOFlxYW9qZ1psNW5PUkVvdi8xZWlUS0Zyb0NZdHp0bnEx?=
 =?utf-8?B?ZXJCY0JBejBsY1ZPRXFjYnNWVUxXVmtFWFZ6eXZxcUtoMEZmYlk3SW1nd00z?=
 =?utf-8?B?RDEyMFVKZytmald4ODZUZm8xSmJCTTVBaklSLzlJY2RQWjBpQW90V2NIaUly?=
 =?utf-8?B?KzNpd1VZalMvUG9NSXQ4MlNYSzNKaVJyRW5yZ1lPbDdwY2h0WHl1RnozSno5?=
 =?utf-8?B?aVZ3b1RHQk1ZNGFVR1huQUNVUFBiQ3lXN0JFdWJRSWJCY2xJU0YxM2NKbXJv?=
 =?utf-8?B?OW40aUR1QWpyRmh4U0RKWGUwR0VneHJtNVpqeXo4a2U2bEVpOFYweUo5TmJs?=
 =?utf-8?B?S1p4ZGZWRVZGT0JtQXdlRW1lNmF0M2UzZk1IbzVoRVc5bGFkcityQmtoR29T?=
 =?utf-8?B?MHR5L0dXZDZVdHFVajN3Rkd4alJhSUo2WE9icW14N0FnR0Z5NnFvek13TjZO?=
 =?utf-8?B?UGZuM2U2VWRCV1VsZis3K2xMelVndTIwR2pQNkpkeDRDVlZVdFZpZ1Z0NnhP?=
 =?utf-8?B?dWhsZGRsNnVEMXgzQUkzQTQzUUxvb1drYjNPL203U24yU054R3FsM3hzOHQr?=
 =?utf-8?B?SkoxamtjTmNJVlJQRlBiYmxDeUZTQnpFMGl6azlpaXRkWjdZanVvQXBzV2lR?=
 =?utf-8?B?N3RTQjRsb1pPM3B5ZnhYSGUrcHBJZUE4aVQ1VmFXdEN3NGY2NTBVSmxwVDBC?=
 =?utf-8?B?ZzBwY3oycFF5Y0ZFTU16YVFCcWRSTGVBY1RpUDAzNDFNaFllNjB4dUgvWVRS?=
 =?utf-8?B?d0puOURiRitBQU9XY0FTV25kMVAwR0U4dWhoM2hWNE9ZRzZkdkx6eWVHREI5?=
 =?utf-8?B?bFBLM2pnbm1VM2M1VEh0eUF0MGQvazZ4Z1NBTWsrbkdqVlhwOExPQm1tZm5n?=
 =?utf-8?B?UXpOMmZhRUlYWHIvb0R4WFpBWVRUc1ZWQW95U0FjWUtRZU5HRkZGVUIrY2px?=
 =?utf-8?B?YjdsYU1CbDRVbTdIazlmd3ZGMjNHU0xzb1ZwTWhlaWdhNUZhWW8vKzFDTm5h?=
 =?utf-8?B?UUFPRXNNRHRrbUozQ0VQRTdySzkxMG9tSlcycEluQmcvbW1iNHM0VUk3Z1hL?=
 =?utf-8?B?dGZ1cmhYQmdJTWRhdWlxZ2dIem9nUG9Id1VYSytkcEphWUUzakdhV0JjdHZW?=
 =?utf-8?B?UnhOWjVEYTNQNTJHUUFIKy9oRXZ4RUhhU29ZOFBocVhZeHA0aGk5Z2tmT2w3?=
 =?utf-8?B?MFpMYUJ3UXNLYTN0UVBjR3d6STluQlhUMkxCNjFqa3B2eTk2aUlkZ3MxZUQr?=
 =?utf-8?B?THJtM01LQUV5NFNVWTUzajFQWjVvTmN6WDgvM29IUlRrMUk1TG5vZ2tIMlFm?=
 =?utf-8?B?WjYrbGFDSzYyT3JYT3hGY3RzcTVDTmRSZmVSOG5XbmtsZjFYTVZiMm03SllX?=
 =?utf-8?B?MzFRcUZFL0VLdFVPTFhJTVc3c3QwQ3Q0THFwY3hONGZLU2JBeU9HdGxCYUZO?=
 =?utf-8?B?UzNIbytDYzVpaVBoZVB3V3J2TjRmLzY3djRpUVR6cUZOOWhjYVNubnVMQVNR?=
 =?utf-8?B?aVpyUDloRkRqZ1ZHbEcxc0lOYmQyL3dOejR5YUZ4S2lseFNFKzMwYU93eUQw?=
 =?utf-8?B?UUJOQ0FWeUZMQWNxTXFHakc4b2VPTDB6UkFwWEwweXRFNmxYWCsrbGc5cXo5?=
 =?utf-8?B?RFBJbFgwS2NDUlJIVFZUaFI2VDU5MHZmWEw3aDBQd2IrTkNLUHBwSHp2ZWRp?=
 =?utf-8?B?NGlnOEo2UHdOUVhuc1BuOUtCQlBSR0VIUjFmRXk2elREQXFvVVlOLytuWFhH?=
 =?utf-8?B?WC80VENSS1VyT1p6NjV5czBHU2hJbmpSa1NvbjFseTczZFBYYXpXU2d5bjcr?=
 =?utf-8?B?dVVFdUZURDhGVDVNcWVSZkxZNEc0NGNlQkxvajJWdzRXeXNyL09xWFpuSUdD?=
 =?utf-8?B?ZitPZmZrQzFVM29EVzRjVWZwby9FTHF4R0ZWMmRCZkFMc2hPU2hKUlJzNjZN?=
 =?utf-8?B?dUNOajFWcDNYNWpNSDRVZ2JpRXVGL3UrUXlpNndLU1FoUGkvZWt1aVZBQWVH?=
 =?utf-8?B?ZTZlZ3lwT04wY1crYnBNS3E4Mys4Q1pSS2MvaHpkNmtRU0Y1TVFBZk5saUJP?=
 =?utf-8?B?dnVIR1htSGNUZXVsU05mOElZRnRQOG44bzlQajIyODJJd21HZWE4Q3B5Rksr?=
 =?utf-8?B?S1JPM2ZOODdyRFdUOWlwc25UVHRLbU5qaTB3dVloSEYwWVhPRW1HN29sTWY0?=
 =?utf-8?B?RkE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 20d2f506-f26a-4980-4cbc-08db5ad96155
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2023 15:29:49.6054
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0pSQlWBWt0AWsMIJUYB+1qeJTxPBFc8Nhpy5LNtZBJgSm5XZF5stgU8LEiiOu6PI3THnj6m2BmGENMhLEZC6Ttiz60DNQKF7/nqee5YmO6s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6413
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Jesper Dangaard Brouer <jbrouer@redhat.com>
Date: Mon, 22 May 2023 13:41:43 +0200

> 
> 
> On 19/05/2023 18.35, Alexander Lobakin wrote:
>> From: Jesper Dangaard Brouer <jbrouer@redhat.com>
>> Date: Tue, 16 May 2023 17:35:27 +0200

[...]

> Not talking about your changes (in this patch).
> 
> I'm realizing that SKBs using metadata area will have a performance hit
> due to accessing another cacheline (the meta_len in skb_shared_info).
> 
> IIRC Daniel complained about this performance hit (in the past), I guess
> this explains it.  IIRC Cilium changed to use percpu variables/datastore
> to workaround this.

Why should we compare metadata of skbs on GRO anyway? I was disabling it
the old hints series (conditionally, if driver asks), moreover...
...if metadata contains full checksum, GRO will be broken completely due
to this comparison (or any other frame-unique fields. VLAN tags and
hashes are okay).

> 
> 
>> The whole xdp_metalen_invalid() gets expanded into:
>>
>>     return (metalen % 4) || metalen > 255;
>>
>> at compile-time. All those typeof shenanigans are only to not open-code
>> meta_len's type/size/max.
>>
>>>
>>> But only use for SKBs that gets created from xdp with metadata, right?
>>>
> 
> Normal netstack processing actually access this skb_shinfo->meta_len in
> gro_list_prepare().  As the caller dev_gro_receive() later access other
> memory in skb_shared_info, then the GRO code path already takes this hit
> to begin with.

You access skb_shinfo() often even before running XDP program, for
example, when a frame is multi-buffer. Plus HW timestamps are also
there, and so on.

> 
> --Jesper
> 

Thanks,
Olek

