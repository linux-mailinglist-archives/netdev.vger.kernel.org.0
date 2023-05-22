Return-Path: <netdev+bounces-4230-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 301F370BC22
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 13:46:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AE260280EDD
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 11:45:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6E06D2F9;
	Mon, 22 May 2023 11:45:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6127BA27
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 11:45:57 +0000 (UTC)
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F171AC
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 04:45:55 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id 2adb3069b0e04-4f3edc05aa5so1631126e87.3
        for <netdev@vger.kernel.org>; Mon, 22 May 2023 04:45:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1684755954; x=1687347954;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=FV8sCT8BFyA8deJYHWz/IM3mCVuJ3I9ttJCLsYuNvvw=;
        b=ncnBE9tQNvkUvX0r4gvHMz688irtuvfbMmzx6VHQYyXOKJkl/kA7MdBVfLDbDJm+rI
         AtB4AsiOidEBoeLiVNHYW0U8mOKjJd48xn/+qCUThICZF0yr0Y/zvo7L/xZjmTNCrp+r
         9a3NmZ9sMUFgg3d4at/mqkLF+eieu6SU1AoNE/RWTYwVjWwok6L7KYceQ87dJTUlBUEw
         XvrzT317ubgjXX2hh7/+6vRlC+Frw79HoyCQ4Z2lK0bMjfytE5+U4N7CtnD96RhgOOJE
         0J0ZYjDR1w4PflsJ1voB+nOO7S3KPofeWVjt0vGGQYdzUUgkCVfAPlksO+tY0IrjZEnm
         KZ7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684755954; x=1687347954;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FV8sCT8BFyA8deJYHWz/IM3mCVuJ3I9ttJCLsYuNvvw=;
        b=Or44NW6E4ZREUQuMy/fUaGemKft2tLEiokZLfBXP7DptIYWad7djxM5JT2sge8Xadu
         81jCit4Zt/Fjtel3YCp+oV7kaoI5ri6lRnr7DO0pHUnYqoSfOKcBaP8klO/XlVlan4T3
         WjYz+N/9dAna13tjRXMb7D/aybwqD5eXjGpQ7BoHrpmDLpmyIp7QvHiz7av4T3eoJht0
         yhyyiu2HGfiZr1tTqvyMiBraVEwjS3wKVpt4QenJvPHhO2PcmypfSkU2W6vWHk67IoHJ
         EAKvw6VgYVZngsuEdw1uKvOleZkgOorBVVXEorSQuq1nw8z3NOADE+/wmJe7IiBx1eB+
         9X5A==
X-Gm-Message-State: AC+VfDyZy7po6e+HdF+OTQYZlg4LdnKFowSn+6rw7EgkLgSsptqO9AD5
	hviPAOy9JknHl98F/WMOboFdkwwL3LaRhI//b+8SAA==
X-Google-Smtp-Source: ACHHUZ6Arb3e86WPLu+kbk3kF3wfmSodwf5+FCkwRV6f1KpcCpFXAAZjz973i1vwCX8k4GFJPOYyd7DyVdEctcGZ77s=
X-Received: by 2002:ac2:4428:0:b0:4f1:3b59:44cc with SMTP id
 w8-20020ac24428000000b004f13b5944ccmr3201723lfl.57.1684755953816; Mon, 22 May
 2023 04:45:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230522031714.5089-1-linyunsheng@huawei.com> <1fc46094-a72a-f7e4-ef18-15edb0d56233@redhat.com>
In-Reply-To: <1fc46094-a72a-f7e4-ef18-15edb0d56233@redhat.com>
From: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Date: Mon, 22 May 2023 14:45:17 +0300
Message-ID: <CAC_iWjJaNuDFZuv1Rv4Yr5Kaj1Wq69txAoLGepvnJT=pY1gaRw@mail.gmail.com>
Subject: Re: [PATCH net] page_pool: fix inconsistency for page_pool_ring_[un]lock()
To: Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc: Yunsheng Lin <linyunsheng@huawei.com>, davem@davemloft.net, kuba@kernel.org, 
	pabeni@redhat.com, brouer@redhat.com, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Jesper Dangaard Brouer <hawk@kernel.org>, 
	Eric Dumazet <edumazet@google.com>, Lorenzo Bianconi <lorenzo@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, John Fastabend <john.fastabend@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Thanks Yunsheng

On Mon, 22 May 2023 at 14:08, Jesper Dangaard Brouer <jbrouer@redhat.com> wrote:
>
>
>
> On 22/05/2023 05.17, Yunsheng Lin wrote:
> > page_pool_ring_[un]lock() use in_softirq() to decide which
> > spin lock variant to use, and when they are called in the
> > context with in_softirq() being false, spin_lock_bh() is
> > called in page_pool_ring_lock() while spin_unlock() is
> > called in page_pool_ring_unlock(), because spin_lock_bh()
> > has disabled the softirq in page_pool_ring_lock(), which
> > causes inconsistency for spin lock pair calling.
> >
> > This patch fixes it by returning in_softirq state from
> > page_pool_producer_lock(), and use it to decide which
> > spin lock variant to use in page_pool_producer_unlock().
> >
> > As pool->ring has both producer and consumer lock, so
> > rename it to page_pool_producer_[un]lock() to reflect
> > the actual usage. Also move them to page_pool.c as they
> > are only used there, and remove the 'inline' as the
> > compiler may have better idea to do inlining or not.
> >
> > Fixes: 7886244736a4 ("net: page_pool: Add bulk support for ptr_ring")
> > Signed-off-by: Yunsheng Lin<linyunsheng@huawei.com>
>
> Thanks for spotting and fixing this! :-)
>
> Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
>

Acked-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>

