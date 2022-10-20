Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74979606124
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 15:11:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230446AbiJTNLK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 09:11:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230401AbiJTNKF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 09:10:05 -0400
Received: from mx0a-00128a01.pphosted.com (mx0a-00128a01.pphosted.com [148.163.135.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A15D175AA;
        Thu, 20 Oct 2022 06:09:35 -0700 (PDT)
Received: from pps.filterd (m0167089.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29KAsCVU003321;
        Thu, 20 Oct 2022 09:09:21 -0400
Received: from nwd2mta4.analog.com ([137.71.173.58])
        by mx0a-00128a01.pphosted.com (PPS) with ESMTPS id 3kb215sxet-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Oct 2022 09:09:12 -0400
Received: from ASHBMBX8.ad.analog.com (ASHBMBX8.ad.analog.com [10.64.17.5])
        by nwd2mta4.analog.com (8.14.7/8.14.7) with ESMTP id 29KD9BIH053247
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 20 Oct 2022 09:09:11 -0400
Received: from ASHBMBX8.ad.analog.com (10.64.17.5) by ASHBMBX8.ad.analog.com
 (10.64.17.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.14; Thu, 20 Oct
 2022 09:09:10 -0400
Received: from zeus.spd.analog.com (10.66.68.11) by ashbmbx8.ad.analog.com
 (10.64.17.5) with Microsoft SMTP Server id 15.2.986.14 via Frontend
 Transport; Thu, 20 Oct 2022 09:09:10 -0400
Received: from tachici-Precision-5530.analog.com ([10.48.65.157])
        by zeus.spd.analog.com (8.15.1/8.15.1) with ESMTP id 29KD8qO2031891;
        Thu, 20 Oct 2022 09:08:57 -0400
From:   Alexandru Tachici <alexandru.tachici@analog.com>
To:     <linux@armlinux.org.uk>
CC:     <alexandru.tachici@analog.com>, <andrew@lunn.ch>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <lennart@lfdomain.com>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <pabeni@redhat.com>
Subject: Re: [net v2 1/1] net: ethernet: adi: adin1110: Fix notifiers
Date:   Thu, 20 Oct 2022 16:08:50 +0300
Message-ID: <20221020130850.18780-1-alexandru.tachici@analog.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <Y1EwzRa3SNpA0++W@shell.armlinux.org.uk>
References: <Y1EwzRa3SNpA0++W@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ADIRuleOP-NewSCL: Rule Triggered
X-Proofpoint-GUID: q-jbGGrNWj4EGzcHz31gSRwm98bQJjXZ
X-Proofpoint-ORIG-GUID: q-jbGGrNWj4EGzcHz31gSRwm98bQJjXZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-20_05,2022-10-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 priorityscore=1501 clxscore=1015 phishscore=0 bulkscore=0 impostorscore=0
 mlxscore=0 malwarescore=0 spamscore=0 mlxlogscore=667 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210200078
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > +
> > +	err = adin1110_setup_notifiers();
> > +	if (err) {
> > +		spi_unregister_driver(&adin1110_driver);
> > +		return err;
> > +	}
>
> And you setup the notifier after, so there is a window when
> notifications could be lost. Is this safe?

At boot time this should be ok. If the module is inserted and then user starts
bridging/bonding etc. will lose some events. Will move notifiers registration
before registering device. Should be fine as the driver checks in all callbacks
if it is meant for him or not the event.

Thanks,
Alexandru
