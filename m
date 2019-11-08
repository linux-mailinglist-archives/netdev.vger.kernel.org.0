Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA1CCF43E0
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 10:51:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730281AbfKHJvO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 04:51:14 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:37763 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730069AbfKHJvN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 04:51:13 -0500
Received: by mail-wm1-f66.google.com with SMTP id q130so5525161wme.2
        for <netdev@vger.kernel.org>; Fri, 08 Nov 2019 01:51:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ef8w2x7FNiOVfJGsrR6qlSZbxSj588ZLEfdLErTlRxk=;
        b=vjVGdLNVuydy4OGmu8C7T/3sIt2+JYxRt61sNL8wg9AbZRk9fd85zPfgDtr1SI/WOe
         XmLOI0i3ic9bAQf06gwR5ZmSbW9R9IOoMqnImKxz6ot2xIg8Pz68esjvj7vOqrDONrOV
         /d9CgnnYjDk7ZiMEPrhuBQo1PRY83NUkHHhm1+Kshk4r8wM+0GWkTRfZmndHAH3wtuHk
         CL+oc4q220zBJ8WHU6F+1pInJKaYs8paqZOSOwUN36sbW863zTPnLeApdY/A/Ig9ZkuJ
         LP1v8R3zwqEx1r67pIwaHJGLhR34gqdX7LuMpIcFdK/5bQ/ac/YO4foU7d6oYxDSEqum
         DCTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ef8w2x7FNiOVfJGsrR6qlSZbxSj588ZLEfdLErTlRxk=;
        b=JLhson8H/3XQr8PVXY4HbdUUS8Svkd49HDFo0/4eao+b3lprEiAXpTUDU1Gvabno6C
         bvoG9QOK4j1HSY2EyR/MwaQM4M51wgjLGk2+WArGv+gBosbttaL0kCwtiiuMBlcRmDXD
         411Uc5Bs7RKKgg4JYgL+mHetnZgKx2V38Af3l8ST86vrdYWYG8HK38z6CDmfBOC6z+hx
         WjjIQqyjk2Wxq9Z8sPpAt2aKMn23xnnNZ4d4fAkseGfm6hjMzNZl6AjWJBhzKBqFBck4
         kTJ/utcGvWdUr1x+YgSV4IIs1clitJFwDekEILmI0+VUG0cx71TaUeEzDDGcsjDW3f5F
         QjHQ==
X-Gm-Message-State: APjAAAVqdrihYrjQ4ggxeCVyXWmkbWSUaze/yhnC6T6tlf4GUbJC2c0s
        eMrvme7aAU2z7TuaQ1QkNsiBsw==
X-Google-Smtp-Source: APXvYqzRA/rYKvuuLhJgEIzhK7tO7DnuUd3U0A1FceWfVu51NbGXrLXsJfv1/SSm4ukqur3WrrZwkQ==
X-Received: by 2002:a1c:998f:: with SMTP id b137mr7637180wme.104.1573206671627;
        Fri, 08 Nov 2019 01:51:11 -0800 (PST)
Received: from localhost (ip-94-113-220-175.net.upcbroadband.cz. [94.113.220.175])
        by smtp.gmail.com with ESMTPSA id u187sm6823960wme.15.2019.11.08.01.51.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Nov 2019 01:51:11 -0800 (PST)
Date:   Fri, 8 Nov 2019 10:51:10 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Parav Pandit <parav@mellanox.com>
Cc:     alex.williamson@redhat.com, davem@davemloft.net,
        kvm@vger.kernel.org, netdev@vger.kernel.org, saeedm@mellanox.com,
        kwankhede@nvidia.com, leon@kernel.org, cohuck@redhat.com,
        jiri@mellanox.com, linux-rdma@vger.kernel.org
Subject: Re: [PATCH net-next 01/19] net/mlx5: E-switch, Move devlink port
 close to eswitch port
Message-ID: <20191108095110.GD6990@nanopsycho>
References: <20191107160448.20962-1-parav@mellanox.com>
 <20191107160834.21087-1-parav@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191107160834.21087-1-parav@mellanox.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Nov 07, 2019 at 05:08:16PM CET, parav@mellanox.com wrote:
>Currently devlink ports are tied to netdev representor.
>
>mlx5_vport structure is better container of e-switch vport
>compare to mlx5e_rep_priv.
>This enables to extend mlx5_vport easily for mdev flavour.
>
>Hence, move devlink_port from netdev representor to mlx5_vport.
>
>Reviewed-by: Saeed Mahameed <saeedm@mellanox.com>
>Signed-off-by: Parav Pandit <parav@mellanox.com>

Since this patchset has 19 patches, which is quite a lot, I suggest to
push out some preparation patches (like this one) to a separate patchset
that would be sent in prior to this one.
