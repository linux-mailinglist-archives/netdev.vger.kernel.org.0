Return-Path: <netdev+bounces-5944-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 52C88713804
	for <lists+netdev@lfdr.de>; Sun, 28 May 2023 08:29:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0D0A9280E9F
	for <lists+netdev@lfdr.de>; Sun, 28 May 2023 06:29:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 842AF65D;
	Sun, 28 May 2023 06:29:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 787B5366
	for <netdev@vger.kernel.org>; Sun, 28 May 2023 06:29:12 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08228A8
	for <netdev@vger.kernel.org>; Sat, 27 May 2023 23:29:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685255350;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=d1z1TCz2XlwxREEQEluVbhG7+rqICZNvx0IHizhIGLQ=;
	b=IJdVF9WkrsGGGk9je/z7heM6Jk1tLcDMmTE/qTlGN0PSKSMhI5kgQ1Se4PfggruC/8W/gi
	OL+se4RwbEnjIvJFgzq9/WJ6k+lrDBDL4PiTzJnlSHcO8BvfRYtgFVOF97jOkekH+zPIpc
	RsJ9MNCRIRuC7+gkRc5UWwi34GnglXM=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-600-7P7RE_OcOfm8PHA8RzOA6Q-1; Sun, 28 May 2023 02:29:08 -0400
X-MC-Unique: 7P7RE_OcOfm8PHA8RzOA6Q-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-3f60f085cd2so8370475e9.0
        for <netdev@vger.kernel.org>; Sat, 27 May 2023 23:29:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685255347; x=1687847347;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=d1z1TCz2XlwxREEQEluVbhG7+rqICZNvx0IHizhIGLQ=;
        b=ZfnQP08GrpfspU5EIbIfdClQvE53iz4TNnDtDkhXhH1dvPYs20pnN98+UAGzP5pP1d
         I230zaZ2XY0Ivqzi66M83WB1X3LFIiq/ovTLgsvvRTC1bBdEqgHa1HGGtJwnnCenny7N
         Fk2gIdl78tZ23hKSK1jysBQSaeaISRJJvrnszJFv9whbqs2BU8hb0r9KM7rCVU+7pybV
         o3puDjtTlxknj2+Hlutjfp6uSUaXMLAhBlg9Nz9L8W+UIDRuGHqJNfArcVeBTxXQn+Tb
         S5puvRRlIzYdbYYEenNOdoeneZIzfaf9WS4XqrEYcyIJdtOrdGWjp20X9PbVeq3U153/
         XGCg==
X-Gm-Message-State: AC+VfDyWgwTXljtKL6NB3BQpfA4umDDMk1dTsklbxhe5KqECq1rJJlZN
	KqOXHx0Lc842COb8d2qwQsPDyMTtRVQ1jxENY6r8oy6XqnzE5yqDF29s9iiad5pi391rx+k04WH
	bmRvJAxKGDCmUax0N
X-Received: by 2002:a7b:cc95:0:b0:3f5:1a4:a08d with SMTP id p21-20020a7bcc95000000b003f501a4a08dmr7162220wma.7.1685255347699;
        Sat, 27 May 2023 23:29:07 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6oMIRa2O5snnR2DBaZbn6UNByaPav76lWPUnAJoPlC/LhnJ393xJpdpLpMJQpzMKIgXPhbhw==
X-Received: by 2002:a7b:cc95:0:b0:3f5:1a4:a08d with SMTP id p21-20020a7bcc95000000b003f501a4a08dmr7162208wma.7.1685255347442;
        Sat, 27 May 2023 23:29:07 -0700 (PDT)
Received: from redhat.com ([2.52.146.27])
        by smtp.gmail.com with ESMTPSA id z10-20020a7bc7ca000000b003f602e2b653sm13856777wmk.28.2023.05.27.23.29.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 May 2023 23:29:06 -0700 (PDT)
Date: Sun, 28 May 2023 02:29:02 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jason Wang <jasowang@redhat.com>
Cc: Liang Chen <liangchen.linux@gmail.com>,
	virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, xuanzhuo@linux.alibaba.com,
	kuba@kernel.org, edumazet@google.com, davem@davemloft.net,
	pabeni@redhat.com, alexander.duyck@gmail.com
Subject: Re: [PATCH net-next 1/5] virtio_net: Fix an unsafe reference to the
 page chain
Message-ID: <20230528022737-mutt-send-email-mst@kernel.org>
References: <20230526054621.18371-1-liangchen.linux@gmail.com>
 <CACGkMEuUTNfHXQPg29eUZFnVBRJEmjjKN4Jmr3=Qnkgjj0B9PQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACGkMEuUTNfHXQPg29eUZFnVBRJEmjjKN4Jmr3=Qnkgjj0B9PQ@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 26, 2023 at 02:38:54PM +0800, Jason Wang wrote:
> On Fri, May 26, 2023 at 1:46 PM Liang Chen <liangchen.linux@gmail.com> wrote:
> >
> > "private" of buffer page is currently used for big mode to chain pages.
> > But in mergeable mode, that offset of page could mean something else,
> > e.g. when page_pool page is used instead. So excluding mergeable mode to
> > avoid such a problem.
> 
> If this issue happens only in the case of page_pool, it would be
> better to squash it there.
> 
> Thanks


This is a tiny patch so I don't care. Generally it's ok
to first rework code then change functionality.
in this case what Jason says os right especially because
you then do not need to explain that current code is ok.

> >
> > Signed-off-by: Liang Chen <liangchen.linux@gmail.com>
> > ---
> >  drivers/net/virtio_net.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > index 5a7f7a76b920..c5dca0d92e64 100644
> > --- a/drivers/net/virtio_net.c
> > +++ b/drivers/net/virtio_net.c
> > @@ -497,7 +497,7 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
> >                         return NULL;
> >
> >                 page = (struct page *)page->private;
> > -               if (page)
> > +               if (!vi->mergeable_rx_bufs && page)
> >                         give_pages(rq, page);
> >                 goto ok;
> >         }
> > --
> > 2.31.1
> >


