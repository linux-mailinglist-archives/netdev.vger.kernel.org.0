Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1B541728E9
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 20:47:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730055AbgB0TpQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 14:45:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:52276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729611AbgB0TpQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Feb 2020 14:45:16 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 557E024691;
        Thu, 27 Feb 2020 19:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582832715;
        bh=qOqxdp4GtrD+msjXNTe/BJ3g8N/6xKJpfk1XlDdN+38=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LjynvZeMwZ/4hwz9LTWya+aN7OcK7edIyeecHyHYkMKWxbl830hBJsccipNoZofPz
         jEdrLtuA5mxIl3J5IUh7HgUk4ulAmupeH8whH3e09IY84gf4Ozw2LSC0+gWaFyJt7v
         scp42y9UtiNEB9of0pZ4i7OMZXKaTrGgNmKTaITU=
Date:   Thu, 27 Feb 2020 11:45:13 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        David Ahern <dahern@digitalocean.com>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andy Gospodarek <andy@greyhouse.net>
Subject: Re: virtio_net: can change MTU after installing program
Message-ID: <20200227114513.277400fb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CACKFLim6Y5HoUSab=J=ex8hmFbJApivWpXpQV8pnzJ4EBnCs9w@mail.gmail.com>
References: <20200226093330.GA711395@redhat.com>
        <87lfopznfe.fsf@toke.dk>
        <0b446fc3-01ed-4dc1-81f0-ef0e1e2cadb0@digitalocean.com>
        <20200226115258-mutt-send-email-mst@kernel.org>
        <ec1185ac-a2a1-e9d9-c116-ab42483c3b85@digitalocean.com>
        <20200226120142-mutt-send-email-mst@kernel.org>
        <20200226173751.0b078185@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CACKFLim6Y5HoUSab=J=ex8hmFbJApivWpXpQV8pnzJ4EBnCs9w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 27 Feb 2020 11:26:58 -0800 Michael Chan wrote:
> On Wed, Feb 26, 2020 at 5:37 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > I had a look at Broadcom and it seems to be missing there as well :(
> > Qlogic also. Ugh.  
> 
> The Broadcom bnxt_en driver should not allow the MTU to be changed to
> an invalid value after an XDP program is attached.  We set the
> netdev->max_mtu to a smaller value and dev_validate_mtu() should
> reject MTUs that are not supported in XDP mode.

I see, thanks!
