Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A6352425E9
	for <lists+netdev@lfdr.de>; Wed, 12 Aug 2020 09:18:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726831AbgHLHSc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Aug 2020 03:18:32 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:57683 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726182AbgHLHSb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Aug 2020 03:18:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597216710;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=u5vnrGUSviiSyDo4A1Jti2cqm6vCb7k5wROaco57qD0=;
        b=c/IGvdeaUMKq+IP9VwQythR6qKjy9n4yJznt4Wkoy+0qBwjmgT75hgg5aAMwzALXo3Xuu+
        NahRHZ4swRKs8KnQ+B2VEgmF0+3RD6w0u1mzRW/AQn0/h6qJSDpuUa3bqvfgtXHjfksKuF
        EnEDg7QsNKbGPHkVTKTLEqcl6NpfWQo=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-324-_9FMwMsLOCCKvXJ57GW_lQ-1; Wed, 12 Aug 2020 03:18:25 -0400
X-MC-Unique: _9FMwMsLOCCKvXJ57GW_lQ-1
Received: by mail-wm1-f69.google.com with SMTP id f74so559179wmf.1
        for <netdev@vger.kernel.org>; Wed, 12 Aug 2020 00:18:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=u5vnrGUSviiSyDo4A1Jti2cqm6vCb7k5wROaco57qD0=;
        b=I2UcARneVA5YokMOworMMfPYoHhZxoMmm8JmwdXfp+8Ee3QE4sEkKEvAxe7GnzVzBA
         hYXDw6MLk+xiLPzcQl1QJ3ya1Sy4dUbQwgytjD7xkGXGpV/Wki6OA4dmDITJjnZpgoxE
         ge9o5ppKItJBsuTuHMVm2LmWgp7TPzorNNQm0dvSocYg+CWU8zMNArPBO/LPlNS3oftu
         a7MEGp5XIQq5NxhrfQCJwpWW4Tj+2/LRZPBUlPo7kQfqx4DxH7oNqWOkY3DvGX03hC8E
         5BF/NjT2ybeR8hf8ko2N46NBkMY25Y+GeIcl3hwa37Oilw1jCDDtG5jBVQa95iuqeDDG
         j1AA==
X-Gm-Message-State: AOAM5309CDgryBfdIqQAuAOEadFJahY7zMWhNc6SRLwdJkOwwYKENd9n
        rlFKYOxjE1ecVd8nhpxopCrTlRp4XMKqizkOCeXGRKdRoPNVokHjNWE/E3tfkLEIfMJpAdm30Fm
        /PN3aQj5mZhYAyjy7
X-Received: by 2002:a1c:e0d7:: with SMTP id x206mr7833383wmg.91.1597216704438;
        Wed, 12 Aug 2020 00:18:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwdYhlEIglOLVe6YV8jXLsNNRYYEwJBGXoch1voDOXD/WBMnFly08DgF2XM7EKR+k6oZDm1/g==
X-Received: by 2002:a1c:e0d7:: with SMTP id x206mr7833366wmg.91.1597216704160;
        Wed, 12 Aug 2020 00:18:24 -0700 (PDT)
Received: from steredhat ([5.180.207.22])
        by smtp.gmail.com with ESMTPSA id w1sm2236205wmc.18.2020.08.12.00.18.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Aug 2020 00:18:23 -0700 (PDT)
Date:   Wed, 12 Aug 2020 09:17:42 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     David Miller <davem@davemloft.net>
Cc:     jhansen@vmware.com, netdev@vger.kernel.org, kuba@kernel.org,
        decui@microsoft.com, linux-kernel@vger.kernel.org,
        stefanha@redhat.com
Subject: Re: [PATCH net 0/2] vsock: fix null pointer dereference and cleanup
 in vsock_poll()
Message-ID: <20200812071742.4zoxlvu44ivunsjd@steredhat>
References: <20200811095504.25051-1-sgarzare@redhat.com>
 <20200811.102418.1200203139092745562.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200811.102418.1200203139092745562.davem@davemloft.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 11, 2020 at 10:24:18AM -0700, David Miller wrote:
> From: Stefano Garzarella <sgarzare@redhat.com>
> Date: Tue, 11 Aug 2020 11:55:02 +0200
> 
> > The first patch fixes a potential null pointer dereference in vsock_poll()
> > reported by syzbot.
> > The second patch is a simple cleanup in the same block code. I put this later,
> > to make it easier to backport the first patch in the stable branches.
> 
> Please do not mix cleanups and bug fixes into the same patch series.

I did it because I was going through the same part of the code,
but I won't do it again!

> 
> net-next is closed, so you should not be submitting non-bugfixes at
> this time.
> 

I'll resend only the first patch, sorry for the noise.

Thanks,
Stefano

