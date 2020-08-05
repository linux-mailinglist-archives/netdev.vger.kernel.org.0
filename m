Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE27423C5DA
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 08:32:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728062AbgHEGcR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 02:32:17 -0400
Received: from mail-eopbgr140074.outbound.protection.outlook.com ([40.107.14.74]:29574
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726377AbgHEGcQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Aug 2020 02:32:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ScKZOaBfpF9Wkttr4rDpvdLIlScxHU4tD/nfXcgkd4n3wPh/4QbA7QEOgERJoP7bQPbOv6zUYRC3qKgMk2WoJ0/CnNEN/0YO8alwbGSZ0wcL6xtINudECHBYYOQUsx6VNF6lu/ozqxVIdpARiKANJPdA6BNxqGFgWHCSkD4kMyNr4yfcipsTCKWoL/ap3whrfmIcsvgl28hcpnLhKNl73DXvJejBBcblpOCzlyB8t4GCWYpUv/EcvDAyxTFY33W/KvhxJHC1DSkrAERRcV3Jd2JtX5EibCwKFoGdcBabUtZGgcrNRs86CR2UZjdoJgck8G5H+EWmUclxvY57OUvweg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BdDhScpjoXVaisT+Kg1CZ9iCEkw2o6GMVbHY54Jrmfk=;
 b=AR48VNXFt/whjXyGLwvLHFwvEoATYkpbX9ZpXboyqhbel1KfYkwUmo4y4ZZhSTU/Z5YfG47xODuhMGafgOTNDwgO4YxdLT4lYHY6tuTseuL2iVpPijxi8Mvm1ra0B3DBqOHN5Vcr/libNIHbvyxsh5k9u1qEbW6jkZNVfh/MxZe+qTZFP9jBKi7eLJo+4RYaayRev9hTT1YHOE87//6Q78R60RhdUnxqpIYhb+zBoXlZFnoWxNHeY3/13NC8QB0lzO3vzAlS5o+K0cHVVzFb15AXRE3H0L6cNcii7AUJ38ezdxXZUQprkqjMUuuPwlWlixDFDX69r6P66R0SRV75AQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BdDhScpjoXVaisT+Kg1CZ9iCEkw2o6GMVbHY54Jrmfk=;
 b=pObr6nESCdZTvPraC1jnBLxVpOwSM9vsO2kNIcAeoMGdl+QPX6rGlU6S6eEkgd0YRh/uYsyMpBJnqyWXBp80UlSo3xmOqSJtZHd94TMi8akvO/Zw7lz0T6hezcJsRDM70MOn3EeLhl5cMhspn3x1CqegwWASDnqlqnnCy+cGRhw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from AM0PR05MB4290.eurprd05.prod.outlook.com (2603:10a6:208:63::16)
 by AM4PR05MB3172.eurprd05.prod.outlook.com (2603:10a6:205:3::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.17; Wed, 5 Aug
 2020 06:32:11 +0000
Received: from AM0PR05MB4290.eurprd05.prod.outlook.com
 ([fe80::21b3:2006:95aa:7a1f]) by AM0PR05MB4290.eurprd05.prod.outlook.com
 ([fe80::21b3:2006:95aa:7a1f%3]) with mapi id 15.20.3261.017; Wed, 5 Aug 2020
 06:32:11 +0000
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
 <7fd63d16-f9fa-9d55-0b30-fe190d0fb1cb@mellanox.com>
 <CAACQVJqXa-8v4TU+M1DWA2Tfv3ayrAobiH9Fajd=5MCgsfAA6A@mail.gmail.com>
From:   Moshe Shemesh <moshe@mellanox.com>
Message-ID: <da0e4997-73d7-9f3c-d877-f2d3bcc718b9@mellanox.com>
Date:   Wed, 5 Aug 2020 09:32:07 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <CAACQVJqXa-8v4TU+M1DWA2Tfv3ayrAobiH9Fajd=5MCgsfAA6A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: AM0PR02CA0017.eurprd02.prod.outlook.com
 (2603:10a6:208:3e::30) To AM0PR05MB4290.eurprd05.prod.outlook.com
 (2603:10a6:208:63::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.105] (31.210.180.3) by AM0PR02CA0017.eurprd02.prod.outlook.com (2603:10a6:208:3e::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.17 via Frontend Transport; Wed, 5 Aug 2020 06:32:10 +0000
X-Originating-IP: [31.210.180.3]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b32271b8-b02f-4be7-5a13-08d8390948a1
X-MS-TrafficTypeDiagnostic: AM4PR05MB3172:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM4PR05MB3172FCE15FB467F29F7D2D3DD94B0@AM4PR05MB3172.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ycPtPb8MA+mvbfupWgMqAdqS0AzWfojGAWtrAYMJsuRYU+4ldYlPF+fz984T6W6U2GzJGz4cZ6qMDnnGBzCUawAZTpyGNC3hWsKysP+uzSVBa6ONvy4MQPw1nOykck9hjhmeCmKjiW8RVP5ilqgrbO2L60qxgKLS0pbkBDWKMfWfZfsSpiv1aksUfrZ7Ivdv4svNRHbo4ZJ/c/jd56b/40Haop3XcDksn7CithVJOlBhzsQfYH3q9K+9wgGYuhG7IXJvdzO7UOAoux0EzRSHC9EEvVc+hLnVuPoRi5idUAH8AmJNZn389J6AQHy+0RCntKoh+8wVicpgzA4DP996tYNs1FWcKRxx4BS0+0jRQqaD45o+jEd9devQgU/RWhIC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB4290.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(136003)(346002)(376002)(396003)(39860400002)(66946007)(186003)(16526019)(52116002)(66476007)(53546011)(6486002)(2616005)(956004)(66556008)(26005)(6916009)(4326008)(5660300002)(478600001)(36756003)(31696002)(8676002)(86362001)(8936002)(6666004)(31686004)(2906002)(16576012)(316002)(54906003)(83380400001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: OSUUa8k/9T1VYxbruYELFjNcUQPhr+yap4WciQyQdMh3B+sTcPA8NRamujmV3U+fAZ3W4mJwv13j2zFWjO4aJ+D2ikNXT8E9G2xOXlWWuPzrg6A63IABakesOidgH/PM6K7SPjNmWQPffRDRykJjVgE6nKHLEdNwPac+jpuza9Ntpn49QB0631OGwL79IFt47UMsOKTQeDfXkVgenB6JcTbyorSp6CdIAINCf8Ho/to2OqvSdRHLWkgDadIeh/4KmvcTn2bW5HGZdG6vJgsz5zrRDC4WYpmjpaCcFI+8iJJzfFb1uYwMrH8HmdiCauK6sYW8YNXxnrfBl8JpqxnctBAZ5VDTK49zai8NdJKw+xoBgyztzX4g/Ro9Ja7aAN4Gz7jKcqm8MWUzxg3vbDeylqQrfVzyBbY1Iw6xNpZ5ut+2or+v5qQSx6ZJ0hmvD9DUIjHhdqiJqrW5Bo2k6VsDbq+/nfQ5eDvB6JoXXapm/cE1tJDoiwC8soXwxmNt1bk3E/4ckMqrjD94Vl0oUckFQi5hHr+JmLSi2ugcVJQr6I6HC+azwqjbO9EdMUV/Q4f7F2JFo+oioscVCjJSlDx/lO26XPxvUcwwhggBX3He6WNCiLECEdglbEovzG2YAUZ57TDJyZ0MLR9XwiAEIj3m0Q==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b32271b8-b02f-4be7-5a13-08d8390948a1
X-MS-Exchange-CrossTenant-AuthSource: AM0PR05MB4290.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2020 06:32:11.0776
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 20O8/dGaE9QQxZfn4j52wcHG52UFoiW3/ehWN93gsl/lYpp004mV/PrWV02yGaaf4Lz5zJbuibguIys2VeFG9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR05MB3172
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 8/4/2020 1:13 PM, Vasundhara Volam wrote:
> On Mon, Aug 3, 2020 at 7:23 PM Moshe Shemesh <moshe@mellanox.com> wrote:
>>
>> On 8/3/2020 3:47 PM, Vasundhara Volam wrote:
>>> On Mon, Aug 3, 2020 at 5:47 PM Moshe Shemesh <moshe@mellanox.com> wrote:
>>>> On 8/3/2020 1:24 PM, Vasundhara Volam wrote:
>>>>> On Tue, Jul 28, 2020 at 10:13 PM Jacob Keller <jacob.e.keller@intel.com> wrote:
>>>>>> On 7/27/2020 10:25 PM, Vasundhara Volam wrote:
>>>>>>> On Mon, Jul 27, 2020 at 4:36 PM Moshe Shemesh <moshe@mellanox.com> wrote:
>>>>>>>> Introduce new option on devlink reload API to enable the user to select the
>>>>>>>> reload level required. Complete support for all levels in mlx5.
>>>>>>>> The following reload levels are supported:
>>>>>>>>      driver: Driver entities re-instantiation only.
>>>>>>>>      fw_reset: Firmware reset and driver entities re-instantiation.
>>>>>>> The Name is a little confusing. I think it should be renamed to
>>>>>>> fw_live_reset (in which both firmware and driver entities are
>>>>>>> re-instantiated).  For only fw_reset, the driver should not undergo
>>>>>>> reset (it requires a driver reload for firmware to undergo reset).
>>>>>>>
>>>>>> So, I think the differentiation here is that "live_patch" doesn't reset
>>>>>> anything.
>>>>> This seems similar to flashing the firmware and does not reset anything.
>>>> The live patch is activating fw change without reset.
>>>>
>>>> It is not suitable for any fw change but fw gaps which don't require reset.
>>>>
>>>> I can query the fw to check if the pending image change is suitable or
>>>> require fw reset.
>>> Okay.
>>>>>>>>      fw_live_patch: Firmware live patching only.
>>>>>>> This level is not clear. Is this similar to flashing??
>>>>>>>
>>>>>>> Also I have a basic query. The reload command is split into
>>>>>>> reload_up/reload_down handlers (Please correct me if this behaviour is
>>>>>>> changed with this patchset). What if the vendor specific driver does
>>>>>>> not support up/down and needs only a single handler to fire a firmware
>>>>>>> reset or firmware live reset command?
>>>>>> In the "reload_down" handler, they would trigger the appropriate reset,
>>>>>> and quiesce anything that needs to be done. Then on reload up, it would
>>>>>> restore and bring up anything quiesced in the first stage.
>>>>> Yes, I got the "reload_down" and "reload_up". Similar to the device
>>>>> "remove" and "re-probe" respectively.
>>>>>
>>>>> But our requirement is a similar "ethtool reset" command, where
>>>>> ethtool calls a single callback in driver and driver just sends a
>>>>> firmware command for doing the reset. Once firmware receives the
>>>>> command, it will initiate the reset of driver and firmware entities
>>>>> asynchronously.
>>>> It is similar to mlx5 case here for fw_reset. The driver triggers the fw
>>>> command to reset and all PFs drivers gets events to handle and do
>>>> re-initialization.  To fit it to the devlink reload_down and reload_up,
>>>> I wait for the event handler to complete and it stops at driver unload
>>>> to have the driver up by devlink reload_up. See patch 8 in this patchset.
>>>>
>>> Yes, I see reload_down is triggering the reset. In our driver, after
>>> triggering the reset through a firmware command, reset is done in
>>> another context as the driver initiates the reset only after receiving
>>> an ASYNC event from the firmware.
>>
>> Same here.
>>
>>> Probably, we have to use reload_down() to send firmware command to
>>> trigger reset and do nothing in reload_up.
>> I had that in previous version, but its wrong to use devlink reload this
>> way, so I added wait with timeout for the event handling to complete
>> before unload_down function ends. See mlx5_fw_wait_fw_reset_done(). Also
>> the event handler stops before load back to have that done by devlink
>> reload_up.
> But "devlink dev reload" will be invoked by the user only on a single
> dev handler and all function drivers will be re-instantiated upon the
> ASYNC event. reload_down and reload_up are invoked only the function
> which the user invoked.
>
> Take an example of a 2-port (PF0 and PF1) adapter on a single host and
> with some VFs loaded on the device. User invokes "devlink dev reload"
> on PF0, ASYNC event is received on 2 PFs and VFs for reset. All the
> function drivers will be re-instantiated including PF0.
>
> If we wait for some time in reload_down() of PF0 and then call load in
> reload_up(), this code will be different from other function drivers.


I see your point here, but the user run devlink reload command on one 
PF, in this case of fw-reset it will influence other PFs, but that's a 
result of the fw-reset, the user if asked for params change or namespace 
change that was for this PF.

>>>    And returning from reload
>>> does not mean that reset is complete as it is done in another context
>>> and the driver notifies the health reporter once the reset is
>>> complete. devlink framework may have to allow drivers to implement
>>> reload_down only to look more clean or call reload_up only if the
>>> driver notifies the devlink once reset is completed from another
>>> context. Please suggest.
