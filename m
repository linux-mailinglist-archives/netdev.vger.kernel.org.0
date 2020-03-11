Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF4701824E9
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 23:31:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731040AbgCKWbw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 18:31:52 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:39787 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729846AbgCKWbw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 18:31:52 -0400
Received: by mail-pf1-f196.google.com with SMTP id w65so2159737pfb.6;
        Wed, 11 Mar 2020 15:31:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=Xn6MB1heFARkj47MUS06hvpuiFejBHCyNyM2A97lp38=;
        b=ME3qlUCpD+uZx5CzsmmCxJfA/nvhO4/f9xMrBhdy3dp4MjyJOjz/UENZ5xyhNWMM4q
         PZGeUpaTYRQE3N+tI7fWhk81ohPXh1BUPxESzvfzVAk6GakE/g9n550Qzape34j8tR+e
         HTLgR2/FHy6Twde0CC2cQBy/TJsaXEBiUKo0C78sQTLiFqmE0hPYAUFW6HMU/vcaOV5w
         5YZd0CJXN4MCbhZ7ENaheI3DFFNVf81IEcASx/s1lBgvjvMlCl0IQ+QdkdrwdM6cWvks
         FjTaFeL+rcR7vFJt0tNsFZi2AyKo/5aunben7fepygk0itxUNmqOZzzDLECMgR6aASqm
         KxCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=Xn6MB1heFARkj47MUS06hvpuiFejBHCyNyM2A97lp38=;
        b=E2VA15L6qzynSIBLPq62voWQzuUMufV9SPZqhkO19bZ1pHhy/tUmw//slDRBDJPj84
         g9mupwMtByGPPHaz9nnvna7QP09qJT3Gdngzh8t1FPXpiArwn8uHHw1BnA2KvqEFDl2F
         OLBBbMmSsYCY5wHZDmTRPfPo/Sjh5+u/kU7U46k0CMfYqoMc6+rsmhksfUzVHVWIdhE3
         8QlvV1yX9Vb9/4dAlRPD1GW7uaa4WwHY93o98DHzIHciHp05OB57IFO9Crr+v9VZNDC0
         QDeYVl1wsB19LNrY1nSiwmh+Hzj63ripweBwKXg8jKPAs6yFN+U99UpfIgJS4MRK2/4F
         vIsg==
X-Gm-Message-State: ANhLgQ2VDYKuegIASgJRATLpG98IiIJkEH0UbatzwvurcUDx8R73zhoB
        LWQKSFcdc09yoGT6IRr6DYioZjN3
X-Google-Smtp-Source: ADFU+vuIbFFAEy+voWHZZAmTAvV46ApiZefWEqyqOwI+8KhN5D0sWieVI8wn5IC/voI+dw2wUNR9Cw==
X-Received: by 2002:a62:6490:: with SMTP id y138mr4911265pfb.96.1583965911346;
        Wed, 11 Mar 2020 15:31:51 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id s21sm44195782pfm.186.2020.03.11.15.31.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2020 15:31:50 -0700 (PDT)
Date:   Wed, 11 Mar 2020 15:31:41 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        kernel-team@cloudflare.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <5e6966cdf1f27_20552ab9153405b4bf@john-XPS-13-9370.notmuch>
In-Reply-To: <87tv2vxa7a.fsf@cloudflare.com>
References: <20200310174711.7490-1-lmb@cloudflare.com>
 <20200310174711.7490-3-lmb@cloudflare.com>
 <87tv2vxa7a.fsf@cloudflare.com>
Subject: Re: [PATCH 2/5] bpf: convert queue and stack map to map_copy_value
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Sitnicki wrote:
> On Tue, Mar 10, 2020 at 06:47 PM CET, Lorenz Bauer wrote:
> > Migrate BPF_MAP_TYPE_QUEUE and BPF_MAP_TYPE_STACK to map_copy_value,
> > by introducing small wrappers that discard the (unused) key argument.
> >
> > Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> > ---
> >  kernel/bpf/queue_stack_maps.c | 18 ++++++++++++++++++
> >  kernel/bpf/syscall.c          |  5 +----
> >  2 files changed, 19 insertions(+), 4 deletions(-)
> >
> > diff --git a/kernel/bpf/queue_stack_maps.c b/kernel/bpf/queue_stack_maps.c
> > index f697647ceb54..5c89b7583cd2 100644
> > --- a/kernel/bpf/queue_stack_maps.c
> > +++ b/kernel/bpf/queue_stack_maps.c
> > @@ -262,11 +262,28 @@ static int queue_stack_map_get_next_key(struct bpf_map *map, void *key,
> >  	return -EINVAL;
> >  }
> >
> > +/* Called from syscall */
> > +static int queue_map_copy_value(struct bpf_map *map, void *key, void *value)
> > +{
> > +	(void)key;
> 
> Alternatively, there's is the __always_unused compiler attribute from
> include/linux/compiler_attributes.h that seems to be in wide use.
> 

+1 use the attribute its much nicer imo.

> > +
> > +	return queue_map_peek_elem(map, value);
> > +}
> > +
> > +/* Called from syscall */
> > +static int stack_map_copy_value(struct bpf_map *map, void *key, void *value)
> > +{
> > +	(void)key;
> > +
> > +	return stack_map_peek_elem(map, value);
> > +}
> > +
> >  const struct bpf_map_ops queue_map_ops = {
> >  	.map_alloc_check = queue_stack_map_alloc_check,
> >  	.map_alloc = queue_stack_map_alloc,
> >  	.map_free = queue_stack_map_free,
> >  	.map_lookup_elem = queue_stack_map_lookup_elem,
> > +	.map_copy_value = queue_map_copy_value,
> >  	.map_update_elem = queue_stack_map_update_elem,
> >  	.map_delete_elem = queue_stack_map_delete_elem,
> >  	.map_push_elem = queue_stack_map_push_elem,
> > @@ -280,6 +297,7 @@ const struct bpf_map_ops stack_map_ops = {
> >  	.map_alloc = queue_stack_map_alloc,
> >  	.map_free = queue_stack_map_free,
> >  	.map_lookup_elem = queue_stack_map_lookup_elem,
> > +	.map_copy_value = stack_map_copy_value,
> >  	.map_update_elem = queue_stack_map_update_elem,
> >  	.map_delete_elem = queue_stack_map_delete_elem,
> >  	.map_push_elem = queue_stack_map_push_elem,
> > diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> > index 6503824e81e9..20c6cdace275 100644
> > --- a/kernel/bpf/syscall.c
> > +++ b/kernel/bpf/syscall.c
> > @@ -218,10 +218,7 @@ static int bpf_map_copy_value(struct bpf_map *map, void *key, void *value,
> >  		return bpf_map_offload_lookup_elem(map, key, value);
> >
> >  	bpf_disable_instrumentation();
> > -	if (map->map_type == BPF_MAP_TYPE_QUEUE ||
> > -	    map->map_type == BPF_MAP_TYPE_STACK) {
> > -		err = map->ops->map_peek_elem(map, value);
> > -	} else if (map->ops->map_copy_value) {
> > +	if (map->ops->map_copy_value) {
> >  		err = map->ops->map_copy_value(map, key, value);
> >  	} else {
> >  		rcu_read_lock();


