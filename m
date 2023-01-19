Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F567673470
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 10:30:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229505AbjASJaS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 04:30:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230022AbjASJ3t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 04:29:49 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on20607.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e88::607])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECB5E677B4
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 01:29:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YA44IMQvXOGBE/zjR0rwWeAxkPKijeb2wO2jxYzZCpS5HtiAGT1h/lv59xtRSiBcgTbpt9rAokSaQzw5qvAhSSTpDvJJHUt+46yMDaG+Hius2nvGKNvEpy9LHNG7x5/TmOXi7whsPFKEevjUSM5WXMmLsDbAm6efOfLS8w939oF+MDiHybR/05WQpp156LMsQFEwIGZGi3LThhcY4pwh7w1PLmTzddobMs+CEBEqHTtusEP5AtAY/O0gW3qLzTpgM75PGCOfqODElWYqaqnt6DE13SR7kjWodkx+cj43YDpVdj7e2heb7TWkUDejQFe9q5kq4kO0E8KGxUpeEp4GHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v/5Xk9d4byVHgCNGkDCGfhIU1suK+Opy20keFNtu0SE=;
 b=VA8SKHT32dBtkpOHcZzYkNVm6ey9j2wWUqObWjC5BgApWsCwXpr9qYUmkfj96LuPUnLk9/fFVgc7qhm71fxuGCGgCag3aPE9QBd8fX/3OyU581QMYI03qufdEEoZP3oPNQVt6R0qu5gc2sHOUmXenP3wqK15uLF1egvjDhJ1d1gDSBHIi36BgECOSyh7aZoL1+WflL+7Y/akdrsMrc9FTqTecF50PG4H7XxMYdQOGxl5ads0HW7NQteve9KURj/Oo4g9cHwVOrtzgZdXdTlG6KPtQ3cwSoVdHwU9gC2/VXSNP2ZsCBPfFEuD42FYkwBso+5eyWiZsKRNj633wHBilg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v/5Xk9d4byVHgCNGkDCGfhIU1suK+Opy20keFNtu0SE=;
 b=Zld/1S1fTbJmmjucd+ytuVwfeqUu5Qc1Bd2Q4UClIgXlg9ZHpJm5RVVsFTMZIuHnDUx4XG+04K6X1ni/24+ziY9SKynOiApW5VpnELVO7md/jVdxjpi3Ao9dKFHw9A1OivHw/xG0BFFTtGk2wXzH10adKvI2oYmL7tBP5Dsu22rkAEVj0qXLGK+ubr9ZVk8CT6bGEh/0RZndd/hDPAbC3SC4jzTG6bhPeZ+7PWaevMJuM50YgdBm/WTnDbwBU6nMqvk2Kh7lVswwaTfo4NQhb74Je9RbOXC/pbn47/BeDc9lyc6O7/IJ9QV3U/Mz/SrP1LeVz8cY1vDU5h8MN0uarw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB6288.namprd12.prod.outlook.com (2603:10b6:8:93::7) by
 PH7PR12MB6636.namprd12.prod.outlook.com (2603:10b6:510:212::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Thu, 19 Jan
 2023 09:27:57 +0000
Received: from DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::d01c:4567:fb90:72b9]) by DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::d01c:4567:fb90:72b9%3]) with mapi id 15.20.6002.013; Thu, 19 Jan 2023
 09:27:57 +0000
Message-ID: <516756d7-0a99-da18-2818-9bef6c3b6c24@nvidia.com>
Date:   Thu, 19 Jan 2023 11:27:49 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net-next 0/5] tls: implement key updates for TLS1.3
To:     Jakub Kicinski <kuba@kernel.org>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Tariq Toukan <tariqt@nvidia.com>,
        Boris Pismenny <borisp@nvidia.com>
Cc:     netdev@vger.kernel.org, Frantisek Krenzelok <fkrenzel@redhat.com>
References: <cover.1673952268.git.sd@queasysnail.net>
 <20230117180351.1cf46cb3@kernel.org> <Y8fEodSWeJZyp+Sh@hog>
 <20230118185522.44c75f73@kernel.org>
Content-Language: en-US
From:   Gal Pressman <gal@nvidia.com>
In-Reply-To: <20230118185522.44c75f73@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO2P265CA0506.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:13b::13) To DS7PR12MB6288.namprd12.prod.outlook.com
 (2603:10b6:8:93::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6288:EE_|PH7PR12MB6636:EE_
X-MS-Office365-Filtering-Correlation-Id: 976427f9-728f-4ac3-90ca-08daf9ff731f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: etPFJMtrehtXOHdnPrMEr6Wo461nbLZJw6q9ufQuaj1o7kKY6SjNlvARL7r1G45BCWNZD7Uua2nc3cSFzENfmTMXSPcrYIE7eWndZ+ONKDKNNARIxbe8Ifpm6SOJUt2P3p/gDx7712qOFvECAmDcd/wOpSRM2RLuSgOz8eVAaKU5kk/k6Mtxpyerc+m4w9quIER4STZcw/l37NAIvVboWohlZj9D223oqo5S9PxL361zGsXNTU+Ve9VqDgFn+gzVpirF1qASd+ZGU1jVd4ze6tuTyBi+Nke1BW8iy8iCzUsV3zP11Vn8MPeEmDCqb2xXm8gFWN/w63T7et5+ms+v6g6GGglp4CgYi9p4EV+xHgxhmkjndC6NRj2NCtBNgSx6xRzEzSspgzY1JJO2+stDgFn3zBYzjLgKVu9obcSg+JBS3qIe1ORpzyW9U/psxRTOYCcEzSNdCYdQw5FpZMi6ei0Wp84OLjBh/nUJbebk/I1YIEJR/C514wA3sTXfH9UUV0xK8VEBapYvG7V2ehJGrnaRBHjlN8I2wBis3xpZEvZNRgRhJygiCovYaoHtfApr8RTqvta51IHBsdX5RrXhoX8LpOzqZPl4T1DYx1KAX1Yd9lZYnu7Ya0qeC3TFMclOIAfl5AUQX19t1VxEOGukVMOJ7+EjEh26TZqxIYp0A4s+2ZEsggtRidg0zjSHS7DzRZlqr9F+0JTPqFuD1DDaMkLfYGQyntJ6oDYb+0+uQv8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6288.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(136003)(396003)(366004)(39860400002)(376002)(451199015)(83380400001)(38100700002)(8936002)(86362001)(6666004)(15650500001)(66476007)(5660300002)(8676002)(66946007)(66556008)(4326008)(31696002)(2906002)(478600001)(41300700001)(6512007)(186003)(6506007)(53546011)(2616005)(26005)(316002)(110136005)(6636002)(6486002)(31686004)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZW82WDk5UVdvenhESTB4S3dNZ0x3ZnFuVjVFZFY0bnhPd3pOTmlVQmFKbXQ1?=
 =?utf-8?B?ZHVKdTBYNlU0b3hoZW9HWDVZNlpWSVZTV2hobi9pT2VPQXJ1dlQ4U1hldWNz?=
 =?utf-8?B?cjVvVkpYYTlNM3ExdmhQQy9nNzY2RThOVkhUa1B5YUJkcTVHeGRCTnV1bWtk?=
 =?utf-8?B?R0dxQWZ3bEVIOXd2QTJLNGlWTWU2bXVhSjZITkR0SG0vajVUWnFvTVI4Qzlj?=
 =?utf-8?B?bU5vQWo0NFUrcHAyc2dISTlqMk1UTEdBY0J1aGNkODk2TGNmaTlSdW1RbTZK?=
 =?utf-8?B?c1ZUUEtsRUEzQTRyVkVTamlQemdKYTU2ME92NG1jTzJVMUhycTdoemlwZ3ZH?=
 =?utf-8?B?aFVma1I4N1ArdTZudW8xYit0NEM4djFCcGdTU3I3YVJZbFZMZDIzSFRsYlIw?=
 =?utf-8?B?d05hNXNPdzk3MWFkTFB5WHdqNjUrcy9FOFQ5NXY3U0Z4eTMrQmNNVFNLNlF4?=
 =?utf-8?B?Y0l5Y2hOa2Q5bTJxMXJUU0MwVUZnOXFBdWNvYXBLNmRzdmVranFsR0FTUnR0?=
 =?utf-8?B?dHhxTkl5ZG90UklvaytPd0JkbURBNWUyOXpKMjBsNlpDUjVoQWpaL1BiTVU0?=
 =?utf-8?B?Nk9Vd09jM0NSc0tsUE00MVhjajVrTDFvS1RMVXFsM2ZrNGFqU2tZZ25XK2xI?=
 =?utf-8?B?NU1LdkpkWkxKd1dhY3g5Q2hmaEpxdXRyNDZMallRNEhuU00zeHVBYmNTY2s5?=
 =?utf-8?B?ejlSOEN2YWJqN0huUE1NaEZISU9MWVpvSWpENVREUkdGcVFXYzlqdGk0eGsv?=
 =?utf-8?B?Ym9Qa3RSc3daYmwrUWoxZ0k1OGdwZnJiWUlqSTg3M3A3VnJYRndoSzk4ejFN?=
 =?utf-8?B?MHVRdCtxeVZ3WWpKR3ZwTUJ2RDdYZ2RXL3RqeUErWXVUN1NEbDhIbVYrSHYx?=
 =?utf-8?B?NllsOUUxQnNUbzVhRGhrQ1NaZ1czVHFmZW1tdkRJT2lHOEtDS3ZYWkp1U0ds?=
 =?utf-8?B?M0lnU2tYMjV3b3M4ZUo4TmZIWW1jc1hVUWdJL0w1Mm4yYnRqdjQzMlhSeGpH?=
 =?utf-8?B?a2MvTDUzcGwvNHR1dHlaUGk3bmZ0QXFWcmY5dXQrRnBFSGg4bkRhQ0RyR3Bq?=
 =?utf-8?B?YWQ1OXNQYXBmUHpOSlB3QU4vWlduRGx5cVNHL0JKSWNLeGpwZTJSWndxb0ZI?=
 =?utf-8?B?K1I1Q2g5ZFlzOUlLNXdzRjI2aXYwZUozMVRnU3lKMlFKaVhWWEl6bzA5T3oy?=
 =?utf-8?B?UVNLTlNlYllmNVNBK3FRUi9JelpFYlUyb3ZlalhwTFJQaDBmWmcwNStZWjd2?=
 =?utf-8?B?THhlaTRQSVdlclEzUXhPclFDbkVtQzR5QTY5bVJLT2VlYXh4YlJkZjBUTkFT?=
 =?utf-8?B?K1gvOTZoWVFINE5nRS9NTVRtRXBXL2dLeG8wWWRhNDh2ZDdCWjhueFB3RUZn?=
 =?utf-8?B?dnVUbFpsdlJCNnlvNUlFY1YyK2pCZDhWeVJnUDI3Y2wzek5vNDZ4VDAxaUwv?=
 =?utf-8?B?VmswY25WTzVVQnoxck93M1c3K2UvcTJLZSszaWJaWURuWmg1ZzE0dHcxYzk0?=
 =?utf-8?B?NktZdlg2U3Q1dVhENTdBdkZQa1RyeWtCb2FhVTFwMkROTHh5NDhQZ0QyaHp5?=
 =?utf-8?B?cjc2TmowNHNXeDdCc2RXd0tMaU5TWm5QTzBZVy9MaVVZaUMzdzVzMmNVWm93?=
 =?utf-8?B?OE8rSDlpUGYvZnVTbFJrWDFxbEVBVEVvUkIrRU4rbS9Ua1VQblozWFFidzd3?=
 =?utf-8?B?QjZycURGZnA5NkZybGRrd2djTExTRGNoczZFTkxEZHErSU9ZeVpCVndESWto?=
 =?utf-8?B?Skk2dldIS2ZBKzB0dEFxajNhcHpuQ0M2Wjg5ZklTcjRVZW9NampSTzJpNk01?=
 =?utf-8?B?OWhybWU1SmxNOFE0cWdUK3YxdThhbXM1TjJtOTA3SmJ4elhwKzJMZzAxQytK?=
 =?utf-8?B?Y0s4Q004ZUdFR1gzcnh0ZjhYYWx5VVhuNWY5aHlXeEI3UitKWGRoYUZkdUlp?=
 =?utf-8?B?VFlhZHB2VkdNK2lZeXZIRVdZOFVHSFIzZm5GRkRuWVFTU1UyU1M5L1Zkc09H?=
 =?utf-8?B?aGJvSEwrQVorTUd2STNhYkt2YU5NNFFsNjdJSzhadVhyTXR0SU15K3pYVTla?=
 =?utf-8?B?RmN1eTg1M0ZuN21iUW9BQjZaN1piQ1ZxQjcyajBYNkh6aUZSR1IyTXcyY1Y3?=
 =?utf-8?Q?EkQJBNxW/4uql48kTd2orOrqE?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 976427f9-728f-4ac3-90ca-08daf9ff731f
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6288.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2023 09:27:57.2427
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NkaoJ+X+q4WChWI9tSoxmsEkKq2XZS8oUm7jXEjy8T3R2QYjmPS7cdXLFhOzgBpd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6636
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19/01/2023 4:55, Jakub Kicinski wrote:
> On Wed, 18 Jan 2023 11:06:25 +0100 Sabrina Dubroca wrote:
>> 2023-01-17, 18:03:51 -0800, Jakub Kicinski wrote:
>>> On Tue, 17 Jan 2023 14:45:26 +0100 Sabrina Dubroca wrote:  
>>>> This adds support for receiving KeyUpdate messages (RFC 8446, 4.6.3
>>>> [1]). A sender transmits a KeyUpdate message and then changes its TX
>>>> key. The receiver should react by updating its RX key before
>>>> processing the next message.
>>>>
>>>> This patchset implements key updates by:
>>>>  1. pausing decryption when a KeyUpdate message is received, to avoid
>>>>     attempting to use the old key to decrypt a record encrypted with
>>>>     the new key
>>>>  2. returning -EKEYEXPIRED to syscalls that cannot receive the
>>>>     KeyUpdate message, until the rekey has been performed by userspace  
>>>
>>> Why? We return to user space after hitting a cmsg, don't we?
>>> If the user space wants to keep reading with the old key - 🤷️  
>>
>> But they won't be able to read anything. Either we don't pause
>> decryption, and the socket is just broken when we look at the next
>> record, or we pause, and there's nothing to read until the rekey is
>> done. I think that -EKEYEXPIRED is better than breaking the socket
>> just because a read snuck in between getting the cmsg and setting the
>> new key.
> 
> IDK, we don't interpret any other content types/cmsgs, and for well
> behaved user space there should be no problem (right?).
> I'm weakly against, if nobody agrees with me you can keep as is.
> 
>>>>  3. passing the KeyUpdate message to userspace as a control message
>>>>  4. allowing updates of the crypto_info via the TLS_TX/TLS_RX
>>>>     setsockopts
>>>>
>>>> This API has been tested with gnutls to make sure that it allows
>>>> userspace libraries to implement key updates [2]. Thanks to Frantisek
>>>> Krenzelok <fkrenzel@redhat.com> for providing the implementation in
>>>> gnutls and testing the kernel patches.  
>>>
>>> Please explain why - the kernel TLS is not faster than user space, 
>>> the point of it is primarily to enable offload. And you don't add
>>> offload support here.  
>>
>> Well, TLS1.3 support was added 4 years ago, and yet the offload still
>> doesn't support 1.3 at all.
> 
> I'm pretty sure some devices support it. None of the vendors could 
> be bothered to plumb in the kernel support, yet, tho.

Our device supports TLS 1.3, it's in our plans to add driver/kernel support.

> I don't know of anyone supporting rekeying.

Boris, Tariq, do you know?
