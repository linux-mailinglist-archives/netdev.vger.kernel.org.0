Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CFE22C9E6B
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 10:59:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387522AbgLAJ4l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 04:56:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726099AbgLAJ4j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 04:56:39 -0500
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95F93C0613CF
        for <netdev@vger.kernel.org>; Tue,  1 Dec 2020 01:55:53 -0800 (PST)
Received: by mail-ej1-x644.google.com with SMTP id lt17so2887276ejb.3
        for <netdev@vger.kernel.org>; Tue, 01 Dec 2020 01:55:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=819QrdssQw5MkTAHaHDuj8B9nUjOk8+QO2N9CCT745Y=;
        b=mj4gpktJBx+UODGzchcRjUpCnM5fozlzl7WoSiCepyudZhOgYJczq+E5d3n+LR0P8L
         HkkcUEGgU8hJrYWMffWuw+X8471HJib9OCaU7AF1dmSVgyRJNz0fXxrKVROKQ8qb/zY2
         WJw3v6bXx17zttSKdeylhWtje6eZ9GKrmUZySzO+QI+6vX9IAoN7QAYvKJzQxBOtDg9A
         alyZQ0RZEpYRR3AFZq2SCtP61gqTMVNbEd3jLJEp3ppQvcVM4l+C8NwAD8exMQgzNchl
         KloPo31IaspqZCVG73VCMCj2QBoehe3/Kn+OPo2JsxKOZAO2MPq71vW0P96tuvZC5SLK
         xtfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=819QrdssQw5MkTAHaHDuj8B9nUjOk8+QO2N9CCT745Y=;
        b=G/XmbVqSFce/TLeTfDviWu65yzQiFNMdc8lD5KdihjTvC8vcLblna9BcIw+GZg68xd
         9qjmG9YWsixsZ+aHp/nYlBhl4TRbIjR18cEHiNSLilvtLDoJnndkj3zPrqI+qM+JSTaf
         D+OZ3m1N92BDiT+evJWYiblfZrM8SPfsvDn5kiVwYYL+JSuUDV++BAqfNcWIhPcvu+do
         LbXJfuWUe0kJCG0sCuGSF3T5j3Gpt7k4Kc3Si/+6DQV2euaLgGLvYXrS8tHHNtrqRd7e
         ysN52U2fiBPTWDTODdUuyrijbOxeZwNpsr0G1GAP81ZxUUsJT60L0+x4f8/jJm0ymFak
         9nmQ==
X-Gm-Message-State: AOAM5308MIWmI03WwSAJcx7BsxyznsG8t/17DuU8UOkGnSTQO97XdIBf
        ZO4dufb7VaDaTzhIhocaDeATbUEvaL9GLaiJPN/O
X-Google-Smtp-Source: ABdhPJxuD4jU7Z/hfw66sqA/PGimE4xpJJ8Fr7/lUL+MS5PMeoJmh0SKrNIRFYVTEqjt8prpiCotgWVifu3pzCeuh9s=
X-Received: by 2002:a17:906:a218:: with SMTP id r24mr2114829ejy.372.1606816552350;
 Tue, 01 Dec 2020 01:55:52 -0800 (PST)
MIME-Version: 1.0
References: <20201112064005.349268-1-parav@nvidia.com> <5b2235f6-513b-dbc9-3670-e4c9589b4d1f@redhat.com>
 <CACycT3sYScObb9nN3g7L3cesjE7sCZWxZ5_5R1usGU9ePZEeqA@mail.gmail.com>
 <182708df-1082-0678-49b2-15d0199f20df@redhat.com> <CACycT3votu2eyacKg+w12xZ_ujEOgTY0f8A7qcpbM-fwTpjqAw@mail.gmail.com>
 <7f80eeed-f5d3-8c6f-1b8c-87b7a449975c@redhat.com>
In-Reply-To: <7f80eeed-f5d3-8c6f-1b8c-87b7a449975c@redhat.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Tue, 1 Dec 2020 17:55:41 +0800
Message-ID: <CACycT3uw6KJgTo+dBzSj07p2P_PziD+WBfX4yWVX-nDNUD2M3A@mail.gmail.com>
Subject: Re: [External] Re: [PATCH 0/7] Introduce vdpa management tool
To:     Jason Wang <jasowang@redhat.com>
Cc:     Parav Pandit <parav@nvidia.com>,
        virtualization@lists.linux-foundation.org,
        "Michael S. Tsirkin" <mst@redhat.com>, elic@nvidia.com,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 1, 2020 at 2:25 PM Jason Wang <jasowang@redhat.com> wrote:
>
>
> On 2020/11/30 =E4=B8=8B=E5=8D=883:07, Yongji Xie wrote:
> >>> Thanks for adding me, Jason!
> >>>
> >>> Now I'm working on a v2 patchset for VDUSE (vDPA Device in Userspace)
> >>> [1]. This tool is very useful for the vduse device. So I'm considerin=
g
> >>> integrating this into my v2 patchset. But there is one problem=EF=BC=
=9A
> >>>
> >>> In this tool, vdpa device config action and enable action are combine=
d
> >>> into one netlink msg: VDPA_CMD_DEV_NEW. But in vduse case, it needs t=
o
> >>> be splitted because a chardev should be created and opened by a
> >>> userspace process before we enable the vdpa device (call
> >>> vdpa_register_device()).
> >>>
> >>> So I'd like to know whether it's possible (or have some plans) to add
> >>> two new netlink msgs something like: VDPA_CMD_DEV_ENABLE and
> >>> VDPA_CMD_DEV_DISABLE to make the config path more flexible.
> >>>
> >> Actually, we've discussed such intermediate step in some early
> >> discussion. It looks to me VDUSE could be one of the users of this.
> >>
> >> Or I wonder whether we can switch to use anonymous inode(fd) for VDUSE
> >> then fetching it via an VDUSE_GET_DEVICE_FD ioctl?
> >>
> > Yes, we can. Actually the current implementation in VDUSE is like
> > this.  But seems like this is still a intermediate step. The fd should
> > be binded to a name or something else which need to be configured
> > before.
>
>
> The name could be specified via the netlink. It looks to me the real
> issue is that until the device is connected with a userspace, it can't
> be used. So we also need to fail the enabling if it doesn't opened.
>

Yes, that's true. So you mean we can firstly try to fetch the fd
binded to a name/vduse_id via an VDUSE_GET_DEVICE_FD, then use the
name/vduse_id as a attribute to create vdpa device? It looks fine to
me.

Thanks,
Yongji
