Return-Path: <netdev+bounces-1200-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 19A1F6FC9ED
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 17:10:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3A0C21C20BEA
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 15:09:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C22917FFD;
	Tue,  9 May 2023 15:09:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06C2C17FEC
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 15:09:56 +0000 (UTC)
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C4DB40CA
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 08:09:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683644995; x=1715180995;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Uk2Wjh+IkyRMn8n9/c1CEnwQ3Qklsuer9OtdAAdE8+I=;
  b=L7MYiQUIPRzOsNZQF6lCoC8cK2/Q0D6gY8sXKhZT2cbG1+fNYi8c+Nts
   KQcmiwUPL8s1Zq5QbMer9GEods8uag3ggqpRAuckLahcKgVJMc0LWW0AK
   3D0BVDPJSpDODx+qkBJaQht9Fc2ZxYGnNpL3HpAL7qewXu1npHIVCWAyl
   m9gvlbXqHSIrR2L0op4igf5CbfGF6vRrhQVcz6/3+HLgrhgOsV1+QxRMd
   FFMqX55ZmlFmckndlpqx/9tX2WOaPg+LOyFr3ykuxkfu8PCbPqkzShnPZ
   8qAkx8BMqc6N806nqUEHuKYhneALhzIn19fm2m37hMMGVSSr5ae4xxY+/
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="347416488"
X-IronPort-AV: E=Sophos;i="5.99,262,1677571200"; 
   d="scan'208";a="347416488"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2023 08:08:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="698937563"
X-IronPort-AV: E=Sophos;i="5.99,262,1677571200"; 
   d="scan'208";a="698937563"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga002.jf.intel.com with ESMTP; 09 May 2023 08:08:44 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 9 May 2023 08:08:44 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 9 May 2023 08:08:44 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 9 May 2023 08:08:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aGtbVfJaNgs4IolEpId1VGYYV90G+Cz/jcE2EwwEvHTahrt28IfBZPdkw7nBuP9sYT4D+8Snrkumu9TyfF8YNeiMtuyXSEqvcozvT8GuOPRBbro91O+uRikXLyRuqqshYmrBQMPN5fd6YLrnErHXHToc51AizMm9vYNGbEwZqMD+ZsmstdlMcLcQXAx92S1aMNX1IxbzRoyvA8VL8afpqrRSQrEcApIbhwLkRmbimrfseFZTwsBXg9RJec7T7slfTphKy3NQlUA0n6x1BrdIPIa42wIoojLmDII6Sq4A7tW/P+04FxR7NxrG2f5SBfhhv5ioMkuGKXunUvAtqfEvfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UlbMn/dl1Gb6akQe8C9RRHzjiyu0Z8bT3clx5i5zTqU=;
 b=e/DMMTATSCwI9WS9C3824bykD3jja7gdsZ/OEjjWGW8IRUKZC9s6rcEtSigVpOTMAHSxwXlba+MeK3Iyo4SyH0pEfx1QMWBMUbFQay0rH5kXUk4wivCUiwYF7gRYHyPic2U++1nyEnpn0Ng7v3AqY6f7OsJEc5r0bG5kWwJaJRcLducyCOTQpQJNmAwYvBdORaNhaGaMWs/yr1DLc+cYil8p/PKW9EpxyJ9CMnXW0hCTvLEwmMjkDuE7EBU7W+6LPzyMQfqBBSnuqrw4QsZQt6mRREforvlSnTYxA/KT4/kInGzP1t3GL+CxNshDcH9rsgZ4rsnnchFRquSGf8k8tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by CY5PR11MB6366.namprd11.prod.outlook.com (2603:10b6:930:3a::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.33; Tue, 9 May
 2023 15:08:41 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::5dbd:b958:84b4:80e1]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::5dbd:b958:84b4:80e1%5]) with mapi id 15.20.6363.032; Tue, 9 May 2023
 15:08:41 +0000
Message-ID: <af492889-6b0d-024d-91e9-a953f99419d8@intel.com>
Date: Tue, 9 May 2023 17:06:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net-next 09/12] ice: implement bridge port vlan
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
 <20230417093412.12161-10-wojciech.drewek@intel.com>
 <72f95cf5-d922-1f3d-2495-e8bdea6de247@intel.com>
 <MW4PR11MB5776A66941471BB2ABF7E99DFD769@MW4PR11MB5776.namprd11.prod.outlook.com>
From: Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <MW4PR11MB5776A66941471BB2ABF7E99DFD769@MW4PR11MB5776.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR0P281CA0118.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a8::19) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|CY5PR11MB6366:EE_
X-MS-Office365-Filtering-Correlation-Id: f105a2bf-bb70-48ce-f6c7-08db509f4617
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vbuumXX5HkQbZHN5TT5bLFzvsgFs0ocMdKdv1JGQTJZRou632w9I9Br6T2HsMy1PiKsqO+5jtejPAiuBXFZtpfoN1ZeNEggoirUwMWP3byWruWykOVnj8BDwHJZJk8SI7j+vLYWq5V13h90AUC4yWkiXKzGXFIzbCNYjlYmzFCLimNHEq5fG82w0H4SexCN9nx17U1rwMqhoOD4/+LatY6h9ffni+QfMUdhZ4n18Q+nzdei1t97E1rSXItCDT96J4nDtOmEyH2i5FxJrEmyASXPYpqRU90NWZmmoL8xxOci2MDA1XAYj2Sqx/vE/engwW2dayr4ReMo/UwHG3pCZ+xIqMd7b63A49uyrHeHd191Zo6fuNIGeLDoxHoEi5LMUE9hi1/7xZbniuctya3p1StJVGYjKvyXmtYY62Wh/x8QnHAC94BJHx6S/PyNTMMKtMFQfOipkGPY1+/QZ874EFtgim/m6LkmNRrrOraOUNOV9gWynDE+3LB8lGYLS2d2qlxukCYsMln6kZagvBv98iLWFa4pXG9WTUs0l4z2aKWs3FpxPJevJk1yYNvDiu4kTYIaXsIWoy3tFGA+WyvgNwVmYFrJ9SM1AnSWo/ee2slCEYwLZe7g4BiAMaootbUtIB8aGTeTS/6BjUW5YYGi6Zw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(346002)(366004)(376002)(39860400002)(396003)(451199021)(31686004)(36756003)(82960400001)(41300700001)(2906002)(86362001)(31696002)(38100700002)(8936002)(8676002)(5660300002)(6862004)(66476007)(66556008)(6636002)(4326008)(478600001)(66946007)(83380400001)(316002)(37006003)(53546011)(186003)(6506007)(6512007)(26005)(54906003)(6486002)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QzlRSzVUcU9GY3Y0NFM0c1lBOVlabE1YTEFIYmhwdmZ2Qm5SUjZPRUpRQXZP?=
 =?utf-8?B?OHl1MjhOeEVrZlJodHhHbWhMZ0N3YlROSmYyM3g3SktnN004dGQ3VFdvSCtS?=
 =?utf-8?B?UnBBYXJBcVRONGFzK2ZHTW5OckNIanJJNkFaR2NtaEpCVzlOQTZ4WlJXbk91?=
 =?utf-8?B?US9ROGVITTErTFZSY2s5U0tIZlJ0S3BYUjNNK1VzMC9zVDI4eXovbFJmK3lW?=
 =?utf-8?B?bVZjY2JqNVdTZUUzTGxCTGVFaldXZ0FiSnc3WFd5RUJGT1IrbFp1MWJxRDd6?=
 =?utf-8?B?dTRIWmFkVXV0bGtyZENZVDVWU0Q5MnJkZ0tPaHNrUkRoMDZVWWRJalQxc2lU?=
 =?utf-8?B?d0t6Tk85Sk56dTZrb1pBQ3E4QWVteGsxblNjTnorYnYzWlpsOVpkQUpleTFJ?=
 =?utf-8?B?bER3T3NNbnJweUFyc1p1SzlvQS9NK3h4WHQ0TTNFMDdkSmlhc2x4Q1I0OHhD?=
 =?utf-8?B?VlI5ZU5KQTZHUzFjQUFkNFNKaXdkMnRISGx4dTF4RkRkSDlxTmNKb1BpWTJl?=
 =?utf-8?B?b3JQekVOTWVJbWdCOXNHQ1B6d0VEY0c1cGJ0RDBUYjl2bnZ4TzB3MnFscUUw?=
 =?utf-8?B?Ny8wa2hjYnd5RTRYWENBekRYUU1PK1NSYVVjYm5qNDNKRE9ib1kwK1h0SmtT?=
 =?utf-8?B?UnNRMWlIN0NBcXNkeS9CbzRZVlRmOFhVcGJ5anZ5Z0dFdjg3ZDd2TG1KUEZL?=
 =?utf-8?B?OWZTamJOTWlmR0w4R0kwMmFnUWxubjVxT2pCb2lxeUE2Z2NLTkYxK0lUMFhm?=
 =?utf-8?B?S0k1RENuZFFGUmtFbG0xa0c2MnpWY0xnb083VXo2YXRONVJwOEs1SDRMUENG?=
 =?utf-8?B?MnpRUHRkNmRKcTJTa0pQT1RpSy9XMnBuVmJmdXZsQ1RyTElueTVNeVdjVUJ5?=
 =?utf-8?B?YVNYcEFyZlE5UldBZy8vaGhpcFRJM1J0bm1nck4zUVc4a3o2MklMbVJCRXcr?=
 =?utf-8?B?bDJKQVRNMFM2eUlTcktMeENjUU5SVHVoK2FEd2JuWEVoMlJHci8vUm5IRW5l?=
 =?utf-8?B?ZHdzbHdRWUFTR3JDeFRlVlZGVnJ6bmpSRDdxakwyRXdreHZxVUFaZWo3ak56?=
 =?utf-8?B?c05FSjZ1K3Bwd0lRMHZteW5TTWxXemdzcWRMR1g1aWlUNG1MUEZNMXpwelpa?=
 =?utf-8?B?TmduS1FzMEVrRjdJT2UvSU1RYnE1WEVyTjgzNGNzOVY0R241c0RqaXcvZ2xW?=
 =?utf-8?B?YkIvV1djK3VtZGZrdURZMDIwL3BSR2RRNWlzQnFRTGZCaHNKaUMxMSs3UHUw?=
 =?utf-8?B?SGdzTnRFdW5NTnNrUlh3WXl4Uk94bnMvemorZTNOSGdIb0Q1VTkrREpFV2s0?=
 =?utf-8?B?TG1kV0RHR01YOXRsWkl5M0JhYVhCYjdHQUdhaXJTU3JzcndPRHMxbTNNR3ZU?=
 =?utf-8?B?ZEU2ZjFVSEpOOVF4TUZOK3FnaWFVQUlZd0dQZUt2U1ZYRzVUc1hFVm1mSWV5?=
 =?utf-8?B?M3VFWm9aMVZ4Z3VGRFdNZ1BlSVV2WmNMUnNHQ1FYajdWZUNWaW9WYU0wcjNi?=
 =?utf-8?B?MXRJdnI3Q3c0YkFoRGJ3cHcrYk5pdURwOHJ3R2ZZMWJ2MXdncUxKN2VMbVEr?=
 =?utf-8?B?cWdFNXNvWGZpOWh4RE9teXZXMy9NUW8rMEtmMENjVzVwQmV1THcxdWt0OGZJ?=
 =?utf-8?B?cHRScmt6anhyN1VuK1p4aFp4Wlo2M2FsMXdoUFVCaEJlc3FMK3pQUVgyYVpq?=
 =?utf-8?B?eHNsZHQ2K0NURHhIcmVidkJhNGVSSE5TTUdPZ05xaERXcGxYdGxnVVhPTHl0?=
 =?utf-8?B?R1gvV0lsdjlMLzNyM1kwT1F1Y0lCZlgyWjd0MmtjNDVQazg0WG8wVFFKMlJP?=
 =?utf-8?B?TkdhZXRvSzcxc3kyTVRYMWVPc25pRnNJcnJVeTk4ZEgzanRUSmxBS0x1cDdL?=
 =?utf-8?B?UHFmY3Y5RDIxNVZUTzhqZW9McHM2MmJnQzZ4RW13a0EvUXA5YUVCTXIwZjR1?=
 =?utf-8?B?SXhLRlRZNC95V2JVT1NIaCtWVTFqVDEwUTJwUzBMWlFjYldtNnpud21YTlV6?=
 =?utf-8?B?WmZ2cVU4OEV6U2J4Q0p4TzlkRVFRSzd1cjVDU0VNMFlvSjVWeTVON00wakJQ?=
 =?utf-8?B?Q1lSeEg1ZFkwQ2dmSXhOeFh3L1BFNE96ZW1vQ3ZhdmJ0ZDdIZmNYcWs1eHRF?=
 =?utf-8?B?M1RldE9rTTYzckJuamRETm14S0Q4WGc3WXNoVE1RWDA0NWd3dFZ2aXd0OTln?=
 =?utf-8?B?dGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f105a2bf-bb70-48ce-f6c7-08db509f4617
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2023 15:08:41.0778
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hUMuPobwh6JHHV37axbqdIYfbhY8CspzxcanQokYwx2pgnT1IwMBT/kU1VX5vE27WQ+uPROPl/DwGpsnL/LbJUginugIYDbgD6+6MP0BpXs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6366
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Wojciech Drewek <wojciech.drewek@intel.com>
Date: Tue, 9 May 2023 13:25:40 +0200

> 
> 
>> -----Original Message-----
>> From: Lobakin, Aleksander <aleksander.lobakin@intel.com>
>> Sent: piątek, 21 kwietnia 2023 18:35
>> To: Drewek, Wojciech <wojciech.drewek@intel.com>
>> Cc: intel-wired-lan@lists.osuosl.org; netdev@vger.kernel.org; Ertman, David M <david.m.ertman@intel.com>;
>> michal.swiatkowski@linux.intel.com; marcin.szycik@linux.intel.com; Chmielewski, Pawel <pawel.chmielewski@intel.com>;
>> Samudrala, Sridhar <sridhar.samudrala@intel.com>
>> Subject: Re: [PATCH net-next 09/12] ice: implement bridge port vlan

[...]

>>> +	/* Setting port vlan on uplink isn't supported by hw */
>>> +	if (port->type == ICE_ESWITCH_BR_UPLINK_PORT)
>>> +		return -EOPNOTSUPP;
>>> +
>>> +	if (port->pvid) {
>>> +		dev_info(dev,
>>
>> dev_err()?
> 
> To me it's not an error, port vlan is already configured

Usually, every user action leading to an errno instead of 0 (success) is
an error, it's the user who is responsible for not doing such things.
A bit more details below, I reply bottom-up this time :z

> 
>>
>>> +			 "Port VLAN (vsi=%u, vid=%u) already exists on the port, remove it before adding new one\n",
>>> +			 port->vsi_idx, port->pvid);
>>> +		return -EEXIST;
>>
>> Hmm, isn't -EBUSY more common for such cases?
>>
>> (below as well)
> 
> I don't think so, user is trying to configure something that is already done.

+

>>> @@ -639,14 +697,29 @@ ice_eswitch_br_vlan_create(u16 vid, u16 flags, struct ice_esw_br_port *port)
>>>
>>>  	vlan->vid = vid;
>>>  	vlan->flags = flags;
>>> +	if ((flags & BRIDGE_VLAN_INFO_PVID) &&
>>> +	    (flags & BRIDGE_VLAN_INFO_UNTAGGED)) {
>>> +		err = ice_eswitch_br_set_pvid(port, vlan);
>>> +		if (err)
>>> +			goto err_set_pvid;
>>> +	} else if ((flags & BRIDGE_VLAN_INFO_PVID) ||
>>> +		   (flags & BRIDGE_VLAN_INFO_UNTAGGED)) {
>>> +		dev_info(dev, "VLAN push and pop are supported only simultaneously\n");
>>
>> (same for dev_err(), as well as below)
> 
> 
> Again, is this an error really? We just don't support such case.

Well, "not supported" is an error in the kernel usually. It's like,
"user is responsible for checking the capabilities before trying to
configure/use something, if he didn't care, then we don't as well" :D
The main problem here is as follows:

1. Most distros have "quiet" in the default command line, which limits
   the default output to errors+.
2. User tries to configure something, which is not supported.
3. Essentially has a bail out with -EOPNOTSUPP.
4. The default kernel output says nothing.

It's not an issue for tools like dmesg, since they usually display the
whole log with every loglevel, but still not really consistent as for
me. Plus, even in such tools, dev_info() will just lost amidst tons of
other nonsensical output, while dev_err() would be marked bold red.

>>
>>> +		return ERR_PTR(-EOPNOTSUPP);
>>> +	}
[...]

Thanks,
Olek

