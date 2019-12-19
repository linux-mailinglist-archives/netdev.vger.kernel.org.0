Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D9C4126785
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 17:59:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726971AbfLSQ7i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 11:59:38 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:41511 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726906AbfLSQ7i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 11:59:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576774776;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MGL6WDhpvx9WJXLOC66ZSgn8G/Jlbj4ZPZWGZkIIBLc=;
        b=GQWTh1odEkOTBvbq+CoImL2PYAcVVZ0AFJF2KFRu424V4WS9blbOPWDO27w4CB5yfUK3a/
        CnzR3wC+BW/c3tC2PBt3stMLTHDDecUgDccyllRiQHpgengRAm7Zh9DDM4o4r97CkF7CC9
        3pS7SjFMJBOR1nR3X3yTZbnCZEZnfvw=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-398-zzdfv9F2PBCecaEGLyUpQA-1; Thu, 19 Dec 2019 11:59:34 -0500
X-MC-Unique: zzdfv9F2PBCecaEGLyUpQA-1
Received: by mail-lf1-f71.google.com with SMTP id d7so626996lfk.9
        for <netdev@vger.kernel.org>; Thu, 19 Dec 2019 08:59:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=MGL6WDhpvx9WJXLOC66ZSgn8G/Jlbj4ZPZWGZkIIBLc=;
        b=JIyKdsV/A7Q0XEXTeZhYpRpCIs1yDC9hbYkGWidDCIG/Kxqyda2bpsbNZKJd71QTNb
         Yo8DsMBpdi1PO2QfMOKBNiy3F2GS0cT1f6DMz+EP1hxEzmkjM5ThcCxDhs+m6qIjSgs3
         m2zpOTJEzZKqHxP8FVRUAdqtPzQVg/D4syAO+UUUpl6LJ7ipvqc6eMElmfgeMPSg88gk
         tgWHdSZkBW7lziCuhpXWtb3w4pQKrbHPOXyabNWYeMPQFaSEXByviyg1u0D1WM404xqP
         iRkbsC/Thjtcb4yr7rS+x6sAsYo1TimvzRYSK3GDnNWE2idMAUSJFYlhRaSqPZxY/zAC
         xFSw==
X-Gm-Message-State: APjAAAUPBuhc6P8rSabnxlK/7T67Nugsgdapqlk6PufQSyLCHxPOJiD3
        IFfglZ5cbNaRHucebfmoJ+xVRq/Ppd9/4H9KWWXbL7Iopd4N9Zg32E6ojfUrK+GYcKLlHpZxzlB
        TbG0QhKqjaUIacIda
X-Received: by 2002:a05:651c:8f:: with SMTP id 15mr6763375ljq.109.1576774772595;
        Thu, 19 Dec 2019 08:59:32 -0800 (PST)
X-Google-Smtp-Source: APXvYqzhzAk06AnWNSsOXuDYDdgrouti3i9ncVXsU5b1ct6nC/BdZGwcfsJxSEzEce7UZBH9WoThTg==
X-Received: by 2002:a05:651c:8f:: with SMTP id 15mr6763361ljq.109.1576774772337;
        Thu, 19 Dec 2019 08:59:32 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id k23sm3241541ljj.85.2019.12.19.08.59.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Dec 2019 08:59:31 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id A9AAA180969; Thu, 19 Dec 2019 17:59:29 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Yonghong Song <yhs@fb.com>, Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        David Miller <davem@davemloft.net>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf\@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH RFC bpf-next 2/3] libbpf: Handle function externs and support static linking
In-Reply-To: <d220154c-6aad-4bc1-ab86-6ae72e351dca@fb.com>
References: <157676577049.957277.3346427306600998172.stgit@toke.dk> <157676577267.957277.6240503077867756432.stgit@toke.dk> <d220154c-6aad-4bc1-ab86-6ae72e351dca@fb.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 19 Dec 2019 17:59:29 +0100
Message-ID: <87v9qc2qvi.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Yonghong Song <yhs@fb.com> writes:

> On 12/19/19 6:29 AM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>>=20
>> This adds support for resolving function externs to libbpf, with a new A=
PI
>> to resolve external function calls by static linking at load-time. The A=
PI
>> for this requires the caller to supply the object files containing the
>> target functions, and to specify an explicit mapping between extern
>> function names in the calling program, and function names in the target
>> object file. This is to support the XDP multi-prog case, where the
>> dispatcher program may not necessarily have control over function names =
in
>> the target programs, so simple function name resolution can't be used.
>>=20
>> The target object files must be loaded into the kernel before the calling
>> program, to ensure all relocations are done on the target functions, so =
we
>> can just copy over the instructions.
>>=20
>> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>> ---
>>   tools/lib/bpf/btf.c    |   10 +-
>>   tools/lib/bpf/libbpf.c |  268 +++++++++++++++++++++++++++++++++++++++-=
--------
>>   tools/lib/bpf/libbpf.h |   17 +++
>>   3 files changed, 244 insertions(+), 51 deletions(-)
>>=20
>> diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
>> index 5f04f56e1eb6..2740d4a6b2eb 100644
>> --- a/tools/lib/bpf/btf.c
>> +++ b/tools/lib/bpf/btf.c
>> @@ -246,6 +246,7 @@ __s64 btf__resolve_size(const struct btf *btf, __u32=
 type_id)
>>   			size =3D t->size;
>>   			goto done;
>>   		case BTF_KIND_PTR:
>> +		case BTF_KIND_FUNC_PROTO:
>>   			size =3D sizeof(void *);
>>   			goto done;
>>   		case BTF_KIND_TYPEDEF:
>> @@ -288,6 +289,7 @@ int btf__align_of(const struct btf *btf, __u32 id)
>>   	case BTF_KIND_ENUM:
>>   		return min(sizeof(void *), t->size);
>>   	case BTF_KIND_PTR:
>> +	case BTF_KIND_FUNC_PROTO:
>>   		return sizeof(void *);
>>   	case BTF_KIND_TYPEDEF:
>>   	case BTF_KIND_VOLATILE:
>> @@ -640,12 +642,16 @@ int btf__finalize_data(struct bpf_object *obj, str=
uct btf *btf)
>>   		 */
>>   		if (btf_is_datasec(t)) {
>>   			err =3D btf_fixup_datasec(obj, btf, t);
>> -			if (err)
>> +			/* FIXME: With function externs we can get a BTF DATASEC
>> +			 * entry for .extern, but the section doesn't exist; so
>> +			 * make ENOENT non-fatal
>> +			 */
>> +			if (err && err !=3D -ENOENT)
>>   				break;
>>   		}
>>   	}
>>=20=20=20
>> -	return err;
>> +	return err =3D=3D -ENOENT ? err : 0;
>>   }
>>=20=20=20
>>   int btf__load(struct btf *btf)
>> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
>> index 266b725e444b..b2c0a2f927e7 100644
>> --- a/tools/lib/bpf/libbpf.c
>> +++ b/tools/lib/bpf/libbpf.c
>> @@ -172,13 +172,17 @@ enum reloc_type {
>>   	RELO_CALL,
>>   	RELO_DATA,
>>   	RELO_EXTERN,
>> +	RELO_EXTERN_CALL,
>>   };
>>=20=20=20
>> +struct extern_desc;
>> +
>>   struct reloc_desc {
>>   	enum reloc_type type;
>>   	int insn_idx;
>>   	int map_idx;
>>   	int sym_off;
>> +	struct extern_desc *ext;
>>   };
>>=20=20=20
>>   /*
>> @@ -274,6 +278,7 @@ enum extern_type {
>>   	EXT_INT,
>>   	EXT_TRISTATE,
>>   	EXT_CHAR_ARR,
>> +	EXT_FUNC
>>   };
>>=20=20=20
>>   struct extern_desc {
>> @@ -287,6 +292,7 @@ struct extern_desc {
>>   	bool is_signed;
>>   	bool is_weak;
>>   	bool is_set;
>> +	struct bpf_program *tgt_prog;
>>   };
>>=20=20=20
>>   static LIST_HEAD(bpf_objects_list);
>> @@ -305,6 +311,7 @@ struct bpf_object {
>>   	char *kconfig;
>>   	struct extern_desc *externs;
>>   	int nr_extern;
>> +	int nr_data_extern;
>>   	int kconfig_map_idx;
>>=20=20=20
>>   	bool loaded;
>> @@ -1041,6 +1048,7 @@ static int set_ext_value_tri(struct extern_desc *e=
xt, void *ext_val,
>>   	case EXT_UNKNOWN:
>>   	case EXT_INT:
>>   	case EXT_CHAR_ARR:
>> +	case EXT_FUNC:
>>   	default:
>>   		pr_warn("extern %s=3D%c should be bool, tristate, or char\n",
>>   			ext->name, value);
>> @@ -1281,7 +1289,7 @@ static int bpf_object__init_kconfig_map(struct bpf=
_object *obj)
>>   	size_t map_sz;
>>   	int err;
>>=20=20=20
>> -	if (obj->nr_extern =3D=3D 0)
>> +	if (obj->nr_data_extern =3D=3D 0)
>>   		return 0;
>>=20=20=20
>>   	last_ext =3D &obj->externs[obj->nr_extern - 1];
>> @@ -1822,29 +1830,51 @@ static void bpf_object__sanitize_btf(struct bpf_=
object *obj)
>>   	struct btf_type *t;
>>   	int i, j, vlen;
>>=20=20=20
>> -	if (!obj->btf || (has_func && has_datasec))
>> +	if (!obj->btf)
>>   		return;
>> -
>>   	for (i =3D 1; i <=3D btf__get_nr_types(btf); i++) {
>>   		t =3D (struct btf_type *)btf__type_by_id(btf, i);
>>=20=20=20
>> -		if (!has_datasec && btf_is_var(t)) {
>> -			/* replace VAR with INT */
>> -			t->info =3D BTF_INFO_ENC(BTF_KIND_INT, 0, 0);
>> -			/*
>> -			 * using size =3D 1 is the safest choice, 4 will be too
>> -			 * big and cause kernel BTF validation failure if
>> -			 * original variable took less than 4 bytes
>> +		if (btf_is_var(t)) {
>> +			struct btf_type *var_t;
>> +
>> +			var_t =3D (struct btf_type *)btf__type_by_id(btf,
>> +								   t->type);
>> +
>> +			/* FIXME: The kernel doesn't understand func_proto with
>> +			 * BTF_VAR_GLOBAL_EXTERN linkage, so we just replace
>> +			 * them with INTs here. What's the right thing to do?
>>   			 */
>> -			t->size =3D 1;
>> -			*(int *)(t + 1) =3D BTF_INT_ENC(0, 0, 8);
>> -		} else if (!has_datasec && btf_is_datasec(t)) {
>> +			if (!has_datasec ||
>> +			    (btf_kind(var_t) =3D=3D BTF_KIND_FUNC_PROTO &&
>> +			     btf_var(t)->linkage =3D=3D BTF_VAR_GLOBAL_EXTERN)) {
>
> You are the first user to use extern function encoding in BTF! Thanks!

Haha, you're welcome!

And yeah, I realise this is pretty bleeding edge stuff, and as you can
probably tell I'm sort of fumbling my way forward here ;)

> Recently, we have discussion with Alexei and felt that putting extern=20
> function into datasec/var is not pretty. So we have the following llvm pa=
tch
>     https://reviews.llvm.org/D71638
> to put extern function as a BTF_KIND_FUNC, i.e.,
>     BTF_KIND_FUNC
>          .info (lower 2 bits) -> FUNC_STATIC, FUNC_GLOBAL, FUNC_EXTERN
>          .type -> BTF_KIND_FUNC_PROTO
>
> Alexei is working on kernel side to ensure this is handled properly=20
> before llvm patch can be merged.
>
> Just let you know for the future potential BTF interface change.

OK, thanks for the head's up. And yeah, I agree this sounds like an
improvement; I was a little puzzled by the datasec/var thing, and a lot
of the weird hacks I had to do were related to working around that. So
if this is just going to go away, that's great!

If you guys can look the rest of the patch over and give me some
pointers on the other FIXME items (and the API), that would be great! No
great rush, though; I'm leaving for the holidays tomorrow, so won't have
any more time to work on this before the new year. I guess I'll and see
how far along the kernel/llvm changes are, and deal with any other
feedback you guys have by then. :)

-Toke

