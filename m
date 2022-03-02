Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED5934CA9CD
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 17:07:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240190AbiCBQI0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 11:08:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240024AbiCBQIZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 11:08:25 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 605D02D1F6
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 08:07:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646237260;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kijBMrzxo7OdLpiSqnAt9AQTzfbPdM8vboePrFXlyXA=;
        b=FxtRp6EJC4xS3Rz/ztFBzPJJ3IKUYnKgnl2gU9FOr8zf201Grot33toq05jEc7gr7f13K4
        E1JMKgS7Wlt5kZC6GloG7OU9nvVzF1Mq1YXtevrDhpaUVRwy9coDyz0xd4RcXV/Y43kp4K
        DbpuFT1iJ06ALYbMD5Fz2J1auV5B9sQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-639-uU2zv3bJOMWGdofAbFUdcQ-1; Wed, 02 Mar 2022 11:07:37 -0500
X-MC-Unique: uU2zv3bJOMWGdofAbFUdcQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 438A2801AFE;
        Wed,  2 Mar 2022 16:07:35 +0000 (UTC)
Received: from localhost (unknown [10.39.194.94])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D504A83C1D;
        Wed,  2 Mar 2022 16:07:23 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, bhelgaas@google.com,
        saeedm@nvidia.com, linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, leonro@nvidia.com,
        kwankhede@nvidia.com, mgurtovoy@nvidia.com, maorg@nvidia.com,
        ashok.raj@intel.com, kevin.tian@intel.com,
        shameerali.kolothum.thodi@huawei.com
Subject: Re: [PATCH V9 mlx5-next 09/15] vfio: Define device migration
 protocol v2
In-Reply-To: <20220302083440.539a1f33.alex.williamson@redhat.com>
Organization: Red Hat GmbH
References: <20220224142024.147653-1-yishaih@nvidia.com>
 <20220224142024.147653-10-yishaih@nvidia.com> <87tucgiouf.fsf@redhat.com>
 <20220302142732.GK219866@nvidia.com>
 <20220302083440.539a1f33.alex.williamson@redhat.com>
User-Agent: Notmuch/0.34 (https://notmuchmail.org)
Date:   Wed, 02 Mar 2022 17:07:21 +0100
Message-ID: <87mti8ibie.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 02 2022, Alex Williamson <alex.williamson@redhat.com> wrote:

> On Wed, 2 Mar 2022 10:27:32 -0400
> Jason Gunthorpe <jgg@nvidia.com> wrote:
>
>> On Wed, Mar 02, 2022 at 12:19:20PM +0100, Cornelia Huck wrote:
>> > > +/*
>> > > + * vfio_mig_get_next_state - Compute the next step in the FSM
>> > > + * @cur_fsm - The current state the device is in
>> > > + * @new_fsm - The target state to reach
>> > > + * @next_fsm - Pointer to the next step to get to new_fsm
>> > > + *
>> > > + * Return 0 upon success, otherwise -errno
>> > > + * Upon success the next step in the state progression between cur_fsm and
>> > > + * new_fsm will be set in next_fsm.  
>> > 
>> > What about non-success? Can the caller make any assumption about
>> > next_fsm in that case? Because...  
>> 
>> I checked both mlx5 and acc, both properly ignore the next_fsm value
>> on error. This oddness aros when Alex asked to return an errno instead
>> of the state value.
>
> Right, my assertion was that only the driver itself should be able to
> transition to the ERROR state.  vfio_mig_get_next_state() should never
> advise the driver to go to the error state, it can only report that a
> transition is invalid.  The driver may stay in the current state if an
> error occurs here, which is why we added the ability to get the device
> state.  Thanks,
>
> Alex

So, should the function then write anything to next_fsm if it returns
-errno? (Maybe I'm misunderstanding.) Or should the caller always expect
that something may be written to new_fsm, and simply only look at it if
the function returns success?

(I think that the code as-is is likely ok, I just want to make sure I'm
not missing something. Apologies if that seems nitpicky.)

