Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB64C59FB78
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 15:36:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238208AbiHXNfz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 09:35:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237698AbiHXNfy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 09:35:54 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2060.outbound.protection.outlook.com [40.107.223.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D105578583
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 06:35:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nYRMzZ8nPkBaLuyZx8LKKe6tnn4mBR/X1mjZibE8H1osNGGQEY8IlkEVElpgSPUIb5i6s5eZBBrLoXeGOOLD3EHYDnTVHumaWsoA8pO30joQM69FNKSauqSg48jYcOJB7EafeMHf1W6jmYJ1njcsCTf5YI2839qrqtHHEdAD7ASpSPnACTp8ZjEJJzyRcXZDKc1P6h9lm29FMTipMWiv12B1slTR3MI5fU3HxO/5Yw3LHfGDCOIcLpZ389z5pplD5LC979DlljKtRO+9Q6GHiraiTSPtKcrAGxJrsaVToEJcX71IAVfmdLf8krSf4KrR1Bpu6EaibuyiG4G51yttAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b5w9o3VyIY59WhkELerk1HAC+JRJNr3uXkw8AqGWEbM=;
 b=IX6dfpJQEnpiw7zMTevHV0J7ISoyV7NCG78gMVr8GuPH3vumK0MHYokx69vyIsoxEjD3AAtQApInTJiAL9urdNm1GuaxlG+50DXbmIagcP74Hc++2DPd/Dx/2RP3E5kB8IXYzVySpjHjC9yeb5Km5e3m7YFKTDFB/8H3BFVjx060Jh/i+DSOyrSp/CEj3R+PIExWgR0U21gnOKvCAHmmLcCscx3eKzZ+LB0MRrDptkF41Xsz6rTS82ej3sxJVhUjhj3dMpY1cQP3kKW+QgDoMS8bejTszkZIGZkoXkQYDw710FeWIY0v1W0siOlbhQ+4oqT5NmIjMYfzk4l8XCbHUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b5w9o3VyIY59WhkELerk1HAC+JRJNr3uXkw8AqGWEbM=;
 b=hTc1pFCSLC5D/UQ9rXdQM3dGg6INlPqaVKLbhFw0DGlDU05yLACX4DNyMHx6crlxUdipu/vgcM0pw0ExsV60eGsQKY+KCD4USnQVKTjVwKWEEXpgdcEt2VCMOm+XgzU5jnyZfCippSwCPEp38Fv4jZaNPHRfCHJq+qFD7WJVH4LLA1zX+/AfDRdLfwGJv6l5AHUYf/LuNdncbuVO+Hxpvi4T4P3DrgofgTiafUlvmYUGpfJOdcwVLBcKlsdxn2JOiBRRgeHgcLNeT0kKLjBnBvrV8Ncvrr1xNwB+tdXUjzACBXASsvY/YE+eD5gStcBamTgVGEXhpy7Kp78BgH3pOw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB6288.namprd12.prod.outlook.com (2603:10b6:8:93::7) by
 SN1PR12MB2576.namprd12.prod.outlook.com (2603:10b6:802:22::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5546.21; Wed, 24 Aug 2022 13:35:50 +0000
Received: from DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::2caa:b525:f495:8a58]) by DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::2caa:b525:f495:8a58%9]) with mapi id 15.20.5566.015; Wed, 24 Aug 2022
 13:35:50 +0000
Message-ID: <e8251cef-585b-8992-f3b2-5d662071cab3@nvidia.com>
Date:   Wed, 24 Aug 2022 16:35:41 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH net-next 0/2] ice: support FEC automatic disable
Content-Language: en-US
To:     Jacob Keller <jacob.e.keller@intel.com>
References: <20220823150438.3613327-1-jacob.e.keller@intel.com>
From:   Gal Pressman <gal@nvidia.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org
In-Reply-To: <20220823150438.3613327-1-jacob.e.keller@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LNXP265CA0004.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:5e::16) To DS7PR12MB6288.namprd12.prod.outlook.com
 (2603:10b6:8:93::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a8b842c4-0233-4535-4e23-08da85d58f4b
X-MS-TrafficTypeDiagnostic: SN1PR12MB2576:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kbgbUiyK3QuFx9M4ehRb99qykEbBMfzUNEBtSM8HDhKDIwQml047aEXoxRvxZR2jCMQD//baU7ZvkfT9FLl29wkBQlaTpj8TRGQToP+mzatsFcaSXfvWraaBa0KgS873XP47hjGrmgoNNEiSekFzD9SmPvOeuL+/hgt5y9a6AuZCuUB5qaeKSxNtJLPJxw0N5BF9Q0Y+IEzZpAYyrTPu73WmyGjbkNClCCGyeZsfIUh+VIOdkpfFkxAriOshqr3k94b2oz2RY0JpKJ/QYNF2t63j8nZs0yFzkB6HiQX9i443hQwtSc4xrYcmAy8sihaB/IFWADG6cOg/kOlXJ9lX+J6dWVvJwtB2pwE+uFclP/qS6k630nof6PckYed0yptFtAz20ujwSZbMtWHt6Y7dIjhHZ6WEGrkSZcYlTNkK54RZeDyaTfJmBPuEP4O5v4JGR4uW373hPMtACzC2+RSqVlrEsy0ddtMl+LsimTunrZQpTtdyXoWRSjZzBLb1JCsjuUwY5qb2xOR5WxQ+YWMRYOM5OR5+hVbXfmfvVX6/jlaK9+MG+IreEEA9Rs63BWKYv4GHL5KX8RdMXdUJvI32Cs/8ZjdHwwlFzMnaAsPzz85nrp1VEXkJYnyfx62XIwGda8UXLVp57/HOT3u3SZYFCI3rCJbVEVOOkCmy+F75EmY/Lmjc/+cdBHRT7mD6/clybp6gCLyD7Sg3IdS1tgUH0D5+pTwcKoPrfk6A0kLfMIAsxXNzWsogSXBHPXxJ+U9wpUpaI0DYiZcG3ueareLXRtRpqfFyu2/agv3ltFe0p+M=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6288.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(346002)(396003)(376002)(39860400002)(136003)(6666004)(31696002)(5660300002)(36756003)(38100700002)(8936002)(66476007)(4744005)(41300700001)(6486002)(4326008)(66556008)(31686004)(478600001)(6916009)(316002)(8676002)(66946007)(186003)(53546011)(6512007)(2616005)(26005)(2906002)(6506007)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K3piblAwR0pVa0NhNE1McitiLzhiSGJtdmJpTXBKQnFBeGlCZzdUbkpxY29v?=
 =?utf-8?B?Y3p6Tlpid0tzTmFGK0llRDVyWXFvZE1pZkd5WGlwdHIxV0IzTU9ZanY1L2V0?=
 =?utf-8?B?WVhJNE1uaHN3L0RaK0pmUFlCN1J3UlJTOWwrSHhuZVdRWUdPTVNNRGVJZUIv?=
 =?utf-8?B?NmlUQTZEMVMwd2NaTHhYTmZORHplaVVDWUpiS3lzQU02dDBtTUtLRTNnVE1B?=
 =?utf-8?B?aUxBK0pScytuNmJmQmNPWTEzMlc1ZjNDaW14dEpHQ1RWUEYybHdrN1NTWHkx?=
 =?utf-8?B?UTJ0Y3kya0U2bndOR09vanpjTnpYTU1ESmVBV3J0RHhBOGFuaE1GMFArSTl0?=
 =?utf-8?B?TldtU0d4dDhJWW9CaVFVWS8rSGFjK2UwbEFIbWJ3NHVtSXlpV0pVR0F5L2Vt?=
 =?utf-8?B?M2RGelc3WWVPRFBTN3ZCVDNHdnYrZ0NhS012cDJHMkFJMVVaYTJqbGVPNXp4?=
 =?utf-8?B?YXlWUXNFYXdNYjJSVGEvSHl0WmsvV0hibDArSUtqYW1pc24xNHNMY2w3SXBO?=
 =?utf-8?B?ZWtsL05Ob1k5eERrZVVvS2NRc0ZXUU1YVzVJUlB3bm1uNWVkeVU0WmkvNlAx?=
 =?utf-8?B?N1oyQnR4SUxmcWc0TkdwQ0VhemVJQ085VG1FZGp0OWkrdUwwWDJRdkdsUDhv?=
 =?utf-8?B?QzF2eG5uQ1A5dVh5cDY2M0cycUQxZjltalRKWUJyRVI3YUdac3NxZTFhMHJ2?=
 =?utf-8?B?L0FXR3BkcC96ckhjc3ZWYkFBVUR6bHZhNHpoTHRpLzhDd2QrTklodzJORWx4?=
 =?utf-8?B?bXlSTUpWTHRMVGpHK1ZUZER6WVZ6N290VDcxUTRlaW1YTklpOGxSdGx0dnhQ?=
 =?utf-8?B?a3ZaN2p3Z0J6LzRUeThrTnVhNGlxc1d3WkFOemhhOWtJNG9Na0d6NTN1U0cy?=
 =?utf-8?B?M0UwZkJGMjhiUXprNjhlbXhaOEVIZWZ4czNyNXFOSGMrRG9CMmxuM2JrLzRF?=
 =?utf-8?B?QXVuRG5tb2FEZFBpSGR0QWE3WUovWFZESDdhK2w3eDYxeWZFT1ZwZS9PdVdD?=
 =?utf-8?B?N0FtZzE5UjdVSUl5WTh1OU9VZzZXMWtFT3h0TGpRZ0tuSUM2V0lsSkxTb2Rh?=
 =?utf-8?B?aWg1NjNOT085YnFEYWJMNnlYcGRBMkN4VTByN0dSbWZxak5oMnkxc1pNcXFM?=
 =?utf-8?B?MkFYZ3F0aVlDcGgvaG5JUDM5NS9ONHhFSkZEK05rdjluMlZSdFJhb2lMT0pP?=
 =?utf-8?B?R3BpenBqNUlRMWtYWDNxVVdLSkl2T3JBTjNjc3pDMVFNL3RBcjFZMEVkam9N?=
 =?utf-8?B?Z2xJbmEvRkZJRFJvSFoyRWFUMUxjNDBoUG5SRmxlb0dsUTJ4MzRRdXltNENr?=
 =?utf-8?B?a1hHclNNZUxUWVQybzFkdE93Y1ZObUVqUVA0ODkzNTRlVURiS0xaZ0hTNXFj?=
 =?utf-8?B?TXhnNVZjY3FxL3FXMWJ6SWFuZ2pyMTZUcFhhVmpLM2dnZFFWSzRtemRmVkx6?=
 =?utf-8?B?b1owa2JWUkFNNWJiZE1JUWJwRHdDV0R0cDcyZzN6d3Z6MFVSZ2pOb0RpeWo0?=
 =?utf-8?B?RU5ldGI3QWxXTW9JczhNVW5zWll6akhqeGVUMUpPbzg5Zk1lRlNRYkhQYngx?=
 =?utf-8?B?djZYaEhBcEVkY3drZmtlRWFTcDFwNWVWTnJpSlBTRldoeUE2RUVXbWRXM21K?=
 =?utf-8?B?dmtCYmNLQ2hpWGRQYW1SNVA3cVhXTlhtYkZZOTZGZ2ZqTXN5NkxabTVCS0Iz?=
 =?utf-8?B?REVWZzh1SkwwUE5xOXl6NHYzSjNqNmVsQkxCK0ZYTDcwbWRHN1JGVFc3ZGFF?=
 =?utf-8?B?Y0tnVTU3TXRTYzFreW10VjFrMG9rQWY4aS9ZbDc4TksrUG5PNTlob0pkRUJn?=
 =?utf-8?B?dHNrNjdSb3ZqQmNRN0o5VWxMblFXbkhNeEJ1L0JQd00rMEwxL240MGJzRmRQ?=
 =?utf-8?B?QlRrYzMyOTZoeG1tWjN2MXAxOUo4MC9CdmlWYTVYVVM3ZmNFTWpGcm5SZC9V?=
 =?utf-8?B?S2xWTWpRMkVWd1hlb2JZb2QwWU9lckJyWjJ2T0g1QWFVUEp3UGprd0tZUURO?=
 =?utf-8?B?RjdvMjdZNWwwbkJQdXZvN2tCd00wYTMzLy9ldWcwL09RbFhxMnBGTWVhay9r?=
 =?utf-8?B?Szh4a1lDTVFOT1FLZmhSY3lGdnhlOEUzeEtCNE44TGRBL0tyaHprN3c2MmVP?=
 =?utf-8?Q?6RdvT7aX+Zg4n4EDHYECF4WiX?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8b842c4-0233-4535-4e23-08da85d58f4b
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6288.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2022 13:35:50.6826
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KlXPVtvpheLnzh64lvkoslcrcL0KoyAfbo/eEhg7WJaV4QICCm1R8qkJxqvbQMZD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2576
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23/08/2022 18:04, Jacob Keller wrote:
> 2) always treat ETHTOOL_FEC_AUTO as "automatic + allow disable"
>
>   This could work, but it means that behavior will differ depending on the
>   firmware version. Users have no way to know that and might be surprised to
>   find the behavior differ across devices which have different firmware
>   which do or don't support this variation of automatic selection.

Hi Jacob,
This is exactly how it's already implemented in mlx5, and I don't really
understand how firmware version is related? Is it specific to your
device firmware?
Maybe you can workaround that in the driver?

I feel like we're going the wrong way here having different flags
interpretations by different drivers.
