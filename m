Return-Path: <netdev+bounces-3210-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0CB6A705F9B
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 07:56:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A81C728146B
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 05:56:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D128C53BD;
	Wed, 17 May 2023 05:56:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1E0C5255
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 05:56:50 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED382E4D
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 22:56:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684303007;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=paowWkASk16hubwATQo3Brz1Kl1HeTMdLB0m2zyw74E=;
	b=bdvSWKHeNOlIIJ/J6tl+/KPwH1yHn0QfdjYYJvworW22Q+sFX3I+J9O+8Tp0ZeCeOHxjdc
	jakieHi/okuIg1InoCb7CGVU5mfc06KHipu8ziJ2w4E80GEPWAl+wMYhbWy/6S06JzrMD5
	qePWxQrig26byjy3xdW6DuzvXy+0u+Y=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-584-_xxic82wNWS3nnAZi78-TQ-1; Wed, 17 May 2023 01:56:45 -0400
X-MC-Unique: _xxic82wNWS3nnAZi78-TQ-1
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-4ef455ba61cso292618e87.0
        for <netdev@vger.kernel.org>; Tue, 16 May 2023 22:56:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684303004; x=1686895004;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=paowWkASk16hubwATQo3Brz1Kl1HeTMdLB0m2zyw74E=;
        b=Sm01pZE9cEFmtHLPM5ZUujVgkGEmRl6IpK3utn0UC5LMsLwSa2noWBlNy5EF7QZPSj
         1VM+1Rj7irhe5RlqPFwP9ggjmR8kDvcsx1xDS55eJ2+HDwCFdfIi3pWh6cOjrZglf64s
         IHYxH4sE03OEoFVVOaMBvmHYvfLdpU2w58Cv5xper9pCGY0qicrQRpTfNZs2prrPF4IA
         vMokCc2PjsfhENt2pPxowLFHSN9Fyz0B1mpjdJovYLDZkc86IIiN8WnVUqgzBvurFUyF
         hdTZVuPdQ7bDZMqq/BX+loWJ9gbHizrlDuwJnUIuxvBRte6rDptA+BoX0t/saq1SvcNB
         /wrg==
X-Gm-Message-State: AC+VfDw4K/2wCNDk++5Ci034rwaswrz97MM14+7HkhtzRCwp20h7RQsf
	VXfXwUZgKbtiyjs3bs2tYfcLO21LalX41BN3lh2FPTfMwpo5n8TIi61ecGMoovQQf0pedsQda2V
	7NqyHUVtA4c0E47QfuHtc3rRcwWnVomKD
X-Received: by 2002:a19:ee0f:0:b0:4f1:1de7:1aaf with SMTP id g15-20020a19ee0f000000b004f11de71aafmr8591205lfb.69.1684303004490;
        Tue, 16 May 2023 22:56:44 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6c5lVz5bfrEcS2OQVMQdb5WrybHfTwnvBceDooNozxkZdY1qQHR0m0Uhv89nelaL2B6z9XJn/liEVS/bUZXdA=
X-Received: by 2002:a19:ee0f:0:b0:4f1:1de7:1aaf with SMTP id
 g15-20020a19ee0f000000b004f11de71aafmr8591199lfb.69.1684303004242; Tue, 16
 May 2023 22:56:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <29db10bca7e5ef6b1137282292660fc337a4323a.1683907102.git.allen.hubbe@amd.com>
In-Reply-To: <29db10bca7e5ef6b1137282292660fc337a4323a.1683907102.git.allen.hubbe@amd.com>
From: Jason Wang <jasowang@redhat.com>
Date: Wed, 17 May 2023 13:56:33 +0800
Message-ID: <CACGkMEu2d2ap_jzUGH8MpLZvscEPGZLtDxRqM2gjPQ43GS1B1g@mail.gmail.com>
Subject: Re: [PATCH] vdpa: consume device_features parameter
To: Shannon Nelson <shannon.nelson@amd.com>
Cc: dsahern@kernel.org, netdev@vger.kernel.org, 
	virtualization@lists.linux-foundation.org, mst@redhat.com, 
	allen.hubbe@amd.com, drivers@pensando.io
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sat, May 13, 2023 at 12:42=E2=80=AFAM Shannon Nelson <shannon.nelson@amd=
.com> wrote:
>
> From: Allen Hubbe <allen.hubbe@amd.com>
>
> Consume the parameter to device_features when parsing command line
> options.  Otherwise the parameter may be used again as an option name.
>
>  # vdpa dev add ... device_features 0xdeadbeef mac 00:11:22:33:44:55
>  Unknown option "0xdeadbeef"
>
> Fixes: a4442ce58ebb ("vdpa: allow provisioning device features")
> Signed-off-by: Allen Hubbe <allen.hubbe@amd.com>
> Reviewed-by: Shannon Nelson <shannon.nelson@amd.com>

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks

> ---
>  vdpa/vdpa.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/vdpa/vdpa.c b/vdpa/vdpa.c
> index 27647d73d498..8a2fca8647b6 100644
> --- a/vdpa/vdpa.c
> +++ b/vdpa/vdpa.c
> @@ -353,6 +353,8 @@ static int vdpa_argv_parse(struct vdpa *vdpa, int arg=
c, char **argv,
>                                                 &opts->device_features);
>                         if (err)
>                                 return err;
> +
> +                       NEXT_ARG_FWD();
>                         o_found |=3D VDPA_OPT_VDEV_FEATURES;
>                 } else {
>                         fprintf(stderr, "Unknown option \"%s\"\n", *argv)=
;
> --
> 2.17.1
>


