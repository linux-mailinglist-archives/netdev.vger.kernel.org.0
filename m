Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80C784DE517
	for <lists+netdev@lfdr.de>; Sat, 19 Mar 2022 02:56:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241793AbiCSB5Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 21:57:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234358AbiCSB5V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 21:57:21 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2130.outbound.protection.outlook.com [40.107.92.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D957F2DE7BA
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 18:56:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C6KjYOiaGmKbMP0ucBb/LJr1IH7USxg5CRdoRK4uImeGBYjNDZN6aBB+sZD9e4M4TnqcCVot3zQ2B8zQAOzjZMqYh1f9SZlA74rIx5xtSU46xWC/0xb2v2B8pwsDEfzpuCwrOzQ5IzO+m0Sk9qCsxUCCU7oDObIsUUPYNQZTolINlDK/Wcqtcen1vITmI3bN4oKVUjWVgDFic8/kuAFO4jxsZYEdfYE1h7/d6hE/JaXv51TPxfq+/Ge7HNfiNHfL2sOzi050l7Z/BwPvvpirMUN81oBnS/OZ89DvwpS/NBlaOBMKWc5KKuAAOWsEVOMEh8CrhNAEBhaDcHNnrfmO3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lE4J6XBtuxJfnbc4xhaMI4E2VDZNmh4VQD08GUn4rdo=;
 b=Y8jwtBGPHnyieYqIi0e4rRi/QBa5B9m0GHOYq75Nc4uCziT8GpsptEY9s5PdCt6ALw++gJvWVpzFz0vxAsOspU7bT4cTwOA+XS8+HcO8zD7gs5Dh4yfCAdJTCYuYS5mjD+XLkhSy/rLrLwXTtPEu228nWVt7CimPhK0uJmw1N2bl7HHJboOVEew/QI7xw++xbcsD83gQSeSyzQqTIo3/4veCnHF01wmOFOjdPj4lTex3THhrznpdlXkflneQcckj8+KezcPdF4Px+GNRInmbUwNCE3Jlwc0z34MuWNuadx1JGNHpnnmwW8icc/QtEpMPYXL4VXKsqEw9vmE8XqxFhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lE4J6XBtuxJfnbc4xhaMI4E2VDZNmh4VQD08GUn4rdo=;
 b=tKpG49AnEtZYFOPCZdaoGpxZb0e39xHbwAsgSMPNMXnx1yqVQwMmcUFLt0lveFX1/5zgX/pS1VwHIVOghXFp7QqTHXgpRqPju06NEltepZU1eoexCnELSEn58weuM4xoZLszAa0LeqriFCQ9MkIX3kWu9N80PhKHyzXS4NptPVM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from DM6PR13MB3705.namprd13.prod.outlook.com (2603:10b6:5:24c::16)
 by MWHPR13MB1166.namprd13.prod.outlook.com (2603:10b6:300:14::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.8; Sat, 19 Mar
 2022 01:55:58 +0000
Received: from DM6PR13MB3705.namprd13.prod.outlook.com
 ([fe80::755d:450b:de86:75fb]) by DM6PR13MB3705.namprd13.prod.outlook.com
 ([fe80::755d:450b:de86:75fb%3]) with mapi id 15.20.5081.015; Sat, 19 Mar 2022
 01:55:58 +0000
Date:   Sat, 19 Mar 2022 09:55:46 +0800
From:   Yinjun Zhang <yinjun.zhang@corigine.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Simon Horman <simon.horman@corigine.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        oss-drivers@corigine.com
Subject: Re: [PATCH net-next 10/10] nfp: nfdk: implement xdp tx path for NFDK
Message-ID: <20220319015546.GB18238@nj-rack01-04.nji.corigine.com>
References: <20220318101302.113419-1-simon.horman@corigine.com>
 <20220318101302.113419-11-simon.horman@corigine.com>
 <20220318105645.3ee1cb6c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220318105645.3ee1cb6c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ClientProxiedBy: HK2P15301CA0013.APCP153.PROD.OUTLOOK.COM
 (2603:1096:202:1::23) To DM6PR13MB3705.namprd13.prod.outlook.com
 (2603:10b6:5:24c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cab7de64-6be2-4aab-13d6-08da094b9cc8
X-MS-TrafficTypeDiagnostic: MWHPR13MB1166:EE_
X-Microsoft-Antispam-PRVS: <MWHPR13MB1166157DC281533F8F7B6850FC149@MWHPR13MB1166.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cCfxxdcDNL0atI3BiuwE9sbLL259Iko7U7HS0kKyD1wTQXRm0Jld1LuJyANdPeiNFKN7/MXjNck1tC8Iv4wKGpN7DEVzVXazMHq7sVXei9+yVnUxOsB62HUWs+x8akREpHUWf/4kURfPXPuL5WZaVJHp0yPhVll8OIylEPdpZ04f10JxktnFwZ8p0j77rd4LlVHgJkimPd+n3HquLYShBm7+LmU3v6LQBKXqX6/6juja+qmaILVq9xvnm64Tn0bZO1pZJVQuZPQRu9ERkVQ+jvRBD/FqDdxLs/fRRdGOsJMtJGu1vU5i/cZq85LAj2FrxyR9ag7RNxkqzbMg9vrZE1HFZfMo3BbEej0f4QYJ8DOXQwHVxWFeDeIT1JaKDf/ysBBHjIWXeQMB211bGcggr0qD3kFpIMPEandZHHmgnHVGDXVgVjFetkDTkjCAwQiEqsmjUGr5o2PTm9Dsoic37OflC1JBZOOjjPdbYU4Q5dLCNxXF9FtxtE/bG+rRbw8FuVEChCWUXb5tv0oAF2zWLgzkNIBvsoO96PyCPfgadJKJCTbgBUOhvgY7R/W1V9LIPXrvUwdIwtRmKdsftjNmOihM2fR8L9Z1loIh0HAycwvLz3AFMLTe1vz7/QTtDsv+Urh3w2zmHQ6IzNUaYJHZgo/M93efCSo9HoT0fbzVME/5zjeZG5+yNd3Z3Nmoh3gsmJ3NBey9j6VtTIzaF1r74A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR13MB3705.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(39830400003)(136003)(346002)(376002)(366004)(396003)(66476007)(66556008)(66946007)(8676002)(44832011)(83380400001)(508600001)(4326008)(6486002)(26005)(316002)(2906002)(8936002)(33656002)(107886003)(186003)(1076003)(52116002)(86362001)(5660300002)(6512007)(6506007)(6666004)(54906003)(38350700002)(38100700002)(6916009);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yJZEds4THz1zjlH8ULygLa6udlDCWcYWfweVtFDv/OAY9LhZbc2OZyiMzgl3?=
 =?us-ascii?Q?SeXFvEtqrlBqwVM5XDuhFGhDhxBYfrCHafdpB62u/UM3K2+sMWgmPxxHaqTR?=
 =?us-ascii?Q?kspuPrtHmfyhbdfxRVP9CwtcD7EeeIKB83+HGFHFNKxymTXg7EBYylG6iaEt?=
 =?us-ascii?Q?aF/S1nGwOm0EXthOMfmwxlUvXmGwy3x72dnxabuvt19HX2kA6gkpD0OOrLZY?=
 =?us-ascii?Q?90+fzRpJeYrKwq48VDb845vwmNCFX3Xq5BPISN/eIvXeAJu0etkYJrcU7bkn?=
 =?us-ascii?Q?U1O1g794VzbbIlm0i0U/ApxTFVwJwDw+vD+/IIuxiYjmV1rBNFsJ4RFLkofq?=
 =?us-ascii?Q?N709eDZHHdexTX91FU7jZlFoKODLwEMIyfNFtCvfkTDufXlJGEQMpzvXKRGe?=
 =?us-ascii?Q?B2lJ/TDTYMPn9HXS38YrMgLhFRLW9zjdUzxhCVo2UZo5mO4hQ04VXOVCU8oE?=
 =?us-ascii?Q?hmmDsyDh9Jdpr3grfPNfENfUHXXljVB6FJgvK2ifVIkMrnbeGn9dRWFQ+mf0?=
 =?us-ascii?Q?pfxtbhapLpkgzz/nmY1llUYwa18/YjOWaR4bftY3Nwv+8ee82lN9kfrhBjbQ?=
 =?us-ascii?Q?rBEQVjRiBjWbFLWk72Wh7LWR85MJ87/FtG9jR3Z2DxmzqO41XiAxYiYHIkmy?=
 =?us-ascii?Q?1wtyvWVlc+CuEYqUcVx5m7Tdtq8jUA75v6Hax7yiRoz++bl6MujXeNz/es9l?=
 =?us-ascii?Q?PIgZMHa2/PaGPaOZZqroSRp3OKp4FodWwhPG5OKKv6sj4bROm20yvLyKuqbC?=
 =?us-ascii?Q?9JfroAMYgcdhK6J+bGHFW04wCNycYGIgZ9Osdbc5x9W+CiaK03BRsa6vaHNH?=
 =?us-ascii?Q?UMGVpHCpS0zcVv2mLRcztLV1ZDyzaBxdQ9ETeCEx3Ala+gAAUsj8SqnaCtHG?=
 =?us-ascii?Q?BO6dbZoK1KR/QRAXd4i2VtzpshVE2gaDxuOlVxEhspGhQbtxN+GklNeMUHku?=
 =?us-ascii?Q?fMitFogep+yiFjOD/YVEN7sihHZkoQNFN9TCqnlEXdSkfRv9L62FXYGyWIRR?=
 =?us-ascii?Q?lqFB6yyQMiBqTl2E/sBX6MQ94Yod0aGzVxZLQj5+DhmtSAFKQoZ+6Ak2eS3z?=
 =?us-ascii?Q?vSgYDHZltpqw2G2eK/FlW26sYQyC8TiNB+kcWoi22RXNGSeiKCP3HcplhbCZ?=
 =?us-ascii?Q?1M558IZUZLkL44sDzztvj1/ZzXNAwolTT16YsmSAdWGXNW/i8Nz5N0bFh7l9?=
 =?us-ascii?Q?PrCp4eNf9eHzG+OLfqtKzl1xI4VYTKTdEqUdYXw2D2Gwz2aPHHGA5irIUysM?=
 =?us-ascii?Q?0wgWSUqw39bBWk0xkendVh8c2Kp//XJ4O7EDymIG7zKpcTVLUJcRQoFw6dC5?=
 =?us-ascii?Q?V37EU3onQ26piwZA+9Df7SBDJl97TsRTGcG6vD2NSlK0iPYV6J1Ordc3FdvX?=
 =?us-ascii?Q?1zBMZ0yhTUIUSeXcLqduC0f/GC/5XyLAxAmdn/JZOCow0x0UzWDXrK2aYFh/?=
 =?us-ascii?Q?s4Ot39YdaS+wzYtJCoaR9QYz0Eu+HPAecKbCmP9rcK5rb/k+VDMNiA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cab7de64-6be2-4aab-13d6-08da094b9cc8
X-MS-Exchange-CrossTenant-AuthSource: DM6PR13MB3705.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2022 01:55:58.5307
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VxTVXJVrBhjqWFj92gMj9HpW8ShFJLAZ7YcJHRb1J6KWOcigpWfXOIe9hun6qmbuzv1JCC+FO1wUBGOGh0NXL6+PG04Yjr0ZrtRMdmZr1QQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR13MB1166
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 18, 2022 at 10:56:45AM -0700, Jakub Kicinski wrote:
> On Fri, 18 Mar 2022 11:13:02 +0100 Simon Horman wrote:
> > From: Yinjun Zhang <yinjun.zhang@corigine.com>
> > 
> > Due to the different definition of txbuf in NFDK comparing to NFD3,
> > there're no pre-allocated txbufs for xdp use in NFDK's implementation,
> > we just use the existed rxbuf and recycle it when xdp tx is completed.
> > 
> > For each packet to transmit in xdp path, we cannot use more than
> > `NFDK_TX_DESC_PER_SIMPLE_PKT` txbufs, one is to stash virtual address,
> > and another is for dma address, so currently the amount of transmitted
> > bytes is not accumulated. Also we borrow the last bit of virtual addr
> > to indicate a new transmitted packet due to address's alignment
> > attribution.
> > 
> > Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
> > Signed-off-by: Fei Qin <fei.qin@corigine.com>
> > Signed-off-by: Simon Horman <simon.horman@corigine.com>
> 
> Breaks 32 bit :(

You mean 32-bit arch? I'd thought of that, but why needn't
`NFCT_PTRMASK` take that into account?
