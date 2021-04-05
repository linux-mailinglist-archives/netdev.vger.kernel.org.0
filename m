Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 859BE3546D8
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 21:00:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235491AbhDES7P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 14:59:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235446AbhDES7N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Apr 2021 14:59:13 -0400
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C540C061756;
        Mon,  5 Apr 2021 11:59:06 -0700 (PDT)
Received: by mail-qt1-x82d.google.com with SMTP id i19so9309016qtv.7;
        Mon, 05 Apr 2021 11:59:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tjfSnHDwy963ouIblOpSqINQ9w23bKFoN2tW4C64Pfg=;
        b=eZWpaXusUPanX6VkN7hRqZyexZFRBSmoxCeHPqOElGHy0OA+TNVSifH52Gq6wgk8nl
         MAhi6icoY1n0hUhQFoqFVKBegOcTaqcUkE7nVSBizP6KInc45efBXnCdhnz5eCCygCVA
         u3zqH15GoyMrHL3b//kBb9pvVEXfuLn2vEyoswqEzYtqBrsxIbrO2l/C7KAAt8m1klQw
         gG2IY8lhFf7eIGZ81rwahfoFSyBHmP/VO/kB2wpUC23mMEWW80Uaae0EGKubvBib9nYB
         XZJg9ctFHgRkOTd0sMz2+VD23+fniEthbxh0gfR0Os6WPkuL0udwmm+ZBuLx7szYnCCa
         2Wvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tjfSnHDwy963ouIblOpSqINQ9w23bKFoN2tW4C64Pfg=;
        b=a36SR/2/ff9tFUaTIRu3OWbfpKsQd9DIBLw6zKoSkxGGcNPE2N06ghTtFZ3VVNvuLH
         sblNt+naNswT+xUjEgYuYISc9U7alXqSZvaznhy0wCK/5aKap1ACA0a0a/1BWR2YgAmo
         zv/YnA+VrtvW4NwoQIPzQvhDRsxevND8WPm76WW17tAmUDBuxmRMtdF0hOjhQc6UhFH9
         IACxFfeYHeOZCOotCcK6Ve6gyQlLlm1YEi94Ymm6Xl2MA06g7SnG0oAph6SEOa1HY1Kd
         YAe7iI/eQr3L8cQbqH+3Ibi0vxd+mmLNMRyfifF16BjAoUYZZId1ZOEjao5cQb+sk3a3
         DWRQ==
X-Gm-Message-State: AOAM533mqUgGCd6z01+cMPChnBMcuWAL/lx78e7+Uxv6/p5EmbF23dvd
        nYpD4tuBow7cLlCwhmCbJxlfhXRL+Q0i/w==
X-Google-Smtp-Source: ABdhPJz975hF1PWFiSgVePWbFGwu8SKegEIH5J0v0R4z5nXeGRfv7Dp8VbHYo06gcf2NmDIN/tQ2og==
X-Received: by 2002:ac8:6d2b:: with SMTP id r11mr23566240qtu.245.1617649145602;
        Mon, 05 Apr 2021 11:59:05 -0700 (PDT)
Received: from horizon.localdomain ([2001:1284:f016:6e1c:5415:37a4:3b1e:78a])
        by smtp.gmail.com with ESMTPSA id g4sm13388135qtg.86.2021.04.05.11.59.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Apr 2021 11:59:05 -0700 (PDT)
Received: by horizon.localdomain (Postfix, from userid 1000)
        id D6ED0C0D87; Mon,  5 Apr 2021 15:59:02 -0300 (-03)
Date:   Mon, 5 Apr 2021 15:59:02 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        liuyacan <yacanliu@163.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH AUTOSEL 5.10 09/33] net: correct sk_acceptq_is_full()
Message-ID: <YGtd9kaPvfSUKERW@horizon.localdomain>
References: <20210329222222.2382987-1-sashal@kernel.org>
 <20210329222222.2382987-9-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210329222222.2382987-9-sashal@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 29, 2021 at 06:21:57PM -0400, Sasha Levin wrote:
> From: liuyacan <yacanliu@163.com>
> 
> [ Upstream commit f211ac154577ec9ccf07c15f18a6abf0d9bdb4ab ]
> 
> The "backlog" argument in listen() specifies
> the maximom length of pending connections,
> so the accept queue should be considered full
> if there are exactly "backlog" elements.

Hi Sasha. Can you please confirm that this one was dropped as well?
Thanks.
