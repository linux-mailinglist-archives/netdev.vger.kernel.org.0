Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 935592531B4
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 16:45:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726988AbgHZOpD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 10:45:03 -0400
Received: from alln-iport-4.cisco.com ([173.37.142.91]:20967 "EHLO
        alln-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726700AbgHZOpA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 10:45:00 -0400
X-Greylist: delayed 428 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Aug 2020 10:44:59 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=1372; q=dns/txt; s=iport;
  t=1598453099; x=1599662699;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=9yim39Oi0ab7s77M3U/AMtE/O7yogxRbNiyxIf6affk=;
  b=OsCV4udQ9nZnyesUVxoFlIYnZF3T88Tvi4xmZDHNhNVJ/F76V6XBRsDx
   acfBAcN8L0ohhj+P/Xgjvg3TNJjgmUTbI02BnweVdEMn48IpQtowlLxOt
   eGMjJJlJPtXUBi9GpEqpWRu4OIkYL/QpAmUfN0Ka5dkBxoNUrpCCO2hak
   w=;
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0CHCQBRc0Zf/4QNJK1fHgEBCxIMQIM?=
 =?us-ascii?q?/NYFILzaGQ5QSAZckCwEBAQwBAS0CBAEBhEwCgjgCJDgTAgMBAQsBAQUBAQE?=
 =?us-ascii?q?CAQYEbYVohXMGeRACAQgOEyUPIyUCBA6GKLBHdIE0ikiBOI0kG4FBP4QhPoQ?=
 =?us-ascii?q?9hXcEj2mCYwGkAQoggkOaKyGgPrISAhEVgTM4I4FXcBWDJU8XAg2OVo4QgSs?=
 =?us-ascii?q?CBgoBAQMJfI5yAYEQAQE?=
X-IronPort-AV: E=Sophos;i="5.76,356,1592870400"; 
   d="scan'208";a="532081834"
Received: from alln-core-10.cisco.com ([173.36.13.132])
  by alln-iport-4.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 26 Aug 2020 14:37:50 +0000
Received: from XCH-ALN-004.cisco.com (xch-aln-004.cisco.com [173.36.7.14])
        by alln-core-10.cisco.com (8.15.2/8.15.2) with ESMTPS id 07QEbnek013265
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=FAIL);
        Wed, 26 Aug 2020 14:37:50 GMT
Received: from xch-aln-004.cisco.com (173.36.7.14) by XCH-ALN-004.cisco.com
 (173.36.7.14) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 26 Aug
 2020 09:37:49 -0500
Received: from xch-aln-004.cisco.com ([173.36.7.14]) by XCH-ALN-004.cisco.com
 ([173.36.7.14]) with mapi id 15.00.1497.000; Wed, 26 Aug 2020 09:37:49 -0500
From:   "Denys Zagorui -X (dzagorui - GLOBALLOGIC INC at Cisco)" 
        <dzagorui@cisco.com>
To:     David Miller <davem@davemloft.net>
CC:     "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "ap420073@gmail.com" <ap420073@gmail.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] net: core: SIOCADDMULTI/SIOCDELMULTI distinguish
 between uc and mc
Thread-Topic: [PATCH v2] net: core: SIOCADDMULTI/SIOCDELMULTI distinguish
 between uc and mc
Thread-Index: AQHWdL9DX5EiyZGf0UOak/RKEYMGSak9MBOAgA1Ly40=
Date:   Wed, 26 Aug 2020 14:37:49 +0000
Message-ID: <1598452669073.46639@cisco.com>
References: <20200817175224.49608-1-dzagorui@cisco.com>,<20200817.150803.1838250925233891556.davem@davemloft.net>
In-Reply-To: <20200817.150803.1838250925233891556.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [173.38.209.7]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Outbound-SMTP-Client: 173.36.7.14, xch-aln-004.cisco.com
X-Outbound-Node: alln-core-10.cisco.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>This doesn't seem appropriate at all.  If anything UC addresses=0A=
>should be blocked and the Intel driver change reverted.  We have=0A=
>a well defined way to add secondary UC addresses and the MC interfaces=0A=
>are not it.=0A=
=0A=
As I understand by =91well defined way=92 you mean macvlan feature. But mac=
vlan =0A=
is more virtualisation thing where an additional netdevice is created and f=
or each=0A=
skb passed to linux stack hash_lookup is made to find a netdevice to which =
this=0A=
skb belongs to based on mac_dst. In case if someone want to have a network=
=0A=
protocol on top of physical layer (AF_PACKET) where NIC should allow severa=
l uc=0A=
mac addr without enabling promiscuous mode i am not sure that for this simp=
le=0A=
task macvlan is needed.=0A=
=0A=
>Furthermore, even if this was appropriate, "fixing" this only for=0A=
>ethernet is definitely not appropriate.  The fix would need to be able=0A=
>to handle any address type.  Having a generic interface work=0A=
>inconsistently for one link type vs. another is a non-starter.=0A=
=0A=
Maybe overusing multicast api isn=92t the best choice for this purpose, but=
 i noticed=0A=
that it is already overused by i40 for the same purpose, that is why i sugg=
ested=0A=
this diff. Anyway i can add separate ioctls for add/del secondary uc, if th=
is is worth it.=
