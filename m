Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8652B1CCD4
	for <lists+netdev@lfdr.de>; Tue, 14 May 2019 18:21:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726279AbfENQVB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 May 2019 12:21:01 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:45470 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726084AbfENQVB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 May 2019 12:21:01 -0400
Received: by mail-wr1-f65.google.com with SMTP id b18so9934721wrq.12
        for <netdev@vger.kernel.org>; Tue, 14 May 2019 09:21:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=BOCFSrhgfdaeCsPqx/9Z23ucW5WFX+NmToiNV2PrBeE=;
        b=MgAq25z5JUla64JBPuMe8Kfv4XTa3Nbyhv1AvXoiBc+5+ZMdcRHkUfIexM9JRTEeZn
         QpQ/Kqb364JdVkJY79ZSPHGmujbQGnOFe0P0klexQIZTDeVo2vp9Qg0QbtWBocxNcFW2
         Vx2CVgHsCioWrPhHfnKyzj7W15X7/WBH1RQ24Neko/9QwyNXwEMvTAZVobnh55hh9idw
         NE+RSvb2z5Mq8YtLqlDRhw+Ip6SjG402PwfgjCPR9OBVcPm1wt4E/3uO8e/KeTx2rFk5
         Atm/nZy7WTu9Z5nq8eQNKCD55VclKwSwKO+XJp6FhoEyo3VW+PoytUpcbrVoQUkX/cQi
         DiMg==
X-Gm-Message-State: APjAAAX5i+opFzy3rP7qRs9CJR16dCM5USf9RU4LzLDLacNBgzVkxFHX
        AUcdq+4qBg9PJJ6PnmTn1EWlRA==
X-Google-Smtp-Source: APXvYqyscd4jQz6/42rGahRh0erb6xOt/MMNshG64dkL9Ee+1e2OY4Rd80gvnBFmXC+AkJhQaflnLg==
X-Received: by 2002:adf:afcd:: with SMTP id y13mr21348543wrd.270.1557850859484;
        Tue, 14 May 2019 09:20:59 -0700 (PDT)
Received: from steredhat (host151-251-static.12-87-b.business.telecomitalia.it. [87.12.251.151])
        by smtp.gmail.com with ESMTPSA id g3sm4407851wmf.9.2019.05.14.09.20.58
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 14 May 2019 09:20:58 -0700 (PDT)
Date:   Tue, 14 May 2019 18:20:56 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Stefan Hajnoczi <stefanha@redhat.com>
Subject: Re: [PATCH v2 7/8] vsock/virtio: increase RX buffer size to 64 KiB
Message-ID: <20190514162056.5aotcuzsi6e6wya7@steredhat>
References: <20190510125843.95587-1-sgarzare@redhat.com>
 <20190510125843.95587-8-sgarzare@redhat.com>
 <bf0416f1-0e69-722d-75ce-3d101e6d7d71@redhat.com>
 <20190513175138.4yycad2xi65komw6@steredhat>
 <fd934a4c-f7d2-8a04-ed93-a3b690ed0d79@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fd934a4c-f7d2-8a04-ed93-a3b690ed0d79@redhat.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 14, 2019 at 11:38:05AM +0800, Jason Wang wrote:
> 
> On 2019/5/14 上午1:51, Stefano Garzarella wrote:
> > On Mon, May 13, 2019 at 06:01:52PM +0800, Jason Wang wrote:
> > > On 2019/5/10 下午8:58, Stefano Garzarella wrote:
> > > > In order to increase host -> guest throughput with large packets,
> > > > we can use 64 KiB RX buffers.
> > > > 
> > > > Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> > > > ---
> > > >    include/linux/virtio_vsock.h | 2 +-
> > > >    1 file changed, 1 insertion(+), 1 deletion(-)
> > > > 
> > > > diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
> > > > index 84b72026d327..5a9d25be72df 100644
> > > > --- a/include/linux/virtio_vsock.h
> > > > +++ b/include/linux/virtio_vsock.h
> > > > @@ -10,7 +10,7 @@
> > > >    #define VIRTIO_VSOCK_DEFAULT_MIN_BUF_SIZE	128
> > > >    #define VIRTIO_VSOCK_DEFAULT_BUF_SIZE		(1024 * 256)
> > > >    #define VIRTIO_VSOCK_DEFAULT_MAX_BUF_SIZE	(1024 * 256)
> > > > -#define VIRTIO_VSOCK_DEFAULT_RX_BUF_SIZE	(1024 * 4)
> > > > +#define VIRTIO_VSOCK_DEFAULT_RX_BUF_SIZE	(1024 * 64)
> > > >    #define VIRTIO_VSOCK_MAX_BUF_SIZE		0xFFFFFFFFUL
> > > >    #define VIRTIO_VSOCK_MAX_PKT_BUF_SIZE		(1024 * 64)
> > > 
> > > We probably don't want such high order allocation. It's better to switch to
> > > use order 0 pages in this case. See add_recvbuf_big() for virtio-net. If we
> > > get datapath unified, we will get more stuffs set.
> > IIUC, you are suggesting to allocate only pages and put them in a
> > scatterlist, then add them to the virtqueue.
> > 
> > Is it correct?
> 
> 
> Yes since you are using:
> 
>                 pkt->buf = kmalloc(buf_len, GFP_KERNEL);
>                 if (!pkt->buf) {
>                         virtio_transport_free_pkt(pkt);
>                         break;
>                 }
> 
> This is likely to fail when the memory is fragmented which is kind of
> fragile.
> 
> 

Thanks for pointing that out.

> > 
> > The issue that I have here, is that the virtio-vsock guest driver, see
> > virtio_vsock_rx_fill(), allocates a struct virtio_vsock_pkt that
> > contains the room for the header, then allocates the buffer for the payload.
> > At this point it fills the scatterlist with the &virtio_vsock_pkt.hdr and the
> > buffer for the payload.
> 
> 
> This part should be fine since what is needed is just adding more pages to
> sg[] and call virtuqeueu_add_sg().
> 
> 

Yes, I agree.

> > 
> > Changing this will require several modifications, and if we get datapath
> > unified, I'm not sure it's worth it.
> > Of course, if we leave the datapaths separated, I'd like to do that later.
> > 
> > What do you think?
> 
> 
> For the driver it self, it should not be hard. But I think you mean the
> issue of e.g virtio_vsock_pkt itself which doesn't support sg. For short
> time, maybe we can use kvec instead.

I'll try to use kvec in the virtio_vsock_pkt.

Since this struct is shared also with the host driver (vhost-vsock),
I hope the changes could be limited, otherwise we can remove the last 2
patches of the series for now, leaving the RX buffer size to 4KB.

Thanks,
Stefano
