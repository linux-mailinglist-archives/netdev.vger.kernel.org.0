Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A63F636C50
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 22:22:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237815AbiKWVWJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 16:22:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237809AbiKWVWI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 16:22:08 -0500
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D304E5E9F4
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 13:22:06 -0800 (PST)
Received: by mail-qk1-x734.google.com with SMTP id k2so13357786qkk.7
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 13:22:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VHgVq5sX90/a/BhOqlHy581ALJwbQnSRnRpBrgLVdZ4=;
        b=fELMiNAAnzjxMhrhiZt4CATnthWy6giZnkz2zXGp5/6n8EoC1LuU8oQfUfEcVQoLA/
         QichA/k207xrB80yyoNaf6+Tc6xJWRMTitzk6yAa5opT9pLOQT8wvAuJEAXSJePCzD1w
         P1cHz58W5dAAqh7AjcFl5B+evStoCtfUo/QXjnjllQ2Q64hRJfOI0JNS7wJdfKKTg9Xw
         pIr4EV4lXRRTewtoWKmDfsV/KVTYBib80VzDNbshHWyjyAUJnzLjamQI1lZwjr3d5Oo3
         LEr00TLTaUa5wfDOmxqWAXothKMITL8f1kDbUtzGHBJDRgCkI2aXdf/FUy+cJ5cKtYnu
         K3mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VHgVq5sX90/a/BhOqlHy581ALJwbQnSRnRpBrgLVdZ4=;
        b=ZGT5n3d8p6A5xj9PsWEsep5OwHhDla3Y0D8CJrlqRDExI3lp9ub9q1XmHCj2qNUG8k
         dluzAK+Ucy5wQrUJbU8t6PWKoIxIkxM8URUZEDeZ3msXQW6f7+u74kcBKw1JX1vNLBFc
         eNwFk6hSmuSVTjBiD1XVH2+9hXeCVDtoYSWjnO07lNZZtsyOGI0eZhVt8NZmMdiH9C1+
         duQkqi2AFKo2dPppl7Yf8U+xmP6SYs5oqVO6FENOGgKx2ypC6clAjUBxraggSF/ozCKe
         b/6PKNEdqoUug4I8cANGK5DDvPRfTG9iQhpgBqTBf6WMiT4ASrHHUN/th+/tFatySf8+
         hLXA==
X-Gm-Message-State: ANoB5pmQEfDxKa44vKwpiMjq8Lo0kS2c3e5+ux9F21/CCHgWRDJLmlNG
        gLHKDqC/Utv1NxotiaQNGjSF/w==
X-Google-Smtp-Source: AA0mqf6Fm5ciQ4wtKxYph7OV6JtS/phXFgRnDvE6jcyPWG1R+idx88hHtrCa8QNdTRhn8Fb+kIVYhg==
X-Received: by 2002:a05:620a:10b4:b0:6fb:f17e:c8f8 with SMTP id h20-20020a05620a10b400b006fbf17ec8f8mr16670583qkk.404.1669238526028;
        Wed, 23 Nov 2022 13:22:06 -0800 (PST)
Received: from localhost ([2620:10d:c091:480::1:bc4])
        by smtp.gmail.com with ESMTPSA id c12-20020ac8054c000000b003995f6513b9sm10148797qth.95.2022.11.23.13.22.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Nov 2022 13:22:05 -0800 (PST)
Date:   Wed, 23 Nov 2022 16:22:31 -0500
From:   Johannes Weiner <hannes@cmpxchg.org>
To:     Yu Zhao <yuzhao@google.com>
Cc:     Ivan Babrou <ivan@cloudflare.com>, Linux MM <linux-mm@kvack.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Shakeel Butt <shakeelb@google.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, cgroups@vger.kernel.org,
        kernel-team <kernel-team@cloudflare.com>
Subject: Re: Low TCP throughput due to vmpressure with swap enabled
Message-ID: <Y36PF972kOK3ADvx@cmpxchg.org>
References: <CABWYdi0G7cyNFbndM-ELTDAR3x4Ngm0AehEp5aP0tfNkXUE+Uw@mail.gmail.com>
 <CAOUHufYd-5cqLsQvPBwcmWeph2pQyQYFRWynyg0UVpzUBWKbxw@mail.gmail.com>
 <CAOUHufYSeTeO5ZMpnCR781esHV4QV5Th+pd=52UaM9cXNNKF9w@mail.gmail.com>
 <Y31s/K8T85jh05wH@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y31s/K8T85jh05wH@google.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 22, 2022 at 05:44:44PM -0700, Yu Zhao wrote:
> Hi Johannes,
> 
> Do you think it makes sense to have the below for both the baseline and
> MGLRU or it's some behavior change that the baseline doesn't want to
> risk?

It looks good to me. Besides the new FMODE_NOREUSE, it's also a nice
cleanup on the rmap side!

It would just be good to keep the comment from folio_referenced_one() and
move it to the vma_has_locality() check in invalid_folio_referenced_vma().

Otherwise,

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
