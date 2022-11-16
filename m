Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 295A562CB79
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 21:51:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234432AbiKPUvb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 15:51:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234275AbiKPUvV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 15:51:21 -0500
Received: from mail-oa1-x2c.google.com (mail-oa1-x2c.google.com [IPv6:2001:4860:4864:20::2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C5066317F
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 12:51:21 -0800 (PST)
Received: by mail-oa1-x2c.google.com with SMTP id 586e51a60fabf-13bef14ea06so21578053fac.3
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 12:51:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QJRWTOFn39/i2MBqc0YwwydcgnN/YEyrikrpEXRCdQg=;
        b=UhLMdEJLgkja2L58MUWCucpJflLeE3eu0gcnn2N4wQJSP32TC0Kc1+XGhKBoJEZ9I2
         0507fZvy2P7sXrdNF2ok+V8IC8EOq8Zm+Csp53M4NbUwTh0uuQooq0nHsRi89MBPlpws
         9e57Y6llfXTLW/rAa7M9GG0yc4OkIO+GzrbUiD4ZNdtBIMzFjuYd5yB1PzG8CPNeONyY
         9P23qSb98WDjtfuZHcqiLYZd71IFJUZ9m+cpEgQ6jD36T8poGXNEUJK9nWf9DcbnitqP
         iT5kJqZcVD9yv6GZEmWI8g4sz3HjtP7eYwmaK0t3k/C5QBjrOCrTHjAktpro5ANDwqtB
         ly7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QJRWTOFn39/i2MBqc0YwwydcgnN/YEyrikrpEXRCdQg=;
        b=bIv9o8pR4xdEdnpXsO+kavab4yKxSqF40UYHmsX6+CS/WlA57n9KwYT4iXc0D5ox/Z
         01f/AsKZvODcUh92vHyfbEKXab1yUTRBvdAw8DVcurwg10Ok9v+x0vZJQe5ugFhpuTcP
         h/ERxTfqkHrSacfeeAJcUriGmEzXy0PCgKD43Iq5rgAYRUWm7b8Wy5WI5bM9cbgwWdnD
         YYOXID5YZSppWzte9sK4pAE1WmWXp3nJ3ryrv5D5UBTTG+BrJVW8sJTOvtyWmNfAwuZy
         vtknqo/nQ0PKT/DFxPo00hV4N/fM6i2sFuqcEr4HCx0MiIIWVwhUzDOhmHp4BZ2WlESI
         Dupw==
X-Gm-Message-State: ANoB5pnuYdh+++IidgLLqJjx6Hbmc58PQS8ByRA5oqy8rGTcrzsG9uZG
        z4L/Am7xgBRu1sXAoLV1O+trF+iptID58edzd2Cbqg==
X-Google-Smtp-Source: AA0mqf40G5k+V5QgecIZfT0FwoHF2CyhvTHUlA39VcQCr3a5bqKBmxJKbVqTzF5L/aPwVGpnnybEA4WrMSOo6dP96jc=
X-Received: by 2002:a05:6870:e9a2:b0:13b:be90:a68a with SMTP id
 r34-20020a056870e9a200b0013bbe90a68amr2708455oao.181.1668631880557; Wed, 16
 Nov 2022 12:51:20 -0800 (PST)
MIME-Version: 1.0
References: <20221115030210.3159213-1-sdf@google.com> <20221115030210.3159213-7-sdf@google.com>
 <fd21dfd5-f458-dfba-594d-3aafd6a4648a@linux.dev> <87bkp7jklt.fsf@toke.dk>
In-Reply-To: <87bkp7jklt.fsf@toke.dk>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Wed, 16 Nov 2022 12:51:09 -0800
Message-ID: <CAKH8qBuD7=6fyFnK0+OfeyERLfR4bfPP8g9mHB=RaOm+UXqhnQ@mail.gmail.com>
Subject: Re: [xdp-hints] Re: [PATCH bpf-next 06/11] xdp: Carry over xdp
 metadata into skb context
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Martin KaFai Lau <martin.lau@linux.dev>, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, song@kernel.org,
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
        netdev@vger.kernel.org, bpf@vger.kernel.org
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

On Wed, Nov 16, 2022 at 1:48 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Martin KaFai Lau <martin.lau@linux.dev> writes:
>
> > On 11/14/22 7:02 PM, Stanislav Fomichev wrote:
> >> Implement new bpf_xdp_metadata_export_to_skb kfunc which
> >> prepares compatible xdp metadata for kernel consumption.
> >> This kfunc should be called prior to bpf_redirect
> >> or when XDP_PASS'ing the frame into the kernel (note, the drivers
> >> have to be updated to enable consuming XDP_PASS'ed metadata).
> >>
> >> veth driver is amended to consume this metadata when converting to skb=
.
> >>
> >> Internally, XDP_FLAGS_HAS_SKB_METADATA flag is used to indicate
> >> whether the frame has skb metadata. The metadata is currently
> >> stored prior to xdp->data_meta. bpf_xdp_adjust_meta refuses
> >> to work after a call to bpf_xdp_metadata_export_to_skb (can lift
> >> this requirement later on if needed, we'd have to memmove
> >> xdp_skb_metadata).
> >
> > It is ok to refuse bpf_xdp_adjust_meta() after bpf_xdp_metadata_export_=
to_skb()
> > for now.  However, it will also need to refuse bpf_xdp_adjust_head().
>
> I'm also OK with deferring this, although I'm wondering if it isn't just
> as easy to just add the memmove() straight away? :)

SG, let me try that! Martin also mentioned bpf_xdp_adjust_head needs
to be taken care of..
