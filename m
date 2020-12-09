Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FCDF2D43BF
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 15:01:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732719AbgLIOAg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 09:00:36 -0500
Received: from mta-02.yadro.com ([89.207.88.252]:54180 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728541AbgLIOAb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Dec 2020 09:00:31 -0500
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 84595412D0;
        Wed,  9 Dec 2020 13:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :x-mailer:message-id:date:date:subject:subject:from:from
        :received:received:received; s=mta-01; t=1607522385; x=
        1609336786; bh=LtEwQr607pb2Yng6ZB5puQAfklphP2HMsQC9LGAQ5ak=; b=b
        rbS8joU0P2khd8vLyglphVBDGyjJuo2wlPtbQJx73NtWwUCcBVxuTQo37tca7vAQ
        YhdSsKcKu5apjiwZmv7HIcBqqfywOjiC0DN2aUtkKCrJYg2IIyDtZr5MFyF4Wnqv
        ahgOv0n/FZXd+81wbJwkZPM09t6lKBVbiUMA3MQZ8A=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id OJXlTB2a5lsQ; Wed,  9 Dec 2020 16:59:45 +0300 (MSK)
Received: from T-EXCH-03.corp.yadro.com (t-exch-03.corp.yadro.com [172.17.100.103])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 498BE41203;
        Wed,  9 Dec 2020 16:59:43 +0300 (MSK)
Received: from localhost.dev.yadro.com (10.199.0.125) by
 T-EXCH-03.corp.yadro.com (172.17.100.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Wed, 9 Dec 2020 16:59:42 +0300
From:   Ivan Mikhaylov <i.mikhaylov@yadro.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
CC:     Ivan Mikhaylov <i.mikhaylov@yadro.com>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2] Add LED mode behavior/select properties and handle
Date:   Wed, 9 Dec 2020 17:04:59 +0300
Message-ID: <20201209140501.17415-1-i.mikhaylov@yadro.com>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.199.0.125]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-03.corp.yadro.com (172.17.100.103)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In KSZ9131 PHY it is possible to control LEDs blink behavior via
LED mode behavior and select registers. Add DTS properties plus handles
of them inside micrel PHY driver.

I've some concerns about passing raw register values into LED mode
select and behavior. It can be passed via array like in microchip
driver(Documentation/devicetree/bindings/net/microchip,lan78xx.txt).
There is the problem in this particular driver - there is a lot of other PHYs
and led mode behavior/select states may intersect, that's the reason why
I did it this way. Is there any good ways to make it look more properly?

Ivan Mikhaylov (2):
  net: phy: micrel: add LED control on KSZ9131
  dt-bindings: net: phy: micrel: add LED mode behavior and select
    properties

 .../devicetree/bindings/net/micrel.txt        |  7 ++
 drivers/net/phy/micrel.c                      | 69 ++++++++++++++++++-
 2 files changed, 75 insertions(+), 1 deletion(-)

-- 
2.21.1

