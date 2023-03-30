Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB6286D0E44
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 21:03:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231852AbjC3TDC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 15:03:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230326AbjC3TDB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 15:03:01 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDEE310F8
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 12:02:55 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id h12-20020a17090aea8c00b0023d1311fab3so20777705pjz.1
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 12:02:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680202975;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p2UKzHLw5AMRHbJxUqeu6Kh29H/LxajcGBLc6kBn8NM=;
        b=jfxxG+wlfnmoC+ExMU9oSM4vowDpE80ayaaX0O2aBGqC2elIvYflpzHBV9g0BvsEZY
         xy6wYhpi53/pArSydRtmoRVAkpJ47+6HOoJ/ys8DqhLR0XEPWl1geCfVLPnO86XM/QRs
         5M5lmSeM47SYVWpnHWtSjh92WtSPWEMrmBsN0ndbnr4svt5eEX/U9eifrPjCFUjKDWxF
         6VgrxjuOvQCwWy7y7Gx4PeORHJ+Umqiq9RGATMWBwQNFyL5cTxzzB86fQGpO0r+Bf6Lx
         E6Jkc/UAy5cdsW4StBgbk+kOUz91yWbobl/7E3Nh9H7TljwvXrNPn+Bvi2+tZGoOavcs
         9qkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680202975;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=p2UKzHLw5AMRHbJxUqeu6Kh29H/LxajcGBLc6kBn8NM=;
        b=KUZ7EsjV+uV90KhnCooa8vfTKHmBx494qNTMVkKEJm+sGDH7wG18qJZpbwFbEj6vWN
         1oMyy9DEszaIw7Iqgfs6G3zH3A3LoEQt9LmmzbmZ6J1158wjiMTBILe00rgMzZr3pS16
         ZsQ5LLs7UXQizWDlq7pItJcshskBKJgbb4bzfwW3ehlZHUaNkkvZ6hFl+ewNWXxtEFJv
         HL3jxuK+MdW+IIm94CIn8KqMOQIzNWJyaie+Uh2BaFfAF+/IqWjPf3z5ahco1RCuIDXo
         wR7GY9SjRwYV45NW4mfL8ZVEaLhIsQEd+rp+vxCEC/cwHiWX/NHjqGEUbGav6Z1WNj0X
         8u0w==
X-Gm-Message-State: AAQBX9d1GY3xLbDo6TWrQ5now/wD1ep2nT4WMhOk0yHTF3icUd+4BVIu
        JCOAQbWXC6eK6aMnaWQg4TXDN4FZd8ZyS5ShP4lcdg==
X-Google-Smtp-Source: AKy350YBv3YNxpoBUla7d5uX/Fr+RDrmMNEjWWjz/UysSH7sQgDbddbgiZwEfCWc8HIRLF59xwmJH1bCBsEZ2qXR3hE=
X-Received: by 2002:a17:902:7b89:b0:19f:2c5a:5786 with SMTP id
 w9-20020a1709027b8900b0019f2c5a5786mr8632202pll.8.1680202974843; Thu, 30 Mar
 2023 12:02:54 -0700 (PDT)
MIME-Version: 1.0
References: <168019602958.3557870.9960387532660882277.stgit@firesoul>
 <168019606574.3557870.15629824904085210321.stgit@firesoul>
 <ZCXWerysZL1XwVfX@google.com> <04256caf-aa28-7e0a-59b1-ecf2b237c96f@redhat.com>
In-Reply-To: <04256caf-aa28-7e0a-59b1-ecf2b237c96f@redhat.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Thu, 30 Mar 2023 12:02:43 -0700
Message-ID: <CAKH8qBv9QngYcMjcL=sZR8wVCufPSAv-ZW72OJB-LhZF5a_DrQ@mail.gmail.com>
Subject: Re: [PATCH bpf RFC-V3 1/5] xdp: rss hash types representation
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     brouer@redhat.com, bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, martin.lau@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, alexandr.lobakin@intel.com,
        larysa.zaremba@intel.com, xdp-hints@xdp-project.net,
        anthony.l.nguyen@intel.com, yoong.siang.song@intel.com,
        boon.leong.ong@intel.com, intel-wired-lan@lists.osuosl.org,
        pabeni@redhat.com, jesse.brandeburg@intel.com, kuba@kernel.org,
        edumazet@google.com, john.fastabend@gmail.com, hawk@kernel.org,
        davem@davemloft.net
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 30, 2023 at 11:56=E2=80=AFAM Jesper Dangaard Brouer
<jbrouer@redhat.com> wrote:
>
>
> On 30/03/2023 20.35, Stanislav Fomichev wrote:
> > On 03/30, Jesper Dangaard Brouer wrote:
> >> The RSS hash type specifies what portion of packet data NIC hardware u=
sed
> >> when calculating RSS hash value. The RSS types are focused on Internet
> >> traffic protocols at OSI layers L3 and L4. L2 (e.g. ARP) often get has=
h
> >> value zero and no RSS type. For L3 focused on IPv4 vs. IPv6, and L4
> >> primarily TCP vs UDP, but some hardware supports SCTP.
> >
> >> Hardware RSS types are differently encoded for each hardware NIC. Most
> >> hardware represent RSS hash type as a number. Determining L3 vs L4 oft=
en
> >> requires a mapping table as there often isn't a pattern or sorting
> >> according to ISO layer.
> >
> >> The patch introduce a XDP RSS hash type (enum xdp_rss_hash_type) that
> >> contain combinations to be used by drivers, which gets build up with b=
its
> >> from enum xdp_rss_type_bits. Both enum xdp_rss_type_bits and
> >> xdp_rss_hash_type get exposed to BPF via BTF, and it is up to the
> >> BPF-programmer to match using these defines.
> >
> >> This proposal change the kfunc API bpf_xdp_metadata_rx_hash() adding
> >> a pointer value argument for provide the RSS hash type.
> >
> >> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> >> ---
> >>   include/linux/netdevice.h |    3 ++-
> >>   include/net/xdp.h         |   46 +++++++++++++++++++++++++++++++++++=
++++++++++
> >>   net/core/xdp.c            |   10 +++++++++-
> >>   3 files changed, 57 insertions(+), 2 deletions(-)
> >
>
> [...]
> >> diff --git a/net/core/xdp.c b/net/core/xdp.c
> >> index 528d4b37983d..38d2dee16b47 100644
> >> --- a/net/core/xdp.c
> >> +++ b/net/core/xdp.c
> >> @@ -734,14 +734,22 @@ __bpf_kfunc int
> >> bpf_xdp_metadata_rx_timestamp(const struct xdp_md *ctx, u64 *tim
> >>    * bpf_xdp_metadata_rx_hash - Read XDP frame RX hash.
> >>    * @ctx: XDP context pointer.
> >>    * @hash: Return value pointer.
> >> + * @rss_type: Return value pointer for RSS type.
> >> + *
> >> + * The RSS hash type (@rss_type) specifies what portion of packet hea=
ders NIC
> >> + * hardware were used when calculating RSS hash value.  The type comb=
inations
> >> + * are defined via &enum xdp_rss_hash_type and individual bits can be=
 decoded
> >> + * via &enum xdp_rss_type_bits.
> >>    *
> >>    * Return:
> >>    * * Returns 0 on success or ``-errno`` on error.
> >>    * * ``-EOPNOTSUPP`` : means device driver doesn't implement kfunc
> >>    * * ``-ENODATA``    : means no RX-hash available for this frame
> >>    */
> >> -__bpf_kfunc int bpf_xdp_metadata_rx_hash(const struct xdp_md *ctx,
> >> u32 *hash)
> >> +__bpf_kfunc int bpf_xdp_metadata_rx_hash(const struct xdp_md *ctx,
> >> u32 *hash,
> >> +                     enum xdp_rss_hash_type *rss_type)
> >>   {
> >
> > [..]
> >
> >> +    BTF_TYPE_EMIT(enum xdp_rss_type_bits);
> >
> > nit: Do we still need this with an extra argument?
> >
>
> Yes, unfortunately (compiler optimizes out enum xdp_rss_type_bits).
> Do notice the difference xdp_rss_type_bits vs xdp_rss_hash_type.
> We don't need it for "xdp_rss_hash_type" but need it for
> "xdp_rss_type_bits".

Ah, I missed that. Then why not expose xdp_rss_type_bits?
Keep xdp_rss_hash_type for internal drivers' tables, and export the
enum with the bits?

> --Jesper
>
