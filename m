Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C60E666FCB
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 11:37:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235396AbjALKhv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 05:37:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236584AbjALKhO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 05:37:14 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4925059FA4
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 02:31:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i0PB3d36wsLUj61Hbg5fQn9PvDzjvsp2EiDijoSKDQ+EoRuqNI4n1lCWK0sgpREM1gv9Tf2kRvLGaL0rMtDJNq463PBX0Sr4ExK0856MFcCDMBNw0K5DPkVhtSsydn3hXeT0hMd1a+2reONOJgXEe/JJsP9gekKqAiHk0DFLoBFwfjKnzIbZp8K+Z0q4TjPlLAtbuwtgxacv/FSID6QIj8qyh1RkfCSr6k4u3Ucxx0AcDDLSt/6Fyd/arVECe8VSiXns5Bx9PMULd+yH7NETMvijuL8w42F2D7FtTaFp1y99SbQ8ZF1JVFIgVfs+fl79gDX6lvRJOb7UdQW99nxQpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7Wvd1IX3BnPgNqJs3kb86juG1YItU3XQE5Y7uQTyGN8=;
 b=J4hn9roOZjRplZlECU0g4U2ByNQieVVXm77wGgsFiZrCC5bBc5WIr7UE9Ai9fPdFSN4TW0WD7QE+bTjVO57erqG+QLgj5iNJgJ74wW5+Z5Vv+OmFtNxc0nO9A+t194ZEOdNMdTmP1zwJTYboQfxdigGeSEX4XNgLqMo9HscMfd9QWgapnWBu39fvDYBJCioRS8+x62QxluSJ0NuUS9zVkxzzBT1W0wKXEzq7sXxFB2IVYyGo6EDsYR9dfy1VP3arEQCP/zTkuQg6pQvqLrhBaR09aaiLMWT48Jj9MVN3OaG2IaCVRVJ5O8hp8HF8gtp2kWDJE73xLF2IeFSuOEypmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7Wvd1IX3BnPgNqJs3kb86juG1YItU3XQE5Y7uQTyGN8=;
 b=X8aHTttxizVNhHtkg8XpgNh1Afhh87MxVF/G/1SIhIz/IzedwHtNEdmKZn33Rv3Xq1jqlUplHEBOjbiftEohk9TgDUVHcqFDZREgDTwOqRWTs+Z+hbBik/x1Aj7v8iDm/XCGUGXmhoxtPPan6b6AmJNxYUadqjYEMn2Cu2VtKCzQJe3PDM0E+JIVkeEcbl5ewmF76mLiX06ZsbRN7edaaA1mfm0jAjHKxBcemRF5ZSJv/6CjovPBw+jYuXrrDSU6a505I9WuAyo/rQGZptwAPwBpeIV4Iu0L9NJRIm/CLcjhuJnWa1MUaihXRGnJsTTMVLAoZsk6F7+gwJSZpIr43Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB6288.namprd12.prod.outlook.com (2603:10b6:8:93::7) by
 PH7PR12MB5903.namprd12.prod.outlook.com (2603:10b6:510:1d7::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Thu, 12 Jan
 2023 10:31:13 +0000
Received: from DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::d01c:4567:fb90:72b9]) by DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::d01c:4567:fb90:72b9%3]) with mapi id 15.20.6002.013; Thu, 12 Jan 2023
 10:31:13 +0000
Message-ID: <f2fd4262-58b7-147d-2784-91f2431c53df@nvidia.com>
Date:   Thu, 12 Jan 2023 12:31:04 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH V1 net-next 0/5] Add devlink support to ena
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        "Arinzon, David" <darinzon@amazon.com>
Cc:     David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        "Bshara, Saeed" <saeedb@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Dagan, Noam" <ndagan@amazon.com>,
        "Agroskin, Shay" <shayagr@amazon.com>,
        "Itzko, Shahar" <itzko@amazon.com>,
        "Abboud, Osama" <osamaabb@amazon.com>
References: <20230108103533.10104-1-darinzon@amazon.com>
 <20230109164500.7801c017@kernel.org>
 <574f532839dd4e93834dbfc776059245@amazon.com>
 <20230110124418.76f4b1f8@kernel.org>
 <865255fd30cd4339966425ea1b1bd8f9@amazon.com>
 <20230111110043.036409d0@kernel.org>
 <29a2fdae8f344ff48aeb223d1c3c78ad@amazon.com>
 <20230111120003.1a2e2357@kernel.org>
From:   Gal Pressman <gal@nvidia.com>
In-Reply-To: <20230111120003.1a2e2357@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0048.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:4a::20) To DS7PR12MB6288.namprd12.prod.outlook.com
 (2603:10b6:8:93::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6288:EE_|PH7PR12MB5903:EE_
X-MS-Office365-Filtering-Correlation-Id: b48565be-c156-4c06-0e2a-08daf48820d3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MVUTH6eoi6StHyu8L+vcIwgxShzYFSBzhCPaZlz66D9T8Smx0K17PiaSsgcxG4hxxWaUisUDaUzGkH2TEDVO1UFFN/+QCP+MiyMh1XNWUA+GvPXWFx1uk7SIDuY0d2q/peYjV7B+h3QQpfcooRi7AYw3hFaf/eNuq0/FwqXVGzZzxzV2kUEyI97nLn4E2gSaQHkM0w88nHWhCD9iNvaeHV9PqresYx/SwekFmhwDZebbw0jHWG2pj8Z+JVv9Gh5R9XpUC7MYlJ0dJj+fk7SuyydBGkCu7hHV478g2fMqlpib8oG6vnCF/zi/Jo4EM13DspHwViUcHJPTwBhsTjQxA0LMpAR2rgbTnXRVF++YpgIT66XZ4kneoZeQtjJlG5z7sL3tFgyZcAMayUH6Amd7YSe327NEapfqYp+LwB9/wrdYdv+ltte4YmAleLuSbr+//edjxYVZg0u9Ii5SwZ+zPjR5N+ICHvlj77bhiJeBPXayNgWyA/HnL7MwAqyXHv3WWsMtmwoWj9D/eo9rGtQm6OSbutm+o6XgGwOAp6sRiRaxAbZSGALlY8/ZZfZNsyG9AvH9NuqlmVGDuygRvx/4lryPgTiONakxYLadhzozN38rXQJNIhVi3VEonnuOi1b54cjbHDMa+/HFS3hTs2RQL3HWkQQtayB66b/LIIFmOK+0pff/Op96xebQS/YzEZSb4GRVut+VQxrWOy+wOHb4HQZlmP8xY4nEBieDABChvkU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6288.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(39860400002)(366004)(376002)(346002)(451199015)(38100700002)(86362001)(8676002)(54906003)(31696002)(41300700001)(66476007)(66946007)(4326008)(66556008)(110136005)(2906002)(478600001)(5660300002)(7416002)(4744005)(316002)(8936002)(6512007)(2616005)(6506007)(186003)(26005)(53546011)(6486002)(6666004)(31686004)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Z1Nrb3llM1RQdVBWV1BXZVZOcGhydFB4a01iU1pQWnVReWJBMzM5ODdlUHdZ?=
 =?utf-8?B?amJKYzRFQ0taRlR2LzVpVUNLODBFRUJIVmtjd1NRLzJKN2NFUExXY3pYNDZn?=
 =?utf-8?B?YmtsVFltMlhXYmFrdDhLbjJIOGJQaWIwTFRjTHFibHE5OHAwYiswci93Z29X?=
 =?utf-8?B?VnR6ell1TGdJMkQzSlN0ZUlBUnJvMVB3N0ZrVUFFM2Z5ZVd1RWdmU09TV3Mv?=
 =?utf-8?B?Rkp2MjhwcWhJWHNmT2pPdDRoWEVQVXEyeWpLS1QrYVdzd0cxNFVwRlhQZGpK?=
 =?utf-8?B?SDhaYkNoTkRpZlMrbm8xSm1ZY216Z2VBRnBRcVdkS3E3MnhuVDdjbXZMd3Y4?=
 =?utf-8?B?T1k5WFVWbnU2WXQ0cUsxRWphNFBNbEtvZ0pGTGpoNHJQZ0YvcDg0MGp6Q01w?=
 =?utf-8?B?bWU4TCsvN1VSLzB4K0h6WHdJV2xac2VRZGd6eFlhcDU4S2JIU2hQTDRldmIr?=
 =?utf-8?B?YU1jbkhWUS8rS3gyRDE2dEh3a09tNVNyVDFVUlh6UjlSMW5BV0NDQjJqNnNU?=
 =?utf-8?B?S0RNWUhpay9zWWpBM1AyenEwRm83TWJIY1hWMGVNVzVGb1VZbkNPY3NSUm9L?=
 =?utf-8?B?aFRtUGhQLzlVa1JzVWI2eTNyblhkcFRkeVBVNHFUOStwUUN0U1RqMHdlZWsx?=
 =?utf-8?B?Q1JQQTVaeHZ2Rjdkb1h3Rld3N1F0YThIMEVpakdTOHVNSGdaaE9QU2szVHMv?=
 =?utf-8?B?TEg1aEE0a1ZkcThiZTZWeEdkN0VQamZ3eUZSN1FJdFpKb2dseHYvd2EwOUpz?=
 =?utf-8?B?Y2lGNnc0QS8vSVBzY2hndWlsUFZXaWRWNDIrSjR6amZyUk4xV2p2bmhOUnZJ?=
 =?utf-8?B?ZitSZUJJTkFURUJPTTVHalhvd2dMbjBWV2NwRDZ4RjEvQVZSTUU1UlVZN1VO?=
 =?utf-8?B?N2FDcEhGZWlBeUttWXI0VW1aYVpycE1rZzdDNUZqZ21KNU4zSW1LYmxBZTB2?=
 =?utf-8?B?QVZpVUEwWUM4TkhyR3htNXZkenAzdys1R09xUUZRWG1DR0FSM0N4bS8rSGF3?=
 =?utf-8?B?U3RkQnc0Ym5hL3Y3bWdSMXdFM1lGZWZmRmo0ekIySDlLSUIwQW5oMzI0UGRm?=
 =?utf-8?B?QzIwbmU5ZS9ka2NPWFhMNlV3NzIvMVk2S1hCM2M0b3piTW84SnoxcVF4VVMy?=
 =?utf-8?B?M2tLeTdaemJjT2ZEMmd3QWlrZnVCNVBCemg1OTl3SHYxNEZMOTNLK051M1Vq?=
 =?utf-8?B?SDZCaE8rUCsrOGxEcVVqMU1ZelhDYUViRTNMTkd4eXlwUFgzbXlNTS9ONm84?=
 =?utf-8?B?REcya1RIZVRLOUR6amROSjhZV3JWbFRhc3k4NWVIWlR3S3BIYmlDYWt2TkRt?=
 =?utf-8?B?R2lGb291RjM3dGZHVnU4dTlvY0l0RHBPVGlPVVc0M09PNGxyNWRGbjNVQ1VG?=
 =?utf-8?B?ZDkvaTIxa3o3UnYzSHNhV3VRUjhqWG53ek9LRDRlOFJZUjdrTGJVQjVDR3V6?=
 =?utf-8?B?V1RFaVR2ZVlTRlZIamJvRjBhVG4zbkk4TnlLdFVFY1VCWk9ROGZZTXVuTm13?=
 =?utf-8?B?eitFY2xWY0FmaVBwcWNYSkliaDNGUXlNdG5ESGxjNmxsbEpWRUcxUnd4Zlgx?=
 =?utf-8?B?eUpxSVZMeTU1Ny9OR1BtQmNvaTNyUi9lNTJtM0tLZnV1QWpxMVl4ZWxCR2hz?=
 =?utf-8?B?SERvNnRCUGhRY0tLNENQQlNmQnZZSVVxODlnOUZ6aXdZb0JlLzVxdFM1L0ZX?=
 =?utf-8?B?WmpHVmNPM29DOUk4WTBnakxFOHk5SE5vZ2hQT2hib1g0UHVqOHYzQlVtdDV2?=
 =?utf-8?B?OE9MZzlUc2ZZQUsrTXFWcVFYZ1JueDhDYVpRRndXMFNYWlIxM1lMWkszRXVu?=
 =?utf-8?B?cEZSS1A2Z1pSOXRrWDU4bWxybVlOdXl4elAzQm00Y0dTemsyVDBadFZEcmlG?=
 =?utf-8?B?aGxYWFY1c2VFdFN1SkIvYzlkL0hqbHZERytZbEp1bUxaeFU4aWFMaGo2R2N0?=
 =?utf-8?B?c3lpV2dUMERsdnBMbTFTQjE3VU0yeE5paUpZMXQwckJoVTQ2cUczYStpalEx?=
 =?utf-8?B?YmFnRjE3Y1R3MlFCdU5vVkc4RnpFMDlFS1hLTjZRdVZ3Z2dVUnBmNEd0bUMy?=
 =?utf-8?B?TkNubXJubkZONHBzUkRsVThCYXV2WCtzTzJhMUFSWGJrSjFrM3E3T05DZ1Bt?=
 =?utf-8?Q?/cPv4Bvs8dSGMxhDAklDOT4K0?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b48565be-c156-4c06-0e2a-08daf48820d3
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6288.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2023 10:31:13.2122
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2UmrSOR8JRJz+kAwCGvi/EAL9Qml+vKkxHTBXS015pbAvrGENoImWQ8yCayLbLQl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5903
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/01/2023 22:00, Jakub Kicinski wrote:
> On Wed, 11 Jan 2023 19:31:39 +0000 Arinzon, David wrote:
>> If the packet network headers are not within the size of the LLQ entry, then the packet will
>> be dropped. So I'll say that c) describes the impact the best given that certain types of
>> traffic will not succeed or have disruptions due to dropped TX packets.
> 
> I see. Sounds like it could be a fit for
> DEVLINK_ATTR_ESWITCH_INLINE_MODE ? But that one configures the depth of
> the headers copied inline, rather than bytes. We could add a value for
> "tunneled" and have that imply 256B LLQ in case of ena.
> 
> The other option is to introduce the concept of "max length of inline
> data" to ethtool, and add a new netlink attribute to ethtool -g.

TX copybreak? When the user sets it to > 96 bytes, use the large LLQ.

BTW, shouldn't ethtool's tx_push reflect the fact that LLQs are being
used? I don't see it used in ena.
