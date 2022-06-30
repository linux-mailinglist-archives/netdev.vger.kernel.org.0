Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0BE6561E9D
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 17:00:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235382AbiF3O71 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 10:59:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233484AbiF3O7Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 10:59:25 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2087.outbound.protection.outlook.com [40.107.21.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DF6EC16;
        Thu, 30 Jun 2022 07:59:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BMg5BSWoQFVMP0/Ie0ZkS3AsVNo0gdEN2ICN5sAEJg8hT4a2is8TebvhSxddFW2IOJEV+R9Eki3QOMLkNCE8kKGggmzzhqez7eEKZk24bVkrrOBR1WsRlaziIhcBa/rLNihEB5HlGMw4mYrCZKhYe40hqa7zT/K4DcAEEluTC7OC8OoELECi/wIXIfiFp29yfIm7F7o5Xy6C0W0ILISGc9BwEESy8s07rz3TcZHMZWc10AtWDO8r/Eu1BN5XzS+b0mxeYuEcqdDNaezsRL1n51k+fXkAr9CLjMNvg2bEXISKUYfzEMSTNCGkrjkA3/oLZX1MwFYxX+cmKtffTS3Gzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rs704/iyGVo8RnP62KwKEiz5MrrAC+sl6bfboCV04kU=;
 b=NIyZVfeiUQH6qy1JigsUoWiycKbbCvvqbd9dr6k/nqurUgw9TuHyI9YLSlg6Klw8XjK0fTG/UgWpQXeOkniAO9IELx3bWdqX1EtKvn9Sng0CrCl0lm9IdW0mxOA5u5pFob5aOAl+3SEoWvAHmcyX4gSyPQTlVI+Iur/6hMvlXFYJpGX1X6IhBklPl9tlia+g96KSwFTbGcZ1C0nQx8s3wVizavXfj/cofI/7M3s/YeiBVcKrxpd2M6/NyoFpryDg7oIK6iEAjmLG1gpOfU8kl5GI44zjUxho5aoj8T8QcgRDwNacrv06KzrL3XtAgYlgKuyhjN810V29KN3fc1Ggsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rs704/iyGVo8RnP62KwKEiz5MrrAC+sl6bfboCV04kU=;
 b=APCz1c3xzFB9wMH6F/ilkiFYljFY1N+agGj3/r9iRij3TvBL9PxZaPL7Y3fzdQ5aQm48zP6IJN+fIKCLtqTqd4Y2qBCDnxPeNu88a4cDCBTMuyUhZzC/xBruhvI/Z2CfNy8Xo/ik+S7ZEnwtebYFijxpGos+2mYyEzzZykCA4/hS8s7aquZxYsd7VgDl+fMpLGdj3Zf1TuZMqYMJEbe4M0+xDBXkA/MHBNBqanRxA7s585e6nDna3Y/b/EtWk8AIO2pDKoLnNFC5qzLtpFNidJ2Qenvehl9JSE/0PtSCiZ0XG2qwtoMICOq2ZLbfLOw209RwpE/+KkOkaiRVbt2TeQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com (2603:10a6:803:c5::12)
 by AM9PR03MB7758.eurprd03.prod.outlook.com (2603:10a6:20b:3dc::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.15; Thu, 30 Jun
 2022 14:59:21 +0000
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::40:718d:349b:b3bb]) by VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::40:718d:349b:b3bb%7]) with mapi id 15.20.5395.014; Thu, 30 Jun 2022
 14:59:20 +0000
Subject: Re: [PATCH net-next v2 02/35] dt-bindings: net: Convert FMan MAC
 bindings to yaml
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        linux-arm-kernel@lists.infradead.org,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
References: <20220628221404.1444200-1-sean.anderson@seco.com>
 <20220628221404.1444200-3-sean.anderson@seco.com>
 <YrxmmSXdKb3pD/Nv@shell.armlinux.org.uk>
From:   Sean Anderson <sean.anderson@seco.com>
Message-ID: <bed8bd29-06d2-0045-25be-929ee345e595@seco.com>
Date:   Thu, 30 Jun 2022 10:59:13 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <YrxmmSXdKb3pD/Nv@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR19CA0008.namprd19.prod.outlook.com
 (2603:10b6:208:178::21) To VI1PR03MB4973.eurprd03.prod.outlook.com
 (2603:10a6:803:c5::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c7bf963b-4ef2-4892-0041-08da5aa91cdd
X-MS-TrafficTypeDiagnostic: AM9PR03MB7758:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iE1lYV+QbDXuRfbk0t2k2L+0/jIiGKZvlE5f45wRqHRpbme09v0RGI6ZOG4OpBedIFGr5uQKSYJz3hRfT60FW3YILqYtiRQKHtjEY50Ls78VaA9+V3YNqQ4VlrgCzYQtO6Vn2iDnLG+I+4quCTlMdb1X0Rh8ackztc9bknqgE5Y5GPnqsPuDmtUTnoqJqSdJk/KBsND1Hg1N8+A61CphuFbxldvqftWUqZdesWsSnejXnQEQG31ZBEGDO+edJbL/+Rspxxa8KdiWt8dVXclJvy52fa/WykxayEUsSF2KmhoyYoptbqtXjrOovSyvQAAoDdzXvygjlNh71B5+7KUTEyc5QrM1s2DfL3lnkrRMXh3UMoKqjHjvaUk1aKslJoJSJ4QYAKKFpjV57DAMAZ9RJAtJI6xxuMlYUdhft61dboROYmZWqUmRvi6lgrHGchB1i4HKQyPTjVGinssgWp/ngpLw2FXw/f7rNcDch14t+8UmFM/fpQtDDWT6P1ku3TGuJSOJieJKccV91KnSmXsZGO2zocFGf+TRg6JCI7KqGglkQDeJP/R+8G/TyH1xrzw3AjziRZ/xttnsCzATRprA3/dEr4lLRtQdpriQTQHrRRxdoK+bxqimfSnxhBbvfO2nzvdzVVq7GxqIivE8F/m+87eHEqHFbI4ZVj+4IyBi5suUpPPG9EgFsWMoaBQKjiMu5WJDlcP+ToCwN4lT7SBaeA/3Dd7+6oa/Hey/l8HpWCp8dCHIITyRpyPBCUG9Dulsw/r50Mmg7NRzqO65VAr89ssfTN/bIyx3zODHmn79ANg6mdoOI7ltsBb1FQ1lVHwdjz/Hal02/COb+lPs0XWTDTmdg0VIMFWmwUy+Jtp+uq7toHpuoVMf6pWA6TBO47H8f9gvsW9ycN7aXn2PFogpOTyQLzv+p0Rze4ILJdMPSKI2U4J8uJzKyPC9qnorcXAC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR03MB4973.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39850400004)(136003)(396003)(376002)(346002)(366004)(2616005)(52116002)(53546011)(41300700001)(6666004)(2906002)(316002)(54906003)(36756003)(6916009)(6506007)(38350700002)(31696002)(86362001)(966005)(478600001)(38100700002)(31686004)(4326008)(6486002)(66476007)(66556008)(66946007)(8676002)(7416002)(44832011)(8936002)(5660300002)(186003)(83380400001)(26005)(6512007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NzNRKzYydmlGZWsvbVFodzlzTXNwbzVMQjNmWWQ2d3RTd1QxaEJXY2p5THFM?=
 =?utf-8?B?ZkRPMC9tOHIydUNSUE9MQytQTXlJNk11Lytsb0lKWUxlNVU3YllxRHpIVktG?=
 =?utf-8?B?UU1CNnlOOHdoQ1c3SnFmME1pc1ZZWDU4aVNHNnlJdjVhUFBNdFVFQVRRejM5?=
 =?utf-8?B?dTBHalZ3RlZpbFhlc2xSbUV4SC9PWG5tYkJGb1RRNkx0d1pIUHJhcFkvK0Ew?=
 =?utf-8?B?dzc0ZW5WYVpNcmtzZmtnNFFkdGw4SlhpbXZ3UHBRUklieVUvdDExOFd6emc0?=
 =?utf-8?B?dm85dUtIWm5pbUVGNXJjWUZOVWpjcXpoRVVxdGs1d2tkc1k1Q2xTci9CY2Vr?=
 =?utf-8?B?aXZrTCtJaUF0QkhmVmZuTXNhT29XL2xuWnpBVzlSUkNCUHBqU001ZkdjL3lB?=
 =?utf-8?B?S0VyY1hxTm9uSVBLa0x4M0EzNmoyUnF1NDNXTkZWZk84VnBaMS8yYWlxdFZK?=
 =?utf-8?B?K2lBU013dUJzR0hPY1NpZExKZU1UNjV2UlhCbHdvUjhXSHB4QzRsamFBU25V?=
 =?utf-8?B?TmhWQ2JCVVRPRXhjV2JKUW5PZ0plYmo0N25hUmN3WWVtZXJjQmpRN3RTMDQx?=
 =?utf-8?B?ZVBQcFF5SEQ0bFFHMy9DSkd1MDA0cmNVS1FBdXFtSHAxQzhCRXU1c0lyQmlj?=
 =?utf-8?B?ODZ6SDNMNXBVN1ZRVzU2Q3hsejhZaFJhZTZqYjJpdGtab2Q0NkY2cnRQcjJ5?=
 =?utf-8?B?Qm05YTlTMXFrYUdSaDZnWWQwYVdTd1c3NldtSzZKR2RDUFBnVldaZmQ4UGdv?=
 =?utf-8?B?R050WTRobHhGTDFRWEhqUDNSRGQ4SEN6NklEdVIzNTdURGMzclU3MWowQ3I3?=
 =?utf-8?B?RXNGT0puUHFiZjhHOHVXZUdkQVFEaktsMEF6bFRmOWF0ZHJ0UmUwZzYxQWlH?=
 =?utf-8?B?S05DQWFjb2ZvOXlXVytOTlpFOUxWZ3R4S2ZZeXUrbEFBMlk2TEVMOThLd1BC?=
 =?utf-8?B?M3BRSFNuc3hXc3NxeHhHRUxmWmtkNGxwWjQvWk5mSmdzOStCbkNVNGFKeVhI?=
 =?utf-8?B?YTJHWGw1UXI0eDU1TWpjZnY1Q3BZM2ZURGRmWFc3SldLUmhsZTlLcUc1ck5D?=
 =?utf-8?B?cTYrL0U1cGRPdlJsN3pGYlpHSENUUWJDaFVpclJleGJhczVublNHSUxOUVpy?=
 =?utf-8?B?c2RXdTJoVy91RC9UUmdlbHhKL0xQZXdhb1MzZ2pqc0QxbU5PKzlBWmdhd2VB?=
 =?utf-8?B?NW4yMExkM0tCbDNmUHFsNWR6VG9vbENZbzRJZGV6MTlYRGV4Zlg4cFpublRo?=
 =?utf-8?B?VjIrYXI1VlcwbWNBNE5NVkgyazZDelp4c3FOd2I5L1BDdDNJMnljc1czMlY1?=
 =?utf-8?B?N3p6Wnp3OGN5Q0ZZRHhjU0FHR0crZnp4N0U3bEtjdGVDZ1ZJWUh2SkRWOGho?=
 =?utf-8?B?SnJYeVJZMFhvRmltc2I2a2lTUnQ1c2gzd01xQ01rLzVJeVFQTWwvSUlzUDFN?=
 =?utf-8?B?VEdlZWpRaVo2U05QZnk0Wmd1Q0VydlovQTdVd2N2T25BV3cwYmpqVlc0T3Vm?=
 =?utf-8?B?dC9wYkRCQnoxVmxQTVdlVDJ3QXdNRG5BQ3o1UE41MTlrNVY4SUpBdFBrTzdN?=
 =?utf-8?B?UXZTQjEwMlpGbFl6akQybHFtZVhFSTJhek84eTZrd1dUN0VYM1liV2hXKy9I?=
 =?utf-8?B?NmxleXBxWU9qYmdqY2YzbnA5ZFFEN0VoYlNPRVBHNGY1aTRsdzFQS2J1UURi?=
 =?utf-8?B?elF0UExOVFVWRVF2SHdFdFJJQzNwM2txVXZnWTdJci9tY1NWOTJWZGlRTEdw?=
 =?utf-8?B?SVlqZnNqK2ZUdHBKbU5aTmVDVURkcWt2Z3BtZHFScGsxQ3d4MU0yaHZiejdw?=
 =?utf-8?B?WWViNGNEalFSRkJ2Uk5TaVM5K0xGbTNyWUU2SlJ6MVZDY2Yzdzc5TkF2Ym1H?=
 =?utf-8?B?L1M2ZlhDbW9remltdUJ1RGk1TDQvclA4ZE9EakRuRzh1NzYvcWJUd1hJeW5K?=
 =?utf-8?B?eWlMdWhLeHM5S2dKWm81ak9nRjFDanlzREk1UmxVMWIwajEwQldBcGpaQ25n?=
 =?utf-8?B?REJ5Ukd0cndMTlpFYm5zUGtVbHppdlVobTd1MWN3VllOdzlwNHhNTkErV0o0?=
 =?utf-8?B?ajluWWFBaTNCNGYrL24xZ3hQN0F3SU1TN01UVS9BUXduQjJoQWlzYmxuVU5a?=
 =?utf-8?B?OVhtbWhSRWRkOHBkMW9NaC84ZDVZL2ZKRC94bkgzOHhkYktWZEFKS2JtaWZ2?=
 =?utf-8?B?cUE9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7bf963b-4ef2-4892-0041-08da5aa91cdd
X-MS-Exchange-CrossTenant-AuthSource: VI1PR03MB4973.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2022 14:59:20.8439
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U/AviSycGJYk6Ksnu1XHgkue29QZSo3+G/iB9Fgehn5vhp84gaWRBJQwAfNYefGgQHHrTo0m5rPh0k+xxcaylA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR03MB7758
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Russell,

On 6/29/22 10:50 AM, Russell King (Oracle) wrote:
> On Tue, Jun 28, 2022 at 06:13:31PM -0400, Sean Anderson wrote:
>> This converts the MAC portion of the FMan MAC bindings to yaml.
>> 
>> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
>> ---
>> 
>> Changes in v2:
>> - New
>> 
>>  .../bindings/net/fsl,fman-dtsec.yaml          | 144 ++++++++++++++++++
>>  .../devicetree/bindings/net/fsl-fman.txt      | 128 +---------------
>>  2 files changed, 145 insertions(+), 127 deletions(-)
>>  create mode 100644 Documentation/devicetree/bindings/net/fsl,fman-dtsec.yaml
>> 
>> diff --git a/Documentation/devicetree/bindings/net/fsl,fman-dtsec.yaml b/Documentation/devicetree/bindings/net/fsl,fman-dtsec.yaml
>> new file mode 100644
>> index 000000000000..809df1589f20
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/net/fsl,fman-dtsec.yaml
>> @@ -0,0 +1,144 @@
>> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
>> +%YAML 1.2
>> +---
>> +$id: http://devicetree.org/schemas/net/fsl,fman-dtsec.yaml#
>> +$schema: http://devicetree.org/meta-schemas/core.yaml#
>> +
>> +title: NXP FMan MAC
>> +
>> +maintainers:
>> +  - Madalin Bucur <madalin.bucur@nxp.com>
>> +
>> +description: |
>> +  Each FMan has several MACs, each implementing an Ethernet interface. Earlier
>> +  versions of FMan used the Datapath Three Speed Ethernet Controller (dTSEC) for
>> +  10/100/1000 MBit/s speeds, and the 10-Gigabit Ethernet Media Access Controller
>> +  (10GEC) for 10 Gbit/s speeds. Later versions of FMan use the Multirate
>> +  Ethernet Media Access Controller (mEMAC) to handle all speeds.
>> +
>> +properties:
>> +  compatible:
>> +    enum:
>> +      - fsl,fman-dtsec
>> +      - fsl,fman-xgec
>> +      - fsl,fman-memac
>> +
>> +  cell-index:
>> +    maximum: 64
>> +    description: |
>> +      FManV2:
>> +      register[bit]           MAC             cell-index
>> +      ============================================================
>> +      FM_EPI[16]              XGEC            8
>> +      FM_EPI[16+n]            dTSECn          n-1
>> +      FM_NPI[11+n]            dTSECn          n-1
>> +              n = 1,..,5
>> +
>> +      FManV3:
>> +      register[bit]           MAC             cell-index
>> +      ============================================================
>> +      FM_EPI[16+n]            mEMACn          n-1
>> +      FM_EPI[25]              mEMAC10         9
>> +
>> +      FM_NPI[11+n]            mEMACn          n-1
>> +      FM_NPI[10]              mEMAC10         9
>> +      FM_NPI[11]              mEMAC9          8
>> +              n = 1,..8
>> +
>> +      FM_EPI and FM_NPI are located in the FMan memory map.
>> +
>> +      2. SoC registers:
>> +
>> +      - P2041, P3041, P4080 P5020, P5040:
>> +      register[bit]           FMan            MAC             cell
>> +                              Unit                            index
>> +      ============================================================
>> +      DCFG_DEVDISR2[7]        1               XGEC            8
>> +      DCFG_DEVDISR2[7+n]      1               dTSECn          n-1
>> +      DCFG_DEVDISR2[15]       2               XGEC            8
>> +      DCFG_DEVDISR2[15+n]     2               dTSECn          n-1
>> +              n = 1,..5
>> +
>> +      - T1040, T2080, T4240, B4860:
>> +      register[bit]                   FMan    MAC             cell
>> +                                      Unit                    index
>> +      ============================================================
>> +      DCFG_CCSR_DEVDISR2[n-1]         1       mEMACn          n-1
>> +      DCFG_CCSR_DEVDISR2[11+n]        2       mEMACn          n-1
>> +              n = 1,..6,9,10
>> +
>> +      EVDISR, DCFG_DEVDISR2 and DCFG_CCSR_DEVDISR2 are located in
>> +      the specific SoC "Device Configuration/Pin Control" Memory
>> +      Map.
>> +
>> +  reg:
>> +    maxItems: 1
>> +
>> +  fsl,fman-ports:
>> +    $ref: /schemas/types.yaml#/definitions/phandle-array
>> +    maxItems: 2
>> +    description: |
>> +      An array of two references: the first is the FMan RX port and the second
>> +      is the TX port used by this MAC.
>> +
>> +  ptp-timer:
>> +    $ref: /schemas/types.yaml#/definitions/phandle
>> +    description: A reference to the IEEE1588 timer
>> +
>> +  pcsphy-handle:
>> +    $ref: /schemas/types.yaml#/definitions/phandle
>> +    description: A reference to the PCS (typically found on the SerDes)
> 
> This description includes ethernet-controller.yaml, which contains:
> 
>   pcs-handle:
>     $ref: /schemas/types.yaml#/definitions/phandle
>     description:
>       Specifies a reference to a node representing a PCS PHY device on a MDIO
>       bus to link with an external PHY (phy-handle) if exists.
> 
> Is there a reason why a custom property is needed rather than using the
> pcs-handle property already provided by the ethernet-controller DT
> description?

This is the existing property name. It must remain the same for backwards compatibility. c.f. tbi-handle.

--Sean
