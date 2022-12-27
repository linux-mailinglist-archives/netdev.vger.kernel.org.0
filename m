Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FB776567AF
	for <lists+netdev@lfdr.de>; Tue, 27 Dec 2022 08:06:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbiL0HGl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Dec 2022 02:06:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbiL0HGb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Dec 2022 02:06:31 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F14D8E9F
        for <netdev@vger.kernel.org>; Mon, 26 Dec 2022 23:05:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672124751;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=t6B+5aJ0Guf5xJnrVgDQJOLVwGWWIObpNI/iqDeXCf0=;
        b=DMfUiOypcJmoTtD6ujp5Phb/18wh+dg2Glh9K9kVjR6INa49jhtk/B4pddLuYtP03kuLgh
        t4h5PpHdKx8r8KZhHOS6kjCMSfidwzEC2zCWCsXZWc8U1zBeCW8lqx2gtPZvnarpLUeI/U
        Jlk8Y6J3/61KN63Vwajhohp77WuPqxA=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-195-VyqNtXfbP6COYai4Mf_hIw-1; Tue, 27 Dec 2022 02:05:47 -0500
X-MC-Unique: VyqNtXfbP6COYai4Mf_hIw-1
Received: by mail-wm1-f72.google.com with SMTP id fm25-20020a05600c0c1900b003d9702a11e5so4905496wmb.0
        for <netdev@vger.kernel.org>; Mon, 26 Dec 2022 23:05:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t6B+5aJ0Guf5xJnrVgDQJOLVwGWWIObpNI/iqDeXCf0=;
        b=7UF8uMCqm6nkd7YJ19BD3CRlXXPFlpRyYkEFDvTW8aBzshiyU+gAeWdWfUwuz2i8VN
         +dve0v7IxHLYhfF681xukL4M7XevsGd3gsiELbIrxCApUoMozzdouvF4cUk4VoDAGVKd
         ohCMaW2LLnfpsVbd2MTUuuljBYPBPV9ajXs78CkejeauFCV0dDUEWc1TecbVadX7//nm
         LH0KC2mLQid+xSNshnlV9ec+D/cA7jbdWSG5ubl+JZ+aWA5XiEtGAAVPKmAReATASn03
         Y/wMgEmc0xnnNrR4EXp35ukK9n/hUXH7Pmn803RarHlZW9Y/BI98u1ad+8Cn6NzzNpTv
         AsFQ==
X-Gm-Message-State: AFqh2kobZiTycKReSfAKLEH64Cq+Seiq8a1YhcIeZOT6NSj5n4jiP85d
        i5nZNzY5RnAkjsrLEOXPeJQJU66pCJPR6ogGZmjBL1oZqjc2FImWoODHkrpW1WHnnWYVDva9B2+
        SoFVUOEd2gPKK11KA
X-Received: by 2002:a05:600c:3789:b0:3d1:f234:12cc with SMTP id o9-20020a05600c378900b003d1f23412ccmr14917378wmr.33.1672124746361;
        Mon, 26 Dec 2022 23:05:46 -0800 (PST)
X-Google-Smtp-Source: AMrXdXv7VxVFTlp1bWTB6ltmdqn/ESzBZWCVVlTMmPA5egsFORFko71Rv1M6SSn/w7ah7B/gMr/N1w==
X-Received: by 2002:a05:600c:3789:b0:3d1:f234:12cc with SMTP id o9-20020a05600c378900b003d1f23412ccmr14917367wmr.33.1672124746164;
        Mon, 26 Dec 2022 23:05:46 -0800 (PST)
Received: from redhat.com ([2.52.151.85])
        by smtp.gmail.com with ESMTPSA id he11-20020a05600c540b00b003d359aa353csm15894121wmb.45.2022.12.26.23.05.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Dec 2022 23:05:45 -0800 (PST)
Date:   Tue, 27 Dec 2022 02:05:42 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Shunsuke Mie <mie@igel.co.jp>,
        Rusty Russell <rusty@rustcorp.com.au>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 2/9] vringh: remove vringh_iov and unite to
 vringh_kiov
Message-ID: <20221227020425-mutt-send-email-mst@kernel.org>
References: <20221227022528.609839-1-mie@igel.co.jp>
 <20221227022528.609839-3-mie@igel.co.jp>
 <CACGkMEtAaYpuZtS0gx_m931nFzcvqSNK9BhvUZH_tZXTzjgQCg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACGkMEtAaYpuZtS0gx_m931nFzcvqSNK9BhvUZH_tZXTzjgQCg@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 27, 2022 at 02:04:03PM +0800, Jason Wang wrote:
> On Tue, Dec 27, 2022 at 10:25 AM Shunsuke Mie <mie@igel.co.jp> wrote:
> >
> > struct vringh_iov is defined to hold userland addresses. However, to use
> > common function, __vring_iov, finally the vringh_iov converts to the
> > vringh_kiov with simple cast. It includes compile time check code to make
> > sure it can be cast correctly.
> >
> > To simplify the code, this patch removes the struct vringh_iov and unifies
> > APIs to struct vringh_kiov.
> >
> > Signed-off-by: Shunsuke Mie <mie@igel.co.jp>
> 
> While at this, I wonder if we need to go further, that is, switch to
> using an iov iterator instead of a vringh customized one.
> 
> Thanks

Possibly, but when doing changes like this one needs to be careful
to avoid breaking all the inlining tricks vringh relies on for
performance.

-- 
MST

