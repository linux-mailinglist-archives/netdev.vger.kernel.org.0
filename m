Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEF3C6B0960
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 14:36:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231349AbjCHNg2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 08:36:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231518AbjCHNf5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 08:35:57 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82A7E22033;
        Wed,  8 Mar 2023 05:34:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678282465; x=1709818465;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=HatTWrrHt3K/oWCByU3gjtazbJHVWQK712JIU9vPotg=;
  b=hLtf3ZZ37GE3YdYMXbORm6Mc67mc1YWVKvYCwAxsEVX6TL+kpKeBFGQ4
   rjU/k2HpkEZSFNWdA+KuCZDVca7ArdheJQV6UebJL4QigGvvDzfqFk8tt
   KK9hbeGZidiRVSwnfd1+0m+gsqnTC9pFPKyb5W99sdVwbK21ZfmCVIry0
   H150Nv858vVAl3ndXaT4ge8N4eT6BlfCkMoMx+jjs8YLYq/uc8+k5H/X7
   uZqj/060EJta/vTCR7ianmTTz44BJFSYTTRp+3ey2MmiJWzI7w3zS6Zxf
   UMVNnOQikhyXblflQsB1/pa0QhnImyjfAcBmbJzBnspBeRAouZT7B2y5p
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10642"; a="334863385"
X-IronPort-AV: E=Sophos;i="5.98,244,1673942400"; 
   d="scan'208";a="334863385"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2023 05:33:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10642"; a="676971421"
X-IronPort-AV: E=Sophos;i="5.98,244,1673942400"; 
   d="scan'208";a="676971421"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga002.jf.intel.com with ESMTP; 08 Mar 2023 05:33:44 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 8 Mar 2023 05:33:43 -0800
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 8 Mar 2023 05:33:43 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 8 Mar 2023 05:33:43 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.175)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 8 Mar 2023 05:33:40 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nATo8OwRlz2gLZIQxRTdcmq22OnnGrQTmXjTYtMnT7MTK7t7xglkL5k/txETm9UzltAnJH9dIm1CODQG0FXc0wrD7CXLlY9n321aW+muVImL52QPucZvQw4YqcC8iX2QL+FUJSLdpu88nzjchtn+W7hPyulSu34972TiHHrmKRWGqsE5YnYMYr/4ebiHjoOAmdbJxdDVxA4Eju3faZ+EbE8FZucJ7TCNZ4/uQtkqoxrO2Ade3Nti5AUeXTaJiKTq2ypDg/SHYQSe40fpo3rr07pEFZ1YLICmVsJcwrPmPdRomJLwCgIResoBEYgP38Pmxa4VcmqqK6b4IsFctxXW5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=950xfyB59QUFi32n+3+j9Mv4VADM6c8fCe8ujO7TTtk=;
 b=S5kbtjUTYvnxhakHHtTjdC4jUYDlI1v52OjBA5a0TuAhl0rzzBe3JBFvx+pa80GT5HL+jtEWbHusTswhuZ8TRPcGf4CituKyCyyxVhNO0xUVDNus0U9H2YDgPqZnlk6NcZVxpQBKdCoEKAjYNWeHh/jQ1bBtEQZ7veGvVyymOGuC6jVvCEOcqUgXK47DO2ZSs9og6fQuGn5RBbOarjGmmBJJ4Zf6fKETIaP3khXVaKf5h56IF2hnN2Xn1XicVlIJ4zhR4YaS0/Vv7PGv2E1Vlxv+hRXb2cB5wp5ZG1pqKIm5Wa/1bDbs+9irrR3Z3WF/IrIpzJ4cNVg1fYupRV0uBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by PH7PR11MB7097.namprd11.prod.outlook.com (2603:10b6:510:20c::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.17; Wed, 8 Mar
 2023 13:33:38 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::7911:de29:ded:224]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::7911:de29:ded:224%5]) with mapi id 15.20.6178.017; Wed, 8 Mar 2023
 13:33:38 +0000
Message-ID: <968526f7-d262-b69e-ca72-f56078158000@intel.com>
Date:   Wed, 8 Mar 2023 14:32:40 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH] xsk: Add missing overflow check in xdp_umem_reg
To:     Kal Cutter Conley <kal.conley@dectris.com>
CC:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Alexei Starovoitov" <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20230307172306.786657-1-kal.conley@dectris.com>
 <ee0aa756-4a9c-1d7a-4179-78024e41d37e@intel.com>
 <CAHApi-kcvc2qB0D6dV7OG99FsnzAEa-rchOMfySkZ-E=EOh_4w@mail.gmail.com>
Content-Language: en-US
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <CAHApi-kcvc2qB0D6dV7OG99FsnzAEa-rchOMfySkZ-E=EOh_4w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0061.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:4b::9) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|PH7PR11MB7097:EE_
X-MS-Office365-Filtering-Correlation-Id: 46e36df1-a0b4-46d2-bd63-08db1fd9b96f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xyNAhr5uj2nPgpjkRLLqBalz/2eqM4gu+0UhPCBCXZYHJ/rFe/WST+E/Tul4rv6vwJlSOM9kZ8OubehsfKnDSnT+NT42n8UBqeoM4drNhCu3EhV7BdxGagEE7bMlcwne2NAXefkquTKLe80lNdIpEtlDtR67AcQipdDtLLKCC8XOJkD6HHPWX/ZlklHg11sC8GPBjjQujQ0ZC5nYYs6osWHP/rLjpJCOEE3YuJpphyYZUKaBqY3pqKksBmGzSe+qLUPYNAyVROI5iq7gqfN3GpR852104b8JbCiDz4/YL3CL15rw/HUCC4Vp5HLKQgbnCxNlRC5CJGeo2pOpUrGDt1M/jpo4+nBEGXEcE49+E9dbrGVaZft4wfHd2W2d2IEGAANAhg0IAeJjevkGaKo7/yzt9mFeP3CrtLqyz5uA4NGlVGHumlvX5OW/7TI+3EPzLG3eapBHutGwoOXK5g+sD2Mulf/Pr6YcjnuYgkUM3+FnGdbPvdWd0hfldCunZ+D+oq3h0w+9A9fuYONQlFLlVPLMI25dNlneJcNAfVkKvrlDqoGeTVA2RXPU0rbGkE28rDkjOt0ZZZHOJVViD+QijudgLEdAQkbhZmj7lvldyJVRogBG6rcZapntS4vWtuBV7EWcb4l/z6Vk3pafZ6SwoZjDnTwD+jFCA6gwHrCFLi/tuCsinSZmyNrNrMm2JmEczbcR5ROAfnVmi2LmQo44RF54qswwWvkTWlF76INi6Hw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(346002)(366004)(396003)(136003)(39860400002)(451199018)(36756003)(6666004)(6486002)(38100700002)(82960400001)(26005)(2616005)(6506007)(83380400001)(186003)(41300700001)(66556008)(8676002)(4326008)(66476007)(6916009)(2906002)(66946007)(8936002)(5660300002)(7416002)(54906003)(316002)(478600001)(86362001)(31696002)(6512007)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WE9mYUJrZFE0bm9Fd0NRSU42Sm1mcXBSRHYyUzBNL0RZL2J6VTRxQ281RVBh?=
 =?utf-8?B?aEdpQUhzWkNnZ2ppeDZ4OUwxc05URm1ibk5LNUYvZ2c1QkFDRkFGNDMzNzFq?=
 =?utf-8?B?eU9LYVJYS2N5ODNKZ2FGd3VJeHQ4dXpOMllrOXo2VHZJcE11WFB5ZitQbFZG?=
 =?utf-8?B?OEFFWWRaNFZVS3RVdTFyZCtVbkpXQjU4ckx0YWF0TjlkQXZvOWl0WjR4K25v?=
 =?utf-8?B?T3BidnNkcTJUSVdZZ3pJWXJmQjFlaDNJQjhaZG9Va0o2YTN0SWs1cmpLcWtk?=
 =?utf-8?B?ZnlDWVVpNWgwakFOUW1ENVhUM3RVaTdOUHNiM3RhekIxZ3hKdlBzNGJtdjcz?=
 =?utf-8?B?UHVvRm5mRW5yaW5kY2lyTEZmMVVxNGp5L1BBZDNYTXJZNmkwUmpoeVBMNE9p?=
 =?utf-8?B?N2dmMWF4aThyelBhQTdhd0ZpTEtsR2QxL1BnQndqaEhDZTNoRDRWYlRqNDhr?=
 =?utf-8?B?TUhLU1R1NWdFcjFiQWxsTkdxcHJFZUN6T2hBb1JSenVQaC9TbmpCdFNVMW82?=
 =?utf-8?B?VHJya2ZtVVBTZ3ZKb1BxeU4vNUxWSmtHdlpkS3Z1Smo3SHlYWmZZQkdhSW44?=
 =?utf-8?B?VnM4SWtuSUY2OWxzd1k0c2wxYWJxUmFYUldNMnlVRlFRdnJ6TWpzejJoOWpJ?=
 =?utf-8?B?bmhubC93bjZOQjVBQlZVaXlmUHJuak5KTTBXQURaMUU1Qk9iYktqcys5MVlV?=
 =?utf-8?B?Z3dOaGlzcEVyYVlXVVpDdFVYM0FFZ3B1M0p5a2tCbUszK2RLTGdHY0VQV251?=
 =?utf-8?B?aGp6eUgyNDhGNDJBZUp1bGNORXFkdGFiQ25UK3d6K3JUelJvVDBhZ3NoYkpw?=
 =?utf-8?B?cDRQZjNCanBPTjJ4TzZhb0MzK1dqQmk1SlBiZmt6aEU5aGsvVGd6cUNrTW5m?=
 =?utf-8?B?TThSbkZra0JmTDlsOU53aWJDMmExWWlYNlZRenM0K1R2NldWaXFySEhPa1Fa?=
 =?utf-8?B?cUZHek45TStBaDdLMFpRclJDSlE1MHpJTkdzWDVtby8wRndIeEtia2tIeTlO?=
 =?utf-8?B?dElvdUI0bytnWXpRZDFZMXE5VTBJZU5MdFZMRTJNekJhaVIwcm9sWllvcVB5?=
 =?utf-8?B?RW9TNU5GaWRzNW85QWZYeU90dWJIZTlLNGRaUUlIWGtsZnY2S3FkbEhuNzkw?=
 =?utf-8?B?TENzb3B5QjY5ZTFEa2VJVG9pTG5zNnl3V1ZVYnE0NVBTb3l4aE9EcmlTNTFh?=
 =?utf-8?B?Y3NVNkFkanRkb2Ewek91cnN5S2x3M2txS293U2hqckZ2M2U4VXA1YzNJWllQ?=
 =?utf-8?B?NXJDUk1SRDA4VUZEbE1SeWdmZkd2c09YNWJKSnM5TENaUEZwR3kxNUt6UUlD?=
 =?utf-8?B?YzZ4UmlJdlJEa0FseWZlSmRQNnU2ZDlnNjNmRmNJL2I5OXJQYm96UXFxUCtV?=
 =?utf-8?B?R0ZBcmU3TElWQnhkM2dLenA4aFdNM1Vwc2JYcUZKTGtEUzRjOWhZRWR6RDhD?=
 =?utf-8?B?VUJZZHVxNzlaYzJwSkpmbGFUdlFucFFxWm5xbWRLRWRMS1FxVEFWVUdCbTQz?=
 =?utf-8?B?MEo2UGVaZ0plUnpub0FtME9JUUdkOHN2ajJnZVFBSnZlUUZtOWhuSkZ4TmQ5?=
 =?utf-8?B?Ui9TNlBJaDNYV215UEEwUVFoeS8rbjk3TXJCYkN2Uk5yMFdReWZxQ2ZMSkxV?=
 =?utf-8?B?dDFkZ0o4M3ZmQUkwS2dHTTVnQ1JkaTJqZERmWlVFSElKd3NCZ0lRMWY3dUxC?=
 =?utf-8?B?ek5aYThidmRTYXBtUDE2bW5RdzVZM3NOdUZlaEVNVXpkNmI2NGNlR3pSclA1?=
 =?utf-8?B?R3hHaTNJSEJraFlONW1VN3VKSi95ZmxDQWJCQ1hpK0YvS29pdjQ4dVh0QnFh?=
 =?utf-8?B?WGdzZXFlZ0dieThYYXYrb1VXRk1DMnFZaGh6N0VxK1ZXNzJML3pjdlJlUXU0?=
 =?utf-8?B?WWErQUNpK2tXOFlyNnpPVFk3VU9VV1lrTUpJaUkwZXVSNUtNdjRaVU8rV0pJ?=
 =?utf-8?B?a3VNZGZEYU42ZXFuTW9kM3NwS1NNNE9rRDdHZnBGZ3hDZlVodGs4ZkpWRjNu?=
 =?utf-8?B?b3EyUDJkS3M5TVpNTEFuNm44bC81b3RybmNUZW5pWHdLcXFVZElQaEpBRHBk?=
 =?utf-8?B?b2xUL3cwa3dnSWNKQjdlT1EzMUdFK2hwQ3I5STVmSHVPSllKQi9CUzZ1WERt?=
 =?utf-8?B?T3JwemlaajNaSkZKaDYrQzBGbTBrYlVRU2dSV25RZHRIaHlSWUNYMWZYTkRD?=
 =?utf-8?Q?ecjINnwdjNLMd918/q6FQt0=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 46e36df1-a0b4-46d2-bd63-08db1fd9b96f
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2023 13:33:38.5341
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0E+35uxSa1X0R+Cl1dtSfy73kPURFihWc2GhZ5BT77OIg4nPcgXzc8BbokwaHrHhnMIGIfmlGljK/b6YthEETSEB7+MQh0fSG6LYo7i8DCA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7097
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kal Conley <kal.conley@dectris.com>
Date: Tue, 7 Mar 2023 19:58:51 +0100

>> The RCT declaration style is messed up in the whole block. Please move
>> lines around, there's nothing wrong in that.
> 
> I think I figured out what this is. Is this preference documented
> somewhere? I will fix it.

It's when you sort the declarations by the line length. I.e.

short var a;
longest var b;
medium var c;

=>

longest var b;
medium var c;
short var a;

I think it's documented somewhere in the kernel. You can try grepping by
"Reverse Christmas Tree".

> 
>>
>>>       int err;
>>>
>>>       if (chunk_size < XDP_UMEM_MIN_CHUNK_SIZE || chunk_size > PAGE_SIZE) {
>>> @@ -188,8 +189,8 @@ static int xdp_umem_reg(struct xdp_umem *umem, struct xdp_umem_reg *mr)
>>>       if (npgs > U32_MAX)
>>>               return -EINVAL;
>>>
>>> -     chunks = (unsigned int)div_u64_rem(size, chunk_size, &chunks_rem);
>>> -     if (chunks == 0)
>>> +     chunks = div_u64_rem(size, chunk_size, &chunks_rem);
>>> +     if (chunks == 0 || chunks > U32_MAX)
>>
>> You can change the first cond to `!chunks` while at it, it's more
>> preferred than `== 0`.
> 
> If you want, I can change it. I generally like to keep unrelated
> changes to a minimum.

You modify the line either way, so I don't see any reasons to keep the
code as-is. It's clear that replacing `== 0` to `!chunks` won't change
the logic anyhow.

> 
>>
>>>               return -EINVAL;
>>
>> Do you have any particular bugs that the current code leads to? Or it's
>> just something that might hypothetically happen?
> 
> If the UMEM is large enough, the code is broke. Maybe it can be
> exploited somehow? It should be checked for exactly the same reasons
> as `npgs` right above it.
> 
>>
>>>
>>>       if (!unaligned_chunks && chunks_rem)
>>> @@ -201,7 +202,7 @@ static int xdp_umem_reg(struct xdp_umem *umem, struct xdp_umem_reg *mr)
>>>       umem->size = size;
>>>       umem->headroom = headroom;
>>>       umem->chunk_size = chunk_size;
>>> -     umem->chunks = chunks;
>>> +     umem->chunks = (u32)chunks;
>>
>> You already checked @chunks fits into 32 bits, so the cast can be
>> omitted here, it's redundant.
> 
> I made it consistent with the line right below it. It seems like the
> cast may improve readability since it makes it known the truncation is
> on purpose. I don't see how that is redundant with the safety check.
> Should I change both lines?

I'd prefer to change both lines. You already check both @npgs and
@chunks for being <= %U32_MAX and anyone can see it from the code, so
the casts don't make anything more readable.

> 
>>
>>>       umem->npgs = (u32)npgs;
>>>       umem->pgs = NULL;
>>>       umem->user = NULL;
>>
>> Thanks,
>> Olek
> 
> Kal

Thanks,
Olek
