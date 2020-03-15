Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EB0D185FDF
	for <lists+netdev@lfdr.de>; Sun, 15 Mar 2020 21:55:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729179AbgCOUzv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Mar 2020 16:55:51 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:42717 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729152AbgCOUzv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Mar 2020 16:55:51 -0400
Received: by mail-pg1-f194.google.com with SMTP id h8so8452630pgs.9
        for <netdev@vger.kernel.org>; Sun, 15 Mar 2020 13:55:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tbQkUnVAWk4DdNT2eI9KPJ4CRtZVJETNZZv1PgzqPdM=;
        b=TUqHtxacJZiW83OVGKgFfuF6Fc/KC14JPIfKhWr/ZLp8b86LYAZcIh4ZLGLvv8HUqh
         qDzP4e7q1vFJZKCl55haTEh/XB2LBczr02MYiehd3c1KVo8oo4NkaGTGAtwHlXKE2t/M
         7pcrHYhRordlMkfMW29YuYSIcpzYZyDZ1wDpc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tbQkUnVAWk4DdNT2eI9KPJ4CRtZVJETNZZv1PgzqPdM=;
        b=pD+jMzRDeCvhv+xwWYcu/PuFI6S1+J6jyqUgQ8WBhxH3zY0YXkBFHBo9t/kr18Tcix
         5QinPPX2DwBk4GUrUUFxRrB9AMp3iZp/UMnHYfjHI3hV8uAMo1zKrrOXRZ1bZYf/USLt
         ZRiA68s1hQ7eSEGltLxYFDgE3jfO2lkfOjcvD6E83cPa7UyK4bBab66ywDSe2EsNAJbI
         JBv9BsroCYEbipkoW8MV7RnzG2B6LI8nTsyENik2za34MQ9xH78D7gysArZroVNYx0TD
         7lx4UWxtWX3CAd2EEsA7nieiFbtg/bJrs+SE/VM9/n2T4+EWpvZmwyhR6aeU4X151Qyn
         pxFQ==
X-Gm-Message-State: ANhLgQ3LR2156ohN9TYdUcFaoKUZ9L7k5NOq28NBRH9jCJwXylyYUGB6
        kJV3grYh+zdG8oIKVOcgVqdhAA==
X-Google-Smtp-Source: ADFU+vtxEx4oeojuJNx6exzRxdGuXoqCl51ncVvkkl2QI21JaiWr2FV9967v4dRa9pBNfHP5Tulp2w==
X-Received: by 2002:a63:a06e:: with SMTP id u46mr23528688pgn.140.1584305749808;
        Sun, 15 Mar 2020 13:55:49 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id h23sm13566341pfo.220.2020.03.15.13.55.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Mar 2020 13:55:48 -0700 (PDT)
Date:   Sun, 15 Mar 2020 13:55:48 -0700
From:   Kees Cook <keescook@chromium.org>
To:     David Miller <davem@davemloft.net>
Cc:     kuba@kernel.org, shuah@kernel.org, luto@amacapital.net,
        wad@chromium.org, linux-kselftest@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH v2 0/4] kselftest: add fixture parameters
Message-ID: <202003151355.C9118025F@keescook>
References: <20200314005501.2446494-1-kuba@kernel.org>
 <20200315.000517.641109897419327751.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200315.000517.641109897419327751.davem@davemloft.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 15, 2020 at 12:05:17AM -0700, David Miller wrote:
> From: Jakub Kicinski <kuba@kernel.org>
> Date: Fri, 13 Mar 2020 17:54:57 -0700
> 
> > This set is an attempt to make running tests for different
> > sets of data easier. The direct motivation is the tls
> > test which we'd like to run for TLS 1.2 and TLS 1.3,
> > but currently there is no easy way to invoke the same
> > tests with different parameters.
> > 
> > Tested all users of kselftest_harness.h.
> > 
> > v2:
> >  - don't run tests by fixture
> >  - don't pass params as an explicit argument
> > 
> > Note that we loose a little bit of type safety
> > without passing parameters as an explicit argument.
> > If user puts the name of the wrong fixture as argument
> > to CURRENT_FIXTURE() it will happily cast the type.
> 
> Hmmm, what tree should integrate this patch series?

I expect the final version (likely v3) to go via Shuah's selftest tree.

-Kees

-- 
Kees Cook
