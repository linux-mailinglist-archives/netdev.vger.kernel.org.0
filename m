Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28E2849590E
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 05:59:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233829AbiAUE7Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 23:59:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231278AbiAUE7X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 23:59:23 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8F40C061574;
        Thu, 20 Jan 2022 20:59:23 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id v11-20020a17090a520b00b001b512482f36so5255167pjh.3;
        Thu, 20 Jan 2022 20:59:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QgZSkP5p5Dow30aome2sRmL62BpV73veAqG3YYmna/k=;
        b=Zjn5sHqCtTDbCHBQQLnbgMKVRWzfwlRxX735uZgHsjQoKMAuIXMHwRWBp3FH69+NxD
         1CYzg/deHxJZ7iQN4sStGRamUybHVBzBk9h+7KhRTfGsxv+elwlwakmaGD7XKjDo1QMi
         6QidxpbUHqs2aLS6CLha2nwHo9sScU+um9gPXU2zuQrmWTc3C0DwwzJSdtzOtGThiFgF
         7YL6Rrizl+Iu7Suzabr7us6P/Fu5IvpuXL7d4KHJY3sP+M+G8dqZBQnynvmoP7/A3Xnn
         vU4Ru41+nNPinXxv1Qzf54NqDrJH/tdBlwgQFEtBf8M4yZEQN05xOSl9YsEEkhhUmM4n
         PlbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QgZSkP5p5Dow30aome2sRmL62BpV73veAqG3YYmna/k=;
        b=13AoOuPno8CgGmqTBQ7j9UTnyFMGRqlm6CmPpDa39k8DvUl2tfurPwQMXR43ovIbmF
         dTimxS0X4tnPbS70M8O1t2PtjGf0PbsXM7XrgfV73g0DULIWBZ3QUthuVph+ahC/PE1R
         aVdZlPmEUDEP+wD4ObgmHBKrO84wp+/qbwCqKWpaQe51LLePbzZT9eFLI1b+n5yhCVMu
         4gPorh6GZytWGuoXGCQMjGIKqK16iy2E/m0M77AhlWipwBfjX3mhKIo8/xQe4U5wypOv
         lR6efdQNdmBmMQjsYlBxmUjzy7fOixeSSey5lvNEPErIq3aMrTRpFoYL+8GLt+DToM21
         cU4w==
X-Gm-Message-State: AOAM530H8ctRwuauo+gf6N7WhWo6k8tSy5QPwewZ1+bEkhhf2kTCzfPd
        +mJzgAGb+Fu2DhX1KGyIkPfPRI0Tu4+gMGSf4wJPx/cIXqw=
X-Google-Smtp-Source: ABdhPJxoJN90Pq24cjwYZk9fCfpFC8HBmIYeUcSOEF1/6D9dcSMx2LMK7ldbE7GppTRMiHoXlBsyFkbisoutav9e1fI=
X-Received: by 2002:a17:902:860c:b0:149:1017:25f0 with SMTP id
 f12-20020a170902860c00b00149101725f0mr2466391plo.116.1642741163046; Thu, 20
 Jan 2022 20:59:23 -0800 (PST)
MIME-Version: 1.0
References: <20220120191306.1801459-1-song@kernel.org> <20220120191306.1801459-8-song@kernel.org>
In-Reply-To: <20220120191306.1801459-8-song@kernel.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 20 Jan 2022 20:59:11 -0800
Message-ID: <CAADnVQL-TAZD6BbN-sXDpAs0OHFWGg3e=RafBQ10=ExXESNQgg@mail.gmail.com>
Subject: Re: [PATCH v5 bpf-next 7/7] bpf, x86_64: use bpf_prog_pack allocator
To:     Song Liu <song@kernel.org>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Kernel Team <kernel-team@fb.com>,
        Peter Zijlstra <peterz@infradead.org>, X86 ML <x86@kernel.org>,
        Song Liu <songliubraving@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 20, 2022 at 11:13 AM Song Liu <song@kernel.org> wrote:
>
> From: Song Liu <songliubraving@fb.com>
>
> Use bpf_prog_pack allocator in x86_64 jit.
>
> The program header from bpf_prog_pack is read only during the jit process.
> Therefore, the binary is first written to a temporary buffer, and later
> copied to final location with text_poke_copy().
>
> Similarly, jit_fill_hole() is updated to fill the hole with 0xcc using
> text_poke_copy().
>
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>  arch/x86/net/bpf_jit_comp.c | 134 +++++++++++++++++++++++++++---------
>  1 file changed, 103 insertions(+), 31 deletions(-)
>
> diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
> index fe4f08e25a1d..6d97f7c24df2 100644
> --- a/arch/x86/net/bpf_jit_comp.c
> +++ b/arch/x86/net/bpf_jit_comp.c
> @@ -216,11 +216,34 @@ static u8 simple_alu_opcodes[] = {
>         [BPF_ARSH] = 0xF8,
>  };
>
> +static char jit_hole_buffer[PAGE_SIZE] = {};

Let's not waste a page filled with 0xcc.
The pack allocator will reserve 128 bytes at the front
and will round up the tail to 64 bytes.
So this can be a 128 byte array?

> +
>  static void jit_fill_hole(void *area, unsigned int size)
> +{
> +       struct bpf_binary_header *hdr = area;
> +       int i;
> +
> +       for (i = 0; i < roundup(size, PAGE_SIZE); i += PAGE_SIZE) {

multi page 0xcc-ing?
Is it because bpf_jit_binary_alloc_pack() allocates 2MB
and then populates the whole thing with this?
Seems overkill.
0xcc in the front of the prog and in the back is there
to catch JIT bugs.
No need to fill 2MB with it.


> +               int s;
> +
> +               s = min_t(int, PAGE_SIZE, size - i);
> +               text_poke_copy(area + i, jit_hole_buffer, s);
> +       }
> +
> +       /*
> +        * bpf_jit_binary_alloc_pack cannot write size directly to the ro
> +        * mapping. Write it here with text_poke_copy().
> +        */
> +       text_poke_copy(&hdr->size, &size, sizeof(size));
> +}
> +
> +static int __init x86_jit_fill_hole_init(void)
>  {
>         /* Fill whole space with INT3 instructions */
> -       memset(area, 0xcc, size);
> +       memset(jit_hole_buffer, 0xcc, PAGE_SIZE);
> +       return 0;
>  }
> +pure_initcall(x86_jit_fill_hole_init);
>
>  struct jit_context {
>         int cleanup_addr; /* Epilogue code offset */
> @@ -361,14 +384,11 @@ static int __bpf_arch_text_poke(void *ip, enum bpf_text_poke_type t,
>
>         ret = -EBUSY;
>         mutex_lock(&text_mutex);
> -       if (memcmp(ip, old_insn, X86_PATCH_SIZE))
> +       if (text_live && memcmp(ip, old_insn, X86_PATCH_SIZE))
>                 goto out;
>         ret = 1;
>         if (memcmp(ip, new_insn, X86_PATCH_SIZE)) {
> -               if (text_live)
> -                       text_poke_bp(ip, new_insn, X86_PATCH_SIZE, NULL);
> -               else
> -                       memcpy(ip, new_insn, X86_PATCH_SIZE);
> +               text_poke_bp(ip, new_insn, X86_PATCH_SIZE, NULL);
>                 ret = 0;
>         }
>  out:
> @@ -537,7 +557,7 @@ static void emit_bpf_tail_call_direct(struct bpf_jit_poke_descriptor *poke,
>         *pprog = prog;
>  }
>
> -static void bpf_tail_call_direct_fixup(struct bpf_prog *prog)
> +static void bpf_tail_call_direct_fixup(struct bpf_prog *prog, bool text_live)
>  {
>         struct bpf_jit_poke_descriptor *poke;
>         struct bpf_array *array;
> @@ -558,24 +578,15 @@ static void bpf_tail_call_direct_fixup(struct bpf_prog *prog)
>                 mutex_lock(&array->aux->poke_mutex);
>                 target = array->ptrs[poke->tail_call.key];
>                 if (target) {
> -                       /* Plain memcpy is used when image is not live yet
> -                        * and still not locked as read-only. Once poke
> -                        * location is active (poke->tailcall_target_stable),
> -                        * any parallel bpf_arch_text_poke() might occur
> -                        * still on the read-write image until we finally
> -                        * locked it as read-only. Both modifications on
> -                        * the given image are under text_mutex to avoid
> -                        * interference.
> -                        */
>                         ret = __bpf_arch_text_poke(poke->tailcall_target,
>                                                    BPF_MOD_JUMP, NULL,
>                                                    (u8 *)target->bpf_func +
> -                                                  poke->adj_off, false);
> +                                                  poke->adj_off, text_live);
>                         BUG_ON(ret < 0);
>                         ret = __bpf_arch_text_poke(poke->tailcall_bypass,
>                                                    BPF_MOD_JUMP,
>                                                    (u8 *)poke->tailcall_target +
> -                                                  X86_PATCH_SIZE, NULL, false);
> +                                                  X86_PATCH_SIZE, NULL, text_live);
>                         BUG_ON(ret < 0);
>                 }
>                 WRITE_ONCE(poke->tailcall_target_stable, true);
> @@ -867,7 +878,7 @@ static void emit_nops(u8 **pprog, int len)
>
>  #define INSN_SZ_DIFF (((addrs[i] - addrs[i - 1]) - (prog - temp)))
>
> -static int do_jit(struct bpf_prog *bpf_prog, int *addrs, u8 *image,
> +static int do_jit(struct bpf_prog *bpf_prog, int *addrs, u8 *image, u8 *tmp_image,
>                   int oldproglen, struct jit_context *ctx, bool jmp_padding)
>  {
>         bool tail_call_reachable = bpf_prog->aux->tail_call_reachable;
> @@ -894,8 +905,8 @@ static int do_jit(struct bpf_prog *bpf_prog, int *addrs, u8 *image,
>         push_callee_regs(&prog, callee_regs_used);
>
>         ilen = prog - temp;
> -       if (image)
> -               memcpy(image + proglen, temp, ilen);
> +       if (tmp_image)
> +               memcpy(tmp_image + proglen, temp, ilen);
>         proglen += ilen;
>         addrs[0] = proglen;
>         prog = temp;
> @@ -1324,8 +1335,10 @@ st:                      if (is_imm8(insn->off))
>                                         pr_err("extable->insn doesn't fit into 32-bit\n");
>                                         return -EFAULT;
>                                 }
> -                               ex->insn = delta;
> +                               /* switch ex to temporary buffer for writes */
> +                               ex = (void *)tmp_image + ((void *)ex - (void *)image);
>
> +                               ex->insn = delta;
>                                 ex->type = EX_TYPE_BPF;
>
>                                 if (dst_reg > BPF_REG_9) {
> @@ -1706,7 +1719,7 @@ st:                       if (is_imm8(insn->off))
>                                 pr_err("bpf_jit: fatal error\n");
>                                 return -EFAULT;
>                         }
> -                       memcpy(image + proglen, temp, ilen);
> +                       memcpy(tmp_image + proglen, temp, ilen);
>                 }
>                 proglen += ilen;
>                 addrs[i] = proglen;
> @@ -2248,8 +2261,10 @@ int arch_prepare_bpf_dispatcher(void *image, s64 *funcs, int num_funcs)
>
>  struct x64_jit_data {
>         struct bpf_binary_header *header;
> +       struct bpf_binary_header *tmp_header;
>         int *addrs;
>         u8 *image;
> +       u8 *tmp_image;

Why add these two fields here?
With new logic header and image will be zero always?
Maybe rename them instead?
Or both used during JIT-ing?

>         int proglen;
>         struct jit_context ctx;
>  };
> @@ -2259,6 +2274,7 @@ struct x64_jit_data {
>
>  struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
>  {
> +       struct bpf_binary_header *tmp_header = NULL;
>         struct bpf_binary_header *header = NULL;
>         struct bpf_prog *tmp, *orig_prog = prog;
>         struct x64_jit_data *jit_data;
> @@ -2267,6 +2283,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
>         bool tmp_blinded = false;
>         bool extra_pass = false;
>         bool padding = false;
> +       u8 *tmp_image = NULL;
>         u8 *image = NULL;
>         int *addrs;
>         int pass;
> @@ -2301,7 +2318,9 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
>                 ctx = jit_data->ctx;
>                 oldproglen = jit_data->proglen;
>                 image = jit_data->image;
> +               tmp_image = jit_data->tmp_image;
>                 header = jit_data->header;
> +               tmp_header = jit_data->tmp_header;
>                 extra_pass = true;
>                 padding = true;
>                 goto skip_init_addrs;
> @@ -2332,14 +2351,18 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
>         for (pass = 0; pass < MAX_PASSES || image; pass++) {
>                 if (!padding && pass >= PADDING_PASSES)
>                         padding = true;
> -               proglen = do_jit(prog, addrs, image, oldproglen, &ctx, padding);
> +               proglen = do_jit(prog, addrs, image, tmp_image, oldproglen, &ctx, padding);
>                 if (proglen <= 0) {
>  out_image:
>                         image = NULL;
> -                       if (header)
> -                               bpf_jit_binary_free(header);
> +                       tmp_image = NULL;
> +                       if (header) {
> +                               bpf_jit_binary_free_pack(header);
> +                               kfree(tmp_header);
> +                       }
>                         prog = orig_prog;
>                         header = NULL;
> +                       tmp_header = NULL;
>                         goto out_addrs;
>                 }
>                 if (image) {
> @@ -2362,13 +2385,27 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
>                                 sizeof(struct exception_table_entry);
>
>                         /* allocate module memory for x86 insns and extable */
> -                       header = bpf_jit_binary_alloc(roundup(proglen, align) + extable_size,
> -                                                     &image, align, jit_fill_hole);
> +                       header = bpf_jit_binary_alloc_pack(roundup(proglen, align) + extable_size,
> +                                                          &image, align, jit_fill_hole);
>                         if (!header) {
>                                 prog = orig_prog;
>                                 goto out_addrs;
>                         }
> -                       prog->aux->extable = (void *) image + roundup(proglen, align);
> +                       if (header->size > bpf_prog_pack_max_size()) {
> +                               tmp_header = header;
> +                               tmp_image = image;
> +                       } else {
> +                               tmp_header = kzalloc(header->size, GFP_KERNEL);

the header->size could be just below 2MB.
I don't think kzalloc() can handle that.

> +                               if (!tmp_header) {
> +                                       bpf_jit_binary_free_pack(header);
> +                                       header = NULL;
> +                                       prog = orig_prog;
> +                                       goto out_addrs;
> +                               }
> +                               tmp_header->size = header->size;
> +                               tmp_image = (void *)tmp_header + ((void *)image - (void *)header);

Why is 'tmp_image' needed at all?
The above math can be done where necessary.

> +                       }
> +                       prog->aux->extable = (void *)image + roundup(proglen, align);

I suspect if you didn't remove the space between (void *) and image
the diff would be less confusing.
This line didn't change, right?

>                 }
>                 oldproglen = proglen;
>                 cond_resched();
> @@ -2379,14 +2416,24 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
>
>         if (image) {
>                 if (!prog->is_func || extra_pass) {
> -                       bpf_tail_call_direct_fixup(prog);
> -                       bpf_jit_binary_lock_ro(header);
> +                       if (header->size > bpf_prog_pack_max_size()) {
> +                               /*
> +                                * bpf_prog_pack cannot handle too big
> +                                * program (> ~2MB). Fall back to regular
> +                                * module_alloc(), and do the fixup and
> +                                * lock_ro here.
> +                                */
> +                               bpf_tail_call_direct_fixup(prog, false);
> +                               bpf_jit_binary_lock_ro(header);
> +                       }
>                 } else {
>                         jit_data->addrs = addrs;
>                         jit_data->ctx = ctx;
>                         jit_data->proglen = proglen;
>                         jit_data->image = image;
> +                       jit_data->tmp_image = tmp_image;
>                         jit_data->header = header;
> +                       jit_data->tmp_header = tmp_header;
>                 }
>                 prog->bpf_func = (void *)image;
>                 prog->jited = 1;
> @@ -2402,6 +2449,17 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
>                 kvfree(addrs);
>                 kfree(jit_data);
>                 prog->aux->jit_data = NULL;
> +               jit_data = NULL;
> +               if (tmp_header != header) {
> +                       text_poke_copy(header, tmp_header, header->size);
> +                       kfree(tmp_header);
> +                       /*
> +                        * Do the fixup after final text_poke_copy().
> +                        * Otherwise, the fix up will be overwritten by
> +                        * text_poke_copy().
> +                        */
> +                       bpf_tail_call_direct_fixup(prog, true);
> +               }
>         }
>  out:
>         if (tmp_blinded)
> @@ -2415,3 +2473,17 @@ bool bpf_jit_supports_kfunc_call(void)
>  {
>         return true;
>  }
> +
> +void bpf_jit_free(struct bpf_prog *fp)
> +{
> +       if (fp->jited) {
> +               struct bpf_binary_header *hdr = bpf_jit_binary_hdr(fp);
> +
> +               if (hdr->size > bpf_prog_pack_max_size())
> +                       bpf_jit_binary_free(hdr);
> +               else
> +                       bpf_jit_binary_free_pack(hdr);
> +       }
> +
> +       bpf_prog_unlock_free(fp);
> +}
> --
> 2.30.2
>
