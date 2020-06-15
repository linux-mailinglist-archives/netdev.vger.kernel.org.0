Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E74F01F9682
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 14:28:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729921AbgFOM2q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 08:28:46 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:57843 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728773AbgFOM2o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 08:28:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592224123;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sBg2fZ9D+qAlMaoxpCp/kIBmDKmXPzYejbkMJfk/U3o=;
        b=LVL8PUHC4lo1QapW6QIkq6KkLsLth5BOXxda97PHOvh0y4UkKzGWmD7+a2RenZS21z7i3V
        AGW2EiS7kp/zDcb8n83i5tmMyLBDaVAx4rtv6yToiosYD+dnKbU5GZBVHILMu4reKNUq4p
        6gedND1PpECjZPWeRywfXi5NuFXefTU=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-244-PtQvL8zcPO-OMd2xuxrcHg-1; Mon, 15 Jun 2020 08:28:39 -0400
X-MC-Unique: PtQvL8zcPO-OMd2xuxrcHg-1
Received: by mail-qk1-f198.google.com with SMTP id p138so14121496qke.7
        for <netdev@vger.kernel.org>; Mon, 15 Jun 2020 05:28:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sBg2fZ9D+qAlMaoxpCp/kIBmDKmXPzYejbkMJfk/U3o=;
        b=BBrNn+mFpRk4ZgE2CHqxR7fOAi7ezoF1bUJ8cyS+J9Be9dWhxTetMBkpqZm72+hd1M
         Y+Ey9E3VaD0XEMVjwIc8wHlOjCV4GUMH33ZCmLckxa6mjwehT24Y0mW1FO2eb76pYxtA
         YuQnOVzpt8d/Mv59NK4AOeXB/WBQkaynU2CIElqKVLkyd7/+oXDnq1BV/LHEA828cBIU
         iIVcruToNT+BeHoAOFQ9Pil2gHfZhTPcE3t8j14lKC5CT2BD9winH6gOmveLfee0806L
         w5RKO2UChO6aoGw+ryyXL0x7Xheijvhbw0KFk8qVBotvmKPYZF8JOILQHtpwglgDFdPj
         QY3w==
X-Gm-Message-State: AOAM533JbAz/aAsDhFaKUohxGFiaKcrfLYn71lvz1+oOQ7Nfjspvmy5T
        ezxbOqDJz3b+pS/WLJk6w7DamrQj5rzNkg8R13KJox9SZqFLtaUBJNAs4Rfqq93RM5UpQmzgQ7S
        B/jbyjzk3N0Uh3q05IcswL4V4WkWefs2T
X-Received: by 2002:a05:620a:1407:: with SMTP id d7mr14076422qkj.89.1592224119510;
        Mon, 15 Jun 2020 05:28:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyMGtIFdrgid15Y38ee12F5MvFgWU29hVuUe2nr/sf233yxjKvAmpE8PkTLK0uLOi4+pmRt8SvQU4mlzAKXbyY=
X-Received: by 2002:a05:620a:1407:: with SMTP id d7mr14076410qkj.89.1592224119276;
 Mon, 15 Jun 2020 05:28:39 -0700 (PDT)
MIME-Version: 1.0
References: <20200611113404.17810-1-mst@redhat.com> <20200611113404.17810-3-mst@redhat.com>
 <20200611152257.GA1798@char.us.oracle.com>
In-Reply-To: <20200611152257.GA1798@char.us.oracle.com>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Mon, 15 Jun 2020 14:28:03 +0200
Message-ID: <CAJaqyWdwXMX0JGhmz6soH2ZLNdaH6HEdpBM8ozZzX9WUu8jGoQ@mail.gmail.com>
Subject: Re: [PATCH RFC v8 02/11] vhost: use batched get_vq_desc version
To:     Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        linux-kernel@vger.kernel.org, kvm list <kvm@vger.kernel.org>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 11, 2020 at 5:22 PM Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
>
> On Thu, Jun 11, 2020 at 07:34:19AM -0400, Michael S. Tsirkin wrote:
> > As testing shows no performance change, switch to that now.
>
> What kind of testing? 100GiB? Low latency?
>

Hi Konrad.

I tested this version of the patch:
https://lkml.org/lkml/2019/10/13/42

It was tested for throughput with DPDK's testpmd (as described in
http://doc.dpdk.org/guides/howto/virtio_user_as_exceptional_path.html)
and kernel pktgen. No latency tests were performed by me. Maybe it is
interesting to perform a latency test or just a different set of tests
over a recent version.

Thanks!

