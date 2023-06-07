Return-Path: <netdev+bounces-9031-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 483917269F6
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 21:39:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A47A91C20E44
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 19:39:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D6A73922C;
	Wed,  7 Jun 2023 19:39:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9174112B79
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 19:39:50 +0000 (UTC)
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFBAD2102
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 12:39:46 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id af79cd13be357-75d13719304so646934185a.3
        for <netdev@vger.kernel.org>; Wed, 07 Jun 2023 12:39:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686166786; x=1688758786;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E3Jak5vd5NN7d5hRbbDSPeXyPKN/kyVEZtBYcqaTqUk=;
        b=MWD7ELCsmg6YQqlEEq1EyAFxWcI+XYIWgniKv+IxOqwrnWMHPlrUNhTZow1l8huru+
         HV4xki4FJJZgmlCH1zKI0ZVnvvzVX946fYuI6njcj9rtWHINEJSvj4jG0grXwYFLWeb5
         4+lj/RGSY+QlTacmcMNvoQvK9gCZBP/nh5s0CYcCQSoZZXJISK/myfYFnUDmyzKVX6kc
         xdwu+CB+TvENJkv9sWkjw0h1f89OgQLQtM6R8VTe6LlU60XfRsfXkG5mFx14r3JMqAZL
         15+mDMNoSdPjEwPIsW4clrnK38Vxo+Ea7+goh8vn5jcSTXi+mgI7xcC0q7bH3/w9zlEb
         7AMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686166786; x=1688758786;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=E3Jak5vd5NN7d5hRbbDSPeXyPKN/kyVEZtBYcqaTqUk=;
        b=U6m1y/bITT3ClxJPqroVoNX/W/hOwn/tACr/cQYjj4YCVNcvD2cbP39k/XmykLyiO/
         3e+sCsT7Hdj0/yKLagEqWYOuMRORzqI3PRBfGFOF2TVXhatV9i7IoO432XRpjul6mweN
         lyva5qtb0HsgcIBP8cO37AB0ojeyIURD+vasShkcvQNbDaPAJA7avWYA7y0Qa4JjcKpd
         UepE/+ibm3sn787Rc+OcVl879Bmm26i/N2KdDo4aQw7FXY94LOl/UkB6Pww8GGzEtt5W
         VkQqvYrOHWOgDWfyKofVx9he3vWfwOwNOiDtdkACwbwUBMdbzTvpz4zIbU4HgrNsE0Ce
         4skA==
X-Gm-Message-State: AC+VfDxALP0nG6FMNobbMn2T5irKe+0FqhvTPQuzf6nFQ1MAwXXiESv8
	J7ubBLUmAPHdESuKheqSXW5GA6SasYHzfapXLLo=
X-Google-Smtp-Source: ACHHUZ5jJsZi5wO4RVNf8VTv4tRjcqj9fujc5xBFqCScff8DXOt3lbYRy0Vbg0bftOHCJ/XSgG0DxR/wyVa0duEPVoA=
X-Received: by 2002:a1f:c114:0:b0:457:d0a:42d1 with SMTP id
 r20-20020a1fc114000000b004570d0a42d1mr1932370vkf.9.1686166785678; Wed, 07 Jun
 2023 12:39:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230530234501.2680230-1-anthony.l.nguyen@intel.com>
 <20230530234501.2680230-6-anthony.l.nguyen@intel.com> <20230531232239.5db93c09@kernel.org>
 <3fe3bf2a-6cb2-c3a1-3fa3-ed9a5425e603@intel.com> <CAF=yD-KAQceDE9UmJAvepz8tWGgqyr+drv_WYp-q=7vEEUTfiA@mail.gmail.com>
 <20230607121006.59d57ca0@kernel.org>
In-Reply-To: <20230607121006.59d57ca0@kernel.org>
From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date: Wed, 7 Jun 2023 21:39:09 +0200
Message-ID: <CAF=yD-LUfyz9M4cKyE_eJUfWGzqtnVZDz4dH=PU2X1zz7N-9gA@mail.gmail.com>
Subject: Re: [PATCH net-next 05/15] idpf: add create vport and netdev configuration
To: Jakub Kicinski <kuba@kernel.org>
Cc: "Linga, Pavan Kumar" <pavan.kumar.linga@intel.com>, Tony Nguyen <anthony.l.nguyen@intel.com>, 
	davem@davemloft.net, pabeni@redhat.com, edumazet@google.com, 
	netdev@vger.kernel.org, emil.s.tantilov@intel.com, jesse.brandeburg@intel.com, 
	sridhar.samudrala@intel.com, shiraz.saleem@intel.com, sindhu.devale@intel.com, 
	willemb@google.com, decot@google.com, andrew@lunn.ch, leon@kernel.org, 
	mst@redhat.com, simon.horman@corigine.com, shannon.nelson@amd.com, 
	stephen@networkplumber.org, Alan Brady <alan.brady@intel.com>, 
	Joshua Hay <joshua.a.hay@intel.com>, Madhu Chittim <madhu.chittim@intel.com>, 
	Phani Burra <phani.r.burra@intel.com>, 
	Shailendra Bhatnagar <shailendra.bhatnagar@intel.com>, 
	Krishneil Singh <krishneil.k.singh@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, Jun 7, 2023 at 9:10=E2=80=AFPM Jakub Kicinski <kuba@kernel.org> wro=
te:
>
> On Wed, 7 Jun 2023 20:20:57 +0200 Willem de Bruijn wrote:
> > > > Please use locks. Every single Intel driver comes with gazillion fl=
ags
> > > > and endless bugs when the flags go out of sync.
> > >
> > > Thanks for the feedback. Will use mutex lock instead of 'VC_MSG_PENDI=
NG'
> > > flag.
> >
> > Was that the intent of the comment?
> >
> > Or is it to replace these individual atomic test_and_set bit
> > operations with a single spinlock-protected critical section around
> > all the flag operations?
>
> No, no. Intel drivers have a history of adding flags to work around
> locking problems. Whatever this bit is protecting should be protected
> by a normal synchronization primitive instead.

Got it. Thanks for clarifying.

> I don't understand why.
>
> Replacing an atomic bitop with a spin lock is a non-change.

