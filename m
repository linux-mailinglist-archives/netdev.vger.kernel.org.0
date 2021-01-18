Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00A942FAD59
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 23:35:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731519AbhARWeU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 17:34:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:38162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731034AbhARWeL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Jan 2021 17:34:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D157C22CB1;
        Mon, 18 Jan 2021 22:33:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611009211;
        bh=IM9a4CUsvxVF6Jq5wqzguvKmewN5sygU/iHsZ+uw6+8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=R8ouSi/oGPcK0P4GP1Mcsycpciaofy7zOME1GNEmg6JT0NhmwB7Psb2swbhhKmC5W
         S5/aYpam1KAIZc7wPydtmd35mz/TZbc/11KCjO0UbzvnDrNre8bKoJInsCIqGu84m3
         wjCCWOIBKE2fEKYdQr5NMUwxMm9MyjFKk883h1COvX6IngQTt5K8+t007OCMsKHk0D
         1UyrKrtvpH89cG5dU7Ho9nDyifS6Kt0hOctIghrLaKMEWTu+XNsPo3IQhVitcESPYL
         cqVnVKQ9E5AA74RX7Z7o36xnBeZvG6E+5NKxhoWRqg3kz1mt/1+kntFbd9vU+550HA
         D/h39XzonnM9Q==
Date:   Mon, 18 Jan 2021 14:33:29 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     <mst@redhat.com>
Cc:     wangyunjian <wangyunjian@huawei.com>, <netdev@vger.kernel.org>,
        <jasowang@redhat.com>, <willemdebruijn.kernel@gmail.com>,
        <virtualization@lists.linux-foundation.org>,
        <jerry.lilijun@huawei.com>, <chenchanghu@huawei.com>,
        <xudingke@huawei.com>, <brian.huangbin@huawei.com>
Subject: Re: [PATCH net-next v7] vhost_net: avoid tx queue stuck when
 sendmsg fails
Message-ID: <20210118143329.08cc14a6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1610685980-38608-1-git-send-email-wangyunjian@huawei.com>
References: <1610685980-38608-1-git-send-email-wangyunjian@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 15 Jan 2021 12:46:20 +0800 wangyunjian wrote:
> From: Yunjian Wang <wangyunjian@huawei.com>
> 
> Currently the driver doesn't drop a packet which can't be sent by tun
> (e.g bad packet). In this case, the driver will always process the
> same packet lead to the tx queue stuck.
> 
> To fix this issue:
> 1. in the case of persistent failure (e.g bad packet), the driver
>    can skip this descriptor by ignoring the error.
> 2. in the case of transient failure (e.g -ENOBUFS, -EAGAIN and -ENOMEM),
>    the driver schedules the worker to try again.
> 
> Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>

Michael, LMK if you want to have a closer look otherwise I'll apply
tomorrow.
