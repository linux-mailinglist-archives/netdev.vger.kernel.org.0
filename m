Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F34414DC26
	for <lists+netdev@lfdr.de>; Thu, 30 Jan 2020 14:41:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727221AbgA3Nly convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 30 Jan 2020 08:41:54 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:45753 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727125AbgA3Nlx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jan 2020 08:41:53 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-8-ilKwKLf5Ng6J2SLpUVZx-g-1; Thu, 30 Jan 2020 08:41:48 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 21DB7107ACC5;
        Thu, 30 Jan 2020 13:41:46 +0000 (UTC)
Received: from bistromath.localdomain (ovpn-117-110.ams2.redhat.com [10.36.117.110])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 340EC5DA7B;
        Thu, 30 Jan 2020 13:41:42 +0000 (UTC)
Date:   Thu, 30 Jan 2020 14:41:41 +0100
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        syzbot+c3ea30e1e2485573f953@syzkaller.appspotmail.com,
        dvyukov@google.com, mkl@pengutronix.de, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, davem@davemloft.net,
        linux-stable <stable@vger.kernel.org>
Subject: Re: [PATCH] bonding: do not enslave CAN devices
Message-ID: <20200130134141.GA804563@bistromath.localdomain>
References: <20200130133046.2047-1-socketcan@hartkopp.net>
MIME-Version: 1.0
In-Reply-To: <20200130133046.2047-1-socketcan@hartkopp.net>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: ilKwKLf5Ng6J2SLpUVZx-g-1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

2020-01-30, 14:30:46 +0100, Oliver Hartkopp wrote:
> Since commit 8df9ffb888c ("can: make use of preallocated can_ml_priv for per
> device struct can_dev_rcv_lists") the device specific CAN receive filter lists
> are stored in netdev_priv() and dev->ml_priv points to these filters.
> 
> In the bug report Syzkaller enslaved a vxcan1 CAN device and accessed the
> bonding device with a PF_CAN socket which lead to a crash due to an access of
> an unhandled bond_dev->ml_priv pointer.
> 
> Deny to enslave CAN devices by the bonding driver as the resulting bond_dev
> pretends to be a CAN device by copying dev->type without really being one.

Does the team driver have the same problem?

-- 
Sabrina

