Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 919A76F4953
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 19:49:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233455AbjEBRtk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 13:49:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjEBRtj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 13:49:39 -0400
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78F1C13A;
        Tue,  2 May 2023 10:49:38 -0700 (PDT)
Received: by mail-oi1-x232.google.com with SMTP id 5614622812f47-38dfa504391so2487483b6e.3;
        Tue, 02 May 2023 10:49:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683049777; x=1685641777;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=AiYQK3LDS9b+aANy8EM0VPV2YGfyW4MmQiZSALWg0Bg=;
        b=TtmTSphKyWgoi/BppYoDen5j4A3wgW7PHyGJwVi3DUr1YlqdpBkywBSUc5zLCHjeH7
         qpRiCv9cWgtsvlKVkKGsvsB+W5FUzTuo94GdBS5cv1sdDL18q/BkfKWBWKOGtyipNKrZ
         3g1FFuZgfAptLhB2IgXJhaAx1aCQ4r2pQcyzqsjFp0cDxFvnldpoXesmqp/DSiZ4XdgJ
         vZo2DfuGXTFxEJK1Jb+w4/nA+3IS1qXPagTxIaWfBirfVykz7uPvrJx5nXv6Fzx2ctDk
         j9HwSDVcU1DX5VSgCVaHs0PLe3YhGSnogp9+7+HgLDoxfDcvnR6/C7IZjIOsuozPhMgv
         z66A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683049777; x=1685641777;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AiYQK3LDS9b+aANy8EM0VPV2YGfyW4MmQiZSALWg0Bg=;
        b=Nwu4I1qxqXUs5XhJizKXOlqd4JOmDf9rjPw4SAejXLfkchgpdOl+SgPBUCjm9Se08x
         AViKDOlD7isGVKblPTfB/z1q9xMGqsnzpDx8cu4Nqm8fpAVgJTvdjQ0Qnm25BYxpk0fk
         7d3QSS0BfAOgVRHCwcBCn+df487XbII8kcM84nnL0VKqYi8iti/8mUc/tgmBroSbLwGk
         nDwoyHU3Hr2vSHqwZeDboE9pjR8cwWB0qVICEfGGdPlVIQkOk1tK5sXn4pT2KMpPwvbe
         EhZM9GwFwYdUjx08pPm25PCaLHY22BPR8l9SCbkr6xS9WIe03uXw7+RzwCn+86cm3V/w
         Y6lQ==
X-Gm-Message-State: AC+VfDyF/ZHaNUzhqdyqUGrs5fO5OY/7V4J0VxDPcgUWwZtGJNexmoaH
        uaFyCIoZoYTqmE24AjSID8I=
X-Google-Smtp-Source: ACHHUZ4mzV6fTIXz8QuoeH7zEVpDjTfzdGUBpE3pACo9E+FIP6e1ZwPG/VyjBBABwOAcFB8v1IbKOQ==
X-Received: by 2002:a05:6808:693:b0:38e:b9b:a85c with SMTP id k19-20020a056808069300b0038e0b9ba85cmr8438111oig.53.1683049777498;
        Tue, 02 May 2023 10:49:37 -0700 (PDT)
Received: from t14s.localdomain ([177.92.48.92])
        by smtp.gmail.com with ESMTPSA id n11-20020a0568080a0b00b003923e412668sm1206351oij.50.2023.05.02.10.49.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 May 2023 10:49:36 -0700 (PDT)
Received: by t14s.localdomain (Postfix, from userid 1000)
        id 0AFD359EE1A; Tue,  2 May 2023 14:49:34 -0300 (-03)
Date:   Tue, 2 May 2023 14:49:34 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     ilia.gavrilov@infotecs.ru, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-sctp@vger.kernel.org, lucien.xin@gmail.com,
        lvc-project@linuxtesting.org, netdev@vger.kernel.org,
        nhorman@tuxdriver.com, pabeni@redhat.com, simon.horman@corigine.com
Subject: Re: [PATCH net v2] sctp: fix a potential buffer overflow in
 sctp_sched_set_sched()
Message-ID: <ZFFNLtBYepvBzoPr@t14s.localdomain>
References: <20230502130316.2680585-1-Ilia.Gavrilov@infotecs.ru>
 <20230502170516.39760-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230502170516.39760-1-kuniyu@amazon.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 02, 2023 at 10:05:16AM -0700, Kuniyuki Iwashima wrote:
> From:   Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>
> Date:   Tue, 2 May 2023 13:03:24 +0000
> > The 'sched' index value must be checked before accessing an element
> > of the 'sctp_sched_ops' array. Otherwise, it can lead to buffer overflow.
> 
> OOB access ?

My thought as well.

> But it's not true because it does not happen in the first place.
> 
> > 
> > Note that it's harmless since the 'sched' parameter is checked before
> > calling 'sctp_sched_set_sched'.
> > 
> > Found by InfoTeCS on behalf of Linux Verification Center
> > (linuxtesting.org) with SVACE.
> > 
> > Fixes: 5bbbbe32a431 ("sctp: introduce stream scheduler foundations")
> > Reviewed-by: Simon Horman <simon.horman@corigine.com>
> > Signed-off-by: Ilia.Gavrilov <Ilia.Gavrilov@infotecs.ru>
> > ---
> > V2:
> >  - Change the order of local variables 
> >  - Specify the target tree in the subject
> >  net/sctp/stream_sched.c | 9 +++++----
> >  1 file changed, 5 insertions(+), 4 deletions(-)
> > 
> > diff --git a/net/sctp/stream_sched.c b/net/sctp/stream_sched.c
> > index 330067002deb..4d076a9b8592 100644
> > --- a/net/sctp/stream_sched.c
> > +++ b/net/sctp/stream_sched.c
> > @@ -146,18 +146,19 @@ static void sctp_sched_free_sched(struct sctp_stream *stream)
> >  int sctp_sched_set_sched(struct sctp_association *asoc,
> >  			 enum sctp_sched_type sched)
> >  {
> > -	struct sctp_sched_ops *n = sctp_sched_ops[sched];
> >  	struct sctp_sched_ops *old = asoc->outqueue.sched;
> >  	struct sctp_datamsg *msg = NULL;
> > +	struct sctp_sched_ops *n;
> >  	struct sctp_chunk *ch;
> >  	int i, ret = 0;
> >  
> > -	if (old == n)
> > -		return ret;
> > -
> >  	if (sched > SCTP_SS_MAX)
> >  		return -EINVAL;
> 
> I'd just remove this check instead because the same test is done
> in the caller side, sctp_setsockopt_scheduler(), and this errno
> is never returned.
> 
> This unnecessary test confuses a reader like sched could be over
> SCTP_SS_MAX here.

It's actualy better to keep the test here and remove it from the
callers: they don't need to know the specifics, and further new calls
will be protected already.

> 
> Since the OOB access does not happen, I think this patch should
> go to net-next without the Fixes tag after the merge window.

Yup.

> 
> Thanks,
> Kuniyuki
> 
> 
> >  
> > +	n = sctp_sched_ops[sched];
> > +	if (old == n)
> > +		return ret;
> > +
> >  	if (old)
> >  		sctp_sched_free_sched(&asoc->stream);
> >  
> > -- 
> > 2.30.2
