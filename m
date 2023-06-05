Return-Path: <netdev+bounces-7860-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BAB07721D9C
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 07:44:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EAE301C20B19
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 05:44:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46FB84435;
	Mon,  5 Jun 2023 05:44:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3742C2104
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 05:44:39 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65529B8
	for <netdev@vger.kernel.org>; Sun,  4 Jun 2023 22:44:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685943876;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/ejXk37OnpgBfntpQO2hBNILL2g4QMjhCiXN34MbvEk=;
	b=fGFQpBRRMc40C8fWbp/Nrv4DsdtHxKzD4SEaxGaMphPyxjZMJnxgZNoBWMR4jE2FEfTD6b
	fA3eKHFWdsf0rYddOWY60d+M+xnW8HeIduBpgtjxURdOCaZfq80SWSHjWyRmv/UF0W1Xoh
	CWVW8WYSk8yRDqF2S90dsTMCa6JGpVA=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-571-dDTWDpCZOSOf9cPByZOcdw-1; Mon, 05 Jun 2023 01:44:33 -0400
X-MC-Unique: dDTWDpCZOSOf9cPByZOcdw-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-30b88392ac6so2393767f8f.0
        for <netdev@vger.kernel.org>; Sun, 04 Jun 2023 22:44:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685943872; x=1688535872;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/ejXk37OnpgBfntpQO2hBNILL2g4QMjhCiXN34MbvEk=;
        b=l1BDXFL8bf3Fm7YaY8/42vEI6ewfXUQa3HxGIRmy68r3ZkR1q8w1suvzamjgcogudg
         d/K03Rkzcn014Mb+B8ePv1BrGI6H+gbAFTsnfiGOBYrT0wOfg55GmURbmPHM8hLVojBA
         JGiSwoa4+yBWGztEpCwy2vIwlfPB+Cjj/gultc9SgSoYY01eLchzKhbQjsrVEO1sSGtb
         elkC+gTNR/8WKq75q67XwDbhX8yRuwKoQnxvPZ3ndXFcZa8fmav5DX7DNtsthneKYkDA
         jIz0YGK8DhRzdAkSrJ+GHJ2TBSZnj0E0gUaN4zTMs8nG5/Eguy1eElTU2TxKumYGiMi7
         Kb4A==
X-Gm-Message-State: AC+VfDw7EFx6xdi5zPTsZYHNeA/MhK8kZi5Iiau+y939sWnt5wxzFIkr
	2tWeACT+E6sxqor/JioOBkG4ewo/N+O5h0hW1qxMO+FY82NXBzUBOrFEkeu6jUd3mxh0kVbRU76
	3+Me1KR3H0xVkAVWC
X-Received: by 2002:adf:f687:0:b0:30a:e5e3:ea66 with SMTP id v7-20020adff687000000b0030ae5e3ea66mr4818787wrp.14.1685943872851;
        Sun, 04 Jun 2023 22:44:32 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5PHhVf9POTk1AmuouTd4HghcP4O8qLZ+32oStK2OroFPJBE288EDHshOL1o8Lb2YOXPb2Bvg==
X-Received: by 2002:adf:f687:0:b0:30a:e5e3:ea66 with SMTP id v7-20020adff687000000b0030ae5e3ea66mr4818781wrp.14.1685943872612;
        Sun, 04 Jun 2023 22:44:32 -0700 (PDT)
Received: from redhat.com ([2.55.41.2])
        by smtp.gmail.com with ESMTPSA id o4-20020a05600c378400b003f195d540d9sm13048625wmr.14.2023.06.04.22.44.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Jun 2023 22:44:31 -0700 (PDT)
Date: Mon, 5 Jun 2023 01:44:28 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc: Jakub Kicinski <kuba@kernel.org>,
	virtualization@lists.linux-foundation.org,
	Jason Wang <jasowang@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>, netdev@vger.kernel.org,
	bpf@vger.kernel.org
Subject: Re: [PATCH vhost v10 10/10] virtio_net: support dma premapped
Message-ID: <20230605014154-mutt-send-email-mst@kernel.org>
References: <20230602092206.50108-1-xuanzhuo@linux.alibaba.com>
 <20230602092206.50108-11-xuanzhuo@linux.alibaba.com>
 <20230602233152.4d9b9ba4@kernel.org>
 <1685931044.5893385-2-xuanzhuo@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1685931044.5893385-2-xuanzhuo@linux.alibaba.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 05, 2023 at 10:10:44AM +0800, Xuan Zhuo wrote:
> On Fri, 2 Jun 2023 23:31:52 -0700, Jakub Kicinski <kuba@kernel.org> wrote:
> > On Fri,  2 Jun 2023 17:22:06 +0800 Xuan Zhuo wrote:
> > >  drivers/net/virtio_net.c | 163 +++++++++++++++++++++++++++++++++------
> >
> > ack for this going via the vhost tree, FWIW, but you'll potentially
> > need to wait for the merge window to move forward with the actual
> > af xdp patches, in this case.
> 
> 
> My current plan is to let virtio support premapped dma first, and then implement
> virtio-net to support af-xdp zerocopy.
> 
> This will indeed involve two branches. But most of the implementations in this
> patch are virtio code, so I think it would be more appropriate to commit to
> vhost. Do you have any good ideas?
> 
> 
> Thanks.

Are you still making changes to net core? DMA core? If it's only
virtio-net then I can probably merge all of it - just a couple of
bugfixes there so far, it shouldn't cause complex conflicts.

-- 
MST


