Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 523BC21308C
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 02:45:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726357AbgGCApT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 20:45:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725937AbgGCApS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 20:45:18 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A368C08C5C1;
        Thu,  2 Jul 2020 17:45:18 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id cv18so6738519pjb.1;
        Thu, 02 Jul 2020 17:45:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=xxCISvRtfhl8oL/cHz8IcSytvLoDXt2VBe6qFVBHxUE=;
        b=nJjrrEkUAQCGFmGDNhnb5PVExZ3pDaEIWh7BZWYbQZD2UR9o86pnVnUTyuKaTuTJDW
         Jpv6HrHW6Wd96BITv2uK8OH5weHw4hI8kcRDXFq3O1XzNvOlUrd+DUkufbneM1Hsi6JO
         v3E0y8rkNX6xX9HKg44GveDw1iZsMMTNN8nogn4UObvseMisxlDOj+eeiCbfVr/pr/0m
         JVMZVayOQCVBgveyiz63ZuW/T6mj4yECIx+Ui3dqVTXvj4WHXz2SXPuuaVC4XL8uWQvP
         o8ct/VHBaCQkVA3WFDpmBrAzUREPYlYXnmBY40tobsjxomCu7nyheU/mGfpxUiCtZ5Fz
         uPag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=xxCISvRtfhl8oL/cHz8IcSytvLoDXt2VBe6qFVBHxUE=;
        b=eKUpemZ8+x+FBdCqiH1eJGSJmZAnnrzKXgXRansfe/SNLmlIad3NilrcaOhK0zGH98
         jj+NZufn8HJWjCR0Us6OAYCPZ8CXFm88tIE8unbomcfaPitCN31NQ8Uu/DFMYXR2tJp9
         oOYiC3er2gJAmSUSM3BLEwcfnqlu0DfIuA4emtNYnKuu2ZiBnxXoUqWYPSZGHUfhSxP8
         AA6MY6zbpsT5/Tu1/y2+279qEZHRK7ABgyct5OJiUoeoMfvBT+Ot/x4DnNmAAZY11jv+
         T9EJ6N+klwYNLf3xyrP15u0GjLT6onEZ1/2SG5B59goF+RUxvknbAnrydVyU7L819QpA
         mJ4g==
X-Gm-Message-State: AOAM530OIiyzeaf6A7xxHA4Xf7wcMXBmKH/sJ2UiHnphUyVbJiv9m7LJ
        c2H9FpawIfRWfH422DGiqzZm4huXj9o=
X-Google-Smtp-Source: ABdhPJz+qnIK30TK5zKdKNpuN2jPEhIs1H8VMPfoPIeYzhAgJgFZjY/TlqevmnyCB1cDQRYUNKAH3A==
X-Received: by 2002:a17:902:369:: with SMTP id 96mr6833712pld.214.1593737117645;
        Thu, 02 Jul 2020 17:45:17 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 125sm9302049pff.130.2020.07.02.17.45.16
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 02 Jul 2020 17:45:17 -0700 (PDT)
Date:   Thu, 2 Jul 2020 17:45:16 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     rentao.bupt@gmail.com
Cc:     Jean Delvare <jdelvare@suse.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        linux-hwmon@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        openbmc@lists.ozlabs.org,
        Samuel Mendoza-Jonas <sam@mendozajonas.com>, taoren@fb.com
Subject: Re: [PATCH] hwmon: (pmbus) fix a typo in Kconfig SENSORS_IR35221
 option
Message-ID: <20200703004516.GA100326@roeck-us.net>
References: <20200702221349.18139-1-rentao.bupt@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200702221349.18139-1-rentao.bupt@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 02, 2020 at 03:13:49PM -0700, rentao.bupt@gmail.com wrote:
> From: Tao Ren <rentao.bupt@gmail.com>
> 
> Fix a typo in SENSORS_IR35221 option: module name should be "ir35221"
> instead of "ir35521".
> 
> Fixes: 8991ebd9c9a6 ("hwmon: (pmbus) Add client driver for IR35221")
> 
> Cc: Samuel Mendoza-Jonas <sam@mendozajonas.com>
> Signed-off-by: Tao Ren <rentao.bupt@gmail.com>

Applied.

Thanks,
Guenter

> ---
>  drivers/hwmon/pmbus/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/hwmon/pmbus/Kconfig b/drivers/hwmon/pmbus/Kconfig
> index 3ad97fd5ce03..e35db489b76f 100644
> --- a/drivers/hwmon/pmbus/Kconfig
> +++ b/drivers/hwmon/pmbus/Kconfig
> @@ -71,7 +71,7 @@ config SENSORS_IR35221
>  	  Infineon IR35221 controller.
>  
>  	  This driver can also be built as a module. If so, the module will
> -	  be called ir35521.
> +	  be called ir35221.
>  
>  config SENSORS_IR38064
>  	tristate "Infineon IR38064"
