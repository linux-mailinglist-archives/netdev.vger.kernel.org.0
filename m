Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FC9D6E300E
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 11:19:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229886AbjDOJTx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Apr 2023 05:19:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbjDOJTw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Apr 2023 05:19:52 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on20600.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe1a::600])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6654949F5;
        Sat, 15 Apr 2023 02:19:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bOTmARFK5H5ne9wqX2+63UdL0BHO1w4E8dHXKUYhDco0DsvmIBly4GF03kVER0f64FOQ5BwwwdKHp+Y4bUSWCRZta03Y8q6CH/CWv4x+CyhkyOWxEQ1rNoqDhuaTlR3nSAIOSsYRTao/lDi1YDpX7nYUexnbAxYXAL8PYWEpaR+Uj+4jAIi+ZD1NWBH2RcEo36oqGYmP2NOSm2+xgoaCzegPcJBmPyh+SEQLX13hTkmcvpMza3OoD2HiaX3Zou+XmdPOCho55rGY4eQTxVczIkGPQZkqZaLCyMVdSN26XpGfcvLoHwAXa+6NYd3TUv6c2YsG2t0nrlIAquQWcUWdQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=94/WLQC1iwlfxCwpll6F2i8MquJ3C6OUPCoQR8ci/i4=;
 b=jndIM2nx4qrUXYulV5x0F7YHKewaXR/A1jOmNggBJb0s/VLPmRWiJh0vjSv7N+Na962WiLePwSmC1DGXXtv9Ee6jprOc15c1KYuw0p/uOll5fDfUY1J1gA+eetdiVoEwHUUsP32aDsqkEvRlEFNnusRbSyH09Le3tsBulx2UETk9My/gnFrvrO8KFZ5PCqKfNFkVvQS07DtgOMql471igif/f3zF8wPuNuQerEPJ+85yCtSR7+zivUFSC3bXHZg4/bNwBj7oo7mScoc694oyduaMg1ayEi6mg4u0jsTizpvnD9LejnBy2GKkOpoVTMWqDZH8sU5CaUrCkxCLv7y/aA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=siemens.com; dmarc=pass action=none header.from=siemens.com;
 dkim=pass header.d=siemens.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=siemens.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=94/WLQC1iwlfxCwpll6F2i8MquJ3C6OUPCoQR8ci/i4=;
 b=sst+UAvYUsx3I19ElcAl19f/F214Se6+4H08yxI24AD9VZQ/OEBfOyqvDWL1A78yppYQUjwdaWo9q28g8teGLDVhgxVtGkS9xIL8CJQUeJvleLcjDkWvLtPBpsVza79oi7Z0mf5LiiPwgOBg9rn7NRYr/Li7XGcMIgZF656YQmRQP8dqgouwRT3btL48gux7iKa+NLA2UnWylw0rf6tPbu58gfMFFx6UP7wQiMFa46JT9Nf7oJTG+MsQUE709Q6Q9PAiIFutSBWn8wyufrpn9JKzMbwv/b3UFF2uY4BaKtuAbCaY6DHdIVDevquvwMofWmtwwMAtIoK0G+ofBLtPYA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=siemens.com;
Received: from PAXPR10MB5712.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:102:248::14)
 by PAVPR10MB7137.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:102:315::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Sat, 15 Apr
 2023 09:19:46 +0000
Received: from PAXPR10MB5712.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::3dcc:70a2:164e:ddd4]) by PAXPR10MB5712.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::3dcc:70a2:164e:ddd4%3]) with mapi id 15.20.6319.004; Sat, 15 Apr 2023
 09:19:46 +0000
Message-ID: <ffa2551d-ca04-3fe9-944a-0383e1d079e3@siemens.com>
Date:   Sat, 15 Apr 2023 11:19:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net v3 1/1] igc: read before write to SRRCTL register
Content-Language: en-US
To:     Song Yoong Siang <yoong.siang.song@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Vedang Patel <vedang.patel@intel.com>,
        Jithu Joseph <jithu.joseph@intel.com>,
        Andre Guedes <andre.guedes@intel.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Stanislav Fomichev <sdf@google.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        David Laight <David.Laight@ACULAB.COM>
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        xdp-hints@xdp-project.net, stable@vger.kernel.org
References: <20230414154902.2950535-1-yoong.siang.song@intel.com>
From:   Florian Bezdeka <florian.bezdeka@siemens.com>
In-Reply-To: <20230414154902.2950535-1-yoong.siang.song@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: VI1PR0601CA0024.eurprd06.prod.outlook.com
 (2603:10a6:800:1e::34) To PAXPR10MB5712.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:102:248::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXPR10MB5712:EE_|PAVPR10MB7137:EE_
X-MS-Office365-Filtering-Correlation-Id: a55ad259-bde7-4d13-949e-08db3d928e00
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kPZdiUaItGxTzDN7R1k7cqUdOqrKpZGLeeNAX4Z28w4IGXpYKyjBeXvYSU/jkwFCVcj/UICwptBuo4VJmWl4eIIuAI3VzhVwg5cvaqUo5QxoQaCVloomC2tZcWCdAYqee+F/5mBq2PY0VJw/pgfUt5eWraUSl0vCLnC0u79LtGoySwCd08AUx/OQ/o0wnyhY/jVG9d7VA4EIKXUoNOkjLCDBvt0ghy/vuu9pxSleqFhA5XMnAtk1CG6tc3WxGjYkT/4XhtECfTIaLiNpaf1A3HuR9nbK4NKWZUwmJaeVVTSb+VKJyAKBQYjinQNieXhqR2h/u1OQ+kdoaOw4JsvoqP5uZS3zrL2zcVMqBH0cAPYjT2A+kYjG3KK48pBC9NLojl74TiHxJN+ObJW15IEykKeXf9w4WXPdd1Kj//mdKU9MVgSqtr2snoLJbiM1sT1vUYtxWAN9D7CaRTF+ZVemHxZ3Xf1ynnTOJPjJyLk4p1u2cy9qK/coQt/yYP02zHK+QYvNCoT5GzDl+/t0A5Fb7jc9gWADD+cgZhjPNBtvfSTda4MsgtK++7y/Ml98EMIECm8fwaoyskZMzSK+aIhHgcHT7z/6CkGEHbdSRhiIs0quDPPRTyc4Wv8i7Af6c7Oc4/lsHNXX1hSZ3fw7zOvcNg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR10MB5712.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(396003)(346002)(136003)(376002)(366004)(451199021)(36756003)(83380400001)(31696002)(66476007)(316002)(86362001)(41300700001)(110136005)(66556008)(4326008)(478600001)(6486002)(8676002)(66946007)(921005)(5660300002)(186003)(4744005)(7416002)(8936002)(82960400001)(44832011)(2906002)(38100700002)(6512007)(53546011)(6506007)(2616005)(6666004)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TERUOVhtSXZzek42bGUxQVRLem12dUVzK29Yc1gyRXdzSkFYSzNjMi9BODI4?=
 =?utf-8?B?c2NNdkYzbzBoSUdjV2RYQ29qMERDYVBGZnM4RUdsYUZ1eC9IbDBHemMzRzBh?=
 =?utf-8?B?WktyVmpIcFBpZHV1UVByNVZTWk1VQzVqNFVoU1RYZlBmM0ZUZGkzanIwaFQ0?=
 =?utf-8?B?NVhRdk56cndaUXdIaVducjJmbjVHd2syM1ZNYXNFeC9BckVLaVFNNkNNQnY1?=
 =?utf-8?B?dGVEeUJzRXNNbWhCNEJMK0VieGMrdXBiNExDN2tUa2YwYS9RS1JiZXJoeGVs?=
 =?utf-8?B?dHRhNGdCYmMvMHFLY0ZXdy9LY3N5T2o4VWJBV3Ntd2xTYWF2RmpDb21UUTd6?=
 =?utf-8?B?NTFGcG9sbi8yV2k2ZlZiVUJkVHdXMC9OZ2N5OGJKUlpiS3llSisxc05JSTVM?=
 =?utf-8?B?R082cHpFcVRZdGNaR3B4dHZ5ZHhHeEd6V0lmeDNqUG16U0tuaWk2eEEwMlB0?=
 =?utf-8?B?d091dUxLUjcrK0cxbHFKY0hzU0RSN0R3MXJzd1cya0haZ253SFVZeCtrT1FC?=
 =?utf-8?B?V0FSVTVpZDJmUmg4Mko4VmVFMUJqdGx0TkZrNVlnSGo3SFovZURoWjI2RjJQ?=
 =?utf-8?B?WndXczhjWHh6UmJXcEh6akQvOFhKaUF0cllKcUhVOTg0WlRON1ovbjZxa3FF?=
 =?utf-8?B?ZVF3M3laWEJ6YjZpRHE4OWszTmgyeVZFc2IrZVhXcXBpNWREaUxJQ1dtNTVQ?=
 =?utf-8?B?b0p5cnJUWW5rYWJ0ek1KcTAvdDRhKzBBcFRsTDl4aEQ5SjgzMmR5eEoxL2lP?=
 =?utf-8?B?MHBxU1E0ZXJiTzJJMWVOeVhLbm02VHlRZzhmYWhkZE5GYnRTTHU5N29aclNH?=
 =?utf-8?B?Nzkza3BScWxmZzlWaFlJSEMxN3dxQ0dqaHV0SkNTRGczMkJLTjY4Z1dmWmth?=
 =?utf-8?B?aG9DRjdzZmc4dVdQWFdJa3ZIUUY3Uk5oeC8vYVY1djY1MEF3djJyRjVmYzNr?=
 =?utf-8?B?QzZMUnRQWGJrYy8xS0RmU3NPcDJDQTl0VHlMWUpWOSt0bFdSVjQ4NWoyM2lF?=
 =?utf-8?B?TCtHQTNpeHdiaFl6RlhrNTNWS2FFTU5pVFJySHN1YWU0V0NQTkxmTWt4SjVi?=
 =?utf-8?B?T3l1SE1PQ0I0c283Q0tQNU9mYm1HQ3VSMTNSSnUvc3djL25zcTRaVzJKWjRK?=
 =?utf-8?B?a0ROU2pmWlhSdU8yU2FZaHRGNUFGa2ZxKzBCY2YzUW00SmdQUGRNQ010Qml5?=
 =?utf-8?B?S2hBUEhBOWYzcmxaVmZKUVQxKzJQTXdQL2lNdEVkdi83WXpHWGpOeGo1WlBS?=
 =?utf-8?B?TFRUdThtWnR3czR0RWROLzZnQVM3bzd2WDMyb1BpZkpqaVVxTHlTUnBDK0ta?=
 =?utf-8?B?U1BCR2ZkVVFoQzN5eGJlU1FQTWJSbzhld0VVdi94bXNOVGQvd1UwU2lmcTdM?=
 =?utf-8?B?UGQ4ajRIL2Q1Vmdtbkt4U2R4VTlLcWRiNDVFb3lid3BNbDZpTThIQ2ZFdmxE?=
 =?utf-8?B?YzV6dEp4YUNrR2l1ZXg3RjFOYzR0emhtSWgyS0NZaWUySGNYMDNtUzFSaUhi?=
 =?utf-8?B?NjNXMllrK3kvQWovR1IrWWVwNVNzUVNaRS9sYS8rV29zU2JVbGV5VTd1aUJO?=
 =?utf-8?B?K21yYXpVaUxIWnRhYXBycWl3b1ROczJ2QndxN2svVEpMM0dFcitWdGZKUzl2?=
 =?utf-8?B?eHFIYkdCK1ZDdHFLV0dZVkYzV0djb291M0lLOC9pL3FlQjI2TSt4Q2ZiYWdT?=
 =?utf-8?B?b05lcjVFeE5rL2ZaOGdTb1dnTERzU1ZjSzRRUStmY2dyRWQrdVRXVVFRbjFB?=
 =?utf-8?B?WXZDd0t6S2Roa0tyYmJzN1VGK1RsQjZkdVhpSmI0Y0lCUW5YNGhjTkJneWFa?=
 =?utf-8?B?YkVYMHlYMFRJd2hVd29veFl1eEhnT1Y2YmNtMmlObmNsT2hVNHNPdXJDMVFh?=
 =?utf-8?B?RGEwZTVidlB3eUU1cmRrOFBsalh4bzNiaStYNWxqRDdlb0l1NSs0S3ovSmZn?=
 =?utf-8?B?dHkzekUrdjF3Yy9uQUVoQ0xoZjVXSmZDZkVGd1FZTjRsL0dIRGJOWFdQcTlU?=
 =?utf-8?B?Qk9EV25PbERrekNQbEVpNXJ5UEtLaHByK1FQYklNT0JVM3huVXE5Tlk1Q1c4?=
 =?utf-8?B?cGtHRU5MQ0NnRU1rN29TMXdkVGxiUHp2YkZrSllKSXAvMFVXa21HazFEemJt?=
 =?utf-8?B?b2RXakFMaEhSUS9PbExWMDJYMXIzeU5HbnJoclJCa21iNGcrS3QzeWRLYXU5?=
 =?utf-8?B?T2FqRUMxcU1wUFZnQkRVN0RNRnZpeng2cXhMQkZJZUd1MXdPZmZtNSs3WGdK?=
 =?utf-8?B?eWVTTk9raEpvMFJuT3pXeU9lTC93PT0=?=
X-OriginatorOrg: siemens.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a55ad259-bde7-4d13-949e-08db3d928e00
X-MS-Exchange-CrossTenant-AuthSource: PAXPR10MB5712.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2023 09:19:46.1775
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 38ae3bcd-9579-4fd4-adda-b42e1495d55a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KAxGCFQN/A1eL7scH4UG4uLnxcfkPjhXygVynoqYn1FNNCssF0afGTkZA9Bg3CJViX5TD68/zx1JrtASnCrLuNpINPdVc6s+9/qSQX2Zepo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAVPR10MB7137
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14.04.23 17:49, Song Yoong Siang wrote:
> igc_configure_rx_ring() function will be called as part of XDP program
> setup. If Rx hardware timestamp is enabled prio to XDP program setup,
> this timestamp enablement will be overwritten when buffer size is
> written into SRRCTL register.
> 

Hi all,

I'm actually searching for the root cause of a similar problem (RX
timestamp lost) that I can reproduce here, but the setup is slightly
different. The setup:

- igc driver
- i225/226 network card
- When starting to transmit frames using XDP with zero copy enabled
  another application (ptp4l) complains about missing RX timestamps
- Loading the XDP program has already been removed (not needed for
  TX only)
- ptp4l is using the traditional socket API
- The RX timestamps seem to come back once we stop sending frames
  using XDP

The "zero copy support" enabled part is important. If ZC support is not
requested everything works fine.

Any ideas?

Best regards,
Florian


