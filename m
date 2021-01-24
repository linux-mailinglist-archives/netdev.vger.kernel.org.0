Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34032301DFC
	for <lists+netdev@lfdr.de>; Sun, 24 Jan 2021 18:43:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726110AbhAXRm5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jan 2021 12:42:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726103AbhAXRm4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jan 2021 12:42:56 -0500
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4895AC061574
        for <netdev@vger.kernel.org>; Sun, 24 Jan 2021 09:42:16 -0800 (PST)
Received: by mail-qk1-x730.google.com with SMTP id a7so3543988qkb.13
        for <netdev@vger.kernel.org>; Sun, 24 Jan 2021 09:42:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=eoYOrlaS1ZdLvAMrNa6DhLoh8beVALjUD1ahn6RLhSg=;
        b=UAY/e4DfagG03UJhSlS7QZlF/Id1ZPRkb+sC9yUeWF+xCSG0bVxO9jv9NUETfVQb+X
         CtRn/nsGH3cHfd0klPpZOgcH/ZAhQcFBPNO4dRkhM2CNdeHwjs84TDrogchayqlfXkIz
         JLHsaFqafZ3h80eBTc4fCMDSmLXPgePkBj3r8VXgxyYI4HxpWzI2SCYQekv0v4okQ/Ge
         V+TBhoWXv+fsJp3whdVW4hH+obLycN3niCh30Ie3DUjnIAyxCltN3HgGUJ67cKmEdwyD
         YA+kcrTVbS0tZXQ1HB2k84ryQmT//Dg5XbTH/+TrWzXQelP20fUlrfbgWxWW5TLpL/B4
         s5+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=eoYOrlaS1ZdLvAMrNa6DhLoh8beVALjUD1ahn6RLhSg=;
        b=VaRQHT8y7bmL1lVSq5vchFBeVo9ZKZTzRIy4qsxw2L298PnZ1fRnAMHFprOcajKCHq
         Wu9PohXmnZdNh5ScIiSeNQH9Qsl099NT0PASqInpxrSTFoVnPSw8+y10WqsohER0OJ9i
         YROew0qeGlqssTTl7n6tdeon7mf1K1rqIZCwt+DpMfrFQJO+l6K2yv+d5kVNNKC/ZqdJ
         I7VgGMlmNA720bwD7IN+II0YZoUkZiIHUp7jOh32nD7aEhNzKiES+l3vBR+kKMIaIBbY
         F3xQte/WHVoIIwWIpdBEEwLakHlZxYkJVwliyAOISfOIcKh0EScFA1vXMxtBMY+do8UV
         Ij8w==
X-Gm-Message-State: AOAM533sXXdcpMifv9m7oI5m/nwCkJEhmFkbdYSYhDHLeG2xe4DDYJoz
        9dIClaAyR/QyfiW6k0L45bo0cpf2E33Bxjo3aCqUEYUAiaMnbg==
X-Google-Smtp-Source: ABdhPJzsM124BcBEImUx5X+AmvgvbPOgjuR66+78tU9rQWFjmlAouFxL+J4yJTpxdsgO6DLDjUfzp/SjUk0ubBi/Ygs=
X-Received: by 2002:a37:aa09:: with SMTP id t9mr387706qke.214.1611510134858;
 Sun, 24 Jan 2021 09:42:14 -0800 (PST)
MIME-Version: 1.0
References: <20210123195916.2765481-1-jonas@norrbonn.se>
In-Reply-To: <20210123195916.2765481-1-jonas@norrbonn.se>
From:   Pravin Shelar <pravin.ovn@gmail.com>
Date:   Sun, 24 Jan 2021 09:42:04 -0800
Message-ID: <CAOrHB_DTV_g3edbP+_UCDFnigGbXP=u2FUr=RH5am=ZGzhU6SA@mail.gmail.com>
Subject: Re: [RFC PATCH 00/16] GTP: flow based
To:     Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 23, 2021 at 12:06 PM Jonas Bonn <jonas@norrbonn.se> wrote:
>
> This series begins by reverting the recently added patch adding support
> for GTP with lightweight tunnels.  That patch was added without getting
> any ACK from the maintainers and has several issues, as discussed on the
> mailing list.
>
> In order to try to make this as painless as possible, I have reworked
> Pravin's patch into a series that is, hopefully, a bit more reviewable.
> That series is rebased onto a series of other changes that constitute
> cleanup work necessary for on-going work to IPv6 support into the
> driver.  The IPv6 work should be rebaseable onto top of this series
> later on.
>
> I did try to do this other way around:  rebasing the IPv6 series on top
> of Pravin's patch.  Given that Pravin's patch contained about 200 lines
> of superfluous changes that would have had to be reverted in the process
> of realigning the patch series, things got ugly pretty quickly.  The end
> result would not have been pretty.
>
> So the result of this is that Pravin's patch is now mostly still in
> place.  I've reworked some small bits in order to simplify things.  My
> expectation is that Pravin will review and test his bits here.  In
> particular, the patch adding GTP control headers needs a bit of
> explanation.
>
> This is still an RFC only because I'm not quite convinced that I'm done
> with this.  I do want to get this onto the list quickly, though, since
> this has implications for the next merge window.  So let's see if we can
> sort this out to everyone's satisfaction.
>

I am all for making progress forward. Thanks Jonas for working on this.
I will finish the review next week.
