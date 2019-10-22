Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DFB0E00F0
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 11:42:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731518AbfJVJmX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 05:42:23 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:44710 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731459AbfJVJmW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 05:42:22 -0400
Received: by mail-lj1-f193.google.com with SMTP id c4so1317608lja.11
        for <netdev@vger.kernel.org>; Tue, 22 Oct 2019 02:42:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6PngoIqd3Df1CdJuHFWIWAR+3vA7GwvMHjLnoNZAyhA=;
        b=nm43MeZUUI6GQpkNT6A0YrESS4a/Z0DJ3o9zbifdiIHtP+9Q2tT5ZcCHuHFQxVKZWs
         3gIcAXIfvHGdVkydGFosRyRjeK+YQ3NgZ4t8Eqq/3w5XjBlr5Ph08jgW7VWWPzcgSPdG
         qJmUdAL/72WUiByqgPOv+SdbkyZV+NMSEfZZpMfqhotrGSNfPYr71tIf3/x82dfNsHZo
         KP6IsKcmUpKy2SQyNWrDhtglHdSbCAEZn1DJPQWzn9DLtcDYxcYJhIB7Z6enotA6m5IZ
         UmPnyUHWTTllkD4Eh9VvC+ZNdYsrFdds6j+/LwFcuoXCmqYlP2ePOZEiQxYrHbxy4dnp
         RYfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6PngoIqd3Df1CdJuHFWIWAR+3vA7GwvMHjLnoNZAyhA=;
        b=Fy+9iRjjhit/tW2pS7O+e4plBDbi40E2rka9Fkz31ZpmWsImf+5Sa3U/GWAft/QrtP
         VBZjSsFA/yX1QTI7M8D1hYag0zptN7A0WnR3bW+C3VPxRy2npG4He6AF+BCr4ka4tdiK
         x4nq3zc6kZYlxOJvdvzT1RhFeLhLq03baZSC01j9eV8LhMKUP/0tWtwcKPDSCVQWssOX
         JsPKDxZAURSO+w5caXwXjCOzjaBw0aFE1bpOOOig5O1Ff/T3Etp0/GYDGNItT+bgB9Ug
         B6b+0jIzManIFoJv0GqOWhU5odoVehIzXkhu/p4ei7MjtvYPVkgh7TWgaPjUnAWJ+76O
         zwbg==
X-Gm-Message-State: APjAAAXqT/TUHYmVjmOHAsc4sDy4C2Ne8+iledvndaYaYW/7EXrVxRUF
        sywEaGZ4/vHkOqUiZbLyMv0ehw==
X-Google-Smtp-Source: APXvYqxzOPJiicnhU2xU73dS4Ka5ImWerivhccwctOI/IfMg9cJRh20c9txgdneMOboGeKD12wD1dg==
X-Received: by 2002:a2e:880e:: with SMTP id x14mr17555702ljh.42.1571737340767;
        Tue, 22 Oct 2019 02:42:20 -0700 (PDT)
Received: from ?IPv6:2a00:1fa0:6f4:f4ee:fd19:4aa8:e73f:e22a? ([2a00:1fa0:6f4:f4ee:fd19:4aa8:e73f:e22a])
        by smtp.gmail.com with ESMTPSA id q124sm9966339ljb.28.2019.10.22.02.42.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 22 Oct 2019 02:42:19 -0700 (PDT)
Subject: Re: [PATCH] 802.11n IBSS: wlan0 stops receiving packets due to
 aggregation after sender reboot
To:     =?UTF-8?Q?Krzysztof_Ha=c5=82asa?= <khalasa@piap.pl>,
        Johannes Berg <johannes@sipsolutions.net>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <m34l02mh71.fsf@t19.piap.pl> <m3v9shl6jz.fsf@t19.piap.pl>
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <628ec530-1f68-e34b-39a5-b3d994d9376c@cogentembedded.com>
Date:   Tue, 22 Oct 2019 12:42:00 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <m3v9shl6jz.fsf@t19.piap.pl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 21.10.2019 15:18, Krzysztof Hałasa wrote:

> Fix a bug where the mac80211 RX aggregation code sets a new aggregation
> "session" at the remote station's request, but the head_seq_num
> (the sequence number the receiver expects to receive) isn't reset.
> 
> Spotted on a pair of AR9580 in IBSS mode.
> 
> Signed-off-by: Krzysztof Halasa <khalasa@piap.pl>
> 
> diff --git a/net/mac80211/agg-rx.c b/net/mac80211/agg-rx.c
> index 4d1c335e06e5..775a51cc51c9 100644
> --- a/net/mac80211/agg-rx.c
> +++ b/net/mac80211/agg-rx.c
> @@ -354,9 +354,11 @@ void ___ieee80211_start_rx_ba_session(struct sta_info *sta,
>   			 */
>   			rcu_read_lock();
>   			tid_rx = rcu_dereference(sta->ampdu_mlme.tid_rx[tid]);
> -			if (tid_rx && tid_rx->timeout == timeout)
> +			if (tid_rx && tid_rx->timeout == timeout) {
> +				tid_rx->ssn = start_seq_num;
> +				tid_rx->head_seq_num = start_seq_num;
>   				status = WLAN_STATUS_SUCCESS;
> -			else
> +			} else

    If you add {} on one branch of *if*, you also need to add {} to all other 
branches, says CodingStyle...

[...]

MBR, Sergei
