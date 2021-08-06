Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 337D83E2475
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 09:50:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241355AbhHFHuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 03:50:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:52028 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241186AbhHFHuO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Aug 2021 03:50:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628236198;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L/XAQHsDYCO+RIwBULn3V8152VMpaegY7HPopBgGtwM=;
        b=RsjW/K53EhLfeq6m9W+A2l/qPGHGIbRfQnUJxZFVwXeVAxgVP5ICNyCqtL35femXuVjQOo
        PaFx0PZEHCFVZ7jpf/5VPjDhSxw9+35+FWymgfH93ZofMRXnHfrPudVsxgKuGkuVZzfDDY
        F9wnsgKE6pk2xKaiwiFGRk+l71Exp7I=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-288-hLAo-GTCPS-Pu_hDcayiMg-1; Fri, 06 Aug 2021 03:49:56 -0400
X-MC-Unique: hLAo-GTCPS-Pu_hDcayiMg-1
Received: by mail-wm1-f70.google.com with SMTP id o67-20020a1ca5460000b0290223be6fd23dso1740165wme.1
        for <netdev@vger.kernel.org>; Fri, 06 Aug 2021 00:49:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=L/XAQHsDYCO+RIwBULn3V8152VMpaegY7HPopBgGtwM=;
        b=PA0Fb4vdZh7bFOHN237jtA7Tf0Fqh8us47iC2ALJViSQDApGL0QATG32HED7PDuRVI
         0gCvwNE9ATSGbMyk6AKJnDJhfWsygvoNGEjsqWkoIrwyJcsjqsLQ/ALQKfDGyQp/pxzb
         IQoV4bj1CfAV8Jk1FlQ5je07Gge5227lU3MNuuoH9G4DkJ1hQZiBjqFhLWNwyjHAABde
         lZU0vWm4VuRFiKBAnDnt1wkOyZXQrGI0xxGxXOf05hJNBVZvthGhpENu+rthfPfOaBGn
         t/lnnGpKutKGdTzlqAxBoq3HrolBl203oExb1COnGagaXoFB21kKPeC/hG6jHuYf/bG1
         +WBg==
X-Gm-Message-State: AOAM530w5X1707hkpmYnhQAKQI+pjsFrzGTHAF8EMIKbK0rbq+3R8q0x
        FAtSLdvX4wvHRQOZkj9yeIrf+Xfy9592LqMBqLh5X2DIPkfczcRPdHYg9UzHtdC/bKJNdxVHjnU
        FwBpMsbNeK3SlMCmF
X-Received: by 2002:a1c:4487:: with SMTP id r129mr18557025wma.62.1628236195568;
        Fri, 06 Aug 2021 00:49:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwuc7Cgq9/1x/vHrvrkqXmHMzhrekrhaEMX/jbQhwO2cwiVTeBB6Y8XuABTzXxSJtxK4sbB7g==
X-Received: by 2002:a1c:4487:: with SMTP id r129mr18557010wma.62.1628236195293;
        Fri, 06 Aug 2021 00:49:55 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-240-80.dyn.eolo.it. [146.241.240.80])
        by smtp.gmail.com with ESMTPSA id h16sm8526236wre.52.2021.08.06.00.49.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Aug 2021 00:49:55 -0700 (PDT)
Message-ID: <dea381f16949a076860a550ae1db91dcca935f8f.camel@redhat.com>
Subject: Re: [PATCH net-next 1/2] selftests/net: GRO coalesce test
From:   Paolo Abeni <pabeni@redhat.com>
To:     Coco Li <lixiaoyan@google.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        Willem de Bruijn <willemb@google.com>,
        Tanner Love <tannerlove@google.com>
Date:   Fri, 06 Aug 2021 09:49:53 +0200
In-Reply-To: <CADjXwjhvb9BVNPjY2f-4yfE51RGL88U3VbiN_gwaMSGbagzQEg@mail.gmail.com>
References: <20210805073641.3533280-1-lixiaoyan@google.com>
         <20210805073641.3533280-2-lixiaoyan@google.com>
         <6595b716cb0b37e9daf4202163b4567116d4b4e2.camel@redhat.com>
         <CADjXwjhvb9BVNPjY2f-4yfE51RGL88U3VbiN_gwaMSGbagzQEg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Thu, 2021-08-05 at 13:17 -0700, Coco Li wrote:
> > Have you considered additionally run the same test of top of a veth
> > pair, and have such tests always enabled, so we could have some
> > coverage regardless of specific H/W available?
> 
> > To do the above you should disable TSO on the veth sender peer and
> > enable GRO on the other end.
> 
> Thanks for the suggestion! To make sure I understand you correctly,
> would this be another script that creates the veth pair separate from
> the gro.sh wrapper?

I personally don't have any strict preference. I *think* the veth
thing could still fit the gro.sh script, but whatever is easier coding
wise would fit. 

The gro.sh script with no/default argument could run all the tests on a
veth pair; if a device name is specified via the command line, it could
additionally run (the specified set of tests) on such device.

Cheers,

Paolo



