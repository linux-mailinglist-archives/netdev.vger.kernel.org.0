Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F3E06238C8
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 02:26:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232216AbiKJB0O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 20:26:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229802AbiKJB0N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 20:26:13 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 994D2186D6;
        Wed,  9 Nov 2022 17:26:12 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id b1-20020a17090a7ac100b00213fde52d49so355232pjl.3;
        Wed, 09 Nov 2022 17:26:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QDNKEh/nnMeolmM2NRHpBe+qACbk9dXcfRIfhAI2nC4=;
        b=qrxtzVcLdOjnF1pVDiyeQcnoJ2J8SBIp14Y38ivJX3x/WhZhPe2HQWipf+K/U77yA0
         emgCx8WohDOumt2OnN02MFX7SEF4rtKb2vPX+EwXDPLkdR/NRQaELEn0eW0cDzv3HbU/
         1+dlHps5usVtChYEW1Z0L8hsbzNHnUJMNKq+fXta1fwfx8FyV00sDC18oW+LPGhIb49N
         WYwPErYLOOViLp8m/nJ4m9rh4t5FY1hzUmbd2Z1H0AxJroIqnIBs6W9OtHAxHGj9O3qM
         pll6Vbthi8kV7N4853ayKZoFv8e4iQae07YtCte+89y84ylIIT71Y1IZP0gQgCXDUpCJ
         oq8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=QDNKEh/nnMeolmM2NRHpBe+qACbk9dXcfRIfhAI2nC4=;
        b=5R0NCqlfqzYfu6239yVabggTrInAnOAPmCuPRziaYxAOyVOZaUbHeFOXFLON/b/GQ4
         sOK7TOke4YCX8brwWQfNQRQH53PKwHooOS7ksRHqUerKq8ngd6LzEzF1dHbqyq5Sh7N9
         XOOkPh3z1PKriFVk/IRXs7nsuY/89oz5vBF5lNkr1JRRQ/WmWJGIaJCix4geeYA7lmyM
         sEfbqzYOR8zPYCXMmxvyqU7PLXIwtRqQIGy1JgwRzjzYg9E1AHAuvANzqR/lWIaja+VZ
         SZEa6XnrvmtUnXYG5nSxNM1Aw8BibCDwx0RTatpTtdnv+4Wh7FQabktpAxBL36wj59L6
         0fUw==
X-Gm-Message-State: ACrzQf1iLEo+aIKz3DUY7Me7xxZg4HJJGXJkStDkS/27g7vNqAlx4J7K
        pYw4VNeNFA1x7QGg82Rn6U8=
X-Google-Smtp-Source: AMsMyM7S9Svs1nfnHtDkykC5jm6zIG/MFVAfwMkeX9pyECGdstQcsq/gvvpf8yDb9Z+5A3MiyJoaGg==
X-Received: by 2002:a17:902:bcc1:b0:187:31da:494a with SMTP id o1-20020a170902bcc100b0018731da494amr48297993pls.121.1668043572087;
        Wed, 09 Nov 2022 17:26:12 -0800 (PST)
Received: from localhost ([98.97.44.95])
        by smtp.gmail.com with ESMTPSA id j126-20020a625584000000b0056bb21cd7basm8876013pfb.51.2022.11.09.17.26.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Nov 2022 17:26:11 -0800 (PST)
Date:   Wed, 09 Nov 2022 17:26:10 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Stanislav Fomichev <sdf@google.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        song@kernel.org, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Message-ID: <636c533231572_13c9f42087c@john.notmuch>
In-Reply-To: <87leokz8lq.fsf@toke.dk>
References: <20221104032532.1615099-1-sdf@google.com>
 <20221104032532.1615099-7-sdf@google.com>
 <187e89c3-d7de-7bec-c72e-d9d6eb5bcca0@linux.dev>
 <CAKH8qBv_ZO=rsJcq2Lvq36d9sTAXs6kfUmW1Hk17bB=BGiGzhw@mail.gmail.com>
 <9a8fefe4-2fcb-95b7-cda0-06509feee78e@linux.dev>
 <6f57370f-7ec3-07dd-54df-04423cab6d1f@linux.dev>
 <87leokz8lq.fsf@toke.dk>
Subject: Re: [xdp-hints] Re: [RFC bpf-next v2 06/14] xdp: Carry over xdp
 metadata into skb context
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> Snipping a bit of context to reply to this bit:
> =

> >>>> Can the xdp prog still change the metadata through xdp->data_meta?=
 tbh, I am not
> >>>> sure it is solid enough by asking the xdp prog not to use the same=
 random number
> >>>> in its own metadata + not to change the metadata through xdp->data=
_meta after
> >>>> calling bpf_xdp_metadata_export_to_skb().
> >>>
> >>> What do you think the usecase here might be? Or are you suggesting =
we
> >>> reject further access to data_meta after
> >>> bpf_xdp_metadata_export_to_skb somehow?
> >>>
> >>> If we want to let the programs override some of this
> >>> bpf_xdp_metadata_export_to_skb() metadata, it feels like we can add=

> >>> more kfuncs instead of exposing the layout?
> >>>
> >>> bpf_xdp_metadata_export_to_skb(ctx);
> >>> bpf_xdp_metadata_export_skb_hash(ctx, 1234);
> =


Hi Toke,

Trying not to bifurcate your thread. Can I start a new one here to
elaborate on these use cases. I'm still a bit lost on any use case
for this that makes sense to actually deploy on a network.

> There are several use cases for needing to access the metadata after
> calling bpf_xdp_metdata_export_to_skb():
> =

> - Accessing the metadata after redirect (in a cpumap or devmap program,=

>   or on a veth device)

I think for devmap there are still lots of opens how/where the skb
is even built.

For cpumap I'm a bit unsure what the use case is. For ice, mlx and
such you should use the hardware RSS if performance is top of mind.
And then for specific devices on cpumap (maybe realtime or ptp things?)
could we just throw it through the xdp_frame?

> - Transferring the packet+metadata to AF_XDP

In this case we have the metadata and AF_XDP program and XDP program
simply need to agree on metadata format. No need to have some magic
numbers and driver specific kfuncs.

> - Returning XDP_PASS, but accessing some of the metadata first (whether=

>   to read or change it)
> =


I don't get this case? XDP_PASS should go to stack normally through
drivers build_skb routines. These will populate timestamp normally.
My guess is simply descriptor->skb load/store is cheaper than carrying
around this metadata and doing the call in BPF side. Anyways you
just built an entire skb and hit the stack I don't think you will
notice this noise in any benchmark.=
