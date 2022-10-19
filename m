Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24D2A6051D7
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 23:20:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229463AbiJSVUb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 17:20:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229803AbiJSVU3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 17:20:29 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1438144E2B
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 14:20:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666214423; x=1697750423;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=b1LGzjvwcvAhd/fgzULCEwR31z6IRP0/3SUcL3uehZM=;
  b=iIkMUtqxTqmo9dUMPPgvoG0M29TXixvimQDXeVWw96wnb1EkTuw7kI4A
   dbVlZ61NRWhziShicarlmh5dhfx6QcKFnstkJSdDnJYeSzKS16vxdvk7R
   gmhVvF0hpCEIZBmCw8uV7uil0KperVbGznxSgnS1Srw0qJ97lFz3V9o9h
   /1SkZjbRUwMqeB8U5AexOp28Je3y5njuM+EDVKL8fgnuwJ6zt4kN7Q5EJ
   fToF+fK1qHeVPbGQFrs1HXbV8b0cfG/AUwycAk31w5PiZfFOB4MyxSbvQ
   NYiKFXT1p06Tb4D17y7wFk3LtEPgW2ufQBVJxnHePYmFOwdK6uwtUhRIg
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10505"; a="286925732"
X-IronPort-AV: E=Sophos;i="5.95,196,1661842800"; 
   d="scan'208";a="286925732"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2022 14:20:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10505"; a="718675297"
X-IronPort-AV: E=Sophos;i="5.95,196,1661842800"; 
   d="scan'208";a="718675297"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by FMSMGA003.fm.intel.com with ESMTP; 19 Oct 2022 14:20:10 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 19 Oct 2022 14:20:10 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 19 Oct 2022 14:20:09 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 19 Oct 2022 14:20:09 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.172)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 19 Oct 2022 14:20:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ElW85qVvndWNL3MJW5lIEAsKaRYA1Huo9HoP0Aev5n4X3JDUHMNSoqLNJli7cdjbCARTmPK3+OOIPaJG0Cfv9yAUWDz7YyJfsBfurSgzbiSKb7YLqGuk/YhYMxNrwpigepQ+RUV6C19Kkgb/SAvKEGM12A0HHTsUkLRAGg4r45b2nAxQCcpgxW8R9MCYYV3MpEx0IlTEFQq3QTK/rpTlJroMtUOWIpq17OKjbj/wkBqyCWnD69oa8Pj2TuWsvz8vZCJPrq4rg2QpSBSKvCMCz0QVk48XWPd6d/wOzhbOR9cutNLeAMOB+u1JdJP1LJP1cBbZYiJ9K0i3o1WIzCy/Hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NjdyYVMcFwqvnzxlav0RCwQWR6XA3FSmWKVaLkWRid4=;
 b=Qh+USxTCG1+lU6sxlEBaW8qthS+aTYYhtnIBF7G83PewTWl/J0/y4CFh2XLYM/GXQ8x675MnBBro4KTR8x+S/13oiNEfXikPejHK7hTrhiYzHo5AG1ySSYENnRwrr69wbTph2ZFN//Azy71bXoqGk2NrRLuF6ZXOQRUBVsDSnb8l2V76Mtcs6qq0a/sTtitDvjxJ5GF6KmvXj94R/AUhOYVvw1unaJxJhLO6kll7MJuLph26/qm0XIJF3KhP7ZnE3qn+agG5qvqEe7UOta+XfRG+pLleBDQFPF6L0xC1PkXlp8+VspxDFVwy9bQywHEkhTf8KyRgziDk63MAGkqH5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by CO1PR11MB4916.namprd11.prod.outlook.com (2603:10b6:303:9c::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.34; Wed, 19 Oct
 2022 21:20:07 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::e314:2938:1e97:8cbf]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::e314:2938:1e97:8cbf%7]) with mapi id 15.20.5723.033; Wed, 19 Oct 2022
 21:20:07 +0000
Message-ID: <d29c7980-7a7e-3a75-3e54-ce081ffdb8cd@intel.com>
Date:   Wed, 19 Oct 2022 14:20:00 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.13.1
Subject: Re: [PATCH net-next 01/13] genetlink: refactor the cmd <> policy
 mapping dump
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <edumazet@google.com>, <pabeni@redhat.com>, <jiri@resnulli.us>,
        <razor@blackwall.org>, <nicolas.dichtel@6wind.com>,
        <gnault@redhat.com>, <fw@strlen.de>
References: <20221018230728.1039524-1-kuba@kernel.org>
 <20221018230728.1039524-2-kuba@kernel.org>
 <68eaa8749d8ad971b34cce82f4306e77ccccbf3a.camel@sipsolutions.net>
 <20221019085911.78c61724@kernel.org>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20221019085911.78c61724@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0111.namprd05.prod.outlook.com
 (2603:10b6:a03:334::26) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|CO1PR11MB4916:EE_
X-MS-Office365-Filtering-Correlation-Id: 18eafb90-6b0c-4c79-c5bd-08dab217b23e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VVUW0/qvDDbGbcvZEsJs9YcXqszjrNVW9qfjSZZrG1XPo+xMOaRrCd6MhnA1nPZCq04nyy55am4wBJLESyFnb6Etf8Mx+va/J4Quw3kTg6vFBY49EhoThECZv9YYLo8F3wV5NPRzMqitmgmQzJmsl+yL4OUouCnmDivtSs6Fx+jdI/Vy1Dk0X5gdtKF3vqGfQoglp0TpFey3xdIh+S2PMRXYVE4oOpuvSt0Jd84KbU1uJkPmGPgtzU52vKIhVy2cPp3GK50h3iVHxvU0Ww7RBDYYQWWcdeVEUS7C/vzWYl8GVP8ptN+Zp+UW339l26kWA29cKg1VCtsjpat+mPZmGvtapHfkbFjPdX+OUc7uklNMqzsTAcVM3oniLSh2RDFxxKPVVA0B5SgykAkqf8q8AsUTtvIYeKak/+r8oRVz31JYatnd8jwJe1HxuzfQr+2cUo5JGnQzsvqQgWDdEkyMyAkJq2h6oCv2lWs+8+8LA7m1JLNrCforNtOMMPuvNc69EESE11PMCOlcMgLL5rwHsww0UFvy4IniMdIUGUGAbyyW81J4zS6vwilq0WSDayxOC5rp6BgSnmdk6d3pyq5KNRE844RKgq/SJU14+H8dMqAYyAAl5jFsDeFTO/b9ZutIrz6K9nC0kPaviZ3m+kZNqSWN0PJm9SGoxF6GVZ3kEkkdbB+znZrl8jSZ5N7JBk9ffKk3HL9ttvHjUOHdrHKAW5gfURDPUnbG+eLSOnzR4SSSdfLv1FHxw/ha3zPXInYaXOSsj5dWURswW+N9+TVLGU0MfDJbnZoADOgiEe72HRQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(136003)(396003)(39860400002)(376002)(366004)(451199015)(31686004)(478600001)(86362001)(31696002)(6486002)(36756003)(66476007)(66556008)(53546011)(6666004)(8676002)(6506007)(316002)(41300700001)(26005)(6512007)(8936002)(110136005)(4326008)(4744005)(7416002)(5660300002)(2616005)(2906002)(186003)(66946007)(82960400001)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UWR0WDR1WXFjR1MxT2ZTN21tenM0U0VYWCtZc1NHWXlYZmFtdnJwSUl6VE1q?=
 =?utf-8?B?d0YvMG83VEk0MFdOdVpXTFJnNXZNazNPZkNBejZtdWMrSUZnRzZXV3drcERp?=
 =?utf-8?B?YTdPY2QzOTl1QytJTjBwcTJ0Q2ovUnp1QlI4OFZKQ3p2ZEN0ZXNoS3JvSU53?=
 =?utf-8?B?VngySU1oc0F1NUUyZUdldXNzNktudXIwQ1Z3Z3dPS211RXJvZXFiQ1VnTk52?=
 =?utf-8?B?Mi9uM0pTVkZYUEdRdjlRVi9kcG1uS04rdHNJcnZJN2F2UVg0b2dOT3A3VmMy?=
 =?utf-8?B?aXdxb1V1c0VNYVJubW8vQTFpTVQzeUtnN25Wek4vdnJodmtFb001K0F2bmxO?=
 =?utf-8?B?ckUvREQ3VTlGYmM5UzlMOHpIRkw4Z2dtOERJY1VZQ0VTMVRLRHZxSTRUc0FC?=
 =?utf-8?B?dURZejJyYmwvdENlWjRxWXVOaENOd2liSHNYbWZKdHFCKzFxMWhZQWRSZUpN?=
 =?utf-8?B?a1QzSWQydk5OcGpxTmtzODkrd2RyWkRJYlB4NzA2WlFaaGVMcVQxYTlpdmJ5?=
 =?utf-8?B?aGltN1NuVmF4bFI1ZHo3a3JlQ0R3NUtxZUw4enNRQ1dkODRKWVlCTnZVVDBr?=
 =?utf-8?B?L2RlZG5kY2lmWEhoOVpYRkNONGZGMXRrT0w2U1ZIck9vNmduTlVHQUN5ZUJt?=
 =?utf-8?B?RDhVNlU5bXhuc1BrbVdWSjdBMVdqMlB4V3AyeGJDNVBNV1hHN1NhZVVWSExD?=
 =?utf-8?B?T3lQdDNOZWpGL3NWOFhkREZxQ1hrUGhIbXdObWwyQXI5Yk1sZ0xMK2RjMEJz?=
 =?utf-8?B?a0p1aXdnajVsKzlyS0dFZjhZY3ZGeFZuZTRZMjdFZ2xOSFZ2VzlJUHVXQlVK?=
 =?utf-8?B?Zk5xbW1VcFBQN1NWVkM4c0UwYk4vWEN0RFdtdG1JTkJuU1ZhZ01FV0EzUUhx?=
 =?utf-8?B?SFRlYUVMaWpTVVlVeFgwYW5DbzEyRnBqR29ISjMvVTJwdFkramwzYWxPZG1o?=
 =?utf-8?B?Z3FUU3MzUzYzSHJUSHlaQkVBN2lvTXQ5M0NsTTVETDlPOG56cDVkSThPcnow?=
 =?utf-8?B?MmdwMVJRY2xGSXJSSkhCMElxS2tUeWhKQ3FndW1FaUhjSXQrN2gzZ2FxK3VQ?=
 =?utf-8?B?SXBFOVM2STVYclBTcmEvSFIyQnRYZGFqdzlUY1RiVFBpbVUwQUxEOFhuSFcy?=
 =?utf-8?B?Sy8zYkx0a2JSclR4L0g0ZVBTYUpIb3l0YVUzQVZDcEE5MWZQSlZwRGZkSmZ4?=
 =?utf-8?B?ZExBb2lHTFVxeGdveFgrOEZibkN3SzNHamlZL0hVSU8yV3BLVWg2bDBseTJI?=
 =?utf-8?B?RElSalhlSzQvTkNwazY2NVJsdk1Xbmk0NFhhYTU4VHFqSWZ1NTJXaDlQVU5D?=
 =?utf-8?B?ZmNTeTFRZ01nOFZSbUQvS09PZHVYTkFFNVl5eHJUUDJTT1VHREFNRlFQbWVY?=
 =?utf-8?B?OENUaHVXazAyeUpUSFdsemhzRnV4YS9TK1ZIWkplZ2RsZm12eGdPQVNDL254?=
 =?utf-8?B?ZkNFaDhKRUw5KzdaOVQzYzUwNExMZ3NhWkQ2ZnBqZUJZZldyQjdvZHZZendr?=
 =?utf-8?B?cytvRTIrQ3JsaFAwNyswajdSMmxqeGxlN20rWGkwaHpkdDlBVU04VGFSWVY5?=
 =?utf-8?B?WDVKaDU3SmJSd1QzenVJL0ljSU53a3VpSzh0SnNRbXVXdmc1UXB0d1lhc1Bn?=
 =?utf-8?B?ZzRUZW1zMUJ3b0wxK2tsL2RVWVZ2M0lMNmRYOVBiZUFZa2g1ZStpdGhhaXBr?=
 =?utf-8?B?YzFUYlkvR1lEZFN6Z1pzM1JWUWZWckw2TXpNdG9WNjNLa0ZWbVJUc1lhdnRX?=
 =?utf-8?B?cmlkOEEzU05KOHR6L1lMR0RhTndLeEJZeXJkUE5mM1Z4TCtNOVIvbUdmNnU0?=
 =?utf-8?B?dDdBZ2JaTXUwb01tQktLNXlyOU0wYkNwTGJVYWF2VGVkSVhCRC9wc3JOTFEw?=
 =?utf-8?B?RUNGcGU0YzQzQmpBOEZLRHFPaHE3Rk1zQ003ZjRMSjFvWFZFdnR4bHNNK01k?=
 =?utf-8?B?MVc1dVNXa2NGNFVPZ0J2ck1XMkpvQXIzeHFUSjZBVXZWRUhSYktNMUtzaVNv?=
 =?utf-8?B?aWt4VGZ3OG1VL21Ia0ZwQ1gvdWljZnRML3d1TStSUy83L1YyWlhpS3RDVG53?=
 =?utf-8?B?aTlKTVRsTnkwQTEyMFVjL0NwdmphbWlIRzVFTFJJL0ZsakNaQ2FONFhPTUVC?=
 =?utf-8?B?dkZEYldOK21EV3JyQXFudE5DSTkyS0M1NEV4YUxETzlvTDhLOHp5NktMeTRj?=
 =?utf-8?B?dWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 18eafb90-6b0c-4c79-c5bd-08dab217b23e
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2022 21:20:07.1577
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5BO2423UTZ2mpxgPk83Mv5ORo2jmmPBsM5z/qKlVvB0qOelzdc1VTC30KTgZi3/FlITCufPp3kBeUIVok+BSVT3iDys4f13UxnGTGRZv9m8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4916
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/19/2022 8:59 AM, Jakub Kicinski wrote:
> On Wed, 19 Oct 2022 09:50:16 +0200 Johannes Berg wrote:
>>> +			if (ctrl_dumppolicy_put_op(skb, cb, &op))
>>> +				return skb->len;
>>> +
>>> +			ctx->opidx = genl_get_cmd_cnt(ctx->rt);  
>>
>> This (now without a comment that you removed rather than changed), still
>> strikes me as odd.
>>
>> I guess if we add a comment /* don't enter the loop below */ that'd be
>> nicer, but I feel maybe putting the loop into the else instead would be
>> nicer?
> 
> The comment got eaten in rebases, it comes back in patch 10 apparently..
> I'll put it back in v2.

Thanks, I had the same confusion when reviewing.

-Jake
