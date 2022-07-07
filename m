Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EC2756A121
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 13:37:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234818AbiGGLhf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 07:37:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232086AbiGGLhe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 07:37:34 -0400
Received: from sender-of-o53.zoho.in (sender-of-o53.zoho.in [103.117.158.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADAEB3207B;
        Thu,  7 Jul 2022 04:37:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1657193806; cv=none; 
        d=zohomail.in; s=zohoarc; 
        b=I5W1IdvoD2nGBr7cTy4zLxcjT4gnMlRtD3AqrqbTzvvbhez+vjGAwX4xj0GilRpUDRiuDkxBNX8mhjf9gK+/UEXhP0WYqQqxp1I4I7LEuYhxU0CpiOEqmWqbqYfH+H81ddpLBbzsXe/oe66t3z0j2L/vpswji0KWN70Hy5k9LPA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.in; s=zohoarc; 
        t=1657193806; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=gTKkhe7yy9xe35WDqN7DEWERl5MpDgjwE9MI2CF5JxY=; 
        b=dxWcutimoHYKOL8oATc3wlMqftMo5koKmJLvdc8pkJnZnGq53Nn3p1Qa1n769/iRxUjc6Tvk/erlLRRsfk7oFIzdtZdIPbAFXE6lgzorc3X3mZYrjN8MEGPWbYZDuEfS5tcyCXon9Zv+6mcG7TaCxIkY1lfPecMxxyYD30Rq4Qw=
ARC-Authentication-Results: i=1; mx.zohomail.in;
        dkim=pass  header.i=siddh.me;
        spf=pass  smtp.mailfrom=code@siddh.me;
        dmarc=pass header.from=<code@siddh.me>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1657193806;
        s=zmail; d=siddh.me; i=code@siddh.me;
        h=Date:Date:From:From:To:To:Cc:Cc:Message-ID:In-Reply-To:References:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=gTKkhe7yy9xe35WDqN7DEWERl5MpDgjwE9MI2CF5JxY=;
        b=GzEjLOsKKpnpUCP+N2Nc85k5+lB8zJSPsSjXmAJLhx7Yksihz/9adhMHH0QIcq0r
        nwxi4Ag7lVlaItZyo+oajMmJQkjxS6eQk/NbnakNPCGvA7MpEsms0svYumhjXEHJGSj
        2AqmeW5HcvwkpR5s1/2iJuVJfbQEdWfuk9b5dGJo=
Received: from mail.zoho.in by mx.zoho.in
        with SMTP id 1657193795628794.4286758139061; Thu, 7 Jul 2022 17:06:35 +0530 (IST)
Date:   Thu, 07 Jul 2022 17:06:35 +0530
From:   Siddh Raman Pant <code@siddh.me>
To:     "Johannes Berg" <johannes@sipsolutions.net>,
        "David S . Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>
Cc:     "linux-wireless" <linux-wireless@vger.kernel.org>,
        "netdev" <netdev@vger.kernel.org>,
        "linux-kernel" <linux-kernel@vger.kernel.org>,
        "linux-kernel-mentees" 
        <linux-kernel-mentees@lists.linuxfoundation.org>
Message-ID: <181d8729017.4900485b8578.8329491601163367716@siddh.me>
In-Reply-To: <20220701145423.53208-1-code@siddh.me>
References: <20220701145423.53208-1-code@siddh.me>
Subject: Ping: [PATCH] net: Fix UAF in ieee80211_scan_rx()
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Importance: Medium
User-Agent: Zoho Mail
X-Mailer: Zoho Mail
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_RED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ping?

On Fri, 01 Jul 2022 20:24:23 +0530  Siddh Raman Pant <code@siddh.me> wrote
> ieee80211_scan_rx() tries to access scan_req->flags after a null check
> (see line 303 of mac80211/scan.c), but ___cfg80211_scan_done() uses
> kfree() on the scan_req (see line 991 of wireless/scan.c).
>
> This results in a UAF.
>
> ieee80211_scan_rx() is called inside a RCU read-critical section
> initiated by ieee80211_rx_napi() (see line 5043 of mac80211/rx.c).
>
> Thus, add an rcu_head to the scan_req struct so as to use kfree_rcu()
> instead of kfree() so that we don't free during the critical section.
>
> Bug report (3): https://syzkaller.appspot.com/bug?extid=f9acff9bf08a845f225d
> Reported-by: syzbot+f9acff9bf08a845f225d@syzkaller.appspotmail.com
> Reported-by: syzbot+6cb476b7c69916a0caca@syzkaller.appspotmail.com
> Reported-by: syzbot+9250865a55539d384347@syzkaller.appspotmail.com
>
> Signed-off-by: Siddh Raman Pant <code@siddh.me>
> ---
>  include/net/cfg80211.h | 2 ++
>  net/wireless/scan.c    | 2 +-
>  2 files changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> index 6d02e12e4702..ba4a49884de8 100644
> --- a/include/net/cfg80211.h
> +++ b/include/net/cfg80211.h
> @@ -2368,6 +2368,7 @@ struct cfg80211_scan_6ghz_params {
>   * @n_6ghz_params: number of 6 GHz params
>   * @scan_6ghz_params: 6 GHz params
>   * @bssid: BSSID to scan for (most commonly, the wildcard BSSID)
> + * @rcu_head: (internal) RCU head to use for freeing
>   */
>  struct cfg80211_scan_request {
>      struct cfg80211_ssid *ssids;
> @@ -2397,6 +2398,7 @@ struct cfg80211_scan_request {
>      bool scan_6ghz;
>      u32 n_6ghz_params;
>      struct cfg80211_scan_6ghz_params *scan_6ghz_params;
> +    struct rcu_head rcu_head;
> 
>      /* keep last */
>      struct ieee80211_channel *channels[];
> diff --git a/net/wireless/scan.c b/net/wireless/scan.c
> index 6d82bd9eaf8c..638b2805222c 100644
> --- a/net/wireless/scan.c
> +++ b/net/wireless/scan.c
> @@ -988,7 +988,7 @@ void ___cfg80211_scan_done(struct cfg80211_registered_device *rdev,
>      kfree(rdev->int_scan_req);
>      rdev->int_scan_req = NULL;
> 
> -    kfree(rdev->scan_req);
> +    kfree_rcu(rdev->scan_req, rcu_head);
>      rdev->scan_req = NULL;
> 
>      if (!send_message)
> -- 
> 2.35.1
>

