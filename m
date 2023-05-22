Return-Path: <netdev+bounces-4328-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D6C3570C166
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 16:46:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6300E1C20A85
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 14:45:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 803A414260;
	Mon, 22 May 2023 14:45:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D0C81079A
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 14:45:59 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FFCBC1
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 07:45:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684766757;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ie326rlH5K/agdGsMF2lJMaz9SgyRnB9zBZLWU3/z4Q=;
	b=iN2CvaIXIvXEu8XnfanchNjxrT6vZOtX3j44hSUcsgYyr7zwdOVMAWJwvXDj/DSBDkpm0I
	e7f7xjGf/qpz2zMybHj2mXuHem83AR5d4C3/TXtw3oKlFZfWkX+rmskZLYqnEDrpyClNfk
	SpExFAxIUbFP2ciYiCL7/MTT+cglUxQ=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-292-F2y7Sf2QOeicSImmzlY5_g-1; Mon, 22 May 2023 10:45:56 -0400
X-MC-Unique: F2y7Sf2QOeicSImmzlY5_g-1
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-3f6b5f643beso135131cf.0
        for <netdev@vger.kernel.org>; Mon, 22 May 2023 07:45:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684766755; x=1687358755;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ie326rlH5K/agdGsMF2lJMaz9SgyRnB9zBZLWU3/z4Q=;
        b=Gs84vj+TFHDYjmZ0LzFdpcoHnhnvK3OAqMcUu7uMI+8ZbzvbVHfuIT/pzxH78KApqH
         E7Qqipy0pPnaWiJWn3UBWZSUGEbhJXLXJOK8zOrtJuN6ogpIa5jKlJFQSFZgNVed0O2E
         wikVgqpBEmh4yvtAH/kDYROmFuiYkXjDZxqveqqwWQs+UzV7WChsf3jB1XtS1o1EQxo5
         ew0m3XMqYfRxGZH19pWy8CSF566UiMaNAnRcirCZYyAZBmHavOWwpxfS7vSo2BKTr7wh
         RtdSweH8OKAQ/ktTYLcWSg4jXMGp46oYFPa/aJcyUhBglsHJDW6k5o0MuofByc/GtWfC
         JHvA==
X-Gm-Message-State: AC+VfDx1Gx9H5D8s9jAp74fvhSz46iBO4HDbGNks2ByZkSl2zwPllcBP
	szkqtJpA2ApOTsVPlD2oPp3pu9cVlHjDJPPagw8p0LiCMQptFmHr5jZeMHvOkq7LSp/CiLLdlcN
	5ZPNFMN2iVRakn4qkW+8J2GVa
X-Received: by 2002:a37:387:0:b0:75b:23a1:69eb with SMTP id 129-20020a370387000000b0075b23a169ebmr1004794qkd.2.1684766755274;
        Mon, 22 May 2023 07:45:55 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6zQ3ntI2Fy9ibmT75vWMxnkcWqVuvT4EOZ8atcv8vJGIHBGJENw25Zmqq6Uz6IpcQHfuhO4g==
X-Received: by 2002:a05:6214:4003:b0:625:8684:33f3 with SMTP id kd3-20020a056214400300b00625868433f3mr3375050qvb.0.1684766733949;
        Mon, 22 May 2023 07:45:33 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-231-222.dyn.eolo.it. [146.241.231.222])
        by smtp.gmail.com with ESMTPSA id mh2-20020a056214564200b00621430707f7sm1984090qvb.83.2023.05.22.07.45.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 May 2023 07:45:33 -0700 (PDT)
Message-ID: <6c888b44da3235c8405d890c51d77f064d84fd5f.camel@redhat.com>
Subject: Re: [RFC PATCH v7 2/8] dpll: Add DPLL framework base functions
From: Paolo Abeni <pabeni@redhat.com>
To: Vadim Fedorenko <vadfed@meta.com>, Jakub Kicinski <kuba@kernel.org>, 
 Jiri Pirko <jiri@resnulli.us>, Arkadiusz Kubalewski
 <arkadiusz.kubalewski@intel.com>, Jonathan Lemon <jonathan.lemon@gmail.com>
Cc: Milena Olech <milena.olech@intel.com>, Michal Michalik
 <michal.michalik@intel.com>, linux-arm-kernel@lists.infradead.org, Vadim
 Fedorenko <vadim.fedorenko@linux.dev>, poros@redhat.com,
 mschmidt@redhat.com, netdev@vger.kernel.org,  linux-clk@vger.kernel.org
Date: Mon, 22 May 2023 16:45:29 +0200
In-Reply-To: <20230428002009.2948020-3-vadfed@meta.com>
References: <20230428002009.2948020-1-vadfed@meta.com>
	 <20230428002009.2948020-3-vadfed@meta.com>
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
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, 2023-04-27 at 17:20 -0700, Vadim Fedorenko wrote:
> From: Vadim Fedorenko <vadim.fedorenko@linux.dev>
>=20
> DPLL framework is used to represent and configure DPLL devices
> in systems. Each device that has DPLL and can configure sources
> and outputs can use this framework. Netlink interface is used to
> provide configuration data and to receive notification messages
> about changes in the configuration or status of DPLL device.
> Inputs and outputs of the DPLL device are represented as special
> objects which could be dynamically added to and removed from DPLL
> device.
>=20
> Co-developed-by: Milena Olech <milena.olech@intel.com>
> Signed-off-by: Milena Olech <milena.olech@intel.com>
> Co-developed-by: Michal Michalik <michal.michalik@intel.com>
> Signed-off-by: Michal Michalik <michal.michalik@intel.com>
> Co-developed-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
> Signed-off-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
> Signed-off-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>

As this patch is quite big and tend to accumulate quite a few comments
- both hard to track and to address - I'm wondering if splitting it in
a few separated patches would could help?

e.g.=C2=A0

- 1 patch for dpll device struct && APIs definition
- 1 patch for pin related APIs
- 1 patch for netlink notification.

(to be considered only if the effort for the above split is not
overwhelming)

Possibly the same could apply to patch 5/8.

Cheers,

Paolo


