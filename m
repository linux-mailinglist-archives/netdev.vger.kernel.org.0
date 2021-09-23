Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1527416087
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 16:06:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241610AbhIWOH3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 10:07:29 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:8800 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241609AbhIWOH1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 10:07:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1632405956; x=1663941956;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Xm1lP2y/11ilMNWi3xkQEqEAdzIENBIegi0I3QPthos=;
  b=YG8iU6Jgi3VlI/gCXbq5vnF+AxmAArjtVCKPbso0BflX0FzORMoLDCAt
   XOu21oGNfENGa6TcughzwifRQ4FVpz5RTxMwPDvJ5SlRKPqKeKK8kq2cL
   VgYm6HLsSms7vKIDIBexLfA9FtTJvjn/jrtnTDWlgYfkZZoK8fidPZbGD
   XTQ87k36uxPk1SAIV4QwwtyoHj6WF8ckrVJ1xPH87QhFcqWmnRJYtqNV2
   zSKT1a6N4XwFkeyxn1wM4WkrHo64k+8oBm8WvRnIHfMm4ODw21xrqpXJz
   6Go8u82++LwVhjXeDptlGz2Z5y65zKx8G82VGyw5gFbluy9BDAalDQu/K
   w==;
IronPort-SDR: m/ytTCdZt7mgPIdh4BAhZlbgRKUEQ2yxZobR+viycboR+J5hM5wJHxQqgI6Bi0bljKErYPfHrm
 EQ1nKSqKWk6TxBHNMZxguMcXEodqU0n+mEJnGSXTGsk8qI9tYwdD9aKGLvmgfJR1yz/EqXbfmM
 KTEgs18AozO99u/yzuhONhRvcpgxz/OfnH42I0zjqYLoW5Agxpwwql28xdahfJfAseQ8NsvK54
 Pa0KsGlTEJzVgKl7LSLYHhdFfUU59c4ba1yWfnYaCQp3sY7xAMXDiOq2H9AxAqsQYI4DJhuWGp
 RaB6EJNq4JYNYpdiqIXeSS/8
X-IronPort-AV: E=Sophos;i="5.85,316,1624345200"; 
   d="scan'208";a="137669681"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 23 Sep 2021 07:05:55 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Thu, 23 Sep 2021 07:05:55 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2176.14 via Frontend
 Transport; Thu, 23 Sep 2021 07:05:54 -0700
Date:   Thu, 23 Sep 2021 16:07:11 +0200
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
CC:     Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "allan.nielsen@microchip.com" <allan.nielsen@microchip.com>,
        "joergen.andreasen@microchip.com" <joergen.andreasen@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        "vishal@chelsio.com" <vishal@chelsio.com>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "idosch@mellanox.com" <idosch@mellanox.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "kuba@kernel.org" <kuba@kernel.org>, Po Liu <po.liu@nxp.com>,
        Leo Li <leoyang.li@nxp.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: Re: [PATCH v4 net-next 7/8] net: mscc: ocelot: use index to set vcap
 policer
Message-ID: <20210923140711.crw3eqnlg7smomqs@soft-dev3-1.localhost>
References: <20210922105202.12134-1-xiaoliang.yang_1@nxp.com>
 <20210922105202.12134-8-xiaoliang.yang_1@nxp.com>
 <20210922131837.ocuk34z3njf5k3yp@skbuf>
 <DB8PR04MB578599F04A8764034485CE89F0A39@DB8PR04MB5785.eurprd04.prod.outlook.com>
 <20210923073059.wbzukwaiyylel72x@soft-dev3-1.localhost>
 <20210923092226.nmin3abnrilmu6rj@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20210923092226.nmin3abnrilmu6rj@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 09/23/2021 09:22, Vladimir Oltean wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> On Thu, Sep 23, 2021 at 09:30:59AM +0200, Horatiu Vultur wrote:
> > > In commit commit b596229448dd ("net: mscc: ocelot: Add support for tcam"), Horatiu Vultur define the max number of policers as 383:
> > > +#define OCELOT_POLICER_DISCARD 0x17f
> > > VCAP IS2 use this policer to set drop action. I did not change this and set the VCAP policers with 128-191 according to the VSC7514 document.
> > >
> > > I don't know why 383 was used as the maximum value of policer in the original code. Can Microchip people check the code or the documentation for errors?
> >
> > It was defined as 383 because the HW actually support this number of
> > policers. But for this SKU it is recomended to use 191, but no one will
> > stop you from using 383.
> 
> So if it is recommended to use 191, why did you use 383? Should Xiaoliang
> change that to 191, or leave it alone?

I think is better to leave it alone. I am not aware of doing any hard if
the value is 383.

> 
> > > > Also, FWIW, Seville has this policer allocation:
> > > >
> > > >       0 ----+----------------------+
> > > >             |  Port Policers (11)  |
> > > >      11 ----+----------------------+
> > > >             |  VCAP Policers (21)  |
> > > >      32 ----+----------------------+
> > > >             |   QoS Policers (88)  |
> > > >     120 ----+----------------------+
> > > >             |  VCAP Policers (43)  |
> > > >     162 ----+----------------------+
> > >
> > > I didn't find Seville's document, if this allocation is right, I will add it in Seville driver.
> 
> Strange enough, I don't remember having reports about the VCAP IS2
> policers on Seville not working, and of course being in the common code,
> we'd start with a count of 384 policers for that hardware too, and
> counting from the end. I think I even tested the policers when adding
> the VCAP IS2 constants, and they worked. Is there any sort of index
> wraparound that takes place?

I don't think there is any wraparound.

-- 
/Horatiu
