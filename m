Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC82035FAF1
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 20:50:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353042AbhDNSq5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 14:46:57 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:50931 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1353023AbhDNSqx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 14:46:53 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 797895C0051;
        Wed, 14 Apr 2021 14:46:31 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 14 Apr 2021 14:46:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=talbothome.com;
         h=message-id:subject:from:to:cc:date:in-reply-to:references
        :content-type:mime-version:content-transfer-encoding; s=fm2; bh=
        3dEbTlea9Fpi/y9H7Z5NQvwVD/AaWaqpw5q1WZPMC8c=; b=b5+HPhBJATK1RUOB
        Xmks/6ihTVlzcjJ59336L/+8mAfprCxSQQy+TbkSo8Mt1K46ucppPBHh4hYJHmqS
        dWS2lvSDRcfR8hqdy/PBIXwtzn9Oqpg5aL5VujLlf6lHe0pHhTVFMPQ8TbYB4yXE
        6rRfQWA2hF86dYnJ+bHsw1wlKQTlHDupF7i/6p51VB4frPKmvz4B134yuyiWXWaY
        02iNW2y+Sm/wMJc5Cd62fzkHrEn0nmnL3zCgD2sAWQQ5G5TX6r9ZJQwdyUVZYPLB
        O+ATS+uM36/fL6mRqfqmS3JDBmbYJ+PQc21fRpTuaAwVaV0vmqoUqNP2j+xdyblG
        2sosMQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; bh=3dEbTlea9Fpi/y9H7Z5NQvwVD/AaWaqpw5q1WZPMC
        8c=; b=pbFVzXh5/l3RbQHb2rR3J2UtJYkCZqQOuPXW0s5qoAmKhlJ6vObWGycM+
        VT+06xy52VKUpKCv+37cEj/wSLUip4cZcM8sqOzqXEeNSOePkLUjgPC07KlaA+BY
        zrZXZJtM8jjw8fgw1Np0OQY/O/ebsmwFSY2Iii9GGMK4FHVQUSbKfU0zN4AJEUHK
        oVlyIuM94Pre0TUNvsq3DSLEvPAre0gqyDeAmvLQg1lNPa+h0ZtflHbz0Cl0J3wB
        8OgTuPVrx1IBpHVInLHfu/URvtXadaJIhuwL9E8E3/EdiWwVHefMtc5jRMvx4fxb
        9tLwUS8Tm/h/RhLT/jo5MkextN6GQ==
X-ME-Sender: <xms:hjh3YJgDGUNWXU12bAKKvPhRqZpSp114W1xzAfiheEOlbY4cdYhzfQ>
    <xme:hjh3YHrKlQaSrJxKH6ZGOGAHpkeuS4belCIAyjUv4IA69Qb7upj3hauz0kzABuCgB
    jDyq-HtJR61C26FHw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudeluddgudefudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepkffuhffvffgjfhgtfggggfesth
    ekredttderjeenucfhrhhomhepvehhrhhishcuvfgrlhgsohhtuceotghhrhhishesthgr
    lhgsohhthhhomhgvrdgtohhmqeenucggtffrrghtthgvrhhnpeejlefffeefkeeljeehve
    fgvdfhieegtddtleeljeekjeefvdfggffgkefgieefhfenucffohhmrghinhepphhurhhi
    rdhsmhdpuggvsghirghnrdhnvghtnecukfhppeduvdekrddvrdehiedruddvleenucevlh
    hushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegthhhrihhsseht
    rghlsghothhhohhmvgdrtghomh
X-ME-Proxy: <xmx:hjh3YJHJ-oe7fQXz3XfSCK_XcNzihlweBmjyu8pJ6CFIHXJjEDHkFw>
    <xmx:hjh3YBkhCvu7ylhmma0JsAyyX5UAnfeNs1audG6l5tQmxxZw6EuiBQ>
    <xmx:hjh3YEkR4xY-SSpK5lD8Y4c32g99H3egBcoA6hOnLehOPH8y3yX8GQ>
    <xmx:hzh3YP83KCwaI5xlKOTwx1n9-4dw3MGmWjyOljPNh-IdF9K-rS0rUA>
Received: from CMU-974457.ANDREW.CMU.EDU (cmu-974457.andrew.cmu.edu [128.2.56.129])
        by mail.messagingengine.com (Postfix) with ESMTPA id 787A1240065;
        Wed, 14 Apr 2021 14:46:30 -0400 (EDT)
Message-ID: <d29aaa8b01d1342f9c51e1c68ea3870f6e7158f8.camel@talbothome.com>
Subject: Re: [Debian-on-mobile-maintainers] Forking on MMSD
From:   Chris Talbot <chris@talbothome.com>
To:     Guido =?ISO-8859-1?Q?G=FCnther?= <agx@sigxcpu.org>
Cc:     ofono@ofono.org, netdev@vger.kernel.org,
        debian-on-mobile-maintainers@alioth-lists.debian.net,
        librem-5-dev@lists.community.puri.sm, 982250@bugs.debian.org,
        985893@bugs.debian.org
Date:   Wed, 14 Apr 2021 14:46:30 -0400
In-Reply-To: <YHc0wV9wjT3WhfYW@bogon.m.sigxcpu.org>
References: <051ae8ae27f5288d64ec6ef2bd9f77c06b829b52.camel@talbothome.com>
         <634e0debea558b90af2cebfc99518071f1d630e9.camel@talbothome.com>
         <YHc0wV9wjT3WhfYW@bogon.m.sigxcpu.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Wed, 2021-04-14 at 20:30 +0200, Guido Günther wrote:
> Hi,
> On Wed, Apr 14, 2021 at 02:21:04PM -0400, Chris Talbot wrote:
> > Hello All,
> > 
> > In talking to the Debian Developer Mr. Federico Ceratto, since I
> > have
> > been unable to get a hold of the Ofono Maintainers, the best course
> > of
> > action for packaging mmsd into Debian is to simply fork the project
> > and
> > submit my version upstream for packaging in Debian. My repository
> > is
> > here: https://source.puri.sm/kop316/mmsd/
> > 
> > I am sending this so the relavent parties are aware of this, and to
> > indicate that I no longer intend on trying to get a hold of
> > upstream
> > mmsd to try and submit patches.
> > 
> > For the Purism Employees, I am additionally asking for permission
> > to
> > keep hosting mmsd on https://source.puri.sm/ . I have been
> > extremely
> > appreciative in using it and I am happy to keep it there, but I
> > want to
> > be neighboorly and ask if it is okay for me to keep it there. If it
> > is
> > not, I completely understand and I am fine with moving it to a new
> > host.
> 
> Keeping your ofono version on source.puri.sm is certainly welcome!
> Cheers,
>  -- Guido
> 
> > 
> > If you have any questions, comments, or concern, please reach out
> > to
> > me.
> > 
> > -- 
> > Respectfully,
> > Chris Talbot
> > 
> > 
> > _______________________________________________
> > Debian-on-mobile-maintainers mailing list
> > Debian-on-mobile-maintainers@alioth-lists.debian.net
> > https://alioth-lists.debian.net/cgi-bin/mailman/listinfo/debian-on-mobile-maintainers
> > 
Thank you for allowing me to keep hosting it there.

Since it is now a fork, I added Mr. Ceratto, Mr. Farraris (a-wai), and
Mr. Clayton Craft (craftyguy, a pmOS developer) as maintainers. Is
there a wish for a Purism maintainer to be added as well? 

Respectfully,
Chris Talbot

