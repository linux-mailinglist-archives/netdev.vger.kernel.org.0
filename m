Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4C6D5522A9
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 19:19:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241794AbiFTRTq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 13:19:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241548AbiFTRTo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 13:19:44 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60069.outbound.protection.outlook.com [40.107.6.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF3F913D5E;
        Mon, 20 Jun 2022 10:19:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VbKh9wmyBGVsEukWZuLBaT0npnj2RiQYLUkVUYUftC/HZ9ElKzfNE2SEMEldGwkH/pVUCH6g1TeJ2eYU//up4f8jno2UC/G9yoQ5L3VW31rU9huDTQkyYsAxgxY4qIbG51CBV+CWiWBSW8llXWci5r/tQFZqIr9IuZAwgl9yfSGhhIAKOIitfm8vQ+LgoJ40MvktZRl6vnyn3+xwiavPWpF2XZohmPB2ZBtWV6AT1BiOuuOMv1pebSm2omagWFaKKEVPo3g4nHEKjUJdBAKHa+VUWrQtZ6NJvoPhsQUNe7DMrwRLMOhr4c68Z3oqv22WXMIB+FB/YKQSSIOMcXSTHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1DXeYASXxuuFPpFyHU2penJ/50t68yn8pWMIB2cb+/A=;
 b=ePCbnpnQUxLwzqP5Mf/+lyQaFXNo1UrNh4hGKCusq7EtMOqRQosbqtzXmdkwh3YlpT6DUyn3rxZHwHmDb9GjD6hu1yOstq4McakJ7nYAqkeGgqeuWqJS3u0iYXcdh4iZhg9+fl+JaGJ1pg69FDLp3O/+2uON8tRqOg3Lxt4L82Di35XFue/6hpJC+zw8cJOCRDyUjSi6cSFXQiNZgwHguyM9s3SIgtDa3QTZjEDWyctlXiaRU6HF4dt4mFgeR6AP5FJgy+Dpbti2wSQZHI/njYVzY0q93wD0xs4O3/Yx3GHO+QDUtwd2Ev3J9Bft2Fmh2EQIAHcafXEncv7WTCyxrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1DXeYASXxuuFPpFyHU2penJ/50t68yn8pWMIB2cb+/A=;
 b=tZO6z0Odcy62RBhE3+1Ow1pACSVFQkfJZWpweEAsr9ZY/MA68Q9Fi/DEw65sL5bWN6y9N902Gy3ghDHM1aXNrKTOkbkNcCMFEzcKV8ZcGKlxsaFGpfmS4fCzDT5MVjrt+/+AT5ohom3B41JUGH11XDHje5RnqtUJ2WkOQhWTXVujWyUnQxl8vD5hn0MI5/0ak45Ve5J5DsxrHrsFL7h3pSioKwu+Htq9LNZUeyvp6Pxhat5CLqmIaE6xZSnArlBNKR3HL1kKgWw45MpBbwcK/A5bymg84FNrX1TLE7bycnogcrhqoE5ehNSVBgmrR46aWEHYdpO/E3AimnAM53/1OA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by HE1PR0301MB2460.eurprd03.prod.outlook.com (2603:10a6:3:6b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.22; Mon, 20 Jun
 2022 17:19:37 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1%6]) with mapi id 15.20.5353.022; Mon, 20 Jun 2022
 17:19:37 +0000
Subject: Re: [PATCH net-next 01/28] dt-bindings: phy: Add QorIQ SerDes binding
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Eric Dumazet <edumazet@google.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Vinod Koul <vkoul@kernel.org>, devicetree@vger.kernel.org,
        linux-phy@lists.infradead.org
References: <20220617203312.3799646-1-sean.anderson@seco.com>
 <20220617203312.3799646-2-sean.anderson@seco.com>
 <110c4a4b-8007-1826-ee27-02eaedd22d8f@linaro.org>
 <535a0389-6c97-523d-382f-e54d69d3907e@seco.com>
 <d79239ce-3959-15f8-7121-478fc6d432e4@linaro.org>
 <e6ed314d-290f-ace5-b0ff-01a9a2edca88@seco.com>
 <16684442-35d4-df51-d9f7-4de36d7cf6fd@linaro.org>
From:   Sean Anderson <sean.anderson@seco.com>
Message-ID: <50fa16ce-ac24-8e4c-5d81-0218535cd05c@seco.com>
Date:   Mon, 20 Jun 2022 13:19:31 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <16684442-35d4-df51-d9f7-4de36d7cf6fd@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MN2PR12CA0029.namprd12.prod.outlook.com
 (2603:10b6:208:a8::42) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1d0776d4-112e-485a-f538-08da52e10d34
X-MS-TrafficTypeDiagnostic: HE1PR0301MB2460:EE_
X-Microsoft-Antispam-PRVS: <HE1PR0301MB2460174DE8D9AB9D5768E59996B09@HE1PR0301MB2460.eurprd03.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YsK9QaPbnG6SPTSk2KqW5RtnAyqw0Z3K00P9F/lmbLiyKqcTzxjmbv0Mp0Qg9WpJIvojrZ5Yy36XG0RDRsv2zIjLXOanqR1q1t2elpSs2kzamTXpZRdXQeYb8rhGfGO1d4KZVNnXEkAr8QYk4yQu7odbqq6nyZUNdbSm9TqUoIcqZwZ2FAfdr19QpE3Ec719TJLT0wgF7NZN2iu8k/MZc6S8yachHWjiUPYSQvFpFrj/++FryP9JVNgjXif7pLv8zQ/lYT223mpHiRvL2wFOXKieDhpIkGzxZ/UZZ/XXmkGK9sePSO00b7xySaaXHMXqbYkd8tfJPfYdBxxHkH6NjqldF/Sn1xXr5VGIwddTIl3qSonXoY87mYFxRPKA87gnEZlquTOF6C3XRPsVItOgyFr+xEDqLyXEjOf9Zn/3UpGb6YOKSYcinTSq61jKPffooPFecWniSh0n6qgY1ECCMMiqcohmeCQDoHrfrELjCDPGt+d94IjutfCGRFHrpydP41dKMN/spPU8aEovnXBcrqKZBLNGPDVVCM+647OqBIuxjiFNUbLPFw3jUfZr9SDQG/2moqSpFWIawpBdZwGrEHqoJgAw4zDzY4nLV3DFZysYUdd88pW4utrhsZMTX7dPsG+37OGK2JrveGouUEDYgJFf3visxlJKAgTOHH+k1Lyp1gzNu6e0badqfcMPJSkhs0NiLi95YCSbDmh3UBeBhW9Cc7hCXuJYbcfUmS4RYkUyuZfT2lBuWrT0WVbWRcWerublIJHQn8McbSng7XBH/w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(136003)(396003)(376002)(39850400004)(366004)(54906003)(110136005)(38100700002)(8936002)(38350700002)(6486002)(36756003)(478600001)(316002)(41300700001)(2616005)(52116002)(83380400001)(53546011)(31686004)(6512007)(6666004)(86362001)(31696002)(30864003)(7416002)(6506007)(5660300002)(44832011)(26005)(8676002)(66556008)(4326008)(66946007)(2906002)(186003)(66476007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d3l3NFFqZzhPNzZRdzRsZlV2eFFYRFVobE9XUHA4NVd2bUpsUkFrczhSTE8w?=
 =?utf-8?B?cklDNDlKc3dwMjhnUWNkZ3dSZ0dTS1NSc2l6dVRYbXFzL2tYNTZHaENEWUpR?=
 =?utf-8?B?Y3YyWDNOaytmNCtzbHR0c0pXTnkwUHJoZEdNZEpMcUx5ZTJpT0RBMmJNa3lj?=
 =?utf-8?B?dWFlcnN6R0prU08vbkpwYnR3WFBuNm5lOURXenptNVZhU2FaRjNNYXM1RTF4?=
 =?utf-8?B?Q3IxNWduTk1ONmpOVVliUHpmbDJLKy9mS3RXQVprdHZhejFrZy9xNmJ0RGZp?=
 =?utf-8?B?RmNIazBrNzhSeHpqNFNqVHJQY0pDSWNHcXZub0swZFoyYmlYcmNTKzc5RUJx?=
 =?utf-8?B?UDh4clhVeFV4UkNQQ25EMGVZcFM3MnNRZmJpUWl0dFV3d2l3eU9EQ2tDRjBi?=
 =?utf-8?B?SWVBbFJYVTQ2bjE0WUYzTUJOUDMrbE5NdWF3NGdMQXIvRzZCaG5pVW9ObHkz?=
 =?utf-8?B?VXY0L01KNHRpN1BENGdhM2xiWm42SS9Qb2Q1YitwV0JHSHR4SlVPc01kTnlo?=
 =?utf-8?B?UWpWU0g5cUk1b0FwK0h2ZEZsN29DRUU3VnY4cTZ1MmJ2QldBck5QdDJBbVVs?=
 =?utf-8?B?V1BldTVWc0c1OUtERkZMNzVyUkUwZHhyVm94Qi9PaEFNWlp2K1VGTHp3RVdS?=
 =?utf-8?B?MHNZQXFxMnhIaGJlOW4wandOc1RtK2RybEVncGJuM3EvZVhJWGYzV1hiMEJK?=
 =?utf-8?B?SXlraFdVSzVaL1B4NDJyOXdCZzQwbUtGODhKSTAxcHRoLzJwMjF1Z2VmWTNR?=
 =?utf-8?B?Ky8vTnJ5SXJuOEhnUFFyeGs1YWpCWlExTVFkZE01d3NKR1RnSzVYWGkzT2Q5?=
 =?utf-8?B?WEV5czVGSVpsVDBGdkJ1akpidDA5UlRLdDV4ZmtYTXdEY3lWR2tOLzl0Uitv?=
 =?utf-8?B?NHNPNnhOclFmdUZ0Tk1qcXNxdXIrU0VuRkNXN3F5WUh1NEdDckRNeFNUS09L?=
 =?utf-8?B?SW5RS0FmcU1sUkVSUjNzVDNRU1VFNkoweTN1YWhvTzNXdllYTGNOWGRRNU1t?=
 =?utf-8?B?SGFWdlI4L3A5ZUNxbEU3WXZ0SGVwOXUvZHd5R2praWJscXAweEJYZzFHWUV1?=
 =?utf-8?B?aTlCZ0ZYWFArWHVTNitTcXhEeTZoQnJ1Q1VQVWdxWWtGUU5HSHFLeVN0cEhw?=
 =?utf-8?B?NDZWUGFVRHVjVTNaSGJhZFFtcm5TUlpUS1FJWnkzWnNMb2R0ZXdpUzlGdnlS?=
 =?utf-8?B?ZDlzOUIyakdwOTNYVnEraFBBdWc1UEFoU1NMb2Y3c2xLZmIvZ1lVN0h6NWNP?=
 =?utf-8?B?MUgvZUIwT3lCRGJnTkZQNmdkOVRySzZEcE1PcXlocE41ZkYyZXBjUXR4U002?=
 =?utf-8?B?SFR0TEdNaGJIRUhmNzRZZElQekRUcWxPOTV2WDVadlBnZkdGb2NLTFFBOEZE?=
 =?utf-8?B?T1V1Ly85U0MrUTZqT0FHUzhRVFNvVVNsam16YTdjdVV4LzV6eGwxdUhyeURj?=
 =?utf-8?B?UExJeERmNnJMVHBrcVk1TW16Qm1Bc1pzcXZBaGhzMklzQ1ZEd095T0o0UGE2?=
 =?utf-8?B?QmFpZFY1WUs1OExiNUVqbkEzdTlTT255Rll1RmJCSnZWNHBndUhxelI5dkg2?=
 =?utf-8?B?WDcxalk2YjNBN1VseHJZTVFVckNTdEs1VTVOMjdmRkpiUUdJNzBJL2RUZEFz?=
 =?utf-8?B?Tmo4YnBvNkQ3OXR0RG1MQklTRUdTZDI3ZWJZbG9NTXU4NnVuZGZTK3l3dnIx?=
 =?utf-8?B?VzM4S2FuaFEraXhMRnNFcVZMZXYwbXdnN2dsZVo0V3pzSCtETjNKaFRnSlYr?=
 =?utf-8?B?WkpBWkRUcnlTQ2NLSS9TK0U2OW11UXZPRVplVTc2Nk5JdXdvMDNTcTVaY2Vt?=
 =?utf-8?B?NVVtMjZlbWdDdVl3ZllUeVp6ZUZXZ05SclBiQXkwd0VuSnVicE5GK3dvRmUx?=
 =?utf-8?B?YnhmTUpaa3FQV0YvakNMWHFsSkQrZXJFVmVzK0JqeTN0OU1kZjF5cjhOOXk1?=
 =?utf-8?B?Zk1vTXhBcFdXWHZaTm1UWnZ4MEJDN0FxaDVGVlEzT1lmYktqcjF1K0I4cTNo?=
 =?utf-8?B?Z1FFNVVhN3lSVnFrREw3U1ByZXpIaDRIaHBoZU1GdmdYZDF6ZmZDMWE4Ym44?=
 =?utf-8?B?YzNrOUs3REZJRHlFd3plVUlwenZUUTNGQ3R1dDFtYU1jaFRFWnNqbUN5MTZa?=
 =?utf-8?B?QkRuY01acVp1QmtKZnVSN2R0NlVwdmJtQnFpMEh3c29oL0pLNjVMdXNsUTdq?=
 =?utf-8?B?MHpjbk5xd1dNNjI2ek9TT3M5MUNaMnkrZWVtZGNqVlNjRGM2d2Q1WGk5NWo5?=
 =?utf-8?B?RzAraCtHRnNycFVuYWlVYXk1VWduWFpVVkovUnd4SlpLQVRxZ0ZkYWFNM0d1?=
 =?utf-8?B?K1N6NStqSkwxQUx3bStaUElaa0JEWWx2YTRkeUZtNldtSUhUU1JmbDhKZFNQ?=
 =?utf-8?Q?qZxcXaFZd/UVcTuU=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d0776d4-112e-485a-f538-08da52e10d34
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2022 17:19:37.0446
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e9wK6OyPKxf5JVT04thEHwBkB1FdClrIEtr87oAxVFlY0AE4armJ80tZ0U8YvJYutVZbf3jTks7gD52z0vvWqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0301MB2460
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/20/22 6:54 AM, Krzysztof Kozlowski wrote:
> On 19/06/2022 17:53, Sean Anderson wrote:
>>>>
>>>>>> +          The first lane in the group. Lanes are numbered based on the register
>>>>>> +          offsets, not the I/O ports. This corresponds to the letter-based
>>>>>> +          ("Lane A") naming scheme, and not the number-based ("Lane 0") naming
>>>>>> +          scheme. On most SoCs, "Lane A" is "Lane 0", but not always.
>>>>>> +        minimum: 0
>>>>>> +        maximum: 7
>>>>>> +      - description: |
>>>>>> +          Last lane. For single-lane protocols, this should be the same as the
>>>>>> +          first lane.
>>>>>> +        minimum: 0
>>>>>> +        maximum: 7
>>>>>> +
>>>>>> +  compatible:
>>>>>> +    enum:
>>>>>> +      - fsl,ls1046a-serdes-1
>>>>>> +      - fsl,ls1046a-serdes-2
>>>>>
>>>>> Does not look like proper compatible and your explanation from commit
>>>>> msg did not help me. What "1" and "2" stand for? Usually compatibles
>>>>> cannot have some arbitrary properties encoded.
>>>>
>>>> Each serdes has a different set of supported protocols for each lane. This is encoded
>>>> in the driver data associated with the compatible
>>>
>>> Implementation does not matter.
>> 
>> Of *course* implementation matters. Devicetree bindings do not happen in a vacuum. They
>> describe the hardware, but only in service to the implementation.
> 
> This is so not true. > Bindings do not service implementation. Bindings
> happen in vacuum

Where are all the bindings for hardware without drivers?

Why don't device trees describe the entire hardware before any drivers are written?

Actually, I have seen some device trees written like that (baked into the chip's ROM),
and they cannot be used because the bindings

- Do not fully describe the hardware (e.g. clocks, resets, interrupts, and other things)
- Do not describe the hardware in a compatible way (e.g. using different names for
  registers and clocks, or ordering fields differently).
- Contain typos and errors (since they were never used)

These same issues apply to any new binding documentation. Claiming that bindings happen
in a vacuum is de facto untrue, and would be unsound practice if it wasn't.

> because they are used by different implementations:
> Linux, u-Boot, BSD and several other quite different systems.

U-Boot doesn't use devicetree for this device (and if it did the port would likely be
based on the Linux driver). BSD doesn't support this hardware at all. We are the first
to create a driver for this device, so we get to choose the binding.

> Any references to implemention from the bindings is questionable,
> although of course not always wrong.
> 
> Building bindings per specific implementation is as well usually not
> correct.

Sure, but there are of course many ways to create bindings, even for the same hardware.
As an example, pinctrl bindings can be written like

pinctrl@cafebabe {
	uart-tx {
		function = "uart-tx";
		pins = "5";
	};
};

or

pinctrl@deadbeef {
	uart-tx {
		pinmux = <SOME_MACRO(5, UART_TX)>;
	};
};

or

pinctrl@d00dfeed {
	uart-tx {
		pinmux = <SOME_MACRO(5, FUNC3)>;
	};
};

and which one to use depends both on the structure of the hardware, as well as the
driver. These bindings require a different driver style under the hood, and using
the wrong binding can unnecessarily complicate the driver for no reason.

To further beat home the point, someone might use a "fixed-clock" to describe a clock
and then later change to a more detailed implementation. They could use "simple-pinctrl"
and then later move to a device-specific driver. 

If the devicetree author is smart, then they will create a binding like

clock {
	compatible = "vendor,my-clock", "fixed-clock";
	...
};

so that better support might be added in the future. In fact, that is *exactly* what I
am suggesting here.

>> 
>>>> , along with the appropriate values
>>>> to plug into the protocol control registers. Because each serdes has a different set
>>>> of supported protocols
>>>
>>> Another way is to express it with a property.
>>>
>>>> and register configuration,
>>>
>>> What does it mean exactly? The same protocols have different programming
>>> model on the instances?
>> 
>> (In the below paragraph, when I say "register" I mean "register or field within a
>> register")
>> 
>> Yes. Every serdes instance has a different way to program protocols into lanes. While
>> there is a little bit of orthogonality (the same registers are typically used for the
>> same protocols), each serdes is different. The values programmed into the registers are
>> unique to the serdes, and the lane which they apply to is also unique (e.g. the same
>> register may be used to program a different lane with a different protocol).
> 
> That's not answering the point here, but I'll respond to the later
> paragraph.
> 
>> 
>>>> adding support for a new SoC will
>>>> require adding the appropriate configuration to the driver, and adding a new compatible
>>>> string. Although most of the driver is generic, this critical portion is shared only
>>>> between closely-related SoCs (such as variants with differing numbers of cores).
>>>>
>>>
>>> Again implementation - we do not talk here about driver, but the bindings.
>>>
>>>> The 1 and 2 stand for the number of the SerDes on that SoC. e.g. the documentation will
>>>> refer to SerDes1 and SerDes2.
>>>>    
>>>> So e.g. other compatibles might be
>>>>
>>>> - fsl,ls1043a-serdes-1 # There's only one serdes on this SoC
>>>> - fsl,t4042-serdes-1 # This SoC has four serdes
>>>> - fsl,t4042-serdes-2
>>>> - fsl,t4042-serdes-3
>>>> - fsl,t4042-serdes-4
>>>
>>> If the devices are really different - there is no common parts in the
>>> programming model (registers) - then please find some descriptive
>>> compatible. However if the programming model of common part is
>>> consistent and the differences are only for different protocols (kind of
>>> expected), this should be rather a property describing which protocols
>>> are supported.
>>>
>> 
>> I do not want to complicate the driver by attempting to encode such information in the
>> bindings. Storing the information in the driver is extremely common. Please refer to e.g.
> 
> Yes, quirks are even more common, more flexible and are in general
> recommended for more complicated cases. Yet you talk about driver
> implementation, which I barely care.
> 
>> 
>> - mvebu_comphy_cp110_modes in drivers/phy/marvell/phy-mvebu-cp110-comphy.c
>> - mvebu_a3700_comphy_modes in drivers/phy/marvell/phy-mvebu-a3700-comphy.c
>> - icm_matrix in drivers/phy/xilinx/phy-zynqmp.c
>> - samsung_usb2_phy_config in drivers/phy/samsung/
> 
> This one is a good example - where do you see there compatibles with
> arbitrary numbers attached?

samsung_usb2_phy_of_match in drivers/phy/samsung/phy-samsung-usb2.c

There is a different compatible for each SoC variant. Each compatible selects a struct
containing

- A list of phys, each with custom power on and off functions
- A function which converts a rate to an arbitrary value to program into a register

This is further documented in Documentation/driver-api/phy/samsung-usb2.rst

>> - qmp_phy_init_tbl in drivers/phy/qualcomm/phy-qcom-qmp.c
>> 
>> All of these drivers (and there are more)
>> 
>> - Use a driver-internal struct to encode information specific to different device models.
>> - Select that struct based on the compatible
> 
> Driver implementation. You can do it in many different ways. Does not
> matter for the bindings.

And because this both describes the hardware and is convenient to the implementation,
I have chosen this way.

>> 
>> The other thing is that while the LS1046A SerDes are fairly generic, other SerDes of this
>> type have particular restructions on the clocks. E.g. on some SoCs, certain protocols
>> cannot be used together (even if they would otherwise be legal), and some protocols must
>> use particular PLLs (whereas in general there is no such restriction). There are also
>> some register fields which are required to program on some SoCs, and which are reserved
>> on others.
> 
> Just to be clear, because you are quite unspecific here ("some
> protocols") - we talk about the same protocol programmed on two of these
> serdes (serdes-1 and serdes-2 how you call it). Does it use different
> registers?

Yes.

> Are some registers - for the same protocol - reserved in one version?

Yes.

For example, I excerpt part of the documentation for PCCR2 on the T4240:

> XFIa Configuration:
> XFIA_CFG Default value set by RCW configuration.
> This field must be 0 for SerDes 3 & 4
> All settings not shown are reserved
> 
> 00 Disabled
> 01 x1 on Lane 3 to FM2 MAC 9

And here is part of the documentation for PCCR2 on the LS1046A:

> SATAa Configuration
> All others reserved
> NOTE: This field is not supported in every instance. The following table includes only
>       supported registers.
> Field supported in	Field not supported in
> SerDes1_PCCR2		—
> —			SerDes2_PCCR2
> 
> 000b - Disabled
> 001b - x1 on Lane 3 (SerDes #2 only)

And here is part of the documentation for PCCRB on the LS1046A:

> XFIa Configuration
> All others reserved Default value set by RCW configuration.
> 
> 000b - Disabled
> 010b - x1 on Lane 1 to XGMIIa (Serdes #1 only)
You may notice that

- For some SerDes on the same SoC, these fields are reserved
- Between different SoCs, different protocols may be configured in different registers
- The same registers may be used for different protocols in different SoCs (though
  generally there are several general layouts)
- Fields have particular values which must be programmed

In addition, the documentation also says

> Reserved registers and fields must be preserved on writes.

All of these combined issues make it so that we need detailed, serdes-specific
configuration. The easiest way to store this configuration is in the driver. This
is consistent with *many* existing phy implementations. I would like to write a
standard phy driver, not one twisted by unusual device tree requirements.

>> 
>> There is, frankly, a large amount of variation between devices as implemented on different
>> SoCs. 
> 
> This I don't get. You mean different SoCs have entirely different
> Serdes? Sure, no problem. We talk here only about this SoC, this
> serdes-1 and serdes-2.
> 
>> Especially because (AIUI) drivers must remain compatible with old devicetrees, I
>> think using a specific compatible string is especially appropriate here. 
> 
> This argument does not make any sense in case of new bindings and new
> drivers, unless you build on top of existing implementation. Anyway no
> one asks you to break existing bindings...

When there is a bug in the bindings how do you fix it? If I were to follow your suggested method, it would be difficult to determine the particular devices

>> It will give us
>> the ability to correct any implementation quirks as they are discovered (and I anticipate
>> that there will be) rather than having to determine everything up front.
> 
> All the quirks can be also chosen by respective properties.

Quirks are *exactly* the sort of implementation-specific details that you were opposed to above.

> Anyway, "serdes-1" and "serdes-2" are not correct compatibles,

The compatibles suggested were "fsl,ls1046-serdes-1" and -2. As noted above, these are separate
devices which, while having many similarities, have different register layouts and protocol
support. They are *not* 100% compatible with each other. Would you require that clock drivers
for different SoCs use the same compatibles just because they had the same registers, even though
the clocks themselves had different functions and hierarchy?

--Sean

> so my NAK
> stays. These might be separate compatibles, although that would require
> proper naming and proper justification (as you did not answer my actual
> questions about differences when using same protocols). Judging by the
> bindings and your current description (implementation does not matter),
> this also looks like a property.
> 
> 
> Best regards,
> Krzysztof
> 
