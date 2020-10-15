Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 690FE28F138
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 13:28:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729718AbgJOL2n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 07:28:43 -0400
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:9049 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728111AbgJOL14 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Oct 2020 07:27:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1602761276; x=1634297276;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=k9yQOQDUXV3I2m/wrCWuOI9bnOjBykltesKYm7FGj/s=;
  b=gynivXkWrvmulGvao/5hdAduBP5V4YhwPNBsolKKcffmGpFSOLAYGiY7
   vyNvv8UMeqF1PkIfYH4R97nl/5XUbor+yHGYwgZA1O3kTWFlTPrNLSMMe
   SUFQcT+pOCkWX7P/MPeuJmmgku+MKUv4i41uCJMmefqLnN4+pZIpwcplt
   dnAKPk5KUF/gIROw7ec6AyZwMEV4dkjR+QjmWvA5T3UQDm5X2EeRL7lrS
   rhtrntMZQHRpY7DC77SaGMe1fkZ7TVgWEBvxqzzHKc7qyJW29CvZz4wF2
   QE9XEmrpwDAm5oKrYToBNBeZZtRXitxRGtkxXLAauF9OAcWNWIsJfvnue
   w==;
IronPort-SDR: EsgFogAKV7dNOJBp+NDOihk/kb75ZQgUoZroWJFdBxQ7eN0Bo7Iap1YqE9twb7+sT36ApfHxm8
 FQxELOd0NBhIsLyj4Zrh+vY3AXx2hbaJt+/aSVXQkHdF9tWnFtS7/ok8/jgvRfDyG7YcNGf9QR
 lLaZ3P92k0F+DU85XMRDXIvZMEN69NZz5FDJBk8sjbAqQ58Ipk+XxSKv2xfhvzNW17t9fT7jc0
 MSb9aGCBxtjKqd5LkMS4uu2AG2TSqELvaen286tfcGaOB2bLIH+enVrTQ8f1k8QlcI5Tbu1rE2
 4PA=
X-IronPort-AV: E=Sophos;i="5.77,378,1596524400"; 
   d="scan'208";a="94714953"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 15 Oct 2020 04:27:56 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 15 Oct 2020 04:27:54 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Thu, 15 Oct 2020 04:27:54 -0700
Date:   Thu, 15 Oct 2020 11:26:14 +0000
From:   Henrik Bjoernlund <henrik.bjoernlund@microchip.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <roopa@nvidia.com>, <nikolay@nvidia.com>,
        <jiri@mellanox.com>, <idosch@mellanox.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>,
        <UNGLinuxDriver@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: Re: [PATCH net-next v5 04/10] bridge: cfm: Kernel space
 implementation of CFM. MEP create/delete.
Message-ID: <20201015112614.zppuogx6j44ldqh6@soft-test08>
References: <20201012140428.2549163-1-henrik.bjoernlund@microchip.com>
 <20201012140428.2549163-5-henrik.bjoernlund@microchip.com>
 <20201014163018.0c2a4fc7@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20201014163018.0c2a4fc7@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for your review. Comments below.
Regards
Henrik

The 10/14/2020 16:30, Jakub Kicinski wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> On Mon, 12 Oct 2020 14:04:22 +0000 Henrik Bjoernlund wrote:
> > +     if (config->mdlevel > 7) {
> > +             NL_SET_ERR_MSG_MOD(extack,
> > +                                "MD level is invalid");
> > +             return -EINVAL;
> > +     }
> > +     /* The MEP-ID is a 13 bit field in the CCM PDU identifying the MEP */
> > +     if (config->mepid > 0x1FFF) {
> > +             NL_SET_ERR_MSG_MOD(extack,
> > +                                "MEP-ID is invalid");
> > +             return -EINVAL;
> > +     }
> 
> If I'm reading patch 7 correctly these parameters come from netlink,
> right? In that case please use the netlink policies to check things
> like ranges or correct values.

I have changed as requested.

-- 
/Henrik
