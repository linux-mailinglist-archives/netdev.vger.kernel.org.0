Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0B1D412BD1
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 04:36:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350827AbhIUCiY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 22:38:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345945AbhIUCQ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 22:16:57 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C75AAC199765
        for <netdev@vger.kernel.org>; Mon, 20 Sep 2021 11:34:44 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id e7so18282407pgk.2
        for <netdev@vger.kernel.org>; Mon, 20 Sep 2021 11:34:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kGWE4DEfxwvVBX2THHceAoHIpcq6+Bxv3TMqqEdsGKE=;
        b=HrrsFd5RctON906ygKpWzAXUJNWZ9ryB2R3uXkZwI0R3X9JpXw2sXF5ovWXSMAuKF+
         dKC8vbAjsY4HLz1p2aMn1K/xB7XRC1XB9HPL2MrmW2EER8fsLU2UuAeXDnMZcd3LWE92
         juLrK9fnTPBI7ckzmB6kaXXP2CzZyNhvSd0SuXCR+Zsdvqv3DL3pMdoPMEac8Vw2WNu/
         mYMn2fKC1Pjv8DoVn17NdnIuymuSrU8jZIcu0HQjbH7gL4ZiTiKw/iLUMCPX+hJ0z5Mt
         8K2Bvx5oBofGFJKTij1bTHymNL9u97s4hu3yvDdo7CzCYb4Ls+7A4ZCTRSHlgIvXeGDd
         h9jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kGWE4DEfxwvVBX2THHceAoHIpcq6+Bxv3TMqqEdsGKE=;
        b=4aA5kj9FAZ/fQpXogr/QoQ2vb0VEK9ItrggNSfKUl2ycaRFc20JOUHXfN3kUrZ26WB
         JZ1/WhaWzIfS00bJB9soUyudgZxdzIsFotTNDmTkYxtgmUawRoFaIJrGNsVIJWwIX674
         ya4Ok/qCZ7qcS8Oy9oiU+Vn6t0bF+dYqzwbHZ4JzANUc8cvgQ8NtByTIZcA3KnQOol30
         ouUfIyp8Nw/3siKLCjmta9cpVarDaf8E1UmzVo5rtIdvdEoZDM5mhBtHFsq1aT2CqWKA
         3CnPwDxZ5GVT1AAzZp8+4JByyqh4nZwGnUlJe7Se40ZvApMqQg54Je2rjX6MhZ36TcPl
         G5hg==
X-Gm-Message-State: AOAM531LDJbaScY+xx1Fldu0XgjVQCwbZv7J1ObiUvlgkxdCzCnPT+hW
        4XodaBOqBSzafMFN+GxFnSL3MSDk0YCFRWoA01k=
X-Google-Smtp-Source: ABdhPJzAinPpYcKwL+ULVf6FAC3ymTDaUF4T2faiAS+SSENG+2sKDAmBP1nQlhIID+JIFEECBS6bYGAGEAPU5nqEXa8=
X-Received: by 2002:a63:1247:: with SMTP id 7mr24515570pgs.366.1632162884411;
 Mon, 20 Sep 2021 11:34:44 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1632133123.git.lucien.xin@gmail.com> <a1253d4c38990854e5369074e4cbc9cd2098c532.1632133123.git.lucien.xin@gmail.com>
In-Reply-To: <a1253d4c38990854e5369074e4cbc9cd2098c532.1632133123.git.lucien.xin@gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 20 Sep 2021 11:34:33 -0700
Message-ID: <CAM_iQpVvZY2QrQ83FzkmmEe_sG8B86i+w_0qwp6M9WaehEW+Zg@mail.gmail.com>
Subject: Re: [PATCH net 2/2] net: sched: also drop dst for the packets toward
 ingress in act_mirred
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 20, 2021 at 7:12 AM Xin Long <lucien.xin@gmail.com> wrote:
>
> Without dropping dst, the packets sent from local mirred/redirected
> to ingress will may still use the old dst. ip_rcv() will drop it as
> the old dst is for output and its .input is dst_discard.
>
> This patch is to fix by also dropping dst for those packets that are
> mirred or redirected to ingress in act_mirred.

Similar question: what about redirecting from ingress to egress?

BTW, please CC TC maintainers for TC patches.

Thanks.
