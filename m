Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB47E27DD4A
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 02:15:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729159AbgI3APD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 20:15:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:37520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728192AbgI3APD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 20:15:03 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B65020739;
        Wed, 30 Sep 2020 00:15:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601424902;
        bh=+1Mo10dGu+efkNNzDAyhsbOru8ke4PbCm8n5mBpFLzQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WHYlAzgDSsp8p8zo2hG0WFQzRxHEP/ngN4vgALDWuXpQBVzoN8LSgKHZ2VCcYkuO3
         yYqYann3wSYgG4FB/U5nCj2cPJQ11Mgg/Got13rrX1qsTd4MPwlH1RzXgwV7fI2xMe
         86B0hVhWgE9SF/vKZM1i2p21+FG0+JVXml9TW/zE=
Date:   Tue, 29 Sep 2020 17:15:00 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH net-next 1/2] ionic: stop watchdog timer earlier on
 remove
Message-ID: <20200929171500.0fab7f33@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200929221956.3521-2-snelson@pensando.io>
References: <20200929221956.3521-1-snelson@pensando.io>
        <20200929221956.3521-2-snelson@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 29 Sep 2020 15:19:55 -0700 Shannon Nelson wrote:
> We need to be better at making sure we don't have a link check
> watchdog go off while we're shutting things down, so let's stop
> the timer as soon as we start the remove.
> 
> Meanwhile, since that was the only thing in
> ionic_dev_teardown(), simplify and remove that function.
> 
> Signed-off-by: Shannon Nelson <snelson@pensando.io>

The asymmetry of when the watchdog is started and stopped is a little
strange. Won't there be a similar problem now with the watchdog
starting too early?
