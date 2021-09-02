Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D6B03FF092
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 17:56:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234417AbhIBP5I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 11:57:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234335AbhIBP5I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 11:57:08 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F6C4C061575
        for <netdev@vger.kernel.org>; Thu,  2 Sep 2021 08:56:09 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id l10so5345893lfg.4
        for <netdev@vger.kernel.org>; Thu, 02 Sep 2021 08:56:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9tWcVr7MLDZpPWzTOZpOUAoFHRjrwNvs4WRjRVjOspg=;
        b=KH1wTSYYNkIIXj+dSMOI6DDJtdkIeI2clasBL4nA439Dh+mKKlY9U04v9ebJp4MYST
         CHwk0Nup2Ft9gHLzEZcJkVEeSKPc6O+xfdkR9RqfkLQTs8lC0MleEEr6ifDXTYX76hG/
         n1hszphKMMnGTrGLBeiQVXqZN9sPWHA1nyQU4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9tWcVr7MLDZpPWzTOZpOUAoFHRjrwNvs4WRjRVjOspg=;
        b=PxbJXib2hECblXXqwClbbj/xhFHXMx2ofrTk66hRiU6ybNfcjoCUyr0YIL7Y0iPjDi
         NXXhPwPBwg7YJkBYZrQ1KB7QhCcEvPRwik903IlfFSTYvL4DzSRdDhrvAdmwwywjxaE5
         1+PRovb+gaanVAIaKixW4z4ZjuHsg2XkGwELUtUiUWkFYNsxwjDSvn/zp0v5uw1/ZOBB
         5VY50eSC3Pcu9LyytouWmkylPEg8EAJEx+/tWRqfu0nnkpdTSbg+Jnn2v6hVXLh6tw2T
         hFne3uneHpfL7Ru0Gj//hCSSiQVQaSSusrVwFPI3Ph7fDNCta11nnnuPpN4BLmx0/N3D
         E4Jw==
X-Gm-Message-State: AOAM533huOuJ6qT7v3s705caRn385g8GyWYsYAN2Mkf9nsJcR6/MFbhQ
        S6Azl6Hv1bYUkz2L8woeL4rcqVwnEvq4cvfC
X-Google-Smtp-Source: ABdhPJy2bIc6KE5fx+GNzk7Db+P9GwnvKqvN8AgDilito0sQ+hqRc2HIqwXYBiFZegUK14Bw2tqXXg==
X-Received: by 2002:a05:6512:67:: with SMTP id i7mr3053098lfo.43.1630598167742;
        Thu, 02 Sep 2021 08:56:07 -0700 (PDT)
Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com. [209.85.208.172])
        by smtp.gmail.com with ESMTPSA id j22sm235111lfh.101.2021.09.02.08.56.07
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Sep 2021 08:56:07 -0700 (PDT)
Received: by mail-lj1-f172.google.com with SMTP id q21so4456298ljj.6
        for <netdev@vger.kernel.org>; Thu, 02 Sep 2021 08:56:07 -0700 (PDT)
X-Received: by 2002:a05:651c:908:: with SMTP id e8mr3161301ljq.507.1630598166945;
 Thu, 02 Sep 2021 08:56:06 -0700 (PDT)
MIME-Version: 1.0
References: <635201a071bb6940ac9c1f381efef6abeed13f70.camel@intel.com>
 <20210902101101.383243-1-luca@coelho.fi> <20210902.113908.1070444215922235089.davem@davemloft.net>
In-Reply-To: <20210902.113908.1070444215922235089.davem@davemloft.net>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 2 Sep 2021 08:55:51 -0700
X-Gmail-Original-Message-ID: <CAHk-=wj5g9+-0VJCMYZR8DNnWpip_PZtMTxyUf8_dz_t_pWCfw@mail.gmail.com>
Message-ID: <CAHk-=wj5g9+-0VJCMYZR8DNnWpip_PZtMTxyUf8_dz_t_pWCfw@mail.gmail.com>
Subject: Re: [PATCH] iwlwifi: mvm: add rtnl_lock() in iwl_mvm_start_get_nvm()
To:     David Miller <davem@davemloft.net>
Cc:     luca@coelho.fi, Johannes Berg <johannes@sipsolutions.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        miriam.rachel.korenblitz@intel.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 2, 2021 at 3:39 AM David Miller <davem@davemloft.net> wrote:
>
> Linus, please just take this directly, thanks.

Done,

            Linus
