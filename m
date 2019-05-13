Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E20D81BB0E
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 18:37:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729967AbfEMQhD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 12:37:03 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:43273 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728659AbfEMQhD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 May 2019 12:37:03 -0400
Received: by mail-pf1-f194.google.com with SMTP id c6so7479396pfa.10
        for <netdev@vger.kernel.org>; Mon, 13 May 2019 09:37:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VzDdaRQRfV/FL2rHBhgK644hgitkO2Oj/QccrnCvFUA=;
        b=ltGboIHeIUMET/iq3ncj5GNFaKJN6pSlBT0YjuynsMjuCskU/X2tf1v6/Y7iX1ylag
         aGcvh2qZbAIUT2FWLdU8xUG88CqSokX3zP2W7oRpFNE9RLN8XY6wAw82plyVltFVwqkc
         lKDSCb0UsiRRwnK6XDwPfPq6VuQJ6aaufkguV8wVfzUI6w2OO7VCuCKAwF+2J3li8TVS
         iX2BMfaN2SApoR5i2Dcs9N7Qw2rmpJ72ifUl5q77wzQVlPb7cC9NBQ9cCe/KyMsIjLZU
         dVeUJrgwRWOaRu2kWiwGY2hEHc8ieduJSoLI+MNjT62JE4wYCCx9eKpxVfEQOC/WjlJq
         Pv4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VzDdaRQRfV/FL2rHBhgK644hgitkO2Oj/QccrnCvFUA=;
        b=ClD/TuaBzjsfVAgNMPfZ+3xZkS8CHAfVEQxobxFylCLgWnB2nCePANq5wUwIvsl4OQ
         vEQMClTCDPQoficd3OWmR/oWUR8yxwP/OPHmqkNeoeiyz73E5cHmUpT82bv6NeIjYtk0
         3ZfMAQDKk6IZA+fhWrzoYWt3lAN0T9/uH7GDxDxyOMmTNjyIQ4CQILiqq6PuWVg0Apk2
         9BmJAd23djxxhuW4vjanMBLeCJAU4cXO+WjY/rEZfoF2SC3kUPgB4iPAG9s42VzqzUPD
         3e+Qr3Rh7NB1DjkRkv/No7l7D58p22e/dOtG3ggFT6apritqb0i1QnQNBfQfJfEFGUZ6
         c5vw==
X-Gm-Message-State: APjAAAWEXQkeGQ7gU7evOoGbT7r7fQcf1Gpg/tbPdgw6skxnbWalcnAa
        QShpgo7XOIiEFcviRzFshGn8ug==
X-Google-Smtp-Source: APXvYqwqNAKL/H4FZIn+nQgBJcOoJgRd6ZuP0FP6FO5f3i1LtETWGAFjSfVakdbTi78lwMY7/gCtow==
X-Received: by 2002:a63:cc4b:: with SMTP id q11mr32517605pgi.43.1557765422433;
        Mon, 13 May 2019 09:37:02 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id v2sm7957295pgr.2.2019.05.13.09.37.02
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 13 May 2019 09:37:02 -0700 (PDT)
Date:   Mon, 13 May 2019 09:36:55 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     David Ahern <dsahern@gmail.com>,
        Sabrina Dubroca <sd@queasysnail.net>, netdev@vger.kernel.org,
        Dan Winship <danw@redhat.com>
Subject: Re: [PATCH net v2] rtnetlink: always put ILFA_LINK for links with a
 link-netnsid
Message-ID: <20190513093655.3b7ed78a@hermes.lan>
In-Reply-To: <83ffac16-f03a-acd7-815a-0b952c0ef951@6wind.com>
References: <d5c4710117d390e0f204b7046483727daf452233.1557755096.git.sd@queasysnail.net>
        <9974090c-5124-b3a1-1290-ac9efc4569c4@gmail.com>
        <83ffac16-f03a-acd7-815a-0b952c0ef951@6wind.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 13 May 2019 17:18:28 +0200
Nicolas Dichtel <nicolas.dichtel@6wind.com> wrote:

> Le 13/05/2019 =C3=A0 17:07, David Ahern a =C3=A9crit=C2=A0:
> > On 5/13/19 7:47 AM, Sabrina Dubroca wrote: =20
> >> Currently, nla_put_iflink() doesn't put the IFLA_LINK attribute when
> >> iflink =3D=3D ifindex.
> >>
> >> In some cases, a device can be created in a different netns with the
> >> same ifindex as its parent. That device will not dump its IFLA_LINK
> >> attribute, which can confuse some userspace software that expects it.
> >> For example, if the last ifindex created in init_net and foo are both
> >> 8, these commands will trigger the issue:
> >>
> >>     ip link add parent type dummy                   # ifindex 9
> >>     ip link add link parent netns foo type macvlan  # ifindex 9 in ns =
foo
> >>
> >> So, in case a device puts the IFLA_LINK_NETNSID attribute in a dump,
> >> always put the IFLA_LINK attribute as well.
> >>
> >> Thanks to Dan Winship for analyzing the original OpenShift bug down to
> >> the missing netlink attribute.
> >>
> >> Analyzed-by: Dan Winship <danw@redhat.com>
> >> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> >> Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
> >> Acked-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
> >> ---
> >> v2: change Fixes tag, it's been here forever as Nicolas said, and add =
his Ack
> >>
> >>  net/core/rtnetlink.c | 16 ++++++++++------
> >>  1 file changed, 10 insertions(+), 6 deletions(-)
> >>
> >> diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
> >> index 2bd12afb9297..adcc045952c2 100644
> >> --- a/net/core/rtnetlink.c
> >> +++ b/net/core/rtnetlink.c
> >> @@ -1496,14 +1496,15 @@ static int put_master_ifindex(struct sk_buff *=
skb, struct net_device *dev)
> >>  	return ret;
> >>  }
> >> =20
> >> -static int nla_put_iflink(struct sk_buff *skb, const struct net_devic=
e *dev)
> >> +static int nla_put_iflink(struct sk_buff *skb, const struct net_devic=
e *dev,
> >> +			  bool force)
> >>  {
> >>  	int ifindex =3D dev_get_iflink(dev);
> >> =20
> >> -	if (dev->ifindex =3D=3D ifindex)
> >> -		return 0;
> >> +	if (force || dev->ifindex !=3D ifindex)
> >> +		return nla_put_u32(skb, IFLA_LINK, ifindex);
> >> =20
> >> -	return nla_put_u32(skb, IFLA_LINK, ifindex);
> >> +	return 0;
> >>  }
> >> =20
> >>  static noinline_for_stack int nla_put_ifalias(struct sk_buff *skb, =20
> >=20
> > why not always adding the attribute?
> >  =20
> Adding this attribute may change the output of 'ip link'.
> See this patch for example:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit=
/?id=3D95ec655bc465

+1

Printing eno1@eno1 is going to make scripts and users upset.


