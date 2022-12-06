Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 900A8643D53
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 07:52:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233933AbiLFGwq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 01:52:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234002AbiLFGwm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 01:52:42 -0500
Received: from gw.red-soft.ru (red-soft.ru [188.246.186.2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 329ACDE9;
        Mon,  5 Dec 2022 22:52:36 -0800 (PST)
Received: from localhost.localdomain (unknown [10.81.81.211])
        (using TLSv1.2 with cipher AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by gw.red-soft.ru (Postfix) with ESMTPSA id 234473E1A0C;
        Tue,  6 Dec 2022 09:52:34 +0300 (MSK)
Date:   Tue, 6 Dec 2022 09:52:33 +0300
From:   Artem Chernyshev <artem.chernyshev@red-soft.ru>
To:     Vishnu Dasa <vdasa@vmware.com>
Cc:     Stefano Garzarella <sgarzare@redhat.com>,
        Pv-drivers <Pv-drivers@vmware.com>,
        Bryan Tan <bryantan@vmware.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "lvc-project@linuxtesting.org" <lvc-project@linuxtesting.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v3] net: vmw_vsock: vmci: Check memcpy_from_msg()
Message-ID: <Y47msXHvtKVlzDu2@localhost.localdomain>
References: <20221205115200.2987942-1-artem.chernyshev@red-soft.ru>
 <C39CC4BC-E87C-4C6D-ADC9-A33E7696BD20@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C39CC4BC-E87C-4C6D-ADC9-A33E7696BD20@vmware.com>
X-KLMS-Rule-ID: 1
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Lua-Profiles: 173957 [Dec 06 2022]
X-KLMS-AntiSpam-Version: 5.9.59.0
X-KLMS-AntiSpam-Envelope-From: artem.chernyshev@red-soft.ru
X-KLMS-AntiSpam-Rate: 0
X-KLMS-AntiSpam-Status: not_detected
X-KLMS-AntiSpam-Method: none
X-KLMS-AntiSpam-Auth: dkim=none
X-KLMS-AntiSpam-Info: LuaCore: 502 502 69dee8ef46717dd3cb3eeb129cb7cc8dab9e30f6, {Tracking_from_domain_doesnt_match_to}, d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;red-soft.ru:7.1.1;127.0.0.199:7.1.2
X-MS-Exchange-Organization-SCL: -1
X-KLMS-AntiSpam-Interceptor-Info: scan successful
X-KLMS-AntiPhishing: Clean, bases: 2022/12/06 06:02:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2022/12/05 16:38:00 #20652685
X-KLMS-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,
On Mon, Dec 05, 2022 at 11:03:47PM +0000, Vishnu Dasa wrote:
> 
> > On Dec 5, 2022, at 3:52 AM, Artem Chernyshev <artem.chernyshev@red-soft.ru> wrote:
> > 
> > vmci_transport_dgram_enqueue() does not check the return value
> > of memcpy_from_msg(). Return with an error if the memcpy fails.
> 
> I think we can add some more information in the description.  Sorry, I
> should've said this earlier.
> 
> vmci_transport_dgram_enqueue() does not check the return value
> of memcpy_from_msg().  If memcpy_from_msg() fails, it is possible that
> uninitialized memory contents are sent unintentionally instead of user's
> message in the datagram to the destination.  Return with an error if
> memcpy_from_msg() fails.
> 
> > 
> > Found by Linux Verification Center (linuxtesting.org) with SVACE.
> > 
> > Fixes: 0f7db23a07af ("vmci_transport: switch ->enqeue_dgram, ->enqueue_stream and ->dequeue_stream to msghdr")
> > Signed-off-by: Artem Chernyshev <artem.chernyshev@red-soft.ru>
> 
> Thanks, Artem!  This version looks good to me modulo my suggestion
> about the description above.
> 
> Reviewed-by: Vishnu Dasa <vdasa@vmware.com>
> 
> Regards,
> Vishnu
> 
No problem, I'll change description in v4

Thanks,
Artem
