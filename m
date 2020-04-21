Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C89831B3064
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 21:32:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726335AbgDUTb6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 15:31:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725930AbgDUTb5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 15:31:57 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 606BCC061BD3
        for <netdev@vger.kernel.org>; Tue, 21 Apr 2020 12:31:57 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id e6so1830505pjt.4
        for <netdev@vger.kernel.org>; Tue, 21 Apr 2020 12:31:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=NZNBzPPg39ZyrA+9K1+5SfyJG/p/D3ab1EaiN8kOOpQ=;
        b=D5E4GkQI8kMxBOpuDMOjkCGLYjzhv9SzQx5s04xfcN97rcZAXp10VOjQbSAr2Va2Ep
         xOLMpcHjY6zHeW3ZNP3LQzJ0SI8bn5J7t4sslKU5XoQ8Hh7f/hmV2OTnxPoAF8Ci6nyN
         khM6ZLtn45Nblr0G9fbnMUFmCSjbE687sAfFlBF1OaQI60mi6gjnomTCbesFpqhm3BVV
         RD+IOKedrI/zH7nugKGj5JxvNaJpwHc7iAPT/cZDE2h8z/lyWZ5haQUSHayyaaVJjnis
         3vFRPZc89wAtD42w3NPuMAAgRbODqu8Ixx1ApaoC8jSjx15fAdrO1g+HM4T+YSNo5KeE
         imow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version;
        bh=NZNBzPPg39ZyrA+9K1+5SfyJG/p/D3ab1EaiN8kOOpQ=;
        b=ATmd6VVtA4HXnhfqx4D/1vSboQtY+aAokKJwfyRyOzZNEOQxOTzkquZ/ICiGYxqbWm
         /y4HW9AJvVu07dMbuUSEgdYOHLBfMC3CHs2EvGWemUPOc6+vDogHvPCPdbGsHvFF1zFZ
         r/eoV8TIzBZ43Vm8oUWODTo34EQyrIPxBp0sI3E+9e9JagQlFgXInOsAvzprPfabcXK9
         yVSdn8ODk8Njx94L36QQxjx/d+0KxiYjD3KmFuWv1BYB4gjA7Q23drt9aAzWvL85vuou
         IkZlwJVJX1qBptwSGF5GOJ+OWPNX4AsMlKVL+AI64N/AYDDcsLATNKwe6f5+c3SU2lZt
         f34Q==
X-Gm-Message-State: AGi0PuaaP8HjmSd7euOq5+ub+T7cs5b2Ia/E0st8oOgHXJxOMCOcZGnp
        Oi5K64GZWvt8gWAHfBV/9Yc6jw==
X-Google-Smtp-Source: APiQypJFBgqr1TsKQVWWIkIK19DIg+mC/W2jjmH2JPSKGjxUsdqPajleKdFLi5uyE7M2nN3ydVuYqg==
X-Received: by 2002:a17:902:c193:: with SMTP id d19mr21224614pld.184.1587497516540;
        Tue, 21 Apr 2020 12:31:56 -0700 (PDT)
Received: from [2620:15c:17:3:3a5:23a7:5e32:4598] ([2620:15c:17:3:3a5:23a7:5e32:4598])
        by smtp.gmail.com with ESMTPSA id y25sm2998977pgc.36.2020.04.21.12.31.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2020 12:31:55 -0700 (PDT)
Date:   Tue, 21 Apr 2020 12:31:54 -0700 (PDT)
From:   David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To:     Christoph Hellwig <hch@lst.de>
cc:     Kees Cook <keescook@chromium.org>,
        Iurii Zaikin <yzaikin@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH 2/5] mm: remove watermark_boost_factor_sysctl_handler
In-Reply-To: <20200421171539.288622-3-hch@lst.de>
Message-ID: <alpine.DEB.2.22.394.2004211231410.54578@chino.kir.corp.google.com>
References: <20200421171539.288622-1-hch@lst.de> <20200421171539.288622-3-hch@lst.de>
User-Agent: Alpine 2.22 (DEB 394 2020-01-19)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 21 Apr 2020, Christoph Hellwig wrote:

> watermark_boost_factor_sysctl_handler is just a pointless wrapper for
> proc_dointvec_minmax, so remove it and use proc_dointvec_minmax
> directly.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: David Rientjes <rientjes@google.com>
