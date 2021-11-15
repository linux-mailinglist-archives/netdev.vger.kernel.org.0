Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7512C44FFED
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 09:17:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231235AbhKOIUE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 03:20:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:47726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229654AbhKOIUD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Nov 2021 03:20:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 51D8C61AA5;
        Mon, 15 Nov 2021 08:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636964228;
        bh=Am8In8ufP7uobTU+uylA0XmVZ21mL5UBy8K/DYCuZQ4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LprKn9O5eyaF6bDb0T7r+3utDcsVTtW8ziUNkj7st33JHhi4aUQYbdl2WAqLFNo3z
         Gzor3+zRFawbLEd6YmUjXutJqb8YZKud/QKjQ49XkFdS90Cd0MFGq/W/uv0RdyhUeJ
         a1EtVNJpKnVYDJhu0ad6hAd2d/lMbMvjW3cP/1TuVNtxBAikq1EOyKZ/IJ5j896guo
         z0fnrC8iqmGBVqHFDrTsq44W1WPJizNjuO8YmKiOm0Zu0slJsooXMCtvpbTk6V7hUn
         sng4RxcJJny49E7z6wEynvykuRK87VGfvQmfHhvgGrKk7BODO4rxve2clNYMCLktBP
         KHEKUEnYKfj2w==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1mmXAc-0004yF-FZ; Mon, 15 Nov 2021 09:16:54 +0100
Date:   Mon, 15 Nov 2021 09:16:54 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     mailhol.vincent@wanadoo.fr, wg@grandegger.com, mkl@pengutronix.de,
        davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] can: etas_es58x: fix error handling
Message-ID: <YZIXdnFQcDcC2QvE@hovoldconsulting.com>
References: <CAMZ6Rq+orfUuUCCgeWyGc7P0vp3t-yjf_g9H=Jhk43f1zXGfDQ@mail.gmail.com>
 <20211115075124.17713-1-paskripkin@gmail.com>
 <YZIWT9ATzN611n43@hovoldconsulting.com>
 <7a98b159-f9bf-c0dd-f244-aec6c9a7dcaa@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7a98b159-f9bf-c0dd-f244-aec6c9a7dcaa@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 15, 2021 at 11:15:07AM +0300, Pavel Skripkin wrote:
> On 11/15/21 11:11, Johan Hovold wrote:
> > Just a drive-by comment:
> > 
> > Are you sure about this move of the netdev[channel_idx] initialisation?
> > What happens if the registered can device is opened before you
> > initialise the pointer? NULL-deref in es58x_send_msg()?
> > 
> > You generally want the driver data fully initialised before you register
> > the device so this looks broken.
> > 
> > And either way it is arguably an unrelated change that should go in a
> > separate patch explaining why it is needed and safe.
> > 
> 
> 
> It was suggested by Vincent who is the maintainer of this driver [1].

Yeah, I saw that, but that doesn't necessarily mean it is correct.

You're still responsible for the changes you make and need to be able to
argue why they are correct.

Johan
