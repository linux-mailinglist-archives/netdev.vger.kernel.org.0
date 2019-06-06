Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E3B636A70
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 05:20:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726701AbfFFDUz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 23:20:55 -0400
Received: from mail-pf1-f175.google.com ([209.85.210.175]:45097 "EHLO
        mail-pf1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726454AbfFFDUy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 23:20:54 -0400
Received: by mail-pf1-f175.google.com with SMTP id s11so558952pfm.12
        for <netdev@vger.kernel.org>; Wed, 05 Jun 2019 20:20:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=nXNHGnpgkyACL7VNXVDeT3z9uteV/W9C0GxFZtKWw80=;
        b=tlPNMoLJ9v9doZHtNoydHkhq8dDtM6/+lOxDYP3UDkrR2XHhGdWEQD7VrWHWeIzaIk
         zIMvO1vxMWdEIPgkIpbiZDMkqdN3TPi9xou0TbmVkkMWPPofcmSJTietSGa/bgDSkmcY
         r/qT5m9g4lj13CK8S1GkHtIsQ/omgjikBCKW7N+J8hYoKxxtEcjaBLvCOz1RvqU7l7ji
         ETX8Xnmn2kG+/7VPDCF74Y5LKTsoT/3UbiKiQeRIjV9mPWNnJN/jjCfjukS6898SW5vQ
         +ricWLv2EwBzpN3NMp+HGEMb/n9I+TPH0xSxym7Um3FlvYFC1tNG/+0JVPTthUnpFFJj
         7cfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=nXNHGnpgkyACL7VNXVDeT3z9uteV/W9C0GxFZtKWw80=;
        b=SPSMF1qjfmm0qQuebNm3zd7O0XEKOfJHuOfOFACvAR10o4naAnsEwR1cb1zGBOHdDi
         ywfdRiWWumBwZBIHSfIxUsnTbvE78qw/C6U6TracG2vssFnA3HfX8yM4mu9daxoS1RKQ
         n7ZZz+BSl/ySpdfy0VWo5nUfoFUKTmT5bPZ70fRAbD6KBtTBwBnmupm9Z/3QerTUzDsM
         uBIwAOE634kF6Qxei+IDwu3b20MWyK+jX7uRd1v5Ux8ihir4WFFqEIJiRwRw+Ub6Lvp7
         2gPYjoqyDLqHOSzTueOExWaA6OWZcGQ0oKSGTS4tRBuDcCuGixyl/SctKMou0TKCqDw/
         ZcDQ==
X-Gm-Message-State: APjAAAWbyOm63p4zWB+eQM1UW3tmRF4IPB7P2ynypi8uyzibJwYthxOA
        thGk/p5UtXYyBZjVPUWM4zM=
X-Google-Smtp-Source: APXvYqw8jqhniFoD0wkYQ13w9Ma8priFccx74U1iYsrx+CRFqw0Fq2lCIDLXEvAlrMrxrl/iF6ipRQ==
X-Received: by 2002:a63:3d0b:: with SMTP id k11mr1212178pga.349.1559791253413;
        Wed, 05 Jun 2019 20:20:53 -0700 (PDT)
Received: from localhost (c-73-222-71-142.hsd1.ca.comcast.net. [73.222.71.142])
        by smtp.gmail.com with ESMTPSA id m5sm265082pgc.84.2019.06.05.20.20.52
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 05 Jun 2019 20:20:52 -0700 (PDT)
Date:   Wed, 5 Jun 2019 20:20:50 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     davem@davemloft.net, Jacob Keller <jacob.e.keller@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: Re: [net-next 06/15] ixgbe: fix PTP SDP pin setup on X540 hardware
Message-ID: <20190606032050.4uwzcc7rdx3dkw5x@localhost>
References: <20190605202358.2767-1-jeffrey.t.kirsher@intel.com>
 <20190605202358.2767-7-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190605202358.2767-7-jeffrey.t.kirsher@intel.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 05, 2019 at 01:23:49PM -0700, Jeff Kirsher wrote:
> + * It calculates when the system time will be on an exact second, and then
> + * aligns the start of the PPS signal to that value.
> + *
> + * This works by using the cycle counter shift and mult values in reverse, and
> + * assumes that the values we're shifting will not overflow.

So I guess that this device can't adjust the frequency in hardware,
and that is why the driver uses a timecounter.

BUT your PPS will not be correct.  You use the 'mult' to calculate the
future counter time of the PPS, but as soon as the PTP stack adjusts
the frequency (and changes 'mult') the PPS will occur at the wrong
time.

Sorry to say it,
Richard
