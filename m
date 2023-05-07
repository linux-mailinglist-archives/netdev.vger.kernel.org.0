Return-Path: <netdev+bounces-752-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CF6C46F98AE
	for <lists+netdev@lfdr.de>; Sun,  7 May 2023 15:38:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B24DF1C21465
	for <lists+netdev@lfdr.de>; Sun,  7 May 2023 13:38:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 111E83D8F;
	Sun,  7 May 2023 13:38:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04B7A2564
	for <netdev@vger.kernel.org>; Sun,  7 May 2023 13:38:21 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A107A1248F
	for <netdev@vger.kernel.org>; Sun,  7 May 2023 06:38:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683466699;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uS0RstiP8T7ZH+Gobo8YpS9JLxcIWNZn7s+bIcTHKj0=;
	b=O5lQRqAlcn/lOYEZD2eOuqDHwbDrXDt3dGqv6bsAepzARx4js6yULS8O1z8JhGG5VMJl/h
	sdz8z8Yo7FjoQxiQKC8VwJ5cms6KMPvbKFAecqmpt41SoQnDqdqoGWTPtegDWnrsbnoAbU
	SS+TsdfCInwkUAXGN0zw/Gb36EgZ4y0=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-657-h1sbClvnMj2if611lhcyKQ-1; Sun, 07 May 2023 09:38:18 -0400
X-MC-Unique: h1sbClvnMj2if611lhcyKQ-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3077fa61967so1375236f8f.1
        for <netdev@vger.kernel.org>; Sun, 07 May 2023 06:38:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683466697; x=1686058697;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uS0RstiP8T7ZH+Gobo8YpS9JLxcIWNZn7s+bIcTHKj0=;
        b=VM8aVxK4fWKqIkHy3zjeYWmHjrWvn5KniukgZ4wd8aggSMXk+UncuhGEl++fQbwoYY
         NEvE5N/RLv/z1U9EdRvk1alhJNuiV+HUNh7ALSqQ4K4600hufavS67SK8NRBT1rpd4/t
         jHK5uz6PSp9qVhs/oKwHUzutCWMxI7iUgaqeILzweNkuQoqkQVf+J894u/Ur8lnySALb
         2V9WVkblO/JAbL7GDr7aVzOsB+wZcFuKAFFGa7B+fZpfYZDT50JczFU39mRRYFR5YehU
         deuysQg3WWU+5ax5+mrRLugbtPM56Ka7FlQJFgOiAa3vscnxZ+P1TxoymuP/JgseVsMC
         onuw==
X-Gm-Message-State: AC+VfDwkuxNk3HpC65a3bmw72TPkgT5hAc5ypmSWzParSsFb7c8SE9Ae
	DoOZAgu1Tflhr9SIfJnH+Sfl4NzmAHtG8EfwkZ46zlkqGew86bxx3YspSZ9JhsRRUb73c/233dG
	X/QcH0w5CmnXtVIJc
X-Received: by 2002:adf:e3cd:0:b0:306:2bff:aad8 with SMTP id k13-20020adfe3cd000000b003062bffaad8mr5217170wrm.35.1683466697639;
        Sun, 07 May 2023 06:38:17 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7raV+1H23nZQQyJsfP3v5WDmwROkIJoLbvrcVTI1UBSNcA2EkWNlsLTJqPAmKBYRZa7JSNpg==
X-Received: by 2002:adf:e3cd:0:b0:306:2bff:aad8 with SMTP id k13-20020adfe3cd000000b003062bffaad8mr5217160wrm.35.1683466697361;
        Sun, 07 May 2023 06:38:17 -0700 (PDT)
Received: from redhat.com ([2.52.158.28])
        by smtp.gmail.com with ESMTPSA id l11-20020adfe58b000000b002f22c44e974sm8247506wrm.102.2023.05.07.06.38.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 May 2023 06:38:16 -0700 (PDT)
Date: Sun, 7 May 2023 09:38:13 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Hao Chen <chenh@yusur.tech>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	huangml@yusur.tech, zy@yusur.tech, Jason Wang <jasowang@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	"open list:VIRTIO CORE AND NET DRIVERS" <virtualization@lists.linux-foundation.org>,
	"open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] virtio_net: set default mtu to 1500 when 'Device maximum
 MTU' bigger than 1500
Message-ID: <20230507093502-mutt-send-email-mst@kernel.org>
References: <20230506021529.396812-1-chenh@yusur.tech>
 <1683341417.0965195-4-xuanzhuo@linux.alibaba.com>
 <07b6b325-9a15-222f-e618-d149b57cbac2@yusur.tech>
 <49455AA8-0606-447E-B455-F905EA184E42@infradead.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49455AA8-0606-447E-B455-F905EA184E42@infradead.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sun, May 07, 2023 at 10:31:34AM +0100, David Woodhouse wrote:
> 
> 
> On 6 May 2023 09:56:35 BST, Hao Chen <chenh@yusur.tech> wrote:
> >In the current code, if the maximum MTU supported by the virtio net hardware is 9000, the default MTU of the virtio net driver will also be set to 9000. When sending packets through "ping -s 5000", if the peer router does not support negotiating a path MTU through ICMP packets, the packets will be discarded.
> 
> That router is just plain broken, and it's going to break all kinds of traffic. Hacking the virtio-net MTU is only a partial workaround.
> 
> Surely the correct fix here is to apply percussive education to whatever idiot thought it was OK to block ICMP. Not to hack the default MTU of one device to the lowest common denominator. 

Yea I don't understand what does path MTU have to do with it.
MTU has to be set the same for all endpoints on LAN, that's
a fundamental assumption that ethernet makes. Going outside LAN
all best are off.


-- 
MST


