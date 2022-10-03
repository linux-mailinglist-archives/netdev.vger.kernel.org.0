Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D54B5F3535
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 20:04:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbiJCSEZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 14:04:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbiJCSEX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 14:04:23 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5101D27CCE
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 11:04:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664820262; x=1696356262;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=quO78FkAmCJRsBw1iXbpT9uFhOX2rUzCfjsOCkq06kY=;
  b=hSzTxuwb1eHEF8UtWt4XLoQUp9Plh30c5fX16eMfi3zPhyyf2bqYIRe9
   ofkydwyWRQNorlvz852OHAPS3XZ/c3JCxw2WqCws3kbZ23K69x3LWMYeg
   cAwp2nfKGpoFndycGYihQeWaIcInlw4wwPfTt2oE8/vqQuzs1JAT3t4+4
   q5k21Mj0AfsXzt41arkUz9Cv3daiCoS6RRkHvrhRfR/LvtFrl0p3pm8iu
   au/oyYdjhNnjHAB1uBgTF8roUUoFoLtUIJiLxCgRSXemlamTrHEXuV/ZP
   INxJ8RKbxfDzC8TbW+LfoKEP5X9pepLY+p9qP/uqbiq74xFm/Q7nrhbcq
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10489"; a="389006985"
X-IronPort-AV: E=Sophos;i="5.93,366,1654585200"; 
   d="scan'208";a="389006985"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2022 11:04:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10489"; a="766029967"
X-IronPort-AV: E=Sophos;i="5.93,366,1654585200"; 
   d="scan'208";a="766029967"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga001.fm.intel.com with ESMTP; 03 Oct 2022 11:04:16 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 3 Oct 2022 11:04:16 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 3 Oct 2022 11:04:15 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Mon, 3 Oct 2022 11:04:15 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 3 Oct 2022 11:04:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bx2MUyWMlWGxZjWmZxQWrC7fZU26xjowQXlps/UiS8+Mk+X626kLSocSFFerOPhy5gfrTpTV2xtNn0OOdTXy5W2kSlz/MDdZFa2OKS10xmkm/X+3hCzyDPSTBK9Qbe94CPX4PfmmwVtwHhYoPt1Quy6e7ppNRe0MsRhb2NdZbL24F6MDSeeN/Pf/F4FlfcSR0eJGm4OJ+F+YQmEahQ317Hp2rEc8EKqHvfbzBmaj+kQlYgslcmlC5neBp91cJUicQJlYI8ZdfpcyvVzvexL8AI2EM9iGkMN3YpJ9uALxuH29fpTFDQbJnJMo2aBcxm5w4Ng3NvlkLzVO58QAoVn1hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YpDOu5ndcRIr03qIrKNtj+zZTA3iqXAqI1Uucfxhn10=;
 b=gimhr6jv6jkrjYmvltrq6l0QFljcehurG8oo3DbzN2uauZAVvQOzEiaMiCcF8WZwzfbEzp0tVYkzFiN0hy3JGDS0QAFZcIAb15trBhZ9ueT6zq05GMMHCVR+UztcJmUXu3w5s5xIkIsHQ+ZvWFtoJIGr8LE5XZ/BMn200vycO0o7/A2bj8Oh106WEQ3xyT5OvXjjfMDKVtK4uCCQLzIYcLOKFMcIRE5Ro6V8dKP7IMhK3/HrVs21zNznwnFiE/czW4Fh+N/mFaeCu/XMr1oviLoK/siyQDjYI+3V8f2i0Lo8rgLcvt95n6q4C/Ucr6TsRjquxSd/sKW+aSqXrjExFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by PH7PR11MB5960.namprd11.prod.outlook.com (2603:10b6:510:1e3::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.17; Mon, 3 Oct
 2022 18:04:13 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::47f1:9875:725a:9150]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::47f1:9875:725a:9150%8]) with mapi id 15.20.5676.030; Mon, 3 Oct 2022
 18:04:13 +0000
Message-ID: <4ac5e807-c07b-ddbd-6ec9-839e80c808e9@intel.com>
Date:   Mon, 3 Oct 2022 11:04:08 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.13.1
Subject: Re: PHY firmware update method
Content-Language: en-US
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Andrew Lunn <andrew@lunn.ch>, Jiri Pirko <jiri@resnulli.us>,
        Michael Walle <michael@walle.cc>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        <netdev@vger.kernel.org>
References: <bf53b9b3660f992d53fe8d68ea29124a@walle.cc>
 <YzQ96z73MneBIfvZ@lunn.ch> <YzVDZ4qrBnANEUpm@nanopsycho>
 <YzWPXcf8kXrd73PC@lunn.ch> <20220929071209.77b9d6ce@kernel.org>
 <YzWxV/eqD2UF8GHt@lunn.ch> <Yzan3ZgAw3ImHfeK@nanopsycho>
 <Yzbi335GQGbGLL4k@lunn.ch> <20220930074546.0873af1d@kernel.org>
 <YzrTKwR/bEPJOs1P@shell.armlinux.org.uk>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <YzrTKwR/bEPJOs1P@shell.armlinux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0018.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::23) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|PH7PR11MB5960:EE_
X-MS-Office365-Filtering-Correlation-Id: 00ce890e-c4ab-44a3-f1f3-08daa569adf0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MwqiJqUPfGjCKQ2EtUtH70TOqDQ5PGuV+aS0KJu1CjNUp5pXTD2if5EIfbeRl8l/Wllc1jt2mHArr6TzTcpbKrgf50Xe5kDBt+JSnOBElS9LvpCgfvPYjX2LlUkGuTVITALRgJ2+1ifYxtZZE63cWJHk+2whJJuWmBxTCM7Y8YqAP/y8Xy8deu1lUXDyQy7O4rguj7K8zvglf//SslU0MeEGdeRVp+xpcWnt24yUDVi2q9GEGp7jMxHFBycoBua6/Hqjk3/ufmNmUxLjzsEbVYzlDjr3YiKP/ZafS3pBwf2gDcz9MJiRgMrHgz0+8xX6gSgoU04GQrx8zU5BG+HIS+rSpXWZuSy81+dgbm/jnhT9Eu0B6k9nupzNpxbOD0doFZ109R+HBIHiK+yRk+27Bl1Nex5a5oaPqqizgqi2QiVBC3t6hIlo4vxmKsE+dktPViZQUw0Ta3XJO8mXf2v//YTNeGFnb6sC6FcCJLDwb6RjqhJ+3bml9TOWaV/6cSZmaB1Zr70xw+/es2jOtEWsJopslP+ZDqmYNx+bOpWeXFDx95s3uqWMFisOX00CGC4VekV1lM8KbYS9cAJm1y+urjNlKwP6rl9wxDYFrASnRFmQZ3j+leH4NWn1Q8+XJOcd4SWt0ZTGqs9lOTJ5GGc6exqjcEz3yRJGldLgxFfLBsv/p+YqyJPqU/qp+HsNwfZTBChm34D9ASnFX0/Tx65jBGkvWVOew2rKa6Thubmye9RTUC26c7bZiSBIejGhWJeRwqOrrDfSQOO1s5joNE8QiRcDrT+mqrv7WEeeMKgP9Uk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(39860400002)(376002)(396003)(366004)(346002)(451199015)(31686004)(82960400001)(3480700007)(38100700002)(66946007)(316002)(478600001)(6666004)(41300700001)(53546011)(2906002)(54906003)(6506007)(15650500001)(110136005)(36756003)(83380400001)(8936002)(5660300002)(6512007)(186003)(31696002)(6486002)(2616005)(26005)(8676002)(66476007)(86362001)(66556008)(4326008)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UTdxelBUQlBTNVZUbEJpYlR2alZrNy92SXlXU2lXa3VMbGJOZW9NNDI2QzNX?=
 =?utf-8?B?QXQ3VUR0ZzJCMjNySUwyQTlPUEdFVHdEZEhCOFgyeXZYazJMdE5Lbmxob3RT?=
 =?utf-8?B?a05KUzVlUGliY1JTRnoxYld6Q08vQ3h5dFpQYW10bzUyRFF4WDk5VW16TDE1?=
 =?utf-8?B?MFdkZnlhRGV4OHdDZGxDdmo3MFIwd0ZoMUl2dHpvY25mWnBIUlBYQlR4RGdz?=
 =?utf-8?B?MWlxRk04bkdsaGJVMkltZEM3MjlaKzJhUmdIczYrOW5ITjcyb25ZOXM0YVh2?=
 =?utf-8?B?QmU0U0gvTVRDajVZUXN4RVhOUHNhb2N2NmFmWUdSYkFyTDFvcUVpQWl1dVBM?=
 =?utf-8?B?TVpHUGdSYjdXU2hQYjRtYVcyNjBmWnpOd2F5dGpMbFBwa0dJK3VCNCszSDh0?=
 =?utf-8?B?bzhyTnVDS3Zsdkx2aWdVUUZIZVhGR3ZYbm11UTNSdjZiS1ZyL214dlJMSHRH?=
 =?utf-8?B?YzVGNGxnU3I4R3RNaStKWlBIQmYzUFdza21KZkxpcUEwemV4YUI5dFFOMWxE?=
 =?utf-8?B?dlpiaUZJcVdCeE1pbnZzcDkzYThCQ204Z0RUK04xei9VaWZtRGVBenppSGpa?=
 =?utf-8?B?SHNVdXJCRWVzQkZUNHk3ZlIydjJLYUVHeVgzSXlzMTF5MlRKQ3ltMWc3Wk5q?=
 =?utf-8?B?aXZjOWpxUFJmZFZZMGZ6SzFrbTdGR1V4cFc2QytTNTl1ODd5dHJQRnJPejlP?=
 =?utf-8?B?dEdQWkFiYVhuMnZsc1puR1RaVEU4NExrckJ3OVBsTDhTQmlZeFQwM0R2U1ZH?=
 =?utf-8?B?T0VmM1BRN1ZnWCtrR0VWM1VwUW9SMnQySUZ5b2c0VkIwelo2K1dWVkNzbTBU?=
 =?utf-8?B?NDJzbTJMUWhXVDhLcEcyNTFJWHczS3JsYUExejlFdys1US9IQVdVUW54ZWxK?=
 =?utf-8?B?TVhTcG9uNkFMdjlzZS83VHNLdzhxcFc3ekxxaVBub2xGeFVUVGlyUDBmdHg2?=
 =?utf-8?B?Z1ZRNTlIWlFuZkZJcXJQS0VqVFdidlA3UEVUL0kxcy8zY29mcURTbFRBQ3By?=
 =?utf-8?B?NEFGckQxV2ZXUWxka296ZUI0TU5JY2lEWWVRbTROZ1VTMmZOVXg2dnZ4YVFN?=
 =?utf-8?B?QmJuYnZyQXNYaWx6Y1hvaUpwaHBWank5K3dGQ1hoRk1Lam9JTlpQUUhOVU1w?=
 =?utf-8?B?QUxJZ0d0elU1RDViQlphdnhwT2wyMnVYaGhhOUZzaTFESTZPK1dtU2E1Rm9H?=
 =?utf-8?B?OUlISzhPYmZha2hPdHZtOE1TSlBjUXFoMmFEMS9JMGZ2Sis5VlVSUm1uZFBr?=
 =?utf-8?B?azJHcXhNaFBmbWFMUkIrQ0YzQ1IzZlh0dlRuY3QrMDFXTTVpOEp4NzBER3Fp?=
 =?utf-8?B?amRXWkJYazFkYU4xZmhkS1UvU1BMTE1UYXBRbVplUXFubzFSc1NpMUJ0VHAw?=
 =?utf-8?B?NFo5QTBSdWVYY0VHeUZ5SXZiWmpkdEtjWk5ZR3U3Y1k0VGpLVHZrajZzdUxp?=
 =?utf-8?B?bCtiSWJmRXNHWFpJNTRYYmY5cjN0aDdBUkZmRkhCYkpsa21VTHIxSERzWXA3?=
 =?utf-8?B?ZmlWWXZEUVc2b20raWp1NCs5MHdvSWJYZVZLQzk3aTdnMGw4QWZHSEV4TzR1?=
 =?utf-8?B?cFR0QnZISVI4K0dwZ0xPaVNUM3VmSlRpbE9iN1VTTVJnVkpWcmVXTm5IUThZ?=
 =?utf-8?B?RDMzdFptaWVmWnRNdEFoc1dRTVVSdmFnSUNYcGwrT0lSeHNhclZUeVp1SEta?=
 =?utf-8?B?SEtvYXhsaDlTWGZIUC83RWZ1ZldPenlJelM5MDNrd2tYRFd4VHgxS1lnOGt2?=
 =?utf-8?B?UnMwSk4vYko5aVZkYU00a0prMGZ6RlJNTjBGcW5VaStYZTRHNEEzQm5NNmlE?=
 =?utf-8?B?RWw2ZFFOMFBKT3Z4RHB0T0NKYkt1QmJRK3p3V2c5VTBOeXp2S3cwOXFiREVt?=
 =?utf-8?B?eTNuWG14U0RYeHI5V2t4eXhNVXdjTGdUOWNMMnFaQmhvU005bmh0Mkl1US9I?=
 =?utf-8?B?MlFVZkxKTnRXcWZPdG9hQVFuY3FtL3k4V0RnYUh3aXlOOFVWdWZtNi9HeU9i?=
 =?utf-8?B?S3h1ekN6TVhMRDVmMGlXWE8rUU50TFBoTVZWUmtDdFZaRW8xcWs2dEhLSE5T?=
 =?utf-8?B?UWVOdWNIdFZSanRyeDl6ZUVMNHh4OHFHeHVHcUx1QVZjTDNWWWdFTTh1dmpm?=
 =?utf-8?B?SnZMYmVCY29VS2xsTEFqaVZENjNkeUU0SW9UbGpNRGQxTjJCN2VFbXRpbUR5?=
 =?utf-8?B?Qnc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 00ce890e-c4ab-44a3-f1f3-08daa569adf0
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2022 18:04:13.5838
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pKNeWUFPhdvKGv2mn3DYjyCPfl8gnIti2c9w18Va3DHugVFDFQEC1j/kYCE4170FCDH1UwBSJ3NgRQ+ZOyG1892xtgpMGnJ7LPfx+cnhxE0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5960
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/3/2022 5:18 AM, Russell King (Oracle) wrote:
> On Fri, Sep 30, 2022 at 07:45:46AM -0700, Jakub Kicinski wrote:
>> Actually maybe there's something in DMTF, does PLDM have standard image
>> format? Adding Jake. Not sure if PHYs would use it tho :S 
> 
> DMTF? PLDM?
> 

Jakub already linked to the standard we were referring to, but for
clarification:

DMTF refers to the group which was the Distributed Management Task
Force, and describes themselves as:

DMTF (formerly known as the Distributed Management Task Force) creates
open manageability standards spanning diverse emerging and traditional
IT infrastructures including cloud, virtualization, network, servers and
storage. Member companies and alliance partners worldwide collaborate on
standards to improve the interoperable management of information
technologies.

PLDM refers to "PLDM - Platform Level Data Model Including Firmware
Update, Redfish Device Enablement (RDE)"

The "PLDM for Firmware Update" is a standard which describes a file
format and associated specifications for how to interpret that file when
performing an update.

I implemented lib/pldmfw.c which is use in the ice driver as a way to
read the binary file to extract information about where each component
of firmware is in the binary, which could then be written to the device
to perform an update.
