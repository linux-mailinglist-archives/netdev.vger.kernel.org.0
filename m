Return-Path: <netdev+bounces-5692-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4DA4E712760
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 15:20:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 066601C21063
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 13:20:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3058E18B17;
	Fri, 26 May 2023 13:20:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 222A718B0C
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 13:20:23 +0000 (UTC)
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 587E812C
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 06:20:18 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id 5b1f17b1804b1-3f603ff9c02so5342065e9.2
        for <netdev@vger.kernel.org>; Fri, 26 May 2023 06:20:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1685107217; x=1687699217;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tQINrp1rONXCHe6H7w31VOnQpsmpECV30LxfyZoDH2Y=;
        b=JTDy1xUZtbNZlQ9HcX37vK8x0vbwOmwLJsTbFNflWUwQDQOuvfDLkBLAE3ivmNfh2y
         KYi2jCkxbBH5tFJCxTSuSWLybm77b1bilX1bAugvVkeJzs1IohVvTV4Z07wQJOKEG5CG
         thkIC9PZKDTfkOVsTanhUTgTD0+twGawjr26IhfL2oIj85yOJU7Fp2DQbIfjmRRbjCNf
         qs15ZZC52Nvdy8AESOCd9tbQEmuEZK9BircVrWbbX+gdU4vORL6cOxVl6vtetQruRrmU
         HJf90Q0xUMlSZS77b1FW85uw+DdFTW3vQKDIZItfBjOYPvNmNQ6Wud+UQdc7x/DFlRSR
         nGlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685107217; x=1687699217;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tQINrp1rONXCHe6H7w31VOnQpsmpECV30LxfyZoDH2Y=;
        b=Jh4gdAid3HuMhKJAOJlTc2SBSqERrurDVQuMvoC/ljew74G8INTqt9pfCeFNlq3zSC
         gVVR0FP/wduMSk3/alkkffpaFKeugNrYLU7ylW1gHDjViP1izhUJ6tKFi3mDVRaetUMM
         XQ6akUgkfUjPkZQJtYPbKIzd4co9n2dVMi4kRKmS1n4XBXVgidx1k8XmJsQk8afT7OvP
         yhLltPOMBsp+H6V1zSz6TKB8Mzfch2JRSH9gNB2kvug/N8nur8bIx5Fnxv7oiHoN3Ste
         81bs2oYbig8N7r55bbI/Pu2FhBjiA+w2dpH1ATSIpM6GCztYruI4wRiqfnOWHe64nv7t
         D43w==
X-Gm-Message-State: AC+VfDxvNs0WR4d65ONUUG2eJ8Aj5/frkA8726KpR5lISafzHKh4ASpe
	J/vEttg8K1d2E9DVDYdIABwLk/avEbEWZZnSxM0=
X-Google-Smtp-Source: ACHHUZ4ikW6D+KwftA6eC2t2dnn3IFyHnr3g07LynxCsbGEY7IY1kHvQ4Ngg1rKR5dNrpnyTgCur8A==
X-Received: by 2002:a05:600c:2948:b0:3f1:92aa:4eb8 with SMTP id n8-20020a05600c294800b003f192aa4eb8mr1450790wmd.16.1685107216850;
        Fri, 26 May 2023 06:20:16 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id g10-20020a5d554a000000b002e5ff05765esm5229256wrw.73.2023.05.26.06.20.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 May 2023 06:20:15 -0700 (PDT)
Date: Fri, 26 May 2023 16:20:12 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: David Howells <dhowells@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Alexander Duyck <alexanderduyck@fb.com>,
	Jesper Dangaard Brouer <brouer@redhat.com>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Kees Cook <keescook@chromium.org>, Jiri Benc <jbenc@redhat.com>,
	netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next] net: fix signedness bug in
 skb_splice_from_iter()
Message-ID: <337838b4-e264-4d4a-87c5-548d49efc5b6@kili.mountain>
References: <99284df8-9190-4deb-ad7c-c0557614a1c8@kili.mountain>
 <760142.1685107058@warthog.procyon.org.uk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <760142.1685107058@warthog.procyon.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 26, 2023 at 02:17:38PM +0100, David Howells wrote:
> Dan Carpenter <dan.carpenter@linaro.org> wrote:
> 
> >  	while (iter->count > 0) {
> >  		ssize_t space, nr;
> > -		size_t off, len;
> > +		ssize_t len;
> > +		size_t off;
> 
> Good point, but why not just move len onto the preceding line?
> 
>  	while (iter->count > 0) {
> -		ssize_t space, nr;
> -		size_t off, len;
> +		ssize_t space, nr, len;
> +		size_t off;

Sure.  Will do.

regards,
dan carpenter


