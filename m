Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DC0F28C6EF
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 03:56:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728453AbgJMB4n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 21:56:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726168AbgJMB4n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 21:56:43 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F8E3C0613D0
        for <netdev@vger.kernel.org>; Mon, 12 Oct 2020 18:56:43 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id 1so3952185ple.2
        for <netdev@vger.kernel.org>; Mon, 12 Oct 2020 18:56:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Qhtp9DcsHC+50o/dFFEBEUFxetslYLjDExV0KXZhOvU=;
        b=KUjWt7JzbiSYqznwkix6e2uekYJi2Oha8ca4Eo6ZvLUEAA6ipLKYQ5N0Ti8H2wxgZi
         6GWlwSrk2Qkd/yxNnddUGtwGgJOXZp76Ls0ZfNs6UcFf5NbY/uhtnDE5WkqtkS0f/ZB3
         hf59IQ4bCJq6doOgRthi4Smpc2xu+8YcvTlIwGByKetKWgm15mSvCbkskppC3eNKaV6O
         XezVH4l4JjEg4CPL6BT2D6wVtk7tB+/0MRwKCggonW05Dw4r2k7ky3fHa8OvXVoO27PO
         dnY3AYdUA86q2yQel85SbsUIOsJNQs1Q4j5oiFO7GwRS5T4CaKlQk3yzg8QXX3mve0JR
         UKVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Qhtp9DcsHC+50o/dFFEBEUFxetslYLjDExV0KXZhOvU=;
        b=riBf5qxMi1JY6/kO9dFE6lQHa5a3if5i+56uuFsVuoQteZldfKIB9XLerx5cgBEm7q
         4s/Qm3GWYTLT1Zbi9ihvs9/lRyAby5ZluGNf+rmZGeSkXOI3G/wwhHjtp8Batb5stm+e
         wflK+l7C9ISn3WwMjMLvLpO6EzpLcgHEy3D7LNQHcjy/nbvhwXMAhXBFUUkiXB5LjIqG
         ZqOa9iaBagqBMbsaSIGQMrWaIHqhPP2SahByLXpeS7gY39uUAPAULQapkKC+87alZPHy
         OXk0XyHGmoh2rF0uZaAvlXs+7ruabRunJMVZ26WiTlRYiuDLvfW3TlqfiO1zUzP05zJb
         kVOQ==
X-Gm-Message-State: AOAM533vtsi4kwBVDRXvMKa/gLs7u2otRCTQnzsUi7xHmBsZdiJGDmxb
        6AX2oDZobtanPzx/nL/wpbLsxPGBqsd1Pw+1AIk=
X-Google-Smtp-Source: ABdhPJwaxZ/tYZO+6w1kUxalOo1vgKDAqySQcITC5SDv5QYEB2X9bGk3RMhKFbLBXP9TcA6uzFt+BGexGf7GU8LPsAI=
X-Received: by 2002:a17:902:9694:b029:d2:1b52:f46 with SMTP id
 n20-20020a1709029694b02900d21b520f46mr27187256plp.78.1602554202940; Mon, 12
 Oct 2020 18:56:42 -0700 (PDT)
MIME-Version: 1.0
References: <20201012231721.20374-1-xiyou.wangcong@gmail.com>
In-Reply-To: <20201012231721.20374-1-xiyou.wangcong@gmail.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Mon, 12 Oct 2020 18:56:32 -0700
Message-ID: <CAJht_EPOjEACReo3M85TiKNquSPu92JWC3SfwsOr5PS7QDDqKw@mail.gmail.com>
Subject: Re: [Patch net v3] ip_gre: set dev->hard_header_len and
 dev->needed_headroom properly
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        syzbot <syzbot+4a2c52677a8a1aa283cb@syzkaller.appspotmail.com>,
        William Tu <u9012063@gmail.com>,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 12, 2020 at 4:17 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> GRE tunnel has its own header_ops, ipgre_header_ops, and sets it
> conditionally. When it is set, it assumes the outer IP header is
> already created before ipgre_xmit().
>
> This is not true when we send packets through a raw packet socket,
> where L2 headers are supposed to be constructed by user. Packet
> socket calls dev_validate_header() to validate the header. But
> GRE tunnel does not set dev->hard_header_len, so that check can
> be simply bypassed, therefore uninit memory could be passed down
> to ipgre_xmit(). Similar for dev->needed_headroom.
>
> dev->hard_header_len is supposed to be the length of the header
> created by dev->header_ops->create(), so it should be used whenever
> header_ops is set, and dev->needed_headroom should be used when it
> is not set.

Acked-by: Xie He <xie.he.0141@gmail.com>

Thank you for your work, Cong!
