Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84CA214E979
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 09:15:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728151AbgAaIP0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 03:15:26 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:36283 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728099AbgAaIP0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jan 2020 03:15:26 -0500
Received: by mail-pg1-f193.google.com with SMTP id k3so3057064pgc.3;
        Fri, 31 Jan 2020 00:15:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0Y/URflAN0egTNKiFFMYLQYMJ9wMyROzssZLeoHgDcA=;
        b=bDvPIqs7zk+6Ua13LmwPSUxJHYoP3sz8dXzrXUCY11vG2q89ymnvF9KOeRMwUirtgO
         WhyUtcVQPAnzhKrKITFqvSYkxlT9ISAcAWsYUN+KrpW0FCHyu+ZluN9d0tj4O4L669Xl
         2lPXBX7A9ppfx8G8cJPmJPdkjkLVNJvFVuhlBD9SJleQXfC/Tqo5TZuncxblMoLotnGK
         Ib83dfWkfHcjCYYEuWSvqtZNns38l/X/5LdjmvUkkdqJjDw/KKgoqrjFMG2JYHJbJtGo
         Hwmntfvq8q/lf8F4I/zJ0W6jIKekE15B6f/Dz4JvKJXfdrWECkV2PUL2Ir7vthKG/b/Q
         h+yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0Y/URflAN0egTNKiFFMYLQYMJ9wMyROzssZLeoHgDcA=;
        b=e6KZ2edjpT7KJDN3hWGg+T5FQmpg6J26Dci8OwgVDEKAIS7qd7NhzNXO0HbLn9Is29
         QE2cLK0J1rHRnBq1HKWSQsfMsn/dLprbhaDzJbN/x1O6XDgQK3uibC3ebPti/I1lgc2q
         +kikTtuxp8IZR/DBzTz9sePd2pYJJz3H05XNlbu+EgkRClLTZd1GdrCy4wE8e3jDyJi6
         nEPuFcYR99/c9SGUmqBCCHD3tloev8UX8vwPoPg/40o6+nXmT7emPiKvJJ0o7n3pyTeW
         eA0WRe81A25hpaGmBK0hhkaQ9rjx/oSdYDbSia10nRXRaww9YS0tEopgYp9JHAKXDKtW
         u17Q==
X-Gm-Message-State: APjAAAVISfE3ran20DdOA430w07mSJi6WAsS/j9Jw5e7OhssAfAtgt6i
        Yv69ECcVEyqbzrNiKDjjVO/mBQCu7Giiy8SeDyc=
X-Google-Smtp-Source: APXvYqwboAwjQDtVTg7bEoGRHsUXs8ZLkrvGg15+8RVjrgNqc260m2Rt7Sk+vi/Git2Gv4dOVb64A1UzzyTlsxidGbE=
X-Received: by 2002:a65:4685:: with SMTP id h5mr9486059pgr.203.1580458525958;
 Fri, 31 Jan 2020 00:15:25 -0800 (PST)
MIME-Version: 1.0
References: <20200131045953.wbj66jkvijnmf5s2@kili.mountain>
In-Reply-To: <20200131045953.wbj66jkvijnmf5s2@kili.mountain>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Fri, 31 Jan 2020 10:15:14 +0200
Message-ID: <CAHp75Vc7eudHy=05nHKB2==QJM1f23E1jZw=7yFKHA1nq0qBqA@mail.gmail.com>
Subject: Re: [PATCH net] device property: change device_get_phy_mode() to
 prevent signedess bugs
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ajay Gupta <ajayg@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Iyappan Subramanian <iyappan@os.amperecomputing.com>,
        Keyur Chudgar <keyur@os.amperecomputing.com>,
        Quan Nguyen <quan@os.amperecomputing.com>,
        Steve Glendinning <steve.glendinning@shawell.net>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        linux-stm32@st-md-mailman.stormreply.com,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 31, 2020 at 7:03 AM Dan Carpenter <dan.carpenter@oracle.com> wrote:
>
> The device_get_phy_mode() was returning negative error codes on
> failure and positive phy_interface_t values on success.  The problem is
> that the phy_interface_t type is an enum which GCC treats as unsigned.
> This lead to recurring signedness bugs where we check "if (phy_mode < 0)"
> and "phy_mode" is unsigned.
>
> In the commit 0c65b2b90d13 ("net: of_get_phy_mode: Change API to solve
> int/unit warnings") we updated of_get_phy_mode() take a pointer to
> phy_mode and only return zero on success and negatives on failure.  This
> patch does the same thing for device_get_phy_mode().  Plus it's just
> nice for the API to be the same in both places.


> +       err = device_get_phy_mode(dev, &config->phy_interface);

> +       if (err)
> +               config->phy_interface = PHY_INTERFACE_MODE_NA;

Do you need these? It seems the default settings when error appears.

-- 
With Best Regards,
Andy Shevchenko
