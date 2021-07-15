Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86BEF3CA154
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 17:17:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238830AbhGOPUQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 11:20:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238819AbhGOPUP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Jul 2021 11:20:15 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0279CC061762
        for <netdev@vger.kernel.org>; Thu, 15 Jul 2021 08:17:21 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id t9so6718534pgn.4
        for <netdev@vger.kernel.org>; Thu, 15 Jul 2021 08:17:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KxuL80J6nw9uZQmtHpLaHar4sqL4G7skG2GsMvgQTIo=;
        b=MjW8UkWyF7CeDkG3CEKArz/i47sv3orsgko3d7r6+jEaxVd8wArI3D4w7Ij+L2notz
         /SficrqdpNGlmRK12PcVY6TwI5ZQgyKsnzrL2uCxM+s02NY8omi4D5S+k0gS4e7IWQFO
         IBv5CPwwEyxj/IAE9BaDszhPo/b0eDWP1XmShjYE3JoyxrApX5HNEZBrJCLc1ssKSJt/
         KBkP2mJLWvCEgNaoxvCy9sS54TZ8i+rzw0NI2QyDvCUZCI0CUjwACQgI5yLbUdFqXKWs
         oV1gCcCDslOtSzgdd+9mF5w2tCGjaeoIiqdea9NtcARn+oy44Pno5SFlXG6aaR0X5Rfc
         CX2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KxuL80J6nw9uZQmtHpLaHar4sqL4G7skG2GsMvgQTIo=;
        b=nyKLnGKIjSNDa83hbHM1Ej99I0DY5PnIJIcpaJx0zP2hQBudWIro993L722C6t6jpw
         WH/OA0uLIjRBTdm8d/YB1n3ZsNeVP9XfTYKFrr66IGfehWE6ORCJT6r9ADNsI45a3Urj
         Zfy1DnCj5nCtlTRG6N3G6Ihhb22ATGAbolkk7nMB3uJFfT9K3GU75vH3JwQnxNFHqZkY
         KNIy5K6JT//+5h0PBoroOvWfiXnhwR2AKhMEMrqHjXlSSN/RQ+klTNLasMa0DvKpSTui
         eXWsmbMfmXAwOevcVdORIsQmADwgN1jUX87f1NimiWF3HCD9XBwYTqK0zdnv/a9aZ4Cd
         WdUA==
X-Gm-Message-State: AOAM530l0GnmoJPUf94zeSYbI+qOYrNnObE6/ZxIr23SFxsorNZlsJ4h
        6mCeqVvIBYpPoAVg1URlNBMS1slahgfzNccTDqo=
X-Google-Smtp-Source: ABdhPJxJ95FxjTa35xakBDP4AaAvSvCvfaFXPKaq8GSQr0HVE1bPS9MF8wATVdTVi0LBZsg98IcFtM5Z19YbfI2UgPg=
X-Received: by 2002:a62:ea1a:0:b029:329:a95a:fab with SMTP id
 t26-20020a62ea1a0000b0290329a95a0fabmr5189115pfh.31.1626362241463; Thu, 15
 Jul 2021 08:17:21 -0700 (PDT)
MIME-Version: 1.0
References: <20210715060021.43249-1-xiyou.wangcong@gmail.com> <536718b6-0735-cc03-6268-c6a130b55ba7@huawei.com>
In-Reply-To: <536718b6-0735-cc03-6268-c6a130b55ba7@huawei.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 15 Jul 2021 08:17:11 -0700
Message-ID: <CAM_iQpUCe=r9gwa91SFjueqYmoOg2TFsym22RNBJbjunOgrWVw@mail.gmail.com>
Subject: Re: [Patch net-next resend v2] net_sched: use %px to print skb
 address in trace_qdisc_dequeue()
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Qitao Xu <qitao.xu@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 15, 2021 at 4:26 AM Yunsheng Lin <linyunsheng@huawei.com> wrote:
>
> On 2021/7/15 14:00, Cong Wang wrote:
> > From: Qitao Xu <qitao.xu@bytedance.com>
> >
> > Print format of skbaddr is changed to %px from %p, because we want
> > to use skb address as a quick way to identify a packet.
> >
> > Note, trace ring buffer is only accessible to privileged users,
> > it is safe to use a real kernel address here.
>
> Does it make more sense to use %pK?
>
> see: https://lwn.net/Articles/420403/

I think you have the answer:

+ * %pK cannot be used in IRQ context because it tests
+ * CAP_SYSLOG.

;) So, no.

Thanks.
