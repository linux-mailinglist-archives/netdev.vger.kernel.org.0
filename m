Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 629D772F1B
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 14:40:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726504AbfGXMkl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 08:40:41 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:52926 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725776AbfGXMkk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 08:40:40 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hqGZO-0005pu-SF; Wed, 24 Jul 2019 14:40:34 +0200
Message-ID: <127c411cc06e04b61220a571f5332b9155c69f77.camel@sipsolutions.net>
Subject: Re: [PATCH 1/2] net: mac80211: Fix possible null-pointer
 dereferences in ieee80211_setup_sdata()
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jia-Ju Bai <baijiaju1990@gmail.com>, davem@davemloft.net
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Wed, 24 Jul 2019 14:40:33 +0200
In-Reply-To: <20190724123623.10093-1-baijiaju1990@gmail.com> (sfid-20190724_143632_658051_4FE62E07)
References: <20190724123623.10093-1-baijiaju1990@gmail.com>
         (sfid-20190724_143632_658051_4FE62E07)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2019-07-24 at 20:36 +0800, Jia-Ju Bai wrote:
> In ieee80211_setup_sdata(), there is an if statement on line 1410 to
> check whether sdata->dev is NULL:
>     if (sdata->dev)
> 
> When sdata->dev is NULL, it is used on lines 1458 and 1459:
>     sdata->dev->type = ARPHRD_IEEE80211_RADIOTAP;
>     sdata->dev->netdev_ops = &ieee80211_monitorif_ops;
> 
> Thus, possible null-pointer dereferences may occur.

No, this cannot happen, monitor interfaces (NL80211_IFTYPE_MONITOR) must
have a valid ->dev, only P2P device and NAN might not.

johannes

