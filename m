Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3CE413A03A
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 05:28:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728991AbgANE0U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 23:26:20 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:34377 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728795AbgANE0U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 23:26:20 -0500
Received: by mail-pf1-f195.google.com with SMTP id i6so5948753pfc.1;
        Mon, 13 Jan 2020 20:26:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=2KUHq2WXOjKK2jLm9wk0AGdw/pEX7ndYWZH2qpSDTzc=;
        b=SOqzHS5I9vSPFY8xZKc65/zhaEMR9q0tiSZ0UD5lMlsVMyWn1fA0/EMa205IbKFU5E
         P0F/vRDsvhq7C/3BTf4aK2zDH9VTzRA2UetHHDu4jP2sxfKTRVp3W5z0zuB4mGlNUzU1
         HmeX7vrou8VIqQTPCtFsc+2Q7ACAzO5cm+DfTf3OQyfSu8zuYAId33tpl2Lo5dBvuiIi
         sPxvR0ChQs50pAgrTClZxyEjktnX/5Dqj6r2v8KhNpDmeK2l4f84vJ4ciQjteOfC25/R
         I0jpQU6RZyBtwLMQEYROdva0zp9Ng4mzUGmrFksIfNSzNtyzHC02KOjk3PvyZQnINP0p
         PehA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=2KUHq2WXOjKK2jLm9wk0AGdw/pEX7ndYWZH2qpSDTzc=;
        b=AOv4Y2eiHr5WxPKmSdqQxyNpwS2VgxVNskJ4BgukJoIlmT+3DDJrJd0Q7hOm3nV2Rv
         yi9TPk3p5EMTVlC9S23wqtSHSRDvg0P/Cdktl+ecz7FpNgbTL5M5Z9/Ko0ur4czW6pKd
         hahNhs2jiAYP+etPeHbf2gQA/I/52GgB4fCIgtDwc2OPpJcuh0e95WKC18J2t02wCiRt
         qnDNGkMj5AK5d0K1/tLbBwLU27rrkCKZ+e13gjpm6FYOUjN18N+R86Cm3gAact4GBNtr
         AoYdEb5N7fvjV2CkZ7PBU/Bv8Z4BRVTYaEj8k1ThtAWG0c0aQH5yZLpbYR4Kwkx8kZOA
         Tnsw==
X-Gm-Message-State: APjAAAWL4xPs2i46xGCFbn6nFeCh9ne+rPR/VN3m/jOCN9KdSq8bdoNB
        CTHRq5lU1Xh2R6fMfsjYGlA=
X-Google-Smtp-Source: APXvYqyFE2nlkVhSYfgbiHs/QLE7+qhUpRExWPVTXDztfJsxAKhzJ+Q7pdP4VOuzKQQKiugDCg8ypQ==
X-Received: by 2002:a62:ddd0:: with SMTP id w199mr22806813pff.1.1578975979931;
        Mon, 13 Jan 2020 20:26:19 -0800 (PST)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id j9sm15697386pff.6.2020.01.13.20.26.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jan 2020 20:26:19 -0800 (PST)
Date:   Mon, 13 Jan 2020 20:26:16 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Vladis Dronov <vdronov@redhat.com>
Cc:     Antti Laakso <antti.laakso@intel.com>, netdev@vger.kernel.org,
        sjohnsto@redhat.com, vlovejoy@redhat.com,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        artem.bityutskiy@intel.com
Subject: Re: [PATCH] ptp: free ptp device pin descriptors properly
Message-ID: <20200114042616.GA1459@localhost>
References: <3d2bd09735dbdaf003585ca376b7c1e5b69a19bd.camel@intel.com>
 <20200113130009.2938-1-vdronov@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200113130009.2938-1-vdronov@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 13, 2020 at 02:00:09PM +0100, Vladis Dronov wrote:
> There is a bug in ptp_clock_unregister(), where ptp_cleanup_pin_groups()
> first frees ptp->pin_{,dev_}attr, but then posix_clock_unregister() needs
> them to destroy a related sysfs device.
> 
> These functions can not be just swapped, as posix_clock_unregister() frees
> ptp which is needed in the ptp_cleanup_pin_groups(). Fix this by calling
> ptp_cleanup_pin_groups() in ptp_clock_release(), right before ptp is freed.
> 
> This makes this patch fix an UAF bug in a patch which fixes an UAF bug.
> 
> Reported-by: Antti Laakso <antti.laakso@intel.com>
> Fixes: a33121e5487b ("ptp: fix the race between the release of ptp_clock and cdev")
> Link: https://lore.kernel.org/netdev/3d2bd09735dbdaf003585ca376b7c1e5b69a19bd.camel@intel.com/
> Signed-off-by: Vladis Dronov <vdronov@redhat.com>

Acked-by: Richard Cochran <richardcochran@gmail.com>
