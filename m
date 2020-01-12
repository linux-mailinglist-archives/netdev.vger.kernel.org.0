Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11F29138843
	for <lists+netdev@lfdr.de>; Sun, 12 Jan 2020 21:45:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387416AbgALUpd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jan 2020 15:45:33 -0500
Received: from mx4.wp.pl ([212.77.101.11]:32345 "EHLO mx4.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732825AbgALUpc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 12 Jan 2020 15:45:32 -0500
Received: (wp-smtpd smtp.wp.pl 22672 invoked from network); 12 Jan 2020 21:45:29 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1578861930; bh=hiso0TBhVn9E3h2VZK4Ha0yg4s3zeLiMWHTl0ZvCCLc=;
          h=From:To:Cc:Subject;
          b=vn9nXgrrrHcbBbI5UCJ9S956hfAsCA4S6/ny4Qtou4Vo6BrL9/43pU/wMLFSb5oPD
           /M7pb0nkjtk2BxBrzUiJueTlZe938b0ZrPv6a8ZhcKiivmOJ1SkqLoSkBevbmdfaax
           6cLXvfUW6A9jyrW+ETaGFO+VhdV+pHIAKw7nd7jE=
Received: from c-73-93-4-247.hsd1.ca.comcast.net (HELO cakuba) (kubakici@wp.pl@[73.93.4.247])
          (envelope-sender <kubakici@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <linyunsheng@huawei.com>; 12 Jan 2020 21:45:29 +0100
Date:   Sun, 12 Jan 2020 12:45:21 -0800
From:   Jakub Kicinski <kubakici@wp.pl>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     Jacob Keller <jacob.e.keller@intel.com>, <netdev@vger.kernel.org>,
        <valex@mellanox.com>, <jiri@resnulli.us>
Subject: Re: [PATCH v2 0/3] devlink region trigger support
Message-ID: <20200112124521.467fa06a@cakuba>
In-Reply-To: <fe6c0d5e-5705-1118-1a71-80bd0e26a97e@huawei.com>
References: <20200109193311.1352330-1-jacob.e.keller@intel.com>
        <4d8fe881-8d36-06dd-667a-276a717a0d89@huawei.com>
        <1d00deb9-16fc-b2a5-f8f7-5bb8316dbac2@intel.com>
        <fe6c0d5e-5705-1118-1a71-80bd0e26a97e@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-WP-MailID: a89c90e55a1a084ed5cad8185d133461
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 000000A [UfM0]                               
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 11 Jan 2020 09:51:00 +0800, Yunsheng Lin wrote:
> > regions can essentially be used to dump arbitrary addressable content. I
> > think all of the above are great examples.
> > 
> > I have a series of patches to update and convert the devlink
> > documentation, and I do provide some further detail in the new
> > devlink-region.rst file.
> > 
> > Perhaps you could review that and provide suggestions on what would make
> > sense to add there?  
> 
> For the case of region for mlx4, I am not sure it worths the effort to
> document it, because Jiri has mention that there was plan to convert mlx4 to
> use "devlink health" api for the above case.
> 
> Also, there is dpipe, health and region api:
> For health and region, they seems similar to me, and the non-essential
> difference is:
> 1. health can be used used to dump content of tlv style, and can be triggered
>    by driver automatically or by user manually.
> 
> 2. region can be used to dump binary content and can be triggered by driver
>    automatically only.
> 
> It would be good to merged the above to the same api(perhaps merge the binary
> content dumping of region api to health api), then we can resue the same dump
> ops for both driver and user triggering case.

I think there is a fundamental difference between health API and
regions in the fact that health reporters allow for returning
structured data from different sources which are associated with 
an event/error condition. That includes information read from the
hardware or driver/software state. Region API (as Jake said) is good
for dumping arbitrary addressable content, e.g. registers. I don't see
much use for merging the two right now, FWIW...
