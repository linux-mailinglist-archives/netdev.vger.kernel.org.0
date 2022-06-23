Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4B2D558B4D
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 00:39:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229977AbiFWWjT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 18:39:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbiFWWjS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 18:39:18 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70074.outbound.protection.outlook.com [40.107.7.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ED02517DE;
        Thu, 23 Jun 2022 15:39:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kI7pJBUDuQaeyWA8H951eFqAUeA7r/RHfYcBqTLOF30OuXYjs2mjJum4qa0zxakj3W5PX4k150hVtMjNxybtG0muR+blmxFeStwZeKZ4N86VuConhuwrNTp0/pvsk2eyePTkk0A1TUTUUH85f8ZTtfAddPNXJ8Ha3EP4KmMtAxZZ9FinL7WRlm2DejHfwPMEal8JEhRfZDI+8BMNDXziA4DL5w1RJM7QQnc5kv4l11L4NcLHSmPLwbWedOWpYTQYBOf+ry9jw2oIICVYP7sE4LcgS1TOm8+fG7X2cQgVEmTG2D6r47aTligRTbqtgASM5c1bZQNMySxqYpTc3U1lKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mgd7gNbiWgpBxgwWaGZ7bZapGSfTMEf2tKlNTZQAI7Y=;
 b=cMoSmgFMvaBzBOJ5PKjYZXv2HunUVXgCSMeC04m6/8Ee0BXyJ5CveSl41RDrDlS7cxURmseS8/okwfv7zMuPqfIeMvoAT3ErZG8NKk8QmYoK5QDPKp2RntB5q+bEbpfWmVNAiAh+9XEJEIPxRogDC4Eh0w9ZcMBRst1IYoMrwzJDLhIdUL3MO7PutFIL1QAMYf9pVvy9LrVvH1rmxbocuivQkn54dx0yIpR4onH7TOS0FepB7QSVJ2PKwXcbW1BRkK62g0jrir9nlxxg9UP3SBpacZqNKfkFXVk3vwENm8Y3g0/qvDlzMJxXdgNJfByPLUkreDsJ44AZBSk2I0nKUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mgd7gNbiWgpBxgwWaGZ7bZapGSfTMEf2tKlNTZQAI7Y=;
 b=tSYDKCfSAziqtinHyCRZFZX8hJ1paxatTHuHvngScBjyXa+KHBF7QdLkyY+k1uh+fW1+TBpX2y3oJsScDHiasr5cE152Uy+4yMXsgy9HuB6qz1tIUs+uT1mCoQ+RD5eBn7axHS/MPVsspjQSoOj8uaOec7NKBb5eYv1sAtUso/uHO4mXidjg4sYSztPiBzmwU22Yr6LHD3I9DzijL7godOELxkQx8pJ6kJ64StuNyA9W2s+oJvF9IXmO13AN7U2zFrNiG+Ygxfpcx2hHPCUnaLSE6H/000RQ29EaiFkCkWpVSJtnHec/aiVYMfDney3bhatM/CGJXXQq0liPvC8yVA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AM6PR03MB5830.eurprd03.prod.outlook.com (2603:10a6:20b:e8::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.17; Thu, 23 Jun
 2022 22:39:13 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1%6]) with mapi id 15.20.5353.022; Thu, 23 Jun 2022
 22:39:13 +0000
Subject: Re: [PATCH net-next 25/28] [RFC] net: dpaa: Convert to phylink
From:   Sean Anderson <sean.anderson@seco.com>
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
 <84c2aaaf-6efb-f170-e6d3-76774f3fa98a@seco.com>
Message-ID: <8becaec4-6dc3-8a45-081a-1a1e8e5f9a45@seco.com>
Date:   Thu, 23 Jun 2022 18:39:08 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <84c2aaaf-6efb-f170-e6d3-76774f3fa98a@seco.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR19CA0060.namprd19.prod.outlook.com
 (2603:10b6:208:19b::37) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 121bfe2f-9864-400f-3db9-08da5569325f
X-MS-TrafficTypeDiagnostic: AM6PR03MB5830:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Gv+aalcDYsenAAnyRDUHcMsP23VTf5nHJ9fI239I5M3N7B5iZJai1yjEf+kQBfVwSAfVNWVXEggfbz0mdOrbduHzIxVSNsMwZxo/rvRe4OyMohzuYbJ0KtTIyc5BBjLc7A7G83Pk4FiTmme2womECpTnK9yk8z9WnMBLIYfdvvi0ArfODo3DPsK4dkrq52/0hHiSo0ZC89Ap7byv78Fw4Y4FhSFBCo6OTq/MIAMEaae00yxVpSGVz0eE8+bPZvsuFEfs2njIkRkCXSz0qrtBvzhPtKIJIX8hU7//12Nj8D3k8/kwU4VR7MBCvfEDSV+2wZLECF3W8h+Na/raBFPy3+fXmCqZdh9Y++bH0KEyXeDOUIUn3tMhSDCU/ztRHcMViMJIJvsl5cws3eaCRR+VK670S39Lxv4S4fA3929adQFdSBkM6hpwd+VZ7jItQLZb5T8DczSYcWWQ9CIYq2ZTJFLXEOCn5a2tRchZurgRwIng5MVF4xV+VdGbWLzvu8JhZWyzTYoOzfWzwKjUKOcTOckzOSa0nXUgGrMMvYOByGq98FE2LofIH42+rKY0L+JOzMnidP3/hSX0UCIkr7wM7yMZfb0n0zwv1gzA+E+6cSC2M221et/UYUGO/zqinRqu3idLqqkqSLT9vilZEEFOoxVCELlC+El8UidkYkzPWVOrL2zngwMUbLMjeaDBpsXIBfAp7zfCypDhHKE0PzO6ALHA3aiUa1Yw38r0V7lK8rHCnqKmSpa5VA1HtejTQJNTC0nzXYaqblUyewpW+U8UmFuKYOK0xLxOnIecsmMOvXdHH/23ihIEAAJaQx+df/yZgyNo0hk5Mmy+bZgRQZE0BRSHsoQSB96YSxHPd+V2djo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39850400004)(366004)(396003)(376002)(346002)(136003)(52116002)(86362001)(31696002)(478600001)(4326008)(6512007)(26005)(53546011)(6486002)(6506007)(316002)(6666004)(54906003)(6916009)(66476007)(66556008)(8676002)(83380400001)(66946007)(186003)(2616005)(41300700001)(38350700002)(5660300002)(36756003)(38100700002)(44832011)(8936002)(2906002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bEE5SHc1QThtWkpyK3l3SUpwOVBndnVIU2JvM0FSNWh2VUhhcEoyYlVCblNk?=
 =?utf-8?B?V1dPMmpGcTN6aTdjbWtSeStJR3V3Qi9STnBZYVRjZTRXVFBOaUxzZVAvMVAr?=
 =?utf-8?B?MitqaDlZUjRUM0NFR0l6YjZpMEI3SGJwUWs2bXJOenNCMG82ZUEyMWVlaWZR?=
 =?utf-8?B?dlFRaFNVY1BVMlRlN2pyY25RaVcxVVNwTnhJeUFWbHRjT0lWMU1aVlZOblc3?=
 =?utf-8?B?N2o2SUVZREIxK1lUMGh6SW0ybFlVK2JTM3BVWThDaUYvZFUwckdYZERreHY1?=
 =?utf-8?B?dzM2RGxCa2lIb1pPQmdwaFZBZVoxYUkwa3RPM3J0dmhlUkhzVGdUTkRhQTJp?=
 =?utf-8?B?eUVNaWtzSk5FY0NzMDJkMlIzTDNGKzROQWJObkwwSVVmY1dRbWV6c2swaXBR?=
 =?utf-8?B?cmVFUWxaNGhFeU0zdlM4dWorVWNkc1E4U0h5aWpmTC80S0RXejlsYjZaMGFD?=
 =?utf-8?B?SWdTb2RtQ3hlOGNJUlF4QjFESTEzODlsdTdPZHB5RktBdCs4M1YzamtmdDN6?=
 =?utf-8?B?SVNEL2NVbXBlWjR1Z01RUWtUdTN2dWhZV2kyN3BURy9NeGNvS0xtK09ZYS94?=
 =?utf-8?B?MFZLYk1UWlE1cWZpNUNrM0owdHF1WVVyeUxwUy9GbTJxWjdoaTdYRyttRHp1?=
 =?utf-8?B?eVJxUTRuV05TNFFhaTRTMFlwcWlQSmNGWWhUVndaNEJ1SnJVMUUvM0xBT0Ro?=
 =?utf-8?B?SU1OaU40a3FHMFRLeXlNQ29XUHJhQWRVM1o1ZE41UGdGUVBPTXR0UjVsRWFh?=
 =?utf-8?B?QTg3dVVZNzJYTUlRS0NJUXp1NmRDWXdELzJjMWVDc1VPWFVyY2E5RnlsTXRp?=
 =?utf-8?B?UDJZMVVCZGhoUFd5SUsxby9NOXMxN2FtSDR2NVNOWFQ4QnR2bC9Xc2xaajI5?=
 =?utf-8?B?WGh6RXBMK3BDV2l1aDVUTU9BdDVKK21PUWVPcEZteGM4QUdPNHZNdGI5bWlW?=
 =?utf-8?B?aGd3NEZJaXRkS3Q4Q3k3UEdxREs5a1ZCMGNYaThDTmRmNDJ4L2ZnSjM1UmMv?=
 =?utf-8?B?cFRMaWVGZEY3b1gyaWVLN0l3ZGxwL3Erc3NDUzhPayswMU0xR1BTZGs1K0Zl?=
 =?utf-8?B?MlpYdHFYd1AxYlBhUmxaL3N5akNPSGEzYUNWYVdyN29IV2RQYnVDNDdXNGRX?=
 =?utf-8?B?bDB2bFVTdzhacGhNTFMxT200TC96bkhUWHpKdW1EMEVsNmdUaHIvc0JqM0dk?=
 =?utf-8?B?WjBudGtubmFHSEt0SDRHZXpaUkRSS2NZeFg0dlUwYWlSeTBhRU55NDU0cjln?=
 =?utf-8?B?NG1KL2t4RjMvR1lmdldlS0NIbmp3dXY4TzFoQlJXZFJXT21sNHpGdXE0YUxa?=
 =?utf-8?B?ZGNhZzd2d3ZZZ2ZlMW5pK3FSWjRPVERXSDZaWjkvTDBLRUJkWmxvMXliZGQz?=
 =?utf-8?B?Z2NwajA2NmhjRjhnVmhHZVBZODhaeE9NdCtaREFLWGFRZ1Z0bm5aNUdaMC9s?=
 =?utf-8?B?U3licE1FUzZKL1YxWU8vTCszUVFKYUdjbjhudXlia3dsbElMWThGYy9raWhh?=
 =?utf-8?B?MFhSRXl2MlY2dzUxVk80QjFJczREcUsvUmhNUGZYeTdQSXlXV1ppS24xc2lj?=
 =?utf-8?B?OHhrbDV3SVpXWUY3UGZXdW40OGZScHIrUVYzOEtpb3R1L3F5VGZRUjJwZUZD?=
 =?utf-8?B?andiUCsyVHlOcEhyRWFLK0NPeFdPYzhrMHV0MEx6K3JjeDdzN2hIbDcxTGY0?=
 =?utf-8?B?Zm9OMG1MOTdTSlNsK1BwdGpiL1lObnlHYUJ6WVQ2S3NCcmFWV0ZZNTlpbDRL?=
 =?utf-8?B?NGxpQnVUVDFDcVgwVUJDbjZJU0YwV1dRM1NacDgvWkZQS2tLVzNoMXo3c3J6?=
 =?utf-8?B?ZDEwSWpvbUptdkg2ZDJvb1I1NDd3WHpPVld0MHpkRlJXQmJGcElHamVFVzcw?=
 =?utf-8?B?SElWRU9NTURCQXhzcVhJR2M2amdEenlCcnhSSUc5Vjh0L2xQNjg4Q3dPQ2lq?=
 =?utf-8?B?WklFNTR1bWl3Q1VmcUVzUUNQd2dNY1dZd1hjYTZWZk00dGdiUzl6dWk3STFh?=
 =?utf-8?B?OGNxbXZWYVVjR1hsVUtQSGFYZzVKOWRvUU5WVUVRK25WYVBBNG9EQk0yMUdF?=
 =?utf-8?B?a0FPZHQvTkVNYWNZR2txRFpLd2J1TFpEcFhaK1Zkc0prSlgrMXJ5OFBYYm9B?=
 =?utf-8?B?Wm5Ka2FFUW5TbmpXWFQrTWk3L2lyREI5L1UzQS9NSzIydDB0NEtMdW9iVXFu?=
 =?utf-8?B?aTZGK0xRTGV4UkUvK0FvLzBwOU9MNmNoeFJ1YXU0R1EyWXQwRG5CQUZ0Ty81?=
 =?utf-8?B?RDlGZUxRbVBGeWhhcUplRGRsQmFwaFVIRjJQT3BzM3kvVmhjaVJKNk14MC8y?=
 =?utf-8?B?UzloT0xtbXhNYVVGbFVIa3kwR0k5WllLcUVOVWN2SkY2QmcreFFyM25KaFFX?=
 =?utf-8?Q?emFUmHXqUzP5KHfA=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 121bfe2f-9864-400f-3db9-08da5569325f
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2022 22:39:13.2469
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OiHo9bNpT8u1zUolmZwDF9HOIdSIuXeT3x7krSfqU3y2jhr9T13JjPPy6qQ9P1ExmNYNXqTn3T7K5O+nnflITQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR03MB5830
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

On 6/18/22 11:58 AM, Sean Anderson wrote:
> Hi Russell,
> 
> On 6/18/22 4:22 AM, Russell King (Oracle) wrote:
>> On Fri, Jun 17, 2022 at 08:45:38PM -0400, Sean Anderson wrote:
>>> Hi Russell,
>>>
>>> Thanks for the quick response.
>>> ...
>>> Yes, I've been using the debug prints in phylink extensively as part of
>>> debugging :)
>>>
>>> In this case, I added a debug statement to phylink_resolve printing out
>>> cur_link_state, link_state.link, and pl->phy_state.link. I could see that
>>> the phy link state was up and the mac (pcs) state was down. By inspecting
>>> the PCS's registers, I determined that this was because AN had not completed
>>> (in particular, the link was up in BMSR). I believe that forcing in-band-status
>>> (by setting ovr_an_inband) shouldn't be necessary, but I was unable to get a link
>>> up on any interface without it. In particular, the pre-phylink implementation
>>> disabled PCS AN only for fixed links (which you can see in patch 23).
>>
>> I notice that prior to patch 23, the advertisment register was set to
>> 0x4001, but in phylink_mii_c22_pcs_encode_advertisement() we set it to
>> 0x0001 (bit 14 being the acknowledge bit from the PCS to the PHY, which
>> is normally managed by hardware.
>>
>> It may be worth testing whether setting bit 14 changes the behaviour.
> 
> Thanks for the tip. I'll try that out on Monday.

Well, I was playing around with this some more, and I found that I could enable
it if I set one of the 10G lanes to SGMII. Not sure what's going on there. It's
possible one of the lanes is mismatched, but I'm still looking into it.

---

How is rate adaptation in the phy supposed to work? One of the 10G interfaces on
the RDB is hooked up to an AQR113 which can adapt rates below 10G to XFI using
pause frames. This is nice and all, but the problem is that phylink_get_linkmodes
sees that we're using PHY_INTERFACE_MODE_10GKR and doesn't add any of the lower
link speeds (just MAC_10000). This results in ethtool output of

Settings for eth6:
	Supported ports: [  ]
	Supported link modes:   10000baseT/Full
	                        10000baseKX4/Full
	                        10000baseKR/Full
	Supported pause frame use: Symmetric Receive-only
	Supports auto-negotiation: Yes
	Supported FEC modes: Not reported
	Advertised link modes:  10000baseT/Full
	                        10000baseKX4/Full
	                        10000baseKR/Full
	Advertised pause frame use: Symmetric Receive-only
	Advertised auto-negotiation: Yes
	Advertised FEC modes: Not reported
	Link partner advertised link modes:  10baseT/Half 10baseT/Full
	                                     100baseT/Half 100baseT/Full
	Link partner advertised pause frame use: Symmetric
	Link partner advertised auto-negotiation: Yes
	Link partner advertised FEC modes: Not reported
	Speed: Unknown!
	Duplex: Unknown! (255)
	Auto-negotiation: on
	Port: MII
	PHYAD: 0
	Transceiver: external
        Current message level: 0x00002037 (8247)
                               drv probe link ifdown ifup hw
	Link detected: yes

The speed and duplex are "Unknown!" because the negotiated link mode (100Base-TX)
doesn't intersect with the advertised link modes (10000Base-T etc). This is
currently using genphy; does there need to be driver support for this sort of thing?
Should the correct speed even be reported here? The MAC and PCS still need to be
configured for XFI.

Another problem is that the rate adaptation is supposed to happen with pause frames.
Unfortunately, pause frames are disabled:

Pause parameters for eth6:
Autonegotiate:	on
RX:		off
TX:		off
RX negotiated: on
TX negotiated: on

Maybe this is because phylink_mii_c45_pcs_get_state doesn't check for pause modes?
The far end link partner of course doesn't necessarily support pause frames. I tried
this with managed = "phy" and "in-band-status" and it didn't seem to make a difference.

--Sean
