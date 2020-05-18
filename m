Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CBCE1D878E
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 20:50:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729140AbgERSuR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 14:50:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728667AbgERSuR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 14:50:17 -0400
Received: from mail-oo1-xc43.google.com (mail-oo1-xc43.google.com [IPv6:2607:f8b0:4864:20::c43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0213C061A0C
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 11:50:16 -0700 (PDT)
Received: by mail-oo1-xc43.google.com with SMTP id p67so2270635ooa.11
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 11:50:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GlndXO6ST6yHAhlzzQ908sbuR6FaivUGri1fi4ejRJs=;
        b=oHhOWT2aFODfJRBGTRiNqP9JxfrIE7ffgPXkxxOXThMLIKX/rr/qZkf8SOlf2Y4vYa
         m89RIDBMKjsHHb/f11iC11srw8X+i91Kqamsmg+3fsTwOakbFEmtWvgUlKoSV+yzrpGr
         nfVivkw+H3sB4boOhix4RPMBfbvBSlTWOeFaVgdEkRhDV4034AET3/GZF9wXMHtxsWUZ
         EW0Ec+TlD5Pp7PLAneUEUAUn4UOxhjhrCiJmMu8Kxbjlexl4CqzrGx8JOvr3IfkNzW85
         7jGyCDj8Qe1XXKIayxEE83GxnpkugpUnN0EJ6tnRr6mAn0cimeZt+0/ZUz75BwLT6Ykl
         5qAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GlndXO6ST6yHAhlzzQ908sbuR6FaivUGri1fi4ejRJs=;
        b=WORqbF46QfwtL8pnedDOt//EMuchazbs6eeWci2a3FD8b7joYEKaqumasJx+r63fmg
         tULZwt8HRkJIx9kZ7gx/bsIOiPtjT8bHHNIO87iY6B3a29fqhtlZc7UAtFx0k+uchMdx
         i2wW0gItjyrwVU9or5ksfbLvfoVC8Dte6ZgEH5+AgZPbWyjA4tJ15/ZSHe6PDpKFfEJc
         PRBG0m4b/P6brsHWRymTC+v64J/MKvO4CC7PVEGrejfTlTOsekBUXDUDnRLURgm6U9vq
         C2OlPfKwDiYXiBPKy2/685822bvLEn9zgLuvzZTNhjLzY8Y3GAHwMumsO+NO4N1zBWQi
         WoQQ==
X-Gm-Message-State: AOAM533rzdW280YYn/yAxLcdpqslj5V4P7LRT2X5mNftIIRPmVCciaZH
        mnUcQS+nTYjyEfDKMKOAxERYt7ztqs0PooJU0Fg=
X-Google-Smtp-Source: ABdhPJxYD4BdKCxedG7CUCB9yJKXlJGb80oveZG2FxEtTavcZIq6MSfHUJyPv6JPObgfL2zcgf5ZoOCZFAftFm6ITu0=
X-Received: by 2002:a4a:5147:: with SMTP id s68mr13965049ooa.86.1589827816312;
 Mon, 18 May 2020 11:50:16 -0700 (PDT)
MIME-Version: 1.0
References: <20200515114014.3135-1-vladbu@mellanox.com> <649b2756-1ddf-2b3e-cd13-1c577c50eaa2@solarflare.com>
In-Reply-To: <649b2756-1ddf-2b3e-cd13-1c577c50eaa2@solarflare.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 18 May 2020 11:50:05 -0700
Message-ID: <CAM_iQpWUzWyPZyDyVFLhOb5peVMp5Y4OeBxfSzuKY5bnF5Z02Q@mail.gmail.com>
Subject: Re: [PATCH net-next v2 0/4] Implement classifier-action terse dump mode
To:     Edward Cree <ecree@solarflare.com>
Cc:     Vlad Buslov <vladbu@mellanox.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Davide Caratti <dcaratti@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 18, 2020 at 8:38 AM Edward Cree <ecree@solarflare.com> wrote:
>
> On 15/05/2020 12:40, Vlad Buslov wrote:
> > In order to
> > significantly improve filter dump rate this patch sets implement new
> > mode of TC filter dump operation named "terse dump" mode. In this mode
> > only parameters necessary to identify the filter (handle, action cookie,
> > etc.) and data that can change during filter lifecycle (filter flags,
> > action stats, etc.) are preserved in dump output while everything else
> > is omitted.
> I realise I'm a bit late, but isn't this the kind of policy that shouldn't
>  be hard-coded in the kernel?  I.e. if next year it turns out that some
>  user needs one parameter that's been omitted here, but not the whole dump,
>  are they going to want to add another mode to the uapi?
> Should this not instead have been done as a set of flags to specify which
>  pieces of information the caller wanted in the dump, rather than a mode
>  flag selecting a pre-defined set?

Excellent point!

I agree, this is more elegant, although potentially needs more work.

I am not sure whether we can simply pass those flags to cb->args[],
if not, that will need more work at netlink layer.

Thanks.
