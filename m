Return-Path: <netdev+bounces-3514-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 076CE707A68
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 08:52:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3F39E28180E
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 06:52:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18E6B2A9C9;
	Thu, 18 May 2023 06:52:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0C6B7E
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 06:52:31 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6EC71FFE
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 23:52:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684392749;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gSavymqDlmQylIsmKhBNIhCqeP+n4S6uIb0DPAJ6JaI=;
	b=UnIOXMNldhD/dBtAYnEEsjuGVSWqoOXcafnyAk2Z5YLpw+5lOwpL4SApwAYs6pZBjXNNqE
	+6xsSCUm6p1+PZnFZ0LsKrGCaeLiJnpArmVyMeRtlM06zu/9xKPbPumUoE4UCyHP6Lke+2
	8LPDZfQdYTCkqSRzH9QI4nKQ75gwAVQ=
Received: from mail-yw1-f197.google.com (mail-yw1-f197.google.com
 [209.85.128.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-481-zGXv7GjYNryztCY-GSvl9Q-1; Thu, 18 May 2023 02:52:28 -0400
X-MC-Unique: zGXv7GjYNryztCY-GSvl9Q-1
Received: by mail-yw1-f197.google.com with SMTP id 00721157ae682-5618b2341d9so25664257b3.2
        for <netdev@vger.kernel.org>; Wed, 17 May 2023 23:52:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684392747; x=1686984747;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gSavymqDlmQylIsmKhBNIhCqeP+n4S6uIb0DPAJ6JaI=;
        b=flVg9g0FhfWx52bRhyKo2Nv9Ep6Qcn+IHIS6oeCxjnZOhOWHrvhpx8JmY7/c6HORc7
         osDNr/WiEYke6Crey//RcCK8kfsLep/GZ8HbVbXhX6oYV+L5S+tg/MIQSWYqCDYhUPfL
         +qdG0MxUdwoBM1/BSll65TKL8x/xVY1+k7MxIxvfhQYWF6bVkagxPCrV+GkUJR+7YWY6
         2wjqzZ3khAQ9ZNdyDo/t3pzij2mF5Mz5No+Ffbmixmj15WpG8rAu/eEOf5dKX/kbl4xP
         Xic1phyQoWoN7L2OK/t+6bG6gVDpkFoei/+BQsKSJqNsBJqT/61DnHFvgVWwjMrIxVWW
         huTw==
X-Gm-Message-State: AC+VfDxnvzyZwGXNxm7Dxsprntoxvh4pcMeT/eWhLXwfioKFqb2rrD2q
	q6shDl/LxjUKu2FUqv3fpeCAs3B17Ce7DP4JNIVTwBDjW0R2iD7wgF6uehAZ8YwAQ6GCIFB5+2E
	VreyZsSIWHYNzXAVaxhAsvhR9q2LRshGXXlgdZuQJ
X-Received: by 2002:a81:4987:0:b0:561:8f81:2a3f with SMTP id w129-20020a814987000000b005618f812a3fmr532484ywa.29.1684392747723;
        Wed, 17 May 2023 23:52:27 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4VwnHV+g9ULJc8v3utx1e1dnIa4PnH69UBNsDWYNoMad/wGAY1hnbUhvl9RrpDZy0E84PXF6zbPbAkJQVr1gw=
X-Received: by 2002:a81:4987:0:b0:561:8f81:2a3f with SMTP id
 w129-20020a814987000000b005618f812a3fmr532477ywa.29.1684392747465; Wed, 17
 May 2023 23:52:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <29db10bca7e5ef6b1137282292660fc337a4323a.1683907102.git.allen.hubbe@amd.com>
In-Reply-To: <29db10bca7e5ef6b1137282292660fc337a4323a.1683907102.git.allen.hubbe@amd.com>
From: Eugenio Perez Martin <eperezma@redhat.com>
Date: Thu, 18 May 2023 08:51:51 +0200
Message-ID: <CAJaqyWeEqpZ67Tn4UdSnF75ZV+8iA_jTOYV_QaP2zy5EUj2xaA@mail.gmail.com>
Subject: Re: [PATCH] vdpa: consume device_features parameter
To: Shannon Nelson <shannon.nelson@amd.com>
Cc: dsahern@kernel.org, netdev@vger.kernel.org, 
	virtualization@lists.linux-foundation.org, mst@redhat.com, 
	jasowang@redhat.com, allen.hubbe@amd.com, drivers@pensando.io
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 12, 2023 at 6:42=E2=80=AFPM Shannon Nelson <shannon.nelson@amd.=
com> wrote:
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

Acked-by: Eugenio P=C3=A9rez <eperezma@redhat.com>


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
>


