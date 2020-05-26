Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 032741E2545
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 17:19:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729309AbgEZPTV convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 26 May 2020 11:19:21 -0400
Received: from mail-oo1-f67.google.com ([209.85.161.67]:40593 "EHLO
        mail-oo1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726939AbgEZPTU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 11:19:20 -0400
Received: by mail-oo1-f67.google.com with SMTP id f39so976300ooi.7;
        Tue, 26 May 2020 08:19:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=VZBcz6P8XvlHsbrU2eTtG7/ScIEzLwH8fekfbRdSKRQ=;
        b=axB0+ztMZNPQHmh2T5J1rNX9XSSqUJ1ghF8kZRp21n86wbYCSnhFvdknxHvMgxWxZL
         rJYrae7L8x9X9tavzKHdELQgCk12rkUHqFsMLw0DOyOPALJ64FjunAwiRSUvz1m3yVhr
         YEgm3brc/NQ/u+Z1lT5X4ylfv29HXZrhuqdCJ1AntbRSp1wcywD6q2CsIn5JhLuIWysr
         t+cDgFv5/X0ScpqJLzcNZ5SDMwfmAU1MKJwdysYqI01xgTnA25QVvB21spZSxQ/bSpyO
         i79CoXuo5QvVoCierl6itgrB8iHESrqx4Z6WWFHlVXuIllaA8n62yLSWiTTNaaTXTJpz
         LKzQ==
X-Gm-Message-State: AOAM530hYjiOOErfVOwMBEOEK3O85DOWy81EVO7IHYM6CudnZRKUWkfX
        Cr6QBA3mlyVEcrw/eY8Zjl1zL0ULWIYdXBscdXM=
X-Google-Smtp-Source: ABdhPJz6T1ptdbNy/G/lwrqbnMsBUWMLewVuG8K8TUsIgnEptYY3NNFI0VGqY6Fo8CDoDMoNJVTCuZ+6jxk8hfWP6YI=
X-Received: by 2002:a4a:be07:: with SMTP id l7mr17198759oop.38.1590506358744;
 Tue, 26 May 2020 08:19:18 -0700 (PDT)
MIME-Version: 1.0
References: <20200525182608.1823735-1-kw@linux.com> <20200525182608.1823735-9-kw@linux.com>
 <20200526063521.GC2578492@kroah.com> <20200526150744.GC75990@rocinante>
In-Reply-To: <20200526150744.GC75990@rocinante>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Tue, 26 May 2020 17:19:07 +0200
Message-ID: <CAJZ5v0grVQhmk=q9_=CbBa8y_8XbTOeqv-Hb6Hivi6ffKsVHmQ@mail.gmail.com>
Subject: Re: [PATCH 8/8] net/iucv: Use the new device_to_pm() helper to access
 struct dev_pm_ops
To:     =?UTF-8?Q?Krzysztof_Wilczy=C5=84ski?= <kw@linux.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
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
        greybus-dev@lists.linaro.org, netdev <netdev@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Linux PM <linux-pm@vger.kernel.org>,
        linux-s390@vger.kernel.org,
        "open list:TARGET SUBSYSTEM" <linux-scsi@vger.kernel.org>,
        "open list:ULTRA-WIDEBAND (UWB) SUBSYSTEM:" 
        <linux-usb@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 26, 2020 at 5:07 PM Krzysztof Wilczyński <kw@linux.com> wrote:
>
> Hello Greg,
>
> [...]
> > It's "interesting" how using your new helper doesn't actually make the
> > code smaller.  Perhaps it isn't a good helper function?
>
> The idea for the helper was inspired by the comment Dan made to Bjorn
> about Bjorn's change, as per:
>
>   https://lore.kernel.org/driverdev-devel/20191016135002.GA24678@kadam/
>
> It looked like a good idea to try to reduce the following:
>
>   dev->driver && dev->driver->pm && dev->driver->pm->prepare
>
> Into something more succinct.  Albeit, given the feedback from yourself
> and Rafael, I gather that this helper is not really a good addition.

IMO it could be used for reducing code duplication like you did in the
PCI code, but not necessarily in the other places where the code in
question is not exactly duplicated.

Thanks!
