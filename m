Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5196C53BCAA
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 18:41:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237155AbiFBQlT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 12:41:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236745AbiFBQlS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 12:41:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87BD813C1F2;
        Thu,  2 Jun 2022 09:41:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3F1A5B82042;
        Thu,  2 Jun 2022 16:41:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06BF7C34115;
        Thu,  2 Jun 2022 16:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654188075;
        bh=IFjttROKZGGylhevLsgEC2YyRTVJprcNcySxHaWLmhM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=cZX264Y83XffDb1tW2vMmPRH1K8klxTPT/e+cvuQz0dmzJC5feTEBTLrRqEgmQ9tj
         UXIWA33elL9JT1aQqiQTj5qDsVJXi4MB1I0c0DFXv2nDLbrH3DW3wEP571w0e9uO9P
         1zk8FnWXFAybXLwcWPaI9L6R2erDoIBv+6VoBJWXvgwrrLO7ia+0Sl+XucPneeckbG
         MXaAu3uuE4uCKknST+DZVa267C5rWrhbJq2cNi0vQ3NVaLrn496Qmjmlp99m2I01x/
         l36lgO350XS9umzpAmXOeYp66dhC3jXCvIzVDL27p05Ig/51HkqOi7S7SaFDMa1B0R
         Buqqh2+NZ8a9g==
Received: by mail-yb1-f182.google.com with SMTP id v22so9273371ybd.5;
        Thu, 02 Jun 2022 09:41:14 -0700 (PDT)
X-Gm-Message-State: AOAM5325v4HHABqOBYXBpL0qotc2BusWlLx5jBpiSxpo3V21YflQGPes
        zt6hawIMYApv/5RbGOzxKlx+AoyOoOCyOzk5Sl0=
X-Google-Smtp-Source: ABdhPJxnHnGOKzXEJokcQ7meWgPecl2a8ESyM99K54n/4dSG3zP9J2fFux+owsd+ABqAB+C39rviJIUMsMibtSPSNr8=
X-Received: by 2002:a05:6902:50f:b0:65c:d620:f6d3 with SMTP id
 x15-20020a056902050f00b0065cd620f6d3mr6255270ybs.322.1654188074062; Thu, 02
 Jun 2022 09:41:14 -0700 (PDT)
MIME-Version: 1.0
References: <20220602032507.464453-1-liuhangbin@gmail.com>
In-Reply-To: <20220602032507.464453-1-liuhangbin@gmail.com>
From:   Song Liu <song@kernel.org>
Date:   Thu, 2 Jun 2022 09:41:03 -0700
X-Gmail-Original-Message-ID: <CAPhsuW4eVM=3xkr3ocm7oYn1VxRY1Ws1msmq1O738_yBTK+qqQ@mail.gmail.com>
Message-ID: <CAPhsuW4eVM=3xkr3ocm7oYn1VxRY1Ws1msmq1O738_yBTK+qqQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: add drv mode testing for xdping
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Mathieu Xhonneux <m.xhonneux@gmail.com>,
        William Tu <u9012063@gmail.com>,
        Toshiaki Makita <toshiaki.makita1@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 1, 2022 at 8:25 PM Hangbin Liu <liuhangbin@gmail.com> wrote:
>
> As subject, we only test SKB mode for xdping at present.
> Now add DRV mode for xdping.
>
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

Acked-by: Song Liu <songliubraving@fb.com>

> ---
>  tools/testing/selftests/bpf/test_xdping.sh | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/tools/testing/selftests/bpf/test_xdping.sh b/tools/testing/selftests/bpf/test_xdping.sh
> index c2f0ddb45531..c3d82e0a7378 100755
> --- a/tools/testing/selftests/bpf/test_xdping.sh
> +++ b/tools/testing/selftests/bpf/test_xdping.sh
> @@ -95,5 +95,9 @@ for server_args in "" "-I veth0 -s -S" ; do
>         test "$client_args" "$server_args"
>  done
>
> +# Test drv mode
> +test "-I veth1 -N" "-I veth0 -s -N"
> +test "-I veth1 -N -c 10" "-I veth0 -s -N"
> +
>  echo "OK. All tests passed"
>  exit 0
> --
> 2.35.1
>
