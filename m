Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DB1B89510
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 02:29:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726275AbfHLA3u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Aug 2019 20:29:50 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:43957 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726144AbfHLA3u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Aug 2019 20:29:50 -0400
Received: by mail-ot1-f67.google.com with SMTP id e12so8813514otp.10
        for <netdev@vger.kernel.org>; Sun, 11 Aug 2019 17:29:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DZzCrGT0DL++n0O7ZVbklUAsoRZbKiBB+RlhLw3Nz2Y=;
        b=hGioseOENmKT7KVdXl1/nLVibfUyemxCYy1sWqxw1MeYv7GT7ouAJiUbp6rhv/NZv6
         PNScttnSrP3BCPLOSl9BE9bj3liJvvbMRDRCa506c6w8qD5g0pYED6V3RyOYG4woXi9k
         Cp2Bjsy88h42dQPawyOBtF8G5GpvjxpGdZzrTqiW9hLiUIU4pPdHRbr1NRBwXVKFPjNJ
         6HeENumBnMeUeDK8H+QXYSr2ilF52YuKLSvLfLXr5SkTIIucMr1WylZcKjoruK2jOzUK
         bG/ZIOGX7C+r0GrsxM/jQXQ7p9bIEcHGQe0Zqt+kHXiqQJDI5gB4ZSAGleM3a3H8tX9e
         rvpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DZzCrGT0DL++n0O7ZVbklUAsoRZbKiBB+RlhLw3Nz2Y=;
        b=QJwGfMYK8tboMtLSgiVYGnni/zuLEH4z/1hTaJ+7/Jq9Qm3jf2BizNGnDv6vBVW0fo
         aRaW0iGz1eHOPvuwmB7Kfv0JtQ3ITHGTrRNRsBNaissn1ZDsczqDM6bfztb3zW73ItH7
         RIttyG5GDS8GWZs44G1AAeQLyIcnJlEAXMGeBokZhZm4F6lDsEXP9Z64JskBXuAchqxK
         3DZFFiR59f7mo/MdMVr/pnFoP28w3JUSPNIZ5MvcaCSgqYAD23NE9+Cct5UOzAkQKC7c
         pEZNGm2lkDBGK+h5BP+9WgejHkpmOo0+ieEIxUlGX84Lx6nXVr6chOSCbdyKCCYvD7IG
         7S9w==
X-Gm-Message-State: APjAAAUK5VzNz92NHwSxJptwg8fxD4HeyZZlbKtxsoJPOVjxYfOLxbQH
        wPrwh9b6dmTVAqOdix/Qq+gxKBVTO7Bng35oZ1s=
X-Google-Smtp-Source: APXvYqyzRX3xEenD5kB19WqRjxKaqt/7e+RgaTSVgSmkGmum1lgoIgioX5bII3/7huhdeoFfQHXH+ZbBwKOaP8kh7bs=
X-Received: by 2002:a02:c916:: with SMTP id t22mr34256884jao.24.1565569789402;
 Sun, 11 Aug 2019 17:29:49 -0700 (PDT)
MIME-Version: 1.0
References: <20190809133248.19788-1-danieltimlee@gmail.com> <20190809133248.19788-3-danieltimlee@gmail.com>
In-Reply-To: <20190809133248.19788-3-danieltimlee@gmail.com>
From:   Y Song <ys114321@gmail.com>
Date:   Sun, 11 Aug 2019 17:29:13 -0700
Message-ID: <CAH3MdRV93z2u0_B7TNjh_qcL+UfN5eKeje4vFRZUAtHWjnzL=g@mail.gmail.com>
Subject: Re: [v4,2/4] tools: bpftool: add net detach command to detach XDP on interface
To:     "Daniel T. Lee" <danieltimlee@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 9, 2019 at 6:35 AM Daniel T. Lee <danieltimlee@gmail.com> wrote:
>
> By this commit, using `bpftool net detach`, the attached XDP prog can
> be detached. Detaching the BPF prog will be done through libbpf
> 'bpf_set_link_xdp_fd' with the progfd set to -1.
>
> Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> ---
>  tools/bpf/bpftool/net.c | 42 ++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 41 insertions(+), 1 deletion(-)
>
> diff --git a/tools/bpf/bpftool/net.c b/tools/bpf/bpftool/net.c
> index 74cc346c36cd..ef1e576c6dba 100644
> --- a/tools/bpf/bpftool/net.c
> +++ b/tools/bpf/bpftool/net.c
> @@ -343,6 +343,43 @@ static int do_attach(int argc, char **argv)
>         return 0;
>  }
>
> +static int do_detach(int argc, char **argv)
> +{
> +       enum net_attach_type attach_type;
> +       int progfd, ifindex, err = 0;
> +
> +       /* parse detach args */
> +       if (!REQ_ARGS(3))
> +               return -EINVAL;
> +
> +       attach_type = parse_attach_type(*argv);
> +       if (attach_type == net_attach_type_size) {
> +               p_err("invalid net attach/detach type: %s", *argv);
> +               return -EINVAL;
> +       }
> +       NEXT_ARG();
> +
> +       ifindex = net_parse_dev(&argc, &argv);
> +       if (ifindex < 1)
> +               return -EINVAL;
> +
> +       /* detach xdp prog */
> +       progfd = -1;
> +       if (is_prefix("xdp", attach_type_strings[attach_type]))
> +               err = do_attach_detach_xdp(progfd, attach_type, ifindex, NULL);
> +
> +       if (err < 0) {
> +               p_err("interface %s detach failed: %s",
> +                     attach_type_strings[attach_type], strerror(errno));
> +               return err;
> +       }

Similar to previous patch, here we should use "strerror(-err)".
With this fixed, you can add my ack:
Acked-by: Yonghong Song <yhs@fb.com>

> +
> +       if (json_output)
> +               jsonw_null(json_wtr);
> +
> +       return 0;
> +}
> +
[...]
