Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1811123B0AD
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 01:08:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729004AbgHCXGa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 19:06:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726805AbgHCXGa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 19:06:30 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E033CC06174A
        for <netdev@vger.kernel.org>; Mon,  3 Aug 2020 16:06:29 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id h7so36778637qkk.7
        for <netdev@vger.kernel.org>; Mon, 03 Aug 2020 16:06:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wAUE6jUn5mAwPKG/Q4g9vNtYtEutYsrwV5EW4m6aKOU=;
        b=aQPbnrjunrUlMKPJZCkOu9GiuwLThf4AAYXaSayDvpYZIe0S0J5kWgrEUjiDBH9If6
         Nk9QNCh3nxu8CXdo+xB/HLA8CehJ2h3vX8mFXWeKtG4Ehnv/lG4XUFRHkTOmDmx2Gu+t
         isoDrdskWg1Yq4JaJ2gyFOMQASXHDC3AOHQFV8jXqTkjjMH9OISCb5l703LpOA/etz3n
         Odi5KMRaQBfXsQRPGtsPxY+h2Mu3CS08N6pHNkSCakHEE7/ei6ZPcuVPeLMgC98An320
         u+suEZDSIIjWB+8Yuby/tpgOMJBQQty/fmvjkfvWZZTaQmoN4l3AusKGnGnuiBnLxtgp
         mMmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wAUE6jUn5mAwPKG/Q4g9vNtYtEutYsrwV5EW4m6aKOU=;
        b=Xuv0QziI+hnlb1eRF8EjN9+OOAS04jOqi23eEPO7vX2n91ushJI1QnriP1rcrEswTR
         h3UKn6N17TWp9vSfnzK6XOr/tTgatBh5RuDE0iI08iRmyOPA3vcBR2EUUH7vxCrb1OwV
         Mr/waLztjPqkrKmhfBpiAxsm4wxBKA2Zm/XjGGdfR8A5jBghDarH2vBTrICb+8p4Snyd
         ifcT8XwNSZ0o0i0aEm0WgVCANNyRAsLjM73XJp5jYD/aXH1wwe8yr6J1T01966OrL16V
         YF5rF2GOuoS1Mhs693XpRrejVnfI3zurVyVM13JUW65Zk6dENkfu9oAeQRZ4XfnpkF9T
         VnKQ==
X-Gm-Message-State: AOAM533BaWMYxEgPSj/QDYwyFyihMFE+Sed8C8/mp4/k6v2M1XT4GVXt
        kpn17/b1UBjokqMhuDDbtcTtuw==
X-Google-Smtp-Source: ABdhPJyd0Tryhkzt206/Jh2HMiFEcuAT06LpeX3boAviXZIf/eRMRzhVp8FyjqPcmsR8tNjqSdSpPA==
X-Received: by 2002:a37:649:: with SMTP id 70mr18613154qkg.318.1596495988988;
        Mon, 03 Aug 2020 16:06:28 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-48-30.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.48.30])
        by smtp.gmail.com with ESMTPSA id 9sm22473777qtg.4.2020.08.03.16.06.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2020 16:06:27 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1k2jXH-0039ha-72; Mon, 03 Aug 2020 20:06:27 -0300
Date:   Mon, 3 Aug 2020 20:06:27 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Joe Perches <joe@perches.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peilin Ye <yepeilin.cs@gmail.com>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [Linux-kernel-mentees] [PATCH net] rds: Prevent kernel-infoleak
 in rds_notify_queue_get()
Message-ID: <20200803230627.GQ24045@ziepe.ca>
References: <20200731053333.GB466103@kroah.com>
 <20200731140452.GE24045@ziepe.ca>
 <20200731142148.GA1718799@kroah.com>
 <20200731143604.GF24045@ziepe.ca>
 <20200731171924.GA2014207@kroah.com>
 <20200801053833.GK75549@unreal>
 <20200802221020.GN24045@ziepe.ca>
 <fb7ec4d4ed78e6ae7fa6c04abb24d1c00dc2b0f7.camel@perches.com>
 <20200802222843.GP24045@ziepe.ca>
 <60584f4c0303106b42463ddcfb108ec4a1f0b705.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <60584f4c0303106b42463ddcfb108ec4a1f0b705.camel@perches.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 02, 2020 at 03:45:40PM -0700, Joe Perches wrote:
> On Sun, 2020-08-02 at 19:28 -0300, Jason Gunthorpe wrote:
> > On Sun, Aug 02, 2020 at 03:23:58PM -0700, Joe Perches wrote:
> > > On Sun, 2020-08-02 at 19:10 -0300, Jason Gunthorpe wrote:
> > > > On Sat, Aug 01, 2020 at 08:38:33AM +0300, Leon Romanovsky wrote:
> > > > 
> > > > > I'm using {} instead of {0} because of this GCC bug.
> > > > > https://gcc.gnu.org/bugzilla/show_bug.cgi?id=53119
> > > > 
> > > > This is why the {} extension exists..
> > > 
> > > There is no guarantee that the gcc struct initialization {}
> > > extension also zeros padding.
> >
> > We just went over this. Yes there is, C11 requires it.
> 
> c11 is not c90.  The kernel uses c90.

The kernel already relies on a lot of C11/C99 features and
behaviors. For instance Linus just bumped the minimum compiler version
so that C11's _Generic is usable.

Why do you think this particular part of C11 shouldn't be relied on?

Jason
