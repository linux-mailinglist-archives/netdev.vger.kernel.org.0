Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 706FD30131
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 19:45:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726719AbfE3Rpw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 13:45:52 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:38244 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725961AbfE3Rpw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 13:45:52 -0400
Received: by mail-pl1-f194.google.com with SMTP id f97so2860135plb.5
        for <netdev@vger.kernel.org>; Thu, 30 May 2019 10:45:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uzDtpb8qB7EkuggCkLpOPSzYqyMUIM8NjndBRRBjV90=;
        b=kAPRQgXHYP2ezt++GGViYXyYSlYJLTmxKpuuMOyReuQUGXsndwRul67YRKRtRjmZ14
         F6arOGHI3KlqWgS2MRcvKqMlUFjygxBiqnzCDO/Y1V8TbW8GW9vxJZjPI9WQ8uSsTCbf
         qrhlFqDOJeDjE/LvtAOzgi3mXrahAZvGb3ijsCpQklZkHnC2iyvdKcPsQlK2sB2fWfpB
         u8iRotr3REyTgpSJ5XzWtuslc+TgUIOLK8a3na3eUbGNkBoOU/A0fLxexrjpwBEp7rf6
         WFJLJUReXKYHbRCpGdHYXOXDu3OTuTWLrC5z2Xd+r8p71YGT7R8JEiYv7RmsUeuqTWWj
         2vIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uzDtpb8qB7EkuggCkLpOPSzYqyMUIM8NjndBRRBjV90=;
        b=HZgb4M0lrBzA7ObFY3lItVSF8jZtQQjer+0t7zcrejBYcz8iB+n9p9z7lpi1QNjpqK
         /YwQ6Yv2Bq0SDzazqxBo1ZD9tbHTBqN6AsddB0IWOOiCFp/SUtHXyVhkp2vjDJ4w6vu5
         hn9hu3Ocq7KOYy2Km/GlllUcdH/8zBGUnZ12b0UIaA70lv43oKRBltr/UFmz85ACe2Lt
         Gi1QobpfnWothgRpLEhj/Ioq4nWi0xHyCaTPY7jrZ7opNGsrzbqXPSdMQXDXp53bsRJ0
         0aExHafeIKiKF76f7+OYxGVKYK8IA73EDFlywLbb/vi6SgZehHoXFufwtn3n6L2Gwgm9
         53GA==
X-Gm-Message-State: APjAAAWeGFJ7tHhJvD10FgdyewzhEpPjl9hPu+QnfZ2Zwg3CJaLmeaNc
        dqHmfgqQEBHRSgatn4yS/VyeCw==
X-Google-Smtp-Source: APXvYqzkp/LIT8V17koNGb4TkevP8y/v+rwPFtdhTil6TyJEu5caRrspHQUfGCWfRyhS9+CRROfdCA==
X-Received: by 2002:a17:902:5ac9:: with SMTP id g9mr4853398plm.134.1559238351991;
        Thu, 30 May 2019 10:45:51 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id a69sm4267838pfa.81.2019.05.30.10.45.51
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 30 May 2019 10:45:51 -0700 (PDT)
Date:   Thu, 30 May 2019 10:45:50 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH iproute2-next 7/9] Add support for nexthop objects
Message-ID: <20190530104550.62d78d8b@hermes.lan>
In-Reply-To: <20190530031746.2040-8-dsahern@kernel.org>
References: <20190530031746.2040-1-dsahern@kernel.org>
        <20190530031746.2040-8-dsahern@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 May 2019 20:17:44 -0700
David Ahern <dsahern@kernel.org> wrote:

> +
> +struct rtnl_handle rth_del = { .fd = -1 };
> +

can this be static?
