Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 746CF28F14E
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 13:30:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729679AbgJOLaG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 07:30:06 -0400
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:21716 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728569AbgJOLaE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Oct 2020 07:30:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1602761403; x=1634297403;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=KQhsyXAMn7AN17uLkcxZ/87dpZXLNz6fwDSYmoiJKHY=;
  b=BxYqeTlg9l0jyp7RBGwaDf+9OoAIfJFlClWJ1Wg2cmfyvKxv8m17HG7Z
   xUv1Ewg7QYALNiVyRJKAayh1glqShxTjgGYV1/9CeXsQOII++FTUcysNF
   LiJgQLZmpaU5jjTsJh1K3dShMiBJSr0i2vUtXgHxZWxDdrbsDwoLCi5n/
   siK4RJ+tR7W2u2Irjp5OI16PLH8Fg2pvBHbyAp+xrEH9d1A6wn8h+wx3D
   sGQuYERSDbcIaeCON8Jd4wLMitBDe+YExDSU1VD9ShzMcHfRLP+91pWg7
   R/YYQXX+L4dr5pMNIn1U1RYmezaNeCzAWKK6hLchN+q5RiaNrNJxvHkg1
   g==;
IronPort-SDR: aDj8Gtvpx8gfgHH52gA6xlunJ54HsZMenp7Qxyj78Y1Ihwbgrqz26jaXm/ttUkXYilL4wcHOjn
 /LWNIMRoNIKiE5WFT8MqJGHggMvu6o5D8p/NfZiPde3O2UT2DrPu1SplcHrmnPlcTj09FcvR1s
 R88XE0PjBfIf68MzzB94FqVDDlrEcG9JFK5lhk+CARpH2N4GoqPfp+kuHqzhGYencTyKtcPIA6
 j3OFkoBWjrhjWc1rAvswKhQdfThWb1Q0Aym5Uhu6y0wDq0v69/2NxpqIuAdeRHDKPnJg/fh4tm
 gl4=
X-IronPort-AV: E=Sophos;i="5.77,378,1596524400"; 
   d="scan'208";a="99624733"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 15 Oct 2020 04:30:03 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 15 Oct 2020 04:30:02 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Thu, 15 Oct 2020 04:30:02 -0700
Date:   Thu, 15 Oct 2020 11:28:22 +0000
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
Message-ID: <20201015112822.adfl5kpgffgzi3wg@soft-test08>
References: <20201012140428.2549163-1-henrik.bjoernlund@microchip.com>
 <20201012140428.2549163-7-henrik.bjoernlund@microchip.com>
 <20201014161610.46dd5785@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20201014161610.46dd5785@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for your review. Comments below.
Regards
Henrik

The 10/14/2020 16:16, Jakub Kicinski wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> On Mon, 12 Oct 2020 14:04:24 +0000 Henrik Bjoernlund wrote:
> > +struct br_cfm_status_tlv {
> > +     __u8 type;
> > +     __be16 length;
> > +     __u8 value;
> > +};
> 
> This structure is unused (and likely not what you want, since it will
> have 2 1 byte while unless you mark length as __packed).

I have changed as requested.

-- 
/Henrik
