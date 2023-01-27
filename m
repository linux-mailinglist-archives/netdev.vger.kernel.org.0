Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 500DD67E853
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 15:33:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233326AbjA0OdH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 09:33:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233338AbjA0OdC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 09:33:02 -0500
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08350EC68
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 06:32:57 -0800 (PST)
Received: by mail-io1-xd2d.google.com with SMTP id k3so407939ioc.10
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 06:32:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=4VJl1LFj78awaMi5u1yCyS89RCOFZobWhyD03Egy1dY=;
        b=e2S+T+hw8P+2HOsuX++A4wB4qB0exNACPcbnqddJ1iayW63HOp3y7k999fxSY+GNQm
         WKLwzxo9LrgQ4PKeLugPBdT2kFegxKKjrL89ZJRlHWpJz5DpUOJMwKwnwU76zfPBL+dk
         6WwLjwPZZbN5HMkYP/crQbMNgnA2BVT4itYy3x2uRkx9Pk4Gq0BH85yZ2mj2BcPj1jEO
         aJJmcVBgCyIXqiuCL8lYUX0UMRltMyYishf11RCDCu3PRHGmXkAHE7pc0DYCKJJUhXlj
         K0s+xY04Wsu7L05JBk9Ic/1trtNjjF9ZB9iwVjsJsCqZ3WX1aNftxv5F80uLd4AWvgb7
         Dvjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4VJl1LFj78awaMi5u1yCyS89RCOFZobWhyD03Egy1dY=;
        b=vdNqqBk3FyFe/G3gwwKJX/uj9KKSoroeT9JZuOO+cAGyzZS0RaZNvrXaJbQbblZ8Ws
         XQeE/YYppEVegrSpbvGLv2ufzI3EH5bYKTMeixwOR0ko3rHqaV49SgxSJ7amQahQ7olm
         +oegSfpwZZ1q/DJgSLiQJkxxVTEbm5uUOPkMPWKc3+4WwOQTa/1vttbHbk33Uy5699CS
         ypaCjdTaTExHt7X2lfFuC6Dpk+oyBUQULwIiCwHvMmftASW2OKgOKJbs0osHnSOtmmL3
         77X2iHk3wrWVxENg6q8TE0RK2SCsRtUYuE0oOW8maXCYce3TWT1WkajsvawhROf9QT37
         I0YA==
X-Gm-Message-State: AO0yUKVDpETn7qv1IJdQiciuxb+jUvoA2fY82P4pi1O8sKNReBtHeex3
        JcylmrLDcznan6GT16pMoQP6GEGIEJKIohq3qhpErA==
X-Google-Smtp-Source: AK7set+3mZJkF8fkciCG6VzvikUhcMDERUzDhLStD/6poffAcfmiE2I8eb4RebH3huth4FaWurCefne/onY5y8p1T2A=
X-Received: by 2002:a02:ad06:0:b0:3a9:5776:864 with SMTP id
 s6-20020a02ad06000000b003a957760864mr1383179jan.67.1674829976842; Fri, 27 Jan
 2023 06:32:56 -0800 (PST)
MIME-Version: 1.0
References: <20230127140944.265135-1-andrei.gherzan@canonical.com> <20230127140944.265135-3-andrei.gherzan@canonical.com>
In-Reply-To: <20230127140944.265135-3-andrei.gherzan@canonical.com>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Date:   Fri, 27 Jan 2023 06:32:44 -0800
Message-ID: <CANP3RGchqLRLRAxgWU69DzWfa9R2d0AhgeBdpJhmaE+c-Sszjw@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] selftests: net: Fix udpgro_frglist.sh shellcheck
 warnings and errors
To:     Andrei Gherzan <andrei.gherzan@canonical.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
        Lina Wang <lina.wang@mediatek.com>, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 27, 2023 at 6:09 AM Andrei Gherzan
<andrei.gherzan@canonical.com> wrote:
>
> This change fixes the following shellcheck warnings and errors:
>
> * SC2155 (warning): Declare and assign separately to avoid masking return
>   values.
> * SC2124 (warning): Assigning an array to a string! Assign as array, or use
>   instead of @ to concatenate.
> * SC2034 (warning): ipv4_args appears unused. Verify use (or export if used
>   externally).
> * SC2242 (error): Can only exit with status 0-255. Other data should be
>   written to stdout/stderr.
> * SC2068 (error): Double quote array expansions to avoid re-splitting
>   elements.
>
> Fixes: edae34a3ed92 ("selftests net: add UDP GRO fraglist + bpf self-tests")
> Signed-off-by: Andrei Gherzan <andrei.gherzan@canonical.com>
> ---
>  tools/testing/selftests/net/udpgro_frglist.sh | 20 +++++++++----------
>  1 file changed, 10 insertions(+), 10 deletions(-)
>
> diff --git a/tools/testing/selftests/net/udpgro_frglist.sh b/tools/testing/selftests/net/udpgro_frglist.sh
> index e1ca49de2491..97bf20e9afd8 100755
> --- a/tools/testing/selftests/net/udpgro_frglist.sh
> +++ b/tools/testing/selftests/net/udpgro_frglist.sh
> @@ -3,7 +3,8 @@
>  #
>  # Run a series of udpgro benchmarks
>
> -readonly PEER_NS="ns-peer-$(mktemp -u XXXXXX)"
> +PEER_NS="ns-peer-$(mktemp -u XXXXXX)"
> +readonly PEER_NS
>
>  BPF_FILE="../bpf/xdp_dummy.bpf.o"
>  BPF_NAT6TO4_FILE="nat6to4.o"
> @@ -19,7 +20,7 @@ trap cleanup EXIT
>
>  run_one() {
>         # use 'rx' as separator between sender args and receiver args
> -       local -r all="$@"
> +       local -r all="$*"

this should technically use arrays, something like

local -a -r args=("$@")

but perhaps just get rid of args and just use "$@" directly below

>         local -r tx_args=${all%rx*}
>         local rx_args=${all#*rx}
>
> @@ -56,13 +57,13 @@ run_one() {
>  }
>
>  run_in_netns() {
> -       local -r args=$@
> +       local -r args="$*"
>    echo ${args}
>         ./in_netns.sh $0 __subprocess ${args}

ie. here could just use "$@" directly twice instead of defining args.
$0 should be doublequoted - though I guess it'll never be empty, and
is unlikely to include spaces.
>  }
>
>  run_udp() {
> -       local -r args=$@
> +       local -r args="$*"
>
>         echo "udp gso - over veth touching data"
>         run_in_netns ${args} -u -S 0 rx -4 -v
> @@ -72,7 +73,7 @@ run_udp() {
>  }
>
>  run_tcp() {
> -       local -r args=$@
> +       local -r args="$*"
>
>         echo "tcp - over veth touching data"
>         run_in_netns ${args} -t rx -4 -t
> @@ -80,7 +81,6 @@ run_tcp() {
>
>  run_all() {
>         local -r core_args="-l 4"

is this still useful? embed directly in ipv6_args

> -       local -r ipv4_args="${core_args} -4  -D 192.168.1.1"

perhaps this should stay as a comment??

>         local -r ipv6_args="${core_args} -6  -D 2001:db8::1"
>
>         echo "ipv6"
> @@ -90,19 +90,19 @@ run_all() {
>
>  if [ ! -f ${BPF_FILE} ]; then

double quote
"${BPF_FILE}"
in case space in file name

>         echo "Missing ${BPF_FILE}. Build bpf selftest first"
> -       exit -1
> +       exit 1
>  fi
>
>  if [ ! -f "$BPF_NAT6TO4_FILE" ]; then

there seems to be inconsistency around [ vs [[, use [[ if relying on bash anyway

>         echo "Missing nat6to4 helper. Build bpf nat6to4.o selftest first"
> -       exit -1
> +       exit 1
>  fi
>
>  if [[ $# -eq 0 ]]; then
>         run_all
>  elif [[ $1 == "__subprocess" ]]; then

while this does indeed work, imho $1 should be "$1" to be less confusing

>         shift
> -       run_one $@
> +       run_one "$@"
>  else
> -       run_in_netns $@
> +       run_in_netns "$@"
>  fi
> --
> 2.34.1
