Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C2DF1F1D3A
	for <lists+netdev@lfdr.de>; Mon,  8 Jun 2020 18:26:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730458AbgFHQ0U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 12:26:20 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:57802 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730442AbgFHQ0T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jun 2020 12:26:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591633576;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PfesJHBEui5hetw3RxW9+nGTdupwdIhkqQYIwcx4mZo=;
        b=htDj+N5w5DH08wTF/tSGf2Mh8cxX+oINpFnzhTJBtSmzMYK9YHd8DqZU//94g1RYyauyIg
        O8T+rHELvDO0en/TjbJvWlKMbRN5KNagv+KzOkyd/DwYYjyeeaiLDXzGVI4z97Ioi0NowI
        LFTPWhVQPdleD5Ctrt1k6jwyMen68TU=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-55-g5EFrPncO4WLaZbgOvguGw-1; Mon, 08 Jun 2020 12:26:13 -0400
X-MC-Unique: g5EFrPncO4WLaZbgOvguGw-1
Received: by mail-wr1-f69.google.com with SMTP id j16so7320267wre.22
        for <netdev@vger.kernel.org>; Mon, 08 Jun 2020 09:26:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PfesJHBEui5hetw3RxW9+nGTdupwdIhkqQYIwcx4mZo=;
        b=XTEG6hk6yPOI14AckOrNR2ujRip+4ZdqDqciRgWuUWYg7roS0XxK519SZa48ivXOW8
         4iLWQCX3JBZBUlyvl1OXVaOZSzwRuYDMCR0BkOvEVxFr2CWss4jfDEvi7e8LkK6fbopf
         f/FUsVJ5HcE6gUxmiwIFPUwFE/tXWKzUGcLe4EOaCI8ChC1mIL60vBKfRKPzWmz1jdQU
         7akdhkDY1fUzCq8enGCIQBBTS6JnEr8zpqeyLuyXfQVQDceEP8tN5tx1ag7lfNJUPusw
         isHUa56XFfxIsjoqt9qfbRgbvyTfiIjuGzPYUB6ZR3YYKi1NH754A/GKmf+UtNBPjGmu
         dl9Q==
X-Gm-Message-State: AOAM5335ql8HyFTY8nZ66jvfWeW6vDQ8bObvc5+KBOZTcqtPt8qpO8bL
        rskXHcEIz0fcddhd9kwSygyq5Ep6nBHGBhnqEPpkg2c0VpmL/EQWaAGGXGZbk34S1r0+qxoGddd
        9TSQt6QlNFOC7xhXy
X-Received: by 2002:a1c:3c08:: with SMTP id j8mr151286wma.158.1591633571882;
        Mon, 08 Jun 2020 09:26:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzMODrjwl3uJvjfo1A6dRDqHo2iDzOMSyj2EtMN5BDt+YBK8zUVruK6nz7/OV+XRdPj9GQbLA==
X-Received: by 2002:a1c:3c08:: with SMTP id j8mr151258wma.158.1591633571606;
        Mon, 08 Jun 2020 09:26:11 -0700 (PDT)
Received: from steredhat ([79.49.207.108])
        by smtp.gmail.com with ESMTPSA id k21sm270313wrd.24.2020.06.08.09.26.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2020 09:26:10 -0700 (PDT)
Date:   Mon, 8 Jun 2020 18:26:08 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>, eperezma@redhat.com,
        Stefan Hajnoczi <stefanha@redhat.com>
Subject: Re: [PATCH RFC v5 12/13] vhost/vsock: switch to the buf API
Message-ID: <20200608162608.gk2fpebujpvmkzpc@steredhat>
References: <20200607141057.704085-1-mst@redhat.com>
 <20200607141057.704085-13-mst@redhat.com>
 <20200608101746.xnxtwwygolsk7yol@steredhat>
 <20200608092953-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200608092953-mutt-send-email-mst@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 08, 2020 at 09:30:38AM -0400, Michael S. Tsirkin wrote:
> On Mon, Jun 08, 2020 at 12:17:46PM +0200, Stefano Garzarella wrote:
> > On Sun, Jun 07, 2020 at 10:11:49AM -0400, Michael S. Tsirkin wrote:
> > > A straight-forward conversion.
> > > 
> > > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > > ---
> > >  drivers/vhost/vsock.c | 30 ++++++++++++++++++------------
> > >  1 file changed, 18 insertions(+), 12 deletions(-)
> > 
> > The changes for vsock part LGTM:
> > 
> > Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
> > 
> > 
> > I also did some tests with vhost-vsock (tools/testing/vsock/vsock_test
> > and iperf-vsock), so for vsock:
> > 
> > Tested-by: Stefano Garzarella <sgarzare@redhat.com>
> > 
> > Thanks,
> > Stefano
> 
> Re-testing v6 would be very much appreciated.

Sure, I'm building v6 now and I'll send you a feedback :-)

Stefano

> 
> > > 
> > > diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
> > > index a483cec31d5c..61c6d3dd2ae3 100644
> > > --- a/drivers/vhost/vsock.c
> > > +++ b/drivers/vhost/vsock.c
> > > @@ -103,7 +103,8 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
> > >  		unsigned out, in;
> > >  		size_t nbytes;
> > >  		size_t iov_len, payload_len;
> > > -		int head;
> > > +		struct vhost_buf buf;
> > > +		int ret;
> > >  
> > >  		spin_lock_bh(&vsock->send_pkt_list_lock);
> > >  		if (list_empty(&vsock->send_pkt_list)) {
> > > @@ -117,16 +118,17 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
> > >  		list_del_init(&pkt->list);
> > >  		spin_unlock_bh(&vsock->send_pkt_list_lock);
> > >  
> > > -		head = vhost_get_vq_desc(vq, vq->iov, ARRAY_SIZE(vq->iov),
> > > -					 &out, &in, NULL, NULL);
> > > -		if (head < 0) {
> > > +		ret = vhost_get_avail_buf(vq, &buf,
> > > +					  vq->iov, ARRAY_SIZE(vq->iov),
> > > +					  &out, &in, NULL, NULL);
> > > +		if (ret < 0) {
> > >  			spin_lock_bh(&vsock->send_pkt_list_lock);
> > >  			list_add(&pkt->list, &vsock->send_pkt_list);
> > >  			spin_unlock_bh(&vsock->send_pkt_list_lock);
> > >  			break;
> > >  		}
> > >  
> > > -		if (head == vq->num) {
> > > +		if (!ret) {
> > >  			spin_lock_bh(&vsock->send_pkt_list_lock);
> > >  			list_add(&pkt->list, &vsock->send_pkt_list);
> > >  			spin_unlock_bh(&vsock->send_pkt_list_lock);
> > > @@ -186,7 +188,8 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
> > >  		 */
> > >  		virtio_transport_deliver_tap_pkt(pkt);
> > >  
> > > -		vhost_add_used(vq, head, sizeof(pkt->hdr) + payload_len);
> > > +		buf.in_len = sizeof(pkt->hdr) + payload_len;
> > > +		vhost_put_used_buf(vq, &buf);
> > >  		added = true;
> > >  
> > >  		pkt->off += payload_len;
> > > @@ -440,7 +443,8 @@ static void vhost_vsock_handle_tx_kick(struct vhost_work *work)
> > >  	struct vhost_vsock *vsock = container_of(vq->dev, struct vhost_vsock,
> > >  						 dev);
> > >  	struct virtio_vsock_pkt *pkt;
> > > -	int head, pkts = 0, total_len = 0;
> > > +	int ret, pkts = 0, total_len = 0;
> > > +	struct vhost_buf buf;
> > >  	unsigned int out, in;
> > >  	bool added = false;
> > >  
> > > @@ -461,12 +465,13 @@ static void vhost_vsock_handle_tx_kick(struct vhost_work *work)
> > >  			goto no_more_replies;
> > >  		}
> > >  
> > > -		head = vhost_get_vq_desc(vq, vq->iov, ARRAY_SIZE(vq->iov),
> > > -					 &out, &in, NULL, NULL);
> > > -		if (head < 0)
> > > +		ret = vhost_get_avail_buf(vq, &buf,
> > > +					  vq->iov, ARRAY_SIZE(vq->iov),
> > > +					  &out, &in, NULL, NULL);
> > > +		if (ret < 0)
> > >  			break;
> > >  
> > > -		if (head == vq->num) {
> > > +		if (!ret) {
> > >  			if (unlikely(vhost_enable_notify(&vsock->dev, vq))) {
> > >  				vhost_disable_notify(&vsock->dev, vq);
> > >  				continue;
> > > @@ -494,7 +499,8 @@ static void vhost_vsock_handle_tx_kick(struct vhost_work *work)
> > >  			virtio_transport_free_pkt(pkt);
> > >  
> > >  		len += sizeof(pkt->hdr);
> > > -		vhost_add_used(vq, head, len);
> > > +		buf.in_len = len;
> > > +		vhost_put_used_buf(vq, &buf);
> > >  		total_len += len;
> > >  		added = true;
> > >  	} while(likely(!vhost_exceeds_weight(vq, ++pkts, total_len)));
> > > -- 
> > > MST
> > > 
> 

