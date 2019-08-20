Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D0D6966D8
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 18:55:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729887AbfHTQzT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 12:55:19 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:36157 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728360AbfHTQzT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 12:55:19 -0400
Received: by mail-lj1-f194.google.com with SMTP id u15so5789882ljl.3;
        Tue, 20 Aug 2019 09:55:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Phz6WQ0uaL8R2Uo384HhPwvzwbGmWWnyjoGcqcn4K/M=;
        b=h/hBE9eRYU9HgxhgyZEnoN0JE5DY0pDUb1H9+NEedM55giAxftcUR+gDDUYkVh6f/o
         qTA1Zx5iZW2uz/e5AyZ6Six0b2R9lr6npuVTBmYUzPpWA2k8eFAr58fZqcINamuBZCpo
         kGej63QqpVVekQS72+NsSfnRfvwigLUlHstcCrFMYE4I5EXEnhmKg52NB/r3zTzdmnI1
         0g05nvFQ4t++oDWHiU4ztwFvAdn2pW6m60DoqlqExX9pTDhvLPYzwflaiuss8SjzJbMp
         z2UgXUtw2I59fNPj+6JnB0d4TtCpWveoidYYlT+alYkzgMIwDM0+tqElFSZbI3YJqUCK
         PxEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Phz6WQ0uaL8R2Uo384HhPwvzwbGmWWnyjoGcqcn4K/M=;
        b=AvFgKSPDGg7AOJEyg02EVy2tIYWZ2CyaOUCZVpmZ3vG9o19pRiNfWRO21X3NU00hPZ
         Q1b2GjQ/WqCSKRYS/7Dn+FOTYC8EUicdBt8WFMwXqt8MW9Aj+s110W6htUj8lddaW75f
         cRwbEVon9hH8YjDU+l3Py1Y/IMlw9u2xSOj+EZqlSzWJYhJVtey71rTOXl4WG+Vf08kP
         zf0y5HejCiQ/frtZbrftcGCTZceO+QBR8dGQrFYXg3AJZ97pL9/IbuAuSVG8tJ9FPY5z
         DFDwkBpObxDBCCiSBsS5WvuasUo/8fhu/bvRO+58ZYi64bzPOmgWI5MMHzD8+6jKoGVu
         dv8g==
X-Gm-Message-State: APjAAAVhHz1W0XZbx1HVYJ2BNX2IlOj5ePS4ARaagAUNYcxt2+h6Lzhg
        6/fDap1EKQGYwV9wEBtcBopeaTcfzbzoIuQv9Ek=
X-Google-Smtp-Source: APXvYqzNxloBAOX/No5O7h8o8NHa4qt1FYCEk9oHaFrTA34v485tGARu8F78zgB3Z/MW6a+tSY9vxIoxwTccOFWMe5I=
X-Received: by 2002:a2e:80d0:: with SMTP id r16mr15717515ljg.17.1566320117195;
 Tue, 20 Aug 2019 09:55:17 -0700 (PDT)
MIME-Version: 1.0
References: <20190820093154.14042-1-quentin.monnet@netronome.com>
In-Reply-To: <20190820093154.14042-1-quentin.monnet@netronome.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 20 Aug 2019 09:55:03 -0700
Message-ID: <CAADnVQ+ZAgmFKKKnBPt8agJ2V-f6H30OyQ104qD2vZkC=qz9wQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 0/5] bpf: list BTF objects loaded on system
To:     Quentin Monnet <quentin.monnet@netronome.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        oss-drivers@netronome.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 20, 2019 at 2:32 AM Quentin Monnet
<quentin.monnet@netronome.com> wrote:
>
> Hi,
> This set adds a new command BPF_BTF_GET_NEXT_ID to the bpf() system call,
> adds the relevant API function in libbpf, and uses it in bpftool to list
> all BTF objects loaded on the system (and to dump the ids of maps and
> programs associated with them, if any).
>
> The main motivation of listing BTF objects is introspection and debugging
> purposes. By getting BPF program and map information, it should already be
> possible to list all BTF objects associated to at least one map or one
> program. But there may be unattached BTF objects, held by a file descriptor
> from a user space process only, and we may want to list them too.
>
> As a side note, it also turned useful for examining the BTF objects
> attached to offloaded programs, which would not show in program information
> because the BTF id is not copied when retrieving such info. A fix is in
> progress on that side.
>
> v2:
> - Rebase patch with new libbpf function on top of Andrii's changes
>   regarding libbpf versioning.

Applied. Thanks
