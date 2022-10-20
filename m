Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A69B9605D90
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 12:40:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230376AbiJTKkL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 06:40:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230393AbiJTKj6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 06:39:58 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2080.outbound.protection.outlook.com [40.107.220.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85815357FF;
        Thu, 20 Oct 2022 03:39:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CvLHDmzHs4bonijyrboHEtbwqL622GW3WCyf3ym6ZsdtBD6w2zoaeaoAmE7DxdxOeXjuBqtZqvUFFtj/HFtAaJI39okrRXkIXyNzF+k9DPq4TsMq5hRy6XRNAdE2yNRDeC0pdRTor/3KsUnXknSTooFeO3/SkCMLR+D2OQXDmoXCS4vt5BN3jqkX62ypJVNahKCKRvQQtIyqBivrgyqtU+VF4+kTwvw2FR2mGtDfyOl8smk+4+rvCzFwSn3SYqzRw7AUfXnbt8dtVtdWpBvp08UxD37EV6l9VkMtoGvOsv3Wa7WnnlOpfWKtc4EaRQM1DfTstP1MyHEvZBeMH7QJYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vI9SPgrHoBEe2M8FYt/Hm1ZPFHfK6STb3DzssSxGPW0=;
 b=bZg86kl0BhPhd70wV/XmfmTzre5gLFNcShWv5XOLz0DolHCjD0N9yHYucUvzsqLaOBimTDp5X/TZc7yEgtWnOe/5v7IrJQog6PM9C6Hi+bhG/GWUcnqcRrcnFNR9MfpTRQga7lhVWROGQ9GvGDhnO5PpaHxiT7EaScE08vTMTo68fyCRR743LHkWLJFN0VGFcB39rSr7U9Mhf4qvk+gQQwKlaaTa2e4GF7MkNfg7NseHssvuCTWd4hKM21xPDAmil4LWZYI0P1+mEzZJAkT/P/pDiDunHbmquXP04uU/yJcBK7z70xiVYKc8VYLzTbv3ssgaRiw6d1RdllvoCWSDwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=sifive.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vI9SPgrHoBEe2M8FYt/Hm1ZPFHfK6STb3DzssSxGPW0=;
 b=N26stKtnYDNwNeHgnxGE2250L9WUd4WmJGU5rdu5MDbTd+FXSdQ6poHe7FL8+Q1WFdg2bFhL7difcaU1CYhhiasCTEGua9K3+Cytl5bvvEYrNKYg3vFGcDJW0C6gw5FSXGUvB6oXW2IqCHByY8prPJAXWdBrXHIWRBvArtFowKQ=
Received: from BN8PR04CA0018.namprd04.prod.outlook.com (2603:10b6:408:70::31)
 by CH0PR12MB5369.namprd12.prod.outlook.com (2603:10b6:610:d4::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.35; Thu, 20 Oct
 2022 10:39:53 +0000
Received: from BN8NAM11FT054.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:70:cafe::f4) by BN8PR04CA0018.outlook.office365.com
 (2603:10b6:408:70::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.35 via Frontend
 Transport; Thu, 20 Oct 2022 10:39:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT054.mail.protection.outlook.com (10.13.177.102) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5746.16 via Frontend Transport; Thu, 20 Oct 2022 10:39:52 +0000
Received: from [10.254.241.52] (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Thu, 20 Oct
 2022 05:39:48 -0500
Message-ID: <495eb398-bec4-5d68-ef5d-4f02d0122a7c@amd.com>
Date:   Thu, 20 Oct 2022 12:39:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Subject: Re: [PATCH net-next 2/2] dt-bindings: add mdio frequency description
Content-Language: en-US
To:     Andy Chiu <andy.chiu@sifive.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <michal.simek@xilinx.com>,
        <radhey.shyam.pandey@xilinx.com>
CC:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <krzysztof.kozlowski+dt@linaro.org>, <robh+dt@kernel.org>,
        <pabeni@redhat.com>, <edumazet@google.com>,
        <greentime.hu@sifive.com>
References: <20221020094106.559266-1-andy.chiu@sifive.com>
 <20221020094106.559266-3-andy.chiu@sifive.com>
From:   Michal Simek <michal.simek@amd.com>
In-Reply-To: <20221020094106.559266-3-andy.chiu@sifive.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT054:EE_|CH0PR12MB5369:EE_
X-MS-Office365-Filtering-Correlation-Id: 99ad4ac9-6151-4f9e-5a57-08dab2876c08
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EnplTAlDf3U4V41MmKlCWoQkhMJb4f2LSSD87r4lihJlCwbNwo8gRlXLMu4Ga++S1NF09od6ioh1YNJMB/4K9xQzUFvw3F0/c/3IdPuhmdsp4z9QIRpb4oBSnPL0v0XOqsj1LGGbEiAEMvyM7yW9JKldH+GnUJukVlLdbuVai9dH6zIBBjQrZKdlqXQXMJbwNl2fMqUPEQDS4mJCBfeSxbsNKX2+U6cCou5t7lhCRC6EaniQBDE0vccnPMbRtT7Mb2mLOBoqYaNlhXotpp6Rx+IvNLgCwbZfBp0KtvgPRcKsVjIXS9DfMhzMPcbCa38YalBF24WY7BBRm7K6irL358cPy4Y25Jo77qcdvk1HRR3OE7CIQGgo+zsvf8dlVAL1+gDQcMgbmzFm47RQy2dDFsxcVYU92XkjJokO8bZjMbj+wIqzqUsVhQBe8mQyZYsgjsljsY//kKrMQR/c12iL862RDvcUoaMgksgfEDAQjsAWrfm3nLnKzQL7mf6rPA7UvXEoMNqExXqqt+obJl6bvu22gMjvxQzg2Kzs281x7nI38het0k4zdAFEkpObUDI/Mwi8jN1oA0TaVHlpfJ9+D9I3SSLPxcfn8GBaLRX+UhXpmsu8vdf6owa5RmdHg9dRs9L+qQyGDMSm/QabxDXNQNEcG6KH84+H678+of7VZGspISOpav7LBuw3HAIUEBSpXcSOdRs3ErHpzaaWZVXADgrOUruGWrCiEm/edZyb4YPtppEQhQTlP3TEbuxKYfUHrLYdK4bgjXJ0ZK/OdIXlktT3vGDNBc2sTxdN+U1NwlIdyfrCBRzuSZir7EkA+F9i4nop3fT6ZXv6d1Fq1MQcbw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(346002)(39860400002)(136003)(376002)(396003)(451199015)(46966006)(40470700004)(36840700001)(31686004)(36756003)(82740400003)(86362001)(31696002)(81166007)(356005)(82310400005)(2906002)(36860700001)(83380400001)(316002)(16576012)(54906003)(336012)(110136005)(186003)(40460700003)(40480700001)(16526019)(47076005)(426003)(70206006)(70586007)(26005)(53546011)(4326008)(478600001)(44832011)(8936002)(5660300002)(2616005)(7416002)(41300700001)(8676002)(43740500002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2022 10:39:52.8693
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 99ad4ac9-6151-4f9e-5a57-08dab2876c08
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT054.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5369
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/20/22 11:41, Andy Chiu wrote:
> CAUTION: This message has originated from an External Source. Please use proper judgment and caution when opening attachments, clicking links, or responding to this email.
> 
> 
> Add a property to set mdio bus frequency at runtime by DT.
> 
> Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
> Reviewed-by: Greentime Hu <greentime.hu@sifive.com>
> ---
>   Documentation/devicetree/bindings/net/xilinx_axienet.txt | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/xilinx_axienet.txt b/Documentation/devicetree/bindings/net/xilinx_axienet.txt
> index 1aa4c6006cd0..d78cf402aa2a 100644
> --- a/Documentation/devicetree/bindings/net/xilinx_axienet.txt
> +++ b/Documentation/devicetree/bindings/net/xilinx_axienet.txt
> @@ -43,6 +43,9 @@ Optional properties:
>                    support both 1000BaseX and SGMII modes. If set, the phy-mode
>                    should be set to match the mode selected on core reset (i.e.
>                    by the basex_or_sgmii core input line).
> +- xlnx,mdio-freq: Define the clock frequency of the MDIO bus. If the property
> +                 does not pressent on the DT, then the mdio driver would use
> +                 the default 2.5 MHz clock, as mentioned on 802.3 spc.

Isn't it better to specify it based on ccf description. It means &clk and used 
clock framework to find value?

Thanks,
Michal
