Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2595F21E2CC
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 00:04:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726828AbgGMWEX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 18:04:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726150AbgGMWEV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 18:04:21 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C29E9C061755
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 15:04:21 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id c16so15199799ioi.9
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 15:04:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pHoQprPw2aCIr6HyWCFN0TjDMXJaJOp3hVYtxTCpWZ4=;
        b=g8V6jT6ehdpue4fseVB3XNPEKXDkBMjFZnqw1BwRhzquTVHxrQThIyJurltuj73TpU
         Wn415CT3ymnISgfUuemRvYtsBibWThvHV1dcLLwk7VSLHNiu7phKLFWobkChbrqapkPr
         OixVkzAZB1YQqZRPzCEXIRNJLxzhWOuPHIELTfy9c4NnFhhCiCKH2CCGzJfsRgb370Vb
         Rck2S4/jlyDQAP5MBdiA3Bv2lSiQLbOU1JQXDwIoHgYCSJ5SWPs0xyfDk9GyN3+h93FZ
         NH6kFUsR1lK1OFZ3Rl+oe7f8uRr7l6Yp1Sc1xlAAzZUeb810ncCzklLvphrpJq8UqgNw
         yBVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pHoQprPw2aCIr6HyWCFN0TjDMXJaJOp3hVYtxTCpWZ4=;
        b=liK4NoGAy+65pL1b0h3dfKyuz1MZMUs7FPaYo0iUUZdnOBNPrbvI5cmVchRhA5ud/M
         AxSLwP0xL8WVc27Wn1Yj3OQQP/mH79pC1TmxcCHArz20i8QO76ABbwwsUUIsKL9eSBuO
         kIpgssTvE9QKo8VMMEIm6q6wqTXo6AOg9b0yDn+fyHDLdT3qnXbVLAjUEkyR5Rlr2ZG3
         K0KN0HiSCf6ttLDsURu9dUOBEcMdAe+py9KYAWX19u3523BRJx3Fz2nHktd/B/+hn8+u
         D2j0tyFpg8/fqZcbQHBo4demPdDxVBULJWbixdE3lQcS8Ajt1+jd/pDyAutgzpMtWdTx
         caog==
X-Gm-Message-State: AOAM533XT9Y7lCEPBy1IUhUnexCxaH5V9nAjNgBf93Z7ba3AXFGPF0hy
        Rqe0FLzKa2z1RG1PGa1vJNmO8MR9nGMPGzkifxw=
X-Google-Smtp-Source: ABdhPJyhqUc0cyk1UrAtA1R2SD3BqOioT9oW8b5XMWorM1VxejizvbuP17nfPnLyBOGt55kYciNYCCXh8Cr4nyquqkA=
X-Received: by 2002:a05:6602:1581:: with SMTP id e1mr1997838iow.44.1594677861063;
 Mon, 13 Jul 2020 15:04:21 -0700 (PDT)
MIME-Version: 1.0
References: <20200711212848.20914-1-lariel@mellanox.com> <20200711212848.20914-3-lariel@mellanox.com>
In-Reply-To: <20200711212848.20914-3-lariel@mellanox.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 13 Jul 2020 15:04:10 -0700
Message-ID: <CAM_iQpXy-_qVUangkd-V8V_shLRMjRNUpJkrWTZ=xv3sYzzaKQ@mail.gmail.com>
Subject: Re: [PATCH net-next v3 2/4] net/sched: Introduce action hash
To:     Ariel Levkovich <lariel@mellanox.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jiri Pirko <jiri@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 11, 2020 at 2:28 PM Ariel Levkovich <lariel@mellanox.com> wrote:
>
> Allow user to set a packet's hash value using a bpf program.
>
> The user provided BPF program is required to compute and return
> a hash value for the packet which is then stored in skb->hash.

Can be done by act_bpf, right?

>
> Using this action to set the skb->hash is an alternative to setting
> it with act_skbedit and can be useful for future HW offload support
> when the HW hash function is different then the kernel's hash
> function.
> By using a bpg program that emulates the HW hash function user
> can ensure hash consistency between the SW and the HW.

It sounds weird that the sole reason to add a new action is
because of HW offloading. What prevents us extending the
existing actions to support HW offloading?

Thanks.
