Return-Path: <netdev+bounces-483-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C6E4E6F7AAE
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 03:26:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0428D1C215AD
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 01:26:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEC4C110B;
	Fri,  5 May 2023 01:26:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D44867E
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 01:26:30 +0000 (UTC)
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53F74124B6
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 18:26:29 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id 2adb3069b0e04-4efe8b3f3f7so1390618e87.2
        for <netdev@vger.kernel.org>; Thu, 04 May 2023 18:26:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683249989; x=1685841989;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZHxYiP3rsNDO4gvJlVMJ6YPoUkm6NH9xnjCDkycgWqM=;
        b=Ay6Bgq2bleS7QdGUso7aKzjj5SLMhFSOChPGyudisEKCJN530TxfgqcZ1g/U5TS8ms
         mY1M0LDPgyE2N2pUEM3Zew2/5a52xLexrm1vQy02E4AtQ8zSjRDHppNJQUUFhwIX+bid
         x6HiN/Y6cToWG+udbW8MnzhIJvvqJE/g3jopoP2tYfCh7Yj9+lMYX10+qwu8PjRZyay6
         31DpYH2RQSL1R9nC1JgM6jOibmYhgRvmk1Tk80kQnzrjzgA23vsPYSCcqaMAcx0e0j8f
         tReAbP4rMLeLxmV+vyFoBUgxv9BlNV8w1JBkZCL68/aCJJ9HidcSU4rbknHfU8fX/hLe
         ZHZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683249989; x=1685841989;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZHxYiP3rsNDO4gvJlVMJ6YPoUkm6NH9xnjCDkycgWqM=;
        b=Sw8yW/5pmG3b31K7FC3NrCwuPk90UiM10T6ZLvQ+4WWVunyYt3DCRn1SyjJEYtL8WB
         jxCNtuR1QD/PkQgkUYyrm+YtQJwAzBcGyPM26VW7AgkjHH2YSCgbvgURCpA5WvqFsCfy
         /PRH88/Jo8DXxqeGuFQXAI9Sw8eFiAsiCwTbYjsKSIpHZiwl316xNnMXAj5GjBDtq8Pk
         zkCrmveisQ6aNfkjLIDt/dSjEHy1CWsoqLnHOAVuZLPg87lHD+VW348ngJTqi+B5UOzR
         3mt5GEqZ115N8XrxUovSFtiqH1nQNs0KK34E5+nLbqT2t57wjgJ8DCb25EIoZl2ocSmf
         QHWQ==
X-Gm-Message-State: AC+VfDzdXaqhtHyjlC7MsPifjv2lAnAIoGGP6I32a38KHYms6VUUBmBw
	103P8sAYz0TGttplBzCbORRCEOTld7hlaVPzhaE=
X-Google-Smtp-Source: ACHHUZ5YzzVwk3bERIXvMhIOjX6CJDXKCYBF/JLoZazm/b3omR2WLMqYYNNwWKZgtJOBaflIUI92fKlTIcWOzrbmYdc=
X-Received: by 2002:ac2:44a6:0:b0:4ea:e0e7:d12d with SMTP id
 c6-20020ac244a6000000b004eae0e7d12dmr50019lfm.1.1683249988560; Thu, 04 May
 2023 18:26:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CACWXhKnjyA8S56idVhSFgH1FLo-qBbpxU_ZBpdnrbvv9_kEY7A@mail.gmail.com>
 <20230424125357.55b50cba@kernel.org> <ZEuIGbUz3x4r8KTj@DEN-LT-70577>
In-Reply-To: <ZEuIGbUz3x4r8KTj@DEN-LT-70577>
From: Feiyang Chen <chris.chenfeiyang@gmail.com>
Date: Fri, 5 May 2023 09:26:17 +0800
Message-ID: <CACWXhKne_EQ_v9e=vdRywYNe3D7Lsciyog=B_cBUZvNVjDx6og@mail.gmail.com>
Subject: Re: Help needed: supporting new device with unique register bitfields
To: Daniel.Machon@microchip.com
Cc: kuba@kernel.org, peppe.cavallaro@st.com, alexandre.torgue@foss.st.com, 
	joabreu@synopsys.com, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Apr 28, 2023 at 4:47=E2=80=AFPM <Daniel.Machon@microchip.com> wrote=
:
>
> Den Mon, Apr 24, 2023 at 12:53:57PM -0700 skrev Jakub Kicinski:
> > On Sun, 23 Apr 2023 16:19:11 +0800 Feiyang Chen wrote:
> > > We are hoping to add support for a new device which shares almost
> > > identical logic with dwmac1000 (dwmac_lib.c, dwmac1000_core.c, and
> > > dwmac1000_dma.c), but with significant differences in the register
> > > bitfields (dwmac_dma.h and dwmac1000.h).
> > >
> > > We are seeking guidance on the best approach to support this new
> > > device. Any advice on how to proceed would be greatly appreciated.
> > >
> > > Thank you for your time and expertise.
> >
> > There's no recipe on how to support devices with different register
> > layout :(  You'll need to find the right balance of (1) indirect calls,
> > (2) if conditions and (3) static description data that's right for you.
> >
> > Static description data (e.g. putting register addresses in a struct
> > and using the members of that struct rather than #defines) is probably
> > the best but the least flexible.
> >
> > Adding the stmmac maintainers.
>
> Hi,
>
> I thought I would chip in, as we are facing a similar case as described
> here.
>
> I am working on adding support for a new chip, that shares most of the
> same logic as Sparx5, yet with differences in register layout. Our
> approach has basically been what Jakub describes.
>
> - We use a macro-based approach for accessing registers (see
>   sparx5_main_regs.h). We have added a layer of indirection, so that any
>   _differences_ between the two chips (offset, count, width etc.) have
>   been moved into respective structs, which is then consulted when
>   accessing registers. This allows us to reuse most of the Sparx5 code.
>
> - Any unique chip features or similar are ops'ed out. In a few cases
>   handled by if's.
>
> - Additionally, chip-specific constants like port count, buffer sizes
>   etc.  are statically described for the driver.
>

Hi, Daniel,

That sounds like a great idea. I'll definitely give it a try.

Thanks,
Feiyang

> I think this has worked out pretty well so far. But again, this is
> balance, as Jakub said. If the differences are too great, it might not
> be the best solution for you.
>
> /Daniel

