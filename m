Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4BB063E689
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 01:33:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbiLAAdC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 19:33:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbiLAAc7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 19:32:59 -0500
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20CF146665
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 16:32:56 -0800 (PST)
Received: by mail-oi1-x22b.google.com with SMTP id m204so422045oib.6
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 16:32:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qf/BMEs9bgR379g3kVf+2jSNyHJ0315hhT9d1N7WzYU=;
        b=BL2TqVq0b1vLdrW8in8KaMpSdTqJPAQOimTS6oBexCA09t525q1m/RRfBvVwC0MRAO
         cpwlKoLiQpj9gvdq1W2COPSn/b220e4mB025docvuJdQJxqNlURnJqm0uaGh4l1tE4MV
         bs2jyH0KZiCP4r/ImYlnvT7LqM3Gv5/BL8mNESjT1w1cLpSK3S0KrupvD5H8dIiW9/92
         9bI8FVcY6Z3bbMAlXfPdhgNJVJ1Qlco1yxEG7XMH7jIphSiWgXT8a1Y2lUfiY01aCMbn
         d41Xpay/JBoGUZB3ggjQJSFktgkFiSBMX/0pX4Kndg0i3+7e1GqcuUr/HRciEZQCuvir
         qvDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qf/BMEs9bgR379g3kVf+2jSNyHJ0315hhT9d1N7WzYU=;
        b=CHD+ubJ9X7Ez3gb8PPjLdnbiRByTXQImw/JNXdnjmQZgr9Z89bJQI6jnqulwBGFeFn
         hUiWzduN6wapfWJEfUuIFmMxx94CKFhgCfS5ZYU/Hl9Cg8m0xBnX26dFCYNsInfEzQ7B
         Ozys8JRdg4G73UGXe9Urws592vFpzI7vZoJEo7ztnVZ02HmudQY6BPBWpPUvfcGabwgD
         KHX/vSu+f9BniP6SqwWR/WJfhdo8DuKNOM1jJe3FYxX6ev4qgSDV3l9V02ULNS3us1G5
         ESDyFj4tXxBJPx4KBKEhAv3Ke1xGX5BWDkjBnOfecFYwy9n5Bh2Zw7yV7eEKIfwm3LR6
         b5zg==
X-Gm-Message-State: ANoB5plT1dp9W7PaRCeTcbDU5EP41BBEO/zKlW4av0nS26ru4AOYvkTS
        xEoUo5s3pzMFGZtcLvyXD4MK7zy7GQVFYcTaJXz+lw==
X-Google-Smtp-Source: AA0mqf4HQxLdf1XvZmFeToHXrxubXKog8HmFrkwcba231TZQR8oI84iISFXiQSdzK1q8YzFrEINs6w3bC9i71atZCiM=
X-Received: by 2002:a05:6808:a90:b0:35b:aa33:425a with SMTP id
 q16-20020a0568080a9000b0035baa33425amr9696615oij.181.1669854775273; Wed, 30
 Nov 2022 16:32:55 -0800 (PST)
MIME-Version: 1.0
References: <20221129193452.3448944-1-sdf@google.com> <8735a1zdrt.fsf@toke.dk>
 <CAKH8qBsTNEZcyLq8EsZhsBHsLNe7831r23YdwZfDsbXo06FTBg@mail.gmail.com> <87o7soxd1v.fsf@toke.dk>
In-Reply-To: <87o7soxd1v.fsf@toke.dk>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Wed, 30 Nov 2022 16:32:44 -0800
Message-ID: <CAKH8qBsJSJoVJGg3j_JxeM_10BRyYTt6kQvbSMWT016jyUOu6w@mail.gmail.com>
Subject: Re: [xdp-hints] Re: [PATCH bpf-next v3 00/11] xdp: hints via kfuncs
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
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 30, 2022 at 3:01 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Stanislav Fomichev <sdf@google.com> writes:
>
> > On Tue, Nov 29, 2022 at 12:50 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke=
@redhat.com> wrote:
> >>
> >> Stanislav Fomichev <sdf@google.com> writes:
> >>
> >> > Please see the first patch in the series for the overall
> >> > design and use-cases.
> >> >
> >> > Changes since v2:
> >> >
> >> > - Rework bpf_prog_aux->xdp_netdev refcnt (Martin)
> >> >
> >> >   Switched to dropping the count early, after loading / verification=
 is
> >> >   done. At attach time, the pointer value is used only for comparing
> >> >   the actual netdev at attach vs netdev at load.
> >>
> >> So if we're not holding the netdev reference, we'll end up with a BPF
> >> program with hard-coded CALL instructions calling into a module that
> >> could potentially be unloaded while that BPF program is still alive,
> >> right?
> >>
> >> I suppose that since we're checking that the attach iface is the same
> >> that the program should not be able to run after the module is unloade=
d,
> >> but it still seems a bit iffy. And we should definitely block
> >> BPF_PROG_RUN invocations of programs with a netdev set (but we should =
do
> >> that anyway).
> >
> > Ugh, good point about BPF_PROG_RUN, seems like it should be blocked
> > regardless of the locking scheme though, right?
> > Since our mlx4/mlx5 changes expect something after the xdp_buff, we
> > can't use those per-netdev programs with our generic
> > bpf_prog_test_run_xdp...
>
> Yup, I think we should just block it for now; maybe it can be enabled
> later if it turns out to be useful (and we find a way to resolve the
> kfuncs for this case).
>
> Also, speaking of things we need to disable, tail calls is another one.
> And for freplace program attachment we need to add a check that the
> target interfaces match as well.

Agreed, thanks!

> >> >   (potentially can be a problem if the same slub slot is reused
> >> >   for another netdev later on?)
> >>
> >> Yeah, this would be bad as well, obviously. I guess this could happen?
> >
> > Not sure, that's why I'm raising it here to see what others think :-)
> > Seems like this has to be actively exploited to happen? (and it's a
> > privileged operation)
> >
> > Alternatively, we can go back to the original version where the prog
> > holds the device.
> > Matin mentioned in the previous version that if we were to hold a
> > netdev refcnt, we'd have to drop it also from unregister_netdevice.
>
> Yeah; I guess we could keep a list of "bound" XDP programs in struct
> net_device and clear each one on unregister? Also, bear in mind that the
> "unregister" callback is also called when a netdev moves between
> namespaces; which is probably not what we want in this case?
>
> > It feels like beyond that extra dev_put, we'd need to reset our
> > aux->xdp_netdev and/or add some flag or something else to indicate
> > that this bpf program is "orphaned" and can't be attached anywhere
> > anymore (since the device is gone; netdev_run_todo should free the
> > netdev it seems).
>
> You could add a flag, and change the check to:
>
> +               if (new_prog->aux->xdp_has_netdev &&
> +                   new_prog->aux->xdp_netdev !=3D dev) {
> +                       NL_SET_ERR_MSG(extack, "Cannot attach to a differ=
ent target device");
> +                       return -EINVAL;
> +               }
>
> That way the check will always fail if xdp_netdev is reset to NULL
> (while keeping the flag) on dereg?

Something like that, yeah. I'll also take a closer look at offload.c
as Martin points out. I should probably leverage it instead of trying
to add more custom handling here..

> > That should address this potential issue with reusing the same addr
> > for another netdev, but is a bit more complicated code-wise.
> > Thoughts?
>
> I'd be in favour of adding this tracking; I worry that we'll end up with
> some very subtle and hard-to-debug bugs if we somehow do end up
> executing the wrong kfuncs...

SG, will try to address soon!
