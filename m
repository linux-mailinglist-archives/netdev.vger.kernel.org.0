Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F22C4CAAEB
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 17:56:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235475AbiCBQ5c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 11:57:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243426AbiCBQ5b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 11:57:31 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BB60C58E6A
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 08:56:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646240206;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=b+eU1DR8864lFUC8Uv63O5YGgPuk4rc7eeKnuMs6uPU=;
        b=XwD2stFzXfNv+TV2Tzm2P9vMzgx/imPe0LvdMwG8YWNPQ42i2TqA/Va6i09xp1ZaSeQtYX
        Hn2NmKbd//V3DSf8i7Q9y0cWxWTVFq5H65/dAZI0ECcMMPzWZABjYRKAr8/p9URfU50GS4
        o9UTXrNJY9QgHYg7SmXm7qshFH3SO9A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-110-MP0ok9X4PomtSMA54dc5nw-1; Wed, 02 Mar 2022 11:56:43 -0500
X-MC-Unique: MP0ok9X4PomtSMA54dc5nw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 532FA1006AA5;
        Wed,  2 Mar 2022 16:56:41 +0000 (UTC)
Received: from localhost (unknown [10.39.194.94])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D8D5B2855B;
        Wed,  2 Mar 2022 16:56:39 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>, bhelgaas@google.com,
        saeedm@nvidia.com, linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, leonro@nvidia.com,
        kwankhede@nvidia.com, mgurtovoy@nvidia.com, maorg@nvidia.com,
        ashok.raj@intel.com, kevin.tian@intel.com,
        shameerali.kolothum.thodi@huawei.com
Subject: Re: [PATCH V9 mlx5-next 09/15] vfio: Define device migration
 protocol v2
In-Reply-To: <20220302093409.1aef2b6e.alex.williamson@redhat.com>
Organization: Red Hat GmbH
References: <20220224142024.147653-1-yishaih@nvidia.com>
 <20220224142024.147653-10-yishaih@nvidia.com> <87tucgiouf.fsf@redhat.com>
 <20220302142732.GK219866@nvidia.com>
 <20220302083440.539a1f33.alex.williamson@redhat.com>
 <87mti8ibie.fsf@redhat.com>
 <20220302093409.1aef2b6e.alex.williamson@redhat.com>
User-Agent: Notmuch/0.34 (https://notmuchmail.org)
Date:   Wed, 02 Mar 2022 17:56:38 +0100
Message-ID: <87k0dci989.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 02 2022, Alex Williamson <alex.williamson@redhat.com> wrote:

> On Wed, 02 Mar 2022 17:07:21 +0100
> Cornelia Huck <cohuck@redhat.com> wrote:
>
>> On Wed, Mar 02 2022, Alex Williamson <alex.williamson@redhat.com> wrote:
>> 
>> > On Wed, 2 Mar 2022 10:27:32 -0400
>> > Jason Gunthorpe <jgg@nvidia.com> wrote:
>> >  
>> >> On Wed, Mar 02, 2022 at 12:19:20PM +0100, Cornelia Huck wrote:  
>> >> > > +/*
>> >> > > + * vfio_mig_get_next_state - Compute the next step in the FSM
>> >> > > + * @cur_fsm - The current state the device is in
>> >> > > + * @new_fsm - The target state to reach
>> >> > > + * @next_fsm - Pointer to the next step to get to new_fsm
>> >> > > + *
>> >> > > + * Return 0 upon success, otherwise -errno
>> >> > > + * Upon success the next step in the state progression between cur_fsm and
>> >> > > + * new_fsm will be set in next_fsm.    
>> >> > 
>> >> > What about non-success? Can the caller make any assumption about
>> >> > next_fsm in that case? Because...    
>> >> 
>> >> I checked both mlx5 and acc, both properly ignore the next_fsm value
>> >> on error. This oddness aros when Alex asked to return an errno instead
>> >> of the state value.  
>> >
>> > Right, my assertion was that only the driver itself should be able to
>> > transition to the ERROR state.  vfio_mig_get_next_state() should never
>> > advise the driver to go to the error state, it can only report that a
>> > transition is invalid.  The driver may stay in the current state if an
>> > error occurs here, which is why we added the ability to get the device
>> > state.  Thanks,
>> >
>> > Alex  
>> 
>> So, should the function then write anything to next_fsm if it returns
>> -errno? (Maybe I'm misunderstanding.) Or should the caller always expect
>> that something may be written to new_fsm, and simply only look at it if
>> the function returns success?
>
> Note that this function doesn't actually transition the device to
> next_fsm, it's only informing the driver what the next state is.
> Therefore I think it's reasonable to expect that the caller is never
> going to use it's actual internal device state for next_fsm.  So I
> don't really see a case where we need to worry about preserving
> next_fsm in the error condition.  Thanks,
>
> Alex

Yeah, I guess any reasonable caller won't try to pass in their internal
state. Let's hope that any stupid usuage of that interface is caught
during review :)

