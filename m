Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBCA9645FA9
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 18:09:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbiLGRJW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 12:09:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229678AbiLGRJU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 12:09:20 -0500
Received: from mail-qv1-xf2c.google.com (mail-qv1-xf2c.google.com [IPv6:2607:f8b0:4864:20::f2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 828DF68699
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 09:09:18 -0800 (PST)
Received: by mail-qv1-xf2c.google.com with SMTP id o12so13093004qvn.3
        for <netdev@vger.kernel.org>; Wed, 07 Dec 2022 09:09:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=HuOdYoaZDEPwhBHdw5R6JgoLkPkq5AjkABUnDUFXsvQ=;
        b=L25+9nzuXC37mO5ONp1KFhc6uwSzdxjDuh+q1RUj9PcSUte1gnxzsik/niGqyJlF5r
         53OzldyC7As1YQHTfuQXkUCDZylT+hQHdA2/R+yJZq7z90yb9AdKiFyaTdnTfBRaevEo
         zC+71K/BSqP4kpYQfjwHnGOq1QeskrDwIstDJaj79Fc074imxcc+Z/CcRXYUrN986Jwx
         xS8dM9tNpBVM48NztTfGeU2A93wHRwa96nJu3t80VE3WtqHGiKQQUtdbavSVZbIHe68Y
         bJ2XHYeRTbrO++RiE1+HCcvFtsHmPnac6cUs6PMAOh5QtILJH0jNIQy8M1jwIgBBYi3c
         RAQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HuOdYoaZDEPwhBHdw5R6JgoLkPkq5AjkABUnDUFXsvQ=;
        b=FXNQku9AzYyPa9GwHDW3eCl9hCpGilsxFCofw7VawjRSPJWOoA5hxn5isF8VPXKtXX
         kyGFs31ZGvAdR6hdnHoPEWaXPPR4gAQ4wkC6LgF2IWSe8Oy457cyu4w4mVIk6+ZwewUM
         pdjRc/otiZfFiJgAl/eRge04HtD8IVX454WcfV90EU/3cgh+w4/rNQXId3t7lu0Dw9tP
         /AZ3MS3vQfnmFntBQtt0IMBb0cTz4oUhe8b3sa0ynlxiF7KVCA1aRetXJPMueYraTc30
         yVYPKQmKtvnBVITxPCV+BtTXDTs12MyLbhY0GmQVUXyFV1q46OIg/zDlnCGDm415Lj0K
         Y69A==
X-Gm-Message-State: ANoB5pllCeDmRBZGFiZxNfRn3UPzGi+OJbjg2dLnuCDJ1XqaDhyf1HYG
        J6xGhUPOG9AyMEJMTKiIFXbb+Q==
X-Google-Smtp-Source: AA0mqf6+64WwPK2RnAvM3DaEXfXQsESPqJfP0kddWqKFr7Sa3vYzCF3c5jfJflVZrGxJYm7E7NY2zA==
X-Received: by 2002:a05:6214:448b:b0:4bb:6419:ecfb with SMTP id on11-20020a056214448b00b004bb6419ecfbmr64187654qvb.109.1670432957650;
        Wed, 07 Dec 2022 09:09:17 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-47-55-122-23.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.122.23])
        by smtp.gmail.com with ESMTPSA id m10-20020ac8444a000000b0039cc944ebdasm13745329qtn.54.2022.12.07.09.09.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 09:09:17 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1p2xv2-005HvE-Hk;
        Wed, 07 Dec 2022 13:09:16 -0400
Date:   Wed, 7 Dec 2022 13:09:16 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Brett Creeley <brett.creeley@amd.com>
Cc:     kvm@vger.kernel.org, netdev@vger.kernel.org,
        alex.williamson@redhat.com, cohuck@redhat.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        shannon.nelson@amd.com, drivers@pensando.io
Subject: Re: [RFC PATCH vfio 3/7] vfio/pds: Add VFIO live migration support
Message-ID: <Y5DIvM1Ca0qLNzPt@ziepe.ca>
References: <20221207010705.35128-1-brett.creeley@amd.com>
 <20221207010705.35128-4-brett.creeley@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221207010705.35128-4-brett.creeley@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 06, 2022 at 05:07:01PM -0800, Brett Creeley wrote:

> +struct file *
> +pds_vfio_step_device_state_locked(struct pds_vfio_pci_device *pds_vfio,
> +				  enum vfio_device_mig_state next)
> +{
> +	enum vfio_device_mig_state cur = pds_vfio->state;
> +	struct device *dev = &pds_vfio->pdev->dev;
> +	unsigned long lm_action_start;
> +	int err = 0;
> +
> +	dev_dbg(dev, "%s => %s\n",
> +		pds_vfio_lm_state(cur), pds_vfio_lm_state(next));
> +
> +	lm_action_start = jiffies;
> +	if (cur == VFIO_DEVICE_STATE_STOP && next == VFIO_DEVICE_STATE_STOP_COPY) {
> +		/* Device is already stopped
> +		 * create save device data file & get device state from firmware
> +		 */
> +		err = pds_vfio_get_save_file(pds_vfio);
> +		if (err)
> +			return ERR_PTR(err);
> +
> +		/* Get device state */
> +		err = pds_vfio_get_lm_state_cmd(pds_vfio);
> +		if (err) {
> +			pds_vfio_put_save_file(pds_vfio);
> +			return ERR_PTR(err);
> +		}
> +
> +		return pds_vfio->save_file->filep;
> +	}
> +
> +	if (cur == VFIO_DEVICE_STATE_STOP_COPY && next == VFIO_DEVICE_STATE_STOP) {
> +		/* Device is already stopped
> +		 * delete the save device state file
> +		 */
> +		pds_vfio_put_save_file(pds_vfio);
> +		pds_vfio_send_host_vf_lm_status_cmd(pds_vfio,
> +						    PDS_LM_STA_NONE);
> +		return NULL;
> +	}
> +
> +	if (cur == VFIO_DEVICE_STATE_STOP && next == VFIO_DEVICE_STATE_RESUMING) {
> +		/* create resume device data file */
> +		err = pds_vfio_get_restore_file(pds_vfio);
> +		if (err)
> +			return ERR_PTR(err);
> +
> +		return pds_vfio->restore_file->filep;
> +	}
> +
> +	if (cur == VFIO_DEVICE_STATE_RESUMING && next == VFIO_DEVICE_STATE_STOP) {
> +		/* Set device state */
> +		err = pds_vfio_set_lm_state_cmd(pds_vfio);
> +		if (err)
> +			return ERR_PTR(err);
> +
> +		/* delete resume device data file */
> +		pds_vfio_put_restore_file(pds_vfio);
> +		return NULL;
> +	}
> +
> +	if (cur == VFIO_DEVICE_STATE_RUNNING && next == VFIO_DEVICE_STATE_STOP) {
> +		/* Device should be stopped
> +		 * no interrupts, dma or change in internal state
> +		 */
> +		err = pds_vfio_suspend_device_cmd(pds_vfio);
> +		if (err)
> +			return ERR_PTR(err);
> +
> +		return NULL;
> +	}
> +
> +	if (cur == VFIO_DEVICE_STATE_STOP && next == VFIO_DEVICE_STATE_RUNNING) {
> +		/* Device should be functional
> +		 * interrupts, dma, mmio or changes to internal state is allowed
> +		 */
> +		err = pds_vfio_resume_device_cmd(pds_vfio);
> +		if (err)
> +			return ERR_PTR(err);
> +
> +		pds_vfio_send_host_vf_lm_status_cmd(pds_vfio,
> +						    PDS_LM_STA_NONE);
> +		return NULL;
> +	}

Please implement the P2P states in your device. After long discussions
we really want to see all VFIO migrations implementations support
this.

It is still not clear what qemu will do when it sees devices that do
not support P2P, but it will not be nice.

Also, since you are obviously using and testing the related qemu
series, please participate in the review of that in the qemu list, or
at least offer your support with testing.

While HCH is objecting to this driver even existing I won't comment on
specific details.. Though it is intesting this approach doesn't change
NVMe at all so it does seem less objectionable to me than the Intel
RFC.

Jason
