Return-Path: <netdev+bounces-9120-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B23C7275FD
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 06:13:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 72288281636
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 04:13:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7EACD1C38;
	Thu,  8 Jun 2023 04:13:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73B3F1C35
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 04:13:19 +0000 (UTC)
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D035A1721
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 21:13:17 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id 5b1f17b1804b1-3f7359a3b78so42375e9.0
        for <netdev@vger.kernel.org>; Wed, 07 Jun 2023 21:13:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686197596; x=1688789596;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M/XsvCUj2CGrnP0CPZnWpYzQ9jaGyy1138TlKWc5IUo=;
        b=jkCSDGce0KUakB/kj5ENqEhkCdst3QS2xlq7D77TmnaWH+BBB9wZlRkiB8Bs5gIRky
         CWRXNXxEpcEtmcT5kKmPHLMhdJ0rcCadMzNJwyP908+NpHa5f63LRHXAdVmTRiqeqGkA
         uda1KkWA1OQjhU7CRX4JcehtGqkq6Nd/gND4OBYAKJ0Z7FLZBKdTUuLfE4+2D/MsRN1y
         ktXBhAWBc7AU5TUPfVmlWouTEpWIWwpyjnp4MfIZyrgkf9/uBPR6y2bjFqTyyC6BExEw
         cWUG6dtKobtz0gxX0gmbLj7gC0yYyu392qdy2st3Dl+HQQSG1xXWGi+G1DRZv9NNnVcD
         zV6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686197596; x=1688789596;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=M/XsvCUj2CGrnP0CPZnWpYzQ9jaGyy1138TlKWc5IUo=;
        b=Q5pQBKOVarOvQ/o4jIck0KK2iy+2j9QYFl4RvsePzCVBTQTwpOE9R4aX71bK0u+CuR
         9H8Bi3E+cUnzp2ssbhZW7sUkYzALcxZA/yGGxY0my/I0X5Yv0IImJ7IhZ9xW3jHsBfk1
         A0mkx6fNP6fDr7lohoW8xkpPPNe+PEfnfgVEUWB+fQJtjKZifxmMfnQmR35EfJIi5h5m
         q9QrAk1nLqL8ItCtfoVNT0j7xVebkR/jOexjtxgIwdNfCHW/aaumqiF6N7OivTdfvDrO
         v33yxDdXdeliwSTjg97UMre2uOU/WCxulUSKaPq+3qJxi51Kp3PD1kk8oOvu1kEUSw0g
         41BA==
X-Gm-Message-State: AC+VfDzbYAWqlZMNgwc/52gZqTCr1/fynCEtLjsgvlGIQwLCoOr9bKrv
	bfbBdZSAxCKgDKfQlSKKBwBwNt7HeBkIFOSRH/kP94me8HzqXTh2PlU=
X-Google-Smtp-Source: ACHHUZ6k8imAYQmKwTPa6Xs32DDV0hLLo0bc60B3U2S0TtnZtIXDaHejOPQ+g+4NMelhPLTHuquY8WFM7uPYJN8c3Q4=
X-Received: by 2002:a7b:ca47:0:b0:3f1:73b8:b5fe with SMTP id
 m7-20020a7bca47000000b003f173b8b5femr94249wml.3.1686197596051; Wed, 07 Jun
 2023 21:13:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230606064306.9192-1-duanmuquan@baidu.com> <CANn89iKwzEtNWME+1Xb57DcT=xpWaBf59hRT4dYrw-jsTdqeLA@mail.gmail.com>
 <DFBEBE81-34A5-4394-9C5B-1A849A6415F1@baidu.com> <CANn89iLm=UeSLBVjACnqyaLo7oMTrY7Ok8RXP9oGDHVwe8LVng@mail.gmail.com>
 <D8D0327E-CEF0-4DFC-83AB-BC20EE3DFCDE@baidu.com> <CANn89iKXttFLj4WCVjWNeograv=LHta4erhtqm=fpfiEWscJCA@mail.gmail.com>
 <8C32A1F5-1160-4863-9201-CF9346290115@baidu.com>
In-Reply-To: <8C32A1F5-1160-4863-9201-CF9346290115@baidu.com>
From: Eric Dumazet <edumazet@google.com>
Date: Thu, 8 Jun 2023 06:13:04 +0200
Message-ID: <CANn89i+JBhj+g564rfVd9gK7OH48v3N+Ln0vAgJehM5xJh32-g@mail.gmail.com>
Subject: Re: [PATCH v2] tcp: fix connection reset due to tw hashdance race.
To: "Duan,Muquan" <duanmuquan@baidu.com>
Cc: "davem@davemloft.net" <davem@davemloft.net>, "dsahern@kernel.org" <dsahern@kernel.org>, 
	"kuba@kernel.org" <kuba@kernel.org>, "pabeni@redhat.com" <pabeni@redhat.com>, 
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 8, 2023 at 5:59=E2=80=AFAM Duan,Muquan <duanmuquan@baidu.com> w=
rote:
>
> Hi, Eric,
>
> Thanks a lot for your explanation!
>
> Even if we add reader lock,  if set the refcnt outside spin_lock()/spin_u=
nlock(), during the interval between spin_unlock() and refcnt_set(),  other=
 cpus will see the tw sock with refcont 0, and validation for refcnt will f=
ail.
>
> A suggestion, before the tw sock is added into ehash table, it has been a=
lready used by tw timer and bhash chain, we can firstly add refcnt to 2 bef=
ore adding two to ehash table,. or add the refcnt one by one for timer, bha=
sh and ehash. This  can avoid the refcont validation failure on other cpus.
>
> This can reduce the frequency of the connection reset issue from 20 min t=
o 180 min for our product,  We may wait quite a long time before the best s=
olution is ready, if this obvious defect is fixed, userland applications ca=
n benefit from it.
>
> Looking forward to your opinions!

Again, my opinion is that we need a proper fix, not work arounds.

I will work on this a bit later.

In the meantime you can apply locally your patch if you feel this is
what you want.

