Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1ED35A6D3
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 00:21:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726849AbfF1WVB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 18:21:01 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:46957 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726563AbfF1WVA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 18:21:00 -0400
Received: by mail-pl1-f194.google.com with SMTP id e5so3968713pls.13
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 15:21:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=koFBRXiQxfEah6hbnE6eGuH1wqYmXqksWsHv41+REbg=;
        b=CChsUbxfBtD3gqbdjJhOT8+8Ihi1mh7Le+XosGIobiUqXrOEBCLq9a/8SEyX8EHI3t
         0AOtr4dIDE/r1JssDrIR9A0G7SklDtMbJHazJD8ZpHWE6/rmc9savA+SO0sZkXHezGNj
         enTHRTj+zpIz5TprMoYBogJAQW1dFKAyfSDE4S2Ox33FBa1Jv+etf/m/u28GlmttOFI/
         Mfae5t0BVOy48l2NTavreHgDva9f9WVxM3GkyhiLgt24XYgq848DN3XC+DzDkvbW7A+u
         prqLqUDyiPrEuSCfC9vCZ3Kmx+z9yetYtDidCQ4e4I3JprLrAhMyAWs2MHQRpY9vZ93q
         ynaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=koFBRXiQxfEah6hbnE6eGuH1wqYmXqksWsHv41+REbg=;
        b=tybI85RAgOJCV5fat/rbEKOz1LLTYpQ/7FHiiIkpeLNnXax/5Wj6yFsIq7VGONBSbY
         j8c6ldZsndI1kV/ktkC+lPOGKVe0gU8aJY+Teq9vpPOsslSJV5H2Jf/cOaSuJEOdQ47R
         9ZY3f2iT/KPT0C+/ALAcOoOlfcck/cSBlhKTNCQezXURiNumkuOq9KFUBpN+0JY25OHF
         pBHrbFkreryhk7ED1kteTf+NCQPtO87Tu3ohlURPzWOkdQU4yZK2QS5T+2kQN5G2Ree0
         I57JedNV+yPum5C8FuVeeL3qx6ab3ZPH84+VmZAqZElnuuwSAWgzt1/hVtNzbjGLFCe+
         R4Jw==
X-Gm-Message-State: APjAAAUi5gV57tdd0qP0Ru47Y8XJYZT/anMGVkXW7BPljyHAM1XdHRcT
        OIgksSxhKRFfwTRKOI22NZjdyA==
X-Google-Smtp-Source: APXvYqxFN/RnpAQdLH1nxXDalVPAyrJ10taH/8ug6t3/d/gC+VVTR1dzhe/F+GfHwZgSW3qp16PHuw==
X-Received: by 2002:a17:902:a516:: with SMTP id s22mr13934223plq.178.1561760460033;
        Fri, 28 Jun 2019 15:21:00 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id o16sm6101135pgi.36.2019.06.28.15.20.59
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 28 Jun 2019 15:20:59 -0700 (PDT)
Date:   Fri, 28 Jun 2019 15:20:58 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Andrea Claudi <aclaudi@redhat.com>
Cc:     netdev@vger.kernel.org, dsahern@kernel.org
Subject: Re: [PATCH iproute2 v2 0/3] do not set IPv6-only options on IPv4
 addresses
Message-ID: <20190628152058.67501bc6@hermes.lan>
In-Reply-To: <cover.1561457597.git.aclaudi@redhat.com>
References: <cover.1561457597.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 25 Jun 2019 12:29:54 +0200
Andrea Claudi <aclaudi@redhat.com> wrote:

> 'home', 'nodad' and 'mngtmpaddr' options are IPv6-only, but
> it is possible to set them on IPv4 addresses, too. This should
> not be possible.
> 
> Fix this adding a check on the protocol family before setting
> the flags, and print warning messages on error to not break
> existing scripted setups.
> 
> Andrea Claudi (3):
>   ip address: do not set nodad option for IPv4 addresses
>   ip address: do not set home option for IPv4 addresses
>   ip address: do not set mngtmpaddr option for IPv4 addresses
> 
>  ip/ipaddress.c | 15 ++++++++++++---
>  1 file changed, 12 insertions(+), 3 deletions(-)
> 

Series applied. Thanks
