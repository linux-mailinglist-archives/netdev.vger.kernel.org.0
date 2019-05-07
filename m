Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFECA16D14
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 23:22:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727273AbfEGVW1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 17:22:27 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:34910 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726582AbfEGVW1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 May 2019 17:22:27 -0400
Received: by mail-qt1-f196.google.com with SMTP id d20so3287719qto.2
        for <netdev@vger.kernel.org>; Tue, 07 May 2019 14:22:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=qKJrOarY2DKNHpkAcDz+cQOZGHxGEuN8oZtuT2g3BJU=;
        b=uoPOqfW/pPF456MLmGkDS1nrQnOjcghZK0kta2Dsv9YUQK4ZZI+hNl8b+/QGqcOgXp
         SiR4e2uQjOTHPLn7svZ2j5CIAB8msFSXYsSq9E43f/in1MJJkg1Ro7BlZXtvyGqvZlYq
         /npUqxUrdzYendTO43/X/TizDaIY/WKUoQfzbo/BZ2ol889nmVZDn/SOxSTWqZttrWKH
         abaaV6vP8yP37QQwRKqMsSuSfKPX2QHOVk0ZonlFsHDe1Vrjnqv8+dK/cjYn+Yjh6LJN
         R//HyG62zUOIMF4Uc4h6UmVEupFWtFfMDdEXWebJRzNi7aNG035Ur+tM2hRIf4VypCxd
         leUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=qKJrOarY2DKNHpkAcDz+cQOZGHxGEuN8oZtuT2g3BJU=;
        b=go1PWygoTogEIDkzDew88kjRUX8v4Mdt9SATD8p1ppb/oek1+SCnruH7iBsTGQUBDN
         9cPmCVqpB7myU2fPnUzGOqwwnLyPxCoAHNqZwgZr1TrwwBxULh4/KaSuLZ3ICR//GmFN
         SXaI3vAmg7zPH8sJ1FU9/edXg5Y4STN+I487ir8/BYstD5I8YNl+hjEMnFcXDkixpg3V
         CJGzMXMm7Tkn6hx/kIjNmzT9u9ZjNkc2kkBwbrC9q3jBUW8FkorQa2nnV5reA9vWToHl
         sk+WJhdbYDNHFk9e8sysHPCzVZ5VYwX35tqoKrigSFoqSnezb7TrrA9gR95NONGFcHHV
         YgdQ==
X-Gm-Message-State: APjAAAXMTCbwdZ2+UhFBXf2iIc47RnBQZnf0fX4sKEvdJuN489I8rFD+
        /5xR7mKInLD6MkyNEPSxPCBLAg==
X-Google-Smtp-Source: APXvYqy3u+oS8uEtwiDrX8KDHqBlOgQ6m/ofOPJPup/tygn7Gv2JLDM0+G0cr9p+vfoZakxIWHv1bw==
X-Received: by 2002:a0c:9863:: with SMTP id e32mr28167463qvd.163.1557264146039;
        Tue, 07 May 2019 14:22:26 -0700 (PDT)
Received: from cakuba.hsd1.ca.comcast.net ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id d41sm2898903qta.22.2019.05.07.14.22.24
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 07 May 2019 14:22:25 -0700 (PDT)
Date:   Tue, 7 May 2019 14:22:14 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     "Michael, Alice" <alice.michael@intel.com>
Cc:     "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Marczak, Piotr" <piotr.marczak@intel.com>,
        "Buchholz, Donald" <donald.buchholz@intel.com>
Subject: Re: [net-next v2 11/11] i40e: Introduce recovery mode support
Message-ID: <20190507142214.26611a49@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <CD14C679C9B9B1409B02829D9B523C290AE87E5E@ORSMSX112.amr.corp.intel.com>
References: <20190503230939.6739-1-jeffrey.t.kirsher@intel.com>
        <20190503230939.6739-12-jeffrey.t.kirsher@intel.com>
        <20190504073522.3bc7e00d@cakuba.netronome.com>
        <CD14C679C9B9B1409B02829D9B523C290AE87E5E@ORSMSX112.amr.corp.intel.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 7 May 2019 18:51:02 +0000, Michael, Alice wrote:
> > -----Original Message-----
> > From: Jakub Kicinski [mailto:jakub.kicinski@netronome.com]
> > Sent: Saturday, May 4, 2019 4:35 AM
> > To: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>; Michael, Alice
> > <alice.michael@intel.com>
> > Cc: davem@davemloft.net; netdev@vger.kernel.org; nhorman@redhat.com;
> > sassmann@redhat.com; Marczak, Piotr <piotr.marczak@intel.com>; Buchholz,
> > Donald <donald.buchholz@intel.com>
> > Subject: Re: [net-next v2 11/11] i40e: Introduce recovery mode support
> > 
> > On Fri,  3 May 2019 16:09:39 -0700, Jeff Kirsher wrote:  
> > > From: Alice Michael <alice.michael@intel.com>
> > >
> > > This patch introduces "recovery mode" to the i40e driver. It is part
> > > of a new Any2Any idea of upgrading the firmware. In this approach, it
> > > is required for the driver to have support for "transition firmware",
> > > that is used for migrating from structured to flat firmware image. In
> > > this new, very basic mode, i40e driver must be able to handle
> > > particular IOCTL calls from the NVM Update Tool and run a small set of
> > > AQ commands.  
> > 
> > What's the "particular IOCTL" you speak of?  This patch adds a fake netdev with
> > a .set_eeprom callback.  Are you wrapping the AQ commands in the set_eeprom
> > now?  Or is there some other IOCTL here?  
> 
> Yes.  The NVMUpdate tool uses the ethtool IOCTL to call the
> driver's .set_eeprom callback.  This then triggers the firmware AQ
> command.  The fake netdev needs to have ethtool support to finish
> upgrading the firmware using the eeprom interface. 

To be clear - the .set_eeprom calls are used to carry some marshalled
commands, not just the raw data to be written into flash?  Right?
Otherwise your tool wouldn't be necessary.

> > Let me repeat my other question - can the netdev you spawn in
> > i40e_init_recovery_mode() pass traffic?  
> 
> No, the device is not expected to pass traffic.  This mode is to
> allow the NVMUpdate to program the NVM.

Creating this fake netdev which can't pass traffic is quite bad, and
pointless given that devlink is capable of handling firmware updates.  
