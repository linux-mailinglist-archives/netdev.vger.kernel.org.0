Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 375C429CB5D
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 22:40:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S374223AbgJ0VkA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 17:40:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:31525 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S374204AbgJ0Vj7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 17:39:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603834797;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iZCw4WPLIr8d65m+i6bSgryxXRO/6LdCkCTO5lQIrHo=;
        b=HlGWiGGN2+KOtUMtWDZ3t5wgM2EKRyD6LXGieYFBlbfDfbubda+LtrJ5Sf4nYWabN9WjCb
        NCUCkjsC5CLJYA3GlMPbupdFcJBwITOb7ZuJhbWP5scYWMwwBNMcbWxGSKRHhrOz3K/mVZ
        0uo1x/H/lp08wyJ5KZYmuBr5hSO6qdU=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-544-5Vmd1dBVPsa_alfO19i0uw-1; Tue, 27 Oct 2020 17:39:56 -0400
X-MC-Unique: 5Vmd1dBVPsa_alfO19i0uw-1
Received: by mail-wm1-f69.google.com with SMTP id r19so1037287wmh.9
        for <netdev@vger.kernel.org>; Tue, 27 Oct 2020 14:39:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iZCw4WPLIr8d65m+i6bSgryxXRO/6LdCkCTO5lQIrHo=;
        b=AgkeL6iY8KatQRXFLwPRWdHiYJXcwOg3fhmaX7Ssx8CyAXD9x5yNQb6KrgHKPpeXc9
         8ANShhl2YOTqtMyqQyFivX13bePfgdL7VMSYHmxdzneKshf40oZItpwkcGRHyllDDizR
         aKqBkkHvsxgVWFaILpGcHO86hEAtQ4oD6LBZ/7zOhBKaVDXabQE5E14ArhkQBrSix8X0
         J6k6/jJClkg6mqxLdRaSX2am9kFtqF6k890k9MNH6FhmCs88zXYTsVydAbKeMx/qJ5jF
         nRSJnYV1kMe5RvXKIRFw81KRD4G8US4bk4k2yFz4YSWqbPW8S3jOANvxsghPhKLMBl0r
         YtOQ==
X-Gm-Message-State: AOAM533vB8gH6Nwp+ecQzDGjO7gGKYIRDZERr7KXJAfZX7Q4opNk48fH
        Ijmo7tssCQc/u3/QsfOJQ15qtxA230qtI1PwAFKgnoSP3OicWBeEl86KKBGahV0M27+E8iNVXWL
        4fGA7z+qTS3KwkoJH
X-Received: by 2002:adf:de91:: with SMTP id w17mr4960080wrl.84.1603834794789;
        Tue, 27 Oct 2020 14:39:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx9phBNc4lOL97Hr7f0S4AXnjPGLuJ8bO5OAbdyzH28Xenkip8vJcdLSmeTF/eUu51h4bks0w==
X-Received: by 2002:adf:de91:: with SMTP id w17mr4960063wrl.84.1603834794548;
        Tue, 27 Oct 2020 14:39:54 -0700 (PDT)
Received: from pc-2.home (2a01cb058d4f8400c9f0d639f7c74c26.ipv6.abo.wanadoo.fr. [2a01:cb05:8d4f:8400:c9f0:d639:f7c7:4c26])
        by smtp.gmail.com with ESMTPSA id p4sm3609501wrf.67.2020.10.27.14.39.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2020 14:39:53 -0700 (PDT)
Date:   Tue, 27 Oct 2020 22:39:51 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Alexander Ovechkin <ovov@yandex-team.ru>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH v2 net] net/sched: act_mpls: Add softdep on mpls_gso.ko
Message-ID: <20201027213951.GA13892@pc-2.home>
References: <1f6cab15bbd15666795061c55563aaf6a386e90e.1603708007.git.gnault@redhat.com>
 <CAM_iQpVBpdJyzfexy8Vnxqa7wH0MhcxkatzQhdOtrskg=dva+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM_iQpVBpdJyzfexy8Vnxqa7wH0MhcxkatzQhdOtrskg=dva+A@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 27, 2020 at 10:28:29AM -0700, Cong Wang wrote:
> On Mon, Oct 26, 2020 at 4:23 AM Guillaume Nault <gnault@redhat.com> wrote:
> >
> > TCA_MPLS_ACT_PUSH and TCA_MPLS_ACT_MAC_PUSH might be used on gso
> > packets. Such packets will thus require mpls_gso.ko for segmentation.
> 
> Any reason not to call request_module() at run time?

So that mpls_gso would be loaded only when initialising the
TCA_MPLS_ACT_PUSH or TCA_MPLS_ACT_MAC_PUSH modes?

That could be done, but the dependency on mpls_gso wouldn't be visible
anymore with modinfo. I don't really mind, I just felt that such
information could be important for the end user.

