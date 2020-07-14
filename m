Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62BE321E4E0
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 02:55:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727097AbgGNAzV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 20:55:21 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43242 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726347AbgGNAzV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 20:55:21 -0400
Received: from 1.general.jvosburgh.us.vpn ([10.172.68.206] helo=famine.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <jay.vosburgh@canonical.com>)
        id 1jv9E4-0005Fb-W2; Tue, 14 Jul 2020 00:55:17 +0000
Received: by famine.localdomain (Postfix, from userid 1000)
        id 460C95FEE7; Mon, 13 Jul 2020 17:55:15 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 3E9909FB79;
        Mon, 13 Jul 2020 17:55:15 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
cc:     Michal Kubecek <mkubecek@suse.cz>, netdev@vger.kernel.org,
        Jarod Wilson <jarod@redhat.com>
Subject: Re: [RFC] bonding driver terminology change proposal
In-reply-to: <20200713154118.3a1edd66@hermes.lan>
References: <CAKfmpSdcvFG0UTNJFJgXwNRqQb-mk-PsrM5zQ_nXX=RqaaawgQ@mail.gmail.com> <20200713220016.xy4n7c5uu3xs6dyk@lion.mk-sys.cz> <20200713154118.3a1edd66@hermes.lan>
Comments: In-reply-to Stephen Hemminger <stephen@networkplumber.org>
   message dated "Mon, 13 Jul 2020 15:41:18 -0700."
X-Mailer: MH-E 8.6+git; nmh 1.6; GNU Emacs 27.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <24040.1594688115.1@famine>
Date:   Mon, 13 Jul 2020 17:55:15 -0700
Message-ID: <24041.1594688115@famine>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Stephen Hemminger <stephen@networkplumber.org> wrote:

>On Tue, 14 Jul 2020 00:00:16 +0200
>Michal Kubecek <mkubecek@suse.cz> wrote:
>
>> On Mon, Jul 13, 2020 at 02:51:39PM -0400, Jarod Wilson wrote:
>> > To start out with, I'd like to attempt to eliminate as much of the use
>> > of master and slave in the bonding driver as possible. For the most
>> > part, I think this can be done without breaking UAPI, but may require
>> > changes to anything accessing bond info via proc or sysfs.  
>> 
>> Could we, please, avoid breaking existing userspace tools and scripts?
>> Massive code churn is one thing and we could certainly bite the bullet
>> and live with it (even if I'm still not convinced it would be as great
>> idea as some present it) but trading theoretical offense for real and
>> palpable harm to existing users is something completely different.
>> 
>> Or is "don't break userspace" no longer the "first commandment" of linux
>> kernel development?
>> 
>> Michal Kubecek
>
>Please consider using same wording as current standard for link aggregration.
>Current version is 802.1AX and it uses the terms:
>  Multiplexer /  Aggregator

	Well, 802.1AX only defines LACP, and the bonding driver does
more than just LACP.  Also, Multiplexer, in 802.1AX, is a function of
various components, e.g., each Aggregator has a Multiplexer, as do other
components.

	As "channel bonding" is a long-established term of art, I don't
see an issue with something like "bond" and "port," which parallels the
bridge / port terminology.

[...]
>As far as userspace, maybe keep the old API's but provide deprecation nags.
>And don't document the old API values.

	Unless the community stance on not breaking user space has
changed, the extant APIs must be maintained.  In the context of bonding,
this would include "ip link" command line arguments, sysfs and procsfs
interfaces, as well as netlink attribute names.  There are also exported
kernel APIs that bonding utilizes, netdev_master_upper_dev_link, et al.

	Additionally, just to be absolutely clear, is the proposal here
intending to undertake a rather significant search and replace of the
text strings "master" and "slave" within the bonding driver source?
This in addition to whatever API changes end up being done.  If so, then
I would also like to know the answer to Andrew's question regarding
patch conflicts in order to gauge the future maintenance cost.

	-J

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
