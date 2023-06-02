Return-Path: <netdev+bounces-7417-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7773A720252
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 14:43:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2E65628188F
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 12:43:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B83B1774A;
	Fri,  2 Jun 2023 12:43:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FFF915BF
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 12:43:28 +0000 (UTC)
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 166FD1B4
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 05:43:20 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id 5b1f17b1804b1-3f70597707eso72065e9.0
        for <netdev@vger.kernel.org>; Fri, 02 Jun 2023 05:43:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685709798; x=1688301798;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cRXpWCFDEJuFO+sgap5Gq9jFXAcAG+6Y5CPTtnqvosQ=;
        b=HgyMQgDK0VLmj5VwU1m4cMsJeVTDKjrin1Y7NCOXW0eXEKwgB5b4vqFhkcv/NMlRi6
         TADoh1uh/dN7xMGNHNT8q/w4PdTGuaIWeCRjbkMDUOupFy8lAf3g12h79RDDmz9XsCb/
         /SBOunWu8t6rJIGuaiZUKMPGFsQDV24n9PfN0Cn6bC7vzy9x8PatddFxCY5OsnpOzRiZ
         wD8uiNY/fyDqwtPziz03ayQRYHBmGTBrlTL9/SLoGurtOb4JkLpoLmVGHL2XXy1SNjI0
         3tI2rP0VRRNMeXgsbIStgMVLNcm1NfvL4yIxF/pGiKRf1t1DwPiNC+VqFxg0vNOd4/VU
         +3aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685709798; x=1688301798;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cRXpWCFDEJuFO+sgap5Gq9jFXAcAG+6Y5CPTtnqvosQ=;
        b=SQnLTDAFXbG9LuaT+L9zZbqHavUJJ1NUHy2bqzbSpPT90MCHMpWs6BKydbdAS9OL2j
         llYZI/IZRPqAZzAfKwwzSE/rPBXUeL+vX2XMaXkGfJE4DvNdIYovyfSFdNOrgzHUI+ej
         pceEXUqPHyRKsxVSibGh7FjeRItGUO113fWlUINhezQixiqkkhm93jhp5YOAy/rye9wN
         kob9yostVLFSC5A1VXImYICJcunPrd9VorW7WybDKgs4WnZUF6pVRh1kstZLd4yEsJZU
         2yoLyf60YJl1ycCvRJnquJQMOqyyEkRZTHzuCcws3761I2+sQf2tNoyvlZuFJOV0e1fX
         K12A==
X-Gm-Message-State: AC+VfDxpQ8sjbuwn7PKg46b4SMAquhSWIUl6TkD6cguMwd+KgNAdnZaQ
	vJP699wkYIZ7QFccO4CiEMZf0I3ag6ImHd4DZWK8fA==
X-Google-Smtp-Source: ACHHUZ71kbqY05Q45BEhjVeKEoDQw6BA+JYl5z60gPhCXFtqcUlevfebxuImf199eurulm8psbO/xNTo8DTU+jyynII=
X-Received: by 2002:a05:600c:3b97:b0:3f1:6839:74a1 with SMTP id
 n23-20020a05600c3b9700b003f1683974a1mr192782wms.6.1685709798352; Fri, 02 Jun
 2023 05:43:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230601-net-next-skip_print_link_becomes_ready-v1-1-7ff2b88dc9b8@tessares.net>
In-Reply-To: <20230601-net-next-skip_print_link_becomes_ready-v1-1-7ff2b88dc9b8@tessares.net>
From: Eric Dumazet <edumazet@google.com>
Date: Fri, 2 Jun 2023 14:43:06 +0200
Message-ID: <CANn89iKrpE7TVb8pTC+pWFDPJ2xcL3s9BhFB6DPxjK34he5RwQ@mail.gmail.com>
Subject: Re: [PATCH net-next] ipv6: lower "link become ready"'s level message
To: Matthieu Baerts <matthieu.baerts@tessares.net>
Cc: mptcp@lists.linux.dev, "David S. Miller" <davem@davemloft.net>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, David Ahern <dsahern@kernel.org>, 
	Mat Martineau <martineau@kernel.org>, Stephen Hemminger <stephen@networkplumber.org>, 
	Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 2, 2023 at 11:36=E2=80=AFAM Matthieu Baerts
<matthieu.baerts@tessares.net> wrote:
>
> This following message is printed in the console each time a network
> device configured with an IPv6 addresses is ready to be used:
>
>   ADDRCONF(NETDEV_CHANGE): <iface>: link becomes ready
>
> When netns are being extensively used -- e.g. by re-creating netns' with
> veth to discuss with each others for testing purposes like mptcp_join.sh
> selftest does -- it generates a lot of messages like that: more than 700
> when executing mptcp_join.sh with the latest version.
>
> It looks like this message is not that helpful after all: maybe it can
> be used as a sign to know if there is something wrong, e.g. if a device
> is being regularly reconfigured by accident? But even then, there are
> better ways to monitor and diagnose such issues.
>
> When looking at commit 3c21edbd1137 ("[IPV6]: Defer IPv6 device
> initialization until the link becomes ready.") which introduces this new
> message, it seems it had been added to verify that the new feature was
> working as expected. It could have then used a lower level than "info"
> from the beginning but it was fine like that back then: 17 years ago.
>
> It seems then OK today to simply lower its level, similar to commit
> 7c62b8dd5ca8 ("net/ipv6: lower the level of "link is not ready" messages"=
)
> and as suggested by Mat [1], Stephen and David [2].
>
> Link: https://lore.kernel.org/mptcp/614e76ac-184e-c553-af72-084f792e60b0@=
kernel.org/T/ [1]
> Link: https://lore.kernel.org/netdev/68035bad-b53e-91cb-0e4a-007f27d62b05=
@tessares.net/T/ [2]
> Suggested-by: Mat Martineau <martineau@kernel.org>
> Suggested-by: Stephen Hemminger <stephen@networkplumber.org>
> Suggested-by: David Ahern <dsahern@kernel.org>
> Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
> ---

Reviewed-by: Eric Dumazet <edumazet@google.com>

