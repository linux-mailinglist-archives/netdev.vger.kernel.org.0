Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AE0B41B83E
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 22:18:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242736AbhI1UUe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 16:20:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:55225 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232756AbhI1UU2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Sep 2021 16:20:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632860328;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6ty+2QJnNc2ErgiU8OvTWlQKFe+mg73c0FaGXapyCUI=;
        b=LvO954vo87napXaGvSpbesqcOibkIb+6cHx72+uulazBnROn7H5eO/l7YnhhXwOjgnvkbI
        2lm3jPI+3cro4AU/kiE3nA3NkqZO3FTVrG5p5YvdiyXKYtXAJyWRSLqjpH0YdbbspJbwUV
        DSTxrbFwt7Aqf/JCyWhpSgxr0tYWmVQ=
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com
 [209.85.167.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-49-mydcnn-aMdyWZMTOxUTnaA-1; Tue, 28 Sep 2021 16:18:46 -0400
X-MC-Unique: mydcnn-aMdyWZMTOxUTnaA-1
Received: by mail-oi1-f200.google.com with SMTP id o185-20020acad7c2000000b0026b63b5c3f4so20902752oig.18
        for <netdev@vger.kernel.org>; Tue, 28 Sep 2021 13:18:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6ty+2QJnNc2ErgiU8OvTWlQKFe+mg73c0FaGXapyCUI=;
        b=WkUZ+PZIyN3QebkhOPojV+XApkayW+BXN9+0lZkxrSBf17JFdUvtbazqPqqGlWRX1/
         Du7Zhtl2Xqb46wshl0bm2/s7VWmLejdAyhAo8C88K5wUH+qHmYEc1sJWGmDYDBaDGdux
         UDWUsxel/Jr3IMZ5UHE3PIIZvEwd0zpw4lxenYQ/ZbT2MqMErNBAfsFcP6QfZpFfmIHj
         L5LDPtGy11cGcFrfqtYrc/lIal+VYx/QSQwSkQnWDLBoSE5dSLfDcVGdvrQJjf4ydpB4
         bVQ4C/JTsEIFSWpBSJkVyS4imQCdpi+MrFd4VigZGh17hV5HIGQ5tHfD79SUOLfi/uEi
         uprA==
X-Gm-Message-State: AOAM533WR9d1wfLkgiJ1FJshZM+kcBgO6isITgM4OXZNaCe3LQN+fTf2
        bBI8ytjW+Bs8GhmfDE9K4z9z5amWsg8r8M3dUrThlSEs8UrNzeUUjNV+id1NJ6Ln8xdw3eBUZyT
        Ij3D7i766hO7BCUty
X-Received: by 2002:a05:6808:1911:: with SMTP id bf17mr4993808oib.91.1632860326167;
        Tue, 28 Sep 2021 13:18:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxnEF+jm/cVpFs6w3fcZqtlMjJaCj4YFZYEjO6KmAyfvS+riQgxI4FMp9dgwGaUsxOL1EiLxA==
X-Received: by 2002:a05:6808:1911:: with SMTP id bf17mr4993786oib.91.1632860325974;
        Tue, 28 Sep 2021 13:18:45 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id p18sm28234otk.7.2021.09.28.13.18.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Sep 2021 13:18:45 -0700 (PDT)
Date:   Tue, 28 Sep 2021 14:18:44 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Doug Ledford <dledford@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>
Subject: Re: [PATCH mlx5-next 2/7] vfio: Add an API to check migration state
 transition validity
Message-ID: <20210928141844.15cea787.alex.williamson@redhat.com>
In-Reply-To: <20210928193550.GR3544071@ziepe.ca>
References: <cover.1632305919.git.leonro@nvidia.com>
        <c87f55d6fec77a22b110d3c9611744e6b28bba46.1632305919.git.leonro@nvidia.com>
        <20210927164648.1e2d49ac.alex.williamson@redhat.com>
        <20210927231239.GE3544071@ziepe.ca>
        <20210928131958.61b3abec.alex.williamson@redhat.com>
        <20210928193550.GR3544071@ziepe.ca>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 28 Sep 2021 16:35:50 -0300
Jason Gunthorpe <jgg@ziepe.ca> wrote:

> On Tue, Sep 28, 2021 at 01:19:58PM -0600, Alex Williamson wrote:
> 
> > In defining the device state, we tried to steer away from defining it
> > in terms of the QEMU migration API, but rather as a set of controls
> > that could be used to support that API to leave us some degree of
> > independence that QEMU implementation might evolve.  
> 
> That is certainly a different perspective, it would have been
> better to not express this idea as a FSM in that case...
> 
> So each state in mlx5vf_pci_set_device_state() should call the correct
> combination of (un)freeze, (un)quiesce and so on so each state
> reflects a defined operation of the device?

I'd expect so, for instance the implementation of entering the _STOP
state presumes a previous state that where the device is apparently
already quiesced.  That doesn't support a direct _RUNNING -> _STOP
transition where I argued in the linked threads that those states
should be reachable from any other state.  Thanks,

Alex

