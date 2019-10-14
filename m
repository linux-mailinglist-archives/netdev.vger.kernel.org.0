Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C26CD6908
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 20:03:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388692AbfJNSCo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 14:02:44 -0400
Received: from mail-pg1-f173.google.com ([209.85.215.173]:43363 "EHLO
        mail-pg1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388677AbfJNSCo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Oct 2019 14:02:44 -0400
Received: by mail-pg1-f173.google.com with SMTP id i32so10520372pgl.10;
        Mon, 14 Oct 2019 11:02:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZkhwpizpfA2VexKlQ2oEQcLnbCJP2Qs7hnm+bKZkprs=;
        b=iqV1EbgfIrrK/aEn7NY5hcsODJgKghSw3zb0g8qpNu/bxk467ktNsNq30MoFBVM8uJ
         X9f9RvUeREb/UaN2RNdUpjgVbwJ/nWJVfCHTu4lzIk1qnzPb2onKunKl42JESCjMODG/
         VGMR2oyaPLm/ancVzJ7VQmoka9YQTnDOj61YUsJ+BVk+t8yVvTg6b8NuVQMQ21RvKZqL
         EpjfJh1D/Ve0ebvy2ixjspdRP2AZQXLd1LQKePb7NBiGyhybK77eCpJwcaYovkTWJuHZ
         jCzNhhC0sxgsomND5b2+0V/EWZu4vDM3+fYx4msdr/5MawxBxYHeYqLLLwpRVumP177m
         +2IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZkhwpizpfA2VexKlQ2oEQcLnbCJP2Qs7hnm+bKZkprs=;
        b=CDHqkT6iV6Z6q5H3KNg67494VHIop/M47EhxmCs3SUprvUWi5GKorQdoD8133W4eIX
         Zt4KPmyfPew4QHnym6CcINeyVL+l4CnGCSREqlX2bhawXNp3scZGYZE0/KX/gJltlcHn
         4hzsLFjQzrCYz65TZHfHk8uvlxAqNj4W3hQLB3GparIWxiVjslwyE3TJadu12UQdbAET
         AZIx3XQJZtonmtvJaSKrFBxLyu/wqhyLWVWNNXGHnAy0Dpscuam7H1J29OfcP3H8YiFt
         FIrj8HP4EH7d6aCOPkAFMFKD6/RktydP+1KhM+cBuFIRFf6TO/mDeT7DpO0lTe+KDovu
         brEQ==
X-Gm-Message-State: APjAAAVzm5sNNb/uhnpRSlcErom9GWmjYjZEcZoV8JLScI1gmWgGLVaN
        wWsSTXi4S/TwPhaSlYICD0qVuOLZOSHetLpcyQA=
X-Google-Smtp-Source: APXvYqxQWcD3OZMgZ13RjzFx9gulMAp7gBH5qy/phpsNrfeg4mjyuhODypsbiToUIfMbUrmcL7a7VzAvGwM09e8wTLs=
X-Received: by 2002:a63:6b06:: with SMTP id g6mr34436310pgc.104.1571076163157;
 Mon, 14 Oct 2019 11:02:43 -0700 (PDT)
MIME-Version: 1.0
References: <00000000000079edde0594d77dd6@google.com> <8a375be8-5a08-4cb5-cd7a-a847a1ec9b31@gmail.com>
In-Reply-To: <8a375be8-5a08-4cb5-cd7a-a847a1ec9b31@gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 14 Oct 2019 11:02:31 -0700
Message-ID: <CAM_iQpUG4_xABqCdjwm77QRhYYh=5B5dV69_ac5SjEuwJa4qNw@mail.gmail.com>
Subject: Re: INFO: task hung in addrconf_verify_work (2)
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     syzbot <syzbot+cf0adbb9c28c8866c788@syzkaller.appspotmail.com>,
        Alexei Starovoitov <ast@kernel.org>, bpf@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        David Ahern <dsahern@gmail.com>, hawk@kernel.org,
        Ido Schimmel <idosch@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Johannes Berg <johannes.berg@intel.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Michal Kubecek <mkubecek@suse.cz>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Petr Machata <petrm@mellanox.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Song Liu <songliubraving@fb.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 13, 2019 at 10:37 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
> Infinite loop because tcf_add_notify() returns -EAGAIN as the message can not be delivered to the socket,
> since its SO_RCVBUF has been set to 0.

Interesting corner case...

>
> Perhaps we need this patch ?

This patch looks reasonable to me, as the -EAGAIN here is mainly (if not
totally) for the locking retry logic.

Thanks.
