Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF37758E14
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 00:42:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726563AbfF0WmM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 18:42:12 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:46828 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726445AbfF0WmM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 18:42:12 -0400
Received: by mail-qt1-f196.google.com with SMTP id h21so4255853qtn.13
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 15:42:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=LmZBei85E6CwS8s1gfZS7GlTQ4QQJHQtLnPi5kcgHQg=;
        b=t8cfLw4XUA2OwKn02Mgo4goCmSc7AkcS3znBp25i8yu9VhaRNaScr45PvzGEzHeVwm
         HezLnmbKvR13B9o/VsS6nFZgXLuBsbRa7XeYDOZzcqf6sSz3Th1oTaAKvRixb09pl5gM
         zUj/kt9/SMsMRcEDuWDpJ+1Gn4c9ppT6ogAeaRSmCBlfBclFR/OMoV6LdMC0SuJgtu/z
         kf4i2HZaR5XJAlOM0Q+qS5XEKfBJEUYvD7SUmXx+RPz99uYhUCZ6thb3liogS01Yt/Jv
         xJqXZNcyJJS+O4DGw5YboOqbGrb6i9yHGdXY3Y16vT9UHZm+Crdcqms8+PQ5Dix6FrmK
         oEWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=LmZBei85E6CwS8s1gfZS7GlTQ4QQJHQtLnPi5kcgHQg=;
        b=JVqgLQqN+Yn2POkWzqo3eLoaMpcu7gSvMQKVoWSMMgrjBZed4JO03oANOVn4yuOVde
         XW/gGe0RdZyBCANZ1277Pj/EL8ilAmwvOPJAsy9NnAHlw9DIj2QuMg6Drz2FQ+6uUUnP
         qjg3CivW0bOzFL7XrgxzJQ9zVQ8zIyEgf5wL8iGGXxJNymAdyJ2IBDRmH6oCEGOKg/By
         SNUFuGHKru0csZtqHVzWkJUZdGc5a4c+2+vNhUvvViEt3RK5j79AJwwqJIxNJ+xJtgKN
         X8tju1sDRJ0mPMr//4rwFRN/hKSX6qS8UyweQXJlX8xiii3XuNRFNcCRYEkq/HhdGv+i
         JPrw==
X-Gm-Message-State: APjAAAXr+huh44+eRA2Hi2Ck8ora3SHj01RojCe/UvQCicf0gcvytBIa
        BXOO65rg//WT0O2Mtif2bkPDRw==
X-Google-Smtp-Source: APXvYqytd/yVlvFlGvghz1+apVKt+Jk63KmG9K2bT43X2V3avUagDbiOyL16iGISUVpAdqUQ8jLaNw==
X-Received: by 2002:ac8:2a0a:: with SMTP id k10mr5603129qtk.148.1561675330998;
        Thu, 27 Jun 2019 15:42:10 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id h40sm250410qth.4.2019.06.27.15.42.09
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 27 Jun 2019 15:42:10 -0700 (PDT)
Date:   Thu, 27 Jun 2019 15:42:06 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     <netdev@vger.kernel.org>, <bjorn.topel@intel.com>,
        <magnus.karlsson@intel.com>, <saeedm@mellanox.com>,
        <maximmi@mellanox.com>, <brouer@redhat.com>, <kernel-team@fb.com>
Subject: Re: [PATCH 4/6 bfp-next] Simplify AF_XDP umem allocation path for
 Intel drivers.
Message-ID: <20190627154206.5d458e94@cakuba.netronome.com>
In-Reply-To: <20190627220836.2572684-5-jonathan.lemon@gmail.com>
References: <20190627220836.2572684-1-jonathan.lemon@gmail.com>
        <20190627220836.2572684-5-jonathan.lemon@gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 27 Jun 2019 15:08:34 -0700, Jonathan Lemon wrote:
> Now that the recycle stack is always used for the driver umem path, the
> driver code path can be simplified.
> 
> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>

I guess it's a question to Bjorn and Magnus whether they want Intel
drivers to always go through the reuse queue..

Could you be more explicit on the motivation?  I'd call this patch set
"make all drivers use reuse queue" rather than "clean up".

Also when you're changing code please make sure you CC the author.
