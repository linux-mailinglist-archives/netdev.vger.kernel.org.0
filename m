Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17B331FFE3C
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 00:37:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730819AbgFRWhA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 18:37:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726835AbgFRWg7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 18:36:59 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D1D6C06174E
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 15:36:59 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id b5so3591007pgm.8
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 15:36:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=EAVbySmv4TpjrMlndczG6CFd33d4RC5FSGNEOklNIX4=;
        b=uQKg5tvD14L1EYKgt1cqWMgfoOW0XKF/zgMl+aEgMBxXbYsNPKL/GuT+59EbEvRu+a
         TyChP9WGfTkEfCrXckY0wHhoAnMC0Pwuh7nZmjF7r798kBkhPVIk7M+Bdx1gygGNs1zx
         ld+H92GBq5DHaiF0u66fCOEH4QGErk5+Ousi/WUoER0f/E7lW1kU4ijZ/dK+QUI+2asz
         FJ5p3Oq1RilNzo2c7ncnPccB/b+IQ2izCu9PC/XBArdLu8VF+a6WjnQbaTCzhgbRBsY+
         jYGTY1mHj6qeJO73uQ274Mjt97qODp3Z/uc3f3mOmkWXGyQDSqplIWeGe99liek40utL
         9dyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EAVbySmv4TpjrMlndczG6CFd33d4RC5FSGNEOklNIX4=;
        b=l0NiG4AHL2OX4kj7KaQsXfo1gJzjSNhppXU4skVlHu+uF3irjn9GFJVtox6tW2uJYd
         lRqARvHfwj0q7aIcvwpnD5eEn9afcPEctuGVrb5JSIFXmqV+vs3UuZVl9bYg5NoR2XI3
         v6X2Mkh6qeX1r8vTKIUP29GkzYIfIndrXWjTHJAk0zPIXr9OYsU1mhobr/pE499FGI+t
         UomlvxedwKL7xXndGxCwfe+e7B2oblo2Rf7YlfO3/22DlSoFIyChbMBXbL3sSh6Agtn1
         5S0JZcdUosEphD6QpURxXTYh9gQZzkDQx0IjGZt1YhOVQ+b9z8iSvw/A8l4dOMWcNSNS
         cF9Q==
X-Gm-Message-State: AOAM533aqBpNWJdENxV+e46p6PuWa1O8c0XqgXUjVuePAEn+Vu+U0j0y
        WxKHkD1+m2zBcVB1Lxmh+Sk=
X-Google-Smtp-Source: ABdhPJwzIJ+zJl5u+29QN7LTr6MVFC+US1OOvUewR364nyGu4JTpVmDxc9QeAHARQwrWIqRUAUs1pA==
X-Received: by 2002:a63:694a:: with SMTP id e71mr607268pgc.432.1592519818803;
        Thu, 18 Jun 2020 15:36:58 -0700 (PDT)
Received: from [10.1.10.11] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id o207sm3891085pfd.56.2020.06.18.15.36.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Jun 2020 15:36:58 -0700 (PDT)
Subject: Re: [RFC PATCH 06/21] mlx5: add header_split flag
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     netdev@vger.kernel.org, kernel-team@fb.com, axboe@kernel.dk,
        Govindarajulu Varadarajan <gvaradar@cisco.com>,
        Michal Kubecek <mkubecek@suse.cz>
References: <20200618160941.879717-1-jonathan.lemon@gmail.com>
 <20200618160941.879717-7-jonathan.lemon@gmail.com>
 <4b0e0916-2910-373c-82cf-d912a82502a4@gmail.com>
 <20200618215053.qxnjegm4h5i3mvfu@bsd-mbp.dhcp.thefacebook.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <c55caf80-7e85-c5d9-da53-9eb128e8fc82@gmail.com>
Date:   Thu, 18 Jun 2020 15:36:57 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <20200618215053.qxnjegm4h5i3mvfu@bsd-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/18/20 2:50 PM, Jonathan Lemon wrote:

> In the same vein, there should be a similar
> setting for the TCP option padding on the sender side.


We had no need for such hack in the TCP stack :)


