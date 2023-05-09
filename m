Return-Path: <netdev+bounces-1198-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BC21B6FC9A8
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 16:57:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 810ED1C20BCD
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 14:57:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 477AB17FF8;
	Tue,  9 May 2023 14:57:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3663217FE6
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 14:57:15 +0000 (UTC)
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B328359E
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 07:57:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683644231; x=1715180231;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=5cJVFL2OXeDtzQ3x86jrJQe+wnAcpldoHZtuoWcBefs=;
  b=RT9PGio29F+MgU9b8Z/H8vU1bfCergDC03+qsKdSd0pAgO7fTD3hAtse
   ZUF6J5zQTwSQp9c/eDteWqIkE1DGo6TTKyjvuxPzTvTLdPG5tdDffyzZ4
   oJe/ioP/v70YcjQKJUZ4PW2r+sxR8o2dJ/b43evTRzJbvohN1mTJn025E
   6XEGTCnIWfg/fv4zpsyPgqi3kSeN1x5w1BkD3EyDsWVdiirmYLkMYNtJP
   LWq35zpbErtjCXHehBQPELuc8h6cg3yz0w0YcaiQDPzZVozwPPpv1JL+S
   BR6AQqSi2DtRVBJnuUdRKKW8Mr2siNEZuKsvYYvK8mthK/R6pNNPkvd2Q
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="352120467"
X-IronPort-AV: E=Sophos;i="5.99,262,1677571200"; 
   d="scan'208";a="352120467"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2023 07:57:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="873216938"
X-IronPort-AV: E=Sophos;i="5.99,262,1677571200"; 
   d="scan'208";a="873216938"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga005.jf.intel.com with ESMTP; 09 May 2023 07:57:08 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 9 May 2023 07:57:09 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 9 May 2023 07:57:09 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 9 May 2023 07:57:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dmZnDh2gDJ8/jhnOmstZ5fZ7to8c2o3MyTAnSloW8gls1B6WS9UU8O/zwa9pMqNkPCNLKZIEW7j+buxEomaMdJWMxTwsTc/eNkvd//fibSe8ZAx3FIMVCM/1fzVMgtAvp4uJiiN6VX/ftqO/35k90emOEn/RjaxDayY8HWu/wJUA2yBPp5p5Tzug0mHLBZnCJSrBx8UpQz4oA6X0J1Xvv4Of75NVYr5V92bjsUCgflohn7h7QFVYsyOfyOFA4ZGkBBhGCJ3A0fUJNPkS93lEdfR1rP4ROBmIo+0pCQnlO65R29R6NOsgurjNL+yn6YzN2mRhVMf6qVk2Amn9U9wLMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kwUDJRFbpUwzz9jRfoRAQhAsprtppbSWf86OUvaYBgw=;
 b=ElvMw2v/46+AbtQy8QphWG+C2TcnVjKYsb1FNYIgVNSYQzCQFM+LD9xsFoZVk84i2m6W0aJ6Grmo4K1wVim2vwG6sUPD9WwznlIexU8N9CCozElmpJEtHS1Dwe7iY8PobkTuXx1SocYR7uQmySuU3Uw8VyJ2OXYilOq7GKnSHVP+6Y5JJq2LBFkFZ7LC1H/K8la5gubsKlRKxWFFx0alzSJaJintM7rvxXNRUAem9m7G1OEvWmZ/Lee3qPeYcbjrQ6KLKt0uhiFK/Q0rAKpcjj2uKDfHUIncwmAngXmms3G3Xv19zWm+xcvFU2FiT94UX5CdAOszZ6wJItTsEDHIjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by BL1PR11MB6049.namprd11.prod.outlook.com (2603:10b6:208:391::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.33; Tue, 9 May
 2023 14:57:08 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::5dbd:b958:84b4:80e1]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::5dbd:b958:84b4:80e1%5]) with mapi id 15.20.6363.032; Tue, 9 May 2023
 14:57:08 +0000
Message-ID: <c25cf06a-b9bf-df05-9be0-62c215c84d04@intel.com>
Date: Tue, 9 May 2023 16:55:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net-next 10/12] ice: implement static version of ageing
Content-Language: en-US
To: "Drewek, Wojciech" <wojciech.drewek@intel.com>
CC: "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>, "Ertman, David M"
	<david.m.ertman@intel.com>, "michal.swiatkowski@linux.intel.com"
	<michal.swiatkowski@linux.intel.com>, "marcin.szycik@linux.intel.com"
	<marcin.szycik@linux.intel.com>, "Chmielewski, Pawel"
	<pawel.chmielewski@intel.com>, "Samudrala, Sridhar"
	<sridhar.samudrala@intel.com>
References: <20230417093412.12161-1-wojciech.drewek@intel.com>
 <20230417093412.12161-11-wojciech.drewek@intel.com>
 <a868e53c-add1-986e-7c96-a02afbddde1e@intel.com>
 <MW4PR11MB57768C748EAECE1F76B53975FD769@MW4PR11MB5776.namprd11.prod.outlook.com>
From: Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <MW4PR11MB57768C748EAECE1F76B53975FD769@MW4PR11MB5776.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR3P281CA0020.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1c::21) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|BL1PR11MB6049:EE_
X-MS-Office365-Filtering-Correlation-Id: 540fa724-427f-4df6-8578-08db509da8c6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xL0HqF3919N/UcYHGwpHMdyeogU/08v7gU1irB9fvtfSyYn32eMAQ7bzXAX1C5iQv4VNqPbfvBQb528mzBAfvMUIII6pE2fbebx8f2YGL9f7zqc4m3zqQUpAwx9WwoIs3KaahZ16vkwj8dqHJ9tjE1YoF8YSCfwXJpDKrQBTvQSCvn6JNfogx/mPXgc379bC6bYYngstcv4ajlLDl5Vo4qcN/57EH8TEKTIbML8j4Ym08AutCYJlCkCnvWg2SPNzxU2TbFXTIXPD6Ey7pm9zGyPla7zs0j6xyQ486R8ShV8WE0/Cb7kXdBPT07NJJSbPZKTRjI9BBRvFyUXqwoEiNRt4HjisZXuvf/Tzo8skcMSz9n6gddeqLo8Us7lJiXOrie7fDq8kp4LthnJJLBYk4xW2S9Zd0StGTeRtUZn6zyTvg8xNlGX8nk08N7cHcpI281sfXO+gOY5aKn6JrqbN3G+PE5X2I9jSjhyCbQQv8lilwZOvCAtX6WYnjTvnNMgPCQX+1+bZbHAgLpQyiMwpBt+oMR+ThB0vTLsUFGbLuLY090++FEdcKTnsc6M96297Z8uyUiCt4LxjhSRpnS/rOoUe32m3L9gzNwfOnXmr3Tp6ydkZYmBJOCIYsFIYuhqPpuhlJyaSxNc9IHspDSU6ow==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(376002)(396003)(346002)(366004)(136003)(451199021)(5660300002)(8936002)(8676002)(6862004)(53546011)(83380400001)(66574015)(186003)(2616005)(2906002)(36756003)(82960400001)(38100700002)(86362001)(31696002)(6512007)(6506007)(316002)(66946007)(66476007)(4326008)(66556008)(6636002)(37006003)(54906003)(31686004)(478600001)(26005)(6486002)(6666004)(41300700001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VU05ODNtbEtRK1plVlN4UW5aWjdYWTNFdFdCQS81cjdCNDJCV3lGZVVrNzFs?=
 =?utf-8?B?WmVxT1h1OERVczJSenpodlNyUGZWU1ZzUy9FTE15ZG1Qa0NqVDg4eGV4QW1G?=
 =?utf-8?B?QTBkTG5nQitkTkw3SVFLeXlWUzhrbHk3a2dQeGYzMVJCYThwZHU3MlkyeHkx?=
 =?utf-8?B?elJyYWlRWm5nTStsZ1EyMjdBQmhWeENDaWhUMmx3WTZhUHJ6VDBqbjdEOGZh?=
 =?utf-8?B?YUNWaks0THlyajZxUEZVK200N2NKRE1JaFp6Sy8zd3NTazYxMGZBS0NsZ0Fw?=
 =?utf-8?B?bFR4SUVES1dFR2xvYzVJTnU3UklDZGdoRW4rWjhlNzVkWmozR2NOQWFCMEcy?=
 =?utf-8?B?MFJnWXRmZFJtRTg4L2R1VXdUOGpqMGw2dnNJbnRMMFJTOFdUOXYySlRpcVVM?=
 =?utf-8?B?NHhROFhJWUY1end0NzQ5WDVpakQyVHdvZFhvWE01cTk1NG5hWWdqYXNZK2Vr?=
 =?utf-8?B?d0szK01Xbk42N2hYb3F0RU9DdHRSOEdyVjRpUzR3ak5zVWlyWXdELzMvSi9F?=
 =?utf-8?B?ajdHZDdsQkV3ZWx5U0tNcU4zY0hJUGFFTG5xTmpmc1h5d3JWUnFyQ0IrUVpM?=
 =?utf-8?B?QStMS3BIRVRVVEdwVTQrR1dNRlRCaE9kMmNSOFF2UUsyL2xhZndJbzRXQ1Fs?=
 =?utf-8?B?MnpLaWJhdUMrdE5pbW5icU1JS1NMK2ZzZG9JRnAzTlpQMVBnck5BKytqczhh?=
 =?utf-8?B?bXRJVlVoYzhmTVRPczUwclljaCtlRVJKMnNCN2c0Z1lvRWlGYWVDYWlJYmJB?=
 =?utf-8?B?bGVBaWJZWGlVY3lTQWc3VC83WE5aM2R3NW0yTllFTWNQTC8rc1MzcnJ4MzZs?=
 =?utf-8?B?Y1I5ZUYrMUZLUmExVXFhTzc1Q3JYbXBvWWtTUFFTc1gzSHpIamFDb2Jvalls?=
 =?utf-8?B?OVZqZElCd1B2Ny9KaUVOc0V6VE5Qbjd2YkowYmJNeU9hQ20wU1EveTI0dmti?=
 =?utf-8?B?NlphRUF3RWRoUG5kQXpOTVQ5Wk82clJ3Z3dUZmVYYmI3ZUZLc25NcVk2Q21i?=
 =?utf-8?B?NldJaGtQMVA0QzVQTFVkSkZBNmJWWHJldEYrQjAwOUlIVHUzc3ZmQzRMKzlQ?=
 =?utf-8?B?ejZQcEhVRTJZdjU2R1MzT3RmWGU5NVppT3FLR2xWL2dNaTkvTU15aG9NVUhV?=
 =?utf-8?B?azZxWUU0VWRmV3VDVmszMm5tSmpDUjA5OGc5SHRWM25HVGExZHpIMHR5Tks0?=
 =?utf-8?B?dWEwbzNBNnRYSXJUbUJrVzE0cjNCUVdhNGljaHJPM2pYWWFYOWQ5a09CLzVl?=
 =?utf-8?B?UVpqTHJqMjNBVU85NWQ4YWs3ZkJUcThJNktrRW1ldHg2eFdQRVMrT3BwdW1j?=
 =?utf-8?B?eVdSVENNanA2YSsyUTF0OEZGYnhwMEVoSWtiVkxadWtoMHJTcitVOWZZVmR1?=
 =?utf-8?B?b2dvSmdFTnZvTWxiWEhFbFBWejRQcVRGV3JUeVVCZU1jTVhaRG83Mm1jUHFy?=
 =?utf-8?B?WFA3WXJpL0YxajNySU93M2dlOVdWNVRhdU51dEpDdlVHODFSalp5RGtTNERt?=
 =?utf-8?B?VWZ4S0tIZVl5aFRWclE1dG1TRE52eFZya0F0Yno5d0QrcDl3YzNOeDZUOCtH?=
 =?utf-8?B?ZGpWL2N3OGhPamE5U1BaL1h6RExVVko4bjBEai8yR3IraUMyVG5qc1hMZVRE?=
 =?utf-8?B?NEVTaDVEckFmcE1OYWUwOFFIWVZZN2RkcXJlR0VrMmdVYlUwTE5VbS9NcW5v?=
 =?utf-8?B?VUZ6ZklCU3ljamxUQ3kveWk0N2lMZUNxM2ZtMWFuZVBZRzV5dlk5VUkvemZz?=
 =?utf-8?B?cW10ZndtS3gyQUtRRjNzUnZtZW92d3hOVWdLODVMLzIyazZNNCsvc2ZwTENu?=
 =?utf-8?B?cDZ5WkwvbERUbk5qQmpqRGxTVE1hNnNsVnZVVkxXSnVLaE9rSXNkVmlFcEtj?=
 =?utf-8?B?NHlEbEVFbzlkdFJmQTdRRCtRME1EdnUzbFdlR0owVjVqa2ZFVkI5bWRQRm54?=
 =?utf-8?B?bGxMc0wrRkRxMzVad2k3QU53UzZDRTZzdHFhL1Q0LzdrY1JNNnJUaGR0TE5a?=
 =?utf-8?B?NmFZMFozSS91aDMrVWFFYkNiM3poZGdQNnFPT1JlbTZHeDI4QWRYdXVGK3p0?=
 =?utf-8?B?V0wrcnVDeVh1RVRoZGs4cS9velNBQzhwd1hOaDhLZC9mWTc3QlRvZm5lSGZt?=
 =?utf-8?B?SnpzQmR4aXQ0K1paNkorSHdPMFlLN2hUK1dIZUJWVUU1WEhxNnFQM2J4SVdh?=
 =?utf-8?B?OHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 540fa724-427f-4df6-8578-08db509da8c6
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2023 14:57:07.7881
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z0F5wcDay/Q3mCyma7N/hX8SjlONaX/D+SxTQqkfrThnvjdOkv2zQ5cYw8TDb2oRg8UuPBKkPkqtyl+rMthEgWpDBA5HEos/meDwkIHfgho=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB6049
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Wojciech Drewek <wojciech.drewek@intel.com>
Date: Tue, 9 May 2023 12:55:53 +0200

> Hi Olek
> 
> Sorry for late response, I didn't manage to answer all your comments before my vacation :)
> Will continue this week.

No problems, I had a little vacation as well, so wouldn't reply either
way :D

> 
>> -----Original Message-----
>> From: Lobakin, Aleksander <aleksander.lobakin@intel.com>
>> Sent: piątek, 21 kwietnia 2023 18:23
>> To: Drewek, Wojciech <wojciech.drewek@intel.com>
>> Cc: intel-wired-lan@lists.osuosl.org; netdev@vger.kernel.org; Ertman, David M <david.m.ertman@intel.com>;
>> michal.swiatkowski@linux.intel.com; marcin.szycik@linux.intel.com; Chmielewski, Pawel <pawel.chmielewski@intel.com>;
>> Samudrala, Sridhar <sridhar.samudrala@intel.com>
>> Subject: Re: [PATCH net-next 10/12] ice: implement static version of ageing
>>
>> From: Wojciech Drewek <wojciech.drewek@intel.com>
>> Date: Mon, 17 Apr 2023 11:34:10 +0200
>>
>>> From: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
>>>
>>> Remove fdb entries always when ageing time expired.
>>>
>>> Allow user to set ageing time using port object attribute.
>>>
>>> Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Thanks,
Olek

