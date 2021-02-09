Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ACF63145D7
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 02:52:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230124AbhBIBvp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 20:51:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229706AbhBIBvn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 20:51:43 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DC5CC061788
        for <netdev@vger.kernel.org>; Mon,  8 Feb 2021 17:50:58 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id g15so11455208pgu.9
        for <netdev@vger.kernel.org>; Mon, 08 Feb 2021 17:50:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DEtTmjMMfKq4GSMEtyWaoKbCUYTiknKD4j8aFmC5Eh0=;
        b=HsoiQG4Py7+1v+fjCv6ZAfguMEGPr8N+PqtWwyG3fejUvxtd88Zm5Y8ZSvCi4puwp7
         90RWX1HWY4LEe/ykqwrkEZ1lgqDoOMKGpDpEInEXLUaoDedhnvWzCbXP3PTE/0G6UK4C
         uYacOr2R+BDLj+l6Sa1vCeQxlETZDxwmFHcgx0zLszQ2sb1qvONV4FVpjc/ODMOwo/2r
         HDu2OR0nm0zMfVhB/+dOJWZJ9rcm3t+DXYZ0Ws+AVgFQaE39ItJMktC/uHygCax0JmTp
         1Ot4D8cmCj7yDsUOuW5au/fwgVUkSC62jglz8yEn/G283gWIfVaCezADTR8bse6CTDIB
         zFWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DEtTmjMMfKq4GSMEtyWaoKbCUYTiknKD4j8aFmC5Eh0=;
        b=OxA8XaCVdNy7Qgoz/0+GMHUXK+wC8RqIh2ZVUmO/xtqCDXawxHn4JhhQlzzkc9H95S
         EN3TNDEFnsK1gkPfarpmh+n8XW462DdR1mxwQPXRdt3FX48b9bf0vhO5Z7nZg+Cl7OaL
         6TiaN4awU7ndz4ZqeoRhIqxkf6cf3RF5WAtc90NDXVJSH42V862dOO0bTPnOaU+wyLQy
         hHEPi9seGfQ8gdKhdPGmjDRtv0yF7kG0gbnUoagCsf/DMU2bRVG6NVX1JMsE71l49iVj
         0yJ/sOqM0q6bF+mz0e0tc5E4ofSEGoRo92XoCzWo+BufzHwv2za0T2UHYj5MBHRDX/RP
         CHrg==
X-Gm-Message-State: AOAM532W5BoxcU1S8CL4HE8ryK7XpEpxozDGeWJkuf0SOlGc00KGk3uU
        FlxZ8fSGRSgEf7H13C5UKfTpBPX++x6ACFwAZmc=
X-Google-Smtp-Source: ABdhPJwNtimmkpLTXS5B8CRcjIaz3OhNjfB8J8VkiKPQvW5/pAPzJKwTrGHX+fq+TuVn5W7sqfAnsiuH8dD3usRoMGI=
X-Received: by 2002:a62:ed01:0:b029:1c8:c6c:16f0 with SMTP id
 u1-20020a62ed010000b02901c80c6c16f0mr20596406pfh.80.1612835458055; Mon, 08
 Feb 2021 17:50:58 -0800 (PST)
MIME-Version: 1.0
References: <20210208175010.4664-1-ap420073@gmail.com>
In-Reply-To: <20210208175010.4664-1-ap420073@gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 8 Feb 2021 17:50:47 -0800
Message-ID: <CAM_iQpU5Z_pZvwKSVBY6Ge8ADsTxsDh+2cvtoO+Oduqr9mXMQA@mail.gmail.com>
Subject: Re: [PATCH net-next 0/8] mld: change context from atomic to sleepable
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        dsahern@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 8, 2021 at 9:50 AM Taehee Yoo <ap420073@gmail.com> wrote:
>
> This patchset changes context of MLD module.
> Before this patch, MLD functions are atomic context so it couldn't use
> sleepable functions and flags.
> This patchset also contains other refactoring patches, which is to use
> list macro, etc.
>
> 1~3 and 5~7 are refactoring patches and 4 and 8 patches actually
> change context, which is the actual goal of this patchset.
> MLD module has used timer API. The timer expiration function is
> processed as the atomic context so in order to change context,
> it should be replaced.
> So, The fourth patch is to switch from timer to delayed_work.
> And the eighth patch is to use the mutex instead of spinlock and
> rwlock because A critical section of spinlock and rwlock is atomic.

Thanks for working on this.

A quick question: are those cleanup or refactoring patches necessary
for the main patch, that is patch 4? If not, please consider separating
patch 4 and patch 8 out, as they fix a bug so they are different from
the others.

Thanks!
