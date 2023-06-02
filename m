Return-Path: <netdev+bounces-7595-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B821720C3B
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 01:16:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 50CFA281B1A
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 23:16:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AA3DC2E3;
	Fri,  2 Jun 2023 23:16:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CEEEC141
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 23:16:55 +0000 (UTC)
Received: from mail-yw1-x112a.google.com (mail-yw1-x112a.google.com [IPv6:2607:f8b0:4864:20::112a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3413123;
	Fri,  2 Jun 2023 16:16:50 -0700 (PDT)
Received: by mail-yw1-x112a.google.com with SMTP id 00721157ae682-565ba2c7554so27244987b3.3;
        Fri, 02 Jun 2023 16:16:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685747810; x=1688339810;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pNwliMKobCXtdO/si4Y3A+t6CcwMuWL8q/4P8sFnIjA=;
        b=UckfgwmKQA2cSEHE/6i4sgkEzADXF/46J2goOgxBCeKZKabFUdJzQUxAUAkovnWpXN
         diw/xMi18QdbsSUmdbYw++khW3L1wXD9wFAAfRelW2rCaPVzmr9eoEOfJXJy2bDxBNVR
         hCj42Ad/xNnBo/pqyr7kP4r4ETk9inlTuKYTm/1N3d7uLIQt5nLyOt7IoG1HtRs3Voxb
         Crw4HCoQO/8GLDwFWuhlUIc5iFsyJwSl2boL6uVfjWUQPTVRP4eH416L1GwCjYEHrGoK
         /D2NqV2xWGiEySnB/w1SvGY0GUUenmoJGjrChPqCUhq0XvjPdCbPAavP5jhthv28bf0i
         j21w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685747810; x=1688339810;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pNwliMKobCXtdO/si4Y3A+t6CcwMuWL8q/4P8sFnIjA=;
        b=E4xcQ3+4c8j1l4rSMigfENCEp48XYDex9FjjAWGDjtkvZv7jgei8zVHbf8Y1RlQyLk
         1myx5Af/bY2OHaj7p+IG2U2S3q5rkOQtu3ipmlA+xgwmUIaqTDysTLs5NdeCwcr0fEWx
         uKW8IbO5j8VkteE4YyVztVSu5YPhNkLAYxMjmO5yHoxcoSW1cx87wGfA/b6qUD+RMf06
         /ew0eRiHCQrLmPNFygnZVSE/odleo1yaOmwVWkmTQNsZd/K73CBAiO6E41vDJx47GexN
         JrTlqOuFcOToo7tpE7SAaBohXssyV3iZMbvD4OwnnTXapdIhxqE9GQnPxgHVUUM7bAgE
         /yzQ==
X-Gm-Message-State: AC+VfDwOLoCn2MDhEdefLhPkXDnGK/XB2wDCygkQQuaR+r0RRZJG/Byx
	2bwPsu/08Jiwl0RvcazKC43lWvZcSWRdrnd2ges=
X-Google-Smtp-Source: ACHHUZ7KF11sXYnchuLIO7iEqA9qCfIeWUKuJtkhh9/sOhxKMMi5qIlXuVPaZo3kIBFs/5VX9w4MsBPiAbizE7XrSv0=
X-Received: by 2002:a81:48cc:0:b0:54f:752e:9e60 with SMTP id
 v195-20020a8148cc000000b0054f752e9e60mr1425182ywa.37.1685747809851; Fri, 02
 Jun 2023 16:16:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <1685643474-18654-1-git-send-email-kashwindayan@vmware.com> <ZHoHfcMgYqO3l7Np@corigine.com>
In-Reply-To: <ZHoHfcMgYqO3l7Np@corigine.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Fri, 2 Jun 2023 19:16:09 -0400
Message-ID: <CADvbK_fCPPHto4XjPeTJPJ9NTXoJGgO7jjEcy1Bq3nQSFAzR9A@mail.gmail.com>
Subject: Re: [PATCH v3] net/sctp: Make sha1 as default algorithm if fips is enabled
To: Simon Horman <simon.horman@corigine.com>
Cc: Ashwin Dayanand Kamat <kashwindayan@vmware.com>, Vlad Yasevich <vyasevich@gmail.com>, 
	Neil Horman <nhorman@tuxdriver.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, 
	"David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, linux-sctp@vger.kernel.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, amakhalov@vmware.com, 
	vsirnapalli@vmware.com, akaher@vmware.com, tkundu@vmware.com, 
	keerthanak@vmware.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 2, 2023 at 11:15=E2=80=AFAM Simon Horman <simon.horman@corigine=
.com> wrote:
>
> + Xin Long
>
> On Thu, Jun 01, 2023 at 11:47:54PM +0530, Ashwin Dayanand Kamat wrote:
> > MD5 is not FIPS compliant. But still md5 was used as the
> > default algorithm for sctp if fips was enabled.
> > Due to this, listen() system call in ltp tests was
> > failing for sctp in fips environment, with below error message.
> >
> > [ 6397.892677] sctp: failed to load transform for md5: -2
> >
> > Fix is to not assign md5 as default algorithm for sctp
> > if fips_enabled is true. Instead make sha1 as default algorithm.
> > The issue fixes ltp testcase failure "cve-2018-5803 sctp_big_chunk"
Hi, Ashwin,

I have the same question as Paolo about "this patch gets fips compliance
_disabling_ the encryption", is it from any standard?

If not,  can't you fix the ltp testcase for fips environment by sysctl?
or set 'CONFIG_SCTP_DEFAULT_COOKIE_HMAC_SHA1=3Dy' instead in config.

Sorry if I don't understand this well. You're trying to avoid SCTP code
calling crypto_alloc_shash(MD5), right? What about other places
where it may also do it in kernel? (where ltp just doesn't cover)

I don't think it makes sense to let SCTP have some code reply on
FIPS only to make ltp testcase happy, while we can actually fix it
in ltp by "sysctl".

Thanks.


> >
> > Signed-off-by: Ashwin Dayanand Kamat <kashwindayan@vmware.com>
> > ---
> > v3:
> > * Resolved hunk failures.
> > * Changed the ratelimited notice to be more meaningful.
> > * Used ternary condition for if/else condtion.
> > v2:
> > * The listener can still fail if fips mode is enabled after
> >   that the netns is initialized.
> > * Fixed this in sctp_listen_start() as suggested by
> >   Paolo Abeni <pabeni@redhat.com>
>
> FWIIW, this seems reasonable to me.
>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>

