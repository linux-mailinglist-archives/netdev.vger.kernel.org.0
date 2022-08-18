Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3E4959843D
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 15:34:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243613AbiHRNcR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 09:32:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243887AbiHRNcP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 09:32:15 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C33CA832D3
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 06:32:14 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id q16so1151467ljp.7
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 06:32:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=mm+CIi+eTqS+IJJSFN2zOluKJ3THx8ghvQL/UiT4BIA=;
        b=hycS8Bgar8HWXzk0HRu5TgUPzOSn584mePOMu7IxMkWasKtRbqVuh/LS+bjcY7iQF5
         08BM90sVj27zPXCHC6dMe73ami+RZnm1892KFLWbao/LaCG0OQuWH3OH6Hk2qKPKJAga
         sOSnxI1OGDxFUJpeQX8uKn/6g+BvFL2Redq0sLP0PdMGHfb/VDcD+pyNbDWHo6cedrFL
         ax01skNXYlUVJa6WrriXTvUKkkWQxDtXkVIAPWerpmqpZ1HcPM/z4f0Hljkk/Uw55qIq
         sOUR+88I4P6e0LrZuGtF0Qa/czejFs0USVk4FWXK7QEl+qzOMiGSFSX3C0PcNKIMYaia
         pVRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=mm+CIi+eTqS+IJJSFN2zOluKJ3THx8ghvQL/UiT4BIA=;
        b=VrZ3128CJEc19xag8hYuvk1kQeSRDz5TKPG2h8ipK7s4XI8Pwbu0iVs7nGFuPbAQ5A
         sMylVtAY2FO/C1nr/Ooj9zVvcDEmqFD19UZbNamX6nr3sPr6ycS+qiLymPY6+urQgTdP
         n5VNveQSFnJhxYmJ82/6lGzdINQlu7AcMxyVdxj/utjqScNEitv9ta8IykSThjgKw1au
         0Cg51MQsaxAaprc5KoDuBAEqJcXko57UdAkgORrAVdFrzy4C/t4V5JqrSJHPxbX5uPAV
         ySqHvP8xgycxwLcRlX0QSbQvGiM66ecPdmDgdfhb6t6JyEv/tAhXHSU3XW/MIQNhKlsE
         dQQA==
X-Gm-Message-State: ACgBeo3hkixHCdT4nKk7RFpRq7NBHrdbpnG2DCXNaeANLjeZvrMDSe0U
        n5QzUiQCOwpgNIa9GaS2K/5x
X-Google-Smtp-Source: AA6agR5UaQ2TuK+k7OQHLit1V5LGJEn1wYG32ouP39jCWRH0Zc62Y7v9UqOpETmF8sLSIQ3l+5dFDQ==
X-Received: by 2002:a2e:a551:0:b0:25f:eb63:2588 with SMTP id e17-20020a2ea551000000b0025feb632588mr898325ljn.9.1660829533017;
        Thu, 18 Aug 2022 06:32:13 -0700 (PDT)
Received: from Mem (2a01cb0890e29600d12d396dd3345aed.ipv6.abo.wanadoo.fr. [2a01:cb08:90e2:9600:d12d:396d:d334:5aed])
        by smtp.gmail.com with ESMTPSA id b12-20020a05651c032c00b0025e040510e7sm231087ljp.74.2022.08.18.06.32.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 06:32:12 -0700 (PDT)
Date:   Thu, 18 Aug 2022 15:32:09 +0200
From:   Paul Chaignon <paul@isovalent.com>
To:     Eyal Birger <eyal.birger@gmail.com>, idosch@nvidia.com,
        petrm@nvidia.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, razor@blackwall.org, daniel@iogearbox.net,
        kafai@fb.com
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH bpf] ip_tunnel: respect tunnel key's "flow_flags" in IP
 tunnels
Message-ID: <20220818133209.GA80579@Mem>
References: <20220818074118.726639-1-eyal.birger@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220818074118.726639-1-eyal.birger@gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 18, 2022 at 10:41:18AM +0300, Eyal Birger wrote:
> Commit 451ef36bd229 ("ip_tunnels: Add new flow flags field to ip_tunnel_key")
> added a "flow_flags" member to struct ip_tunnel_key which was later used by
> the commit in the fixes tag to avoid dropping packets with sources that
> aren't locally configured when set in bpf_set_tunnel_key().
> 
> VXLAN and GENEVE were made to respect this flag, ip tunnels like IPIP and GRE
> were not.
> 
> This commit fixes this omission by making ip_tunnel_init_flow() receive
> the flow flags from the tunnel key in the relevant collect_md paths.
> 
> Fixes: b8fff748521c ("bpf: Set flow flag to allow any source IP in bpf_tunnel_key")
> Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
> ---
>  drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c | 3 ++-
>  include/net/ip_tunnels.h                            | 4 +++-
>  net/ipv4/ip_gre.c                                   | 2 +-
>  net/ipv4/ip_tunnel.c                                | 7 ++++---
>  4 files changed, 10 insertions(+), 6 deletions(-)

Thanks for the fix!

Reviewed-by: Paul Chaignon <paul@isovalent.com>

