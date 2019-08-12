Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACD898A4F0
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 19:52:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726549AbfHLRww (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 13:52:52 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:35965 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726236AbfHLRwv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 13:52:51 -0400
Received: by mail-pl1-f194.google.com with SMTP id g4so1681620plo.3
        for <netdev@vger.kernel.org>; Mon, 12 Aug 2019 10:52:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=FDBHhm9o0hCKPWae4nXBJdHpjQnOdVxkg9O1sCwpT3c=;
        b=f6bs+VkH6HmAmbfT0JcI9UiQX2Yy2ulAeH7sjJn9fNGaqzxmrnPUaLY9Sd/BZ/F3Fh
         o+hCBJBSQCOW6UFH+Ch9gxkeaN31YSnXEh5GHcqIX3ngKsCMnXeyLr9dzuFGBlytvi1e
         jvY+ARqwLpPAP0y3fZ6XR1/uT2hnENUYO0GlmqohQpVtGDr+qMAswuKr3YnJUekuDQzX
         wZYmEIRqCETd5hMzowmN2snNJN6kRCXIJ6h41E/H22TYELKVI1biFKjikb0kxBF5u2Vw
         CLk/M8GeNYoN6rxRJz99VnMVJHf8FKMhhr3ZpL0h6jhd6hXDRd+iBlEShFytZoq2cOoa
         /f/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=FDBHhm9o0hCKPWae4nXBJdHpjQnOdVxkg9O1sCwpT3c=;
        b=qlc24DrXp+LkLPCa4R11qYOUHyZ1nDcVeiQ5XudXUN8gEyvtcZzvY4TWo++AqENEO2
         mj5pLrMkUnlNXfyPzurIhs9awpqltDOo0YumNKlIac07h0l30CdpbJb4How3LPgfSgDO
         yKwwa9V6yLS7sFJv2bWoYLejjj6P9+uhe0vsRH+fSCRSmOFBR+dylPII1EC3aOKyo+OM
         rHDA/eu91aTMOlnnYkLc1+9tyGAP7gZGk2+E6zMhj0psraqAs0TduVifrkJ8g+bmE7Qh
         gzM6eeUZ/bs/ZFs6bSdbmD0bKY+gr+eN+baNO7YCbWAx8ejLl7fC4sNxC+1MnImY64K1
         V37g==
X-Gm-Message-State: APjAAAXLV7kESLMq1key2MvAE08YsPGuohLNlE3JAd8dhNEEGQXPUn0v
        4OCR42hyYbhSgXzPH4tjd3R4pQ==
X-Google-Smtp-Source: APXvYqyLAo893vqHTfzBwG3ccLyA4X+EsqC2/4r6iU+AD+DOwYk6KGio6qLinnSkPUx3XIRRykfiWA==
X-Received: by 2002:a17:902:be03:: with SMTP id r3mr34472025pls.156.1565632370710;
        Mon, 12 Aug 2019 10:52:50 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id r6sm229803pjb.22.2019.08.12.10.52.49
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 12 Aug 2019 10:52:50 -0700 (PDT)
Date:   Mon, 12 Aug 2019 10:52:49 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Stanislav Fomichev <sdf@google.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, davem@davemloft.net, ast@kernel.org,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>
Subject: Re: [PATCH bpf-next v2 2/4] bpf: support cloning sk storage on
 accept()
Message-ID: <20190812175249.GF2820@mini-arch>
References: <20190809161038.186678-1-sdf@google.com>
 <20190809161038.186678-3-sdf@google.com>
 <db5ec323-1126-d461-bc65-27ccc1414589@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <db5ec323-1126-d461-bc65-27ccc1414589@iogearbox.net>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/12, Daniel Borkmann wrote:
> On 8/9/19 6:10 PM, Stanislav Fomichev wrote:
> > Add new helper bpf_sk_storage_clone which optionally clones sk storage
> > and call it from sk_clone_lock.
> > 
> > Cc: Martin KaFai Lau <kafai@fb.com>
> > Cc: Yonghong Song <yhs@fb.com>
> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> [...]
> > +int bpf_sk_storage_clone(const struct sock *sk, struct sock *newsk)
> > +{
> > +	struct bpf_sk_storage *new_sk_storage = NULL;
> > +	struct bpf_sk_storage *sk_storage;
> > +	struct bpf_sk_storage_elem *selem;
> > +	int ret;
> > +
> > +	RCU_INIT_POINTER(newsk->sk_bpf_storage, NULL);
> > +
> > +	rcu_read_lock();
> > +	sk_storage = rcu_dereference(sk->sk_bpf_storage);
> > +
> > +	if (!sk_storage || hlist_empty(&sk_storage->list))
> > +		goto out;
> > +
> > +	hlist_for_each_entry_rcu(selem, &sk_storage->list, snode) {
> > +		struct bpf_sk_storage_elem *copy_selem;
> > +		struct bpf_sk_storage_map *smap;
> > +		struct bpf_map *map;
> > +		int refold;
> > +
> > +		smap = rcu_dereference(SDATA(selem)->smap);
> > +		if (!(smap->map.map_flags & BPF_F_CLONE))
> > +			continue;
> > +
> > +		map = bpf_map_inc_not_zero(&smap->map, false);
> > +		if (IS_ERR(map))
> > +			continue;
> > +
> > +		copy_selem = bpf_sk_storage_clone_elem(newsk, smap, selem);
> > +		if (!copy_selem) {
> > +			ret = -ENOMEM;
> > +			bpf_map_put(map);
> > +			goto err;
> > +		}
> > +
> > +		if (new_sk_storage) {
> > +			selem_link_map(smap, copy_selem);
> > +			__selem_link_sk(new_sk_storage, copy_selem);
> > +		} else {
> > +			ret = sk_storage_alloc(newsk, smap, copy_selem);
> > +			if (ret) {
> > +				kfree(copy_selem);
> > +				atomic_sub(smap->elem_size,
> > +					   &newsk->sk_omem_alloc);
> > +				bpf_map_put(map);
> > +				goto err;
> > +			}
> > +
> > +			new_sk_storage = rcu_dereference(copy_selem->sk_storage);
> > +		}
> > +		bpf_map_put(map);
> 
> The map get/put combination /under/ RCU read lock seems a bit odd to me, could
> you exactly describe the race that this would be preventing?
There is a race between sk storage release and sk storage clone.
bpf_sk_storage_map_free uses synchronize_rcu to wait for all existing
users to finish and the new ones are prevented via map's refcnt being
zero; we need to do something like that for the clone.
Martin suggested to use bpf_map_inc_not_zero/bpf_map_put.
If I read everythin correctly, I think without map_inc/map_put we
get the following race:

CPU0                                   CPU1

bpf_map_put
  bpf_sk_storage_map_free(smap)
    synchronize_rcu

    // no more users via bpf or
    // syscall, but clone
    // can still happen

    for each (bucket)
      selem_unlink
        selem_unlink_map(smap)

        // adding anything at
        // this point to the
        // bucket will leak

                                       rcu_read_lock
                                       tcp_v4_rcv
                                         tcp_v4_do_rcv
                                           // sk is lockless TCP_LISTEN
                                           tcp_v4_cookie_check
                                             tcp_v4_syn_recv_sock
                                               bpf_sk_storage_clone
                                                 rcu_dereference(sk->sk_bpf_storage)
                                                 selem_link_map(smap, copy)
                                                 // adding new element to the
                                                 // map -> leak
                                       rcu_read_unlock

      selem_unlink_sk
       sk->sk_bpf_storage = NULL

    synchronize_rcu
