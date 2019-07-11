Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6A386563A
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 13:59:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728528AbfGKL7R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jul 2019 07:59:17 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:39358 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727974AbfGKL7Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jul 2019 07:59:16 -0400
Received: by mail-wr1-f65.google.com with SMTP id x4so5979067wrt.6
        for <netdev@vger.kernel.org>; Thu, 11 Jul 2019 04:59:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=5vu72Pa+XWsA3e7pdSb3CfwSv7O8asY1FTsoovcZqqk=;
        b=hkmlNV2GBd8+/pJPC+lKCOCvPbjB+R/bJYeo79Tdtc0ATDPcH7l+Yfz4W5+m0qBiaj
         jYQU8/RH36FdRnhTStebAPlL5JWBNSdw/kDHfYMVpFHF3taMv3UlwHT4leejodTg5Jr1
         KlxH669NUD/mEOCoHAI6tn4VA3xgNGmMJT4W6bUcX7LnKjHTgxFfHP5POt53DztUP5PV
         UBNh7MXrP5Tngw+v+Rz0J2tdgzhmB4ePZF/Jt4xYLGZHFIckAZZZUMzBc7eIBXS82PBX
         n3Cu7E9uJ9U5aYDcEVhyu5N6nwVCUpGsi+Noj1KFK12DgvQGXXTWerpqAalFXZDv/umC
         fM+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=5vu72Pa+XWsA3e7pdSb3CfwSv7O8asY1FTsoovcZqqk=;
        b=dlcqy7mwnqEI1Y8cM6qsBm2vaPVMLGJW6ARfgmH56h7VxpcrjiSypEP4Ueb8MVhwPK
         +T4SUheXwhjKuyIPFTgCkXoODUu+8DMqW/eC+MRwTH+kVHKddlfsfUOL66Mz0kFaL07N
         1VJFLVVR3RHYnr56I4/x4e4UiCn16XwrGyUPDipbeZxoE4i9tP3WbGuVF1DamvtuK9jg
         dGkM74QjOrGUrBGCLLjkOuzwcJspC/K+kftBWM7P8aPcJFLxzIp2cqTv+/rxl3zmnGm+
         l/ns0xr0+/RSLhZ8AuTAS6/3MdPliUQkyx6HUwfWuqTx1Oz6gCbfz8gS1AqmJOu5sv4A
         wc4Q==
X-Gm-Message-State: APjAAAUCiaPH7ENfx9pgFZbsFfnZE/NU98PrVcewkW5Aj+glZsPpD+va
        l8UXQz9KHN0gNjbw3baNllB8Vw==
X-Google-Smtp-Source: APXvYqwyv17KUcCwDg2uwOLKfzKaFEJTxfy0XN/Gczu9/uuEoDLNSSsyUj3ushp5tBc8v/nro+sz+g==
X-Received: by 2002:adf:ec49:: with SMTP id w9mr4630060wrn.303.1562846353921;
        Thu, 11 Jul 2019 04:59:13 -0700 (PDT)
Received: from LAPTOP-V3S7NLPL ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id q1sm4648133wmq.25.2019.07.11.04.59.13
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 11 Jul 2019 04:59:13 -0700 (PDT)
References: <1562275611-31790-1-git-send-email-jiong.wang@netronome.com> <1562275611-31790-3-git-send-email-jiong.wang@netronome.com> <CAEf4BzaF-Bvj9veA1EYu5GWQrWOu=ttX064YTrB4yNQ4neJZOQ@mail.gmail.com>
User-agent: mu4e 0.9.18; emacs 25.2.2
From:   Jiong Wang <jiong.wang@netronome.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jiong Wang <jiong.wang@netronome.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Edward Cree <ecree@solarflare.com>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        oss-drivers@netronome.com
Subject: Re: [oss-drivers] Re: [RFC bpf-next 2/8] bpf: extend list based insn patching infra to verification layer
In-reply-to: <CAEf4BzaF-Bvj9veA1EYu5GWQrWOu=ttX064YTrB4yNQ4neJZOQ@mail.gmail.com>
Date:   Thu, 11 Jul 2019 12:59:10 +0100
Message-ID: <87o920235d.fsf@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Andrii Nakryiko writes:

> On Thu, Jul 4, 2019 at 2:32 PM Jiong Wang <jiong.wang@netronome.com> wrote:
>>
>> Verification layer also needs to handle auxiliar info as well as adjusting
>> subprog start.
>>
>> At this layer, insns inside patch buffer could be jump, but they should
>> have been resolved, meaning they shouldn't jump to insn outside of the
>> patch buffer. Lineration function for this layer won't touch insns inside
>> patch buffer.
>>
>> Adjusting subprog is finished along with adjusting jump target when the
>> input will cover bpf to bpf call insn, re-register subprog start is cheap.
>> But adjustment when there is insn deleteion is not considered yet.
>>
>> Signed-off-by: Jiong Wang <jiong.wang@netronome.com>
>> ---
>>  kernel/bpf/verifier.c | 150 ++++++++++++++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 150 insertions(+)
>>
>> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
>> index a2e7637..2026d64 100644
>> --- a/kernel/bpf/verifier.c
>> +++ b/kernel/bpf/verifier.c
>> @@ -8350,6 +8350,156 @@ static void opt_hard_wire_dead_code_branches(struct bpf_verifier_env *env)
>>         }
>>  }
>>
>> +/* Linearize bpf list insn to array (verifier layer). */
>> +static struct bpf_verifier_env *
>> +verifier_linearize_list_insn(struct bpf_verifier_env *env,
>> +                            struct bpf_list_insn *list)
>
> It's unclear why this returns env back? It's not allocating a new env,
> so it's weird and unnecessary. Just return error code.

The reason is I was thinking we have two layers in BPF, the core and the
verifier.

For core layer (the relevant file is core.c), when doing patching, the
input is insn list and bpf_prog, the linearization should linearize the
insn list into insn array, and also whatever others affect inside bpf_prog
due to changing on insns, for example line info inside prog->aux. So the
return value is bpf_prog for core layer linearization hook. 

For verifier layer, it is similar, but the context if bpf_verifier_env, the
linearization hook should linearize the insn list, and also those affected
inside env, for example bpf_insn_aux_data, so the return value is
bpf_verifier_env, meaning returning an updated verifier context
(bpf_verifier_env) after insn list linearization.

Make sense?

Regards,
Jiong

>
>> +{
>> +       u32 *idx_map, idx, orig_cnt, fini_cnt = 0;
>> +       struct bpf_subprog_info *new_subinfo;
>> +       struct bpf_insn_aux_data *new_data;
>> +       struct bpf_prog *prog = env->prog;
>> +       struct bpf_verifier_env *ret_env;
>> +       struct bpf_insn *insns, *insn;
>> +       struct bpf_list_insn *elem;
>> +       int ret;
>> +
>> +       /* Calculate final size. */
>> +       for (elem = list; elem; elem = elem->next)
>> +               if (!(elem->flag & LIST_INSN_FLAG_REMOVED))
>> +                       fini_cnt++;
>> +
>> +       orig_cnt = prog->len;
>> +       insns = prog->insnsi;
>> +       /* If prog length remains same, nothing else to do. */
>> +       if (fini_cnt == orig_cnt) {
>> +               for (insn = insns, elem = list; elem; elem = elem->next, insn++)
>> +                       *insn = elem->insn;
>> +               return env;
>> +       }
>> +       /* Realloc insn buffer when necessary. */
>> +       if (fini_cnt > orig_cnt)
>> +               prog = bpf_prog_realloc(prog, bpf_prog_size(fini_cnt),
>> +                                       GFP_USER);
>> +       if (!prog)
>> +               return ERR_PTR(-ENOMEM);
>> +       insns = prog->insnsi;
>> +       prog->len = fini_cnt;
>> +       ret_env = env;
>> +
>> +       /* idx_map[OLD_IDX] = NEW_IDX */
>> +       idx_map = kvmalloc(orig_cnt * sizeof(u32), GFP_KERNEL);
>> +       if (!idx_map)
>> +               return ERR_PTR(-ENOMEM);
>> +       memset(idx_map, 0xff, orig_cnt * sizeof(u32));
>> +
>> +       /* Use the same alloc method used when allocating env->insn_aux_data. */
>> +       new_data = vzalloc(array_size(sizeof(*new_data), fini_cnt));
>> +       if (!new_data) {
>> +               kvfree(idx_map);
>> +               return ERR_PTR(-ENOMEM);
>> +       }
>> +
>> +       /* Copy over insn + calculate idx_map. */
>> +       for (idx = 0, elem = list; elem; elem = elem->next) {
>> +               int orig_idx = elem->orig_idx - 1;
>> +
>> +               if (orig_idx >= 0) {
>> +                       idx_map[orig_idx] = idx;
>> +
>> +                       if (elem->flag & LIST_INSN_FLAG_REMOVED)
>> +                               continue;
>> +
>> +                       new_data[idx] = env->insn_aux_data[orig_idx];
>> +
>> +                       if (elem->flag & LIST_INSN_FLAG_PATCHED)
>> +                               new_data[idx].zext_dst =
>> +                                       insn_has_def32(env, &elem->insn);
>> +               } else {
>> +                       new_data[idx].seen = true;
>> +                       new_data[idx].zext_dst = insn_has_def32(env,
>> +                                                               &elem->insn);
>> +               }
>> +               insns[idx++] = elem->insn;
>> +       }
>> +
>> +       new_subinfo = kvzalloc(sizeof(env->subprog_info), GFP_KERNEL);
>> +       if (!new_subinfo) {
>> +               kvfree(idx_map);
>> +               vfree(new_data);
>> +               return ERR_PTR(-ENOMEM);
>> +       }
>> +       memcpy(new_subinfo, env->subprog_info, sizeof(env->subprog_info));
>> +       memset(env->subprog_info, 0, sizeof(env->subprog_info));
>> +       env->subprog_cnt = 0;
>> +       env->prog = prog;
>> +       ret = add_subprog(env, 0);
>> +       if (ret < 0) {
>> +               ret_env = ERR_PTR(ret);
>> +               goto free_all_ret;
>> +       }
>> +       /* Relocate jumps using idx_map.
>> +        *   old_dst = jmp_insn.old_target + old_pc + 1;
>> +        *   new_dst = idx_map[old_dst] = jmp_insn.new_target + new_pc + 1;
>> +        *   jmp_insn.new_target = new_dst - new_pc - 1;
>> +        */
>> +       for (idx = 0, elem = list; elem; elem = elem->next) {
>> +               int orig_idx = elem->orig_idx;
>> +
>> +               if (elem->flag & LIST_INSN_FLAG_REMOVED)
>> +                       continue;
>> +               if ((elem->flag & LIST_INSN_FLAG_PATCHED) || !orig_idx) {
>> +                       idx++;
>> +                       continue;
>> +               }
>> +
>> +               ret = bpf_jit_adj_imm_off(&insns[idx], orig_idx - 1, idx,
>> +                                         idx_map);
>> +               if (ret < 0) {
>> +                       ret_env = ERR_PTR(ret);
>> +                       goto free_all_ret;
>> +               }
>> +               /* Recalculate subprog start as we are at bpf2bpf call insn. */
>> +               if (ret > 0) {
>> +                       ret = add_subprog(env, idx + insns[idx].imm + 1);
>> +                       if (ret < 0) {
>> +                               ret_env = ERR_PTR(ret);
>> +                               goto free_all_ret;
>> +                       }
>> +               }
>> +               idx++;
>> +       }
>> +       if (ret < 0) {
>> +               ret_env = ERR_PTR(ret);
>> +               goto free_all_ret;
>> +       }
>> +
>> +       env->subprog_info[env->subprog_cnt].start = fini_cnt;
>> +       for (idx = 0; idx <= env->subprog_cnt; idx++)
>> +               new_subinfo[idx].start = env->subprog_info[idx].start;
>> +       memcpy(env->subprog_info, new_subinfo, sizeof(env->subprog_info));
>> +
>> +       /* Adjust linfo.
>> +        * FIXME: no support for insn removal at the moment.
>> +        */
>> +       if (prog->aux->nr_linfo) {
>> +               struct bpf_line_info *linfo = prog->aux->linfo;
>> +               u32 nr_linfo = prog->aux->nr_linfo;
>> +
>> +               for (idx = 0; idx < nr_linfo; idx++)
>> +                       linfo[idx].insn_off = idx_map[linfo[idx].insn_off];
>> +       }
>> +       vfree(env->insn_aux_data);
>> +       env->insn_aux_data = new_data;
>> +       goto free_mem_list_ret;
>> +free_all_ret:
>> +       vfree(new_data);
>> +free_mem_list_ret:
>> +       kvfree(new_subinfo);
>> +       kvfree(idx_map);
>> +       return ret_env;
>> +}
>> +
>>  static int opt_remove_dead_code(struct bpf_verifier_env *env)
>>  {
>>         struct bpf_insn_aux_data *aux_data = env->insn_aux_data;
>> --
>> 2.7.4
>>

