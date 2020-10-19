Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAA042923F0
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 10:52:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729415AbgJSIwj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 04:52:39 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:21254 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729287AbgJSIwj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 04:52:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1603097558; x=1634633558;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=tJ/a1JvUOjBjoPtEuJeWoMkuf2rsk+6hMQF3y1Sz3mw=;
  b=qMeEnYvdXeZAw3yedp76hOAh+rTbpXp+oJIsZnoDFSWkwqF4xEGevHO3
   87cxwYnGZ2CD69MSj0SZEJaaW0JMiLh/NXhjltZrZK3jl6VCrEJrHYfr9
   73RkfI9FyWY/IWdwSyxZuBJtZ2B5vrq3WpOBwxJ3M8yr2tWpY6dmKqbJf
   3OmIgJnE1YDFczeB4XjcgkjPrB6ohVUWYGv2G/E55gDi7qkaB32/jdMWV
   5g77R7WZLeX81wpsENGe6Tr60uTNUpQj5P4JmMM/ZwJU68pX0TZqVqE4P
   S05IP+8RvDYgUVPbNZU1OdIZ6OyHAlFVvPKreRff7BHqRG9B9p8sSaQcj
   Q==;
IronPort-SDR: Xjs9Y3nloL7WeTI9F5WakznkLOCdoQdi1582lAkA0C7Z3S3NKwTvCbzEPATNuv0L+l91fVjIup
 1hGemwGMGYLlkpB5IMAWkINGC0nS0m09CNxRpnQTytqAs7ALTMO7G9mGUbYmVOb5totGOv5V7I
 3yUw/zibH+ZYyDYHkm3J6CS3tRhpG09ITAYLvxLZx/AbGpEiAr+3Eq68WUBfwoqfbOHH50/3pc
 Us8gACj93lDBn0dqEFwb3ylt4zn/wiz68gwccDHNIKO/nSy7F9YuFjgdEemoNIDKea61vCmESG
 SzI=
X-IronPort-AV: E=Sophos;i="5.77,394,1596524400"; 
   d="scan'208";a="93092731"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 19 Oct 2020 01:52:38 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 19 Oct 2020 01:52:37 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Mon, 19 Oct 2020 01:52:37 -0700
Date:   Mon, 19 Oct 2020 08:51:04 +0000
From:   Henrik Bjoernlund <henrik.bjoernlund@microchip.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <roopa@nvidia.com>, <nikolay@nvidia.com>,
        <jiri@mellanox.com>, <idosch@mellanox.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>,
        <UNGLinuxDriver@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: Re: [PATCH net-next v6 07/10] bridge: cfm: Netlink SET configuration
 Interface.
Message-ID: <20201019085104.2hkz2za2o2juliab@soft-test08>
References: <20201015115418.2711454-1-henrik.bjoernlund@microchip.com>
 <20201015115418.2711454-8-henrik.bjoernlund@microchip.com>
 <20201015103431.25d66c8b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20201015103431.25d66c8b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thank you for the review. Comments below.

The 10/15/2020 10:34, Jakub Kicinski wrote:
> 
> On Thu, 15 Oct 2020 11:54:15 +0000 Henrik Bjoernlund wrote:
> > +     [IFLA_BRIDGE_CFM_MEP_CONFIG_MDLEVEL]     = {
> > +     .type = NLA_U32, .validation_type = NLA_VALIDATE_MAX, .max = 7 },
> 
>         NLA_POLICY_MAX(NLA_U32, 7)

I will change as requested.

> 
> Also why did you keep the validation in the code in patch 4?

In patch 4 there is no CFM NETLINK so I desided to keep the validation in the
code until NETLINK was added that is now doing the check.
I this a problem?

-- 
/Henrik
