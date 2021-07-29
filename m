Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A56D3DA246
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 13:38:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234029AbhG2Li4 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 29 Jul 2021 07:38:56 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:54595 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231576AbhG2Liz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 07:38:55 -0400
Received: from smtpclient.apple (p5b3d23f8.dip0.t-ipconnect.de [91.61.35.248])
        by mail.holtmann.org (Postfix) with ESMTPSA id 8BF25CED14;
        Thu, 29 Jul 2021 13:38:50 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.100.0.2.22\))
Subject: Re: [PATCH v2] Bluetooth: skip invalid hci_sync_conn_complete_evt
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20210728075105.415214-1-desmondcheongzx@gmail.com>
Date:   Thu, 29 Jul 2021 13:38:50 +0200
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        skhan@linuxfoundation.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        syzbot+66264bf2fd0476be7e6c@syzkaller.appspotmail.com
Content-Transfer-Encoding: 8BIT
Message-Id: <72819085-5564-4386-AD94-2901083CDE65@holtmann.org>
References: <20210728075105.415214-1-desmondcheongzx@gmail.com>
To:     Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
X-Mailer: Apple Mail (2.3654.100.0.2.22)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Desmond,

> Syzbot reported a corrupted list in kobject_add_internal [1]. This
> happens when multiple HCI_EV_SYNC_CONN_COMPLETE event packets with
> status 0 are sent for the same HCI connection. This causes us to
> register the device more than once which corrupts the kset list.
> 
> As this is forbidden behavior, we add a check for whether we're
> trying to process the same HCI_EV_SYNC_CONN_COMPLETE event multiple
> times for one connection. If that's the case, the event is invalid, so
> we report an error that the device is misbehaving, and ignore the
> packet.
> 
> Link: https://syzkaller.appspot.com/bug?extid=66264bf2fd0476be7e6c [1]
> Reported-by: syzbot+66264bf2fd0476be7e6c@syzkaller.appspotmail.com
> Tested-by: syzbot+66264bf2fd0476be7e6c@syzkaller.appspotmail.com
> Signed-off-by: Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
> ---
> 
> v1 -> v2:
> - Added more comments to explain the reasoning behind the new check, and
> a bt_dev_err message upon detecting the invalid event. As suggested by
> Marcel Holtmann.
> 
> net/bluetooth/hci_event.c | 16 ++++++++++++++++
> 1 file changed, 16 insertions(+)

I shortened the error message and then applied your patch to bluetooth-next tree.

Regards

Marcel

