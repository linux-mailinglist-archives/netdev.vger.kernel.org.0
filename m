Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 416755293BC
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 00:45:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346673AbiEPWpa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 18:45:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345766AbiEPWp2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 18:45:28 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1DF23EF12;
        Mon, 16 May 2022 15:45:26 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id s23so17550281iog.13;
        Mon, 16 May 2022 15:45:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9E7RpF3kV6uZXouTfZrM1fmjZpic/OFFP4Rr3o2bqnA=;
        b=LPzyDwK1mHDDhjjzL6eMFYzavfB/+fZqNoysv+PK+BKBqU1s9j6pVjsIslmdAO88fW
         rxzsz4AjZmwzgp9HAIfj5hopHnLycaTWqL2S8kG0quEcq35z5b8Gb2uQwyUxHnQPEDiY
         wyU+A3WmFFkJbSxSM1g+jzBCc/A0ms8mGu2wQAIZYImZZh/AKDQYGHKzwWj2GW/BUQl9
         95s2G5fN8DBb1VcIDYaW9xeXvDlkaHmVSGV8uuxxgDR6AZX0m0XBzjSXf98r2UyKOxKZ
         OcJltAsd9tAn6kwbQYic2BZUOGWHJJPMPx5xUxHkzzTxqWO5foj1MBWpiHYvqrg+T2fq
         7bGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9E7RpF3kV6uZXouTfZrM1fmjZpic/OFFP4Rr3o2bqnA=;
        b=rcRMfi+Vdbdf/pWB6CS2hadz1MiXyTuA7fli76aUPzroY9jLnD1UeXckH7pAkFL1+U
         gvviofGHk1dZuYCTfRGjspBd3RJltCQ1bcPDENU5Np0h2vf95jeBGkc7Z/7pgolWxDb2
         Ozc5/xtFmKPK2vRXzdlKSHcHBU9bzX1Nkzz2fVXgbuy0gUIUT7ugXuz2yQNZzSZpZJox
         7D5Y6GOXPGh4EmNopr9Ty5UELsXqKN7NjtoGu8lcgp31oDicrZaHU9T2MD0wgtWVk6xg
         ATjQrkQiD60jwQMHDSJ1wllI3VfTcSmld7v2wRT1B5YJ50USEeZOQFIISOInXXE5yoqj
         ATug==
X-Gm-Message-State: AOAM533glyJPnIVhhfu2kxdzD+am82qtmXdnH5Pe8f2Q4Hzhc8BNPJfi
        oJBX3wbcjNDN6QpV7Xmrp/lo7ejY42VqYHk4r70=
X-Google-Smtp-Source: ABdhPJw7Fg0ClVP+XC5GPYevvUVOxVKp0UvEXx/7+mToohzRfuFsiF+HjkMYUgcNp8fngXAb8ZOVnj44mK2FXEsEQiE=
X-Received: by 2002:a5e:8e42:0:b0:657:bc82:64e5 with SMTP id
 r2-20020a5e8e42000000b00657bc8264e5mr8838937ioo.112.1652741126084; Mon, 16
 May 2022 15:45:26 -0700 (PDT)
MIME-Version: 1.0
References: <20220513224827.662254-1-mathew.j.martineau@linux.intel.com> <20220513224827.662254-6-mathew.j.martineau@linux.intel.com>
In-Reply-To: <20220513224827.662254-6-mathew.j.martineau@linux.intel.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 16 May 2022 15:45:15 -0700
Message-ID: <CAEf4BzbsK9C1=h=7s25Ezh8HFo7=+vA1XSuLjbQA2Bi16W4kvg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 5/7] selftests/bpf: verify token of struct mptcp_sock
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Geliang Tang <geliang.tang@suse.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, mptcp@lists.linux.dev,
        Matthieu Baerts <matthieu.baerts@tessares.net>
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

On Fri, May 13, 2022 at 3:48 PM Mat Martineau
<mathew.j.martineau@linux.intel.com> wrote:
>
> From: Geliang Tang <geliang.tang@suse.com>
>
> This patch verifies the struct member token of struct mptcp_sock. Add a
> new function get_msk_token() to parse the msk token from the output of
> the command 'ip mptcp monitor', and verify it in verify_msk().
>
> v4:
>  - use ASSERT_* instead of CHECK_FAIL (Andrii)
>  - skip the test if 'ip mptcp monitor' is not supported (Mat)
>
> Acked-by: Matthieu Baerts <matthieu.baerts@tessares.net>
> Signed-off-by: Geliang Tang <geliang.tang@suse.com>
> Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
> ---
>  tools/testing/selftests/bpf/bpf_tcp_helpers.h |  1 +
>  .../testing/selftests/bpf/prog_tests/mptcp.c  | 64 +++++++++++++++++++
>  .../testing/selftests/bpf/progs/mptcp_sock.c  |  5 ++
>  3 files changed, 70 insertions(+)
>

[...]

> +       fd = open(monitor_log_path, O_RDONLY);
> +       if (!ASSERT_GE(fd, 0, "Failed to open monitor_log_path"))
> +               return token;
> +
> +       len = read(fd, buf, sizeof(buf));
> +       if (!ASSERT_GT(len, 0, "Failed to read monitor_log_path"))
> +               goto err;
> +
> +       if (strncmp(buf, prefix, strlen(prefix))) {

ASSERT_STRNEQ ?

> +               log_err("Invalid prefix %s", buf);
> +               goto err;
> +       }
> +
> +       token = strtol(buf + strlen(prefix), NULL, 16);
> +
> +err:
> +       close(fd);
> +       return token;
> +}
> +
>  static int verify_msk(int map_fd, int client_fd)
>  {
>         char *msg = "MPTCP subflow socket";
>         int err, cfd = client_fd;
>         struct mptcp_storage val;
> +       __u32 token;
> +
> +       token = get_msk_token();
> +       if (!ASSERT_GT(token, 0, "Unexpected token"))
> +               return -1;
>
>         err = bpf_map_lookup_elem(map_fd, &cfd, &val);
>         if (!ASSERT_OK(err, "bpf_map_lookup_elem"))
> @@ -58,6 +102,12 @@ static int verify_msk(int map_fd, int client_fd)
>                 err++;
>         }
>
> +       if (val.token != token) {


ASSERT_NEQ

> +               log_err("Unexpected mptcp_sock.token %x != %x",
> +                       val.token, token);
> +               err++;
> +       }
> +
>         return err;
>  }
>

[...]
