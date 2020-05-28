Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4BDB1E70A8
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 01:46:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437716AbgE1Xqb convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 28 May 2020 19:46:31 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2256 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2437677AbgE1Xq1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 19:46:27 -0400
Received: from lhreml704-chm.china.huawei.com (unknown [172.18.7.108])
        by Forcepoint Email with ESMTP id 3416019FFA0122A31601;
        Fri, 29 May 2020 00:46:25 +0100 (IST)
Received: from lhreml703-chm.china.huawei.com (10.201.108.52) by
 lhreml704-chm.china.huawei.com (10.201.108.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Fri, 29 May 2020 00:46:24 +0100
Received: from lhreml703-chm.china.huawei.com ([10.201.68.198]) by
 lhreml703-chm.china.huawei.com ([10.201.68.198]) with mapi id 15.01.1913.007;
 Fri, 29 May 2020 00:46:24 +0100
From:   Salil Mehta <salil.mehta@huawei.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        tanhuazhong <tanhuazhong@huawei.com>
CC:     David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Zhuangyuzeng (Yisen)" <yisen.zhuang@huawei.com>,
        Linuxarm <linuxarm@huawei.com>
Subject: RE: [PATCH V2 net-next 0/2] net: hns3: adds two VLAN feature
Thread-Topic: [PATCH V2 net-next 0/2] net: hns3: adds two VLAN feature
Thread-Index: AQHWL2SRCDH7TdC4jUyLacrsUtfjv6iy2UmAgAAnNACAAMiEAIAHZXCAgAEck4CAAbd90A==
Date:   Thu, 28 May 2020 23:46:24 +0000
Message-ID: <a3129e7c11e94b2ca2acf77bc08284a2@huawei.com>
References: <1590061105-36478-1-git-send-email-tanhuazhong@huawei.com>
        <20200521121707.6499ca6b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200521.143726.481524442371246082.davem@davemloft.net>
        <cb427604-05ee-504c-03d0-fcce16b3cfcc@huawei.com>
        <356be994-7cf9-e7b2-8992-46a70bc6a54b@huawei.com>
 <20200527123031.7fd4834d@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20200527123031.7fd4834d@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.47.29.93]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub/David,

> From: Jakub Kicinski [mailto:kuba@kernel.org]
> Sent: Wednesday, May 27, 2020 8:31 PM
> To: tanhuazhong <tanhuazhong@huawei.com>
> Cc: David Miller <davem@davemloft.net>; netdev@vger.kernel.org;
> linux-kernel@vger.kernel.org; Salil Mehta <salil.mehta@huawei.com>;
> Zhuangyuzeng (Yisen) <yisen.zhuang@huawei.com>; Linuxarm <linuxarm@huawei.com>
> Subject: Re: [PATCH V2 net-next 0/2] net: hns3: adds two VLAN feature
> 
> On Wed, 27 May 2020 10:31:59 +0800 tanhuazhong wrote:
> > Hi, Jakub & David.
> >
> > For patch#1, is it acceptable adding "ethtool --get-priv-flags"
> > to query the VLAN. If yes, I will send a RFC for it.
> 
> The recommended way of implementing vfs with advanced vlan
> configurations is via "switchdev mode" & representors.

AFAIK, switchdev ops only facilitates the standard abstract
interface to any underlying standard or proprietary hardware
which could be ASIC, eswitch etc. Therefore, standard tools
like ip, bridge or even stacks like FRR etc. could be used
while leveraging the below hardware forwarding.

Not sure how will switchdev ops will be of help here?


Just curious how does Mellanox supports Hybrid port mode?

In general, 
We can have port being configured as Access/Trunk ports.

Access port = Only untagged packets are sent or are expected.
                RX'ed Tagged packets are dropped.
Trunk Port  = Only Tagged packet are received or sent and any
                Untagged packets received are dropped.

Mellanox also support Hybrid mode in Onyx platform:

Hybrid - packets are sent tagged or untagged, the port
expects both tagged and untagged packets. This mode is
a combination of Access and Trunk modes. There is an
option to configure multiple VLANs on the hybrid port.
PVID is configured on the port for untagged ingress
packets.

First two configuration are easy to realize using the
standard Linux configuration tools like ip/bridge but
not sure about the hybrid? also, why do we even need
to create a bridge to realize any of above port modes?

Note: HNS hardware does not have eswitch support.


Salil.

