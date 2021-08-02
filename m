Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 885883DE08F
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 22:20:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231213AbhHBUUt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 16:20:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:31923 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230493AbhHBUUs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 16:20:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627935638;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lYH60gJpCg8wFsELo1ByQts1CdUqSFKUUU+BBKD7WDg=;
        b=QRcdgSovpbebKfT7i+RF4rqX78Roa93ch19dZTX1q6TzBQaGoY8pon/FF/342X3yWb8wSd
        ips7tK7RRqFVLOTlYkui2aPcQWZ9vy3SDBkbIlWQioFEiT2/vHq5TVOFXj5/JSooF6iOWM
        tSS/6UoyVBc/62jB3Gs1ePrViAcmaXQ=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-550-6Igkls82NUOM9pU22ZKaVA-1; Mon, 02 Aug 2021 16:20:36 -0400
X-MC-Unique: 6Igkls82NUOM9pU22ZKaVA-1
Received: by mail-ej1-f70.google.com with SMTP id o16-20020a1709066010b0290593804ff1e1so3464957ejj.19
        for <netdev@vger.kernel.org>; Mon, 02 Aug 2021 13:20:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lYH60gJpCg8wFsELo1ByQts1CdUqSFKUUU+BBKD7WDg=;
        b=TfZjEPzN83NMQQkazVsGqa/bkwXodBluL5nlytVwes4sSVRGHbeK4xsWm2VS5DNv5d
         IsN1j25LZaKlx+ZFmD0LTiJFAZLsIq56APjIA1FHmKkxkUXCUPCkRju+gfm94GRZCsZu
         yG1NwVyc5lMeJIyrF0AoDll2odUCt0uj47neAnUCWE8AbpxT6RfRZTyKuUkn8D1hIyEQ
         gMfarkarWkUrNFxHbIZNclzZUkBerUSZBI9kqh8uj8f2S7CesmMScqXW6h3C/ZgbzMM8
         d4lIKsx2s5N6R+q1ESulI8/c8HHXgyHhVCQGSyZUJHOQOI5YCDvQ4Vbxf2Lxk+UKFVn4
         jqGw==
X-Gm-Message-State: AOAM532pvBVWJ8cZqMjTdzADm+HhiV6j/xO/5lgmLPv3fHrEB7iItwBy
        f2ddLOxF2ZC+hpBkWxut2kSDLUAOjLDpet/jF2D3bIgHs2oaRCWxi5fWu5sRkHxchJSwpTmkNol
        HwzswSvmXyOodedBK
X-Received: by 2002:a17:907:2058:: with SMTP id pg24mr17304495ejb.315.1627935635609;
        Mon, 02 Aug 2021 13:20:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzNObW5q1IP6WqK4TCphQaUTzjdngOTrnHQZIkLfU7YFK/3j8v+/uqxNT4tPH6bOwqjXzCsfg==
X-Received: by 2002:a17:907:2058:: with SMTP id pg24mr17304472ejb.315.1627935635293;
        Mon, 02 Aug 2021 13:20:35 -0700 (PDT)
Received: from redhat.com ([2.55.140.205])
        by smtp.gmail.com with ESMTPSA id s24sm5204737ejd.19.2021.08.02.13.20.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 13:20:34 -0700 (PDT)
Date:   Mon, 2 Aug 2021 16:20:30 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     fuguancheng <fuguancheng@bytedance.com>
Cc:     jasowang@redhat.com, stefanha@redhat.com, sgarzare@redhat.com,
        davem@davemloft.net, kuba@kernel.org, arseny.krasnov@kaspersky.com,
        andraprs@amazon.com, colin.king@canonical.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] VSOCK DRIVER: Add multi-cid support for guest
Message-ID: <20210802161503-mutt-send-email-mst@kernel.org>
References: <20210802120720.547894-1-fuguancheng@bytedance.com>
 <20210802120720.547894-2-fuguancheng@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210802120720.547894-2-fuguancheng@bytedance.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 02, 2021 at 08:07:17PM +0800, fuguancheng wrote:
> This patch allowes the user to specify multiple additional CIDS
> for the guest that can be used for communication between host
> and guest.
> 
> The guest reads the additional cids from the device config space.
> The device config space layout can be found at uapi/linux/virtio_vsock.h
> The existing ioctl call for device VHOST_VIRTIO with request code
> VHOST_VSOCK_SET_GUEST_CID is modified to notify the host for the
> additional guest CIDS.
> 
> Signed-off-by: fuguancheng <fuguancheng@bytedance.com>
> ---
>  drivers/vhost/vhost.h             |   5 ++
>  drivers/vhost/vsock.c             | 173 +++++++++++++++++++++++++++++---------
>  include/net/af_vsock.h            |   1 +
>  include/uapi/linux/vhost.h        |   7 ++
>  include/uapi/linux/virtio_vsock.h |   3 +-
>  net/vmw_vsock/af_vsock.c          |   6 +-
>  net/vmw_vsock/virtio_transport.c  |  72 ++++++++++++++--
>  net/vmw_vsock/vsock_loopback.c    |   8 ++
>  8 files changed, 222 insertions(+), 53 deletions(-)
> 
> diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
> index 638bb640d6b4..52bd143ccf0c 100644
> --- a/drivers/vhost/vhost.h
> +++ b/drivers/vhost/vhost.h
> @@ -25,6 +25,11 @@ struct vhost_work {
>  	unsigned long		flags;
>  };
>  
> +struct multi_cid_message {
> +	u32 number_cid;
> +	u64 *cid;
> +};
> +
>  /* Poll a file (eventfd or socket) */
>  /* Note: there's nothing vhost specific about this structure. */
>  struct vhost_poll {
> diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
> index f249622ef11b..f66c87de91b8 100644
> --- a/drivers/vhost/vsock.c
> +++ b/drivers/vhost/vsock.c
> @@ -43,12 +43,25 @@ enum {
>  static DEFINE_MUTEX(vhost_vsock_mutex);
>  static DEFINE_READ_MOSTLY_HASHTABLE(vhost_vsock_hash, 8);
>  
> +struct vhost_vsock_ref {
> +	struct vhost_vsock *vsock;
> +	struct hlist_node ref_hash;
> +	u32 cid;
> +};
> +
> +static bool vhost_transport_contain_cid(u32 cid)
> +{
> +	if (cid == VHOST_VSOCK_DEFAULT_HOST_CID)
> +		return true;
> +	return false;
> +}
> +
>  struct vhost_vsock {
>  	struct vhost_dev dev;
>  	struct vhost_virtqueue vqs[2];
>  
>  	/* Link to global vhost_vsock_hash, writes use vhost_vsock_mutex */
> -	struct hlist_node hash;
> +	struct vhost_vsock_ref *ref_list;
>  
>  	struct vhost_work send_pkt_work;
>  	spinlock_t send_pkt_list_lock;
> @@ -56,7 +69,8 @@ struct vhost_vsock {
>  
>  	atomic_t queued_replies;
>  
> -	u32 guest_cid;
> +	u32 *cids;
> +	u32 num_cid;
>  	bool seqpacket_allow;
>  };
>  
> @@ -70,23 +84,49 @@ static u32 vhost_transport_get_local_cid(void)
>   */
>  static struct vhost_vsock *vhost_vsock_get(u32 guest_cid)
>  {
> -	struct vhost_vsock *vsock;
> +	struct vhost_vsock_ref *ref;
>  
> -	hash_for_each_possible_rcu(vhost_vsock_hash, vsock, hash, guest_cid) {
> -		u32 other_cid = vsock->guest_cid;
> +	hash_for_each_possible_rcu(vhost_vsock_hash, ref, ref_hash, guest_cid) {
> +		u32 other_cid = ref->cid;
>  
>  		/* Skip instances that have no CID yet */
>  		if (other_cid == 0)
>  			continue;
>  
>  		if (other_cid == guest_cid)
> -			return vsock;
> +			return ref->vsock;
>  
>  	}
>  
>  	return NULL;
>  }
>  
> +static int check_if_cid_valid(u64 guest_cid, struct vhost_vsock *vsock)
> +{
> +	struct vhost_vsock *other;
> +
> +	if (guest_cid <= VMADDR_CID_HOST || guest_cid == U32_MAX)
> +		return -EINVAL;
> +
> +	/* 64-bit CIDs are not yet supported */
> +	if (guest_cid > U32_MAX)
> +		return -EINVAL;
> +	/* Refuse if CID is assigned to the guest->host transport (i.e. nested
> +	 * VM), to make the loopback work.
> +	 */
> +	if (vsock_find_cid(guest_cid))
> +		return -EADDRINUSE;
> +	/* Refuse if CID is already in use */
> +	mutex_lock(&vhost_vsock_mutex);
> +	other = vhost_vsock_get(guest_cid);
> +	if (other) {
> +		mutex_unlock(&vhost_vsock_mutex);
> +		return -EADDRINUSE;
> +	}
> +	mutex_unlock(&vhost_vsock_mutex);
> +	return 0;
> +}
> +
>  static void
>  vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
>  			    struct vhost_virtqueue *vq)
> @@ -427,6 +467,7 @@ static struct virtio_transport vhost_transport = {
>  		.module                   = THIS_MODULE,
>  
>  		.get_local_cid            = vhost_transport_get_local_cid,
> +		.contain_cid              = vhost_transport_contain_cid,
>  
>  		.init                     = virtio_transport_do_socket_init,
>  		.destruct                 = virtio_transport_destruct,
> @@ -542,9 +583,9 @@ static void vhost_vsock_handle_tx_kick(struct vhost_work *work)
>  		virtio_transport_deliver_tap_pkt(pkt);
>  
>  		/* Only accept correctly addressed packets */
> -		if (le64_to_cpu(pkt->hdr.src_cid) == vsock->guest_cid &&
> -		    le64_to_cpu(pkt->hdr.dst_cid) ==
> -		    vhost_transport_get_local_cid())
> +		if (vsock->num_cid > 0 &&
> +		    (pkt->hdr.src_cid) == vsock->cids[0] &&
> +		    le64_to_cpu(pkt->hdr.dst_cid) == vhost_transport_get_local_cid())
>  			virtio_transport_recv_pkt(&vhost_transport, pkt);
>  		else
>  			virtio_transport_free_pkt(pkt);
> @@ -655,6 +696,10 @@ static int vhost_vsock_stop(struct vhost_vsock *vsock)
>  
>  static void vhost_vsock_free(struct vhost_vsock *vsock)
>  {
> +	if (vsock->ref_list)
> +		kvfree(vsock->ref_list);
> +	if (vsock->cids)
> +		kvfree(vsock->cids);
>  	kvfree(vsock);
>  }
>  
> @@ -677,7 +722,9 @@ static int vhost_vsock_dev_open(struct inode *inode, struct file *file)
>  		goto out;
>  	}
>  
> -	vsock->guest_cid = 0; /* no CID assigned yet */
> +	vsock->ref_list = NULL;
> +	vsock->cids = NULL;
> +	vsock->num_cid = 0;
>  
>  	atomic_set(&vsock->queued_replies, 0);
>  
> @@ -739,11 +786,14 @@ static void vhost_vsock_reset_orphans(struct sock *sk)
>  
>  static int vhost_vsock_dev_release(struct inode *inode, struct file *file)
>  {
> +	int index;
>  	struct vhost_vsock *vsock = file->private_data;
>  
>  	mutex_lock(&vhost_vsock_mutex);
> -	if (vsock->guest_cid)
> -		hash_del_rcu(&vsock->hash);
> +	if (vsock->num_cid) {
> +		for (index = 0; index < vsock->num_cid; index++)
> +			hash_del_rcu(&vsock->ref_list[index].ref_hash);
> +	}
>  	mutex_unlock(&vhost_vsock_mutex);
>  
>  	/* Wait for other CPUs to finish using vsock */
> @@ -774,41 +824,80 @@ static int vhost_vsock_dev_release(struct inode *inode, struct file *file)
>  	return 0;
>  }
>  
> -static int vhost_vsock_set_cid(struct vhost_vsock *vsock, u64 guest_cid)
> +static int vhost_vsock_set_cid(struct vhost_vsock *vsock, u64 __user *cids, u32 number_cid)
>  {
> -	struct vhost_vsock *other;
> +	u64 cid;
> +	int i, ret;
>  
> -	/* Refuse reserved CIDs */
> -	if (guest_cid <= VMADDR_CID_HOST ||
> -	    guest_cid == U32_MAX)
> +	if (number_cid <= 0)
>  		return -EINVAL;
> -
> -	/* 64-bit CIDs are not yet supported */
> -	if (guest_cid > U32_MAX)
> -		return -EINVAL;
> -
> -	/* Refuse if CID is assigned to the guest->host transport (i.e. nested
> -	 * VM), to make the loopback work.
> -	 */
> -	if (vsock_find_cid(guest_cid))
> -		return -EADDRINUSE;
> -
> -	/* Refuse if CID is already in use */
> -	mutex_lock(&vhost_vsock_mutex);
> -	other = vhost_vsock_get(guest_cid);
> -	if (other && other != vsock) {
> +	/* delete the old CIDs. */
> +	if (vsock->num_cid) {
> +		mutex_lock(&vhost_vsock_mutex);
> +		for (i = 0; i < vsock->num_cid; i++)
> +			hash_del_rcu(&vsock->ref_list[i].ref_hash);
>  		mutex_unlock(&vhost_vsock_mutex);
> -		return -EADDRINUSE;
> +		kvfree(vsock->ref_list);
> +		vsock->ref_list = NULL;
> +		kvfree(vsock->cids);
> +		vsock->cids = NULL;
> +	}
> +	vsock->num_cid = number_cid;
> +	vsock->cids = kmalloc_array(vsock->num_cid, sizeof(u32),
> +				    GFP_KERNEL | __GFP_RETRY_MAYFAIL);
> +	if (!vsock->cids) {
> +		vsock->num_cid = 0;
> +		ret = -ENOMEM;
> +		goto out;
> +	}
> +	vsock->ref_list = kvmalloc_array(vsock->num_cid, sizeof(*vsock->ref_list),
> +			       GFP_KERNEL | __GFP_RETRY_MAYFAIL);
> +	if (!vsock->ref_list) {
> +		vsock->num_cid = 0;
> +		ret = -ENOMEM;
> +		goto out;
>  	}
>  
> -	if (vsock->guest_cid)
> -		hash_del_rcu(&vsock->hash);
> -
> -	vsock->guest_cid = guest_cid;
> -	hash_add_rcu(vhost_vsock_hash, &vsock->hash, vsock->guest_cid);
> -	mutex_unlock(&vhost_vsock_mutex);
> +	for (i = 0; i < number_cid; i++) {
> +		if (copy_from_user(&cid, cids + i, sizeof(cid))) {
> +			/* record where we failed, to clean up the ref in hash table. */
> +			vsock->num_cid = i;
> +			ret = -EFAULT;
> +			goto out;
> +		}
> +		ret = check_if_cid_valid(cid, vsock);
> +		if (ret) {
> +			vsock->num_cid = i;
> +			goto out;
> +		}
>  
> +		vsock->cids[i] = (u32)cid;
> +		vsock->ref_list[i].cid = vsock->cids[i];
> +		vsock->ref_list[i].vsock = vsock;
> +		mutex_lock(&vhost_vsock_mutex);
> +		hash_add_rcu(vhost_vsock_hash, &vsock->ref_list[i].ref_hash,
> +			     vsock->cids[i]);
> +		mutex_unlock(&vhost_vsock_mutex);
> +	}
>  	return 0;
> +
> +out:
> +	/* Handle the memory release here. */
> +	if (vsock->num_cid) {
> +		mutex_lock(&vhost_vsock_mutex);
> +		for (i = 0; i < vsock->num_cid; i++)
> +			hash_del_rcu(&vsock->ref_list[i].ref_hash);
> +		mutex_unlock(&vhost_vsock_mutex);
> +		vsock->num_cid = 0;
> +	}
> +	if (vsock->ref_list)
> +		kvfree(vsock->ref_list);
> +	if (vsock->cids)
> +		kvfree(vsock->cids);
> +	/* Set it to null to prevent double release. */
> +	vsock->ref_list = NULL;
> +	vsock->cids = NULL;
> +	return ret;
>  }
>  
>  static int vhost_vsock_set_features(struct vhost_vsock *vsock, u64 features)
> @@ -852,16 +941,16 @@ static long vhost_vsock_dev_ioctl(struct file *f, unsigned int ioctl,
>  {
>  	struct vhost_vsock *vsock = f->private_data;
>  	void __user *argp = (void __user *)arg;
> -	u64 guest_cid;
>  	u64 features;
>  	int start;
>  	int r;
> +	struct multi_cid_message cid_message;
>  
>  	switch (ioctl) {
>  	case VHOST_VSOCK_SET_GUEST_CID:
> -		if (copy_from_user(&guest_cid, argp, sizeof(guest_cid)))
> +		if (copy_from_user(&cid_message, argp, sizeof(cid_message)))
>  			return -EFAULT;
> -		return vhost_vsock_set_cid(vsock, guest_cid);
> +		return vhost_vsock_set_cid(vsock, cid_message.cid, cid_message.number_cid);
>  	case VHOST_VSOCK_SET_RUNNING:
>  		if (copy_from_user(&start, argp, sizeof(start)))
>  			return -EFAULT;
> diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
> index ab207677e0a8..d0fc08fb9cac 100644
> --- a/include/net/af_vsock.h
> +++ b/include/net/af_vsock.h
> @@ -170,6 +170,7 @@ struct vsock_transport {
>  
>  	/* Addressing. */
>  	u32 (*get_local_cid)(void);
> +	bool (*contain_cid)(u32 cid);
>  };
>  
>  /**** CORE ****/
> diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
> index c998860d7bbc..a3ea99f6fc7f 100644
> --- a/include/uapi/linux/vhost.h
> +++ b/include/uapi/linux/vhost.h
> @@ -17,6 +17,13 @@
>  
>  #define VHOST_FILE_UNBIND -1
>  
> +/* structs used for hypervisors to send cid info. */
> +
> +struct multi_cid_message {
> +	u32 number_cid;
> +	u64 *cid;
> +};
> +
>  /* ioctls */
>  
>  #define VHOST_VIRTIO 0xAF
> diff --git a/include/uapi/linux/virtio_vsock.h b/include/uapi/linux/virtio_vsock.h
> index 3dd3555b2740..0afc14446b01 100644
> --- a/include/uapi/linux/virtio_vsock.h
> +++ b/include/uapi/linux/virtio_vsock.h
> @@ -42,7 +42,8 @@
>  #define VIRTIO_VSOCK_F_SEQPACKET	1	/* SOCK_SEQPACKET supported */
>  
>  struct virtio_vsock_config {
> -	__le64 guest_cid;
> +	__le32 number_cid;
> +	__le64 cids[];

Config space should be generally limited to ~256 bytes.
That is < 32 cids. Enough? I would implement an interface where
you write a number and read back a cid, instead.


>  } __attribute__((packed));
>

You want a feature bit for this.

  
>  enum virtio_vsock_event_id {
> diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
> index 3e02cc3b24f8..4e1fbe74013f 100644
> --- a/net/vmw_vsock/af_vsock.c
> +++ b/net/vmw_vsock/af_vsock.c
> @@ -507,13 +507,13 @@ EXPORT_SYMBOL_GPL(vsock_assign_transport);
>  
>  bool vsock_find_cid(unsigned int cid)
>  {
> -	if (transport_g2h && cid == transport_g2h->get_local_cid())
> +	if (transport_g2h && transport_g2h->contain_cid(cid))
>  		return true;
>  
> -	if (transport_h2g && cid == VMADDR_CID_HOST)
> +	if (transport_h2g && transport_h2g->contain_cid(cid))
>  		return true;
>  
> -	if (transport_local && cid == VMADDR_CID_LOCAL)
> +	if (transport_local && transport_local->contain_cid(cid))
>  		return true;
>  
>  	return false;
> diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
> index e0c2c992ad9c..5f256a57d9ae 100644
> --- a/net/vmw_vsock/virtio_transport.c
> +++ b/net/vmw_vsock/virtio_transport.c
> @@ -61,10 +61,41 @@ struct virtio_vsock {
>  	bool event_run;
>  	struct virtio_vsock_event event_list[8];
>  
> -	u32 guest_cid;
> +	/* The following fields are used to hold additional cids given by the hypervisor
> +	 * such as qemu.
> +	 */
> +	u32 number_cid;
> +	u32 *cids;
> +
>  	bool seqpacket_allow;
>  };
>  
> +static bool virtio_transport_contain_cid(u32 cid)
> +{
> +	struct virtio_vsock *vsock;
> +	bool ret;
> +	u32 num_cid;
> +
> +	num_cid = 0;
> +	rcu_read_lock();
> +	vsock = rcu_dereference(the_virtio_vsock);
> +	if (!vsock || !vsock->number_cid) {
> +		ret = false;
> +		goto out_rcu;
> +	}
> +
> +	for (num_cid = 0; num_cid < vsock->number_cid; num_cid++) {
> +		if (vsock->cids[num_cid] == cid) {
> +			ret = true;
> +			goto out_rcu;
> +		}
> +	}
> +	ret = false;
> +out_rcu:
> +	rcu_read_unlock();
> +	return ret;
> +}
> +
>  static u32 virtio_transport_get_local_cid(void)
>  {
>  	struct virtio_vsock *vsock;
> @@ -72,12 +103,12 @@ static u32 virtio_transport_get_local_cid(void)
>  
>  	rcu_read_lock();
>  	vsock = rcu_dereference(the_virtio_vsock);
> -	if (!vsock) {
> +	if (!vsock || !vsock->number_cid) {
>  		ret = VMADDR_CID_ANY;
>  		goto out_rcu;
>  	}
>  
> -	ret = vsock->guest_cid;
> +	ret = vsock->cids[0];
>  out_rcu:
>  	rcu_read_unlock();
>  	return ret;
> @@ -176,7 +207,7 @@ virtio_transport_send_pkt(struct virtio_vsock_pkt *pkt)
>  		goto out_rcu;
>  	}
>  
> -	if (le64_to_cpu(pkt->hdr.dst_cid) == vsock->guest_cid) {
> +	if (le64_to_cpu(pkt->hdr.dst_cid) == vsock->cids[0]) {
>  		virtio_transport_free_pkt(pkt);
>  		len = -ENODEV;
>  		goto out_rcu;
> @@ -368,10 +399,33 @@ static void virtio_vsock_update_guest_cid(struct virtio_vsock *vsock)
>  {
>  	struct virtio_device *vdev = vsock->vdev;
>  	__le64 guest_cid;
> +	__le32 number_cid;
> +	u32 index;
>  
> -	vdev->config->get(vdev, offsetof(struct virtio_vsock_config, guest_cid),
> -			  &guest_cid, sizeof(guest_cid));
> -	vsock->guest_cid = le64_to_cpu(guest_cid);
> +	vdev->config->get(vdev, offsetof(struct virtio_vsock_config, number_cid),
> +			  &number_cid, sizeof(number_cid));

need to handle existing devices without the feature.

> +	vsock->number_cid = le32_to_cpu(number_cid);
> +
> +	/* number_cid must be greater than 0 in the config space
> +	 * to use this feature.
> +	 */
> +	if (vsock->number_cid > 0) {
> +		vsock->cids = kmalloc_array(vsock->number_cid, sizeof(u32), GFP_KERNEL);
> +		if (!vsock->cids) {
> +			/* Space allocated failed, reset number_cid to 0.
> +			 * only use the original guest_cid.
> +			 */
> +			vsock->number_cid = 0;
> +		}
> +	}
> +
> +	for (index = 0; index < vsock->number_cid; index++) {
> +		vdev->config->get(vdev,
> +				  offsetof(struct virtio_vsock_config, cids)
> +				  + index * sizeof(uint64_t),
> +				  &guest_cid, sizeof(guest_cid));
> +		vsock->cids[index] = le64_to_cpu(guest_cid);

You just drop high bits here. Unlikely to behave well if they
are not 0.


> +	}
>  }
>  
>  /* event_lock must be held */
> @@ -451,6 +505,7 @@ static struct virtio_transport virtio_transport = {
>  		.module                   = THIS_MODULE,
>  
>  		.get_local_cid            = virtio_transport_get_local_cid,
> +		.contain_cid              = virtio_transport_contain_cid,
>  
>  		.init                     = virtio_transport_do_socket_init,
>  		.destruct                 = virtio_transport_destruct,
> @@ -594,6 +649,8 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
>  	}
>  
>  	vsock->vdev = vdev;
> +	vsock->cids = NULL;
> +	vsock->number_cid = 0;
>  
>  	ret = virtio_find_vqs(vsock->vdev, VSOCK_VQ_MAX,
>  			      vsock->vqs, callbacks, names,
> @@ -713,6 +770,7 @@ static void virtio_vsock_remove(struct virtio_device *vdev)
>  
>  	mutex_unlock(&the_virtio_vsock_mutex);
>  
> +	kfree(vsock->cids);
>  	kfree(vsock);
>  }
>  
> diff --git a/net/vmw_vsock/vsock_loopback.c b/net/vmw_vsock/vsock_loopback.c
> index 169a8cf65b39..3abbbaff34eb 100644
> --- a/net/vmw_vsock/vsock_loopback.c
> +++ b/net/vmw_vsock/vsock_loopback.c
> @@ -63,6 +63,13 @@ static int vsock_loopback_cancel_pkt(struct vsock_sock *vsk)
>  	return 0;
>  }
>  
> +static bool vsock_loopback_contain_cid(u32 cid)
> +{
> +	if (cid == VMADDR_CID_LOCAL)
> +		return true;
> +	return false;
> +}
> +
>  static bool vsock_loopback_seqpacket_allow(u32 remote_cid);
>  
>  static struct virtio_transport loopback_transport = {
> @@ -70,6 +77,7 @@ static struct virtio_transport loopback_transport = {
>  		.module                   = THIS_MODULE,
>  
>  		.get_local_cid            = vsock_loopback_get_local_cid,
> +		.contain_cid              = vsock_loopback_contain_cid,
>  
>  		.init                     = virtio_transport_do_socket_init,
>  		.destruct                 = virtio_transport_destruct,
> -- 
> 2.11.0
> 
> 

