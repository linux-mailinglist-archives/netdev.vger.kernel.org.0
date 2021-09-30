Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DE9141D5A3
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 10:47:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348461AbhI3Iss (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 04:48:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348052AbhI3Iss (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 04:48:48 -0400
X-Greylist: delayed 133 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 30 Sep 2021 01:47:05 PDT
Received: from forwardcorp1o.mail.yandex.net (forwardcorp1o.mail.yandex.net [IPv6:2a02:6b8:0:1a2d::193])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96B8AC06161C
        for <netdev@vger.kernel.org>; Thu, 30 Sep 2021 01:47:05 -0700 (PDT)
Received: from myt5-23f0be3aa648.qloud-c.yandex.net (myt5-23f0be3aa648.qloud-c.yandex.net [IPv6:2a02:6b8:c12:3e29:0:640:23f0:be3a])
        by forwardcorp1o.mail.yandex.net (Yandex) with ESMTP id 96D3E2E0A27;
        Thu, 30 Sep 2021 11:44:47 +0300 (MSK)
Received: from myt5-70c90f7d6d7d.qloud-c.yandex.net (2a02:6b8:c12:3e2c:0:640:70c9:f7d [2a02:6b8:c12:3e2c:0:640:70c9:f7d])
        by myt5-23f0be3aa648.qloud-c.yandex.net (mxbackcorp/Yandex) with ESMTP id Eli5Jy5C89-ilua6cYd;
        Thu, 30 Sep 2021 11:44:47 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1632991487; bh=9mdgrb1xUAKb2RJeOXhmy/3Mh5G6erQpiSrjy9fmbC4=;
        h=To:Message-Id:References:Date:Subject:Cc:In-Reply-To:From;
        b=ItotbwHtjepse5svkxJiqzl1ej2ulXmPWSWpMwGd9gVe/H49vgpfKfHw1xBq6OUy/
         Ijd8OUrXDRo6t1ciPdwxh/17jv69lrwQIAnfB4XwS2jRf9IYuJuVddwPL0e59zJsmP
         FcVVyeaOPopEJkzr5xUKH/7GLT1Jnj7gUZo4JO5o=
Authentication-Results: myt5-23f0be3aa648.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from smtpclient.apple (2a02:6b8:0:40c:18e6:8210:53f1:533d [2a02:6b8:0:40c:18e6:8210:53f1:533d])
        by myt5-70c90f7d6d7d.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPS id xKyLaR1S0r-ilxeL7a2;
        Thu, 30 Sep 2021 11:44:47 +0300
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client certificate not present)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.120.0.1.13\))
Subject: Re: [PATCH] ipv6: enable net.ipv6.route sysctls in network namespace
From:   "Alexander Al. Kuznetsov" <wwfq@yandex-team.ru>
In-Reply-To: <20210921060909.380179f0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Date:   Thu, 30 Sep 2021 11:44:46 +0300
Cc:     netdev@vger.kernel.org, zeil@yandex-team.ru, ebiederm@xmission.com,
        davem@davemloft.net
Content-Transfer-Encoding: quoted-printable
Message-Id: <1A4FB0E6-C840-4A09-B067-9A9F9B9565F3@yandex-team.ru>
References: <20210921062204.16571-1-wwfq@yandex-team.ru>
 <20210921060909.380179f0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
To:     Jakub Kicinski <kuba@kernel.org>
X-Mailer: Apple Mail (2.3654.120.0.1.13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On 21 Sep 2021, at 16:09, Jakub Kicinski <kuba@kernel.org> wrote:
>=20
> On Tue, 21 Sep 2021 09:22:04 +0300 Alexander Kuznetsov wrote:
>> We want to increase route cache size in network namespace
>> created with user namespace. Currently ipv6 route settings
>> are disabled for non-initial network namespaces.
>> Since routes are per network namespace it is safe
>> to enable these sysctls.
>>=20
>> Signed-off-by: Alexander Kuznetsov <wwfq@yandex-team.ru>
>> Acked-by: Dmitry Yakunin <zeil@yandex-team.ru>
>=20
> Your CC list is very narrow. IMO you should CC Eric B on this,=20
> at the very least.
>=20
> Why only remove this part and not any other part of 464dc801c76aa?

We remove this part by analogy with 5cdda5f1d6add and enable only =
sysctls that we need.

>> diff --git a/net/ipv6/route.c b/net/ipv6/route.c
>> index b6ddf23..de85e3b 100644
>> --- a/net/ipv6/route.c
>> +++ b/net/ipv6/route.c
>> @@ -6415,10 +6415,6 @@ struct ctl_table * __net_init =
ipv6_route_sysctl_init(struct net *net)
>> 		table[8].data =3D &net->ipv6.sysctl.ip6_rt_min_advmss;
>> 		table[9].data =3D =
&net->ipv6.sysctl.ip6_rt_gc_min_interval;
>> 		table[10].data =3D =
&net->ipv6.sysctl.skip_notify_on_dev_down;
>> -
>> -		/* Don't export sysctls to unprivileged users */
>> -		if (net->user_ns !=3D &init_user_ns)
>> -			table[0].procname =3D NULL;
>> 	}
>>=20
>> 	return table;
>=20
> I don't know much about user ns, are we making an assumption here that
> this user ns corresponds to a net ns? Or just because it's _possible_
> to make them 1:1 we can shift the decision to the admin?

Sorry, but I don't understand what you mean.=
