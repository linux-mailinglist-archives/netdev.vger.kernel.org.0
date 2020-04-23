Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD0891B5E87
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 17:02:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728978AbgDWPCE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 11:02:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726380AbgDWPCD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 11:02:03 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1898C08ED7D
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 08:02:03 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id l25so6707726qkk.3
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 08:02:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=DLwlpyiza8pfOpInPyB6SQVmpFuV9ub52P3ivKoHw+Q=;
        b=MpTA3aBFCm1HNXFhRgmQQeLoIMXRE5UGqDxYSdKUjn3dMtCD5O4Dm+a8we/8q/899V
         rZpvs89aOPkgQ+lchUQxEorWeQTXdYjr2p34E8p0AHHkB5MvWG/oIAuSqBUXr8bEkWLy
         cbvzJyo7TzOPKNRhTwAN4DXYP7jZw1p5mq7FTkSfhWG457axz54Vg71gcRgD7AOVtL7O
         ldhq5VYg5hesDS8nRlgdq0DUjohNn960pV+1NazDUqyrlapwrVnb/0C2nwaBU3G1udKv
         Lwde1AwEmpUDxKRmhkQVS1MEhL607zBwLWha314hB+B/j7MyO05n5VMlTAXjBWHVaW22
         22rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=DLwlpyiza8pfOpInPyB6SQVmpFuV9ub52P3ivKoHw+Q=;
        b=O7l7GnW9+ZjfKJuNgVBqjbvx+UYOHz2T3YvB/AQ+O4S5MNVu2QnSgU80J0RyeY4DDv
         ype0C53zn1cvBZhljy8upUlz+elBtbwKT/vfy8ITG0qegWh1GbN3YHtPMlXPkeyMwSAO
         0o2ltcnKoDjgwnAyKuxMYygnm0hRnaWypHQGH5MXFznOaOM03cDLYGJBSvxEyYe4aKtH
         VOwm+gzbyy/ThwGPw5aBJBw5ZIIMBK6DAIXf3tgYuR1JVFHVwb+G9YRg/P65tnKSjklr
         zDkkRMy5Lk+n55zNF0n1OLENUq4GSpqLxq61Ja+cpiMnwkZPfOt7aYUK71LZEqyM8xdF
         t5uw==
X-Gm-Message-State: AGi0PubxQRaMFi+3pzFpNf2wVMBbFd7HZSg7OL1J/QkaVBfdgW2+Zn/t
        XxLYCc62t02wBUJeAqD/WusEiw==
X-Google-Smtp-Source: APiQypKaydI4/rlah4IgBC55XmvhaZ/nIcUKbMhOucAvCOsB3n1xvJZiMz/1q2AIwJCiI6OkB+bPNw==
X-Received: by 2002:a37:2e43:: with SMTP id u64mr3876337qkh.386.1587654122880;
        Thu, 23 Apr 2020 08:02:02 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id p4sm1714275qkg.48.2020.04.23.08.02.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 23 Apr 2020 08:02:02 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jRdMX-0003QP-L4; Thu, 23 Apr 2020 12:02:01 -0300
Date:   Thu, 23 Apr 2020 12:02:01 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     "Saleem, Shiraz" <shiraz.saleem@intel.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>
Subject: Re: [RFC PATCH v5 01/16] RDMA/irdma: Add driver framework definitions
Message-ID: <20200423150201.GY26002@ziepe.ca>
References: <20200417171251.1533371-1-jeffrey.t.kirsher@intel.com>
 <20200417171251.1533371-2-jeffrey.t.kirsher@intel.com>
 <20200417193421.GB3083@unreal>
 <9DD61F30A802C4429A01CA4200E302A7DCD4853F@fmsmsx124.amr.corp.intel.com>
 <20200421004628.GQ26002@ziepe.ca>
 <9DD61F30A802C4429A01CA4200E302A7DCD4A3E9@fmsmsx124.amr.corp.intel.com>
 <20200421182256.GT26002@ziepe.ca>
 <9DD61F30A802C4429A01CA4200E302A7DCD4DB92@fmsmsx124.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9DD61F30A802C4429A01CA4200E302A7DCD4DB92@fmsmsx124.amr.corp.intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 23, 2020 at 12:32:48AM +0000, Saleem, Shiraz wrote:

> we have a split initialization design for gen2 and future products.
> phase1 is control path resource initialization in irdma_probe_dev
> and phase-2 is the rest of the resources with the ib registration
> at the end of irdma_open. irdma_close must de-register the ib device
> which will take care of ibdev free too. So it makes sense to keep
> allocation of the ib device in irdma_open.

The best driver pattern is to allocate the ib_device at the very start
of probe() and use this to anchor all the device resources and
memories.

The whole close/open thing is really weird, you should get rid of it.

Jason
