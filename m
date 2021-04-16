Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 776F43629FF
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 23:13:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344152AbhDPVNK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 17:13:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235809AbhDPVNI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 17:13:08 -0400
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E381C061574;
        Fri, 16 Apr 2021 14:12:43 -0700 (PDT)
Received: by mail-qk1-x72c.google.com with SMTP id o5so30375308qkb.0;
        Fri, 16 Apr 2021 14:12:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pej7cYSY7G++pCyMAJmDVXBzw+DrojrmueaKR2kfWvY=;
        b=BX/Uss1RFKucFsMCZsRQ0QE7jgcdrT1NnTd1q4O6jafSkjbXH39SrsG8+l0iWy0DIU
         ExSUB5BDfr84ZeqgYn2q6VYaM6yaGa7hGs3xf1+ozEp6y+C5y85tGE1kiHnXV/IHFs3q
         m7d6S5iikMF2BQvD2FeAg0n/Z6PRZBVX9EjtBLcvC/zgBLzcsgzUuENtKqtwm78JTO9p
         JF5TzsiVWfJOPMA9Egz2N7KZymkTvOguPpre2YOFxm9+ksiSDyL/oDBXqiOhHb+AshWV
         ndJl5JeDtQc4VNYsDHVYeSoQbPNBLB/mgERlgkdsK70uFb0L5X929MiczHULRjZDa8hJ
         E0Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pej7cYSY7G++pCyMAJmDVXBzw+DrojrmueaKR2kfWvY=;
        b=mx5ssOIlI1hUa5h650ID+FIDRNKAhdPRUMh3LlzZDdpZIM0hKGmwVcAeE6uiI1EiFN
         0f+KQsHFA7b7DLxJ/Tb416iHR2oDd0KRlBRPBKyVqbPZgm/5T3Ep04RrVuypblE2L8Rm
         SQPzOauBOLqBUY8QjjW/D2xQiFFCAHVWGO0u+2IsylLkoIdn16JLtxdx4irBbK14EnK1
         eXEI1Lzi/vgJU4AJsiZpC5dHuR9ifq5kVcWpOZYm/sfsyTz2zFsWZ0WNXi0AIRM7wE7u
         n5A7T1EKQTgIKfrcumlp1PhV7aWS1dgPLr300z2PE/Gjp31j/ra5cxVEvtDHmYhDPSP3
         dmBg==
X-Gm-Message-State: AOAM533dWV9jg5k8M3E9SiB+LOkyfzO65DycpdbdC61l5EgZ3yH3/Bva
        lbZCk8dCy97u/JCATVLOuvVJx+WRwf5uQdm9
X-Google-Smtp-Source: ABdhPJwz15JS4tTE2Z7l24KG2GsiWuSfGDGJ4OnV+YsQx2YUL//IMrj070shK8loUGD6wZjFLwtjYg==
X-Received: by 2002:a37:e50e:: with SMTP id e14mr1201256qkg.117.1618607562894;
        Fri, 16 Apr 2021 14:12:42 -0700 (PDT)
Received: from horizon.localdomain ([2001:1284:f016:34ad:eee9:5f0:5b4c:3593])
        by smtp.gmail.com with ESMTPSA id d14sm5064497qkg.33.2021.04.16.14.12.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Apr 2021 14:12:42 -0700 (PDT)
Received: by horizon.localdomain (Postfix, from userid 1000)
        id 13155C086B; Fri, 16 Apr 2021 18:12:40 -0300 (-03)
Date:   Fri, 16 Apr 2021 18:12:40 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] sctp: Fix out-of-bounds warning in
 sctp_process_asconf_param()
Message-ID: <YHn9yNDetZu4bFFR@horizon.localdomain>
References: <20210416191236.GA589296@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210416191236.GA589296@embeddedor>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 16, 2021 at 02:12:36PM -0500, Gustavo A. R. Silva wrote:
> Fix the following out-of-bounds warning:
> 
> net/sctp/sm_make_chunk.c:3150:4: warning: 'memcpy' offset [17, 28] from the object at 'addr' is out of the bounds of referenced subobject 'v4' with type 'struct sockaddr_in' at offset 0 [-Warray-bounds]
> 
> This helps with the ongoing efforts to globally enable -Warray-bounds
> and get us closer to being able to tighten the FORTIFY_SOURCE routines
> on memcpy().
> 
> Link: https://github.com/KSPP/linux/issues/109
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Thanks.
