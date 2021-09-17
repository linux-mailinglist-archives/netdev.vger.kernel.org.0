Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4134640F3B5
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 10:08:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244250AbhIQIIz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 04:08:55 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:24579 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232441AbhIQIDm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 04:03:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1631865739;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KBIJbtxqpsvYfSGsoXWpkXUV/K2kqD11Dmr/jOFu7SA=;
        b=A+ss+0LKpGmwJ+YeZZtJOqiKQi9+Or2AzrQAcOGiFOoJiFPZH2SqIwV391CB+C/Nwvowck
        ST9la2FptIoBfLy2YubzOIkhysgSs1+yNe6zps7ocaBYuc3BtpsYE9xi6HeCODXhV2LiZf
        2iNtX9EEhRCw5BxwXDkkDHxlPNWc5mI=
Received: from EUR02-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur02lp2051.outbound.protection.outlook.com [104.47.5.51]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-23-CIeg8T_XOUKhUb9NNwS0Wg-1; Fri, 17 Sep 2021 10:02:17 +0200
X-MC-Unique: CIeg8T_XOUKhUb9NNwS0Wg-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SMpbiV15scZTEJKI9fg1XxaSWkfmDvG8fKretbzbYe4xaDgkUH/PnyePmClvRQ47psbibXLbi+qrLeeomrZzReqquBQfnrDoD+jSVJJ3xQwU1jS/BoM6mrgVXjqVgMYMgVK4qnZXj931FQv0TOnRvGl2xxApkgZEPMPMFEwqxD0SnuMFCWGofla1ssbwC+j7EUyongKqCau1IZIlCfOdKhNGUOBq/1s4kRGRaC78fM6VKvhnCrkTyKcoOnRubadSB7l4owRsX+QdHbje0uvnP200GbzYj7jUG0Ecv/ufSYIrVOp1oTgsCaUsVMIRGVLHUMVD9hFwO2nb7BWqNh19BQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=KBIJbtxqpsvYfSGsoXWpkXUV/K2kqD11Dmr/jOFu7SA=;
 b=L+vMOWoML8wk/S9nFgy2ls29nGzitw/c1vnDODE9gwCd3y5aMHmweNSdD7CWtvuA+PuEKOGkK6jc6aXIOZ6MmO6UHdl5kLUDdHw3Tcez8b4EGNzBpz98Q6f89XGoWltfY/sndrwsQnpDTJVQILH564U3vQoAAJMHwjHgHqDwQI7pHK0PDaZwao+/99E64+HZybprmyQOD2Ebg/cEyZnUKysV+aDqUKSYNjfXZEflnfUoR4iVgwNZYqr5KGN49GlDdGiWHkz0JoBAMK97fMNIFHSsnkMce27tQFclWiHBt3wn2A9sj0WlxIhfz8lXu4GIEz+da0GtVJz6Tgi1eiwNXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=suse.com;
Received: from AM7PR04MB6821.eurprd04.prod.outlook.com (2603:10a6:20b:105::22)
 by AM5PR04MB3042.eurprd04.prod.outlook.com (2603:10a6:206:5::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.16; Fri, 17 Sep
 2021 08:02:15 +0000
Received: from AM7PR04MB6821.eurprd04.prod.outlook.com
 ([fe80::78e1:ab2a:f283:d097]) by AM7PR04MB6821.eurprd04.prod.outlook.com
 ([fe80::78e1:ab2a:f283:d097%5]) with mapi id 15.20.4523.017; Fri, 17 Sep 2021
 08:02:15 +0000
Message-ID: <902ad36d-153c-857b-40a6-449f76aa17b0@suse.com>
Date:   Fri, 17 Sep 2021 16:02:01 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Content-Language: en-US
To:     Punit Agrawal <punitagrawal@gmail.com>
Cc:     Michael Riesch <michael.riesch@wolfvision.net>, wens@kernel.org,
        netdev <netdev@vger.kernel.org>,
        "moderated list:ARM/STM32 ARCHITECTURE" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>, sashal@kernel.org
References: <20210823143754.14294-1-michael.riesch@wolfvision.net>
 <CAGb2v67Duk_56fOKVwZsYn2HKJ99o8WJ+d4jetD2UjDsAt9BcA@mail.gmail.com>
 <568a0825-ed65-58d7-9c9c-cecb481cf9d9@wolfvision.net>
 <87czpvcaab.fsf@stealth>
 <aa905e4d-c5a7-e969-1171-3a90ecd9b9cc@wolfvision.net>
 <2424d7da-7022-0b38-46ba-b48f43cda23d@suse.com> <877dff7jq6.fsf@stealth>
From:   Qu Wenruo <wqu@suse.com>
Subject: Re: [PATCH] net: stmmac: dwmac-rk: fix unbalanced pm_runtime_enable
 warnings
In-Reply-To: <877dff7jq6.fsf@stealth>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR02CA0043.namprd02.prod.outlook.com
 (2603:10b6:a03:54::20) To AM7PR04MB6821.eurprd04.prod.outlook.com
 (2603:10a6:20b:105::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [0.0.0.0] (149.28.201.231) by BYAPR02CA0043.namprd02.prod.outlook.com (2603:10b6:a03:54::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Fri, 17 Sep 2021 08:02:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e6c8dd85-89ea-47c0-954e-08d979b17635
X-MS-TrafficTypeDiagnostic: AM5PR04MB3042:
X-Microsoft-Antispam-PRVS: <AM5PR04MB304250890A49BEF9AEBA957CD6DD9@AM5PR04MB3042.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: g5fnYkcpJBVhi23YDnVGl+0doRh9q1n1D+tOr4WwaNGi7Lf3SMWd0omYS7GsTf8YsTLudRoJXcdekXTPES7yqsPAA7TzwyPDM3JBhrAHH16XkcOOQM+bhZmdH+374tNEYjBob9fb/UmO2won4Vm7rZR8+h4IVbZgWUCJrXB/f+GQCSClaAwuvKwuGgBcpNo+ildbRdgjLXNRSx9LYwMtN0HovQ5377Dq0BdD0PauEu5G6MpYeooKDOIxqMn3J8uUeTKrWpH2A/WekOJWkqvtw2ItYbY0JexOjmF6HGgDwuQing5HNp8ugLQQVoeJggQJVTGHQlil4OCp56Z4qqhhezDLEOZMhUPZkY8qVjE8SHhVh4WNSaHw+oEBNo6bbqTn3glmwp3UYF1PdUIid2unUXWW0ZyACt+bI5f2j8Tia2d/ZUNbi4s6VHzZnQgbdrl+Rh1Vo5uPaEqN3WFuqQm41mVOrJ2IAOR4Pyt6NohW0vA1fxn8tqG7iJckkGdyCUZkqVXMtVg2QZr8bf1FIBqT/d7YoCnsnbFz+y9rkEZ8+2Lb7tdZk4fOL4QDsym6q+5hXgTnpyiTuPg+BtLXCqtIrbU0FqDe4LDZuvZEAM2e01RxrEs/pgIAdKiDXhrlKJX9/Z1E7oq+iU3U7BeiRA2r9ro1plnu7UfBiY65hFN7KnuDP0+pBMdygbVKimGBktd6dOPIIPDgTxpF22lNW8a11vYfTAxs/BAFc9eTndPQQzlThT8XllYSBAEu5lkbkUrl
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM7PR04MB6821.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(39860400002)(136003)(376002)(346002)(36756003)(6706004)(38100700002)(6916009)(16576012)(31696002)(956004)(26005)(6486002)(66476007)(66556008)(66946007)(478600001)(53546011)(31686004)(186003)(7416002)(6666004)(86362001)(8676002)(4326008)(2906002)(2616005)(5660300002)(8936002)(83380400001)(316002)(54906003)(78286007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eFFxTHR6VjUyeFIzb1FlWDlYMjEwaCtaTzF4QVZlQlczbTVmVGRTQklQT0xv?=
 =?utf-8?B?L3F4TjhHeDdTMGJyTnY5Z052TDRlQk5waS93WFJRdjNSdUtFOTdVK3pOUnVB?=
 =?utf-8?B?L0NkcitXc21ZTXlHM21TRE1rVUlIYXR6Q1lVL0MxUVdKcVlHM3p2WHVIVTF3?=
 =?utf-8?B?ZVR1OFRpMXZ0bjIzT1pQd0RiY0ExNW02Tk1nb1hHMlJyWlR3c3BGWlgvT1I2?=
 =?utf-8?B?bWJDNlFCMm85bmdoT1h1bHdSZ3E2Nm1tTTd1alZheHo4NDgvOWFNUlMvMDZP?=
 =?utf-8?B?SENvTjlwUHdPWGwwcy9QajJNSTlDQm9LZXRqL2RBaWVhNDI3eGw4ekdZVnVi?=
 =?utf-8?B?ZE44eHBBVk0xOFlJaTI2akRheHFNMkNJY1FaNG80cWtCRnNPMjZNNmZna0dR?=
 =?utf-8?B?Vm5qU3ZEZUVsbTdwZ3Z6c0VOS0l4RmxtenNDRmdPVkZmYjM0L0JTWE9rUEh0?=
 =?utf-8?B?dzR1SU5MOHlQeDJUSkFNS1FnV1lCRm8xM0Q4bmUyUXJxRmd0ekJaYVF1KzhC?=
 =?utf-8?B?YjdZdHpKdWN1QkJFcTNrdVV3UlM3WndSdm8xVHJuYkZYM0QwZlN6aWQ1UXp4?=
 =?utf-8?B?bXpUYnJtQStJK1FxWjFuSFlSQk1CV014MzNJTElicUNuUUdmZnliYm1zZ2Z4?=
 =?utf-8?B?SnFyeFUzVXFiVE9ROHhpWGZJSDRzZ1B0dlRBVHBDVlpneXgvR3RnNi9jRStM?=
 =?utf-8?B?emZwOHU5dldhUTB3K3o0TDVOK08zZnVPeDBaRGJpTGNmQXp3ZGRjK1I0YmM4?=
 =?utf-8?B?b3IzV3lmTytJVWFNVWZHMXhDYVZZVm1EbkNma05CNmdhaCtuTnIvNDUwOFJU?=
 =?utf-8?B?RVRGaURRenR4YlFWbFJua3NjNStRTmlLQTZrb25LTWxZTlFzU0hITlZxcE9k?=
 =?utf-8?B?WngydU9hL1pGaHBhNjljdnRMRnc3dFJDVmZQYzNyenNiQ1k5V1dRWS9xT0RE?=
 =?utf-8?B?L0p4by8vcUpuMU9mdlpGY0dHQ1JiazhaaU5WdThUVklSSFk3MVdBcUZCd0hm?=
 =?utf-8?B?cUNsUDhXa0dyTTVzTzhOZ09NV3RjejF4aGJWaUZkNUVZWXdWUVFDaS9GL09H?=
 =?utf-8?B?L21oTVBvUjRyajhKNWRkL3dmekt1NTJoakJPV2NINXVXaGpkQ0xDZ3NMeFZQ?=
 =?utf-8?B?eENqaHVYY3hidHJPL245MzNvcnNBZlFZWmFRaVFCZTlGdlF2cXVHZlFRaTI5?=
 =?utf-8?B?YWpWbTVwb0ZqcERGOUxhUWtkTTF5RU9WWkhHZVA2empSMnNUMjRzOW83VUUv?=
 =?utf-8?B?YzRpNkR3NENKb0JqVEhVZ3g0aUdRZ2MydjlLcnExK3BsOW1TMmI4ZVY3K1ZC?=
 =?utf-8?B?dWNRTlRja1dIdU8wdGJyQWVSSTFZVnR3UHprcm9aLzhsY2o4SnNxN2pZdmZO?=
 =?utf-8?B?Q0pnYjdBaGprSlRhODdobEJlM1diZTJIdEw3dmVlTml3RHhaUy9QNDNLWHhR?=
 =?utf-8?B?djZXeE1TNzFSdlhNOWpuYU9hdmpzVno1cUljb1RzYmIxeTRPY0lVQWsyMnlj?=
 =?utf-8?B?S0oxeWFxei9MQjEwU0JnSGx4SzJid1FiY1ZXd2FyV1FPKzVZNkVmcWFqSDZi?=
 =?utf-8?B?RmNDZmVVc1NGRURiRXFSb1BNc0tSSGFUbzA4YkMxckZsVUs3SGY5MjlpMEpu?=
 =?utf-8?B?NW9rS3lxZDR4eWVycjg4MFBVZjBaS0hCcC9KWlNZdXIvRWNRN0k2TGJkNlpX?=
 =?utf-8?B?dHNRdHNkd1lkNUpqK3NncGFlWWNHQzFDSkxoRUQ2bk5JVXFDY0x0TjZtTVAx?=
 =?utf-8?Q?Sy0kEyr0m7Kki6XLsxZ+6PrCKlF8UCi25R1SSkL?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6c8dd85-89ea-47c0-954e-08d979b17635
X-MS-Exchange-CrossTenant-AuthSource: AM7PR04MB6821.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2021 08:02:15.2267
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i0PkP6Q0r8r3rZiC0KXx1fqdvzVqSnmQZjkDYDlXwAbNiGmEPvPbDR26NjmDclCF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR04MB3042
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021/9/17 15:18, Punit Agrawal wrote:
> Hi Qu,
> 
> Qu Wenruo <wqu@suse.com> writes:
> 
>> On 2021/8/30 22:10, Michael Riesch wrote:
>>> Hi Punit,
>>> On 8/30/21 3:49 PM, Punit Agrawal wrote:
>>>> Hi Michael,
>>>>
>>>> Michael Riesch <michael.riesch@wolfvision.net> writes:
>>>>
>>>>> Hi ChenYu,
>>>>>
>>>>> On 8/29/21 7:48 PM, Chen-Yu Tsai wrote:
>>>>>> Hi,
>>>>>>
>>>>>> On Mon, Aug 23, 2021 at 10:39 PM Michael Riesch
>>>>>> <michael.riesch@wolfvision.net> wrote:
>>>>>>>
>>>>>>> This reverts commit 2c896fb02e7f65299646f295a007bda043e0f382
>>>>>>> "net: stmmac: dwmac-rk: add pd_gmac support for rk3399" and fixes
>>>>>>> unbalanced pm_runtime_enable warnings.
>>>>>>>
>>>>>>> In the commit to be reverted, support for power management was
>>>>>>> introduced to the Rockchip glue code. Later, power management support
>>>>>>> was introduced to the stmmac core code, resulting in multiple
>>>>>>> invocations of pm_runtime_{enable,disable,get_sync,put_sync}.
>>>>>>>
>>>>>>> The multiple invocations happen in rk_gmac_powerup and
>>>>>>> stmmac_{dvr_probe, resume} as well as in rk_gmac_powerdown and
>>>>>>> stmmac_{dvr_remove, suspend}, respectively, which are always called
>>>>>>> in conjunction.
>>>>>>>
>>>>>>> Signed-off-by: Michael Riesch <michael.riesch@wolfvision.net>
>>>>>>
>>>>>> I just found that Ethernet stopped working on my RK3399 devices,
>>>>>> and I bisected it down to this patch.
>>>>>
>>>>> Oh dear. First patch in a kernel release for a while and I already break
>>>>> things.
>>>>
>>>> I am seeing the same failure symptoms reported by ChenYu on my RockPro64
>>>> with v5.14. Reverting the revert i.e., 2d26f6e39afb ("net: stmmac:
>>>> dwmac-rk: fix unbalanced pm_runtime_enable warnings") brings back the
>>>> network.
>>>>
>>>>> Cc: Sasha as this patch has just been applied to 5.13-stable.
>>>>>
>>>>>> The symptom I see is no DHCP responses, either because the request
>>>>>> isn't getting sent over the wire, or the response isn't getting
>>>>>> received. The PHY seems to be working correctly.
>>>>>
>>>>> Unfortunately I don't have any RK3399 hardware. Is this a custom
>>>>> board/special hardware or something that is readily available in the
>>>>> shops? Maybe this is a good reason to buy a RK3399 based single-board
>>>>> computer :-)
>>>>
>>>> Not sure about the other RK3399 boards but RockPro64 is easily
>>>> available.
>>> I was thinking to get one of those anyway ;-)
>>>
>>>>> I am working on the RK3568 EVB1 and have not encountered faulty
>>>>> behavior. DHCP works fine and I can boot via NFS. Therefore, not sure
>>>>> whether I can be much of help in this matter, but in case you want to
>>>>> discuss this further please do not hesitate to contact me off-list.
>>>>
>>>> I tried to look for the differences between RK3568 and RK3399 but the
>>>> upstream device tree doesn't seem to carry a gmac node in the device
>>>> tree for EK3568 EVB1. Do you have a pointer for the dts you're using?
>>> The gmac nodes have been added recently and should enter
>>> 5.15-rc1. Until
>>> then, you can check out the dts from linux-rockchip/for-next [0].
>>
>> Do you have the upstream commit?
>>
>> As I compiled v5.15-rc1 and still can't get the ethernet work.
>>
>> Not sure if it's my Uboot->systemd-boot->customer kernel setup not
>> passing the device tree correctly or something else...
> 
> For the RK3568 device tree changes, I think the pull request got delayed
> to the next cycle. So likely to land in v5.16.
> 
> In case you're after ethernet on RK3399, there's no solution
> yet. Reverting 2d26f6e39afb ("net: stmmac: dwmac-rk: fix unbalanced
> pm_runtime_enable warnings") gets you there in the meanwhile.

Thanks, currently I have seen other distros like ManjaroARM is already 
reverting that commit.

But even with that commit reverted, I still get some other strange 
network behavior.

The most weird one is distcc, when the RK3399 board is the client and 
x86_64 desktop acts as a volunteer, after compiling hundreds of files, 
it suddenly no longer work.

All work can no longer be distributed to the same volunteer.


But on RPI CM4 board, the same kernel (both upstream 5.14.2, even the 
binary is the same), the same distro (Manjaro ARM), the same distcc 
setup, the setup works flawless.


Not sure if this is related, but it looks like a network related 
problem, and considering both boards are using the same kernel, just 
different ethernet driver, I guess there is something more problematic 
here in recent RK3399 code.

Thanks,
Qu
> 
> [...]
> 

