Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D2873F7B99
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 19:33:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242389AbhHYRe0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 13:34:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242333AbhHYReO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 13:34:14 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0776C061757;
        Wed, 25 Aug 2021 10:33:28 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id 18so322737pfh.9;
        Wed, 25 Aug 2021 10:33:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jDz0GO/sDA4MC0xQVYz8V4Wd0OWf5ozUiNTHo51XtSs=;
        b=Rfpf4AZD9CQsx9V4G9z75RNxi9To35GAmKJTUxA0uYW20GceH+jJoRzgiEOBk2hKlT
         07TV98mS4mdfD/e8tdoLfvJML0/quFxoF4z8SztRFOQmcERHT6BLUhpgz6Qmep9JUT/X
         im5+lDYTNWUKH0+3QIH0a/gn0p//XP0rvAMlup4LinNImuKZhcgT0Gn8xAnaXkx/+ofr
         4iDH3LfgtMDnQCo0dxafinxt4pop7Num7AB9kKnKtA8SW7v930K1VbkiXIvcAErgprKG
         3jd64+xF4oJgl6GHRm0F04wI7qFQ3UN8fYVkqSVJYOm/CIGty+8PYo/jeiRMeNXUaemt
         5FMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jDz0GO/sDA4MC0xQVYz8V4Wd0OWf5ozUiNTHo51XtSs=;
        b=J9zBh9KX+l8E4l0tc8jU5yM66X+tWS/hXXwPWnv/DAEtX/Xy53TJnAQtZ9xKcUrnsj
         jMLag/sD7bPY3KiRML8oayHJcnfOePy3ImkavOxfKezLmxteaaTgO3E0TTRPIqLT4Pqg
         Pf+CveoSI8oDDsjHEMOD1igZWqxrg2iwan6J7vCE2zdNlv9XJVFU4PE0naNWuFd6wB/S
         eGg1XMkaPlgSw3ZrbxnpJ9XDEwuLRX8hSYHsjkA3olmTlJr0iMSw7w6gr5EgukZ7eIAK
         UUq8WRJ8RjI5EqVEHix9z67F2qGvt2tBIFospj3n1Xu/5q8mtBALaUAkcgd9m3380flw
         +dcw==
X-Gm-Message-State: AOAM533LcnZ4eG/+EEHNyIGryueoJG3hQm7OqbEkZV/dTiNnuHGDLC5g
        0wQVz+s16aFp/62htSVVqWk=
X-Google-Smtp-Source: ABdhPJynccttmGOmsCaSHsk2vdJjnmjdrZp0KzQ/E1gz+gJqBCn8i6sB4oF17R0e2l5oKRZZOnvHWg==
X-Received: by 2002:a62:f90d:0:b0:3e3:5739:d075 with SMTP id o13-20020a62f90d000000b003e35739d075mr31574656pfh.19.1629912808042;
        Wed, 25 Aug 2021 10:33:28 -0700 (PDT)
Received: from ast-mbp.lan ([2607:fb90:b2da:ad8d:883:bb6d:9e85:dd2d])
        by smtp.gmail.com with ESMTPSA id g26sm616834pgb.45.2021.08.25.10.33.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Aug 2021 10:33:27 -0700 (PDT)
Date:   Wed, 25 Aug 2021 10:33:14 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, jonathan.lemon@gmail.com,
        ciara.loftus@intel.com, bpf@vger.kernel.org, yhs@fb.com,
        andrii@kernel.org
Subject: Re: [PATCH bpf-next v3 10/16] selftests: xsk: validate tx stats on
 tx thread
Message-ID: <20210825173314.dbkzinas3afz2lxk@ast-mbp.lan>
References: <20210825093722.10219-1-magnus.karlsson@gmail.com>
 <20210825093722.10219-11-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210825093722.10219-11-magnus.karlsson@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 25, 2021 at 11:37:16AM +0200, Magnus Karlsson wrote:
> From: Magnus Karlsson <magnus.karlsson@intel.com>
> 
> Validate the tx stats on the Tx thread instead of the Rx
> tread. Depending on your settings, you might not be allowed to query

thread.

> the statistics of a socket you do not own, so better to do this on the
> correct thread to start with.
> 
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>

Overall the set looks good to me.
I'd like to see an Ack from Maciej, since he reviewed v2.
