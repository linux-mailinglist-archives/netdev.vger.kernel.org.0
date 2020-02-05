Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3675C152606
	for <lists+netdev@lfdr.de>; Wed,  5 Feb 2020 06:34:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726302AbgBEFeD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Feb 2020 00:34:03 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:46586 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725875AbgBEFeD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Feb 2020 00:34:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580880842;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UpoA79PTiO2rp87/4RjJ0Oaw1CL7CM0sYNu+diR+ohU=;
        b=g6qCyz0sGTDSfWDlqn1tcafxWSNTrYjr8duwJAvjkl4UiZzf9+qsVhntYUYHtElEavLDty
        0xmqencx0UBit5uWnps2XVyUvCpO7je4r3QxFGLoajc3gMMkW+BZZZbUsQeMrkcH0EpwnX
        ayiSzmVUb0HZVjwXyMGJJ71iSUWNSeY=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-412-fM3p0apMPxWu8c2qhc81IQ-1; Wed, 05 Feb 2020 00:33:58 -0500
X-MC-Unique: fM3p0apMPxWu8c2qhc81IQ-1
Received: by mail-qv1-f69.google.com with SMTP id d7so804779qvq.12
        for <netdev@vger.kernel.org>; Tue, 04 Feb 2020 21:33:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UpoA79PTiO2rp87/4RjJ0Oaw1CL7CM0sYNu+diR+ohU=;
        b=i7pC0qnAbUIEhpqIaz0AIIwyfhiz6H5fs3EEr4gmR2UA3uSX4oBLiWVPkcGpV4kTcL
         U91W82X7Lunz3bCjOyBxZGcurDQSQi88cX7Bw05n73YbgfNOIS5bg1bpkVOZ6I0RxRe+
         7KwZxKkOPXx7g0qc92AXbAo8uPGEHD2GTYGjpjMaqGDgb4p8G21RkY3CGksswWGm3KX3
         f+o1lTRsVecf9HtMK6/8xCMJdkGMmrjUvX7f+jhxKe09BRmH5qA/uZYE9cVj29Tr4Qtd
         j6r8CttQN2zB/tpbXEDL1RlvMjo9f9bW1IT4gBNJMSMadWMcIIwTjychL7VcdCgRo5Yd
         LHTw==
X-Gm-Message-State: APjAAAUXgsjEzr13oAhbafCl264PP0XISnIqnpM5jrg336f5tEtKTQz8
        T/Ja/G/GGfFOes2Tucf0Y6wZYd2eSeFIFZpY5MxNkYUOM41SS1yT0eIn8WyhQYOwHNG4lHTJyF6
        QsvEMi9d4wrMEg8FP
X-Received: by 2002:ae9:c10b:: with SMTP id z11mr31554693qki.157.1580880838437;
        Tue, 04 Feb 2020 21:33:58 -0800 (PST)
X-Google-Smtp-Source: APXvYqyPyGS4sGVa29gfwEv/nW9Jz92sfCSHCicovqzsWK08mnYnXlDIxmWkXBF3U8uJQk1Lyqq61A==
X-Received: by 2002:ae9:c10b:: with SMTP id z11mr31554675qki.157.1580880838213;
        Tue, 04 Feb 2020 21:33:58 -0800 (PST)
Received: from redhat.com (bzq-79-176-41-183.red.bezeqint.net. [79.176.41.183])
        by smtp.gmail.com with ESMTPSA id r3sm3624696qtc.85.2020.02.04.21.33.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Feb 2020 21:33:57 -0800 (PST)
Date:   Wed, 5 Feb 2020 00:33:52 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Yuya Kusakabe <yuya.kusakabe@gmail.com>
Cc:     jasowang@redhat.com, ast@kernel.org, daniel@iogearbox.net,
        davem@davemloft.net, hawk@kernel.org, john.fastabend@gmail.com,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, kuba@kernel.org,
        andriin@fb.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next v4] virtio_net: add XDP meta data support
Message-ID: <20200205003236-mutt-send-email-mst@kernel.org>
References: <8da1b560-3128-b885-b453-13de5c7431fb@redhat.com>
 <20200204071655.94474-1-yuya.kusakabe@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200204071655.94474-1-yuya.kusakabe@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 04, 2020 at 04:16:55PM +0900, Yuya Kusakabe wrote:
> @@ -852,8 +868,9 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
>  			 * adjustments. Note other cases do not build an
>  			 * skb and avoid using offset
>  			 */
> -			offset = xdp.data -
> -					page_address(xdp_page) - vi->hdr_len;
> +			metasize = xdp.data - xdp.data_meta;
> +			offset = xdp.data - page_address(xdp_page) -
> +				 vi->hdr_len - metasize;
>  
>  			/* recalculate len if xdp.data or xdp.data_end were
>  			 * adjusted

Tricky to get one's head around.
Can you pls update the comment above to document the new math?

-- 
MST

