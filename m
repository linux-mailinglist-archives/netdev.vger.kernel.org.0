Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54DE91E24FC
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 17:07:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729784AbgEZPHu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 11:07:50 -0400
Received: from mail-ej1-f65.google.com ([209.85.218.65]:43297 "EHLO
        mail-ej1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728166AbgEZPHt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 11:07:49 -0400
Received: by mail-ej1-f65.google.com with SMTP id a2so24155918ejb.10;
        Tue, 26 May 2020 08:07:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KjgTih7A660W8l2Ai5zV0xie7l2fjS3cquiqxZY0eUs=;
        b=lj0xOxS+RFiPf9SsOq/2HiLpzJM8NqDxbOEmL6gK5IWHwUO1MvEcGdGh/ue2UIwHEs
         g1fuHrUZTMNafI1bJQlUpKzxnH0gIOZ2sDFdr3agSkIZjUNbR+E+3qyAH8GhAbdq+JQO
         uowDnKKCjJIGxSvbMpLth3SFSzzIFsGZtL8EgFNZpGPyXxh2/PdBvnFAGRG+aE0vP4A8
         Jk5rQMDzbtDospNqOqOlXNmu5iNO6beaa8MWhQt6lm/O3dx5IYX2B9t6zjPUsAQuBYGW
         +1KPD8SnieaYmzDNPUcPPHZqGVuJBVrp4k5fShXQmCcuIFEyUovshFaMOKky8Wl3YcdI
         ToQA==
X-Gm-Message-State: AOAM5306iPBdlX3xOO+3pC8x3R7m9tVCiXk0LcQ01D98VdJJ/LLCrMTi
        8Sp0+ggbBZLudgHz0UkIczY=
X-Google-Smtp-Source: ABdhPJzpF2izaI7HGirZOZ/xZQdcIiUyWXIQKdVRDh55kJz8UdqLFQpxuDMPANNvmQBg9fruG2pCcw==
X-Received: by 2002:a17:906:8748:: with SMTP id hj8mr1609977ejb.335.1590505666414;
        Tue, 26 May 2020 08:07:46 -0700 (PDT)
Received: from rocinante ([95.155.85.46])
        by smtp.gmail.com with ESMTPSA id t22sm137834ejr.93.2020.05.26.08.07.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2020 08:07:45 -0700 (PDT)
Date:   Tue, 26 May 2020 17:07:44 +0200
From:   Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kw@linux.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <lenb@kernel.org>, Kevin Hilman <khilman@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Pavel Machek <pavel@ucw.cz>, Johan Hovold <johan@kernel.org>,
        Alex Elder <elder@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Felipe Balbi <balbi@kernel.org>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        John Stultz <john.stultz@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        greybus-dev@lists.linaro.org, netdev@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH 8/8] net/iucv: Use the new device_to_pm() helper to
 access struct dev_pm_ops
Message-ID: <20200526150744.GC75990@rocinante>
References: <20200525182608.1823735-1-kw@linux.com>
 <20200525182608.1823735-9-kw@linux.com>
 <20200526063521.GC2578492@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200526063521.GC2578492@kroah.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Greg,

[...]
> It's "interesting" how using your new helper doesn't actually make the
> code smaller.  Perhaps it isn't a good helper function?

The idea for the helper was inspired by the comment Dan made to Bjorn
about Bjorn's change, as per:

  https://lore.kernel.org/driverdev-devel/20191016135002.GA24678@kadam/

It looked like a good idea to try to reduce the following:

  dev->driver && dev->driver->pm && dev->driver->pm->prepare

Into something more succinct.  Albeit, given the feedback from yourself
and Rafael, I gather that this helper is not really a good addition.

Thank you everyone and sorry for the commotion!

Krzysztof
