Return-Path: <netdev+bounces-1157-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8232E6FC5F9
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 14:11:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D476A281194
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 12:11:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA34B182AE;
	Tue,  9 May 2023 12:11:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1F9B17ACF
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 12:11:22 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61536272D
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 05:11:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683634279;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=t/RQaaUXnmzd+KSdlgEdbSgDn1n2vtnUGdBoVDTHHUc=;
	b=bEfp9C4Q4klqfGVMGcgn/EtgiJBN1nYBqbXppyCfAlL78mhLGht/5w1vC4MNkbM8imiGSo
	dq3NCl+KUSBNDwYx0CoOSIRR0jiB8O7aXMNrXKnvlmdpf3dlCH5EG2CmV5ZpzzcFi4H3aT
	QKI/7tKXJa1x1k7dDs2TP1WrgtI8lmM=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-168-3xaVG3VJNpebgmri9JR7jg-1; Tue, 09 May 2023 08:10:43 -0400
X-MC-Unique: 3xaVG3VJNpebgmri9JR7jg-1
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-50d88a986afso4531057a12.0
        for <netdev@vger.kernel.org>; Tue, 09 May 2023 05:10:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683634242; x=1686226242;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=t/RQaaUXnmzd+KSdlgEdbSgDn1n2vtnUGdBoVDTHHUc=;
        b=NNaLKNL1w0HRrgo4CaJdILmTtSLGAhjAp8gDSgBnaPK3i80H6zFCuCDzmKU14wtUNu
         npGm2dInA1jB5QrnHfDOAYrfDgRdPn6eo0yx1Kd2j6+XlXqGMITFoOKulgBLLDxGLr1A
         NBi1hEklsfExHw7K7qKPMnNSDcBY8tw6jCdGqVgYQZMJQvwuv8lbzTqApyJwTTcrx+6t
         Xobxvo957gaDWogSUTQ7a02Sgz5wG+8hECiqO6j/qZpzLWAfCRUfYQ5qKOQjkqUP/Zok
         4CVYnSxmDCMfbI6DB0pFtlXDPWUyCe7mrgdN2hVfcJPu5SZG9dEp9M+u3ztLqYUMwcla
         8KVw==
X-Gm-Message-State: AC+VfDwBALebvdb9VERFZSWFgOfRxFqx/UzK41SafCZ+Mo2DaaZJx7mi
	MFiNZ/03dp+0memP1r+qQPqzneXegGWwbxLY0kbSfkKtIUi/0aHnmzmoStQSR2c4dMGmevtxksf
	jHy8oL1TntDva18Co
X-Received: by 2002:a17:907:d86:b0:953:42c0:86e7 with SMTP id go6-20020a1709070d8600b0095342c086e7mr11907182ejc.4.1683634242014;
        Tue, 09 May 2023 05:10:42 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5ziyroNxxsqiekoVaCaWu4X37anv4qlBfms9GfaeLY386YagIOqmfJnY0OXDPjopSYgDpkQA==
X-Received: by 2002:a17:907:d86:b0:953:42c0:86e7 with SMTP id go6-20020a1709070d8600b0095342c086e7mr11907155ejc.4.1683634241599;
        Tue, 09 May 2023 05:10:41 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id my14-20020a1709065a4e00b0096643397aeesm1238647ejc.184.2023.05.09.05.10.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 May 2023 05:10:41 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
	id 783C7AFD2ED; Tue,  9 May 2023 14:10:40 +0200 (CEST)
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To: Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org
Cc: lorenzo.bianconi@redhat.com, bpf@vger.kernel.org, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, hawk@kernel.org,
 john.fastabend@gmail.com, linyunsheng@huawei.com, ast@kernel.org,
 daniel@iogearbox.net, jbenc@redhat.com
Subject: Re: [PATCH net-next] net: veth: make PAGE_POOL_STATS optional
In-Reply-To: <c9e132c3f08c456ad0462342bb0a104f0f8c0b24.1683622992.git.lorenzo@kernel.org>
References: <c9e132c3f08c456ad0462342bb0a104f0f8c0b24.1683622992.git.lorenzo@kernel.org>
X-Clacks-Overhead: GNU Terry Pratchett
Date: Tue, 09 May 2023 14:10:40 +0200
Message-ID: <87mt2daenz.fsf@toke.dk>
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
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Lorenzo Bianconi <lorenzo@kernel.org> writes:

> Since veth is very likely to be enabled and there are some drivers
> (e.g. mlx5) where CONFIG_PAGE_POOL_STATS is optional, make
> CONFIG_PAGE_POOL_STATS optional for veth too in order to keep it
> optional when required.

s/when/instead of/ ?

Other than that:

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>


