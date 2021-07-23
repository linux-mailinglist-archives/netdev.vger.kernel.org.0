Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B176F3D37B6
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 11:31:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233315AbhGWIum (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 04:50:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbhGWIul (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 04:50:41 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E20FC061575;
        Fri, 23 Jul 2021 02:31:14 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id h10so933543edv.8;
        Fri, 23 Jul 2021 02:31:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ao2RnG7ISGLnAa4hG4vDQIREJNPq/pTbnRjpX9KH6vY=;
        b=FS8hYJMt0WhpUPxRpcq7UOVN0vy83RBinj5w0q65KdLgaiDpl/Guqj2usyZdTeY1TC
         OjIiw8+Tw7y571dJ5uHAvzqioHPYPXb8JwZUBB+bV4CS6H1xF78pUZqOUKQe+e7ej86H
         SK+mLKCmfxVGmDUFNgx1ICeFuu5DflY3PepgZXPERNWIP2oTj3xdydKO5p8UHwAkCuSO
         gPqat8PgATLyYL1T2IAps4QnWkAPlJROIXAkfEkkXqG6u7qHj4su33FcINeDXjCXP4d/
         OGRtF7Zmf5EwAitlUpUWsnJE8nME9s8PRzdLhyEk9SQ5qjOWDmraMQrg1SKngF2AVKyE
         tVeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ao2RnG7ISGLnAa4hG4vDQIREJNPq/pTbnRjpX9KH6vY=;
        b=ub3qmQRuIMVUfAN+X9aiBsEdYFVW7CnrHK5ojyTv2aOx8SLUfqh0ny1TjPo3I1U2ei
         FTSoOR2STIUyT06hRr6uajrY9pQEGMhslytUNUfGM4ZzAPRykVjrcrR7P+gcNWHIbrxf
         A1k70xNyptMzWvmM8EQRriy7sgDv0cfbyyReYBOGs5iYkcX9OG093ZQj9iU5Cx+ax+7u
         jQjdIe6iLE51zMbm3CNcasTX+qZeEyxMs5uPHhbqPB4JwpyyRZ0pc7i1QP28NktF39I3
         4V73xyFwQvy3EEsqjsThen+zxXI1IcB4c6LK2zrMy01xM9U5TyvfIWN1+zDa8CmPNgHZ
         RMtA==
X-Gm-Message-State: AOAM532hPcHx/PAAZ8a41X18aQQumcOh9xfljhAM9Nz8bhi5Qx8EpyrY
        0apYGjVkXflMlAYJr1FRjLvp49c5nVXL8mfWEdg=
X-Google-Smtp-Source: ABdhPJwmxxSBbdDMkBKBpbzgA6W119m/cttuRzaIzPul/alqvQSBQq9M5HNGMLSUCWRTCrpakiINtxNtwwqjMLKlBHQ=
X-Received: by 2002:a05:6402:1c10:: with SMTP id ck16mr4375755edb.339.1627032672678;
 Fri, 23 Jul 2021 02:31:12 -0700 (PDT)
MIME-Version: 1.0
References: <20210723050919.1910964-1-mudongliangabcd@gmail.com>
 <d2b0f847dbf6b6d1e585ef8de1d9d367f8d9fd3b.camel@sipsolutions.net>
 <CAD-N9QWDNvo_3bdB=8edyYWvEV=b-66Tx-P6_7JGgrSYshDh0A@mail.gmail.com> <11ba299b812212a07fe3631b7be0e8b8fd5fb569.camel@sipsolutions.net>
In-Reply-To: <11ba299b812212a07fe3631b7be0e8b8fd5fb569.camel@sipsolutions.net>
From:   Dongliang Mu <mudongliangabcd@gmail.com>
Date:   Fri, 23 Jul 2021 17:30:46 +0800
Message-ID: <CAD-N9QWRNyZnnDQ3XTQ_SAWNEgiMCJV+5Z69eHtRVcxYtXcM+A@mail.gmail.com>
Subject: Re: [PATCH] cfg80211: free the object allocated in wiphy_apply_custom_regulatory
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Luca Coelho <luciano.coelho@intel.com>,
        Ilan Peer <ilan.peer@intel.com>,
        syzbot+1638e7c770eef6b6c0d0@syzkaller.appspotmail.com,
        linux-wireless@vger.kernel.org,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 23, 2021 at 5:18 PM Johannes Berg <johannes@sipsolutions.net> wrote:
>
> On Fri, 2021-07-23 at 17:13 +0800, Dongliang Mu wrote:
> > On Fri, Jul 23, 2021 at 4:37 PM Johannes Berg <johannes@sipsolutions.net> wrote:
> > >
> > > On Fri, 2021-07-23 at 13:09 +0800, Dongliang Mu wrote:
> > > > The commit beee24695157 ("cfg80211: Save the regulatory domain when
> > > > setting custom regulatory") forgets to free the newly allocated regd
> > > > object.
> > >
> > > Not really? It's not forgetting it, it just saves it?
> >
> > Yes, it saves the regd object in the function wiphy_apply_custom_regulatory.
>
> Right.
>
> > But its parent function - mac80211_hwsim_new_radio forgets to free
> > this object when the ieee80211_register_hw fails.
>
> But why is this specific to mac80211-hwsim?
>
> Any other code calling wiphy_apply_custom_regulatory() and then failing
> the subsequent wiphy_register() or otherwise calling wiphy_free() will
> run into the same situation.
>
> So why wouldn't we free this in wiphy_free(), if it exists?
>

Hi Johannes,

if zhao in the thread is right, we don't need to add this free
operation to wiphy_free().

What we should do is to only handle regd in the error handling code of
mac80211_hwsim_new_radio. This will not affect other users of
mac80211-hwsim. Any idea?

> johannes
>
