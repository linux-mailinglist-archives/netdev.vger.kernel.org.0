Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78776263A30
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 04:22:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730177AbgIJCWp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 22:22:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:34304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730154AbgIJCUo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Sep 2020 22:20:44 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D416E21D81;
        Wed,  9 Sep 2020 22:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599691867;
        bh=a5gaZ4YIWgCHM3yo8Kv1lF5lXFIBLh2HSH8Ox0si5bM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eovnLuJl+4rh9RoE8aCf1FkOa2Gl9v+hoL931xU7fTraU/9c9jkv7tItaDGWBKa53
         aK9mgNdF4CmbMbHBeDgrREeBwhS8oQGdRd9JvgzQjosLJqPmzhqZIMG2J0f+AVgdRX
         RqHXFU3MeoYM1o86GcxNaJqs+PrUck8eZLrPm4Yw=
Date:   Wed, 9 Sep 2020 15:51:05 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     syzbot <syzbot+8267241609ae8c23b248@syzkaller.appspotmail.com>,
        davem@davemloft.net, jhs@mojatatu.com, jiri@resnulli.us,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        xiyou.wangcong@gmail.com
Subject: Re: INFO: rcu detected stall in cleanup_net (4)
Message-ID: <20200909155105.5efb291a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <877dt2pqeb.fsf@intel.com>
References: <000000000000db78de05aedabb5a@google.com>
        <20200909085203.5e335c61@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <877dt2pqeb.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 09 Sep 2020 14:54:36 -0700 Vinicius Costa Gomes wrote:
> > Vinicius, could you please take a look at all the syzbot reports which
> > point to your commit? I know syzbot bisection is not super reliable,
> > but at least 3 reports point to your commit now, so something's
> > probably going on.  
> 
> I did take a look, and it seems that it all boils down to having too
> small (unreasonable?) intervals in the schedule, which causes the
> hrtimer handler to starve the other kernel threads.
> 
> I have a quick fix to restrict the interval values to more sensible
> values (at least equal to the time it takes to transmit the mininum
> ethernet frame size), I am testing it and I will propose it soon. But a
> proper solution will require more time.

Great, thank you!
