Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F21E828AAC4
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 23:50:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729541AbgJKVuM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 17:50:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728605AbgJKVuL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Oct 2020 17:50:11 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF448C0613CE
        for <netdev@vger.kernel.org>; Sun, 11 Oct 2020 14:50:11 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id p11so7445998pld.5
        for <netdev@vger.kernel.org>; Sun, 11 Oct 2020 14:50:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iccx2G1iGpG0w8fZM0A192hc6HuyYCamVUV5qoAjOKM=;
        b=XxqQpq4hZ4sGpTIaJ8g5TzWpy7lGrrQ2WOZwgsZH8JGCeWQqXcOWnXVV7bsyuiu4bK
         nlLJ8glMpHTGYow/CE36duR6748q8Q/JjTUybpHmOTeeIoK5HFedEa9WOVeWmkawBJ1p
         oubHhyAJEmIpOwYwxbGbakeg1RlobQgPnEQW3U23N2VooGW3X4tc28gDlk5DK5Z8vSSO
         3qrgCojlDJK7XkshC8nnrfZKUZH+YOKRwKunkAqETdMNe7OCav3UMCwLRGwalMTkvuIy
         JxhXTbK3k/z12kLZ5+VkjbF/FLLy5f7+Tb81FEERw1D0acITR+SH4bpqgQ0jvSiJUH2Z
         5bnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iccx2G1iGpG0w8fZM0A192hc6HuyYCamVUV5qoAjOKM=;
        b=azkchUtpLs4Qt5CLq/4Gd01DuCv9fbJba3XeFwvn8sKfwOD0gR7C6Z39iQM9ELFgCw
         g/RXJxFI/5adZA2fab1DB8+zah9q/xoXQYIOGilKj+FwcCJlvpCCb2lv5mi3m8jweMww
         mWq8fHGHuObC5dTxCLqWVb1xJN0vIMQB+Wdk7Zj79EaA036RNvXuuK+9n639UZ8l++lu
         Yrfs7W5G0m7Svjl99AtYDwMV92kvpTiZMtccnSlvrJWb+8pSdBsfbs27EMKeNeqA1jo0
         syEXH6b4GBLEKx0vK93+RemIypEVjm78GJqRH/68vMmEJKTKhnSQZJ4NZAGwaaWDOQUy
         YcWA==
X-Gm-Message-State: AOAM531xqLt6VC0bLzTDnGwejOkkYLTOTNXSMiSCF4wJdwHXmZPGp2Ml
        r3ZytryNse/G7nyLG/GQn8fXpzURCJ4Fs9+Rz2s=
X-Google-Smtp-Source: ABdhPJwC3s+mdo5HFlu7r8ZJO86plIvSCDUVTYBDb3MuFWs70jJUHP82FttyXwmo+5kPI6lM+8goeGD0VmpYIJcGcfY=
X-Received: by 2002:a17:902:c154:b029:d4:bb6f:6502 with SMTP id
 20-20020a170902c154b02900d4bb6f6502mr14313221plj.23.1602453011216; Sun, 11
 Oct 2020 14:50:11 -0700 (PDT)
MIME-Version: 1.0
References: <20201011191129.991-1-xiyou.wangcong@gmail.com>
 <CAJht_EP5LWUadxwMpdsRAhUrjaUHpi-1QO5N28r7Sqtp4Qxjpw@mail.gmail.com> <CA+FuTSe7QxHUJfyh3Wr3nb+dG=mrE5MCETCdSiVu9ZCXnFqAag@mail.gmail.com>
In-Reply-To: <CA+FuTSe7QxHUJfyh3Wr3nb+dG=mrE5MCETCdSiVu9ZCXnFqAag@mail.gmail.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Sun, 11 Oct 2020 14:50:00 -0700
Message-ID: <CAJht_EOfNv-zHTxzsstPT2-DqaCSb-wrATffoscDPQS3wPkU3w@mail.gmail.com>
Subject: Re: [Patch net v2] ip_gre: set dev->hard_header_len and
 dev->needed_headroom properly
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        syzbot <syzbot+4a2c52677a8a1aa283cb@syzkaller.appspotmail.com>,
        William Tu <u9012063@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 11, 2020 at 2:07 PM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> On Sun, Oct 11, 2020 at 4:42 PM Xie He <xie.he.0141@gmail.com> wrote:
> >
> > Hi, thanks for attempting to fix this tunnel. Are we still considering
> > removing header_ops->create?
> >
> > As said in my email sent previously today, I want to remove
> > header_ops->create because 1) this keeps the un-exposed headers of GRE
> > devices consistent with those of GRETAP devices, and 2) I think the
> > GRE header (and the headers before the GRE header) is not actually the
> > L2 header of the tunnel (the Wikipedia page for "Generic Routing
> > Encapsulation" doesn't consider this protocol to be at L2 either).
> >
> > I'm not sure if you still agree to remove header_ops->create. Do you
> > still agree but think it'd be better to do that in a separate patch?
> >
> > Removing header_ops->create would simplify the fixing of the issue you
> > are trying to fix, too, because that way we would no longer need to
> > use header_ops or hard_header_len. Also, I'm worried that changing
> > hard_header_len (or needed_headroom) in ipgre_link_update would have
> > racing issues. If we remove header_ops, we no longer need to use
> > hard_header_len and we can just set needed_headroom to the maximum
> > value, so that we no longer need to update them in ipgre_link_update.
>
> Our messages crossed.
>
> It seems there are legacy expectations that sendto/recvfrom packet
> sockets allow writing/reading the outer IP address, as of commit
> 6a5f44d7a048 ("[IPV4] ip_gre: sendto/recvfrom NBMA address"). That is
> the express purpose of that commit.
>
> The behavior is inconsistent with other tunnels, as you also point
> out, and probably only rarely used if at all. I would love to get rid
> of it, but given that we cannot be certain that it is unused, I'm afraid
> that we have to continue to support this special case.

OK. At least we agree that in an ideal world header_ops for GRE
devices should be removed.

Thanks, Willem.
