Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFEBC226CA5
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 19:00:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388949AbgGTQ6m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 12:58:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729409AbgGTQ6l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 12:58:41 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 199D5C061794
        for <netdev@vger.kernel.org>; Mon, 20 Jul 2020 09:58:41 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id i3so13622189qtq.13
        for <netdev@vger.kernel.org>; Mon, 20 Jul 2020 09:58:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yrYU++O/Y0Os6jNsvnF3GJuoTIebv6oJnFmQnwQFi4U=;
        b=BJE8TJB2NJuX0pCCvsFjeDPGTdg5zNOp8J7MZIb37HFusmbA+Ea6qjk3kT4A5zPL6e
         gMrdcQxyZ1N51JJTYFmUBCg5pI0mcXd/AfrQgNcrbu6PE6bM7tuhWDxkdssYvYbtMfu8
         QEP6XYPmcG+hUHkGPPDAPfJJwJTSbc+PmO04StaeclOTUy/KaTezeqCBlJS8yMliK3/F
         2Eh/SZ9Hp1hWw52vjWFNcJnTabaYhYj2GhRcjMf0s5W3oevqpmQXN6ZBDmCLDTd2KaEt
         BDTNNiMFm/MCqayXUowV2Am6f/9E63a9r394hvoFQDfXdsDdB0MhN6DGwWoLeBP9Nqfr
         w47g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yrYU++O/Y0Os6jNsvnF3GJuoTIebv6oJnFmQnwQFi4U=;
        b=iD0YQLQg74BV3U82QckMz3/DaXhRf4Y12S3tj2UHr6T/vlzRNjchm4BsDmgaCuYhIY
         wxUErnabjNkX5oIvQjo4lF0ryKA3m4MohGHbfhcUKDY2lbW0RmBFjZA4zw4GHMy+btVX
         3dNFfj/xw0EeGZsFC8DnXMC8g5yI9th8W3PzCrrQtDFeiV465BJYDc9ofGhW7O1+EML6
         u2QEICznMvXdbKHvx6BSWJZebdqmez+8rI3Zd4LWTyDxltA9xlnlunPzESSyEbXNiD6P
         jy6NZLIDjwICMzX5NxqVzq7FnvV2eaL7QoYlS1ALmMRfB7v0fAbc07k0FMhKzlrSELVS
         y4Hw==
X-Gm-Message-State: AOAM533fmd1Ds2QzvBnJm4674IJaOX/V+OuDr/1fxK4K9AUqTPXg3hSD
        D9VeLVPXrla2f5Vwa//YYkU=
X-Google-Smtp-Source: ABdhPJz5gevbewRib98IdyxtwzZqumPAzG8+N50Th+9aiTnzn10N4jHbbm0CeqqVlBcRGOPtBIaPWw==
X-Received: by 2002:ac8:1c09:: with SMTP id a9mr25001423qtk.64.1595264320417;
        Mon, 20 Jul 2020 09:58:40 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:247a:2d5a:19c4:a32f? ([2601:282:803:7700:247a:2d5a:19c4:a32f])
        by smtp.googlemail.com with ESMTPSA id q189sm116606qkd.57.2020.07.20.09.58.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Jul 2020 09:58:39 -0700 (PDT)
Subject: Re: [PATCH iproute2-next 1/3] devlink: Add a possibility to print
 arrays of devlink port handles
From:   David Ahern <dsahern@gmail.com>
To:     Moshe Shemesh <moshe@mellanox.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        Vladyslav Tarasiuk <vladyslavt@mellanox.com>
References: <1595165763-13657-1-git-send-email-moshe@mellanox.com>
 <1595165763-13657-2-git-send-email-moshe@mellanox.com>
 <84c465a4-867e-80de-f38b-9fb7da733e0e@gmail.com>
Message-ID: <38d403d0-40ba-beca-98c1-02a4cb392fab@gmail.com>
Date:   Mon, 20 Jul 2020 10:58:38 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <84c465a4-867e-80de-f38b-9fb7da733e0e@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/20/20 10:44 AM, David Ahern wrote:
> Why can't the 'if (dl->json_output) {' check be removed and this part be
> folded in with the context handled automatically by the print functions?

never mind; I see now.
