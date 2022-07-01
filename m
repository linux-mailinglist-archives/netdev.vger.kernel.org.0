Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D06B56373B
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 17:51:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231547AbiGAPvl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 11:51:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230090AbiGAPvj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 11:51:39 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80054.outbound.protection.outlook.com [40.107.8.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A92B012D01;
        Fri,  1 Jul 2022 08:51:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eLKy0/SSmV/Eei8HzUZL0SkO1fBJA7+v0MJxW2nLZPO1VVJTOe/NMnrszhYWZXhX3g1AH77c1WpgvWmzwoislLG9+HDA3G3uRZxej1tT8upKgYOfJof2OiqZhlyFk2Bt3p9JFdY3Bbn9HOZM6P7bAkRKgL1SZ9d03h6Uu7HPfkvFFmYZRd0mLzHnw7niWiIsLk3DsRLgiNGqv45f4ufn2844qme4bJ7ZMgbj23FpojtTLJ8X/c8yejp/r+peGSpbBRGz0F4bN8v1hsKYQDtJPq0p6LXuXANMzIbjOp+LP6NYtSKdmJR6JTkx+6tEtCbYgGgYhwxiJP6HTn73f0xR9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9CRgMzr4MALScryW32p3s9CLgODyqVGZaxwd/z6EhPA=;
 b=XGECQPlhZb5L4lng9pANuAntQpEfmq8ZQi65JZM3rtq8xkGMEOXyfs4DWkoFt3pvHI0OLdDGnz86ndYxvfWCNIO8yWDmRWdof4I+4zhBU6xPjMX2vCiQUDHcBcchOFtP25HcAl4GfK+0D65k5xCXgYqXugDmsa1kvRw4/qXQvKUPYw4HJKM+cxoFyMzH/wxGLW76vAlNDvKIp3PmU0k7kDCRu6IVgDM5NtfhLteiqqFV6iX0gvi6DvuUMkdkeb41ihZ9+eyiEyu6BMBGYpSArm9uZ5x8e2exxxSh7zGWS6tI/+CaHg+/X2Sx72ZeU5V4vaL5I0gJGPU8eAP8txBkVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9CRgMzr4MALScryW32p3s9CLgODyqVGZaxwd/z6EhPA=;
 b=OVShXfO7XhJjwgShFCkcco8KXlVdSovTw3rh7sbxZ7uYzb95tOd/VEMbDcfl3kpUwJHuZX7+Q+ORsVK0QhMHW95xlDuDDZxrQp4e0pTuItb9N8h5dsFHy7ajK1IfdNlPNWVRum3gvbwDv94hb8uIiyJt+qV9LCLi3zSO5INphjaDOW1+JZzAlI0BpQfW7+e6xt4CVwNg+gfSlh3eKr4TTaPTmmt1wortDwJa73MTNhV1A9382BCRbHkQKnv0lohD2U8RHU4qqr5zThX+qBuIDG3gXv3v8EHXw3lvHechQfA9LE0WdsrCs9JMoHg/ITyAGpxQGxdvVl7XWVrnWvIAbg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AM0PR03MB5060.eurprd03.prod.outlook.com (2603:10a6:208:102::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.15; Fri, 1 Jul
 2022 15:51:33 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1%6]) with mapi id 15.20.5395.015; Fri, 1 Jul 2022
 15:51:33 +0000
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
From:   Sean Anderson <sean.anderson@seco.com>
Message-ID: <00a7292c-4752-50e9-87e7-09e1435c2b56@seco.com>
Date:   Fri, 1 Jul 2022 11:51:28 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20220701100313.qjiwfqirnw2pgjqi@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR15CA0035.namprd15.prod.outlook.com
 (2603:10b6:208:1b4::48) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3bf21035-f872-471b-dcce-08da5b79926f
X-MS-TrafficTypeDiagnostic: AM0PR03MB5060:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: R5V/xD4yImcsgcYc0aUHcohiQQLnweoggPV5iflbbdJtP7LWmmZ4+wj8z5iCNahD4zr9ewNBifCpw5DMXxT6conD5heewiH/+71Q1WwsqidrSGnhHII/e0KKtvBiYWmsMAcJtsfC+r2uNAi6ePGcbC27OHlVa3oI3mJtg4ULxRo2wrMriSumulGf8GrVQpzUy2Hsa5O+wIGli0sgUKQD/jhyZKoGPbhSnmaUyvz5fZSZItei895uvXRJuoIxMtlDT4bqiavMUiY5qeaZpLjJkwtruhMN28xUcgHbrVzXLf1Xncwl/imFS0w4ePpTNFjauWhWDkBxlW1evlER87+gvUknQ6UpP99RocfUOgFuFvxdyHD83MFT1xbGt66ooRSuPMepRRv4jQ4KndjvZ3PsmJwhv0ERHxvEj8WMi4bJsIJBkF56x2rIZQKJFoXr3eupb2O0UIcXrqYYE+5FGPGHWfybNJH1bvCPN5jLwFRfkuGCOeHcD37/N4/J2gVNZMYO36I5vjNKZdpwoNhZMYgptitZTTiCiuGqT42w/1xMtMJEHhRp5rqr75cMQdYT8OWLfGPRh+K6EMukj022nhPpCy7dAtVpuThj4aOj8zPFcJix6s7wUnZHOCJYfnB/yWI5w17nYTZmHyK9UsdTl8EZY73u7krxz6bxXaMVXOEsZxfGV1aNak4nbDyacGu2WIt2Ehi2WUJnh5pjoktXf8kiVoDw2Nb4XMHPD8T2XfV5tIyoUxmAYkZoXyLaKwsIO0XhMB41wKhnJCNqRkueOhIQdd26pOyrXY35AsdV/qG+YLGEQQIqXvlWnLsc8UqILNr/UtggLLIlBST1p9E4yw/nzCGtyGIEjuLmSW8UBySgPs2EOJXqhddZKifI1iPjSFSKy6J6p8zk09aH5Bhrk5/Nkw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(39850400004)(136003)(396003)(366004)(346002)(83380400001)(54906003)(6916009)(36756003)(86362001)(2906002)(7416002)(31696002)(5660300002)(31686004)(26005)(8936002)(44832011)(66946007)(316002)(38350700002)(66476007)(4326008)(38100700002)(66556008)(966005)(8676002)(6666004)(6506007)(478600001)(2616005)(6512007)(41300700001)(186003)(6486002)(53546011)(52116002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?clVBYjV2ZU1Yb3V1ZUMya01ZT2l5c0Q0MWJ4TG54eWtMajVwVStWLzJ2Nitz?=
 =?utf-8?B?Z2FNdlNYNHJOZkVhN2lwNytDNllEOUU5eU1yRjZJNE9aTDlyZFNnU1VxMTdm?=
 =?utf-8?B?bkZ6blhoaGYxZkJvK1pvRFJtYlRleEp2c2xpemtxZWV2U0ZzY0hESWRwOStS?=
 =?utf-8?B?RFJycCtZcjdaUmovNnRHbUF6MXgwdGhsTEJQdG9WcmlQOEIwR0h6em9rOEF0?=
 =?utf-8?B?d2d0YUIzTnRQV1lnYXp5MjJzZVBocGtaQWNHUE1sa1pVQlBZeTA5bDBVWG5k?=
 =?utf-8?B?eDdLa2U0K0g2czgvVWxQQXJiUGsxUU5BZ3JxOUw4bEZNSTRXWndlM1krRStY?=
 =?utf-8?B?R2xibEJHbEtxeERPbDRLQ2tzd3dFUXgrQ0ZMaG01RUx5MDVwODJPbEE5OUZY?=
 =?utf-8?B?YjladFRKL24rZDVhQ1VseThsWnRybW4rZE45TG1GUUtIMTdrbXlqT2hBL0Vl?=
 =?utf-8?B?d0dwanRMeW1PUGN0ZWp2M1UwYlZ0N1pyNk1zOHJhNWV0KzhiWlphbnAwc01F?=
 =?utf-8?B?S3UwQTRYRFR4VmNYZUVPbVpMTzlDWlJDS0NkZTV3MzI0UGhuKytOZHZHM2Zi?=
 =?utf-8?B?OW9XUlZxWURsRW13elp2SXVON0pXK01YZDBYZDhub0VuM0ZIVnN0SlBKSVhU?=
 =?utf-8?B?NGJZb2VWMTJHOVhVUHJkSEFUNE1rbzlnakV4QmIxZDJjeWZBTFJNSmE5SzUx?=
 =?utf-8?B?Um82K295TXhBK0FXTXd2elNlU1pPUGwzMGd0ZmpWT0Z1R2dqeHBnYm9qanBl?=
 =?utf-8?B?eUo2YjhPUWh0eU5JTUdMd2NHS2JqZmZHNnVwODJQYW8zRGtnRWxmbC94dkVU?=
 =?utf-8?B?MEx6ZDhoeWhjenYyaGVmZlY3Sk04NWNMbThNblZUWUxVN2pSVmNwQjZBT1dE?=
 =?utf-8?B?aHhRQUZNbjVSekhSQUhTQzlkTCtDcmt3bUs0TnQwOUlkMUFNLzNCaXozdytO?=
 =?utf-8?B?S0crdVJ4MWVlQjNFS2EzeTNHOStDaHMvNUROalBCKytuYzUrdDVtT1QrUzVE?=
 =?utf-8?B?WmtPOVdxZ2NTOGhYZ3JoclZVQU1OWGs2VDU4UlEwdzl0Rmh4MXBOZlQ0cWs5?=
 =?utf-8?B?aTl6eTl2aUJlOVl4dCtEc3l5K2JTTmpDcmEzWmxQQXZRUjJEU0ZRMVZVQU1W?=
 =?utf-8?B?cEluellRaHd2RXJ1dVhmc2YzbHBUVDltbnh3dTNUbHJ0L1k2Vzk5TGZtcDVV?=
 =?utf-8?B?MnJ2N0g4cjJhUWRBODZsSW9LMFdUUUhqRzB4eTlzeWt1V1ZEUnpIOFFXQ2JI?=
 =?utf-8?B?UzIrdTBiVFVFNE5qUWw0czhKbVh3b3VYckhyU2hJa0xGWW9FTDVnL2dFL3Fm?=
 =?utf-8?B?MWhzV0Fza1loaGpIWHhGcUl5TEM3SXhZckxCSGRxWlgweHo0ams4WlZxU1pm?=
 =?utf-8?B?MHBHMW1vOTRyQzNxZFpaOVhzUkNWUDE2UkpTbitTcEQzR0orV2JXMGcySGhT?=
 =?utf-8?B?S2ZxR3ZLa3VSNkhaSW9CRmtnQnJBRnh1U3AydFJXZ1c1dS9GaUUvNW85OCs2?=
 =?utf-8?B?SnJBR0tSN2ZIWGk4QURyeXcwd09qTTcrT2VPNzJ4NzNHa3k2NWpMckFmUUlY?=
 =?utf-8?B?ZmxwWmFWYk42T1BnKzRWQlZEMnVkc1hnVTYybXNaTGpxWjBRdU5BWW5sNFY4?=
 =?utf-8?B?c0JGWU9UcEV3RE8zSlo0a0d4bVhlc3MxQ2d3dnFicllTVjd4U3gwa0E3Q2hm?=
 =?utf-8?B?OHNDYVB2ZVJFREJaS1RhWDVwait3ZVRxWTNEdGRSRCt6MGxtdGN0elVlT2w5?=
 =?utf-8?B?Nk84NjJMd1lWcmZuRkpIbnFRa0lUVU82ZkdPc242OFVTdGZOMDJKYTVvd1hp?=
 =?utf-8?B?YWIxQyttQ0pVZVp4YkdRYlpnRzJscHFFNkw2TkpZaDc3bGIwbjZMVEpXRXZv?=
 =?utf-8?B?UW9yMDJOMHlIaUdIZFlBd2FjSzZFRzlrTXJEencwRUd0ck4xbXgvUmJHNk5K?=
 =?utf-8?B?bGZTTXBlMXVvSys3YVFyNW5lVHpLS2tLNURDSEJjbFZnbVM1QmVvTS9zcEI1?=
 =?utf-8?B?NFJybmdGc2M0UVM4aFYzRi9IUG9vR2c4ZmVtVlpsN29tWDlMZ0pMTFVGYWFF?=
 =?utf-8?B?QkJ0SjhHbEtzS3J5NXppYUVjQnlwQmxIL3hrRS9xbUR6YXpxNmVYLy9hcVNC?=
 =?utf-8?B?TElySkk1ZEUrZ3Z3aHhna25TZmxTbXk5RlYzYjFMb1BueVp5WHNXYUNqVWxi?=
 =?utf-8?B?OGc9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bf21035-f872-471b-dcce-08da5b79926f
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2022 15:51:33.4040
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3HT8Dorv33+XFcJlx7/AXR8EDrBYRqJWyD+x2/xEsl2dZ7L936NIDqCl6TwL02QJQ6gdmTGz/RnyXko04u2I9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR03MB5060
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ioana,

On 7/1/22 6:03 AM, Ioana Ciornei wrote:
> On Thu, Jun 30, 2022 at 02:11:17PM -0400, Sean Anderson wrote:
>> 
>> 
>> On 6/30/22 11:56 AM, Ioana Ciornei wrote:
>> > 
>> > Hi Sean,
>> > 
>> > I am in the process of adding the necessary configuration for this
>> > driver to work on a LS1088A based board. At the moment, I can see that
>> > the lane's PLL is changed depending on the SFP module plugged, I have a
>> > CDR lock but no PCS link.
>> 
>> I have a LS1088A board which I can test on.
> 
> If it's a LS1088ARDB one, you have to bypass / disable the retimer which
> is between the SerDes lane and the SFP cage. I have some i2cset commands
> which do this, let me know if you need them.

I'd appreciate that.

> By the way, I think the LS1046ARDB also has a retimer. What are you
> doing with that when you switch to an SFP module (SGMII/1000Base-X)?

I haven't tested that so far... In fact, I'd forgotten about that retimer.
Perhaps it can be modeled as an additional "phy". Although according to
the datasheet,

> Each channel of the DS110DF111 will, by default operate at 10.3125 Gbps
> and 1.25 Gbps

so it seems like it shouldn't need reconfiguration to switch between SGMII
and XFI.

>> >> +There is an additional set of configuration for SerDes2, which supports a
>> >> +different set of modes. Both configurations should be added to the match
>> >> +table::
>> >> +
>> >> +    { .compatible = "fsl,ls1046-serdes-1", .data = &ls1046a_conf1 },
>> >> +    { .compatible = "fsl,ls1046-serdes-2", .data = &ls1046a_conf2 },
>> > 
>> > I am not 100% sure that different compatible strings are needed for each
>> > SerDes block. I know that in the 'supported SerDes options' tables only
>> > a certain list of combinations are present, different for each block.
>> > Even with this, I find it odd to believe that, for example, SerDes block
>> > 2 from LS1046A was instantiated so that it does not support any Ethernet
>> > protocols.
>> 
>> As it happens, it does support SGMII on lane B, but it mainly supports
>> SATA/PCIe.
>> 
>> If you happen to have some additional info about the internal structure of
>> the SerDes, I'd be very interested. However, as far as I can tell from the
>> public documentation the protocols supported are different for each SerDes
>> on each SoC.
>> 
>> E.g. the LS1043A has a completely different set of supported protocols on its SerDes.
> 
> Yes, between the SoCs there are differences and having SoC specific
> compatible helps there.
> 
> What I am not sure of is if there are different instantiations of the
> SerDes in the same SoC. Will let you know when I find out more myself.
> 
>> >> +
>> >> +#define PROTO_MASK(proto) BIT(LYNX_PROTO_##proto)
>> >> +#define UNSUPPORTED_PROTOS (PROTO_MASK(SATA) | PROTO_MASK(PCIE))
>> > 
>> > From what I know, -KX and -KR need software level link training.
>> 
>> There was no mention of that in the datasheet, but I suspect that's
>> a PCS issue.
> 
> 
> No, not just the PCS is involved in the backplane (-KR, -KX) link
> training.
> Depending on the what the link partner requests, the pre- and post-tap
> coefficients (the TECR0 register) need to be changed. Those default
> values presented in the RM may well work in some situations, but not all
> of them. They are usually just used as a starting point for the link
> training algorithm which will try to get the link to an optimal point.
> 
> Here is an application note which describes in more details what I just
> said: https://www.nxp.com/docs/en/application-note/AN12572.pdf

Well the linked repo [1] certainly is interesting, as it contains around 1/3
of a general phy driver. To support KX/KR it definitely seems like some kind
of iterative process is necessary, probably using phy_configure. Such a process
is most naturally driven using the PCS... it might make sense to reference the
SerDes from the PCS node instead of the MAC. E.g.

	mdio@e9000 {
		#address-cells = <1>;
		#size-cells = <0>;
		compatible = "fsl,fman-memac-mdio", "fsl,fman-xmdio";
		reg = <0xe7000 0x1000>;

		pcsphy4: ethernet-phy@0 {
			reg = <0x0>;
			phys = <&serdes1 1>;
		};
	};

This of course would be easier with a more normal probing process.

That said, I do agree with you that KX/KR would probably not function as-is.

[1] https://source.codeaurora.org/external/qoriq/qoriq-components/linux-extras/

>> > Am I understanding correctly that if you encounter a protocol which is
>> > not supported (PCIe, SATA) both PLLs will not be capable of changing,
>> > right?
>> 
>> Correct.
>> 
>> > Why aren't you just getting exclusivity on the PLL that is actually used
>> > by a lane configured with a protocol which the driver does not support?
>> 
>> PCIe will automatically switch between PLLs in order to switch speeds. So
>> we can't change either, because the currently-used PLL could change at any
>> time. SATA doesn't have this restriction. Its rates have power-of-two
>> relationships with each other, so it can just change the divider. However,
>> I've chosen to get things exclusively in both cases for simplicity.
> 
> Oh, ok. I didn't know that PCIe does this automatic switchover between
> PLLs. Thanks!
> 
>> 
>> >> +			} else {
>> >> +				/* Otherwise, clear out the existing config */
>> >> +				pccr = lynx_proto_mode_prep(mode, pccr,
>> >> +							    LYNX_PROTO_NONE);
>> >> +				lynx_write(serdes, pccr, PCCRn(mode->pccr));
>> >> +			}
>> > 
>> > Hmmm, do you need this?
>> > 
>> > Wouldn't it be better to just leave the lane untouched (as it was setup
>> > by the RCW) just in case the lane is not requested by a consumer driver
>> > but actually used in practice. I am referring to the case in which some
>> > ethernet nodes have the 'phys' property, some don't.
>> 
>> The reason why I do this is to make sure that no other protocols are selected.
>> We only clear out the protocol configuration registers for a protocol that we've
>> configured (e.g when we go from SGMII to XFI we clear out the SGMII register).
>> But if the RCW e.g. configured QSGMII, we need to disable it because otherwise we
>> will accidentally leave it enabled.
>> 
>> > If you really need this, maybe you can move it in the phy_init callback.
>> 
>> That's fine by me.
>> 
>> >> +
>> >> +			/* Disable the SGMII PCS until we're ready for it */
>> >> +			if (mode->protos & LYNX_PROTO_SGMII) {
>> >> +				u32 cr1;
>> >> +
>> >> +				cr1 = lynx_read(serdes, SGMIIaCR1(mode->idx));
>> >> +				cr1 &= ~SGMIIaCR1_SGPCS_EN;
>> >> +				lynx_write(serdes, cr1, SGMIIaCR1(mode->idx));
>> >> +			}
>> >> +		}
>> >> +	}
>> >> +
>> >> +	/* Power off all lanes; used ones will be powered on later */
>> >> +	for (i = 0; i < conf->lanes; i++)
>> >> +		lynx_power_off_lane(serdes, i);
>> > 
>> > This means that you are powering-off any lane, PCIe/SATA lanes
>> > which are not integrated with this driver at all, right?.
>> > I don't think we want to break stuff that used to be working.
>> 
>> You're right. This should really check used_lanes first.
>> 
> 
> I am not sure if the used_lanes indication will cover the case in which
> just some, for example, SGMII lanes have a 'phys' property pointing to
> them but not all of them.

This is why I've disabled the SerDes by default. Boards which enable it
will need to ensure that all the Ethernet interfaces have had their phys
property added.

> Again, powering off the lane can be done in the phy_init.

Not if no one ever uses the lane. Unlike the clock subsystem, unused phys
are not automatically powered off. We could of course wait until sometime
after probe, but doing it now is easiest.

--Sean
