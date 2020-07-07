Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1414A21783D
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 21:48:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728448AbgGGTsk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 15:48:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727003AbgGGTsj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 15:48:39 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 729D2C061755
        for <netdev@vger.kernel.org>; Tue,  7 Jul 2020 12:48:39 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id v6so30832884iob.4
        for <netdev@vger.kernel.org>; Tue, 07 Jul 2020 12:48:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=G8/+uH7geSfjwOLSjoKYzxVRyNcWK2FsXaGwSUYJUAE=;
        b=ro/seMS6g/W3njkQMUXq7oRfOqgbZHlBl8zINAKpUVoGio8tqbadtSxP3weztDjd/E
         6sZRtYyAoJeD5Sa3GZQeeFSXMx3YhRTKjEyriSOcoPLj29VL7+S5vVNH5H8KSXm25svm
         m5AeoTfc4mge6l/x+UwwycCLAZaKKDzQh41JhtK6YC9aucLNhN6P2zbKFBGTXshckNm1
         qSlXHJO3oV0+IHo6CsxdBeeAhMs/NDR/h2IWQJFgdpXD0cvDUFYFC0G8nFWhLqfirdwC
         Lm/4TwpRh7q9axBczf4zK+1gbqsrhvopAn+Ry1E+LbemctJIHpW6rXXgWxPxtQ2hU1I+
         txLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=G8/+uH7geSfjwOLSjoKYzxVRyNcWK2FsXaGwSUYJUAE=;
        b=s6SeffO1Gw5r8WchiD9Dz/BcSbcqbHmuSizjgsOY9jpV0eT99aQLkzh5wxSaLZ6nvE
         eSbhkXLta6LTgNKaLZlamFWt8jJ8QsGd5KCzeWjV7JsOZ6CXFXcMZmaOt9PAnKeEeZSB
         cwq2sGRwgOHZGVilrQf8tnkldgwKtOkaXhcUarTEMAMEMgG013v8Ay3Eale5nHW1iCCO
         C1R0n/wAecXxNHj2SaMhTFWFYsrCB/vVIabIxMsil1MMgdo94p5JhO6i99mngc8efRsV
         57XDh5qcb9shK1t3MJDXoFabuaUK5ibC9vhy8L4M2ZAJ1PUP5YI8eYt4Bbm0edbTnfoj
         Dp3w==
X-Gm-Message-State: AOAM530U2WPgk/deaH0K+LHeFB//tFRpI43++9LjE9M5yN1Ve3gajNgL
        JgyaQ/c3xJYDU9Xil6ga2ihT48f90nUADBN+1CvNysswaIo=
X-Google-Smtp-Source: ABdhPJzJqNR0pYYQe+HAra8uGDcj4jEUmJhzu/fXef/zVmz6feqKuoR6mW9yR2CQPsN5U/0fY6L5ZDINKMvpSZlNo5A=
X-Received: by 2002:a05:6602:148d:: with SMTP id a13mr33571258iow.44.1594151318815;
 Tue, 07 Jul 2020 12:48:38 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1593209494.git.petrm@mellanox.com> <79417f27b7c57da5c0eb54bb6d074d3a472d9ebf.1593209494.git.petrm@mellanox.com>
In-Reply-To: <79417f27b7c57da5c0eb54bb6d074d3a472d9ebf.1593209494.git.petrm@mellanox.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 7 Jul 2020 12:48:27 -0700
Message-ID: <CAM_iQpXBF6hBb4T_cjGw39PRuxaxE1f=Cfmr49QMkCtv-LT61w@mail.gmail.com>
Subject: Re: [PATCH net-next v1 2/5] net: sched: Introduce helpers for qevent blocks
To:     Petr Machata <petrm@mellanox.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 26, 2020 at 3:46 PM Petr Machata <petrm@mellanox.com> wrote:
> The function tcf_qevent_handle() should be invoked when qdisc hits the
> "interesting event" corresponding to a block. This function releases root
> lock for the duration of executing the attached filters, to allow packets
> generated through user actions (notably mirred) to be reinserted to the
> same qdisc tree.

I read this again, another question here is: why is tcf_qevent_handle()
special here? We call tcf_classify() under root lock in many other places
too, for example htb_enqueue(), which of course includes act_mirred
execution, so why isn't it a problem there?

People added MIRRED_RECURSION_LIMIT for this kinda recursion,
but never released that root lock.

Thanks.
