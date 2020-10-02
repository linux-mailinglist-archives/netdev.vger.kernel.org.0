Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0EAB281AB1
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 20:13:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388275AbgJBSNz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 14:13:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726017AbgJBSNy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 14:13:54 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56DDDC0613D0;
        Fri,  2 Oct 2020 11:13:53 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id 67so1804560ybt.6;
        Fri, 02 Oct 2020 11:13:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aZug4wKTw7QpG/4RqonYa4BNVRxqzVE2szW6NmWqrEc=;
        b=K/RjbXMCUxvR/UIUdwDx4dNitz3+7C2JksVxTrLsxwsxmBuDiNi6eNX72D5a5HnAJZ
         opfX+rFyigwillLYPao1WYZzFjKWI2mMc6zIEOZ8p2kmloe337I32LOhJMNK+jhYolTH
         WKTwDnBRNcrs9MG9m035DjDJ5vIzNi5S98EK4gsbXWUsE4NqDX66mjfrccUjt1FlXvSo
         VSj/vmCcBjoM7yjH+KaXeUOnJGe1DsL8427Fu5WrtwWAPUZWkxIkCaa0sX4VdxN9o6K9
         R2ag9rCvEXzCzlz7fldcWoCqldmGFHUu1fU1cds2WnMKFYjABmfBV8n/uf2yBvQuhOym
         jeyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aZug4wKTw7QpG/4RqonYa4BNVRxqzVE2szW6NmWqrEc=;
        b=eCbeOXEjMSs05ngUG1P4n3l7ddBSJ1bW9A/oCFst9w+z9lR2iTruANFhqxAlyYvzve
         4oFmqDCKZeELDRtzhAE+lxOHHtxDHqnbnFwsBwfnpfAO7Qb3JGMKPyHOjboPv0Jy40Ct
         MFR7KpZrH59OrJsVdnsEh6D6NKXDf0ffqhkxiJBB7HhV1LvIq53SwaSK0QApCBvwpx23
         6sElRMtk0YklUbm0ciRtLaJa8nCmuTqrkskFuanQVW20AVeKsrxikLH7WAQSX3ZOEo8/
         LmKKHAwov0+x+wZIKFCzk8dsNCfS2b29HKsApd96xPNkKHAAk4LZwGNkutpYNfR6iEUc
         WpZA==
X-Gm-Message-State: AOAM532W+3uFieJ4XHoimdkWZblKoo6L/RB51Z+XC+K9eA0BhjbteHf2
        QKU6C6YInq+b1IP+dXJDKK5KUfEwGPVdUsqUN0E=
X-Google-Smtp-Source: ABdhPJxXl0gX900SfwuCet8AAjoKxcnGqsi+Mr73feiYNDxsZOU5pB1iQlwLs3Ju+HDjw8WEor4DafITX8Hvovizir4=
X-Received: by 2002:a25:6644:: with SMTP id z4mr4515603ybm.347.1601662432651;
 Fri, 02 Oct 2020 11:13:52 -0700 (PDT)
MIME-Version: 1.0
References: <20201002075750.1978298-1-liuhangbin@gmail.com> <20201002114936.GA20275@ranger.igk.intel.com>
In-Reply-To: <20201002114936.GA20275@ranger.igk.intel.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 2 Oct 2020 11:13:41 -0700
Message-ID: <CAEf4BzZBCYSdYxpAJ_gv0jRpuvTObpobQVccoqmsYVybgmfbxg@mail.gmail.com>
Subject: Re: [PATCH libbpf] libbpf: check if pin_path was set even map fd exist
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     Hangbin Liu <liuhangbin@gmail.com>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 2, 2020 at 4:56 AM Maciej Fijalkowski
<maciej.fijalkowski@intel.com> wrote:
>
> On Fri, Oct 02, 2020 at 03:57:50PM +0800, Hangbin Liu wrote:
> > Say a user reuse map fd after creating a map manually and set the
> > pin_path, then load the object via libbpf.
> >
> > In libbpf bpf_object__create_maps(), bpf_object__reuse_map() will
> > return 0 if there is no pinned map in map->pin_path. Then after
> > checking if map fd exist, we should also check if pin_path was set
> > and do bpf_map__pin() instead of continue the loop.
> >
> > Fix it by creating map if fd not exist and continue checking pin_path
> > after that.
> >
> > Suggested-by: Andrii Nakryiko <andrii.nakryiko@gmail.com>
> > Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> > ---
> >  tools/lib/bpf/libbpf.c | 75 +++++++++++++++++++++---------------------
> >  1 file changed, 37 insertions(+), 38 deletions(-)
> >

[...]

> > +
> > +                     if (map->init_slots_sz) {
>
> Couldn't we flatten the code by inverting the logic here and using goto?

I explicitly asked Hangbin to not use goto to alter control flow here,
I'd like to keep goto within libbpf mostly for error handling.

>
>         if (!map->init_slot_sz) {
>                 pr_debug("map '%s': skipping creation (preset fd=%d)\n",
>                          map->name, map->fd);
>                 goto map_pin;
>         }
>
>         (...)
> map_pin:
>         if (map->pin_path && !map->pinned) {
>
> If I'm reading this right.
>

[...]

> > --
> > 2.25.4
> >
