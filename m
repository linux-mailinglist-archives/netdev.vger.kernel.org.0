Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AD452AA60E
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 15:56:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727494AbgKGO4u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 09:56:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726021AbgKGO4u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Nov 2020 09:56:50 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25166C0613CF;
        Sat,  7 Nov 2020 06:56:50 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id c20so4271620pfr.8;
        Sat, 07 Nov 2020 06:56:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=OAig6VAxVJWLlM9kU+eo4+P+aWW3ULQ0FM1RxfarM9M=;
        b=CQnZBPYi36lb0zaqTveQEl6aXebyRDAIJNlLG8C+i9z5OJXcDbYzE66OA5u8grgRWY
         y4zghRJHjrDBmxyrEitK4dIbAF9UZhChahWNLIa08Xcb34mIa7SmntjD60NOZcZdRoyn
         voBas3u3lMQEOuryON53LvcfQsUEOb33pK5hrvWbOA2rHze8zudkGIlt1Fc/RyvkUOh8
         h+DStyUukLDve+LyoZlnrr/dTAVPJe5WB9iddJNj4Bkw5i1Etr79OW/eTURHEyQol12i
         ybgZfX7o2AB7aaS7qLOY9S3Hkrl3W99oFbqP1aFTn8GGH4i0eJbJnVDBsfzhVYUn6HMj
         5xrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=OAig6VAxVJWLlM9kU+eo4+P+aWW3ULQ0FM1RxfarM9M=;
        b=Je0Einv2w3ZtVuenNMeLa0HVPqv9MpketS+RhJV6StsN6kyap68BRomN8746Kr4d+y
         zvjm5+9kczkDjR8wtclhTnq1rxrhdseapzUSK6MqU/jJy2e8mnYuhaDPNsroU5lCFP6g
         f+oa9J1yb3oyVhNPwYAW37g8ggLAOZK9SJ1joiYwu5o2bEeASsrpOiXknrY65XiYJ11f
         JX25B9iuh7WulPbEAHj6ajr7RdPTQVcM0eNGTh/seBFk9of1kxFvF353D99zXDDnUUY1
         H9un/N6dJyA4YNNXWYCJrN7+bb5KjB5jdyMUFPPqEo28fY96YaFtys9MfrrZbqxs8MAh
         oFNA==
X-Gm-Message-State: AOAM530fz9HShuP+vmwaR1nWVbi8uKhgTnZtnkYU6R0zlCE8O1H7A5R2
        yTs7UoXYLCgROI6HhVUVNEHlooLvOto=
X-Google-Smtp-Source: ABdhPJzHVNhsx2ltWm1JiUclfjnuT/COISRTG2bm+R8byiw9EgmM+5ZKTWikBRbc9iTxDbySwLiDPg==
X-Received: by 2002:a62:1455:0:b029:18b:83a2:768b with SMTP id 82-20020a6214550000b029018b83a2768bmr6516559pfu.3.1604761009403;
        Sat, 07 Nov 2020 06:56:49 -0800 (PST)
Received: from hoboy.vegasvil.org (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id i6sm5702909pjt.49.2020.11.07.06.56.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2020 06:56:48 -0800 (PST)
Date:   Sat, 7 Nov 2020 06:56:46 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Wang Qing <wangqing@vivo.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pcp_clock: return EOPNOTSUPP if !CONFIG_PTP_1588_CLOCK
Message-ID: <20201107145646.GA9653@hoboy.vegasvil.org>
References: <1604719703-31930-1-git-send-email-wangqing@vivo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1604719703-31930-1-git-send-email-wangqing@vivo.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 07, 2020 at 11:28:23AM +0800, Wang Qing wrote:
> pcp_clock_register() is checked with IS_ERR(), and will crash if !PTP,
> change return value to ERR_PTR(-EOPNOTSUPP) for the !CONFIG_PTP_1588_CLOCK
>  and so question resolved.

NAK.

Drivers must use the documented interface.

Thanks,
Richard
