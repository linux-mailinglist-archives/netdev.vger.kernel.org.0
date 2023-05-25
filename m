Return-Path: <netdev+bounces-5475-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E952C7118AE
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 23:02:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 64FF71C20F46
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 21:02:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 704C423D6C;
	Thu, 25 May 2023 21:02:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D5EE21CF4;
	Thu, 25 May 2023 21:02:36 +0000 (UTC)
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81849E77;
	Thu, 25 May 2023 14:02:06 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id 4fb4d7f45d1cf-510eb980ce2so4423929a12.2;
        Thu, 25 May 2023 14:02:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685048519; x=1687640519;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YF904l5eHXm/D9/gV3iINOpNWwiTaK2N707yQvcmq9Y=;
        b=lS2NlldDNi1wXkeq9yVXGwNGPp3LREHUQnkVypUuFPRSE5788n77GVyq0oVGnkKAVr
         SnpcEx+DKZXCfsmsmEILbTe1BSmPB4gWfNoOVQKwG325JPMT3kOMO2+F9NmNX9FIAL5n
         HJVxvw8ek/b2ZHX8Kr/sPwAs/NG1bvyPOF5SUbzsMb6lODuguyZjxbhHabstcuaJRuKu
         GWNONv6f4lQ8RojMlLmI1WhdTYD040cHVjoElCIJMY7aFa4ukPnKdrCh4dJDz72K1QAe
         iFvXSdCY0W3venDQ3dun6t8MsX3VmD0Tdaz84e5hZtN/eJy7aom9ou/54CQGY5hpMtiz
         ReMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685048519; x=1687640519;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YF904l5eHXm/D9/gV3iINOpNWwiTaK2N707yQvcmq9Y=;
        b=FSjZnhMLm+sDLSS2InGCijFyaKAD6TZ6L60jHn9/8XFzVXdJwcGXSb3zINpnayQ5l/
         MG25wlv7+JMnn3p1RAMRMYNXtmnqTIuF2Z+64EUzxSVpOmGeB2rSWpIGOlrKhED3HEBI
         2U2thi/3EGIl8W4EUHnJGlt/BWeN4ZBmHOfDmwS/gwW+pL1nRTU5JK0zDJhxr87X7hyZ
         QoqU9SMGxhG671t1xyrkZgBh43Z5A/UgZ0p2I1VhnaK/Rf9PEwB0hsFnRAm140O1ZAs7
         +ilH9mhwyzsuAgf+rPF+iRFNYfyf3iA+79R38wfIjt4FbrpTM/zoHxVOcbuYJ9hb3ojh
         34UQ==
X-Gm-Message-State: AC+VfDxianIbT3lD5lk15T/K0cbfofgEA//l+FS2Ga1B81pvLdp1wE4Q
	9RLg8ybU9v5j7TeJu/LqLsFqsJDdr1KMHZALTQ7v7QELOTkAYw==
X-Google-Smtp-Source: ACHHUZ409cMTqW8t4vrvuM50Gn79tH9Zn+d9Ey8Ie2xUuMQhpSkUeh8LZPTTlZZy4jbbsSjDHvCUsDm6VK0fFdB5pVo=
X-Received: by 2002:a17:907:3f83:b0:96f:e5af:ac5f with SMTP id
 hr3-20020a1709073f8300b0096fe5afac5fmr24465ejc.47.1685048518534; Thu, 25 May
 2023 14:01:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230525110100.8212-1-fw@strlen.de> <20230525110100.8212-2-fw@strlen.de>
In-Reply-To: <20230525110100.8212-2-fw@strlen.de>
From: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date: Thu, 25 May 2023 14:01:46 -0700
Message-ID: <CAEf4BzZ69YgrQW7DHCJUT_X+GqMq_ZQQPBwopaJJVGFD5=d5Vg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/2] tools: libbpf: add netfilter link attach helper
To: Florian Westphal <fw@strlen.de>
Cc: bpf@vger.kernel.org, ast@kernel.org, netdev@vger.kernel.org, dxu@dxuuu.xyz, 
	qde@naccy.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 25, 2023 at 4:01=E2=80=AFAM Florian Westphal <fw@strlen.de> wro=
te:
>
> Add new api function: bpf_program__attach_netfilter_opts.
>
> It takes a bpf program (netfilter type), and a pointer to a option struct
> that contains the desired attachment (protocol family, priority, hook
> location, ...).
>
> It returns a pointer to a 'bpf_link' structure or NULL on error.
>
> Next patch adds new netfilter_basic test that uses this function to
> attach a program to a few pf/hook/priority combinations.
>
> Suggested-by: Andrii Nakryiko <andrii.nakryiko@gmail.com>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  tools/lib/bpf/libbpf.c   | 51 ++++++++++++++++++++++++++++++++++++++++
>  tools/lib/bpf/libbpf.h   | 15 ++++++++++++
>  tools/lib/bpf/libbpf.map |  1 +
>  3 files changed, 67 insertions(+)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 5cca00979aae..033447aa0773 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -11811,6 +11811,57 @@ static int attach_iter(const struct bpf_program =
*prog, long cookie, struct bpf_l
>         return libbpf_get_error(*link);
>  }
>
> +struct bpf_link *bpf_program__attach_netfilter_opts(const struct bpf_pro=
gram *prog,
> +                                                   const struct bpf_netf=
ilter_opts *opts)

let's just call it `bpf_program__attach_netfilter`. We add "_opts" if
we had variant without opts. This doesn't apply here, so a shorter
name is preferable.

> +{
> +       const size_t attr_sz =3D offsetofend(union bpf_attr, link_create)=
;
> +       struct bpf_link *link;
> +       int prog_fd, link_fd;
> +       union bpf_attr attr;
> +
> +       if (!OPTS_VALID(opts, bpf_netfilter_opts))
> +               return libbpf_err_ptr(-EINVAL);
> +
> +       prog_fd =3D bpf_program__fd(prog);
> +       if (prog_fd < 0) {
> +               pr_warn("prog '%s': can't attach before loaded\n", prog->=
name);
> +               return libbpf_err_ptr(-EINVAL);
> +       }
> +
> +       link =3D calloc(1, sizeof(*link));
> +       if (!link)
> +               return libbpf_err_ptr(-ENOMEM);
> +       link->detach =3D &bpf_link__detach_fd;
> +
> +       memset(&attr, 0, attr_sz);
> +
> +       attr.link_create.prog_fd =3D prog_fd;
> +       attr.link_create.netfilter.pf =3D OPTS_GET(opts, pf, 0);
> +       attr.link_create.netfilter.hooknum =3D OPTS_GET(opts, hooknum, 0)=
;
> +       attr.link_create.netfilter.priority =3D OPTS_GET(opts, priority, =
0);
> +       attr.link_create.netfilter.flags =3D OPTS_GET(opts, flags, 0);
> +
> +       link_fd =3D syscall(__NR_bpf, BPF_LINK_CREATE, &attr, attr_sz);

this code shouldn't do direct syscall, these high-level APIs should go
through libbpf low-level API. In this case, you need to call
bpf_link_create().

Except bpf_link_create() doesn't really support NETLINK links yet,
which is what we'll need to fix first. bpf_link_create() determines
what kind of parameters to pass to kernel based on bpf_attach_type.
And we currently don't have an attach type for NETLINK BPF link.
Thankfully it's not too late to add it. I see that link_create() in
kernel/bpf/syscall.c just bypasses attach_type check. We shouldn't
have done that. Instead we need to add BPF_NETLINK attach type to enum
bpf_attach_type. And wire all that properly throughout the kernel and
libbpf itself. Thankfully kernel release is not finalized and we can
still fix that up, but please prioritize it before we get too far into
rc releases.

> +
> +       link->fd =3D ensure_good_fd(link_fd);
> +
> +       if (link->fd < 0) {
> +               char errmsg[STRERR_BUFSIZE];
> +
> +               link_fd =3D -errno;
> +               free(link);
> +               pr_warn("prog '%s': failed to attach to pf:%d,hooknum:%d:=
prio:%d: %s\n",
> +                       prog->name,
> +                       OPTS_GET(opts, pf, 0),
> +                       OPTS_GET(opts, hooknum, 0),
> +                       OPTS_GET(opts, priority, 0),
> +                       libbpf_strerror_r(link_fd, errmsg, sizeof(errmsg)=
));
> +               return libbpf_err_ptr(link_fd);
> +       }
> +
> +       return link;
> +}
> +
>  struct bpf_link *bpf_program__attach(const struct bpf_program *prog)
>  {
>         struct bpf_link *link =3D NULL;
> diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> index 754da73c643b..081beb95a097 100644
> --- a/tools/lib/bpf/libbpf.h
> +++ b/tools/lib/bpf/libbpf.h
> @@ -718,6 +718,21 @@ LIBBPF_API struct bpf_link *
>  bpf_program__attach_freplace(const struct bpf_program *prog,
>                              int target_fd, const char *attach_func_name)=
;
>
> +struct bpf_netfilter_opts {
> +       /* size of this struct, for forward/backward compatibility */
> +       size_t sz;
> +
> +       __u32 pf;
> +       __u32 hooknum;
> +       __s32 priority;
> +       __u32 flags;
> +};
> +#define bpf_netfilter_opts__last_field flags
> +
> +LIBBPF_API struct bpf_link *
> +bpf_program__attach_netfilter_opts(const struct bpf_program *prog,
> +                                  const struct bpf_netfilter_opts *opts)=
;
> +
>  struct bpf_map;
>
>  LIBBPF_API struct bpf_link *bpf_map__attach_struct_ops(const struct bpf_=
map *map);
> diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
> index 7521a2fb7626..e13d60608bf3 100644
> --- a/tools/lib/bpf/libbpf.map
> +++ b/tools/lib/bpf/libbpf.map
> @@ -395,4 +395,5 @@ LIBBPF_1.2.0 {
>  LIBBPF_1.3.0 {
>         global:
>                 bpf_obj_pin_opts;
> +               bpf_program__attach_netfilter_opts;

opts and the rest looks good, thanks

>  } LIBBPF_1.2.0;
> --
> 2.39.3
>

