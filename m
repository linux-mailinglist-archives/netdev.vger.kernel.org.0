Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 264A425EA07
	for <lists+netdev@lfdr.de>; Sat,  5 Sep 2020 22:04:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728758AbgIEUE2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Sep 2020 16:04:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:40420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728745AbgIEUEZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Sep 2020 16:04:25 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E6DE2083B;
        Sat,  5 Sep 2020 20:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599336264;
        bh=uiFTdAAQTAFcaCzTEJOInfiQ/VR+dysQXF7PGVOoN3I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cSlcMl6mTzQX9lkwEhATQze45wunX6l0hPIwoSZYxnYDImRc0pZhu+GDMu1kHaYfc
         aF/UbJy1+I8C7VlsaFF2XaSYt0WK5djwLhIz/ujGzAoO6tlaJ9ZTgnsvAbDSs9DEAo
         jy189uP5EQMjVCssGJ5qd4Dry2P1sZ8S2YvJrzAc=
Date:   Sat, 5 Sep 2020 13:04:22 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH v2 net-next 2/2] ionic: add devlink firmware update
Message-ID: <20200905130422.36e230df@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200904000534.58052-3-snelson@pensando.io>
References: <20200904000534.58052-1-snelson@pensando.io>
        <20200904000534.58052-3-snelson@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  3 Sep 2020 17:05:34 -0700 Shannon Nelson wrote:
> +/* The worst case wait for the install activity is about 25 minutes when
> + * installing a new CPLD, which is very seldom.  Normal is about 30-35
> + * seconds.  Since the driver can't tell if a CPLD update will happen we
> + * set the timeout for the ugly case.

25 minutes is really quite scary. And user will see no notification
other than "Installing 50%" for 25 minutes? And will most likely not 
be able to do anything that'd involve talking to the FW, like setting
port info/speed?

Is it possible for the FW to inform that it's updating the CPLD?

Can you release the dev_cmd_lock periodically to allow other commands
to be executed while waiting?
