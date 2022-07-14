Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 021F95741F6
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 05:37:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233081AbiGNDhw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 23:37:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233065AbiGNDhv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 23:37:51 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE157EE28
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 20:37:49 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id 70so748796pfx.1
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 20:37:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lvv+2TNZ0UDHHJtA78+IPj1aaCqqH2RNt69XAZ3FeMQ=;
        b=kGmHh59tEq+2m/EXFCaTXBuhec54r+LXVmBhv6huC9hibsPHvJJj1ys+qrE6Q+QlQB
         DI+v8T/0C8b7exf9ujwi1xbkMLl9p7N1O5hrIZPIougaTEF8SPcDJJsowVGMzT2k/VKv
         gugnlaGDXN3zCL1vGMPLCtpsB3dD/4KuIqLcg5BwnkVhqmliDQ44sbdgaIe741XIyZav
         jcPYFO9cGu0bm80KPz9p4b0TIxZIyDVfVXc6+dkpNBMBLYhLK+6YwsXdLlP41e82M9vq
         sZ2e6CjUFE21Wi9/8r83RaofWIL6rhx1sJe31XDvEWFzOxRqXnoa/WCWWcHVeWS8tzUP
         vxwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lvv+2TNZ0UDHHJtA78+IPj1aaCqqH2RNt69XAZ3FeMQ=;
        b=XS1a165jAAFgXOV7XWVYX9dW7taun02fZEOFiL4Jq9Mi6nXybO9D3OOzf0QVqPthEZ
         DkvAWqiK8EISCpqKscAq4pkWPTxob4eOGOMIb7jcbXTYe5GfKn/jmtN34aSh1Jo+T7zz
         CCefH09FdPOUjDtJlBf4uIBM6stNovg4d1eJ6+rOkShDMiiV6e2Koi/IS4i+yjPGjVlt
         nYsh2m60Z0HZKPPtO4H3lH2NQi04ZyztIdNnKAv55dczgH35CS+6LwO4DEkfCsIDjmHK
         2ZSi5PmzG21IsYxho3jkq7GGT+aCQpsRUvBDtcwUxZvHb3ReU0KvQJBeVG1ve07Z8Dfv
         ibaA==
X-Gm-Message-State: AJIora9ebqq/83K6gHBxbLZUF3z3YveEmX7JoJnGEJKPtgICkNixH6P+
        pvLUDQP1X18By0reLz5CVfBnPxC6LaBE5YhE1Gv8sw==
X-Google-Smtp-Source: AGRyM1t2WNX3fdg8RDVN4sXgU8o9Eo5obTLhkOP7m80mDOjsuCxh8E/oGcw8TMyRHeHrzjaR3mcwAC6vdTYNNiVwhGk=
X-Received: by 2002:a62:6d05:0:b0:528:99a2:b10 with SMTP id
 i5-20020a626d05000000b0052899a20b10mr6311821pfc.72.1657769869020; Wed, 13 Jul
 2022 20:37:49 -0700 (PDT)
MIME-Version: 1.0
References: <20220714015647.25074-1-xiaolinkui@kylinos.cn>
In-Reply-To: <20220714015647.25074-1-xiaolinkui@kylinos.cn>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Wed, 13 Jul 2022 20:37:37 -0700
Message-ID: <CAKH8qBuj=7HXF2xTRWqso9o56t5Tpg68C+r5PnHVnEyu129UmA@mail.gmail.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: Return true/false (not 1/0) from
 bool functions
To:     xiaolinkui <xiaolinkui@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, john.fastabend@gmail.com,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        yhs@fb.com, kpsingh@kernel.org, haoluo@google.com,
        jolsa@kernel.org, mykolal@fb.com, shuah@kernel.org,
        nathan@kernel.org, ndesaulniers@google.com, trix@redhat.com,
        xiaolinkui@kylinos.cn, netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 13, 2022 at 6:57 PM xiaolinkui <xiaolinkui@gmail.com> wrote:
>
> From: Linkui Xiao <xiaolinkui@kylinos.cn>
>
> Return boolean values ("true" or "false") instead of 1 or 0 from bool
> functions.  This fixes the following warnings from coccicheck:
>
> tools/testing/selftests/bpf/progs/test_xdp_noinline.c:407:9-10: WARNING:
> return of 0/1 in function 'decap_v4' with return type bool
> tools/testing/selftests/bpf/progs/test_xdp_noinline.c:389:9-10: WARNING:
> return of 0/1 in function 'decap_v6' with return type bool
> tools/testing/selftests/bpf/progs/test_xdp_noinline.c:290:9-10: WARNING:
> return of 0/1 in function 'encap_v6' with return type bool
> tools/testing/selftests/bpf/progs/test_xdp_noinline.c:264:9-10: WARNING:
> return of 0/1 in function 'parse_tcp' with return type bool
> tools/testing/selftests/bpf/progs/test_xdp_noinline.c:242:9-10: WARNING:
> return of 0/1 in function 'parse_udp' with return type bool
>
> Generated by: scripts/coccinelle/misc/boolreturn.cocci
>
> Signed-off-by: Linkui Xiao <xiaolinkui@kylinos.cn>
Reviewed-by: Stanislav Fomichev <sdf@google.com>

> Suggested-by: Stanislav Fomichev <sdf@google.com>
That shouldn't be here :-) I didn't suggest the patch, you're
suggesting it, I'm just suggesting to properly format it.
Probably not worth a respin, I hope whoever gets to apply it can drop
that line (or maybe keep it, I don't mind).

> ---
>  .../selftests/bpf/progs/test_xdp_noinline.c   | 30 +++++++++----------
>  1 file changed, 15 insertions(+), 15 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/progs/test_xdp_noinline.c b/tools/testing/selftests/bpf/progs/test_xdp_noinline.c
> index 125d872d7981..ba48fcb98ab2 100644
> --- a/tools/testing/selftests/bpf/progs/test_xdp_noinline.c
> +++ b/tools/testing/selftests/bpf/progs/test_xdp_noinline.c
> @@ -239,7 +239,7 @@ bool parse_udp(void *data, void *data_end,
>         udp = data + off;
>
>         if (udp + 1 > data_end)
> -               return 0;
> +               return false;
>         if (!is_icmp) {
>                 pckt->flow.port16[0] = udp->source;
>                 pckt->flow.port16[1] = udp->dest;
> @@ -247,7 +247,7 @@ bool parse_udp(void *data, void *data_end,
>                 pckt->flow.port16[0] = udp->dest;
>                 pckt->flow.port16[1] = udp->source;
>         }
> -       return 1;
> +       return true;
>  }
>
>  static __attribute__ ((noinline))
> @@ -261,7 +261,7 @@ bool parse_tcp(void *data, void *data_end,
>
>         tcp = data + off;
>         if (tcp + 1 > data_end)
> -               return 0;
> +               return false;
>         if (tcp->syn)
>                 pckt->flags |= (1 << 1);
>         if (!is_icmp) {
> @@ -271,7 +271,7 @@ bool parse_tcp(void *data, void *data_end,
>                 pckt->flow.port16[0] = tcp->dest;
>                 pckt->flow.port16[1] = tcp->source;
>         }
> -       return 1;
> +       return true;
>  }
>
>  static __attribute__ ((noinline))
> @@ -287,7 +287,7 @@ bool encap_v6(struct xdp_md *xdp, struct ctl_value *cval,
>         void *data;
>
>         if (bpf_xdp_adjust_head(xdp, 0 - (int)sizeof(struct ipv6hdr)))
> -               return 0;
> +               return false;
>         data = (void *)(long)xdp->data;
>         data_end = (void *)(long)xdp->data_end;
>         new_eth = data;
> @@ -295,7 +295,7 @@ bool encap_v6(struct xdp_md *xdp, struct ctl_value *cval,
>         old_eth = data + sizeof(struct ipv6hdr);
>         if (new_eth + 1 > data_end ||
>             old_eth + 1 > data_end || ip6h + 1 > data_end)
> -               return 0;
> +               return false;
>         memcpy(new_eth->eth_dest, cval->mac, 6);
>         memcpy(new_eth->eth_source, old_eth->eth_dest, 6);
>         new_eth->eth_proto = 56710;
> @@ -314,7 +314,7 @@ bool encap_v6(struct xdp_md *xdp, struct ctl_value *cval,
>         ip6h->saddr.in6_u.u6_addr32[2] = 3;
>         ip6h->saddr.in6_u.u6_addr32[3] = ip_suffix;
>         memcpy(ip6h->daddr.in6_u.u6_addr32, dst->dstv6, 16);
> -       return 1;
> +       return true;
>  }
>
>  static __attribute__ ((noinline))
> @@ -335,7 +335,7 @@ bool encap_v4(struct xdp_md *xdp, struct ctl_value *cval,
>         ip_suffix <<= 15;
>         ip_suffix ^= pckt->flow.src;
>         if (bpf_xdp_adjust_head(xdp, 0 - (int)sizeof(struct iphdr)))
> -               return 0;
> +               return false;
>         data = (void *)(long)xdp->data;
>         data_end = (void *)(long)xdp->data_end;
>         new_eth = data;
> @@ -343,7 +343,7 @@ bool encap_v4(struct xdp_md *xdp, struct ctl_value *cval,
>         old_eth = data + sizeof(struct iphdr);
>         if (new_eth + 1 > data_end ||
>             old_eth + 1 > data_end || iph + 1 > data_end)
> -               return 0;
> +               return false;
>         memcpy(new_eth->eth_dest, cval->mac, 6);
>         memcpy(new_eth->eth_source, old_eth->eth_dest, 6);
>         new_eth->eth_proto = 8;
> @@ -367,8 +367,8 @@ bool encap_v4(struct xdp_md *xdp, struct ctl_value *cval,
>                 csum += *next_iph_u16++;
>         iph->check = ~((csum & 0xffff) + (csum >> 16));
>         if (bpf_xdp_adjust_head(xdp, (int)sizeof(struct iphdr)))
> -               return 0;
> -       return 1;
> +               return false;
> +       return true;
>  }
>
>  static __attribute__ ((noinline))
> @@ -386,10 +386,10 @@ bool decap_v6(struct xdp_md *xdp, void **data, void **data_end, bool inner_v4)
>         else
>                 new_eth->eth_proto = 56710;
>         if (bpf_xdp_adjust_head(xdp, (int)sizeof(struct ipv6hdr)))
> -               return 0;
> +               return false;
>         *data = (void *)(long)xdp->data;
>         *data_end = (void *)(long)xdp->data_end;
> -       return 1;
> +       return true;
>  }
>
>  static __attribute__ ((noinline))
> @@ -404,10 +404,10 @@ bool decap_v4(struct xdp_md *xdp, void **data, void **data_end)
>         memcpy(new_eth->eth_dest, old_eth->eth_dest, 6);
>         new_eth->eth_proto = 8;
>         if (bpf_xdp_adjust_head(xdp, (int)sizeof(struct iphdr)))
> -               return 0;
> +               return false;
>         *data = (void *)(long)xdp->data;
>         *data_end = (void *)(long)xdp->data_end;
> -       return 1;
> +       return true;
>  }
>
>  static __attribute__ ((noinline))
> --
> 2.17.1
>
