Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B17521D7E3
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 16:08:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729971AbgGMOIt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 10:08:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729689AbgGMOIs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 10:08:48 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B19F3C061755;
        Mon, 13 Jul 2020 07:08:48 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id l12so17341857ejn.10;
        Mon, 13 Jul 2020 07:08:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=jFx3xxix0F8ETQCtd//YrBkRHyNpSKt8DUbehu81nM0=;
        b=hiQgbcp1vIlX39x6+QVdnLHGJ77oa5e1fwPasSS2+sV8zK6rqOW6JJ5Z0pNLWQ3fyH
         odx7b6feIbBRhv8AmdyCvjpu0Er3BjW++icYFpMcdLmYGXMb77ApdSCFPHQ7PYZx99Pk
         I8Mkstkgkprd7gWz2X1JGLeP0HTASvNy6CqmbcfoqDEDZQChTyxcj63JpPe2R9IPFeT2
         /H1agutVggOmAMHTMBd1fVRznJhJOpwoIKMNSwMgPNuLntSS4oJmPdK6ISJkxSSBE833
         eVGo5j4lAbf7jgdbIbwlcZJzo8zXY3jvhHGQazORWLnEKzUgjRXdpzLO50YpqLvoskPU
         1YgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=jFx3xxix0F8ETQCtd//YrBkRHyNpSKt8DUbehu81nM0=;
        b=kD7MaVRXN9n2i/OypgDP4Fmg0zWlPtBbDbm4xk6d5F/0u7tey1nc/1iru5L0kBqTMx
         pVrWpsPBb3BLC8rj3bYFPAiaDsjO8xLe1RAsaDXbOasi347A+ECN+p8+8IpK+/NI3cAr
         UNWSpyDTCRGbimiOibjm1RTxUGHkkkHNo6SQaMAVbWogjwwb3mkYgslB65MSotnvLPsn
         kYnkv3qq464uEN1Z1mlFndLp/6EKm5hYpLYtYDGbYdeiEjBn2vA3J6qndcYDDoHgXRqG
         9Srp1GU8Ig4b/ItdAF7CQncEtmSb+Z8yEIC1bdrGtJ6fQtUErYIYfReSPo5BB1rWd3Bt
         AjEw==
X-Gm-Message-State: AOAM533VKLkC2bSbeMWfgFSc9cbR8HvdSXBqryh0elIdqkaBtxbVXghw
        dDmACm/OZbSaht8nAp/3Unbnaj2Y9UL7eA==
X-Google-Smtp-Source: ABdhPJx6tmdfVPPqPXF73jvefigbV9HS5iNfnxRnmUOs/bTLDWDUL20JfnLrxQhjKR+rCuUnUBZ6NA==
X-Received: by 2002:a17:906:7017:: with SMTP id n23mr56573249ejj.262.1594649326677;
        Mon, 13 Jul 2020 07:08:46 -0700 (PDT)
Received: from net.saheed (54007186.dsl.pool.telekom.hu. [84.0.113.134])
        by smtp.gmail.com with ESMTPSA id p4sm9800064eja.9.2020.07.13.07.08.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Jul 2020 07:08:45 -0700 (PDT)
Subject: Re: [RFC PATCH 12/35] r8169: Tidy Success/Failure checks
To:     Heiner Kallweit <hkallweit1@gmail.com>, helgaas@kernel.org,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>
Cc:     bjorn@helgaas.com, skhan@linuxfoundation.org,
        linux-pci@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <20200713122247.10985-1-refactormyself@gmail.com>
 <20200713122247.10985-13-refactormyself@gmail.com>
 <e6610668-4d16-cbaa-8513-9ca335b06225@gmail.com>
From:   Saheed Bolarinwa <refactormyself@gmail.com>
Message-ID: <c42ddef7-d6b0-158d-8278-80a582d2cca4@gmail.com>
Date:   Mon, 13 Jul 2020 15:09:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <e6610668-4d16-cbaa-8513-9ca335b06225@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thank you for the review.

On 7/13/20 3:45 PM, Heiner Kallweit wrote:
>
> Patches 11 and 12 are both trivial, wouldn't it make sense to merge them?
> Apart from that: Acked-by: Heiner Kallweit <hkallweit1@gmail.com>

I separated them for easy review, I will merge them in the next version.

- Saheed

