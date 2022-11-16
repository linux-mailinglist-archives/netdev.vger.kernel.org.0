Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5885162B34A
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 07:29:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231343AbiKPG3M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 01:29:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232555AbiKPGZH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 01:25:07 -0500
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 623C91D0FB
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 22:25:06 -0800 (PST)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20221116062503epoutp01a2d944736fc587bfcfdf5419cdc085d7~n-JTngB8e2176321763epoutp01x
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 06:25:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20221116062503epoutp01a2d944736fc587bfcfdf5419cdc085d7~n-JTngB8e2176321763epoutp01x
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1668579903;
        bh=5NRup8vgLkTmA5HFv9gMOga2SlWSziLFncqMmJU/jGg=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=PAeDSBhEjs7syzlvfqUnT08Lbi/YmfmCQvNjq2+erI1h85aSJ40LTvgSrVBHEFkbm
         aosaOeMCKevxM5vjR+81rrfkbQ6SykBIrycXQMGOv4IDI9vZ5DBFetNV0xc0YbINGY
         hd1PDbr4Lmk+EJ1CTkQdlmDo7nSaPjeCLwj6I1xE=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20221116062502epcas5p4ec6c1cb2db6cb395a5480e8088a8583f~n-JTJXL4J1136511365epcas5p41;
        Wed, 16 Nov 2022 06:25:02 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.178]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4NBtM14tVnz4x9Q3; Wed, 16 Nov
        2022 06:25:01 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        76.AD.39477.D3284736; Wed, 16 Nov 2022 15:25:01 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20221116062454epcas5p4d4a3d30fd84046e5ecc05e09ec38edd9~n-JLFx8L41136611366epcas5p4q;
        Wed, 16 Nov 2022 06:24:54 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20221116062454epsmtrp26c5977ea8543e5493471b593368151f5~n-JLEdZc-2917829178epsmtrp2T;
        Wed, 16 Nov 2022 06:24:54 +0000 (GMT)
X-AuditID: b6c32a4a-259fb70000019a35-b2-6374823dbc22
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        36.2E.18644.63284736; Wed, 16 Nov 2022 15:24:54 +0900 (KST)
Received: from FDSFTE302 (unknown [107.122.81.78]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20221116062451epsmtip1f9ebf1b6636ea6de6b12105d4ca3d264~n-JIVjmBN0771307713epsmtip1w;
        Wed, 16 Nov 2022 06:24:51 +0000 (GMT)
From:   "Sriranjani P" <sriranjani.p@samsung.com>
To:     "'Andrew Lunn'" <andrew@lunn.ch>
Cc:     <peppe.cavallaro@st.com>, <alexandre.torgue@foss.st.com>,
        <joabreu@synopsys.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <mcoquelin.stm32@gmail.com>, <richardcochran@gmail.com>,
        <netdev@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        "'Chandrasekar R'" <rcsekar@samsung.com>,
        "'Suresh Siddha'" <ssiddha@tesla.com>, <ravi.patel@samsung.com>,
        "'Pankaj Dubey'" <pankaj.dubey@samsung.com>
In-Reply-To: <Y2Uu16RSF9Py5AdC@lunn.ch>
Subject: RE: [PATCH 2/4] net: stmmac: dwc-qos: Add FSD EQoS support
Date:   Wed, 16 Nov 2022 11:54:47 +0530
Message-ID: <04b001d8f984$23e921b0$6bbb6510$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQHa0oM14/tprCIIIJ9eaP02I486nwFlYCwxA2F8WH0BdTEg364Lglhg
Content-Language: en-in
X-Brightmail-Tracker: H4sIAAAAAAAAA02Te1AbVRTGe7PZJOCErinaW5Q2XYQCI4/UEDYVii0M7PiYYdrOUHUq7oQ1
        MCSbmIeiY0cetQVGWyh9kBgg0qAWpz4CVEB52lJp1SCU4KMgRGJVKiCUlugQTLNp5b/fPfc7
        9zvfvXMFiGiFFyYoYAy0jqFUOC+Ye/6rmOi41FKDInHEEUJ4/jgFCMd4P0JYHIe4hHvAxScm
        GmdRYuj8UZSw/+pEiZFOC4+odE6jRP3KOZQYsD5I3LpyAxCNbTf5xOpMGyCm5r/kE+ahdpS4
        8M3vCNE4aUWfEJGtZ3/kkO5jbXyywzzOJ612I2lvruCRLbY3yY72RQ451z3KI4+2NgOyr1tC
        upe7ELK1ZxGQ3tI6Prlo35wd8lxhSj5N5dE6Mc0oNHkFjDIVf2pvbnpukixREieRE8m4mKHU
        dCqe8XR2XGaByhcTF79CqYy+Ujal1+MJO1N0GqOBFudr9IZUnNbmqbRSbbyeUuuNjDKeoQ07
        JImJ25N8whcL84dqjvC09pCimWvlaDG4dl8lCBJATAr7XAOgEgQLRNgXAB7528VjFwsAtvX/
        zGUXiwBOzk3y7rV4SxB2oxPAyxZLoOU6gN75Kr+KhyXAmQ8b/ByKPQLr605w7ogQzMSFbxXP
        cu9sBGHb4A2Hy88bsHQ4+p3Hz1wsEjrcPX4WYnLo+HoBZfl+OGia9tcRbAv8/C8Lwo4khh73
        +yhrlgk7xzwIq9kIL3re9o8KsYYg6B67HciQAVc+quGwvAH+eamVz3IYXJztCmiUsOVCC8qy
        CpaXlgXM0mDvVYtvCIHPIAZ+0pnAlsPhycsfc1jfEPjOv9OB44Wwvf4uR8EzrooAPwzPuRbQ
        KoCb10Qzr4lmXhPB/L+bFXCbwSZaq1craX2SdjtDv3rvyRUatR34/0Hsk+1ganI+vh9wBKAf
        QAGChwqbig0KkTCPeu11WqfJ1RlVtL4fJPnuuxoJe0Ch8X0kxpArkcoTpTKZTCp/TCbBNwrP
        1MYqRJiSMtCFNK2ldXf7OIKgsGJORFT8G/QL25oKfsFEzfv3LwXZb1+Et9Lrzl45eCx5vdgy
        fjzFOaAekWcnlR0+9VnqBzLnycczxsKLtuLlezhK0575gfBh/u7lXaveHE58xOnG1ZJNwcOn
        s8t6e1d6fsgafkZgdfY91NH57pbasYmRZ4979s3nDes9SznR4r0y2/UTlEOCV9jmmKGFbhs5
        6BqdaqpNkBbv8mZZIk1ZaYKYCJXneW/hP9XB1ih8UFfUZSsxmX5rfG/3SxO5NesvMbZ1DslM
        8g5Mxey7GXo4Q7Yueol5eVQurjr0fdMB2876zUKi+qdMPm+suy/HQaHfHvg001iepp45OPRo
        w3JkqUB8Fefq8ylJLKLTU/8B7nOlv5AEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sa0xSYRjHe3nPOVwKOoLZm5kZZTkqjVbt7bpa1k6rtqx1czUjPKlLiAFm
        2IfsXlTqsNUiTTN1abUaSmFLmFROVomX6LLU2YV57UprUmlNqM1vvz3/y/4fHh4Ue4lwXppa
        z2rVinQpJSDuPpRGzl5wRK+c87RxNPb3XADY3e6EuMB9jMDe+ndc3FHyicRNd3NIbHn/gsSt
        9wsobHzxgcRXBm+RuL44DP940g9wifU7F//pswL89ssDLjY32Uj86Gk3xCWdxeRyMVNd8ZrD
        eHOtXKbG3M5lii0ZjKXyNMVUlR5iamw+DvPZ7qGYnOpKwNTZ5Yx3oBYy1Q4fYIaOFHIZnyVy
        gyhRsCSZTU/bz2rjlu0SpDbln6Q0FtGBvrZTZDZoG20EfB6i56G6ocPQCAQ8MW0DyGkvgkEh
        Ark6S/+xBFUMdXGDJi9Anq5OYlig6DjUd72IGuZQehq6UnieM2yCdAWBrpnMRDDRBtBgx69A
        gk/PQP3udwGW0CuRp9EfYIKORm6vI8BCeiFyN3wjgxyCXJc+BO6QjkW3bxeAIE9G9z4W/JsX
        hfzecjK4YjW6/9IPg57x6LH/LMwDEvOIKvOIKvOIKvOISDEgKsEEVqNTpah0cs1cNZsZq1Oo
        dBnqlFjlPpUFBD5BJrOBB5VfYp2AwwNOgHhQGiosy9YrxcJkhSGL1e5L0makszonmMgjpOOF
        TUZXkphOUejZvSyrYbX/VQ6PH57NiXtU3tL/ZpwH8uO7bmqS+nP98JzLIEkRlW15te78tFER
        G6sOGhziwstb4ZOpm01puSEGV7N1fTybeHHVspmdHSsda1Whve3zo5oTImIMooXRiZu7s7I9
        A2t6laHHC12vn93oEVFTl85dnJXrcGV1qRWZP/QL7HecqZNUxpqf7QmG2t3UCj3eJqnK+R7N
        JDROWf75bPK5x9OFjaV7zjRP/iqa2N1ji9ld0SA3ZT70js3fFK/aCTasvxjda1cJau0m+UkZ
        jBwjM1C6CF9e2Q45N6r+xPY3SqtvzawVspJNpjDPYPpVcc7XsAbhe37RorE3n0NXeP5Aa8LA
        772r4NEWKaFLVchlUKtT/AUU/Fu8eAMAAA==
X-CMS-MailID: 20221116062454epcas5p4d4a3d30fd84046e5ecc05e09ec38edd9
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20221104115854epcas5p4ca280f9c4cc4d1fa564d80016e9f0061
References: <20221104120517.77980-1-sriranjani.p@samsung.com>
        <CGME20221104115854epcas5p4ca280f9c4cc4d1fa564d80016e9f0061@epcas5p4.samsung.com>
        <20221104120517.77980-3-sriranjani.p@samsung.com> <Y2Uu16RSF9Py5AdC@lunn.ch>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Andrew Lunn [mailto:andrew@lunn.ch]
> Sent: 04 November 2022 20:55
> To: Sriranjani P <sriranjani.p@samsung.com>
> Cc: peppe.cavallaro@st.com; alexandre.torgue@foss.st.com;
> joabreu@synopsys.com; davem@davemloft.net; edumazet@google.com;
> kuba@kernel.org; pabeni@redhat.com; mcoquelin.stm32@gmail.com;
> richardcochran@gmail.com; netdev@vger.kernel.org; linux-stm32@st-md-
> mailman.stormreply.com; linux-arm-kernel@lists.infradead.org; linux-
> kernel@vger.kernel.org; Chandrasekar R <rcsekar@samsung.com>; Suresh
> Siddha <ssiddha@tesla.com>
> Subject: Re: [PATCH 2/4] net: stmmac: dwc-qos: Add FSD EQoS support
> 
> > +static int dwc_eqos_setup_rxclock(struct platform_device *pdev) {
> > +	struct device_node *np = pdev->dev.of_node;
> > +
> > +	if (np && of_property_read_bool(np, "rx-clock-mux")) {
> > +		unsigned int reg, val;
> > +		struct regmap *syscon =
> syscon_regmap_lookup_by_phandle(np,
> > +			"rx-clock-mux");
> > +
> > +		if (IS_ERR(syscon)) {
> > +			dev_err(&pdev->dev, "couldn't get the rx-clock-mux
> syscon!\n");
> > +			return PTR_ERR(syscon);
> > +		}
> > +
> > +		if (of_property_read_u32_index(np, "rx-clock-mux", 1,
> &reg)) {
> > +			dev_err(&pdev->dev, "couldn't get the rx-clock-mux
> reg. offset!\n");
> > +			return -EINVAL;
> > +		}
> > +
> > +		if (of_property_read_u32_index(np, "rx-clock-mux", 2,
> &val)) {
> > +			dev_err(&pdev->dev, "couldn't get the rx-clock-mux
> reg. val!\n");
> > +			return -EINVAL;
> > +		}
> > +
> > +		regmap_write(syscon, reg, val);
> 
> This appears to be one of those binds which allows any magic value to be
> placed into any register. That is not how DT should be used.
[Sriranjani P] Will fix in the next version.
> 
>    Andrew
[Sriranjani P] Thank you for the review comment.

