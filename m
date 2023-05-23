Return-Path: <netdev+bounces-4651-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7306D70DAD5
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 12:49:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EBC581C20D24
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 10:49:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DC574A84F;
	Tue, 23 May 2023 10:49:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0254E4A840
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 10:49:20 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 690761AC
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 03:49:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684838958;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ryOV6FrETkyLPUAE4LLv8nmixcI2Qm818FZeFjpOA8c=;
	b=PIA15cVVska+fMcnBv28aa5OZFPnAE0edfp/Mn38VWEVlKV4pPlesCZyYbfUDj3vBHLj6f
	IYnoLlugwmeEpYxRsLPVTVfxTPVAEjWcmtWgH+2cpuAlfSdKJjjsh6lU1sCMKTv5z2nIso
	0wkcJ/UJ/n6VE6JF+v3xkeu+f6xwhs8=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-331-2c5waE31MqyHIMjIIscK7w-1; Tue, 23 May 2023 06:49:11 -0400
X-MC-Unique: 2c5waE31MqyHIMjIIscK7w-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-3f4fffe7883so4836215e9.0
        for <netdev@vger.kernel.org>; Tue, 23 May 2023 03:49:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684838949; x=1687430949;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ryOV6FrETkyLPUAE4LLv8nmixcI2Qm818FZeFjpOA8c=;
        b=dp1YySv4tQuxUM9AGuEcgCXQo5xDV9JmyHctCXEWUvaehTZgiZg3DgXLm3mjMtLl+T
         OBjx1dzAIDjkfyeYx99fSt05RzI5E+/JCo8D/OOb1/uhyUBipNZH21jDeEPiTt8AZ41W
         DYcfP4+ygztOKtIc640fcg4KNn3gc+Aqccb6x4yPH1uHEhK1I3yTfE8VcV+iRiSWR1nF
         XEe2YMj5VGwCRmQ3fR7S0iY4olhhwMZ5TMwBfDVY909T+P7t8nKWSToRGE2mAEk7KuGR
         31bQEAL9feotTO2PyW9d1denRgVmdY+UNDf7qXFmwsVfqTPNZ1/fQzPPaapYUZl52n6k
         UNtg==
X-Gm-Message-State: AC+VfDzjLr2kP+Gj7RxAwf97emIUnLEj7okMRc6O5NmMawvM9DGrsm9X
	IknNR+W1roVQVQXYxYCboWsSWg4Hm13Ob0C2SCFdomil09L4oomM/w/xY/24YWhEdq2+rHGjeIk
	l/m4Z068yj3Q9l23T
X-Received: by 2002:a05:600c:511c:b0:3f6:5dc:59f6 with SMTP id o28-20020a05600c511c00b003f605dc59f6mr3969839wms.4.1684838948929;
        Tue, 23 May 2023 03:49:08 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4fYGxX3G25nNx/fhqLirB/t91uXhIuRFTfWd5HV0AM7jAPSUBc025W4tkarivsyY2ufgzUaQ==
X-Received: by 2002:a05:600c:511c:b0:3f6:5dc:59f6 with SMTP id o28-20020a05600c511c00b003f605dc59f6mr3969824wms.4.1684838948660;
        Tue, 23 May 2023 03:49:08 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-246-0.dyn.eolo.it. [146.241.246.0])
        by smtp.gmail.com with ESMTPSA id y21-20020a7bcd95000000b003f4e8530696sm11258618wmj.46.2023.05.23.03.49.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 May 2023 03:49:08 -0700 (PDT)
Message-ID: <beea9ce517bf597fb7af13a39a53bb1f47e646d4.camel@redhat.com>
Subject: Re: [PATCH net-next] nfp: add L4 RSS hashing on UDP traffic
From: Paolo Abeni <pabeni@redhat.com>
To: Louis Peens <louis.peens@corigine.com>, David Miller
 <davem@davemloft.net>,  Jakub Kicinski <kuba@kernel.org>
Cc: Simon Horman <simon.horman@corigine.com>, netdev@vger.kernel.org, 
	oss-drivers@corigine.com
Date: Tue, 23 May 2023 12:49:06 +0200
In-Reply-To: <20230522141335.22536-1-louis.peens@corigine.com>
References: <20230522141335.22536-1-louis.peens@corigine.com>
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

On Mon, 2023-05-22 at 16:13 +0200, Louis Peens wrote:
> From: Jaco Coetzee <jaco.coetzee@corigine.com>
>=20
> Add layer 4 RSS hashing on UDP traffic to allow for the
> utilization of multiple queues for multiple connections on
> the same IP address.
>=20
> Previously, since the introduction of the driver, RSS hashing
> was only performed on the source and destination IP addresses
> of UDP packets thereby limiting UDP traffic to a single queue
> for multiple connections on the same IP address. The transport
> layer is now included in RSS hashing for UDP traffic, which
> was not previously the case. The reason behind the previous
> limitation is unclear - either a historic limitation of the
> NFP device, or an oversight.

FTR including the transport header in RSS hash for UDP will damage
fragmented traffic, but whoever is relaying on fragments nowadays
should have already at least a dedicated setup.

So patch LGTM,

thanks,

Paolo


