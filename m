Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3B0F4AF60D
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 17:07:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236553AbiBIQHW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 11:07:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236511AbiBIQHV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 11:07:21 -0500
X-Greylist: delayed 3905 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 09 Feb 2022 08:07:22 PST
Received: from mx0a-00128a01.pphosted.com (mx0a-00128a01.pphosted.com [148.163.135.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47B6CC0613C9;
        Wed,  9 Feb 2022 08:07:22 -0800 (PST)
Received: from pps.filterd (m0167089.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 219EELie022353;
        Wed, 9 Feb 2022 10:01:32 -0500
Received: from nwd2mta4.analog.com ([137.71.173.58])
        by mx0a-00128a01.pphosted.com (PPS) with ESMTPS id 3e46jbtae8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Feb 2022 10:01:32 -0500
Received: from ASHBMBX9.ad.analog.com (ASHBMBX9.ad.analog.com [10.64.17.10])
        by nwd2mta4.analog.com (8.14.7/8.14.7) with ESMTP id 219F1VUx056491
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 9 Feb 2022 10:01:31 -0500
Received: from ASHBMBX9.ad.analog.com (10.64.17.10) by ASHBMBX9.ad.analog.com
 (10.64.17.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.14; Wed, 9 Feb 2022
 10:01:30 -0500
Received: from zeus.spd.analog.com (10.66.68.11) by ashbmbx9.ad.analog.com
 (10.64.17.10) with Microsoft SMTP Server id 15.2.986.14 via Frontend
 Transport; Wed, 9 Feb 2022 10:01:30 -0500
Received: from localhost.localdomain ([10.48.65.12])
        by zeus.spd.analog.com (8.15.1/8.15.1) with ESMTP id 219F1BGV030677;
        Wed, 9 Feb 2022 10:01:14 -0500
From:   <alexandru.tachici@analog.com>
To:     <o.rempel@pengutronix.de>
CC:     <alexandru.tachici@analog.com>, <andrew@lunn.ch>,
        <davem@davemloft.net>, <devicetree@vger.kernel.org>,
        <hkallweit1@gmail.com>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux@armlinux.org.uk>,
        <netdev@vger.kernel.org>, <robh+dt@kernel.org>
Subject: Re: [PATCH v4 4/7] net: phy: Add 10BASE-T1L support in phy-c45
Date:   Wed, 9 Feb 2022 17:12:20 +0200
Message-ID: <20220209151220.15154-1-alexandru.tachici@analog.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220207092753.GC23727@pengutronix.de>
References: <20220207092753.GC23727@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
X-ADIRuleOP-NewSCL: Rule Triggered
X-Proofpoint-ORIG-GUID: ecP3ea8MbRQPPDOZEkuMGLmXug0406tG
X-Proofpoint-GUID: ecP3ea8MbRQPPDOZEkuMGLmXug0406tG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-09_08,2022-02-09_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxlogscore=793
 priorityscore=1501 adultscore=0 lowpriorityscore=0 malwarescore=0
 suspectscore=0 impostorscore=0 bulkscore=0 clxscore=1011 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202090085
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Sat, Dec 11, 2021 at 10:07:49PM +0100, Andrew Lunn wrote:
> > > +		ret = phy_read_mmd(phydev, MDIO_MMD_PMAPMD, MDIO_PMA_EXTABLE);
> > > +		if (ret < 0)
> > > +			return ret;
> > > +
> > > +		if (ret & MDIO_PMA_EXTABLE_BT1)
> > 
> > 
> > This pattern of reading the MDIO_PMA_EXTABLE register and then looking
> > for bit MDIO_PMA_EXTABLE_BT1 happens a lot. It is not something which
> > is expected to change is it? So i wounder if it should be read once
> > and stored away?
> 
> What is the state of this patches? Will you be able to make requested
> changes and send new version?

I will come back with a V5 where I will add the requested changes.

Regards,
Alexandru
