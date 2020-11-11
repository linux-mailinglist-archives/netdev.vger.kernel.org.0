Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA5072AE71A
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 04:31:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbgKKDbI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 22:31:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725900AbgKKDbH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 22:31:07 -0500
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A82BC0613D1
        for <netdev@vger.kernel.org>; Tue, 10 Nov 2020 19:31:06 -0800 (PST)
Received: by mail-qt1-x841.google.com with SMTP id i12so467984qtj.0
        for <netdev@vger.kernel.org>; Tue, 10 Nov 2020 19:31:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9Ix5fP55XIPKkFVDlWIVFNqrgekJZbQLF2d0gbdpRgc=;
        b=n2xkXqHxsYOwisZJ2WhM8VCpWggQtxP3oewevoU1/Not4kB9fQM0IleShVkegfK2Vl
         zMBbIGWQR87w7R+VqfF3NjO3VeknMoE+kAjoWwRBV2v21DXS+rKG3MhLz9GsZJU+L7Ip
         9/rYo5lQcK3/IqxmgeHMS8VYrmMWGjK6eNDhVyVXnwCl8lISFy0+cgl5OE5y7deTs2Kb
         CJwOJjoiuMah2tS5pf5fZJ/nPzgQG006gRQP2cdRGmIuevg/T/BhcAaOEwKUgJSqQm/o
         0X7fVjj1hTsiKDg7XlEO6LTzdXOb9sMBL3Q8PbyxFM+x22XX6Ov1a+hNO4J58v6iDQDt
         XYRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9Ix5fP55XIPKkFVDlWIVFNqrgekJZbQLF2d0gbdpRgc=;
        b=sIE3Fdjde8pmliOMsZqPt90rVkhAITs2RClh1RgbizMr8Zs3aQp9Eu6m3n2qUdeybv
         fxTyr+aXtKsJI0Nm9CX5X/fJfVBd98TJIY+8ZZreNeIXw3YKyPX0iLQvN/UkRmu9Jzc+
         WWxU3/v/qLHTKwwM6fb7/ZP27n5UuOtOhAgFZJ+Ekwrb+p9sprvJSIUCkbP1CPPrIv3r
         8GeTI+NKlVBmAV1sXfYayJVRvrQGgiahqWI/1LrI7JuzvTPBiXrT98R9vxsV6sv0xuiz
         B2C+TYtOS7NhHKeYJCpW9WLURQ3JbzJy4qGbssJ5M1IBUifgsQkkr2VsuWBXGd0VZHAN
         a2fQ==
X-Gm-Message-State: AOAM531rzvB6oca4Um56O3+oSZaJOhdrbSIz4ACACQaAcwa01yjURs3V
        6F8Q6bilubCAjqZ+UCqzYTY=
X-Google-Smtp-Source: ABdhPJwCakJtqUYjx0lFsi1TajSpteWyz/VTzkWsOrUPGUiTsz4RO4LJhj6GDkZ5V5aUQl94/PTXwg==
X-Received: by 2002:ac8:570e:: with SMTP id 14mr21062475qtw.229.1605065465422;
        Tue, 10 Nov 2020 19:31:05 -0800 (PST)
Received: from localhost.localdomain ([2001:1284:f013:f46e:fd51:d129:1f9d:9ebd])
        by smtp.gmail.com with ESMTPSA id p8sm996573qtc.37.2020.11.10.19.31.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2020 19:31:04 -0800 (PST)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 49F70C0E58; Wed, 11 Nov 2020 00:31:02 -0300 (-03)
Date:   Wed, 11 Nov 2020 00:31:02 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     wenxu@ucloud.cn
Cc:     kuba@kernel.org, dcaratti@redhat.com, vladbu@nvidia.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH v7 net-next 0/3] net/sched: fix over mtu packet of defrag
 in
Message-ID: <20201111033102.GE3913@localhost.localdomain>
References: <1605062967-19819-1-git-send-email-wenxu@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1605062967-19819-1-git-send-email-wenxu@ucloud.cn>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 11, 2020 at 10:49:24AM +0800, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
> 
> Currently kernel tc subsystem can do conntrack in act_ct. But when several
> fragment packets go through the act_ct, function tcf_ct_handle_fragments
> will defrag the packets to a big one. But the last action will redirect
> mirred to a device which maybe lead the reassembly big packet over the mtu
> of target device.
> 
> The first patch fix miss init the qdisc_skb_cb->mru
> The send one refactor the hanle of xmit in act_mirred and prepare for the
> third one
> The last one add implict packet fragment support to fix the over mtu for
> defrag in act_ct.

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
