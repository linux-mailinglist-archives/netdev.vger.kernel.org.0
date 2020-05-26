Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B3251E24A6
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 16:57:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729783AbgEZO5s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 10:57:48 -0400
Received: from mail-ej1-f65.google.com ([209.85.218.65]:37776 "EHLO
        mail-ej1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727978AbgEZO5r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 10:57:47 -0400
Received: by mail-ej1-f65.google.com with SMTP id l21so24159170eji.4;
        Tue, 26 May 2020 07:57:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=h/vc/U48e43hYebkBpRwszhtS9SjYZ2xSvS7nTqAhXk=;
        b=JPgpJnLNkWjACul1dvYApARVGs2Cs5gfG38iSSaBGT9/l5HFAlskGf9v34VHttoTvd
         cN9mDEwJ9T2RpslOcBxIh3Ok6hEdzIQwFiiibxZG5vsq7L6QpmZwS2RWsfcLS4DzBhpL
         2UsyWHHXavFq7+qswrou69yuetvQU/XCZlHtrhiyueM6ERqDLX8Xd3B0xuRVF4u0T/JB
         3FbgiyyU/xsDy3HAghkLsm0BWrnDttYQlIdKeg33LsCiCJA9GTkm9MSzIjVerh8ATz3W
         fvX6oKgTZC+77hTsTqts/rPQf8cB7ZzNHFrzvM3tRsKxivdTMljMV9kdwqgl9PT3z9r8
         ql7g==
X-Gm-Message-State: AOAM5322H1G4oVJlE4HYNCDokfd3D5xFWS8N3RXUnHQpcWHMowcngU31
        1wgyg9nuoHj3xOkFpKT+l+Y=
X-Google-Smtp-Source: ABdhPJzdElVIHtsR0qMTrQLNXyURt2kuG/VwKifaQBwdr8EPvJOXOlo0YVxmLG6Ml176FD4Quk6tgg==
X-Received: by 2002:a17:906:4406:: with SMTP id x6mr1463667ejo.160.1590505065110;
        Tue, 26 May 2020 07:57:45 -0700 (PDT)
Received: from rocinante ([95.155.85.46])
        by smtp.gmail.com with ESMTPSA id v3sm149610ejj.14.2020.05.26.07.57.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2020 07:57:44 -0700 (PDT)
Date:   Tue, 26 May 2020 16:57:42 +0200
From:   Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kw@linux.com>
To:     Ursula Braun <ubraun@linux.ibm.com>
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <lenb@kernel.org>, Kevin Hilman <khilman@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Pavel Machek <pavel@ucw.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Johan Hovold <johan@kernel.org>, Alex Elder <elder@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Felipe Balbi <balbi@kernel.org>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
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
Message-ID: <20200526145742.GA75990@rocinante>
References: <20200525182608.1823735-1-kw@linux.com>
 <20200525182608.1823735-9-kw@linux.com>
 <55c3d2eb-feff-bf33-235d-b89c0abef7b1@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <55c3d2eb-feff-bf33-235d-b89c0abef7b1@linux.ibm.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ursula,

On 20-05-26 09:07:27, Ursula Braun wrote:
> 
> 
> On 5/25/20 8:26 PM, Krzysztof Wilczyński wrote:
> > Use the new device_to_pm() helper to access Power Management callbacs
> > (struct dev_pm_ops) for a particular device (struct device_driver).
> > 
> > No functional change intended.
> > 
> > Signed-off-by: Krzysztof Wilczyński <kw@linux.com>
> 
> pm support is going to be removed (for s390 in general and) for
> net/iucv/iucv.c with this net-next patch:
[...]

Good to know!  Thank you for letting me know.  I appreciate that.

Krzysztof
