Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 683DE2B7DEF
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 13:57:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726489AbgKRMyz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 07:54:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726249AbgKRMyy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 07:54:54 -0500
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A931EC0613D4;
        Wed, 18 Nov 2020 04:54:54 -0800 (PST)
Received: by mail-pj1-x1044.google.com with SMTP id ei22so1062248pjb.2;
        Wed, 18 Nov 2020 04:54:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Wy/KEppnAdk/cNOgtsabIIPwjqGYS6CaxiiJ4TMK5i8=;
        b=o3bTqWP+TZ6TijALWjM2TG4Nt4leqd6UyHEbZEHS3zmgNBhbotf9NwQf/wUDONyJ+z
         uF3pGFjnrjPQmCCix8o7sCCPacZGz7QdRSCibdXY59vRNYdNT2cxlLBNlswwTHwh+i4m
         057MmUeMzex70xACaYwprcXTs0w2cWmZVwqJrOjo0ehhXv2gfLCWMdBgu9Ab8NGYKdn+
         mHmGc0dklaUGgegLLjmIzjwtTNLUO437szgfypD9E/MYGiFgKHOds3GiP1QHoE43OUSr
         JQWxeCnNryeB7SO7hGJE20goJZewE9XfPPy1xxk7QJjYJlbR9WssytuKLX6gB3+eQ2HR
         /oNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Wy/KEppnAdk/cNOgtsabIIPwjqGYS6CaxiiJ4TMK5i8=;
        b=Fs1b75d6zTSDJcUlF/kMRONlRFPEl5Kkd7GRnTPE8NH0DLCCJyrYeLyggHjKPrQimD
         2aqQomXtjcixPv9zHLKzvtXPT4rdM3ETyy+gNq97Bn3rQOZwTQsAPG79aSs4FIhEZnax
         ty/KjsTw1t1xEarrqiYaT9RdvM/8ivaUvRmQxb6QHLwYCewuJDWaUnzBF4BJaIBOYX7S
         WglJSRWbRqUATzOy5nXF/TtMiMMvRtAz4ZZc3K25l2i70jefd+wrbXvWAoXIZkrWIfoF
         fDvWvmaqfaKja8cQDDp/JnnhzjPaMZ3GNhQBNygo9r5ydcuiKM/n5EFgWiD9VT3j1A95
         oJGw==
X-Gm-Message-State: AOAM5322qEFp5UHBWzpAe429B0V6dQjUK8WbZ3X1NKA5cTuNZbswy+o2
        SeJ9nOwQXZvCnlVh2C8o9E4=
X-Google-Smtp-Source: ABdhPJymCFNey6f4iesj7Ck4E+dXHQMDg5Y6qwOw35FTo8NqA7iy/BgTEAB3A040esLfdt2ku8wwKQ==
X-Received: by 2002:a17:90a:fb54:: with SMTP id iq20mr1929878pjb.111.1605704094325;
        Wed, 18 Nov 2020 04:54:54 -0800 (PST)
Received: from hoboy.vegasvil.org (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id t200sm3692106pfc.143.2020.11.18.04.54.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2020 04:54:53 -0800 (PST)
Date:   Wed, 18 Nov 2020 04:54:51 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     Miroslav Lichvar <mlichvar@redhat.com>,
        intel-wired-lan@lists.osuosl.org, andre.guedes@intel.com,
        linux-pci@vger.kernel.org, netdev@vger.kernel.org,
        bhelgaas@google.com
Subject: Re: [Intel-wired-lan] [PATCH next-queue v2 3/3] igc: Add support for
 PTP getcrosststamp()
Message-ID: <20201118125451.GC23320@hoboy.vegasvil.org>
References: <20201114025704.GA15240@hoboy.vegasvil.org>
 <874klo7pwp.fsf@intel.com>
 <20201117014926.GA26272@hoboy.vegasvil.org>
 <87d00b5uj7.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87d00b5uj7.fsf@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 17, 2020 at 05:21:48PM -0800, Vinicius Costa Gomes wrote:
> Agreed that would be easiest/simplest. But what I have in hand seems to
> not like it, i.e. I have an earlier series implementing this "one shot" way
> and it's not reliable over long periods of time or against having the
> system time adjusted.

Before we go inventing a new API, I think we should first understand
why the one shot thing fails.

If there is problem with the system time being adjusted during PTM,
then that needs solving in any case!

Thanks,
Richard
