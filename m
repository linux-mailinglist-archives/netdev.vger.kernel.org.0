Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B2933A728A
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 01:36:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230222AbhFNXiN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 19:38:13 -0400
Received: from mail-pj1-f54.google.com ([209.85.216.54]:33760 "EHLO
        mail-pj1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbhFNXiM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 19:38:12 -0400
Received: by mail-pj1-f54.google.com with SMTP id k22-20020a17090aef16b0290163512accedso789678pjz.0;
        Mon, 14 Jun 2021 16:36:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lr6aILUoCbQ0hKwSxYI3cPDsVRTQKFfkYKOXdzGE+8Y=;
        b=QnHLJOqXafWl0e3J2N2LKnzvddczLeLXNBfNP5AcHP3c60nLsDNpaFEbGVB6fp3z7Z
         OJo14j2hO9ECwtGMveRrWJTFqafDlIL4Q4esiUU45+XpQe4JM21qHACPmCfXWCXZOoc/
         OOjFKZbiQ3AWpZ2TBD2//u3CF0rcjZT1AzeJnQvGsdp0FfWQw3OySrR2yzIWrAKIQ61U
         j+vph7uVJ6yrglDy93CfNh8B1a6Ujqsg/O42nmqgBHDSvKq7MatenMGZ9GExeNJ6btg0
         73CxzwKYyk3pDdDyzT/2u0yXBAmtgR+Bj939d9cypfo83mDng2e5dQbmmdzNS4IZHs4c
         XEWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lr6aILUoCbQ0hKwSxYI3cPDsVRTQKFfkYKOXdzGE+8Y=;
        b=geVenMZUWrvxCWr1TQTX0Ad4dUEy27GuWzvP+MLevwX5BeJhiCYCMMqnVpifE8roix
         YRXotra4lnFUzXgiob7Vngg4/lKBBKrThZYbz9cCA02P5amrjKre7nzj/YC6Y8TQvUTL
         S0vY4mxWtNTNgrH9S0BWNHTVm8KAEwTKkwn+2tQRhh/zV6DaZ249z9v5LTZbwVD1tSce
         Qe2GnT56ccSqJxgm7Z9AQHnOGxKdTceAiyM2Fj7r6Vqzk8t4V3FdJS61mpQi9zbMlf0X
         klmSRSZEtyPp+G2y2wqY9s/5J3gjhp6IC7vJVsU/cVX3h0HxUXIvEkZfpI2LxjhrI4Z3
         JIzg==
X-Gm-Message-State: AOAM533KdjQnxGSg572RvXAmQRfmnJl0IkLXwmtIi8fsVq5CViDewdi5
        Gb3u7YS/zVtdYK+oUP1GuiE=
X-Google-Smtp-Source: ABdhPJzeU2mJGkBEiQkypCz/F5fvh7ADZhdu/3wyH2ITec5XcWTsIN5i4qV1USqwzLmTvik8YSBOxw==
X-Received: by 2002:a17:90b:3b92:: with SMTP id pc18mr21241387pjb.100.1623713708821;
        Mon, 14 Jun 2021 16:35:08 -0700 (PDT)
Received: from mail.google.com ([141.164.41.4])
        by smtp.gmail.com with ESMTPSA id q9sm10149196pjd.9.2021.06.14.16.35.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 16:35:08 -0700 (PDT)
Date:   Tue, 15 Jun 2021 07:35:00 +0800
From:   Changbin Du <changbin.du@gmail.com>
To:     David Miller <davem@davemloft.net>
Cc:     changbin.du@gmail.com, viro@zeniv.linux.org.uk, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, xiyou.wangcong@gmail.com,
        David.Laight@ACULAB.COM, christian.brauner@ubuntu.com
Subject: Re: [PATCH v4] net: make get_net_ns return error if NET_NS is
 disabled
Message-ID: <20210614233500.5xkkyzmbu7dzymxv@mail.google.com>
References: <20210611142959.92358-1-changbin.du@gmail.com>
 <20210614.121234.1863995090731912256.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210614.121234.1863995090731912256.davem@davemloft.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 14, 2021 at 12:12:34PM -0700, David Miller wrote:
> 
> I applied an earlie5r version of this chsange already, so you will
> need to send relative fixups.
>
That version is fine. This one just does a rebase.

> Thank you.

-- 
Cheers,
Changbin Du
