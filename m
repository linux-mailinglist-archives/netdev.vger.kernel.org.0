Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6CF446061A
	for <lists+netdev@lfdr.de>; Sun, 28 Nov 2021 13:35:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236670AbhK1Mih (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Nov 2021 07:38:37 -0500
Received: from mga18.intel.com ([134.134.136.126]:27498 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236616AbhK1Mge (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 28 Nov 2021 07:36:34 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10181"; a="222703455"
X-IronPort-AV: E=Sophos;i="5.87,271,1631602800"; 
   d="scan'208";a="222703455"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2021 04:33:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,271,1631602800"; 
   d="scan'208";a="608363506"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga004.jf.intel.com with ESMTP; 28 Nov 2021 04:33:18 -0800
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Sun, 28 Nov 2021 04:33:17 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Sun, 28 Nov 2021 04:33:17 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.175)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Sun, 28 Nov 2021 04:33:17 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ChoI2qMRobqGu1pMv82sWdYwUY1z/XDzyCCqrsRaCPrHZ5O4HLWTlKgN4ZVPeq22vczSvZyJ4HNgA948UVG1LL+LCOpx66WQ/IIL/W7lInIqQE7k09l5IHH0Vb/gFAo3SC5naxxNA5RKN+MWqNrPLEcL7dpTRqn4x4huxT1EK+gt9yBueGZ9fTBMjlkj2C2cvpRti0rHr2DmeSaurGYxrmrmiXWLfuxj56+KlwbDmwLnK7Jph1yzbF/ia+chuwEOMaDJbb8iOTjVTht1scmu7KYDGFvcp+Aelm1/ktmccPwnqJsDzWceDnLk2UK8gTsdgpriAmO5Dw8topZ+CqUueg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=61KX8HiFYa8RQblEzMJLMPzypN2PQ95zeSqbaagrRpQ=;
 b=RK6OOW/ZLwdDqFbeIp9n5TAekTEC8KFhW827TIQU11IWT7uYlTEok2C/HZP/2W4OQ1H0OIj0ewIDmw6LL1SeX7yqqLXewkw6uBX4suNqHw6AP09kKolV7E4fKueszPVwNRiOz1TIEuO7NHVU1GcUfPau785WR5YwZ4oFNCeAuAd3fbO2tKyNlzPCN4kd6KUHfT90V02TxR2BfKExjIJ47pMa8KQIH7bZAwPR6BmxTS+efRaF5b4SbZcAy0fJpMJtgKRPFegIe6/gsgrTOGmBfB8XtphTzi4cwmySZeIWIErGhyerhcMnWbeluikM0Hj5mmBUFV/l1c9bF2fK57UyFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=61KX8HiFYa8RQblEzMJLMPzypN2PQ95zeSqbaagrRpQ=;
 b=BvQN0DXDRGWk/cj4411tWVPX7HhcDL8u8PWimGyi+3d6kUZnIpLgnqIwIinyhhUyHARhUKK7K16UtsS6qFWCk/ojMyZB7SeMqpIPvZaWiFPVjZCsqrUkN4cmqj1591gQtBba06hJIoI6suhtAWsRzptfQwZSqo0y7/feXgKUL8E=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4787.namprd11.prod.outlook.com (2603:10b6:303:6e::10)
 by MWHPR11MB0013.namprd11.prod.outlook.com (2603:10b6:301:67::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Sun, 28 Nov
 2021 12:33:16 +0000
Received: from CO1PR11MB4787.namprd11.prod.outlook.com
 ([fe80::ad1a:85f8:d216:bea]) by CO1PR11MB4787.namprd11.prod.outlook.com
 ([fe80::ad1a:85f8:d216:bea%2]) with mapi id 15.20.4734.024; Sun, 28 Nov 2021
 12:33:16 +0000
Message-ID: <b9f738b6-1140-55d1-bb3f-d54f3521b739@intel.com>
Date:   Sun, 28 Nov 2021 14:33:07 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.3.2
Subject: Re: [Intel-wired-lan] [PATCH 1/3] Revert "e1000e: Additional PHY
 power saving in S0ix"
Content-Language: en-US
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        "Lifshits, Vitaly" <vitaly.lifshits@intel.com>,
        "Ruinskiy, Dima" <dima.ruinskiy@intel.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <acelan.kao@canonical.com>, Jakub Kicinski <kuba@kernel.org>,
        <intel-wired-lan@lists.osuosl.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Neftin, Sasha" <sasha.neftin@intel.com>, <mpearson@lenovo.com>
References: <20211122161927.874291-1-kai.heng.feng@canonical.com>
 <14e6c86d-0764-ceaf-4244-fcbf2c2dc23e@intel.com>
 <CAAd53p4cQ+3HQKP3--SW68fNPM9LZPbkBrrA68iu12-gA4-B7Q@mail.gmail.com>
From:   Sasha Neftin <sasha.neftin@intel.com>
In-Reply-To: <CAAd53p4cQ+3HQKP3--SW68fNPM9LZPbkBrrA68iu12-gA4-B7Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM5PR0301CA0002.eurprd03.prod.outlook.com
 (2603:10a6:206:14::15) To CO1PR11MB4787.namprd11.prod.outlook.com
 (2603:10b6:303:6e::10)
MIME-Version: 1.0
Received: from [192.168.1.12] (5.29.60.197) by AM5PR0301CA0002.eurprd03.prod.outlook.com (2603:10a6:206:14::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.20 via Frontend Transport; Sun, 28 Nov 2021 12:33:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 802764cf-c15d-43c2-6f05-08d9b26b406b
X-MS-TrafficTypeDiagnostic: MWHPR11MB0013:
X-Microsoft-Antispam-PRVS: <MWHPR11MB001335DB3822381EE9C6A5D197659@MWHPR11MB0013.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3YEFriz6FDlgLtF9TmQTIz/0ePIFP4fLQvILUyRwtAgD/2zZU4FO2VokhLts/yQjGZk2mZ7YdRVWijrG1LA/RuxcNzMqLlrRfxU26ks2mcM5XLkiDUZef8K89bYeFP1SzYP+bkM8NKMMsliHLl/C+VUGc8J4cr4Q+9lmMAYlLSZyHEjLrqilEHif8T7nX9nRuWrzPqp6bZdbWRfBpPSnFmJXc/ZM2xDKlaSlAvZmDkBKQ6FyOtkNSncDkVSItE8J1euxLNozFlmprdD5XP50foqNLKoDHgSlZtNFO/eG+5cga8WoioNxQdffW13yfYP3mD8nMO9Qv+9z1TwTGrOidnYg4QlNWwKN8QwSdQ8RNfpqaHvHqcsEBATdb0wma9TBIPo4mAcqGxjdbSS5h2oEkRwRHGnvcqC7H0C1tgzEUyYXwIgBmVo85uSO0lqDEhL/qTQaI6dTRF3TFp8JtPhl2pFQ2k9Kn7UKuDt0jZeaNhkbDCCvyfsdbArVl+VM9h8C1qfN1BhysgMZeBHcmByK0yE1LDZ/YV/fz0g739tuhbLwkJ9ZMfQGk6pQK3uc23y+Slv56yFIXjjfafhohPAHO6i08a/D5x/GDb8zJNkl1PJYXW59hGsJKeEHXFfsoWoA5sgI4LKnRgJ5PgEhrv3yG0dQdSFnhqUFmal8TCMg9aCG4fr04MPsUA1x3lVt0nP5mZ/DBoLAoJIdyxSd/tOugPxo0Blpe4z+XF0T17YObwkqeTgxZO3/L8iXPreFpTEyJ1hq3qwAePeob2hGCsHYaxh6BiYgCR9BXAGngBqx8QcOKxqA12QXTkBzQBSojghfhKPHHqw38d5FkzOWCC05kLc383XMIEP0+GVr5mp8mLFqWTZ3MdtwdCiIdyPwQo16
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4787.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(508600001)(956004)(2616005)(4326008)(316002)(186003)(8676002)(66556008)(66946007)(26005)(66476007)(44832011)(6636002)(31696002)(966005)(38100700002)(36756003)(83380400001)(2906002)(86362001)(8936002)(31686004)(6486002)(82960400001)(6666004)(5660300002)(54906003)(110136005)(16576012)(53546011)(32563001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZGJrS0s3K0xTU1I4eEVrWFo3L3pYMzlvMWVCay9Oc052SFNLb3F3N1lmQzU4?=
 =?utf-8?B?N1Z2ek5VaitaOVl2TmtRbkVJblhPT25kMFhlMFhnVWhCaTFMSU84MUREWXVE?=
 =?utf-8?B?RDlxUENDUExmNkJDV3Z4UnBPYUlBaXdpbEh6Zm9rMXZYQWdBdUdWMEV6MXV6?=
 =?utf-8?B?RkpoQ240L3RwUEg0bGdrQjZXUTlXOFYrandBY2dPK01vU00vN2FaVG5pQ0RO?=
 =?utf-8?B?WlBQV1Q5M2xINU94REMxM0dxaHIxbXJKN0dHemkrN21WaDRwcG1Iam9OcFhF?=
 =?utf-8?B?UWpEcTVPaThnZTlTYmpMU3BPUnEyT3hQM25jWTZRWDZuU1E0OFJWc2QrNzA0?=
 =?utf-8?B?SFRzTyt3ZC9vQ3h4T0xuY25zbGU3TGc3N1RmN0RGVkhjQVJmejlzUDQrd2pi?=
 =?utf-8?B?QjgzcnYvQU9PMmlKZ3JuQWl3UjU4Z2pUSXhKcGdITytjMnZvU0E3bDlMSjA1?=
 =?utf-8?B?bWlkWG5JMXAzR0V6UWhJR3JCUGhKNCtWM1N0a1pPMlF2NkdSaElxSklkSEdu?=
 =?utf-8?B?enI3RWZNa1MrY3pla1FXaGF3WWlIQkVZTGg3QWhhVlhVVGtJc3ZBWXN4dm5T?=
 =?utf-8?B?a1ZIUnZiNEpackc3M0RlcXRvSnVVV2ZtT01FeS9NM01aNStMQlhBVnpjd1B4?=
 =?utf-8?B?bnF6b0toUTdXQS9lejZWbFJkTjBETnF5dlhPR1JZM2ZSTTBJNjl6eVdJak95?=
 =?utf-8?B?emVOdEtQdGVuamlwUEJ4aTB5bGR4Mnp5ZUVVMTFVZ3M4aDd3SUVHY1c4WEhU?=
 =?utf-8?B?VHJqSlNEKzllN2JHU3VZendlclpqMjAzRjZuZC9mb29qQ2pSZHRaeTJrMGdr?=
 =?utf-8?B?Z0hsT0JOblhtTUhVcDZvQ0c5WDJKL2tZUHVBbXZmcndUVy9iRm90SWV5dlo3?=
 =?utf-8?B?a09WNUlqeGhlVjFDTm1xdnlYQjBzaENvK3Y4elJJTWlYQ1VEeGR5aG1GT3k1?=
 =?utf-8?B?YTFldWVEbTdKbXpPK3doVGlaRm1TbGtaTEdWWUE4R3JNWk50ZzZSczZFU3Nr?=
 =?utf-8?B?Z28wTVlGaVV3c0JUcjJFV3J6RVR1VDhQdDRxV042Y1FUVkxJVXRTc0FpZTZl?=
 =?utf-8?B?bWRZdS80eUpJTWJKTEdRRFllUkY0RUZMdThOY2hYMU1DeDFvOXlKeUIxdmdv?=
 =?utf-8?B?K09QMVVDZnZUSDRSRFYzWnQwOTNRd0tSSFN5VmRqZnBjdlFOK1hqclhlZTBP?=
 =?utf-8?B?R0swSVhUaHpQVWxySlhHcjZ0dU9rSE1mUng2dzZxbzVLQ1k3dWJ1TDdZOG15?=
 =?utf-8?B?ZWpwUzY0WGZNM0pSVGxxUHVjRGJ6R0RYT0sxZEg0bGRNN0d4TC9TR1pqZTlv?=
 =?utf-8?B?NVQvQWZGNWFQWGdab2VWOHdMQVdEejhFYmdSM20va3NMeExZcjlNaVFpVU0v?=
 =?utf-8?B?Z2E3QUdpM2k3NEJBVC8vVExVekduemhjalFzU2V3QVJZOVRINE1hd3JVd1kx?=
 =?utf-8?B?QVl0aHMzZ1hRM3RReXZwd0ZDc1NTY2I0OTFSS1pHZGFMdmYxRHFoTlV4TmI5?=
 =?utf-8?B?SFI5WnlyVDNibVZ1ZmtVRGFZRnRqL1R4aHFsRUZ2SFc2cWc1YmwrblVVTmp5?=
 =?utf-8?B?aWVDV1gzc2I2MGI2TVdRZ3p2TGJ3MDdtK09UOHFYbDVRNnFUUjdLNUxsbjkw?=
 =?utf-8?B?Z2R1dHVKUFczcjNEclI3TXdzdUE5MzlnRWpjMUk3V0xwYlpTRDdrdXZQWmU3?=
 =?utf-8?B?dTRVcmUzY2JmMEFJTi9CT0hXSjFIeEpVT0txNlFmQ1dvR1VuU2hUUjIwYWVq?=
 =?utf-8?B?Q3JMSEI2ZlJwTDRrbTFKNHFzV2lRczV3TUFyMm1TNWpzM1EwMUhxeWxwY3hP?=
 =?utf-8?B?cFVqRjh6d2todTFQNTE2NjBmdnI5RXF6MDhuRWtQLzcwd015VzNYZGxCUGxI?=
 =?utf-8?B?bWZ4RERHU0l1aStoUnliSXUzZ0NRQjQ4Nmo3UTFwQ0dCS3A5YzBmeGt6blJL?=
 =?utf-8?B?KzlmSVNaR2Q0dTUvZkk1N2JDSWNGRDkxTkJVcnk3NFYxU1FXQlZrT1l4bDls?=
 =?utf-8?B?WFliL3FnYXJQbHFMWGlXWEhWWVNkc2RReU5Xa0JJa3phb2FQSjRvS3k1bmNp?=
 =?utf-8?B?Q2VkNFRKWFpSVGhOSDFvcGgxNUM0cEovUFVJSkQzdHZRL1NWSGROcVhhR0dW?=
 =?utf-8?B?bVRJOVMzQnNONFpzdGtiN1ZpZnZUUEZCM2NjUjhwbTFtYUdhSG83UFRKcVBN?=
 =?utf-8?Q?OdB69/giBAmm7l7bhWwrnUk=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 802764cf-c15d-43c2-6f05-08d9b26b406b
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4787.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2021 12:33:16.4281
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VV4T3YYEJD/+hQlj5casdy2Zd29cQRy12LrpN3fEc0Rb3CaeGwJpUPSyxb2N85TYimEsrCUwjes6UCqQXFApJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB0013
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/24/2021 08:34, Kai-Heng Feng wrote:
> Hi, Vitaly,
> 
> On Tue, Nov 23, 2021 at 11:22 PM Lifshits, Vitaly
> <vitaly.lifshits@intel.com> wrote:
>>
>> Hello Kai,
>>
>>
>> We believe that simply reverting these patches is not a good idea. It will cause the driver to behave on a corporate system as if the CSME firmware is not there. This can lead to an unpredictable behavior in the long run.
> 
> I really don't want to revert the series either.
> 
>>
>>
>> The issue exposed by these patches is currently under active debug. We would like to find the root cause and fix it in a way that will still enable S0ix power savings on both corporate and consumer systems.
> 
> I am aware. But we've been waiting for the fix for a while, so I guess
> it's better to revert the series now, and re-apply them when the fix
> is ready.
> 
> Kai-Heng
Hello Kai-Heng,
In this patch, we addressed additional PHY power saving. There is no 
point in trying to revert it.
> 
>>
>>
>> On 11/22/2021 18:19, Kai-Heng Feng wrote:
>>
>> This reverts commit 3ad3e28cb203309fb29022dea41cd65df0583632.
>>
>> The s0ix series makes e1000e on TGL and ADL fails to work after s2idle
>> resume.
>>
>> There doesn't seem to be any solution soon, so revert the whole series.
>>
>> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=214821
>> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
>> ---
>>   drivers/net/ethernet/intel/e1000e/netdev.c | 6 ------
>>   1 file changed, 6 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
>> index 44e2dc8328a22..e16b7c0d98089 100644
>> --- a/drivers/net/ethernet/intel/e1000e/netdev.c
>> +++ b/drivers/net/ethernet/intel/e1000e/netdev.c
>> @@ -6380,16 +6380,10 @@ static void e1000e_s0ix_entry_flow(struct e1000_adapter *adapter)
>>    ew32(CTRL_EXT, mac_data);
>>
>>    /* DFT control: PHY bit: page769_20[0] = 1
>> - * page769_20[7] - PHY PLL stop
>> - * page769_20[8] - PHY go to the electrical idle
>> - * page769_20[9] - PHY serdes disable
>>    * Gate PPW via EXTCNF_CTRL - set 0x0F00[7] = 1
>>    */
>>    e1e_rphy(hw, I82579_DFT_CTRL, &phy_data);
>>    phy_data |= BIT(0);
>> - phy_data |= BIT(7);
>> - phy_data |= BIT(8);
>> - phy_data |= BIT(9);
>>    e1e_wphy(hw, I82579_DFT_CTRL, phy_data);
>>
>>    mac_data = er32(EXTCNF_CTRL);
> _______________________________________________
> Intel-wired-lan mailing list
> Intel-wired-lan@osuosl.org
> https://lists.osuosl.org/mailman/listinfo/intel-wired-lan
> 
Sasha
