Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B95918BD80
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 18:06:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727941AbgCSRGC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 13:06:02 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:41914 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727252AbgCSRGC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 13:06:02 -0400
Received: by mail-pl1-f196.google.com with SMTP id t16so1311861plr.8;
        Thu, 19 Mar 2020 10:06:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mx5DvKRxxyY0wOXhg3EMG7KO1PdJZR/OsFUrUGU4uMU=;
        b=HrfUN9onw2GKU3By5XzeMxV4A2DkIlcAaScCEhbKccaRCA+OW2V6qh8AoUDCoWha7V
         0HEXobtHm3m0bXeWOXK3tU17wqzevx+HMwNLAIzJVVHXnHwR40Vpa4XqWCLPAV/+FA84
         5S2bV9Zi4iQ2gzOr7yr029PN17Fafm1cf2xFuHRC1N6vfWUz6MXjKkqq50cwmZPJd6H1
         9gA04W9nJUkkwJ1edEpeoDffEQOH+c9S+5XBuazlP6dOff1OIcDXGjUH9geKiyqZARKg
         c5u0dxMjrqthNWNbdR325ouwMVdvQcDTs1WPP6c5KHagiz8xHyFKC09UpQgPiGjmZB+s
         8ZhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mx5DvKRxxyY0wOXhg3EMG7KO1PdJZR/OsFUrUGU4uMU=;
        b=mkjMNWNHwZPAmeon0OpLhHD4hQXjxJhJyUI7/XZoBditaSEUXIVHiSLs7zmwvHnN77
         yX52cPm+kNd6XVW5Wew4BMhl2eu7M+toKDZ8HUs8veVEw4z6kF+WA5YtGpo4VBMJgLIH
         AX7iRHX1B0V8qLOLTJW03UtGzctDPQn1Le6CkDqOYsOPyMcTWlQpWrLDjDk1IcP28eM2
         rSudGZQQMDVKZ3k3S8eGGaUmk0S7xnV11AxxSKddna2qK3zy8084/a6TJ5MHj0J0UBXO
         B9XPR0DQ9BG8O3NxHhLW8GgoSKIfE8eurADC95+OaHNXF5VFdtQtLGpMYWUe5KM4JloA
         wyzQ==
X-Gm-Message-State: ANhLgQ05HCV3Ctiny3b7/QQ+bieeK4O14UKnvuoBDXTj8z5WI5PkPdOt
        FQQtkl4+oNKGjWj1RWubLuhGAFlV
X-Google-Smtp-Source: ADFU+vtTjX6mFt5mDmZhoMIKgm6kXf7ZrUipcu5gC03ub9yW3xvkOkQXcMFAYEeZimyXVTqa8FPxKg==
X-Received: by 2002:a17:90b:1911:: with SMTP id mp17mr4866372pjb.196.1584637560067;
        Thu, 19 Mar 2020 10:06:00 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id a3sm2957980pfg.172.2020.03.19.10.05.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Mar 2020 10:05:59 -0700 (PDT)
Subject: Re: [PATCH net] ipv6: don't auto-add link-local address to lag ports
To:     Jarod Wilson <jarod@redhat.com>,
        Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Moshe Levi <moshele@mellanox.com>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        Netdev <netdev@vger.kernel.org>
References: <20200318140605.45273-1-jarod@redhat.com>
 <8a88d1c8-c6b1-ad85-7971-e6ae8c6fa0e4@gmail.com>
 <CAKfmpSc0yea5-OfE1rnVdErDTeOza=owbL00QQEaH-M-A6Za7g@mail.gmail.com>
 <25629.1584564113@famine>
 <CAKfmpScbzEZAEw=zOEwguQJvr6L2fQiGmAY60SqSBQ_g-+B4tw@mail.gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <3dbabf42-90e6-4c82-0b84-d1b1a9e8fadf@gmail.com>
Date:   Thu, 19 Mar 2020 10:05:58 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <CAKfmpScbzEZAEw=zOEwguQJvr6L2fQiGmAY60SqSBQ_g-+B4tw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/19/20 9:42 AM, Jarod Wilson wrote:


> Interesting. We'll keep digging over here, but that's definitely not
> working for this particular use case with OVS for whatever reason.
> 

I did a quick test and confirmed that my bonding slaves do not have link-local addresses,
without anything done to prevent them to appear.

You might add a selftest, if you ever find what is the trigger :)


