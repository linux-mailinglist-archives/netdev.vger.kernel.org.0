Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F22E617D63
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 14:04:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231658AbiKCNEB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 09:04:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231523AbiKCNDi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 09:03:38 -0400
Received: from repost01.tmes.trendmicro.eu (repost01.tmes.trendmicro.eu [18.185.115.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A8D418E21
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 06:02:32 -0700 (PDT)
Received: from 104.47.12.57_.trendmicro.com (unknown [172.21.205.29])
        by repost01.tmes.trendmicro.eu (Postfix) with SMTP id 818D210000D17;
        Thu,  3 Nov 2022 13:02:30 +0000 (UTC)
X-TM-MAIL-RECEIVED-TIME: 1667480549.579000
X-TM-MAIL-UUID: 33f0748b-1928-4232-831b-16e63baa28b7
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (unknown [104.47.12.57])
        by repre01.tmes.trendmicro.eu (Trend Micro Email Security) with ESMTPS id 8D85E1000292E;
        Thu,  3 Nov 2022 13:02:29 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NWoMrBIfKNX6He2uBf0ds6Edt9QHHmoR5285rqi5W2jSFsqmNru5Pk8tg1YaVCWce6VU84hGi9meugd/3oDEQp+DBg2os8kOTQ2aadA3emorlkxS0dXqH8nkIZlhsRPkgxYxDmIAe4I9dq2WaXVdOUjE/Mh9m8eb/yGw1gRjYQkyh/APc8ushFiG9u75kTUKSV2KsAY0Rqfmcpv00ndukHMdoH/hHb/dL9Jw9h2/NvFkTV3iP6eyJOPyaCm4v/uq1EtqsViR7w4Rv6XVW2uXcOAkxb5OGQ/+MCnECBEDVZmxn4ETJlwusDwAyo4GJ+IJywCodGNYkbB8fxNmnvoOtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=USwS0bGWZKzFY+ZeGxQEqezrpRvtbaRtCjDteX8O0tM=;
 b=PTVxbVqmzwGUDCXVHW32tMnX3Ncw+G/lfA2VSeF7CamZizDKe+TQ1jNGYHmNzv/7hV58ptYHfTrQ15GJ6ZG5VLHETf3SNJwpu9jhsfg9FcQwqo7xfG3ef9FznhxiQ6H0N+x6Iu9V3JnwsIc+uQWDczBHtUz00qtr/fghfVXWIwwphc1NHJByN3GFCviFhnB5I3dd2cdAlFVI4kpQ23RFASY13vH7UOymlSh7uOh6xR2iz+e0AqL5RiiMJSJ0gGRxY9UQieHywuF0E9zCpYj6rpEFIxghSsAA2gaFZIZIZ8BB5fvAZzLtt6t6PEW4qwMRhC9ZeNjjnqotm7jJ0vutNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=opensynergy.com; dmarc=pass action=none
 header.from=opensynergy.com; dkim=pass header.d=opensynergy.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=opensynergy.com;
Message-ID: <6eee6929-577b-2b26-605d-ff650c435d21@opensynergy.com>
Date:   Thu, 3 Nov 2022 14:02:25 +0100
Subject: Re: [RFC PATCH 1/1] can: virtio: Initial virtio CAN driver.
Content-Language: en-US
To:     Oliver Hartkopp <socketcan@hartkopp.net>,
        Harald Mommer <harald.mommer@opensynergy.com>,
        virtio-dev@lists.oasis-open.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Dariusz Stojaczyk <Dariusz.Stojaczyk@opensynergy.com>
References: <20220825134449.18803-1-harald.mommer@opensynergy.com>
 <b19f3d7e-9439-5c2b-c731-e5eaef37442d@hartkopp.net>
From:   Harald Mommer <hmo@opensynergy.com>
In-Reply-To: <b19f3d7e-9439-5c2b-c731-e5eaef37442d@hartkopp.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BE1P281CA0056.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:23::17) To VI1PR04MB4352.eurprd04.prod.outlook.com
 (2603:10a6:803:4a::25)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB4352:EE_|DU2PR04MB8853:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a3bfeaf-5c89-4c52-e5fc-08dabd9ba848
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: np589N/3GU1YnImhxrY+/aZbjj7MnsQAd7Eg8+dbE4YO7pEqNrXRoo8kvpWQ9yG+LNmXbXudvaKWqMigyUco16H1/9qVr9raNapsVMWiXDSArjTzOyIcwRXtMJdc9ULu2JmAZv8KiRpGLIM3h+oAK8StyeB+CmNSJd/VoQPf0RDZU6KvNoRHBTWvW7lHyQHH9sqHuMSDgQnDNWNxd/CrSsuftinK/8PmDUQSGYT5aOwsk/6LtMRFW0DeeoAgaAITIhuNx2pyPCyhHvR1JEh6N6MfjugEsDHu/YBCIO8D5TWhvj+2maC5ha1+JlluZ2iN3DQf7CUnbGAXW1eWZ8MzswLubWbIa89aaGtxvWRwv5kzZfbLr+/DFzdRMzupTb/p8yuNe4o/hkhT9G/CNhrx1zmdB4sM0bsFbEhnLPBhwUg2iq7G4qY68IbOmf2rcfXdFyVcAZq6/7c4hzyuna8hQ4/yyXvynDKQ1OrVx0fb/AYCnxcLrJtE4OL5g1DiG33FU/B1kdoIO2ze6VZ8tdQrv2iXH1CU62x334qQxm/WIypIwJ0kKSwLVrhtxRfn2mbXanSoynKADoJlNRnPx3TGr5YzHcI5h9iXIvfcFYB0OmQs6LaVm/JVuLXf+Q+eTCNgrutPDZJt53SQuhhocfFgLaU/BrULbTaZIWdSZHItHnNx9ZS9cvWqd4Kx8rtKDSL3rnvm34kcFKkmC8KCG9K3B0fWpzGxTvsY/y+7uD0a4yE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4352.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(39840400004)(396003)(346002)(366004)(136003)(451199015)(66574015)(53546011)(36756003)(38100700002)(15974865002)(107886003)(8676002)(5660300002)(2906002)(31696002)(110136005)(42186006)(41300700001)(66556008)(66476007)(7416002)(478600001)(54906003)(8936002)(66946007)(2616005)(186003)(316002)(4326008)(26005)(31686004)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WUJ4cVIwREUrbGNDK3FlRjEzQUpFMUZoNEJWYk4rWGI5ZDg3eGlIWmpEbE9m?=
 =?utf-8?B?bytlaTk0bTRwTEFOMGlBTmNPK250blMveDV1OUxPQ2gzbWJsV2toRm1vV0xP?=
 =?utf-8?B?OWlSSEE1eWVINWR2REoyZFp4elJaeVVwUmFBaTgwazBRaFBRbmowSCt3Vldh?=
 =?utf-8?B?MHhCWXduTGJGYUpXZG51VVdxbnh2ZFFXMjBMRUpNbUZUR1hxRVNrVzJIYkE2?=
 =?utf-8?B?alVGOXFabCs5T1gwenlsN2FvOHROK0NzKzljN244SEN1WTBqUmUydzFMa1pV?=
 =?utf-8?B?ZU4wcmU0dThJQVIxQjZEbE9pOHZoNGgwRkNnMENsd2xoQi83TkxETTlRZHB6?=
 =?utf-8?B?a3d6eGw5cHlrRUtHQStHQVJKUTJIWWRZa0JqVXNRV0VQazUxWVVoK0NlUjZa?=
 =?utf-8?B?cW9zMzFLeitRTW5LYVA5WmdMVHVUcndVeCtkSWVjYmNzS1Y1QUFpL1JpNjdW?=
 =?utf-8?B?UXRWR0tlblhpQU9IUHhyYlJwbzJiekpENXJKS1lzSUN3UzNCNU1yZFFhU0dv?=
 =?utf-8?B?VjNMRkk0U1pMWDliNmd5QUVDcTY4NUJlcGU4bHIzWDNDc1QwM3NKa0loUldq?=
 =?utf-8?B?VnRvREJyUmxlQUlSMlUwektpVyttNEQ3aFlBeU0zM1htb05LSEp5NmxtQ0tK?=
 =?utf-8?B?NjBKSG1TUkpXOXUvT0gzamZORXlsWTVVbFdNcXdTTDJXMm5RQkZuZXJQb3Nk?=
 =?utf-8?B?OHZqR0N0NloxeDRJMjBVTjdOL0hwZk11a0F2RTZWQVdZa2JZTmtIMyszZ2xn?=
 =?utf-8?B?YWwrc0JadkJsVXp3dGJXR29DcXJ6NUt4Q3VUdFNIQ29VQUpNaGhTcWp0bHZy?=
 =?utf-8?B?Y3Nsa3JHblNOaFp4NWxBYWhHS1NnNm1Dbk4wTFlkdHZJeUZvZml3a1pkbEJk?=
 =?utf-8?B?THh0czlXdjVITDlrbWFnZ1Vja3pPV21VbGx0S25MTFI5d1VWSEZsdHNjNTlC?=
 =?utf-8?B?NDVnTDl4bG8wWTVlb0I4V3VDdWQ0QlBhMWdpdHdDV1RkOVR2RnI2MlBWbXFY?=
 =?utf-8?B?KzZNVGFTT2sza29ZVGJRWnZRWTRIRDRtZlRLajlUWGdVV2R6ZVhLbmg4My9y?=
 =?utf-8?B?blhiMkU0RDExOWwxcStmVlVYcmh4dWN1eDEva3NJaUdGZExXdFE3V3NHZXBj?=
 =?utf-8?B?WEp2MGlNT2NXMnFwOEhzbnEyTEIxMTdva0R3Znd6MzZXRFdnUmdRdmF1SUY1?=
 =?utf-8?B?d3EyOVY0c05sREh0OXZ4WHZVcTlsc1FCcTMxaG01NTNHYllkeVh3MW8rdUla?=
 =?utf-8?B?OEo4SUhXeWlMTzY2ckNCb0h3dHpwWFpHSzV4d0JURE1uYm9yeUJORmtLajd0?=
 =?utf-8?B?QjRtajR3YVVnbGNwMmJkRi9KeDRpc3lyN242UGxaYnZRZVFCaURzdHNGYWM5?=
 =?utf-8?B?THpaSGQ3MFJIamc4RWRtN1M3WHIzVEdtTG5pMjJrTHFFVUYvY2R1eTRLV1R3?=
 =?utf-8?B?S2ViQ21YKzNtaGpRU1lDWTdIMERVVkI4SzJTTC9kcnRSblJwNVYyOFpKQm1q?=
 =?utf-8?B?RWoyMENOTjVOaWNDWUhTTHJlV05tVnloL2lIMk5YcCtlditla3hFcTRpejJq?=
 =?utf-8?B?N2dUMEZpSWRmd2Z3SWh2ZkwyT0VTbzJic2ZNQ3pVcDJjK0J1OVNnY0t3Nkx6?=
 =?utf-8?B?L3U4TWpiejhZQ3g0UnVRU1NnbmVEUTJrS3c3R0xybFBpbjE2YlNUQ2VINDFH?=
 =?utf-8?B?Q1VLWktqVUQ0WEVKQW5VUFZyU0hza1dGQkVGdGV0a0ZOc0trV2VGdVRwZ2do?=
 =?utf-8?B?eWR0bkY4bDBQK1ZoUlo1Z2U0RDFpK0VibW8wczVUTndSSE1SSnFadkdSTm55?=
 =?utf-8?B?QlRZZVVDRGo0ckJGSld0NW8ya205eDAzYTNvNmFTOHNzeHBMdGd1WjdiZTBo?=
 =?utf-8?B?YVRaMVI5dTduVVFKRm5XVmZqNTVlZ2l6MGl0eG5FZXpWZzYyazFpcUlZOWpQ?=
 =?utf-8?B?OWNObEtoYVFQVncvUHpiTGNTaTl2ZFo0QVFyNTFwRk03Y3lTNFFlV1pBdi9K?=
 =?utf-8?B?UkRZR25EVnI2a1hpR09TWWM0QzE1NTlXUk5qY2JMMjV1RlV5SWhWR3pxcVNp?=
 =?utf-8?B?YUFvZU1wS0pHNTAxUDZoNnhLN05ka1hwQ3pjbjVobG5BKzc4aTZhWS9rcHNy?=
 =?utf-8?Q?/Q4w35RLHqxLItPkSw7Fg6cNW?=
X-OriginatorOrg: opensynergy.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a3bfeaf-5c89-4c52-e5fc-08dabd9ba848
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4352.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2022 13:02:26.9151
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 800fae25-9b1b-4edc-993d-c939c4e84a64
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Cxd+0jlDW0ifKNJNhgYqkLB12H/MaSvMqqa45FQuBqLvzTGiin5ZwkloIQXyEj93YhUbvrYM4EE5hxdBtPzQWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8853
X-TM-AS-ERS: 104.47.12.57-0.0.0.0
X-TMASE-Version: StarCloud-1.3-9.0.1006-27240.007
X-TMASE-Result: 10--17.586200-4.000000
X-TMASE-MatchedRID: gzVbiXtWD9sMek0ClnpVp/HkpkyUphL982SgwNf6SK5/iZ1aNsYG7ndv
        O8u+q1pdKYeaFKae6Lz3sQPKccofpQx5TL3qCTgEAD5jSg1rFtAEa8g1x8eqF3Eyvb3DXVhE5ax
        aw7fIL5FGk4qcd9wxZw4qvtoDTIAKn6xXepMP3Wd1e7Xbb6Im2lK6+0HOVoSott4vFM+nzlMEvn
        cM0Cy/pBk8ffVB7V0z6L+DGNlkhD9tVyxlb2HgKJd+vKkqem+eO8fk7n+zHAzDZ+9HI5nLbCYia
        X7LCuq+1pTtLKMW2+mHNDPTxAgTr7gNNywta23k72Rb2bEJC+2X2rvknNYlE4yW3GQHxHDTTO2W
        j/eDsouyjcZFbvUOyMz43V5/DvDfHChWHg5gjGqTeuX4xo2DEH2JWrzSHAwqa/+fqrgvoa2lKI4
        pJ+G9PzAfmA9yk0/GVTMBhQGAIf7M7NyB96bxz5KIqFdDcBucSk785FRpncVJKYD1WhGOCaPFjJ
        EFr+olA6QGdvwfwZanmxwscwVeE90H8LFZNFG7bkV4e2xSge6FK285nKzlbhPjWjcQtMf8viPoS
        x8JaG3kaczgxHn/15RMZUCEHkRt
X-TMASE-XGENCLOUD: 007a1e24-753a-4d60-a227-266addf4441e-0-0-200-0
X-TM-Deliver-Signature: 1FCBC07859B3F9A7CF598DAFAC1DF543
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=opensynergy.com;
        s=TM-DKIM-20210503141657; t=1667480550;
        bh=P+7QFb6FHsANTY4xS15aLwAPUyCp3ktUInhOlTX5hck=; l=3765;
        h=Date:To:From;
        b=E/X98Im9jALayAW35F1dQccu/lSNLvkMRCkHeCR/QRmNFyDbUczDDJEgykbHmTdIT
         TzQ0ukkadvrPosoIX/XNuw8P5O017JoMEADUIMXaMHlPU54Q490bbgiFQVozEx40Lx
         z1y60Ge2mGe07IK3BagAh8hoF0zAYjT4v9eYvE8opsT/OZ7BrM/ulkNWI8TdDvEKsZ
         HURxLbzHmyfkCza1nK+LtYiRWzDGYHPMCtMs3yRffaE3QdeTpB5mGP/zcZTbdrijxc
         hoHbWVNH+9VNopez1P278U4TfJZF32KoaWbyRrafDJt1b3NnfLYU8f/hCuSr8zFzVx
         CM8GaKchdP2+w==
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On 27.08.22 11:02, Oliver Hartkopp wrote:
>> +    if ((can_flags & ~CAN_KNOWN_FLAGS) != 0u) {
>
> For your entire patch:
>
> Please remove this pointless " != 0u)" stuff.
>
>     if (can_flags & ~CAN_KNOWN_FLAGS) {
>
> is just ok.
Too much MISRA habit in my head which has no place here. Did so.
>> +        if (can_id > CAN_EFF_MASK) {
>
> The MASK is not a number value.
>
> The check should be
>
> if (can_id & ~CAN_EFF_MASK) {
>
> or you simply mask the can_id value to be really sure without the 
> netdev_warn() stuff.
CAN_EFF_MASK is now treated as bitmask. And decided to remove this 
netdev_warn() stuff as proposed, masked the values. So I will miss 
invalid combinations from the virtio CAN device (may also be buggy) I 
might still be interested in but this excessive netdev_warn() usage was 
in the end also for my taste too much.
>
> Are you sure that you could get undefined CAN ID values here?
>
>> +            stats->rx_dropped++;
>> +            netdev_warn(dev, "RX: CAN Ext Id 0x%08x too big\n",

The proposed virtio CAN specification says: "The type of a CAN message 
identifier is determined by flags. The 3 most significant bits of can_id 
do not bear the information about the type of the CAN message identifier 
and are 0."

=> This trace could have been seen when a buggy device wasn't obeying 
the 2nd sentence.

>> +        if (len != 0u) {
>> +            stats->rx_dropped++;
>> +            netdev_warn(dev, "RX: CAN Id 0x%08x: RTR with len != 0\n",
>> +                    can_id);
>
> This is not the right handling.
>
> Classical CAN frames with RTR bit set can have a DLC value from 0 .. F 
> which is represented in
>
> can_frame.len (for values 0 .. 8)
> can_frame.len8_dlc (values 9 .. F; len must be 8)
>
> With the RTR bit set, the CAN controller does not send CAN data, but 
> the DLC value is set from 0 .. F.

RTR frames! DLC values <> 0 but then no payload. This needed to be 
reworked and fixed.

> When you silently sanitize the length value here, you should do the 
> same with the can_id checks above and simply do a masking like
>
> can_id &= CAN_SFF_MASK or can_id &= CAN_EFF_MASK
>
Did so. Too much netdev_warn() in the code, really. Too much is too much.
>> +    (void)netif_receive_skb(skb);
>
> Why this "(void)" here and at other places in the patch? Please remove.
> Is there no error handling needed when netif_receive_skb() fails? Or 
> ar least some statistics rollback?
Old MISRA habit to silence the warning when no error is expected to be 
possible to occur. This has no place here and was replaced by some 
better error handling evaluating the returned error not updating the 
statistics as proposed. For the (void) below just omitted the (void), I 
see no possible good error handling there and we're not going to run the 
driver through the MISRA checker.
>> +
>> +putback:
>> +    /* Put processed RX buffer back into avail queue */
>> +    (void)virtio_can_add_inbuf(vq, can_rx, sizeof(struct 
>> virtio_can_rx));
>> +
>> +    return 1; /* Queue was not emtpy so there may be more data */
>> +}
>
> Best regards,
> Oliver
>
Regards
Harald

(First answering all those review E-Mails, then will have to fight with 
sending the changed code).

-- 
Dipl.-Ing. Harald Mommer
Senior Software Engineer

OpenSynergy GmbH
Rotherstr. 20, 10245 Berlin

Phone:  +49 (30) 60 98 540-0 <== Zentrale
Fax:    +49 (30) 60 98 540-99
E-Mail: harald.mommer@opensynergy.com

www.opensynergy.com

Handelsregister: Amtsgericht Charlottenburg, HRB 108616B
Geschäftsführer/Managing Director: Regis Adjamah

