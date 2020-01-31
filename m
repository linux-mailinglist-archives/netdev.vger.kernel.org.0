Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8807014EE68
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 15:27:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729014AbgAaO1y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 09:27:54 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:36826 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728730AbgAaO1x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jan 2020 09:27:53 -0500
Received: by mail-wr1-f65.google.com with SMTP id z3so8863763wru.3
        for <netdev@vger.kernel.org>; Fri, 31 Jan 2020 06:27:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=V/PCnqNtDQJTE0n6z019lCU8yqKmiVuTIJCF6Mgs2hA=;
        b=zym66xsy/sjzCBn080zU+FiBL1C3WjHGj6hPdfx+yz4tx+sXjgCI4IXwOcP9KNvUr8
         6xFC8DlHxEY9TDbv71iMStIek4j0ibL8+k1x0uloTJlEcofseH+Me4fZK0nY0uaJ1l2B
         MhgiEy4L3KgUMEJ2vBNwdDr2F/Qc2pQES4V0TnYIZSxkhpL+J7pIIzSZxpwibXe7atfi
         m4J0ZN45z+vzoF2Sh8E5EdsKIJMNMACaoDn/Vv+PsEBgXOEYSs6XQeFQgj3Vu9JYN9rP
         jEeTloINK+LpNlSfYB9wbzt3pgjTwCG+J1xn3oNJviWGRq5jOdoCf4iUO1imiX3vMGFS
         r6NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=V/PCnqNtDQJTE0n6z019lCU8yqKmiVuTIJCF6Mgs2hA=;
        b=hP5UfKzJUUtFC4syyny+0nDMit6u04CzToKuYW/UUWQJq/ySdXNDj/g23KKu1PHEwP
         3PM+2K2l0jGc/mBp/MqIjuoei201YGYLmIB8NzcNPPQ+o4zKmJoeR7rlmzQYhmry+40O
         r7ZODe6e15fm0Q/sZuaj2GZJuhc5GvU9wPlcCuDI2KwfTve3QLhwOu/XUDF0rPO71m12
         gtFzX7EVdA/0MQXHcssYOaXy8KEto0PI1s2WksnL3DnV7diAdjQBckwbQEn5XTIIr4Lu
         a2wg2awrTrK5mkYt5EHYQawGAYZi5Y4677E7bdX+U4dY550Im5M8YvxMRPsi7RSDv+Cc
         iZ/Q==
X-Gm-Message-State: APjAAAWp9K8ZLTmzEc1N8lNvFYXSpf5SnRNL82hOSA0wRoGO3WmhXowm
        +uopGItxt74CM8TT1J3QxJT1WA==
X-Google-Smtp-Source: APXvYqwffjVdonyWBGQTjTsoah1oQOI+zi0erFyjvn3dkdCOYmw51m6xt5K4qjQP30gxfi9r574VWA==
X-Received: by 2002:a5d:4651:: with SMTP id j17mr12699429wrs.237.1580480871833;
        Fri, 31 Jan 2020 06:27:51 -0800 (PST)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id j12sm12916560wrw.54.2020.01.31.06.27.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jan 2020 06:27:51 -0800 (PST)
Date:   Fri, 31 Jan 2020 15:27:50 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     Jiri Pirko <jiri@mellanox.com>, Ido Schimmel <idosch@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Petr Machata <petrm@mellanox.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH v2] mlxsw: spectrum_qdisc: Fix 64-bit division error in
 mlxsw_sp_qdisc_tbf_rate_kbps
Message-ID: <20200131142750.GA2251@nanopsycho.orion>
References: <20200130232641.51095-1-natechancellor@gmail.com>
 <20200131015123.55400-1-natechancellor@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200131015123.55400-1-natechancellor@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Jan 31, 2020 at 02:51:23AM CET, natechancellor@gmail.com wrote:
>When building arm32 allmodconfig:
>
>ERROR: "__aeabi_uldivmod"
>[drivers/net/ethernet/mellanox/mlxsw/mlxsw_spectrum.ko] undefined!
>
>rate_bytes_ps has type u64, we need to use a 64-bit division helper to
>avoid a build error.
>
>Fixes: a44f58c41bfb ("mlxsw: spectrum_qdisc: Support offloading of TBF Qdisc")
>Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>

Acked-by: Jiri Pirko <jiri@mellanox.com>
