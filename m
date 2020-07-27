Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E447722EAF1
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 13:15:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726555AbgG0LPm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 07:15:42 -0400
Received: from mx.nohats.ca ([193.110.157.68]:45770 "EHLO mx.nohats.ca"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726269AbgG0LPl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 07:15:41 -0400
X-Greylist: delayed 488 seconds by postgrey-1.27 at vger.kernel.org; Mon, 27 Jul 2020 07:15:40 EDT
Received: from localhost (localhost [IPv6:::1])
        by mx.nohats.ca (Postfix) with ESMTP id 4BFcTX22TqzGD5;
        Mon, 27 Jul 2020 13:07:28 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nohats.ca;
        s=default; t=1595848048;
        bh=ihM5zlpPUwu5qc+sfphnwTk+/+5A/ctwB4iibx2ctqs=;
        h=From:Subject:Date:References:Cc:In-Reply-To:To;
        b=hvTLJL6szI+fhbR7O0d4W38tiyGsnzAr8Sr4nSeNjBLxcyQb3xpC1kgrduyEIFMbP
         5HJq0KSWtqsuud2Zh9POE31YEaskHV43W/LiVufawGhWTmDjnu8CkBXsEzgJKR3QXZ
         sJ6CrshfQ0p08ZGvzm+sTTyrjhTn4hjGsXOv3tno=
X-Virus-Scanned: amavisd-new at mx.nohats.ca
X-Spam-Flag: NO
X-Spam-Score: 0.695
X-Spam-Level: 
X-Spam-Status: No, score=0.695 tagged_above=0 required=5 tests=[BAYES_00=-0.9,
        DKIM_ADSP_ALL=0.8, RDNS_NONE=0.793, SPF_HELO_NONE=0.001,
        SPF_NONE=0.001] autolearn=no autolearn_force=no
Received: from mx.nohats.ca ([IPv6:::1])
        by localhost (mx.nohats.ca [IPv6:::1]) (amavisd-new, port 10024)
        with ESMTP id 1G_vQA4Nj0U2; Mon, 27 Jul 2020 13:07:27 +0200 (CEST)
Received: from bofh.nohats.ca (unknown [193.110.157.194])
        (using TLSv1.2 with cipher ADH-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.nohats.ca (Postfix) with ESMTPS;
        Mon, 27 Jul 2020 13:07:27 +0200 (CEST)
Received: from [193.110.157.210] (unknown [193.110.157.210])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
        (No client certificate requested)
        by bofh.nohats.ca (Postfix) with ESMTPSA id CEC186029BA5;
        Mon, 27 Jul 2020 07:07:25 -0400 (EDT)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Paul Wouters <paul@nohats.ca>
Mime-Version: 1.0 (1.0)
Subject: Re: [RFC PATCH ipsec] xfrm: don't pass too short packets to userspace with ESPINUDP encap
Date:   Mon, 27 Jul 2020 07:07:24 -0400
Message-Id: <6FEDD2D2-CBA1-41E8-85B8-0180EFB4738E@nohats.ca>
References: <20200727092819.GY20687@gauss3.secunet.de>
Cc:     Sabrina Dubroca <sd@queasysnail.net>, netdev@vger.kernel.org,
        Andrew Cagney <andrew.cagney@gmail.com>,
        Tobias Brunner <tobias@strongswan.org>
In-Reply-To: <20200727092819.GY20687@gauss3.secunet.de>
To:     Steffen Klassert <steffen.klassert@secunet.com>
X-Mailer: iPhone Mail (17F80)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Jul 27, 2020, at 05:28, Steffen Klassert <steffen.klassert@secunet.com> w=
rote:
>=20
> =EF=BB=BF
>>=20
>> This patch changes that behavior, so that only properly-formed non-ESP
>> messages are passed to userspace. Messages of 8 bytes or less that
>> don't contain a full non-ESP prefix followed by some data (at least
>> one byte) will be dropped and counted as XfrmInHdrError.
>=20
> I'm ok with that change. But it affects userspace, so the *swan
> people have to tell if that's ok for them.


Libreswan is okay with this, we actually discussed this with Sabrina as a re=
sult of the TCP work where she noticed the difference.

Paul=

