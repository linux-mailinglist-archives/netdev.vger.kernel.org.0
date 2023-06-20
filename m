Return-Path: <netdev+bounces-12262-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C8E7F736E9F
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 16:26:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 05E4B1C20C80
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 14:26:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5E0D171AC;
	Tue, 20 Jun 2023 14:26:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8DB6168B0
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 14:26:20 +0000 (UTC)
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D845E3
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 07:26:18 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id a640c23a62f3a-985b04c46caso713686066b.0
        for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 07:26:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent.com; s=google; t=1687271176; x=1689863176;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X2wyBTcJR6p7csnloJ91l2fVHCCEzSyNd6gk8W1QMZU=;
        b=IeCrNA1exspDxFBwqnWrzIbklXPs4QqPKOgcO7ttuCtiUkxaOZPrcS6jp7l6dhhuQD
         93+vcVyyvCua+EUGT66gCYA/AczRo9UxREMSJtI/pbc73NAFcPSauR8Gbe+jAIg1bcSv
         fLzHbprAear5HrplJnqUg4JU7xdod2fv4q0oqvGnAa3ZBhiWVPYgdgdtTPG25wPuTWzP
         aAXr5I0SFlHN+JHX7wEAovCY268gbM4jdPsXYi4wfcSn/EEUiGs3WMFFM/cvzHs8agy2
         vck1flEDgI/qXLS8IBdKq7mOIMsWUdhffhPjMH4rDvAKfk4gSema5MePVFbWAH2O+258
         WNXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687271176; x=1689863176;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=X2wyBTcJR6p7csnloJ91l2fVHCCEzSyNd6gk8W1QMZU=;
        b=Z4iWKeXLRptLR6rQ4ERmScpaFMpUAPEAy3kWvmOBojTaBLfRbCaFlT9NmxysVPdH6H
         NbUQduCKEg+SrxhXnKE4mm45IZhex6xwnPYIcUV3wFldYaydvssSI0x4qGEOy2ZaUv14
         P2I3BaogkmyTswH9JP0g3qXxn4BGsJm3pksSlbLmut+opwGuBqJUkGDW03dB9YSQasPP
         p/IKlByD4k9U1B35jPqdnaNZgg/GruwBBdQMhekeaGdbCGkN6QqelrMaumwnRkP85PGp
         ikAdojxIgegX5HHA8v2KccKkkaTZn6wdEhZFdKjGgyGItFaY1NPF8QPi2aDAGfXatsql
         aVqg==
X-Gm-Message-State: AC+VfDwUjeMkYB4lr9fBijAWigQbOs9MuNXmY1YqKPATnIcp8xLkXGo4
	ub96LEdm+XSRhMRdxrlV9g0aAUwSQKiCijI4acvOZDQAWBlV1Xc2uV7AM8/q
X-Google-Smtp-Source: ACHHUZ4F6Bo5HQM/coVzb7fcVno2rPqSFsE7C5eCVHJUdGh3D3sd3vLRXEApaqIuSAwaopl7QePrBD+Ai+HPg3lns/w=
X-Received: by 2002:a17:906:9b88:b0:988:8fed:8ae9 with SMTP id
 dd8-20020a1709069b8800b009888fed8ae9mr5845806ejc.37.1687271176657; Tue, 20
 Jun 2023 07:26:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230613-so-reuseport-v2-3-b7c69a342613@isovalent.com> <20230613185647.64531-1-kuniyu@amazon.com>
In-Reply-To: <20230613185647.64531-1-kuniyu@amazon.com>
From: Lorenz Bauer <lmb@isovalent.com>
Date: Tue, 20 Jun 2023 15:26:05 +0100
Message-ID: <CAN+4W8ge-ZQjins-E1=GHDnsi9myFqt7pwNqMkUQHZOPHQhFvQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 3/6] net: remove duplicate reuseport_lookup functions
To: Kuniyuki Iwashima <kuniyu@amazon.com>
Cc: andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org, 
	daniel@iogearbox.net, davem@davemloft.net, dsahern@kernel.org, 
	edumazet@google.com, haoluo@google.com, hemanthmalla@gmail.com, 
	joe@wand.net.nz, john.fastabend@gmail.com, jolsa@kernel.org, 
	kpsingh@kernel.org, kuba@kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, martin.lau@linux.dev, mykolal@fb.com, 
	netdev@vger.kernel.org, pabeni@redhat.com, sdf@google.com, shuah@kernel.org, 
	song@kernel.org, willemdebruijn.kernel@gmail.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 13, 2023 at 7:57=E2=80=AFPM Kuniyuki Iwashima <kuniyu@amazon.co=
m> wrote:
>
> The assignment to result below is buggy.  Let's say SO_REUSEPROT group
> have TCP_CLOSE and TCP_ESTABLISHED sockets.
>
>   1. Find TCP_CLOSE sk and do SO_REUSEPORT lookup
>   2. result is not NULL, but the group has TCP_ESTABLISHED sk
>   3. result =3D result
>   4. Find TCP_ESTABLISHED sk, which has a higher score
>   5. result =3D result (TCP_CLOSE) <-- should be sk.
>
> Same for v6 function.

Thanks for your explanation, I think I get it now. I misunderstood
that you were worried about returning TCP_ESTABLISHED instead of
TCP_CLOSE, but it's exactly the other way around.

I have a follow up question regarding the existing code:

    result =3D lookup_reuseport(net, sk, skb,
                    saddr, sport, daddr, hnum);
    /* Fall back to scoring if group has connections */
    if (result && !reuseport_has_conns(sk))
        return result;

    result =3D result ? : sk;
    badness =3D score;

Assuming that result !=3D NULL but reuseport_has_conns() =3D=3D true, we us=
e
the reuseport socket as the result, but assign the score of sk to
badness. Shouldn't we use the score of the reuseport socket?

Thanks
Lorenz

