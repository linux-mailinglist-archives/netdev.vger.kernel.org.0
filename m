Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3982213A9C
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 15:04:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726385AbgGCNEb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 09:04:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726035AbgGCNEa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jul 2020 09:04:30 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26E8BC08C5C1
        for <netdev@vger.kernel.org>; Fri,  3 Jul 2020 06:04:30 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id e8so2593479ljb.0
        for <netdev@vger.kernel.org>; Fri, 03 Jul 2020 06:04:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=aqWAr6YE4mor+umudAtTaMREXXbTAYzN9ke9vhJfzLA=;
        b=AXQGaQg6oslP/FN9reEP2I5tn0CBatUG1Mn12w3psdrWP10ctbgJj63KnPInmhTvOg
         V9/1Yn/pXP56f1An2wGy+QCD9MTuFIWB7ukT3kBrh+Xe1/rTPuSvZ7JVehZM99DVTZGp
         fbfnztwah99cFjMXt6JUw28fb2dITryVsBtQg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=aqWAr6YE4mor+umudAtTaMREXXbTAYzN9ke9vhJfzLA=;
        b=rTmupWNzKXsXNGh6pLGDamUenkUJoX7FgaFpNw0PeciIExkJ8RksHd8KEmssv/GJBL
         cDbQwfjBJgssRNurPoLlItCd6dO9MkOKvdcIKMnRKZO+dltUrIVAFZghoEyf92jbXYnh
         H70FOTcOcBBea1mjep75DDdIdwTVA2jxpwYsRz0ynB6ksaqkja3h+LCvlQ0BD/TTVFQq
         iB8lnpZK8EW0Bj31t12gxpUbGs386Phk7tAIeUKFx3xLdX61UMqulcp/1sShoGX9F55O
         8Naa4pg74KWKCbmiRn7XmLufhiLkOl9iS7TSMBRQLH45bFKmCgBYPfcQ0F9bkxGS/4qa
         wFvw==
X-Gm-Message-State: AOAM531Q7kQHt8a1u2dggAB6GrtIxaUQxGqn/gu26Lzhj9wpvu9GkcEA
        kHQF/vkS2Sze5927dC7QHmIEUg==
X-Google-Smtp-Source: ABdhPJzk91UGq6DCVW6pRW19MDYBqCK8QNvglm3Y1CP1VoeJZXenvZo8n3VKlj6eeaQPdluN1cf6kQ==
X-Received: by 2002:a05:651c:2cc:: with SMTP id f12mr18648114ljo.329.1593781468617;
        Fri, 03 Jul 2020 06:04:28 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id y21sm4096039ljm.30.2020.07.03.06.04.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jul 2020 06:04:27 -0700 (PDT)
References: <20200702092416.11961-11-jakub@cloudflare.com> <202007022256.E30co8dz%lkp@intel.com>
User-agent: mu4e 1.1.0; emacs 26.3
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     kernel test robot <lkp@intel.com>
Cc:     bpf@vger.kernel.org, kbuild-all@lists.01.org,
        netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marek Majkowski <marek@cloudflare.com>
Subject: Re: [PATCH bpf-next v3 10/16] udp6: Run SK_LOOKUP BPF program on socket lookup
In-reply-to: <202007022256.E30co8dz%lkp@intel.com>
Date:   Fri, 03 Jul 2020 15:04:26 +0200
Message-ID: <87imf4oilh.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 02, 2020 at 04:51 PM CEST, kernel test robot wrote:

[...]

> All errors (new ones prefixed by >>, old ones prefixed by <<):
>
>>> ERROR: modpost: "bpf_sk_lookup_enabled" [net/ipv6/ipv6.ko] undefined!
>

We're missing an EXPORT_SYMBOL for CONFIG_IPV6=m build. Will fix in v4.
