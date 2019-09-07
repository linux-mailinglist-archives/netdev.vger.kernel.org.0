Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1FEAAC469
	for <lists+netdev@lfdr.de>; Sat,  7 Sep 2019 06:18:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729383AbfIGESK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Sep 2019 00:18:10 -0400
Received: from mail-pf1-f178.google.com ([209.85.210.178]:45641 "EHLO
        mail-pf1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726141AbfIGESJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Sep 2019 00:18:09 -0400
Received: by mail-pf1-f178.google.com with SMTP id y72so5845932pfb.12
        for <netdev@vger.kernel.org>; Fri, 06 Sep 2019 21:18:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=/y66JKrfnVZgt0YVQUbBNEorefQgDoJjzb7LMVWdDv8=;
        b=0jCkkUDQySsJl5OuJQZaH5g2b4heNgMqUrmwsJqt+6+7o4Rvo0jdcfVlzktD/7l4ui
         fNhg4hzP6/tWRYbUXXaUlMdw3D7AnjhuCljm5JZ4NuvvN1nxlDnFIX7h4w4zL/Cny5az
         Jmt9QR3/nkyFwCnllZDZFFU51C3jcHCorVybuFXb3wlxylTcCt7H4JZEOqwS39xhqWo7
         miFdgryg+VmbE4r7ZZ0MauSkgec1wKQM1b4aTbNZZEniNpXaiFF+nBZpfeXdnNXEVl7m
         Ch6dVTAgZUrtEPdB/F+jJtwOXt2PNCJPQFhssX6ajvPzqFnYgcM1+woD+7gcoNzQT28H
         8pog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=/y66JKrfnVZgt0YVQUbBNEorefQgDoJjzb7LMVWdDv8=;
        b=ZRfkmX6oHpOpLjDy92kLQ7c98YUyE4bYDaEnS5HoQQA80DpU7Uu0cauceETvbGnome
         OJ+uDiQ4XSHMm1/gS42XgFG4Y5oH8QG6pskWGkjeVBnc2hYY3hfYBYuxg6S5HBPIhmUE
         UKPWG44C+PVBBxc6R4JEdKN3Isir8+tCvdRL91KEIa026ILHSGjD7gJIBPeDbt+JZUPX
         d0tAiXiGfppU/9eyR+hIZV1aeB0v6a0/q+HRnrfwwi97ExmPEzURuSrY2+GvuQfhvOm/
         Ac/U5OnBtuNHINhAFqd1nzN6gY3eXs4kd2DRYGZw9VbYCZuxEUvrv0D85vSJubXiGiKe
         2ohQ==
X-Gm-Message-State: APjAAAWoYeJRr1SjiHwiA5FQKckN8u9PdBLb7eeatj0Db0rL1Gok4Ij6
        tVWmWoQDfrH/uVxl4Srfgz41EQ==
X-Google-Smtp-Source: APXvYqzkrFkg8BSt5eptHcRDWtzo7Egfj39mCIJm47gT/tz7mAjwKEIJyPz+c4Dj9uKSPFFbHdgDNQ==
X-Received: by 2002:a17:90a:ca0e:: with SMTP id x14mr13628584pjt.70.1567829888933;
        Fri, 06 Sep 2019 21:18:08 -0700 (PDT)
Received: from cakuba.netronome.com ([45.41.183.19])
        by smtp.gmail.com with ESMTPSA id z23sm9676667pfn.45.2019.09.06.21.18.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Sep 2019 21:18:08 -0700 (PDT)
Date:   Fri, 6 Sep 2019 21:17:30 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Dirk van der Merwe <dirk.vandermerwe@netronome.com>,
        Simon Horman <simon.horman@netronome.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        oss-drivers@netronome.com
Subject: Re: [net-next 02/11] devlink: add 'reset_dev_on_drv_probe' param
Message-ID: <20190906211730.5c362b48@cakuba.netronome.com>
In-Reply-To: <8066ba35-2f9b-c175-100f-e754b4ca65be@netronome.com>
References: <20190906160101.14866-1-simon.horman@netronome.com>
        <20190906160101.14866-3-simon.horman@netronome.com>
        <20190906183106.GA3223@nanopsycho.orion>
        <8066ba35-2f9b-c175-100f-e754b4ca65be@netronome.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 6 Sep 2019 11:40:54 -0700, Dirk van der Merwe wrote:
> >> DEVLINK_PARAM_RESET_DEV_VALUE_UNKNOWN (0)
> >> +			  Unknown or invalid value.  
> > Why do you need this? Do you have usecase for this value?  
> 
> I added this in to avoid having the entire netlink dump fail when there 
> are invalid values read from hardware.
> 
> This way, it can report an unknown or invalid value instead of failing 
> the operation.

That's the first reason, the second is that we also want to report 
the unknown value if it's not recognized by the driver. For u8/enum
parameters the value may possibly be set to a value older driver
doesn't understand, but users should still be able to set them to one
of the known ones.

We'd also like to add that to 'fw_load_policy'. WDYT?
