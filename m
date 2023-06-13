Return-Path: <netdev+bounces-10365-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8108D72E225
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 13:50:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B101A281218
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 11:50:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED6922A713;
	Tue, 13 Jun 2023 11:50:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8843290F9
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 11:50:45 +0000 (UTC)
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52808171D;
	Tue, 13 Jun 2023 04:50:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686657028; x=1718193028;
  h=message-id:date:subject:to:references:cc:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=6/wG5JMGdjZy9ySMWNrNrSgbeex+/2FMXJY30QfRaUk=;
  b=e1JleghEGhPpdYn0GyuL5SJ6eMbosgjMDtJCFJARkmyAfdURhq6YpqUr
   e1LjaVow0n4JuwKVPoY04j211vpiG4uWqVfRPgBORf7fQD3OOj4yfLtbK
   6k+scPyb0E9j/jZ59yJwpmb51PgYmiy5filzzJP7KzRA20tZyOvYY1QMQ
   HRBTO2+Jrs2xamCno/8JCMnBG5dT9KMtPDrxwHxV2O4ErLyRLAa0LPBqL
   WkJyi3qBV5kCnU4qOsR+2Dy6tlOzD5M5scxi0q0/lWOPkdHBkb3vsHzMd
   ve0OtQ9JLO41SdJ86gdXs8KaDF2IXQIHcR2MePBNNv1iH3KC4T3Tf2UZf
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10739"; a="444680992"
X-IronPort-AV: E=Sophos;i="6.00,239,1681196400"; 
   d="scan'208";a="444680992"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2023 04:50:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10739"; a="744652037"
X-IronPort-AV: E=Sophos;i="6.00,239,1681196400"; 
   d="scan'208";a="744652037"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga001.jf.intel.com with ESMTP; 13 Jun 2023 04:50:25 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 13 Jun 2023 04:50:25 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 13 Jun 2023 04:50:25 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.42) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 13 Jun 2023 04:50:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C6YP4DXhIS1Yzecy3gUubQz2I5PYYYbdOW9zmagwKz2irJZsgAOkE/lGqFBLwDBPsGCcAEe5wEOduu067/vcTksp2V4PN6+XATexBc4vdqplqK4jjypmczkiDXtk5EKkeZvNpHbKcEsSlJpBkpaohtgOyk8sRAzqU+/sVbH/2QaI9TWf0XUHQHfIiSkZD7ksg1V8eqVjr9E+bjouTncw7OW2wnLKug+FXCvfjdcptfJ6w4HRbqfrwUGrcfblAPN6k7w4e5fsXSNAPnKXUSEJ5cXqJTqZ5GsSyJZNkuqMl4mOLPomjMOa6II5dJ6Z48ccugHdltRzOqgEQJhIqjJM/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6/wG5JMGdjZy9ySMWNrNrSgbeex+/2FMXJY30QfRaUk=;
 b=MuixePeGtKKLfBH/lyh50Oazv1gMo1gQf9vWCoVn6Q8LMBoP/R3GiWwfaO4nh+cVxeXrF/d9/+v5M+VReljje8XUfTLG1/hUyNzawHFG1z4JQGZ8q/AwbNlb0U0UL/lCiWDXR8R+RmHzXvcYmK1lU2S74iR7MhudVvDuZFjYcIlNpzbDpsxO9iic0hi+1NIuxODvex2d+oQoEfZcZfFGkr9FfDOENXdHVW6ioXK5WMjNJpapjEdSOG00Oec92R8hGtBxzdVmkMAwpGmRzFnXXt+4E+47xr3JqJoHMqmN58Odrrv+RyaQHwlj6CucY46qat61vmawuNpZY0BL24zVLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by CH3PR11MB7276.namprd11.prod.outlook.com (2603:10b6:610:14b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Tue, 13 Jun
 2023 11:50:22 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::82b6:7b9d:96ce:9325]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::82b6:7b9d:96ce:9325%6]) with mapi id 15.20.6455.030; Tue, 13 Jun 2023
 11:50:22 +0000
Message-ID: <293a81d3-f0b4-904c-a5f9-64ce091f1ecd@intel.com>
Date: Tue, 13 Jun 2023 13:47:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.1
Subject: Re: [Intel-wired-lan] [PATCH iwl-next v7 00/15] Introduce Intel IDPF
 driver
To: Pavan Kumar Linga <pavan.kumar.linga@intel.com>
References: <20230612231021.39409-1-pavan.kumar.linga@intel.com>
Content-Language: en-US
CC: "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	<intel-wired-lan@lists.osuosl.org>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
From: Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <20230612231021.39409-1-pavan.kumar.linga@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0050.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:48::13) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|CH3PR11MB7276:EE_
X-MS-Office365-Filtering-Correlation-Id: 3502525c-7ce5-48d8-2e93-08db6c045e63
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UiJnbKqSmMI64gZTk5JK3ZtAPfi8GybeVrrjosCqTflzm1vXnoNxiAzkh46xa7aC/H80QAHh6q7HQS+XGCgBoT6q8s0RG9qO+rE7e7Czhl/hdh+qiBX81PCg01HKTXghk8OQYmEt+L7lo0zPnOPLGIviBAauK9RH698xzOUZZE8VumT8mO0BeykG5DefsJwyLylkO8PHfeYuick09X/PXo8d02Ykwqmuj4Y6jr3VSMQzVBH3UPytZbwSf7Z/IcAG+8UyRKgYW1Jhdtf6uTGaFOztRvECFZwHm8c5ulsk1xA7pzL+sOjshUUlhVVM53YZmk3+6m8xBV3j7DuqBg/hgYkHtylwqNbjijEGvJ7Ua335FTIIKurJomr0/cC24860wWo2DMk22dNSjQwgKrME2xheHYndzp9+QuLmc9y/LDhwWlr6JnkQKqmrRx+tSDsq/ihloa14CP1CI28GHnO62Xk2WsCdh/pROd7fT/RaMxzJPz0L40p6FZZqYoNIinrIJB10OvQ2kF3JoKXUdEEqybvBZb3Yl1Oe/5gXBt/xkO0hjO0ykrnXuicL3YYZDSgVBfLudCZiYW+8q7Ov5p9M6V46s4LZigaZSnhk9d/wjQ0wlPDLQ6qjNofEGFMNVNrgcT5GPWH8bWJCegcNIA4s2A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(346002)(39860400002)(396003)(366004)(136003)(451199021)(66946007)(66476007)(37006003)(4326008)(478600001)(4744005)(6862004)(31686004)(2906002)(8936002)(6636002)(41300700001)(8676002)(5660300002)(316002)(54906003)(66556008)(6666004)(6486002)(2616005)(6512007)(86362001)(26005)(6506007)(186003)(36756003)(38100700002)(82960400001)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RVZ3dGJGZFBrcUxQS0tqVC9hcHExaDU1cWhqZGxvbitmMS9abjZESVBEbXZi?=
 =?utf-8?B?YnFoTzZ4eGkwT0FQQ21uRDVvdDJJUEczaGEwYXhmaWV3YnZ6citGajErektk?=
 =?utf-8?B?NElaSGlvY2FRRU9JWmF0NXhXVVJWSnZDT0c5dmhrM01lOTd3TVZZUXRCWGJm?=
 =?utf-8?B?YUswVFZZc3h5VjdIb2xJOWlwenpJUnc2dkw4SHZKTXAwR3d1YTAzU0FEQi9L?=
 =?utf-8?B?b0tpT2U5SVdWU1BmcDZsSFdmTWhJbm5MY09XSGZWc283UExTbmp3Q2gvcWdq?=
 =?utf-8?B?cEFZREFUdVREN3d4K0s2ZVBRbXpFQXlEYW1yM0VzOEVDWkd3dFdrYjFoN05t?=
 =?utf-8?B?QzBlTEt1ekVhcFVVeFc1Z0RCVE91clRZbXg2cFBPbmM5b1M0SUVyREFId0w2?=
 =?utf-8?B?TVdUVVNkLy9obFZkNXNvSVJjY2dCRGlsUUNvVS9oNUdwRmhzV2VZRUk3cUVO?=
 =?utf-8?B?UG1tZlo5OEhMTGV6c1p4WEZ0Ny85Y2UvMEpYdVh5SGZMVEpoekpQQWJIS1dU?=
 =?utf-8?B?Z2d4bDJ6SThub2RHSzdIQ243cTRQYnFBNHV2c3VIQ0JWcGtVbXk3RmJXR2xR?=
 =?utf-8?B?Z2psazVIQmljZ241MUxjUkpydGtRV1JMMlJqOXAvd0ZRTmVxVnpLUUwwRVVQ?=
 =?utf-8?B?VUFpcmhHNEJXYnhqMWlISTJpQ2FvTFhGVlBmZndpWjZ2Mk1uMHJhTHJyTmEv?=
 =?utf-8?B?dXQvTlVkMHVTU2FXRkdsYnhvTDh5RUgyYytycEZjQkJMVlQrNlc0TjFiNHJF?=
 =?utf-8?B?dU1ISWh1RDF6UlNZdVdZSUJneExKYmtFTVlGRk93ZHdJTnRpbUN4Z1NGZVBE?=
 =?utf-8?B?TFFGVkJkd3lIT25sL2ZDSlVyVG1xQ0s1blE0ZjhwdnNtRWQ3RWRBTjR2NWNZ?=
 =?utf-8?B?LzBrd1dXT2dhWjJCaUdxbHlXc3dUMC9wNXowcTNYVzdOOXppY1BnMFpiajUv?=
 =?utf-8?B?SWNPNXNnaS9Kb3BiR1dLR0wxZjN1YUtIY0pMUHJuelRXeHBwSTdDQytHc1BB?=
 =?utf-8?B?MnF0V2Y3dlZ0KzUzOWxHMFRuMFAyTFJ4SHd5aUxrOTNQcmNZbWJRYjF6VHd0?=
 =?utf-8?B?MXpMNHF5OGQ4cDBpVmREMUprUE5vMzNWTzM4Qm50T1ZhekNhaXh3em1nY1pQ?=
 =?utf-8?B?L0JoUHBuc2g4d2VTZkNhd3d6djBTa0Y2RXI2VlYrbCtlSlZQbGdHYjdUY1hi?=
 =?utf-8?B?eG9ETk5DYWZxTUZ2bWtMWGY4a2N0aEtqSUo0WmpXRHdCMzdvZTJ5QnhPUkFr?=
 =?utf-8?B?bmg4Z21IYk9QbTJNOWVXbXJUM2QxeGpPbmNOeG1ZTFdUc1FKd2taZGxUeWRM?=
 =?utf-8?B?aXFrVzRGWkdjdFZoVklOUWNhaE9yMmNlTFErVVhUd2dHajBxRXRuWlpqRkxr?=
 =?utf-8?B?QjNDTHc3bGFpbm8wazluRGEwVWNCbHpESU5GMkxOd2VSSGZFT3BOWFpZQ3pX?=
 =?utf-8?B?TU9aOFE1ZHEwYkc2aFg0b2sxakw1TENJMTdDV0lrNDRXY29FZGZURDFHRTk0?=
 =?utf-8?B?emRscFoxcUlhZnN6VFlKdUpOWmoxbWdxOTJVU1d6MHNRMW83S2IrWGl6eUgw?=
 =?utf-8?B?SHdmc2J2cWhIRGtJMW04RlNPbHFnU0xRdWtmSThrRGt2U2svRVlMNERDakZ3?=
 =?utf-8?B?YURDZEp1alcyRmVvS0lDbWRUL3RvOUc2TVBrWW5VRXdraURWYWlSbHk1Rmd1?=
 =?utf-8?B?WlNVZmxHbHBrMWY4cWhQKzNid2VlS2tFajdqMXJXRjlVWkJFb1I4a0w4Y0hR?=
 =?utf-8?B?MUVnWTlCaS9kVkdzd29nNUpQM09Vd0l6M3VIR2tWb29LbFF3TndNN2ZrOHB6?=
 =?utf-8?B?V3JIVXdiZm5GR291S1dPcEUrMzU4QnNsRzNCNTkxd0lYNnpWTDdqSFh3eUhE?=
 =?utf-8?B?WEFnZDBsSHQ0bkdoZFJjSTJ0cjNqQW1nUXJFQW01MUtVUTZwdEx1MjJMVVhj?=
 =?utf-8?B?SGZFbUJBWjJCT3NKZWVRQmNYMEhxWTZOYWh6akZBRHoxWXZqOGxIR3ZFZnRi?=
 =?utf-8?B?RmVWd0lZTTlCcTVFeEZWQVlXd3BmeFUwOUdQcFBpQ1FKdjJRNDhsVFZFenox?=
 =?utf-8?B?MkRwendObGdLRnRCTlJRK3NaTGlXeWpiTGpROXBXNVJrYlBNbTdzamJPdDV4?=
 =?utf-8?B?bWJyRWlhdWJ5WWM3SUhkWE5Xbk1nWFJyTWEweDhtQ3BVVmM5WTh6Mm1OaUNS?=
 =?utf-8?B?SlE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3502525c-7ce5-48d8-2e93-08db6c045e63
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2023 11:50:22.5279
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Hqsld0QCEk1v07fs25jKenONqA/ILuF4HDsxZpj/GLgEHnRRcRLIYrQcI+/f+jIZgA66hce4y+9bAm92CuNUzHZTO/fQuwUJO0hNSBjH2uE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7276
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Pavan Kumar Linga <pavan.kumar.linga@intel.com>
Date: Mon, 12 Jun 2023 16:10:06 -0700

> This patch series introduces the Intel(R) Infrastructure Data Path Function
> (IDPF) driver. It is used for both physical and virtual functions. Except

No netdev maintainers and generic MLs, not speaking that the previous
versions already were there? What?

[...]

Thanks,
Olek

