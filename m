Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4770458E376
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 00:59:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229463AbiHIW7Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 18:59:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiHIW7X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 18:59:23 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C68476A48C
        for <netdev@vger.kernel.org>; Tue,  9 Aug 2022 15:59:22 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id 13so11246297plo.12
        for <netdev@vger.kernel.org>; Tue, 09 Aug 2022 15:59:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uk9xllDpkkKXpKKIb2SVKChrgQXlBadBKkhIa/3xmyo=;
        b=dZ2uJaE62FdktfwqERKSuS1IY6YRO7A5RIsSwCjKhpQyrxa2ACOtIwvnqoxv9/gV/q
         p1/zDJ0gjYAmB4+1AZZ+GYoDktMby0jovdjOATZmxqc8o/I0BN2Su7+Ri9IUXHWI408C
         Qn2NLLkhzhZRf2O+9Q0Jgu/2XwL/MnNPE6TZU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uk9xllDpkkKXpKKIb2SVKChrgQXlBadBKkhIa/3xmyo=;
        b=dp0vYSu2Tjire4ezVjLZtvNUJ9/LDg/AqJ1Plq+KK5JVcIyUABpzAtnmKvm4jVjRcG
         sr6hwSiAVUzbhcTI/1+zcWGV2WBoJofXbUS4kL5Xd+oDz+G5ySL17MdZeHDNlPw/v3PL
         bLjcHzpasVlfARlQMAOw2YGFQI62sbs8/xaDtLKfL4MYa9HF6ck08wL0hFdrGuUw5pnK
         7JUYJMWfzmO/qIPeKdUKbjds1MQIquz+jjusZXLg6zmX00PV7fitBsR0fMk5OdoaSdYx
         uIO0nyNc2JZLLKiS/6YHAx/zs9OIjnVpM3FF+4GWR5u2GsfocP0XiyechR+PFuE3kLlq
         RTYA==
X-Gm-Message-State: ACgBeo0A8e04en5iSVe/QF/3snC41ZU1789YDFYa6auUUudM2hUEP8UG
        ARnGykccbzrLhqgMVYDoUoIB5w==
X-Google-Smtp-Source: AA6agR4VvwV5pmCbMvV+o4oZfGL8y9RJ4dr9r2jB8f+9e5BmgaE7XElONCJDKLTkLsgD/24bkYBbnQ==
X-Received: by 2002:a17:90b:ec7:b0:1f2:fa08:44cd with SMTP id gz7-20020a17090b0ec700b001f2fa0844cdmr672249pjb.183.1660085962328;
        Tue, 09 Aug 2022 15:59:22 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id gd8-20020a17090b0fc800b001ef9659d711sm111565pjb.48.2022.08.09.15.59.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Aug 2022 15:59:21 -0700 (PDT)
Date:   Tue, 9 Aug 2022 15:59:20 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
Cc:     linux-rdma@vger.kernel.org, netdev@vger.kernel.org, jgg@nvidia.com,
        leonro@nvidia.com, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, bharat@chelsio.com
Subject: Re: [PATCH for-rc] RDMA/cxgb4: fix accept failure due to increased
 cpl_t5_pass_accept_rpl size
Message-ID: <202208091559.5656BBD4@keescook>
References: <20220809184118.2029-1-rahul.lakkireddy@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220809184118.2029-1-rahul.lakkireddy@chelsio.com>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 10, 2022 at 12:11:18AM +0530, Rahul Lakkireddy wrote:
> From: Potnuri Bharat Teja <bharat@chelsio.com>
> 
> Commit 'c2ed5611afd7' has increased the cpl_t5_pass_accept_rpl{} structure
> size by 8B to avoid roundup. cpl_t5_pass_accept_rpl{} is a HW specific
> structure and increasing its size will lead to unwanted adapter errors.
> Current commit reverts the cpl_t5_pass_accept_rpl{} back to its original
> and allocates zeroed skb buffer there by avoiding the memset for iss field.
> Reorder code to minimize chip type checks.
> 
> Fixes: c2ed5611afd7 ("iw_cxgb4: Use memset_startat() for cpl_t5_pass_accept_rpl")
> Signed-off-by: Potnuri Bharat Teja <bharat@chelsio.com>
> Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>

Thanks for the better solution!

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
