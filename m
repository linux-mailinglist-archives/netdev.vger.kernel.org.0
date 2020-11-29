Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FFD32C7B51
	for <lists+netdev@lfdr.de>; Sun, 29 Nov 2020 22:17:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726777AbgK2VN0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Nov 2020 16:13:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726304AbgK2VN0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Nov 2020 16:13:26 -0500
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06610C0613D2
        for <netdev@vger.kernel.org>; Sun, 29 Nov 2020 13:12:46 -0800 (PST)
Received: by mail-il1-x143.google.com with SMTP id t13so9462642ilp.2
        for <netdev@vger.kernel.org>; Sun, 29 Nov 2020 13:12:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=3aEwOdQ6stHrGJaERbU+2tS6VKh8OH8UKxZFXU2wIC0=;
        b=m6vPoxhjotxS3tfZmfrhsKlXU0ITpZPT58+vPB8FY/hdvd8zBfWr5q9K50FcPmpZ0u
         fnpcZeZSNyxsnXMnoVNvj1LklXBytiSQB8GXhp4E9IQ9y6jhG5NARWC4WjHNhxNnknl1
         fOk6EpaXk0LmRHOGHJTXbYwqYntJQmPAQpa91RgEgh0H6iRHdf4Or+Srr4ZIL2+OfTy2
         V+Y5CmyeOGohlI4ux2ZGtzATyvgcd9rGdJcfCL/vSsUW1Maebl2OB8C/wlFsDGE+IuZc
         s53ntBemzBTqpxF/6bvOWsknDfeocj8Kp6bO8+EkvwlVoM+tLXkOfFcyxsAOutrqsruU
         q/uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3aEwOdQ6stHrGJaERbU+2tS6VKh8OH8UKxZFXU2wIC0=;
        b=K/C46tr1BQMxfJi+Wn5OVnLWTxEYIHoWw/lwEZMBz04C620ZbGS+cLd8tE9pdD+5WF
         Vx3HWpP2p+uKr3+FD0n9cioigOSRBJPG1AgZR9Gad2cXviTfZEGYBfpLz1PnwUSBB5Wl
         dZtZYc5PHdXpPJQCW+0pfLnV9rC1u12A04Al5RMFxxRUfuWVBzaHhg4SqvLfy5rR2RFQ
         2c1LF0zwACVBvWnJQrrpZL9LzSdbdS3zSNcJH5JVvJ4vnqmHrSbmTPRwYRZvNIVAfBA2
         fO9jy+Gge22fVDeBC5dVg45pwcCXoXRw9T5gMdLI9Itxwe+E8auHp/uP4SSKCpr1yL5D
         Vvcg==
X-Gm-Message-State: AOAM533cUEV91wL9P5N5uGTBRZsjrqcbe3kuBMygtZj8Cve5Mr3JA3yw
        u0WesQGBh43tc+bH36DTzVlomDURfyc=
X-Google-Smtp-Source: ABdhPJxC1chIpQe2nsUhyQiPEgaIFESYapgpg1oiGvkI7Ihklq6Wiab/WYfiu4k1Y/gEM42uJtTuZA==
X-Received: by 2002:a92:ce48:: with SMTP id a8mr15992082ilr.115.1606684365372;
        Sun, 29 Nov 2020 13:12:45 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:282:800:dc80:4896:3e20:e1a7:6425])
        by smtp.googlemail.com with ESMTPSA id c8sm7214392ioq.40.2020.11.29.13.12.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 29 Nov 2020 13:12:44 -0800 (PST)
Subject: Re: [PATCH iproute2-net 1/3] devlink: Add devlink reload action and
 limit options
To:     Moshe Shemesh <moshe@mellanox.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        netdev@vger.kernel.org
References: <1606389296-3906-1-git-send-email-moshe@mellanox.com>
 <1606389296-3906-2-git-send-email-moshe@mellanox.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <165b31e9-6dce-477d-339d-206fe221fcee@gmail.com>
Date:   Sun, 29 Nov 2020 14:12:44 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <1606389296-3906-2-git-send-email-moshe@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/26/20 4:14 AM, Moshe Shemesh wrote:
> @@ -1997,7 +2066,7 @@ static void cmd_dev_help(void)
>  	pr_err("       devlink dev eswitch show DEV\n");
>  	pr_err("       devlink dev param set DEV name PARAMETER value VALUE cmode { permanent | driverinit | runtime }\n");
>  	pr_err("       devlink dev param show [DEV name PARAMETER]\n");
> -	pr_err("       devlink dev reload DEV [ netns { PID | NAME | ID } ]\n");
> +	pr_err("       devlink dev reload DEV [ netns { PID | NAME | ID } ] [ action { driver_reinit | fw_activate } ] [ limit no_reset ]\n");

line length is unreasonable; add new options on the next line.

>  	pr_err("       devlink dev info [ DEV ]\n");
>  	pr_err("       devlink dev flash DEV file PATH [ component NAME ] [ overwrite SECTION ]\n");
>  }

