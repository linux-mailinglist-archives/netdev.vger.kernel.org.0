Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B7C0523DBA
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 21:41:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347197AbiEKTl2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 15:41:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347091AbiEKTkx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 15:40:53 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CA1B2624;
        Wed, 11 May 2022 12:40:47 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id 202so2647546pgc.9;
        Wed, 11 May 2022 12:40:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dPkym92MRzXkOG2DANEgEY8jF++hFd92UjLpouQ6HRo=;
        b=ELOhNhmzQI79EeKD2P3pxVlOXNal8uOWHF6idOc6NJle6dWEMkR3wpDqyidgRHzBda
         zrWe+vC/BFIuSb3BDBBQsHcURfQ1yUw6vT0j/RavE6iCbOtkh7frLTkTFJ/4ldmZE//5
         9edY1mkJB+Whg490YbGA+BlHC8KBjzEJXrkx+MgBzzUd9RgnxDZix7ZJROcbXdbCeNNJ
         RbQt6CHarl4a1TmSZWaLnDzRwjGWcf656mjezstD8HMVY6d7KQfFqcfSGVInKF83sUe/
         xLVoJ7QuMYtK+8SOPSxFxZ4unjs1rkTdgDj16ALFVoGGMfnU4Gz5/YdzLGVVXr2lWgKB
         KbFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dPkym92MRzXkOG2DANEgEY8jF++hFd92UjLpouQ6HRo=;
        b=Qmrvdcu6DwlCsNv9BdcJzwc1H3748on1tqmUryCWpVS2n8qRkYOssqseIM25DAGC4J
         5ErnNQLXnaz9wDVCATEwHnB4dXlmlAhohv1zbYQx/owO6gZntsJzPkurF4f4Vk2amorc
         FZx0ip7oq01eM8LPi0kFzmfKpdkxT0zb0q7SveIXZoWlESM8SJryhJC9rBq6c7t1x32Q
         fV6o3FS5py+2+/x2uJozOS3stHvXy8vxujidl/CZ5TMIVwHsOH9VgWnLms7VbvQgjiNi
         +OjeHKu0WLSE9oWN/722o4dedrlGwxdaTIUjCKeKwnnyWMH6mpSJbEGgLf3KlX/LEpNb
         Cttw==
X-Gm-Message-State: AOAM533FirYTvANdQXK+rXHsiVsedZRZgA7blZ9M6h+iaQsJHInG77A6
        q6I68bv89agmqXtsxg2t8AA=
X-Google-Smtp-Source: ABdhPJzQGLl6yt3isM5vp9paIKLPgl8O5HCZi4v+47KJGreOq+CSAdX1iqOfWQ25rYwGztVX7g8RlQ==
X-Received: by 2002:a62:484:0:b0:50d:a020:88e5 with SMTP id 126-20020a620484000000b0050da02088e5mr26518715pfe.51.1652298047355;
        Wed, 11 May 2022 12:40:47 -0700 (PDT)
Received: from localhost ([112.79.166.171])
        by smtp.gmail.com with ESMTPSA id 32-20020a631560000000b003c14af5060esm260825pgv.38.2022.05.11.12.40.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 May 2022 12:40:47 -0700 (PDT)
Date:   Thu, 12 May 2022 01:11:23 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, pablo@netfilter.org,
        fw@strlen.de, netfilter-devel@vger.kernel.org,
        lorenzo.bianconi@redhat.com, brouer@redhat.com, toke@redhat.com
Subject: Re: [PATCH bpf-next] net: netfilter: add kfunc helper to update ct
 timeout
Message-ID: <20220511194123.g3grzln5cjwtmhb3@apollo.legion>
References: <1327f8f5696ff2bc60400e8f3b79047914ccc837.1651595019.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1327f8f5696ff2bc60400e8f3b79047914ccc837.1651595019.git.lorenzo@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 03, 2022 at 09:59:14PM IST, Lorenzo Bianconi wrote:
> Introduce bpf_ct_refresh_timeout kfunc helper in order to update time
> nf_conn lifetime. Move timeout update logic in nf_ct_refresh_timeout
> utility routine.
>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---

Acked-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>

The sparse error can be ignored, kfunc is meant to be global without a
prototype.

>  include/net/netfilter/nf_conntrack.h |  1 +
>  net/netfilter/nf_conntrack_bpf.c     | 20 ++++++++++++++++++++
>  net/netfilter/nf_conntrack_core.c    | 21 +++++++++++++--------
>  3 files changed, 34 insertions(+), 8 deletions(-)
>
> diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
> index 69e6c6a218be..02b7115b92d0 100644
> --- a/include/net/netfilter/nf_conntrack.h
> +++ b/include/net/netfilter/nf_conntrack.h
> @@ -205,6 +205,7 @@ bool nf_ct_get_tuplepr(const struct sk_buff *skb, unsigned int nhoff,
>  		       u_int16_t l3num, struct net *net,
>  		       struct nf_conntrack_tuple *tuple);
>
> +void nf_ct_refresh_timeout(struct nf_conn *ct, u32 extra_jiffies);
>  void __nf_ct_refresh_acct(struct nf_conn *ct, enum ip_conntrack_info ctinfo,
>  			  const struct sk_buff *skb,
>  			  u32 extra_jiffies, bool do_acct);
> diff --git a/net/netfilter/nf_conntrack_bpf.c b/net/netfilter/nf_conntrack_bpf.c
> index bc4d5cd63a94..d6dcadf0e016 100644
> --- a/net/netfilter/nf_conntrack_bpf.c
> +++ b/net/netfilter/nf_conntrack_bpf.c
> @@ -217,16 +217,36 @@ void bpf_ct_release(struct nf_conn *nfct)
>  	nf_ct_put(nfct);
>  }
>
> +/* bpf_ct_refresh_timeout - Refresh nf_conn object
> + *
> + * Refresh timeout associated to the provided connection tracking entry.
> + * This must be invoked for referenced PTR_TO_BTF_ID.
> + *
> + * Parameters:
> + * @nf_conn      - Pointer to referenced nf_conn object, obtained using
> + *		   bpf_xdp_ct_lookup or bpf_skb_ct_lookup.
> + * @timeout      - delta time in msecs used to increase the ct entry lifetime.
> + */
> +void bpf_ct_refresh_timeout(struct nf_conn *nfct, u32 timeout)
> +{
> +	if (!nfct)
> +		return;
> +
> +	nf_ct_refresh_timeout(nfct, msecs_to_jiffies(timeout));
> +}
> +
>  __diag_pop()
>
>  BTF_SET_START(nf_ct_xdp_check_kfunc_ids)
>  BTF_ID(func, bpf_xdp_ct_lookup)
>  BTF_ID(func, bpf_ct_release)
> +BTF_ID(func, bpf_ct_refresh_timeout);
>  BTF_SET_END(nf_ct_xdp_check_kfunc_ids)
>
>  BTF_SET_START(nf_ct_tc_check_kfunc_ids)
>  BTF_ID(func, bpf_skb_ct_lookup)
>  BTF_ID(func, bpf_ct_release)
> +BTF_ID(func, bpf_ct_refresh_timeout);
>  BTF_SET_END(nf_ct_tc_check_kfunc_ids)
>
>  BTF_SET_START(nf_ct_acquire_kfunc_ids)
> diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
> index 0164e5f522e8..f43e743728bd 100644
> --- a/net/netfilter/nf_conntrack_core.c
> +++ b/net/netfilter/nf_conntrack_core.c
> @@ -2030,16 +2030,11 @@ void nf_conntrack_alter_reply(struct nf_conn *ct,
>  }
>  EXPORT_SYMBOL_GPL(nf_conntrack_alter_reply);
>
> -/* Refresh conntrack for this many jiffies and do accounting if do_acct is 1 */
> -void __nf_ct_refresh_acct(struct nf_conn *ct,
> -			  enum ip_conntrack_info ctinfo,
> -			  const struct sk_buff *skb,
> -			  u32 extra_jiffies,
> -			  bool do_acct)
> +void nf_ct_refresh_timeout(struct nf_conn *ct, u32 extra_jiffies)
>  {
>  	/* Only update if this is not a fixed timeout */
>  	if (test_bit(IPS_FIXED_TIMEOUT_BIT, &ct->status))
> -		goto acct;
> +		return;
>
>  	/* If not in hash table, timer will not be active yet */
>  	if (nf_ct_is_confirmed(ct))
> @@ -2047,7 +2042,17 @@ void __nf_ct_refresh_acct(struct nf_conn *ct,
>
>  	if (READ_ONCE(ct->timeout) != extra_jiffies)
>  		WRITE_ONCE(ct->timeout, extra_jiffies);
> -acct:
> +}
> +
> +/* Refresh conntrack for this many jiffies and do accounting if do_acct is 1 */
> +void __nf_ct_refresh_acct(struct nf_conn *ct,
> +			  enum ip_conntrack_info ctinfo,
> +			  const struct sk_buff *skb,
> +			  u32 extra_jiffies,
> +			  bool do_acct)
> +{
> +	nf_ct_refresh_timeout(ct, extra_jiffies);
> +
>  	if (do_acct)
>  		nf_ct_acct_update(ct, CTINFO2DIR(ctinfo), skb->len);
>  }
> --
> 2.35.1
>

--
Kartikeya
