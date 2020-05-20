Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF4DC1DB447
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 14:57:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726827AbgETM5L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 08:57:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726439AbgETM5J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 08:57:09 -0400
Received: from mail-qv1-xf30.google.com (mail-qv1-xf30.google.com [IPv6:2607:f8b0:4864:20::f30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FF1EC061A0E
        for <netdev@vger.kernel.org>; Wed, 20 May 2020 05:57:09 -0700 (PDT)
Received: by mail-qv1-xf30.google.com with SMTP id d1so1236600qvl.6
        for <netdev@vger.kernel.org>; Wed, 20 May 2020 05:57:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=NvhkpsgiFlCMhi8iFQGtwEX6GRKqAUUpVVhE3XynkAU=;
        b=hgVTZa0Toidamqjtj9i7BaX6Pf3W1DFUXWv32c2VKUZ9gJpMuTRugh7fqsHisHkIso
         qu0Ch6/1Yf6EQNG8DtYpVglovTa1Sq/fyp73SEeTVFDKMrVfHigNnHytIuEzlRXk2NHd
         Mdw+ByGUm+JErwXij8Zpgd/vAJ4LMOD+jPUqB/pwVAyI29A+cn1v5l8s3pX6J9aHGHMm
         NqymeSJxeITxYKwyZtFQ8vRNOeZcI8hzdr5kXehHqKk9JWCsRHWJsfZjLmkZpeXqCl9s
         ecfzFeijKpgzLe33W3+cxqEAKutdVFLTBiiDTbOeMIy56zR/5Nh102J8Pjyjf67Ea7S+
         4t2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=NvhkpsgiFlCMhi8iFQGtwEX6GRKqAUUpVVhE3XynkAU=;
        b=Ezk0fnj+4Onr2IKFIzEfaWS73prhFhpfwXZTA7AXHAmqG5adm3WvxGk7il3YR9NpTV
         fQdJG/WOrhZwg7aiV5tq8HGxzCsYQw7664iFVR77nY1ycHeU4xbuzd2KNBZCPf7uPgDF
         vjxkfJCrnFHORXIkmWkt64rkS7Cmay1JDDs+VfCuc+HBgeD0WgsVRy5V5D0B6iLOH+Ur
         TLbAMhIJnToPPYnuYkiHp+VhE+D1/+J49AAPSPyb+Fic9bqPc5/6fTGbwBl+rez8Tp3R
         RZ6CVZeswsZ3rctdCy9KBWOLdcihJqjaJgEFfFcpf/tbG5PwBPEbkhJx0qtAkoHU1JEq
         aFqg==
X-Gm-Message-State: AOAM532j/2mDJP4Ni3O4jle7+CBnLBk4HqP+2r8E9vERdQ4izXm1aKjL
        peOg8KseW1c/Tvmyf6RLvHv0AQ==
X-Google-Smtp-Source: ABdhPJw4S49naazllgVfN/YmWsUbmOHw54ems5BHWM36PeKPYCjqcTLRbOCPjdQ6dEq+FpNgFGJacA==
X-Received: by 2002:ad4:5684:: with SMTP id bc4mr4765167qvb.85.1589979428391;
        Wed, 20 May 2020 05:57:08 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-48-30.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.48.30])
        by smtp.gmail.com with ESMTPSA id y21sm2156720qkb.95.2020.05.20.05.57.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 20 May 2020 05:57:08 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jbOHT-0006CV-JE; Wed, 20 May 2020 09:57:07 -0300
Date:   Wed, 20 May 2020 09:57:07 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     davem@davemloft.net, gregkh@linuxfoundation.org,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        pierre-louis.bossart@linux.intel.com,
        Fred Oh <fred.oh@linux.intel.com>
Subject: Re: [net-next v4 10/12] ASoC: SOF: Introduce descriptors for SOF
 client
Message-ID: <20200520125707.GJ31189@ziepe.ca>
References: <20200520070227.3392100-1-jeffrey.t.kirsher@intel.com>
 <20200520070227.3392100-11-jeffrey.t.kirsher@intel.com>
 <20200520125437.GH31189@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200520125437.GH31189@ziepe.ca>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 20, 2020 at 09:54:37AM -0300, Jason Gunthorpe wrote:
> > +	if (!time) {
> > +		dev_err(sdev->dev, "error: probe of virtbus dev %s timed out\n",
> > +			name);
> > +		virtbus_unregister_device(vdev);
> 
> Unregister does kfree? In general I've found that to be a bad idea,
> many drivers need to free up resources after unregistering from their
> subsystem.

oops, never mind, this is the driver side it makes some sense - but
I'm not sure you should call it during error unwind anyhow. See above
about the wait being kind of bonkers..

Jason
