Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C9485B1640
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 10:06:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230012AbiIHIGV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 04:06:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229782AbiIHIGU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 04:06:20 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD24F2A720;
        Thu,  8 Sep 2022 01:06:18 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id s206so15998843pgs.3;
        Thu, 08 Sep 2022 01:06:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=srKp0qF1Diby5Qs9xfv49IWriKBlWuLXT5Vhw8RgQwA=;
        b=pYClB6FS9fkQJ5dt0Gt64pDWEkSCLMROuws+FO+tdaksEJnwfYGi+WhEKmcgU1uM/A
         FflnhAPK3MIEeVOpmabdaFB6iJue3l9izzL+cTkDpS2Y1gQ8A1zpsw13yRXsNTvxggLX
         00dHo1IYwxj6jQ919AYsDphu1A6GULpmksejsvpYEjbF9+Voo/vOXqaPelkT7UPAwa6D
         TYNZdH2FDfDZZgFQlhyh04XZ3VmTty14teo0BNTrEbTnBl6f4ppyzeYhSeG57FVOIAc2
         z/hwtGO/QXLfd3UEQ+Xx50uOorZON8lkspfytJCWt9Flad7V8m801cOz9isQ7lrL707p
         MMSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=srKp0qF1Diby5Qs9xfv49IWriKBlWuLXT5Vhw8RgQwA=;
        b=V32WHEP+JxtvhwGbcHThwmhIOAEyjQFHe+NGCTnCTitdcqxMGsZnjUOEJbdsDg4Teb
         zq4f6m0vW/Bn50s7OH3gWzyLnf263WwbrsskP+HFopB6SX7ivDSh7Mp7z1EjA3Stn4CE
         cUsvZI1Ic/0yGZRxSHMRXVHUzZ0QCdhFwCTZrL33T/JBLODRuojdsL+Ch9DwjOg41C3k
         NrvQhGJcqg0pY9nvL/mKM26cex/6TH1vug8wsVbZn/K3RAvsrSh0mWvUPkdl0xWJvBcM
         zT/45jowaRD+4VkI5XKi6EPFzLMsIwvk4uIjU0PMNBE95CeXVf8KX79kcQ95hmjXVHiW
         Yhjg==
X-Gm-Message-State: ACgBeo3aW9H/NmL3r+TGeRBC/i84A/15uMyqZJsR2cYeted3+z4HHagh
        fSsrS9hM91yybaPuuXfn2oe9D0PSh8WxCS/VrtY=
X-Google-Smtp-Source: AA6agR57bUG3mPEtxyWXG+q4PpxQqoYcnvuFddzBAFn03hap+zWba66gaObxQ5TYtNzzDguiam3ukKXhvg31qkBIdCs=
X-Received: by 2002:a63:cc51:0:b0:41f:12f5:675b with SMTP id
 q17-20020a63cc51000000b0041f12f5675bmr6690826pgi.69.1662624378290; Thu, 08
 Sep 2022 01:06:18 -0700 (PDT)
MIME-Version: 1.0
References: <166256538687.1434226.15760041133601409770.stgit@firesoul> <166256558657.1434226.7390735974413846384.stgit@firesoul>
In-Reply-To: <166256558657.1434226.7390735974413846384.stgit@firesoul>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Thu, 8 Sep 2022 10:06:06 +0200
Message-ID: <CAJ8uoz3UcC2tnMtG8W6a3HpCKgaYSzSCqowLFQVwCcsr+NKBOQ@mail.gmail.com>
Subject: Re: [PATCH RFCv2 bpf-next 17/18] xsk: AF_XDP xdp-hints support in
 desc options
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        xdp-hints@xdp-project.net, larysa.zaremba@intel.com,
        memxor@gmail.com, Lorenzo Bianconi <lorenzo@kernel.org>,
        mtahhan@redhat.com,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        dave@dtucker.co.uk, Magnus Karlsson <magnus.karlsson@intel.com>,
        bjorn@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 7, 2022 at 5:48 PM Jesper Dangaard Brouer <brouer@redhat.com> wrote:
>
> From: Maryam Tahhan <mtahhan@redhat.com>
>
> Simply set AF_XDP descriptor options to XDP flags.
>
> Jesper: Will this really be acceptable by AF_XDP maintainers?

Maryam, you guessed correctly that dedicating all these options bits
for a single feature will not be ok :-). E.g., I want one bit for the
AF_XDP multi-buffer support and who knows what other uses there might
be for this options field in the future. Let us try to solve this in
some other way. Here are some suggestions, all with their pros and
cons.

* Put this feature flag at a known place in the metadata area, for
example just before the BTF ID. No need to fill this in if you are not
redirecting to AF_XDP, but at a redirect to AF_XDP, the XDP flags are
copied into this u32 in the metadata area so that user-space can
consume it. Will cost 4 bytes of the metadata area though.

* Instead encode this information into each metadata entry in the
metadata area, in some way so that a flags field is not needed (-1
signifies not valid, or whatever happens to make sense). This has the
drawback that the user might have to look at a large number of entries
just to find out there is nothing valid to read. To alleviate this, it
could be combined with the next suggestion.

* Dedicate one bit in the options field to indicate that there is at
least one valid metadata entry in the metadata area. This could be
combined with the two approaches above. However, depending on what
metadata you have enabled, this bit might be pointless. If some
metadata is always valid, then it serves no purpose. But it might if
all enabled metadata is rarely valid, e.g., if you get an Rx timestamp
on one packet out of one thousand.

> Signed-off-by: Maryam Tahhan <mtahhan@redhat.com>
> ---
>  include/uapi/linux/if_xdp.h |    2 +-
>  net/xdp/xsk.c               |    2 +-
>  net/xdp/xsk_queue.h         |    3 ++-
>  3 files changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/include/uapi/linux/if_xdp.h b/include/uapi/linux/if_xdp.h
> index a78a8096f4ce..9335b56474e7 100644
> --- a/include/uapi/linux/if_xdp.h
> +++ b/include/uapi/linux/if_xdp.h
> @@ -103,7 +103,7 @@ struct xdp_options {
>  struct xdp_desc {
>         __u64 addr;
>         __u32 len;
> -       __u32 options;
> +       __u32 options; /* set to the values of xdp_hints_flags*/
>  };
>
>  /* UMEM descriptor is __u64 */
> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> index 5b4ce6ba1bc7..32095d78f06b 100644
> --- a/net/xdp/xsk.c
> +++ b/net/xdp/xsk.c
> @@ -141,7 +141,7 @@ static int __xsk_rcv_zc(struct xdp_sock *xs, struct xdp_buff *xdp, u32 len)
>         int err;
>
>         addr = xp_get_handle(xskb);
> -       err = xskq_prod_reserve_desc(xs->rx, addr, len);
> +       err = xskq_prod_reserve_desc(xs->rx, addr, len, xdp->flags);
>         if (err) {
>                 xs->rx_queue_full++;
>                 return err;
> diff --git a/net/xdp/xsk_queue.h b/net/xdp/xsk_queue.h
> index fb20bf7207cf..7a66f082f97e 100644
> --- a/net/xdp/xsk_queue.h
> +++ b/net/xdp/xsk_queue.h
> @@ -368,7 +368,7 @@ static inline u32 xskq_prod_reserve_addr_batch(struct xsk_queue *q, struct xdp_d
>  }
>
>  static inline int xskq_prod_reserve_desc(struct xsk_queue *q,
> -                                        u64 addr, u32 len)
> +                                        u64 addr, u32 len, u32 flags)
>  {
>         struct xdp_rxtx_ring *ring = (struct xdp_rxtx_ring *)q->ring;
>         u32 idx;
> @@ -380,6 +380,7 @@ static inline int xskq_prod_reserve_desc(struct xsk_queue *q,
>         idx = q->cached_prod++ & q->ring_mask;
>         ring->desc[idx].addr = addr;
>         ring->desc[idx].len = len;
> +       ring->desc[idx].options = flags;
>
>         return 0;
>  }
>
>
