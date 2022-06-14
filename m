Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E37954A99C
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 08:40:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238869AbiFNGkI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 02:40:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231724AbiFNGkH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 02:40:07 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2059.outbound.protection.outlook.com [40.107.94.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06C9037A96;
        Mon, 13 Jun 2022 23:40:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IBiMSL9ewUVGQaGOjuIbvJSOPIoQxQlPTUHXwD1Pi4fIeNhITioIHkxuxlBupQGPxCvL4tOTqTSM8v1DHoQyH8YCA0yW/KB/SPYmDmukt8+gsrqTRLo8kP2TixXJcKIpt5zmM5C0BDnb3RV/MFllnIUreel3JJggmR5WLIIGvsCRehYcU67RB2LrCp/trV9qk2q2NzNe5Aa/ZYp6czpNv/dt5KuIHa60HN7VnMM1D5a78l6hOlT85VlufybMUeqAh7mGHaYqxEhtxINWrUZe1Xck7XIDfr9hKsUWuYmh1+9yBvCEtXbqSEHMDlnA5iJxKdEhY36UvbHomhcz45hXOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qn1J/b2OzuBhS5h+bPfSngDrjV9PQd3NC0Uf2GizMhA=;
 b=iOqfGGBQHOptst1/P2SeD+AnUGtXQs6R9D0zXbcIl/MRPKXrybNESBV+fasPJJ3R5L1CNu4ihRxH3iYt26gRsaZ6LAqbe/yWvgy34Grs2TpPgUjfclytUfzrw+LqomKXg7vKQZSHRbZA6RbNfb6cUbCPS7mLyEyTGOxTGOifTk7SdFtNkeCBrgys7tB0ZtqMOmMuk/+YPnJoYDobN5OS6azpGtaJl1tUJBdbZ2TIJDhiWh32RbMRfiYnIWhqUN3VqCsiHGJ4GO9ntqZsJzIpwkq/QDyiy5aU9susw2HDDoYECNlSIrN2VZd20qXZKn7pXrTzOUTRRSXdni2RchGIAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qn1J/b2OzuBhS5h+bPfSngDrjV9PQd3NC0Uf2GizMhA=;
 b=tfAs0VlzaN4qVsLiXgg1V3QK54W3BVJkLQU8HsUCpSyObsmanEVKkx9Bn0vKbcuIXARxmgmALXo78mrX/tLF9/o6zLF3EZSOSJyg3FC2z82VZjiqyYVxgkIYe07BbbmQA+gOpiUSR3wtVoA7IgC37DPMPZKqlMuuwt/dFFXZNLFz5PRnCxYU0b+sykTdDBUCxOaHU0cLnMBAMrpciQI4iGR4H95kNmAPvg8ttrCpnRpM8QsEOjO+fBXWwQqGmHkhmB3GPFCyJXqJ4Sm5aLQfskKyqS1r0+9eBxWlqH8F50RMQzw4V0Y8IP9k9VpPqCtqlRpx3sOdTcE/I3OtbC8POg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5150.namprd12.prod.outlook.com (2603:10b6:5:391::23)
 by CY4PR12MB1718.namprd12.prod.outlook.com (2603:10b6:903:120::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.20; Tue, 14 Jun
 2022 06:40:03 +0000
Received: from DM4PR12MB5150.namprd12.prod.outlook.com
 ([fe80::b133:1c18:871e:23eb]) by DM4PR12MB5150.namprd12.prod.outlook.com
 ([fe80::b133:1c18:871e:23eb%5]) with mapi id 15.20.5332.020; Tue, 14 Jun 2022
 06:40:03 +0000
Message-ID: <fd83162c-e88e-99b7-3758-cec942f3f37a@nvidia.com>
Date:   Tue, 14 Jun 2022 09:39:51 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH net] docs: tls: document the TLS_TX_ZEROCOPY_RO
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, corbet@lwn.net, linux-doc@vger.kernel.org
References: <20220610180212.110590-1-kuba@kernel.org>
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
In-Reply-To: <20220610180212.110590-1-kuba@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO3P265CA0012.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:bb::17) To DM4PR12MB5150.namprd12.prod.outlook.com
 (2603:10b6:5:391::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a1cbaf2e-a634-4385-8554-08da4dd0b65e
X-MS-TrafficTypeDiagnostic: CY4PR12MB1718:EE_
X-Microsoft-Antispam-PRVS: <CY4PR12MB171802C110635428E99E5B42DCAA9@CY4PR12MB1718.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 81i7YiWNcnbGOoMxuI/suWRPludZTUM3suYXRHIR55GlqiaWqEa5Ml6kd2oFOwUZQ2j4W362ddw2NmxUKe/l82yp/zr6joOdmlnMrYyno/su/TJ/jTvGT2ABg2O4HhFUYKjsvnfpCbsi3aMWfnQ0WEO9lyf3KdtJNNKwj3Ivev1T8CgZMCzeq+DhQQHjDCG6ucp4+Hpq9jL7jkoK41yr/tR86YcfW+poCEKZkPoPPFN9fjwSn8P19MZoztsrST6SAk9tJ8k7cYJ094+g+4OxxT2fYH6nhRWg396kzikpovrPgcgyckl7ioTd8d6nsXKNseERj/U8bNkHX2XekH2vnGC26yYmi0Je1rMMbia98o8Jj5e2j0qFfYIKs4LKOzNFB9IsqXRz5C/l0s//M3pn3hvpa2HVkdOEC617CeLuzAecR//jnovfAlliwAo3miigAm5H5/sJFybwT4WEulwemjQSw7ZlBpU03CT7Nb+DPW48J3b6UC5cOnUXRQuepeLTTaHFErhyHe4HFtc5ZmNx3/eBp+N1F4b6xS8I2vbmB+zxQlVxXKCpC6LvWF34WIhe/5my5aH8B7Fcy9mVwCjoY6f2sGSpqQdedgeSuiHFjqFUEc5suMMbW1OLS/byiOngxCcCfgvjVt6F5tyiwNtGatnE4YL5IkQ8wWXvKjRz3wIJAzWDdxYdNQvfzniTLPVA92CufpjKKbvG/tzMq2BjSZ99OV/QgMVD3v8b1vOMgfw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5150.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(26005)(38100700002)(8936002)(6512007)(31686004)(86362001)(2906002)(31696002)(316002)(508600001)(6486002)(5660300002)(66556008)(66946007)(66476007)(8676002)(4326008)(186003)(83380400001)(6666004)(36756003)(2616005)(6506007)(53546011)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WXRnSjBQVVNQRGJuMjlQeHphTzNhSkR0RE5sSjB3ZVdOQmt1V0p0dnlIb1dK?=
 =?utf-8?B?elhFbkd0cUN5UFdIcnpVbHAxdFpFcHdjcFh5VVJ1MkdWTy80TEh4eVVtKzZp?=
 =?utf-8?B?TjFjbVEzVHhwcHl2dGd4aWRBQmp0a2p2d1g4L1hNVDlJc2lmc1AzYmhKbFVm?=
 =?utf-8?B?MDQzVkJMeFRtZDN2RTI0ckJWamVxT1dsZkk3VG83TzR2UHQ4U1NNUzJsR0JJ?=
 =?utf-8?B?NkdIUW1LTmlLYkw1ZUllZUtWbnByVFhnL3c5TmNrU0VQdi9kcXhWTFgvVy9T?=
 =?utf-8?B?ZTZSK1A2V2xtUkhGZmgxc25tUHBjd3RvRVIxVzBIRldPcVY4ZlA3b0ZraVlx?=
 =?utf-8?B?b1RFbGJ4RVJvWXY1YWIvK3c2L2dNemlYZ1NnUGlJV3RmdWJWRnVhWnJrYWIx?=
 =?utf-8?B?S1ViQXpBSk0xZlNJd3NGRis4ZWkyNDFGYnNQRmR4QWpBRmpqa2dRQTIrVnQ3?=
 =?utf-8?B?ZGVxZ2hXNm5ZbHplaTBxcVp5eUNFazIvU3NHUm01UURxTjN2Ri9PaEphMERJ?=
 =?utf-8?B?TSs1OGw3M1VMSmoxdWdQaTd5WWZVMTBlT2xwT2F0QmpMOVBWTi9NZ0hIR1Jr?=
 =?utf-8?B?d0QvQk5FRWhHbHJHc0xHMTRzcVhwVWJCazJCRyt2d2Y1NGM3QTl3eWhtQWtz?=
 =?utf-8?B?WWV1NVdQazAzVTg2aDZReGo1RzJwT3RWMktRY1VlQSsrN09NR3kyMmhJVXBy?=
 =?utf-8?B?Wms4WkN3TEpUSWFJejkxN3gzRndCNXk3blBBUE9IbjRqelJqWUpFVWt0RkxG?=
 =?utf-8?B?SDRqdG9zWlMrUFBpTGZrc0l6TEJuMFcycFNKeDg5TVA2V29BcjZvaW1zRW5a?=
 =?utf-8?B?VUZvellOOXRibG1vaDNTQTViK0dFRHEzYkpjQjRpQUNQaHBOS3lPSmY4UlRl?=
 =?utf-8?B?ZlBJSkJOZ0cxOWJmaHVRTkpFcGdsdmdVWU5VZmZpaFVjaFBRRnBBZU1yRjNP?=
 =?utf-8?B?MjBRTjRuL1ZJa3ljY3YvemsyK1VZVDVCZGZUWjhBYVBEbGVjdldROW50YXE5?=
 =?utf-8?B?aFJKTWdBaVRIQzVjeGhFRlRTdzBuaU44ZDcwcEVDRVVkWUpydkdLZTVUeThs?=
 =?utf-8?B?UlpRSHBpSHpHMGJTUndBeVBuNURicHBIUytTZW9TZ0MvVHg4Rm1MZ043NEFL?=
 =?utf-8?B?UUlOZktsK0RtaG9zL2JnaDZDNkExTnJ5YTJMdGdaQmJZRXdQVU9tUG45QlVj?=
 =?utf-8?B?YTFSNmdmV2tGR3FtRnppMTFnVFdOaW94d1pWUmVJWmhvdjhtSzZLMnhLV0V6?=
 =?utf-8?B?eitoaUZNZkVKcUxZUmxVcTBQem1tVUpjWC9vYk1tQUNLU3BENmdBZDA4aUU5?=
 =?utf-8?B?UmZHdHdNQytiSFVxYitYUVJ3ZEZlVUhxY1ozNnJHQmUzdCsxRnFoTDhyODE0?=
 =?utf-8?B?MG93enBnTlVWUW9pNE0zR1FkRVU2Y1NlTW5rbTRySy9kakZrenpYTjRVVVBp?=
 =?utf-8?B?QTNxd1FpcUttRjdwTys3Tll0VnVuMytaSUFEaXZ5VGlZVlRLVCtvbDVqYXd5?=
 =?utf-8?B?VzZCbWNOY0U1ZmhVYkYxQ1hTN1NaNVI1bWZXQTVIcnErSm9SMkh0ZWxBL2xH?=
 =?utf-8?B?VU03U1dla1A2QjhtL2o3dUxoK2ZPWUdCRzhyTHRPcVQvM0V4b0NQSTRydG1u?=
 =?utf-8?B?SjJtQXdjUWpiMml6L00yNHFoTEF1YUN0ZndpMkdobTNxbzJUWWpTK2hKNCtt?=
 =?utf-8?B?UUU2Y0Zva04ySXVvM1B5c3ZML01aYnQ3V01OdWFUZ0FrM01HNE9DcWpwWitK?=
 =?utf-8?B?WEVnNUZzOG9HZVcvd0JMS0pGRU1ueXF4MEh5VjJqOWlNTUtEN2lLSHRoMmUx?=
 =?utf-8?B?YkVYeThXa1cwbDgzZ0JpRWJsMVNPZ2JuUDZMSStocnJWVnFmVmtpZ3FlMFZh?=
 =?utf-8?B?aGR3d0hIOFAxMy94azh2U1Q2ckRPWmlQMndpR0QyNFpQN1N6bnh6ZCtxNktL?=
 =?utf-8?B?RTVhZWVsQlc1Y0cydkg0QlRYVGkzYWtrZDZlNUlVZGI5Wm5SRlhtSmtVMXl1?=
 =?utf-8?B?a1R3Vm5HdU5Xd0thZm9DbjVsdUNOdlhWa01tYXhxRXlIOUJpVXZBNG1EaTFL?=
 =?utf-8?B?c3hyczU3SXdNbDZRWEp4aWQ2Tk1pTFBvckJ0QWJMM1hyVThpWG9LKy9KT3VL?=
 =?utf-8?B?RkI3dmVZZzhOb0w5bkF5YTRVK1gydE1md3F2RGNXc3hkU1R1VUZ5VTdheGI0?=
 =?utf-8?B?a2NObXRqWmwydzMrTEhUTHUzY3VtbFVnalIrSDMxQVhUdmxOa1VmNVBuM0N6?=
 =?utf-8?B?VjNFRWR6cnFjUGFSdE41djZGV0RieHJoUHFHaTdNc0dUQmpna25ZbGJlQlFq?=
 =?utf-8?B?aTFZYllDd0lDNXlMRTF3RnZqSXpYUmRuOGtBMWppdysrMThkMkZGZz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1cbaf2e-a634-4385-8554-08da4dd0b65e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5150.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2022 06:40:03.7019
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6B0HjEtUyrSwmWbMUbnZ5+8raue3QR4rzfFT+mQh2KHjXxMM25h0A+UTC0VTdZEUGi98AC9jSIwea60hSt5lvg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1718
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-06-10 21:02, Jakub Kicinski wrote:
> Add missing documentation for the TLS_TX_ZEROCOPY_RO opt-in.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: corbet@lwn.net
> CC: linux-doc@vger.kernel.org
> ---
>   Documentation/networking/tls.rst | 25 +++++++++++++++++++++++++
>   1 file changed, 25 insertions(+)
> 
> diff --git a/Documentation/networking/tls.rst b/Documentation/networking/tls.rst
> index 8cb2cd4e2a80..be8e10c14b05 100644
> --- a/Documentation/networking/tls.rst
> +++ b/Documentation/networking/tls.rst
> @@ -214,6 +214,31 @@ of calling send directly after a handshake using gnutls.
>   Since it doesn't implement a full record layer, control
>   messages are not supported.
>   
> +Optional optimizations
> +----------------------
> +
> +There are certain condition-specific optimizations the TLS ULP can make,
> +if requested. Those optimizations are either not universally beneficial
> +or may impact correctness, hence they require an opt-in.
> +All options are set per-socket using setsockopt(), and their
> +state can be checked using getsockopt() and via socket diag (``ss``).
> +
> +TLS_TX_ZEROCOPY_RO
> +~~~~~~~~~~~~~~~~~~
> +
> +For device offload only. Allow sendfile() data to be transmitted directly
> +to the NIC without making an in-kernel copy. This allows true zero-copy
> +behavior when device offload is enabled.
> +
> +The application must make sure that the data is not modified between being
> +submitted and transmission completing. In other words this is mostly
> +applicable if the data sent on a socket via sendfile() is read-only.
> +
> +Modifying the data may result in different versions of the data being used
> +for the original TCP transmission and TCP retransmissions. To the receiver
> +this will look like TLS records had been tampered with and will result
> +in record authentication failures.
> +
>   Statistics
>   ==========
>   

Acked-by: Maxim Mikityanskiy <maximmi@nvidia.com>
