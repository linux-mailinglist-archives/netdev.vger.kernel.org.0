Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25FFF561FFF
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 18:11:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235984AbiF3QLW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 12:11:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235499AbiF3QLV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 12:11:21 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2061.outbound.protection.outlook.com [40.107.21.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4BC429C98;
        Thu, 30 Jun 2022 09:11:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N1e/7o8C1H4uiLJQBsg2JxZmi3LnFeZq6kgX+Poasu9DhbqfwX8lHY/KKEw1/e8tTFthL7fmaf9mg3OEF00DgeItmYFRH0sNWk9Z6zUUszwS2Z341zCPhotQXN6/fe8ZYgLI+kf8Ki+HiasOL1ALPE2XMiH45BAglxhM23w0yQFHaJPJVMosleUsAdMR1mX9sGFciCQaeobVH+ikNDAp//soMLqHEqrpio+WAZMYo+cfSalKbekytcwn0IQ/gsURVTFiMfiwSLNxIV7OX+wmur3M7fenyPrwmlPNp3Ki74BZH5BYQwR2acGN4gvRuZBFmrxxtoM11Ttr0e3WkyoEdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s6n+UgYfZkdnFrPqUgtvjzYo7R2V2MU2VdksBg45LtY=;
 b=QS2da0hHJ/Z6eYWHAJWy2WJ+zg4tqzX988PolOyc9Rr79FJlFXyMYyolta0bBs47ZLnjsGTkWUvUFPYPgRu/vdDIHIVZx/5eCSSCi649e8q+Sd9np3462zYOImlT3W5LoVxiGgLu2ndkoTaCMlXMqOMw1ktaX3SfV2DieiYMVb05CHFlEDV5Hd8X66DPi8VAXZ2/pAS2CzzCBD0wkpqNC5VL4Pl4YNOisp2SJXo4rdhmZ9hJvC+ElDE1I9CrXSgjtnsFJX624nz3yHK4+Qkr0IRkCrKlqrn/j/GHxYoWt7l4kUvyI6bsbVuTuX4fbRFIzgb/ex8H5zamZIq3+pkWOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s6n+UgYfZkdnFrPqUgtvjzYo7R2V2MU2VdksBg45LtY=;
 b=zT2DLHTy2EeTR00FGGr5u6XhBmXgbTYyXxf4PV5RUKFtOhq2GPSTwMsrTaBThyUE3kP7/uKNIkpqh0gPnTQdg505UCoXLbRUaQq1Dqbd8ATKo1JIdtmQRi9EFOWDlW+SimrYw9+ZQOpMSAA0E/IBE7eFz+sXrZDOrCpacwcywEz1/FFN98zFEFj0pJpu/HYO2srD+tXuHopkWoJX/Xl75SnxXjMvt4pQOm9bejT79zg1hOQJXmVrUZLN9e0o9ah2I6xNNrxnTXClzHfjSmJAvjsZgmxPqd4F4M3NdmOlJLEtWfD6xlKoCnrrnH/3ppVCHLz4ebQryAAPEHtVW2zvkw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com (2603:10a6:803:c5::12)
 by AM6PR03MB4837.eurprd03.prod.outlook.com (2603:10a6:20b:82::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.15; Thu, 30 Jun
 2022 16:11:16 +0000
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::40:718d:349b:b3bb]) by VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::40:718d:349b:b3bb%7]) with mapi id 15.20.5395.014; Thu, 30 Jun 2022
 16:11:16 +0000
Subject: Re: [PATCH net-next v2 03/35] dt-bindings: net: fman: Add additional
 interface properties
To:     Rob Herring <robh@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-arm-kernel@lists.infradead.org,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        devicetree@vger.kernel.org
References: <20220628221404.1444200-1-sean.anderson@seco.com>
 <20220628221404.1444200-4-sean.anderson@seco.com>
 <20220630160156.GA2745952-robh@kernel.org>
From:   Sean Anderson <sean.anderson@seco.com>
Message-ID: <e154ff02-7bcd-916a-0ec4-56bf624ccf7b@seco.com>
Date:   Thu, 30 Jun 2022 12:11:10 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20220630160156.GA2745952-robh@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL0PR1501CA0003.namprd15.prod.outlook.com
 (2603:10b6:207:17::16) To VI1PR03MB4973.eurprd03.prod.outlook.com
 (2603:10a6:803:c5::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7c86e61b-1a3f-4ffa-ff54-08da5ab32953
X-MS-TrafficTypeDiagnostic: AM6PR03MB4837:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fv4ofGbKgt7ZiRmQ5WAYZoYj32q2O7M66wS1P1S4Nakb0I5U6B0WjNtSSvb0ZhUzeds0ESsi2CCDiIpbbNp7dAMi7hqtp6V/Sz7h1gGJ2ICWD3T01NhbvEYsHTexVftIe9WjyHupLm8gIDIpOb/tWMVvJgklAWPbKadnK6Fz7x8squ42+8KIvmfTUmhr9EN0EdDrT2IQEZuS29Fk1QvxTuh32yM31BBrbFcz5wSGnxb8zcT7C0HAJYAJmYLOgbHTWlmw0RypXJNiEbTmHCrf4/S4ELfKUkEwDtEzeLCM8zvXoALFHfVFam3IE7obO99XoRtDQc91b7mGbjWnFdQDG6vtNGO1z4JGHjrTVNap35TZQabRZ82YMYAjVhaxmRqzAHMpCHchi1eJngJJQeb7wCgx5VO/akGj44TPMoWAk2kwrWrUPGihLjZ5Ic7yA8DYvtY2P9UuY2U43uUSVqYtAs+NoIXMHRNy/ymYUmSDyE1KmismlYshXUbINYG+N2brZ4CacvjAg6NslH/QSLb98GqK1Scr0xhwYjIlF2b5SEH8kIQMe2abAF8hZ9NhQvcjK0ParT+ZkkcGc1f63E4nGeqxrY10rWiEnju61C8hLRn4lBgddJxKIpxd5L6DxTKqw22cvaVAN3wCzkmdE39g75I7FZv+NP5LMxY7qIMHrr/pvUM64I1WFNFDk8MRSeN3+6VNUTLvOltZ+D2k4HBun4lt0Do6p5A+FmoqdvxzMQMMJvMW5pGEYPy3O7mV3e7DYjNuhBV1CtBP6MQ9J2Cg5UlXgWenswKyImFy/ibKrdOzJK7SzjG/nabwEbUSMLASyTXkm7c1yaAac53mmAhkzM6Bu9/T3vZL/16P1iVPThpXgWJpi4XNuzWKLZkalpMb
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR03MB4973.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(376002)(396003)(39850400004)(346002)(366004)(83380400001)(36756003)(86362001)(31686004)(186003)(38350700002)(38100700002)(2616005)(41300700001)(2906002)(66476007)(66556008)(66946007)(8676002)(26005)(6506007)(5660300002)(52116002)(44832011)(53546011)(8936002)(6512007)(478600001)(6486002)(316002)(54906003)(31696002)(7416002)(6916009)(4326008)(6666004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YUtHeFpJTTlyNDd6amxudzZVUXVwRXI5ZHh1c2F0ZEFWQ0pEVVA3MkMzbUs2?=
 =?utf-8?B?Q3JjQUFFYVlDakhyTEZlUEpOMzgxaU5veTQ2ODU3WkRnMjZCQ2w2eWw2emtZ?=
 =?utf-8?B?WlhPblRUR3VWSGlOZXpSWkphTjZGaU5RbWhsOFc3ODJ6NnhCRUpjY2tpSFFy?=
 =?utf-8?B?T0tQanVyd0FobjU2Y2doWGVINEJWMEhGb2krR0FEQjhtQ2FLWEhHcXNGcjN0?=
 =?utf-8?B?dDZXYjAvS2xRUFFvUmFYTDhQamU4N3Y2UHhGNnBBNnloMWNZTEoxZTVnWFNs?=
 =?utf-8?B?L2djbmRMRUxtKzlUUWNvVUZaa1h0U3M0YnF0Y0QvQlloejRONW1lRG8rY2FJ?=
 =?utf-8?B?UTFDYTZWUjhaQ2JBTWtrNkV2QTZsOEhBWW81NHdRaEI2OEtpVmhjdUs5QlFZ?=
 =?utf-8?B?ZGF5SlAwbkpOV01tMVc4ZDIrS3BQbm9HZ2N3bk9ncktya1g0Z2J0bDgveUtY?=
 =?utf-8?B?ZmNBTkJqVTJvcUhUMC9zdmM5dUlLNTVDUm1BNkVaSEhWZVd2WWFVTDkwa2FH?=
 =?utf-8?B?T3JCUzhpU1hlRFNjRGhYUDRqcGhzSUo1VzE4ZkMrZ1FPem9WUHZnTXMrLzZw?=
 =?utf-8?B?SnRSZHphMHZXTFdtV2ptQ3hZNjZCWHl5MlJpNHBKSmVmN2ZFV3dDa0VlcGlK?=
 =?utf-8?B?bHlVMU9UT0o0WjRsRVJ3ZFZiSStYM0xwNlpid01tTjBSVGR4anNoa1pvdUp0?=
 =?utf-8?B?MHVzSVBPc2VCQjV5cVN0ejJTamVSZHJwK25waHBma3hCbzFPSnBqaVpSbWlX?=
 =?utf-8?B?TXllcGZxVkdrcy9kWmYyN0hlNm0rWmIraUQ0NStaZ25Va2dDNHlxa3d5Nlhp?=
 =?utf-8?B?RGwyeVEzTVFaSzBYWUMxRmt3ZS9nK1kyQ3NsdE1ITkhkdTFHOHdOYWpqbzVB?=
 =?utf-8?B?dVpJSWF3RzdDTXJZeGZBNC9vRW1JYnRiRjJ1cG15ZTJpOTBKd29QYTExWmUr?=
 =?utf-8?B?eUF3eC8weHBrclV5cWJkNXNsSkZHcENnd2lEY21FQlZEZkpPek03cVF1dUFa?=
 =?utf-8?B?VEc0c21jaU9XSXNzV1JvU2hadWpESXdiQ2gzc1lvRTl5K3VHcTFuQWJ2ZWdx?=
 =?utf-8?B?d0JLNkg1L1YxTEVEWVJFajFBbXpTM0o5VCtXWGppZ0JUbWRiV0xxbE9jZTh2?=
 =?utf-8?B?TmtTVmlPbG9NNEZ6QVlPMy9xZ213MTBvY2JYY0tvdW1mQnZScUxRc1d3VTha?=
 =?utf-8?B?bGNzdW9KK2F2R2lqUEhEb2lpNkdrdldYaWVrVEJDYXkvc05EY3JsVFh2NXFY?=
 =?utf-8?B?akV1Z21DTHpoNzU1M1V3alV5R01rc3NxNk1UNUdYKytLT3gxc0szWjRaNUVy?=
 =?utf-8?B?UmJYYndhNVhLU1lRNk9oQUd4MkExNlhEdENaMXM2Wktxdzk1TWZRWE1sR0gx?=
 =?utf-8?B?RnhtNmxLVnZpbi9ScEVYN3ZNa3FDNnBqcFl4cVFmanpXdHcvMk04TTJWNmoy?=
 =?utf-8?B?bkhBMGZPTVMrOXkvYlkwdjZVd0pzRFF4TzUzQkZ2azJ6R1dXbjBQa3ZWNWtC?=
 =?utf-8?B?S3gwQWhLM09idFgwSzQzZ3NMSGl0OWhXbUpJOGNsbVNXTmpUTXQ3aWpQbGRu?=
 =?utf-8?B?UW5QTjJxc1UrOS9LZ29IeEUxMHZ5b2t2cHczRjJKZ2VRMmlxSnVNeTlXMVh3?=
 =?utf-8?B?TTVqZUFLV2hLUHdkT2FrVFNBa0JLTzJhVUlHeGsyQ2szcVFrWk5KTlkwN3pR?=
 =?utf-8?B?clhOTytOLzFsMFdRNk5vdTExTmtOdDlLcmdlQUo5Q3NDaEN2WlBIemE5YVlM?=
 =?utf-8?B?VnJYc0hRQWM5bHQrbmUwZzBQWWh0UGVpSERyaDRNNHloYlZjY2UzYlZjZkZk?=
 =?utf-8?B?bEZCUkNIdHphRUFHVUJ5QnkySzUxWU9nY1g0WURLeCsybmpUc3ZmQW9EVkNw?=
 =?utf-8?B?a0NjZFdjTUYvZjRxZW5jbitrSVhhNTNBKzM5cUpLcEJVNDhiUDlXRW1hQ2Ju?=
 =?utf-8?B?ZmtBVTBOSmdGOGJ1V1pyTmFiQVl3ZjVscjMrOGJtUTk1RndqdXlsRTJna1da?=
 =?utf-8?B?MWtRMUo2MVA4TWJOb0EvQnZJelNPMWpKdFlKRVZDRkdaYk5kaks2cE1GRlFI?=
 =?utf-8?B?VFZmT2JKbW5yOXJIV240L0xUSU9NZXVEVkRYWUtTYlh0RlhWa3NmUi9GS2Qz?=
 =?utf-8?B?OHQ1bm1FSVdWMkE5b2t0OE1kUWZEd2QvMWUvczVVMlVUSGpBWVhuTzdSWE5y?=
 =?utf-8?B?UFE9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c86e61b-1a3f-4ffa-ff54-08da5ab32953
X-MS-Exchange-CrossTenant-AuthSource: VI1PR03MB4973.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2022 16:11:16.6925
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: staxEmeeJyHcQ+h/VOOnBP6gaYPbkP/n1cy3DMlg1+pK2bKF6CPBbZaLTua9+Q5atQB/0fJfzkrXE5FoiLzyMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR03MB4837
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Rob,

On 6/30/22 12:01 PM, Rob Herring wrote:
> On Tue, Jun 28, 2022 at 06:13:32PM -0400, Sean Anderson wrote:
>> At the moment, mEMACs are configured almost completely based on the
>> phy-connection-type. That is, if the phy interface is RGMII, it assumed
>> that RGMII is supported. For some interfaces, it is assumed that the
>> RCW/bootloader has set up the SerDes properly. This is generally OK, but
>> restricts runtime reconfiguration. The actual link state is never
>> reported.
>> 
>> To address these shortcomings, the driver will need additional
>> information. First, it needs to know how to access the PCS/PMAs (in
>> order to configure them and get the link status). The SGMII PCS/PMA is
>> the only currently-described PCS/PMA. Add the XFI and QSGMII PCS/PMAs as
>> well. The XFI (and 1GBase-KR) PCS/PMA is a c45 "phy" which sits on the
>> same MDIO bus as SGMII PCS/PMA. By default they will have conflicting
>> addresses, but they are also not enabled at the same time by default.
>> Therefore, we can let the XFI PCS/PMA be the default when
>> phy-connection-type is xgmii. This will allow for
>> backwards-compatibility.
>> 
>> QSGMII, however, cannot work with the current binding. This is because
>> the QSGMII PCS/PMAs are only present on one MAC's MDIO bus. At the
>> moment this is worked around by having every MAC write to the PCS/PMA
>> addresses (without checking if they are present). This only works if
>> each MAC has the same configuration, and only if we don't need to know
>> the status. Because the QSGMII PCS/PMA will typically be located on a
>> different MDIO bus than the MAC's SGMII PCS/PMA, there is no fallback
>> for the QSGMII PCS/PMA.
>> 
>> mEMACs (across all SoCs) support the following protocols:
>> 
>> - MII
>> - RGMII
>> - SGMII, 1000Base-X, and 1000Base-KX
>> - 2500Base-X (aka 2.5G SGMII)
>> - QSGMII
>> - 10GBase-R (aka XFI) and 10GBase-KR
>> - XAUI and HiGig
>> 
>> Each line documents a set of orthogonal protocols (e.g. XAUI is
>> supported if and only if HiGig is supported). Additionally,
>> 
>> - XAUI implies support for 10GBase-R
>> - 10GBase-R is supported if and only if RGMII is not supported
>> - 2500Base-X implies support for 1000Base-X
>> - MII implies support for RGMII
>> 
>> To switch between different protocols, we must reconfigure the SerDes.
>> This is done by using the standard phys property. We can also use it to
>> validate whether different protocols are supported (e.g. using
>> phy_validate). This will work for serial protocols, but not RGMII or
>> MII. Additionally, we still need to be compatible when there is no
>> SerDes.
>> 
>> While we can detect 10G support by examining the port speed (as set by
>> fsl,fman-10g-port), we cannot determine support for any of the other
>> protocols based on the existing binding. In fact, the binding works
>> against us in some respects, because pcsphy-handle is required even if
>> there is no possible PCS/PMA for that MAC. To allow for backwards-
>> compatibility, we use a boolean-style property for RGMII (instead of
>> presence/absence-style). When the property for RGMII is missing, we will
>> assume that it is supported. The exception is MII, since no existing
>> device trees use it (as far as I could tell).
>> 
>> Unfortunately, QSGMII support will be broken for old device trees. There
>> is nothing we can do about this because of the PCS/PMA situation (as
>> described above).
>> 
>> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
>> ---
>> 
>> Changes in v2:
>> - Better document how we select which PCS to use in the default case
>> 
>>  .../bindings/net/fsl,fman-dtsec.yaml          | 52 +++++++++++++++++--
>>  .../devicetree/bindings/net/fsl-fman.txt      |  5 +-
>>  2 files changed, 51 insertions(+), 6 deletions(-)
>> 
>> diff --git a/Documentation/devicetree/bindings/net/fsl,fman-dtsec.yaml b/Documentation/devicetree/bindings/net/fsl,fman-dtsec.yaml
>> index 809df1589f20..ecb772258164 100644
>> --- a/Documentation/devicetree/bindings/net/fsl,fman-dtsec.yaml
>> +++ b/Documentation/devicetree/bindings/net/fsl,fman-dtsec.yaml
>> @@ -85,9 +85,41 @@ properties:
>>      $ref: /schemas/types.yaml#/definitions/phandle
>>      description: A reference to the IEEE1588 timer
>>  
>> +  phys:
>> +    description: A reference to the SerDes lane(s)
>> +    maxItems: 1
>> +
>> +  phy-names:
>> +    items:
>> +      - const: serdes
>> +
>>    pcsphy-handle:
>> -    $ref: /schemas/types.yaml#/definitions/phandle
>> -    description: A reference to the PCS (typically found on the SerDes)
>> +    $ref: /schemas/types.yaml#/definitions/phandle-array
>> +    minItems: 1
>> +    maxItems: 3
> 
> What determines how many entries?

It depends on what the particular MAC supports. From what I can tell, the following
combinations are valid:

- Neither SGMII, QSGMII, or XFI
- Just SGMII
- Just QSGMII
- SGMII and QSGMII
- SGMII and XFI
- All of SGMII, QSGMII, and XFI

All of these are used on different SoCs.

>> +    description: |
>> +      A reference to the various PCSs (typically found on the SerDes). If
>> +      pcs-names is absent, and phy-connection-type is "xgmii", then the first
>> +      reference will be assumed to be for "xfi". Otherwise, if pcs-names is
>> +      absent, then the first reference will be assumed to be for "sgmii".
>> +
>> +  pcs-names:
>> +    $ref: /schemas/types.yaml#/definitions/string-array
>> +    minItems: 1
>> +    maxItems: 3
>> +    contains:
>> +      enum:
>> +        - sgmii
>> +        - qsgmii
>> +        - xfi
> 
> This means '"foo", "xfi", "bar"' is valid. I think you want to 
> s/contains/items/.
> 
>> +    description: The type of each PCS in pcsphy-handle.
>> +
> 
>> +  rgmii:
>> +    enum: [0, 1]
>> +    description: 1 indicates RGMII is supported, and 0 indicates it is not.
>> +
>> +  mii:
>> +    description: If present, indicates that MII is supported.
> 
> Types? Need vendor prefixes.

OK.

> Are these board specific or SoC specific? Properties are appropriate for 
> the former. The latter case should be implied by the compatible string.

Unfortunately, there are not existing specific compatible strings for each
device in each SoC. I suppose those could be added; however, this basically
reflects how each device is hooked up. E.g. on one SoC a device would be
connected to the RGMII pins, but not on another SoC. The MAC itself still
has hardware support for RGMII, but such a configuration would not function.

--Sean

>>  
>>    tbi-handle:
>>      $ref: /schemas/types.yaml#/definitions/phandle
>> @@ -100,6 +132,10 @@ required:
>>    - fsl,fman-ports
>>    - ptp-timer
>>  
>> +dependencies:
>> +  pcs-names: [pcsphy-handle]
>> +  mii: [rgmii]
>> +
>>  allOf:
>>    - $ref: "ethernet-controller.yaml#"
>>    - if:
>> @@ -117,7 +153,11 @@ allOf:
>>              const: fsl,fman-memac
>>      then:
>>        required:
>> -        - pcsphy-handle
>> +        - rgmii
>> +    else:
>> +      properties:
>> +        rgmii: false
>> +        mii: false
>>  
>>  unevaluatedProperties: false
>>  
>> @@ -138,7 +178,11 @@ examples:
>>              reg = <0xe8000 0x1000>;
>>              fsl,fman-ports = <&fman0_rx_0x0c &fman0_tx_0x2c>;
>>              ptp-timer = <&ptp_timer0>;
>> -            pcsphy-handle = <&pcsphy4>;
>> +            pcsphy-handle = <&pcsphy4>, <&qsgmiib_pcs1>;
>> +            pcs-names = "sgmii", "qsgmii";
>> +            rgmii = <0>;
>>              phy-handle = <&sgmii_phy1>;
>>              phy-connection-type = "sgmii";
>> +            phys = <&serdes1 1>;
>> +            phy-names = "serdes";
>>      };
>> diff --git a/Documentation/devicetree/bindings/net/fsl-fman.txt b/Documentation/devicetree/bindings/net/fsl-fman.txt
>> index b9055335db3b..bda4b41af074 100644
>> --- a/Documentation/devicetree/bindings/net/fsl-fman.txt
>> +++ b/Documentation/devicetree/bindings/net/fsl-fman.txt
>> @@ -320,8 +320,9 @@ For internal PHY device on internal mdio bus, a PHY node should be created.
>>  See the definition of the PHY node in booting-without-of.txt for an
>>  example of how to define a PHY (Internal PHY has no interrupt line).
>>  - For "fsl,fman-mdio" compatible internal mdio bus, the PHY is TBI PHY.
>> -- For "fsl,fman-memac-mdio" compatible internal mdio bus, the PHY is PCS PHY,
>> -  PCS PHY addr must be '0'.
>> +- For "fsl,fman-memac-mdio" compatible internal mdio bus, the PHY is PCS PHY.
>> +  The PCS PHY address should correspond to the value of the appropriate
>> +  MDEV_PORT.
>>  
>>  EXAMPLE
>>  
>> -- 
>> 2.35.1.1320.gc452695387.dirty
>> 
>> 
> 
