Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 577D058276B
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 15:13:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233676AbiG0NNS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 09:13:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbiG0NNR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 09:13:17 -0400
Received: from mx0a-00128a01.pphosted.com (mx0a-00128a01.pphosted.com [148.163.135.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 089FC22BFC;
        Wed, 27 Jul 2022 06:13:16 -0700 (PDT)
Received: from pps.filterd (m0167089.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26RACOnK013409;
        Wed, 27 Jul 2022 09:12:46 -0400
Received: from nwd2mta3.analog.com ([137.71.173.56])
        by mx0a-00128a01.pphosted.com (PPS) with ESMTPS id 3hgdw6b1f9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Jul 2022 09:12:46 -0400
Received: from ASHBMBX8.ad.analog.com (ASHBMBX8.ad.analog.com [10.64.17.5])
        by nwd2mta3.analog.com (8.14.7/8.14.7) with ESMTP id 26RDCj63061066
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 27 Jul 2022 09:12:45 -0400
Received: from ASHBCASHYB4.ad.analog.com (10.64.17.132) by
 ASHBMBX8.ad.analog.com (10.64.17.5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.14; Wed, 27 Jul 2022 09:12:44 -0400
Received: from ASHBMBX9.ad.analog.com (10.64.17.10) by
 ASHBCASHYB4.ad.analog.com (10.64.17.132) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.14; Wed, 27 Jul 2022 09:12:44 -0400
Received: from zeus.spd.analog.com (10.66.68.11) by ashbmbx9.ad.analog.com
 (10.64.17.10) with Microsoft SMTP Server id 15.2.986.14 via Frontend
 Transport; Wed, 27 Jul 2022 09:12:44 -0400
Received: from localhost.localdomain ([10.48.65.12])
        by zeus.spd.analog.com (8.15.1/8.15.1) with ESMTP id 26RDCB50024189;
        Wed, 27 Jul 2022 09:12:17 -0400
From:   <alexandru.tachici@analog.com>
To:     <andrew@lunn.ch>
CC:     <alexandru.tachici@analog.com>, <d.michailidis@fungible.com>,
        <davem@davemloft.net>, <devicetree@vger.kernel.org>,
        <edumazet@google.com>, <geert+renesas@glider.be>,
        <geert@linux-m68k.org>, <gerhard@engleder-embedded.com>,
        <joel@jms.id.au>, <krzysztof.kozlowski+dt@linaro.org>,
        <kuba@kernel.org>, <l.stelmach@samsung.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <robh+dt@kernel.org>, <stefan.wahren@i2se.com>,
        <stephen@networkplumber.org>, <wellslutw@gmail.com>
Subject: [net-next,v2,2/3] net: ethernet: adi: Add ADIN1110 support
Date:   Wed, 27 Jul 2022 16:26:12 +0300
Message-ID: <20220727132612.31445-1-alexandru.tachici@analog.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <Yt76W+MbeHucJj0f@lunn.ch>
References: <Yt76W+MbeHucJj0f@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain
X-ADIRuleOP-NewSCL: Rule Triggered
X-Proofpoint-GUID: u0jf2sfaQPUe4lUCdPtLJvWVr9epQG22
X-Proofpoint-ORIG-GUID: u0jf2sfaQPUe4lUCdPtLJvWVr9epQG22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-27_03,2022-07-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011
 priorityscore=1501 spamscore=0 malwarescore=0 suspectscore=0 bulkscore=0
 phishscore=0 lowpriorityscore=0 mlxlogscore=749 adultscore=0 mlxscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207270054
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > +static irqreturn_t adin1110_irq(int irq, void *p)
> > +{
> > +	struct adin1110_priv *priv = p;
> > +	u32 status1;
> > +	u32 val;
> > +	int ret;
> > +	int i;
> > +
> > +	mutex_lock(&priv->lock);
> 
> The MDIO bus operations are using the same lock. MDIO can be quite
> slow. Do you really need mutual exclusion between MDIO and interrupts?
> What exactly is this lock protecting?
> 
>   Andrew

Hi Andrew,

Thanks for all the help here.

With this lock I am mainly protecting SPI read/writes. The hardware doesn't expose the MDIO pins.
In order to read/write a PHY reg, there has to be a SPI read/write to the device, the same
line where the MAC is programmed and ethernet frames are sent/received, not very efficient I know.

Best regards,
Alexandru

