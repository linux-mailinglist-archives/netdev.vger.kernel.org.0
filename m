Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05A281E81ED
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 17:36:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727078AbgE2PgU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 11:36:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726962AbgE2PgT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 11:36:19 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E71FC03E969;
        Fri, 29 May 2020 08:36:19 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id y1so2203064qtv.12;
        Fri, 29 May 2020 08:36:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=c+MMdeVxRZeoQGBWcJz8mkMsH1Gvo3n6WkWpW9us2ZE=;
        b=IZqgJwWgF8fJuC0MrftA1lZ75spdnAIvnhcXFABTcbKXU3wRCbDxGSx+HQxpi9NqM1
         c/rMH8b0VfrwwZ3g8TS3ZoC2ED9ooh8EaVZlqK4bA9qB+BUSb+vDE5PfAGHwBh00T2YX
         pcKl4G1Zeu8VbRwgJYgVrjfdaI2rGQlafO0qvjfOK7/mVyZ5gFO+7L0Jsokf4SFR3iLh
         MmQ5bEgIR1Ss90zdJLTPZDnnF7VbBOtO3uAVXQ5nelSNcugZ5yoWI58fmyh+a3tq/2CJ
         UtC/wUHBBk9E1RxlpeKHWhqER7ucka5S0J6qIDaFmlM224VQXnBxEAjyi1M5xqAF/Msz
         wBTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=c+MMdeVxRZeoQGBWcJz8mkMsH1Gvo3n6WkWpW9us2ZE=;
        b=hGLSGqabSJ0GMvDVDcBJQJ3mvqx+M7KuTBHsJTFAZPnI8jAEhDmbztMiNRUv17EcjT
         iwEOAdQcgFCmlbTwpHLC4Ic+mm+KXVjmbF2rgwkpzq0Xd7UrURhHFs/ulyPJ2GCnBsJS
         DVaLXamQJziEsgZAlMzGTP8dufxKb2h3CxDdB2B8GvcdtX4XoMZllhY+WcUuZDEVKYSs
         8NiP2f/u4cKtO9cQOztG5YgUclFW85Tm9AMV0sZ2iaDH4Dzih56uL76OdvC4WPQ6+bT0
         1YTq8noqucd4+TMowi3TvAbA3zrVF1SDu2BwgRSTvofbWajyRM5VfdRpLq3fSNt7jNMH
         H4Gg==
X-Gm-Message-State: AOAM533hLqBhXcpRBn4mHHZqkjT/aRuBm/V2+8RrLmw/Vy+Uc2FdvZEE
        y0Z6okH5zdah08Ft6WtscHg=
X-Google-Smtp-Source: ABdhPJw4vHoX3KGzV7ayHVSDIVNT4rGOKKSPk3aMjUknrdGg6XXceYdmBj27dmlSTvfr/pkx7y/rUA==
X-Received: by 2002:ac8:2492:: with SMTP id s18mr9267013qts.81.1590766578416;
        Fri, 29 May 2020 08:36:18 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:9452:75de:4860:c1e3? ([2601:282:803:7700:9452:75de:4860:c1e3])
        by smtp.googlemail.com with ESMTPSA id w10sm8773648qtc.15.2020.05.29.08.36.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 May 2020 08:36:17 -0700 (PDT)
Subject: Re: [PATCH v3 bpf-next 1/5] devmap: Formalize map value as a named
 struct
To:     Jesper Dangaard Brouer <brouer@redhat.com>,
        David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        kuba@kernel.org, toke@redhat.com, lorenzo@kernel.org,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com
References: <20200529052057.69378-1-dsahern@kernel.org>
 <20200529052057.69378-2-dsahern@kernel.org> <20200529102256.22dd50da@carbon>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <2a121938-fe50-694c-40c6-0f4b8edbefb5@gmail.com>
Date:   Fri, 29 May 2020 09:36:14 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <20200529102256.22dd50da@carbon>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/29/20 2:22 AM, Jesper Dangaard Brouer wrote:
> We do need this struct bpf_devmap_val, but I think it is wrong to make this UAPI.
> 
> A BPF-prog can get this via:  #include "vmlinux.h"

sure. I see that now.

I forgot to fold in a small update to the selftests, so I need to send a
v4 anyways. I will wait until later in the day in case there are other
comments.
