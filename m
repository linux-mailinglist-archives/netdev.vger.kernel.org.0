Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E7C5B51C6
	for <lists+netdev@lfdr.de>; Tue, 17 Sep 2019 17:46:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729778AbfIQPq3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Sep 2019 11:46:29 -0400
Received: from canardo.mork.no ([148.122.252.1]:40655 "EHLO canardo.mork.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728003AbfIQPq3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Sep 2019 11:46:29 -0400
Received: from miraculix.mork.no (miraculix.mork.no [IPv6:2001:4641:0:2:7627:374e:db74:e353])
        (authenticated bits=0)
        by canardo.mork.no (8.15.2/8.15.2) with ESMTPSA id x8HFkLQV019542
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Tue, 17 Sep 2019 17:46:21 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1568735182; bh=01F0+hoCVuL91LPexeI+J5fAbsP/o62EI5xZw9DZwNA=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=dqx9U4lJuXVqWbWCKQEHhYcuwa4PNOEQN8whjxPCB6mDbVCL+uDM+6mdOa/D+Xkss
         9EbJpT1xgDN9R8k9dwCPSjjnPTAh77gaeI4y4yJc91lQBrU0p5PAtwyycNBT3I5Kwe
         Ew1VVgTsrxUO3AJFbcK9oJ1rzR505tiNLzZDEV70=
Received: from bjorn by miraculix.mork.no with local (Exim 4.92)
        (envelope-from <bjorn@mork.no>)
        id 1iAFgL-0007xx-10; Tue, 17 Sep 2019 17:46:21 +0200
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     syzbot <syzbot+ce366e2b8296e25d84f5@syzkaller.appspotmail.com>
Cc:     andreyknvl@google.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, oliver@neukum.org,
        syzkaller-bugs@googlegroups.com
Subject: Re: divide error in cdc_ncm_update_rxtx_max
Organization: m
References: <00000000000018e4250592c043c3@google.com>
Date:   Tue, 17 Sep 2019 17:46:20 +0200
In-Reply-To: <00000000000018e4250592c043c3@google.com> (syzbot's message of
        "Tue, 17 Sep 2019 07:09:00 -0700")
Message-ID: <87d0fzlycz.fsf@miraculix.mork.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.101.4 at canardo
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot <syzbot+ce366e2b8296e25d84f5@syzkaller.appspotmail.com> writes:

> syzbot has tested the proposed patch but the reproducer still
> triggered crash:
> divide error in usbnet_update_max_qlen
>
> cdc_ncm 5-1:1.0: setting tx_max =3D 16384
> divide error: 0000 [#1] SMP KASAN
> CPU: 1 PID: 1737 Comm: kworker/1:2 Not tainted 5.3.0-rc7+ #0
> Hardware name: Google Google Compute Engine/Google Compute Engine,
> BIOS Google 01/01/2011
> Workqueue: usb_hub_wq hub_event
> RIP: 0010:usbnet_update_max_qlen drivers/net/usb/usbnet.c:344 [inline]
> RIP: 0010:usbnet_update_max_qlen+0x231/0x370 drivers/net/usb/usbnet.c:338

Sure, but that's another error already fixed by Oliver..

I guess this fix worked.  But I believe we should see if this is a more
generic issue than just this single driver/bug.  I fear it is...



Bj=C3=B8rn
