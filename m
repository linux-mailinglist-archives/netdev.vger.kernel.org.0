Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7275660BB7
	for <lists+netdev@lfdr.de>; Sat,  7 Jan 2023 03:05:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235727AbjAGCFG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 21:05:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230046AbjAGCFF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 21:05:05 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9452584BE7;
        Fri,  6 Jan 2023 18:05:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673057103; x=1704593103;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=6U8XE60RZvAEVTg51sQfHbPwsHNHHwmMJub9MGabnzc=;
  b=Gz6N03wUm1wRPlNtbDsYqz8FFnqHgkSaNnQwvxuPB6r1eLPNRiHtfD/u
   uZpYQLUMYOzdDQb8njwhWPfxV4dhYgG+SVIP5tyQOJccs8Vnqc8OPFsC5
   +NXa/LIraMEG2TkpjQSEz5aSabuCqdQ/pzIc9fwrWHqVK4KhRFPApPEi4
   Djlktw/L8+2Fh3eIOljNFNTlRkoBDFmsM9bB8O9o0JKoOHJJzh7HsIxe+
   GDwJf9YtNiKlCjv0slm0gE9qgXM4SQJ6KNrdkyj7MLmx5AS7jERO/Ca+C
   s7L5h7INuRr5rQM4hvj47iURIqq9F3XWUEBJuiu8+ZnGlJh/TlQ9LEJBh
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10582"; a="302301116"
X-IronPort-AV: E=Sophos;i="5.96,307,1665471600"; 
   d="scan'208";a="302301116"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2023 18:05:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10582"; a="719376603"
X-IronPort-AV: E=Sophos;i="5.96,307,1665471600"; 
   d="scan'208";a="719376603"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga008.fm.intel.com with ESMTP; 06 Jan 2023 18:05:01 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 6 Jan 2023 18:05:01 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 6 Jan 2023 18:05:01 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 6 Jan 2023 18:05:01 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.102)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 6 Jan 2023 18:05:01 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jMh7r9FtC8qRdmmxMyDC4Gdh7WagGaZcs+IRs3Qmvb2L7jyIb5rHzUqShm5buR6jpL+uItR7LAA5TDyRXYmSYEzHV0Txr1BblrrFKXLkUC3ngsvKBy9a6NqVMZIsWm8qwRsGh7or5UNyizAjIHGUyES14LRCk5QH6mq+jS59bVLUm2NOc2wFPT4c/RMWiy98J3OOCjTjaCphV600XAZnGwNSUYdSERYhf8hS/h1/eKaWsTSIJDN0xqIOpOyZCArzeQVlyzYeLciw9LSfvwl6lBvsB5B8bmuOmPW5rsFlcJ+DCLtdK6lgpkgBRMRq7ZujOlWJiHVPpI0DaPh6+xGLMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gUdFCcMbM6lCkXHl1jz//31MN8hHDhxU3DY4xt2yW6A=;
 b=BYEEQCneXL+GrPFK+7Z5PsHxQp8WMKO1+lVf8XgE+Na7bM7zEVnSnEu/Wt1XbtOxqitc+/wfz2A4NAMyexG/ARh3AAhNQoMGVCLx0no3G3f0zYyJipM6sCBrHczmAqSLfKG8biTcyap1LPic1/0AjtKPwrPhBoA9myBoqbJUtxt0KV7KjofcAx223djyqhwIDNHTPAm7YhpxE2bukr1+Md4Ix8bghecn3jFuHIcj67iUSxmcF+7vOcKNtMFju7CmOVABmovz9zD1JDvxzLzXMt+G8oYS52mvYNlwcEGs4VpyRRIkCaiMWiT9GbwqPf/glQmCo3ZZH5kZISQeejmUag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MW3PR11MB4764.namprd11.prod.outlook.com (2603:10b6:303:5a::16)
 by BN9PR11MB5417.namprd11.prod.outlook.com (2603:10b6:408:11e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Sat, 7 Jan
 2023 02:04:57 +0000
Received: from MW3PR11MB4764.namprd11.prod.outlook.com
 ([fe80::d585:716:9c72:fbab]) by MW3PR11MB4764.namprd11.prod.outlook.com
 ([fe80::d585:716:9c72:fbab%6]) with mapi id 15.20.5944.019; Sat, 7 Jan 2023
 02:04:57 +0000
Message-ID: <50dfdff7-81c7-ab40-a6c5-e5e73959b780@intel.com>
Date:   Fri, 6 Jan 2023 18:04:54 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH net-next 0/7] Remove three Sun net drivers
Content-Language: en-US
To:     John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
        <netdev@vger.kernel.org>
CC:     <linux-pci@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-mips@vger.kernel.org>, <linux-trace-kernel@vger.kernel.org>,
        <sparclinux@vger.kernel.org>, Leon Romanovsky <leon@kernel.org>
References: <20230106220020.1820147-1-anirudh.venkataramanan@intel.com>
 <800d35d9-4ced-052e-aebe-683f431356ae@physik.fu-berlin.de>
From:   Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
In-Reply-To: <800d35d9-4ced-052e-aebe-683f431356ae@physik.fu-berlin.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0100.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::15) To MW3PR11MB4764.namprd11.prod.outlook.com
 (2603:10b6:303:5a::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW3PR11MB4764:EE_|BN9PR11MB5417:EE_
X-MS-Office365-Filtering-Correlation-Id: cfc5b8c6-874c-4133-77b7-08daf0539399
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +V/036EctnGTgNiO5yKJtBhlpBBYwv5J8PeXEwIblKUD9iIVDh4eh8NvOwdK6eqV+04vEEye60nCWfaYxlO8qO+ze1qJ1ZzsSw2hAtuk8nErJG10vX9xgKka0zH4f1P5y7VzKEUT424pI4recNLPL+91ACoQ2lkxRwFo9i3P9R7tRGae434fA656c3jzCwanxDmLynSt9uNo3hvO0zEDcXtccSKR40kGQgP3TwVglYKfA0aHYENoIRRFFJeeCrlBWz510j5maw3+Q7xVM7pIDj9Np4IwAMTKl/cbXFh2PGB5o4aJJjTFyS4f7FIA5HWoOEQd344sBUDDfb4XWeilX7z35QmRDfKbSjUJzzOc6k6mInHI9ZYqQi9UhNikuDHVN4+ap/2uV3lKa2R8nlpYSf+kMWjYyBTtUirN+VIJkaAA4Ov0i39DX6d3FvKDDtY2xAv1bfHuxPDdsGAF+frmcEVBtbkuRHtvCJJ8t4CY3d/DO6zfyvI9MxFLcQ4Huj6acEsfc4rYFqbfqIJBDgvLP9zJL2LUaJYDf6zOGAtUJL236EIep1d45C+65Cn1qIsu/7ICwOd0RBQ3pCiZsR1CfzTXs6ZTnfbA5wH4zJY/pT8fTwnfDnaGkz2MiKAZ8Cy0SRLqHJnZIMvrd6sS7dL+CjTtEUCy2xJNmKlP4zHQ4CAXRddp20SqfjUrawtW+LxmSzXusnjBIxeEfd171cqedpTZ1IlNYlp5KXRonGqOiJo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR11MB4764.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(366004)(346002)(136003)(396003)(39860400002)(451199015)(2616005)(186003)(44832011)(83380400001)(26005)(6512007)(86362001)(31696002)(36756003)(38100700002)(82960400001)(478600001)(316002)(2906002)(66946007)(8676002)(41300700001)(4326008)(5660300002)(8936002)(6486002)(66556008)(6666004)(31686004)(66476007)(6506007)(53546011)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UXpRQUo4Vzg3bU9EUENLVGhlNUNOSHk3WjNqR2Z4SnZrcXp1VE11ak1FT3da?=
 =?utf-8?B?czVURkF4ZlUwQzNTRHFDUjFlV1hRTW5IOXhTTVJaakE4U1AvZVh3UFZKZDBE?=
 =?utf-8?B?YlVUbWpNUXY1dlhoeXEvNUR4K20xSU5ZMStrVnhXT0NJYTZGRGhBNzZudzVK?=
 =?utf-8?B?YkRjR3AyYVFGbHlvMGFva2pXdW9ISDFEVFZZbzJoNTJWaVhBcHVGVVNYdVYr?=
 =?utf-8?B?OFZPWXhObnNjRG9BdE1CMU00Y0JDQnJBd2lzc2FvOEhiemprU3dwQkxOOWRE?=
 =?utf-8?B?WjdsMDI4TVBQYVY0U3hwNjdtbFIvWk1kMThaUnh0cUtjckZUOEJRZHJpUEUv?=
 =?utf-8?B?Qy9IOThMRzNjNUtDSmUxOTZIMGxQcTNWVStGMDdTZ0NjSjg4Zk5sNHU2M1Ni?=
 =?utf-8?B?UFI2Q1NnbEY0VDVqbm01MTVDNURNSUptUTBhYWRJYUx4WTJBQnVDY0JLZXIx?=
 =?utf-8?B?UnVQbXhqbnFpaysxRGd5L0Y1NTZKRUwzM1lHNE1MZS9BTUh2VmUyaE55THBL?=
 =?utf-8?B?N0wzL2Z6WFphKzFDczhWZnczMmFhNkI5T0VuakdRcm9yVWZhZFpUbHFCWEZ6?=
 =?utf-8?B?aC9VOU5iNzkyMW5pVnVzbDBrSDVKNVYzd2pIN2pmbWJoWXh0MmdSQXdvczRV?=
 =?utf-8?B?aTVjWTdINTZUQzJZSENZb1dKUEJ0YTZrS3VEWDlOc3FCeGdacUc4RWVaOStL?=
 =?utf-8?B?N2Iwbkphb0FSbmx4dnFPNFd1NGN3NSs0TWR3Qk5sNndyTXk1anVPSlRoa0tO?=
 =?utf-8?B?SkdHWitmTktpUjBFM2c1SW5BRlNWSWdJdEFoNEZkRlFWOFc2dFJST3BGTWFt?=
 =?utf-8?B?UFZNZTBLSjkvMGV5TkVDNWlJaGRodXMzNW94UHJIL0NCQk82dUhKamMweW1r?=
 =?utf-8?B?MWJpRUtONFVPZjQrVUk1Z0Fvc1BaOXlrL1NXeDdHR0JYYjhSNkNVc0J6N1hy?=
 =?utf-8?B?TnA5Q2JCTlpTY1hDbFl1Q2FST3Y2SzF6YkM0NldnaE5rTUJQd0xlSUQyeGh2?=
 =?utf-8?B?eEFXbDhxR3E0Vi9aT2hBUHc5TzJPY2VoMUNUSk9VWUxWTURUdHR1MzhSMW1h?=
 =?utf-8?B?dld6YkZReTd4RDhZbHR2MmE4V2lXaFJtWEtsamhNOFB4TlVYdiswS2pMUndK?=
 =?utf-8?B?ckNCdGNOMEQ0ZUtDTm5QMmpOeXlrVjZCN1dzZjRzeVdvQlBoeFNJV0pDVDFW?=
 =?utf-8?B?a2FwV3BQV2FERVNSa0NHYTMyd0ZNZ2ZNUlZTUVBqbHE1SlhuM3pHYzFXTTRp?=
 =?utf-8?B?UW9XRFQ4T1MyWTdMUWFNOEp3MXhmVVV4Nkw4UHFZUTNWVXg1eG5Sd2luOTQ1?=
 =?utf-8?B?VTBCZXk2d0xqWGUzMmUxbUp1ZWY2eUpYM3pkVkI2UE9iSVBzVmZRcGNIaFRO?=
 =?utf-8?B?NFdKYjJsUXlnbzExTENoTlA0ay9xcHN4ZWVhbktZSkhVVGxtVmJtdVJBbncw?=
 =?utf-8?B?UGVmSllWK3Zldi93SW1mZTFYNzVjYUJCTFRhNEtmSXQyNzUrcnN0cjJWNGJl?=
 =?utf-8?B?SUVwS1RDVW93bUR1ci9WK0VGOVFQNE9Gc2Fxbi84U3F0NSt1WU9tTFRacEQ2?=
 =?utf-8?B?QnZFZ1g3c002MVh5bGdqZkg0YklHN1J0S3oxOFNCU3lWVm9WZklYR3pIWVFJ?=
 =?utf-8?B?S0VIMHpZTkJLSFB4S3pNaHA3YXlhbkh5elB4bGpYQUZwS3ViQ010dldlNGNz?=
 =?utf-8?B?U0dxWjZBUFlYYWxjbDE5RXlIaWZrWmZGWUdGUjdQVk8xcUI0cjlLYnhNMm1q?=
 =?utf-8?B?MFR5ZklTUnVReWI2dkVFTkFKenF6ZjJSU1FEamU3TitHOUhGU2xLTE1MODhQ?=
 =?utf-8?B?RUxEajArajVwUXFWRjdjTXBRYWZQT08vak1CRkdHZUN6dHM0a29td0ZES29V?=
 =?utf-8?B?OXVZMnNjdG42ZGozbUFWL2RLTHJZSXRGazNZY3dwQzZOM0UwaEY2SCtkcWpW?=
 =?utf-8?B?VExQdG5QQnVtQnBNRnhJdE0vWGxIVS8yZVo4L1F1U3EwbXFOMjY3cEwzWEJ1?=
 =?utf-8?B?U0xpTlBheXlqSXRMaEZtNlpVTXQwZHBUeEtUU0dJYVNNV1NpeVlRZW1wMGNa?=
 =?utf-8?B?dU00WGw0ejVIbTJvdWlmREFxSEw1RXdINDUrOUlkTmFIK1JsTVpvc0NGampt?=
 =?utf-8?B?TGx2Uk5UMVRsSHpidTFvc2dyMmZPOU1Qc0R1czBUM3dwd0NCTHhuaWs1NE9s?=
 =?utf-8?Q?rF42NIurx8d3y/eTNWD7xRA=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cfc5b8c6-874c-4133-77b7-08daf0539399
X-MS-Exchange-CrossTenant-AuthSource: MW3PR11MB4764.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2023 02:04:57.7950
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 05Cby3Lb9d/ST49gCgkVjdn8ADEMBTxEl85iENCfbXQLc3HFIFDp5Bj1CG3hSzvJcyRfROUjdWJ9J/6D7FLh6TBr+bRFTP9O+fjRB2Thgp5v8D7qYF5HYENLCh87u7wA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5417
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/6/2023 5:36 PM, John Paul Adrian Glaubitz wrote:
> Hello!
> 
> On 1/6/23 23:00, Anirudh Venkataramanan wrote:
>> This series removes the Sun Cassini, LDOM vswitch and sunvnet drivers.
> 
> This would affect a large number of Linux on SPARC users. Please don't!

Thanks for chiming in. Does your statement above apply to all 3 drivers?

> 
> We're still maintaining an active sparc64 port for Debian, see [1]. So
> does Gentoo [2].
> 
>> In a recent patch series that touched these drivers [1], it was suggested
>> that these drivers should be removed completely. git logs suggest that
>> there hasn't been any significant feature addition, improvement or fixes
>> to user-visible bugs in a while. A web search didn't indicate any recent
>> discussions or any evidence that there are users out there who care about
>> these drivers.
> 
> Well, these drivers just work and I don't see why there should be regular
> discussions about them or changes.

That's fair, but lack of discussion can also be signs of disuse, and 
that's really the hunch I was following up on. Given what you and Karl 
have said, I agree that we shouldn't remove these drivers. I'll stop 
pursuing this unless there are new arguments to the contrary.

Ani
