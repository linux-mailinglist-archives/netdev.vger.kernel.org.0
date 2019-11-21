Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B517104E85
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 09:56:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726623AbfKUI4k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 03:56:40 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:35549 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726165AbfKUI4j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 03:56:39 -0500
Received: by mail-wr1-f65.google.com with SMTP id s5so3378631wrw.2
        for <netdev@vger.kernel.org>; Thu, 21 Nov 2019 00:56:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=F2vcbszjzqtUgO+UplRcSrFW0BfrUiYd8h4dMIEn1sE=;
        b=E2U6Xl1gAvEyEPkta74iKZuIalJdnMFyPeOnUvz3YfF6kq5Ma2X7lADQ91R/6Sxot2
         DaedUTG1fQxO3wso0exn+JP00XZj1wmn9mtOMNdq4cGsECB9ISBbCN3lrtI5gXOIWUGl
         +838hes+hTnQBJvMSdbNCvK/hJWQ9yl4SqmxnD2iM+XIrMUZWSw+YuAVZK0a4LmkteKk
         Ew4/I+w8hLAmn2DR7sG+MDiJteQgc0/oCwO6i/ssgvRyT9RRxiWx5FnPoclXvu/+1cin
         YZG3CqmQEd1L1bG2V+ic8viJhZ2i5kIJxmSV8Pc5ROnhv3NpU0+0q/TKdkw+jGRrJr3f
         J9lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=F2vcbszjzqtUgO+UplRcSrFW0BfrUiYd8h4dMIEn1sE=;
        b=tYYEcQnOBwakRDUzWNBz8LtjAujP2nmG8hGqtFuHhSZBFQzvguqqcygiRbZfFre/Dh
         gAglYM5nnIac8IQeSjzIhLNqwbMkBQ+T29MA0nbj1tPBoUvi8oHj1H2J8fxdjJKC89X+
         syMEMhRoOjddXIgs8NoSqWpQVTqr+Ibnj5oFCzRiezffvtxR8/lOjkeH1tKBaX1wH/NB
         fdx8U//XNzJWvxzbq2Wpp7/qYHeYIPySt2QEptRJYJqTg0zaRHj6dHRfB3uXuTBvUL2A
         c/jSMDzpzDz64pEvPXGcsX3P0b+P+c7g6oLKEgbGJdzsEdQnCqYs2AvPaoodU8BVILad
         ldXQ==
X-Gm-Message-State: APjAAAWXYI5EiGiFnUlurhIlaJ+c6EKJsJHsiaAwiE3zYVPotPGaIrGU
        NyH3Gc34SrAdSovrlGDCgettDQ==
X-Google-Smtp-Source: APXvYqym6t/Z/L47bRwg/Epw8NAu3r9GSYJCQdwUJDr6+LXu/CKRuVQX7GpTiaIS2KdaHfmWbZNfPQ==
X-Received: by 2002:a5d:464b:: with SMTP id j11mr2398300wrs.394.1574326598064;
        Thu, 21 Nov 2019 00:56:38 -0800 (PST)
Received: from localhost (ip-94-113-116-128.net.upcbroadband.cz. [94.113.116.128])
        by smtp.gmail.com with ESMTPSA id x10sm487548wrp.58.2019.11.21.00.56.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Nov 2019 00:56:37 -0800 (PST)
Date:   Thu, 21 Nov 2019 09:56:37 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     dsahern@gmail.com, stephen@networkplumber.org,
        netdev@vger.kernel.org, oss-drivers@netronome.com,
        Shalom Toledo <shalomt@mellanox.com>,
        Quentin Monnet <quentin.monnet@netronome.com>
Subject: Re: [PATCH iproute2-next] devlink: fix requiring either handle
Message-ID: <20191121085637.GA2234@nanopsycho>
References: <20191120175606.13641-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191120175606.13641-1-jakub.kicinski@netronome.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Nov 20, 2019 at 06:56:06PM CET, jakub.kicinski@netronome.com wrote:
>devlink sb occupancy show requires device or port handle.
>It passes both device and port handle bits as required to
>dl_argv_parse() so since commit 1896b100af46 ("devlink: catch
>missing strings in dl_args_required") devlink will now
>complain that only one is present:
>
>$ devlink sb occupancy show pci/0000:06:00.0/0
>BUG: unknown argument required but not found
>
>Drop the bit for the handle which was not found from required.
>
>Reported-by: Shalom Toledo <shalomt@mellanox.com>
>Fixes: 1896b100af46 ("devlink: catch missing strings in dl_args_required")
>Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
>Reviewed-by: Quentin Monnet <quentin.monnet@netronome.com>
>Tested-by: Shalom Toledo <shalomt@mellanox.com>

Acked-by: Jiri Pirko <jiri@mellanox.com>

Thanks!
