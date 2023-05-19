Return-Path: <netdev+bounces-3946-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A23AF709B7D
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 17:42:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 86C7B1C212D4
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 15:42:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C12A71118B;
	Fri, 19 May 2023 15:42:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5BE711189
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 15:42:41 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 611C41B0
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 08:42:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684510959;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Jt+/cJ4nWjCmvpQkJFUy4G/NdHR1IPGRqyictYqkQog=;
	b=hi7M9r2oJQPACzhVy9arQ+56z0WYwy9rlXlc5wCr8WsTtceEtrL1ctdlUV8WQDXJaIho0D
	PynAG7iQyMYpv9YpLIu0W9IvkJrLzI1rtIOZKcDZNzVwQ/ve3A9NGE7+XQS81CsKGRGSDi
	XErGmJHeXWwD1Fs817G0inI75gcf3is=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-364-va-ZZYtdMFuvYuHoxWFz-w-1; Fri, 19 May 2023 11:42:37 -0400
X-MC-Unique: va-ZZYtdMFuvYuHoxWFz-w-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-3f4b96aa44aso5324485e9.1
        for <netdev@vger.kernel.org>; Fri, 19 May 2023 08:42:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684510956; x=1687102956;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Jt+/cJ4nWjCmvpQkJFUy4G/NdHR1IPGRqyictYqkQog=;
        b=CilkL5Jo5+vBR29HVPcrFYxijVoiPJOH/YGDh9JkQxXknH+ETn55H0WiOxDoQkOsfh
         PXXFZPHlZkWHNj9uTgeySLuDpu7v2XVEG5vyw4Q06XV2Pcz24BwXCVQwMPTwlTZy61qW
         TtaSHw8aI2FR19cFnW2eM4TX08AkR8uw3cXn+vcsAD3rsaiElzme0xBBsxTu6xAfT401
         T/supZJkRy/Bix4pWKRkNgJCzdLE5GWAqD58YkzB3+JUVdpZVuRvgXpxFwxM8gSZ9lq+
         6QRFkxEknNzBMTtjwVqSup3UponabxW+yB0F0A56t3AZuSQQ0mSQ6YjrJyJbHJglYECE
         yf/w==
X-Gm-Message-State: AC+VfDz1B8UZrIMtcfZnsXNXjOqeXmOrWl7N43VS998ntID/D51IBNdw
	2/s3rXijCxoGqyPo+E7DibHXbCxgNFi2KpmoPZWBTShhEiuJ+RbCd1TdPEFNIb3Ctxws5JOjz9D
	hcBE5uhV1UE+/Uvqx
X-Received: by 2002:a05:600c:1d0e:b0:3f4:2297:f25b with SMTP id l14-20020a05600c1d0e00b003f42297f25bmr2158042wms.0.1684510956775;
        Fri, 19 May 2023 08:42:36 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4N9GJzZz8wHS97yA0R3l/hkzXH2gTECzf/kabyPfHR/tZ+jyEYNC24niZl0bnehX1oxKHY0A==
X-Received: by 2002:a05:600c:1d0e:b0:3f4:2297:f25b with SMTP id l14-20020a05600c1d0e00b003f42297f25bmr2158026wms.0.1684510956416;
        Fri, 19 May 2023 08:42:36 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-235-104.dyn.eolo.it. [146.241.235.104])
        by smtp.gmail.com with ESMTPSA id n8-20020a1c7208000000b003f50876905dsm2811299wmc.6.2023.05.19.08.42.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 May 2023 08:42:36 -0700 (PDT)
Message-ID: <586f34837914765c25bac131438cd83609c9b6d4.camel@redhat.com>
Subject: Re: [PATCH] net/handshake: Squelch allocation warning during Kunit
 test
From: Paolo Abeni <pabeni@redhat.com>
To: Chuck Lever <cel@kernel.org>, netdev@vger.kernel.org, 
	kernel-tls-handshake@lists.linux.dev
Cc: Linux Kernel Functional Testing <lkft@linaro.org>, Chuck Lever
	 <chuck.lever@oracle.com>
Date: Fri, 19 May 2023 17:42:34 +0200
In-Reply-To: <168450889814.157177.678686730886780464.stgit@oracle-102.nfsv4bat.org>
References: 
	<168450889814.157177.678686730886780464.stgit@oracle-102.nfsv4bat.org>
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

On Fri, 2023-05-19 at 11:09 -0400, Chuck Lever wrote:
> From: Chuck Lever <chuck.lever@oracle.com>
>=20
> The "handshake_req_alloc excessive privsize" kunit test is intended
> to check what happens when the maximum privsize is exceeded. The
> WARN_ON_ONCE_GFP at mm/page_alloc.c:4744 can be disabled safely for
> this allocator call site.

Should such flag being added to the relevant entry in
handshake_req_alloc_params?

Thanks!

Paolo



