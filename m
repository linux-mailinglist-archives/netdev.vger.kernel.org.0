Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EAAE1A0A41
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 11:34:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728151AbgDGJe2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Apr 2020 05:34:28 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41878 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726725AbgDGJe1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Apr 2020 05:34:27 -0400
Received: from mail-wm1-f71.google.com ([209.85.128.71])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <andrea.righi@canonical.com>)
        id 1jLkci-0001t2-Uv
        for netdev@vger.kernel.org; Tue, 07 Apr 2020 09:34:25 +0000
Received: by mail-wm1-f71.google.com with SMTP id s9so360941wmh.2
        for <netdev@vger.kernel.org>; Tue, 07 Apr 2020 02:34:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uPsTNxLdIDWlRCtJqG7CoBzdAg59oIT20FSzJSMfJfM=;
        b=dMdFRmH7iTdOMF02dT4KFcmO0LWgxcoxRLGiVa/9aSQjYe/KO5gvqgpcMIFw8HhWwV
         8gf5H5tWnCO1eQbJxRtV5oRmrd1aFWT8fG+aLHVdGhAMzGkZx8c17yk6VXN+XXWCt1qc
         HhKeDDTWjUeuoc+x8oP1cdmOE3aXo2c75tla8Yc0OMkk8hnWOz8tTaQ534ya2uN+2Xhd
         YVHCsqrW2yjDCdcH7Q02oLsLJVVuJWqwcDhZGZnyHqKqe3NI+ZiXBAlQuV9NnHtqzdoC
         L5WnxvlsQmZZMmQ43nQ0kweyF7KMAb8vRdWuf24LARuHilMpbfFpE47Nghqk29KAbmDA
         vyMA==
X-Gm-Message-State: AGi0PubVIWag5Z5e0JCJEM26QeH3CERFEkx7/3CXe4DZBZrpqwaRxtXP
        d9LvGtpl2TkznHOW/1dYXcX+fdDkUIlm6DVTaCJ5g9Qk3ap7EP2jKlZbAzEniowGosba2EgxagC
        t6Uch8yGB5PnVao7nILjU7qHedEy5oLzwrA==
X-Received: by 2002:a1c:68d5:: with SMTP id d204mr1442651wmc.15.1586252064435;
        Tue, 07 Apr 2020 02:34:24 -0700 (PDT)
X-Google-Smtp-Source: APiQypKmrWsL/bX9oZ/TNvsql4F4PCjQsXe8fa6CUIX/VQhprHmkFfhDzZXlUz4Tuus9VKxSSbzujw==
X-Received: by 2002:a1c:68d5:: with SMTP id d204mr1442631wmc.15.1586252064149;
        Tue, 07 Apr 2020 02:34:24 -0700 (PDT)
Received: from localhost (host123-127-dynamic.36-79-r.retail.telecomitalia.it. [79.36.127.123])
        by smtp.gmail.com with ESMTPSA id f5sm20796541wrj.95.2020.04.07.02.34.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Apr 2020 02:34:23 -0700 (PDT)
Date:   Tue, 7 Apr 2020 11:34:22 +0200
From:   Andrea Righi <andrea.righi@canonical.com>
To:     Vladis Dronov <vdronov@redhat.com>
Cc:     Piotr Morgwai =?utf-8?Q?Kotarbi=C5=84ski?= <morgwai@morgwai.pl>,
        Colin Ian King <colin.king@canonical.com>,
        Richard Cochran <richardcochran@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ptp: free ptp clock properly
Message-ID: <20200407093422.GD3665@xps-13>
References: <20200309172238.GJ267906@xps-13>
 <1196893766.20531178.1585920854778.JavaMail.zimbra@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1196893766.20531178.1585920854778.JavaMail.zimbra@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 03, 2020 at 09:34:14AM -0400, Vladis Dronov wrote:
> Hello, Andrea, Colin, all,
> 
> This fix is really not needed, as its creation is based on the assumption
> that the Ubuntu kernel 5.3.0-40-generic has the upstream commit 75718584cb3c,
> which is the real fix to this crash.
> 
> > > > I would guess that a kernel in question (5.3.0-40-generic) has the commit
> > > > a33121e5487b but does not have the commit 75718584cb3c, which should be
> > > > exactly fixing a docking station disconnect crash. Could you please,
> > > > check this?
> > >
> > > Unfortunately the kernel in question already has 75718584cb3c:
> > > https://git.launchpad.net/~ubuntu-kernel/ubuntu/+source/linux/+git/bionic/commit/?h=hwe&id=c71b774732f997ef38ed7bd62e73891a01f2bbfe
> 
> Apologies, but the assumption above is not correct, 5.3.0-40-generic does
> not have 75718584cb3c. If it had 75718584cb3c it would be a fix and the ptp-related
> crash (described in https://bugs.launchpad.net/bugs/1864754) would not happen.
> 
> This way https://lists.ubuntu.com/archives/kernel-team/2020-March/108562.html fix
> is not really needed.

Hi Vladis,

for the records, I repeated the tests with a lot of help from the bug
reporter (Morgwai, added in cc), this time making sure we were using the
same kernels.

I confirm that my fix is not really needed as you correctly pointed out.
Thanks for looking into this and sorry for the noise! :)

-Andrea
