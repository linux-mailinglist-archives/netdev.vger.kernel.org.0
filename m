Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1164A2ED737
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 20:08:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729337AbhAGTHj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 14:07:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:41746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725903AbhAGTHi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Jan 2021 14:07:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CC7762343F;
        Thu,  7 Jan 2021 19:06:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610046418;
        bh=FLbCNz9ha1GQCDeC22fpxYQhEAshqfiEF05pVQts9Mw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qPQ4noF0G8stJ4tFY6i1b9vDo4cd6zpnuVZqVgD5Rzio9m0HcL1QzHXVv4PChvvq0
         +3qWUPO2mzHBmnZSY+tfs/JuX8S4f1zb+e6JIoGBKrn7uTM8cHha4b+yCeEKRMbinv
         oXtrPOaoE2QR4vMOjN8ZWG0e8nJs7BLHb1bT9c8t5ZIgwOqOGIXQtVrCfNU5oBStjs
         ltlXL5rHJbCvOnrZMzrx/4WtohYKglKL4OU9nhSUWlQTHOMp+JQy4NK56XV63x1O2K
         6SLxoccO3+sDYIxy62M5KXg+tx/RVidYb0krNuJ3UgY1IWhlGNkfGohy3I9jafT0Pm
         ZONUtLGBZtwXw==
Date:   Thu, 7 Jan 2021 11:06:56 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        linux-can@vger.kernel.org, kernel@pengutronix.de,
        Dan Murphy <dmurphy@ti.com>, Sean Nyekjaer <sean@geanix.com>
Subject: Re: [net-next 15/19] can: tcan4x5x: rework SPI access
Message-ID: <20210107110656.7e49772b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210107110035.42a6bb46@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20210107094900.173046-1-mkl@pengutronix.de>
        <20210107094900.173046-16-mkl@pengutronix.de>
        <20210107110035.42a6bb46@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 7 Jan 2021 11:00:35 -0800 Jakub Kicinski wrote:
> On Thu,  7 Jan 2021 10:48:56 +0100 Marc Kleine-Budde wrote:
> > +struct __packed tcan4x5x_map_buf {
> > +	struct tcan4x5x_buf_cmd cmd;
> > +	u8 data[256 * sizeof(u32)];
> > +} ____cacheline_aligned;  
> 
> Interesting attribute combo, I must say.

Looking at the rest of the patch I don't really see a reason for
__packed.  Perhaps it can be dropped?
