Return-Path: <netdev+bounces-8383-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 08537723DA0
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 11:34:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6F7E31C20F14
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 09:34:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D229294DC;
	Tue,  6 Jun 2023 09:34:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 425D729117
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 09:34:23 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59BB3170D
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 02:34:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686044042;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wN4b69xo6rSjA1E3xDaIpxOZ9wdwUCtXvAmORundino=;
	b=gOa5Y6CmPfm3SNNQciR+DCo6Zy6smXCRChhfNOrSV+YHQ+CHl+crrBf01SAGMH4eObCfzN
	WF0JeXhTqEaeiFu9lQDMUWgNC4XcbW/BdposhOrWBKO52TcPZyFtxYCo/AlY45OugTeCcf
	H2jmCX9aBI7HxMD+wjpIAq0Wd2ePYXE=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-270-aDRNC7FkOt2Ldop5okQOAQ-1; Tue, 06 Jun 2023 05:34:00 -0400
X-MC-Unique: aDRNC7FkOt2Ldop5okQOAQ-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-94a348facbbso483159966b.1
        for <netdev@vger.kernel.org>; Tue, 06 Jun 2023 02:33:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686044039; x=1688636039;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wN4b69xo6rSjA1E3xDaIpxOZ9wdwUCtXvAmORundino=;
        b=T+/pPxVAP2h0mSBRfkKW2IL8ZKEgmBAMg5SGO1kwUAimxsKsBfuNbX9vYPRAvrU+FN
         a0UNqp7hpQzK7XH8YSUNKBcNmabV4c1f+xgEjEXGLjycMsB9TZE8Olx6f31O+CzZhBpK
         vHXGEz7cccgNJFhPhb/i+KvIfhecIkzOD7voJ3vWokRDTdtWsarrXSPpuayH4+oNLGb5
         vjfMOYZPoKJPMbGQ5tz5vs0nxAtOWR/ua+vYDEKMyS8AtW3Y9uGGVs/7btTPsJdzgKw3
         eT0sdw6elXIFq44rN5mkToPMh9uVjNBiIkmDEXlDNbhl7/lE0JimFDqa2P35BG2JqFml
         yNTQ==
X-Gm-Message-State: AC+VfDypaRCBxoyT622g3IbildHl4K4rabHkgUBZkBCHEsSD/IhtWUAa
	vsS4XOosSILzSqgHD1DLm91009VGydv1SQYhI/W1sC5tTNQk+gvpX8HlWtmspE5s70+0P5IYWEq
	TYGo12GxKSgXusGJf+VNZNgnOTR1EhEXT
X-Received: by 2002:a17:906:6a20:b0:94e:48ac:9a51 with SMTP id qw32-20020a1709066a2000b0094e48ac9a51mr2101994ejc.4.1686044039037;
        Tue, 06 Jun 2023 02:33:59 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5pM3VqIk4XNqJUh/s4jQhSFFjen1muE9hAy6St1eT5BhmpLXiidhzMmximTlmxjgPOlULnJgNjfK2ENkswQ2w=
X-Received: by 2002:a17:906:6a20:b0:94e:48ac:9a51 with SMTP id
 qw32-20020a1709066a2000b0094e48ac9a51mr2101972ejc.4.1686044038818; Tue, 06
 Jun 2023 02:33:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230528140938.34034-1-andriy.shevchenko@linux.intel.com>
 <ZHWo3LHLunOkXaqW@corigine.com> <ZH3srm+8PnZ1rJm9@smile.fi.intel.com>
In-Reply-To: <ZH3srm+8PnZ1rJm9@smile.fi.intel.com>
From: Alexander Aring <aahringo@redhat.com>
Date: Tue, 6 Jun 2023 05:33:47 -0400
Message-ID: <CAK-6q+hkL8cStdSPnZF_D1CtLvJZ=P16TJ8BCGpkGwrbh8uN3A@mail.gmail.com>
Subject: Re: [PATCH net-next v1 1/1] ieee802154: ca8210: Remove stray
 gpiod_unexport() call
To: Miquel Raynal <miquel.raynal@bootlin.com>
Cc: Simon Horman <simon.horman@corigine.com>, Stefan Schmidt <stefan@datenfreihafen.org>, 
	linux-wpan@vger.kernel.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Alexander Aring <alex.aring@gmail.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi,

On Mon, Jun 5, 2023 at 10:12=E2=80=AFAM Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
>
> On Tue, May 30, 2023 at 09:42:20AM +0200, Simon Horman wrote:
> > On Sun, May 28, 2023 at 05:09:38PM +0300, Andy Shevchenko wrote:
> > > There is no gpiod_export() and gpiod_unexport() looks pretty much str=
ay.
> > > The gpiod_export() and gpiod_unexport() shouldn't be used in the code=
,
> > > GPIO sysfs is deprecated. That said, simply drop the stray call.
> > >
> > > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> >
> > Reviewed-by: Simon Horman <simon.horman@corigine.com>
>
> Thank you!
> Can this be applied now?

ping, Miquel? :)

- Alex


