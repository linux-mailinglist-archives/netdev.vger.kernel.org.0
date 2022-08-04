Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4336C589580
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 02:54:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238824AbiHDAx7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 20:53:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229686AbiHDAx6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 20:53:58 -0400
Received: from smtp.uniroma2.it (smtp.uniroma2.it [160.80.6.16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A80C5D0D5;
        Wed,  3 Aug 2022 17:53:54 -0700 (PDT)
Received: from smtpauth-2019-1.uniroma2.it (smtpauth.uniroma2.it [160.80.5.46])
        by smtp-2015.uniroma2.it (8.14.4/8.14.4/Debian-8) with ESMTP id 2740qnit002637;
        Thu, 4 Aug 2022 02:52:54 +0200
Received: from lubuntu-18.04 (unknown [160.80.103.126])
        by smtpauth-2019-1.uniroma2.it (Postfix) with ESMTPSA id 5281012005F;
        Thu,  4 Aug 2022 02:52:45 +0200 (CEST)
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=uniroma2.it;
        s=ed201904; t=1659574365; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QQXxUxRYonN3DnTiqF9rDc5G08qopkQ454FbGxazTn8=;
        b=eBd9tjgWPS47PoKCiFZSzaNK767mmz5G9RA/ssJ824Ah4AWK+oNWVvO/sfIrVbcyq73mmL
        sPCufU/U3o2tmYCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniroma2.it; s=rsa201904;
        t=1659574365; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QQXxUxRYonN3DnTiqF9rDc5G08qopkQ454FbGxazTn8=;
        b=xkfmBoQxpkrVzn6MaBclUIglloslqaqLIL8e+cBI2wQmVE4fRgnz55APYNthrW6vSzwqFY
        +yOgFFOUw3QL+FZ639FGzNoCSjk4PhHIiHr6bb+CExcx8p2rQfmZEZYJxpbidGptRgSNpf
        FR38WkW+RXVRzUXgryeI4A46R/uNtlUz9EjsTZOFLxlK/wuOXaOMN2TPoijobGZR2Bh18f
        CAic4eVD1khhT5IHkQFUsK8KQo8xk/NNJPGQQPqA4FGpkm4Rs5oBdHpp1khna8yygbUImG
        GcZz5+eLWcumGK6D3jYDqEwKj3Ho3DfpjzjCO3nytZYyu4MN9xbkGjIZff9ebg==
Date:   Thu, 4 Aug 2022 02:52:45 +0200
From:   Andrea Mayer <andrea.mayer@uniroma2.it>
To:     Nick Desaulniers <ndesaulniers@google.com>,
        David Ahern <dsahern@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Tom Rix <trix@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
        Andrea Mayer <andrea.mayer@uniroma2.it>
Subject: Re: [PATCH] net: seg6: initialize induction variable to first valid
 array index
Message-Id: <20220804025245.b61ebbfd313a49927aa61f9a@uniroma2.it>
In-Reply-To: <9e8728e0-75e7-d3a8-038b-48e51be4df07@kernel.org>
References: <20220802161203.622293-1-ndesaulniers@google.com>
        <9e8728e0-75e7-d3a8-038b-48e51be4df07@kernel.org>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.100.0 at smtp-2015
X-Virus-Status: Clean
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Nick,
please see below, thanks.

> [ cc Andrea ]
@David Ahern: thanks David!

> On 8/2/22 10:12 AM, Nick Desaulniers wrote:
> > Fixes the following warnings observed when building
> > CONFIG_IPV6_SEG6_LWTUNNEL=y with clang:
> > 
> >   net/ipv6/seg6_local.o: warning: objtool: seg6_local_fill_encap() falls
> >   through to next function seg6_local_get_encap_size()
> >   net/ipv6/seg6_local.o: warning: objtool: seg6_local_cmp_encap() falls
> >   through to next function input_action_end()
> > 
> > LLVM can fully unroll loops in seg6_local_get_encap_size() and
> > seg6_local_cmp_encap(). One issue in those loops is that the induction
> > variable is initialized to 0. The loop iterates over members of
> > seg6_action_params, a global array of struct seg6_action_param calling
> > their put() function pointer members.  seg6_action_param uses an array
> > initializer to initialize SEG6_LOCAL_SRH and later elements, which is
> > the third enumeration of an anonymous union.
> > 
> > The guard `if (attrs & SEG6_F_ATTR(i))` may prevent this from being
> > called at runtime, but it would still be UB for
> > `seg6_action_params[0]->put` to be called; the unrolled loop will make
> > the initial iterations unreachable, which LLVM will later rotate to
> > fallthrough to the next function.
> > 
> > Make this more obvious that this cannot happen to the compiler by
> > initializing the loop induction variable to the minimum valid index that
> > seg6_action_params is initialized to.

By looking at the patch, it looks that your changes seem reasonable.
The first two SEG6_LOCAL_{UNSPEC,ACTION} attributes are quite "special" in the
sense that they do not have the seg6_action_param callbacks set.
The SEG6_LOCAL_UNSPEC attribute is practically not used; while
SEG6_LOCAL_ACTION is handled out of the several loops.

Hence, I think we can skip these two attributes (in the loops) by setting the
induction variable to the value you proposed, i.e. SEG6_LOCAL_SRH.

Ciao,
Andrea

> > 
> > Reported-by: Thomas Gleixner <tglx@linutronix.de>
> > Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
> > ---
> >  net/ipv6/seg6_local.c | 10 +++++-----
> >  1 file changed, 5 insertions(+), 5 deletions(-)
> > 
> > diff --git a/net/ipv6/seg6_local.c b/net/ipv6/seg6_local.c
> > index 2cd4a8d3b30a..b7de5e46fdd8 100644
> > --- a/net/ipv6/seg6_local.c
> > +++ b/net/ipv6/seg6_local.c
> > @@ -1614,7 +1614,7 @@ static void __destroy_attrs(unsigned long parsed_attrs, int max_parsed,
> >  	 * callback. If the callback is not available, then we skip to the next
> >  	 * attribute; otherwise, we call the destroy() callback.
> >  	 */
> > -	for (i = 0; i < max_parsed; ++i) {
> > +	for (i = SEG6_LOCAL_SRH; i < max_parsed; ++i) {
> >  		if (!(parsed_attrs & SEG6_F_ATTR(i)))
> >  			continue;
> >  
> > @@ -1643,7 +1643,7 @@ static int parse_nla_optional_attrs(struct nlattr **attrs,
> >  	struct seg6_action_param *param;
> >  	int err, i;
> >  
> > -	for (i = 0; i < SEG6_LOCAL_MAX + 1; ++i) {
> > +	for (i = SEG6_LOCAL_SRH; i < SEG6_LOCAL_MAX + 1; ++i) {
> >  		if (!(desc->optattrs & SEG6_F_ATTR(i)) || !attrs[i])
> >  			continue;
> >  
> > @@ -1742,7 +1742,7 @@ static int parse_nla_action(struct nlattr **attrs, struct seg6_local_lwt *slwt)
> >  	}
> >  
> >  	/* parse the required attributes */
> > -	for (i = 0; i < SEG6_LOCAL_MAX + 1; i++) {
> > +	for (i = SEG6_LOCAL_SRH; i < SEG6_LOCAL_MAX + 1; i++) {
> >  		if (desc->attrs & SEG6_F_ATTR(i)) {
> >  			if (!attrs[i])
> >  				return -EINVAL;
> > @@ -1847,7 +1847,7 @@ static int seg6_local_fill_encap(struct sk_buff *skb,
> >  
> >  	attrs = slwt->desc->attrs | slwt->parsed_optattrs;
> >  
> > -	for (i = 0; i < SEG6_LOCAL_MAX + 1; i++) {
> > +	for (i = SEG6_LOCAL_SRH; i < SEG6_LOCAL_MAX + 1; i++) {
> >  		if (attrs & SEG6_F_ATTR(i)) {
> >  			param = &seg6_action_params[i];
> >  			err = param->put(skb, slwt);
> > @@ -1927,7 +1927,7 @@ static int seg6_local_cmp_encap(struct lwtunnel_state *a,
> >  	if (attrs_a != attrs_b)
> >  		return 1;
> >  
> > -	for (i = 0; i < SEG6_LOCAL_MAX + 1; i++) {
> > +	for (i = SEG6_LOCAL_SRH; i < SEG6_LOCAL_MAX + 1; i++) {
> >  		if (attrs_a & SEG6_F_ATTR(i)) {
> >  			param = &seg6_action_params[i];
> >  			if (param->cmp(slwt_a, slwt_b))
>
