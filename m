Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E2B11BE82A
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 22:11:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726776AbgD2ULG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 16:11:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726456AbgD2ULG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 16:11:06 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB218C03C1AE;
        Wed, 29 Apr 2020 13:11:05 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id k6so3707504iob.3;
        Wed, 29 Apr 2020 13:11:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=K1WKF1Pu64+IM5UCAf5a1VpVYUmnyGP1gNVwrO7bEJQ=;
        b=eLd0kjhPDPC11+sLgcoc8gGXPeFw0dIg/t//9cT/1QfD4P1LTj7fK6RgbgmvWYa2AH
         vX+b/ZLDGKFRkfTYj+QNfgdP/urWziTpcP4rB7GTfH/riUKKBEJv4gc34nKHm99PjKhT
         0yxemK9zedGe6EavBaTq2zUxGJBLZg3y5HE8nDGZpJWD7UxE34GGyx0UKE7b5fMY//Ox
         UddMtn33neo4pSdprxhToiN4VREZk94SYrRnJXxQ2C0JHd2wCddC0dvC0KvGWsa955w+
         flTfWj5+7ZwkCNBR0hB4ja/W86IJXYWG1fDfTHkqfa6Phsp6EJ90v9j+eaii2H8ONspZ
         mWOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=K1WKF1Pu64+IM5UCAf5a1VpVYUmnyGP1gNVwrO7bEJQ=;
        b=NzzbZqAZEEnmt8w7tvPV3MV3io4ys3VYNCT0KO0kNJSkWW6ejnIxnxZDptOsWhoWZE
         jf1x+AiZnoAPkZsTMTDHb7mMgE3F+ltxFTYl7TswfZ6tJsW47y1E14nyO3NS/7jxpVgS
         DyNuJ4XKrkLhPKRPc0dv8f62A8tjz+DJOFWXD42EDaWtlr9fIcHNbhw002FWjsyUaM6N
         ywFnjoIsSb/N0SPOSGK+sEA+AztvYDN+qHXotMg4UvHaTPGx9mbYCsG8nz+vyQi+cwHQ
         DHklDGCefsH0u9M17p0l6JjgBUG70/MYQuk6PfsydHTZc9DtW2VyOwtmWinO00RpC9kp
         4eEw==
X-Gm-Message-State: AGi0PuYFXFEcwNNMLTSUoT1/MKo1KPj73XOzfefKHD5cTZIeyvGqZ5k8
        aoQ5E97Nj0CwFWPf+4zd4/o=
X-Google-Smtp-Source: APiQypLAchJtPMpqlpsiE+F/tDWfUobzvFCMhhOdLw+HSv53YJp34z5oN1CJaAC1t6KDJZu8zy0lxg==
X-Received: by 2002:a5e:c744:: with SMTP id g4mr24916098iop.20.1588191065051;
        Wed, 29 Apr 2020 13:11:05 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id m14sm1395476ilq.68.2020.04.29.13.11.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2020 13:11:04 -0700 (PDT)
Date:   Wed, 29 Apr 2020 13:10:56 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Quentin Monnet <quentin@isovalent.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>,
        Richard Palethorpe <rpalethorpe@suse.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Message-ID: <5ea9df505abc3_4d8d2ae8075c45bc7d@john-XPS-13-9370.notmuch>
In-Reply-To: <20200429144506.8999-1-quentin@isovalent.com>
References: <20200429144506.8999-1-quentin@isovalent.com>
Subject: RE: [PATCH bpf-next v3 0/3] tools: bpftool: probe features for
 unprivileged users
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quentin Monnet wrote:
> This set allows unprivileged users to probe available features with
> bpftool. On Daniel's suggestion, the "unprivileged" keyword must be passed
> on the command line to avoid accidentally dumping a subset of the features
> supported by the system. When used by root, this keyword makes bpftool drop
> the CAP_SYS_ADMIN capability and print the features available to
> unprivileged users only.
> 
> The first patch makes a variable global in feature.c to avoid piping too
> many booleans through the different functions. The second patch introduces
> the unprivileged probing, adding a dependency to libcap. Then the third
> patch makes this dependency optional, by restoring the initial behaviour
> (root only can probe features) if the library is not available.
> 
> Cc: Richard Palethorpe <rpalethorpe@suse.com>
> Cc: Michael Kerrisk <mtk.manpages@gmail.com>
> 
> v3: Update help message for bpftool feature probe ("unprivileged").
> 
> v2: Add "unprivileged" keyword, libcap check (patches 1 and 3 are new).
> 
> Quentin Monnet (3):
>   tools: bpftool: for "feature probe" define "full_mode" bool as global
>   tools: bpftool: allow unprivileged users to probe features
>   tools: bpftool: make libcap dependency optional
> 
>  .../bpftool/Documentation/bpftool-feature.rst |  12 +-
>  tools/bpf/bpftool/Makefile                    |  13 +-
>  tools/bpf/bpftool/bash-completion/bpftool     |   2 +-
>  tools/bpf/bpftool/feature.c                   | 143 +++++++++++++++---
>  4 files changed, 143 insertions(+), 27 deletions(-)
> 
> -- 
> 2.20.1
> 


For the series,

Acked-by: John Fastabend <john.fastabend@gmail.com>
