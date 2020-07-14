Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A079A21F438
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 16:37:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728243AbgGNOhe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 10:37:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725890AbgGNOhd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 10:37:33 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3514C061755
        for <netdev@vger.kernel.org>; Tue, 14 Jul 2020 07:37:32 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id e8so23061355ljb.0
        for <netdev@vger.kernel.org>; Tue, 14 Jul 2020 07:37:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lK9a1yh/EhE3qkm1elmL6lwF7ziT/zqKmAG/PHA6ZOA=;
        b=Z3NSvmGi1zKUsvgeygynh+ITklJceB1KEnpIldaqI5MEUZy2m/tQgDrFqcbvYfh63r
         j0VcE1IcdAM6R/CBN1UvvaAk6ARqymw753YL/papmNPPisKpDn86xp0k1KyaKLQ8f4V/
         PEUDjxMF7d7mAuadqlHJjVMniI6vB1hQKh26CHWGzRmuLOh8Oy64AM5AgRaPXcaGKvxL
         p9ZRzaowPofuPENecCZDZLN0Tyd75Y2MVb/LLI2VRQtyH60caW51NTdVEWHI6Nxdio1w
         su/OWOJQzUw5OgjUHHHrvMgRg8z19M5VCXPMBfHCAp8Jz+fwZT7vZX7SGozCDimJJ8DJ
         G5yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lK9a1yh/EhE3qkm1elmL6lwF7ziT/zqKmAG/PHA6ZOA=;
        b=uobR6jjvhaLhN8Njaw/lhzqVfYfTY9/oD29tfILkULzVW/yTmIxMhDoQzHUscfCgeN
         yYH2GtTxs6eEXDmSsVUyd7G2BBYBxnX4hfdJtyp2JHvK0BBmuaj6IwKnV5yIKqwv5ImN
         T6Hs5jtLTPvBvP+pipIiRSZNa7vor9QHHYx63MwcBZignI14OB9rMqysWicnXn29qzQy
         OrHtNBG2USCM+80rUFWWqcEqxPZ7H08cupN4OAk4/KHlPzvY+UCIELjn1lZBKambFYp0
         gra+f+BThBeV32DT1OvLuGq9POFLbRxu8ET2JtwLxSfsUolvegsmVjvvAFrDNBPz42OP
         NvZw==
X-Gm-Message-State: AOAM5324lPngv3RkacIeuYsa/eLVicrtlC5mbj6zt+BiilDNn5ftXsyU
        FTZG9hI1/4HK+IL2fqQg/uj+jx8G7ZapJhlpiCfmrA==
X-Google-Smtp-Source: ABdhPJzX5dpcaBKDxEYLl0vrwhi8F7+YdV8dkC4BCrbt7sSJP+LG5g2U5WSp4XIU7quRW1BEQAv2maCKFgN7vcoO7KY=
X-Received: by 2002:a2e:9857:: with SMTP id e23mr2609366ljj.411.1594737451191;
 Tue, 14 Jul 2020 07:37:31 -0700 (PDT)
MIME-Version: 1.0
References: <2fa6dda741a8a315405989bf3276d9158f4d92e2.1594036709.git.lucien.xin@gmail.com>
 <e852e03656d09a9e469c3fe9c04af25a0551075c.1594036709.git.lucien.xin@gmail.com>
 <2a8edf158432201b796f13ccc2e80f2fcafbb8d8.1594036709.git.lucien.xin@gmail.com>
 <b588daa77c6304119b8578d31d3e29fbc8959178.1594036709.git.lucien.xin@gmail.com>
 <cover.1594036709.git.lucien.xin@gmail.com> <97bd8d867973d769486f5a9b98fe6e13ba3fa821.1594036709.git.lucien.xin@gmail.com>
 <a0c059b3690e690248cbbe1130e160b96b30d989.1594036709.git.lucien.xin@gmail.com>
In-Reply-To: <a0c059b3690e690248cbbe1130e160b96b30d989.1594036709.git.lucien.xin@gmail.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 14 Jul 2020 20:07:19 +0530
Message-ID: <CA+G9fYv1Zx7ptDDs-WAeJ_rhsUX6ZJ1Kx2Nk=BUt_hjKiKhC+A@mail.gmail.com>
Subject: Re: [PATCHv3 ipsec-next 06/10] ip6_vti: support IP6IP6 tunnel
 processing with .cb_handler
To:     Xin Long <lucien.xin@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        kbuild test robot <lkp@intel.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sabrina Dubroca <sd@queasysnail.net>,
        lkft-triage@lists.linaro.org,
        Linux-Next Mailing List <linux-next@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 6 Jul 2020 at 17:32, Xin Long <lucien.xin@gmail.com> wrote:
>
> Similar to IPIP tunnel's processing, this patch is to support
> IP6IP6 tunnel processing with .cb_handler.
>
> v1->v2:
>   - no change.
> v2-v3:
>   - enable it only when CONFIG_INET6_XFRM_TUNNEL is defined, to fix
>     the build error, reported by kbuild test robot.
>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  net/ipv6/ip6_vti.c | 33 +++++++++++++++++++++++++++++++++
>  1 file changed, 33 insertions(+)
>
> diff --git a/net/ipv6/ip6_vti.c b/net/ipv6/ip6_vti.c
> index 1147f64..39efe41 100644
> --- a/net/ipv6/ip6_vti.c
> +++ b/net/ipv6/ip6_vti.c
> @@ -1218,6 +1218,26 @@ static struct xfrm6_protocol vti_ipcomp6_protocol __read_mostly = {
>         .priority       =       100,
>  };
>
> +#if IS_ENABLED(CONFIG_INET6_XFRM_TUNNEL)
> +static int vti6_rcv_tunnel(struct sk_buff *skb)
> +{
> +       const xfrm_address_t *saddr;
> +       __be32 spi;
> +
> +       saddr = (const xfrm_address_t *)&ipv6_hdr(skb)->saddr;
> +       spi = xfrm6_tunnel_spi_lookup(dev_net(skb->dev), saddr);

arm build failed due this error on linux-next 20200713 and  20200713
15:51:27 | net/ipv6/ip6_vti.o: In function `vti6_rcv_tunnel':
15:51:27 | ip6_vti.c:(.text+0x1d20): undefined reference to
`xfrm6_tunnel_spi_lookup'

ref:
https://ci.linaro.org/view/lkft/job/openembedded-lkft-linux-next/DISTRO=lkft,MACHINE=am57xx-evm,label=docker-lkft/812/consoleText

config link,
http://snapshots.linaro.org/openembedded/lkft/lkft/sumo/am57xx-evm/lkft/linux-next/811/config

-- 
Linaro LKFT
https://lkft.linaro.org
