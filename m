Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D00768FFE8
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 06:34:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbjBIFe0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 00:34:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbjBIFeZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 00:34:25 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58152303C1
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 21:34:23 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id k13so1774824plg.0
        for <netdev@vger.kernel.org>; Wed, 08 Feb 2023 21:34:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=theori.io; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=sfESC8dxTyubNTEJXCjZP/zE93GREeXZWpu8Do6hdX8=;
        b=cQ/Io4dpgTZQlLSW6XjBL2gdxeVqdNeyqdfD6R6livKGUg5bEnlpqMh6fiEb0bQE0G
         7OZHPHW4FbIPNaRxtjHmtY1px5/ZpElnagm0gTea/gWFx09eFKYCGhWWsv2EfWj9sxRs
         9KJlFsflMimstlaguENRVCEF7cASzqL/PCNQ4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sfESC8dxTyubNTEJXCjZP/zE93GREeXZWpu8Do6hdX8=;
        b=5tsMTh1ucsRm1lzi/ci6ofJgm2AKdOkJupcseqaH/Y1zUlLh2OU9d74WGZ4mHVNQoK
         rDl7esSlRoeczQKkzNkENqB+d190Mas2geK3M41kQxXPQYc9tK708yZ1lpuILkDl3APx
         K5TMPjXZQmdqolfk59vabU68kw5YgqcrCYMLakd1dZKgK2Mxc51Mssym3SRo0uC0zolu
         13+Q6pmL5lZwQXYPGzm2UHRlf+LqiWTjzDh0HLsFIroAV+ztS6KDLDyAUFz9JTrLvukk
         v1gsaRU5bOKhifukq5vWqo91yQIVQQE8Kn5fvJiaIpqlpMArcab7JU5zCoVgkdzy+qFn
         yBDA==
X-Gm-Message-State: AO0yUKXYtLl3r3R9Gy+kQkpkx8ce3BOg+iEAG1ju3TcsCWbh+8lpi+/I
        RpB4mKgZTYvZhdPPBIy5yEaOByDrWpl0LAu3
X-Google-Smtp-Source: AK7set8MLjG35tFF6PAjKdQCwFJtoAnIe90XbmA1tcr8uCGUNDuJy3m/8s8eSFfn0wwTZ081v12OQg==
X-Received: by 2002:a17:903:120c:b0:197:35fc:6a5d with SMTP id l12-20020a170903120c00b0019735fc6a5dmr10781466plh.30.1675920862869;
        Wed, 08 Feb 2023 21:34:22 -0800 (PST)
Received: from ubuntu ([106.101.3.52])
        by smtp.gmail.com with ESMTPSA id w2-20020a170902a70200b001965f761e6dsm422074plq.182.2023.02.08.21.34.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Feb 2023 21:34:22 -0800 (PST)
Date:   Wed, 8 Feb 2023 21:34:16 -0800
From:   Hyunwoo Kim <v4bel@theori.io>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Sabrina Dubroca <sd@queasysnail.net>, steffen.klassert@secunet.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, v4bel@theori.io, imv4bel@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH] xfrm: Zero padding when dumping algos and encap
Message-ID: <20230209053416.GA5032@ubuntu>
References: <20230204175018.GA7246@ubuntu>
 <Y+Hp+0LzvScaUJV0@gondor.apana.org.au>
 <20230208085434.GA2933@ubuntu>
 <Y+N4Q2B01iRfXlQu@gondor.apana.org.au>
 <Y+Oggx0YBA3kLLcw@hog>
 <Y+QriSfj3OYBj6J6@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y+QriSfj3OYBj6J6@gondor.apana.org.au>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 09, 2023 at 07:08:57AM +0800, Herbert Xu wrote:
> On Wed, Feb 08, 2023 at 02:15:47PM +0100, Sabrina Dubroca wrote:
> >
> > Do you mean as a replacement for Hyunwoo's patch, or that both are
> > needed? pfkey_msg2xfrm_state doesn't always initialize encap_sport and
> > encap_dport (and calg->alg_key_len, but you're not using that in
> > copy_to_user_calg), so I guess you mean both patches.
> 
> It's meant to be a replacement but yes we should still zero x->encap
> because that will leak out in other ways, e.g., on the wire.
> 
> Hyunwoo, could you please repost your patch just for x->encap?

Can the x->encap patch do this?

I didn't add the syzbot hash as x->encap is not the flow reported by syzbot:
Subject: [PATCH] af_key: Fix heap information leak

Since x->encap of pfkey_msg2xfrm_state() is not
initialized to 0, kernel heap data can be leaked.

Fix with kzalloc() to prevent this.

Signed-off-by: Hyunwoo Kim <v4bel@theori.io>
---
 net/key/af_key.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/key/af_key.c b/net/key/af_key.c
index 2bdbcec781cd..a815f5ab4c49 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -1261,7 +1261,7 @@ static struct xfrm_state * pfkey_msg2xfrm_state(struct net *net,
 		const struct sadb_x_nat_t_type* n_type;
 		struct xfrm_encap_tmpl *natt;

-		x->encap = kmalloc(sizeof(*x->encap), GFP_KERNEL);
+		x->encap = kzalloc(sizeof(*x->encap), GFP_KERNEL);
 		if (!x->encap) {
 			err = -ENOMEM;
 			goto out;
> 
> > > +static int copy_to_user_encap(struct xfrm_encap_tmpl *ep, struct sk_buff *skb)
> > > +{
> > > +	struct nlattr *nla = nla_reserve(skb, XFRMA_ALG_COMP, sizeof(*ep));
> > 
> > XFRMA_ENCAP
> 
> Good catch.  I will repost the patch.
> 
> > > +	uep->encap_oa = ep->encap_oa;
> > 
> > Should that be a memcpy? At least that's how xfrm_user.c usually does
> > copies of xfrm_address_t.
> 
> It doesn't really matter.
> 
> Thanks,
> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
