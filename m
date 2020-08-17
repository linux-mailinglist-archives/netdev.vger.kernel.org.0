Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51FDC246189
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 10:57:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728099AbgHQI5I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 04:57:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727001AbgHQI5G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 04:57:06 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2D58C061388;
        Mon, 17 Aug 2020 01:57:05 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1k7awD-005bkG-1W; Mon, 17 Aug 2020 10:56:17 +0200
Message-ID: <d4de00a939be7b2b37ac1eb84c48777b73614dce.camel@sipsolutions.net>
Subject: Re: [PATCH 3/8] net: mac80211: convert tasklets to use new
 tasklet_setup() API
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Allen Pais <allen.cryptic@gmail.com>, gerrit@erg.abdn.ac.uk,
        davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        alex.aring@gmail.com, stefan@datenfreihafen.org,
        santosh.shilimkar@oracle.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us
Cc:     keescook@chromium.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wpan@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-s390@vger.kernel.org, Allen Pais <allen.lkml@gmail.com>,
        Romain Perier <romain.perier@gmail.com>
Date:   Mon, 17 Aug 2020 10:56:06 +0200
In-Reply-To: <20200817085120.24894-3-allen.cryptic@gmail.com> (sfid-20200817_105156_998114_A405125C)
References: <20200817085120.24894-1-allen.cryptic@gmail.com>
         <20200817085120.24894-3-allen.cryptic@gmail.com>
         (sfid-20200817_105156_998114_A405125C)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-08-17 at 14:21 +0530, Allen Pais wrote:
> 
> -static void ieee80211_tasklet_handler(unsigned long data)
> +static void ieee80211_tasklet_handler(struct tasklet_struct *t)
>  {
> -	struct ieee80211_local *local = (struct ieee80211_local *) data;
> +	struct ieee80211_local *local = from_tasklet(local, t, tasklet);

Yay, thank you!

Reviewed-by: Johannes Berg <johannes@sipsolutions.net>


Dave, if you want to take this patch, I have no objections - I have
nothing in my mac80211-next tree (yet).

johannes

