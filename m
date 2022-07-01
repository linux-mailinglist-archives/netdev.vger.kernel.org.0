Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCCC5563B7B
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 23:15:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231518AbiGAVEe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 17:04:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229911AbiGAVEc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 17:04:32 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2063.outbound.protection.outlook.com [40.107.21.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0D71433BC;
        Fri,  1 Jul 2022 14:04:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mfc9HLcfSdpCKi5AS/OSHeA1UYKLB7I79UmWzALXzDL65rJ+ThgnzEBPSpcbNwKnRiyf7QAkdaiz7KHohN+uV2Tx+nQf6ygUWYg6yR19kBiNDERtGpIqN4pJuXb8jJerO5kuGrOBuBjsGCA8g9v0cQKbNjgi+jvuNS3Z4GZ0Hg4dRa0p7oquD+tjWvbyxf5Qwu4qXGvvlrda1kbKf+tGYjm0V/AWyQJI4fvI7UZaeia9bjde4BBozD5qzA2ohNAvOCk8Wu9fA0IGpX1sdXmS/pVpSxaARZeE+z7ofHhfHqNDOIEh9coE3HYG/C0sfakv5cdfMc0gH53W7LvpaE7mVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z01NnFIGIf/pgBSQF9KnqouCLdIBOdjKbLIVcQ3I2eA=;
 b=cQQqxkwLSpD48M3CXzcIbpFDU53ZjjEPj3qHL15uj8NEjUoqAVRtf7Wa3suSnVii3N96RGFwFqYuR2UB0IyEgS5vIyKo9x1eKDqH1KC6QatY5Vm2OAD/19nJK5Pc+yZusW/luI12rMhYYyKMWL6nL6g7IoFbSMVFcmfDv0DM28w/jf2UTCKGDyRDAVxy4XtQGpxcGekapeQYt9rPlItgassQcTuRibNwx25qDvmdvquk2Vo7ddR86nxhUmgvQJax/JsbSULZslwUDlcG3fM071U+wqMXKp0bIyzB7c9qTagzAHGMxvX/MOlb+Yl7NuGNuY/+VPGV3ynvURG07pHx+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z01NnFIGIf/pgBSQF9KnqouCLdIBOdjKbLIVcQ3I2eA=;
 b=tR8miTiTJ7KMRp+3FMQDPtXVW+Qz7XG/T2+IzDOARBxSXbkJHO0Xo7Mhh1VechhqVBmg6knwK3u/GG0eyD1Oi1FQCteREUQeTXebOHUc7wuXLxhewZGV2TOCFxPBChEUB8x1kqg4LmllQMyxufnFD8e6YtW0B96ZIU49d5g7Y3dZCi3RR/H9R2hOzu+MphTNaVcsTq5cpbpAQZaIZbQhef/MWqFjjtGuUS0OCsWyEsuflP4TEVQluNvYv9JhIh+JEkUD3I7FsE1I69hF7xkQDxbeqBx17vLPNJACdUBoOp04ZHJg4Ys8KGiFYBVP1007RVQqO5CkKBVYDyvRFnClhA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AM5PR03MB3044.eurprd03.prod.outlook.com (2603:10a6:206:18::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.15; Fri, 1 Jul
 2022 21:04:26 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1%6]) with mapi id 15.20.5395.015; Fri, 1 Jul 2022
 21:04:26 +0000
From:   Sean Anderson <sean.anderson@seco.com>
Subject: Re: [PATCH net-next v2 04/35] [RFC] phy: fsl: Add Lynx 10G SerDes
 driver
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Eric Dumazet <edumazet@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Vinod Koul <vkoul@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-phy@lists.infradead.org" <linux-phy@lists.infradead.org>
References: <20220628221404.1444200-1-sean.anderson@seco.com>
 <20220628221404.1444200-5-sean.anderson@seco.com>
 <20220630155657.wa2z45z25s4e74m4@skbuf>
 <0ed86fb5-4d26-4fb2-8867-adf9df1eea2a@seco.com>
 <20220701100313.qjiwfqirnw2pgjqi@skbuf>
 <343faa45-4e4a-7a7f-b0c3-fcc9db89e976@seco.com>
Message-ID: <58658d8d-f5c5-2dc3-c178-6450c2962955@seco.com>
Date:   Fri, 1 Jul 2022 17:04:21 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <343faa45-4e4a-7a7f-b0c3-fcc9db89e976@seco.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BLAP220CA0023.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:32c::28) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2bb6634f-3ece-464a-e4b8-08da5ba54833
X-MS-TrafficTypeDiagnostic: AM5PR03MB3044:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SDC5Mw0dHbS9ZzrMIzMb3yXpnj9D4aBnxqlJx1IPIU/FKmMvC5Uk+2Bd6VYv7qzV0Q0cIBVmFqGkev+lbB4xu8Q1GR9y3IooLe7BvVHEN8pLFyf82dAZIWE7fDr4+TgL8X5VCHsnNhLuk8lHTwZcXKrxyZlgXlph8gO/7A1/gseYmkSjljkQJJxrOijnoIf4ZwmdmsT20ix6ZkTRzaOD5QaRf3KfksAEgnkrTKTKHo59hlv8pB5UL0B4bTWqoVm70m5R3l9AyA4i7GIk1eWGHHY+i8JHLMn1E6eh9CsxgducQpqNX1KTku7TJdixz7YXWGRJ0oFKBTMMYHBHk6B2BMcnaczLVVz4FyO3quB6cMtnK5TavMAtuouwJADm54WAcfLmJ5NXAJhRsNDuWSL5Vtov+i1HeIeXs3oPCmE9UlsQI7Q6F8UNnIzQ5A2mBFGHQi+L/HJlQ1HBVWXfZuPfC7u9MoUqCKG7G/5RFylyPQbNcdd8BKSje5XiULn2UxAMDFtlZjIECJDWjhfvwM0LBOT6nUtArLOf87I9dC2+DGCiViv+vEsmGWC9z5b4TruD3pUqqg2HjghFXyIdwCFdtZI0nr/HLQUo5mEdJTu7nSxhngOt9esAQY5df5ArEj33SC5z3CNXNYxU1krFCcCJv/5wGUITm042yLIx9aOY5BGFJXmJQYIm9s2wFDKGTbL9mwMHB7shZ4YBKUSHiJuoMpir/1dTGNunCBqTJ5GFHOqvG4HlHwql6ePHYWo8bSQGlW0rCjG3dY0AoT4KykoLJBMavBJ5y+PlUdtwT3jyy5SggTSHfx+8RFti7BoOzqOhpvpPhN7KI4Rc3jVSfLONS40evHzEb3e3CQKAPCnnBbiKzGQMRt6KDbnYLqGwA+ZT2Jxy20dlIU1T4oO7gQxeKQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(366004)(136003)(396003)(346002)(39850400004)(83380400001)(52116002)(54906003)(8936002)(36756003)(6916009)(5660300002)(44832011)(31686004)(86362001)(31696002)(7416002)(2906002)(478600001)(38100700002)(6512007)(38350700002)(316002)(4326008)(8676002)(66946007)(66556008)(66476007)(6666004)(6506007)(41300700001)(966005)(26005)(2616005)(186003)(6486002)(53546011)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RTBpYnVaeHRxYytuM2hQdm00WWp6cS8xcTdLTlIzaEw5TXpKOUViaFJ1N1Q5?=
 =?utf-8?B?Zm1INkVPT1BsK3NPZG80Q0ZOVDJIdnplUkdtYlV0R1A4czZ6QVA4RVBxNTI4?=
 =?utf-8?B?VXJSdThIS2gxN3FjMjViY3JYaW0rZExnN2tiamF6c2U5MEJwTEFWQ1ZEYnBz?=
 =?utf-8?B?MllOVVRZRzVYTXBVc0pYaHJEWFdiTDRzTmRWbks1VThkRDB3Skp0NWRiTzd3?=
 =?utf-8?B?S2RleUJrWnN4SGUwNUJrcWR6a0tOaERIVUFkeHBMWFdJVVI2TzZVRUxDZlcy?=
 =?utf-8?B?M1pCVG52U1lhTGJ3RGNlVnNYNytqTGNxUlJ4TmdrVkZGRi94b2NQTGJOR2Yw?=
 =?utf-8?B?eDYrMTdpSjhCWHFTUW1qeTBnTmMzZ1VnbmR6dTdVSE1senMrQWxwTHRadzdF?=
 =?utf-8?B?UHo2dU11dk1QSVRFb05kOWdmV1p1d0p6aUZDaEQ3cEE4NGV4LzhZRk9sS3Mv?=
 =?utf-8?B?c1Uzdlc2N2Faa2JMTHRmV2JNRFdmQWdCeTdvT3RpNFp2dmtFWjF1ZFpTd1dR?=
 =?utf-8?B?dWlHWDlyNzd5TDJmWEx2UUU5bmk0RmhiNDJ4Rkk5ZUZsWk5mejRTWVFWWWRD?=
 =?utf-8?B?KytzeEZDWVU2bXdjN3gvL1psVWMrMHZoSmlrdEpDd2szNjFTMWtxVFhFblBh?=
 =?utf-8?B?RU5BUDFOTUEydmJpQ3N2RzdZelJBTk9aRFJIMmxjcXpwZHRYWXQyeGF0ak03?=
 =?utf-8?B?NWRuT0dXNWtsaEd0dU5VSVBFc3pNa0YxNHlia2YwRjhTSS9yUVBTc3pFYmo1?=
 =?utf-8?B?WFdrd2lWS1AzazBsUndsY0lEWDVnOWRIVHJES3R2YXYwTEdnd1poWGJDQ2dx?=
 =?utf-8?B?d0VGL1ZkemdHVjFlQkY3Qnl0WkVtL0x1WFpWTFJPM25FbGJ2eGVnOGtjZ1dW?=
 =?utf-8?B?UXBIVUZ4Vml6N3BHTXN2aDJHSmIwdmtFSHE4SFZQbUl2MHZoQUFKaFgvbUhs?=
 =?utf-8?B?eE10OWpqWVlIdm1ZUU9rK0NzM1ljSlRpdllGZnZHZUFadkRlT0hVemtNeWpG?=
 =?utf-8?B?VW9QSHhDMUtGTFZpZUNqQjU3cmtoMHpCUHVzcU5yVEtOeFljWDd1ZjdXWVA0?=
 =?utf-8?B?RFJJOVFPNkNQYzlneVNpU1lGQ1lNcHh5M09xVW1EaWxOQ2ZPQnJzN3FNNmFB?=
 =?utf-8?B?Qm4yUDN1QWlwUi93cjVMZ3BPVENISUVKNkZRT25mK2tFaWhpTGthSHBoeU9M?=
 =?utf-8?B?ZEFzYlhXdU00RWFiaVVUc3dlYlNjeFFCY0V3WUlSU25YNkM4R3drb3B2dnBj?=
 =?utf-8?B?M0cyZllZWjFxdTNHWUdJNmovb01uajNRdHJxN2lpajRxczhCTk5tYXFCcnIy?=
 =?utf-8?B?T1ZBZkpPZ09RY1M5VG91dFIxcUtlUEVyejUydVJLbVVNSzFxRHhMbVRIYWdP?=
 =?utf-8?B?dGJydWlsVzhhQzdMSGZicUtnWUVFV1NhVyt5ckFQOEZWcWZVUEpacFc2WDBG?=
 =?utf-8?B?dC96MzBweGsyVm1RZy9rQThlUHhpck52eUxEMWZzSzdXVWhLYmtRVVM3eDJ6?=
 =?utf-8?B?VG9UOW5pUUpkdHJZU2puenJCd09sWll1ZkNFSDNpdHp3YUM5bkxrM2xwNWR5?=
 =?utf-8?B?bngwbXlmOE42MUxuSWNwUmFKcTgrNXBPcmdLTUN6MDZqeUJRUEIrWUVpd3VD?=
 =?utf-8?B?endKSVJ6YlMzVlBCS2NkZmdrUXFXdDA4emlhQ3RWUVNreUs0WnFUZXZvQTky?=
 =?utf-8?B?MVFRUXZEZ3hvNmtLbFFTMGJuZG15dkhoZ3lKb1ZOaUN6UHplM0VZSTdNc0k0?=
 =?utf-8?B?Vm1XTlhOV0dFOXFtVzh3eSsxS2M2NmMvamZwVVBZNEI3VEZNSmxPb2RIVS9Z?=
 =?utf-8?B?Z3JlcVNUZFJnUk01RHlwTWxSWGlEZ1RXNjFDc2xNV05sM2FHc0d1a1o4OGJt?=
 =?utf-8?B?b3BpNjZLK2wyS0hCcTBlV21RUWYyV1VVaHNDTUhHUm1KL1lncy9lMFExODlm?=
 =?utf-8?B?VGFQUVlZTkZXS2FtY0tvbmFjODFIMnJMbWxXOWJqQ0F2eTFicDFKNFY2eE44?=
 =?utf-8?B?cGJqclkvNWI1SW8rTDU5Sk5ETGIwaGo5MXNLTFBsbXYzb2ZWclZqQ3hkN3Jr?=
 =?utf-8?B?OThxeGJ4SDlCSmdSOE9JaHJxcGN4VzZKYzdvdnhOZmxwNE15TnErREJxeUFC?=
 =?utf-8?B?eTVZVjg2SStuZVdjQURPZDI2QUhNTVoxb21md29LQzNiVGVIa3h1K0ZIVUZ0?=
 =?utf-8?B?S3c9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2bb6634f-3ece-464a-e4b8-08da5ba54833
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2022 21:04:26.7000
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ycSCINycdItNvs1T7DATvKMexZjsZF6+OWUPqSlbEmKzuzb0OhMBKXqGUg/DYlyf+XzyVTAPneP4sXva7+IBjw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR03MB3044
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Just some follow-ups to my earlier email:

On 7/1/22 11:50 AM, Sean Anderson wrote:
> Hi Ioana,
> 
> On 7/1/22 6:03 AM, Ioana Ciornei wrote:
>> On Thu, Jun 30, 2022 at 02:11:17PM -0400, Sean Anderson wrote:
>>> 
>>> 
>>> On 6/30/22 11:56 AM, Ioana Ciornei wrote:
>>> > 
>>> > Hi Sean,
>>> > 
>>> > I am in the process of adding the necessary configuration for this
>>> > driver to work on a LS1088A based board. At the moment, I can see that
>>> > the lane's PLL is changed depending on the SFP module plugged, I have a
>>> > CDR lock but no PCS link.
>>> 
>>> I have a LS1088A board which I can test on.
>> 
>> If it's a LS1088ARDB one, you have to bypass / disable the retimer which
>> is between the SerDes lane and the SFP cage. I have some i2cset commands
>> which do this, let me know if you need them.
> 
> I'd appreciate that.
> 
>> By the way, I think the LS1046ARDB also has a retimer. What are you
>> doing with that when you switch to an SFP module (SGMII/1000Base-X)?
> 
> I haven't tested that so far... In fact, I'd forgotten about that retimer.
> Perhaps it can be modeled as an additional "phy". Although according to
> the datasheet,
> 
>> Each channel of the DS110DF111 will, by default operate at 10.3125 Gbps
>> and 1.25 Gbps
> 
> so it seems like it shouldn't need reconfiguration to switch between SGMII
> and XFI.

I tested this, and the SFP module works for both SGMII and XFI.

>>> >> +There is an additional set of configuration for SerDes2, which supports a
>>> >> +different set of modes. Both configurations should be added to the match
>>> >> +table::
>>> >> +
>>> >> +    { .compatible = "fsl,ls1046-serdes-1", .data = &ls1046a_conf1 },
>>> >> +    { .compatible = "fsl,ls1046-serdes-2", .data = &ls1046a_conf2 },
>>> > 
>>> > I am not 100% sure that different compatible strings are needed for each
>>> > SerDes block. I know that in the 'supported SerDes options' tables only
>>> > a certain list of combinations are present, different for each block.
>>> > Even with this, I find it odd to believe that, for example, SerDes block
>>> > 2 from LS1046A was instantiated so that it does not support any Ethernet
>>> > protocols.
>>> 
>>> As it happens, it does support SGMII on lane B, but it mainly supports
>>> SATA/PCIe.
>>> 
>>> If you happen to have some additional info about the internal structure of
>>> the SerDes, I'd be very interested. However, as far as I can tell from the
>>> public documentation the protocols supported are different for each SerDes
>>> on each SoC.
>>> 
>>> E.g. the LS1043A has a completely different set of supported protocols on its SerDes.
>> 
>> Yes, between the SoCs there are differences and having SoC specific
>> compatible helps there.
>> 
>> What I am not sure of is if there are different instantiations of the
>> SerDes in the same SoC. Will let you know when I find out more myself.

I don't think there are any major register layout differences between
SerDes on the same SoC; the differences are mainly in protocol support.
For example, consider the T4240. It has 4 SerDes -- two "networking" and
two "non-networking". The "networking" SerDes mostly support the same
protocols (except SerDes2 supports XFI on lanes A-D). Similarly, the
"non-networking" SerDes both support PCIe and SRIO, but SerDes3 supports
Interlaken, and SerDes2 supports Aurora and SATA. There are also several
pages of additional restrictions which I haven't fully read through.

Now, that's not to say that you couldn't use one set of configuration
for all four SerDes. You'd mainly lose the ability to determine which
protocols were valid. This is of course important for things like SFP
slots: XFI is available on some lanes but not others, and if the
networking layer doesn't figure that out it can silently fail to work.
It's also nice to get some kind of error message if you select the wrong
lane.

>>> >> +
>>> >> +#define PROTO_MASK(proto) BIT(LYNX_PROTO_##proto)
>>> >> +#define UNSUPPORTED_PROTOS (PROTO_MASK(SATA) | PROTO_MASK(PCIE))
>>> > 
>>> > From what I know, -KX and -KR need software level link training.
>>> 
>>> There was no mention of that in the datasheet, but I suspect that's
>>> a PCS issue.
>> 
>> 
>> No, not just the PCS is involved in the backplane (-KR, -KX) link
>> training.
>> Depending on the what the link partner requests, the pre- and post-tap
>> coefficients (the TECR0 register) need to be changed. Those default
>> values presented in the RM may well work in some situations, but not all
>> of them. They are usually just used as a starting point for the link
>> training algorithm which will try to get the link to an optimal point.
>> 
>> Here is an application note which describes in more details what I just
>> said: https://www.nxp.com/docs/en/application-note/AN12572.pdf
> 
> Well the linked repo [1] certainly is interesting, as it contains around 1/3
> of a general phy driver. To support KX/KR it definitely seems like some kind
> of iterative process is necessary, probably using phy_configure. Such a process
> is most naturally driven using the PCS... it might make sense to reference the
> SerDes from the PCS node. E.g.
> 
> 	mdio@e9000 {
> 		#address-cells = <1>;
> 		#size-cells = <0>;
> 		compatible = "fsl,fman-memac-mdio", "fsl,fman-xmdio";
> 		reg = <0xe7000 0x1000>;
> 
> 		pcsphy4: ethernet-phy@0 {
> 			reg = <0x0>;
> 			phys = <&serdes1 1>;
> 		};
> 	};
> 
> This of course would be easier with a more normal probing process.
> 
> That said, I do agree with you that KX/KR would probably not function as-is.

I had a longer look at that driver, and while KR would probably not
work, the KX portions seem like they would work as-is.

The other thing is that UNSUPPORTED_PROTOS is really supposed to hold
protocols which used to work and which we don't know how to manage.
AFAICT, KR/KX always required a downstream Linux (e.g. they were never
configured just using the RCW). So it should be fine to keep these as
is, perhaps with some comments or warnings. Ultimately, the PCS doesn't
support these modes, so they will not normally be selected.

> [1] https://source.codeaurora.org/external/qoriq/qoriq-components/linux-extras/
> 
>>> > Am I understanding correctly that if you encounter a protocol which is
>>> > not supported (PCIe, SATA) both PLLs will not be capable of changing,
>>> > right?
>>> 
>>> Correct.
>>> 
>>> > Why aren't you just getting exclusivity on the PLL that is actually used
>>> > by a lane configured with a protocol which the driver does not support?
>>> 
>>> PCIe will automatically switch between PLLs in order to switch speeds. So
>>> we can't change either, because the currently-used PLL could change at any
>>> time. SATA doesn't have this restriction. Its rates have power-of-two
>>> relationships with each other, so it can just change the divider. However,
>>> I've chosen to get things exclusively in both cases for simplicity.
>> 
>> Oh, ok. I didn't know that PCIe does this automatic switchover between
>> PLLs. Thanks!

A small correction: Apparently in some circumstances the PCIe controller
can reconfigure an existing PLL to switch. I'm not sure exactly how this
is configured.

>>> 
>>> >> +			} else {
>>> >> +				/* Otherwise, clear out the existing config */
>>> >> +				pccr = lynx_proto_mode_prep(mode, pccr,
>>> >> +							    LYNX_PROTO_NONE);
>>> >> +				lynx_write(serdes, pccr, PCCRn(mode->pccr));
>>> >> +			}
>>> > 
>>> > Hmmm, do you need this?
>>> > 
>>> > Wouldn't it be better to just leave the lane untouched (as it was setup
>>> > by the RCW) just in case the lane is not requested by a consumer driver
>>> > but actually used in practice. I am referring to the case in which some
>>> > ethernet nodes have the 'phys' property, some don't.
>>> 
>>> The reason why I do this is to make sure that no other protocols are selected.
>>> We only clear out the protocol configuration registers for a protocol that we've
>>> configured (e.g when we go from SGMII to XFI we clear out the SGMII register).
>>> But if the RCW e.g. configured QSGMII, we need to disable it because otherwise we
>>> will accidentally leave it enabled.
>>> 
>>> > If you really need this, maybe you can move it in the phy_init callback.
>>> 
>>> That's fine by me.
>>> 
>>> >> +
>>> >> +			/* Disable the SGMII PCS until we're ready for it */
>>> >> +			if (mode->protos & LYNX_PROTO_SGMII) {
>>> >> +				u32 cr1;
>>> >> +
>>> >> +				cr1 = lynx_read(serdes, SGMIIaCR1(mode->idx));
>>> >> +				cr1 &= ~SGMIIaCR1_SGPCS_EN;
>>> >> +				lynx_write(serdes, cr1, SGMIIaCR1(mode->idx));
>>> >> +			}
>>> >> +		}
>>> >> +	}
>>> >> +
>>> >> +	/* Power off all lanes; used ones will be powered on later */
>>> >> +	for (i = 0; i < conf->lanes; i++)
>>> >> +		lynx_power_off_lane(serdes, i);
>>> > 
>>> > This means that you are powering-off any lane, PCIe/SATA lanes
>>> > which are not integrated with this driver at all, right?.
>>> > I don't think we want to break stuff that used to be working.
>>> 
>>> You're right. This should really check used_lanes first.
>>> 
>> 
>> I am not sure if the used_lanes indication will cover the case in which
>> just some, for example, SGMII lanes have a 'phys' property pointing to
>> them but not all of them.
> 
> This is why I've disabled the SerDes by default. Boards which enable it
> will need to ensure that all the Ethernet interfaces have had their phys
> property added.
> 
>> Again, powering off the lane can be done in the phy_init.
> 
> Not if no one ever uses the lane. Unlike the clock subsystem, unused phys
> are not automatically powered off. We could of course wait until sometime
> after probe, but doing it now is easiest.
> 
> --S
> 
