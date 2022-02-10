Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C3A84B0D71
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 13:21:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241451AbiBJMU7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 07:20:59 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232947AbiBJMU6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 07:20:58 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2050.outbound.protection.outlook.com [40.107.223.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29CC3B90;
        Thu, 10 Feb 2022 04:20:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ThzTmLc/mgliYA+GnpWhhrE5Lzpd4wO0eVD1BPGn8vfhNnG5KPKPS6HfapHaAj6BetQCdk4JWtsEa1z6IZf2kTPxXYuOUWZrc5oeS0mcGNXN7epi7n1+MPMUD6iUdRNXHJq4YF9kNXWxF7uN2gmLLUnG5bEOVTEyhrN+QKO567UGHCp01AH8bRwbEIl5E5rV1UzEdNDCx5ijPAjQJcBI+VU5QjYFcg6XnOMcxuwoLuT0dj5XnI8ZJWt21eKIBVLWm535855UsPA66CoMStFYb2tJcbyJFwbwoNa34vIFMLk2BCy4j8cKxsFGSwtsZOSkU4JMiHcuTMHCL8X4yceHaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y2Iyuaqg5xIcU7KrdKiJI14VNxyCV2UqV8oSsChZfvs=;
 b=eF//yTYV4gcmyNnkHUVGXnOecIsJgZoqW6M3DsPB5yZAB+sKHNx5+XXIXQHxUCH+NrBeQKCbLKVd9oAY+PL2KvkNXTtSugMrUmhGDes4ceY+IBn1/gVEhKDRPOGgtD7Jh2QWgdkOpxqefyM6a2N04IWWFcV+N1DisNU32KQGBwRXJGV7/yKf0Y1HJ+fIT5jejA+kVqQt4FTo3R3XA9DjssYmVF3YdBuzE5/WOpn+24jl1vgMB9XWO+5yBrfgCCeEf4BoEOF0EDkyfn7UQfxLGI8bCZ9OT8zLZYnm1oZRUR9lhpe9FngsNaTJjV9BbeFCTPGKyO4bZ6lTOUihS4/cNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=kernel.org smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y2Iyuaqg5xIcU7KrdKiJI14VNxyCV2UqV8oSsChZfvs=;
 b=Amj1ZrLSEAy6DqBjMCvkh8N4lSGpbT5zsQShj06KVHwjj0CCagMztnK0IU/HPe5nxuHYR4tl98S0vXQLFRaki5tnhx6b3NxqfcJ544JD0dyxa2QTPui9bVw48Usf3XjX4LYS/dcp3xIOyH04wIUtG94f/xGGqL2Mq7wZO0wnz7w=
Received: from BN9PR03CA0850.namprd03.prod.outlook.com (2603:10b6:408:13d::15)
 by DM5PR0201MB3447.namprd02.prod.outlook.com (2603:10b6:4:79::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Thu, 10 Feb
 2022 12:20:57 +0000
Received: from BN1NAM02FT031.eop-nam02.prod.protection.outlook.com
 (2603:10b6:408:13d:cafe::75) by BN9PR03CA0850.outlook.office365.com
 (2603:10b6:408:13d::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11 via Frontend
 Transport; Thu, 10 Feb 2022 12:20:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch02.xlnx.xilinx.com;
Received: from xsj-pvapexch02.xlnx.xilinx.com (149.199.62.198) by
 BN1NAM02FT031.mail.protection.outlook.com (10.13.2.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4975.11 via Frontend Transport; Thu, 10 Feb 2022 12:20:57 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Thu, 10 Feb 2022 04:20:42 -0800
Received: from smtp.xilinx.com (172.19.127.96) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Thu, 10 Feb 2022 04:20:42 -0800
Envelope-to: git@xilinx.com,
 robh@kernel.org,
 linux-can@vger.kernel.org,
 wg@grandegger.com,
 netdev@vger.kernel.org,
 davem@davemloft.net,
 devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 kuba@kernel.org,
 linux-arm-kernel@lists.infradead.org,
 mkl@pengutronix.de,
 robh+dt@kernel.org
Received: from [10.254.241.49] (port=45360)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <michal.simek@xilinx.com>)
        id 1nI8RF-000Cme-K7; Thu, 10 Feb 2022 04:20:42 -0800
Message-ID: <8132b563-c726-36aa-c210-937a996784c4@xilinx.com>
Date:   Thu, 10 Feb 2022 13:20:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH v2] dt-bindings: can: xilinx_can: Convert Xilinx CAN
 binding to YAML
Content-Language: en-US
To:     Rob Herring <robh@kernel.org>,
        Amit Kumar Mahapatra <amit.kumar-mahapatra@xilinx.com>
CC:     <naga.sureshkumar.relli@xilinx.com>, <linux-can@vger.kernel.org>,
        <wg@grandegger.com>, <netdev@vger.kernel.org>,
        <appana.durga.rao@xilinx.com>, <git@xilinx.com>,
        <davem@davemloft.net>, <devicetree@vger.kernel.org>,
        <michal.simek@xilinx.com>, <linux-kernel@vger.kernel.org>,
        <kuba@kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <mkl@pengutronix.de>, <robh+dt@kernel.org>
References: <20220209174850.32360-1-amit.kumar-mahapatra@xilinx.com>
 <1644445576.227208.1050091.nullmailer@robh.at.kernel.org>
From:   Michal Simek <michal.simek@xilinx.com>
In-Reply-To: <1644445576.227208.1050091.nullmailer@robh.at.kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8b12d2fb-d1f2-4ad1-96ca-08d9ec8fca7f
X-MS-TrafficTypeDiagnostic: DM5PR0201MB3447:EE_
X-Microsoft-Antispam-PRVS: <DM5PR0201MB3447C44119277F542C185989C62F9@DM5PR0201MB3447.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0sRXNCk1VoqeuEEw8glZW3DkjbdFpRZbRCrFXfpQo0MuMe3ZHa2Q0C9833WJ0AWHYLsdIlaQ3c/Q2K+6op7c86FRou+5Yv/tUQNE++vJll+9n22Xihyu2oRTHy2EDfXPe6YQa+OZ3Hx3k+0Qh5zhk27AY9+sy5YqF+SFhdjADoJjaU5urAI3m9fbLy73gWT86M9TobZlnAmPyxkeHHzHngfJ+lzSvjlstztelLkrAcr3tXL6qkE6nnleTK8AVXely8n+Qq5YP1XgxOws/0eA3QFMsrBlmCQ5g/fnDNdt3a8hGQP2uKUqTrxgs2ZHnw5YuKKjyoPp40O1A13txsikkg9/tC3M/53kGdl5Nji9wgtnVaVEDzYNuFWJbB31MV4kvDhhgcCmqGloutkp4erlwBCzLcW2K1ZdjePj79LBa+LCNcq66nHkFMWSf042bBiA+BZuiWZkEPVVgybcyTaBf1pb6h3RHRAmtgJt8iKTXNWYuU8JFJ855gLmzA1RzQr+1aHgiTTCmsuFIoHxJmnYWQCop00mopKTfHVFKqjK3awbr2EVClBHDiG96bEGl66BP90/mmgd8HgZsgZvGzfrFTn6TGzfrEXuhAj5Kd9hIUz3EXwMv74VDw522Tuj5f9Km50UIzEHfIEGUycFM4x9Vq5ZtXtkIcAuDEkcolwkXsW7NGzCZ1MQkn3DFRA6vevvKjDveD2PTszgaoZQAplIxXyH5UdH9jEYskQ/Wy9julDqCyoKLsRVXCF55dzU1uR4KJMk9vck8T0pp0ulybLQmfiyv0cn7JYB0iBjiEc3cv+fbcFDUTp3dcTb+jjSvEsbb8s6sQ7ZMdIBJ/l9t4o7z/3UBQbHV6WvPpUvnSJ8tZ8=
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch02.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(40460700003)(36860700001)(8936002)(31686004)(508600001)(31696002)(6666004)(966005)(8676002)(426003)(336012)(9786002)(83380400001)(53546011)(70206006)(4326008)(47076005)(54906003)(6636002)(316002)(26005)(186003)(70586007)(7636003)(82310400004)(110136005)(5660300002)(356005)(2616005)(7416002)(44832011)(2906002)(36756003)(50156003)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2022 12:20:57.0067
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b12d2fb-d1f2-4ad1-96ca-08d9ec8fca7f
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch02.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: BN1NAM02FT031.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR0201MB3447
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/9/22 23:26, Rob Herring wrote:
> On Wed, 09 Feb 2022 23:18:50 +0530, Amit Kumar Mahapatra wrote:
>> Convert Xilinx CAN binding documentation to YAML.
>>
>> Signed-off-by: Amit Kumar Mahapatra <amit.kumar-mahapatra@xilinx.com>
>> ---
>> BRANCH: yaml
>>
>> Changes in v2:
>>   - Added reference to can-controller.yaml
>>   - Added example node for canfd-2.0
>> ---
>>   .../bindings/net/can/xilinx_can.txt           |  61 -------
>>   .../bindings/net/can/xilinx_can.yaml          | 160 ++++++++++++++++++
>>   2 files changed, 160 insertions(+), 61 deletions(-)
>>   delete mode 100644 Documentation/devicetree/bindings/net/can/xilinx_can.txt
>>   create mode 100644 Documentation/devicetree/bindings/net/can/xilinx_can.yaml
>>
> 
> Running 'make dtbs_check' with the schema in this patch gives the
> following warnings. Consider if they are expected or the schema is
> incorrect. These may not be new warnings.
> 
> Note that it is not yet a requirement to have 0 warnings for dtbs_check.
> This will change in the future.
> 
> Full log is available here: https://patchwork.ozlabs.org/patch/1590637
> 
> 
> can@ff060000: 'power-domains' does not match any of the regexes: 'pinctrl-[0-9]+'
> 	arch/arm64/boot/dts/xilinx/avnet-ultra96-rev1.dt.yaml
> 	arch/arm64/boot/dts/xilinx/zynqmp-sm-k26-revA.dt.yaml
> 	arch/arm64/boot/dts/xilinx/zynqmp-smk-k26-revA.dt.yaml
> 	arch/arm64/boot/dts/xilinx/zynqmp-zc1232-revA.dt.yaml
> 	arch/arm64/boot/dts/xilinx/zynqmp-zc1254-revA.dt.yaml
> 	arch/arm64/boot/dts/xilinx/zynqmp-zc1275-revA.dt.yaml
> 	arch/arm64/boot/dts/xilinx/zynqmp-zc1751-xm015-dc1.dt.yaml
> 	arch/arm64/boot/dts/xilinx/zynqmp-zc1751-xm016-dc2.dt.yaml
> 	arch/arm64/boot/dts/xilinx/zynqmp-zc1751-xm017-dc3.dt.yaml
> 	arch/arm64/boot/dts/xilinx/zynqmp-zc1751-xm018-dc4.dt.yaml
> 	arch/arm64/boot/dts/xilinx/zynqmp-zc1751-xm019-dc5.dt.yaml
> 	arch/arm64/boot/dts/xilinx/zynqmp-zcu100-revC.dt.yaml
> 	arch/arm64/boot/dts/xilinx/zynqmp-zcu102-rev1.0.dt.yaml
> 	arch/arm64/boot/dts/xilinx/zynqmp-zcu102-rev1.1.dt.yaml
> 	arch/arm64/boot/dts/xilinx/zynqmp-zcu102-revA.dt.yaml
> 	arch/arm64/boot/dts/xilinx/zynqmp-zcu102-revB.dt.yaml
> 	arch/arm64/boot/dts/xilinx/zynqmp-zcu104-revA.dt.yaml
> 	arch/arm64/boot/dts/xilinx/zynqmp-zcu104-revC.dt.yaml
> 	arch/arm64/boot/dts/xilinx/zynqmp-zcu106-revA.dt.yaml
> 	arch/arm64/boot/dts/xilinx/zynqmp-zcu111-revA.dt.yaml
> 
> can@ff070000: 'power-domains' does not match any of the regexes: 'pinctrl-[0-9]+'
> 	arch/arm64/boot/dts/xilinx/avnet-ultra96-rev1.dt.yaml
> 	arch/arm64/boot/dts/xilinx/zynqmp-sm-k26-revA.dt.yaml
> 	arch/arm64/boot/dts/xilinx/zynqmp-smk-k26-revA.dt.yaml
> 	arch/arm64/boot/dts/xilinx/zynqmp-zc1232-revA.dt.yaml
> 	arch/arm64/boot/dts/xilinx/zynqmp-zc1254-revA.dt.yaml
> 	arch/arm64/boot/dts/xilinx/zynqmp-zc1275-revA.dt.yaml
> 	arch/arm64/boot/dts/xilinx/zynqmp-zc1751-xm015-dc1.dt.yaml
> 	arch/arm64/boot/dts/xilinx/zynqmp-zc1751-xm016-dc2.dt.yaml
> 	arch/arm64/boot/dts/xilinx/zynqmp-zc1751-xm017-dc3.dt.yaml
> 	arch/arm64/boot/dts/xilinx/zynqmp-zc1751-xm018-dc4.dt.yaml
> 	arch/arm64/boot/dts/xilinx/zynqmp-zc1751-xm019-dc5.dt.yaml
> 	arch/arm64/boot/dts/xilinx/zynqmp-zcu100-revC.dt.yaml
> 	arch/arm64/boot/dts/xilinx/zynqmp-zcu102-rev1.0.dt.yaml
> 	arch/arm64/boot/dts/xilinx/zynqmp-zcu102-rev1.1.dt.yaml
> 	arch/arm64/boot/dts/xilinx/zynqmp-zcu102-revA.dt.yaml
> 	arch/arm64/boot/dts/xilinx/zynqmp-zcu102-revB.dt.yaml
> 	arch/arm64/boot/dts/xilinx/zynqmp-zcu104-revA.dt.yaml
> 	arch/arm64/boot/dts/xilinx/zynqmp-zcu104-revC.dt.yaml
> 	arch/arm64/boot/dts/xilinx/zynqmp-zcu106-revA.dt.yaml
> 	arch/arm64/boot/dts/xilinx/zynqmp-zcu111-revA.dt.yaml
> 

Yes add power-domains as was done for example by this commit for ttc.

Thanks,
Michal

commit 557804a81d256b15952dcd179280ede92a5bfae1
Author:     Michal Simek <michal.simek@xilinx.com>
AuthorDate: Fri Oct 15 10:29:14 2021 +0200
Commit:     Daniel Lezcano <daniel.lezcano@linaro.org>
CommitDate: Tue Nov 2 10:03:25 2021 +0100

     dt-bindings: timer: cadence_ttc: Add power-domains

     Describe optional power-domain property to fix dts_check warnings.
     The similar change was done by commit 8c0aa567146b ("dt-bindings: gpio:
     fsl-imx-gpio: Add power-domains").

     Signed-off-by: Michal Simek <michal.simek@xilinx.com>
     Acked-by: Rob Herring <robh@kernel.org>
     Link: 
https://lore.kernel.org/r/cc655a72b20790f6d7408b1aaf81c4bf878aafb4.1634286552.git.michal.simek@xilinx.com
     Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>

