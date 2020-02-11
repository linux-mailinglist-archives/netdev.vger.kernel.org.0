Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12A7D15881E
	for <lists+netdev@lfdr.de>; Tue, 11 Feb 2020 03:07:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727728AbgBKCH4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Feb 2020 21:07:56 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:34453 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727592AbgBKCH4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Feb 2020 21:07:56 -0500
Received: by mail-lf1-f68.google.com with SMTP id l18so5813461lfc.1
        for <netdev@vger.kernel.org>; Mon, 10 Feb 2020 18:07:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6ZmktFtWuNRr4MBQJWn7k52Pxjy+kjDuDMoIZxcgghA=;
        b=JShucc8r6D0hpeQT1Nnrm1g5ANmN7Qo/kC9ja9eYheqbwRWtW6iBI7iAF7MqgaTDXe
         EhrqvIPUINQoMoQ8goy1qNA3ZRXhiyGuval5jBA1G2OdAVfZKMH31Bd7+08ReOWRrocf
         QaEnZGmB7acwDOJTWolplby3wrYLVP5sMqcdc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6ZmktFtWuNRr4MBQJWn7k52Pxjy+kjDuDMoIZxcgghA=;
        b=hNWCLWkJFVDrlt2IliKxm/BGv3Ku+/yjTaZDXO+PFrSuRxm0qHcI+LZxTYY33vCpin
         sXM0h0ZTsBaK2fluRga88wJ47W+XqQOrr8Ul5xkn/fYLDkCdMdR840ygLJMDT+n7WWvm
         /YrryXNCgb2hMlb8smZOv6OcVas286G7BlyCnTR+rbI9O48IdMNcSRbhuiujnz7KYd/a
         SGJtIyJ2KK0e2ubV5TrAfEeBYFbDfgrmF+rup7eITDQAZGRC2THSmgcZwN8gWo+jE6h3
         UGr3FeOtgJQuabFqW9efeoi56q933Ue1zWa1bUlym1aHPCGs0+b8IlzcRRNl5ML/NPvc
         Dgcw==
X-Gm-Message-State: APjAAAUoWTbrch8vqSvkuGL0yKQRrU6CpJkxhVWNssuC1Eurrm91XCaz
        f5wckOAFGWu6eqpS3rEqQWFHG/EQEp4=
X-Google-Smtp-Source: APXvYqxDTzxP+3OXkxHUgaIpqqwzRFi+TEKUyen/2XSY34rXPJzhhFJSlC3Bha8Fku1X6h8wUiarGg==
X-Received: by 2002:a19:c3c2:: with SMTP id t185mr2249290lff.56.1581386872785;
        Mon, 10 Feb 2020 18:07:52 -0800 (PST)
Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com. [209.85.208.170])
        by smtp.gmail.com with ESMTPSA id w16sm914436lfc.1.2020.02.10.18.07.51
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Feb 2020 18:07:51 -0800 (PST)
Received: by mail-lj1-f170.google.com with SMTP id v17so9757536ljg.4
        for <netdev@vger.kernel.org>; Mon, 10 Feb 2020 18:07:51 -0800 (PST)
X-Received: by 2002:a2e:97cc:: with SMTP id m12mr2637598ljj.241.1581386871172;
 Mon, 10 Feb 2020 18:07:51 -0800 (PST)
MIME-Version: 1.0
References: <20200210010252-mutt-send-email-mst@kernel.org>
In-Reply-To: <20200210010252-mutt-send-email-mst@kernel.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 10 Feb 2020 18:07:35 -0800
X-Gmail-Original-Message-ID: <CAHk-=whvPamkPZCyeERbgvmyWhJZhdt37G3ycaeRZgOo1bpVVw@mail.gmail.com>
Message-ID: <CAHk-=whvPamkPZCyeERbgvmyWhJZhdt37G3ycaeRZgOo1bpVVw@mail.gmail.com>
Subject: Re: [PULL] vhost: cleanups and fixes
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     KVM list <kvm@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Cc: stable@vger.kernel.org, david@redhat.com, dverkamp@chromium.org,
        hch@lst.de, jasowang@redhat.com, liang.z.li@intel.com, mst@redhat.com,
        tiny.windzz@gmail.com," <wei.w.wang@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 9, 2020 at 10:03 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
>   https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

Hmm? Pull request re-send? This already got merged on Friday as commit
e0f121c5cc2c, as far as I can tell.

It looks like the pr-tracker-bot didn't reply to that old email. Maybe
because the subject line only says "PULL", not "GIT PULL". But more
likely because it looks like lore.kernel.org doesn't have a record of
that email at all.

You might want to check your email settings. You have some odd headers
(including a completely broken name that has "Cc:" in it in the "To:"
field).

               Linus
