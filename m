Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 665F723B544
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 08:53:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726806AbgHDGxX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 02:53:23 -0400
Received: from host-88-217-225-28.customer.m-online.net ([88.217.225.28]:50164
        "EHLO mail.dev.tdt.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725904AbgHDGxW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 02:53:22 -0400
Received: from mail.dev.tdt.de (localhost [IPv6:::1])
        by mail.dev.tdt.de (Postfix) with ESMTP id 03F3620084;
        Tue,  4 Aug 2020 06:53:15 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 04 Aug 2020 08:53:15 +0200
From:   Martin Schiller <ms@dev.tdt.de>
To:     Xie He <xie.he.0141@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux X25 <linux-x25@vger.kernel.org>
Subject: Re: [PATCH v2] drivers/net/wan/lapbether: Use needed_headroom instead
 of hard_header_len
Organization: TDT AG
In-Reply-To: <CAJht_EO1srhh68DifK61+hpY+zBRU8oOAbJOSpjOqePithc7gw@mail.gmail.com>
References: <20200730073702.16887-1-xie.he.0141@gmail.com>
 <CAJht_EO1srhh68DifK61+hpY+zBRU8oOAbJOSpjOqePithc7gw@mail.gmail.com>
Message-ID: <c88c0acc63cbc64383811193c5e1b184@dev.tdt.de>
X-Sender: ms@dev.tdt.de
User-Agent: Roundcube Webmail/1.1.5
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED autolearn=ham
        autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dev.tdt.de
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020-07-30 10:02, Xie He wrote:
> Hi Martin,
> 
> I'm currently working on a plan to make all X.25 drivers (lapbether.c,
> x25_asy.c, hdlc_x25.c) to set dev->hard_header_len /
> dev->needed_headroom correctly. So that upper layers no longer need to
> guess how much headroom a X.25 device needs with a constant value (as
> they currently do).
> 
> After studying af_packet.c, I found that X.25 drivers needed to set
> needed_headroom to reserve the headroom instead of using
> hard_header_len. Because hard_header_len should be the length of the
> header that would be created by dev_hard_header, and in this case it
> should be 0, according to the logic of af_packet.c.
> 
> So my first step is to fix the settings in lapbether.c. Could you
> review this patch and extend your support via a "Reviewed-by" tag? If
> this can be fixed, I'll go on and fix other X.25 drivers. Thanks!
> 
> It's very hard to find reviewers for X.25 code because it is
> relatively unmaintained by people. I hope I can do some of the
> maintenance work. I greatly appreciate your support!

I don't like the idea to get rid of the 1-byte header.
This header is also used in userspace, for example when using a tun/tap
interface for an XoT (X.25 over TCP) application. A change would
therefore have very far-reaching consequences.

BTW: The linux x25 mailing list does not seem to work anymore. I've been
on it for some time now, but haven't received a single email from it.
I've tried to contact owner-linux-x25@vger.kernel.org, but only got an
"undeliverable" email back.

It would be great if you could add me to CC list of all versions of your
patches, so I don't need to "google" for any further related mails.

So, what's the latest version of the patch now, which you want me to
review?
