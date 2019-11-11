Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35541F7433
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 13:40:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726964AbfKKMkp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 07:40:45 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:39052 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726853AbfKKMkp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 07:40:45 -0500
Received: by mail-wm1-f68.google.com with SMTP id t26so13049293wmi.4
        for <netdev@vger.kernel.org>; Mon, 11 Nov 2019 04:40:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=V+GuVxjGTCySax0xEHhWpFRbl1vWy/++Yn18cLUXl18=;
        b=El4FNdv7FnPaTXRTtx7NRQHqNFYlmlIIlAwLDgg673rDBDttU+6zYVtUkJFmL+ftRi
         pSFkgXHdGI3Xu0Sy1ByOVlzPUqyj9b8rmnPoaWapW77PPmgyPbgwp6tHchvcARvi+FAE
         GdFamj6LJUfVOievKqd7r/OC9ZgNlb4EqvPxACajuvJ8BvFa2gXO2uhWdUUI2hL3Y3W+
         5rFMXN7fSH4GaKWwHCwwOfAFAl9wlMRyMRm2jzX5v3/z31b2SI6g900/MOnTuB8Y+YdM
         YuRIbSkMfuV81BSS6is91GPQ0UHVsundYzCs3yHx1MMH/+BsDPb0TW+SIlnr8D57IQbx
         tUkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=V+GuVxjGTCySax0xEHhWpFRbl1vWy/++Yn18cLUXl18=;
        b=p9phlLGWRB4Zxg+qReRk5KOJRGSZQADmVU4akC0+t/rItR/g7p9gtOodhfFRLdKLvI
         GIjKt/c/tOGIWQT1J+i6s3GczdtU1lEFujl/6w1ve7KwuwymZBb1hRqKuuwZRf2nMfxb
         D+RVDFpIzg2F1CnFPPPtZGlaROAlJI0xo0MC8Ktiftk1WuDWfGGrcislwMCTieUGzy2H
         HSBUpS3oXbwwpIi3uKHjzJyrxH5fDtLiGxi2QzfKGvad2Z0HFejOek1ecTKYmeRTdCrk
         8PITQg5eWE/AvRxkeqSi0KzF2RdPlQyAfPkUI0kQrmNeWc2NesSVq5FWy1AS4abUZsk/
         zBNQ==
X-Gm-Message-State: APjAAAXSKPP/bZrtyL80I9zo0fVMPerCW3OHDWLTnthGzRt1ItTsTs+m
        Wn8R0rYnMkLJwYSB68W4a8v+cg==
X-Google-Smtp-Source: APXvYqzziP1gXIrCy1SyJhNWHHUvzLmGxJpg9XITmOgX/B2bstPcq529XCrjX5HV4uarQiFk/RFEww==
X-Received: by 2002:a1c:48c2:: with SMTP id v185mr18272017wma.61.1573476043963;
        Mon, 11 Nov 2019 04:40:43 -0800 (PST)
Received: from netronome.com ([2001:982:756:703:d63d:7eff:fe99:ac9d])
        by smtp.gmail.com with ESMTPSA id w10sm13458266wmd.26.2019.11.11.04.40.43
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 11 Nov 2019 04:40:43 -0800 (PST)
Date:   Mon, 11 Nov 2019 13:40:43 +0100
From:   Simon Horman <simon.horman@netronome.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        David Ahern <dsahern@gmail.com>, Thomas Graf <tgraf@suug.ch>,
        Jiri Benc <jbenc@redhat.com>
Subject: Re: [PATCH net-next] lwtunnel: ignore any TUNNEL_OPTIONS_PRESENT
 flags set by users
Message-ID: <20191111124042.74mb6l7tyatpg5iz@netronome.com>
References: <8f830b0757f1c24aaebe19c771f274913174d6a5.1573359981.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8f830b0757f1c24aaebe19c771f274913174d6a5.1573359981.git.lucien.xin@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 10, 2019 at 12:26:21PM +0800, Xin Long wrote:
> TUNNEL_OPTIONS_PRESENT (TUNNEL_GENEVE_OPT|TUNNEL_VXLAN_OPT|
> TUNNEL_ERSPAN_OPT) flags should be set only according to
> tb[LWTUNNEL_IP_OPTS], which is done in ip_tun_parse_opts().
> 
> When setting info key.tun_flags, the TUNNEL_OPTIONS_PRESENT
> bits in tb[LWTUNNEL_IP(6)_FLAGS] passed from users should
> be ignored.
> 
> While at it, replace all (TUNNEL_GENEVE_OPT|TUNNEL_VXLAN_OPT|
> TUNNEL_ERSPAN_OPT) with 'TUNNEL_OPTIONS_PRESENT'.
> 
> Fixes: 3093fbe7ff4b ("route: Per route IP tunnel metadata via lightweight tunnel")
> Fixes: 32a2b002ce61 ("ipv6: route: per route IP tunnel metadata via lightweight tunnel")
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Reviewed-by: Simon Horman <simon.horman@netronome.com>

