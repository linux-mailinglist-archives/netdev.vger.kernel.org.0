Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8975628B5AE
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 15:13:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388013AbgJLNNA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 09:13:00 -0400
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:3146 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730509AbgJLNNA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 09:13:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1602508380; x=1634044380;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=WDNT8T0chASPmyuQTDcnmhl3GRuR4J/TIt+goiJGxHc=;
  b=cShTrUwyhlwIinKqzMf46ngu4thJ5t5NDQEP42mDm+BHz18azEo09E4L
   gbGvG9NE0FAfhWP1gYiGcuq43wI9ycj7UrL4VbWpufrLr6EV1DSg171LE
   xl3fQA/YAJytjuT/YeCvQ1nyeWPyRrGhJX2oN9jlSI5tMJvyywgdttOmL
   lxBhEeUPuuFIQH6AYmzCy3WJY1rvd2aJUVuN0w8/bRAZGfHq5Z2+rGF21
   VOqrNc2+GDGC43ZXpxv0CyHcKop4HMGcdPUdAOrXI7BseNpE5a55Ojbkn
   Ykf7V/Bnvquqv4OFpvSmcPG0gjYNoMS5o6FZTqdQD3hV/IWh7wEpTsGz7
   w==;
IronPort-SDR: jMAa8hS83ioD4sD46XKD3RoH7LywRyVayGQX1U+vaezL7QA25B5lS8nFCQBejZI/zeVq8uScE2
 5zNdKxY+7g0bILYTevndOj3+NKVyXk9pX3rTPxB6rbCfj0LTHvlGOH9sIsdh6WQnGOkNj6xIsU
 CE68sDrBqkHz9xQ1xO/6nxHXA7uKK442u7MzIxA/JP/gFPrpu4JGoDUBizY8r/LlgH0v74tUNt
 S9DQBWvRKK+W7m8pagLb3RQLd0WA4mLXURkaZ1LnAGXP5EDqUjBzHHHL4e7kq3T+IiRFVjNptA
 pMw=
X-IronPort-AV: E=Sophos;i="5.77,366,1596524400"; 
   d="scan'208";a="94260662"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Oct 2020 06:13:00 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 12 Oct 2020 06:12:59 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Mon, 12 Oct 2020 06:12:59 -0700
Date:   Mon, 12 Oct 2020 13:11:13 +0000
From:   "henrik.bjoernlund@microchip.com" <henrik.bjoernlund@microchip.com>
To:     Nikolay Aleksandrov <nikolay@nvidia.com>
CC:     "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        "idosch@mellanox.com" <idosch@mellanox.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "horatiu.vultur@microchip.com" <horatiu.vultur@microchip.com>
Subject: Re: [PATCH net-next v4 06/10] bridge: cfm: Kernel space
 implementation of CFM. CCM frame RX added.
Message-ID: <20201012131113.p54op2ku7r4l54bv@soft-test08>
References: <20201009143530.2438738-1-henrik.bjoernlund@microchip.com>
 <20201009143530.2438738-7-henrik.bjoernlund@microchip.com>
 <2ec76c98813c8190ced9e34b70b46d2dad94d714.camel@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <2ec76c98813c8190ced9e34b70b46d2dad94d714.camel@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for the review.

The 10/09/2020 21:52, Nikolay Aleksandrov wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> On Fri, 2020-10-09 at 14:35 +0000, Henrik Bjoernlund wrote:
> > This is the third commit of the implementation of the CFM protocol
> > according to 802.1Q section 12.14.
> >
> > Functionality is extended with CCM frame reception.
> > The MEP instance now contains CCM based status information.
> > Most important is the CCM defect status indicating if correct
> > CCM frames are received with the expected interval.
> >
> > Signed-off-by: Henrik Bjoernlund  <henrik.bjoernlund@microchip.com>
> > Reviewed-by: Horatiu Vultur  <horatiu.vultur@microchip.com>
> > ---
> >  include/uapi/linux/cfm_bridge.h |  10 ++
> >  net/bridge/br_cfm.c             | 269 ++++++++++++++++++++++++++++++++
> >  net/bridge/br_private_cfm.h     |  32 ++++
> >  3 files changed, 311 insertions(+)
> >
> 
> Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>
> 
> 

-- 
/Henrik
