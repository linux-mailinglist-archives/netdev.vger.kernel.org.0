Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E24729D594
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 23:05:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729986AbgJ1WFR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 18:05:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729971AbgJ1WFO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 18:05:14 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35499C0613D1;
        Wed, 28 Oct 2020 15:05:14 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id b3so615204pfo.2;
        Wed, 28 Oct 2020 15:05:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=GeMX+k14VhxeG76k1/qSlgb4+cXieu72K4e08pwdt1o=;
        b=InpLHLruF700Q395/JUSDPFi5ct3Q0NFGhIrDU/UmIhGdDThKH8GKD+cw6T2N6QNcD
         PUvF0K87ShFDKaAjJCfvpeMCAaEiJ8eHb269GNLlCVUSVFBQarvkQDFEeK2v65rPe7+J
         tC/1aFfwnYWg9j8u/6Ud/Yyen1uhouxurM0nLvzz3MYFdzPpthJUWusVU6lftQoy21uA
         qiW9X1ZTMFe3cniRtPQ+TCgotIme378DGRcyAXvYYZgBHvV1ur7fGjNBhSILa0vbkqSM
         tRUkeNha3rVBlOMkNme6QRGiAF7X/US6S2FlZ9tPWrsV95ioL0sZyvBU99MP8xfC1Ema
         woPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=GeMX+k14VhxeG76k1/qSlgb4+cXieu72K4e08pwdt1o=;
        b=lzAqOSVmhU6VbRxYBDriHSDMrHey6KVNiVhpaRvSGsyBJZ6oe/lNxa6Kgo9ZeKm7jw
         72626PUiA4Wzw92EBR2nnt08hZrqLAqQ/pEukMRqcjE9Gy67ZGvTfqHa330OVmqqvsl1
         dmDUdms+/w5hAwlsY/+6dXLjqapVltPxry1/ThdulwOK6VxdYhdGIuoABnR/xiKn3syz
         6NuYhb62FMA8Mrng0Lyv3BurqQCXo4F7Wcc/xOFuCz7PhwcnIYVS42WjxIdX66ew7qKd
         VbLx+X3wuk4lLZooWloUYYTmUrskVoEoAwmKYhTeSUbSaiJIqBT3cdekqIxXywQ+mOlM
         UbFg==
X-Gm-Message-State: AOAM533RQkowhIxbHb2inKGnNmAVletJsLE743O6uN+WKsPGXEmBLzY0
        M12JzlevK7J8lG5GABHnLbBduYkTX45V4g==
X-Google-Smtp-Source: ABdhPJw+P7PZ1ANDYILo79Hsg7TsK8M0hrdd6+wFNAfXxYnBAlE0Wr2vQTH+qAkmHlbh1+XaD9f7GA==
X-Received: by 2002:a63:78c3:: with SMTP id t186mr490857pgc.12.1603907075050;
        Wed, 28 Oct 2020 10:44:35 -0700 (PDT)
Received: from hoboy.vegasvil.org (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id d26sm224049pfo.82.2020.10.28.10.44.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2020 10:44:34 -0700 (PDT)
Date:   Wed, 28 Oct 2020 10:44:27 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        "Gautham R. Shenoy" <ego@linux.vnet.ibm.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Javier =?iso-8859-1?Q?Gonz=E1lez?= <javier@javigon.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Andrew Donnellan <ajd@linux.ibm.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Baolin Wang <baolin.wang7@gmail.com>,
        Benson Leung <bleung@chromium.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Bruno Meneguele <bmeneg@redhat.com>,
        Chunyan Zhang <zhang.lyra@gmail.com>,
        Dan Murphy <dmurphy@ti.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Fabrice Gasnier <fabrice.gasnier@st.com>,
        Felipe Balbi <balbi@kernel.org>,
        Frederic Barrat <fbarrat@linux.ibm.com>,
        Guenter Roeck <groeck@chromium.org>,
        Hanjun Guo <guohanjun@huawei.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Jens Axboe <axboe@kernel.dk>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Juergen Gross <jgross@suse.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Kranthi Kuntala <kranthi.kuntala@intel.com>,
        Lakshmi Ramasubramanian <nramas@linux.microsoft.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Len Brown <lenb@kernel.org>,
        Leonid Maksymchuk <leonmaxx@gmail.com>,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        Mario Limonciello <mario.limonciello@dell.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Nayna Jain <nayna@linux.ibm.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Oleh Kravchenko <oleg@kaa.org.ua>,
        Orson Zhai <orsonzhai@gmail.com>, Pavel Machek <pavel@ucw.cz>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Peter Meerwald-Stadler <pmeerw@pmeerw.net>,
        Peter Rosin <peda@axentia.se>, Petr Mladek <pmladek@suse.com>,
        Philippe Bergheaud <felix@linux.ibm.com>,
        Sebastian Reichel <sre@kernel.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vineela Tummalapalli <vineela.tummalapalli@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-pm@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-usb@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        netdev@vger.kernel.org, xen-devel@lists.xenproject.org
Subject: Re: [PATCH 20/33] docs: ABI: testing: make the files compatible with
 ReST output
Message-ID: <20201028174427.GE9364@hoboy.vegasvil.org>
References: <cover.1603893146.git.mchehab+huawei@kernel.org>
 <4ebaaa0320101479e392ce2db4b62e24fdf15ef1.1603893146.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ebaaa0320101479e392ce2db4b62e24fdf15ef1.1603893146.git.mchehab+huawei@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 28, 2020 at 03:23:18PM +0100, Mauro Carvalho Chehab wrote:

> diff --git a/Documentation/ABI/testing/sysfs-uevent b/Documentation/ABI/testing/sysfs-uevent
> index aa39f8d7bcdf..d0893dad3f38 100644
> --- a/Documentation/ABI/testing/sysfs-uevent
> +++ b/Documentation/ABI/testing/sysfs-uevent
> @@ -19,7 +19,8 @@ Description:
>                  a transaction identifier so it's possible to use the same UUID
>                  value for one or more synthetic uevents in which case we
>                  logically group these uevents together for any userspace
> -                listeners. The UUID value appears in uevent as
> +                listeners. The UUID value appears in uevent as:

I know almost nothing about Sphinx, but why have one colon here ^^^ and ...

> +
>                  "SYNTH_UUID=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx" environment
>                  variable.
>  
> @@ -30,18 +31,19 @@ Description:
>                  It's possible to define zero or more pairs - each pair is then
>                  delimited by a space character ' '. Each pair appears in
>                  synthetic uevent as "SYNTH_ARG_KEY=VALUE". That means the KEY
> -                name gains "SYNTH_ARG_" prefix to avoid possible collisions
> +                name gains `SYNTH_ARG_` prefix to avoid possible collisions
>                  with existing variables.
>  
> -                Example of valid sequence written to the uevent file:
> +                Example of valid sequence written to the uevent file::

... two here?

Thanks,
Richard
