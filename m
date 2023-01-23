Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4F59677C70
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 14:28:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231978AbjAWN2z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 08:28:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229989AbjAWN2y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 08:28:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B633B1BAD8;
        Mon, 23 Jan 2023 05:28:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7855EB80DA1;
        Mon, 23 Jan 2023 13:28:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63C60C433D2;
        Mon, 23 Jan 2023 13:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674480531;
        bh=PjQuKVkt8sNW6/8m5TYyVHX44lfq9Wq/dMIGWb7XXys=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jutvxuDZb3rKOTqEiSsnZctYwyQfVrr1fX1KfkPBczrWaI3YCc0QOqc6GXu1Rwu6f
         p54yz3f8grJtbhtXeWofDZrDWGs0KAyHeJv7UzQX7rW9kEkQs7ddBeszq8Msbp0tZt
         i42Fvoba4J38d9NNgePAUuMfOliu52GtpSYGOTqujLZ/7j6Xs6GyAAVQcMXfT4Q7iv
         2PzknCDgl/tP6lAnSCSoJySC6QgCeZrnZdqS66YG+r5BbfLFFen6O6uTgpuvj442Fd
         5wkzRPUBlphKX1g0jJj92rHwxdGKWSCSsScEceTOj58OjkdR7O9GlTfpwAO9Xjzwan
         CUtMaYCOc6Qfg==
Date:   Mon, 23 Jan 2023 15:28:46 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Joe Perches <joe@perches.com>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "coreteam@netfilter.org" <coreteam@netfilter.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lvc-project@linuxtesting.org" <lvc-project@linuxtesting.org>
Subject: Re: [PATCH] netfilter: conntrack: remote a return value of the
 'seq_print_acct' function.
Message-ID: <Y86Lji5prQEAxKLi@unreal>
References: <20230123081957.1380790-1-Ilia.Gavrilov@infotecs.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230123081957.1380790-1-Ilia.Gavrilov@infotecs.ru>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 23, 2023 at 08:19:50AM +0000, Gavrilov Ilia wrote:
> The static 'seq_print_acct' function always returns 0.
> 
> Change the return value to 'void' and remove unnecessary checks.
> 
> Found by InfoTeCS on behalf of Linux Verification Center
> (linuxtesting.org) with SVACE.
> 
> Fixes: 1ca9e41770cb ("netfilter: Remove uses of seq_<foo> return values")
> Signed-off-by: Ilia.Gavrilov <Ilia.Gavrilov@infotecs.ru>
> ---
>  net/netfilter/nf_conntrack_standalone.c | 26 ++++++++++---------------
>  1 file changed, 10 insertions(+), 16 deletions(-)
> 
> diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
> index 0250725e38a4..bee99d4bcf36 100644
> --- a/net/netfilter/nf_conntrack_standalone.c
> +++ b/net/netfilter/nf_conntrack_standalone.c
> @@ -275,22 +275,18 @@ static const char* l4proto_name(u16 proto)
>  	return "unknown";
>  }
>  
> -static unsigned int
> +static void
>  seq_print_acct(struct seq_file *s, const struct nf_conn *ct, int dir)
>  {
> -	struct nf_conn_acct *acct;
> -	struct nf_conn_counter *counter;
> +	struct nf_conn_acct *acct = nf_conn_acct_find(ct);
>  
> -	acct = nf_conn_acct_find(ct);
> -	if (!acct)
> -		return 0;
> -
> -	counter = acct->counter;
> -	seq_printf(s, "packets=%llu bytes=%llu ",
> -		   (unsigned long long)atomic64_read(&counter[dir].packets),
> -		   (unsigned long long)atomic64_read(&counter[dir].bytes));
> +	if (acct) {
> +		struct nf_conn_counter *counter = acct->counter;
>  
> -	return 0;
> +		seq_printf(s, "packets=%llu bytes=%llu ",
> +			   (unsigned long long)atomic64_read(&counter[dir].packets),
> +			   (unsigned long long)atomic64_read(&counter[dir].bytes));
> +	}

The preferred linux kernel style is to perform if (check_error) return;
In this case, this pattern should stay.

acct = nf_conn_acct_find(ct);
if (!acct)
   return;

Thanks
