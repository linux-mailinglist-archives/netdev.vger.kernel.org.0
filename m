Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 032752BB8C6
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 23:18:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728625AbgKTWRM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 17:17:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728161AbgKTWRL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 17:17:11 -0500
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54C78C0613CF
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 14:17:11 -0800 (PST)
Received: by mail-yb1-xb44.google.com with SMTP id g15so9961718ybq.6
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 14:17:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qfbYA0sdZsAxg06Q9gTjVtwV6w2K/dwmudQsYrBosGQ=;
        b=iPZivH7dqb6IaNNyovXzZTmcJDzZSGMEcTAp4UcYtlnYu2Jb56oULRGm754eCJOMn9
         SBoLJVEN21Fx5VhKhgAi77Ssde0cr1HpLM+G72v9az7QNZYHX/BWlBzdKZrQhEpLYN3W
         i0ue31Q1I7ZA32BYwQRDNiicWlNfuJx51GBEusbPq8BhfMqmYzTviwFcA5QIbw/uSvIu
         lW+RQJdwIkANNVJQequ1dXsf+zLueVGpNjBjIg6TD+/rnxPlsQ8jDFIvm2sJBOnD0Z8j
         pKnPmT3hD7FEMIPFawolDR/Eiy4zOgPkDkKtVjID4OI+B7gQ1Wrhc73ecIzWvYGKOw4L
         e5iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qfbYA0sdZsAxg06Q9gTjVtwV6w2K/dwmudQsYrBosGQ=;
        b=b+SnwZyLTE90xW2bzjYO5GcQUFiTmzRJT0g+4WHjjEHTt801KppbBKEOiQn97cBIY7
         e3LrxUqqt6HUlbPZ1zBEhTVwZ7dRyX02Mtf8bfBljEeMlSPovUlDm3I+xUjiQg5o0yXH
         TNoJZnvBU/VgSB8KNLJNbvm1nRSatYZnS6p6BSwwzyIv0f9URPfK0UkNj1XlOVn5Y/Wh
         zmQudu0O+OPmaYTj+LvTgz1W4xtK6k4dQYJrp5dnCj6fKrGWa63uTcjz0+rInX4sOPnr
         rG9PoalCMn3FJaKejZrF0uaenIzjPlGDC/Qdxhavzkrfc3hduckQa1RQW+4ORW5fGoPL
         tWIQ==
X-Gm-Message-State: AOAM532fu8rsHppS2kJgPApfqcOJnI5de0RJfE0XHNxwmNmy52JvO9U4
        EylPkCaIVIMapm+rbYuv+yNybNqRiEjnaN3LsWrYlsVzJoA=
X-Google-Smtp-Source: ABdhPJy2f+E4Mj+OkeA9pUIydWYfgFGS4wn1fSaRJ4GmHVusLr/oTJPGOw03DX7G378/NRqSSWXqGeZ3KQtvSdtxO50=
X-Received: by 2002:a25:a86:: with SMTP id 128mr20332463ybk.370.1605910630666;
 Fri, 20 Nov 2020 14:17:10 -0800 (PST)
MIME-Version: 1.0
References: <160577663600.7755.4779460826621858224.stgit@wsfd-netdev64.ntdv.lab.eng.bos.redhat.com>
In-Reply-To: <160577663600.7755.4779460826621858224.stgit@wsfd-netdev64.ntdv.lab.eng.bos.redhat.com>
From:   Pravin Shelar <pravin.ovn@gmail.com>
Date:   Fri, 20 Nov 2020 14:16:59 -0800
Message-ID: <CAOrHB_Be-B8oLwx-zYXpwhjpQAWdkw1NrYh36S8e6bRH8X0cqg@mail.gmail.com>
Subject: Re: [PATCH net] net: openvswitch: fix TTL decrement action netlink
 message format
To:     Eelco Chaudron <echaudro@redhat.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        ovs dev <dev@openvswitch.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Bindiya Kurle <bindiyakurle@gmail.com>,
        Ilya Maximets <i.maximets@ovn.org>, mcroce@linux.microsoft.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 19, 2020 at 1:04 AM Eelco Chaudron <echaudro@redhat.com> wrote:
>
> Currently, the openvswitch module is not accepting the correctly formated
> netlink message for the TTL decrement action. For both setting and getting
> the dec_ttl action, the actions should be nested in the
> OVS_DEC_TTL_ATTR_ACTION attribute as mentioned in the openvswitch.h uapi.
>
> Fixes: 744676e77720 ("openvswitch: add TTL decrement action")
> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
Thanks for working on this. can you share OVS kmod unit test for this action?
