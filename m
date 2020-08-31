Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19B052581A8
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 21:20:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728589AbgHaTUq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 15:20:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725886AbgHaTUp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 15:20:45 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6784DC061573
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 12:20:45 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id w20so7261719iom.1
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 12:20:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=googlenew;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VbsmIYFcCApwTQL7+EMSPobJ4a0ziZZZ0Sl4+N0BNSk=;
        b=lOXyFgUWLqn9z1dheza0Jl1Rhdq33jNeyaqY0UvT9oaxnIHlBj4mfi7/2PP69H24GF
         GibwFsi+lS9OgX58YNlhbiX4EbXLLIvR2SddfuFXLFjLLsjZUZ9RSvmwnjgAjH1m13tz
         Tb5kkmy4Be6NlL6NDvJYb3A8xISO165WG+lIscABrbUDw+lC7796VhhrWqaUVOXCigkX
         kPiEPK1iB2tHw2kwkm2qWK96rRmLn+3QfO+E9qqipeJVSQcuFbvvn74QgBDsOHbFpXOn
         TH7bz9bFyMAn6VJqPgZD6qbsFzId3CW+/+58xcKZ3uLR/FCZZSi+OIiESk6ULC/jOrPn
         XVww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VbsmIYFcCApwTQL7+EMSPobJ4a0ziZZZ0Sl4+N0BNSk=;
        b=rMXIgDimSTnryoYG6LWsrJTX+8Je28enzit07MHByoorAjvUUpHLCB9nPFdjfqhmlu
         HGNKMH7KkSUlVdaONBHCy17075GCEwjemJdzvHMdMXHUH3EB5rCRHT7l5/fZtFLgP77j
         +E4aGBWQeNDIbveRRYN1PiHBy8wEgTdnJEKuSaNhm6w52Ps1lYyAZnPxBGJAk9d7dq7G
         XxanPI++7SF3tH+LZF6P1e4ZbFCh8kcEIDC36DoX6zsIRHiC9L75Aus/xukXdj7AS29Z
         dnWTVK6whXtCMsL9UbXYX3xKUMaUTvIxC1bdJ6+mp7q0aEMMLalWyPrReMF2fdZNeief
         SqZQ==
X-Gm-Message-State: AOAM531EeDSkJa3sYuJN8w4dkEDrINhHonEeIBsacfZVEcBaCRYxhfsT
        XwgJf98x6CJX5LNNTcIIrgE2T5WIKF4qo0d+1UNSIA==
X-Google-Smtp-Source: ABdhPJycbmaM3yErlvZOEzZAxcip3jA56GAixLhXJvs33XkNFLxtDhP363DwvOZUXS7PZkX/L0aXNBkX5MsX7rQ7ahY=
X-Received: by 2002:a05:6638:ec5:: with SMTP id q5mr2593922jas.13.1598901643730;
 Mon, 31 Aug 2020 12:20:43 -0700 (PDT)
MIME-Version: 1.0
References: <CABb8VeGOUfXOjVcoHkMZhwOoafLH5L-cY_yvrYz1a+zMQPwLsg@mail.gmail.com>
 <CACKFLin0kKuckRf2b7CmoAM3UyzOQZo7fRUg0-9jT5p_LLAhTA@mail.gmail.com>
In-Reply-To: <CACKFLin0kKuckRf2b7CmoAM3UyzOQZo7fRUg0-9jT5p_LLAhTA@mail.gmail.com>
From:   Baptiste Covolato <baptiste@arista.com>
Date:   Mon, 31 Aug 2020 12:20:32 -0700
Message-ID: <CABb8VeGse3W=oawRp+12FGCRhwMMs=fY4rbwM6HVKJSc41RfPw@mail.gmail.com>
Subject: Re: rtnl_lock deadlock with tg3 driver
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     David Christensen <drc@linux.vnet.ibm.com>,
        Michael Chan <mchan@broadcom.com>,
        Siva Reddy Kallam <siva.kallam@broadcom.com>,
        Prashant Sreedharan <prashant@broadcom.com>,
        Netdev <netdev@vger.kernel.org>, Daniel Stodden <dns@arista.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 30, 2020 at 9:58 PM Michael Chan <michael.chan@broadcom.com> wrote:
>
> On Fri, Aug 28, 2020 at 5:40 PM Baptiste Covolato <baptiste@arista.com> wrote:
> >
> > Hi David, Michael,
> >
> > I am contacting you because I'm experiencing an issue that seems to be
> > awfully close to what David attempted to fix related to the tg3 driver
> > infinite sleep while holding rtnl_lock
> > (https://lkml.org/lkml/2020/6/15/1122).
>
> David's remaining issue was tg3_reset_task() returning failure due to
> some hardware error.  This would leave the driver in a limbo state
> with netif_running() still true, but NAPI not enabled.  This can
> easily lead to a soft lockup with rtnl held when it tries to disable
> NAPI again.
>
> I think the proper fix is to close the device when tg3_reset_task()
> fails to bring it to a consistent state.  I haven't heard back from
> David in a while, so I will propose a patch to do this in the next
> day.
>
> Let's see if this patch will also work for you.  Thanks.


Thanks Michael. Looking forward to trying this patch out.

-- 
Baptiste Covolato
