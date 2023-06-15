Return-Path: <netdev+bounces-11112-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A0BA731909
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 14:38:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 195EE1C20F1E
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 12:38:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DA1E63A5;
	Thu, 15 Jun 2023 12:38:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11FCD6106
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 12:38:02 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C26F81FDB
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 05:38:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686832681;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gTIAUs6tWTx1JxWTYhYUIaHzGBgz21d+mfQ6B/1Bob8=;
	b=NQLN7iFng6hFlqLz1FJO5bY7JNngeDT72Y01bJtI3QTtrKLUAnFNV3K7PIqmjp3NxLejqB
	3/m/2AsHVRJtcO26o9EFDDfMtH628zJawz6aBWWZan+RPcEueqPCSdfWD5EOwrV0D3VuTY
	gyFFvdrPX2HjxTtUT0NDlmXiVRdu+vg=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-381-caIo-0gqOCqRqzkvrhflww-1; Thu, 15 Jun 2023 08:37:53 -0400
X-MC-Unique: caIo-0gqOCqRqzkvrhflww-1
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-9829a080268so80996366b.3
        for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 05:37:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686832672; x=1689424672;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gTIAUs6tWTx1JxWTYhYUIaHzGBgz21d+mfQ6B/1Bob8=;
        b=Z2JxKjcpuBORc2idnL3HrmfAVdANeCkisTpQpdIhZdVqFq3NyW9mdrCLwfnIq8XcRH
         EoHkGyxKM+KQwm6ZcI3VdTQ3Xr3YogQATNv/MYxGE478YARHPBZVmFiBdKvs954Y5G+7
         hEnjDi/R5cmRTw/Iw96EvXm4SgERtppfexZAZQ+zZyb9nb0+JWdSc/uuyqSrgfL3g5bt
         rZlDV8ZQP6iIZO13riWJPueoIZWAcfiFG/Bf///mSNlHdYWFVH16PvyiYSyb2cW4Pblx
         aRrRDmMOJ2A1eiaAqNMb4WsaiBBkXKHU1DAJB7sa6FpPC30s53T40Bu0fX0cuDpbxlnZ
         QCIw==
X-Gm-Message-State: AC+VfDwo7Fgb1sE96npiKOqNOixPzzxmgptRLEx/sGaFP80+2HT+NJad
	DuOs4XIX3mCKzjcY92J5E/tj5xk41xBRfOMP++JwXl0VuRdKreie88tCyAYQD/5kXfkuNKKgBBl
	Ax1xg49dZZexPTDWP
X-Received: by 2002:a17:906:58c8:b0:96f:e7cf:5015 with SMTP id e8-20020a17090658c800b0096fe7cf5015mr20449709ejs.17.1686832672180;
        Thu, 15 Jun 2023 05:37:52 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4yLdrC3Ns33uRvMP1BQdUvRNhpaN9fVe272nbI+nzoGeNbjGmBXTp3+HDcp0B9u0AVYvhhYg==
X-Received: by 2002:a17:906:58c8:b0:96f:e7cf:5015 with SMTP id e8-20020a17090658c800b0096fe7cf5015mr20449690ejs.17.1686832671834;
        Thu, 15 Jun 2023 05:37:51 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id q15-20020a170906940f00b00977eb9957e9sm9378146ejx.128.2023.06.15.05.37.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jun 2023 05:37:51 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
	id 68D0ABBEC27; Thu, 15 Jun 2023 14:29:54 +0200 (CEST)
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To: Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
 intel-wired-lan@lists.osuosl.org
Cc: netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
 magnus.karlsson@intel.com, fred@cloudflare.com,
 aleksander.lobakin@intel.com, Maciej Fijalkowski
 <maciej.fijalkowski@intel.com>
Subject: Re: [PATCH v3 iwl-next] ice: allow hot-swapping XDP programs
In-Reply-To: <20230615113326.347770-1-maciej.fijalkowski@intel.com>
References: <20230615113326.347770-1-maciej.fijalkowski@intel.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date: Thu, 15 Jun 2023 14:29:54 +0200
Message-ID: <87v8fogb7h.fsf@toke.dk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Maciej Fijalkowski <maciej.fijalkowski@intel.com> writes:

> Currently ice driver's .ndo_bpf callback brings interface down and up
> independently of XDP resources' presence. This is only needed when
> either these resources have to be configured or removed. It means that
> if one is switching XDP programs on-the-fly with running traffic,
> packets will be dropped.
>
> To avoid this, compare early on ice_xdp_setup_prog() state of incoming
> bpf_prog pointer vs the bpf_prog pointer that is already assigned to
> VSI. Do the swap in case VSI has bpf_prog and incoming one are non-NULL.
>
> Lastly, while at it, put old bpf_prog *after* the update of Rx ring's
> bpf_prog pointer. In theory previous code could expose us to a state
> where Rx ring's bpf_prog would still be referring to old_prog that got
> released with earlier bpf_prog_put().
>
> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>


