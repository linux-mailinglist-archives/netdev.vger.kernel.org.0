Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92E57648E08
	for <lists+netdev@lfdr.de>; Sat, 10 Dec 2022 10:45:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229818AbiLJJpW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Dec 2022 04:45:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiLJJpJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Dec 2022 04:45:09 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 294FE18E28
        for <netdev@vger.kernel.org>; Sat, 10 Dec 2022 01:44:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670665440;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sEgMOXB1URkPfrDg7A7bvT1ZlUj5a168oU8az7r9NzI=;
        b=WlwcdjYBYAzT7efQR+8FPpKYvb/h9hoMTCml1xzpx6+gq8pPUzdmZF4xvvmZzkwoPQOvtX
        rUuCGCNHFioITw+EHOkGhxJv119p1amfsb5bNLC2tGr5qC4JDmfdLcvCh+JNUHXQwHPg2N
        KF4kDDeEgdwTbHa/W2KdmOjatM4mbKU=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-635-37MUYin8MmmdXiCdktZ-vA-1; Sat, 10 Dec 2022 04:43:59 -0500
X-MC-Unique: 37MUYin8MmmdXiCdktZ-vA-1
Received: by mail-il1-f197.google.com with SMTP id d6-20020a056e02214600b00303620c6e39so1553497ilv.6
        for <netdev@vger.kernel.org>; Sat, 10 Dec 2022 01:43:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sEgMOXB1URkPfrDg7A7bvT1ZlUj5a168oU8az7r9NzI=;
        b=KEnJB0reNC3W6aJKqKAqeZpt7PpoXsRlMdocQDPdwbnORiTjJDZvjetVEpH/Y5C8VV
         MF0RE5V1kdNHPN2jrqOAnPfalo8n8W/MprLcSMwU4J9wjzYQ1mnnkf7PDg5wofXWHix1
         yA8tfzZKGKsWcXHhxp6ZTlsuQaPRl/qt0pT+K6P68IPgj4+TNte7MIFOg9XuMucCxCf2
         QJ/nT7ScHlZq41+wPiy+sYRs1UMEbh9SuKT6zaqmasTP2qYrGaHeee942sfIN8US3lMy
         KDI6meaK7jMzAFXrw/37cpaCsf9R3UyshmvrMhAIzmxZs4a4sY4LXVYzWY1KLZR0X5S7
         PnIQ==
X-Gm-Message-State: ANoB5plDXqmCeL+LqXAFqpomP92mTGXxkR6rZwD12+Ac9bbqFMowEnGA
        n/3cVpUsk+Eh8eGOdAcIjednhzSygAmuyoXvZQTaTaM07kxB4etlqn2sHegDO7mkWahbjlys/sD
        gK4K6XdrSEn9MvV9HZem7m1YkulCK8CAn
X-Received: by 2002:a92:ca8d:0:b0:302:de10:7ae1 with SMTP id t13-20020a92ca8d000000b00302de107ae1mr34308975ilo.15.1670665438872;
        Sat, 10 Dec 2022 01:43:58 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5TlEH6Q+lQ8NRkKblbnwcwT1gZItOWRjjchWox0DLfgEdFskgB/z+cMXoGsiXedca8YsKeiNpW7W9gxGIeWdM=
X-Received: by 2002:a92:ca8d:0:b0:302:de10:7ae1 with SMTP id
 t13-20020a92ca8d000000b00302de107ae1mr34308964ilo.15.1670665438684; Sat, 10
 Dec 2022 01:43:58 -0800 (PST)
MIME-Version: 1.0
References: <20221206145936.922196-1-benjamin.tissoires@redhat.com> <nycvar.YFH.7.76.2212101007030.9000@cbobk.fhfr.pm>
In-Reply-To: <nycvar.YFH.7.76.2212101007030.9000@cbobk.fhfr.pm>
From:   Benjamin Tissoires <benjamin.tissoires@redhat.com>
Date:   Sat, 10 Dec 2022 10:43:47 +0100
Message-ID: <CAO-hwJJkDBeHrqzuNUOe72osOsM+W3ySc6yygt0rPqDzFi=v-A@mail.gmail.com>
Subject: Re: [PATCH HID for-next v3 0/5] HID: bpf: remove the need for
 ALLOW_ERROR_INJECTION and Kconfig fixes
To:     Jiri Kosina <jikos@kernel.org>
Cc:     Florent Revest <revest@chromium.org>,
        Jon Hunter <jonathanh@nvidia.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 10, 2022 at 10:07 AM Jiri Kosina <jikos@kernel.org> wrote:
>
> On Tue, 6 Dec 2022, Benjamin Tissoires wrote:
>
> > Compared to v2, I followed the review from Alexei which cleaned up the
> > code a little bit.
> >
> > I also got a kbuild test bot complaining[3] so add a fix for that too.
> >
> > For reference, here is the previous cover letter:
> >
> > So this patch series aims at solving both [0] and [1].
> >
> > The first one is bpf related and concerns the ALLOW_ERROR_INJECTION API.
> > It is considered as a hack to begin with, so introduce a proper kernel
> > API to declare when a BPF hook can have its return value changed.
> >
> > The second one is related to the fact that
> > DYNAMIC_FTRACE_WITH_DIRECT_CALLS is currently not enabled on arm64, and
> > that means that the current HID-BPF implementation doesn't work there
> > for now.
> >
> > The first patch actually touches the bpf core code, but it would be
> > easier if we could merge it through the hid tree in the for-6.2/hid-bpf
> > branch once we get the proper acks.
>
> For the series:
>
>         Reviewed-by: Jiri Kosina <jkosina@suse.cz>

Thanks. I have applied the rest of the series to for-6.2/hid-bpf.

Cheers,
Benjamin

>
> Thanks,
>
> --
> Jiri Kosina
> SUSE Labs
>

