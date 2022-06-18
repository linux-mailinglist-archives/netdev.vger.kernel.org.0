Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B48905505F3
	for <lists+netdev@lfdr.de>; Sat, 18 Jun 2022 17:58:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235545AbiFRP6u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jun 2022 11:58:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiFRP6t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jun 2022 11:58:49 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2043.outbound.protection.outlook.com [40.107.20.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2CB213E1D;
        Sat, 18 Jun 2022 08:58:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D1Q23TPQeYn4TGPnRMj4EQmAP3VcZx4h563JhUk7HvERcZLMCedbHdLQRLWNK4evfh92DU/sjg8LTiVjko3l6XeWhbyCLkmCT1qGbJ6DAJBwUuh1pH861PHHJIG3ZGwUS/e56bygxataQfe5xuyL3AiwAQ6kqTJwWNh5qCPOBznxT7CoDNj6GsFoOt4YNElozlw5BvnMhsOKSVU9yZjkibKKvftXgDnDndUUHdkP/UCxhh2leJxXfF8FlhQA3JGm1KyZLazL3pOsJH5800Sxcxyb5J7HWwvybnRBXDJxWAUzXxXUVNCxBcMvnomwY9d2K8tt29NpxwXgSGJrcfL6lA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NLcNp5Aycn5NRVoOAc0yHdJ6U9T2hBEGBNDaY6t9PiE=;
 b=ILhDz+nifU5dnMTsoZH+UaW0oWJuvzzmPFUubl4SNlXjJw6Z5uji/zXoFrYZdFG/gBEgnozYjREzoq14vBWQ1MGyA/3MxAhCDkW6hrsDpkVcA8k9Vy3MBiPpl4EPHDpC5lkiauhEp3jW3euxuIn/3KpiAFsqY5hIsACzwDpg055lqplW9QXSMspcQXfj2mLYA44VN0Hs0vJRHftnZeZUdWGcR5Km8QuFP5H7r81a7wEEtbmBRoYymcJrB1GaMdR0jBnNXkNCgv/BrRhQi9VFNk95XT4dAb9Otv9hc4c5JU+JqkC9FLznPpUZPGE9W+vzo11/hSvBN5Nu5fST8Aa3nQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NLcNp5Aycn5NRVoOAc0yHdJ6U9T2hBEGBNDaY6t9PiE=;
 b=znBlaHgZAB+jz3uJWl+G5xD5pgGzIdkxz6BpO5Ij700z1cns26aSOrYSyPivjncGRLekwaksE6fV5Tuzj8pZ/QcpZgWv1wGQfAnV9ozBHro+L0jT7eovyx0bOia5OwuUDtocvo/2n0YNtYr4+Tq6ZOqhWv7SyYet6Tg8Hz/QC26B6AEHNGqueWTs5vuSGq+pESNl9dPDQTBMduJVOF00W+A8FZ+H7x3sqIUIZQTLsr1EAs43Hm/Y8yDg2ii5E20JHFu1/nG7es1RwppwZx9ATTGSjV+D5sAtgPQSbSBnZXK7Ou/+KFEE97hxf/Y+t3ger4iQG0Bey8vtx0xKVuhDSA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by DB7PR03MB4601.eurprd03.prod.outlook.com (2603:10a6:10:16::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.18; Sat, 18 Jun
 2022 15:58:46 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1%6]) with mapi id 15.20.5353.018; Sat, 18 Jun 2022
 15:58:45 +0000
Subject: Re: [PATCH net-next 25/28] [RFC] net: dpaa: Convert to phylink
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
References: <20220617203312.3799646-1-sean.anderson@seco.com>
 <20220617203312.3799646-26-sean.anderson@seco.com>
 <Yqz5wHy9zAQL1ddg@shell.armlinux.org.uk>
 <dde1fcc4-4ee8-6426-4f1f-43277e88d406@seco.com>
 <Yq2LLW5twHaHtRBY@shell.armlinux.org.uk>
From:   Sean Anderson <sean.anderson@seco.com>
Message-ID: <84c2aaaf-6efb-f170-e6d3-76774f3fa98a@seco.com>
Date:   Sat, 18 Jun 2022 11:58:41 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
In-Reply-To: <Yq2LLW5twHaHtRBY@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BLAPR03CA0037.namprd03.prod.outlook.com
 (2603:10b6:208:32d::12) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1801ace0-0271-44fe-802c-08da51436cdb
X-MS-TrafficTypeDiagnostic: DB7PR03MB4601:EE_
X-Microsoft-Antispam-PRVS: <DB7PR03MB4601821CE5D861A40B09248696AE9@DB7PR03MB4601.eurprd03.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BxXoguvDqh/tEFewxWKmas1n19dq54DlmJ3Wiux/04Nkd2DKLpxE9VgPSUI/bDIjEEw+aH+fKsPsIyu6u1rMd6j2igpVyBm1OvJRJIOffvwopTdO/0ZHeFKIcwEYlcYLpCtqGkwRYslhGw3HTDXwhOiA2VEtMhg1e4pfYGA8d+EJVVh9ApAdsOyF/351Sk5bOdlx51YCfp9Fu6dNyjb/8OpCqXC2Gg41IlWrXwMhSHdws1fbdExKD312BNiBMOhhfTcktmRY73vpBEOCaRuW5b0EsIfooc4nS0A9SHtf2UAC/hy6OtW2YW2a6hT6A6E4NRdWKdLoqr2vGmKhipu4Db91BafEyT4kgk8Bd97id1drMFGhK6LgN3Eu+i/OEp6dTAhz/hUt6HmDvaD88yIGcEG3vdT+nqFvzdOOTEmO5EfyZcOex/aJtt7mn4Fk2weqDZKFwHwORadOmUGfVs8thmHAPYkFPosJWeNyZ4blJLdwmY6oR6dw8b8OarAXdQgfM+7HrGv7KbNU9XLyKQN8uAMOaCH89GaA6F0Q2jrCBv2x0PdHyh6xaYCzbwZYH37wK0r+6KXb5R1NLywHyQ3NHJ77cRcTc5ULAP+Vp4CGPaMCr/JCsHVdI33acqj40ztWZEooWVGxV9o/ceI1WQQSxYGjsC/KkGk8uRVjS/NnGEYy5hTTkIpoTEyzUYZpmZMn6igret8Jc2N9xCIz1vq1AoDi9UuX5NE388AYnrFAFpc86Ka3vE2V3/F3XFx9ht9R
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(6512007)(26005)(66556008)(4326008)(316002)(31696002)(53546011)(66476007)(52116002)(86362001)(2906002)(6666004)(6506007)(6916009)(66946007)(54906003)(8676002)(8936002)(36756003)(31686004)(38350700002)(5660300002)(38100700002)(6486002)(44832011)(2616005)(83380400001)(186003)(498600001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SGRkQXJFamNZQ3dTeUZLdlJvUjB4NHFsRGwxdStuWjRLSlEyUkFtYzBrQWNv?=
 =?utf-8?B?YjlDNXlLRjhXSjRWUWdJL1NIM1pJVWpFVGN6Z2pFSi9LNGVUMlpTeUZRTzJz?=
 =?utf-8?B?TlB5NjNUOGM1OURTWElaQ2FQRHVSZlpTK3l1bm1TNTdMNnBnbEZUTEJrekV4?=
 =?utf-8?B?dU5mOEQ3SzJhNW5pWEVTYzArR1FlYnp0bS9McWJIU09EWUR1TXRPSzlOZU1O?=
 =?utf-8?B?YUNQK3dUaVNreXJaVnB5amhnWE1XRlIrak9JdElQS0RPUnBGTEFoSlV5UjZo?=
 =?utf-8?B?b3RoclhzWDNFUWhWdmZ4YVY1d1JGYzVrY1Zod0ZOQmtReExnL2JYNWlQQnZH?=
 =?utf-8?B?M1JscHpMNUY0Vy8yQnB4RklZUWV5b0ZSRzRGQmtQM2ZsVWZyQzM5SDJJb3hS?=
 =?utf-8?B?dFQ4dmMzTDh6THc1RHVMWGZrVjZzeWVuZ0pYU2ZPS1N5Yk8xTkJpVnBhUWVF?=
 =?utf-8?B?eS9BdXZhUGJESFBjZzhxY05uMXhMaFBpOTlvM0ttQytZZE4zSmYwMTM2QnNX?=
 =?utf-8?B?WU5aZDZRRjRvdmQrSnpkOXRROU5EdTREckZmS2l1cnNEMFlNbElYVXlLaEti?=
 =?utf-8?B?OTB3VWF6RmxsV1ovbG9tTnVmR1N4V1o5MmFtOHVEQ1pPZndBMzVwWXJINDVQ?=
 =?utf-8?B?Wm1nWG9kNHdJZXRFTG1PSnVSY244MlBNeVRKL1R1N1V0MHROSHR6ZGh5a0Ew?=
 =?utf-8?B?S2EweHphajRzd2k3WkU5N2w4UjJBUXlUNGlnNnJGa1Y3TjFjZmo1TVFybnBM?=
 =?utf-8?B?WTFZcmJkZ0c5RFRwN1lVeE9CK0FKME5zNHpWNnJpY0xxVmhDb3QwNTBpVytm?=
 =?utf-8?B?aDJsZlJEdHNxMk1kOWhJYndBUTVIYkxFMXZwQmNIVnBTMTFzelVwMFA3WHpH?=
 =?utf-8?B?Rktkc3lvcWNac2RKVE9Cc0xWYmlDQWhFcm8vT0R4eXhiRy84dFd2WGlaTUNt?=
 =?utf-8?B?M2ZESG9ETmt1dmRMOWk1OWtZckt2U1JHaUE5VXRkS0oweDVPcEZ3UW1vM1NW?=
 =?utf-8?B?MWFhNVdjWml1YmRaMDhvZElFcUM5WjQzb3VxalhkZ3AwcVE0WkxlVkk5c041?=
 =?utf-8?B?NHhIZUMyUWo2NUtlSCt0QWNmTWZleEJMU1FsdUJhRDdscmdQUlBEMEsxc0Ft?=
 =?utf-8?B?TGYvVHdqMzFueUdIYmhoTjlJMGMvSXNBeG5ySWd0YVFxWUtLc2JBcmJraElQ?=
 =?utf-8?B?VjQzVk5rQU1BY0s4QzVENlcySkg1dnFjbHE1MmlOU0dtWWkwcmlXK21PbUVa?=
 =?utf-8?B?VkZOOTZ5NFVJNDhacmpNbzhZL3hQbndxNFM0aXljQ2dib05YNkp1bDRkRWhW?=
 =?utf-8?B?b28zZFF2cHF5R1ZLajRsemVBTC9lVXBQNUdXNGx4VUlCVGVwRFRrS2MrL3k1?=
 =?utf-8?B?VkpVWS83TmF0eGVNS3dYRUxJd2EzNTV4eXorR1RCYW9EaVBOazYwZFVjS3hN?=
 =?utf-8?B?WlUvK2RQQ2dUa0diaFd5cGJnMUpaVVJnWlovWkpNUEdna1NMbGFHeW9pSjN2?=
 =?utf-8?B?TTM1dFQ0Ump1T3N6RDZaazFmbmd5NU8yV2RLRWhnNXJBVVdUVXJFSThrTlNS?=
 =?utf-8?B?TTNMWVVEYnZOSXRIS0tCVEFkYUJIMXNjbkVlOE1MWHpoWnd0Q3c3VGhBZFFx?=
 =?utf-8?B?NkRkUU4wd2w3T1RadVFBWGNlRTJVZTMyT0VXWlljWGVDcmNoS2tnV25DWHo1?=
 =?utf-8?B?NHZtWXNGR3BIRzRsOTBHQW92TE9zVUJZcDZIL09OREVEOHlRWGNyd0JQNWUy?=
 =?utf-8?B?S2NER3lHQ1FZTmxNVTcyU1Z1NHVXc0ttRFYrK241THBoSlhUYUxrQ2FNU1Mr?=
 =?utf-8?B?TVBzZW9KclpseFkreFpFUndWdDVXVUNoeExlQmc4ME1IdFpyVVEvNHA4VGlr?=
 =?utf-8?B?T242N0daNHQ5ZmdLbktvZUQvYS8rUXh1a1p0QUN2ejF2dndIcURIeUlyOGFu?=
 =?utf-8?B?S3EwVW5sbmNiSjB6UStIeXV4TFJKM1ZtTG1GbUpoa1NLREhGUlQ1czhCaWhQ?=
 =?utf-8?B?RjBLR1k2dnYvRWY2S0VFMGY0b3B4L0FLRkxQZzBBRkJDMUtsY1VGeHNVSXZX?=
 =?utf-8?B?Uzk1UnBFU252aHV4M0RCRFBnKzlGK2ZNSVFOTC9TZ1NsaHZpMGxjaGdBVTM3?=
 =?utf-8?B?TTd2N1dDSHNyVFhZMlpEMTFCZDRrTi8zaFVUb2tJWnU1Y3Z4RSt6ZkxFbXls?=
 =?utf-8?B?RExzc2JDRWE3U3IzOVFmV2ltM1VyaXJ6TnZrUnpNc1hTWGowc3lkb2pnbFZn?=
 =?utf-8?B?TmUzL2FaeEtpei9OTkdHVWVuVE9VZW1ZdDhsODhIV1VnY0NaSHgzOEJIU3BL?=
 =?utf-8?B?YVd2ek11aEE0U1B0Q3ovWUpXQU1qNWwwU3RLNU5XOVR2QThoNVlZWXhYRkxQ?=
 =?utf-8?Q?l3ryZy8oENUvOXaQ=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1801ace0-0271-44fe-802c-08da51436cdb
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2022 15:58:45.9048
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NSTwpd4GQrojdQrwLbByI9htVardmzKr63MEt+Rjo2/yoY82PFpQnpB8GplGRUqkiJQCGc3aURB9qI3Mt3wc9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR03MB4601
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Russell,

On 6/18/22 4:22 AM, Russell King (Oracle) wrote:
> On Fri, Jun 17, 2022 at 08:45:38PM -0400, Sean Anderson wrote:
>> Hi Russell,
>>
>> Thanks for the quick response.
>> ...
>> Yes, I've been using the debug prints in phylink extensively as part of
>> debugging :)
>>
>> In this case, I added a debug statement to phylink_resolve printing out
>> cur_link_state, link_state.link, and pl->phy_state.link. I could see that
>> the phy link state was up and the mac (pcs) state was down. By inspecting
>> the PCS's registers, I determined that this was because AN had not completed
>> (in particular, the link was up in BMSR). I believe that forcing in-band-status
>> (by setting ovr_an_inband) shouldn't be necessary, but I was unable to get a link
>> up on any interface without it. In particular, the pre-phylink implementation
>> disabled PCS AN only for fixed links (which you can see in patch 23).
> 
> I notice that prior to patch 23, the advertisment register was set to
> 0x4001, but in phylink_mii_c22_pcs_encode_advertisement() we set it to
> 0x0001 (bit 14 being the acknowledge bit from the PCS to the PHY, which
> is normally managed by hardware.
> 
> It may be worth testing whether setting bit 14 changes the behaviour.

Thanks for the tip. I'll try that out on Monday.

--Sean
