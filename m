Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B7B663CBF5
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 00:41:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230160AbiK2Xlq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 18:41:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230016AbiK2Xlp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 18:41:45 -0500
Received: from mail-oa1-x2d.google.com (mail-oa1-x2d.google.com [IPv6:2001:4860:4864:20::2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BB8F6F0DA
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 15:41:44 -0800 (PST)
Received: by mail-oa1-x2d.google.com with SMTP id 586e51a60fabf-1322d768ba7so19083380fac.5
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 15:41:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UWfZ91ImgWeO8DwgII+oCDs9mlXWxVZrR+3wVed57KM=;
        b=mZr58q/aMc2yWL/6kZbHxgPxdDDOBWBbYRmyE648vEE+k7lSU3XpJb40CYcuma1AqV
         /vFlt7uuXj/Xwoi67Kf/l6EQX6uNGbhGu1EGzm/jPCn5NQSKBAMYYwtlQo+XF4/0hU1g
         znlSqRl0p/u7xOUP88YFNU2Hkh0QYKeKdFrqgQz33S8hgYDJjvO7WRwfo8A9UZEVAmFe
         r8ZMaxrfunSHoHL+5oTFOQApIrkENZ7ln8idCJ4W7xIRpspgZtSRdF2rZb/4ZT/fVMBH
         H22Bun9twBSG2fQrnkf2LL45FbTGSk1A3NDB3+XlzJWpVRDGQZymb90RzP8JdTJOj8te
         8EUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UWfZ91ImgWeO8DwgII+oCDs9mlXWxVZrR+3wVed57KM=;
        b=udq3IWZS2tPFENNkikFwnstto+3ydKBCPqOZAFGfTCQkkp1i0wHmzW2heL71dkxbfR
         1pTjBgtvWp7LDHqpWEVMiHGb7B7cbF0f/zgWXOiOIk+QWz9uZRAASFsHyOAa7ZvjdG92
         Poi6EuSHxFtOVgu7sLKh9spZhNSTlxj6NJOnZfDpTn94e4t1d7GnTqT39ce0pNPe+Tmf
         bQlR8AB/rWIrHSw2Cv9fxP56UqymegrXIWN5WXonoDp+wA3ZCbfAVRnnOyfHRq8Zd6jW
         77wjFQU0+nwKY6n59UnX68ceo2a4eaE4eB8j5UyjnXk2GacQjT4dICe/xmx4BNNlMmkK
         3UpA==
X-Gm-Message-State: ANoB5pkudeSoE2SHN70GKsvgupG24wSWL4xuwOSwycDmT6jiFzX1augT
        Qtcc2v+0gmcCV8dfTjZcR618t8LeiKEglhcYiDHl7w==
X-Google-Smtp-Source: AA0mqf4tY0QqX5s08Ulkn5JAFiHJ8maUKTh5dzZLB/ResofP+IafTNtppviQZG4XH7cBw5GaPzhVwpJphlSZkXXyObM=
X-Received: by 2002:a05:6870:c18a:b0:142:870e:bd06 with SMTP id
 h10-20020a056870c18a00b00142870ebd06mr29858140oad.181.1669765303730; Tue, 29
 Nov 2022 15:41:43 -0800 (PST)
MIME-Version: 1.0
References: <20221129193452.3448944-1-sdf@google.com> <8735a1zdrt.fsf@toke.dk>
In-Reply-To: <8735a1zdrt.fsf@toke.dk>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Tue, 29 Nov 2022 15:41:32 -0800
Message-ID: <CAKH8qBsTNEZcyLq8EsZhsBHsLNe7831r23YdwZfDsbXo06FTBg@mail.gmail.com>
Subject: Re: [xdp-hints] [PATCH bpf-next v3 00/11] xdp: hints via kfuncs
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org,
        haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 29, 2022 at 12:50 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@red=
hat.com> wrote:
>
> Stanislav Fomichev <sdf@google.com> writes:
>
> > Please see the first patch in the series for the overall
> > design and use-cases.
> >
> > Changes since v2:
> >
> > - Rework bpf_prog_aux->xdp_netdev refcnt (Martin)
> >
> >   Switched to dropping the count early, after loading / verification is
> >   done. At attach time, the pointer value is used only for comparing
> >   the actual netdev at attach vs netdev at load.
>
> So if we're not holding the netdev reference, we'll end up with a BPF
> program with hard-coded CALL instructions calling into a module that
> could potentially be unloaded while that BPF program is still alive,
> right?
>
> I suppose that since we're checking that the attach iface is the same
> that the program should not be able to run after the module is unloaded,
> but it still seems a bit iffy. And we should definitely block
> BPF_PROG_RUN invocations of programs with a netdev set (but we should do
> that anyway).

Ugh, good point about BPF_PROG_RUN, seems like it should be blocked
regardless of the locking scheme though, right?
Since our mlx4/mlx5 changes expect something after the xdp_buff, we
can't use those per-netdev programs with our generic
bpf_prog_test_run_xdp...

> >   (potentially can be a problem if the same slub slot is reused
> >   for another netdev later on?)
>
> Yeah, this would be bad as well, obviously. I guess this could happen?

Not sure, that's why I'm raising it here to see what others think :-)
Seems like this has to be actively exploited to happen? (and it's a
privileged operation)

Alternatively, we can go back to the original version where the prog
holds the device.
Matin mentioned in the previous version that if we were to hold a
netdev refcnt, we'd have to drop it also from unregister_netdevice.
It feels like beyond that extra dev_put, we'd need to reset our
aux->xdp_netdev and/or add some flag or something else to indicate
that this bpf program is "orphaned" and can't be attached anywhere
anymore (since the device is gone; netdev_run_todo should free the
netdev it seems).
That should address this potential issue with reusing the same addr
for another netdev, but is a bit more complicated code-wise.
Thoughts?

> -Toke
>
