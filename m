Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AA046D07CD
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 16:13:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232171AbjC3ONs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 10:13:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231983AbjC3ONr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 10:13:47 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2075.outbound.protection.outlook.com [40.107.212.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2F3483CF;
        Thu, 30 Mar 2023 07:13:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bal+jSeaPz58sAO9sB9OFPo+ndz+tZ0sBZ8iJm0DSRE3msJIBM3jECCFINqr4srjVtavUibLpe6TScX/ipQ8NclzcfQ1aViVrsnS89y9spaE4u7qwjQxpkoSf9fnipWAZPb+h0ZzhlVk0cmUDFrpLTFsf0NmbGVsym1ftETnklSXGNW16I8ulepeM5eS6hVvS75A0CsMrlvZOCAY8PuHW/FYqAiAMnzgSOY9Q5WpInpfzYaitT6GI3De7l9whJkUmMyTlE4r2tZutVf7w7aOI3s3xGORK0LbsUcnygkM82SydTDCtBtjoyRr9dtT9X7aQsKqD8awcwrdXKwMH3BwPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x0R+1O0pWNaXE5gSsjT3kTitnKX2vvbO1/3fcTbc27c=;
 b=QV7j/vR+lRUCd62gq0I+uYujO1cI2y3f3feboq7/0eBb8wR+zaGJop30P9HF1U67kJQDbGgOVkxjxjgWtYu/EdMMBT9xUMVuSJZQLkFj4F2G9yTwFYUgOhi9Xe0swJNi4ZVJHauwR9zQyQzEs93ne8+EDyfcDlL2oY5GK4vQWrp5D+rsxGRsgRm39OR4hNiW224xYelgetk/Z4ASXV99gA5nPJ/ZLikOcGHunakU3g6ug7riFYjXm/Gmjdd1nKIsEb3Xz2NmZHN9sBJF5wDQdx2VIw69saW/iLu+wRRJ7WqGecgWxijwozsgNX5KWdXdxkcwNBP1IAq5i2jkcrDGZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x0R+1O0pWNaXE5gSsjT3kTitnKX2vvbO1/3fcTbc27c=;
 b=QaEhptnx/+WCw2YxbOh9dk4HhK5+Emt6Vg+Hj1D9/84Xm7KqVeSTg21mRHBRhqFF3kHGKp44Fwi5PwxgjhX6PDRwPQ0rjBhOjGTNj/Y/3Y9unbs4WptV9wM6JGrdyDZx/gkSHy/a01t7PxN1pgfjrW1XWPj/U3/bAtmLJi3jVhE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MN0PR12MB6101.namprd12.prod.outlook.com (2603:10b6:208:3cb::10)
 by SJ1PR12MB6052.namprd12.prod.outlook.com (2603:10b6:a03:489::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Thu, 30 Mar
 2023 14:13:42 +0000
Received: from MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::f4d:82d0:c8c:bebe]) by MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::f4d:82d0:c8c:bebe%2]) with mapi id 15.20.6254.022; Thu, 30 Mar 2023
 14:13:41 +0000
Message-ID: <cdf612bf-96f6-9b4e-a32c-50007892083c@amd.com>
Date:   Thu, 30 Mar 2023 09:13:37 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH RESEND] wifi: mt76: mt7921e: Set memory space enable in
 PCI_COMMAND if unset
Content-Language: en-US
To:     Sean Wang <sean.wang@kernel.org>
Cc:     nbd@nbd.name, lorenzo@kernel.org, ryder.lee@mediatek.com,
        shayne.chen@mediatek.com, sean.wang@mediatek.com,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Anson Tsao <anson.tsao@amd.com>, Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20230329195758.7384-1-mario.limonciello@amd.com>
 <CAGp9LzrkX4uFAtLwvjH+uUuRgT_YDg3eE8SqgWEXOFmw5r=aMQ@mail.gmail.com>
From:   "Limonciello, Mario" <mario.limonciello@amd.com>
In-Reply-To: <CAGp9LzrkX4uFAtLwvjH+uUuRgT_YDg3eE8SqgWEXOFmw5r=aMQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH2PR18CA0059.namprd18.prod.outlook.com
 (2603:10b6:610:55::39) To MN0PR12MB6101.namprd12.prod.outlook.com
 (2603:10b6:208:3cb::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR12MB6101:EE_|SJ1PR12MB6052:EE_
X-MS-Office365-Filtering-Correlation-Id: 06c18fa4-c381-43a9-8bac-08db3128f6af
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qiXs0ZwJ0zijikN11Rr7P2FN1YXwEtS2/UGbQvewMGhYwNh/HXQeMEr7Q1GCmUjYm2BJcLOpX/zT7aWnYnleYshfURJaWzLktoiuKbCzJ5JvKxbR1zy6u5hlWy1Jcr+9Lny6KkWb/zXXdSk4pZVmcRSGlc3gb7+Z+VZbTbOYkDHdaOhXQC+wDdjg3UqqLIlt1xbaNsHUb9mlBH4CTeLL9CSDxl3Ft2qQmIs/l68tzz9rxSY2qnM3pY6qEgCqQYzdnGhTN/l5ReH2Ul0XBR+jQI0cz25ga7gZa/7PMF6ZLD81hyKjkYmx+jMdBCEpk+QyAl3GW6PuD3VTt0TV4uHlGLKzXADNz6WdIt0P2fkGTYUJiu5DS8zE/5S+uK42X0cUydZR5DneunBPurVK1xhqV8td/Svc6171yRGbpCc/yoKIgYCOTk/UJ5KCLXZNjNPX5+BGP1NKTirlNUUuNbsAD+1hgKE4GMKt+wZ6kU/zKqkWl0izcS44QsWW+l7XzjbIFypWoEumr1soqLElnpw+CE+oExqI4HiR2j+3XWuGc85cll/hmiyMi55SLZPKN1FI1jBeEzlQHX55XYl8FFYBIlM0mHYNX0wLZU02D0eqtSTirW+dtVkJode5/fcKFgTz5u9/Rk3N5wDdybBXYV6sog==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6101.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(366004)(136003)(39860400002)(346002)(451199021)(6512007)(6486002)(83380400001)(31696002)(31686004)(54906003)(66946007)(7416002)(38100700002)(26005)(2906002)(86362001)(316002)(478600001)(966005)(8676002)(6666004)(6506007)(36756003)(5660300002)(2616005)(41300700001)(66476007)(6916009)(4326008)(186003)(53546011)(66556008)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RkZMcEJ2Ui9QVzEzVEZteGMwVFJzK2NXMDJWR3ZkYkVabTVHM0xFMk9nc3or?=
 =?utf-8?B?bDM5YjR1UmFVRVhyYkliRHBMVGVWVFczcTFJbEtZeHByNTdkK3hrTkpsTnFl?=
 =?utf-8?B?MXR0NStYSnMrWXpyN01ZaFJQT00vYjMwNGx4MDJVeUJSZkhRM3d2a0RoQ2Ja?=
 =?utf-8?B?UGJ0czdFYlhZSWpzOTNBUnErc3JYZDBHVDRhSFQ1T1E0K2VwMlVXL1J1RGlT?=
 =?utf-8?B?WUk0MzcydFJKV0FmUmNUeVB1Umpaclo5SWJZbHltRzczV2ZSTExFOExFQm1q?=
 =?utf-8?B?amFYRFFtUDJnNytKM01LZS9VT3M1L1hyZXZ0UXB5VUxrQktRdllJcUlUNE9w?=
 =?utf-8?B?T0hVNTM5NFRpcVMwUm1MNDR1Tm1iQzFteWVlVGNpdWVhZTcxeE1XNGZxRUky?=
 =?utf-8?B?TC83UW81YWFOR044Y3g3VnRhUXR3MVlnTTVMYmdqTWZnaHFvTWRjcVpuQm5T?=
 =?utf-8?B?SjZQTUUvM3k3b2J1RVd4YWQrNjhYT1N3RHpCNHBwZkNSQXoxSFc5N1BpSnhs?=
 =?utf-8?B?enJrY25Jc1JrRk5DYUw1eXVMZ2w0TXNvS1VhS2hVU1BuQmY0VDB3aUVzNURO?=
 =?utf-8?B?Sm56eHk1REJCNFBKVlRvWGtFOHZhUklpY1NtUDZMaWp3MXpBbmE5MjNrTzNV?=
 =?utf-8?B?cVZ3QlUzQjQrNEFhMXJnK0JRbnlUbFk0UllhSDFQWldpTWRJMGk1MnNWYTVl?=
 =?utf-8?B?UCt1Skp4Y0xlVUtjejlRVklRK3lNci9MQkhGVE8wbU9Ed0g1Wk5GWmVKU0c0?=
 =?utf-8?B?RHpRWHl6ZGp4T1Z5cjVCVnlkWnlIcy9BL085L3FPcXRVTi93Vk9hVkRnakl1?=
 =?utf-8?B?OGMvMTZtRmVma1phUHE4WlF6MmhxNVpiQkM4ODl0MjRpL3hTSlI3NC9FL2Z2?=
 =?utf-8?B?TlhZbFdwVUh2YzJYQ1hhbUJTQ09hVjIyQVA5Zlpwd0JhOTZxY1NQVjAyeG0v?=
 =?utf-8?B?UFl4QzRNc1ZkL2MySFZFcWxaZzZPOGxKRitLL0JFODN1MVBIS0RXU3ZzWTlk?=
 =?utf-8?B?QS91Qi83Z0grRFRPUDBXN0tvcEJreThFK2VCaTBrb2dhdDZPcjdDa0xTOWlB?=
 =?utf-8?B?eVhQSEoydjV5MWdLUDA4L0l4eTgvY0UzVzNaeW9IdE5MU2RWTUxDVk80ZjVk?=
 =?utf-8?B?T2NJaTc1RnhCdGdWYnBuNCtrRXptWCtTTm5RQjR6Q042WGxJc3ZKclFjOEtq?=
 =?utf-8?B?L21EMlZjR3BGeVhZalk3NHl6TGVsU1F6QzJlbms3SW51TE9TVWYxVHZEaFVB?=
 =?utf-8?B?VXdnRUk1WVlJd2Y0NU4wb2t4SXF4T0EvbnhoQ01aRWxHaVR3S1l5ZEFlNHFI?=
 =?utf-8?B?cFl6Z3Z0S294QnByQUNzZGxaNmdGZDhWM3BzQzBYb2JiUjdCMUh3eGdsVU5S?=
 =?utf-8?B?aEUvanpmbDJUdWJycXoyeWhTeGtONXRxSDJKWG5WbVJwR1NUSVhsdDVac0xt?=
 =?utf-8?B?b1VjdUNJWm5POEkrQ2RmZ1RhcnZYZ1NNTGs5QVpqK3dUSGxXSHNJbGxLekp3?=
 =?utf-8?B?R1NoelVlVjlsTTN4UE9IM05pVTcxNWJJanhqUzBUV0NUSFU2NzhubWhHdWcv?=
 =?utf-8?B?SHhGM0lSeFAxaThxRi8wMFZBdm56N1gzeXd2WEMreVBRNEx5QlBERVJYRzB2?=
 =?utf-8?B?eVZJbG8wN3BEaGxvdVZINUJSZU8yRTNzSk05cUNyN0lvV1k4VFZjczVZa2hk?=
 =?utf-8?B?L1A0djlSSy95L2hNSVJITEZkQ3RnVmJ3NzV1a0JwcThBeU1ZREExcTlBNk5V?=
 =?utf-8?B?cHMwQStHUzFiaHVFc291QzF1eTJKeFMxTGM2NVdUZm1veExVQTdYY1RjOXNJ?=
 =?utf-8?B?WnpxMkcyMnRpZUYzSlBsRTVIR0V6L1I2SXVtS003T0NjSFMydFVxN2pzbHhB?=
 =?utf-8?B?YlBMWUZtV2diR3BvWU1iMkxkOVE3d21zS0hhY3VFOWtYQTd2OUdUWGJPYSsx?=
 =?utf-8?B?YkNaWFJBZDA4Vk85WGcyK2lZZVVtN256NXlFdnV6RzdBSlM2QklZMjE0WHBx?=
 =?utf-8?B?dlhid2lpVnhMbllrMFltd0NlSmROOHBTbDJ5SXQ0b0FPUUZzOUxuSnpSZFdW?=
 =?utf-8?B?U1BFR3M3MFNOVzFqM0xJRWhKY1JTWlZhOVdYTkFZMDIzNkYvbFc2c1Z3TkNl?=
 =?utf-8?Q?cS2/sQ36IXb5sJKN7JMfKrMKj?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06c18fa4-c381-43a9-8bac-08db3128f6af
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6101.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2023 14:13:41.2019
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OJY4oOiZKkhvVupe5gUNJex0sXA8NKGeMPphSmN32zlJsI5EH9d1TQFJy+oPC3SSWFektoI0xHI2p+Sxll6XqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6052
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/29/2023 18:24, Sean Wang wrote:
> Hi,
> 
> On Wed, Mar 29, 2023 at 1:18 PM Mario Limonciello
> <mario.limonciello@amd.com> wrote:
>>
>> When the BIOS has been configured for Fast Boot, systems with mt7921e
>> have non-functional wifi.  Turning on Fast boot caused both bus master
>> enable and memory space enable bits in PCI_COMMAND not to get configured.
>>
>> The mt7921 driver already sets bus master enable, but explicitly check
>> and set memory access enable as well to fix this problem.
>>
>> Tested-by: Anson Tsao <anson.tsao@amd.com>
>> Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
>> ---
>> Original patch was submitted ~3 weeks ago with no comments.
>> Link: https://lore.kernel.org/all/20230310170002.200-1-mario.limonciello@amd.com/
>> ---
>>   drivers/net/wireless/mediatek/mt76/mt7921/pci.c | 6 ++++++
>>   1 file changed, 6 insertions(+)
>>
>> diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/pci.c b/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
>> index cb72ded37256..aa1a427b16c2 100644
>> --- a/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
>> +++ b/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
>> @@ -263,6 +263,7 @@ static int mt7921_pci_probe(struct pci_dev *pdev,
>>          struct mt76_dev *mdev;
>>          u8 features;
>>          int ret;
>> +       u16 cmd;
>>
>>          ret = pcim_enable_device(pdev);
>>          if (ret)
>> @@ -272,6 +273,11 @@ static int mt7921_pci_probe(struct pci_dev *pdev,
>>          if (ret)
>>                  return ret;
>>
>> +       pci_read_config_word(pdev, PCI_COMMAND, &cmd);
>> +       if (!(cmd & PCI_COMMAND_MEMORY)) {
>> +               cmd |= PCI_COMMAND_MEMORY;
>> +               pci_write_config_word(pdev, PCI_COMMAND, cmd);
>> +       }
> 
> If PCI_COMMAND_MEMORY is required in any circumstance, then we don't
> need to add a conditional check and OR it with PCI_COMMAND_MEMORY.

Generally it seemed advantageous to avoid an extra PCI write if it's not 
needed.  For example that's how bus mastering works too (see 
__pci_set_master).


> Also, I will try the patch on another Intel machine to see if it worked.

Thanks.

> 
>       Sean
> 
>>          pci_set_master(pdev);
>>
>>          ret = pci_alloc_irq_vectors(pdev, 1, 1, PCI_IRQ_ALL_TYPES);
>> --
>> 2.34.1
>>

