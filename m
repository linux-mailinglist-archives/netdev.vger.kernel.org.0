Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9539D38103B
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 21:03:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232513AbhENTFH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 15:05:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231709AbhENTFF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 15:05:05 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECAEEC06175F
        for <netdev@vger.kernel.org>; Fri, 14 May 2021 12:03:52 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id c13so413377pfv.4
        for <netdev@vger.kernel.org>; Fri, 14 May 2021 12:03:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=VWunAqK+FZyoTV2vjU3HeNB9kZQfJxaL+p7FRXpB3v8=;
        b=JBsuXKPLey+XhgBL4O0cJdva2yDe7zLMx/jjM8bSnpRVxLrwz2JcMgo+bObx71S2GS
         cheyla6heHxUN0y0Nfx+LRGrcoXwQ9l5JKZKt37SyBvhyfrW02F62BJPBxUWghGz/REM
         psf5IE5vtuOIlUlEI6YoCQGUvYecvNq4icPpQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VWunAqK+FZyoTV2vjU3HeNB9kZQfJxaL+p7FRXpB3v8=;
        b=Oa2srSRaF9TbKrAi43LUfUjtMzvE6rsgwPgi2nLdJgLP/UwUjL9QNYHN7+mhxtAohE
         /z5fe0k+F9JChnBBhxaV+FaDdkoJLPvUs5w31qmdmPQACO5Mx1INDuvM7FKITYWR3/0z
         S5rDsX6a/tYuZN+e+LyOUFT2/QpEX9DRivMgHQBJ967/FsZgJEiiF0xKC6JzOt90zQnv
         SSr9pu7ZJVBFzBBQf+BAhgu3Gqn8xDlUJiPnA32wtpyi+TNDGjqvFFLj2379u71+b53p
         3x7ogoaBoS1bsX+UIzdU3u4w0v4MX0d+SMzhbpFjTUD6rLKgXZGDAUo9BDZcCdeKNv1H
         2sWA==
X-Gm-Message-State: AOAM5303sw45/pXGcKbnHLzfntitceLb9SL6xM2YxisbSIAPKejVx7Dl
        /n/4hBbJzh5iylXzTngKHvUgcw==
X-Google-Smtp-Source: ABdhPJy/2ssb8xICyRpzUdXDJOa7C5xielVPk0SjlrBIAD2a+w+docVTMCOrVjaCXs6HLij/mumypA==
X-Received: by 2002:a65:6549:: with SMTP id a9mr24482406pgw.213.1621019032283;
        Fri, 14 May 2021 12:03:52 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id c201sm4624403pfc.38.2021.05.14.12.03.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 12:03:51 -0700 (PDT)
Date:   Fri, 14 May 2021 12:03:50 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Casey Schaufler <casey@schaufler-ca.com>
Cc:     casey.schaufler@intel.com, jmorris@namei.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        linux-audit@redhat.com, john.johansen@canonical.com,
        penguin-kernel@i-love.sakura.ne.jp, paul@paul-moore.com,
        sds@tycho.nsa.gov, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v26 07/25] LSM: Use lsmblob in security_secctx_to_secid
Message-ID: <202105141203.60B0435@keescook>
References: <20210513200807.15910-1-casey@schaufler-ca.com>
 <20210513200807.15910-8-casey@schaufler-ca.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210513200807.15910-8-casey@schaufler-ca.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 13, 2021 at 01:07:49PM -0700, Casey Schaufler wrote:
> Change the security_secctx_to_secid interface to use a lsmblob
> structure in place of the single u32 secid in support of
> module stacking. Change its callers to do the same.
> 
> The security module hook is unchanged, still passing back a secid.
> The infrastructure passes the correct entry from the lsmblob.
> 
> Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>

This looks like sane refactoring into the new blob type.

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
