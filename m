Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBFD43EDD4D
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 20:45:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230137AbhHPSqU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 14:46:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230084AbhHPSqT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 14:46:19 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD0FDC061764
        for <netdev@vger.kernel.org>; Mon, 16 Aug 2021 11:45:47 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id c24so36325919lfi.11
        for <netdev@vger.kernel.org>; Mon, 16 Aug 2021 11:45:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DOC2qH+Gi4fjMQIz9mck49PHMjhmRHhlBc5XPTN/slk=;
        b=dlWwzGdKnjpZ4WYlLo8WeTdORYWvDWRJjhGZmS+s1OFr5JDoN0EGxsPrhHjxuGQ2uc
         FG7p+14j3jd3Evx8uDZCVwAtozoUshNqkre3LopUGMLuvXCt4QTC5gXmBUeFG1RdoC19
         UxqeeP50p9nOccLYj5dbMBjyL9e/5U+xPlzTRwdqpmaSj6eqsL6RHWTFqCQsocV0PIzq
         UjBbjwNeRBGVYoFFl1jT4rEhw57ro4V7soFL46PVVPDEv/eGdlC7v8iAItpt/CMpdvoz
         mXIKXmr/In7WrV0I26EN050uHGmlXYkprqhH88wh5KHRZGa/uCNEskK8Mf0aOg7/qTVi
         gd8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DOC2qH+Gi4fjMQIz9mck49PHMjhmRHhlBc5XPTN/slk=;
        b=rpqnbbWfcn+13VqDNtFKRU0GreIWfgGrDo5PqhuEFGGo2O5tayRw1pQn4JQEYHy7Lg
         8dP/6yeuagcN7C7ciKX6mXq8NAlHfb0gUbvjJVZlwevruG2YPuAZQU2j8t46OKIW+k6i
         mFDS+xePtZg4yETWAWxf/CZT8yOCxY2Gkg/XGWNi+FxQyaSnwTSHJtjViZos415LVI16
         h92U1FHk28fpXbXVsWJriY0pVWI20nvEkKsA6vNT4n7V+2/1Q9UaHhorMOaEptWegrO7
         2VrWmMSks90Xdmoi3P9S5MlYMTkN/C1lbbld7cQHW71ITaF/89W+eMyt+dD1ZyY2RIjD
         y5qw==
X-Gm-Message-State: AOAM530Of9euyp0cb+PUj1SFuEeOMx5CTrWRYwi/kxGYp6Poaz7qssFK
        wMNM5J/GmyZacAsyjhjXgJ41UOvctbnqRf3jO01YiA==
X-Google-Smtp-Source: ABdhPJymwoDPQqlOB+EX5j4gczTEQbJyFmpxxy0jpOPg4mOQagZVz8rvhBzYGr6IYbENYGkyN9TNPwyrWGmpIJJ8je4=
X-Received: by 2002:a05:6512:3041:: with SMTP id b1mr16693lfb.122.1629139545812;
 Mon, 16 Aug 2021 11:45:45 -0700 (PDT)
MIME-Version: 1.0
References: <20210814234248.1755703-1-nathan@kernel.org>
In-Reply-To: <20210814234248.1755703-1-nathan@kernel.org>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Mon, 16 Aug 2021 11:45:34 -0700
Message-ID: <CAKwvOd=Oo1u9FsHUaMi-pnb=bM0QngYjhBnDU819aetO2OZsvw@mail.gmail.com>
Subject: Re: [PATCH] iwlwifi: mvm: Fix bitwise vs logical operator in iwl_mvm_scan_fits()
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 14, 2021 at 4:43 PM Nathan Chancellor <nathan@kernel.org> wrote:
>
> Clang warns:
>
> drivers/net/wireless/intel/iwlwifi/mvm/scan.c:835:3: warning: bitwise
> and of boolean expressions; did you mean logical and?
> [-Wbool-operation-and]
>                 (n_channels <= mvm->fw->ucode_capa.n_scan_channels) &
>                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>                                                                     &&
> 1 warning generated.
>
> Replace the bitwise AND with a logical one to solve the warning, which
> is clearly what was intended.
>
> Fixes: 999d2568ee0c ("iwlwifi: mvm: combine scan size checks into a common function")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Thanks for the patch!
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>

> ---
>  drivers/net/wireless/intel/iwlwifi/mvm/scan.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
> index 0368b7101222..494379fc9224 100644
> --- a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
> +++ b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
> @@ -832,7 +832,7 @@ static inline bool iwl_mvm_scan_fits(struct iwl_mvm *mvm, int n_ssids,
>                                      int n_channels)
>  {
>         return ((n_ssids <= PROBE_OPTION_MAX) &&
> -               (n_channels <= mvm->fw->ucode_capa.n_scan_channels) &
> +               (n_channels <= mvm->fw->ucode_capa.n_scan_channels) &&
>                 (ies->common_ie_len +
>                  ies->len[NL80211_BAND_2GHZ] +
>                  ies->len[NL80211_BAND_5GHZ] <=
>
> base-commit: ba31f97d43be41ca99ab72a6131d7c226306865f
> --
> 2.33.0.rc2
>


-- 
Thanks,
~Nick Desaulniers
