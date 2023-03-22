Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68A4C6C53C7
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 19:34:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230295AbjCVSeg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 14:34:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229668AbjCVSef (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 14:34:35 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 378C3305E0;
        Wed, 22 Mar 2023 11:34:34 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id cy23so76644126edb.12;
        Wed, 22 Mar 2023 11:34:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679510072;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zXYVlCwzaCfo+TEgKRpH4aKOEUQ6BiDkt6e2qr/DXFc=;
        b=fF+TBG+Lq4+D06+SOgB+UV/iHXuR665aEs3vP9TN9sIrpcu2QGKc1rPbt4THqHFwuk
         DdaoZ6Ul73wtcxi8kCx5cZ7DzlgyilNGPMhcbltGWJopC7YHHpYOhvZQ8o1YIMrocCpE
         HWvmT/oiuvzZAvhFXTdp8pCeXAiAz1N7b82Ju2mOY0zBEg2tcxMvBmS9I2f733aNcuey
         ltOjZU8F6IyFJ1QZNaLRK2bd1WtxBt1ICj3SX/nCUaoCd6nS8Cyc8cJwv/xEsHJcU8eA
         dzeh3CWrJU6OJcU3HNe9/BZspG42mLWTYaiNdbH0uos0zeQFSckGUrqa+rdXGUISLJJl
         IHXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679510072;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zXYVlCwzaCfo+TEgKRpH4aKOEUQ6BiDkt6e2qr/DXFc=;
        b=UmxJ3GPq1HPbPhr/Gjy01gdPAhiZ3f43VhBHaI9SsSfbeNNpNMyzpeS6MOXIOPGKqn
         moTksJiFPFqKTYnbAGiQZ//WbcUvTOhKdYwu/oniXocT/7hzg3/DzWMqxdI/X8HYrOVa
         G7aHhe8q6ypnHMi23K7p/EoWf2xFpW+WgAOK4+KEALtY5yyY2Qu8nK0CIP0Ya4nbZQob
         h9lIjyeLi3Yps5GcfZFkIfslDWT1YsPdh954Ftc9kFjeG2xeIWqcxoyN1Ea9ULuGYtB1
         lLmD13QbAm6LIVAhfLJLaRlmhwcIEL0CCXqXElc5lUZInH9K4xa6hgHydVOPJdZELNNo
         CkSA==
X-Gm-Message-State: AO0yUKVXSI2cYGewh4lGTDghHkvs7Z1WLmjLYVqabbwq2910qqboqY+e
        i6BWQo0Ex50+rHpgwglKwDfJV7OqpkujXmGNTvQ=
X-Google-Smtp-Source: AK7set+cm8vcp787lnxRtwapHZN5BJEt7huWdkMB3WhRgBBpjK5k1sP0sjkwT6LiP1GE3bE/5t41Vq0oMY8RqjEeOvw=
X-Received: by 2002:a17:906:f858:b0:92a:581:ac49 with SMTP id
 ks24-20020a170906f85800b0092a0581ac49mr3776308ejb.3.1679510072459; Wed, 22
 Mar 2023 11:34:32 -0700 (PDT)
MIME-Version: 1.0
References: <167940675120.2718408.8176058626864184420.stgit@firesoul> <682a413b-4f84-cc06-d378-3b44d721c64e@gmail.com>
In-Reply-To: <682a413b-4f84-cc06-d378-3b44d721c64e@gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 22 Mar 2023 11:34:21 -0700
Message-ID: <CAADnVQ+AAiFPDkn0r9+1YAcjgLRoF63HspmcL2CQeqvQcHC57A@mail.gmail.com>
Subject: Re: [PATCH bpf V2] xdp: bpf_xdp_metadata use EOPNOTSUPP for no driver support
To:     Tariq Toukan <ttoukan.linux@gmail.com>,
        Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Larysa Zaremba <larysa.zaremba@intel.com>,
        xdp-hints@xdp-project.net, anthony.l.nguyen@intel.com,
        "Song, Yoong Siang" <yoong.siang.song@intel.com>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 21, 2023 at 1:43=E2=80=AFPM Tariq Toukan <ttoukan.linux@gmail.c=
om> wrote:
>
>
>
> On 21/03/2023 15:52, Jesper Dangaard Brouer wrote:
> > When driver doesn't implement a bpf_xdp_metadata kfunc the fallback
> > implementation returns EOPNOTSUPP, which indicate device driver doesn't
> > implement this kfunc.
> >
> > Currently many drivers also return EOPNOTSUPP when the hint isn't
> > available, which is ambiguous from an API point of view. Instead
> > change drivers to return ENODATA in these cases.
> >
> > There can be natural cases why a driver doesn't provide any hardware
> > info for a specific hint, even on a frame to frame basis (e.g. PTP).
> > Lets keep these cases as separate return codes.
> >
> > When describing the return values, adjust the function kernel-doc layou=
t
> > to get proper rendering for the return values.
> >
> > Fixes: ab46182d0dcb ("net/mlx4_en: Support RX XDP metadata")
> > Fixes: bc8d405b1ba9 ("net/mlx5e: Support RX XDP metadata")
> > Fixes: 306531f0249f ("veth: Support RX XDP metadata")
> > Fixes: 3d76a4d3d4e5 ("bpf: XDP metadata RX kfuncs")
> > Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
>
> For the mlx4/5 parts:
> Acked-by: Tariq Toukan <tariqt@nvidia.com>

FYI this patch was applied to bpf tree.

pw-bot doesn't notice bpf tree anymore :(
