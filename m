Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 596DA1E1312
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 18:55:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389243AbgEYQzI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 12:55:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388093AbgEYQzH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 12:55:07 -0400
Received: from mail-qv1-xf34.google.com (mail-qv1-xf34.google.com [IPv6:2607:f8b0:4864:20::f34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D406CC061A0E
        for <netdev@vger.kernel.org>; Mon, 25 May 2020 09:55:06 -0700 (PDT)
Received: by mail-qv1-xf34.google.com with SMTP id v15so8265356qvr.8
        for <netdev@vger.kernel.org>; Mon, 25 May 2020 09:55:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=vIhfX/nLxz4zC4XGXmvwEIkgcpXWnXVmLpEPqcDbepU=;
        b=XOCr/N5ndAnUb/ExUIV5beBvtjSHcKHsFrRinxaFMrP8qaXvIQ5FsIHrXyMd/eEwYV
         rfdhXJMevDmM16Kp6tCm+8rUwOOApSJdKq6ouF/BouBSn6FnJi+CVBbWDK5uZWuz5tV2
         Ms/09dnTA6/yEKhm945A1dsIXiSlm3TNFjsmBY89mz31r7ceRRS6hPYxyTJeiNGTPE6l
         loAOlqlSszNcvoWSysHP42jVLIIBj3AZrpDsOMoNRplGZKXMPBLrot31JTfpPLnsW98G
         qT7RJcYj9j9UTOmkp+JKbAKtcSy0qVcxpVxoNeolNs5JvE8Nqp1VBHmdDLSWZsU/ac9n
         BSOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=vIhfX/nLxz4zC4XGXmvwEIkgcpXWnXVmLpEPqcDbepU=;
        b=r5fzifDi1xltLd8htPDnSjwLFpnilEBckZ41IQxQjFnbQJKv43xwZmTzTqGeLQxerd
         Gavfhm5b4A58w2SzvBMZDOHkbOG8ORp892k3+pZWHj/7tA527Gpc6S/Cm9wpb32PyHYD
         LMIpLmdoDGSt0lv74A56V0T2TtfXa2KoGyHWnLerESst3DkqnpgQWZ2MyNtog8ZWXJ5w
         kH41/Lq3UyCqfXhkkUqsipij1ttvMSM0txUcWb3pfKYtrTiSt4+JH8qKsVnbjkTH5kRa
         iNl4bUXGFcyPexrPYV5NXERcrDX2/QO2UvS6xF/3gtcBs1tXhSXzZEv8/1WbSpd8L/7C
         E26g==
X-Gm-Message-State: AOAM532uMxLTFKs1dGcfI0v+cTwge9Ck/e9RAlUMAodDCdixgG1rWSGg
        I6GfW9Af5k39F9w6bcJSpeVFkvb5c2E=
X-Google-Smtp-Source: ABdhPJxK1zEVfqxlpD/QX2DC0R9zcVQLTgTCktLoTl0G8UJMEQnX8szc+AwgIdZ7U2gZu4tPRlCzIA==
X-Received: by 2002:a0c:a98d:: with SMTP id a13mr492750qvb.157.1590425706038;
        Mon, 25 May 2020 09:55:06 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-48-30.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.48.30])
        by smtp.gmail.com with ESMTPSA id u205sm2265383qka.81.2020.05.25.09.55.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 25 May 2020 09:55:05 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jdGNU-0003gc-U8; Mon, 25 May 2020 13:55:04 -0300
Date:   Mon, 25 May 2020 13:55:04 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com, Fred Oh <fred.oh@linux.intel.com>
Subject: Re: [net-next v4 10/12] ASoC: SOF: Introduce descriptors for SOF
 client
Message-ID: <20200525165504.GF744@ziepe.ca>
References: <20200520070227.3392100-1-jeffrey.t.kirsher@intel.com>
 <20200520070227.3392100-11-jeffrey.t.kirsher@intel.com>
 <20200520125437.GH31189@ziepe.ca>
 <08fa562783e8a47f857d7f96859ab3617c47e81c.camel@linux.intel.com>
 <20200521233437.GF17583@ziepe.ca>
 <7abfbda8-2b4b-5301-6a86-1696d4898525@linux.intel.com>
 <20200523062351.GD3156699@kroah.com>
 <57185aae-e1c9-4380-7801-234a13deebae@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <57185aae-e1c9-4380-7801-234a13deebae@linux.intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 23, 2020 at 02:41:51PM -0500, Pierre-Louis Bossart wrote:

> If yes, that's yet another problem... During the PCI probe, we start a
> workqueue and return success to avoid blocking everything. And only 'later'
> do we actually create the card. So that's two levels of probe that cannot
> report a failure. I didn't come up with this design, IIRC this is due to
> audio-DRM dependencies and it's been used for 10+ years.

I think there are more tools now than 10 years ago, maybe it is time
to revisit designs like this - clearly something is really wrong with
it based on your explanations.

Jason
