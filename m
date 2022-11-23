Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0403A6368D7
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 19:30:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238849AbiKWS3w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 13:29:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239169AbiKWS3g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 13:29:36 -0500
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3579117AB5
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 10:29:35 -0800 (PST)
Received: by mail-oi1-x22f.google.com with SMTP id v81so19913799oie.5
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 10:29:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nY/GetO0ojf+iZPKg3hv2WXNz71nE7mSwhFRQYOk8rA=;
        b=sz5g01+ON0AtuUZHovF5qCplXGYARKpRflG0mxepxPrTm9wyXboj9DugJNEmbM36o+
         XusU8Loltia9OHBlro3fHJ77xxqJ8Q8vs2y7tpm9PJpCLn/KY4sPPzk2lnUR7qHFt7Uh
         e/q46mZLpm59EKXriFJZ4n33IsZBwRZLZhB3mJ1cIUpk8NxF86VOWPLRmOMlcU8Hm7Ot
         YAvNHDeAFtKoazlpfE49KlyYeZSjy1qqKzl014GojzamO7RL/LINqRg/TMlCCmumzZLe
         WaT4bfHjApuvrYEHV1f5XN95MMTJvB+q7ZUeZ6VC0FRkYNf6Nr2yPABTzlq99ShcrIbX
         n9/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nY/GetO0ojf+iZPKg3hv2WXNz71nE7mSwhFRQYOk8rA=;
        b=iFbjoqKvsVOG1i9xFdXKA2WGXEHgGF57mgu/QvVAJ5S0wGEWoXiyl6YXx5kwK7U914
         rTmG4GRFuVZ/+ZzRmH+fm3EKxx1ffhpWPZGD628EAiCjx5OmmkMac1VjNIWSEI2HT6kt
         SDEtglagn0CJM5+Rkq1gI1tJgZSZ4ubdvHdFr1koneBS81XZ5m+LurDNerVSaXC2WWme
         Y3F+rr0V/9TiBKJ8b7fTeyPHC+bng8FM5l5n5RSv259/zm+BfPhpuDSYTasUh7LuO0XT
         45RY9hYnKlUxuq2iD4rXuu1Ta+UZn0R3OZPmavk98HX3kSFDPohgJ+y5QxxmYT5D4CZE
         IC1g==
X-Gm-Message-State: ANoB5pmz43vvxgyP0wa/dzaj5oDIk8rN/UmiaxzKATyDo4pYg0WJ5LQ0
        wYErfmR+sxCqKbNnS8I4MXkvCqdR4ypSOvezNv+SQQ==
X-Google-Smtp-Source: AA0mqf5Z7f+oqbSMm+nMByO3KvXwrijzWqgC0HeUlc2lWzDx4dH99Nc2INA5soSPtL9HnO9B7JPwvxxzRMShLuIJ4H0=
X-Received: by 2002:a05:6808:f09:b0:354:8922:4a1a with SMTP id
 m9-20020a0568080f0900b0035489224a1amr4511945oiw.181.1669228174410; Wed, 23
 Nov 2022 10:29:34 -0800 (PST)
MIME-Version: 1.0
References: <20221121182552.2152891-1-sdf@google.com> <20221121182552.2152891-9-sdf@google.com>
 <877czlvj9x.fsf@toke.dk>
In-Reply-To: <877czlvj9x.fsf@toke.dk>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Wed, 23 Nov 2022 10:29:23 -0800
Message-ID: <CAKH8qBsSFg+3ULN-+aqabXZJRVwPtq9P71d0VZCuT2tMrx4DHw@mail.gmail.com>
Subject: Re: [xdp-hints] [PATCH bpf-next v2 8/8] selftests/bpf: Simple program
 to dump XDP RX metadata
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

On Wed, Nov 23, 2022 at 6:26 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Stanislav Fomichev <sdf@google.com> writes:
>
> > +static int rxq_num(const char *ifname)
> > +{
> > +     struct ethtool_channels ch =3D {
> > +             .cmd =3D ETHTOOL_GCHANNELS,
> > +     };
> > +
> > +     struct ifreq ifr =3D {
> > +             .ifr_data =3D (void *)&ch,
> > +     };
> > +     strcpy(ifr.ifr_name, ifname);
> > +     int fd, ret;
> > +
> > +     fd =3D socket(AF_UNIX, SOCK_DGRAM, 0);
> > +     if (fd < 0)
> > +             error(-1, errno, "socket");
> > +
> > +     ret =3D ioctl(fd, SIOCETHTOOL, &ifr);
> > +     if (ret < 0)
> > +             error(-1, errno, "socket");
> > +
> > +     close(fd);
> > +
> > +     return ch.rx_count;
> > +}
>
> mlx5 uses 'combined' channels, so this returns 0. Changing it to just:
>
> return ch.rx_count ?: ch.combined_count;
>
> works though :)

Perfect, will do the same :-) Thank you for running and testing!

> -Toke
>
