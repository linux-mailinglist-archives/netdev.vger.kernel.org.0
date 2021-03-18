Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C77F340CF1
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 19:29:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232216AbhCRS2j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 14:28:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbhCRS22 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 14:28:28 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 910B0C06174A
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 11:28:28 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id v2so1997644pgk.11
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 11:28:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=di61z0+6G1KqhJV1Y5CWvNlk0LTY4PxQLfbGiAMX8jY=;
        b=bQtsOG410LIgWoMin+2WpIpvNAwTkpO123nTGs+a4mqH0BL4Y7mk15SRqZDXo6b0Nt
         F56C21zWYKjA1b40MQ6uuT1C17cLTg9XWTLbJ4TVJX0yxLaolc+NMe84t86hzbQwuczX
         YN8sge6K/QMzjGlBhOtVEfANVNjCYIJO696+U/qn44AxJTL00wrdBwm1Qfv5Rg3zjuGi
         djXDTjBT2zR3h4/0qoBOa93X0qS9yg5DaT6cduRMfWHKOsO07R2oX/cJtTttSiGmXz2g
         lbfP3OJTi9foIOVGlRW9jvMz9OIrFi9OoIHk6DpSxb7pzWI0mnNe4QjeQyqtQJXpuUQv
         uJnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=di61z0+6G1KqhJV1Y5CWvNlk0LTY4PxQLfbGiAMX8jY=;
        b=Rdz3f0GgFaBNDgWM6jkZepxT2E32JqfOuBbUbV9adp9AVLjjjrbBlUblUwOJlnqY8o
         g8yJG4M3EL2LKB+ZU1kNIhtbZzKokxcVdu4loh41kPnLHvboTQiECEboxWwxc5AEQkSA
         E3og8FbBPOPxpW9CmFi1Zomn7004o4QaVODUXXZwjzLviQNWGV/lwoq6V1LQdNsin8Wg
         t203ooThCljDrFY5/tFeHc/gsnezm4PgaqC9AOReIpyZNOoGIzRSE7jbr5aQ4L9I7bvl
         IHoKVzglns4RUbDSyKbOYPVCHKqPpY6LYWs/uW6l8PJWHY5LVaW6xWIjBu4+8mDvBhrV
         csug==
X-Gm-Message-State: AOAM531wexeXCTdNhQTAhAFvdVUO2vpw02bAM4bWDtCAEsV0Q4kkJSWO
        TNqCDnYKMux1h38NeXARhri6wQ==
X-Google-Smtp-Source: ABdhPJz9/iP+LJfsLXO+8UKQstlMvy3+NXQATHSZ8RRZGTW4/rJlEHFDMApSPYi+9325iLT6KJYGig==
X-Received: by 2002:a65:4288:: with SMTP id j8mr7989187pgp.231.1616092108012;
        Thu, 18 Mar 2021 11:28:28 -0700 (PDT)
Received: from hermes.local (76-14-218-44.or.wavecable.com. [76.14.218.44])
        by smtp.gmail.com with ESMTPSA id 133sm3284873pfa.130.2021.03.18.11.28.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Mar 2021 11:28:27 -0700 (PDT)
Date:   Thu, 18 Mar 2021 11:28:19 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Jiri Bohac <jbohac@suse.cz>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Jiri Pirko <jiri@nvidia.com>
Subject: Re: [PATCH] net: check all name nodes in  __dev_alloc_name
Message-ID: <20210318112819.476f7e20@hermes.local>
In-Reply-To: <20210318090652.tetotzcnoiqjtlue@dwarf.suse.cz>
References: <20210318034253.w4w2p3kvi4m6vqp5@dwarf.suse.cz>
        <20210317211108.5b2cdc77@hermes.local>
        <20210318090652.tetotzcnoiqjtlue@dwarf.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 18 Mar 2021 10:06:52 +0100
Jiri Bohac <jbohac@suse.cz> wrote:

> On Wed, Mar 17, 2021 at 09:11:08PM -0700, Stephen Hemminger wrote:
> > Rather than copy/paste same code two places, why not make a helper function?  
> 
> I tried and in it was ugly (too many dependencies into the
> currecnt function)
> 
> Another option I considered and scratched was to opencode and
> modify list_for_each to also act on the dev->name_node
> which contains the list head. Or maybe one of the
> list_for_each_* variants could be directly misused for that.

That seems like overly complex and unhelpful option.

> I don't understand why this has been designed in such a
> non-standard way; why is the first node not part of the list and
> the head directly in the net_device?
> 
> In the end I considered the copy'n'paste of 9 lines the least
> ugly and most readable.
> 

Sure, make sense.
