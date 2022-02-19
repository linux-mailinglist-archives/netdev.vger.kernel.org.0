Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 434714BC9CF
	for <lists+netdev@lfdr.de>; Sat, 19 Feb 2022 19:27:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241937AbiBSS1r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Feb 2022 13:27:47 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229800AbiBSS1q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Feb 2022 13:27:46 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BB4B6595;
        Sat, 19 Feb 2022 10:27:27 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id 195so10638311pgc.6;
        Sat, 19 Feb 2022 10:27:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cDOVwdPhJtRuD2UM+h4JisNaLV7i5u67kH/eR6cZvr8=;
        b=Q5sd5JuV4/abAzu+n7UjrlM2u7pgD/y/T5zQTYhee0arZyF40iBngJnv3/Tk5Vj8EZ
         kgA2Mj52p5fKbuooYtWnyTzmiZaO6co8ZmyVDHWIa4n8VMKg4WNmWcCvluqiCtI5VM6y
         DaXvQs/Ue7zBR6bBkRDM/UA41wUB36uvJdu4WxDIKi2W+FXnbXMBGxC/gOBvj84GpIlI
         KPnX6CIL+LMj8YQJ7Sij+dKms+EIRcnx1y7+gYMqJCFVPBsG35Gx5UAqP8oRBwaemfaW
         d820sJ/2xF4RlgYNiV0POPHt2f44Tp7tyJ/xL9q4t6ze04yA0BjXPJKoc2ufAN7GSdxl
         wIWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cDOVwdPhJtRuD2UM+h4JisNaLV7i5u67kH/eR6cZvr8=;
        b=Z4W3DADSEi2kaEssqKenlVOPdWn8WfozfLcD/wzXSuYOJWbUDjbyxv/0oC/Ct+4jR4
         1d9LE6DCY6gXo+1UHw030WM4YBf1rApfZzgf4HTMTW0TzvT9n8kOe3qnAVc0sA/Rz7AW
         fWZJ/6hcglkMTFellMPICJcAb0QKDA/SVQcBcB0wMsL497w4qlI4oIDqW8GV++kNZwXs
         ZfHbbygM2a8+Y+JstQDyN5+UkdhZqB4Fzdp1uph2cJXzIB75YvnHP5+sVtutpVu0IXHL
         ahZU46ZXy9gIZ54OGMRNZkAnvyyWoc1krih/G3G5xKW6X7rNNTxNbUcdav0C7B+jqsxs
         P6kw==
X-Gm-Message-State: AOAM53131FORBI3w65sXTlC5tu11TZvieM7NYnX0O3RwumW8KFEcAbQV
        cL2aG/NcDNcFHkiupXLJ3Hr0HP0qIIHoisyqpIg=
X-Google-Smtp-Source: ABdhPJx4WvKp5v95IXepuBPyV9QSiIa7pizB0TlATygJlASo0tdKgYaIREFhrKbCpMyAG6pOyUjoBXnYY95g20AdUaQ=
X-Received: by 2002:a05:6a00:809:b0:4f1:14bb:40b1 with SMTP id
 m9-20020a056a00080900b004f114bb40b1mr1675910pfk.69.1645295246766; Sat, 19 Feb
 2022 10:27:26 -0800 (PST)
MIME-Version: 1.0
References: <20220218095612.52082-1-laoar.shao@gmail.com> <20220218095612.52082-3-laoar.shao@gmail.com>
In-Reply-To: <20220218095612.52082-3-laoar.shao@gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sat, 19 Feb 2022 10:27:15 -0800
Message-ID: <CAADnVQJhGmvY1NDsy9WE6tnqYM6JCmi4iZtB7xHuWh4yC-awPw@mail.gmail.com>
Subject: Re: [PATCH RFC 2/3] bpf: set attached cgroup name in attach_name
To:     Yafang Shao <laoar.shao@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 18, 2022 at 1:56 AM Yafang Shao <laoar.shao@gmail.com> wrote:
>
> Set the cgroup path when a bpf prog is attached to a cgroup, and unset
> it when the bpf prog is detached.
>
> Below is the result after this change,
> $ cat progs.debug
>   id name             attached
>    5 dump_bpf_map     bpf_iter_bpf_map
>    7 dump_bpf_prog    bpf_iter_bpf_prog
>   17 bpf_sockmap      cgroup:/
>   19 bpf_redir_proxy
>
> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> ---
>  kernel/bpf/cgroup.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
> index 43eb3501721b..ebd87e54f2d0 100644
> --- a/kernel/bpf/cgroup.c
> +++ b/kernel/bpf/cgroup.c
> @@ -440,6 +440,7 @@ static int __cgroup_bpf_attach(struct cgroup *cgrp,
>         struct bpf_cgroup_storage *storage[MAX_BPF_CGROUP_STORAGE_TYPE] = {};
>         struct bpf_cgroup_storage *new_storage[MAX_BPF_CGROUP_STORAGE_TYPE] = {};
>         enum cgroup_bpf_attach_type atype;
> +       char cgrp_path[64] = "cgroup:";
>         struct bpf_prog_list *pl;
>         struct list_head *progs;
>         int err;
> @@ -508,6 +509,11 @@ static int __cgroup_bpf_attach(struct cgroup *cgrp,
>         else
>                 static_branch_inc(&cgroup_bpf_enabled_key[atype]);
>         bpf_cgroup_storages_link(new_storage, cgrp, type);
> +
> +       cgroup_name(cgrp, cgrp_path + strlen("cgroup:"), 64);
> +       cgrp_path[63] = '\0';
> +       prog->aux->attach_name = kstrdup(cgrp_path, GFP_KERNEL);
> +

This is pure debug code. We cannot have it in the kernel.
Not even under #ifdef.

Please do such debug code on a side as your own bpf program.
For example by kprobe-ing in this function and keeping the path
in a bpf map or send it to user space via ringbuf.
Or enable cgroup tracepoint and monitor cgroup_mkdir with full path.
Record it in user space or in bpf map, etc.

Also please read Documentation/bpf/bpf_devel_QA.rst
bpf patches should be based on bpf-next tree.
These patches are not.
