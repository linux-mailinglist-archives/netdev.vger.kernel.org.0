Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23FCF60352C
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 23:49:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbiJRVss (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 17:48:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbiJRVsm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 17:48:42 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150070.outbound.protection.outlook.com [40.107.15.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36040BBF3D;
        Tue, 18 Oct 2022 14:48:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ecM/XbotoQUTDluC/mG963Z/mPthXImIliD0+MKd2T6O9dS7MjN6AswE5iZEMa7t3zVhC9NMAQH5KBDc8vBoruY4FrNhCZzvmT1WMIi7B6iV0SggAORCamstfwFCfAe/ltC7Xi3sKOxdwMyvZ2fI+QmXuQTHEWU37C2PvBio/gefq74BKpuT7TgwZG/lY3SzYHhGP9OdZ1infA+fgLkeaAoAk7S5h6sqgF+ijeEmvDj2v7boWSGxIFf/dP0wrCgOqW+nXkOwSKLTS/gr4T5bSLySZmKcdtq+/vDvWqZU8yZLtS9Igb9/+ejrRKVuh/3Z5v2OFBfUZdYMfW2OE7vRpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c9FaqAIDEwru8VioUlf22IjpPf4Te9oJ459eWD9rkjE=;
 b=hxUdbvpMD+I77KSByXg7/UfDajTb1ZzI5tsjwpN2BxvrIj6HjDe5hKZeAuogcBdzC0UC8CJm9u83Bl/H7SXT59fnR3hwC2K2ygR/d0b569igdvXS8SV6mDbsfg5PD1X0ho0yZT2pmujanN53m7uFQAi+KZhuLTVMIZzRwLsDLpLdt3lRr/p26kvsqujzN2z31rY+w4rfiDuv/biLLssmI8ldX/FRiF4ggnvDJ3bRwgq8UDjUV9ALhMpofjAjkdtJ0tI1lZrqvH/GUqnlZ4LQHWj0C15sDSaP45iqh0rTxjtwTLSXYYt/Pw7havB1VPEOX9+/jDqivHhvgJnDn2vmog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c9FaqAIDEwru8VioUlf22IjpPf4Te9oJ459eWD9rkjE=;
 b=Z6gEHD5hWtrzaoF080K/bmx3OwZ1cmCvaQppoeo/AzDdcni1TiOK4LKq+NTvzb6w39BgcrYfkqSFnBM/TEBEdufdJEyqA33+d9bT7x+CQsaIS3cZAtJfUsyNPX6ppniwVPegu5wt0V5KnJilXvrbS8YIxsJOeqPtKra5i3LvewJy/wgm/LePyLvKtSgpYf+QnJ39SPstdqfMChkfzx3rukSZObFZcnHDDPnv49T/11PntVw1ErTVaPJUJ14xg0ZX8wERGeDmTfjiGVCwhaTKbmmbnq5kJ+s9LNNo4yYNXmOe9in6nuaRorz9++D96BkWB8ozugEFqEY80Eq81gXqvQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com (2603:10a6:803:c5::12)
 by DU0PR03MB8463.eurprd03.prod.outlook.com (2603:10a6:10:3b5::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.32; Tue, 18 Oct
 2022 21:47:27 +0000
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::3d5c:1e59:4df8:975d]) by VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::3d5c:1e59:4df8:975d%6]) with mapi id 15.20.5723.033; Tue, 18 Oct 2022
 21:47:27 +0000
Subject: Re: [PATCH net] net: fman: Use physical address for userspace
 interfaces
To:     Andrew Lunn <andrew@lunn.ch>, Andrew Davis <afd@ti.com>
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Camelia Groza <camelia.groza@nxp.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
References: <20221017162807.1692691-1-sean.anderson@seco.com>
 <Y07guYuGySM6F/us@lunn.ch> <c409789a-68cb-7aba-af31-31488b16f918@seco.com>
 <97aae18e-a96c-a81b-74b7-03e32131a58f@ti.com> <Y08dECNbfMc3VUcG@lunn.ch>
From:   Sean Anderson <sean.anderson@seco.com>
Message-ID: <595b7903-610f-b76a-5230-f2d8ad5400b4@seco.com>
Date:   Tue, 18 Oct 2022 17:47:21 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <Y08dECNbfMc3VUcG@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0140.namprd13.prod.outlook.com
 (2603:10b6:208:2bb::25) To VI1PR03MB4973.eurprd03.prod.outlook.com
 (2603:10a6:803:c5::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR03MB4973:EE_|DU0PR03MB8463:EE_
X-MS-Office365-Filtering-Correlation-Id: 3fe6f2fb-d786-42d2-aeb0-08dab1525942
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YMFjpFS51k5KCu2d3MfPaEzOMdtT/8yXlTwxDKCP9YnIHMHiYWD5Bfu5BKqyO3pnSbsRicKi72NSE1qy+Y1pBhfdNIVb7YckPmu9umRUzTBeyn+K1npgJxVqHdHqPaBtYdvX2wRWi1FXKKCO4CnclfQuAg0QoBjT91PO5xM2r//ctxCsCbZ2TmdLRe60X4kqHg8r7vC5Ij6Ceod0bNAE5T6Q8VuJIsdjnw3RRUKRQk/Glf1W/Q7zjkLiHGWLnCT34U53CgUBjsj7abrvgyKRcwqroJsWrqndd1fovW46YOWsjhWRKZpL5t6++jaD+os0vyvBk78HXKgWM7gsrJ22NdqdTfDckUarhL6n/PnQnlT0n2mBM4WYaduKXSLn6JCpjH1c3FDZNKPFBI1l0jLUSdLhLLnMTQahalnAUVW5I72UrO+1W4U+bVA8OceZbr2kVMg3NTzLwjcb5n0yMI/Eb/dv/WJT3NV8g4bdYS828Rq9Wj1Hr/kAL01N1xVFcrhN5tiGErxCT1V0XuXvsyCCYWR7BP3Kv19qcuUAj1SGY+LR6eIbuaVqW1IT8bGunQKRGCP0jHExRxkLFL2/+ZJfHcMvKDoVe1vMbCBFJMkcM0E/U6wOhXN4I/kk1ODXu2PiO8Ob7Yb17gkoS0us0lwyQuZgg+5gr3mBl9UNV/ReCHs+6k1MKPXno/vDbN4kFzy9UqSwetv+/CuKslmUAeLulkgb67BP7spa6vfQEo2jTcQ0Zu1MyhiPdPH0lzF1fZ9Vc/mSoDfu3Bjm8i0JhTDpoSph2l0OED1GQUsQIdL/OkJAGm2ak084x4sxYa/90nkUdSuNBs5dJjlVlI/ni7YjnuX73iC8JhHq6Q7JFeCkuUs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR03MB4973.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(366004)(39850400004)(136003)(396003)(376002)(451199015)(54906003)(186003)(6486002)(83380400001)(86362001)(31696002)(38350700002)(2616005)(38100700002)(5660300002)(7416002)(2906002)(44832011)(4326008)(6666004)(8936002)(41300700001)(6512007)(66476007)(6506007)(478600001)(66946007)(52116002)(316002)(53546011)(966005)(66556008)(110136005)(8676002)(31686004)(26005)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QXBRYmFNVGd6R3lSajhRVHRTbDI0S0dMa1lLbTZTenBOMXdQeWwrekxiRFJj?=
 =?utf-8?B?NGVHRDI4Nlc2R3lJT1IyeEFST2d4WTNPUElGdHRWOXlMMTNCM3NNZzdoOUlY?=
 =?utf-8?B?WHE4RlpBdnF6RFBwcjUxNmVzQ3Y4VE52amRzWDdPenJsYlMxbVA2YjBoVmxH?=
 =?utf-8?B?VkpWbFZNRVR3TWNNMG02cFVoZnJ4RU9wOVBxTk9yd282cnN3TWUvdXNHSm5S?=
 =?utf-8?B?K0xZbk5GREJod1dGYWxkMm1Oa3N6QWZ5bndybkUzbk4vYjV4VE9QeFlhbkFi?=
 =?utf-8?B?eVNKUVp4bEZIN1YvRU5XVk5zMXpUeFE5eG1NUXZzY3FFL3F3TmFCQUZEcTlo?=
 =?utf-8?B?bHRGa0pOYmNiaHEyd2N5MUZLSTczNmh0VnMybnE3NmpUUXcySTlvSlo1c1dZ?=
 =?utf-8?B?M001b0Q0MnVRQWp6cUF4OVpTT1Jjakx1ZDRROGhIeVp0WHk3Tm11UjE1VExz?=
 =?utf-8?B?OE5aMjdueFo4WEt1a3pxMXlJaG5DR2pVbFBIOTdPQ216WlAvNU9zNGhDdHdO?=
 =?utf-8?B?NWx1eVUzRENlbEZnaWpOaVpMSldoallrOWV0Vlg2b0Z6VkI5RzFIWDhDSEFU?=
 =?utf-8?B?aWM0dTlHTzFpRG1Uc3kyQjFGRFVSemZxeU9kR0ZUMzBIV0lRZHRhTi9iUHoz?=
 =?utf-8?B?bUdTOXVVMEFRTHh3RnNQSWVCNzhYMGIwZEsxSGE0NjJyRlpaTmVDb000NE9W?=
 =?utf-8?B?SE1MMzhaSk95bUN4M0FtU09iQjFZRW5UODJsM0lDRXFFcTByMjMzVXlhVnNJ?=
 =?utf-8?B?dk44YnFzcnQ1eXU1dFRhSjl2dnJIWjlSTnVUMlhDeVBiaFdldWhSclpkdFk2?=
 =?utf-8?B?QXdhVHFaTmJzRW9mNGVycUZnYlM5ejQ5SzRmazk2VEpUNmpVS01JUHN3Umhy?=
 =?utf-8?B?NDhwSk9XdUVHcHU2RWlSVTFQUVlHNmVKSmE0ZElId0hFdUF2Ym5qbCs3RDda?=
 =?utf-8?B?Mlpob3lYN0lLc0VNZUFuazY5UjZDMlZ0QlFkZ2dqN0RhT2VidFhWanozWkQy?=
 =?utf-8?B?bjZCTmRpakwyekJmdHNyWFNQemFvUjluVUdJdThvZzJKNHlNVVNJL3JUU0k4?=
 =?utf-8?B?RFFpY0Z2cFg5akJwZ1VTdHczUmZjcVhtM2c4S09idWZONGJiMG1CK2xPUUwy?=
 =?utf-8?B?blNEMm9objV6ZFZYaEkyL05wbml0dnlLV3NBZGl0ZWVXa3IxVkREQm5idzlW?=
 =?utf-8?B?WWNpb21wdEwrWmZIMG83SEI0TjQ3VlZlSDBwNFljbkxHUGgvb0drdVdzSkxw?=
 =?utf-8?B?T1crYlhPWUlmQ0lYa0M1eTZBUW5Tb2hCd1VDdzZqM3NKN05pL1NxKzJ5YnQv?=
 =?utf-8?B?ZHM5YWtFZG5BRHhvV2h4dDVWQWFNN3M1eUhIajBiK2NlcThvQXNuanM3NlVX?=
 =?utf-8?B?akt2dE41Ti9ITks5Uk04SUdXNVcvNy9KSDdwMkxuQllqRkhsdzVmRFZjTFcv?=
 =?utf-8?B?Vm96M2ZVUkJiV2lHYXVwVnRLQTFwei9XN3l4c2QzTmFDMG9GTEw2aVBsVVVh?=
 =?utf-8?B?QW1Za29kakJzRG15MnJzRFlnWmgzUE9sN0JRRTRhdlZpQlN4a054aWFEZFhm?=
 =?utf-8?B?L1k5dmhwRUdRbVBYSEwreGdSZmhRbkN6WklEZnNDcWM5WDZtSU14My9IcXdO?=
 =?utf-8?B?U2tyNmgrbTg1ZENZVFJtQW01bXp6NE1kVHJQZnpudzVSNW5RYXJPYThQbDBx?=
 =?utf-8?B?b1Q0SHQ1WmRrR1U0TVRld3VjSFBPRktMajJuSzRjYlNwcStEN3lZeWVuZXdQ?=
 =?utf-8?B?TC9INTRqSGJHUFh1bFlyTW5aWUpKb2N0N0c1V1RwYlpRU2JkZVliSHRkblBu?=
 =?utf-8?B?Tlh3UTZsTE9yZThjNytPbXZNMFF6dHpvRit4dkVaNFlzYVR4YWpCQXgvOGRp?=
 =?utf-8?B?cng2NlRKRUJBOHpkOW9Kb3l1Vkp1ZVA0NTNIUllEMFlkRHExYThERDdJWFpo?=
 =?utf-8?B?cGRqSUd3SHM1MHpubVNqVUVqZHo2eDhoTXZFSjQxZVJkSnF1aWVUL3NzS2xK?=
 =?utf-8?B?aXJMSkdKVlFZYnFzRHppaG5PRjNKU1Y2bXNRdzNFWnJsSXlhMXpvSVNLK3NN?=
 =?utf-8?B?R2g5MStiT3FSYXVqWFc1ZWhSQnFWdVRBWUdvc29INHQvZWpTYms2YVhCdyt4?=
 =?utf-8?B?V0t2V09tYUptQWllUGZEaUVRcE5HT0ZmU29ia2FodTJtTW9wS3RLZkJSRXhH?=
 =?utf-8?B?Y1E9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3fe6f2fb-d786-42d2-aeb0-08dab1525942
X-MS-Exchange-CrossTenant-AuthSource: VI1PR03MB4973.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2022 21:47:27.0885
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MSarxgjaKzfgoGKHDUWuWwBrBlHPyue5uWqGvF8IbhFbEFbKraqsn5x+M9GGN1K7OSu9EPlIScTkFeqfwVWXwg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR03MB8463
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/18/22 5:39 PM, Andrew Lunn wrote:
> On Tue, Oct 18, 2022 at 01:33:55PM -0500, Andrew Davis wrote:
>> On 10/18/22 12:37 PM, Sean Anderson wrote:
>> > Hi Andrew,
>> > 
>> > On 10/18/22 1:22 PM, Andrew Lunn wrote:
>> > > On Mon, Oct 17, 2022 at 12:28:06PM -0400, Sean Anderson wrote:
>> > > > For whatever reason, the address of the MAC is exposed to userspace in
>> > > > several places. We need to use the physical address for this purpose to
>> > > > avoid leaking information about the kernel's memory layout, and to keep
>> > > > backwards compatibility.
>> > > 
>> > > How does this keep backwards compatibility? Whatever is in user space
>> > > using this virtual address expects a virtual address. If it now gets a
>> > > physical address it will probably do the wrong thing. Unless there is
>> > > a one to one mapping, and you are exposing virtual addresses anyway.
>> > > 
>> > > If you are going to break backwards compatibility Maybe it would be
>> > > better to return 0xdeadbeef? Or 0?
>> > > 
>> > >         Andrew
>> > > 
>> > 
>> > The fixed commit was added in v6.1-rc1 and switched from physical to
>> > virtual. So this is effectively a partial revert to the previous
>> > behavior (but keeping the other changes). See [1] for discussion.
> 
> Please don't assume a reviewer has seen the previous
> discussion. Include the background in the commit message to help such
> reviewers.
> 
>> > 
>> > --Sean
>> > 
>> > [1] https://lore.kernel.org/netdev/20220902215737.981341-1-sean.anderson@seco.com/T/#md5c6b66bc229c09062d205352a7d127c02b8d262
>> 
>> I see it asked in that thread, but not answered. Why are you exposing
>> "physical" addresses to userspace? There should be no reason for that.
> 
> I don't see anything about needing physical or virtual address in the
> discussion, or i've missed it.

Well, Madalin originally added this, so perhaps she has some insight.

I have no idea why we set the IFMAP stuff, since that seems like it's for
PCMCIA. Not sure about sysfs either. 

> If nobody knows why it is needed, either use an obfusticated value, or
> remove it all together. If somebody/something does need it, they will
> report the regression.

I'd rather apply this (or v2 of this) and then remove the "feature" in
follow-up.

--Sean
