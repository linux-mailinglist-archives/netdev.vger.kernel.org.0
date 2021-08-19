Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F5C13F22AD
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 00:09:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235837AbhHSWJo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 18:09:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:45454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235771AbhHSWJo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Aug 2021 18:09:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 45AAD610A5;
        Thu, 19 Aug 2021 22:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629410947;
        bh=AYSsdq1T+WJd/WPPjiJxb+R+LyWyGay3qN7C8kjHd3o=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=TYTVkF/D4Zzx5uoGpL5vKt+FnfsmuEgU2NJd0W5dn4A9JL5KlVgbel65dQLUVOXJt
         gUnu2u53U+CrBWJiELgJutMgXaQUCm4E69V9KgKB/qAisBz6YaeBFwT3x+oUQMZ0/7
         xbuQ5nm4w2lgNKYBgIfa8z2txxLJTBccvAI8n7XIZPBepMPANn8oyGptSo9nUGmDMW
         G+sYneGmUEt7NrLM9gOihoYH3B2qKY8Q22P8U7WV5Zs2drgXUV8K57phfi5n6YijpD
         0Sty8oLxTy8BfE84Av4agoVFyPbicsgAAbfK3nIc2KGw65qxJX1ixrdQraWECtdMtH
         5K6isA3gof+Ig==
Received: by mail-lf1-f51.google.com with SMTP id i28so16096125lfl.2;
        Thu, 19 Aug 2021 15:09:07 -0700 (PDT)
X-Gm-Message-State: AOAM5302D0dK3wqkDHOwXdwQou93CTHGmatzxbAlE7Gco8+SS81c32Af
        nd3Gt39/ZLes/lVSHBXqjnWJP+RnmmEmYWDfGT0=
X-Google-Smtp-Source: ABdhPJxpMJvtmt/wlWrBRm8sIykY2bqH1OBaJ194CASEOKBUdMDXaNBE282t1PWWPFwy/EqckmIh6cJke2g2n6FSDsc=
X-Received: by 2002:a05:6512:11e9:: with SMTP id p9mr12235770lfs.372.1629410945562;
 Thu, 19 Aug 2021 15:09:05 -0700 (PDT)
MIME-Version: 1.0
References: <20210819072431.21966-1-lizhijian@cn.fujitsu.com>
In-Reply-To: <20210819072431.21966-1-lizhijian@cn.fujitsu.com>
From:   Song Liu <song@kernel.org>
Date:   Thu, 19 Aug 2021 15:08:54 -0700
X-Gmail-Original-Message-ID: <CAPhsuW4LfJhqgqcrmbtWPadsQsjxF6sx39Gmj3dbb01oZ6GX_Q@mail.gmail.com>
Message-ID: <CAPhsuW4LfJhqgqcrmbtWPadsQsjxF6sx39Gmj3dbb01oZ6GX_Q@mail.gmail.com>
Subject: Re: [PATCH 1/3] selftests/bpf: make test_doc_build.sh work from
 script directory
To:     Li Zhijian <lizhijian@cn.fujitsu.com>
Cc:     Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        open list <linux-kernel@vger.kernel.org>, philip.li@intel.com,
        yifeix.zhu@intel.com, kernel test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 19, 2021 at 12:27 AM Li Zhijian <lizhijian@cn.fujitsu.com> wrote:
>
> Previously, it fails as below:
> -------------
> root@lkp-skl-d01 /opt/rootfs/v5.14-rc4/tools/testing/selftests/bpf# ./test_doc_build.sh
> ++ realpath --relative-to=/opt/rootfs/v5.14-rc4/tools/testing/selftests/bpf ./test_doc_build.sh
> + SCRIPT_REL_PATH=test_doc_build.sh
> ++ dirname test_doc_build.sh
> + SCRIPT_REL_DIR=.
> ++ realpath /opt/rootfs/v5.14-rc4/tools/testing/selftests/bpf/./../../../../
> + KDIR_ROOT_DIR=/opt/rootfs/v5.14-rc4
> + cd /opt/rootfs/v5.14-rc4
> + for tgt in docs docs-clean
> + make -s -C /opt/rootfs/v5.14-rc4/. docs
> make: *** No rule to make target 'docs'.  Stop.
> + for tgt in docs docs-clean
> + make -s -C /opt/rootfs/v5.14-rc4/. docs-clean
> make: *** No rule to make target 'docs-clean'.  Stop.
> -----------
>
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Li Zhijian <lizhijian@cn.fujitsu.com>

Acked-by: Song Liu <songliubraving@fb.com>

> ---
>  tools/testing/selftests/bpf/test_doc_build.sh | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/test_doc_build.sh b/tools/testing/selftests/bpf/test_doc_build.sh
> index ed12111cd2f0..d67ced95a6cf 100755
> --- a/tools/testing/selftests/bpf/test_doc_build.sh
> +++ b/tools/testing/selftests/bpf/test_doc_build.sh
> @@ -4,9 +4,10 @@ set -e
>
>  # Assume script is located under tools/testing/selftests/bpf/. We want to start
>  # build attempts from the top of kernel repository.
> -SCRIPT_REL_PATH=$(realpath --relative-to=$PWD $0)
> +SCRIPT_REL_PATH=$(realpath $0)
>  SCRIPT_REL_DIR=$(dirname $SCRIPT_REL_PATH)
> -KDIR_ROOT_DIR=$(realpath $PWD/$SCRIPT_REL_DIR/../../../../)
> +KDIR_ROOT_DIR=$(realpath $SCRIPT_REL_DIR/../../../../)
> +SCRIPT_REL_DIR=$(dirname $(realpath --relative-to=$KDIR_ROOT_DIR $SCRIPT_REL_PATH))
>  cd $KDIR_ROOT_DIR
>
>  for tgt in docs docs-clean; do
> --
> 2.32.0
>
>
>
