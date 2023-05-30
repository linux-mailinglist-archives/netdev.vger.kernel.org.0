Return-Path: <netdev+bounces-6397-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 10BD871624E
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 15:41:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C0020281047
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 13:41:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA2C6209A1;
	Tue, 30 May 2023 13:41:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE2A11993C
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 13:41:16 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87727100
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 06:41:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685454069;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=n0CkyHEtcTifnOXVB8Vspl4eg4a6Ka45BNcOmHqGA8I=;
	b=DXDhZQgOZ30dsmu57lWpRlBT2tAldgsxGaNjuBUGyKs93cTFRC6Ubvk0C3HyayivaqoerI
	KOuJi2ECQ3WO9hIDT2XSyQ9Fhyi7vJXujURo7tea+cfeM39ZX2aFikxAeoEdPZVsGwcRDc
	dT2JlnbrD+u2S06cRNBdj3ltut+B4qs=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-222-45Fpp_r6N623V_yF-QNYEQ-1; Tue, 30 May 2023 09:41:08 -0400
X-MC-Unique: 45Fpp_r6N623V_yF-QNYEQ-1
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-75cb47e5507so8782685a.1
        for <netdev@vger.kernel.org>; Tue, 30 May 2023 06:41:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685454068; x=1688046068;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=n0CkyHEtcTifnOXVB8Vspl4eg4a6Ka45BNcOmHqGA8I=;
        b=i9wLH9hicGkOSqhutX+8r5DX9G1YyLasG0/o+Ixd8OvSfvGbvNztSbwDvFOh6liOA/
         BVlLuWVttQE9+4gFFp0LDCRR7MgCuL3kU7gvV0ZvxLnn10PT0wK24XkdZ3dU6YYbOm+i
         19hTW/qeH4GFS5/ZHKBoXycs+vm15WRKqTvCT9PxYGiftdl7tNEJMLVzO1TfBBusNBQ6
         GM+v7yBP3xqK9Uo61lZHrD74sF2NCniswtRaoHnbxKHbRURItgIZitmvT4AjRcholWwu
         6ZLvNoWWTmOjC5jju5rjpVwGCodg+eQegR/xasIK0yBrVV9afBuLci6WFjY8JVUyv8hZ
         +KZw==
X-Gm-Message-State: AC+VfDzDuX9aBGZhlbvQE7LD+mjEHRKDBuk9sUGKMuwhfZvvmCzzdipT
	aK38Ly4ThlKuXWW9ni98d1MfpOAUArZVoQdzsdS137HUdmirEIQlUgiLmaYEXc5GHlM2iNEtelj
	+ndx2WvzS9dosdYdRCNKQuZkv
X-Received: by 2002:a05:620a:2694:b0:75b:23a1:82a2 with SMTP id c20-20020a05620a269400b0075b23a182a2mr2019258qkp.3.1685454067873;
        Tue, 30 May 2023 06:41:07 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7j/oCMBGzRbpvd7/AXnahFFwjHyAEk12eU0pbhaky5dA8obmwDB2JJodeXY7f1zLQga2djRg==
X-Received: by 2002:a05:620a:2694:b0:75b:23a1:82a2 with SMTP id c20-20020a05620a269400b0075b23a182a2mr2019242qkp.3.1685454067613;
        Tue, 30 May 2023 06:41:07 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-248-97.dyn.eolo.it. [146.241.248.97])
        by smtp.gmail.com with ESMTPSA id p2-20020a05621415c200b0061b58b07130sm1355409qvz.137.2023.05.30.06.41.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 May 2023 06:41:07 -0700 (PDT)
Message-ID: <a75954b2fd1aeccb2a6898dc9d10f7e46f611788.camel@redhat.com>
Subject: Re: [PATCH net-next v3 1/2] usbnet: ipheth: fix risk of NULL
 pointer deallocation
From: Paolo Abeni <pabeni@redhat.com>
To: George Valkov <gvalkov@gmail.com>, Foster Snowhill <forst@pen.gy>
Cc: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>,  Jakub Kicinski <kuba@kernel.org>, Simon Horman
 <simon.horman@corigine.com>, Jan Kiszka <jan.kiszka@siemens.com>, linux-usb
 <linux-usb@vger.kernel.org>, Linux Netdev List <netdev@vger.kernel.org>
Date: Tue, 30 May 2023 15:41:04 +0200
In-Reply-To: <A4F3E461-E5BE-4707-B63A-BD6AAC3DBD02@gmail.com>
References: <20230527130309.34090-1-forst@pen.gy>
	 <0f7a8b0c149daa49c34a817cc24d1d58acedb9f4.camel@redhat.com>
	 <A4F3E461-E5BE-4707-B63A-BD6AAC3DBD02@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, 2023-05-30 at 14:11 +0300, George Valkov wrote:
> Sorry, I attached the old version by mistake. Here is the new version:

LGTM.

Please in future prefer inline patch vs attachments even for
discussion.

Note that you will have to formally repost both patches.

Thanks!

Paolo


