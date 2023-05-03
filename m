Return-Path: <netdev+bounces-154-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0CDD86F5823
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 14:47:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 44D1928155C
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 12:47:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D909D519;
	Wed,  3 May 2023 12:47:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02A4B46AC
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 12:47:44 +0000 (UTC)
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BD6B5FCF;
	Wed,  3 May 2023 05:47:28 -0700 (PDT)
Received: by mail-ot1-x32b.google.com with SMTP id 46e09a7af769-6a5d9853d97so2022657a34.2;
        Wed, 03 May 2023 05:47:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683118047; x=1685710047;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=NigIXQjygNqUGbl1KyWfMasETKpvGp2yq5YCtYgRjcI=;
        b=jOtKThdI61HhCtBnoYvsufzmPdi73uZXHVTmOVsFgxS+zmG0qXxbloV0SxaAB9KYw1
         X2OcU28s/1OjTasWNDU8sMCEHvRf4hK4XS7v16Ewh6U8dBnCHGmTqv4yqBdQaQf5vh0G
         xHs5to0rCaiXSrruNvmh7Y8imJ5ee5NKMxgmZoAFCxmoqCOz7dzjKXvH/EUtCk5flKap
         Vyt5eoUbW5rgc4yaoAH5UluXZK02T9yQ2qE0TjqEg4Mlix9SjfGn14KCYVOJdAFzcKFR
         UvV30Eds2mayxN8tEeSRNiHhZ+o9ZSg7k9SAR/T31FQTrNzeKP19HLY3S/AJCBwGYuv4
         5TnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683118047; x=1685710047;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NigIXQjygNqUGbl1KyWfMasETKpvGp2yq5YCtYgRjcI=;
        b=FymYKitPe7IgHIxJ1qf1ogAaMJnMqqcTwewqpcCO9hyR8b+slwsJ6rO+X+noxVNF26
         WFYV9qchGnySLvwOxHsmDpE4tt4rb7SdDAolJuynRuTPSITgpgIZFdUA38lfTcxyYLO+
         imTETdatml0nB4MxFZdLx7Nbc6GmBCx2ogkky8zExM0yhbEPR+w2jszMQJFgqxegIIpv
         Sb5RS1m5PKmW3rc3i49IfZi3Gh/UPSoDd9WrmySL3Kn7n676VQc0/70OAWv6TWJ/Pk6t
         Z8Nq+eO2FPtMTPNAUtQuGTMCMZu1slPGBPofgKB69yfC3TfaHxZ38tH9+2Q+TkPul2uR
         cPtA==
X-Gm-Message-State: AC+VfDwGZZ4FTmujgLDxqTyMlv57MDXe8tkXrEuAs/kWFymeoQzqzgv/
	ZLmXwrdfGhR48eFtBbfjeKU=
X-Google-Smtp-Source: ACHHUZ4lV5Q5gRDnWfk4wuFidmh40kCsC9iQ7DNhkB4SOa2RK40ED6smSwBIbVoScpfeibVZ5EZfMw==
X-Received: by 2002:a05:6830:10c6:b0:6a5:f839:17f4 with SMTP id z6-20020a05683010c600b006a5f83917f4mr10269385oto.0.1683118047332;
        Wed, 03 May 2023 05:47:27 -0700 (PDT)
Received: from t14s.localdomain ([177.92.48.92])
        by smtp.gmail.com with ESMTPSA id dm13-20020a0568303b8d00b006a5e22458e9sm524305otb.80.2023.05.03.05.47.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 May 2023 05:47:26 -0700 (PDT)
Received: by t14s.localdomain (Postfix, from userid 1000)
	id 8135759F008; Wed,  3 May 2023 09:47:24 -0300 (-03)
Date: Wed, 3 May 2023 09:47:24 -0300
From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To: Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>
Cc: Kuniyuki Iwashima <kuniyu@amazon.com>,
	"davem@davemloft.net" <davem@davemloft.net>,
	"edumazet@google.com" <edumazet@google.com>,
	"kuba@kernel.org" <kuba@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
	"lucien.xin@gmail.com" <lucien.xin@gmail.com>,
	"lvc-project@linuxtesting.org" <lvc-project@linuxtesting.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"nhorman@tuxdriver.com" <nhorman@tuxdriver.com>,
	"pabeni@redhat.com" <pabeni@redhat.com>,
	"simon.horman@corigine.com" <simon.horman@corigine.com>
Subject: Re: [PATCH net v2] sctp: fix a potential buffer overflow in
 sctp_sched_set_sched()
Message-ID: <ZFJX3KLkcu4nON7l@t14s.localdomain>
References: <20230502130316.2680585-1-Ilia.Gavrilov@infotecs.ru>
 <20230502170516.39760-1-kuniyu@amazon.com>
 <ZFFNLtBYepvBzoPr@t14s.localdomain>
 <95bc9b12-9e1e-5054-c2df-ad9201d94ed5@infotecs.ru>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <95bc9b12-9e1e-5054-c2df-ad9201d94ed5@infotecs.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 03, 2023 at 09:08:17AM +0000, Gavrilov Ilia wrote:
> >> This unnecessary test confuses a reader like sched could be over
> >> SCTP_SS_MAX here.
> >
> > It's actualy better to keep the test here and remove it from the
> > callers: they don't need to know the specifics, and further new calls
> > will be protected already.
> >
> 
> I agree that the check should be removed, but I think it's better to
> keep the test on the calling side, because params->assoc_value is set as
> the default "stream schedule" for the socket and it needs to be checked too.
> 
> static int sctp_setsockopt_scheduler(..., struct sctp_assoc_value
> *params, ...)
> {
> ...
>    if (params->assoc_id == SCTP_FUTURE_ASSOC ||
>        params->assoc_id == SCTP_ALL_ASSOC)
>        sp->default_ss = params->assoc_value;
> ...
> }

Good point. But then, don't remove the check. Instead, just fix that
ordering and make it less confusing.  Otherwise you will be really
making it prone to the OOB if a new call gets added that doesn't
validate the parameter.

Thanks,
Marcelo

