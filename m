Return-Path: <netdev+bounces-12215-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0635C736C09
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 14:37:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B92571C20C56
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 12:37:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5795FC1B;
	Tue, 20 Jun 2023 12:37:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D91DCC8F9
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 12:37:05 +0000 (UTC)
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B56DED7
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 05:37:04 -0700 (PDT)
Received: by mail-oi1-x232.google.com with SMTP id 5614622812f47-38dec65ab50so3411508b6e.2
        for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 05:37:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687264624; x=1689856624;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oOUzyBU8AfKs3w+4AjHPQ6H1vCOZyRGUN7rd325+XE4=;
        b=OraYY8mU4kwdUK1aJl0fyENqX9+fdbSxDowDIOXYeNCeAg4mngwMmR69tSWxkG8vH1
         EJ6n15EvFvsOK89JL4hZY7lU4VfiIo4tTV1Aq4kb6sRFxVm4vVVedy5jaVfKEUytHQZt
         FYVJJ3vWIu5+bxaVwnOdGCmJyP9Sa8RNOZN6nLemWAxt0PGiiXcZHjkhCZ30oKrsby9R
         +bcQhpv3RclFHiBy3bnlsk+rGx9CmTz787QybTpIYiav0QvrZakBF1Dowaix+ZUSgLpE
         BP4EtUHr2r9IPECJhD1+BMbzmiLz7YxAVfYJEjv2VPIWxmx73qRvcVXsTdp8pkHE0xFL
         xbUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687264624; x=1689856624;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oOUzyBU8AfKs3w+4AjHPQ6H1vCOZyRGUN7rd325+XE4=;
        b=jduLcTS6XGvbhkg8SsvNi+Sypg/gVpnloUMWkEqgRwS/odmQ7gnEZjjZOzr+y1ygAd
         MLGJv+s2pMhH02Qxn7x5HI2W+sBeDBw1N34TmqeUdHtS1YGUNUg/4kD9D7EDPmnTt/NS
         vaNwa64fJqwNLdyi2F3ckcg0pz8s+yizrKoqBWBjdz8qHknVfbSWNx4hh/5MHur1j+LF
         btxyK5TNRcTxuSDOl+6mer5MhC3V2uEVb6o89tOC3CNYuAyUgBKzMFNNajjXzB4qwVpg
         hM5Kb0YALHpJlRIBD7u6574zBDyrhLQ4rcZ7XLP3hyF1xq3ot6+OazE/UrT+U5+/TZMX
         OpQg==
X-Gm-Message-State: AC+VfDwDnLQet1bNMw2JfoFeRh/H+PdAJyPQKi4hVW4wQqLJFjzlH6ip
	SOXdKqYLmig063gLNqqy+qr6m5YcaxJVIzH9WPODl51P32s=
X-Google-Smtp-Source: ACHHUZ6qENlmk9GCuRZsmvMmVsvouC9y4ihqeII8cs46CSkEjOJCFcUhYvXYBAvsBp1QIJ2tcS9NeUbQ3cQhwyUXRp0=
X-Received: by 2002:a05:6808:20a1:b0:39c:df37:eba9 with SMTP id
 s33-20020a05680820a100b0039cdf37eba9mr15469134oiw.31.1687264623726; Tue, 20
 Jun 2023 05:37:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CADDGra2uwCeiQR6z3O+rHKkZhLHpwO7NG3J_goeX_ieqE-fZkg@mail.gmail.com>
 <CADDGra12cxUhPnrFrWVn7xhbs5TuRpjiOa+wFcPr1FV=+Yemjw@mail.gmail.com>
In-Reply-To: <CADDGra12cxUhPnrFrWVn7xhbs5TuRpjiOa+wFcPr1FV=+Yemjw@mail.gmail.com>
From: Mahendra SP <mahendra.sp@gmail.com>
Date: Tue, 20 Jun 2023 18:06:21 +0530
Message-ID: <CADDGra2kvsqBaL=OY_52th3uvFTpvsGn9u5kgqCZZHu+n81vjQ@mail.gmail.com>
Subject: Re: USGv6 R1 profile test results on kernel version 5.10
To: netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Can someone please help with your inputs for the query?

Thanks
Mahendra

On Thu, Jun 15, 2023 at 11:04=E2=80=AFAM Mahendra SP <mahendra.sp@gmail.com=
> wrote:
>
> Hi All,
>
> We are trying to run the USGv6 R1 profile against the 5.10 kernel
> version. However we see multiple failures w.r.t. RFC 4862 and RFC 8201
> (I can provide failure test details if needed )
> Wanted to check if USGv6 R1 profile has already been run by someone
> and if yes, please let us know if any issues were found or any
> additional patch requirements.
>
> If these failures are expected in 5.10 kernel due to any code change
> dependency, please suggest which higher kernel version needs to be
> used to pass the USGv6 R1 profile.
>
> Thanks
> Mahendra

