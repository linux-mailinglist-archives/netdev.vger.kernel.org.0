Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCD7029DB2F
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 00:44:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389640AbgJ1WvE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 18:51:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388114AbgJ1Wsg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 18:48:36 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F799C0613CF;
        Wed, 28 Oct 2020 15:48:34 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id s15so1185961ejf.8;
        Wed, 28 Oct 2020 15:48:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Pp16dBQBBlf/9dVYs6G5ARUBtflMbvFTVbY3ulB6k00=;
        b=rvcbKJXQ0/tONTT3At9ENuKpCDUyxM5lpxPa/cva3ibRsVxeogublke5/zAumnaOrE
         pEeTeYtFc9/OTTYELvHmPGucguBQhQwVhMnNWPNNObZK/9DjBMKlsuHgJzmvTglWKhJc
         gSzwnBfWCVFvf+rn2lb6HUm849hiJUdrltQOQslhxZ1Yaq9LMJS9MzRM+PUtofm3jg1o
         3IZlz6hDT/cK5Ufx50x1fvKPiKQ71yAkOsdwLXKjqNaufYOOEOJ7kA09BkNCD34MUGKl
         mpcH710+arytSNNCmYrFPmBq9P0sp8MD8eL0WBPKHoYB1ctSKLI5GcNemuAndFITck4N
         dkhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Pp16dBQBBlf/9dVYs6G5ARUBtflMbvFTVbY3ulB6k00=;
        b=TmE5xrD5lXXbvj6zDQ+Lm12O/aZsjsJQwx7amtdQ+BGgC7RF30fM9PEtY26yc1131p
         c1E21Z65qnFgQxGTQxQ/miXX9wX9NQ+0Z7TLNVGNu01bXrZZTC08DDkHz/J4z86pXTMn
         4ok2I4W5bbY535JXTJ4PCoR/xRC6GAqb/Z2fQ8e2vSoXYDntxzc8EclqQcyi/MiXfHO5
         uZqJOESgKRsKSenPIv89QN9XVoY77Xu6xWfeXwy8tpYZ4NrSa2NbGsyZjQiOd/vkjR7R
         KlXv3j007+C+etSJLU2lf8al3Ts4/vK4/gLouFlWjAxgrR2AZy8qJjWLw0zE7QJYN9gU
         8Nyg==
X-Gm-Message-State: AOAM530esiS4lSsDQgYUmSYQG5cChJqJzyeM8MIueX5bMWTZhvGj5V2B
        yWRI4uN5QCLX0BZl5OV59s431HHW4UipwNbnBeceoWxk
X-Google-Smtp-Source: ABdhPJziVtOva/fk3jdTC0vhOQGvoWANvhh0VmXgD3L4sOioAyLX6I24KCwxJDmgS1GKzHU8+sIyYLCqGATg1/p89ik=
X-Received: by 2002:a17:906:a250:: with SMTP id bi16mr7046239ejb.265.1603892579255;
 Wed, 28 Oct 2020 06:42:59 -0700 (PDT)
MIME-Version: 1.0
References: <20201027161120.5575-1-elder@linaro.org> <20201027161120.5575-6-elder@linaro.org>
 <CA+FuTSdGCBG0tZXfPTJqTnV7zRNv2VmuThOydwj080NWw4PU9Q@mail.gmail.com> <95d20d91-d187-2638-6978-8c0ff752b49f@linaro.org>
In-Reply-To: <95d20d91-d187-2638-6978-8c0ff752b49f@linaro.org>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 28 Oct 2020 09:42:23 -0400
Message-ID: <CAF=yD-LjW5OpKcT+CNPmSkFfDgSGoa2hsFqS9wkMzdNDG1_eRQ@mail.gmail.com>
Subject: Re: [PATCH net 5/5] net: ipa: avoid going past end of resource group array
To:     Alex Elder <elder@linaro.org>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, evgreen@chromium.org,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> >> +       /* We program at most 6 source or destination resource group limits */
> >> +       BUILD_BUG_ON(IPA_RESOURCE_GROUP_SRC_MAX > 6);
> >> +
> >>         group_count = ipa_resource_group_src_count(ipa->version);
> >> -       if (!group_count)
> >> +       if (!group_count || group_count >= IPA_RESOURCE_GROUP_SRC_MAX)
> >>                 return false;
> >
> > Perhaps more a comment to the previous patch, but _MAX usually denotes
> > the end of an inclusive range, here 5. The previous name COUNT better
> > reflects the number of elements in range [0, 5], which is 6.
>
> I agree with your point, but the max here represents something different
> from what you're expecting.
>
> For a given resource type (source or destination) there is some fixed
> number (count) of resources available based on the version of SoC.
> The *driver* can handle any number of them up to the maximum number
> (max) for any SoC it supports.  In that respect, it *does* represent
> the largest value in an inclusive range.
>
> I could change the suffix to something like SRC_COUNT_MAX, but in
> general the symbol names are longer than I like in this driver and
> I'm trying to shorten them where possible.

Makes sense. Can you then call this out more explicitly in the commit
message? That MAX here means max count, not max element id.
