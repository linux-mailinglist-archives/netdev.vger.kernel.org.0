Return-Path: <netdev+bounces-3469-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9EB737074E5
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 00:01:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 51FFC2811FE
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 22:01:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6243F10949;
	Wed, 17 May 2023 22:01:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AE4A33F6
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 22:01:44 +0000 (UTC)
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2DB32D4D
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 15:01:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684360902; x=1715896902;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=QJKcTo2MP+BQNhiIeFzCFEi7uYOi1ty0nJECZq9Kybg=;
  b=EQOhVCVLV/OilKJluuy6AGSWeM51rBTQCGsMMpwo+tBpt8g0VGSmSYs1
   UC/OGs1GylnBWivuU/qJmBLUymDtkqUyMoHOzKjbV1q+wkIN9nIl/fpON
   kqk2bJNuR3iBfUVxvllyE5eLdWzCMFs5y/LjprwDTyr8CUsnNE73QCCzc
   Tf96PefiGaBXPFsmRKWW6k3Z75uU3z2hUMzuzOKzYZAkPOIPQwU4gmUO5
   KZ0rsSGRkxmsE4d4r5UZ8cEOOs15WR5v033Im5guSYeE6sMsX6sigg6En
   7jlmcVTzcVjy3Kato3KVMp3AmRalLghRiEGzV6B48UBNzolvB/PTDOvXW
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10713"; a="380088400"
X-IronPort-AV: E=Sophos;i="5.99,283,1677571200"; 
   d="scan'208";a="380088400"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2023 15:01:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10713"; a="704966467"
X-IronPort-AV: E=Sophos;i="5.99,283,1677571200"; 
   d="scan'208";a="704966467"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga007.fm.intel.com with ESMTP; 17 May 2023 15:01:41 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 17 May 2023 15:01:40 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 17 May 2023 15:01:40 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.47) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 17 May 2023 15:01:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BeVbYE2nUgaK34Me7O8+zSIEMn2fujTZ+e4tNAQ/2F/KvDLItVkByDH6wp5cYM5XR/EZuYhL9+YdM9aVe5D2zIIT2oPKYlzzWYY7IGUcaNgZ/HyNukj9z8azKOl43Hv9AbVKq2fdrDmJxj9ZwwYQZ4fPDPszY6tu+9l3Q/+rXqd0zIo5RChKtvI3nQvXEWSZLLWJOD829T2JOOO49DzDT5jNSBVM1QbPVVkUV47vk3Jq9jo9AdLGo/7Sdl7BI/aC1zhtNAt34cGjH1idu4ywdDSvSzapS/hjE+gQi3r2XTB/q12dt8X/drsgKEdQVY7qMSU26ir2I1l6JkukvqjGKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wdLfVeaB/DE3raqamL0rPNRNYT9KpPLyPShuJ8FS38Y=;
 b=WMoOu/re3H2KG9o19ulgEAnQw5qvp0Gws90aOF3dJNXxzk1FNVVQmpF3i+c+AI98xNuncQBS8qAd1d8dO8yLvbrlqxYnq3P1Oc+IIfHDk49ODB6JfaDdF9Qee0Ij1nY8kvD1HZWc66Y/qsNZiSJP8l4FducIFVe7clpYqMjiraxWi8KIXoyt9EBk5Zb6UOehK5gKAGsWrvvyMZ/Gtm0984NqZG8oxD8mEik5hf6MqgN5M3FDGyaykU63ObQ/5rkGb6HkYUOiv1tiHAt8ASp72nE2pmcwI0X9p+qkS2qClEHQLvf+bjwKCYDh1tZBef/ejENNwkbnFK0n6s6s+N58Sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by SA1PR11MB6686.namprd11.prod.outlook.com (2603:10b6:806:259::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.30; Wed, 17 May
 2023 22:01:37 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::27fc:4cc8:6fea:1584]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::27fc:4cc8:6fea:1584%5]) with mapi id 15.20.6387.032; Wed, 17 May 2023
 22:01:37 +0000
Message-ID: <1571c8f5-b36a-5af1-d56c-d38f69406840@intel.com>
Date: Wed, 17 May 2023 15:01:34 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH net-next RFC v4 2/5] net: Expose available time stamping
 layers to user space.
Content-Language: en-US
To: Jakub Kicinski <kuba@kernel.org>, Vladimir Oltean
	<vladimir.oltean@nxp.com>
CC: "Russell King (Oracle)" <linux@armlinux.org.uk>, Andrew Lunn
	<andrew@lunn.ch>, =?UTF-8?Q?K=c3=b6ry_Maincent?= <kory.maincent@bootlin.com>,
	<netdev@vger.kernel.org>, <glipus@gmail.com>,
	<maxime.chevallier@bootlin.com>, <vadim.fedorenko@linux.dev>,
	<richardcochran@gmail.com>, <gerhard@engleder-embedded.com>,
	<thomas.petazzoni@bootlin.com>, <krzysztof.kozlowski+dt@linaro.org>,
	<robh+dt@kernel.org>
References: <20230406173308.401924-1-kory.maincent@bootlin.com>
 <20230406173308.401924-3-kory.maincent@bootlin.com>
 <20230406184646.0c7c2ab1@kernel.org> <20230511203646.ihljeknxni77uu5j@skbuf>
 <54e14000-3fd7-47fa-aec3-ffc2bab2e991@lunn.ch>
 <ZF1WS4a2bbUiTLA0@shell.armlinux.org.uk>
 <20230511210237.nmjmcex47xadx6eo@skbuf> <20230511150902.57d9a437@kernel.org>
 <20230511230717.hg7gtrq5ppvuzmcx@skbuf> <20230511161625.2e3f0161@kernel.org>
From: Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20230511161625.2e3f0161@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR06CA0056.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::33) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|SA1PR11MB6686:EE_
X-MS-Office365-Filtering-Correlation-Id: 481c759c-b1c4-4bf8-642c-08db5722496f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BNQxhECBx/rSesy2s8FRZlfOucvoRJLF8oWEeDugxSt3qSEood4Jj9LtHfX32x5tSqdhycYPqrak9xdmt+Zo9+wQnbr6z3fe7nMcU4DlNOckJN7P/g4rshdvBtfnR/Ia7DOASvFDg0jmKTFmbPWbNCJlJS97JFwtb2wZuTZOhhT6xUXQACfjvKlwp3ZqETur+6EJMTCWWaZ0915wy+v0qTPkROmVtXFZGZK7azUsIMhyazHNdGeyzE/eSXPSXbtGXURcbMA5NBvcLykTr8dQeVYRxY7zPwjJObsiT7BtpFHotgk4xbI0PtB3ZyfSAxd9U5ynSR77J+ZxtCC+AR0TYQNBn/peyJzuyaE+4jqtP01C27e+QjXNQbUtnqSy4uC8Ku1CV4HCL64M8QzflVs37cVsOBaIC0fg8G32Cg6U5IBpWwV4SmoW2d8pBrtPqJCFNADhbmiZIrCeNLpKusRwU55G2YN8gxQp70PhhNJwlXHFQCcobZ+44KqTHAJbcEJDHyIyhWBeuZWRvI1iw++AcFkVeNro7Atva02hBYDdkSZ8kZTGs+G5SdM7po2u0lTLSOply4+ou9e7YuTVu7lEFkqEsbo5TNDWsQJ+ZPxfNwClU08hKt/fBgmg30xtutR/3Z8b2fLVEQfcLdGi94lFeg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(136003)(39860400002)(366004)(396003)(376002)(451199021)(478600001)(54906003)(110136005)(7416002)(8676002)(86362001)(8936002)(5660300002)(4744005)(31696002)(36756003)(2906002)(66556008)(4326008)(66476007)(82960400001)(66946007)(316002)(41300700001)(38100700002)(186003)(2616005)(26005)(83380400001)(53546011)(6512007)(6506007)(6486002)(31686004)(6666004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UERrejI3eDZFMTVFUFUyN3pMdTFNcEdsR0hmYkVacnJGTFV4MnRrcnNmdXUr?=
 =?utf-8?B?bVNUVlN4UzI5ZzhmWVhUY2I3eTBVTkczcXJ0NUpyTVhWZjJFZkZXbG5uUE9X?=
 =?utf-8?B?TitrOUNiRlE4aUE3b2k0amdwOVRkbUtTUFJFRTZ1Q3d5SlgzNjhGdkhWU2VN?=
 =?utf-8?B?WEcyVG9YaGQ1dFRPMDVucmZBNERXZnY3MDZ1NHZEbmQyckhQclhQcDdWN2Rr?=
 =?utf-8?B?dXBQMjBTTi9PakNSUmNPbVNZVGltdUtsOTlrazByMFQwYVVWeFJjeW1TN0or?=
 =?utf-8?B?WmYrVmFOdHExWENUUlRjMFBON2VobjFONlVvckErMXNQVHk5enVBWmNRY3Rz?=
 =?utf-8?B?N3U5bENuNGgyN1ZHcHF2ZFR4QzJTVTJVOHZWcHhsYjVLejFIWGRQZ1BNNW5L?=
 =?utf-8?B?aXIzaEp3anVmS2V0L0VrTzRKd05pRWFLU3I5RmZBamZJc3dVTXFNY2Jtbit6?=
 =?utf-8?B?VXBCa21Ua09UaVU5UmMzWDJGVzVDaHQvT2FHcVQ2ajhLUUptV0JCMVBvU0Z0?=
 =?utf-8?B?WVd6cS9JL2hWT0twVTgyU3l6VGlqMkg2UXFGelNoaTFZU0FDNld4Vk9oM2Fv?=
 =?utf-8?B?R09hZCtXRTk2Uzh1RTJzVk5Qc3hqaVZpdCt3OUdLTVM0OThvMi9qMzdpU2RP?=
 =?utf-8?B?enZNK0pkRm1mejRXYmtvZXVOaWUwUlYyUGdoamRRV2FMSzRLQzd4bU15TlFO?=
 =?utf-8?B?RTU0VjhZQWh2UVhmbGUrU2xFK3dKNGwxK0NiT0NzV2hmVUUydDRwSTdmZVV2?=
 =?utf-8?B?WjVkU3BmbGNmcjNwNDExZWRYSmNwKzZaeTRmOHJWRFVwNjUxTEZJbkRDcVIx?=
 =?utf-8?B?NUwyUmMxdEw0TUh2Mng3dXlCR0RKeG52K09vWG9raHhqUzBmSVY0RFdjMEJi?=
 =?utf-8?B?TWxMS3A0dzBTQVQzVmNwTDhTSzFqcy8wbmxEMGd6RjdrMmxUUjNKTkFDQ05S?=
 =?utf-8?B?UlBLSnJpSG52VEZaVHFLdlMrNlhkbTFBcXRReGFtUm5vbndWYk1rWS9rME01?=
 =?utf-8?B?TzhSSE9vZ0lrNWErQnl0SThnYW5MQUd6cGExbERML01qdDJnYWZhL0tDYzRo?=
 =?utf-8?B?bkxGYTB3anhjbXdDcFFwNkhYa3dQVnpzNTU5c1N1L1hmajF2S0s4NWNTWm1k?=
 =?utf-8?B?c1hiNndPRmZmenQ4c1o5VTk5cDN1UkRnb1N6SlIyL3RLNnRnVCtiSkN6Sm9L?=
 =?utf-8?B?M2xScUgyazVsZ1pFZU1FRUwxSHQ0YkVaV0ZYRmt0aldCR1dvUjh5ZUJ0QUh4?=
 =?utf-8?B?Z2lZOHdqdlhlbS9zK2dOMTBWMjNhM1FoWDRtV0prcFNZaCs1c25uWVhvKzhw?=
 =?utf-8?B?Y3BnZjFHTVloWGN3Z3MwT000Ti95alRrYTRLWjBVdTVZU3FvNDFTWU9lNndP?=
 =?utf-8?B?MEJZeFhlNnFrRFIra1ZBd25UTWJscnlxQUgva2d2U25meVRQMjRyNWgxOS9F?=
 =?utf-8?B?QzdWQkYzbjU1Qkw1bkZDeVBMcUJYQXdTMU14bi9aR2NPZ0RpbUFCbE1vUlYz?=
 =?utf-8?B?cDdOQXM2ZzRMWGQzT1lKUTgzeDdySmhNbW5DKzlZVVhJTlJRTVdzYmhMTjVW?=
 =?utf-8?B?RHBOTTBWYXVFVmNkWFYrWlR2YzJiTjdncHRlK2JvOUx0d0pEM1l0SVg4VjJG?=
 =?utf-8?B?SytWeld0OVNhZVhja3ZvRHVPMldQVmgzbmgyV2ZCS20wVDlLQ3lSc0ZsRWgx?=
 =?utf-8?B?MGJaN3NyUEs4dHBDeGJDbmRzVUNRNk83V29UcStuM1pNaEcxTWtMVk16MVVt?=
 =?utf-8?B?dFF4N0tSbVArYXRxb0k0bFhDNXV3Q2F3ZDgyNGNlNDR6WEZ5clFHR1dDWDZD?=
 =?utf-8?B?dFJkOHh0MGhmeU1KcnFDODkrQk1naHZNM1ZSV05Zd3dXY2dWVlEzZGlzLzJz?=
 =?utf-8?B?OCt0U1BRcUpNR0R0VHgzdk8wNm9sUWk2NWtoUk00WXk3eVBCVkgyWXJiOFJj?=
 =?utf-8?B?N3htT3Q5Tlp4L0xrOHFscmx6QjBlUk1Fb0dLYm1meHcwRitpTlVOVUdXTlla?=
 =?utf-8?B?TVlJQ1ZIT3lNK0kzMGxEZEZlMmNaci81RmpVVGpzeXhUUEN0KzZJaENWZmxv?=
 =?utf-8?B?ZE1rSzQ1VG9JZDRFMjB5cXVKNnlhdCttdVFtcnpldHZTWFFIRXZ1WnZycW8v?=
 =?utf-8?B?S2g4cjVMMEJkajIweW5JWTRubTh1VUY1eUh4RlBFRUE3a3NKYy8xTmpTQzN5?=
 =?utf-8?B?RXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 481c759c-b1c4-4bf8-642c-08db5722496f
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2023 22:01:37.6911
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4Jnk6VEYFQmjn+AYIjCCkzlqaThezFvEk77chGq3pZQ8vdpNu2twHUec8wAyns3daID/4jLf9sUduaOqsU8z/mGo1GK4tZ6Pecj2316wbOk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6686
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 5/11/2023 4:16 PM, Jakub Kicinski wrote:
> On Fri, 12 May 2023 02:07:17 +0300 Vladimir Oltean wrote:
>> AFAIU from igc_ptp_tx_hwtstamp(), it's just that the igc DMA
>> controller did not bother to transport the timestamps from the MAC
>> back into the descriptor, leaving it up to software to do it out of
>> band, which of course may cause correlation bugs and limits
>> throughput. Surely they can do better.
> 

In myy understanding for for MAC timestamping, the igc hardware stores
the timestamp in a register and assumes you only have one outstanding
timestamp request at a time.

The MAC timestamp is captured well after the Tx descriptor is written
back as complete. There's no completion queue on this device to send
such a message out-of-band of the Tx writeback. Delaying the writeback
until after the Tx timestamp is captured would have its own challenges.

Obviously it *can* be done better than this, but thats not how the igc
hardware was designed.

