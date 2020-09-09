Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8B1D263280
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 18:44:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731010AbgIIQou (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 12:44:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:57488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731017AbgIIQoa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Sep 2020 12:44:30 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 046892166E;
        Wed,  9 Sep 2020 16:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599669868;
        bh=Z3ES0Z23Wj7krnBaEyYOJC6YZHNR1w4gU3ktqLtAMMk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=vraq28BUV71+S9ptGzTZ8uNrfxXGN5Wly28aSdGMUXIIL8ClcjgO+tJM85wFBuMaV
         A+Uwu3XvhOExKRr2PpHF1bqNE+Obh8Y5b45VCz5ziWWD6HjTnyrzJjd4R3j0fKFNDX
         ZYyYIeR/D/aK30f7rWT7X+9l+nWCo6OlDTCjyb4g=
Date:   Wed, 9 Sep 2020 09:44:26 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH v3 net-next 2/2] ionic: add devlink firmware update
Message-ID: <20200909094426.68c417fe@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <9938e3cc-b955-11a1-d667-8e5893bb6367@pensando.io>
References: <20200908224812.63434-1-snelson@pensando.io>
        <20200908224812.63434-3-snelson@pensando.io>
        <20200908165433.08afb9ba@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <9938e3cc-b955-11a1-d667-8e5893bb6367@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 9 Sep 2020 09:23:08 -0700 Shannon Nelson wrote:
> On 9/8/20 4:54 PM, Jakub Kicinski wrote:
> > On Tue,  8 Sep 2020 15:48:12 -0700 Shannon Nelson wrote:  
> >> +	dl = priv_to_devlink(ionic);
> >> +	devlink_flash_update_status_notify(dl, label, NULL, 1, timeout);
> >> +	start_time = jiffies;
> >> +	end_time = start_time + (timeout * HZ);
> >> +	do {
> >> +		mutex_lock(&ionic->dev_cmd_lock);
> >> +		ionic_dev_cmd_go(&ionic->idev, &cmd);
> >> +		err = ionic_dev_cmd_wait(ionic, DEVCMD_TIMEOUT);
> >> +		mutex_unlock(&ionic->dev_cmd_lock);
> >> +
> >> +		devlink_flash_update_status_notify(dl, label, NULL,
> >> +						   (jiffies - start_time) / HZ,
> >> +						   timeout);  
> > That's not what I meant. I think we can plumb proper timeout parameter
> > through devlink all the way to user space.  
> 
> Sure, but until that gets worked out, this should suffice.

I don't understand - what will get worked out?
