Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19DEE16A847
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 15:25:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727681AbgBXOZk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 09:25:40 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:28534 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727483AbgBXOZk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 09:25:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582554339;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TB7sUf2pFHZ1gfff7bVBVaPbnW5iGaEMa9gLQVlWv7I=;
        b=fh2IOZwpzP18N2VCPWaI4qo6NbNhSfF41shJ2TXU0JLWmz0J1OpjmSGm7VXzdhJBMEHQGJ
        xcaMU41tyVto4IlpkTnxsiKwYkz9FZ5qx97LwMupUuSgY52CcHQeXwzXBldP8NBj5Frbhq
        rTuMrApYgALsycq/v6O2jKxwOBYQ5Gc=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-229-eh7mQlfUMjOakQQgtsTkYQ-1; Mon, 24 Feb 2020 09:25:37 -0500
X-MC-Unique: eh7mQlfUMjOakQQgtsTkYQ-1
Received: by mail-qk1-f198.google.com with SMTP id m25so10864969qka.4
        for <netdev@vger.kernel.org>; Mon, 24 Feb 2020 06:25:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TB7sUf2pFHZ1gfff7bVBVaPbnW5iGaEMa9gLQVlWv7I=;
        b=k2p1YIRETOcpVQg6JQypTBheZhXS/SoLRN9f9MDlxPJgERYwStRnMMhW23AWJca0ZQ
         v6lRvgZNBy5bpOBwJ8NEfSrPqn35Y8vytMNLBQ+fHW2SbPnmLQYyqi5/xX6L17hm1Y2W
         urm/R3I1O8FxYX6zVdqtxg0YJbI4wPAmoIE3IShnz8Hz3M3BAo6cHPJoun8tMTYKa6Lv
         znmrGqIhuPhidYcG/SmOAbXKHdZGAHNVQgbYl9jgTsR8GzAvOsHGlzYKZKdBiJHERFu9
         ZthpFeL8TUzUnQQ6JixBMiNCkym+9FlClZtBTtWu2vYb31g2Q8gm81fPi7FOvTqyXAOA
         gfXQ==
X-Gm-Message-State: APjAAAUt4FYPp1Lzg4QiJm94ATQPKx22fmXf9UDiuw8QiVBaA3sgoVMW
        9mVezSLJOyYy+AO4u2v7u+v6UCotw8Ie25AL+m3Nbdm7y2wcgcFlXCjazOUIxQCdOHJkC5y5yRG
        UxYoHL6uZOCju+EAG
X-Received: by 2002:ac8:7657:: with SMTP id i23mr48528800qtr.197.1582554337426;
        Mon, 24 Feb 2020 06:25:37 -0800 (PST)
X-Google-Smtp-Source: APXvYqznUlCcqXeerYYf+szsmuv/Ph5idwuFaPaAFKrIhkobzWbc5eRNhdpX5HexMXIGUCrH38q8gw==
X-Received: by 2002:ac8:7657:: with SMTP id i23mr48528784qtr.197.1582554337178;
        Mon, 24 Feb 2020 06:25:37 -0800 (PST)
Received: from redhat.com (bzq-79-178-2-214.red.bezeqint.net. [79.178.2.214])
        by smtp.gmail.com with ESMTPSA id g26sm5921357qkk.68.2020.02.24.06.25.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2020 06:25:36 -0800 (PST)
Date:   Mon, 24 Feb 2020 09:25:32 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     anton.ivanov@cambridgegreys.com
Cc:     netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        linux-um@lists.infradead.org, jasowang@redhat.com,
        eric.dumazet@gmail.com
Subject: Re: [PATCH v3] virtio: Work around frames incorrectly marked as gso
Message-ID: <20200224092526-mutt-send-email-mst@kernel.org>
References: <20200224132550.2083-1-anton.ivanov@cambridgegreys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200224132550.2083-1-anton.ivanov@cambridgegreys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 24, 2020 at 01:25:50PM +0000, anton.ivanov@cambridgegreys.com wrote:
> From: Anton Ivanov <anton.ivanov@cambridgegreys.com>
> 
> Some of the locally generated frames marked as GSO which
> arrive at virtio_net_hdr_from_skb() have no GSO_TYPE, no
> fragments (data_len = 0) and length significantly shorter
> than the MTU (752 in my experiments).
> 
> This is observed on raw sockets reading off vEth interfaces
> in all 4.x and 5.x kernels. The frames are reported as
> invalid, while they are in fact gso-less frames.
> 
> The easiest way to reproduce is to connect a User Mode
> Linux instance to the host using the vector raw transport
> and a vEth interface. Vector raw uses recvmmsg/sendmmsg
> with virtio headers on af_packet sockets. When running iperf
> between the UML and the host, UML regularly complains about
> EINVAL return from recvmmsg.
> 
> This patch marks the vnet header as non-GSO instead of
> reporting it as invalid.
> 
> Signed-off-by: Anton Ivanov <anton.ivanov@cambridgegreys.com>

Reviewed-by: Michael S. Tsirkin <mst@redhat.com>

> ---
>  include/linux/virtio_net.h | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/virtio_net.h b/include/linux/virtio_net.h
> index 0d1fe9297ac6..2c99c752cb20 100644
> --- a/include/linux/virtio_net.h
> +++ b/include/linux/virtio_net.h
> @@ -98,10 +98,11 @@ static inline int virtio_net_hdr_from_skb(const struct sk_buff *skb,
>  					  bool has_data_valid,
>  					  int vlan_hlen)
>  {
> +	struct skb_shared_info *sinfo = skb_shinfo(skb);
> +
>  	memset(hdr, 0, sizeof(*hdr));   /* no info leak */
>  
> -	if (skb_is_gso(skb)) {
> -		struct skb_shared_info *sinfo = skb_shinfo(skb);
> +	if (skb_is_gso(skb) && sinfo->gso_type) {
>  
>  		/* This is a hint as to how much should be linear. */
>  		hdr->hdr_len = __cpu_to_virtio16(little_endian,
> -- 
> 2.20.1

