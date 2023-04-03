Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 798306D54F8
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 00:54:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233732AbjDCWyn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 18:54:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233811AbjDCWym (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 18:54:42 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2071.outbound.protection.outlook.com [40.107.223.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9762144B6
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 15:54:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NCiERM7Y2FqfayxIsquc5BEGQ3HBE4sl50GBtndr7o5CxCwq313ItWzbO/oKkDvVUC7GDmQb5ItJwAhgBvZXd/0zQt7+dErtOBG/Bhwq7kQpNZk7U75XHe/ybyj7/37AzZ/ITi1rzE6GmumXHGkzKkqR0FlE3686iEErQU9hDQirNWRQVgRo7mSY1QzV0wlEUBuPBezpIZCdjvDMyrsBP8oowx68lBEaFWM57Ji28oIPLldtCXR7Wg08kt/7aSzn3FHuTYSIFwZMSeBK7GoK2ekb4bICvZXZoOZeMbfs4SuVBgCXHGF+GVgrhl2U6XveTjdTcWzbV2iEFAoe665syQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5Gz5O6rvLIVMiipRWnfuFQKnwIePpmtDyPOiZAUJcdw=;
 b=BVRj3CU7jWnTzHW95KoFTJZV/5WLQ7489KLnHdnbgFCV0H80YZPo7l7c+rlzLjkhKp5dMzc1nvHVIy7oUhArFntY84JyY91ktPaXFogE86rfFpDlgroKbAGbxXfuaPPB0ADvh17sCTjeZVOXEz9qPGutam33MFiV9PAQ35Wd3OCo9iTT2ueC3XN/EnQ7E99myslDtkKPYH0zibyb5fcoQTVZUmdOhHN669hrmnTbSZF/r27yVhd0tMNmK70jS6YAxUJD0TN8fQcfRSSvPpWvrkKPschtUM+lCKM4mV8gykPsNIEpwR+TzWHUJVHJxjAgdMYgXc2aStY8nQw4WykO5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5Gz5O6rvLIVMiipRWnfuFQKnwIePpmtDyPOiZAUJcdw=;
 b=mjCl16abgbg/N+V+JZDWzMfodIbrsPKL8DSGY4TqBV485OF0A1XQtfX79y99HjHTBFwxdMyZ6mtYARZxtn2bFrb1K/iHmOCgLOyFcgyvxuzTicmF0aJbK57pTKN+xNVoNww46fGlvciIFJfw/g3jQCv9MTge3e9zjZzJyByd2hg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) by
 SJ2PR12MB7866.namprd12.prod.outlook.com (2603:10b6:a03:4cc::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.30; Mon, 3 Apr
 2023 22:54:37 +0000
Received: from DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::e786:9262:56b5:ca86]) by DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::e786:9262:56b5:ca86%6]) with mapi id 15.20.6254.033; Mon, 3 Apr 2023
 22:54:37 +0000
Message-ID: <eb945338-915a-64cd-52c5-3d818ba45667@amd.com>
Date:   Mon, 3 Apr 2023 15:54:33 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.0
Subject: Re: [Intel-wired-lan] [PATCH net-next 01/15] virtchnl: add virtchnl
 version 2 ops
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Pavan Kumar Linga <pavan.kumar.linga@intel.com>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        shiraz.saleem@intel.com, emil.s.tantilov@intel.com,
        willemb@google.com, decot@google.com, joshua.a.hay@intel.com,
        sridhar.samudrala@intel.com, Alan Brady <alan.brady@intel.com>,
        Madhu Chittim <madhu.chittim@intel.com>,
        Phani Burra <phani.r.burra@intel.com>
References: <20230329140404.1647925-1-pavan.kumar.linga@intel.com>
 <20230329140404.1647925-2-pavan.kumar.linga@intel.com>
 <49947b6b-a59d-1db1-f405-0ab4e6e3356e@amd.com>
 <20230403152053.53253d7e@kernel.org>
From:   Shannon Nelson <shannon.nelson@amd.com>
In-Reply-To: <20230403152053.53253d7e@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0389.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1::34) To DS0PR12MB6583.namprd12.prod.outlook.com
 (2603:10b6:8:d1::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6583:EE_|SJ2PR12MB7866:EE_
X-MS-Office365-Filtering-Correlation-Id: 8dfd9ee2-b9c7-4e3c-ff5f-08db3496664b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EtcmTsTHLzCTt51Jf1UOXvK60ruMAVhCepkJOlPxbIMo+4fxlZqFtWFd5xoVY8oRGd4kkN1rh3MMVah5EFL8zD3Fgjf3xFIof9zhh1+TpRW9ihUXCSMU5UDRLnLdxvd8GmpLGrIm1zG0K0nhJDE1N4QzgA0UI5GEIlB64v4cmSRBQtqTsLVEEdPFCHcn7oJwuWOY1klrIVy5QEnlrSM2PpA82S+x/YynQ1RKyAr4YMaTx1Kl4bBt/vdwPyNzlrxpmaIdiRaTUEKhkyC9ANKchM3KTTrtgkZfz/pLGoJkz5XSokOe2uDfYM2keAdsmJYpO85Ogk1oBUodCVpJnk4gqMFwmoG762waOcnHjeEDrqxVxOXIi2pLkBO0ObvB2IXL/Qyw3l0iFolR0DNrKz6olcJ+ucnx3XQgULIdVF3n3391VIO8wJZJqa/ZA9+vKQVsXvSi2dnYDbxGDhsPdRMfOFc0ePpMBGklppZ+BYpEoD6VvRs5qtDiItHXrfQi4ifi4wFoAprq4f5hoR8ewnq1zZZRSX8G944BavAQaemsLL3FyOGznaksJQKBdtgqE1mXVbfMpyxQWwi/GpBG0ASeqyKL3iT2ngTmN2E/GeuoROqRAkUoO0y4TI4LJc9TuXVfz7TTNuOA16M128t6EpJqKQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6583.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(39860400002)(346002)(376002)(396003)(136003)(451199021)(26005)(6512007)(6506007)(86362001)(31696002)(36756003)(53546011)(2616005)(83380400001)(186003)(38100700002)(478600001)(66946007)(66476007)(66556008)(31686004)(2906002)(6916009)(4326008)(7416002)(5660300002)(316002)(8676002)(4744005)(8936002)(44832011)(54906003)(6666004)(41300700001)(6486002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VDhhekxlVVc1encwOElJTEdRRVZhNE5qK214dWl6OXFyemVQRDVpbUR5bldL?=
 =?utf-8?B?VXFuT2FVVlZhckZYR1VUVHdxaktpb0duRHptSUlNSmt4V0hzUy9DSlFnODVu?=
 =?utf-8?B?cUZGSThSWFZSZWhlYnNiN0xaWE5zQ0plME1Land4SklhUFBhTituS09QWDRZ?=
 =?utf-8?B?MXBmbHpkZGFEc0lNNThpOG5lUDF2SUFyL2s3M3dlYytwNFUzZ1VIWVRnUFpE?=
 =?utf-8?B?dWhhVVd6Q2ZPbHRXWXVoZE9KSXU3WkgzQ0ZOam8xWllnYUpDSmVkdW01MFdH?=
 =?utf-8?B?WjRUSzBWSWpRb0cvMXJINk5xRHV5cXg4ZkRMNm1VN095KzlobXV1ZEtaOGo2?=
 =?utf-8?B?Y3cxOHFnVlVRc2NOS2RteVVhb3BvWHdUWXNwckJmSXlXTzBHeDlTRUx6ZzZj?=
 =?utf-8?B?emFCNSttZ0dlTGcwYkxqWFlFS2JoRk5pUWFuNkhKaWFZYmhyOUFERU5QMWtZ?=
 =?utf-8?B?blUxUDZnakxaelZ6K3NZNlRTQW1BN0ZkOUJLazFVeFBLVGxrdGZ6Sm55MmZM?=
 =?utf-8?B?M0FGUmZhaW5rTWxydURVVVlYZncydWliYWdqTkV6UjhhMW5sdUdIcmhQeGN1?=
 =?utf-8?B?T0kwM25GaW43VGk5T0RhTGxLWlpnVkxnWmZtVDhNVkVKaGpoMkgrRXliOXRE?=
 =?utf-8?B?VHQ3d054OGxGaFdaVUpLUkEvSEUvUGM1eG91Y1ljK2FHejA1YzYyeFhHcnpY?=
 =?utf-8?B?c0J4ZXpzd2lZRTZwSG1BZU9UOEdQVDdjbVVHa1haUlc0VVZwa2JzSWZFbTJC?=
 =?utf-8?B?aThnbEw0RGh6M3NFaWxvdWRsTDlGdUxSZ1lBNW51b0JrM2R5QmtTc0xkYWxv?=
 =?utf-8?B?TWt4Z0VFNHVGYXVqNDBqL096Wm5jd1hFOU1lRENDZFF2QVhNMEFGOHVzaE0r?=
 =?utf-8?B?NmhEMFZ5Q0ZLVjRSd3AzMzJOSENBTy9FaGFXUVp5LzVvOExEeHMzYVhsaTNz?=
 =?utf-8?B?WXVEWDVzdVZ1K08xRDMyc0lObzA3UGdPQkl5YlJzRkRxbWM1WkhjMU5UbUkv?=
 =?utf-8?B?L1k0Z2Q5L0Jva00rZzVTaEtNSnI4OXlZdDhVR09vYTB1UkRjK2NmNGdVMVFQ?=
 =?utf-8?B?WnhMNVplVTZkaEdpZWlZcHQzWE9NODZxbDZQTEZ5ckZXaDB5MnNkVno2RVA5?=
 =?utf-8?B?VUlUSFNlcTdrRFozbGU0NSs2c2F2VFhGU1I1ZndpRmxLQ1RjQjhFa2wyZ3U1?=
 =?utf-8?B?ckREc2xJcFpuS1FpbENzaHdHRHBNVWVyaS9MWkFnTEQwN0tHeWM4NXZlNytD?=
 =?utf-8?B?Zzc1VnVOU1lud0R6QjhJV21ET21HS21sMWV6Uk9TNDBWT1FIMmxjZ1JuZ0Jj?=
 =?utf-8?B?WTNFWlRmYXMxWGhTQU9vWDUxNWpBaTVUUXBNbjdHUS95Zm9FdlExbUtwOEdO?=
 =?utf-8?B?TGcrN3F4MG1LMVdIcTlaN3BVYk5jL0I5bGZ6ck4wbmx1b3JselZJbm81QlhE?=
 =?utf-8?B?MDF3TXh6OUtkMlpjQmpsWWFPdmUrWUZTM2VYZTR2WWVIckRxQzlpV0wvYzNp?=
 =?utf-8?B?R3F5NjE2NnhFcnFUTE9lTHcrcEVSSVp2VWdGMGFaTjRBT3dzRlRCbkZ4WmM1?=
 =?utf-8?B?Z3dQM3lYQ1gxMTU2UnVHUmQxeHR5OVBLdlZKaG5SZDZzUll3ME9CRUVDTGww?=
 =?utf-8?B?Y1F1b3hGalBaRVBXYWJWc3QzWU9DeWoySkxJalRoZS9aVVhnRGJhbUxJdEEy?=
 =?utf-8?B?R0xJOFduMlBrMjJDUWdIWnJSSXZ4TUFCWFk1YmxWRUJBbTY5UFN0N0dmN2Zo?=
 =?utf-8?B?YWJIeGl3ME1hUFhIOXNKZzN3LzhwT3l6TXFKK2g2RHh4QzJ6VXNldlBWbncy?=
 =?utf-8?B?ZlJ0YWlyUUE0di9XWW5nY1VTazlrSG83ME0yai9hekM4aVhoSEVxWTlucGVL?=
 =?utf-8?B?a1AxU0d3Z0RJa3JENzhLTmJTUEFKVkdETVlrMHdyR0FkbnRUa29zU3RSUDd2?=
 =?utf-8?B?NGp3S0xnUUZzaFl3RDlnQ0J6c0E0VEVEK2pQNVBZYjRMeEQxZnEwNDNxUnBp?=
 =?utf-8?B?clVRQ1hONzhyZXhLbmlFWVo0SUFjUmUxVlVHRE5PNTd4R0RtbUdwRllpVFVz?=
 =?utf-8?B?WDJ3cDNpMkROSFJEZDkwYWl6WDVKRm5oRkdmUjhVNWowbk5YMTZLVGJGWFpQ?=
 =?utf-8?Q?0s+JOUsQwcbUOLeuG8c0peVBQ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8dfd9ee2-b9c7-4e3c-ff5f-08db3496664b
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6583.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2023 22:54:37.0911
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8eCJ8R46mk5nJjo9gKz1G4BiC8/jMnjD2TF33a8Wq3tFVaMJ9+FtFFeXnbbll0b2MzopAz27oxfJd0+R0sZd5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7866
X-Spam-Status: No, score=-0.6 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/3/23 3:20 PM, Jakub Kicinski wrote:
> 
> On Mon, 3 Apr 2023 15:01:55 -0700 Shannon Nelson wrote:
>>> diff --git a/drivers/net/ethernet/intel/idpf/virtchnl2.h b/drivers/net/ethernet/intel/idpf/virtchnl2.h
>>
>> If this is to be a standardized interface, why is this header buried in
>> the driver specific directory instead of something more accessible like
>> include/linux/idpf?
> 
> The noise about this driver being "a standard" is quite confusing.
> 
> Are you considering implementing any of it?
> 
> I haven't heard of anyone who is yet, so I thought all this talk of
> a standard is pretty empty from the technical perspective :(

Just that they seem to be pushing it to become a standard through OASIS,
as they infer by pointing to their OASIS docs in this patch, and I was 
under the (mistaken?) impression that this would be the One Driver for 
any device that implemented the HW/FW interface, kinda like virtio.  If 
that's true, then why would the driver live under the Intel directory?

sln
