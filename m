Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7C5143B7B3
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 18:58:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237620AbhJZRAz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 13:00:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:36190 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236241AbhJZRAw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 13:00:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635267506;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RT0f5R5Twi94kzA8iIwbfKM5SjvkjYQA1GvTSxCPDNE=;
        b=f54oZGtek7UbhfbXwb/L9U9IOE4KpLCVGyFXhaj1E5S90MptmZvh3wb/ahckIJOUaLm6F6
        reuoTcGJjioBC0BvUM/binMvFhZtg6HWFV9Wr1O2z0bcmXzDa7VB43bEODHpYn8cF+F0Ht
        XtNjP8EXz3JCAAqPp4V8WQ9vueAlimM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-67-vCyWaVC1NYeMftwcco5klg-1; Tue, 26 Oct 2021 12:58:21 -0400
X-MC-Unique: vCyWaVC1NYeMftwcco5klg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 74BFE10A8E13;
        Tue, 26 Oct 2021 16:58:19 +0000 (UTC)
Received: from localhost (unknown [10.39.193.201])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6008160862;
        Tue, 26 Oct 2021 16:58:01 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Leon Romanovsky <leonro@nvidia.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, alex.williamson@redhat.com,
        bhelgaas@google.com, jgg@nvidia.com, saeedm@nvidia.com,
        linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, kwankhede@nvidia.com,
        mgurtovoy@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH V4 mlx5-next 06/13] vfio: Fix
 VFIO_DEVICE_STATE_SET_ERROR macro
In-Reply-To: <YXgv29Og1Ds2mMSS@unreal>
Organization: Red Hat GmbH
References: <20211026090605.91646-1-yishaih@nvidia.com>
 <20211026090605.91646-7-yishaih@nvidia.com> <87pmrrdcos.fsf@redhat.com>
 <YXgqO0/jUFvDWVHv@unreal> <87h7d3d9x3.fsf@redhat.com>
 <YXgv29Og1Ds2mMSS@unreal>
User-Agent: Notmuch/0.32.1 (https://notmuchmail.org)
Date:   Tue, 26 Oct 2021 18:57:59 +0200
Message-ID: <87bl3bd8q0.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 26 2021, Leon Romanovsky <leonro@nvidia.com> wrote:

> On Tue, Oct 26, 2021 at 06:32:08PM +0200, Cornelia Huck wrote:
>> On Tue, Oct 26 2021, Leon Romanovsky <leonro@nvidia.com> wrote:
>> 
>> > On Tue, Oct 26, 2021 at 05:32:19PM +0200, Cornelia Huck wrote:
>> >> On Tue, Oct 26 2021, Yishai Hadas <yishaih@nvidia.com> wrote:
>> >> 
>> >> > Fixed the non-compiled macro VFIO_DEVICE_STATE_SET_ERROR (i.e. SATE
>> >> > instead of STATE).
>> >> >
>> >> > Fixes: a8a24f3f6e38 ("vfio: UAPI for migration interface for device state")
>> >> > Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
>> >> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
>> >> 
>> >> This s-o-b chain looks weird; your s-o-b always needs to be last.
>> >
>> > It is not such clear as it sounds.
>> >
>> > Yishai is author of this patch and at some point of time, this patch passed
>> > through my tree and it will pass again, when we will merge it. This is why
>> > my SOB is last and not Yishai's.
>> 
>> Strictly speaking, the chain should be Yishai->you->Yishai and you'd add
>> your s-o-b again when you pick it. Yeah, that looks like overkill; the
>> current state just looks weird to me, but I'll shut up now.
>
> We will get checkpatch warning about duplicated signature.
>
> WARNING: Duplicate signature
> #11:
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> total: 0 errors, 1 warnings, 86 lines checked

...this looks more like a bug in checkpatch to me, as it is possible for
a patch to go through the same person twice.

But I'll really shut up now.

