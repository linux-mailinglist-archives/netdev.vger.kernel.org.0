Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D2AB67A044
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 18:36:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233961AbjAXRf6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 12:35:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232166AbjAXRf5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 12:35:57 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F20110AB0
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 09:35:56 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id c6so15450573pls.4
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 09:35:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3Xdvi7fIlYYO+f7EySJG/JTcc0Pmw2obhupOEULGvoM=;
        b=FWddA1QM2tSZl3bk6p8veEjjy+nIv282XwDrC4a72f1F1DbSvsofCGGY+Q9+ZIbcAo
         QzXs/ug7zKW5kEDStV6Hy2EfXks+nwn/a5t2lHc1Ds06qzXIrmAb1yYa/Pzlj7y3cZk/
         J521plLn8oh6VREwqCOHqX9q92I4LA7kTMJUgnwHGsJS2MLGVC8vWy57X2f6tINr+N+E
         tG3WNTmrXx3WDDptWXxAtbnIF4Pkt6ZITJ65E/cCXY620PwSyejDwHZSo63dKtwpnUDj
         E/VDG4s56h9BDSwQKdzPaUdNoxWLYP49ryGmd1r2eaVXfi5yvcSJMo33tZnLkLqqN7nz
         eshw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3Xdvi7fIlYYO+f7EySJG/JTcc0Pmw2obhupOEULGvoM=;
        b=k3wVRtk2DfM6fI/cGLkphjA+396+KDTm55j0qzV3IYHWITRIP8CG6V5oVSPBJUmBlA
         6ROzW2+ovSBgpV1eh4447ctlixC8K+YWHFX6wFrawbdXoOzanYqjsxgkFBvIwyFrAwvt
         f9ScBq9MMqO8dPOvlDFupN7GwaoixrOwa/p734asQnUquJ6ffzra48GTIe1SPTUIeIuT
         W4xdolEs6bGpVC4Af4gymI9njsBib22nFutJClbHyysSDS2WfQrzaO8cHJWIibBn/3la
         wOJ2f0Rgy+ei2D7vc8T2ikit1eB6Fkq5KfqZfXikKznv5cmaHaId+SyceyLVTKXqIF7G
         CkMw==
X-Gm-Message-State: AFqh2kqyBad3JomYSTQe9Tcaq+QeFycm5NM65o8oVAQNHkUNtx4owSkp
        3bvps9ar+INabqs8WQnTVo1oUFXXgg5BuMyNkdmViA==
X-Google-Smtp-Source: AMrXdXsevx4h6ZcmBSNEUhpYybXYrpwt4VnRJPSPjl6wWgpUFF5obP1UAhJ0j2Qd5E0Ab3ihQWJJqoZ8/uJYeLh0WmU=
X-Received: by 2002:a17:90b:3741:b0:219:fbc:a088 with SMTP id
 ne1-20020a17090b374100b002190fbca088mr4176615pjb.162.1674581755350; Tue, 24
 Jan 2023 09:35:55 -0800 (PST)
MIME-Version: 1.0
References: <20230119221536.3349901-1-sdf@google.com> <901e1a7a-bb86-8d62-4bd7-512a1257d3b0@linux.dev>
 <CAKH8qBs=1NgpJBNwJg7dZQnSAAGpH4vJj0+=LNWuQamGFerfZw@mail.gmail.com>
 <5b757a2a-86a7-346c-4493-9ab903de19e4@intel.com> <87lelsp2yl.fsf@toke.dk> <da633a14-0d0e-0be3-6291-92313ab1550d@redhat.com>
In-Reply-To: <da633a14-0d0e-0be3-6291-92313ab1550d@redhat.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Tue, 24 Jan 2023 09:35:42 -0800
Message-ID: <CAKH8qBtOM6v0N6iRq+1EPPw2ow9kBD0FXCQJRxuc+02wa+mpkA@mail.gmail.com>
Subject: Re: [xdp-hints] Re: [PATCH bpf-next v8 00/17] xdp: hints via kfuncs
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        brouer@redhat.com, Martin KaFai Lau <martin.lau@linux.dev>,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        song@kernel.org, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
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

On Tue, Jan 24, 2023 at 4:23 AM Jesper Dangaard Brouer
<jbrouer@redhat.com> wrote:
>
>
> On 24/01/2023 12.49, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> > Alexander Lobakin <alexandr.lobakin@intel.com> writes:
> >
> >> From: Stanislav Fomichev <sdf@google.com>
> >> Date: Mon, 23 Jan 2023 10:55:52 -0800
> >>
> >>> On Mon, Jan 23, 2023 at 10:53 AM Martin KaFai Lau <martin.lau@linux.d=
ev> wrote:
> >>>>
> >>>> On 1/19/23 2:15 PM, Stanislav Fomichev wrote:
> >>>>> Please see the first patch in the series for the overall
> >>>>> design and use-cases.
> >>>>>
> >>>>> See the following email from Toke for the per-packet metadata overh=
ead:
> >>>>> https://lore.kernel.org/bpf/20221206024554.3826186-1-sdf@google.com=
/T/#m49d48ea08d525ec88360c7d14c4d34fb0e45e798
> >>>>>
> >>>>> Recent changes:
> >>>>> - Keep new functions in en/xdp.c, do 'extern mlx5_xdp_metadata_ops'=
 (Tariq)
> >>>>>
> >>>>> - Remove mxbuf pointer and use xsk_buff_to_mxbuf (Tariq)
> >>>>>
> >>>>> - Clarify xdp_buff vs 'XDP frame' (Jesper)
> >>>>>
> >>>>> - Explicitly mention that AF_XDP RX descriptor lacks metadata size =
(Jesper)
> >>>>>
> >>>>> - Drop libbpf_flags/xdp_flags from selftests and use ifindex instea=
d
> >>>>>     of ifname (due to recent xsk.h refactoring)
> >>>>
> >>>> Applied with the minor changes in the selftests discussed in patch 1=
1 and 17.
> >>>> Thanks!
> >>>
> >>> Awesome, thanks! I was gonna resend around Wed, but thank you for
> >>> taking care of that!
> >> Great stuff, congrats! :)
> >
> > Yeah! Thanks for carrying this forward, Stanislav! :)

Thank you all as well for the valuable feedback and reviews!

> +1000 -- great work everybody! :-)
>
> To Alexander (Cc Jesse and Tony), do you think someone from Intel could
> look at extending drivers:
>
>   drivers/net/ethernet/intel/igb/ - chip i210
>   drivers/net/ethernet/intel/igc/ - chip i225
>   drivers/net/ethernet/stmicro/stmmac - for CPU integrated LAN ports
>
> We have a customer that have been eager to get hardware RX-timestamping
> for their AF_XDP use-case (PoC code[1] use software timestamping via
> bpf_ktime_get_ns() today).  Getting driver support will qualify this
> hardware as part of their HW solution.
>
> --Jesper
> [1]
> https://github.com/xdp-project/bpf-examples/blob/master/AF_XDP-interactio=
n/af_xdp_kern.c#L77
>
