Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ECC22CDD2F
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 19:18:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727329AbgLCSRK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 13:17:10 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26719 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726312AbgLCSRJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 13:17:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607019343;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5UJmIrtebEeIb+aQQtEy57TDaJTv2bPv6VhHOCsT/Z0=;
        b=hJU7JT3i7e8x5+REwL9ms1aUoo1eO41VZ2Ak3N7SC0gdsLiT2OABglIJmxyBawg20sj2Bq
        7o4pTl7o1kFRr31hSNVZEQAmCi32ft+XbbwO6WsfiR/OmTYlZ9s7EynnUA6OOqO4YeHgPL
        VR8ey0/J5oIJ0fdMqavNjM4xwMiL8Fc=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-591-ac5LZyJNOo2wyTqOjm_A-A-1; Thu, 03 Dec 2020 13:15:40 -0500
X-MC-Unique: ac5LZyJNOo2wyTqOjm_A-A-1
Received: by mail-wr1-f70.google.com with SMTP id n13so1539037wrs.10
        for <netdev@vger.kernel.org>; Thu, 03 Dec 2020 10:15:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5UJmIrtebEeIb+aQQtEy57TDaJTv2bPv6VhHOCsT/Z0=;
        b=nCBrPZLTyceBSmjkPb3PLk8ex2RldAkw0bVqmn0enZuEe9YCi0RI2/MYgBZj1g7ohV
         fCFklxePxtaE3llx27O+u2nGsoVlIOZZib70nnylAhSCGZCrvzPoKcN0uZIlSEgEkQk0
         pt+enwPhO4geSezziXyxUWGJhTNXR84/Kwc5M4Nghgjfxi0n9qzaG6vsJmR+M4fqTiaS
         GpUAMV27to2cP4kc1+MiWlH+COdcrGRuv/299VfPBQ4yKICMePqygdnoUJuGWCpCGZmv
         a0WfIvvIm5eQCM+CmiJkMSBJue8bwUXKZ/BPUsuWvQYOzqJF8FKcyg7ND2/DDe+UHNpV
         Uh0w==
X-Gm-Message-State: AOAM530aOX12p2fOW8eDVD+mDxtYtwROt0FkulF4aDr9Nk1yoyV97XR+
        dizi+VDV++kWO843+1SPDT9Yv0no2HZz+Su6MfMYmge1xHx1pNGmWj6fDWm2dBZ2BVoqNDt5ZyJ
        vIwHnF9sxrRSxyWjU
X-Received: by 2002:a5d:4641:: with SMTP id j1mr509739wrs.94.1607019339251;
        Thu, 03 Dec 2020 10:15:39 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzbIi7PLJ1FwowvOH24DQ79sMfQyPAcvszKEKrPBwZx0qc6IGHtRYx1+vkTmatvusrzlYXKbw==
X-Received: by 2002:a5d:4641:: with SMTP id j1mr509722wrs.94.1607019339080;
        Thu, 03 Dec 2020 10:15:39 -0800 (PST)
Received: from linux.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id u85sm155575wmu.43.2020.12.03.10.15.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Dec 2020 10:15:38 -0800 (PST)
Date:   Thu, 3 Dec 2020 19:15:36 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     jhs@mojatatu.com, jiri@resnulli.us,
        Cong Wang <xiyou.wangcong@gmail.com>, kuba@kernel.org,
        netdev@vger.kernel.org, marcelo.leitner@gmail.com,
        John Hurley <john.hurley@netronome.com>
Subject: Re: [PATCH net v2] net/sched: act_mpls: ensure LSE is pullable
 before reading it
Message-ID: <20201203181536.GB2735@linux.home>
References: <3243506cba43d14858f3bd21ee0994160e44d64a.1606987058.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3243506cba43d14858f3bd21ee0994160e44d64a.1606987058.git.dcaratti@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 03, 2020 at 10:37:52AM +0100, Davide Caratti wrote:
> when 'act_mpls' is used to mangle the LSE, the current value is read from
> the packet dereferencing 4 bytes at mpls_hdr(): ensure that the label is
> contained in the skb "linear" area.

Acked-by: Guillaume Nault <gnault@redhat.com>

