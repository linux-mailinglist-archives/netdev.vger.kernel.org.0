Return-Path: <netdev+bounces-8434-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 44B917240B8
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 13:21:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A8EC71C20EA5
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 11:21:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50CA015AD2;
	Tue,  6 Jun 2023 11:21:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43F2212B79
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 11:21:04 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 335E4E52
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 04:21:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686050462;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ebVF+Max5iyqvwuGYgC/XuMFb8EIbpDHTovot3c/RRY=;
	b=cyMnXLudHHPiF7mVDzaJc+MRWyPBhXKBhwU1+tlDaE+HrefHWHacCYf9+IalYTt0ABf4iC
	G0mMq2Y6fFR1GTjsn2gSqDgdZl9xpDSFgz9XmlebLRp1lOOgHXU5YWM1KGhlncob59JjIj
	L4J61p4L4DFEwnQyEW/+bJyCiMkp0eU=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-642-SN7YjWGOMHWm8j3pTr3-Xw-1; Tue, 06 Jun 2023 07:21:01 -0400
X-MC-Unique: SN7YjWGOMHWm8j3pTr3-Xw-1
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-75d54053a76so24581685a.1
        for <netdev@vger.kernel.org>; Tue, 06 Jun 2023 04:21:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686050460; x=1688642460;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ebVF+Max5iyqvwuGYgC/XuMFb8EIbpDHTovot3c/RRY=;
        b=WyTaS5zPhu8bdOYVGd8hcPj+S7jXPB6GV+xVM8xh+4kPZkI2LYkv9UKfXrpD+qwXKM
         YVpCG0fgx0gIYgHCW/PH71gxE33EYf+BQvLijDnn2ihvpadjFYJW3AE614kuQSSYYO1Z
         /R9istEtJlpY0sgo41MUd9uguGeV50hxoiQlToOEUBkxj03qyC95HdCeq6e/Taj5Aat5
         ptTu98i/rCn3k4OqBuFJjwVjQFhPdluIgIBb/odEPrY79UU8FxG9LRer0XNba7P848OC
         /xXUz/HxP43W8z9XyipH3EV+f56ZUPQJiHmYb5AhJQQ8n6xRrxCx4gbjE3wVrORjSijU
         xCjQ==
X-Gm-Message-State: AC+VfDylbUSuLg7ZBVabqx4vL/zUN8rPell5FRXJejQO2Z7e/TZzIwO1
	aWddjW0DjWF/5NbOPlyk0uGazvDnQvv28ZUbJ4+egVLgOIjp1yIzVE5MjGmeuqpi0hIFxhtNDtb
	Uw3UY9cq5FiRmCnPFKtJbPQAY
X-Received: by 2002:a05:620a:6193:b0:75e:c678:d49e with SMTP id or19-20020a05620a619300b0075ec678d49emr1858914qkn.2.1686050460551;
        Tue, 06 Jun 2023 04:21:00 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ70txRJXtKwBAapUKNxYE7fFjx2DvuV1I+j+FBbtbexPBQVPSmMnzDDrhyGWaEdkJ93Jp/QZw==
X-Received: by 2002:a05:620a:6193:b0:75e:c678:d49e with SMTP id or19-20020a05620a619300b0075ec678d49emr1858890qkn.2.1686050460286;
        Tue, 06 Jun 2023 04:21:00 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-114-89.dyn.eolo.it. [146.241.114.89])
        by smtp.gmail.com with ESMTPSA id q21-20020ae9e415000000b0075d405f4bdcsm255424qkc.125.2023.06.06.04.20.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jun 2023 04:21:00 -0700 (PDT)
Message-ID: <d61eea76bfff30ced8462aeb98409caa9b2232a2.camel@redhat.com>
Subject: Re: [PATCH net-next v1 1/1] mac_pton: Clean up the header inclusions
From: Paolo Abeni <pabeni@redhat.com>
To: Simon Horman <simon.horman@corigine.com>, Andy Shevchenko
	 <andriy.shevchenko@linux.intel.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, "David S. Miller"
	 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	 <kuba@kernel.org>
Date: Tue, 06 Jun 2023 13:20:57 +0200
In-Reply-To: <ZH7xgznYTfyLIslo@corigine.com>
References: <20230604132858.6650-1-andriy.shevchenko@linux.intel.com>
	 <ZH7xgznYTfyLIslo@corigine.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, 2023-06-06 at 10:42 +0200, Simon Horman wrote:
> On Sun, Jun 04, 2023 at 04:28:58PM +0300, Andy Shevchenko wrote:
> > Since hex_to_bin() is provided by hex.h there is no need to require
> > kernel.h. Replace the latter by the former and add missing export.h.
> >=20
> > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>=20
> Hi Andy,
>=20
> is there a tool that you used to verify this change?

I guess build testing it should suffice ;)

/P


