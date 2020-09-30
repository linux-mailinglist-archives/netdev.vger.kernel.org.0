Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD68927DD4B
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 02:15:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729191AbgI3APX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 20:15:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:37576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728192AbgI3APX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 20:15:23 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A264820739;
        Wed, 30 Sep 2020 00:15:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601424922;
        bh=MdEw3lra3a0QIBQbyd/A+QonY9EE7km4KLL4aosvPnw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CPm1IjOC1TVfZw4Z5wNtUR6SyWObQEDbboGL8Es6ZmsSBXf1HxFULrAzGW6CFpj35
         sl9anWf/xA+Aq7AUPsXJxJKM3rTvo0OMNT00az7jFy08yXhkXSc75q2uBIHU+qNk08
         J3txIr5A+ZbnMyoOGXOn3/Qj0Tp5oxMUUem8P5Yg=
Date:   Tue, 29 Sep 2020 17:15:21 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH net-next 2/2] ionic: prevent early watchdog check
Message-ID: <20200929171521.654fdef9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200929221956.3521-3-snelson@pensando.io>
References: <20200929221956.3521-1-snelson@pensando.io>
        <20200929221956.3521-3-snelson@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 29 Sep 2020 15:19:56 -0700 Shannon Nelson wrote:
> In one corner case scenario, the driver device lif setup can
> get delayed such that the ionic_watchdog_cb() timer goes off
> before the ionic->lif is set, thus causing a NULL pointer panic.
> We catch the problem by checking for a NULL lif just a little
> earlier in the callback.
> 
> Signed-off-by: Shannon Nelson <snelson@pensando.io>

Hah, I should have looked at the second patch :D
