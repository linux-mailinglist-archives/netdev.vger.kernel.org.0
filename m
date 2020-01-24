Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFDC314867B
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 15:03:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389125AbgAXODI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 09:03:08 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:36521 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387698AbgAXODI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 09:03:08 -0500
Received: by mail-wr1-f66.google.com with SMTP id z3so2122969wru.3
        for <netdev@vger.kernel.org>; Fri, 24 Jan 2020 06:03:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0Z4paaJ7cX/XoDkKHP32ckWRlcdwXKbjbLJbLHRyqLE=;
        b=O7hyn1Dx1CC9srqIk80m4/NUYUOZ1fcCa8G9GF6TRYlW9GzdKn26p2aGrDYJcutRF/
         l0x5zMYLvElu8kpQFNxe2rIC5Itb1zyDPfa4Nks50ddz0t1pCTIeB7AZqUq7LC0mp7OW
         kYe9LxliL3OULQVO1v6nR/E0jLIlQpV22oGemVa0MoTxUS5ZCuzPTQvlTcXMWJQ+qwhL
         0ePlbm+e5crxcgwMgwv6CdgsFMXifh/swcVHwWrTB2aKz3wZW+XwPqF/aGaZuUmBV8hT
         g5lkNE8OYxVJHxHjheCAyYEYKq4EwfSIa9rX7DrKzn4eY/0Ar2ssRNCpwXlJ0i6IKJ5o
         RLeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0Z4paaJ7cX/XoDkKHP32ckWRlcdwXKbjbLJbLHRyqLE=;
        b=FblvOMzKF0DRrlwYjzY4AicwwP9PhEq349pyckd692bd3Udgx87ESoDX1B73O0z/0d
         KtT9F8DbubG9dcYnujV+WnRQcfeg97k5PdQuOVgc1Fc8GHa5IyjvV37y2JNTHN3RaUGz
         CiCnyaopeuLYA2K/gdIrUrTmegaiyNkJYphfgn1KFj65FyW+1S8XblfD6DrCXr7j3Kee
         IagzY6gqY8jprsARpk6uDhymQyll8T2gilxsvnSTYwSdbDJZePK+OitE/nOwGfzww7O7
         xPaTS4s8lAeUR6hTgOlJPVXXhpXtEDqJJSCnXnq5b3C/qdciKNATF9GMcWnEIq9bjOZ+
         md1Q==
X-Gm-Message-State: APjAAAVLL8TFBGvC3P+xesHoiJiitpKp8ITUWDb5YkK0kSyumbLd0AYb
        54NRNKKaHkZ3O2h3laMQ2lNwrQ==
X-Google-Smtp-Source: APXvYqxR49DAnEJ4q1VTMTSzA4rjoBVk0brPi4dH6Q8Dd4qJY2DIVJEXttXV9x01VYrnFbmSJYsDiw==
X-Received: by 2002:adf:e547:: with SMTP id z7mr4443988wrm.258.1579874585369;
        Fri, 24 Jan 2020 06:03:05 -0800 (PST)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id x18sm7733583wrr.75.2020.01.24.06.03.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jan 2020 06:03:04 -0800 (PST)
Date:   Fri, 24 Jan 2020 15:03:03 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@mellanox.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, petrm@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 03/14] mlxsw: spectrum_qdisc: Extract a per-TC
 stat function
Message-ID: <20200124140303.GA2254@nanopsycho.orion>
References: <20200124132318.712354-1-idosch@idosch.org>
 <20200124132318.712354-4-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200124132318.712354-4-idosch@idosch.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Jan 24, 2020 at 02:23:07PM CET, idosch@idosch.org wrote:
>From: Petr Machata <petrm@mellanox.com>
>
>Extract from mlxsw_sp_qdisc_get_prio_stats() two new functions:
>mlxsw_sp_qdisc_collect_tc_stats() to accumulate stats for that one TC only,
>and mlxsw_sp_qdisc_update_stats() that makes the stats relative to base
>values stored earlier. Use them from mlxsw_sp_qdisc_get_red_stats().
>
>Signed-off-by: Petr Machata <petrm@mellanox.com>
>Signed-off-by: Ido Schimmel <idosch@mellanox.com>

Acked-by: Jiri Pirko <jiri@mellanox.com>
