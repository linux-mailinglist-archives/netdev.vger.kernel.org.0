Return-Path: <netdev+bounces-6330-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A052715C80
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 13:02:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7206B28111F
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 11:02:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 936DC174F5;
	Tue, 30 May 2023 11:02:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8448F125B1
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 11:02:46 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5131DA8
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 04:02:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685444564;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dSzk8Yi5vP8hlY2CK6/rG6duz8saPW0zYZYVLxPb0K8=;
	b=VTCiA28w4YPQHEKfuiDxx+ZgmKbDwAx/hiJaLfmrEcQRIpZz+SBc9JRx6oVRHIiYiWxLBS
	xouQ9QR59vOcsEU2bcahNyu+kg3IabUpy9riAdRYTEDM/JgC87bhfRD8yT2bpLJjIisG5o
	7lmg6hbs4h3idU7H0a3JD/oD64rlVz4=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-120-ya1KLLkyP2Ottv07f2W7nQ-1; Tue, 30 May 2023 07:02:43 -0400
X-MC-Unique: ya1KLLkyP2Ottv07f2W7nQ-1
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-64d614d3674so903108b3a.0
        for <netdev@vger.kernel.org>; Tue, 30 May 2023 04:02:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685444562; x=1688036562;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dSzk8Yi5vP8hlY2CK6/rG6duz8saPW0zYZYVLxPb0K8=;
        b=XBsZlW8PGkj9Ik/owd6RaDNF7P84MMCKbKDxEvPvKAU6vqRmVHemJGMWDoSx4u5KfA
         NyfDAEa3liRGNZObRl4Qd9eKY/YPFbzkcnGDfJHIoUSib3jZnPiNd94ihLGZUPqC2H4n
         fwKpao7M5OyYf7T7Jv52FPcxEBeZLKB6SOKeapbjVxqVf950WE1N0nRdlDrmyr4jGkKp
         n6xTwS+mw5tI2D1nNd1Z33FPEWG2dJe5rSkzuKWy25CaW55XwaFYkDvCKeeSa8dWSPhF
         S45U94tw610xX6xTUP3eRHO1RhO9ncaiJpwgEsp8+yI7jjWc1IUhbFlG0wKqHMGZ/y7S
         wQWQ==
X-Gm-Message-State: AC+VfDxAPTkZxVbfc5oWhvgItrsOE/02NaJJqH62UuvNCcTzV0naIOHk
	/nvf1h1QJCv2Bu/xxPt2xkQ6DO788JkwKT2lGP1G69tz1tX4pdBt3TfhZnK/bMxxgvUm9Q0iUji
	sqmsFuC1saDvq7hxf4WYc1bIg
X-Received: by 2002:a05:6a00:2e12:b0:643:9bc3:422a with SMTP id fc18-20020a056a002e1200b006439bc3422amr1637046pfb.3.1685444562216;
        Tue, 30 May 2023 04:02:42 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4/wLRPw7JOC5bPdXKbq0a8bjrBR7lJ5iXuRDjL3OKqL5l6HeuOZyQpXD+m4y7K36bLzx2U4A==
X-Received: by 2002:a05:6a00:2e12:b0:643:9bc3:422a with SMTP id fc18-20020a056a002e1200b006439bc3422amr1637028pfb.3.1685444561854;
        Tue, 30 May 2023 04:02:41 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-248-97.dyn.eolo.it. [146.241.248.97])
        by smtp.gmail.com with ESMTPSA id b15-20020aa7810f000000b0064ceb16a1a2sm1364941pfi.182.2023.05.30.04.02.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 May 2023 04:02:41 -0700 (PDT)
Message-ID: <0f7a8b0c149daa49c34a817cc24d1d58acedb9f4.camel@redhat.com>
Subject: Re: [PATCH net-next v3 1/2] usbnet: ipheth: fix risk of NULL
 pointer deallocation
From: Paolo Abeni <pabeni@redhat.com>
To: Foster Snowhill <forst@pen.gy>, "David S. Miller" <davem@davemloft.net>,
  Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>
Cc: Georgi Valkov <gvalkov@gmail.com>, Simon Horman
 <simon.horman@corigine.com>,  Jan Kiszka <jan.kiszka@siemens.com>,
 linux-usb@vger.kernel.org, netdev@vger.kernel.org
Date: Tue, 30 May 2023 13:02:37 +0200
In-Reply-To: <20230527130309.34090-1-forst@pen.gy>
References: <20230527130309.34090-1-forst@pen.gy>
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

Hi,=20

On Sat, 2023-05-27 at 15:03 +0200, Foster Snowhill wrote:
> From: Georgi Valkov <gvalkov@gmail.com>
>=20
> The cleanup precedure in ipheth_probe will attempt to free a
> NULL pointer in dev->ctrl_buf if the memory allocation for
> this buffer is not successful. While kfree ignores NULL pointers,
> and the existing code is safe, it is a better design to rearrange
> the goto labels and avoid this.
>=20
> Signed-off-by: Georgi Valkov <gvalkov@gmail.com>
> Signed-off-by: Foster Snowhill <forst@pen.gy>

If you are going to repost (due to changes in patch 2) please update
this patch subj, too. Currently is a bit confusing, something alike
"cleanup the initialization error path" would be more clear.

Thanks,

Paolo


