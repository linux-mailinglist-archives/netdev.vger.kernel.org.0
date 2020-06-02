Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAD561EB4E6
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 07:08:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725927AbgFBFIM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 01:08:12 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:23146 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725781AbgFBFIM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 01:08:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591074490;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=i21+6+jn+AssAfqfuTEOtmF/3IbU/JSkgC0yQOaoU/8=;
        b=C8c+sS+ra3NNZEBw0tdIPwppA59bo6IpJVzaYZUcw6paD8fCl2XZYIjFCgOF/hFRvH6VzX
        NJZFQpqWRVtFIgk04tkJYlMGQNbyWwJ9UpILvAFIXBC/DhB2N0jNGHuvs0yEjvaJ/aFaCX
        +y3Oh9NLDAc/pnsc+XjDRNkneyReg34=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-56-LLJ8snYyNsiHz9eNhHafcg-1; Tue, 02 Jun 2020 01:08:08 -0400
X-MC-Unique: LLJ8snYyNsiHz9eNhHafcg-1
Received: by mail-wm1-f70.google.com with SMTP id s15so472942wmc.8
        for <netdev@vger.kernel.org>; Mon, 01 Jun 2020 22:08:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=i21+6+jn+AssAfqfuTEOtmF/3IbU/JSkgC0yQOaoU/8=;
        b=bubsXrNPiS+aIw34aNXXHcZZc+vOYyCOkgtcwLH0Hrg9rPfOqm7aCXBoo0G1h7LIRv
         KE22DU6n5OLXcWfdM/lmSvXhJVl++v6T+ZPyCgK3S+SI61XXFg/0q8KELm+oJ9dNrp2J
         lDpYB2SS4Y9tZKfhD87b1K/ZvI/znpfAJKTkfHrx1RR5GEeRIDnp9YvH7ZDqHAfPy3wE
         6OqXJ0+isUz1Cvf1I3/n7CzHf+2VjQuOpkYmzeejJ+jUEa/YlhaSr1Ur74b8OfaJ4Owb
         0jf/1viULE7vlvY5d+mt38exStoTQcAJbLPziKAqtebCJB1a6+C5EzwWfx8Lgci9QCrw
         vF7g==
X-Gm-Message-State: AOAM533IySgAfMAqL1wt9yHY8KtqjrBE0rCRqapGZ9NDZdlE1eFnBuVI
        Bap/nF5pFXTym6rOtg+PwnojAHOWVZ86upT7WyFqR8vIXttjKpwcBiG4gFXi0S1M4SbPetyse1d
        Shkx+Jed0/Wj+e1xQ
X-Received: by 2002:a5d:4c81:: with SMTP id z1mr26712881wrs.371.1591074487434;
        Mon, 01 Jun 2020 22:08:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz7ZFXMW684yAQznwucY1IA0VuesC1zA8zze+z7mJFUahZ6qoJQid59fnWEYmNevYhEMFGybw==
X-Received: by 2002:a5d:4c81:: with SMTP id z1mr26712868wrs.371.1591074487279;
        Mon, 01 Jun 2020 22:08:07 -0700 (PDT)
Received: from redhat.com (bzq-109-64-41-91.red.bezeqint.net. [109.64.41.91])
        by smtp.gmail.com with ESMTPSA id a126sm1761521wme.28.2020.06.01.22.08.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2020 22:08:06 -0700 (PDT)
Date:   Tue, 2 Jun 2020 01:08:03 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        rob.miller@broadcom.com, lingshan.zhu@intel.com,
        eperezma@redhat.com, lulu@redhat.com, shahafs@mellanox.com,
        hanand@xilinx.com, mhabets@solarflare.com, gdawar@xilinx.com,
        saugatm@xilinx.com, vmireyno@marvell.com,
        zhangweining@ruijie.com.cn, eli@mellanox.com
Subject: Re: [PATCH 5/6] vdpa: introduce virtio pci driver
Message-ID: <20200602010332-mutt-send-email-mst@kernel.org>
References: <20200529080303.15449-1-jasowang@redhat.com>
 <20200529080303.15449-6-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200529080303.15449-6-jasowang@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 29, 2020 at 04:03:02PM +0800, Jason Wang wrote:
> +static void vp_vdpa_set_vq_ready(struct vdpa_device *vdpa,
> +				 u16 qid, bool ready)
> +{
> +	struct vp_vdpa *vp_vdpa = vdpa_to_vp(vdpa);
> +
> +	vp_iowrite16(qid, &vp_vdpa->common->queue_select);
> +	vp_iowrite16(ready, &vp_vdpa->common->queue_enable);
> +}
> +

Looks like this needs to check and just skip the write if
ready == 0, right? Of course vdpa core then insists on calling
vp_vdpa_get_vq_ready which will warn. Maybe just drop the
check from core, move it to drivers which need it?

...


> +static const struct pci_device_id vp_vdpa_id_table[] = {
> +	{ PCI_DEVICE(PCI_VENDOR_ID_REDHAT_QUMRANET, PCI_ANY_ID) },
> +	{ 0 }
> +};

This looks like it'll create a mess with either virtio pci
or vdpa being loaded at random. Maybe just don't specify
any IDs for now. Down the road we could get a
distinct vendor ID or a range of device IDs for this.

> +MODULE_DEVICE_TABLE(pci, vp_vdpa_id_table);
> +
> +static struct pci_driver vp_vdpa_driver = {
> +	.name		= "vp-vdpa",
> +	.id_table	= vp_vdpa_id_table,
> +	.probe		= vp_vdpa_probe,
> +	.remove		= vp_vdpa_remove,
> +};
> +
> +module_pci_driver(vp_vdpa_driver);
> +
> +MODULE_AUTHOR("Jason Wang <jasowang@redhat.com>");
> +MODULE_DESCRIPTION("vp-vdpa");
> +MODULE_LICENSE("GPL");
> +MODULE_VERSION("1");
> -- 
> 2.20.1

