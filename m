Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54C1E27F9E7
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 09:06:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730695AbgJAHGp convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 1 Oct 2020 03:06:45 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:54538 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725918AbgJAHGo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 03:06:44 -0400
Received: from marcel-macbook.fritz.box (p4fefc7f4.dip0.t-ipconnect.de [79.239.199.244])
        by mail.holtmann.org (Postfix) with ESMTPSA id 8394ECECD2;
        Thu,  1 Oct 2020 09:13:42 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.1\))
Subject: Re: [PATCH] net: bluetooth: Fix null pointer dereference in
 hci_event_packet()
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20200930141813.410209-1-anmol.karan123@gmail.com>
Date:   Thu, 1 Oct 2020 09:06:42 +0200
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        open list <linux-kernel@vger.kernel.org>,
        syzkaller-bugs@googlegroups.com,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        syzbot+0bef568258653cff272f@syzkaller.appspotmail.com
Content-Transfer-Encoding: 8BIT
Message-Id: <6F6EF48D-561E-4628-A4F1-F1AF28743CAF@holtmann.org>
References: <20200929173231.396261-1-anmol.karan123@gmail.com>
 <20200930141813.410209-1-anmol.karan123@gmail.com>
To:     Anmol Karn <anmol.karan123@gmail.com>
X-Mailer: Apple Mail (2.3608.120.23.2.1)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Anmol,

> AMP_MGR is getting derefernced in hci_phy_link_complete_evt(), when called from hci_event_packet() and there is a possibility, that hcon->amp_mgr may not be found when accessing after initialization of hcon.
> 
> - net/bluetooth/hci_event.c:4945
> The bug seems to get triggered in this line:
> 
> bredr_hcon = hcon->amp_mgr->l2cap_conn->hcon;
> 
> Fix it by adding a NULL check for the hcon->amp_mgr before checking the ev-status.
> 
> Fixes: d5e911928bd8 ("Bluetooth: AMP: Process Physical Link Complete evt")
> Reported-and-tested-by: syzbot+0bef568258653cff272f@syzkaller.appspotmail.com 
> Link: https://syzkaller.appspot.com/bug?extid=0bef568258653cff272f 
> Signed-off-by: Anmol Karn <anmol.karan123@gmail.com>
> ---
> Change in v3:
>  - changed return o; to return; (Reported-by: kernel test robot <lkp@intel.com>
> )
> 
> net/bluetooth/hci_event.c | 5 +++++
> 1 file changed, 5 insertions(+)

patch has been applied to bluetooth-next tree.

Regards

Marcel

