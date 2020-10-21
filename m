Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E63A295553
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 01:48:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2507297AbgJUXsj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 19:48:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2408091AbgJUXsj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Oct 2020 19:48:39 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E443C0613CE
        for <netdev@vger.kernel.org>; Wed, 21 Oct 2020 16:48:39 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id a200so2424048pfa.10
        for <netdev@vger.kernel.org>; Wed, 21 Oct 2020 16:48:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=f10vmgX7jXKo9E3thDnh3S0Y4fRJR8z4hDcpxjP8T+g=;
        b=SSiuK9Hq+WzNgZWEJtiFvDoomfJr/Xi6SGtiB3J0TJmw1+PSqkQMZndBNPrXlAQYV7
         19TmcfEpR1CjVKGWhfRpr3eKqWHv5cuy6kBViF12WikINxrdTii/QyKh7JdBS7DCP9J+
         EmDPc5dfzep+2IRH7zsclqQ6lZC20B7tnQ7lE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=f10vmgX7jXKo9E3thDnh3S0Y4fRJR8z4hDcpxjP8T+g=;
        b=I2rIeDEbxKBFbiyLuxY4dt/z04dYiyoZ4znoPwAVXYA+U5Z1vbb7NNlPBtp/ACUIFl
         FWkbus1fKkZ3povil6z+nN/qkOHbuMfXHb55LY5YGeHtlauzC+LxHFfoYhsqXkoITNlB
         ya3r7qTpLsZZznkzSqKaKH/jI27kb0ab0W8RdNf2LM4rU0nacdezwP71rLBniwslgigZ
         s1B0uOTH2DiwzgNtCGF6EIxrOP90/9IULiRVTBBpW3AJfXu9BlXCTG2tTIdW0SrJBReV
         EGWUZfdN33BEzgSFGCYeRrgq0kHK16CM4svUZXbgfsvSCttMjqBAykxxQs8+WBiO1SZq
         +8pA==
X-Gm-Message-State: AOAM533s18GcEGHPZXb4c0OziW40adtfS2nD+oWttNZaG7co7MUfh//z
        Vj2JsMBzHLlkSeustAkZyddpfg==
X-Google-Smtp-Source: ABdhPJxqbDqLPvR+s6SlaFCJTQyNZAo8JVF2fzS2DVEHzp+Kzr27m/Ow1Zi17gLvmPgEspBua8YrAQ==
X-Received: by 2002:aa7:97ba:0:b029:152:879f:4789 with SMTP id d26-20020aa797ba0000b0290152879f4789mr16223pfq.81.1603324118711;
        Wed, 21 Oct 2020 16:48:38 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id 186sm3370129pff.95.2020.10.21.16.48.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2020 16:48:38 -0700 (PDT)
Date:   Wed, 21 Oct 2020 16:48:37 -0700
From:   Kees Cook <keescook@chromium.org>
To:     laniel_francis@privacyrequired.com
Cc:     linux-hardening@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org
Subject: Re: [RFC][PATCH v3 2/3] Modify return value of nla_strlcpy to match
 that of strscpy.
Message-ID: <202010211648.4CBF3805A9@keescook>
References: <20201020164707.30402-1-laniel_francis@privacyrequired.com>
 <20201020164707.30402-3-laniel_francis@privacyrequired.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201020164707.30402-3-laniel_francis@privacyrequired.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 20, 2020 at 06:47:06PM +0200, laniel_francis@privacyrequired.com wrote:
> From: Francis Laniel <laniel_francis@privacyrequired.com>
> 
> nla_strlcpy now returns -E2BIG if src was truncated when written to dst.
> It also returns this error value if dstsize is 0 or higher than INT_MAX.
> 
> For example, if src is "foo\0" and dst is 3 bytes long, the result will be:
> 1. "foG" after memcpy (G means garbage).
> 2. "fo\0" after memset.
> 3. -E2BIG is returned because src was not completely written into dst.
> 
> The callers of nla_strlcpy were modified to take into account this modification.
> 
> Signed-off-by: Francis Laniel <laniel_francis@privacyrequired.com>

This looks correct to me. Thanks for the respin!

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
