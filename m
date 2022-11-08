Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37D8E6205B9
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 02:22:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232936AbiKHBWq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 20:22:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232075AbiKHBWp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 20:22:45 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 638071A06A;
        Mon,  7 Nov 2022 17:22:44 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id u24so20238087edd.13;
        Mon, 07 Nov 2022 17:22:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=qogEVG2fX+zGMVl9bXIk2ZIpX0dWcbHLBDNY+TfrxQ4=;
        b=jOWOhDrUwS3p4IVFpoZ6YkDH4dkN4bw/5En2W4X97Se/mBin9BPthDJOr68aVU0TZC
         UayHpNLvKTpCrjoj0TmkqEQWWbEq92SWAMudexeHLsqxlM3+5TbBgQW7Z9EJAIJzYnBZ
         dUfknKEkC6dmr1OT2njm08OAogxNFU5XbCU8W5brpdTwrttXCgApuV4vVr2aVYfKVVWH
         h1FDJMYDN5WaVYvG1SGy/TurxUmzONuc747AeZVRvqa+dlO9KT3fPaI+DtsjYrA4x55R
         EAZl5tzAIQbOtUOBinUh0nGWtbMMCZKOjY0d0bgwdcs7cwDpzw+7nFcmaALnTEyUgIzH
         5XlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qogEVG2fX+zGMVl9bXIk2ZIpX0dWcbHLBDNY+TfrxQ4=;
        b=R6KSjCWzUxxVtMylz3A9pyqsdcspWfHJYweJImIPTGttTJ07b3U1ILScTZZEmYZs2K
         KjTnSfku3U60hTiZ7U9vGddckBFzpHzSoYHgo+TNE5Dm07UftBCASU3mwgyV9aHvEhAT
         HbSj2id8xA0VQi9DaMyY63YuLH6Gum3eXUrCwCzlys8z/w4fLv68t4GgFfgIF1X0+LE9
         zrstlSxu/2yiyZzsM3u4kzUpTkGfFaCR46j3RzVrHHcUjyeJ75Q9+ewTZZ7cSPSsXFLT
         eplvyCmAGMestUBbWkolJrwhPSlmBFZZ/8GTG54hkSLILyXRGH0kavm3k54Md8o3uulk
         BMjQ==
X-Gm-Message-State: ACrzQf0Y0PoggLrYx2EhoMi+6XkhmGyRc1FBk220Uk059BHBSuyaGot3
        7dWgWwGjZbqD50n2zhyCP5ECooY6yWC7S6xCRVg=
X-Google-Smtp-Source: AMsMyM73SWtfWOixjC5sjgHIO9B7+8yTA1q/o+5ymiX1BM2pBNcxWX8uhsj+de/eJ3hYoHbavNeZymTaAXtp7j56ynI=
X-Received: by 2002:a05:6402:951:b0:459:aa70:d4b6 with SMTP id
 h17-20020a056402095100b00459aa70d4b6mr871932edz.224.1667870562814; Mon, 07
 Nov 2022 17:22:42 -0800 (PST)
MIME-Version: 1.0
References: <20221107092032.178235-1-yangjihong1@huawei.com> <20221107092032.178235-4-yangjihong1@huawei.com>
In-Reply-To: <20221107092032.178235-4-yangjihong1@huawei.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 7 Nov 2022 17:22:30 -0800
Message-ID: <CAEf4BzZd+hzeRhLD6DaDVx67fySd+KaTP6eOJid-u9mqnQwigg@mail.gmail.com>
Subject: Re: [PATCH bpf v2 3/5] libbpf: Skip adjust mem size for load pointer
 in 32-bit arch in CO_RE
To:     Yang Jihong <yangjihong1@huawei.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, illusionist.neo@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, mykolal@fb.com,
        shuah@kernel.org, benjamin.tissoires@redhat.com, memxor@gmail.com,
        asavkov@redhat.com, delyank@fb.com, bpf@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 7, 2022 at 1:23 AM Yang Jihong <yangjihong1@huawei.com> wrote:
>
> bpf_core_patch_insn modifies load's mem size from 8 bytes to 4 bytes.
> As a result, the bpf check fails, we need to skip adjust mem size to fit
> the verifier.
>
> Signed-off-by: Yang Jihong <yangjihong1@huawei.com>
> ---
>  tools/lib/bpf/libbpf.c | 34 +++++++++++++++++++++++++++++-----
>  1 file changed, 29 insertions(+), 5 deletions(-)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 184ce1684dcd..e1c21b631a0b 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -5634,6 +5634,28 @@ static int bpf_core_resolve_relo(struct bpf_program *prog,
>                                        targ_res);
>  }
>
> +static bool
> +bpf_core_patch_insn_skip(const struct btf *local_btf, const struct bpf_insn *insn,
> +                        const struct bpf_core_relo_res *res)
> +{
> +       __u8 class;
> +       const struct btf_type *orig_t;
> +
> +       class = BPF_CLASS(insn->code);
> +       orig_t = btf_type_by_id(local_btf, res->orig_type_id);
> +
> +       /*
> +        * verifier has to see a load of a pointer as a 8-byte load,
> +        * CO_RE should not screws up access, bpf_core_patch_insn modifies
> +        * load's mem size from 8 bytes to 4 bytes in 32-bit arch,
> +        * so we skip adjust mem size.
> +        */

Nope, this is only for BPF UAPI context types like __sk_buff (right
now). fentry/fexit/raw_tp_btf programs traversing kernel types and
following pointers actually need this to work correctly. Don't do
this.

> +       if (class == BPF_LDX && btf_is_ptr(orig_t))
> +               return true;
> +
> +       return false;
> +}
> +
>  static int
>  bpf_object__relocate_core(struct bpf_object *obj, const char *targ_btf_path)
>  {
> @@ -5730,11 +5752,13 @@ bpf_object__relocate_core(struct bpf_object *obj, const char *targ_btf_path)
>                                 goto out;
>                         }
>
> -                       err = bpf_core_patch_insn(prog->name, insn, insn_idx, rec, i, &targ_res);
> -                       if (err) {
> -                               pr_warn("prog '%s': relo #%d: failed to patch insn #%u: %d\n",
> -                                       prog->name, i, insn_idx, err);
> -                               goto out;
> +                       if (!bpf_core_patch_insn_skip(obj->btf, insn, &targ_res)) {
> +                               err = bpf_core_patch_insn(prog->name, insn, insn_idx, rec, i, &targ_res);
> +                               if (err) {
> +                                       pr_warn("prog '%s': relo #%d: failed to patch insn #%u: %d\n",
> +                                               prog->name, i, insn_idx, err);
> +                                       goto out;
> +                               }
>                         }
>                 }
>         }
> --
> 2.30.GIT
>
