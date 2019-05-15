Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18C241EA73
	for <lists+netdev@lfdr.de>; Wed, 15 May 2019 10:49:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726487AbfEOItT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 May 2019 04:49:19 -0400
Received: from mail.neratec.com ([46.140.151.2]:37819 "EHLO mail.neratec.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725876AbfEOItT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 May 2019 04:49:19 -0400
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Wed, 15 May 2019 04:49:17 EDT
Received: from localhost (localhost.localdomain [127.0.0.1])
        by mail.neratec.com (Postfix) with ESMTP id F11E7CE03B5;
        Wed, 15 May 2019 10:42:37 +0200 (CEST)
Received: from mail.neratec.com ([127.0.0.1])
        by localhost (mail.neratec.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id c_iS8IbrZwkn; Wed, 15 May 2019 10:42:37 +0200 (CEST)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by mail.neratec.com (Postfix) with ESMTP id CDB08CE03BB;
        Wed, 15 May 2019 10:42:37 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.neratec.com CDB08CE03BB
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=neratec.com;
        s=9F5C293A-195B-11E9-BBA5-B4F3B9D999CA; t=1557909757;
        bh=33k1il0TdXPhz6mNRhtDyUhxSpd8ZUSitH/iFFo4aCQ=;
        h=To:From:Message-ID:Date:MIME-Version;
        b=skhpjLDdJcQQq+zfzVUkVAf5NZL78K25i8t6lW8O+PoOffu13z5XO9o3tsVlsidxA
         hpcjTzZQF3xRrzP8y+OywHvApymjANWH1lS+a++SOBcf3UjCXawP5JJ8UgIELOBfxw
         5In2hFVnxkdRKUwSOq4AIkpLeOBGwc9BsZ7Seh3Zs3ENO9qjZ8jwbcixvoYIj9ejWK
         e1y6xryk9UeBcRLZ879abKf+Hf7jfm2IWVEaSUa0o/uRCaW1lMVGUluHlGUqonWQk5
         ET6tD1Jlb9KNbzTOMCForEy2s6tQcAMla9i91aPEyUiH1d+Zrx65k6ieQmHbkChvyc
         6jP3hXcTEJjZg==
X-Virus-Scanned: amavisd-new at neratec.com
Received: from mail.neratec.com ([127.0.0.1])
        by localhost (mail.neratec.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id ul44t1G2z7_C; Wed, 15 May 2019 10:42:37 +0200 (CEST)
Received: from [172.29.80.10] (dynvpn-010.vpn.neratec.com [172.29.80.10])
        by mail.neratec.com (Postfix) with ESMTPSA id 9E0B1CE03B5;
        Wed, 15 May 2019 10:42:37 +0200 (CEST)
Subject: Re: IP-Aliasing for IPv6?
To:     "M. Buecher" <maddes+kernel@maddes.net>, netdev@vger.kernel.org
References: <5c3590c1568251d0f92b61138b7a7f10@maddes.net>
From:   Matthias May <matthias.may@neratec.com>
Message-ID: <c3fec945-9393-d786-7e48-3e0c3134728f@neratec.com>
Date:   Wed, 15 May 2019 10:42:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <5c3590c1568251d0f92b61138b7a7f10@maddes.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/05/2019 20:49, M. Buecher wrote:
> Preamble: I'm just a network hobbyist at home, so please bear with me i=
f
> something in this mail is "stupid" from an expert's point of view.
>=20
> According to the documentation [1] "IP-Aliasing" is an obsolete way to
> manage multiple IP[v4]-addresses/masks on an interface.
> For having multiple IP[v4]-addresses on an interface this is absolutely
> true.
>=20
> For me "IP-Aliasing" is still a valid, good and easy way to "group" ip
> addresses to run multiple instances of the same service with different
> IPs via virtual interfaces on a single physical NIC.
>=20
> Short story:
> I recently added IPv6 to my LAN setup and recognized that IP-Aliasing i=
s
> not support by the kernel.
> Could IP-Aliasing support for IPv6 be added to the kernel?
>=20
> Long story:
> I tried to find out how to do virtual network interfaces "The Right Way
> (tm)" nowadays.
> So I came across MACVLAN, IPVLAN and alike on the internet, mostly in
> conjunction with containers or VMs.
> But MACVLAN/IPVLAN do not provide the same usability as "IP-Aliasing",
> e.g. user needs to learn a lot about network infrastructre, sysctl
> settings, forwarding, etc.
> They also do not provide the same functionality, e.g. the virtual
> interfaces cannot reach their parent interface.
>=20
> In my tests with MACVLAN (bridge)/IPVLAN (L2) pinging between parent an=
d
> virtual devices with `ping -I <device> <target ip>` failed for IPv4 and
> IPV6.
> Pinging from outside MACVLAN worked fine for IPv4 but not IPv6, while
> IPVLAN failed also for pinging with IPv4 to the virtual interfaces.
> Pinging to outside only worked from the parent device.
> Unfortunately I could not find any source on the internet that describe=
s
> how to setup MACVLAN/IPVLAN and their surroundings correctly for a
> single machine. It seems they are just used for containers and VMs.
>=20
> If it is possible to setup MACVLAN/IPVLAN that they can reach and also
> can be reached from their parent device, other virtual devices and from
> outside, then please guide me to the right direction or provide links.
> Would be much appreciated.
> Otherwise I would like to see IP-Aliasing for IPv6.
>=20
> Hope to stimulate further thoughts and thanks for reading
> Matthias "Maddes" B=C3=BCcher
>=20
> [1] https://www.kernel.org/doc/html/latest/networking/alias.html
>=20

Hi
You might want to take a look at the "label" argument of ip when setting
an IP address.

BR
Matthias
