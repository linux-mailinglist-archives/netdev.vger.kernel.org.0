Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02AA3148AE5
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 16:07:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388162AbgAXPHL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 10:07:11 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:37839 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388032AbgAXPHL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 10:07:11 -0500
Received: by mail-wm1-f68.google.com with SMTP id f129so2017191wmf.2
        for <netdev@vger.kernel.org>; Fri, 24 Jan 2020 07:07:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1Tkdd0XHlG41hNS4jgXhvhqf0hPpm9opFVCSyW//bVg=;
        b=m696dXqV6pFhHf/c1lb43JGCU80cLqA1GNB20emWm5ennmEre2IEcQIoIXT3J/wVLB
         5GmgvAqvPq7U0E+Go94qh1wXbmzgjNZxfig2yAztHeUrPbv8iZYlm4/smcrvBVE46+Po
         jnnf7AwvZTUukl1wRNvn2hg63GgpDbB8bQc2C+7Nojpn8qH5kzBKJoacRAVNRba8Yrc4
         WwMo1okrs4xt4/9piEqTYH9XyAaYHy2nccQumUweLjPQ1Us3933ZmDMhWPst6P2w+9uS
         CELJoYsrJ7NE30rxnXnMFMKq9EGmC1K5nbLxanqRVYjzNNd+/kCVszVXImydGbexvtZX
         io1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1Tkdd0XHlG41hNS4jgXhvhqf0hPpm9opFVCSyW//bVg=;
        b=uEKFYPYhP/IgNq3j85WZJuFYr+/nGYcs22g/MHSOeJuVePrgbzPVHSfFf2ub00fhj/
         utze2yvwPms5tpAAdO+cz6b5CGFsqEa0jiuoqbOlM6L91uYQapaKMw75O/rYF+ZYkZgD
         hqwIfhgjSWd/FiFDKOnjHDfBKfFn8o3bmkxvWnH5Jn2d8qitv7iWhDFgRA/+VbBH2aud
         GoH369BB0kmA5tcSwQnPdHz9+IuhwfItAesaDCmdM//o6rikeNs7coISHHBMpUWrhUlu
         rFqDs/bJn2dlMX1pm/q4doQUPd6b/6y8SPnzocpzGwQ+GsBTib4gyH0/BOCAk+GiTIqm
         CUYw==
X-Gm-Message-State: APjAAAXt5z0p2KgwVr7pn457BGjnXVjbTD8nvtgn2YAZdeLOMMKerDx+
        c+EESsV7acVx1KJ2/S5Au0KycQ==
X-Google-Smtp-Source: APXvYqx1lghhKe7mPG6zOAsFL1Yq3T9BJrn7Ua27+cEG5F38OKWOYFXzIARGstvdMM+ZAsYTDzO+vQ==
X-Received: by 2002:a1c:9e15:: with SMTP id h21mr3741930wme.95.1579878428999;
        Fri, 24 Jan 2020 07:07:08 -0800 (PST)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id 124sm7542244wmc.29.2020.01.24.07.07.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jan 2020 07:07:08 -0800 (PST)
Date:   Fri, 24 Jan 2020 16:07:07 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@mellanox.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, petrm@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 09/14] mlxsw: spectrum: Configure shaper rate
 and burst size together
Message-ID: <20200124150707.GG2254@nanopsycho.orion>
References: <20200124132318.712354-1-idosch@idosch.org>
 <20200124132318.712354-10-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200124132318.712354-10-idosch@idosch.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Jan 24, 2020 at 02:23:13PM CET, idosch@idosch.org wrote:
>From: Petr Machata <petrm@mellanox.com>
>
>In order to allow configuration of burst size together with shaper rate,
>extend mlxsw_sp_port_ets_maxrate_set() with a burst_size argument. Convert
>call sites to pass 0 (for default).
>
>Signed-off-by: Petr Machata <petrm@mellanox.com>
>Signed-off-by: Ido Schimmel <idosch@mellanox.com>

Acked-by: Jiri Pirko <jiri@mellanox.com>
