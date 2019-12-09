Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B504D116B87
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 11:54:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727458AbfLIKyv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 05:54:51 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:55482 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727347AbfLIKyu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 05:54:50 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.3)
        (envelope-from <johannes@sipsolutions.net>)
        id 1ieGgi-00FN4j-L6; Mon, 09 Dec 2019 11:54:48 +0100
Message-ID: <db33800253f071a1cfbb91f413af59e73faa6775.camel@sipsolutions.net>
Subject: Re: [PATCH] virtio: Work around frames incorrectly marked as gso
From:   Johannes Berg <johannes@sipsolutions.net>
To:     anton.ivanov@cambridgegreys.com, netdev@vger.kernel.org
Cc:     jasowang@redhat.com, virtualization@lists.linux-foundation.org,
        linux-um@lists.infradead.org, mst@redhat.com
Date:   Mon, 09 Dec 2019 11:54:46 +0100
In-Reply-To: <20191209104824.17059-1-anton.ivanov@cambridgegreys.com>
References: <20191209104824.17059-1-anton.ivanov@cambridgegreys.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.2 (3.34.2-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


>  		else if (sinfo->gso_type & SKB_GSO_TCPV6)
>  			hdr->gso_type = VIRTIO_NET_HDR_GSO_TCPV6;
> -		else
> -			return -EINVAL;
> +		else {
> +			if (skb->data_len == 0)
> +				hdr->gso_type = VIRTIO_NET_HDR_GSO_NONE;


maybe use "else if" like in the before? yes, it's a different type of
condition, but braces look a bit unnatural here to me at least

johannes


