Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 700FC506630
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 09:45:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349549AbiDSHsH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 03:48:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243210AbiDSHsB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 03:48:01 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8262D25E9A;
        Tue, 19 Apr 2022 00:45:18 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id b19so21202605wrh.11;
        Tue, 19 Apr 2022 00:45:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=LIDXo/Uity2xr0NOefpQVn0crCBfVXuQDDJyi/aflIk=;
        b=P1T979CbMsI2SUmYhQenmVVAIhGym62LpiPwyhu9mqZxFcDQfYblpBVJSI318EvEkU
         8qraQoEDiW07OJeqNLpO1y4LicWptHus+FDeTQ+ri0fKDi0Gd3qjTzchzJWw1eV3J2P/
         ur+/YV9SpThD14a+M4Xmx2nBHefr2HCF9i0g9r/v0YFck8Sp1dDQHrhoCRX/D8LLD+nv
         hSbMh/wtA7UytVfbYUIxc8Vd3UCJhC0dZWi5dnl6xtPjbpaBDhqNaROJjuoWcG/xdpM/
         cfT1g6fLQGRIHJeLkDOGbTqf4WV/fdLr/5gECYLOYf83BQnlZ2tdaiA8le5fVPy13rCW
         ro6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=LIDXo/Uity2xr0NOefpQVn0crCBfVXuQDDJyi/aflIk=;
        b=sH63uNP/BKEVHY0KYgRsdMm7i+ZGXehZEyFlLQvTalOM5d/aVVKjAtHF4klj7Z+YJJ
         +Sj+xCvzQkOaPeLP68RvnUnXIFjhFriP0yTO27SZkMayje4zXFtEy7wmQPZOO3GvYKyi
         alSOLcY3q4KF18z7psZUAl0T/jjFU90ALhiNTF519MOxycAFLlJoyPT3XbiSjI1ZfmJR
         /KgbSH7ifFg8RidH90WpniRvKkByoN0F+rBFmbFswB8cMTps7YrBvdzZdfvagFsHnf/1
         f8nse9JmxsMb7sWuaUvYIYMndZ1j0ex2otu+bJJJCw9yNpcrYXXiS8xsUFmo+o9cq01S
         xT7w==
X-Gm-Message-State: AOAM533eE2rhI49jObnixFUOsvTGzDpcQZU9EACFEPlZ/FyLtGGkL658
        HIqeEjPo983LGa6iF6xVvGE=
X-Google-Smtp-Source: ABdhPJzezuCr1A2N5D3o9C3Ys+bbuuIe1wYYoQKgg7RlsTX7w5PNcndV/T40ockclreuq/ypyy6ZLw==
X-Received: by 2002:adf:e2cc:0:b0:203:e8ba:c709 with SMTP id d12-20020adfe2cc000000b00203e8bac709mr10556484wrj.713.1650354316985;
        Tue, 19 Apr 2022 00:45:16 -0700 (PDT)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id h10-20020a05600c414a00b0038ebb6884d8sm22941157wmm.0.2022.04.19.00.45.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 19 Apr 2022 00:45:16 -0700 (PDT)
Date:   Tue, 19 Apr 2022 08:45:13 +0100
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     Jakob Koschel <jakobkoschel@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com, Ariel Elior <aelior@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Casper Andersson <casper.casan@gmail.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Arnd Bergmann <arnd@arndb.de>,
        Colin Ian King <colin.king@intel.com>,
        Eric Dumazet <edumazet@google.com>,
        Xu Wang <vulab@iscas.ac.cn>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, bpf@vger.kernel.org,
        Mike Rapoport <rppt@kernel.org>,
        Brian Johannesmeyer <bjohannesmeyer@gmail.com>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "Bos, H.J." <h.j.bos@vu.nl>
Subject: Re: [PATCH net-next v4 14/18] sfc: Remove usage of list iterator for
 list_add() after the loop body
Message-ID: <20220419074513.bgqmi3c5ydogpytj@gmail.com>
Mail-Followup-To: Jakob Koschel <jakobkoschel@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com, Ariel Elior <aelior@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Jiri Pirko <jiri@resnulli.us>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Casper Andersson <casper.casan@gmail.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Arnd Bergmann <arnd@arndb.de>,
        Colin Ian King <colin.king@intel.com>,
        Eric Dumazet <edumazet@google.com>, Xu Wang <vulab@iscas.ac.cn>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
        bpf@vger.kernel.org, Mike Rapoport <rppt@kernel.org>,
        Brian Johannesmeyer <bjohannesmeyer@gmail.com>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "Bos, H.J." <h.j.bos@vu.nl>
References: <20220415122947.2754662-1-jakobkoschel@gmail.com>
 <20220415122947.2754662-15-jakobkoschel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220415122947.2754662-15-jakobkoschel@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 15, 2022 at 02:29:43PM +0200, Jakob Koschel wrote:
> In preparation to limit the scope of a list iterator to the list
> traversal loop, use a dedicated pointer pointing to the location
> where the element should be inserted [1].
> 
> Before, the code implicitly used the head when no element was found
> when using &new->list. The new 'pos' variable is set to the list head
> by default and overwritten if the list exits early, marking the
> insertion point for list_add().
> 
> Link: https://lore.kernel.org/all/CAHk-=wgRr_D8CB-D9Kg-c=EHreAsk5SqXPwr9Y7k9sA6cWXJ6w@mail.gmail.com/ [1]
> Signed-off-by: Jakob Koschel <jakobkoschel@gmail.com>
> ---
>  drivers/net/ethernet/sfc/rx_common.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/sfc/rx_common.c b/drivers/net/ethernet/sfc/rx_common.c
> index 1b22c7be0088..716847ba7038 100644
> --- a/drivers/net/ethernet/sfc/rx_common.c
> +++ b/drivers/net/ethernet/sfc/rx_common.c
> @@ -556,6 +556,7 @@ efx_rx_packet_gro(struct efx_channel *channel, struct efx_rx_buffer *rx_buf,
>  struct efx_rss_context *efx_alloc_rss_context_entry(struct efx_nic *efx)
>  {
>  	struct list_head *head = &efx->rss_context.list;
> +	struct list_head *pos = head;

This violates the reverse Xmas list policy. This definition should be
1 line further down.

Martin

>  	struct efx_rss_context *ctx, *new;
>  	u32 id = 1; /* Don't use zero, that refers to the master RSS context */
>  
> @@ -563,8 +564,10 @@ struct efx_rss_context *efx_alloc_rss_context_entry(struct efx_nic *efx)
>  
>  	/* Search for first gap in the numbering */
>  	list_for_each_entry(ctx, head, list) {
> -		if (ctx->user_id != id)
> +		if (ctx->user_id != id) {
> +			pos = &ctx->list;
>  			break;
> +		}
>  		id++;
>  		/* Check for wrap.  If this happens, we have nearly 2^32
>  		 * allocated RSS contexts, which seems unlikely.
> @@ -582,7 +585,7 @@ struct efx_rss_context *efx_alloc_rss_context_entry(struct efx_nic *efx)
>  
>  	/* Insert the new entry into the gap */
>  	new->user_id = id;
> -	list_add_tail(&new->list, &ctx->list);
> +	list_add_tail(&new->list, pos);
>  	return new;
>  }
>  
> -- 
> 2.25.1
