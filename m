Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD731228955
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 21:39:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730335AbgGUTjQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 15:39:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730048AbgGUTjP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 15:39:15 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97865C061794
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 12:39:15 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id k23so22686946iom.10
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 12:39:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fG6U2FtYu4E71mx0I6ffCly3uoQ5jCvKuBbC3K3WGI4=;
        b=WS8NSU04RlobCdeaSses0rRUvk1h6il55EtAaGlgkegsRiLNwxrSwtL9Fuwrx3eeqL
         jH6lzXpsT82GKx2ima6xps4iIXnZpIaEweeEctdppMIIHOpGt5bvaQRwFcRtuy0rWNnp
         E/CFLKoumGBctvH/0pXm7pXfw66nfa4+3vwN9ERomRow+UHgZKed5wSax7VZc4Z6BnOq
         DS4B23VPJA8RhWkjam4vOQCWuH1vMLcZ3XdfF5M5FAidRerseBhSVls+KFjTk06H9qey
         WC7wHh8g8Wn5dcMSIk6kdUFgQr6vAf/oMlkYlQUsKbbmfHcVE90BYuw8BrX/pto3oJXK
         jKTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fG6U2FtYu4E71mx0I6ffCly3uoQ5jCvKuBbC3K3WGI4=;
        b=FM5B8Kx2W5Bg/FxiZKonF8dhjC8T9qqgD0/o7cRf3lg8d7bIlYBCuHqqj3q31U1yyn
         ailGQ9WWXsOM2MpN0cjWyxV/36UsY0Bc/CHXaFZXhpwsj73jlJZkoqgVvHsGehO03sg9
         ZWsMCy1iTE9CsCCinFPHHjEicjf58ePA/CFEBJ7aDGw3UibbIM+Wxy9HMR/A2MElXvRa
         Yij7XS+byRkntR40VGaVWIj2/G17+ef1x7JCcGS7Bb4nEXpBj8yQnHQMgt96ehqzGkTE
         JYTPMERhIbY3X30bV8/JixBhQ8s63DAJDM1R/4wO9mcd/HL7Jn7UOU7j1nv8atKXxLGF
         4wug==
X-Gm-Message-State: AOAM530B4G/lZ+DRDQZV+0n6e2Utu07+YzLzpZIHPv8LHFEH28Zgtxgl
        /SrN7AHmi4RMBndAvI5qNT83o/ZAt6EOK5aAdUA=
X-Google-Smtp-Source: ABdhPJw2+USm4tW+/At1GJxxQoC4J5j7UbtWDNStYl2+DPrCzGxwuwpyYyjEP0Lv5eOeOwBZDAoK4uYUn9w2y09JAPw=
X-Received: by 2002:a6b:acc5:: with SMTP id v188mr28400803ioe.85.1595360355007;
 Tue, 21 Jul 2020 12:39:15 -0700 (PDT)
MIME-Version: 1.0
References: <1595336962-98677-1-git-send-email-geffrey.guo@huawei.com>
In-Reply-To: <1595336962-98677-1-git-send-email-geffrey.guo@huawei.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 21 Jul 2020 12:39:03 -0700
Message-ID: <CAM_iQpVYtsPH_2a5fPi_ebAUr9KbfBp53Vt7dxrCG44JqPj2Lg@mail.gmail.com>
Subject: Re: [PATCH] ipvlan: add the check of ip header checksum
To:     guodeqing <geffrey.guo@huawei.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mahesh Bandewar <maheshb@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 21, 2020 at 6:17 AM guodeqing <geffrey.guo@huawei.com> wrote:
>
> The ip header checksum can be error in the following steps.
> $ ip netns add ns1
> $ ip link add gw link eth0 type ipvlan
> $ ip addr add 168.16.0.1/24 dev gw
> $ ip link set dev gw up
> $ ip link add ip1 link eth0 type ipvlan
> $ ip link set ip1 netns ns1
> $ ip netns exec ns1 ip link set ip1 up
> $ ip netns exec ns1 ip addr add 168.16.0.2/24 dev ip1
> $ ip netns exec ns1 tc qdisc add dev ip1 root netem corrupt 50%
> $ ip netns exec ns1 ping 168.16.0.1
>
> The ip header of a packet maybe modified when it steps in
> ipvlan_process_v4_outbound because of the netem, the corruptted
> packets should be dropped.

This does not make much sense, as you intentionally corrupt
the header. More importantly, the check you add is too late, right?
ipvlan_xmit_mode_l3() already does the addr lookup with IP header,

Thanks.
