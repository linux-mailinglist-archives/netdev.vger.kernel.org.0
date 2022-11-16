Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37E5662BBD6
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 12:27:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233286AbiKPL10 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 06:27:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239272AbiKPL0P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 06:26:15 -0500
Received: from out4-smtp.messagingengine.com (out4-smtp.messagingengine.com [66.111.4.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A68C613F9B;
        Wed, 16 Nov 2022 03:17:13 -0800 (PST)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 814A05C00EB;
        Wed, 16 Nov 2022 06:17:10 -0500 (EST)
Received: from imap51 ([10.202.2.101])
  by compute3.internal (MEProxy); Wed, 16 Nov 2022 06:17:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm3; t=1668597430; x=1668683830; bh=WhCKFm0a09
        MlSvjbnoZ4pQKn5yOWcxJ75avGTPaj7aI=; b=OmM/HwRQLVZ22MddVbTr9ZfVpY
        znGzgMuOhEhcazPsCepm1wotoJY955OmagthxgfOYOJfHpvZT3R93NNxK1njyHxa
        ibgfWf1wDzduqaH3IVB2IaKsGizyNXnMqLKa5wxZFNmrIhhhqhZUSG9sjmwZGVws
        8RKXCBDZ36RBd+d6Gfkm0OiF4Dx/Sllr8twMlNcGVAQAIMUDUVkm72ArmOLhOf6Z
        M1H/AStbzVUbxCxF+mgeIqha3HJ7ML+SKbxmhRqaHRC8Av/89pbu0JRDRR+q98sT
        fffbee7rIm/JCTvZZKIzhwBB/lFyZkYIU367AujB/Y9sOcm99uEstzvIhumQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1668597430; x=1668683830; bh=WhCKFm0a09MlSvjbnoZ4pQKn5yOW
        cxJ75avGTPaj7aI=; b=ZkjJGSjhCOLySrXZDWS9flh7yWttV508r5UpTRaPz7dN
        jPEXaITZMAmqP85V76Q95Me22w+DnR7F9sDOkCAlsj69dspV1Ul593U9l8rvNgMI
        PsvU+UC4+CX3A1hf0RCyzTT7OQg9wiZJlJn8RQOnGZEXP/rn9e7KYpLlwwSFCNmN
        T3dPZRFZCOP3zz+Dgc+6ZewnnAquKN8FOOld2pwjfuqQ171PDSl2QbaW57Bkw8yR
        b1Diu7W19+6ZcYeXp6uXKc12CpAXvxXn9XoDxaP8POyB65NZV9TpqyCBlBcol/3D
        URFAUHiYhZnj+Hrv/vpPa5o9cV4Wa2Aze1ECH4dMfw==
X-ME-Sender: <xms:tcZ0Y1rY347kKuZX1I0mpU9IKOG12ygKrnrmfs-LcxTk3AIyEHIiXg>
    <xme:tcZ0Y3oWnrjxVpkDNLaRXaAhK5YvFHoXNz--WJOt1RPWNCag00mWw8ZT5nLD7B-Xp
    Fgo67Sn8DAQPoEu-nk>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrgeeigddvhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefofgggkfgjfhffhffvvefutgesthdtredtreertdenucfhrhhomhepfdetrhhn
    ugcuuegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdruggvqeenucggtffrrghtth
    gvrhhnpeffheeugeetiefhgeethfejgfdtuefggeejleehjeeutefhfeeggefhkedtkeet
    ffenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrrh
    hnugesrghrnhgusgdruggv
X-ME-Proxy: <xmx:tcZ0YyOGWR-0mHmaZ8fdDVkTfA7O02drAljumbRHgv3S8Y1yvVF6Ww>
    <xmx:tcZ0Yw77yA53L6f8Iup16MPQm7Ax27RrRwxQ_0fR3eXnAi8G96KTxQ>
    <xmx:tcZ0Y049Ta4oH0gaJ_0bPjWWt1F93sPp2vPVjpEc68wU0fjJMVnssA>
    <xmx:tsZ0Y66l3nYZWH9rfjI_cZ5BM8mPE50TVNTDXVGI7_D-W0c-d4WOoQ>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 75CCDB60086; Wed, 16 Nov 2022 06:17:09 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.7.0-alpha0-1115-g8b801eadce-fm-20221102.001-g8b801ead
Mime-Version: 1.0
Message-Id: <37d42235-1960-4001-9be9-20a85de54730@app.fastmail.com>
In-Reply-To: <20221116091247.52388-1-vivek.2311@samsung.com>
References: <CGME20221116090644epcas5p3a0fa6d51819a2b2a9570f236191748ea@epcas5p3.samsung.com>
 <20221116091247.52388-1-vivek.2311@samsung.com>
Date:   Wed, 16 Nov 2022 12:16:49 +0100
From:   "Arnd Bergmann" <arnd@arndb.de>
To:     "Vivek Yadav" <vivek.2311@samsung.com>, rcsekar@samsung.com,
        krzysztof.kozlowski+dt@linaro.org,
        "Wolfgang Grandegger" <wg@grandegger.com>,
        "Marc Kleine-Budde" <mkl@pengutronix.de>,
        "David S . Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>, pankaj.dubey@samsung.com,
        ravi.patel@samsung.com, "Alim Akhtar" <alim.akhtar@samsung.com>,
        linux-fsd@tesla.com, "Rob Herring" <robh+dt@kernel.org>
Cc:     linux-can@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        aswani.reddy@samsung.com, sriranjani.p@samsung.com,
        ajaykumar.rs@samsung.com
Subject: Re: [PATCH] arm64: dts: fsd: Change the reg properties from 64-bit to 32-bit
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 16, 2022, at 10:12, Vivek Yadav wrote:
> Change the reg properties from 64-bit to 32-bit for all IPs, as none of
> the nodes are above 32-bit range in the fsd SoC.
>
> Since dma-ranges length does not fit into 32-bit size, keep it 64-bit
> and move it to specific node where it is used instead of SoC section.

I don't think that works, the dma-ranges property is part of the
bus, not a particular device:

 		mdma0: dma-controller@10100000 {
 			compatible = "arm,pl330", "arm,primecell";
-			reg = <0x0 0x10100000 0x0 0x1000>;
+			reg = <0x10100000 0x1000>;
 			interrupts = <GIC_SPI 424 IRQ_TYPE_LEVEL_HIGH>;
 			#dma-cells = <1>;
 			clocks = <&clock_imem IMEM_DMA0_IPCLKPORT_ACLK>;
 			clock-names = "apb_pclk";
 			iommus = <&smmu_imem 0x800 0x0>;
+			#address-cells = <2>;
+			#size-cells = <2>;
+			dma-ranges = <0x0 0x0 0x0 0x10 0x0>;
 		};

Since the dma-controller has no children, I don't see how this has
any effect. Also, translating a 36-bit address into a 32-bit
address just means it gets truncated anyway, so there is no
point in making it appear to have a larger address range.

      Arnd
