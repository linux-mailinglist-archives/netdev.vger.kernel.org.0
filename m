Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF8BF77142
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 20:30:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387433AbfGZS37 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 14:29:59 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:39835 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726539AbfGZS36 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 14:29:58 -0400
Received: by mail-pg1-f194.google.com with SMTP id u17so25155045pgi.6
        for <netdev@vger.kernel.org>; Fri, 26 Jul 2019 11:29:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1N4TT7HcMyCz+oNFaNKxQbyESzqeum5I6auwLgNOfPs=;
        b=G2OKyNuJ6wBHfsk7j7r3JhW1OQgqNOZ+r8Iek328CbRa0cn+OZvl57A58mg8eEgfTc
         FSplbV7+PFQK2caIW2w7iKTyuZJXa3vywFv/oh5faKudNf97fYJnx/v8sdDuh8N7Vdrg
         Ief3NbPupY4nr2wvbHYx7pUTvmmBSEW0631ccTAfjvqq8xEWCIl2fXcpSCgzwAnXvXzF
         ld3HbJHLjGUvqZ7jlrAkMStvGrDJtQuraffPHxTdGcJGYc0oZuPt73n3rOb9IoBT+GE0
         vUYwZ/94Xdq2+V3oyqlRL4YF8xRfBdpEKW/KCpDDQFM4jBrqsaXFvr+fDqmKPkE5iBgG
         TelA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1N4TT7HcMyCz+oNFaNKxQbyESzqeum5I6auwLgNOfPs=;
        b=VnH6FaKKHQzMKPmOfJ97aZEi0XINu8PfbqKxeIEqyLbV8rmfojtH4VdHQCEXkE3HEy
         jfr9dS+1Q5bM0PXWsL+blh7SUzu4AGl4Y7mYVBm4NE+qL7Ws+mHVt05zb2JmSnUBMPae
         vTJG2EUNEL5W/NTg6eFO/IPJ0p0Aix8R3l4DvwT7pEDKNOdTz4k6BYzYEspVADHmnfaj
         YepIQ7on4nxBjhfuibvmqNwMC6He/aCRRDyAdsdrjaiDBw5pnmo7thUATlw3ryufdj0w
         MSDBujRWinmoXSE4cZE/73vXj3z4e+H6owyFqne0Gnn8de2Vij5Q2Aq8qCI4ojXS3rth
         P2wg==
X-Gm-Message-State: APjAAAVNr8xDgJuMkFXCachcaYtvrRno4y+m+YREuBMUwkDky6zIkPAe
        RoXTtHYaziEJQGEjLrdkRGA152HJ
X-Google-Smtp-Source: APXvYqzCxNFeqWVDqVlwxGmMHEcYoKyOJrgXNBrjy8Hxs3NLqZOmE/L2C2fwx61Q0dUGdPpRQv/1Rg==
X-Received: by 2002:aa7:8383:: with SMTP id u3mr23729702pfm.175.1564165798193;
        Fri, 26 Jul 2019 11:29:58 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id f64sm56581716pfa.115.2019.07.26.11.29.57
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 26 Jul 2019 11:29:58 -0700 (PDT)
Date:   Fri, 26 Jul 2019 11:29:56 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Sergei Trofimovich <slyfox@gentoo.org>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH] iproute2: devlink: use sys/queue.h from libbsd as a
 fallback
Message-ID: <20190726112956.3b54f906@hermes.lan>
In-Reply-To: <20190724081838.18198-1-slyfox@gentoo.org>
References: <20190724081838.18198-1-slyfox@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 24 Jul 2019 09:18:38 +0100
Sergei Trofimovich <slyfox@gentoo.org> wrote:

> On sys/queue.h does not exist linux-musl targets and
> fails build as:
> 
>     devlink.c:28:10: fatal error: sys/queue.h: No such file or directory
>        28 | #include <sys/queue.h>
>           |          ^~~~~~~~~~~~~
> 
> The change pulls in 'sys/queue.h' from libbsd in case
> system headers don't already provides it.
> 
> Tested on linux-musl and linux-glibc.
> 
> Bug: https://bugs.gentoo.org/690486
> CC: Stephen Hemminger <stephen@networkplumber.org>
> CC: netdev@vger.kernel.org
> Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
> ---

This is ugly and causes more maintainability issues.

Maybe just fix devlink not to depend on sys/queue.h at all.
It makes more sense to have common code style and usage across all of
iproute2.

We already have local version list.h, why continue with BSD stuff.
