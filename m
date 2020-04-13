Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE1271A6C51
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 21:04:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387804AbgDMTE4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 15:04:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1733140AbgDMTEy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Apr 2020 15:04:54 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6DADC0A3BDC;
        Mon, 13 Apr 2020 12:04:54 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id j4so10565122qkc.11;
        Mon, 13 Apr 2020 12:04:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wC/txZshdYx4OnuDmE/oKJ8R6zLqF3vRrj2okliQpoA=;
        b=o5A22m6Mi3eXHCviKB+nMb5Zmc3fDgfT10Sab0BmTJvRTwTi8QMDyKMQJFpIXnKuAo
         f1Jc8EeKBf0uCKiMWlFeLR8Cl3bBSiVWo1uC7ZWUYi9EBQnrgQRs9kxXXlBNnQb+fkkI
         kJ9LrVlRQhls2aiNLCmH6f90Vs3ZcS4JOnbftVzAkz23q1fbOp2PNopArmwDEnIRN5GQ
         ED7eo0Cjb3+q1eDCZaP1MpmD+SHBcmfORZKrwgUeePh5J/eCAMIuCHOwZNLEd8X+bXDc
         /AZ9AB1Wftsm/Ta7Uc1seioXfYbCUesqrIplByGwvGhUHbjvLtsR2mOg5jA7iBw344Bh
         ZPgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=wC/txZshdYx4OnuDmE/oKJ8R6zLqF3vRrj2okliQpoA=;
        b=ZwvtGq0YZejt0Y33Uc9fjwEwNo92cr9tDURms97uGRPR3wrpzZIyK0T1Tf0U4GdIw+
         u4twGx0oYfwm//7V1OTKU5NdXzewtFTmxHYgVKETOxwAwwRrn/sfqbx2cjuW8q9DA7Qg
         /ibBssLyVObzk/Cz6eOkl75Uw7SSmJZ8fETC1qfYWR9ve7DkizjPHtPMR9VHz9bULPGk
         U3BmYArOk5TR92vGw+u0Yg6NuJ/FLbA7gch1GTe+So2/B1fK02qtmj4NvvG0V0ZTtLJk
         Nadkg9itxS9UEm2UwYmr2/CBolwcmYwFN+P7qx/ql1CybWxgjWQIy7CnP0AV0NNvyi6m
         L0ow==
X-Gm-Message-State: AGi0PuZsf/O8ZgqqGBPC74XJ70K6kgaqSEICOZNtYV4MmqdqrtPx/JUW
        ZQy+Ae5meDczoBwRrFmka4c=
X-Google-Smtp-Source: APiQypK0fZxl+lLGyvKierlixb1ZwXMRqJmhoH7tz97J8X1oD+RPhTwnKmxOKO2e8GbeXeRJrP9rOQ==
X-Received: by 2002:a37:a555:: with SMTP id o82mr13064046qke.397.1586804693911;
        Mon, 13 Apr 2020 12:04:53 -0700 (PDT)
Received: from localhost ([199.96.181.106])
        by smtp.gmail.com with ESMTPSA id f127sm8816925qkd.74.2020.04.13.12.04.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2020 12:04:53 -0700 (PDT)
Date:   Mon, 13 Apr 2020 15:04:52 -0400
From:   Tejun Heo <tj@kernel.org>
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-api@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Serge Hallyn <serge@hallyn.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Saravana Kannan <saravanak@google.com>,
        Jan Kara <jack@suse.cz>, David Howells <dhowells@redhat.com>,
        Seth Forshee <seth.forshee@canonical.com>,
        David Rheinsberg <david.rheinsberg@gmail.com>,
        Tom Gundersen <teg@jklm.no>,
        Christian Kellner <ckellner@redhat.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        =?iso-8859-1?Q?St=E9phane?= Graber <stgraber@ubuntu.com>,
        linux-doc@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 6/8] genhd: add minimal namespace infrastructure
Message-ID: <20200413190452.GH60335@mtj.duckdns.org>
References: <20200408152151.5780-1-christian.brauner@ubuntu.com>
 <20200408152151.5780-7-christian.brauner@ubuntu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200408152151.5780-7-christian.brauner@ubuntu.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Wed, Apr 08, 2020 at 05:21:49PM +0200, Christian Brauner wrote:
> This lets the block_class properly support loopfs device by introducing
> the minimal infrastructure needed to support different sysfs views for
> devices belonging to the block_class. This is similar to how network
> devices work. Note, that nothing changes with this patch since

I was hoping that all devices on the system would be visible at the root level
as administration at system level becomes pretty tricky otherwise. Is it just
me who thinks this way?

Thanks.

-- 
tejun
