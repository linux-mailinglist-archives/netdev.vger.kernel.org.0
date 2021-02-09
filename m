Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F28A5314B8D
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 10:29:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229669AbhBIJ05 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 04:26:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:51094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229832AbhBIJVk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Feb 2021 04:21:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7201864EB4;
        Tue,  9 Feb 2021 09:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612862460;
        bh=G1Eub0Qc9s6bDhEC55bOrEw/Bgdsa/I8bGjOhdhgxII=;
        h=In-Reply-To:References:From:Subject:Cc:To:Date:From;
        b=GFoXYFn4I5JIe0gU5kMhovUvhPCQZGU/CkrpiEXeK4eXX+fhaYE1zG6RhZJNRxcma
         18n5KHnV7Lt5FS5qGfcfkX8cg7/LaEBBV9XuvWEyvj++BlOOYTDe73xxvsRFKltMal
         L/0Wqih1MEOhVFU6mnkdyRYdyUKO9IVWMiv+ZXwh8nb/VLa7y3cesuYSCltH0GfEHR
         wxp+RKUBMY1K15C2rXO5oKxVDVrta4S8NJ/EM9+WbvmfXH1Dmvmpi1y3Cq9cVZQi9p
         qDksteGE1UHyZDWzIxpSFRihRM+lokp7cZEqOeSWoPx/oNU8j6Pls0HxnQ3hN5l/B1
         Zpb9YnyqCAskw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <161286193169.5645.3845763619163247582@kwain.local>
References: <20210208171917.1088230-1-atenart@kernel.org> <20210208171917.1088230-10-atenart@kernel.org> <CAKgT0Uc3TePxDd12MQiWtkUmtjnd4CAsrN2U49R1p7wXsvxgRA@mail.gmail.com> <161286193169.5645.3845763619163247582@kwain.local>
From:   Antoine Tenart <atenart@kernel.org>
Subject: Re: [PATCH net-next v2 09/12] net-sysfs: remove the rtnl lock when accessing the xps maps
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Netdev <netdev@vger.kernel.org>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Message-ID: <161286245694.5645.16005415845082591521@kwain.local>
Date:   Tue, 09 Feb 2021 10:20:57 +0100
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quoting Antoine Tenart (2021-02-09 10:12:11)
>=20
> As the sb_dev pointer is protected by the rtnl lock, we'll have to keep
> the lock. I'll move that patch at the end of the series (it'll be easier
> to add the get_device/put_device logic with the xps_queue_show
> function). I'll also move netdev_txq_to_tc out of xps_queue_show, to
> call it under the rtnl lock taken.

That was not very clear. I meant I won't remove the rtnl lock, but will
try not to take it for too long, using get_device/put_device. We'll see
if I'll have a dedicated patch for that or not.
