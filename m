Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6007D4795F2
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 22:03:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240957AbhLQVDa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 16:03:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239777AbhLQVD3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Dec 2021 16:03:29 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE86FC06173E
        for <netdev@vger.kernel.org>; Fri, 17 Dec 2021 13:03:28 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id v13-20020a17090a088d00b001b0e3a74cf7so4976541pjc.1
        for <netdev@vger.kernel.org>; Fri, 17 Dec 2021 13:03:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6GodjcWAF3mYu9woL8hOan7NZaP/rSFrCXq8dZE0pbw=;
        b=IjRe+4C5VR/6st8qatG2AWz5ro7Na79jF+aQrTP5APsV9BCC3QGy8M7cXhCgRrQlEl
         xyLKSr+EwODHgQ/yOswEqvOirZrLob31qDDprPVn6V56LMzPPySqj4YSt2epEnkC+77W
         LkWDEvd0MTD8fSNni7bGq4vtPzmqtpnz1zdBl0BPW4FiIXVixVmAqh6eNkeShIBig0Jc
         hoMysvZqugoXUae5TPFhJcj1+8grdb1VZ7dbtpz0hf2y7va7ift/o9qZMTYRJQR1XFQ5
         84gt78r1K41pWxPPRwWA5DmMsvJLpsNDbzf/4BBkEhcNMSi0XtUPc4mAa8FX2R+hxM3d
         jVIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6GodjcWAF3mYu9woL8hOan7NZaP/rSFrCXq8dZE0pbw=;
        b=m6LpHHHm2z3rIlj06c4yLJzUVdM0MX+L1nziOqlDtL9kgVWxMoihc5iT/uuUcF8ZM9
         Jhr8C18USt0RJY5JZZrnTOHO77frV0Xd0nxg5QP8ArpomR6+kZCqq8d2uDFcgDdMEz33
         xegSL7e9fQW89fY91a9wCXrLNf7EcuTi9Ndelza95N8xCjkiQMJZCdqP3YTJkyEnufJq
         LlqdEww7EAGUfF01x/zh/vzAr/SOO2Iw06GBzFQxXCn8a5BtjU4sWxwN87Fy9scWbNYi
         u1H6RXW2UMYNutALKvADuQAfDLkeKYIZdcVnT5XgCMhlfo1vbFRT0z3eRDAxCm4QG/88
         MBIA==
X-Gm-Message-State: AOAM533+snhDCnDFmdO/3s6HKbiyK3E51+xoL/9lWEDrKYQAPnZoTYgP
        64lNIaunwjmosNRGbKNGSttsjQ==
X-Google-Smtp-Source: ABdhPJwtxXLNgSU0Fr8EsRIJMgqrR6xSikrxpNpz6MQ9mlpbLz5wFWFuIoe74UXzqn+KVLpy8Iq9BQ==
X-Received: by 2002:a17:90a:5d8e:: with SMTP id t14mr14156989pji.95.1639775008335;
        Fri, 17 Dec 2021 13:03:28 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id r21sm9234622pfh.128.2021.12.17.13.03.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Dec 2021 13:03:28 -0800 (PST)
Date:   Fri, 17 Dec 2021 13:03:25 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Yevhen Orlov <yevhen.orlov@plvision.eu>
Cc:     netdev@vger.kernel.org,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 6/6] net: marvell: prestera: Implement initial
 inetaddr notifiers
Message-ID: <20211217130325.305961eb@hermes.local>
In-Reply-To: <20211217195440.29838-7-yevhen.orlov@plvision.eu>
References: <20211217195440.29838-1-yevhen.orlov@plvision.eu>
        <20211217195440.29838-7-yevhen.orlov@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 17 Dec 2021 21:54:38 +0200
Yevhen Orlov <yevhen.orlov@plvision.eu> wrote:

>  	switch (event) {
>  	case NETDEV_UP:
> +		if (re) {
> +			NL_SET_ERR_MSG_MOD(extack, "rif_entry already exist");
> +			return -EEXIST;
> +		}
> +		re = prestera_rif_entry_create(port->sw, &re_key,
> +					       prestera_fix_tb_id(kern_tb_id),
> +					       port_dev->dev_addr);
> +		if (!re) {
> +			NL_SET_ERR_MSG_MOD(extack, "Can't create rif_entry");
> +			return -EINVAL;
> +		}
> +		dev_hold(port_dev);

How are these device references cleaned up on module removal?
