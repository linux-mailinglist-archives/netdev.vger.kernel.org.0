Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF8021EAF6E
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 21:05:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728224AbgFATF0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 15:05:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726149AbgFATF0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 15:05:26 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04884C061A0E
        for <netdev@vger.kernel.org>; Mon,  1 Jun 2020 12:05:26 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id g3so4803737ilq.10
        for <netdev@vger.kernel.org>; Mon, 01 Jun 2020 12:05:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=d0Kvpr+eO0nqrt1adZVCJQrUGS0YeZptp+pSmCojb5E=;
        b=XDHRYero/qZBRRaxUPC/AxdovkAZh2zpkO+kPuCmlIexOsHRNJUIg0Znsth+QntbYe
         SZwu/p8cmseWiBoQvHXZaWFJw1+ukslSEg6DPTX9atG1v0MuelypqGRMPj4GEN5iWnfu
         huM3AZ6IIWBnwFptwOimde+vs1/QgDvYHiXYNJZkaLrccc7/vKplhds/ERYqMCyPPLvG
         B0+BdfUCL0woQvwtLvE5c8AOyHXoGlLxVoSL4QHdGoGZXVigUNFCa5TzvUZ8f25hbz+B
         iQ7elWbyZPdWpi6NfJYwroxBLwPPpV4ICZA6fyGJ7k2/eWRwOP5PlQHemvvaO8NAEVmm
         01TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=d0Kvpr+eO0nqrt1adZVCJQrUGS0YeZptp+pSmCojb5E=;
        b=hJ/hl+lc/s+CGz5ueB8ZAIYHf4b4AHjqsMtncjW2OB0k9IpA+Btns8oePc1g/xv3Xd
         VQuLrqrDYUakGWsAeqhQxGiaPXknIKsBMfhWULoPtdsf8x6VHuZJPELzRMvRrk600T9g
         444EnmHrc5N3zsawNVFf/GmjWsh4fQ5ZIS0KX+OhTlkYaUaJFvbL9cfNYeRjjkWMN+n+
         9JSUuUybbYFqj8q6IUduNeaN3hRcA8SpxGOsd09Y6VcqPw49lGBhw9yDehEc0dyIdGpc
         c1KxIw3WYbX8VU48cCDVlkrZiajAO0bd3nzKlivN1nRAXsBQKmIeMr4w5iO0Y5teDm/c
         jMjg==
X-Gm-Message-State: AOAM5338qba6seXcXYTsMMnjd27H7gx01woAO4aPsMqcR/WEHCdo2waU
        QjaZPbN6XWa8loXb7PcO2bYq7x/RTyL079kyJXWNVw==
X-Google-Smtp-Source: ABdhPJzzbKUWm7qRk3ZmY8ynyijzOg6Q0kdZWj983EMOFyqdiIl5IbX/omKnANRUTmbhoXW8nPb6++vVJBon/oZAKsM=
X-Received: by 2002:a92:dc89:: with SMTP id c9mr7802619iln.238.1591038325446;
 Mon, 01 Jun 2020 12:05:25 -0700 (PDT)
MIME-Version: 1.0
References: <c0284a5f2d361658f90a9cada05426051e3c490d.1590703192.git.dcaratti@redhat.com>
 <20200601.113714.711382126517958012.davem@davemloft.net> <d0c9367d71860bf7c5439511e5f45bd05286d40a.camel@redhat.com>
In-Reply-To: <d0c9367d71860bf7c5439511e5f45bd05286d40a.camel@redhat.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 1 Jun 2020 12:05:14 -0700
Message-ID: <CAM_iQpWcV-9AFj7H7fqZAn2mCpn3xQ9fP4untNpYxWjwJj0S7g@mail.gmail.com>
Subject: Re: [PATCH net-next] net/sched: fix a couple of splats in the error
 path of tfc_gate_init()
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     David Miller <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>, Po Liu <Po.Liu@nxp.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Ivan Vecera <ivecera@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 1, 2020 at 11:49 AM Davide Caratti <dcaratti@redhat.com> wrote:
> hello Dave,
>
> for this patch I will probably need to send a follow-up, because
> the TC action overwrite case probably has still some issues [1] [2].
> I can do that targeting the 'net' tree, unless Po or Cong have some
> objections.
>
> Ok?

Sounds reasonable. It is a bug fix anyway.

Thanks.
