Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65AE628F13D
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 13:29:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729788AbgJOL3r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 07:29:47 -0400
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:21622 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729543AbgJOL3R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Oct 2020 07:29:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1602761356; x=1634297356;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=7EnMnyHDlxSioQWuwItYVnheB1FER3TeFm6RMS/adn4=;
  b=dAcjAu1Y97wQ9r7hbYoJ1/wITFVACk2+YQohuZVgZsnJySDYZQMlWR1I
   s5VmAqRGQuyTsxSI3pW8jQPb4oOyPSo9XbRDrUst2cgrX84x24A3jViXM
   H95mN3iaqmQ84cJhY0JA6+5t3aIWe5m2GnzHoeJ95cGKs5foM03a3WURJ
   ceOSJTqOoYw0PjA47DFswLKsWyBFaCbtLHFE2JFUl1gtcPIwHvrEmjYth
   nAvPyyNSTpif2zBONYRaTSAIl+pqygMbaSDsxqAwtVb00mqTyER6D7oTQ
   oKUREtsBDFr+6LL+xk5RuOyQJuBjf1UEhqUUW+BBsVP/u6hKS0TZwbABX
   w==;
IronPort-SDR: rqczGmyF/adutI1bxyM8+BL3JcbEmb6ibjJcGJB1ctc1Umys+2Fx0drIfyLLIiC8trUzhBU4pr
 /YwuBwzCmSsLImr34UzFXMMBHy0jtIc+BJox0jZr+C1R5Zj4l2MGFRRlI7WceiwgPvUsU6mun6
 KQGwoGpG++QYtj+4fDOK9WsQKMdawCohy2YUc5j0geuAaCIpl3QscYdU8/5FmwnbdWt+7ZRFNd
 gQj/MuZn/dXpl3WJgxAReUAW9b0CxLMQLLqs9aJVW5lMuPFgZIH57RpBiLHZ214Q5E+O1TOOzs
 0nA=
X-IronPort-AV: E=Sophos;i="5.77,378,1596524400"; 
   d="scan'208";a="99624569"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 15 Oct 2020 04:29:16 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 15 Oct 2020 04:29:16 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Thu, 15 Oct 2020 04:29:15 -0700
Date:   Thu, 15 Oct 2020 11:27:35 +0000
From:   Henrik Bjoernlund <henrik.bjoernlund@microchip.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <roopa@nvidia.com>, <nikolay@nvidia.com>,
        <jiri@mellanox.com>, <idosch@mellanox.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>,
        <UNGLinuxDriver@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: Re: [PATCH net-next v5 06/10] bridge: cfm: Kernel space
 implementation of CFM. CCM frame RX added.
Message-ID: <20201015112735.fi2aauhyqt5ahlh2@soft-test08>
References: <20201012140428.2549163-1-henrik.bjoernlund@microchip.com>
 <20201012140428.2549163-7-henrik.bjoernlund@microchip.com>
 <20201014162655.3cbc8664@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20201014162655.3cbc8664@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for your review. Comments below.
Regards
Henrik

The 10/14/2020 16:26, Jakub Kicinski wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> On Mon, 12 Oct 2020 14:04:24 +0000 Henrik Bjoernlund wrote:
> > +     /* This CCM related status is based on the latest received CCM PDU. */
> > +     u8 port_tlv_value; /* Port Status TLV value */
> > +     u8 if_tlv_value; /* Interface Status TLV value */
> > +
> > +     /* CCM has not been received for 3.25 intervals */
> > +     bool ccm_defect;
> > +
> > +     /* (RDI == 1) for last received CCM PDU */
> > +     bool rdi;
> > +
> > +     /* Indications that a CCM PDU has been seen. */
> > +     bool seen; /* CCM PDU received */
> > +     bool tlv_seen; /* CCM PDU with TLV received */
> > +     /* CCM PDU with unexpected sequence number received */
> > +     bool seq_unexp_seen;
> 
> Please consider using a u8 bitfield rather than a bunch of bools,
> if any of this structures are expected to have many instances.
> That'd save space.

I have changed as requested.

-- 
/Henrik
