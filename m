Return-Path: <netdev+bounces-9036-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E0B2726A7F
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 22:15:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D9AE41C20D25
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 20:15:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 880AF3925D;
	Wed,  7 Jun 2023 20:15:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A4E619BBC
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 20:15:22 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D8241988
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 13:15:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686168919;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IbNJSMdQgU9VQLlBMF193RvlUeSC+D1EGbqTaY89bwo=;
	b=TM4D1KwtDiFTi+wEc4CIe1rdS2TwONzarjWtPWerQ0m6N2xobEzeNC1tqqLD71EURFeMpd
	exxC3X20xAGvJ3rxyi8LgGx1KR1jr/o3doFzrVbUnd/mHXn4WPCfbv8I8KG26ms6j6v3Lm
	r7e9ulTjVz/pq9MYYBg73I37Qza4iJw=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-655-uyTjz8MoNp6CiejcIeDGSg-1; Wed, 07 Jun 2023 16:15:18 -0400
X-MC-Unique: uyTjz8MoNp6CiejcIeDGSg-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-3f7e64e1157so23003065e9.0
        for <netdev@vger.kernel.org>; Wed, 07 Jun 2023 13:15:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686168917; x=1688760917;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IbNJSMdQgU9VQLlBMF193RvlUeSC+D1EGbqTaY89bwo=;
        b=bQs75CTkyaiE5A0TFFWaydWbyC+sLn5KACLfqbc0+geYxaZdJRqCziEAXuVzIJoE5M
         W9e0m0ZWcod1MD5Y8HPDsnptHmIkVndN8PGKK50VcoMTj0q6RJS2ufVCArjB4BFdzDeY
         Ei9B6c8rKJ2sOpj4hefqDamEpo7bOM+xy+CnK/5XwYIuaPPT3lbEBUdsjk7ekdQrKyAO
         WsHgYkwhg2tHJaA8Dk9y57xxYWMHQVPuEzEOMj3zjfHyk6H8zp1Ic2ivyoHoOe//UIog
         xrWFpHf7ZaJSZdlzB/d6bsbWJElLZ2cnQBOUhGUmW75nVxNTnUkqyY1+2U8f3TQuvZtN
         lNqw==
X-Gm-Message-State: AC+VfDzqG0f3ptu88jqgPWcDldcAZdZ+2WmPZpNNrjLrnOCfzT5Pqsde
	S4bZbjaUrEDfTqAjZlRrwgCnVHjx6tavmVcZ4YeeMatBM64HJWmAbD0DVZwP6jRpG1S3UDfUfXj
	EZwWOrOsuqubcP/lM
X-Received: by 2002:a1c:7717:0:b0:3f7:eadb:941d with SMTP id t23-20020a1c7717000000b003f7eadb941dmr7565491wmi.19.1686168917313;
        Wed, 07 Jun 2023 13:15:17 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6BuNZENhGXmy7RykVEep93dqwtBJaN8D86qVbIP42EfYDXBC7+P61b2CTrPMue3++mbYka1g==
X-Received: by 2002:a1c:7717:0:b0:3f7:eadb:941d with SMTP id t23-20020a1c7717000000b003f7eadb941dmr7565477wmi.19.1686168916980;
        Wed, 07 Jun 2023 13:15:16 -0700 (PDT)
Received: from redhat.com ([2.55.4.169])
        by smtp.gmail.com with ESMTPSA id s17-20020a7bc391000000b003f727764b10sm3110831wmj.4.2023.06.07.13.15.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jun 2023 13:15:16 -0700 (PDT)
Date: Wed, 7 Jun 2023 16:15:12 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Jakub Kicinski <kuba@kernel.org>,
	virtualization@lists.linux-foundation.org,
	Jason Wang <jasowang@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>, netdev@vger.kernel.org,
	bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH vhost v10 00/10] virtio core prepares for AF_XDP
Message-ID: <20230607161440-mutt-send-email-mst@kernel.org>
References: <20230602092206.50108-1-xuanzhuo@linux.alibaba.com>
 <20230602232902.446e1d71@kernel.org>
 <1685930301.215976-1-xuanzhuo@linux.alibaba.com>
 <ZICOl1hfsx5DwKff@infradead.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZICOl1hfsx5DwKff@infradead.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, Jun 07, 2023 at 07:05:11AM -0700, Christoph Hellwig wrote:
> On Mon, Jun 05, 2023 at 09:58:21AM +0800, Xuan Zhuo wrote:
> > On Fri, 2 Jun 2023 23:29:02 -0700, Jakub Kicinski <kuba@kernel.org> wrote:
> > > On Fri,  2 Jun 2023 17:21:56 +0800 Xuan Zhuo wrote:
> > > > Thanks for the help from Christoph.
> > >
> > > That said you haven't CCed him on the series, isn't the general rule to
> > > CC anyone who was involved in previous discussions?
> > 
> > 
> > Sorry, I forgot to add cc after git format-patch.
> 
> So I've been looking for this series elsewhere, but it seems to include
> neither lkml nor the iommu list, so I can't find it.  Can you please
> repost it?

I bounced to lkml now - does this help?


