Return-Path: <netdev+bounces-2262-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E4D66700F17
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 20:55:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 66DD0281D4E
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 18:55:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D3F523D5E;
	Fri, 12 May 2023 18:55:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 124FF23D59
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 18:55:38 +0000 (UTC)
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFF621FD6
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 11:55:37 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id 3f1490d57ef6-ba5ebdc4156so6511610276.3
        for <netdev@vger.kernel.org>; Fri, 12 May 2023 11:55:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683917737; x=1686509737;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Apu6D8O64dOrAgLxicGzFFoIWOvMx7nXa8biHwBcP24=;
        b=SLRcM1TdgFCrbjFjbGCeqsKojq8VkL4FekesxJ50cQixz4auuqO5C7nOwYJr7zgaMC
         cUMdNU/c0CowmUdnn7k/CuKbX8+1iaddq2zhYwm21kTX6zak8cQX9s437nKoemYyUrhR
         z6Zyy9ai3kBA89RGnCHl66RfqXyuyyKAvb2uiUuiBgBqFOiRp3ZJM89Xk01IKcofl1hc
         zXX0XwxI7qYgjHt+9Pid6YGk/BF/qWULXCmpP4AL8b0NJ8dU9uIa3meuyOX6J8uN9zrH
         IV5lO8lRw+zeY6q5BxTqs3HIwxRUmVilJjTo7evPnnDtBVoLAZ2XNuPgXFIT19eNo4Ix
         fx7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683917737; x=1686509737;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Apu6D8O64dOrAgLxicGzFFoIWOvMx7nXa8biHwBcP24=;
        b=kyMFszTnFN78VABZ8+L05/Htyf6ZyBvldhXUnPgasT6pdMSvkuffhg3nYRamyjQdS4
         qcKc+C7HQelj8Gm/Ph8ec63p3ZJ7ZZ/q8+zkRcvBbprPevvNEgBIIdBK+K5lxeieEauf
         k66MNeJb+qmUlNsiEL/i8SzNIFRI2wa8quvZ6/70dWPcEU6a1YozHEeWdCaCEY1QR82A
         +i3XwJ3xdgvBGvzn/C6JQwNVe2LRh3WKjX+Rv1j7b6UGZxj5iMxXgdq2Djs6VRE+DINW
         S3w8I+mzftbVaNzSVL7uwOQR4MlEOzW5TXtydGzfNRTSE2hT6gsK6M9761BfP4NSeZvG
         n/BA==
X-Gm-Message-State: AC+VfDyokwtG5O5znqVCxw5ozZqHu7vOoJiPhbNiIU0yAFVWCeTqpiaI
	tJ0/7Zs3/aUezFV8lt+omt0z2wN1e0/CjP540/tUk4dj
X-Google-Smtp-Source: ACHHUZ4vjG622xV08WuerLXcZ5Gz7pGTL6uHkQN7SLM7V6/fhvARbggbqXwEYzW6FnQqELu0zbPxADoyO2i3FdHVPIk=
X-Received: by 2002:a05:6902:18c7:b0:b99:75f:8f24 with SMTP id
 ck7-20020a05690218c700b00b99075f8f24mr31640757ybb.30.1683917737003; Fri, 12
 May 2023 11:55:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <e995c2a2b885e11d744e9c2743032d16e4fe9baa.1683847331.git.lucien.xin@gmail.com>
In-Reply-To: <e995c2a2b885e11d744e9c2743032d16e4fe9baa.1683847331.git.lucien.xin@gmail.com>
From: William Tu <u9012063@gmail.com>
Date: Fri, 12 May 2023 11:55:01 -0700
Message-ID: <CALDO+Saq9yJ34KRK5n-e=TvKYLO9PXG=0h9jOh2J0GMkpPQyLA@mail.gmail.com>
Subject: Re: [PATCH net] erspan: get the proto with the md version for collect_md
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, davem@davemloft.net, kuba@kernel.org, 
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, 
	Kevin Traynor <ktraynor@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
	FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 11, 2023 at 4:22=E2=80=AFPM Xin Long <lucien.xin@gmail.com> wro=
te:
>
> In commit 20704bd1633d ("erspan: build the header with the right proto
> according to erspan_ver"), it gets the proto with t->parms.erspan_ver,
> but t->parms.erspan_ver is not used by collect_md branch, and instead
> it should get the proto with md->version for collect_md.
>
> Thanks to Kevin for pointing this out.
>
> Fixes: 94d7d8f29287 ("ip6_gre: add erspan v2 support")
> Reported-by: Kevin Traynor <ktraynor@redhat.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---

Hi Xin,
LGTM, thanks for fixing this.
Reviewed-by: William Tu <u9012063@gmail.com>

