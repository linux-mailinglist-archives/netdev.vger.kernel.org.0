Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D26C361FFD1
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 21:50:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233067AbiKGUut (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 15:50:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233057AbiKGUus (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 15:50:48 -0500
Received: from EUR03-VI1-obe.outbound.protection.outlook.com (mail-vi1eur03on2078.outbound.protection.outlook.com [40.107.103.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AE2224F35;
        Mon,  7 Nov 2022 12:50:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S7lOUkD5yX4p0ElkZahRISHV6P3MIRTxRstWLwluOJ0MOvPQBbkWbanFvYsHu2g4YFUOmcGCcw1emwofSLsCAbXxi+8svmYXNm2I0lwkKSKrK9PUyPEok57L493oyzm5FU51AK6YBt8SRvV7fYa9J5Sk1E/gJgjvQ1LiAXTOcNMk+Tqj/dxriZqz+zdgrI/EU/2cjLp+MoW/TJ5KZzBYsP7wKeI2XGqcKqG1iH89V29KnHaWqgxcXFB3yX479pCmngLGxQHGfCO1+QqH2xcd1AKKdzdp1uDmanqPQwf9ubaHAB3hkykf8bZY7mEOPqSJIqgtNiUaSI7Uke4A68wPtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3dmFuPYSRwdopL0yEsEh53yHHCz5/U/MKNRTNbNyFjY=;
 b=KWQeXFPkI3jylMFegZKH2j5RX7hs+RDANL2ln+V4EvfOE99a18gpmlx7v1CycP4El6VuZBfu2OCfWYWTa9mRRjhOrtc9Oq5s5XTAPhrqFmYvdNWnAdUaHC9f8ZHPVyPhkCfdLsiQD5oORAlaVCbeitvfacWhOTWDHo38De9uzPUpSIP2c6v6ZmB+QLyPPeA+RRgH6KNff3ecK0ZAjat0kMTRT0eYALvlu8+sEs419bn+DvIRw+hrPl8ZTTsJUI8wUJ5RG5G71jU2cczgxN6ta9Ix58gIn9WkrkxLLrFKNp8ZiGPhG9gThIp1hULQLunc9FDTHLrULoeBcIwf442lIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3dmFuPYSRwdopL0yEsEh53yHHCz5/U/MKNRTNbNyFjY=;
 b=BC4bIrFoKsBItQN/mqskDrRSqlL2tHgt/Jp0TocSgT9zFYAZ4XixXfFj2T2xjgUUlS/tcCCbF/pD4Wzl9JQrp6Fqw8k+PdoS3nHuPX3I7P8C32swP3GPTNcr7iulLZ/EEnCvWzzoMa5AKseJxV4fUlBEqaDr+CxMBTg710GvmJcTY+wbPNhnREzJP9AEg4wdbhToQoNK6fIwsDGBzWk8Pa5xUJ6dJrGnGH7MfvrupzFfrbYZVKEjuphZbIm6g0/7IlwPKX2wUajz/yZ8ziPPprPNiMwakdGMoqBglVBFdiiGk0mjR3Bq4/b7w/Yr/fxZcRimTP5AqK1Dc27Wv6rKhA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by DB9PR03MB7337.eurprd03.prod.outlook.com (2603:10a6:10:228::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.22; Mon, 7 Nov
 2022 20:50:42 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::e9d6:22e1:489a:c23d]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::e9d6:22e1:489a:c23d%4]) with mapi id 15.20.5791.022; Mon, 7 Nov 2022
 20:50:42 +0000
Message-ID: <7caf2d6a-3be9-4261-9e92-db55fe161f7e@seco.com>
Date:   Mon, 7 Nov 2022 15:50:37 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH net-next v2 08/11] of: property: Add device link support
 for PCS
Content-Language: en-US
To:     Vladimir Oltean <olteanv@gmail.com>, Rob Herring <robh@kernel.org>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Frank Rowand <frowand.list@gmail.com>,
        Saravana Kannan <saravanak@google.com>,
        devicetree@vger.kernel.org
References: <20221103210650.2325784-1-sean.anderson@seco.com>
 <20221103210650.2325784-9-sean.anderson@seco.com>
 <20221107201010.GA1525628-robh@kernel.org>
 <20221107202223.ihdk4ubbqpro5w5y@skbuf>
From:   Sean Anderson <sean.anderson@seco.com>
In-Reply-To: <20221107202223.ihdk4ubbqpro5w5y@skbuf>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR22CA0025.namprd22.prod.outlook.com
 (2603:10b6:208:238::30) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB7PR03MB4972:EE_|DB9PR03MB7337:EE_
X-MS-Office365-Filtering-Correlation-Id: 106d962f-e441-4f95-fe11-08dac101bc3c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: d20gLlUR2gJRbvNKnNCcwaLLa4nFDwC7pwbyVwvdjBfQiN+hAJ5sKAOne8D84uNW+cXvSGOUy1kM/V/sO/blpC2AJisxk+qrctGVAX5tMSEEgQn0I+pH6bBaeVY/rsxM77Tus2LgBh39dToFM6Jgp9NNl8zsDWcMYfokXH9G+JF6ogKlL5CwnSSZHwmbJuz86jp68ZBIDiOLLfef9llakfA8RQJfk/EN7j4CTqmpe3dQOwuvJscpI8DS4F/UgwEs8shiDs7T5FNKvAGYoJ0FhzwIabE/bXtXOSBaXDaKbPpm9umbC/XYc8WY9fLx5soj0TbGaPYgxy4yr9EBT+1/xgB6/Fs+LVuMKkhCuihQ3r0fufpqScSv9ZiVBQtdkZAsCgXdpvCs4ZVpr+KMjrOODb4i7uqIeClkU8OBLudI5SUsiKAv2hB1cXQ81HmnRIuMhwe7Gf/YnWvsVAplaidnBKnKOqVBnV+g6vcCMpVrwaPGU/luTReSnRHHkx3C8IRwSahGwMXSz/v/wkoV0UqgFXY8gBwdPXeRTerTCNw0dcldAl2pGZtqtWaHeh1tWSqQiiQZ2NMXWzrLcBD+oiN2bZVK1tiNSLFklxwj+nouLfoPsTH0yTUVigImXc7KMENgCcahEF3xmM8rbeRfmKoGpqNPlroojb75IX/t6hwQCOeih0WpIDWqFkZRFvrampsdhfy3/Tb7gtSZxTrs3AYU+Hm7iZnjuABiDmA2zkfh/9IOzrSo9XHR2LSyWsPIrQWWxwyTfDbIAJ3A4KMBZDz0KaWZz8SVuvDnw21Kfrqy6JDFOsNCwmxCUIYYkVrQoOohfosNHh2861Z0U4WDXF+u+oHF4xlC/2tL3lMmIzGoLiE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(396003)(346002)(376002)(39850400004)(451199015)(36756003)(31686004)(86362001)(31696002)(5660300002)(7416002)(44832011)(2906002)(52116002)(6666004)(26005)(6512007)(2616005)(6506007)(53546011)(186003)(83380400001)(38100700002)(38350700002)(54906003)(110136005)(8936002)(478600001)(4326008)(8676002)(66946007)(66556008)(66476007)(316002)(6486002)(966005)(41300700001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dC9kSjJLVnQ0Ri9rakQ5NzhBQTFHYitHR3I0dGEyeTdQQ2thU2lBV0Fpd2dK?=
 =?utf-8?B?YStXUTMwQTRiUDNldXlRYTRVS2Z1bG5lZWZkRmM0UWpsVUVzbHRjQnhQK2pD?=
 =?utf-8?B?M3g5K0VYOUxDaFhVV1FvR0wyVlNCeFl6YS81RjFaYWpWZlZPRXRvZklmWlFu?=
 =?utf-8?B?QXRMSTg5L3VrYmFIaGZLSXFESFd4YlNpVFBRWGVJK1g5ZTlqbmNtRDdEU0lZ?=
 =?utf-8?B?MUVKVzFndHBLNDBOQUdHMy96c3BjRHVGYk9ZTjhnQTJsbWY0WFlqWmp3dWc5?=
 =?utf-8?B?ZGxBenpPNkM1WG1ZSDJGT3BkbTlHTFZuemRwTzQ5K1FsRTF2NW9NWWQ2eS9T?=
 =?utf-8?B?QWU4ZE1odVNNZ0hUYlZyeE9hMTEyb2txc2MzMlI0ZkowUEhoVzN6WU5zRlo0?=
 =?utf-8?B?aDl2SVc5eTh3VEZ0UVN0RHA4dWpYSWxDYmRSTHhtcXdyN3d6alV1LzFDNHk4?=
 =?utf-8?B?TFBZcVc0YTBYL2NSemQyZllKaTVkUWVJcm4yby90MHRNV0dIc1VVZk1VTk5a?=
 =?utf-8?B?R2pWU09Ed0h6Y1JlWkJjb0ZKb1FscU5YaTViM3dBb1FTcitQc2xyVXpWVExP?=
 =?utf-8?B?UTVDS1QyeG5YYzlycDBGUXZOcGkzck9YbVZHREpEL0Y1YVpCM3dqK25nWWd6?=
 =?utf-8?B?Uml1TzNNQ0QzK1RETDdSOUNmSFU5NWJmclRiYnNpMndVRUJzU1BkdmN2bmZs?=
 =?utf-8?B?b0QwMENnRkZsNzl5THVrNHlDOTVKQUYrNjJkRkF1SjRrY3RwR1Vsb1BEU1hN?=
 =?utf-8?B?WjJtczJ0OEpRYmFoOEY5YkJvd0hweVIzMXZoRXpoSzZJcHlpOXV5MW9EQWpJ?=
 =?utf-8?B?cDJud1ZobFdkRGVNRFNxenhUUHkyVzNrc0V3Y0Y1eG5EZFU0YnJHYVdGc2xP?=
 =?utf-8?B?Z25obHhMK2JnYWprdlFSVXVucjFXaVhEYlJFS3BPeUZWcDB4ODRxbDNRRHpx?=
 =?utf-8?B?aUxhMng3aThYMlBnanlMVDhXdzVjRlFBbkN0bjlOVFZsNytlUytHQ1d6RFJN?=
 =?utf-8?B?eVN3Q2pwQXlPTk9ZMkpEeVhRc3ZxZ3d4amtubzIvNVNrN3hhOWR1UlBVQTdT?=
 =?utf-8?B?eW5oYXM3RStCcEo2R1R2TjVMQWxTS1ErWTBoMkxZdjZyYm9Ldno2enVyZkYv?=
 =?utf-8?B?TnpNeVhFUFg0T2Y3dktvajlpa1ZVTzFVcG0xbCt6anpNNzVsM2FTaCtCbTFE?=
 =?utf-8?B?ZDRjWmNzM3JXT0ZGNktnWm9PTjVJTGloWlNjYTNuUXZyR2RIQXBrRFRCMjhM?=
 =?utf-8?B?VFRvS25sT0RvT3NTY1RQMzVWVk9XQktGa2RUbGg4cmZ0bDFPZDd1Vlo4NDRZ?=
 =?utf-8?B?T3J4MHJsUThRUXRtSzdDa3p6ZTE4SUQwUW5ueURPQ0VtVS90MVNBOW42L3NP?=
 =?utf-8?B?bUlHaktPOFQ5Y3owZjdMWXRheUY5d04xc3FUajJaTW9QRm8rRmRrMDY3Qnpu?=
 =?utf-8?B?OC90QldCbFYzb2RVeDl3cjBZaUNoZW1HMXROTmx6Mk1wUU5RejNsenlzSWhu?=
 =?utf-8?B?ZW4ycDVERVpHVEluaFl5eFYybFc1U05Vb2dmbTF5ZkthSDhhMnRDTHhBU0tW?=
 =?utf-8?B?aVVkbmh3dXB2L2VBZ0NXRFFqQUtuaU9DUlQxZGU4c2owcDB1ckhGZkRYb0FM?=
 =?utf-8?B?RVkvQXFpRzZoenQ3TDlPclFNNlZTN0dlUmQ4a3lBcmhqY3N1cVo3aUtISzZw?=
 =?utf-8?B?ejFNNkJkaHNZckNYa0hhNUFoK1M4TkJ2TmJ6cUpjYU5KOGowTkxNWFByN1RN?=
 =?utf-8?B?dzRRWUxLK2wwSVdzb1NrOEl2Sk5VcDFGbWlibjZ6Z1V3ZWs0Yno4Y1o0UEYv?=
 =?utf-8?B?NDdHMnplSXlVOUlVZGZDWWVYZ2ZxMCtvbk1QUURraFc1UHVrR2g0RXd2OFFk?=
 =?utf-8?B?WUhwOHFLL1NNY3ozM3Nncy9lT0tMOURjT3AwTWlJMFMwdisrQXo4aGtlckhK?=
 =?utf-8?B?Q25maXF2blZydHBPSU5hemNyTmRQWkg4WFJBQmhNZW1EcUhjeDRjVWdneHV4?=
 =?utf-8?B?WGt2cnhNYXIxTitSRVQwMUI0VW1WS08zTmsyODEyVE5WTjlEUS95Rmt4Q2pq?=
 =?utf-8?B?MEF4dHA3NjJVajNFUGtmU1pYNWFpMmZCcWEvcVpkUjhnUFRYazRScUxqREVu?=
 =?utf-8?Q?HejQ2RlU1rmo9KKH9L7np3zGO?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 106d962f-e441-4f95-fe11-08dac101bc3c
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2022 20:50:42.6088
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IL2WQymvfXxwfCVEA0HCmGHB/xa+KQ9xh1SaqRsyLiIB7RZpvU9roZ0B61MsPROaj5ye6NEQqVylLF5xERNsYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR03MB7337
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/7/22 15:22, Vladimir Oltean wrote:
> On Mon, Nov 07, 2022 at 02:10:10PM -0600, Rob Herring wrote:
>> On Thu, Nov 03, 2022 at 05:06:47PM -0400, Sean Anderson wrote:
>> > This adds device link support for PCS devices. Both the recommended
>> > pcs-handle and the deprecated pcsphy-handle properties are supported.
>> > This should provide better probe ordering.
>> > 
>> > Signed-off-by: Sean Anderson <sean.anderson@seco.com>
>> > ---
>> > 
>> > (no changes since v1)
>> > 
>> >  drivers/of/property.c | 4 ++++
>> >  1 file changed, 4 insertions(+)
>> 
>> Seems like no dependency on the rest of the series, so I can take this 
>> patch?
> 
> Is fw_devlink well-behaved these days, so as to not break (forever defer)
> the probing of the device having the pcs-handle, if no driver probed on
> the referenced PCS? Because the latter is what will happen if no one
> picks up Sean's patches to probe PCS devices in the usual device model
> way, I think.

Last time [1], Saravana suggested to move this to the end of the series to
avoid such problems. FWIW, I just tried booting a LS1046A with the
following patches applied

01/11 (compatibles) 05/11 (device) 08/11 (link) 09/11 (consumer)
=================== ============== ============ ================
Y                   N              Y            N
Y                   Y              Y            Y
Y                   Y              Y            N
N                   Y              Y            N
N                   N              Y            N

and all interfaces probed each time. So maybe it is safe to pick
this patch.

--Sean

[1] https://lore.kernel.org/netdev/CAGETcx97ijCpVyOqCfnrDuGh+SahQCC-3QrJta5HOscUkJQdEw@mail.gmail.com/
