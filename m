Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 628F67CCC8
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 21:33:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730935AbfGaTcy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 15:32:54 -0400
Received: from mail-ua1-f67.google.com ([209.85.222.67]:34379 "EHLO
        mail-ua1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730575AbfGaTcy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 15:32:54 -0400
Received: by mail-ua1-f67.google.com with SMTP id c4so623415uad.1
        for <netdev@vger.kernel.org>; Wed, 31 Jul 2019 12:32:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=c/NJmknjYXnLTaXRtiFYceCSSkLEpxXu+tMv/jvhB4c=;
        b=LI2KcArlX/KDX2TcyNDMmZ/ZE5cTjMJZAWURsjSV4Imlv9kH1NUViD2h4jhBiochFl
         PcBkIr6h+Ama1aEpsEKY0+YWcr4zGIYiDZeHjfAcoJ7D5bhZGrutuuXh2VyPBF/PGSWj
         rBFxsMepIBDKtn7K+Eb/QauyvOUUPBIaZeWYB7D9OTcRzYVrpta97Tts+NPdJEtxyeZT
         4mnFi5qkP9mb/xCWugLIcKxaQeVkFke1DMMaZqkdopWouBcYnmfoYEzQAihrW4DvwoYG
         gTaz79+pmrgYhwBHdPqps4krBCsM0VZnUBMsMvvHGss/KNwAXa5MNeRXmHLX55kimuyr
         zZ8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=c/NJmknjYXnLTaXRtiFYceCSSkLEpxXu+tMv/jvhB4c=;
        b=KU52Qnp35wXuQXxF4LRYqKmjrDo3zPpKhvFocTQ1ZuZRH8ZFbdEPS0U585RoHdz97n
         pxhBXe82xrU8WVLEy8aHW9dvKKrf1pQWJ8jMO2eaDDox/Z2//PFY5Q6mbN4pBrEnENWb
         IjbxLnIzOyvM8OwdN6TeW0NZYBuEpkEAVCuUbX/mJqIZNEiCJ9JjBlIqC9E3lioNec7O
         NeEARGrl862NRAidegBWmo+J3l5S5NEhGoRoX2rICeBdw17xTYmMQ//TZo2b4EIh5ra9
         qQiidOE7WT9CgVVFeWYFzL50KS6HvKvWHRgV53Ln5WJU5tPVnMXM+v43ilnO89Z1z6wE
         ARqw==
X-Gm-Message-State: APjAAAX7YRcZMIhKPlEui9Ui27slCLJDTYaaz/hb2OoeNtXJAqbfl7eQ
        hOKGuZw0O79E7lB4pHzFY+0HkQ==
X-Google-Smtp-Source: APXvYqw7F0dP8sLkKJbAjJz+H7jEhemrR3x/a26pLVHnQrJcxOczpiTadHqsEDo3aJO4KIor71NCpQ==
X-Received: by 2002:ab0:67d6:: with SMTP id w22mr11381723uar.68.1564601573050;
        Wed, 31 Jul 2019 12:32:53 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-55-100.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.55.100])
        by smtp.gmail.com with ESMTPSA id g8sm21073143vkf.21.2019.07.31.12.32.52
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 31 Jul 2019 12:32:52 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1hsuLE-0007bw-8g; Wed, 31 Jul 2019 16:32:52 -0300
Date:   Wed, 31 Jul 2019 16:32:52 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Jason Wang <jasowang@redhat.com>
Cc:     mst@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH V2 4/9] vhost: reset invalidate_count in
 vhost_set_vring_num_addr()
Message-ID: <20190731193252.GH3946@ziepe.ca>
References: <20190731084655.7024-1-jasowang@redhat.com>
 <20190731084655.7024-5-jasowang@redhat.com>
 <20190731124124.GD3946@ziepe.ca>
 <31ef9ed4-d74a-3454-a57d-fa843a3a802b@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <31ef9ed4-d74a-3454-a57d-fa843a3a802b@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 31, 2019 at 09:29:28PM +0800, Jason Wang wrote:
> 
> On 2019/7/31 下午8:41, Jason Gunthorpe wrote:
> > On Wed, Jul 31, 2019 at 04:46:50AM -0400, Jason Wang wrote:
> > > The vhost_set_vring_num_addr() could be called in the middle of
> > > invalidate_range_start() and invalidate_range_end(). If we don't reset
> > > invalidate_count after the un-registering of MMU notifier, the
> > > invalidate_cont will run out of sync (e.g never reach zero). This will
> > > in fact disable the fast accessor path. Fixing by reset the count to
> > > zero.
> > > 
> > > Reported-by: Michael S. Tsirkin <mst@redhat.com>
> > Did Michael report this as well?
> 
> 
> Correct me if I was wrong. I think it's point 4 described in
> https://lkml.org/lkml/2019/7/21/25.

I'm not sure what that is talking about

But this fixes what I described:

https://lkml.org/lkml/2019/7/22/554

Jason
