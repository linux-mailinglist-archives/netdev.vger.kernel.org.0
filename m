Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A18C428F9C9
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 21:57:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728264AbgJOT5Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 15:57:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727690AbgJOT5Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Oct 2020 15:57:25 -0400
Received: from mail-vk1-xa42.google.com (mail-vk1-xa42.google.com [IPv6:2607:f8b0:4864:20::a42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68E88C061755
        for <netdev@vger.kernel.org>; Thu, 15 Oct 2020 12:57:25 -0700 (PDT)
Received: by mail-vk1-xa42.google.com with SMTP id c63so84128vkb.7
        for <netdev@vger.kernel.org>; Thu, 15 Oct 2020 12:57:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YBVEqXqrWmYiBEqtmuP4w++5FXvhmYaYH6S1iUxEz+8=;
        b=InD8elzokThpNLw51mii5SWkzrMRCG2AfBmW6AlbcjdWrqu5etEBwQKvIu+sx1EScy
         RG+EY5b7lJsn6ONGD2S7vGDT6z7++dbemWD38tvtlXmo6RKWg6TL6UlkZuYRUkYJC0Ei
         E5AVSQWPmHrfGjoLq9hfFAb2NDvNZ6UncnCOdvrGH1rEXwU+SNlkSeKbYrkgT6Dhlli5
         HvR9OWKCWxzykZXLUuW4qO2DHZ07n74Es0NKFe9Ai7610OgVQ5KagR6X4PKlA9aASqOD
         eZ1PBW2qIhoE248tKmYYhp/RcDtJVxbvskkIk1Z3iwGuGv08UY1+AIaxtfoDj6N0jr2L
         Ryhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YBVEqXqrWmYiBEqtmuP4w++5FXvhmYaYH6S1iUxEz+8=;
        b=Y/wDu7MWvoLRlLBvJZBTgo654Bp/KEWiFzUueJIpWrd6wemJUmhygUHq50W0WIpDdF
         0SQg4MghDzPLGgqFlG1n9eAENHNzYhQC+wRljjJsqmSIyIVDpgk0KMChe7oD5Yq2un4S
         qGZ1riClwrtsNSWNp/BaoGsn9H0rd/pOgJaDN2Glr+jOdFiQvFzuFa//TL6rjt3H85fh
         LdCqOu47fsTQi2dlkdb7mRRGgUibWy6aRKbYrC7GjJRERuGLhwUupoI7FoWds2PbTAmp
         IMNkLR03LjfidFcEDaesBs8UErIbQ++DPDjmF8iaER9ZjkgbtIEm4d7veFe/jPuw4FXZ
         L0HA==
X-Gm-Message-State: AOAM533gegyaEfZLO5DhdstfhQPw1nwbSK2c9n8n1+s0nh2U+DGw8s9f
        8AnC2jhMHPDvQYQAgKgGzL94phBwPqE=
X-Google-Smtp-Source: ABdhPJzjpEQVsdxLG9tEtwbYknstFDPilZ4mQXzU/PzgEoDAld1pxOrHHlB1emjSiDxnjeimrAZ4DA==
X-Received: by 2002:a1f:5106:: with SMTP id f6mr399311vkb.4.1602791844107;
        Thu, 15 Oct 2020 12:57:24 -0700 (PDT)
Received: from mail-ua1-f48.google.com (mail-ua1-f48.google.com. [209.85.222.48])
        by smtp.gmail.com with ESMTPSA id 123sm1337vsr.6.2020.10.15.12.57.22
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Oct 2020 12:57:23 -0700 (PDT)
Received: by mail-ua1-f48.google.com with SMTP id x26so1193516uau.0
        for <netdev@vger.kernel.org>; Thu, 15 Oct 2020 12:57:22 -0700 (PDT)
X-Received: by 2002:ab0:7718:: with SMTP id z24mr218254uaq.92.1602791841985;
 Thu, 15 Oct 2020 12:57:21 -0700 (PDT)
MIME-Version: 1.0
References: <20201011191129.991-1-xiyou.wangcong@gmail.com>
 <CA+FuTSfeTWBpOp+ZCBMBQPqcPUAhZcAv2unwMLqgGt_x_PkrqA@mail.gmail.com>
 <CAJht_EM7KW1+sXpv2PZXwJuECuzDS7knEGGA9k6hogoPSDgW_g@mail.gmail.com>
 <CA+FuTScUwbuxJ-bed+5s_KVXMTj_com+K438hM61zaOp9Muvkg@mail.gmail.com>
 <CAJht_ENhobjCkQmKBB6DtZkx599F3dQyHA4i43=SDSzNkWPLgQ@mail.gmail.com>
 <CA+FuTSd=54S48QXk3-3CBeSdj8L3DAnRRE6LLmeXaN1kUq-_ww@mail.gmail.com>
 <CAJht_EPFCTjv6JAMWFgCdgYpwfEVYB9_r0HaiKUTwekEiPnoDg@mail.gmail.com>
 <CAJht_EN2f=3fwjsW5GcXEAZJuJ934HFVAwxBFff-FAT17a=64w@mail.gmail.com>
 <CA+FuTSf+7fwJHBMog4wiGRmhD32qfdGVhnOarA9jpdeti822xw@mail.gmail.com> <CAJht_EOP3_+R-6_SNZHM9scOO2aWhz1TjFs-0jZbjqBYBiHZ-Q@mail.gmail.com>
In-Reply-To: <CAJht_EOP3_+R-6_SNZHM9scOO2aWhz1TjFs-0jZbjqBYBiHZ-Q@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 15 Oct 2020 15:56:45 -0400
X-Gmail-Original-Message-ID: <CA+FuTSdF9p4Y61Ceucdg9OUT5nv+ieVUy7Rzkq6TUYc532jHCg@mail.gmail.com>
Message-ID: <CA+FuTSdF9p4Y61Ceucdg9OUT5nv+ieVUy7Rzkq6TUYc532jHCg@mail.gmail.com>
Subject: Re: [Patch net v2] ip_gre: set dev->hard_header_len and
 dev->needed_headroom properly
To:     Xie He <xie.he.0141@gmail.com>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        syzbot <syzbot+4a2c52677a8a1aa283cb@syzkaller.appspotmail.com>,
        William Tu <u9012063@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 15, 2020 at 3:19 PM Xie He <xie.he.0141@gmail.com> wrote:
>
> On Thu, Oct 15, 2020 at 6:42 AM Willem de Bruijn
> <willemdebruijn.kernel@gmail.com> wrote:
> >
> > On Wed, Oct 14, 2020 at 10:25 PM Xie He <xie.he.0141@gmail.com> wrote:
> > >
> > > Actually I think dev->type can be seen from user space. For example,
> > > when you type "ip link", it will display the link type for you. So I
> > > think it is useful to keep different dev->type labels without merging
> > > them even if they appear to have no difference.
> >
> > Ah, indeed. These constants are matched in iproute2 in lib/ll_types.c
> > to string representations.
> >
> > Good catch. Yes, then they have to stay as is.
>
> So in this case it may be better to keep dev->type as ARHPHRD_IPGRE
> for GRE devices with or without header_ops. This way we can avoid the
> need to update iproute2.
>
> We can still consider changing GRE devices in collect_md mode from
> ARPHRD_NONE to ARHPHRD_IPGRE. The original author who changed it to
> ARPHRD_NONE might assume ARHPHRD_IPGRE is for GRE devices with
> header_ops, so he felt he needed to distinguish GRE devices without
> header_ops by dev->type. However, ARHPHRD_IPGRE is actually already
> used for GRE devices with header_ops AND without header_ops. So it
> doesn't hurt to use ARHPHRD_IPGRE for GRE devices in collect_md mode,
> too. This would also make iproute2 to correctly display GRE devices in
> collect_md mode as GRE devices.

That's true. Whenever you make user visible changes there is some
chance of breakage. I'm not sure it's worth the risk here. The present
state is perhaps not ideal, but not broken.
