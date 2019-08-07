Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5965854CE
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 22:55:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388468AbfHGUzS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 16:55:18 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:43929 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729934AbfHGUzS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 16:55:18 -0400
Received: by mail-pl1-f194.google.com with SMTP id 4so35551394pld.10
        for <netdev@vger.kernel.org>; Wed, 07 Aug 2019 13:55:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=U/D8itQFbcquUi6ypUZ48jaAzYaZ5NFPMVCkdAnYsYo=;
        b=WHAE5prFg5jyjK4F7eb8277T1frOWov+AKCsMiuGsOeG76p2VlUVDsrOsIrub3MPYp
         7O5jXT2oMsrUK8ohYEPx1iTEwHoSlJWc4/q0hfN9IoXTGmFLFfaDH0mT6HGkyvzZB7U3
         d6pqVeV2CNg21HUO+IGlar2F7hIguyNOEJmOfXPDk11fDZmzUm/dRZcDIei9TtuJn0OC
         PCamchsQckaOJS1Z+bPVta3HIqTsQLbSDRFdJ8KA7vJR2e62PZrI5ygFujrWi0zs5udE
         M2EVRYb3tTtbWji2UCev1Rde4kEEcfS/+77xH8WTQeSLvaGUuAOko4lrIc/kuBnae4lC
         bLig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=U/D8itQFbcquUi6ypUZ48jaAzYaZ5NFPMVCkdAnYsYo=;
        b=EtT6yVmU/mnZO+BCTiqSF+RjyOV2yERMRsNVpQfrbBeDH2JyHKP8N9gy9C3mrBjMmj
         dXzj8WOJY1AG9/BI1yr2W+GkrG4P8VQGXTNUNAI9lZ38GwiCMFzQ3wM8EZzsaR4v8UEM
         5GbjeK+8gEV/74k5vyvUFTEYjfnzfQAGLy3NBlmPiOkZg2ggRgAO5cm0lVofxfW2EYKq
         uEGgiJFMOXemvEkoclSyBa/Tko+SKZBrkpS/SfywqgAuPRD9N3JE5BL3iPL9OKRWDe+B
         TAvJWzl/kxvHXFl6lzwoRDIFOegqBGV5YADWr+xNZRf/GQlyMiO2fty4U7abD/3pBZy3
         lVHA==
X-Gm-Message-State: APjAAAUnNlM13PxutAq/Yo/LqQR6t8Xr+whGkvIKRWBnPK7OqXGHfTjD
        RVhCBc7I6LUY+cJbW2xZb8A=
X-Google-Smtp-Source: APXvYqxSecis+iDcqjPYHDtt+PO9rjntW19inpXlI8wyQlMvzI22gQf5Dkja1snLCp4ysHggowPniQ==
X-Received: by 2002:a63:89c2:: with SMTP id v185mr9307795pgd.241.1565211317217;
        Wed, 07 Aug 2019 13:55:17 -0700 (PDT)
Received: from [172.27.227.247] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id w132sm94268100pfd.78.2019.08.07.13.55.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 07 Aug 2019 13:55:16 -0700 (PDT)
Subject: Re: [RFC] implicit per-namespace devlink instance to set kernel
 resource limitations
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Jiri Pirko <jiri@resnulli.us>,
        netdev@vger.kernel.org, davem@davemloft.net, mlxsw@mellanox.com,
        f.fainelli@gmail.com, vivien.didelot@gmail.com, mkubecek@suse.cz,
        stephen@networkplumber.org, daniel@iogearbox.net,
        brouer@redhat.com, eric.dumazet@gmail.com
References: <20190806164036.GA2332@nanopsycho.orion>
 <c615dce5-9307-7640-2877-4e5c01e565c0@gmail.com>
 <20190806180346.GD17072@lunn.ch>
 <e0047c07-11a0-423c-9560-3806328a0d76@gmail.com>
 <20190807114918.15e10047@cakuba.netronome.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <c3cd420e-4071-c1b3-4ecb-c995f57ee8ed@gmail.com>
Date:   Wed, 7 Aug 2019 14:55:14 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190807114918.15e10047@cakuba.netronome.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/7/19 12:49 PM, Jakub Kicinski wrote:
> Perhaps I'm misinterpreting your point there.

yes, this thread is getting out of hand.

I am not pushing for an in-kernel, fib resource controller. Jiri wants
to remove the existing devlink resource code from netdevsim into a
standalone driver, code that was added for testing and as the commit log
shows as a demonstration of how one could create a controller using the
devlink API. I added some color commentary as to why a devlink
controller makes sense for the use case and how it should work, but I am
not asking for such a controller to be added to the kernel.

The netdevsim resource controller is counter based; the absolute
simplest form of limits. If I wanted basic counting for a fib resource
controller, I would add an option to limit the number of fib rules and
routes using sysctl similar to what exists for neighbors. Consistency. I
don't need the overhead and unrelated messiness of cgroups. I don't need
the overhead of handling fib notifiers. fib (rule) add -- check counter,
increment counter; fib (rule) delete -- decrement counter. Simple, per
namespace, done.
