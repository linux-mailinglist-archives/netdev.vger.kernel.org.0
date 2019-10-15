Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9ED38D6F71
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 08:12:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726869AbfJOGMW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 02:12:22 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:35505 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726101AbfJOGMV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 02:12:21 -0400
Received: by mail-wr1-f67.google.com with SMTP id v8so22232303wrt.2
        for <netdev@vger.kernel.org>; Mon, 14 Oct 2019 23:12:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=8jhn3G6ooIBKGF5W+1nI+KeFPaB8M8BxZpMwU7ttwsA=;
        b=gZWcCNEurTz1q97i2tw4BVFfvF9TVMulsdVWSO5PxelldzthOfSIDzr9koXKwEYz5Z
         ViVYpBEpNVB/97lDTHpeZMoYldeVBauxnrZ/+bGAD3yfKyR6pm7gjr6dlDbZfVCWL60d
         OVnRQw/4wAP+ygJ33XCBNepS1z6C+meFRnci+slrbhV1ZWAKWdXCrwqvTgB5Rwef7aM5
         /GgYUapD0q0TeACOCDm+v71JJ9aSRW9neCFHkbX/8f8wJkGkTCo0x78g+6UvFAvgAf2d
         adAErGImevYk3BRPCMeCn606jaYPEUmRf2JthH2KYA6LwLQA2++U1AHfF2cB0YPSmDEV
         toDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=8jhn3G6ooIBKGF5W+1nI+KeFPaB8M8BxZpMwU7ttwsA=;
        b=nP5fni8/0VpIYSf2arRD6uM7OBEI2RJzPM7BYMNmu2lxUSvZW1ImnVSGKiIifp9w/x
         37x4g/5XarTd9GALd6A9QDNZ3J7t7n5EOKviUB/vHrwDLoph2uOkhkRL05aRIGY/DF6X
         frWE9aKEPU/GKuv7zL2XqEE8ySoH7bvuyP+zCwbl06RArY7WQqPWTlIWrohgWHxwupou
         aBv7O7l0hmrIqETGp96CYnx42qscjnJSPmC8RPaS8peQhtU5rbAkpjjizS06zQEXa48r
         sZBi32CNIKJHH+FuhqrwqE8VaWNFkRa7PqOLZcT8jpein48znRDDLepLgRCe7SmoryQQ
         F+Pw==
X-Gm-Message-State: APjAAAWXIVsNHEexuBRWCf9KwWihCb+Pl0ryLYbz35MLbHHNJ7ARUieM
        p71himsx7+J7wlTAhrMEiklvJQ==
X-Google-Smtp-Source: APXvYqxwAJCgfNd6ynp2vWCs508GmziRVxnjiz5aF1Z4eQm7uWrQ1dpzzfDD9KoJBfvo4hueP0mk7A==
X-Received: by 2002:a5d:488f:: with SMTP id g15mr15696552wrq.9.1571119939771;
        Mon, 14 Oct 2019 23:12:19 -0700 (PDT)
Received: from localhost (ip-89-177-225-135.net.upcbroadband.cz. [89.177.225.135])
        by smtp.gmail.com with ESMTPSA id o19sm25305238wmh.27.2019.10.14.23.12.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Oct 2019 23:12:19 -0700 (PDT)
Date:   Tue, 15 Oct 2019 08:12:18 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, jakub.kicinski@netronome.com,
        saeedm@mellanox.com, vishal@chelsio.com, vladbu@mellanox.com,
        ecree@solarflare.com
Subject: Re: [PATCH net-next,v5 2/4] net: flow_offload: bitwise AND on mangle
 action value field
Message-ID: <20191015061218.GE2314@nanopsycho>
References: <20191014221051.8084-1-pablo@netfilter.org>
 <20191014221051.8084-3-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191014221051.8084-3-pablo@netfilter.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Oct 15, 2019 at 12:10:49AM CEST, pablo@netfilter.org wrote:
>Drivers perform a bitwise AND on the value and the mask. Update
>tc_setup_flow_action() to perform this operation so drivers do not need
>to do this.
>
>Remove sanity check for sane value and mask values from the nfp driver,
>the front-end already guarantees this after this patch.
>
>Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Acked-by: Jiri Pirko <jiri@mellanox.com>
