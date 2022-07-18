Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1437578891
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 19:37:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235856AbiGRRhZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 13:37:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233840AbiGRRhU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 13:37:20 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 844D52CDEB
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 10:37:19 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id m8so2874049edd.9
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 10:37:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=b+gmIONhiXxkz2QJGmvVZScE/IgGuCeLYBs+pSoO9pY=;
        b=oElG1zSg7nkfYFa72t3wUeZgcCxRnPTZd06p685jd9catlbeoNHx5ZKn2aRERXYU/z
         rSTa7xtQMPkuJwPkww0ddidvQY2YkPeaW7K1FYhUnOh5KHMoanza38wqZyGD7wNo9l0c
         Q3SI8OUBXlVKxqWQpenJ7n7MZFRBgk4ItwtGBq6sHr2SHZcGRncahiJKiE9y65fkDD7Y
         g3r7MQBhyiwHwYfoGqQewG8Y74bedQdDAPPNgJGx2035cQih2V8W/7eXAz+c7gqHkdbr
         NgUPksjmmgnvD6rKpGn7kbuh7PqpjgJ17POw6UvHu9mGhU4Cky+yF1yCAqxeQhBpYWkF
         +s0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=b+gmIONhiXxkz2QJGmvVZScE/IgGuCeLYBs+pSoO9pY=;
        b=NSapm0rX/vXcCbwKpQsDIuAmGzo+E6yjiKgB3xXOZcqhtRV+Ktf8sQ6hQW2bK7GM7Z
         fc7bOrvyIiN3xy1FwuB97PHCycMH2xiLPSKmKV72kO+OYGFmcGuGlT+MU5+gsviQjb+Q
         5blr91V3x3qPsopuQYnDEGQpPGmB+b/HAC2XFtEfWnFQqbxSl9Olsx+eLZWr9jC2OVVu
         B52wSebJHDmy5vNwseG6+jHWZcWzJXJow8TxouDhuKtwxmE798E4AKu0Z4nvK5ljBy1S
         e3kz4YLuHP+8J0Y+PUSuJYA1EMWsb0btvjDBWQp2szGguLpaFRxfZQWvkDoxtUp6XuIJ
         NX1w==
X-Gm-Message-State: AJIora+DtvlV3EzduUXtAMuUqkeijSoSJRMkXA7AzQy+Ii3naOsNwG4u
        NGz8h4nKn85xx66xuwElOAhUDU7qyAv6cNxcCKJc7Q==
X-Google-Smtp-Source: AGRyM1vbZFm8g67CerRlz65r1qAynjhwjir/KKeN6fTAWvWageMn3GxLPmiyd9V+vMFp0XRoBaNcqXCzlRC+GI41ufk=
X-Received: by 2002:a05:6402:3511:b0:43a:cb79:e7cb with SMTP id
 b17-20020a056402351100b0043acb79e7cbmr37681105edd.43.1658165838087; Mon, 18
 Jul 2022 10:37:18 -0700 (PDT)
MIME-Version: 1.0
References: <20220711222919.2043613-1-justinstitt@google.com>
In-Reply-To: <20220711222919.2043613-1-justinstitt@google.com>
From:   Justin Stitt <justinstitt@google.com>
Date:   Mon, 18 Jul 2022 10:37:05 -0700
Message-ID: <CAFhGd8qRfhQg2k8E7pUm5EYSLp+vmtSd5tZuqtpZUyKud6_Zag@mail.gmail.com>
Subject: Re: [PATCH] iwlwifi: mvm: fix clang -Wformat warnings
To:     Gregory Greenman <gregory.greenman@intel.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Avraham Stern <avraham.stern@intel.com>,
        Miri Korenblit <miriam.rachel.korenblit@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Any chance a maintainer could take a look at this patch? I am trying
to get it through this cycle and we are so close to enabling the
-Wformat option for Clang. There's only a handful of patches remaining
until the patch enabling this warning can be sent!
