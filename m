Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C1486DC23F
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 03:04:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbjDJBEx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Apr 2023 21:04:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbjDJBEw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Apr 2023 21:04:52 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2079.outbound.protection.outlook.com [40.107.93.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F06430EB;
        Sun,  9 Apr 2023 18:04:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FTt804NmkF64CSe3rUxKiF6b6CVv269xFNyQK10kfoD7kGmBRXpgsXfLeEZAsTG57uzy4sHW4vXriNBhzdmz0LVtlgvqUlcR+SOWVYh+sw9NSJvpOiSUlJtVti1xyfspSFX7PuaKb8A22BiclkUF3dwmFy2wyuE4cqqDRDBylASEWByFpBxC0xwPkc8X0XYQlDaDizUioUpbWVsifMMrvUEUPQVREJck0sm5RbiTsh8jjZXKlqtmYMgg8vDu89tDrNm9yqCI+6YQhZOhUPzwsaAZtxqlQV1i1oIbEyIymvFxZN6cYhdq7C9pSiZoPA2yp3/L8X45URRjGDsybXrzTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M5XKv8uMK514+ziVeJ6GyfgluEG1G99Ix2mUUbN+l+k=;
 b=XGTXbaik2UgpYfk6F4v6t1aWndZrwrPlLLC05gVqllZ3tMfIfEFyhWT/8JpGSTz7M5lLSY1f8jB9PpfibeWv1Xko8whfRyz46cBNSEenv/O3ubAfSp8E732+Ps3AgFrnpGN1phmVHLIRVW7zt7Sp4PBVOczvJAK3aR5uWpWX1Ecz3b1QMwS9TuvarnKPBVfmmN7yVcW2Vsnk1pWZw6FMqIkdjd086Mo8xUxM3tLyUly17n1xOvhKbyou2NaVw3hYeUSvgVVFRMG+ZWwRqQFMGDy9KS0gWdZtuxbxgr7D9gjv2j2+CSEoJpL7DTTkMlnXaSUlDFLr/m6V48p01pXQbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M5XKv8uMK514+ziVeJ6GyfgluEG1G99Ix2mUUbN+l+k=;
 b=AnmjFL8tUO80UgCkaTq5TpfXsCpz009W5bFBGRBY9XQd/UPxw1g/P2AFf5nFroA4jwmNYomuU6/DPv0xp3U/hcqAcxFlh38pElavhqzRZWiiGvnYs/4Xbm6bG15caj0ED6OoK2AINlcN6d/L//mI4QozJMKrg4yP7CPGCGCfOTw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MN0PR12MB6101.namprd12.prod.outlook.com (2603:10b6:208:3cb::10)
 by DM4PR12MB6543.namprd12.prod.outlook.com (2603:10b6:8:8c::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6277.31; Mon, 10 Apr 2023 01:04:47 +0000
Received: from MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::f4d:82d0:c8c:bebe]) by MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::f4d:82d0:c8c:bebe%2]) with mapi id 15.20.6277.036; Mon, 10 Apr 2023
 01:04:47 +0000
Message-ID: <cf823f67-e220-ea93-9124-a04020e48581@amd.com>
Date:   Sun, 9 Apr 2023 20:04:43 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH RESEND] wifi: mt76: mt7921e: Set memory space enable in
 PCI_COMMAND if unset
Content-Language: en-US
To:     "lorenzo@kernel.org" <lorenzo@kernel.org>,
        "ryder.lee@mediatek.com" <ryder.lee@mediatek.com>,
        "nbd@nbd.name" <nbd@nbd.name>
Cc:     "shayne.chen@mediatek.com" <shayne.chen@mediatek.com>,
        "sean.wang@mediatek.com" <sean.wang@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        "Tsao, Anson" <anson.tsao@amd.com>, Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Sean Wang <sean.wang@kernel.org>
References: <20230329195758.7384-1-mario.limonciello@amd.com>
 <CAGp9LzrkX4uFAtLwvjH+uUuRgT_YDg3eE8SqgWEXOFmw5r=aMQ@mail.gmail.com>
 <cdf612bf-96f6-9b4e-a32c-50007892083c@amd.com>
 <MN0PR12MB61012EEFC07D4FAE534C1323E2929@MN0PR12MB6101.namprd12.prod.outlook.com>
 <CAGp9LzqWna+BU_F-=zxCmo62616Jjn2pXQG-Zk43Ax13zRjF0Q@mail.gmail.com>
From:   Mario Limonciello <mario.limonciello@amd.com>
In-Reply-To: <CAGp9LzqWna+BU_F-=zxCmo62616Jjn2pXQG-Zk43Ax13zRjF0Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN7PR04CA0229.namprd04.prod.outlook.com
 (2603:10b6:806:127::24) To MN0PR12MB6101.namprd12.prod.outlook.com
 (2603:10b6:208:3cb::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR12MB6101:EE_|DM4PR12MB6543:EE_
X-MS-Office365-Filtering-Correlation-Id: d103758d-37a3-476c-bf37-08db395f93cd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hWhhTkGs0ZTrdypbGGBXiZUVixlEWtN1orms1xdFgpwm8yJho2tzHDGLTrmdvFlJxSrj3ymKA2gMAHYsbqhrw9C6u8pwbpxZaav+bs9ph6G9RSLxHnBcRLcRHC+7+22He0RY0+aTLj6LnoFgsZRkxEwwupb3zl0MCT+GHpk43R4kvBPm/cMa5VkUQOShPVsdELnUbMOowEhH/v66BrdYqyghehGqdKZJ12z/erE3drQB+Y4NyKOuzQ9Q8J1+GqKSru1aFZyrOMwIsQG7WcyiwLAJppxBjnIK0avY+ZFzd0AQcM1TZ4+XWbE51KcExVDzc+mJ8WqSuMCXFN2piwZDn0sRW+k10fzh9L5WxtoKks3S3/O2fHKaw8413z+zccwoxGB9vYoMWP/nvMlDeNuulDPl1AEzDmtTjtgECXgDBWufMkU+unY7b2MPMMYr45R5wV4V7JLPOZbYWGgFlMZA7JgwA3TxpJBAM4ujAl6790kft+jhW0HEK/NMLexxGvf+yi3Jt2C86P0XkKGPZ76BivWxKs/9ezFNYWGsblOlVe74rFq+suOytGFcjT3YFz2l5IaE8nhNLAE6Jj+nTAJexvn2hwMBhP7yvlw37bLId7kJmVBZ+A5rGmmcwwqkM//17po+9BUdXPsklJeOGBvxoA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6101.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(366004)(376002)(346002)(39860400002)(451199021)(31686004)(38100700002)(36756003)(86362001)(31696002)(6506007)(8936002)(44832011)(110136005)(6486002)(966005)(5660300002)(7416002)(478600001)(316002)(2616005)(53546011)(186003)(66556008)(66946007)(2906002)(54906003)(41300700001)(6666004)(6512007)(8676002)(66476007)(4326008)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MUh3VGxJR2k5MkVJZm10YWdGTld5cm1wMUZyR0kyMGYyQmlNY3BONTMyQjZT?=
 =?utf-8?B?RWk2RUl0OEhLbDNtOFRZTExCQ2NZMGN5UkRBeUtPQVZUclh4NVZqOWJxOGZX?=
 =?utf-8?B?NU1QRVdJSENMSXNIMWJaczc5ZnY0YTdWRGFucmpkak5zcUVtT085RUlwZlR3?=
 =?utf-8?B?TnBGRlkxS25lYTI2WXN5MFBVa3pRSWhzVER2WVcxdU9iTkhEWWN2VE12RUZq?=
 =?utf-8?B?MlRwVnY0NGJqT3NJamxBYXFzb3ZDUXVoakZKOGpXanVuc2xpUy9ad0orNXZ1?=
 =?utf-8?B?NlVWRDdzQmdNZGxqb1FDb1JEREFlWGhEQkNnVHdFa2xkK0E2N3hMd0xMSzZ2?=
 =?utf-8?B?N21icWlRN1dKQUppMUhHdnNpT3lJU3dCQzhwL0NCK3JTWlV5SWFCeHUzNU5V?=
 =?utf-8?B?c3VLV2hqWVI2K25hbXdjRVlsZkRKcjNHZnhBVWNPSzdKVWI5dnhMMTNQTHBn?=
 =?utf-8?B?TFR2S2I1SFBxWWJUcDhKcnh2d0tJYWdXVU9vWUJzc0lDWXVHSGx6cGNVSnFR?=
 =?utf-8?B?Z0p6dS80NUlLS09qdUMzQTF4UHhlOEcwblc5ek5CT1cxZkJ5akhNMGZ3akZC?=
 =?utf-8?B?WTJLeGlsa0JiN25ITjl0OExoem8vQTZzUm5vN0NmZ3BWaDJ1a3h4Z0hzcGw5?=
 =?utf-8?B?YlRnRVlOYVpaa0VuSnZZaFJPTDRoVE1IZU01QXg2eHdTdWVyaXQybGFOU3My?=
 =?utf-8?B?K1Bkc05qYjNuV0s2aWcva0J1bERya0VUUjZETDJvdWVmNHJHbno0Y2swMTRZ?=
 =?utf-8?B?eHhuMEQzZ3M4RXJMU20vdHkvNHJvK0UyQXQ2YVZtbjFRQ1lybWxBY2toMnVU?=
 =?utf-8?B?bFdKZ3RsZTcyY1BLWmRFZEg3T0hIV2dQSDZxYVJ5QVYraTgxSS9XaDBhU1N5?=
 =?utf-8?B?aUx0dWpvQkFmR0svVUVSL2pNUUZrN3lmWkhKeUE3dmlMVUtMRktHa1ZQQ3ls?=
 =?utf-8?B?d3pqQ3ZEV1JWL1VzVjQvWUhEakUxTVYzUFEvbU9Xd3ZBNlJ2VjYzTHBIRkRx?=
 =?utf-8?B?d1RpWGw0SjlVZ1FVNFUyL0VyR2piNDlCUlR4VlFmc3NGWDVpa1pUVm5wWWpJ?=
 =?utf-8?B?dFo1SkM1OG9oeGh6ZDFpNENWY1luTnNaTGd5WUplZGZkWEgzZHBDb2FabDVO?=
 =?utf-8?B?dnBxTmtIS25WYXlZcmlydVhzZkIyMlZyUkU4RE9MTFBWdDFjZ1Q4Z1RuOHNk?=
 =?utf-8?B?aVQ3VFpDa1FKRWdlM3UvN1A2eHdOdVRvVFAxMHJWSzJERWV4RTV3WGtBU3pl?=
 =?utf-8?B?OUxxOW8vendldnEveGxocW5JMUx4d0VweTZHc3F2NWF2cnJ2bWhVY0IwL1Ey?=
 =?utf-8?B?UlVIb2dKMk9lc251VWZmU3BXd2lqVEQ2czY3ZXhUa2U2UjhZenNLbHZVTFp2?=
 =?utf-8?B?dHZydHY5bTVpeXcvVnVwT3NVWXZWMDhpeUwvRHE4WlgvYS93YkJrVG9ubHlx?=
 =?utf-8?B?REZKQ1ZnNUYvUkhDM2JIcVRxZW5iV1BEZXhDUnI2VE04WEhmSnE3T1NqaTVx?=
 =?utf-8?B?bXY2VllJZEpwZmFwZXVMeDBxTG5ROTlBUDFHdjY0VXlRR2lmNlFjWkFVTmYx?=
 =?utf-8?B?cUlRa2dGaExIcXNKMmNLTGx5WjZWWW91eXJvQkZPanZoVDU4YldsYWVKREtM?=
 =?utf-8?B?YmJLU01UVFVXWXhzS3FEbDVoVXUwdjJrS2FYbno1SWZMTWtKVmNLZWk2WUVr?=
 =?utf-8?B?cmFmdTdrWWhPRDBzZzlmUWV1ci9Ld0d5N0NEYVMvTHF6YUtheHJxTzNSazEv?=
 =?utf-8?B?d244UFdURGFWbFlUMG9PQy8rai9iTzVVODRKSnNsOHFCT0p4ajlOVG1hUStD?=
 =?utf-8?B?dzdyTUdxcXVUdG1GY0hoWlNDQUJ6WU11Q1UvTVBLWTlIVjcxM1R5MVFEUStr?=
 =?utf-8?B?VXQ2bVppQlRiM1NFMFZKVmFKUjE5cDVUdlBXMS9hV3RMeExlUUxVSllsL28x?=
 =?utf-8?B?QVR3MWJaL0laZzBzVm41S0t2T0wzMVYzK2loNnBBMDdSMFBnK2pFdWs0eDh0?=
 =?utf-8?B?SlBJRmN5S2tkSUhxQXM3cDVlRTFLc25zMjdnTk9TMUlLWEZTMnIyZkxJdEZl?=
 =?utf-8?B?eEYzQWp1Ykt3WDJKOVNjL1p4N2EvdzJZVmN5bVBpQWxRTlBVYnphdmFaczZT?=
 =?utf-8?B?d2hiN0ROdkFIU2U1Nk45dFFlWXJGQ1c4eWVGc1RyN1hHZml6Uzl2bkI4NS8x?=
 =?utf-8?Q?dwf9H9A50e4IkOmMK6AgzDrdBt6gKLDXBK0qqmr1ebw3?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d103758d-37a3-476c-bf37-08db395f93cd
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6101.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2023 01:04:46.8904
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v3PCoqGquQGRwNQyYRwEV3ZhxhKzZwkkvm2CI3hcUofAlE7y0+khZc1dLK1HVM+SP7fJlUkjzETybyxdR9rsPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6543
X-Spam-Status: No, score=-3.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 4/9/23 19:57, Sean Wang wrote:
> On Mon, Apr 3, 2023 at 6:42 AM Limonciello, Mario
> <Mario.Limonciello@amd.com> wrote:
>> [Public]
>>
>>> On 3/29/2023 18:24, Sean Wang wrote:
>>>> Hi,
>>>>
>>>> On Wed, Mar 29, 2023 at 1:18 PM Mario Limonciello
>>>> <mario.limonciello@amd.com> wrote:
>>>>> When the BIOS has been configured for Fast Boot, systems with mt7921e
>>>>> have non-functional wifi.  Turning on Fast boot caused both bus master
>>>>> enable and memory space enable bits in PCI_COMMAND not to get
>>> configured.
>>>>> The mt7921 driver already sets bus master enable, but explicitly check
>>>>> and set memory access enable as well to fix this problem.
>>>>>
>>>>> Tested-by: Anson Tsao <anson.tsao@amd.com>
>>>>> Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
>>>>> ---
>>>>> Original patch was submitted ~3 weeks ago with no comments.
>>>>> Link: https://lore.kernel.org/all/20230310170002.200-1-
>>> mario.limonciello@amd.com/
>>>>> ---
>>>>>    drivers/net/wireless/mediatek/mt76/mt7921/pci.c | 6 ++++++
>>>>>    1 file changed, 6 insertions(+)
>>>>>
>>>>> diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
>>> b/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
>>>>> index cb72ded37256..aa1a427b16c2 100644
>>>>> --- a/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
>>>>> +++ b/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
>>>>> @@ -263,6 +263,7 @@ static int mt7921_pci_probe(struct pci_dev *pdev,
>>>>>           struct mt76_dev *mdev;
>>>>>           u8 features;
>>>>>           int ret;
>>>>> +       u16 cmd;
>>>>>
>>>>>           ret = pcim_enable_device(pdev);
>>>>>           if (ret)
>>>>> @@ -272,6 +273,11 @@ static int mt7921_pci_probe(struct pci_dev
>>> *pdev,
>>>>>           if (ret)
>>>>>                   return ret;
>>>>>
>>>>> +       pci_read_config_word(pdev, PCI_COMMAND, &cmd);
>>>>> +       if (!(cmd & PCI_COMMAND_MEMORY)) {
>>>>> +               cmd |= PCI_COMMAND_MEMORY;
>>>>> +               pci_write_config_word(pdev, PCI_COMMAND, cmd);
>>>>> +       }
>>>> If PCI_COMMAND_MEMORY is required in any circumstance, then we
>>> don't
>>>> need to add a conditional check and OR it with PCI_COMMAND_MEMORY.
>>> Generally it seemed advantageous to avoid an extra PCI write if it's not
>>> needed.  For example that's how bus mastering works too (see
>>> __pci_set_master).
>>>
>>>
>>>> Also, I will try the patch on another Intel machine to see if it worked.
>>> Thanks.
>> Did you get a chance to try this on an Intel system?
> Hi,
>
> Sorry for the late response. We have tested the related Intel platform
> and it worked fine. You can add the tag from me like
> Acked-by: Sean Wang <sean.wang@mediatek.com>
>
Thanks!

Felix, Lorenzo, or Ryder can you guys please pick this up?

Thanks,

