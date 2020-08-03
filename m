Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7031423A7EA
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 15:53:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727887AbgHCNxJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 09:53:09 -0400
Received: from mail-vi1eur05on2074.outbound.protection.outlook.com ([40.107.21.74]:3905
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727039AbgHCNxI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Aug 2020 09:53:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=moIv3i4h38dPUrdcL9oxyXv8Y+lCmHEUiD3DyDTHSeNhUA80IpfXN8dexGLkwWMYehDBHeE5w71p27Mdb6NOyahg0LLfcAmtUEj6/sltJh47T4qrb9PihPJgHnqD+0D7cz4wvETY9EO1/kLplsY/hGwYb3WNCdPe3lgQCzBZ/0ArDJZOj2g8VEEpP7ugQ5PRWBmIX29bskL0tDYXTuWguEH81TZv6tdbvx6EqMJnkbvaqA0thUPt7gz6UxW/G/Vj8dU+fyfMne/X+BKehTphuKZB9E1uSR1YkQeDUeNyrACNZbRtrzo/T9V/li+HuZ/GwtnM6zYvQOUTw0bBVn7aDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cKWrQAzSSo3chTXHrj7jyXwgaYWGzskk9506coIjC0c=;
 b=Ohk8+1hF8enWCJrSR9wrX2ixa1f2lTF6DMdeGAI0DDqNUNilDOLg9w0JfS8Rn7WgnrabHkyYCEwlwDbiDS388xoIh1T0g6Np5kVZQHzCoohA15f9wUCEcWJhFz54SoKdGhIbOkyiKKnYEs6wRl81kix0y0mQBFOON/lEFW7iU3dtjZwqToEKWtl35M50UKYF9CxCFMkEVFHGckHV9dWqNxbfiP6gBl4TNUPg5yfAWsDtSczog5RXNb5MGWR/9h8nxTDoPDqwvZjfb2xoPLojlLKiB3Joch3o9VPuQk4LmnShSWCZVP+6ial7+B+bmCh/qjMJe3mtJdA2Jdth9RkNfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cKWrQAzSSo3chTXHrj7jyXwgaYWGzskk9506coIjC0c=;
 b=VuY7dsi99AFWOYBOu2gvVDGeAekm+zkPA60YBM8ZyDTuWpJLnG7/dn+JGFlqvzndKWsMswVneWqpicq7xpnAUEA588ZoDBwhWw1ZHQcGvwcCEzp5rA3TeNbCFzpeBlnuCBaMvfPLtIJfTl113OiASuL1o8xon2ciWqGKHQT+DhU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from AM0PR05MB4290.eurprd05.prod.outlook.com (2603:10a6:208:63::16)
 by AM0PR05MB5026.eurprd05.prod.outlook.com (2603:10a6:208:d0::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.17; Mon, 3 Aug
 2020 13:53:04 +0000
Received: from AM0PR05MB4290.eurprd05.prod.outlook.com
 ([fe80::21b3:2006:95aa:7a1f]) by AM0PR05MB4290.eurprd05.prod.outlook.com
 ([fe80::21b3:2006:95aa:7a1f%3]) with mapi id 15.20.3239.021; Mon, 3 Aug 2020
 13:53:04 +0000
Subject: Re: [PATCH net-next RFC 00/13] Add devlink reload level option
To:     Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <1595847753-2234-1-git-send-email-moshe@mellanox.com>
 <CAACQVJqNXh0B=oe5W7psiMGc6LzNPujNe2sypWi_SvH5sY=F3Q@mail.gmail.com>
 <a3e20b44-9399-93c1-210f-e3c1172bf60d@intel.com>
 <CAACQVJo+bAr_k=LjgdTKbOxFEkpbYAsaWbkSDjUepgO7_XQfNA@mail.gmail.com>
 <7a9c315f-fa29-7bd5-31be-3748b8841b29@mellanox.com>
 <CAACQVJpZZPfiWszZ36E0Awuo2Ad1w5=4C1rgG=d4qPiWVP609Q@mail.gmail.com>
From:   Moshe Shemesh <moshe@mellanox.com>
Message-ID: <7fd63d16-f9fa-9d55-0b30-fe190d0fb1cb@mellanox.com>
Date:   Mon, 3 Aug 2020 16:52:02 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <CAACQVJpZZPfiWszZ36E0Awuo2Ad1w5=4C1rgG=d4qPiWVP609Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: FRYP281CA0005.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::15)
 To AM0PR05MB4290.eurprd05.prod.outlook.com (2603:10a6:208:63::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.105] (31.210.180.3) by FRYP281CA0005.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.13 via Frontend Transport; Mon, 3 Aug 2020 13:53:03 +0000
X-Originating-IP: [31.210.180.3]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 471db937-ddd8-4158-735d-08d837b48b6a
X-MS-TrafficTypeDiagnostic: AM0PR05MB5026:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR05MB502663C2C3F71F02713D8960D94D0@AM0PR05MB5026.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N6jzOuxHWa1CPbL9Yht6UNdvFEkoWG9AaghuFolLZuFXgMgiZltLWRGqiAuZtGYHCIumo/z+WPiXUbJL2sgEga2eHdRmL20MUZrU8uUwElHtzoz3hl/igV6jS/Ur2jxUWO/lgJ4MIq09eW5UI5J2PRE2DE+CuxO5uENOzgyJR2MvgR75xQQWkNBkJmgmTGDDHlkaub9FQ79PJx9QOGJTReedAV3cevmTLLjnaJLzRCNl+2mM+o12FhMrQQUuNfhNzva6v4v+u8SsGtIEKTOO/Ed2sjJGawdHuDhbq+LGYpyZcRRqcVJV82vMjIs7E3oZFZQOgPo1UDjS/aTLEoKPhg3XuOeswD8Vh3Nimeg8/VrwBPXdWpTllwc0ZZ/zpyhX
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB4290.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(136003)(39860400002)(376002)(366004)(346002)(83380400001)(8936002)(52116002)(956004)(316002)(6486002)(16576012)(6916009)(86362001)(8676002)(36756003)(4326008)(478600001)(2906002)(2616005)(31696002)(16526019)(5660300002)(54906003)(31686004)(66476007)(66556008)(53546011)(186003)(66946007)(26005)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Ducg4qsysC1LVcxEXIDq2Xmb9LttnlFoQ3xvjrgIms6yS3lMslfRtId+8xTPn5CR25wboT8lY3S9mJLdpgqUIUo5z1r0g8g4xBuLXVJYg5zqU6x9k5fGVLfwtI6Nty+A+qDuyEigDFAdt05WCgtkZba4g3djR3SUUz77ql95FYASjM442Ogv+1Rqy6DXhd727rKKcIhmCjZzrhc5Md5snG9KPPR/8071msiggZAKNiDElObp3gEQZ3anPldhgC8Ltl+SJ/QAKaf71Om+nwbi9AbGiZAYVKi9G2Y/Nqy3m/ZXxECetn0ZQyd0R34AML1TfsFWy47XukFZUQty3syemsu9uaJVURKMCUgW3VUEnvkLTtHOeRQ4fkj3/4MipGyG/2pfOV3/5PEXXSuaIKOqholOEDppnCqMOWUnr4+wFHtd/W0XnjP39b4l2Xg160E9wCvX2nF4sQJPaMe2mCH8da9ZOaBayZNnacMTW1XxyTWvv01Iwhf2iIHHYVS9Wpo25+3e/7nCUt439ZG6N0NFNXQt/R7nKDApoLbBISrhVqxb51e6FNSlMWjPPDFNyhMIguaIJ6R64EEURazec0aiQrPQGK6OqXu9+BkipUxPAW42TrwnVmQm6M3fhe1UhFpayVMd5OY01nM4J7vy2RnblA==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 471db937-ddd8-4158-735d-08d837b48b6a
X-MS-Exchange-CrossTenant-AuthSource: AM0PR05MB4290.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2020 13:53:04.7294
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NpUAnCnLsFA5K212AreIVXZ1co/SZSghs46pFQyk7p4bOnSMblLmRovsxwlDBFyjvKxhlVIElxPoxWPBfGAnqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB5026
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 8/3/2020 3:47 PM, Vasundhara Volam wrote:
> On Mon, Aug 3, 2020 at 5:47 PM Moshe Shemesh <moshe@mellanox.com> wrote:
>>
>> On 8/3/2020 1:24 PM, Vasundhara Volam wrote:
>>> On Tue, Jul 28, 2020 at 10:13 PM Jacob Keller <jacob.e.keller@intel.com> wrote:
>>>>
>>>> On 7/27/2020 10:25 PM, Vasundhara Volam wrote:
>>>>> On Mon, Jul 27, 2020 at 4:36 PM Moshe Shemesh <moshe@mellanox.com> wrote:
>>>>>> Introduce new option on devlink reload API to enable the user to select the
>>>>>> reload level required. Complete support for all levels in mlx5.
>>>>>> The following reload levels are supported:
>>>>>>     driver: Driver entities re-instantiation only.
>>>>>>     fw_reset: Firmware reset and driver entities re-instantiation.
>>>>> The Name is a little confusing. I think it should be renamed to
>>>>> fw_live_reset (in which both firmware and driver entities are
>>>>> re-instantiated).  For only fw_reset, the driver should not undergo
>>>>> reset (it requires a driver reload for firmware to undergo reset).
>>>>>
>>>> So, I think the differentiation here is that "live_patch" doesn't reset
>>>> anything.
>>> This seems similar to flashing the firmware and does not reset anything.
>>
>> The live patch is activating fw change without reset.
>>
>> It is not suitable for any fw change but fw gaps which don't require reset.
>>
>> I can query the fw to check if the pending image change is suitable or
>> require fw reset.
> Okay.
>>>>>>     fw_live_patch: Firmware live patching only.
>>>>> This level is not clear. Is this similar to flashing??
>>>>>
>>>>> Also I have a basic query. The reload command is split into
>>>>> reload_up/reload_down handlers (Please correct me if this behaviour is
>>>>> changed with this patchset). What if the vendor specific driver does
>>>>> not support up/down and needs only a single handler to fire a firmware
>>>>> reset or firmware live reset command?
>>>> In the "reload_down" handler, they would trigger the appropriate reset,
>>>> and quiesce anything that needs to be done. Then on reload up, it would
>>>> restore and bring up anything quiesced in the first stage.
>>> Yes, I got the "reload_down" and "reload_up". Similar to the device
>>> "remove" and "re-probe" respectively.
>>>
>>> But our requirement is a similar "ethtool reset" command, where
>>> ethtool calls a single callback in driver and driver just sends a
>>> firmware command for doing the reset. Once firmware receives the
>>> command, it will initiate the reset of driver and firmware entities
>>> asynchronously.
>>
>> It is similar to mlx5 case here for fw_reset. The driver triggers the fw
>> command to reset and all PFs drivers gets events to handle and do
>> re-initialization.  To fit it to the devlink reload_down and reload_up,
>> I wait for the event handler to complete and it stops at driver unload
>> to have the driver up by devlink reload_up. See patch 8 in this patchset.
>>
> Yes, I see reload_down is triggering the reset. In our driver, after
> triggering the reset through a firmware command, reset is done in
> another context as the driver initiates the reset only after receiving
> an ASYNC event from the firmware.


Same here.

>
> Probably, we have to use reload_down() to send firmware command to
> trigger reset and do nothing in reload_up.
I had that in previous version, but its wrong to use devlink reload this 
way, so I added wait with timeout for the event handling to complete 
before unload_down function ends. See mlx5_fw_wait_fw_reset_done(). Also 
the event handler stops before load back to have that done by devlink 
reload_up.
>   And returning from reload
> does not mean that reset is complete as it is done in another context
> and the driver notifies the health reporter once the reset is
> complete. devlink framework may have to allow drivers to implement
> reload_down only to look more clean or call reload_up only if the
> driver notifies the devlink once reset is completed from another
> context. Please suggest.
