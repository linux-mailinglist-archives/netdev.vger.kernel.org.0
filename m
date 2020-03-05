Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A513F17A385
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 11:58:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727198AbgCEK6I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 05:58:08 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38031 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726048AbgCEK6H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 05:58:07 -0500
Received: from mail-wm1-f72.google.com ([209.85.128.72])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <andrea.righi@canonical.com>)
        id 1j9oCb-0003eb-3a
        for netdev@vger.kernel.org; Thu, 05 Mar 2020 10:58:05 +0000
Received: by mail-wm1-f72.google.com with SMTP id w3so1425667wmg.4
        for <netdev@vger.kernel.org>; Thu, 05 Mar 2020 02:58:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=udGZa6zUTBnjvV9RDovAxlAbvCOTgp2vn9poHckj0LU=;
        b=PKkQecrCa8D4wlOs9njVE8+REztyXTZnc9pNbWU6w3jINsUUbFr2uILLFHck+pOyKq
         gG7lQYfqm2KgwiDSUzw+TqUWCS7tetCAQS9tLTDQr/OpWCcCX5QpPw37pS0ql5vYb3AN
         majW8MLDDkNmWAljUVsujxifszA+zSPgVAJVmozi3yH/oVlf0tMPr87LCOFp8l1IWBXV
         8Bi/ltGRfMJ22ylfIvI7nK1XcInWS1Wnyz7CQD6mYQpP2/TUKECxHJ7fk7Hiz14GbC7x
         o62HxREcWOKn6g2fjegKIre0IOooO6LuFVLj1BbFNXfQsmY34k6gx1W2trtDiNN25vqH
         ndrw==
X-Gm-Message-State: ANhLgQ1Qd5qVsoc6nPL3B/S5/QTBHQ1Bo3ruT2oiceuCYSCFMokIEFF8
        h2ymJ/qShaDHAKBnnb4hlo+Rbo9Ee6Jp6RJSPNCdyMGDf07llRYrMdY7bynOKbLYQqT2uZMYfn3
        bMtSK0NfEYhquQ6aC/qkLqLwE5JXsdLbbqw==
X-Received: by 2002:a5d:4389:: with SMTP id i9mr8893032wrq.90.1583405884725;
        Thu, 05 Mar 2020 02:58:04 -0800 (PST)
X-Google-Smtp-Source: ADFU+vv4iMXGTqqE+qve6h7wkGy0rppGrS96fNmwqzfIXN3ymTQ0oUkPnpqY9TxcelI6qvl2thhWSQ==
X-Received: by 2002:a5d:4389:: with SMTP id i9mr8893000wrq.90.1583405884377;
        Thu, 05 Mar 2020 02:58:04 -0800 (PST)
Received: from localhost (host96-127-dynamic.32-79-r.retail.telecomitalia.it. [79.32.127.96])
        by smtp.gmail.com with ESMTPSA id w17sm12798445wrm.92.2020.03.05.02.58.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Mar 2020 02:58:03 -0800 (PST)
Date:   Thu, 5 Mar 2020 11:58:02 +0100
From:   Andrea Righi <andrea.righi@canonical.com>
To:     Vladis Dronov <vdronov@redhat.com>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ptp: free ptp clock properly
Message-ID: <20200305105802.GD267906@xps-13>
References: <20200304175350.GB267906@xps-13>
 <1830360600.13123996.1583352704368.JavaMail.zimbra@redhat.com>
 <20200305073653.GC267906@xps-13>
 <1136615517.13281010.1583405254370.JavaMail.zimbra@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1136615517.13281010.1583405254370.JavaMail.zimbra@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 05, 2020 at 05:47:34AM -0500, Vladis Dronov wrote:
> Hello, Andrea, all,
> 
> > > I would guess that a kernel in question (5.3.0-40-generic) has the commit
> > > a33121e5487b but does not have the commit 75718584cb3c, which should be
> > > exactly fixing a docking station disconnect crash. Could you please,
> > > check this?
> > 
> > Unfortunately the kernel in question already has 75718584cb3c:
> > https://git.launchpad.net/~ubuntu-kernel/ubuntu/+source/linux/+git/bionic/commit/?h=hwe&id=c71b774732f997ef38ed7bd62e73891a01f2bbfe
> > 
> > It looks like there's something else that can free up too early the
> > resources required by posix_clock_unregister() to destroy the related
> > sysfs files.
> > 
> > Maybe what we really need to call from ptp_clock_release() is
> > pps_unregister_source()? Something like this:
> 
> Err... I believe, "Maybe" is not a good enough reason to accept a kernel patch.
> Probably, there should be something supporting this statement.

Indeed. :) I've asked the original bug reporter to repeat the test with
this patch. Let's see if we can still reproduce the failure...

Thanks,
-Andrea
