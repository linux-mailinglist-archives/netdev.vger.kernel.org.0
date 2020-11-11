Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C82652AE64A
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 03:19:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732145AbgKKCSu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 21:18:50 -0500
Received: from mail-bn7nam10on2082.outbound.protection.outlook.com ([40.107.92.82]:38698
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726861AbgKKCSs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Nov 2020 21:18:48 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=io3v6OcVJOEU7zxfqUael3tO6GlkEzfqeRcM2Xyi53JbsEk3mk4fwBJzg10y0KFI3yPSesz9y+2t303gx4ORHGNHyEBLWxm7LbKk8c12YPBIOdHkORtK5a9EdRApIarG3cmIiDMQyfQh081nzfgn9SmzYUw+QGdsFwJ613gGhwxe7tjaaZSuCylkfEV0/J8oRbqONJqrlH+LOaCGpuxzs+Pr15OOXS9b0KluEb09YGKAzYSQ2CBFPmahmf0e9t2M8pbJ1eYWd0Ikg5bbb0r4cDr1Ih8AUvx4/JWExSFXnbk5ad7/OU5FxgC1BIvDlDXcJI+j3bZw3zpyA+F0eM/faw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jP5fqFHiSKAMRbd+YD23rXfF21rW7eoxnGkXOb8VqOY=;
 b=WIijz3NNo6ANlr+1pHHWB3Td/2ZhoYYMsJ1LHFELeUpuenfRWkGuM58oqs9VK8Om3C8qTad84g/R3LZ5T4a8yr1tkjTHwOe8v7EmzHOUdwmb4UjJ3ThEqLb1ISnr7kpY+VXp7NlDNXhMO9E2W1/2hEGHi6bzh94R8/2zU1FM2urwt7cFq2Xptvh+9bNNPXXq+vClhiuhzBzKz91UI0WbooigzC2begCwFvEpPWiRyYaZ4ssLK22DP41pWjnjvKDrRu4v4NykcHOVbqAhp9fQW19ftEpNGJcrkjMS7tiG57IMENQ0xcph7ONei9TgjNsdoJmWA6f34ooeFFW0nPOdrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synaptics.com; dmarc=pass action=none
 header.from=synaptics.com; dkim=pass header.d=synaptics.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=Synaptics.onmicrosoft.com; s=selector2-Synaptics-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jP5fqFHiSKAMRbd+YD23rXfF21rW7eoxnGkXOb8VqOY=;
 b=QoPMhjUU37I4MkFMiuRpjV+tXx6lHTNKbamk4NdFl7zWFIeqHO2ApjuAY+paoFE6evT8yqhgTyB6+kKy6ZhOJEUYHUu0MBXXkaIbiVF1Q6eD/R+Y1NJkrE5zfw090qG4OE6LtRp5uQWWJaGJ3N0pia4J54zPEgmHxvqyJMkah9I=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=synaptics.com;
Received: from SN2PR03MB2383.namprd03.prod.outlook.com (2603:10b6:804:d::23)
 by SN6PR03MB3728.namprd03.prod.outlook.com (2603:10b6:805:50::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.22; Wed, 11 Nov
 2020 02:18:45 +0000
Received: from SN2PR03MB2383.namprd03.prod.outlook.com
 ([fe80::49be:5ea3:8961:a22]) by SN2PR03MB2383.namprd03.prod.outlook.com
 ([fe80::49be:5ea3:8961:a22%6]) with mapi id 15.20.3541.025; Wed, 11 Nov 2020
 02:18:45 +0000
Date:   Wed, 11 Nov 2020 10:10:33 +0800
From:   Jisheng Zhang <Jisheng.Zhang@synaptics.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: stmmac: platform: use optional clk/reset
 get APIs
Message-ID: <20201111101033.753555cc@xhacker.debian>
In-Reply-To: <20201109115713.026aeb68@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
References: <20201109160855.24e911b6@xhacker.debian>
        <20201109115713.026aeb68@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.147.44.204]
X-ClientProxiedBy: SJ0PR13CA0202.namprd13.prod.outlook.com
 (2603:10b6:a03:2c3::27) To SN2PR03MB2383.namprd03.prod.outlook.com
 (2603:10b6:804:d::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from xhacker.debian (192.147.44.204) by SJ0PR13CA0202.namprd13.prod.outlook.com (2603:10b6:a03:2c3::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.13 via Frontend Transport; Wed, 11 Nov 2020 02:18:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b41cbbf0-acb3-437d-767f-08d885e81e04
X-MS-TrafficTypeDiagnostic: SN6PR03MB3728:
X-Microsoft-Antispam-PRVS: <SN6PR03MB372815ABF045FCDE206FA9C7EDE80@SN6PR03MB3728.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JE/l+N3dRaLRZLqsdbUoKKFbqGLDrkxh/lO+vz0HvegyZ5kFuoLln6v45BKLdrxahDv12/kL9Uwoh4kM/eV59H7rWJGacfrIY+dz6TQenie4RKdSDo3ECihy9akn3g3PfM4TYk4lMBlgAyiEXUwIk79fqGXq9LLNn/VYnxh0QaA3ip4LjQhdoG0tJBU2fX4kWjAhgJHZi2rjS7R6s+6CIsvONyojZruvzMxOOWTu+bYehgWqaXXTIXqkeEeGpra/jVsRfWSp1nsfvYFNRbTyhANojXOvy18uesLsZxr2ZLR4ilIFd6awAGokA+a2GEMWXx5vc+SFcbUtMsJUO2R9EQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN2PR03MB2383.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39850400004)(366004)(346002)(376002)(136003)(26005)(6666004)(7696005)(9686003)(55016002)(478600001)(66556008)(66946007)(66476007)(8936002)(8676002)(16526019)(316002)(7416002)(1076003)(86362001)(956004)(2906002)(4326008)(83380400001)(6506007)(4744005)(5660300002)(54906003)(52116002)(6916009)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: vtd/6jgDfCG9DnAaIPV/F83TuqegdUPBEhQNnHGtD6/i+Yg/dGTYhAgQ/dBkDqjN3YfY82nulE+ES5MPFgCVD5mGVdUM3S3FOI+gRiPfqXxseNVxQFrfEuXbP+PUAxmVhdUXWqgbEXN0o8Wa2jTvetbuMOqBg/mtTkTiAa22iH5c7reL650zPSLsMCgGkIF8mjhafrryKP2pL1AK4iiEMYOUloIGfIh7iEut5bbgdyVAElcYHV8PcFfBKsqpkh2mc23yliAA+uygifd+6kxU9WVtsohxsRNdI+ngDmd6+ZwnY6U8joTYXlhxwhK3zSk/RLVH3RLJnY7ryZZZErHK05lRIqUpNPaR47UkPW1mNmpnbuXm3rxzjmZfz9uXB7G9CsBTh24gEI1/4RvRssVdPghL9De2yi+bRoajwQBZTAU60kRLUWtyfLcdltLeQ2BVnzpZD+s3xyXI/yfWclZQGv/OYryK4n5nPrAp7Y4yJUabg3PU7Y3La6egUXItZrdClPUBiNLugpKfuURjOx55wlRDDZL/x0lNEf7qZjJRyUOBdiC4EXyFYnsTTjkitWKBnM1UvTIH3S15WYJmrsdNPdEgxpTa1m5cOgp7c30PUXsI1/E5kGKkKHKsv7w2yS4tx4OlrrSyclSgods9C6AuIA==
X-OriginatorOrg: synaptics.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b41cbbf0-acb3-437d-767f-08d885e81e04
X-MS-Exchange-CrossTenant-AuthSource: SN2PR03MB2383.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2020 02:18:45.7600
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335d1fbc-2124-4173-9863-17e7051a2a0e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KhNCVKVJAMlsQbchNZrDhEUzWNFhbaYdjg5CJ998NxGE1vNqt5laBCC5DkcWfx9d6uoVQQkEPOcZm8GF37AdYA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR03MB3728
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 9 Nov 2020 11:57:13 -0800 Jakub Kicinski wrote:


> 
> 
> On Mon, 9 Nov 2020 16:09:10 +0800 Jisheng Zhang wrote:
> > @@ -596,14 +595,10 @@ stmmac_probe_config_dt(struct platform_device *pdev, const char **mac)
> >               dev_dbg(&pdev->dev, "PTP rate %d\n", plat->clk_ptp_rate);
> >       }
> >
> > -     plat->stmmac_rst = devm_reset_control_get(&pdev->dev,
> > -                                               STMMAC_RESOURCE_NAME);
> > +     plat->stmmac_rst = devm_reset_control_get_optional(&pdev->dev, STMMAC_RESOURCE_NAME);  
> 
> This code was wrapped at 80 chars, please keep it wrapped.
> 

I tried to keep wrapped, since s/devm_reset_control_get/devm_reset_control_get_optional,
to match alignment at open parenthesis on the second line, the
"STMMAC_RESOURCE_NAME" will exceed 80 chars. How to handle this situation?

Thanks in advance

