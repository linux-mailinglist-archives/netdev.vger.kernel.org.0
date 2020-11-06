Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 269242A9ED8
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 22:07:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728549AbgKFVHZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 16:07:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:45576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728408AbgKFVHZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Nov 2020 16:07:25 -0500
Received: from sx1.lan (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 387B12087E;
        Fri,  6 Nov 2020 21:07:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604696844;
        bh=JXg0lmC2R+uKjF0oGYWjltw0eJE/5o7We79L8QFFolo=;
        h=Subject:From:To:Date:In-Reply-To:References:From;
        b=tYIqBpLIMXsHvOwTe6Df/GmcIScUr4s63MYPmsYAc7dEhl+PNHKVJfMwXAPXqf+bV
         pLP0IQF6jAWaWQE/p9zPxuQJ9+UK4MHgcHs3m8Fi096pAvcEldgezBESVXzHfQ1pd1
         YOOjvJxGJ4llx5Vuui/btNo5Rl5ALNEJVY4f3TMg=
Message-ID: <c4b1c48fc3d6d80f062ff56495a022b83fafd994.camel@kernel.org>
Subject: Re: [PATCH v2 net-next 3/8] ionic: add lif quiesce
From:   Saeed Mahameed <saeed@kernel.org>
To:     Shannon Nelson <snelson@pensando.io>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org
Date:   Fri, 06 Nov 2020 13:07:23 -0800
In-Reply-To: <20201106001220.68130-4-snelson@pensando.io>
References: <20201106001220.68130-1-snelson@pensando.io>
         <20201106001220.68130-4-snelson@pensando.io>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-11-05 at 16:12 -0800, Shannon Nelson wrote:
> After the queues are stopped, expressly quiesce the lif.
> This assures that even if the queues were in an odd state,
> the firmware will close up everything cleanly.
> 
> Signed-off-by: Shannon Nelson <snelson@pensando.io>
> ---
>  .../net/ethernet/pensando/ionic/ionic_lif.c   | 24
> +++++++++++++++++++
>  1 file changed, 24 insertions(+)
> 
> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
> b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
> index 519d544821af..990bd9ce93c2 100644
> --- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
> +++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
> @@ -1625,6 +1625,28 @@ static void ionic_lif_rss_deinit(struct
> ionic_lif *lif)
>  	ionic_lif_rss_config(lif, 0x0, NULL, NULL);
>  }
>  
> +static int ionic_lif_quiesce(struct ionic_lif *lif)
Sorry maybe i wasn't clear before, 

i mean make this function return a void

static void ionic_lif_quiesce(struct ionic_lif *lif)

> +	(void)ionic_lif_quiesce(lif);

I didn't mean to typecast the return value here :)


