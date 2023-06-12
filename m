Return-Path: <netdev+bounces-10004-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7276372B9C9
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 10:07:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B24561C20995
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 08:07:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADB83FBEC;
	Mon, 12 Jun 2023 08:07:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A189E1FD8
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 08:07:33 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56F5D123
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 01:07:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686557235;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4o6iBs/cGUwezMGSZngT4KvoAhZmnl7dmMW6aK8mMXs=;
	b=iqcrAOdhoWK3h3hsBaz2SjKgE8om5wQzi6mIgCYNhAbhwBDKxembbjsapmzyyryhCdZNfU
	cW6IDTZeulQxb2yAyZy0M+nisnP1l1O+fOzyz3rrrSRpddjVH3RatWvpHkHmodfkyzJti3
	HQ+N/Q/lMw/GXIy0LFLRz9ywXV1DzN0=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-103-wvNiDvbCNDCh77XYlxkgNA-1; Mon, 12 Jun 2023 03:25:16 -0400
X-MC-Unique: wvNiDvbCNDCh77XYlxkgNA-1
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-74faf5008bbso86265385a.0
        for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 00:25:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686554716; x=1689146716;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4o6iBs/cGUwezMGSZngT4KvoAhZmnl7dmMW6aK8mMXs=;
        b=AgQ86YT65kKQP0mAI397zUwjxpYzJ2pCaNAGFEfokHf/EukVyatv+mU+n713CofSzU
         hoS4i+G2yB/1oxQ3KdqkIJzHOlk7XxSaFsyFd2ggrlwE20DzD0mid+xmnR8XmS5wAqAc
         SA+uKkMX4IbPpW9IZE7tKXBtbP1NLlIXI/XaoEZ9ILl39+M9FO6iOzODYjH9qhQZj54U
         4pFgxj1sRfMm/NKHpJWJiyiOy4cMhoPdOlxVnnl2ERDcBYNh4ohCTivigg+8wIEh0hvz
         i2PpyCGLClTzSrPnFivwARZA8+3+p7LSdWRlUvvqgSx3CqvrFbMK5IYZ5dVBcneM2Smd
         d63A==
X-Gm-Message-State: AC+VfDygl2gaVXnpwonyO1otCCN14hsSLhSp7xNNTmpJgPrD9IzvLXs2
	+dpNeUeT5enhcUpVOE13qp1PZ4mm4BiBiIN1Svt6haEDf7pRzg9Q1yXnaRC36GRw2NJp4JAD5EF
	YVnMt7t3Xd3x+PP5D
X-Received: by 2002:a05:620a:261b:b0:75d:53ee:ced2 with SMTP id z27-20020a05620a261b00b0075d53eeced2mr9737752qko.3.1686554715877;
        Mon, 12 Jun 2023 00:25:15 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5VuifOapEch7jQlR/qS70uakqBc0QmL94RvL3OjCGbDQ+rEyQGny14ZUgrn99WU43OqLM/LQ==
X-Received: by 2002:a05:620a:261b:b0:75d:53ee:ced2 with SMTP id z27-20020a05620a261b00b0075d53eeced2mr9737716qko.3.1686554715595;
        Mon, 12 Jun 2023 00:25:15 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-250-244.dyn.eolo.it. [146.241.250.244])
        by smtp.gmail.com with ESMTPSA id v11-20020ae9e30b000000b0074fb15e2319sm2685635qkf.122.2023.06.12.00.25.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jun 2023 00:25:15 -0700 (PDT)
Message-ID: <38dad5cb196741e56d018cea155982928694b2cc.camel@redhat.com>
Subject: Re: [RFC PATCH v8 03/10] dpll: core: Add DPLL framework base
 functions
From: Paolo Abeni <pabeni@redhat.com>
To: Jiri Pirko <jiri@resnulli.us>, Arkadiusz Kubalewski
	 <arkadiusz.kubalewski@intel.com>
Cc: kuba@kernel.org, vadfed@meta.com, jonathan.lemon@gmail.com,
 corbet@lwn.net,  davem@davemloft.net, edumazet@google.com, vadfed@fb.com, 
 jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com, saeedm@nvidia.com, 
 leon@kernel.org, richardcochran@gmail.com, sj@kernel.org,
 javierm@redhat.com,  ricardo.canuelo@collabora.com, mst@redhat.com,
 tzimmermann@suse.de,  michal.michalik@intel.com,
 gregkh@linuxfoundation.org,  jacek.lawrynowicz@linux.intel.com,
 airlied@redhat.com, ogabbay@kernel.org,  arnd@arndb.de,
 nipun.gupta@amd.com, axboe@kernel.dk, linux@zary.sk,  masahiroy@kernel.org,
 benjamin.tissoires@redhat.com, geert+renesas@glider.be, 
 milena.olech@intel.com, kuniyu@amazon.com, liuhangbin@gmail.com, 
 hkallweit1@gmail.com, andy.ren@getcruise.com, razor@blackwall.org, 
 idosch@nvidia.com, lucien.xin@gmail.com, nicolas.dichtel@6wind.com,
 phil@nwl.cc,  claudiajkang@gmail.com, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org,  netdev@vger.kernel.org,
 intel-wired-lan@lists.osuosl.org,  linux-rdma@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org,  poros@redhat.com,
 mschmidt@redhat.com, linux-clk@vger.kernel.org,  vadim.fedorenko@linux.dev
Date: Mon, 12 Jun 2023 09:25:06 +0200
In-Reply-To: <ZIWVuPMyKRPv6oyh@nanopsycho>
References: <20230609121853.3607724-1-arkadiusz.kubalewski@intel.com>
	 <20230609121853.3607724-4-arkadiusz.kubalewski@intel.com>
	 <ZIWVuPMyKRPv6oyh@nanopsycho>
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

On Sun, 2023-06-11 at 11:36 +0200, Jiri Pirko wrote:
> Fri, Jun 09, 2023 at 02:18:46PM CEST, arkadiusz.kubalewski@intel.com wrot=
e:
> > From: Vadim Fedorenko <vadim.fedorenko@linux.dev>
>=20
> [...]
>=20
> > +int dpll_device_register(struct dpll_device *dpll, enum dpll_type type=
,
> > +			 const struct dpll_device_ops *ops, void *priv)
> > +{
> > +	struct dpll_device_registration *reg;
> > +	bool first_registration =3D false;
> > +
> > +	if (WARN_ON(!ops))
> > +		return -EINVAL;
> > +	if (WARN_ON(type < DPLL_TYPE_PPS || type > DPLL_TYPE_MAX))
> > +		return -EINVAL;
> > +
> > +	mutex_lock(&dpll_lock);
> > +	reg =3D dpll_device_registration_find(dpll, ops, priv);
> > +	if (reg) {
> > +		mutex_unlock(&dpll_lock);
> > +		return -EEXIST;
> > +	}
> > +
> > +	reg =3D kzalloc(sizeof(*reg), GFP_KERNEL);
> > +	if (!reg) {
> > +		mutex_unlock(&dpll_lock);
> > +		return -EEXIST;
> > +	}
> > +	reg->ops =3D ops;
> > +	reg->priv =3D priv;
> > +	dpll->type =3D type;
> > +	first_registration =3D list_empty(&dpll->registration_list);
> > +	list_add_tail(&reg->list, &dpll->registration_list);
> > +	if (!first_registration) {
> > +		mutex_unlock(&dpll_lock);
> > +		return 0;
> > +	}
> > +
> > +	xa_set_mark(&dpll_device_xa, dpll->id, DPLL_REGISTERED);
> > +	mutex_unlock(&dpll_lock);
> > +	dpll_device_create_ntf(dpll);
>=20
> This function is introduced in the next patch. Breaks bissection. Make
> sure you can compile the code after every patch applied.

WRT, I think the easiest way to solve the above is adding the function
call in the next patch.

Cheers,

Paolo


