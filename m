Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6796918DA87
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 22:47:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727192AbgCTVre (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 17:47:34 -0400
Received: from mail-qv1-f67.google.com ([209.85.219.67]:40701 "EHLO
        mail-qv1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726666AbgCTVrd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 17:47:33 -0400
Received: by mail-qv1-f67.google.com with SMTP id cy12so3870077qvb.7;
        Fri, 20 Mar 2020 14:47:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VlHdPKE0Qj9PMu1C1DT1442L1PWWpxhM86xPqlFjtQs=;
        b=BA3LWTuO4nKZhOfPUm4ikoOpUTNLKp9r3laXtAZ+bj98sQFcgXjCXaK4qLsr+OxZOA
         vBaXN3/cs7bn9MP7rEtfy80shmxsp+wqbixL+4lbogFachlKFb8akzcTwqNdUNbyuU5l
         YfTjOvXARkHwFXL0TPxlnn+uUeb17/pdnI8afiDjN+EUU1GIN5bSqe10834db16hPJpe
         yJfrGg7rWBpOnXhg0K55TsxjylIFBcEQ8/Zz5FAmzc2PvInG15Bkc7DWnneESHPL4G6Q
         c0aS6b3LRgAcekEJ48BoerKccs35aOMA/pV5Bohanz7ZoTLiB2ZLqvv3eg7rFQ0UWzeJ
         wwAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VlHdPKE0Qj9PMu1C1DT1442L1PWWpxhM86xPqlFjtQs=;
        b=YTYbgg5WzE0kAAPLCGPh7z8ECUTY5cmAuynJ2kzgH6AAUVNlvxGhbTl6ILt8oC7Nua
         bAQL2o58IGOdJNXeAXY76A5ASGWR/g4yy3HLN52LOx/3AJX87afGySoUMQHYy3kHdZbQ
         S8Toj65UOgHo/rLwgSc36DKPPVm5GXVxOFqMqjG9aX5FmmzDBVVTPig1hJatxynysbzs
         pLyaW19sAfA9Ot6FmNvWqMbQ0y0wQWS4JolBDQT+d1DAR6lfOworLdE242aZlz+B476l
         y13C7GdWrrSo294RaT/fEr/zuYpm/Go3icTT3P0N0vRMginAgjE4CwOwNA2i+haN67Ge
         fYUA==
X-Gm-Message-State: ANhLgQ3Jft5jZM9eAi4EG8GQC6d/Q6bWQR5hzpO+MD6+80LFSUjyxVte
        eCh/ZyUCHmolnKwXP+iiiFP5aCjDUMRmJQtWUZE3Ng==
X-Google-Smtp-Source: ADFU+vuUn5ppPGbTrd2IOXl9aX/DL3IxHBa66y9yr9Rshoc33LEQFj7Etu+pw2JkOwQo7euvs9JHXfmtJZGNPZ1loRY=
X-Received: by 2002:a0c:bd2a:: with SMTP id m42mr10736364qvg.163.1584740852359;
 Fri, 20 Mar 2020 14:47:32 -0700 (PDT)
MIME-Version: 1.0
References: <20200320203615.1519013-1-andriin@fb.com> <20200320203615.1519013-4-andriin@fb.com>
 <20200320213316.GA2708166@mini-arch.hsd1.ca.comcast.net>
In-Reply-To: <20200320213316.GA2708166@mini-arch.hsd1.ca.comcast.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 20 Mar 2020 14:47:21 -0700
Message-ID: <CAEf4BzYh-DieT1yDmwfg0KrdgCjUNPn6ougvWQhn2htk75ecnQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 3/6] bpf: implement bpf_link-based cgroup BPF
 program attachment
To:     Stanislav Fomichev <sdf@fomichev.me>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 20, 2020 at 2:33 PM Stanislav Fomichev <sdf@fomichev.me> wrote:
>
> On 03/20, Andrii Nakryiko wrote:
> > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > index 5d01c5c7e598..fad9f79bb8f1 100644
> > --- a/include/uapi/linux/bpf.h
> > +++ b/include/uapi/linux/bpf.h
> > @@ -111,6 +111,7 @@ enum bpf_cmd {
> >       BPF_MAP_LOOKUP_AND_DELETE_BATCH,
> >       BPF_MAP_UPDATE_BATCH,
> >       BPF_MAP_DELETE_BATCH,
> [..]
> > +     BPF_LINK_CREATE,
> Curious, why did you decide to add new command versus reusing existing
> BPF_PROG_ATTACH/BPF_PROG_DETACH pair? Can we have a new flag like
> BPF_F_NOT_OWNED that we can set when calling BPF_PROG_ATTACH to trigger
> all these new bpf_link properties (like cgroup not holding an extra ref)?

It was my initial approach, but I've got internal feedback that this
will be actually more confusing than useful. E.g., for bpf_link case,
BPF_PROG_DETACH is disabled, so having BPF_PROG_ATTACH is creating a
false expectation in this case. BPF_PROG attach is returning 0 on
succes and <0 on error, but BPF_LINK_CREATE is returning error or >0
FD.

Also with BPF_LINK_UPDATE, it makes more sense to have dedicated
per-link operations.
