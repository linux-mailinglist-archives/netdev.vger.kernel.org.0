Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 919376CCD4C
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 00:36:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbjC1Wgx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 18:36:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjC1Wgw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 18:36:52 -0400
Received: from mail-yw1-x112a.google.com (mail-yw1-x112a.google.com [IPv6:2607:f8b0:4864:20::112a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CC02FD
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 15:36:51 -0700 (PDT)
Received: by mail-yw1-x112a.google.com with SMTP id 00721157ae682-5456249756bso258874047b3.5
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 15:36:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112; t=1680043010;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+UNQvF8UOEhiBUfEZA+3IQy6uvaasF3Nx+C0W7hu5w4=;
        b=jFp9ucyhyyrspSSHIRZyfoc7G1AHxaiMD6k1udjODCuluExwWT+bWYIV3DwmNFwogk
         SRGr9Dh/4pbyiyIFtwvCzCw+WJ5Qi6KUC8sIjtC3o8dB8vOL+stexFhx/0odekvDEMd0
         fgUDd7TEDR1XoSWRf0F+HgdA4KT6MnkuK9FKnYTpGyWHymB9AkPi8GWHnwDXPjELD1gc
         HLM4Fi9rWhFX86r3JTp/M15qyrp0cWQxBqlOOHp/UTz14LP4Rxe8GsiK6xxj+86wSR+A
         WtrQMVY+raIXQbQ42RYsPzN+JqUVDKbpz3tY/VVrScAtrnU/sS80TZ0OO/bSvb7ApEgL
         2RUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680043010;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+UNQvF8UOEhiBUfEZA+3IQy6uvaasF3Nx+C0W7hu5w4=;
        b=WoHt5Z3F5f2p95a2Y93IM/g8rKMxf3dCdJz8fjqpjU5xJsESDik57hHG5NbKHM81r3
         Jy20HWXFCiC3zKlYEQPVwJ04hSJGhhZctXy4If1HG3y/+js1sP+WGhurTj3nzdrkyLD9
         1V3PPtWLAMh3AqsQ/134kwheZqve9sHVjTM0blZUjtRyFO5FzJeced5wnGXULfWbDKV0
         EZRG988bK+AIT/7oZN+vraOS+pl1PuCKbw/511xyLlFnIMg7lGM0M2RvgrI+KU4pC1Kd
         PliWoKQx74RTVUT7pC47c72fhDOvZQp5o8CshfDX6M+RsLOyLURzkriQwnUnbTcjG4Uv
         6c/w==
X-Gm-Message-State: AAQBX9cv1jNfAcY0nAQ7x9Xv53QpJQaiOdRP3Ucd+0iRjQTm6fL7KPaJ
        aA9gjlM1dQ5A6uzPdOq8si7k0ph+QIWKffC24qws6A==
X-Google-Smtp-Source: AKy350YQZ5UyGhY/2mp50i7pJ7eIiMS0wvq9J7rpKl1o+iEzHILspJo71pqpCO5FJhOxnYWFi6z9GJ6pT8ovCOTbirc=
X-Received: by 2002:a81:b286:0:b0:545:7b92:2890 with SMTP id
 q128-20020a81b286000000b005457b922890mr8342630ywh.7.1680043010333; Tue, 28
 Mar 2023 15:36:50 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1680021219.git.dcaratti@redhat.com> <72335bd036509a533d1cf00554b77b674fad846f.1680021219.git.dcaratti@redhat.com>
In-Reply-To: <72335bd036509a533d1cf00554b77b674fad846f.1680021219.git.dcaratti@redhat.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Tue, 28 Mar 2023 18:36:39 -0400
Message-ID: <CAM0EoMmv+_rLFVEuJNgpScdpUKLtbpb6oWrpNBx-w9Z660ga+A@mail.gmail.com>
Subject: Re: [PATCH net-next v3 3/4] selftests: tc-testing: add tunnel_key
 "nofrag" test case
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ilya Maximets <i.maximets@ovn.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Pedro Tammela <pctammela@mojatatu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 28, 2023 at 12:45=E2=80=AFPM Davide Caratti <dcaratti@redhat.co=
m> wrote:
>
>  # ./tdc.py -e 6bda -l
>  6bda: (actions, tunnel_key) Add tunnel_key action with nofrag option
>
> Signed-off-by: Davide Caratti <dcaratti@redhat.com>

Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>

cheers,
jamal

> ---
>  .../tc-tests/actions/tunnel_key.json          | 25 +++++++++++++++++++
>  1 file changed, 25 insertions(+)
>
> diff --git a/tools/testing/selftests/tc-testing/tc-tests/actions/tunnel_k=
ey.json b/tools/testing/selftests/tc-testing/tc-tests/actions/tunnel_key.js=
on
> index b40ee602918a..b5b47fbf6c00 100644
> --- a/tools/testing/selftests/tc-testing/tc-tests/actions/tunnel_key.json
> +++ b/tools/testing/selftests/tc-testing/tc-tests/actions/tunnel_key.json
> @@ -983,5 +983,30 @@
>          "teardown": [
>              "$TC actions flush action tunnel_key"
>          ]
> +    },
> +    {
> +        "id": "6bda",
> +        "name": "Add tunnel_key action with nofrag option",
> +        "category": [
> +            "actions",
> +            "tunnel_key"
> +        ],
> +        "dependsOn": "$TC actions add action tunnel_key help 2>&1 | grep=
 -q nofrag",
> +        "setup": [
> +            [
> +                "$TC action flush action tunnel_key",
> +                0,
> +                1,
> +                255
> +            ]
> +        ],
> +        "cmdUnderTest": "$TC actions add action tunnel_key set src_ip 10=
.10.10.1 dst_ip 10.10.10.2 id 1111 nofrag index 222",
> +        "expExitCode": "0",
> +        "verifyCmd": "$TC actions get action tunnel_key index 222",
> +        "matchPattern": "action order [0-9]+: tunnel_key.*src_ip 10.10.1=
0.1.*dst_ip 10.10.10.2.*key_id 1111.*csum.*nofrag pipe.*index 222",
> +        "matchCount": "1",
> +        "teardown": [
> +            "$TC actions flush action tunnel_key"
> +        ]
>      }
>  ]
> --
> 2.39.2
>
