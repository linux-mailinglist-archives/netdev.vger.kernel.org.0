Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BABBD4A9CFE
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 17:33:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376599AbiBDQdJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 11:33:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351964AbiBDQdI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 11:33:08 -0500
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D89EC06173D
        for <netdev@vger.kernel.org>; Fri,  4 Feb 2022 08:33:08 -0800 (PST)
Received: by mail-yb1-xb32.google.com with SMTP id c6so20397829ybk.3
        for <netdev@vger.kernel.org>; Fri, 04 Feb 2022 08:33:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=EVnHVPDcB7R0jZ9d0sv4LhrYeQykGnEBRrwdY7bXSrk=;
        b=FS+zOqInHCOm5yzGVm3Zh1fXXPi426YqoU+Z7ZPQy8SiOpEvWJAQUvbHcINB9Cv1v/
         8QotmUxWL+g5pvgBnZsqVc0My5PVLRYGRykjjy2tXP4tylRzR4ZgGnjopSWKP1XQ9lrk
         78mfI8wGu69P+Idk1zqIf7riULSq2W7mG3m4mdQK9guPvF+S1ahj296v4qc9q7AqDlHg
         8VEmjm5VD+kY1hcZurw/wyfnQH/metqSJSRbbJdXoZX+EicPfV/l/+zHsK/ftBaw5Ne/
         LVN/1l+OP+1hczDnfB5OJZoq5DUTR2WCAQ32Ato30H7QB6nr7rZtoRtYhaGytvw+ZwsR
         W2Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=EVnHVPDcB7R0jZ9d0sv4LhrYeQykGnEBRrwdY7bXSrk=;
        b=jw5f5crVHu+KvhOuCVh8T5N1l+lTDfvXwJmYfQ0MVd2X82qHchp5z+e6BT02xcLqWK
         2OyUqEfOzoL/Zeye6AUTIfyZBnPUnB8gw1p/ER6HDx9q6SpwUIxaNR5tsKZfDsQ5gTlJ
         fLBRFtQjunqIv++PL3QuQk0CiqK8MPBIZxc2Jl8jJTLiyS7Ah0jONjN7Ldsh3abMztNq
         0amSGDdSwm9QeP90fMt4ZFh5RCGAQbM27WhrJzcGtJXu2YBGYdwmtao76Akqq/iPUglW
         RNnvrvc/yywfaafhZSNqmuT6NtR7N9sK4TQiaElYqcUXcFYdkPpZ5rAuHxcodJs2GlLl
         Xl5g==
X-Gm-Message-State: AOAM533LpEgzU8hSf/IPiek5YN3YLHm7FMDzgiNhSNHyzoUPuRzaDQd2
        dLh50LdQNv57W8mCGq3sgKPRVu1kEi6pHJpiRQ8P4w==
X-Google-Smtp-Source: ABdhPJze8bUnsl2Ufqt5VIdSuVkqtitJ/2McV9d15H1GDF6qLzPCtmnBYzVah8+NPefay+lmo/rhb3G1plu9Dony8fg=
X-Received: by 2002:a81:1704:: with SMTP id 4mr3726520ywx.32.1643992387282;
 Fri, 04 Feb 2022 08:33:07 -0800 (PST)
MIME-Version: 1.0
References: <20220202122848.647635-1-bigeasy@linutronix.de>
 <20220202122848.647635-2-bigeasy@linutronix.de> <CANn89iJm9krQ-kjVBxFzxh0nG46O5RWDg=QyXhiq1nA3Erf9KQ@mail.gmail.com>
 <87v8xwb1o9.fsf@toke.dk> <YfvH9YpKTIU4EByk@linutronix.de> <87leysazrq.fsf@toke.dk>
 <Yf1EWFgPtjIq3Hzw@linutronix.de>
In-Reply-To: <Yf1EWFgPtjIq3Hzw@linutronix.de>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 4 Feb 2022 08:32:56 -0800
Message-ID: <CANn89iK8MxwvCzkGgS4XKriRTiCQVJM01d19t8hbzk77adRLAA@mail.gmail.com>
Subject: Re: [PATCH net-next v2 1/4] net: dev: Remove preempt_disable() and
 get_cpu() in netif_rx_internal().
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>,
        bpf <bpf@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 4, 2022 at 7:20 AM Sebastian Andrzej Siewior
<bigeasy@linutronix.de> wrote:
>
> The preempt_disable() () section was introduced in commit
>     cece1945bffcf ("net: disable preemption before call smp_processor_id(=
)")
>
> and adds it in case this function is invoked from preemtible context and
> because get_cpu() later on as been added.
>
> The get_cpu() usage was added in commit
>     b0e28f1effd1d ("net: netif_rx() must disable preemption")
>
> because ip_dev_loopback_xmit() invoked netif_rx() with enabled preemption
> causing a warning in smp_processor_id(). The function netif_rx() should
> only be invoked from an interrupt context which implies disabled
> preemption. The commit
>    e30b38c298b55 ("ip: Fix ip_dev_loopback_xmit()")
>
> was addressing this and replaced netif_rx() with in netif_rx_ni() in
> ip_dev_loopback_xmit().
>
> Based on the discussion on the list, the former patch (b0e28f1effd1d)
> should not have been applied only the latter (e30b38c298b55).
>
> Remove get_cpu() and preempt_disable() since the function is supposed to
> be invoked from context with stable per-CPU pointers. Bottom halves have
> to be disabled at this point because the function may raise softirqs
> which need to be processed.
>
> Link: https://lkml.kernel.org/r/20100415.013347.98375530.davem@davemloft.=
net
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
> v1=E2=80=A6v2:
>   - merge patch 1 und 2 from the series (as per Toke).
>   - updated patch description and corrected the first commit number (as
>     per Eric).
>

SGTM thanks, please add for the next submission:

Reviewed-by: Eric Dumazet <edumazet@google.com>
