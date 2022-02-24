Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B8B24C324A
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 17:55:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229516AbiBXQyp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 11:54:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbiBXQyo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 11:54:44 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8D9E71CA5CF
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 08:54:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645721651;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TFzCT2dhW1N6HXXtHuDe0zCejBWeCRMYeu/iCcyBxEg=;
        b=FQtkSQsVzqgTXez/R3Up+4s4WohpPdvEazYxNBFZK+SL6Ou9jvkeph2rQEAChNDzjMjbCB
        DLrJUgA9718i2XyOd+ryuqjKJbrhEgV9h7oDLQpJmt9GdVTYVrmX8vL7bsG/tRXdmpMUfe
        kcWvDReu8hXIAFyf9WIukgqdYir2fxM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-365-yMWhBbDgPQet_wLMY1CQOg-1; Thu, 24 Feb 2022 11:54:08 -0500
X-MC-Unique: yMWhBbDgPQet_wLMY1CQOg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B3B5451DF;
        Thu, 24 Feb 2022 16:54:05 +0000 (UTC)
Received: from localhost (unknown [10.39.195.9])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5229280684;
        Thu, 24 Feb 2022 16:54:00 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, bhelgaas@google.com,
        saeedm@nvidia.com, linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, leonro@nvidia.com,
        kwankhede@nvidia.com, mgurtovoy@nvidia.com, maorg@nvidia.com,
        ashok.raj@intel.com, kevin.tian@intel.com,
        shameerali.kolothum.thodi@huawei.com
Subject: Re: [PATCH V9 mlx5-next 10/15] vfio: Extend the device migration
 protocol with RUNNING_P2P
In-Reply-To: <20220224093542.3730bb24.alex.williamson@redhat.com>
Organization: Red Hat GmbH
References: <20220224142024.147653-1-yishaih@nvidia.com>
 <20220224142024.147653-11-yishaih@nvidia.com> <87fso870k8.fsf@redhat.com>
 <20220224083042.3f5ad059.alex.williamson@redhat.com>
 <20220224161330.GA19295@nvidia.com>
 <20220224093542.3730bb24.alex.williamson@redhat.com>
User-Agent: Notmuch/0.34 (https://notmuchmail.org)
Date:   Thu, 24 Feb 2022 17:53:59 +0100
Message-ID: <87czjc6w9k.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 24 2022, Alex Williamson <alex.williamson@redhat.com> wrote:

> On Thu, 24 Feb 2022 12:13:30 -0400
> Jason Gunthorpe <jgg@nvidia.com> wrote:
>
>> On Thu, Feb 24, 2022 at 08:30:42AM -0700, Alex Williamson wrote:
>> > On Thu, 24 Feb 2022 16:21:11 +0100
>> > Cornelia Huck <cohuck@redhat.com> wrote:

>> > > conflicts with it. We should not create the impression that STOP_COPY
>> > > will neccessarily be mandatory for all time.  
>> 
>> We really *should* create that impression because a userspace that
>> does not test STOP_COPY in the cases required above is *broken* and
>> must be strongly discouraged from existing.

Well yes, you need STOP_COPY with the current implementation. I'm not
arguing against that.

>> 
>> The purpose of this comment is to inform the userspace implementator,
>> not to muse about possible future expansion options for kernel
>> developers. We all agree this expansion path exists and is valid, we
>> need to keep that option open by helping userspace implement
>> correctly.
>
> Chatting with Connie offline, I think the clarification that might help
> is something alone the lines that the combination of bits must support
> migration, which currently requires the STOP_COPY and RESUMING states.
> The VFIO_MIGRATION_P2P flag alone does not provide these states.  The
> only flag in the current specification to provide these states is
> VFIO_MIGRATION_STOP_COPY.  I don't think we want to preclude that some
> future flag might provide variants of STOP_COPY and RESUMING, so it's
> not so much that VFIO_MIGRATION_STOP_COPY is mandatory, but it is
> currently the only flag which provides the base degree of migration
> support.

Indeed.

>
> How or if that translates to an actual documentation update, I'm not
> sure.  As it stands, we're not speculating about future support, we're
> only stating these two combinations are valid.  Future combinations may
> or may not include VFIO_MIGRATION_STOP_COPY.  As the existing proposed
> comment indicates, other combinations are TBD.  Connie?  Thanks,
>
> Alex

Hm... "a flag indicating support for a migration state machine such as
VFIO_MIGRATION_STOP_COPY is mandatory"?

