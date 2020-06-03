Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B476A1ECDC9
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 12:45:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725888AbgFCKpI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 06:45:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725828AbgFCKpH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jun 2020 06:45:07 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11C8EC08C5C0
        for <netdev@vger.kernel.org>; Wed,  3 Jun 2020 03:45:07 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id j10so1808736wrw.8
        for <netdev@vger.kernel.org>; Wed, 03 Jun 2020 03:45:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/YnE0O+Q12VSUWojSIFNw1I9cYzl9U/HVnxg1X2NGA0=;
        b=2Qph+gGfG/3dNJgiz7i+J0pAtm8+aGqgmRjwWPgb3lNQ7UhzZcD4p8Mpj9spc60UQh
         ugmlpfceiKTVKsQ2AT4hNFAMca5C0ANx3n4EdNFvqz9CL3/rp8w7r0dzVOeqryy3dyGd
         wAxVSP85qLZnKKTcdZqjmOhxgiXIBxBZJaoAUFjVB/wXNKfEVJG6T/OcKxSWbf09UY0I
         R3txs/BvI7H6OIGlIfsyFunEei8XElqX5Gn+I5t8jlWmRbXvdvMeoA2LG49s+hEWRbWG
         e+rd+z7Ygk2NF7Jbtp0y7HuoyD2hybLdsWCrbmg1+ZKX1EWn2nlkisxyGpDtjQPQ/bsJ
         8x6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/YnE0O+Q12VSUWojSIFNw1I9cYzl9U/HVnxg1X2NGA0=;
        b=lZ21G5HtpJxHt9JKxBaa09ulHYm4Jf2Qh7+8ONKHRwbIH5BuV1jfIlDC/W0mArckIH
         ERsMKJ5tw/FFZVSAtLP32piS2zVJPeLiXEGZHw0r/QxhoJgDRSvR8Y7jXXKVQ4PJKjmb
         MtDzZltXqGFD0XWwt4iOi+EHvhunw9palqgtsNJNsshhgEryGsod5p3e+oig5oSFHd/9
         6B93WG+lkAyk9aoTnM/lwoAG736ZguhdmGNIXOisg9lzlLUlFsa5YH7jCVcsL9Qu1Vpj
         tLJpqp0tUvpNzlQeUaQDeJ0DDx/YeSdQxm51U1tN7YAGTz1Jx0zj3rX3+Lbcrdegfvhb
         3JRQ==
X-Gm-Message-State: AOAM533g/xf2AWdHBbUZhp758lUJyHi9/wEGQbqY3L4i8TR4AgxZ+Cd7
        /AneD7vAPmfquJZUwPzuE5Zy0g==
X-Google-Smtp-Source: ABdhPJyT0oq9FDVtbQtst2hNWfGwBVlSwILzjXYduhDqD8qInf6Rb59PirLbNm6Kxz4xiZ0hQpcOnQ==
X-Received: by 2002:a5d:6cce:: with SMTP id c14mr29060838wrc.377.1591181105698;
        Wed, 03 Jun 2020 03:45:05 -0700 (PDT)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id x186sm2396262wmg.8.2020.06.03.03.45.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jun 2020 03:45:04 -0700 (PDT)
Date:   Wed, 3 Jun 2020 12:45:04 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Danielle Ratson <danieller@mellanox.com>, netdev@vger.kernel.org,
        davem@davemloft.net, michael.chan@broadcom.com,
        jeffrey.t.kirsher@intel.com, saeedm@mellanox.com, leon@kernel.org,
        jiri@mellanox.com, idosch@mellanox.com, snelson@pensando.io,
        drivers@pensando.io, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, mlxsw@mellanox.com
Subject: Re: [RFC PATCH net-next 0/8] Expose devlink port attributes
Message-ID: <20200603104504.GA2165@nanopsycho>
References: <20200602113119.36665-1-danieller@mellanox.com>
 <20200602123311.32bb062c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200602123311.32bb062c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Jun 02, 2020 at 09:33:11PM CEST, kuba@kernel.org wrote:
>On Tue,  2 Jun 2020 14:31:11 +0300 Danielle Ratson wrote:
>> Currently, user has no way of knowing if a port can be split and into
>> how many ports.
>> 
>> Among other things, it is currently impossible to write generic tests
>> for port split.
>> 
>> In order to be able to expose the information regarding the split
>> capability to user space, set the required attributes and pass them to
>> netlink.
>> 
>> Patch 1: Move set attribute from devlink_port_attrs to devlink_port.
>> Patch 2: Move switch_port attribute from devlink_port_attrs to devlink_port
>> Patch 3: Replace devlink_port_attrs_set parameters with a struct.
>> Patch 4: Set and initialize lanes attribute in the driver.
>> Patch 5: Add lanes attribute to devlink port and pass to netlink.
>> Patch 6: Set and initialize splittable attribute in the driver.
>> Patch 7: Add splittable attribute to devlink port and pass them to netlink.
>> Patch 8: Add a split port test.
>
>Since we have the splitability and number of lanes now understood by
>the core - can the code also start doing more input checking?

Yep, that should certainly be done so some of the checks can move from
the drivers. Do you want to have this done as a part of this patchset or
a separate one?
