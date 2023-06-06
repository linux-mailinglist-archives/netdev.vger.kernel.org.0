Return-Path: <netdev+bounces-8428-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B7F7F724057
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 13:00:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 71A982814EB
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 11:00:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6976414AAE;
	Tue,  6 Jun 2023 11:00:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59DC2468F
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 11:00:00 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAA201724
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 03:59:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686049163;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fjDXftYp5RUrNR1VA3ZUFoVwqX6agK4RoTjNejwdF8o=;
	b=FRsDr+5Eptr8P1kgJOhUfTSel/CEWm9jL2jVR0IQDsthMKw6wU65P33Wr4EEolXwKw9Cd0
	a//bsU/JMG/EnK/eGigJPDI/o7TjM5jKwZxqJO4Y7rttmuayLGjO3hETHboL7iPP4Pre6q
	7E2Fs8fCFrVIWK0QY4nFe6wR5v33xYk=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-53-YRMEWl4UMRqSp5gCJPQ5Ow-1; Tue, 06 Jun 2023 06:59:22 -0400
X-MC-Unique: YRMEWl4UMRqSp5gCJPQ5Ow-1
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-3f8654d47b4so5567881cf.1
        for <netdev@vger.kernel.org>; Tue, 06 Jun 2023 03:59:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686049161; x=1688641161;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fjDXftYp5RUrNR1VA3ZUFoVwqX6agK4RoTjNejwdF8o=;
        b=jefpnx+HhIQMlMV84BlhnRZckx+gDA19/bd+EgG9Z9HRjPap8YceuYKitwef88Fu/p
         zh6w0ecpd5Fc4eFOABcTQiysz5e2pGC15PCi9IKdWCOZwOsge7PuJSItO+z0qSmsDPeP
         XJRPUc3EOh8yZAobEH0GYozK7iOw9ABLcFskn5+oVKdhRayK+A61bImpENgfpe4CCJfX
         H3/o5/+FGclxIln+orCmXXsZ+HE5t5nZ4io7WD8zb3V+RzehwmjAUyARmj5KTXRudq6y
         wLXEWi1++rqoq9NhO0434WtRlG5Pq4HlZlMPDHob7TwfQiyIcdx6rd0N193SwpzfpPUz
         v/xQ==
X-Gm-Message-State: AC+VfDz4e0lgYJ8qqCWKkQrJkUWi8DturAwKbGgnv8YahqRi1sWzXHba
	Pl7u5xKqQnymdld5Ok+48IVtA3SnNT04fGf6ResgUgBfcaNv5XY24DSmqrAa0XNfvs1bxJi7AFW
	FOiuBm/vYy1I/cBGt
X-Received: by 2002:ad4:594d:0:b0:625:aa49:a48b with SMTP id eo13-20020ad4594d000000b00625aa49a48bmr1681303qvb.6.1686049161486;
        Tue, 06 Jun 2023 03:59:21 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4860n1BYkfmXe2BunU1XbdTSEOrGqg2bogsqCCVtENchpUXVgVq2DDqvRz5QYJ0/KLaTL0Bg==
X-Received: by 2002:ad4:594d:0:b0:625:aa49:a48b with SMTP id eo13-20020ad4594d000000b00625aa49a48bmr1681293qvb.6.1686049161203;
        Tue, 06 Jun 2023 03:59:21 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-114-89.dyn.eolo.it. [146.241.114.89])
        by smtp.gmail.com with ESMTPSA id ep12-20020a05621418ec00b0061b731bf3c2sm5255180qvb.80.2023.06.06.03.59.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jun 2023 03:59:20 -0700 (PDT)
Message-ID: <bedca9be6c496bbe9e124eda7ce13cf15bf7ca54.camel@redhat.com>
Subject: Re: [PATCH net] lib: cpu_rmap: Fix potential use-after-free in
 irq_cpu_rmap_release()
From: Paolo Abeni <pabeni@redhat.com>
To: Ben Hutchings <ben@decadent.org.uk>, netdev@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org, Eli
	Cohen <elic@nvidia.com>, jacob.e.keller@intel.com, saeedm@nvidia.com
Date: Tue, 06 Jun 2023 12:59:17 +0200
In-Reply-To: <ZHo0vwquhOy3FaXc@decadent.org.uk>
References: <ZHo0vwquhOy3FaXc@decadent.org.uk>
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
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi,

On Fri, 2023-06-02 at 20:28 +0200, Ben Hutchings wrote:
> irq_cpu_rmap_release() calls cpu_rmap_put(), which may free the rmap.
> So we need to clear the pointer to our glue structure in rmap before
> doing that, not after.
>=20
> Fixes: 4e0473f1060a ("lib: cpu_rmap: Avoid use after free on rmap->obj ..=
.")
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>

The patch LGTM, but please include the full blamed commit title into
the fixes tag. A new version will be needed.

Also add Jacob and Saeed to the cc-list

Thanks,

Paolo


