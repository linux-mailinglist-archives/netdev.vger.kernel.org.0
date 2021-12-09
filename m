Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CB1746E5EF
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 10:50:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231481AbhLIJyC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 04:54:02 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:7850 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231328AbhLIJyB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 04:54:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1639043429; x=1670579429;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=t3Qy4GfOU/53oJwtNxwcyeVDIIhug4oc/HuZUlRKQy8=;
  b=lxf8Js7ZcXWS76IlD9naBVXAEJ+k4dw/w39meoarROIDvTmeMBRTm7re
   EVmZnkaFkigZ70lAL4JpIAgfNViiEk+JleQGaOg9HYjaz+GSpHGWEaMq4
   XiABMmPJ+SPnAW+1vViSfY8SXs645rDULc7R3DOVaECU7IQRLGZu0kBdj
   0Jfa+I3/2wUJ18S1hAoKeyrfmIcwPKLrdg144EcI/o/9jvIFAKWTwuT+e
   nZOJ435gje3XyhfunVa1B+hZKeHZBiNnDhsMAqDINFy52QvUawsGgh9Yi
   3UxXutr09KrQsywjdnjBCORs0jO2T+2PbAvcfPwx4LJlOO73LcWaXn6BF
   g==;
IronPort-SDR: ORkEKRQl+V2+Mzpn5bHH7DY7JtbsqfD0U75Zx63cLnppZEfkwr9BS6p6A5miQgAu1ZikBrYawN
 L9PpRP9JugrLPLzz/jlIP5g+5C1Cz9UxwwwUg8lWE3qGqKg/Iuv+1c0Sx4gBlG0GXQP+6e7rtU
 iBOtS4SDK8qv2aYgyKJ2fXhPhNLWh/yxlTs3fg2qiEzz3MDl5GRe3ASzshOks6Fd9EHWBX4P+9
 P6EL1eFx3AIVQSQ6fJ+8z08FB7+9j66uq/wiCOPbf136f7VyfZQ8bk45RNVIi3bYhVP7pOybM2
 eeoIkNfWa1CNCPp2F+/mHP31
X-IronPort-AV: E=Sophos;i="5.88,192,1635231600"; 
   d="scan'208";a="146639655"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Dec 2021 02:50:28 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Thu, 9 Dec 2021 02:50:28 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Thu, 9 Dec 2021 02:50:28 -0700
Date:   Thu, 9 Dec 2021 10:52:26 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "Andrew Lunn" <andrew@lunn.ch>, <davem@davemloft.net>,
        <robh+dt@kernel.org>, <UNGLinuxDriver@microchip.com>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v2 0/6] net: lan966x: Add switchdev and vlan
 support
Message-ID: <20211209095226.4ov3zqnwwc4ftqsy@soft-dev3-1.localhost>
References: <20211207124838.2215451-1-horatiu.vultur@microchip.com>
 <20211208181712.37c41155@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20211208181712.37c41155@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 12/08/2021 18:17, Jakub Kicinski wrote:
> 
> On Tue, 7 Dec 2021 13:48:32 +0100 Horatiu Vultur wrote:
> > This patch series extends lan966x with switchdev and vlan support.
> > The first patches just adds new registers and extend the MAC table to
> > handle the interrupts when a new address is learn/forget.
> > The last 2 patches adds the vlan and the switchdev support.
> 
> Anyone willing to venture a review?

In case someone will have a look at this, I have sent a new version (v3)
where I have cc everyone in this email thread.


-- 
/Horatiu
