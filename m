Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1A861DEFBC
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 21:08:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730997AbgEVTId (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 15:08:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730922AbgEVTId (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 15:08:33 -0400
Received: from mail-qv1-xf43.google.com (mail-qv1-xf43.google.com [IPv6:2607:f8b0:4864:20::f43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7BDAC05BD43;
        Fri, 22 May 2020 12:08:32 -0700 (PDT)
Received: by mail-qv1-xf43.google.com with SMTP id fb16so5239973qvb.5;
        Fri, 22 May 2020 12:08:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RSKvN9GsCgTeXDr/XJE3bDuJb3nm0AFXNuuPiYKCNlw=;
        b=uhepK/Mfr7dHA4lujcE2P6GZrPSU5wATxf2sjY/mWHlCeJUMTIhz/fv+nViuEmc8Gf
         GEQo4VpDhkP9sevXvpuZbMVwxfqKTkR+N3bR12CEZFPb28WmIXYalxfQeRvb323sATX2
         idBHO9QxFI16XmxCpgEtjkqQJun/eBMvsjKPbewiOYf5tAqF4JCSu9RxGmO8+PVpAsqw
         kmuQ7zgXmdTf79dRxNxawAujl1+3w0PbJ7GOBFtOMJGjOSC+LwFjawnjvqRG+Y/24Wt/
         bLEMa79tWWEnnI420nxqdTHYbwVrgMlIyg/OctpFjeDBYa9UpYm9FlYrrIQ4k2QMb1Rc
         jAeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RSKvN9GsCgTeXDr/XJE3bDuJb3nm0AFXNuuPiYKCNlw=;
        b=GB5YDZ0n5Lj2KuYZwGllU/BwgU2ECIZmUuKPp/+LyDZNEt8Rx4PoW4VDaxKuYzIKI7
         SNTVg8OtHagmGsotiLiT60SD6c42CpGLRPO9xFanfsZXJlFdZONXYIqBn3UZyxyfHsw7
         sB4m3U6XlX0KCALBS7Hs0Q/0OQ4D5pWykD2m8UTp1Lamh/EUYH8vXmGNf01RJ5GRIzp8
         u8sFTMYs2zg2fUuBMxrz4elvknx65NwETGPC78S04UGseZVukFYQSTtbdJ76VRm73ezA
         fEQ2+jyjOLfoq74wPRvSi2NX3fZ3kW8EtUEpEhZqz9kUb/hM296JqMNe4sdoUo+Jv+Fl
         RqmA==
X-Gm-Message-State: AOAM532fAdpPMIKDQzy+GkQIZ4r5HBk/wBLDKvuGrPGMJrKTqOnXhDMa
        opcLYmb4lkivUXMhSbSmitaWGqgKCtAJe+8yEgE=
X-Google-Smtp-Source: ABdhPJwr8AqOf14843trhTGV00bCKP0IIYcHllnnd6LkWIuEL92YkXQRB2JtH9P+6wA5tZAww620tvxUvTD3dq9CfVM=
X-Received: by 2002:a0c:a892:: with SMTP id x18mr5140027qva.247.1590174512189;
 Fri, 22 May 2020 12:08:32 -0700 (PDT)
MIME-Version: 1.0
References: <20200517195727.279322-1-andriin@fb.com> <20200517195727.279322-8-andriin@fb.com>
 <20200522012328.7vs44qhutdiukrog@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20200522012328.7vs44qhutdiukrog@ast-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 22 May 2020 12:08:21 -0700
Message-ID: <CAEf4Bzat4ct+czJAKta-7Kwo-MVRxSG3J7qe04un3ymn6dK2xw@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 7/7] docs/bpf: add BPF ring buffer design notes
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 21, 2020 at 6:23 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Sun, May 17, 2020 at 12:57:27PM -0700, Andrii Nakryiko wrote:
> > Add commit description from patch #1 as a stand-alone documentation under
> > Documentation/bpf, as it might be more convenient format, in long term
> > perspective.
> >
> > Suggested-by: Stanislav Fomichev <sdf@google.com>
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> >  Documentation/bpf/ringbuf.txt | 191 ++++++++++++++++++++++++++++++++++
>
> Thanks for the doc. Looks great, but could you make it .rst from the start?
> otherwise soon after somebody will be converting it adding churn.

Yeah, sure, will do conversion in v3.
