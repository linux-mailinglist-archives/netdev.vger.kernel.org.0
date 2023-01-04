Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8332D65DB64
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 18:41:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235044AbjADRlO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 12:41:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjADRlN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 12:41:13 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4039F8FFA
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 09:41:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672854072; x=1704390072;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=fAzxWlkOhFLE7rZoNWlyeSpZwdJAV1CH7EOWO8Zer0I=;
  b=L20y7y0f+XYX7WgEWtuiLcGO50VTadWGcKfhtgZ5JcSq5gQd6ynpym9x
   nnWSAP98DlI216x843WX/ZrH0EQIupRynsb/VHuHa9W0os/Rcp9XKG9ak
   KRX468JYSWrZIiiYJOz/KVU9bDomc+1UEk2sT8DOlE5zZdQb8dEN7qfL0
   jTu3fcE8m5FQxa7/1mWyXDGPWVj/sKgY8g4WWcpUgotkSAlwT1VKgv6Yj
   /hRcGADQIsl1Oqu/cO6g5bTMf1A+LH+Sa0rQxYiB4pjajDTWuE8J6pN96
   pzdHeLbMuC2SNsYX3o3XM070ENMjiZVXmVm6bC5LRLNJPbY92AlwfX10s
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10580"; a="301686796"
X-IronPort-AV: E=Sophos;i="5.96,300,1665471600"; 
   d="scan'208";a="301686796"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jan 2023 09:41:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10580"; a="687604497"
X-IronPort-AV: E=Sophos;i="5.96,300,1665471600"; 
   d="scan'208";a="687604497"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga001.jf.intel.com with ESMTP; 04 Jan 2023 09:41:09 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 4 Jan 2023 09:41:08 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 4 Jan 2023 09:41:08 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 4 Jan 2023 09:41:08 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 4 Jan 2023 09:41:07 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nat4tW2SnP1SEeOPgWdaLvS7BiSmrNy4JQFe9Y42YOpYDTHziXjddwuQjdAXaz94lTGzWyeB2PiWjrucVzmahJfd/74R5z7hjCla8CSzxgnHfULkeL6y1S5jOGOX4kFteyXQ2nB7A/UJ7E5/R4VviNtUUfT+YK9GxkoS7otHgZUKdBvWOPMAsKVip7Nz6HW1PkHmz96/pHVFE3a8KSj+DKaivCnScGlhF2uaU2ahpfLlDcVQZPddgD3aIirarjX9d9sOiVXJZZU2hfjQBTTBPme9aw/VM3MqOe3t/jSr1IPSG9Omf+OvY/fcMblQXSoXsJk7O7QFEV8LvIogMTMSTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JjXfuJcXlUKo6ah6Rd8pQz3UROeY1t+fdTfZUozZVA0=;
 b=nFUH+dtgHQ881Mvs7C6c3ecdedpFrDDvOkhVJT4+E6erHdRY5hxXuVfIVL4oMULstq/+w634pcMZ/IhQ9C5oPK+sQh/K0IpR5Z+JF/9xqzIL10k27HjvGhUraKH/r2F6TltLtF540STKrINC1SZQ3vPjODzdFYgb69Oxt5629dpl80hJEI2d1iR+pR1d7XL5FG97cRHXP8XdiqeOOYuRHS5krVUtumlP2yTc+QlyQhx+lIPuO7Gt4s+tdgKXGP30PMHCYiL9EnZzK3a14T1KM5pFZSaKHWcLQOVQGpiFSqgJNsolqbX5cxwfn3PK4D+YCIu1ynuudsehMnJTGAiXDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by LV2PR11MB6069.namprd11.prod.outlook.com (2603:10b6:408:17a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Wed, 4 Jan
 2023 17:41:05 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::933:90f8:7128:f1c5]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::933:90f8:7128:f1c5%5]) with mapi id 15.20.5944.019; Wed, 4 Jan 2023
 17:41:05 +0000
Message-ID: <df371b51-2d46-a7d1-19c2-8f482f283336@intel.com>
Date:   Wed, 4 Jan 2023 09:41:01 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [RFC PATCH net-next 1/1] ice: use GNSS subsystem instead of TTY
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <edumazet@google.com>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        <johan@kernel.org>, <jirislaby@kernel.org>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Karol Kolacinski <karol.kolacinski@intel.com>,
        Michal Michalik <michal.michalik@intel.com>
References: <20221215231047.3595649-1-anthony.l.nguyen@intel.com>
 <Y7UYpQq/DBCNcKiL@kroah.com>
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
In-Reply-To: <Y7UYpQq/DBCNcKiL@kroah.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR03CA0003.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::8) To SN6PR11MB3229.namprd11.prod.outlook.com
 (2603:10b6:805:ba::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR11MB3229:EE_|LV2PR11MB6069:EE_
X-MS-Office365-Filtering-Correlation-Id: df9fe193-7df0-4682-03a5-08daee7ada9b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wsb2F2lSL4WopvDU2CxbvxI3IL5c7UJGqKQivK/06JgkXLeqaP3EF4rFi0mA0qIZLrfAdKS2TwzTT5rKOPD+LO2BJ0DFWcqrrupKQNfLuqIk5Lze1vpd0cvMzTCnR3fyqLfv1DrgbCD6fs5vV2tCe6XjKV6VmbAh4sgxzBj4FE0Xt5LS984VMjqxu5ejav0CQbEuWU1hOVr0+AD2QDxiyYZv4D7ENEDKufw5kPF41rhpOYHlNSGR17oWlNGdgcZG+mjndlmx4ls6PZAUTONdToo6jaVxqa85TeE54uI/3CC4B4wrktEbJhf5W2eCV/eAov19wAolOAkjfz66ko2Z4q2QKw7+/xlIiBGFLJDhv/UNZawybZ/JS5s66Pu/B14nVqcfcAAHUn49NgDxPiwzCO0CWOg7fGdOOpBNVdVNee6FUALffVNj/FdYTAVOYzHnj+Grtz9HbI8cFiUsttIWpQxH+zhZXT5fmEDCdmzy5K3+JLKEFCwne2k6U1VfELpp0a35MVVI5hOtQMsVcaGW2PbNJTzF990gCnm95BNshaGI48BDOP3wEf8d04VosbU3SiZqFmSbA/5NKFDg+oGhustk3ObjtyJFRgD7kRQk2BOHqz+056lUxZfsgIhP1Zo3DgFJdZ0HDjJq2b/c83fNZihEYA4p241t3x3Gale1N7ldV4BlzleLi9k9VyjtNga3tZsM9NYaUqE3Fa+V21u5w5kV8aS7xoPW9yV2brevmkouKTXyhCA6B7hF6r8Y2NTk
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(366004)(136003)(396003)(346002)(376002)(451199015)(53546011)(31686004)(5660300002)(6916009)(186003)(6506007)(2906002)(6512007)(54906003)(478600001)(966005)(6486002)(26005)(41300700001)(6666004)(107886003)(4326008)(8676002)(8936002)(86362001)(31696002)(83380400001)(2616005)(66946007)(82960400001)(66556008)(38100700002)(36756003)(66476007)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SVJsVmlhKzRHMEYxVnBLZitDTFFPTThKQjlLK3F1Tkg1UWRPOVBoYm1kamJv?=
 =?utf-8?B?aUJTdWY0VUNzZGthaElPQVZramQ0UzI0a25EbEtuNk4rY1VrbkhVbkVOdzNT?=
 =?utf-8?B?d0pMNEVFeFZ6Z2JJYVBTSlpmY05sNXhWWXhicHJ0ZGRNY2M1dXVXcHZPVUxE?=
 =?utf-8?B?b0w0QnAvV2JrbkFxamNobHY1dThXeE9EaHZBS3I5NE1TVjNIZU9mcEs0Znk0?=
 =?utf-8?B?ejRYMGwxdFlsUitJekp5YzV2ODJIZEYyRVY4R3h5cGxjWVRQYm9BYzd1UmFM?=
 =?utf-8?B?Nmo0Q3duZ0krSlBEaDRMZjlmMWdsZVM3U3NGUmF6UjdidVJGNkMwVEZuK1FQ?=
 =?utf-8?B?TFhoOC9FbkhUM2FRckpObzhhUFJQTUhwY2lzMS9WVjNaLzZ6VXNhZVpQY3Ev?=
 =?utf-8?B?U1FzR2RQWHJDMnVuOUU3dmc1aXVseHFEaTBuNml0dEdPVC81NkVxUGN3cy8x?=
 =?utf-8?B?eUpWekl4MThrbVJQQW5EVUpuZFNSTW9XTUUyaFhWVk0wOXBZN3Zub0JSellj?=
 =?utf-8?B?WktSQ2hsdWVBYU9QS0NOUU1NSFZ0VzdWZlUwTFdtTkpJU0lOZFovaWJsK1pS?=
 =?utf-8?B?VU9jY29obGF5dDIzVHlleEFGU2JQTU5KbXBYK0RDZENtZlcya2tzWTI4YVpS?=
 =?utf-8?B?YkVmN1V3SDRrbkszSWdmeUVaYUhFVnlDRURRQU5QZksweDhCeU5aYVZvanZ5?=
 =?utf-8?B?SHl5SWlCQ0RFRCtmNE9FZERwb0duSUpoUEFxVFRvSi9MblAvVkR4RXJWRWs2?=
 =?utf-8?B?eDdWbWdTemRzdzV4dHplN0JUdE5ENkZIemlYQm84VnQxUmJnRWFzQ3lSYUJn?=
 =?utf-8?B?QVBYNnFwSzVjRVFUYmVmc2RQMHZRKzBFSFV2STNKZmVuSm5ncFlCcStWL1ZH?=
 =?utf-8?B?amxnUWdtUjZMWDlJV3FPd09YZFZVdEs3SVoxbjRyMy93MDV2TlJ5TjNkM2Yy?=
 =?utf-8?B?emtuNWg1ck9jMUNHeWNSQnRrYkJlVmlkQ0tkQkV1cER6YVQrVEJSVVZjMGtr?=
 =?utf-8?B?SWowN1RjcEorc1A4dVpPMERYRktaOUg3SFIrY2dwTURSejFtYjdrZDRWa3lS?=
 =?utf-8?B?SVh6UTdYSmVKWThnVFVFTFNoL09xUGF6QVhUTXpNdCs0SXlUWHMzb0M2Skh5?=
 =?utf-8?B?azJLcXhoRnJtYzRYZm4rQTc5NXpnV0pOeXRhV1lMMTBKRGpXektDbHFndHlI?=
 =?utf-8?B?d1QxMlZpUUZLcDJXeHpQMFBBQk4wbXdvVWo1NU42b01ML1NUa0pzUXYya1or?=
 =?utf-8?B?TVIzcHQvQlFOWWdQbi83TERRaldyajhqRmJUaVRpZXFhWk1heW1KVm5vNldq?=
 =?utf-8?B?YUY0cHkvZmkxemRXT1o1UW5yNjVNL0JMQUUvU2JZN0FJNGQ4clVOWmNPQlp4?=
 =?utf-8?B?Mm1GcTVobDk4d2NkNmVyeUdycDdlVVRtSG5EQzI0WldhVjQrSXduWVdSbEVL?=
 =?utf-8?B?WWFuN2dWU1lURnQyUVhHcWhDOSt1MWZEb1ZGZ2YvcjNwZ2JNV3lJVmpicTF1?=
 =?utf-8?B?Y3FtUjhBSy90Vm11L2djRGhMd1pHWmQ1NW8xRVBLOHp6aGdVZGsrVWpLZVl2?=
 =?utf-8?B?amp3VmNlaGszcVdBZFM5NGtHN1FOYnRQWUNYSzVQaHlDWml3QXdVMG9wMEt5?=
 =?utf-8?B?M1VaeFR1V3lhVEl5ZXBxM3hBbzZaN1k2ai9HZDRjTmpqYk5FSmh6U3ZyQWhk?=
 =?utf-8?B?OGNMeGZSQ2ZpTTB0eVpPSGNLblZueXAvTHhUYUZxTDM5c01kTzU1OWRQWWNR?=
 =?utf-8?B?USttODhXaDNqOVNhMGVucExJY1dDU0dZOVpTNkRwRk9KQ1p6MzlpS1dhNm1n?=
 =?utf-8?B?YVJ3Y0l0RXFzc0hGeE8wVk5SdzJSQUFSV09LR3UwQzVWMFI3NEhoWk5VdFVD?=
 =?utf-8?B?ZFdxY2dnS0RxejhkZ1lwdGVVOW1JUlI2dWI2a1dOYjFyU2R2aHZlMDRLcHFl?=
 =?utf-8?B?WGZKYmNSNXVYYmE5WFU0bWkrT1gxeU5WNU1MdjFTYVNhQkNJcWY3Vi9jM0xa?=
 =?utf-8?B?VUJGSGR5Q0t3NlhKZzBnUjZWdzNvWVBIcndBUlZYS2xHS0c3c0RMYmhGQjhT?=
 =?utf-8?B?ZHd0ZDEwazJKTW9QdFNaMGFvQ0FFRXd6dzhVNmJNZnRpTkpSZWNUOS9sWnhO?=
 =?utf-8?B?aTAweGlDUEtCaVdod0o4R0sxRUlFbFNzR0tGMU5WZjVBT3F6ZFZXM2lPSEZO?=
 =?utf-8?B?Z0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: df9fe193-7df0-4682-03a5-08daee7ada9b
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jan 2023 17:41:04.9234
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nA02O//GXl2NvJK9P20GIL/8RT9zrcXIEMFUPpOJdHJgcNoLVOF0x9GMuSFq+bPpUWOd//M/ojpIZkDJ56XWQ55CCR7Ux1EcqYBQIuaQSk0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR11MB6069
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-6.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/3/2023 10:11 PM, Greg KH wrote:
> On Thu, Dec 15, 2022 at 03:10:47PM -0800, Tony Nguyen wrote:
>> From: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
>>
>> Previously support for GNSS was implemented as a TTY driver, it allowed
>> to access GNSS receiver on /dev/ttyGNSS_<bus><func>.
>>
>> Use generic GNSS subsystem API instead of implementing own TTY driver.
>> The receiver is accessible on /dev/gnss<id>. In case of multiple
>> receivers in the OS, correct device can be found by enumerating either:
>> - /sys/class/net/<eth port>/device/gnss/
>> - /sys/class/gnss/gnss<id>/device/
>>
>> User expecting onboard GNSS receiver support is required to enable
>> CONFIG_GNSS=y/m in kernel config.
>>
>> Reviewed-by: Alexander Lobakin <alexandr.lobakin@intel.com>
>> Signed-off-by: Karol Kolacinski <karol.kolacinski@intel.com>
>> Signed-off-by: Michal Michalik <michal.michalik@intel.com>
>> Signed-off-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
>> ---
>> Based on feedback from:
>> https://lore.kernel.org/netdev/20220829220049.333434-4-anthony.l.nguyen@intel.com/
> 
> Why is this "RFC"?  What is left to be done to it to warrant that
> marking?

net-next was closed at this time, so I sent it with RFC during that 
window to get any feedback to make needed changes before it opened again.

There are a couple of patches for net that will cause merge conflicts 
with this so I'm trying to get those in before submitting the non-RFC 
version of this to minimize conflicts. I'm hoping to submit this next week.

Thanks,
Tony
