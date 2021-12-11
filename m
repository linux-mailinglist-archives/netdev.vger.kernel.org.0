Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 274D5470F3D
	for <lists+netdev@lfdr.de>; Sat, 11 Dec 2021 01:09:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244172AbhLKAMr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 19:12:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237677AbhLKAMq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 19:12:46 -0500
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18FEFC061714;
        Fri, 10 Dec 2021 16:09:11 -0800 (PST)
Received: by mail-ot1-x335.google.com with SMTP id n17-20020a9d64d1000000b00579cf677301so11269949otl.8;
        Fri, 10 Dec 2021 16:09:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=AjuBUrbI07vSicWM7Jf3wVpvEq4PKtw2sqmTEx6HEpc=;
        b=aySVZBDnKt2IMf0iKJvfcKDePWUac4vo6TUNn6F1IeL2XX2y0cPrfmEJl/fVQqLrJU
         QOfBNCdvByYPnJ2Eof9oWvWhV2OzCim0hETU9ydzqYtzXrcXBvmxzK5carvPKBabQZ6F
         ETKQ5Z7b0PjNON0cwP/kthwiT9DGr6tPfB2Y+JLV1f1+jl6ZijPwpWxi6ykLKxnQ5Ol/
         TC1IPTFOKxZNzzhjcvjCLzPmZD0rouF7YVBs9/w/Tfk9oefZVjcsiIVkR2mYTFqT0Jcb
         PCmD6ZbjlCXl9h7ghqqLwIkGp01QXxn9iRSxCp6clulv4n5TYfUe1H0gCObS/E2GUKxZ
         OuEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=AjuBUrbI07vSicWM7Jf3wVpvEq4PKtw2sqmTEx6HEpc=;
        b=du6faER7607E2wjzptplC3YipmyUyJ5UrGod4FvC2eaVf5s824cYZ9if3CeLKVLwvN
         0mQ90XKlxKwKsGm7smSMOGIQqQtnrj7t1nXaj3zWLfasupDSHgqqq1Hp0gLCuSzlK3I+
         C+VyV0PhP/qaVXadiqOdchqlE3rMWosS2izCne57rPfbjW3rr8OffUeFNvC1skJqafTr
         rF6mPlP7zu7tHg9CbD3CFn2voEzpAO8/lTEu3HUK/lMEvQ8Kfx7NOKwpVZGPWDyWaOT3
         FQb56RFN7rp+ib7gUaHS4Djp4EnOo4iDv1oSZZI/Gof/b9+spTeoFKg4v+UqgFodCZka
         aJGg==
X-Gm-Message-State: AOAM532Ux3m6/fYaiOCgKIze0k0yB5cvxrX/kno0nAadNvoSVu9r4Vra
        xwZbGAELGgl3t/OuctEJm5w=
X-Google-Smtp-Source: ABdhPJwkzaZ63+TBnIkAwTr89v4wOdwK6J+OKJeGZAnAvfp7dYMZi5sqZ/yBa3oZmsBY6s1RKmSePg==
X-Received: by 2002:a05:6830:4d6:: with SMTP id s22mr13951906otd.270.1639181350460;
        Fri, 10 Dec 2021 16:09:10 -0800 (PST)
Received: from localhost ([172.243.151.11])
        by smtp.gmail.com with ESMTPSA id t5sm818107ool.10.2021.12.10.16.09.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 16:09:10 -0800 (PST)
Date:   Fri, 10 Dec 2021 16:09:02 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Message-ID: <61b3ec1e6868f_2c4032083e@john.notmuch>
In-Reply-To: <8a7a7972107efa6e2ba8e603bd5f054c79de3431.1639162845.git.lorenzo@kernel.org>
References: <cover.1639162845.git.lorenzo@kernel.org>
 <8a7a7972107efa6e2ba8e603bd5f054c79de3431.1639162845.git.lorenzo@kernel.org>
Subject: RE: [PATCH v20 bpf-next 03/23] net: mvneta: update mb bit before
 passing the xdp buffer to eBPF layer
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lorenzo Bianconi wrote:
> Update multi-buffer bit (mb) in xdp_buff to notify XDP/eBPF layer and
> XDP remote drivers if this is a "non-linear" XDP buffer. Access
> skb_shared_info only if xdp_buff mb is set in order to avoid possible
> cache-misses.
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---

Acked-by: John Fastabend <john.fastabend@gmail.com>
