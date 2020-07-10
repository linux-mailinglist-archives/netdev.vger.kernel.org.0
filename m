Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 409DB21AE71
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 07:21:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726536AbgGJFVA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 01:21:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726288AbgGJFUV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 01:20:21 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6B68C08C5CE
        for <netdev@vger.kernel.org>; Thu,  9 Jul 2020 22:20:17 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id d18so4818955ion.0
        for <netdev@vger.kernel.org>; Thu, 09 Jul 2020 22:20:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+lwkF5O8BWiY8G7im/kz7Xiwf3lJM09LEg4kvnx/I7s=;
        b=BeVUg6bBGzXciUBNaRyQSOLa665k2L+cfAgPSQ48PnmXVUcpOroJPgEfv5qGrMLZ5a
         x2bmiHqsR0l/mvefwo8GYLw/bG5hCRFm5bjtvfKdcDtymoLuzQxivMx1nBzI46dwAk10
         uNc2LmDcw3PIcF5WGlVThBPzZlLf8kGQqGDs01iw7NsnjKnUG/sm3dOVc2HeWbbDi/+k
         W/tKs6VjSupiUoFFwEpfDnWmGiWIIxKn2C6naE4gNmxUQ0lXpRyXyJzzljh5DqaTHeS4
         Ffv1Ke+UPLwo/8nHZRgQ6UzlYMi2O2YH2N9jeASdSWD33tN7pwa3PyGwdnqZcy7M7ZwA
         P7Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+lwkF5O8BWiY8G7im/kz7Xiwf3lJM09LEg4kvnx/I7s=;
        b=td9q/nrqVKGwErpx0uUTBI7lc8heBFUIirJy0UsEP9A5qjA+mNNnm3Rz2TyazUHHp/
         1uTUi1hsURPuipUhnOp2LbIpks+57WoCAXMxY94s1MaF7FACkhv95W4TVr+QhkeK8Kpd
         tmuoqSKkaXa7gS02NDaGCKAILLVPcw1daIfMhveXUdpfz8rQDO8vFodHM1Ak0/S3TJ4/
         yPKFnoIwGu5jBsKwaUFst4kYKvTF1aCOii3FAZSvecpZi+9ltUvE1E6V8KWFwMzUoztP
         EynGLvMLas892LQypEg0OTAYSNL+3NBWOd6yQWeMmp/FvrET8KxYxEsM7BSUVmrW4Vbp
         c0ug==
X-Gm-Message-State: AOAM532p4RYR4q30Zurp9HXrB3lPz1zs0JS07qD3XcD5HO1fVI6ppgP/
        zdkUoRSv/mIdP1qobdyGf117gxaTN7eMGxdzAHhUHOujdyA=
X-Google-Smtp-Source: ABdhPJzoRaeUPzjkiTIHl2AJJN7ZwteDJqj+4vKlVnoIX4EBRECyTQ62/9rQYNco9JuU1rZU0Rp8VLhksMQf4f9t0gM=
X-Received: by 2002:a5d:9819:: with SMTP id a25mr44285019iol.85.1594358417259;
 Thu, 09 Jul 2020 22:20:17 -0700 (PDT)
MIME-Version: 1.0
References: <28bff9d7-fa2d-5284-f6d5-e08cd792c9c6@alibaba-inc.com>
 <CAM_iQpVux85OXH-oYeH15sYTb=kEj0o7uu9ug9PeTesHzXk_gQ@mail.gmail.com>
 <5c963736-2a83-b658-2a9d-485d0876c03f@alibaba-inc.com> <CAM_iQpV5LRU-JxfLETsdNqh75wv3vWyCsxiTTgC392HvTxa9CQ@mail.gmail.com>
 <ad662f0b-c4ab-01c0-57e1-45ddd7325e66@alibaba-inc.com> <CAM_iQpUE658hhk8n9j+T5Qfm4Vj7Zfzw08EECh8CF8QW0GLW_g@mail.gmail.com>
 <00ab4144-397e-41b8-e518-ad2aacb9afd3@alibaba-inc.com> <CAM_iQpVoxDz2mrZozAKAjr=bykKO++XM3R-rgyUCb8-Edsv58g@mail.gmail.com>
In-Reply-To: <CAM_iQpVoxDz2mrZozAKAjr=bykKO++XM3R-rgyUCb8-Edsv58g@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 9 Jul 2020 22:20:06 -0700
Message-ID: <CAM_iQpWAHdws4Zu=qD1g5E3tOShefQwK8Mbf9YNCiR2OvHA-Kw@mail.gmail.com>
Subject: Re: [PATCH net-next 2/2] net: sched: Lockless Token Bucket (LTB) Qdisc
To:     "YU, Xiangning" <xiangning.yu@alibaba-inc.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 9, 2020 at 10:04 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> IOW, without these *additional* efforts, it is broken in terms of
> out-of-order.
>

Take a look at fq_codel, it provides a hash function for flow classification,
fq_codel_hash(), as default, thus its default configuration does not
have such issues. So, you probably want to provide such a hash
function too instead of a default class.
