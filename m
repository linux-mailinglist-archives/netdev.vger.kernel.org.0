Return-Path: <netdev+bounces-586-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 72CBD6F8520
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 16:59:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 091BD28100D
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 14:59:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C07C1C141;
	Fri,  5 May 2023 14:59:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF81B5383
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 14:59:46 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33F3D17DD6
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 07:59:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683298784;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rBXNgO7aRryOo3aOK63YAEnZA6K4XoikS9SxHfhUh30=;
	b=Xdpu0TN5wUDqy1TFcaxWXsjJYrGZYlHWi+hj8K+e+VIY+DYuxSeFX0kLq5yWau31tcBkEF
	cS40AdKe38QfsHDqy+iqI9lAoJa52kf2tz8DKaxxpVmHiq09EY7sf1fYZ9rR0zYlBbu+/n
	o7OctNrG5uWmKpJaEN2HA9ndcyK90CY=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-569-lZL0HrEgO1W2htqUEuv_4Q-1; Fri, 05 May 2023 10:59:42 -0400
X-MC-Unique: lZL0HrEgO1W2htqUEuv_4Q-1
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-50bc6c6b9dbso13148741a12.0
        for <netdev@vger.kernel.org>; Fri, 05 May 2023 07:59:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683298781; x=1685890781;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rBXNgO7aRryOo3aOK63YAEnZA6K4XoikS9SxHfhUh30=;
        b=k1wz32AY/JiWWqCbVk3Cu+Akirz2UE083TtahOP2j1BSjkOU38tsyqV48HZmeb89ZU
         mh6ODCf1EjIq40JlTxvM08/eyBEl+luO1lfB7CKYh+p9hapQFIMIufrTdfkSldg2EzLB
         yPDJYZocH3wgTsQVc0/OmshJvGWlblb2RaDMp0bSOqxMOFARvd6BLZIxA3Oa7pHhDLLD
         aZChodTUF5jYlBMt9+poxu98gXLj7pHt3oNoTYLpNmdl7PHOMYPENtgljE4U0tiPVxTi
         QruSwSUIRHqjZukdcUHp0zGKMatTiECQc7xe4N4eUVUAcTNarTMnAikaaI6Dw9tQPXHx
         O6Tw==
X-Gm-Message-State: AC+VfDzbNFisxQLGIKpAv//s1AqQ/nBiYK+fK9uyDbDM4JyrshqElfES
	rsfcTQt601xD8rCCY15yDaQtdTcLa4k7azKFsv0NulnHTILWz4gd/z+1i26wHPo1Mc9QTmWo5hb
	Lfh+PT50nCnHR2wsB
X-Received: by 2002:aa7:ccc6:0:b0:50b:dfe2:91 with SMTP id y6-20020aa7ccc6000000b0050bdfe20091mr1904396edt.7.1683298781576;
        Fri, 05 May 2023 07:59:41 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ41nBmpMVnXW7PKFZ8ZB30pUuvlx01dx8IxPbfnWfLUCXzpn0UbIn+XfcKAeqyn2xG3hPxzGw==
X-Received: by 2002:aa7:ccc6:0:b0:50b:dfe2:91 with SMTP id y6-20020aa7ccc6000000b0050bdfe20091mr1904374edt.7.1683298781292;
        Fri, 05 May 2023 07:59:41 -0700 (PDT)
Received: from redhat.com ([77.137.193.128])
        by smtp.gmail.com with ESMTPSA id h20-20020aa7c614000000b00501d73cfc86sm3024677edq.9.2023.05.05.07.59.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 May 2023 07:59:40 -0700 (PDT)
Date: Fri, 5 May 2023 10:59:37 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: ye xingchen <yexingchen116@gmail.com>
Cc: jasowang@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
	ye.xingchen@zte.com.cn
Subject: Re: [PATCH] vhost_net: Use fdget() and fdput()
Message-ID: <20230505105811-mutt-send-email-mst@kernel.org>
References: <CACGkMEsmf3PgxmhgRCsPZe7fRWHDXQ=TtYu5Tgx1=_Ymyvi-pA@mail.gmail.com>
 <20230505084155.63839-1-ye.xingchen@zte.com.cn>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230505084155.63839-1-ye.xingchen@zte.com.cn>
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 05, 2023 at 04:41:55PM +0800, ye xingchen wrote:
> >>
> >> From: Ye Xingchen <ye.xingchen@zte.com.cn>
> >>
> >> convert the fget()/fput() uses to fdget()/fdput().
> >What's the advantages of this?
> >
> >Thanks
> >>
> >> Signed-off-by: Ye Xingchen <ye.xingchen@zte.com.cn>
> >> ---
> >>  drivers/vhost/net.c | 10 +++++-----
> >>  1 file changed, 5 insertions(+), 5 deletions(-)
> >>
> >> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> >> index ae2273196b0c..5b3fe4805182 100644
> >> --- a/drivers/vhost/net.c
> >> +++ b/drivers/vhost/net.c
> >> @@ -1466,17 +1466,17 @@ static struct ptr_ring *get_tap_ptr_ring(struct file *file)
> >>
> >>  static struct socket *get_tap_socket(int fd)
> >>  {
> >> -       struct file *file = fget(fd);
> >> +       struct fd f = fdget(fd);
> >>         struct socket *sock;
> >>
> >> -       if (!file)
> >> +       if (!f.file)
> >>                 return ERR_PTR(-EBADF);
> >> -       sock = tun_get_socket(file);
> >> +       sock = tun_get_socket(f.file);
> >>         if (!IS_ERR(sock))
> >>                 return sock;
> >> -       sock = tap_get_socket(file);
> >> +       sock = tap_get_socket(f.file);
> >>         if (IS_ERR(sock))
> >> -               fput(file);
> >> +               fdput(f);
> >>         return sock;
> >>  }
> >>
> >> --
> >> 2.25.1
> >>
> fdget requires an integer type file descriptor as its parameter, 
> and fget requires a pointer to the file structure as its parameter.

In which kernel?

include/linux/file.h:extern struct file *fget(unsigned int fd);


> By using the fdget function, the socket object, can be quickly 
> obtained from the process's file descriptor table without 
> the need to obtain the file descriptor first before passing it 
> as a parameter to the fget function. This reduces unnecessary 
> operations, improves system efficiency and performance.
> 
> Best Regards
> Ye


