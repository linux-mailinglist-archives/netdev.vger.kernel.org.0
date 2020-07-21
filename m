Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA2842288AB
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 20:58:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730297AbgGUS56 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 14:57:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726499AbgGUS55 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 14:57:57 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D8DDC061794
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 11:57:57 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id x9so17339476ila.3
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 11:57:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0v2N6RSK2biQEM2ARq13gUaadLq8seT0DhLH2WcJUlM=;
        b=l1x5Y9CU27ah00WkrIVwGfugTx7HIHv2vgLFFWurlpufaG1BRfAjDm5PE+nnQL0VPm
         Xgxg91TKWU7rR2QNQJI0d1x3vokgGQkaVChj4+pOxUHuHRwIBwXmO1ObflHudmElrFrN
         uYHNEVMn2q4sfVB36V+vRDzPnvBtel9G2H4FZtpq3MkB5WfTg8/4POduT12MP7AGOQH7
         Y/wTtmoPL6Ay/UTjj24FAXrM0B68uAVGa3ubtifWSVwR4OBLcB7saAoWqMctZ7PY0sad
         FfquJhYFdoAMczNQQQ6qHb5QOXDZHiIWDXmWBK2ZAEtLnbk2rSDwXqWjJSm32BgL6i7E
         LZFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0v2N6RSK2biQEM2ARq13gUaadLq8seT0DhLH2WcJUlM=;
        b=q9mZhfh2wRBwA7mtTfiiN9+G3lcqfEj37p5QheUnDghNdnuIvqjqFLwyGsboKegqcN
         pWaY6XrkiLlMm8c4yqWXpd8UrzPbDj5rA5D0MOk3XpUl43O5DE+w9ry1+rXKH8JKI0b7
         hsfWyyHYCPYHmfUh5wBmaQEU3GvqxPl1e9BUahB3GL1q4kuKKCX/EPqii9ps6ylTPaHO
         pek572ST/5NY7q6G+iIxY1UlfF0DAP3YrXkLG8yuoUpnn+Z1JY+tJwwe6+6Xg8XZGHaX
         BlT9bZt+Q+lP8NkNVKzWcC6FJL9Ib1d3IFBgiDmvsZnFOWtl9bGFZ+erwy7Wd5AQcnOi
         kW1g==
X-Gm-Message-State: AOAM53122zlSLJJZN2AuQWhB4x5DzyabcCbRRGy1L1ejw2sNhG/UV0Jo
        1+7SAraV3TPVtQ2vmgeKdi9Sruw2eneNm6raK6A=
X-Google-Smtp-Source: ABdhPJxbGxnSP90P7WCM2FeaKHIsP3IID36f/6vCQmALMLW+a2Tr62p847N03yysKLWjXcLsLtacPLr7APC1M1r+cAE=
X-Received: by 2002:a05:6e02:128d:: with SMTP id y13mr29108397ilq.305.1595357876576;
 Tue, 21 Jul 2020 11:57:56 -0700 (PDT)
MIME-Version: 1.0
References: <20200720081041.8711-1-jiri@resnulli.us>
In-Reply-To: <20200720081041.8711-1-jiri@resnulli.us>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 21 Jul 2020 11:57:45 -0700
Message-ID: <CAM_iQpVZLGiDR_foe7HdaW0-f5kO+5+Mm6p1e59tb2_VASFpHA@mail.gmail.com>
Subject: Re: [patch net-next v2] sched: sch_api: add missing rcu read lock to
 silence the warning
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Ido Schimmel <idosch@mellanox.com>, mlxsw@mellanox.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 20, 2020 at 1:10 AM Jiri Pirko <jiri@resnulli.us> wrote:
> diff --git a/include/linux/hashtable.h b/include/linux/hashtable.h
> index 78b6ea5fa8ba..f6c666730b8c 100644
> --- a/include/linux/hashtable.h
> +++ b/include/linux/hashtable.h
> @@ -173,9 +173,9 @@ static inline void hash_del_rcu(struct hlist_node *node)
>   * @member: the name of the hlist_node within the struct
>   * @key: the key of the objects to iterate over
>   */

I think you need to update the doc here too, that is adding @cond.
