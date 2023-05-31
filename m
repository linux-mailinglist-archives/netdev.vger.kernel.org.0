Return-Path: <netdev+bounces-6749-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5813C717C4E
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 11:45:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E9BEF1C20E09
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 09:45:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C94612B8E;
	Wed, 31 May 2023 09:45:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DB523D64
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 09:45:38 +0000 (UTC)
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BA1710E;
	Wed, 31 May 2023 02:45:36 -0700 (PDT)
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-517ab9a4a13so4911757a12.1;
        Wed, 31 May 2023 02:45:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685526336; x=1688118336;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=t/2aFBpIsqpE5f/CcamhdekTeF9dAuGTGy1N658Z3Aw=;
        b=YpvqIF6sjCT028bnduUEPYNw38JvAqY+IPI/cxef6XFIQvhLfzkB3FMygvoJf87c2I
         T34xKd4kGaBOpMFReQXRXXjY+a1lvs/IFb8ciWma1eFb8XQUFxHgyet7Gu4EjRMBHECj
         Rj+kBR3YjGRcwgD2DUVELllJlhlWWIfnhZsNNTJRA2L+xUWcgd9P0Fcqwyics628IHD4
         DuzctOKA97z2F4VEU+M2hEVPpKla0WlmEoVl1jOc3w1QBhEUAYetB/L7wn+67UYpCzpX
         e6AYP8JmIIqDeJXV2R5p8Rf4Refe/0LVqzt6927sT6IJZ48iZhyrrqM0sehJOSJSqw8J
         itxA==
X-Gm-Message-State: AC+VfDwQUztd7OskD+HTDuO3DiZDdzsuMbkBy1wzaevBCUsV+OxOrPh+
	dQz2zlEyBmu1KuGxwgOhhgZCwRYaHdRbhLje/7w=
X-Google-Smtp-Source: ACHHUZ6keaXUYHaJYg6vFOspqfoUed6ZnCFmBKZmVeFdviOjIuQo6mQbZ2GJJKlVVoH9EV6aBxz/wMIDSqnCz222cKQ=
X-Received: by 2002:a17:90b:951:b0:256:35f0:a2b0 with SMTP id
 dw17-20020a17090b095100b0025635f0a2b0mr5138557pjb.0.1685526335890; Wed, 31
 May 2023 02:45:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230507155506.3179711-1-mailhol.vincent@wanadoo.fr>
 <20230530144637.4746-1-mailhol.vincent@wanadoo.fr> <20230530144637.4746-4-mailhol.vincent@wanadoo.fr>
 <ZHYbaYWeIaDcUhhw@corigine.com> <CAMZ6RqK2vr0KRq76UNOSKzHMEfhz1YPFdg7CdQJqq4pBH3hj5w@mail.gmail.com>
 <ZHZTUw9HWE10CUn0@corigine.com>
In-Reply-To: <ZHZTUw9HWE10CUn0@corigine.com>
From: Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date: Wed, 31 May 2023 18:45:24 +0900
Message-ID: <CAMZ6RqL=hB_566G4rmOYksgnSV1sQEyQEgjHPfkVEL5TQfejqg@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] can: length: refactor frame lengths definition to
 add size in bits
To: Simon Horman <simon.horman@corigine.com>
Cc: Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org, 
	Thomas.Kopp@microchip.com, Oliver Hartkopp <socketcan@hartkopp.net>, netdev@vger.kernel.org, 
	marex@denx.de, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed. 31 May 2023 at 04:53, Simon Horman <simon.horman@corigine.com> wrote:
> On Wed, May 31, 2023 at 02:29:43AM +0900, Vincent MAILHOL wrote:
> > On Wed. 31 May 2023 at 00:56, Simon Horman <simon.horman@corigine.com> wrote:
> > > On Tue, May 30, 2023 at 11:46:37PM +0900, Vincent Mailhol wrote:
>
> ...
>
> > > > +/**
> > > > + * can_bitstuffing_len() - Calculate the maximum length with bitsuffing
> > > > + * @bitstream_len: length of a destuffed bit stream
> > >
> > > Hi Vincent,
> > >
> > > it looks like an editing error has crept in here:
> > >
> > >         s/bitstream_len/destuffed_len/
> >
> > Doh! Thanks for picking this up.
> >
> > I already prepared a v4 locally. Before sending it, I will wait one
> > day to see if there are other comments.
>
> Thanks, sounds good.

On a side note, I was puzzled because I did not get any documentation
warnings when running a "make W=1". I just realized that only .c files
get checked, not headers. I sent a separate patch to fix the
documentation:

  https://lore.kernel.org/linux-doc/20230531093951.358769-1-mailhol.vincent@wanadoo.fr/

Yours sincerely,
Vincent Mailhol

