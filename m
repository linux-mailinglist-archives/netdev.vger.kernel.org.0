Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 054FF17772B
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 14:32:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729444AbgCCNcD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 08:32:03 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:36299 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728113AbgCCNcD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 08:32:03 -0500
Received: by mail-wr1-f68.google.com with SMTP id j16so4376289wrt.3
        for <netdev@vger.kernel.org>; Tue, 03 Mar 2020 05:32:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kDShFzlUt7ywM2eIw7Q7qwYeV+vMVQectfDSrlVtEXY=;
        b=SDBdymBN6MOUoXXhhjdalepxHykAYBCSi7YVBzClKubWEx6oJ0cZG235EXxcmw+PCF
         F7s2gabuonrytX4/zxO4wGizHmgbazJhrcC9R+vDtY3XkCMtBs98z8uajM4bImXgf9Id
         ldVZZIe8fpZj8xrIITx9uWHuNYvocNJ3IH84ZT35IpqXWpaAZaZwo7JZRxgSCCyelr0W
         x4OjzTlAZ6B3SqWdySGulPJDR6U3S0zREiU5JcfIiOMbzE0vjRAzXUI4xV/agBdDl+/Q
         wGN/jw9FY+YtP2Vajcishg+xgSMR5AETPaVvLuJ9Fc5vYMmKZF/YB144X7rEitrZo3rv
         waHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kDShFzlUt7ywM2eIw7Q7qwYeV+vMVQectfDSrlVtEXY=;
        b=dfdKAxYHIF9ZeGGgvuLKI5E9sU2qdbmAEr0NylU1fQjVybTDKnlCViqsNyRCDr/tSz
         iUaxU8Gu+DPtXHgQS6IoXh8oGgWFuLgjle06k6zS6sRSFtLC8Rn9c5KaKazrsFz79Rrf
         zJWVJxzvIzpOH4iqAtKkhcLaNdyyVgN5E9OcH8dmvZ031iFcI4b8MyG+aI4tUuvJ0dtG
         iapuIqq/UatXpq17HcLXsWuf+kEQhNloBVat8gvNeM9KZZGxCOr5KtSBTZqQzJ2D4/2N
         gqdFu6y8fhDlnQPzUOQF38UBIUSkq/1ZhadCZVHzHxGCWAkISp8Kjy+K/91JqHXnPaey
         +WSw==
X-Gm-Message-State: ANhLgQ28zQvVTF7zbLtXlKsTjKi7Jun2Op85Ub5kwColiNOvD+jaViIf
        HEYJOTM0zqGwrlodIqVeWIO2NA==
X-Google-Smtp-Source: ADFU+vskuMxivAv2iOIsOBraZ9ZSxqVEVTx/1GSsd6Yyhn4/Lz63ApOy5xdKZTzT6qa4nM1G5aF7sw==
X-Received: by 2002:a5d:4d10:: with SMTP id z16mr5877299wrt.271.1583242321012;
        Tue, 03 Mar 2020 05:32:01 -0800 (PST)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id i12sm19368044wrw.64.2020.03.03.05.32.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2020 05:32:00 -0800 (PST)
Date:   Tue, 3 Mar 2020 14:31:59 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        Jiri Pirko <jiri@mellanox.com>,
        Alex Vesker <valex@mellanox.com>
Subject: Re: [PATCH net 02/16] devlink: validate length of region addr/len
Message-ID: <20200303133159.GK2178@nanopsycho>
References: <20200303050526.4088735-1-kuba@kernel.org>
 <20200303050526.4088735-3-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200303050526.4088735-3-kuba@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Mar 03, 2020 at 06:05:12AM CET, kuba@kernel.org wrote:
>DEVLINK_ATTR_REGION_CHUNK_ADDR and DEVLINK_ATTR_REGION_CHUNK_LEN
>lack entries in the netlink policy. Corresponding nla_get_u64()s
>may read beyond the end of the message.
>
>Fixes: 4e54795a27f5 ("devlink: Add support for region snapshot read command")
>Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Jiri Pirko <jiri@mellanox.com>
