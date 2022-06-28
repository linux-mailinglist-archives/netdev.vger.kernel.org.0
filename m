Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 555DB55C8DC
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 14:56:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344978AbiF1L0s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 07:26:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230376AbiF1L0q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 07:26:46 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2052.outbound.protection.outlook.com [40.107.22.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E48F62CDF0;
        Tue, 28 Jun 2022 04:26:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f0RDJfZw6vj54LRuO1G2LJv1UtSGWhl3Z31N28F9RomxfOqQz6rxL7wrywpXQPt9jqhMHC0omwwY7sthH/5LgKjwNrw2hvlEMFDw/DaUb/fXglISeFJwA1fn3T53FEljRYtkznNVA0pMsmLPMrWqQvVEoWFNrHuxZqIapC1YTdCqh9UiF5yb9lIOy8oW3c6eNsvKuPmuFNGrITsp7A/RRYMAAzAAayL+SAVcW9imRn0xf8ynQMdT1ryUWOF7l3qYmx7UbxpDa2NOyS584yqkQbIL4cwF+xPLnxKDpUhcRkqGzb35gAsA9TvFPXgyVC9VZWuUnC+xc0+xZHQshXS3ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jnz3xjMw36qokxaOvBCds+sOvQGnOugaz6/aUwKsx0k=;
 b=M7V7WqYH89yq3+1N9Gt4N5MQoVTj1BvHhN4Q0mv30v5nf9yqEcHTIJpq3Zj+cQcW6pxfI08+8jgvCAQf1X5Tqjjz3DnPnpcryCS/hUJhO9W6JwhG5l/TEh1MIZ/zWvq5K3utpF/BdgzAaUN5ierXo2SANufgwhMylhTvMOLfXkjL29I9cHz5IfEWxXj7yy38h6AixInvu00SRVa9eUoqMN02KPueH1JRJFvFE357PIt0wqJN+vq8It8oE++W4Pdp189mQrTfqm+TtDiTY4jAJAc3i9wpTWzCJlF5V8qIJJFhSOCE3jbot3I5WFU6v0dTJnHqr5/y4mTYpB45suKnFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jnz3xjMw36qokxaOvBCds+sOvQGnOugaz6/aUwKsx0k=;
 b=y4skIj+mPEFWriOHkbo+opD9I2VUpwq4BcY9sQBf/uAZTtekJkH3ZPb4aFVd9GB3AvXb/x/tEyfRyui8ZNN9ZEISw7qEf7Ds8giya88by6rUbcpEn+5BkSVR443NbqpIUyOY74Go4mPtWmJg1v9MU2sHQGbknznPcHEccGEpQIoZyTx9fHMb92yGEi5nYtk4RjAc0gL6AeUW6L4exffXlRm/S+sVlspzVn/snJTulL2AGIjU8p0PyHLDJuUYAVUSnavojcw3VFFAvfmlk/fFmA2ujXMe5+iXzi/D31Z1dj5F6E+eusOUtUfgYIebDwyorzP3ePvwRxJkk1KYc6s8Tg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from VI1PR0401MB2526.eurprd04.prod.outlook.com
 (2603:10a6:800:58::16) by AM5PR0402MB2753.eurprd04.prod.outlook.com
 (2603:10a6:203:a0::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Tue, 28 Jun
 2022 11:26:43 +0000
Received: from VI1PR0401MB2526.eurprd04.prod.outlook.com
 ([fe80::21d5:a855:6e65:cf5d]) by VI1PR0401MB2526.eurprd04.prod.outlook.com
 ([fe80::21d5:a855:6e65:cf5d%12]) with mapi id 15.20.5373.018; Tue, 28 Jun
 2022 11:26:42 +0000
Message-ID: <d7c3ce9f-d144-0083-162b-448570f2b5e5@suse.com>
Date:   Tue, 28 Jun 2022 13:26:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] drivers/net/usb/r8152: Enable MAC address passthru
 support
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>,
        Franklin Lin <franklin_lin@wistron.corp-partner.google.com>
Cc:     edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        franklin_lin@wistron.com
References: <20220628015325.1204234-1-franklin_lin@wistron.corp-partner.google.com>
 <YrrVT33IZ1hMkhw2@lunn.ch>
From:   Oliver Neukum <oneukum@suse.com>
In-Reply-To: <YrrVT33IZ1hMkhw2@lunn.ch>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS9PR04CA0033.eurprd04.prod.outlook.com
 (2603:10a6:20b:46a::8) To VI1PR0401MB2526.eurprd04.prod.outlook.com
 (2603:10a6:800:58::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5bd165b6-958d-472e-cb31-08da58f9138b
X-MS-TrafficTypeDiagnostic: AM5PR0402MB2753:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: d/+JbpnbYkvHxUuVOhEZOQIyourDJZbjLU7yhP/47EQdy+e626fp5Gp2vgrQ8FsDqbfvazQOBMIvXHM3ubMKGucy1r5V1PZ+alMC0yIboBilme1zEKjedrOJmUwce5DW2lrMT9qcR89YM0BYkvJ1pMn6yFegJsblylWsa2p6jRM8udx6CBC2YYLAe/kL/ZbYHk1IcQgz6xhs8vFH3XrG9bueefp7b9kLh9NXab9qgSerLws1sbGvqvybl2DWxDTD9axZbvZrNmzVmsjIQcYLg/qSKAbQitNsGOC9FSynAzrRehyuyHkGbHqiJsC+6ZpLuffgsTt7AW7Npcrv1ybMfOTJpS/xTiRrAU5/VHNESz4XU2wCZR4i2kuZd19U9iFKvgrVf4MCVsmBTX3YM9+qqmjdZeVyWEX2pRbvUh3chG9T+8gs8ddupNcg/9IdEkOqTeZ8Wkpu70aIkMc6XPEfLgEvSxqW/95PgsPRL3RAOSlMvX5N3ql1uRBRinbnRepcBo5VBhUDRZaiX/pPNHwQZ7Bpu899OmflKeh+S53gzgmrzFIlJ3Fl4woeoJxe5H6Kd+GuLnE58WBwXbQ8mxegGdb04n25PSM+n+ecv/AjzgkTkZEoz5kndPUXbIkArOL8ED3HbPLtYPep6JZWapdlTuuTHR5vKVRucH3PPLRT7ax3Ep9iIRRDSpbYH+1cl8PfFQFrhzZ8M08yMYBqFKQpZl0paPzFLTOf+e3i0OLeGIKw+zOKtD7yLtoVKcvljjy2UJrViUp3pmDl20am+JLYJwvNnf2f8cQrIERVX/8jT7p7KP9SIKiW4kxJqhDTHVgc
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0401MB2526.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(366004)(376002)(346002)(136003)(396003)(66946007)(4326008)(66556008)(6486002)(31686004)(6506007)(2906002)(478600001)(110136005)(316002)(8676002)(2616005)(38100700002)(66476007)(186003)(41300700001)(36756003)(53546011)(5660300002)(7416002)(86362001)(4744005)(8936002)(6512007)(31696002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RnlpdFErNHZzNU9URzFOdThjb3RzLzRiMmttREJvMC9HZjl3bDFOMHg4V1lQ?=
 =?utf-8?B?MG9MVXJ2aUJXSXBNRHNBc2V4aU9OdGNIQkZ2bFkwUkhoc0ZjZkZYdnFVclJX?=
 =?utf-8?B?ejBQSXZiajEvQjZKbU1wRmZGRzdsb0xWRnowaktrYVgvVG4vd3phbkFEWjRV?=
 =?utf-8?B?OXBtUTQweFczQVZza2UrOCsydS9lSjB0OGtTeWdDUnB6cHdtc1NwcWFJU3RW?=
 =?utf-8?B?WVBlNGtkNys2RFhqRVprcjNYck4wUkpRRDJ0RDhQZWtHdnp3Ti9mRWl0N2R3?=
 =?utf-8?B?eUUyZE9ZTXZ2cWNsWUphVWx3VDlJWWJVdzJTVW8zK1djQnJ1bGdMbm92Rmhz?=
 =?utf-8?B?YTYwS0tpNEUwZGl6ZjhPb05XVUFMbFFmWnF5Qk9WNHgyWWNVSmx0ckkvTUQ2?=
 =?utf-8?B?R1dlVjhpZGYxUitvU2hnNEJLMUJnbFRQK1VkYUpSWDJoUW5PcnJpUGdyd1kr?=
 =?utf-8?B?UmVpUUZBSk9lKytXK01GLzZtQ3ZvMGZUalFYVDRsRlVBaUVaZS80WkIxS01l?=
 =?utf-8?B?bThXTzhIS2F5MjdtYVZ4Sy95S1RlSExBaG5TUzJwY0tzc2xKQzBTWUtoeitT?=
 =?utf-8?B?Z2xoNVlkRERteXVpcWZOWHA0U1RLT2VKZlQ1UEtaVmhCMmVob0xJREhkblVV?=
 =?utf-8?B?NzNwNENWOXpNVFpRTXlSOEZzb2N3Qm52aHBPdnlVeDVFTlR0V3ZKRG1kNmcw?=
 =?utf-8?B?UmpjSDc3WTFQOHhWbDZUbjRnNXVxK2I4SlcxYU9IZVNuNExjLzBtZjBHRXV0?=
 =?utf-8?B?V3VVYzBabXpBTHg4azhHcWN5Skd5bUVhUW5XWEhicHFYQ1dLdTFIYXZhWnB1?=
 =?utf-8?B?VUEzMmtmeUhiTEtiZlA1UDBXR1ArZ0xrL3REN3QzRXdYTFhpRjJ5MFFLRnJa?=
 =?utf-8?B?Y00xMlVnRGNjUHhFTGMrRGgyRWVzcjREellNbkt1bkovd2JEMHJqQ1l5T25x?=
 =?utf-8?B?cEd0MitCa2liemtKVC9temRzRG1rZUY1SW5lSHZCUTFFem1jQ1JXeERrUkht?=
 =?utf-8?B?aG51WUNvUnZHa002dllJYVZrRlRlZmg5TS9XWDZpdEFsdjBWUXVKY0xhNDE1?=
 =?utf-8?B?TXZjL0QralpPUzlzVndobTlrVmtDbnhocWFJdmRJRUlJZ2lKOWVEYmwvVHRT?=
 =?utf-8?B?YkZUZGd6bGhPb05TWjFaVFJ2ak5uVXFRVUxjVmMwOXkwdk9oT24xdXYrMS8z?=
 =?utf-8?B?cUxyV1NWbGk5cUlIaG5DeDJDY001OC9MZ0kwVElIQTZFLzljWEJZcGdkczRE?=
 =?utf-8?B?Y3lFTS9uenoxbHJvK2dWM2NpUTF0Z1U3VzRWU1dyNlBaY3MwV2tWQjNuSlE5?=
 =?utf-8?B?VFFSdDJ6VHh4ZnJYY3JFU2Q4RDRoT0V5STBudG0yaXVXZklqcm8ra0wvOHk5?=
 =?utf-8?B?TkxjNElqdEhtalBYaExrckVtc0tucXRvZUpzQjVMUHpZbjMzVU1KdzJwQll2?=
 =?utf-8?B?OHRiLzN0b2ZaTW15R3pGM0RLcXVxdXdKdjVuSHJ2R3NESnoyQzFTaTVEYkpm?=
 =?utf-8?B?YlVyTkJNSHNEeGo0cUFXQUpJak1NY292dDNKRVJYczdwWTNNc1RtNUlBdHJP?=
 =?utf-8?B?NkFFQ0RTQU55OElxNkg4NlN0TzBWOWlwc2MvZDllMzQzVUFzMjhzN1c2Smcw?=
 =?utf-8?B?bHUrZ1hQK3ZGSEZrMjNuSVNWNzFYUVhMM1lwNmZHNll3VHFOYlViMnU0T3F0?=
 =?utf-8?B?bDVUM05PR3ZCRDhycXdZcCtSbmdSd0h4OWp2aWg1dUs1YjFXN0FjNkRydjdr?=
 =?utf-8?B?aXdvYWRSWVBDRWhMdnVyL3g5UEdPVUl0YUVkL1FySVAwNXlSVXk4dWQrR2xv?=
 =?utf-8?B?L1dOU2hhT212M2VHT1NmUXpLSlJZOWd6cXR5dVJLNjlTVXkvWGpMc0pKd0VR?=
 =?utf-8?B?T3dZbUVJUFlDRDBlRTNCZFdxclZWZjNpK0lYR3NaZE5TSUJOZnQ3eFJxbVd4?=
 =?utf-8?B?RlZacldVbzdHOHl2TExGbm5kMWJJWmE2bGlRYS9tVDcvVC9aWnByZnZCRDUy?=
 =?utf-8?B?MzlhaTJmTVhteGxId044dkswYUdhR0hMUXE3a2twYzYzMEdFRG9LM3JXeTZo?=
 =?utf-8?B?UGJYNEorTGZBTkRpMUtpZVdWT0tZNnBMcmFvbDVqaE5qWWlQWnlSZGRES0Vh?=
 =?utf-8?B?N3lhOE9oWUw4NXl2MDc4VGo4VXdBU2d4eFBucWdPT2xXTmF3c2t0dnhMR2gw?=
 =?utf-8?Q?V4Vbv+ggQ74ZF97gGUrFvJ1ZfiXzzDxmVPQtvmpXKXSX?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5bd165b6-958d-472e-cb31-08da58f9138b
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0401MB2526.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 11:26:42.5938
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DYdQhjEr4DgS6520kkKgVcm0e/11+sRPXx8pHwq36Ux7a7Edo9132ETbWS05siHC80V1Bixn2xgDt0XcYIzF6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR0402MB2753
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 28.06.22 12:17, Andrew Lunn wrote:
> On Tue, Jun 28, 2022 at 09:53:25AM +0800, Franklin Lin wrote:
>> From: franklin_lin <franklin_lin@wistron.corp-partner.google.com>
>>
>> Enable the support for providing a MAC address
>> for a dock to use based on the VPD values set in the platform.
> 
> Maybe i'm missing it, but i don't see any code which verifies this
> r8152 is actually in the dock, and not a USB ethernet dongle plugged
> into some port of either the laptop or the dock itself.

And it will happily assign the same MAC to multiple devices.
I am afraid this patch needs some basic redesign.

	Regards
		Oliver

