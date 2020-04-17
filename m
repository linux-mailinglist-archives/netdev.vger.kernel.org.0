Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B5E21AE8B6
	for <lists+netdev@lfdr.de>; Sat, 18 Apr 2020 01:50:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726435AbgDQXtq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 19:49:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726320AbgDQXtp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Apr 2020 19:49:45 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE417C061A0C
        for <netdev@vger.kernel.org>; Fri, 17 Apr 2020 16:49:44 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id f13so3550075qti.5
        for <netdev@vger.kernel.org>; Fri, 17 Apr 2020 16:49:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=rv+SIvq+0d5RU7/wGuuG4u37IHm0iWvJ0sVJzXRdtBg=;
        b=Djaf0gR5xl0A166FGH2eh3UZrlL+mMOJ6MJWMUad07t1KvlBrSH/fPStFh7ThJL1zh
         Pf/dUDE+Uz4nnnk/DtSoEjfjcUv0YPQh5O3xTKRicliSds8/2R3vS3Fw06U2bDzRHPo1
         KtxtX6rY0BAh1bdQkTQpkpcF06qycUQWBTlqSc6GwhSxXy3VPr5Gcixmj5pJzFyoQniJ
         LTE9IxnDpvoMsyp8Z8sCrI/ZRVSVnqz89FCHxyAAKujRFJXhLY2AHfu+NjLgnKZEZ0u+
         5zMNAeS+bgabRnwqr9xl1X5dRQRo/W7+23j4JDG0zeYsXfpqWBOtLLz9rr5NpG9doLMm
         grEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=rv+SIvq+0d5RU7/wGuuG4u37IHm0iWvJ0sVJzXRdtBg=;
        b=AFD80JYzaAclMxE2nB0wecBxAAFHCKhIRDuvuYs2EZP2KDvwrk0W0A4A32p94FSfZp
         FL8ocoqnYNzKu/Cot4Sbd9mn5J00SeTbGjTay4Kw6nISk/pvM85mxr6bHQjCKb6RlJJ+
         4sjzu6mf2OxpSo4dWbBoFMxWuYKTODT0srXtNYKcC0NTyy175h73uVDcFwYysuGrpu0h
         LBcJq1f5XkFe2XsppkpMiBsd81YbezJJ0XCCKnu6EbR7r6ySoLI6bfWl0i/NXd0Wph/b
         CugXXUIMA29A5jAOLA1PSEy/hiE0HTd55N7Bb4BK/OgYwaHcWQAs3lrvhvjXrr0jXRQd
         23FA==
X-Gm-Message-State: AGi0PuZ3lY4dj94ptFKO55edtttautVNbnMrr1uf+BzdmPyZm3zu+cLL
        VNikiNRp5pfEjGBFhoQJdFyUMA==
X-Google-Smtp-Source: APiQypI2JZHWDsTvhNPOt4w6MPSufSWhWXO4Y60JCD3ch58mhHIwtRzZXh3Mc1p9qk0+VA7fQyW9Dw==
X-Received: by 2002:ac8:164e:: with SMTP id x14mr5725673qtk.196.1587167384100;
        Fri, 17 Apr 2020 16:49:44 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id u17sm9349864qka.0.2020.04.17.16.49.43
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 17 Apr 2020 16:49:43 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jPajv-0007ff-2U; Fri, 17 Apr 2020 20:49:43 -0300
Date:   Fri, 17 Apr 2020 20:49:43 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     davem@davemloft.net, gregkh@linuxfoundation.org,
        Dave Ertman <david.m.ertman@intel.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com, ranjani.sridharan@linux.intel.com,
        pierre-louis.bossart@linux.intel.com,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: Re: [net-next 2/9] ice: Create and register virtual bus for RDMA
Message-ID: <20200417234943.GM26002@ziepe.ca>
References: <20200417171034.1533253-1-jeffrey.t.kirsher@intel.com>
 <20200417171034.1533253-3-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200417171034.1533253-3-jeffrey.t.kirsher@intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 17, 2020 at 10:10:27AM -0700, Jeff Kirsher wrote:

> +/**
> + * ice_peer_vdev_release - function to map to virtbus_devices release callback
> + * @vdev: pointer to virtbus_device to free
> + */
> +static void ice_peer_vdev_release(struct virtbus_device *vdev)
> +{
> +	struct iidc_virtbus_object *vbo;
> +
> +	vbo = container_of(vdev, struct iidc_virtbus_object, vdev);
> +	kfree(vbo);
> +}
> +
> +/**
> + * ice_init_peer_devices - initializes peer devices
> + * @pf: ptr to ice_pf
> + *
> + * This function initializes peer devices on the virtual bus.
> + */
> +int ice_init_peer_devices(struct ice_pf *pf)
> +{
> +	struct ice_vsi *vsi = pf->vsi[0];
> +	struct pci_dev *pdev = pf->pdev;
> +	struct device *dev = &pdev->dev;
> +	int status = 0;
> +	unsigned int i;
> +
> +	/* Reserve vector resources */
> +	status = ice_reserve_peer_qvector(pf);
> +	if (status < 0) {
> +		dev_err(dev, "failed to reserve vectors for peer drivers\n");
> +		return status;
> +	}
> +	for (i = 0; i < ARRAY_SIZE(ice_peers); i++) {
> +		struct ice_peer_dev_int *peer_dev_int;
> +		struct ice_peer_drv_int *peer_drv_int;
> +		struct iidc_qos_params *qos_info;
> +		struct iidc_virtbus_object *vbo;
> +		struct msix_entry *entry = NULL;
> +		struct iidc_peer_dev *peer_dev;
> +		struct virtbus_device *vdev;
> +		int j;
> +
> +		/* structure layout needed for container_of's looks like:
> +		 * ice_peer_dev_int (internal only ice peer superstruct)
> +		 * |--> iidc_peer_dev
> +		 * |--> *ice_peer_drv_int
> +		 *
> +		 * iidc_virtbus_object (container_of parent for vdev)
> +		 * |--> virtbus_device
> +		 * |--> *iidc_peer_dev (pointer from internal struct)
> +		 *
> +		 * ice_peer_drv_int (internal only peer_drv struct)
> +		 */
> +		peer_dev_int = kzalloc(sizeof(*peer_dev_int), GFP_KERNEL);
> +		if (!peer_dev_int)
> +			return -ENOMEM;
> +
> +		vbo = kzalloc(sizeof(*vbo), GFP_KERNEL);
> +		if (!vbo) {
> +			kfree(peer_dev_int);
> +			return -ENOMEM;
> +		}
> +
> +		peer_drv_int = kzalloc(sizeof(*peer_drv_int), GFP_KERNEL);
> +		if (!peer_drv_int) {
> +			kfree(peer_dev_int);
> +			kfree(vbo);
> +			return -ENOMEM;
> +		}

The lifetimes of all this memory look really suspect. The vbo holds a
pointer to the peer_dev but who ensures it it freed after all the vbo
kref's are released so there isn't a dangling pointer in
vbo->peer_dev?

One allocation is much simpler to understand:

struct iidc_virtbus_object {
   struct virbus_device vdev;
   [public members]
}

struct iidc_virtbus_object_private {
   struct iidc_virtbus_object vobj;
   [private members]
}

And just kzalloc a single iidc_virtbus_object_private

> +		peer_dev->msix_entries = entry;
> +		ice_peer_state_change(peer_dev_int, ICE_PEER_DEV_STATE_INIT,
> +				      false);
> +
> +		vdev = &vbo->vdev;
> +		vdev->name = ice_peers[i].name;
> +		vdev->release = ice_peer_vdev_release;
> +		vdev->dev.parent = &pdev->dev;
> +
> +		status = virtbus_register_device(vdev);
> +		if (status) {
> +			kfree(peer_dev_int);
> +			kfree(peer_drv_int);
> +			vdev = NULL;

To me this feels very unnatural, virtbus_register_device() does the
kfree for the vbo if it fails so this function can't have a the normal
goto error unwind and ends up open coding the error unwinds in each if
above.

> +/* Following APIs are implemented by peer drivers and invoked by device
> + * owner
> + */
> +struct iidc_peer_ops {
> +	void (*event_handler)(struct iidc_peer_dev *peer_dev,
> +			      struct iidc_event *event);
> +
> +	/* Why we have 'open' and when it is expected to be called:
> +	 * 1. symmetric set of API w.r.t close
> +	 * 2. To be invoked form driver initialization path
> +	 *     - call peer_driver:open once device owner is fully
> +	 *     initialized
> +	 * 3. To be invoked upon RESET complete
> +	 */
> +	int (*open)(struct iidc_peer_dev *peer_dev);
> +
> +	/* Peer's close function is to be called when the peer needs to be
> +	 * quiesced. This can be for a variety of reasons (enumerated in the
> +	 * iidc_close_reason enum struct). A call to close will only be
> +	 * followed by a call to either remove or open. No IDC calls from the
> +	 * peer should be accepted until it is re-opened.
> +	 *
> +	 * The *reason* parameter is the reason for the call to close. This
> +	 * can be for any reason enumerated in the iidc_close_reason struct.
> +	 * It's primary reason is for the peer's bookkeeping and in case the
> +	 * peer want to perform any different tasks dictated by the reason.
> +	 */
> +	void (*close)(struct iidc_peer_dev *peer_dev,
> +		      enum iidc_close_reason reason);

The open and close op looks really weird

Jason
