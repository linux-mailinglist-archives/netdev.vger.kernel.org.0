Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE97F3FE07C
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 18:57:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345423AbhIAQ6h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 12:58:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345409AbhIAQ6g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 12:58:36 -0400
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E78DC061575
        for <netdev@vger.kernel.org>; Wed,  1 Sep 2021 09:57:39 -0700 (PDT)
Received: by mail-ot1-x330.google.com with SMTP id i3-20020a056830210300b0051af5666070so506012otc.4
        for <netdev@vger.kernel.org>; Wed, 01 Sep 2021 09:57:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=giqz3wmXDwiNb+W4XLyWhWpM/fLXh7bHonLhIoXYdKI=;
        b=YdWDvImIkmRGtVOlX4avq7IdLggw4b0SGGBL7RXRcKCVWPgHBjzJtE+DxiG17aM/9/
         c2sUnqwNviPDxXtQ/IIarLc9yVTgx2eIsHN/gzYPPpDFF7i7EofTs74l5KQ6oZaUQUKF
         7b7spcCJas38iNqEyVM20Qd6A6knw4sbLTGduU1gfPwC293mnLIeB+k3as83C9S6oeli
         IuzGfa3mOaSS9J8pYmDZOH2DmQn/tQjpkZ37aJTwSMrsFP5Xro+AEMflI1NYVsYoZtnL
         Zidm1nDx/jgRnh8H+q5Oy10ZrjAWQha/wKZE0ocyg93JAPORkMQVX0KRoJWLhBGIX7Ld
         HgIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=giqz3wmXDwiNb+W4XLyWhWpM/fLXh7bHonLhIoXYdKI=;
        b=Vv0/i2M5lZVLkgBqmUJVt5sXr3tjmR7enbrvb4PVmSD+mtLZsS1pJenwlCyHnHwOCX
         bzdJd86ARSEOEAfQugMqu5TAt8h0zCtTOGI0n9TDBQJC7Z9D09gcRjozffUObL5ogya0
         L1k23jhTPcowwhrRkMidzVQA7Ttx4GGnwUp7VReL3WzMVStYa+JewOQFF2UEORugEfti
         h4QYgKhxefwHnSNDIuHRfICzUQg5CNznQvWOm9bSa/BSqm0wfQNJvAlN3qqoh8/tNb9T
         i+WIPsuwIZxTOR3wEFW3QcN3xcMeyPLuuIhJ+gRHVIE8QVY3zmbL59uwuLEd+HmRqUYZ
         GAhw==
X-Gm-Message-State: AOAM533XnA1BXCZjFVQe0IMVy87ZqIvBblz4oDr9hhReAjk3XzYCeeKQ
        BeVxHYm3+jsfQG06MAWTmvE=
X-Google-Smtp-Source: ABdhPJxkG7aL3p1TYFVehcnel2sPee3f03KJhjOOSpgiFj9h9IJuI5fBsO5F9CgBFvptKH9wmtWyeg==
X-Received: by 2002:a05:6830:1647:: with SMTP id h7mr323503otr.123.1630515458779;
        Wed, 01 Sep 2021 09:57:38 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id k8sm56476oom.20.2021.09.01.09.57.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Sep 2021 09:57:38 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 1 Sep 2021 09:57:36 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        edwin.peer@broadcom.com, gospo@broadcom.com
Subject: Re: [PATCH net-next v2 04/11] bnxt_en: introduce new firmware
 message API based on DMA pools
Message-ID: <20210901165736.GA2510553@roeck-us.net>
References: <1630222506-19532-1-git-send-email-michael.chan@broadcom.com>
 <1630222506-19532-5-git-send-email-michael.chan@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1630222506-19532-5-git-send-email-michael.chan@broadcom.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 29, 2021 at 03:34:59AM -0400, Michael Chan wrote:
> From: Edwin Peer <edwin.peer@broadcom.com>
> 
> This change constitutes a major step towards supporting multiple
> firmware commands in flight by maintaining a separate response buffer
> for the duration of each request. These firmware commands are also
> known as Hardware Resource Manager (HWRM) commands.  Using separate
> response buffers requires an API change in order for callers to be
> able to free the buffer when done.
> 

parisc:allmodconfig, and probably others:

drivers/net/ethernet/broadcom/bnxt/bnxt.c: In function 'bnxt_init_board':
drivers/net/ethernet/broadcom/bnxt/bnxt.c:12280:27: error: 'struct bnxt' has no member named 'db_lock'

There is a difference between "#ifdef writeq" and "#if BITS_PER_LONG == 32".

Guenter
