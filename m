Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17FB01F1A14
	for <lists+netdev@lfdr.de>; Mon,  8 Jun 2020 15:30:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729792AbgFHNar (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 09:30:47 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:44560 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729621AbgFHNaq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jun 2020 09:30:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591623044;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gb88/02YmS9YtUx19YCEMGvgGVki3Ib3eUuUkCjJy+U=;
        b=VpWAxmgcP+M+Nw6ahhL8fej9ahlYNi5QeZHh9m7vE4RCEhSYbMlfhNQw3q2CdT2UPH2hzN
        ITGGIUktKDpwVbhHROmbAnnnhfNe7+RZM9jwP5hv+8t1Rb43bUpQp358GUSSSgm68d65Oc
        6Sozw1TONatPLSeHpEHAJLr1K0fPzJA=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-108-v8JpuxXUMnioK5LMV9qX9g-1; Mon, 08 Jun 2020 09:30:43 -0400
X-MC-Unique: v8JpuxXUMnioK5LMV9qX9g-1
Received: by mail-wr1-f72.google.com with SMTP id o1so7112178wrm.17
        for <netdev@vger.kernel.org>; Mon, 08 Jun 2020 06:30:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gb88/02YmS9YtUx19YCEMGvgGVki3Ib3eUuUkCjJy+U=;
        b=teEH2E/4fQ43TsygxLL/J3fYoWab8qcPqVA865paSLQQQcBW9jbZ4zmzjdV0v/ecuG
         k7HdQ3OI76RPIFSHILQ+NylBrIhJKHhX1EzJDZXQFmv+O3NiLetEjvmGoL1U63eSD5dA
         rBifrjQ+JyqfgcND5WXlpDRzK+jfD1lgJyWKZ6FJS1GsQJk4FP8MPA+COXET7nWgsMWf
         kMb0FDV0oCezpCzYNlpqcC8ZgBFRvDY8ravhmr2TaiMHXXi7WkYaKSlb4b039kk28rWD
         hPVS2toXz7/di2D4eQvviXFT+rqiwGr2hiWDrNzEIn8BYwjD/Lb83VaY0N1XcxQrTzqj
         dwxQ==
X-Gm-Message-State: AOAM532w/PChWDFpEaNxWtxm5MxsWXT8IoE65Nhde64jOl58IoCoKLJO
        VxHoigNqSpGpcxLkjVOB9AHuL6EnlIJkY2V7QQFcn2/L1cYue62dNEs5lXoqSXu+A+tpZ2oVKtm
        cgXuWB4MYv9iryZ4B
X-Received: by 2002:adf:ec03:: with SMTP id x3mr23586217wrn.297.1591623041921;
        Mon, 08 Jun 2020 06:30:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz62tJA6E64oEIZnfe39XFv8r0W7nilgUKIntVO4j0UrGBnVrvqs8Lk+4LFru+2gi/RHZ/CMw==
X-Received: by 2002:adf:ec03:: with SMTP id x3mr23586189wrn.297.1591623041702;
        Mon, 08 Jun 2020 06:30:41 -0700 (PDT)
Received: from redhat.com (bzq-109-64-41-91.red.bezeqint.net. [109.64.41.91])
        by smtp.gmail.com with ESMTPSA id a81sm24080582wmd.25.2020.06.08.06.30.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2020 06:30:41 -0700 (PDT)
Date:   Mon, 8 Jun 2020 09:30:38 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>, eperezma@redhat.com,
        Stefan Hajnoczi <stefanha@redhat.com>
Subject: Re: [PATCH RFC v5 12/13] vhost/vsock: switch to the buf API
Message-ID: <20200608092953-mutt-send-email-mst@kernel.org>
References: <20200607141057.704085-1-mst@redhat.com>
 <20200607141057.704085-13-mst@redhat.com>
 <20200608101746.xnxtwwygolsk7yol@steredhat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200608101746.xnxtwwygolsk7yol@steredhat>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 08, 2020 at 12:17:46PM +0200, Stefano Garzarella wrote:
> On Sun, Jun 07, 2020 at 10:11:49AM -0400, Michael S. Tsirkin wrote:
> > A straight-forward conversion.
> > 
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > ---
> >  drivers/vhost/vsock.c | 30 ++++++++++++++++++------------
> >  1 file changed, 18 insertions(+), 12 deletions(-)
> 
> The changes for vsock part LGTM:
> 
> Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
> 
> 
> I also did some tests with vhost-vsock (tools/testing/vsock/vsock_test
> and iperf-vsock), so for vsock:
> 
> Tested-by: Stefano Garzarella <sgarzare@redhat.com>
> 
> Thanks,
> Stefano

Re-testing v6 would be very much appreciated.

> > 
> > diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
> > index a483cec31d5c..61c6d3dd2ae3 100644
> > --- a/drivers/vhost/vsock.c
> > +++ b/drivers/vhost/vsock.c
> > @@ -103,7 +103,8 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
> >  		unsigned out, in;
> >  		size_t nbytes;
> >  		size_t iov_len, payload_len;
> > -		int head;
> > +		struct vhost_buf buf;
> > +		int ret;
> >  
> >  		spin_lock_bh(&vsock->send_pkt_list_lock);
> >  		if (list_empty(&vsock->send_pkt_list)) {
> > @@ -117,16 +118,17 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
> >  		list_del_init(&pkt->list);
> >  		spin_unlock_bh(&vsock->send_pkt_list_lock);
> >  
> > -		head = vhost_get_vq_desc(vq, vq->iov, ARRAY_SIZE(vq->iov),
> > -					 &out, &in, NULL, NULL);
> > -		if (head < 0) {
> > +		ret = vhost_get_avail_buf(vq, &buf,
> > +					  vq->iov, ARRAY_SIZE(vq->iov),
> > +					  &out, &in, NULL, NULL);
> > +		if (ret < 0) {
> >  			spin_lock_bh(&vsock->send_pkt_list_lock);
> >  			list_add(&pkt->list, &vsock->send_pkt_list);
> >  			spin_unlock_bh(&vsock->send_pkt_list_lock);
> >  			break;
> >  		}
> >  
> > -		if (head == vq->num) {
> > +		if (!ret) {
> >  			spin_lock_bh(&vsock->send_pkt_list_lock);
> >  			list_add(&pkt->list, &vsock->send_pkt_list);
> >  			spin_unlock_bh(&vsock->send_pkt_list_lock);
> > @@ -186,7 +188,8 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
> >  		 */
> >  		virtio_transport_deliver_tap_pkt(pkt);
> >  
> > -		vhost_add_used(vq, head, sizeof(pkt->hdr) + payload_len);
> > +		buf.in_len = sizeof(pkt->hdr) + payload_len;
> > +		vhost_put_used_buf(vq, &buf);
> >  		added = true;
> >  
> >  		pkt->off += payload_len;
> > @@ -440,7 +443,8 @@ static void vhost_vsock_handle_tx_kick(struct vhost_work *work)
> >  	struct vhost_vsock *vsock = container_of(vq->dev, struct vhost_vsock,
> >  						 dev);
> >  	struct virtio_vsock_pkt *pkt;
> > -	int head, pkts = 0, total_len = 0;
> > +	int ret, pkts = 0, total_len = 0;
> > +	struct vhost_buf buf;
> >  	unsigned int out, in;
> >  	bool added = false;
> >  
> > @@ -461,12 +465,13 @@ static void vhost_vsock_handle_tx_kick(struct vhost_work *work)
> >  			goto no_more_replies;
> >  		}
> >  
> > -		head = vhost_get_vq_desc(vq, vq->iov, ARRAY_SIZE(vq->iov),
> > -					 &out, &in, NULL, NULL);
> > -		if (head < 0)
> > +		ret = vhost_get_avail_buf(vq, &buf,
> > +					  vq->iov, ARRAY_SIZE(vq->iov),
> > +					  &out, &in, NULL, NULL);
> > +		if (ret < 0)
> >  			break;
> >  
> > -		if (head == vq->num) {
> > +		if (!ret) {
> >  			if (unlikely(vhost_enable_notify(&vsock->dev, vq))) {
> >  				vhost_disable_notify(&vsock->dev, vq);
> >  				continue;
> > @@ -494,7 +499,8 @@ static void vhost_vsock_handle_tx_kick(struct vhost_work *work)
> >  			virtio_transport_free_pkt(pkt);
> >  
> >  		len += sizeof(pkt->hdr);
> > -		vhost_add_used(vq, head, len);
> > +		buf.in_len = len;
> > +		vhost_put_used_buf(vq, &buf);
> >  		total_len += len;
> >  		added = true;
> >  	} while(likely(!vhost_exceeds_weight(vq, ++pkts, total_len)));
> > -- 
> > MST
> > 

