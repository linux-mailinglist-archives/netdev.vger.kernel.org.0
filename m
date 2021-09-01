Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7B3B3FE2B3
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 21:01:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242301AbhIATCT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 15:02:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244650AbhIATCN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 15:02:13 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14519C061575
        for <netdev@vger.kernel.org>; Wed,  1 Sep 2021 12:01:16 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id f18so1048139lfk.12
        for <netdev@vger.kernel.org>; Wed, 01 Sep 2021 12:01:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=npd1RU7mbNsF3k0GeBkr9d4yP6Ob5CEAADTVG3CYCjw=;
        b=ErHaIpxZiEMxxjypsttdmUORwYq4vP1VZ+xYSjVl8afEmUE0mZp3Aj9x4LVzPgegFp
         QxCWY5+Gxwtt2L2qth2RgEkh1nozrNfG4UGJESfbueNOy10Bzrii0P8RVC60ibu3uR99
         Ri6W/fH6hsL0OtQOBkjpL0U0EcWE6CxP3PMa4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=npd1RU7mbNsF3k0GeBkr9d4yP6Ob5CEAADTVG3CYCjw=;
        b=dEdrxBiozqF03lJyNJlv12kr8YSB2teDPjWFTiqhc0T5ylqAntZ+pY51pezyqpM1Em
         ODogfydMiDoZphgKq7mxRivJ073wpBevPKTPkyxAFmDFVG2j3OZaDSZaBX4siyoWoKLG
         Kuo0CsXhLQ/FUWVdPearTRfJEojIU2NSMCfa2iq8kKNzDY0HBrMUHuRdBH54ES8svUDX
         A6/hfLlPyHkFSYOPENhvISSSaduRce2sx9et/LPQ5DuaN8Qcv5/jAixupm9zEQiC9XUQ
         15uw77gQtVU8BDfgMV/zzJ5Y0G+HfzpuZ9HO+Vxq+ce8S3Eq360Obm7Z7Eoeyy5uMv4O
         tMvw==
X-Gm-Message-State: AOAM5326ySakZWu/o2EJMdpZ0iOph1yh6vdI/1QA4ajxNsaoITzqBjGE
        DFZH0qGlkvkinBgzczgitbeaeSLLEzphTZj/
X-Google-Smtp-Source: ABdhPJykqjCxkqOGq7Uiv3kHhkfC449EwCyKtAPSUHYXH0S0rnV/AEHOvVJLxYdl9TL1VwTFnBq8cA==
X-Received: by 2002:ac2:5fe9:: with SMTP id s9mr686509lfg.600.1630522874023;
        Wed, 01 Sep 2021 12:01:14 -0700 (PDT)
Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com. [209.85.208.177])
        by smtp.gmail.com with ESMTPSA id w6sm31434lfc.211.2021.09.01.12.01.13
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Sep 2021 12:01:13 -0700 (PDT)
Received: by mail-lj1-f177.google.com with SMTP id w4so718495ljh.13
        for <netdev@vger.kernel.org>; Wed, 01 Sep 2021 12:01:13 -0700 (PDT)
X-Received: by 2002:a2e:3004:: with SMTP id w4mr888035ljw.465.1630522873162;
 Wed, 01 Sep 2021 12:01:13 -0700 (PDT)
MIME-Version: 1.0
References: <20210831203727.3852294-1-kuba@kernel.org>
In-Reply-To: <20210831203727.3852294-1-kuba@kernel.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 1 Sep 2021 12:00:57 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjB_zBwZ+WR9LOpvgjvaQn=cqryoKigod8QnZs=iYGEhA@mail.gmail.com>
Message-ID: <CAHk-=wjB_zBwZ+WR9LOpvgjvaQn=cqryoKigod8QnZs=iYGEhA@mail.gmail.com>
Subject: Re: [GIT PULL] Networking for v5.15
To:     Jakub Kicinski <kuba@kernel.org>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 31, 2021 at 1:37 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> No conflicts at the time of writing. There were conflicts with
> char-misc but I believe Greg dropped the commits in question.

Hmm. I already merged this earlier, but didn't notice a new warning on
my desktop:

  RTNL: assertion failed at net/wireless/reg.c (4025)
  WARNING: CPU: 60 PID: 1720 at net/wireless/reg.c:4025
regulatory_set_wiphy_regd_sync+0x7f/0x90 [cfg80211]
  Call Trace:
   iwl_mvm_init_mcc+0x170/0x190 [iwlmvm]
   iwl_op_mode_mvm_start+0x824/0xa60 [iwlmvm]
   iwl_opmode_register+0xd0/0x130 [iwlwifi]
   init_module+0x23/0x1000 [iwlmvm]

and

  RTNL: assertion failed at net/wireless/reg.c (3106)
  WARNING: CPU: 60 PID: 1720 at net/wireless/reg.c:3106
reg_process_self_managed_hint+0x26c/0x280 [cfg80211]
  Call Trace:
   regulatory_set_wiphy_regd_sync+0x3a/0x90 [cfg80211]
   iwl_mvm_init_mcc+0x170/0x190 [iwlmvm]
   iwl_op_mode_mvm_start+0x824/0xa60 [iwlmvm]
   iwl_opmode_register+0xd0/0x130 [iwlwifi]
   init_module+0x23/0x1000 [iwlmvm]

and

  RTNL: assertion failed at net/wireless/core.c (84)
  WARNING: CPU: 60 PID: 1720 at net/wireless/core.c:84
wiphy_idx_to_wiphy+0x97/0xd0 [cfg80211]
  Call Trace:
   nl80211_common_reg_change_event+0xf9/0x1e0 [cfg80211]
   reg_process_self_managed_hint+0x23d/0x280 [cfg80211]
   regulatory_set_wiphy_regd_sync+0x3a/0x90 [cfg80211]
   iwl_mvm_init_mcc+0x170/0x190 [iwlmvm]
   iwl_op_mode_mvm_start+0x824/0xa60 [iwlmvm]
   iwl_opmode_register+0xd0/0x130 [iwlwifi]
   init_module+0x23/0x1000 [iwlmvm]

and

  RTNL: assertion failed at net/wireless/core.c (61)
  WARNING: CPU: 60 PID: 1720 at net/wireless/core.c:61
wiphy_idx_to_wiphy+0xbf/0xd0 [cfg80211]
  Call Trace:
   nl80211_common_reg_change_event+0xf9/0x1e0 [cfg80211]
   reg_process_self_managed_hint+0x23d/0x280 [cfg80211]
   regulatory_set_wiphy_regd_sync+0x3a/0x90 [cfg80211]
   iwl_mvm_init_mcc+0x170/0x190 [iwlmvm]
   iwl_op_mode_mvm_start+0x824/0xa60 [iwlmvm]
   iwl_opmode_register+0xd0/0x130 [iwlwifi]
   init_module+0x23/0x1000 [iwlmvm]

They all seem to have that same issue, and it looks like the fix would
be to get the RTN lock in iwl_mvm_init_mcc(), but I didn't really look
into it very much.

This is on my desktop, and I actually don't _use_ the wireless on this
machine. I assume it still works despite the warnings, but they should
get fixed.

I *don't* see these warnings on my laptop where I actually use
wireless, but that one uses ath10k_pci, so it seems this is purely a
iwlwifi issue.

I can't be the only one that sees this. Hmm?

                 Linus
