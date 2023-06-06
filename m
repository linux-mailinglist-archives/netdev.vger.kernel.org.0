Return-Path: <netdev+bounces-8394-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4534F723E4B
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 11:51:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ABA451C20E1C
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 09:51:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 805982A6E0;
	Tue,  6 Jun 2023 09:51:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75706294DC
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 09:51:15 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F27F5E73
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 02:51:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686045072;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=38AKLlfRzFfzbHumACWesn62Y/isbifhTQ7f9ujx0kg=;
	b=Np8RcoalX+EoHxelUxM5a8lQlT8rgQvF/7RPrwMqnppSiE80A1Cdb0Z/DpQHOzk4lArorn
	NU4/mtoQSNZ8lRF2Xsnon5UbVDYQfHD3oKX/gyPfVEEsRzKUDVX0sESEmKwbnzb8uAl36u
	/iO7PgXbDZFK7CKgqPq91V2u3GRg+ps=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-518-sImLV-OaNpihoneHZh7e8g-1; Tue, 06 Jun 2023 05:51:11 -0400
X-MC-Unique: sImLV-OaNpihoneHZh7e8g-1
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-97455ea1c14so367999666b.2
        for <netdev@vger.kernel.org>; Tue, 06 Jun 2023 02:51:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686045070; x=1688637070;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=38AKLlfRzFfzbHumACWesn62Y/isbifhTQ7f9ujx0kg=;
        b=NcOaTktmt4cUyihwe7fWE+zcfuddJcf+1CxZTx4PrgJFtHto+ahCOZLm8x9wNmEu4w
         ZUXnyPE3dlHmSzyK7f54ug3lANlai39kUOccbZxe3pdROnJks6hESgC5N6uXXuKajqNi
         4B95xtjFuwDBJpI3AXK2qWuKJFGbO3RKoU7vrdwgzRPz5kG2/6bYhPv7P1SrL9xyHSxQ
         KhcpAwsV+2z0n2agZABOj8fyF6fBXUcwpngmUjXBP9GpWB/z0Dfg4HHtEUzXWyK31inc
         anQtBiFJLnDJn2TdfHb23NWteKHYGrBxS+o8wDNP/ZBk6x9kDA2ennCf8inePYruC9V8
         e0EA==
X-Gm-Message-State: AC+VfDxjLS4Kmq46uygKa33cI+i5aJMclqSNZ4Hyzxg+9EDzTzEMR8vS
	paMA2jIz/6toZcxVVCUTBuI4zbgswsXXkTiiwcK2pN+aGDoht1HRZcPOW7cTpVkxta4uYJpwp4W
	asDvS9mQKkBlrSEOxlNYCKd7XAcVzJqdB
X-Received: by 2002:a17:907:7da5:b0:976:b93f:26db with SMTP id oz37-20020a1709077da500b00976b93f26dbmr1746056ejc.53.1686045070073;
        Tue, 06 Jun 2023 02:51:10 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7Dv3AJpDlVEjRtuKVJHJ8H8bJ9LrW98cfd9HvqCm7NXhOTBDEvR3sZYKUjCUGJsG8TnUKUHFJh/2NwjIVZfoA=
X-Received: by 2002:a17:907:7da5:b0:976:b93f:26db with SMTP id
 oz37-20020a1709077da500b00976b93f26dbmr1746034ejc.53.1686045069784; Tue, 06
 Jun 2023 02:51:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230528140938.34034-1-andriy.shevchenko@linux.intel.com>
 <ZHWo3LHLunOkXaqW@corigine.com> <ZH3srm+8PnZ1rJm9@smile.fi.intel.com>
 <CAK-6q+hkL8cStdSPnZF_D1CtLvJZ=P16TJ8BCGpkGwrbh8uN3A@mail.gmail.com> <20230606114743.30f7567e@xps-13>
In-Reply-To: <20230606114743.30f7567e@xps-13>
From: Alexander Aring <aahringo@redhat.com>
Date: Tue, 6 Jun 2023 05:50:58 -0400
Message-ID: <CAK-6q+hoNTZFyg6cGDHmJYV+mw17AgJ6EEkgDz=qrNa3pkmtrw@mail.gmail.com>
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
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Miquel,

On Tue, Jun 6, 2023 at 5:47=E2=80=AFAM Miquel Raynal <miquel.raynal@bootlin=
.com> wrote:
>
>
> aahringo@redhat.com wrote on Tue, 6 Jun 2023 05:33:47 -0400:
>
> > Hi,
> >
> > On Mon, Jun 5, 2023 at 10:12=E2=80=AFAM Andy Shevchenko
> > <andriy.shevchenko@linux.intel.com> wrote:
> > >
> > > On Tue, May 30, 2023 at 09:42:20AM +0200, Simon Horman wrote:
> > > > On Sun, May 28, 2023 at 05:09:38PM +0300, Andy Shevchenko wrote:
> > > > > There is no gpiod_export() and gpiod_unexport() looks pretty much=
 stray.
> > > > > The gpiod_export() and gpiod_unexport() shouldn't be used in the =
code,
> > > > > GPIO sysfs is deprecated. That said, simply drop the stray call.
> > > > >
> > > > > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com=
>
> > > >
> > > > Reviewed-by: Simon Horman <simon.horman@corigine.com>
> > >
> > > Thank you!
> > > Can this be applied now?
> >
> > ping, Miquel? :)
>
> I already applied it locally, but I am trying to fix my "thanks for
> patch" routine to not tell you it was applied on the mtd tree :-p

okay no problem. Fully understandable as we have a new workflow
mechanism for 802.15.4.

Thanks. :)

- Alex


