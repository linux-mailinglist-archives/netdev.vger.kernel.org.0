Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96F472219BA
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 04:08:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727915AbgGPCIj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 22:08:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726984AbgGPCIi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 22:08:38 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD327C061755;
        Wed, 15 Jul 2020 19:08:38 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id s26so2951177pfm.4;
        Wed, 15 Jul 2020 19:08:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4uKGYf+tOJWMlOipTgbQQLVfzGcYMjPjk/udv7LQbjY=;
        b=kpe1uwRbmgBUqYfLIPPgkrH/caXm7zLSMbHZbWiWUnCqT3wZRrnvLQ7BcFgXg5k+HM
         JfAvpgxt0/Y39X9qKyV17x0o6sb1/FCK2NadEtaMoUuG9DLY5DeuuL1y1DJfcKoroio+
         oLIfmXs/OgEb5nNYhBFzhf8FbcW+wV35FHrimSaJnoupKxIgHL/18S4ssc7xADM1+BlR
         8mRx6XsctETuT9LlQa9WyqBj87Ib3dxC/h4JfkkjiUTH2eCsndtuEpN+4seGzBOQVB2p
         WzHtUZMtB54X9XKsQRmz99oDztwV8Pyqm5nN+T1LgVPVEMOGRh9O50gSTYJo26lL7VLv
         vMoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4uKGYf+tOJWMlOipTgbQQLVfzGcYMjPjk/udv7LQbjY=;
        b=ReNfW2J0KZ/iuP+yFT9YU/75wz5Ts4LpzFoIJ7T7fs2ANXbrzy7EggyLxo6gUXgnEw
         JGVMxBFo6RxrxBAyPOY2c7IIAN+iRB1jD8uaTwFistCdJsb3UUjNh4DDr+tGCYo44e3J
         4cb2WxhxkOh1dnW9Y9TPFYVhZRPyN+tkfGhUTSPjiIJaFWJRyCPAWBKK9lQe51L+KJ+m
         FfCrkd7xn53xs2Qc4lg7isZ5IuZNMmket3f96pIjH/K5mqRhYJlWmnUq9ttM3jgTC2Xs
         O8U0W1Gll1fSgA+uTfn7zgdgd28TYYYP/aEsWPKHYr40zqKkWtpO+0LFOkh9q7PMAYi5
         Jb4A==
X-Gm-Message-State: AOAM530Ni6cKr8ZPkLiGKqdG3mvpQzvnNyhu13Zmgx/bYUVSIjctWFGv
        ceKwJuULDVZWyGet35ETntg=
X-Google-Smtp-Source: ABdhPJynFbc5e7ZETVQWwua/9t0ysF4xUQBjGcIlXJUtu3xw9MEB5LMYVwyiXmSsgtX/JPxc22zyhg==
X-Received: by 2002:a65:64c1:: with SMTP id t1mr2241960pgv.267.1594865318093;
        Wed, 15 Jul 2020 19:08:38 -0700 (PDT)
Received: from dhcp-12-153.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id d5sm3078071pju.15.2020.07.15.19.08.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2020 19:08:37 -0700 (PDT)
Date:   Thu, 16 Jul 2020 10:08:27 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>, ast@kernel.org
Subject: Re: [PATCH bpf-next] bpf: add a new bpf argument type
 ARG_CONST_MAP_PTR_OR_NULL
Message-ID: <20200716020827.GI2531@dhcp-12-153.nay.redhat.com>
References: <20200715070001.2048207-1-liuhangbin@gmail.com>
 <67a68a77-f287-1bb1-3221-24e8b3351958@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <67a68a77-f287-1bb1-3221-24e8b3351958@iogearbox.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 16, 2020 at 12:28:16AM +0200, Daniel Borkmann wrote:
> On 7/15/20 9:00 AM, Hangbin Liu wrote:
> > Add a new bpf argument type ARG_CONST_MAP_PTR_OR_NULL which could be
> > used when we want to allow NULL pointer for map parameter. The bpf helper
> > need to take care and check if the map is NULL when use this type.
> > 
> > Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> 
> Is this patch to be merged into the set in [0] for passing NULL ex_map as discussed?
> Seems you sent out two incomplete sets?
> 
>   [0] https://lore.kernel.org/bpf/20200709013008.3900892-1-liuhangbin@gmail.com/T/#m99a8fa8ffe79d5f00d305c0800ad3abe619294f2

Yes, I did it by intend. I thought these two should be consider as
different feature. So I'd prefer post them separately. Once both
patches are merged, I will post a followup patch to add the NULL pointer
support to xdp multicast helper.

> 
> > ---
> >   include/linux/bpf.h   |  1 +
> >   kernel/bpf/verifier.c | 11 ++++++++---
> >   2 files changed, 9 insertions(+), 3 deletions(-)
> > 
> > diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> > index c67c88ad35f8..9d4dbef3c943 100644
> > --- a/include/linux/bpf.h
> > +++ b/include/linux/bpf.h
> > @@ -253,6 +253,7 @@ enum bpf_arg_type {
> >   	ARG_PTR_TO_ALLOC_MEM,	/* pointer to dynamically allocated memory */
> >   	ARG_PTR_TO_ALLOC_MEM_OR_NULL,	/* pointer to dynamically allocated memory or NULL */
> >   	ARG_CONST_ALLOC_SIZE_OR_ZERO,	/* number of allocated bytes requested */
> > +	ARG_CONST_MAP_PTR_OR_NULL,	/* const argument used as pointer to bpf_map or NULL */
> >   };
> >   /* type of values returned from helper functions */
> > diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> > index 3c1efc9d08fd..d3551a19853a 100644
> > --- a/kernel/bpf/verifier.c
> > +++ b/kernel/bpf/verifier.c
> > @@ -3849,9 +3849,13 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
> >   		expected_type = SCALAR_VALUE;
> >   		if (type != expected_type)
> >   			goto err_type;
> > -	} else if (arg_type == ARG_CONST_MAP_PTR) {
> > +	} else if (arg_type == ARG_CONST_MAP_PTR ||
> > +		   arg_type == ARG_CONST_MAP_PTR_OR_NULL) {
> >   		expected_type = CONST_PTR_TO_MAP;
> > -		if (type != expected_type)
> > +		if (register_is_null(reg) &&
> > +		    arg_type == ARG_CONST_MAP_PTR_OR_NULL)
> > +			/* final test in check_stack_boundary() */;
> > +		else if (type != expected_type)
> >   			goto err_type;
> >   	} else if (arg_type == ARG_PTR_TO_CTX ||
> >   		   arg_type == ARG_PTR_TO_CTX_OR_NULL) {
> > @@ -3957,7 +3961,8 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
> >   		return -EFAULT;
> >   	}
> > -	if (arg_type == ARG_CONST_MAP_PTR) {
> > +	if (arg_type == ARG_CONST_MAP_PTR ||
> > +	    (arg_type == ARG_CONST_MAP_PTR_OR_NULL && !register_is_null(reg))) {
> >   		/* bpf_map_xxx(map_ptr) call: remember that map_ptr */
> >   		meta->map_ptr = reg->map_ptr;
> 
> I would probably have the semantics a bit different in the sense that I would
> update meta->map_ptr to the last ARG_CONST_MAP_PTR, meaning:
> 
>     meta->map_ptr = register_is_null(reg) ? NULL : reg->map_ptr;

Thanks for the suggestion. I will update it.

> 
> >   	} else if (arg_type == ARG_PTR_TO_MAP_KEY) {
> > 
> 
> In combination with the set, this also needs test_verifier selftests in order to
> exercise BPF insn snippets for the good & [expected] bad case.

OK, I will add a test for this.

Thanks
Hangbin
