Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E234D3407D4
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 15:28:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231178AbhCRO2Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 10:28:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231410AbhCRO2M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 10:28:12 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26523C06174A
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 07:28:12 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id k10so4278798ejg.0
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 07:28:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zhlUHRDpn+jcX+5O00x2slanp03Cw+trhKHN4OhT9Go=;
        b=giWslzRhRi7k8ZmUhaphXs11qQTN6BeWxzuflrVgLEmigLKScwIYL7WGKzlShsOUkW
         yscOMV8eoE94DyKYzlcES8XI/AGmJzXytq71s25wQd0s/aoP7IbjCe1cF1C/iyPdcWv4
         uZNw9LeQwWSBzMYpO2xjM1mDCQgHuPFp2YsS7eL8Nc/Cuafk8wrAcb+27lrCMLLRZRAM
         So9LQV3re0QPKD02uzCNb6iL2uYmN/dU1JmLLAPrgL4dw9zM5zka11OnemB4MNZuajG5
         6xX9m/XPiLrJKeFDDdoU46MJH4dlGWacsKz6eg0+3nkp3bImh1AsPimDk0Z0wjW76TD8
         AvvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zhlUHRDpn+jcX+5O00x2slanp03Cw+trhKHN4OhT9Go=;
        b=J4HQBe0E9lpqdOyZFtoluxJna5ORd2ZT5M1IG7Lv+0aCkkww3gl39ejMwqDsqafLx/
         gy0qBbO/C9NbmiylUi2fEfLr2lYh3iO2npQsMHxsppCUIhwLDxkU1RTzPsqiOvUWqhtt
         L9P96DjZpIjl/r7CmudEBFs4WX2vpiTS7whGtcSU+5vdagrVhUjTFYWaCorAQTaQsj0D
         0ddWr5+ZAPdv6/bYgIKtxVkRVjxN9Gzbpe6rAp+PCevuC/AULR5ZzYwqWIbIXBdEXhJ0
         bTBomFXiRt/Q7yzDYv4mlToktM63hbOSd7XXvnZhFNz0nEfRIQt5ALgnurT8ud1ZmW99
         vdwQ==
X-Gm-Message-State: AOAM532oR+ZnzP7pipjGRVhXvkb4IRoK79B/ZFU1R3lS+ea5FFzy3uZv
        SeijJTAEr1v6vnZNBXTyEYQ=
X-Google-Smtp-Source: ABdhPJz7NvnhI34Vu+1elgvdmxK2BTz5oGJDsbkQnSfMUB6dEUDmWFlYS7U3fiPWajdfjesuUUYitg==
X-Received: by 2002:a17:906:bc81:: with SMTP id lv1mr41414111ejb.135.1616077690920;
        Thu, 18 Mar 2021 07:28:10 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id s9sm2179658edd.16.2021.03.18.07.28.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Mar 2021 07:28:10 -0700 (PDT)
Date:   Thu, 18 Mar 2021 16:28:09 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next 4/8] net: dsa: mv88e6xxx: Remove some
 bureaucracy around querying the VTU
Message-ID: <20210318142809.fid4them33ne6luf@skbuf>
References: <20210318141550.646383-1-tobias@waldekranz.com>
 <20210318141550.646383-5-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210318141550.646383-5-tobias@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 18, 2021 at 03:15:46PM +0100, Tobias Waldekranz wrote:
> The hardware has a somewhat quirky protocol for reading out the VTU
> entry for a particular VID. But there is no reason why we cannot
> create a better API for ourselves in the driver.
> 
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
