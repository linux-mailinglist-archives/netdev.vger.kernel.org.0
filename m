Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98EC01B21BB
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 10:33:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728383AbgDUIcs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 04:32:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726600AbgDUIcr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 04:32:47 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26A0AC061A0F;
        Tue, 21 Apr 2020 01:32:46 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id h2so2549316wmb.4;
        Tue, 21 Apr 2020 01:32:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=fdZ+qw8FSd+oZ7JAfQgjqj+cDvfl7DNp/1zLFgbSM2E=;
        b=G67UBLWEM3iK3cdE5JucXd34fvZ4Qj9biiMaVbx1Pqx6O7/CrPFKV+kc3KRhB5GEJK
         Rxx04dnq2tne3y+9MYeQzQonNXsQdubPhMhHS9oF6UwrJdCpbHVwqMvR5VnvLAedlfgS
         OFwTJEEkAlkUABWPjZEEUgU174ZqcboQSvg0EKrOdhh3a9byCJRLtub+ZDl1/LQ+GS0/
         OPwgtEH50KY46m/F5+f2loTp2Vy25zS+oPpLau2Ttyrxz+6CpcseZdEIdKCs/s7B3APA
         9Xw1IOafn+w7kzO5saXSNWjBM2hiYHhhrqxcVaDJYOTsff+AEYzoUy+OulwPZsg79zr8
         gOBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=fdZ+qw8FSd+oZ7JAfQgjqj+cDvfl7DNp/1zLFgbSM2E=;
        b=QQo5qKPSMKk4BALyJaN0Is5Xt03bSJgji1oi3PTthNW32/+K29cZhii7NeEZrh0QIn
         4V1ZdtRZxpdhynnZ1xApKfdm6md0lrvvtF5cqgsI5lFutkzp1nTgX2l0cFIja0un/ZcT
         ZVMucHOo1qU9PZnZqN5pdLFPaBXXhxgsgQpZnCiqHwOuDIj2vLAiBKKoAxgLh6IrmsFe
         fKYZhfr7qoGmMT3/4up00XeV/DFOmfwgo5xkIz8RAwv33yGMsNtgTMIkIbTH2cjf2hbp
         XWQjCganU4qvPfL5odfaYZkndXRI7UvdhPGhz7OM6nIWa1jHbpkLiUjsdamG3N194hrr
         npvQ==
X-Gm-Message-State: AGi0Pub34U5LaVtSGMhMXu0UPNc1LFmsr04xL/k/a69YQ7EvliiMUaYW
        rVceixNaYI2TmjI6e623pErbxd9gtSpz3943xQQ=
X-Google-Smtp-Source: APiQypKu95XjFZWhNAScyNi+0tTB50gdzunIlMkUKPL7WWAHgb3OJtuJ+NG6FGMz4x9JdDKWwv5qNISk3IqSFHy1vvQ=
X-Received: by 2002:a7b:c927:: with SMTP id h7mr3645204wml.122.1587457964786;
 Tue, 21 Apr 2020 01:32:44 -0700 (PDT)
MIME-Version: 1.0
References: <20200417074558.12316-1-sedat.dilek@gmail.com> <20200421075030.E9F6AC433BA@smtp.codeaurora.org>
In-Reply-To: <20200421075030.E9F6AC433BA@smtp.codeaurora.org>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Tue, 21 Apr 2020 10:32:32 +0200
Message-ID: <CA+icZUWjmZVT-0niozgA=9rdXcAOACTT4VUXgGooLYbELvMCHg@mail.gmail.com>
Subject: Re: [PATCH wireless-drivers v3] iwlwifi: actually check allocated
 conf_tlv pointer
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chris Rorvick <chris@rorvick.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 21, 2020 at 9:50 AM Kalle Valo <kvalo@codeaurora.org> wrote:
>
> Sedat Dilek <sedat.dilek@gmail.com> wrote:
>
> > From: Chris Rorvick <chris@rorvick.com>
> >
> > Commit 71bc0334a637 ("iwlwifi: check allocated pointer when allocating
> > conf_tlvs") attempted to fix a typoe introduced by commit 17b809c9b22e
> > ("iwlwifi: dbg: move debug data to a struct") but does not implement the
> > check correctly.
> >
> > Fixes: 71bc0334a637 ("iwlwifi: check allocated pointer when allocating conf_tlvs")
> > Tweeted-by: @grsecurity
> > Signed-off-by: Chris Rorvick <chris@rorvick.com>
> > Signed-off-by: Sedat Dilek <sedat.dilek@gmail.com>
>
> Patch applied to wireless-drivers.git, thanks.
>
> a176e114ace4 iwlwifi: actually check allocated conf_tlv pointer
>

Thanks, Sedat.

> --
> https://patchwork.kernel.org/patch/11494331/
>
> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
