Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34571C90C9
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 20:25:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728495AbfJBSZh convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 2 Oct 2019 14:25:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42936 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727756AbfJBSZh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Oct 2019 14:25:37 -0400
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com [209.85.208.199])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 92C0410B78
        for <netdev@vger.kernel.org>; Wed,  2 Oct 2019 18:25:36 +0000 (UTC)
Received: by mail-lj1-f199.google.com with SMTP id q185so41281ljb.20
        for <netdev@vger.kernel.org>; Wed, 02 Oct 2019 11:25:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=ibQgq7pRDE4NMnwf0Oe/pHy9vleqF3n5ofWwZ/N+LVo=;
        b=iccct3jMoMTE4rvtusZol+tfW6Di0g9fLsxziQja2jBb27lSBs7pS+UV2UcGIioLFA
         dEp6rsBYpQS9gHtw1ntvdv80z4IxYn+qcdw7xFAPVKfZasTUoZXrpWL+APWLLLIWav21
         DMLgiWZ/HFOyO882JaA8s2dVFb8W7r/tT43LfhVwGN6iVaQlW5h/Zy3Ig0f30n3MXLfR
         fpvDMDW+pOOPcVyGMHGJuHoZF5bZQv5Ot1r4m6VA0UcGZogsEU5dm7U+8gdfrz1RbHTh
         OOAxpWPDINJTZDUZOErhbsrxuxZJPj+9LmAWkh5l+ugBI/mRbzNruZpKqYM9Of0WsDVF
         HaXQ==
X-Gm-Message-State: APjAAAVIS6yUrXdYu7X6Kble3Bg6O8fCi/X6RlUy5vfODrD93Qi8wX+3
        joPsoeYFp5b8YcBV8PQXKLCZPOsNaPBvUxdie39CzmLuZMObI+rbuh6aDO79uMWjjXvZ1mRc4Sg
        ZLTunlYt/uqfQ0s8v
X-Received: by 2002:ac2:5445:: with SMTP id d5mr3083136lfn.43.1570040735055;
        Wed, 02 Oct 2019 11:25:35 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwtkK9eR9QNvCdWZq+zcFWwZHEcXsn/QQSCkOeyIwohrymf7Lk80K5KxPvs6bNY5aCBfXdIgg==
X-Received: by 2002:ac2:5445:: with SMTP id d5mr3083115lfn.43.1570040734763;
        Wed, 02 Oct 2019 11:25:34 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id p22sm39930ljp.69.2019.10.02.11.25.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Oct 2019 11:25:34 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 0EEFA18063D; Wed,  2 Oct 2019 20:25:33 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Marek Majkowski <marek@cloudflare.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>
Subject: Re: [PATCH bpf-next 2/9] xdp: Add new xdp_chain_map type for specifying XDP call sequences
In-Reply-To: <CACAyw9-u7oAmC1F4rW8wH2a2aoxrDHCENcM4j5WmriS7YLmevQ@mail.gmail.com>
References: <157002302448.1302756.5727756706334050763.stgit@alrua-x1> <157002302672.1302756.10579143571088111093.stgit@alrua-x1> <CACAyw9-u7oAmC1F4rW8wH2a2aoxrDHCENcM4j5WmriS7YLmevQ@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 02 Oct 2019 20:25:32 +0200
Message-ID: <878sq3romb.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lorenz Bauer <lmb@cloudflare.com> writes:

> On Wed, 2 Oct 2019 at 14:30, Toke Høiland-Jørgensen <toke@redhat.com> wrote:
>>
>> diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
>> index 113e1286e184..ab855095c830 100644
>> --- a/kernel/bpf/hashtab.c
>> +++ b/kernel/bpf/hashtab.c
>> @@ -1510,3 +1510,156 @@ const struct bpf_map_ops htab_of_maps_map_ops = {
>>         .map_gen_lookup = htab_of_map_gen_lookup,
>>         .map_check_btf = map_check_no_btf,
>>  };
>> +
>> +struct xdp_chain_table {
>> +       struct bpf_prog *wildcard_act;
>> +       struct bpf_prog *act[XDP_ACT_MAX];
>> +};
>> +
>> +static int xdp_chain_map_alloc_check(union bpf_attr *attr)
>> +{
>> +       BUILD_BUG_ON(sizeof(struct xdp_chain_table) / sizeof(void *) !=
>> +                    sizeof(struct xdp_chain_acts) / sizeof(u32));
>> +
>> +       if (attr->key_size != sizeof(u32) ||
>> +           attr->value_size != sizeof(struct xdp_chain_acts))
>> +               return -EINVAL;
>
> How are we going to extend xdp_chain_acts if a new XDP action is
> introduced?

By just checking the size and reacting appropriately? Don't think that
is problematic, just takes a few if statements here?

>> +
>> +       attr->value_size = sizeof(struct xdp_chain_table);
>> +       return htab_map_alloc_check(attr);
>> +}
>> +
>> +struct bpf_prog *bpf_xdp_chain_map_get_prog(struct bpf_map *map,
>> +                                           u32 prev_id,
>> +                                           enum xdp_action action)
>> +{
>> +       struct xdp_chain_table *tab;
>> +       void *ptr;
>> +
>> +       ptr = htab_map_lookup_elem(map, &prev_id);
>> +
>> +       if (!ptr)
>> +               return NULL;
>> +
>> +       tab = READ_ONCE(ptr);
>> +       return tab->act[action - 1] ?: tab->wildcard_act;
>> +}
>> +EXPORT_SYMBOL_GPL(bpf_xdp_chain_map_get_prog);
>> +
>> +/* only called from syscall */
>> +int bpf_xdp_chain_map_lookup_elem(struct bpf_map *map, void *key, void *value)
>> +{
>> +       struct xdp_chain_acts *act = value;
>> +       struct xdp_chain_table *tab;
>> +       void *ptr;
>> +       u32 *cur;
>> +       int i;
>> +
>> +       ptr = htab_map_lookup_elem(map, key);
>> +       if (!ptr)
>> +               return -ENOENT;
>> +
>> +       tab = READ_ONCE(ptr);
>> +
>> +       if (tab->wildcard_act)
>> +               act->wildcard_act = tab->wildcard_act->aux->id;
>> +
>> +       cur = &act->drop_act;
>> +       for (i = 0; i < XDP_ACT_MAX; i++, cur++)
>> +               if(tab->act[i])
>> +                       *cur = tab->act[i]->aux->id;
>
> For completeness, zero out *cur in the else case?

Ah, good point. I assumed the caller was kzalloc'ing; seems that's not
the case; will fix.

>> +
>> +       return 0;
>> +}
>> +
>> +static void *xdp_chain_map_get_ptr(int fd)
>> +{
>> +       struct bpf_prog *prog = bpf_prog_get(fd);
>> +
>> +       if (IS_ERR(prog))
>> +               return prog;
>> +
>> +       if (prog->type != BPF_PROG_TYPE_XDP ||
>> +           bpf_prog_is_dev_bound(prog->aux)) {
>> +               bpf_prog_put(prog);
>> +               return ERR_PTR(-EINVAL);
>> +       }
>> +
>> +       return prog;
>> +}
>> +
>> +static void xdp_chain_map_put_ptrs(void *value)
>> +{
>> +       struct xdp_chain_table *tab = value;
>> +       int i;
>> +
>> +       for (i = 0; i < XDP_ACT_MAX; i++)
>> +               if (tab->act[i])
>> +                       bpf_prog_put(tab->act[i]);
>> +
>> +       if (tab->wildcard_act)
>> +               bpf_prog_put(tab->wildcard_act);
>> +}
>> +
>> +/* only called from syscall */
>> +int bpf_xdp_chain_map_update_elem(struct bpf_map *map, void *key, void *value,
>> +                                 u64 map_flags)
>
> Nit: check that map_flags == 0

Yup, will fix.

>> +{
>> +       struct xdp_chain_acts *act = value;
>> +       struct xdp_chain_table tab = {};
>> +       u32 lookup_key = *((u32*)key);
>> +       u32 *cur = &act->drop_act;
>> +       bool found_val = false;
>> +       int ret, i;
>> +       void *ptr;
>> +
>> +       if (!lookup_key)
>> +               return -EINVAL;
>
> Is it possible to check that this is a valid prog id / fd or whatever
> it is?

I suppose we could. The reason I didn't was that I figured it would be
valid to insert IDs into the map that don't exist (yet, or any longer).
Theoretically, if you can predict the program ID, you could insert it
into the map before it's allocated. There's no clearing of maps when
program IDs are freed either.

>> +
>> +       if (act->wildcard_act) {
>
> If this is an fd, 0 is a valid value no?

Yes, technically. But if we actually allow fd 0, that means the
userspace caller can't just pass a 0-initialised struct, but will have
to loop through and explicitly set everything to -1. Whereas if we just
disallow fd 0, that is no longer a problem (and normally you have to
jump through some hoops to end up with a bpf program pointer as standard
input, no?).

It's not ideal, but I figured this was the least ugly way to do it. If
you have a better idea I'm all ears? :)

>> +               ptr = xdp_chain_map_get_ptr(act->wildcard_act);
>> +               if (IS_ERR(ptr))
>> +                       return PTR_ERR(ptr);
>> +               tab.wildcard_act = ptr;
>> +               found_val = true;
>> +       }
>> +
>> +       for (i = 0; i < XDP_ACT_MAX; i++, cur++) {
>> +               if (*cur) {
>> +                       ptr = xdp_chain_map_get_ptr(*cur);
>> +                       if (IS_ERR(ptr)) {
>> +                               ret = PTR_ERR(ptr);
>> +                               goto out_err;
>> +                       }
>> +                       tab.act[i] = ptr;
>> +                       found_val = true;
>> +               }
>> +       }
>> +
>> +       if (!found_val) {
>> +               ret = -EINVAL;
>> +               goto out_err;
>> +       }
>> +
>> +       ret = htab_map_update_elem(map, key, &tab, map_flags);
>> +       if (ret)
>> +               goto out_err;
>> +
>> +       return ret;
>> +
>> +out_err:
>> +       xdp_chain_map_put_ptrs(&tab);
>> +
>> +       return ret;
>> +}
>> +
>> +
>> +const struct bpf_map_ops xdp_chain_map_ops = {
>> +       .map_alloc_check = xdp_chain_map_alloc_check,
>> +       .map_alloc = htab_map_alloc,
>> +       .map_free = fd_htab_map_free,
>> +       .map_get_next_key = htab_map_get_next_key,
>> +       .map_delete_elem = htab_map_delete_elem,
>> +       .map_fd_put_value = xdp_chain_map_put_ptrs,
>> +       .map_check_btf = map_check_no_btf,
>> +};
>
> --
> Lorenz Bauer  |  Systems Engineer
> 6th Floor, County Hall/The Riverside Building, SE1 7PB, UK
>
> www.cloudflare.com
