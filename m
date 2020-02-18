Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DC21163773
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 00:47:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726808AbgBRXrP convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 18 Feb 2020 18:47:15 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:38364 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726641AbgBRXrO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 18:47:14 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EB65815B73682;
        Tue, 18 Feb 2020 15:47:13 -0800 (PST)
Date:   Tue, 18 Feb 2020 15:47:13 -0800 (PST)
Message-Id: <20200218.154713.1411536344737312845.davem@davemloft.net>
To:     toke@redhat.com
Cc:     kuba@kernel.org, lorenzo@kernel.org, netdev@vger.kernel.org,
        ilias.apalodimas@linaro.org, lorenzo.bianconi@redhat.com,
        andrew@lunn.ch, brouer@redhat.com, dsahern@kernel.org,
        bpf@vger.kernel.org
Subject: Re: [RFC net-next] net: mvneta: align xdp stats naming scheme to
 mlx5 driver
From:   David Miller <davem@davemloft.net>
In-Reply-To: <87eeury1ph.fsf@toke.dk>
References: <526238d9bcc60500ed61da1a4af8b65af1af9583.1581984697.git.lorenzo@kernel.org>
        <20200218132921.46df7f8b@kicinski-fedora-PC1C0HJN>
        <87eeury1ph.fsf@toke.dk>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 18 Feb 2020 15:47:14 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>
Date: Tue, 18 Feb 2020 23:23:22 +0100

> Jakub Kicinski <kuba@kernel.org> writes:
> 
>> On Tue, 18 Feb 2020 01:14:29 +0100 Lorenzo Bianconi wrote:
>>> Introduce "rx" prefix in the name scheme for xdp counters
>>> on rx path.
>>> Differentiate between XDP_TX and ndo_xdp_xmit counters
>>> 
>>> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
>>
>> Sorry for coming in late.
>>
>> I thought the ability to attach a BPF program to a fexit of another BPF
>> program will put an end to these unnecessary statistics. IOW I maintain
>> my position that there should be no ethtool stats for XDP.
>>
>> As discussed before real life BPF progs will maintain their own stats
>> at the granularity of their choosing, so we're just wasting datapath
>> cycles.
>>
>> The previous argument that the BPF prog stats are out of admin control
>> is no longer true with the fexit option (IIUC how that works).
> 
> So you're proposing an admin that wants to keep track of XDP has to
> (permantently?) attach an fexit program to every running XDP program and
> use that to keep statistics? But presumably he'd first need to discover
> that XDP is enabled; which the ethtool stats is a good hint for :)

Really, mistakes happen and a poorly implemented or inserted fexit
module should not be a reason to not have access to accurate and
working statistics for fundamental events.

I am therefore totally against requiring fexit for this functionality.
If you want more sophisticated events or custome ones, sure, but not
for this baseline stuff.

I do, however, think we need a way to turn off these counter bumps if
the user wishes to do so for maximum performance.
