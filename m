Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCCBE1F325F
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 04:48:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727027AbgFICsq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 22:48:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726818AbgFICsp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jun 2020 22:48:45 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CD6FC03E969
        for <netdev@vger.kernel.org>; Mon,  8 Jun 2020 19:48:45 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id w1so19496946qkw.5
        for <netdev@vger.kernel.org>; Mon, 08 Jun 2020 19:48:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2sxlE7i93AFiNSjHpfbDPGRWunaZuuI3VKN4VdQdlhA=;
        b=pf0M04atEFgndDASzxXbtGJkB5lVTj/DnLui2DgRquFKZ6w4VfvPDEq2nLHT3/ulkB
         sDBYhP+rnBSaV4xcUa3OB42eGalgwK/OjABdK0HWRpJJu4OtAlAmY/rPodM/nZA/1UeY
         4Hnt507Ma9tEFKnd7QPYjxCCg0IuDRhGwJVMgLqvl9KmvOHWg/sdACPzz/wbR0mxOrGu
         gt2b6U1mbI5dwly8NWzgeU+MTn6tIIi3wZC5NWiVhimV7FJ0rqKgFUX9JYGvZCG4pb+D
         AfGhUTlsfIct8eDjiot6+RjHoecYGf/9GcXeaeR5uNx8Nkmd8k2WzWQUwKnidC6t4o0L
         AiBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2sxlE7i93AFiNSjHpfbDPGRWunaZuuI3VKN4VdQdlhA=;
        b=T1vevoul8IUYf0yQ0AsVa/jBgQ0i6p2XcqIwL0lKhWq97mL8zdR6pPVk+8x5Ou8w0Z
         AONM1Htvo0t6Ndmbqr+jUNJWhVAbi2pbQktiN25uO+QaSDocMY1MYnpBAqJsM0r07P7S
         rtZKm0hwLpS2DUbYdPbHevcPoEFLPIqrPRftwPznvQXcobzOurHhvAWxYaTJ/BxgUVlO
         bXvrsmRHJw2fvODnJrpdPqu8dBkeEMcntQKr7fgS/f4OpwGO3LH+Af6o7rGoQVRXLm2M
         6gMUnCL324Hwrm8hBmQ/lb18e2aShwbAEUVKZpa3Xl6vi4vqh+KDyb8vAH/ksWL/D+Gr
         KEpg==
X-Gm-Message-State: AOAM533fGjEFeg8DP6CHkOxSz56eDUf36LVrjkOqWwCg6X57SkBfGNQN
        omJHjSQyMdCrV7felnb4nlE=
X-Google-Smtp-Source: ABdhPJw85IRG2oFXHjdkRFhoguPAz7W+1rjbaT/Mjjz2Qx0dFdusKJN8Ca1rPTSj+FSZd+Dp/1GBlA==
X-Received: by 2002:a05:620a:c09:: with SMTP id l9mr26390792qki.224.1591670924525;
        Mon, 08 Jun 2020 19:48:44 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:88f9:fca6:94cb:96a4? ([2601:282:803:7700:88f9:fca6:94cb:96a4])
        by smtp.googlemail.com with ESMTPSA id i94sm9506804qtd.2.2020.06.08.19.48.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Jun 2020 19:48:43 -0700 (PDT)
Subject: Re: [PATCH net] nexthops: Fix fdb labeling for groups
To:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net
Cc:     Roopa Prabhu <roopa@cumulusnetworks.com>
References: <20200609002120.16155-1-dsahern@kernel.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <8911b1d5-db1c-3e3c-5611-b0a88dd34996@gmail.com>
Date:   Mon, 8 Jun 2020 20:48:41 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200609002120.16155-1-dsahern@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/8/20 6:21 PM, David Ahern wrote:
> fdb nexthops are marked with a flag. For standalone nexthops, a flag was
> added to the nh_info struct. For groups that flag was added to struct
> nexthop when it should have been added to the group information. Fix
> by removing the flag from the nexthop struct and adding a flag to nh_group

I forgot to propagate the change in remove_nh_grp_entry. Will send a v2.
