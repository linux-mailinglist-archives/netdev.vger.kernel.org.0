Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28E9E222800
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 18:07:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729084AbgGPQHJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 12:07:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728374AbgGPQHI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 12:07:08 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93FFFC061755
        for <netdev@vger.kernel.org>; Thu, 16 Jul 2020 09:07:08 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id z15so7610896wrl.8
        for <netdev@vger.kernel.org>; Thu, 16 Jul 2020 09:07:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5WuKZaiLzVoCG4+51nhsl4nIS0Ta+YQ9r4oS74n3K68=;
        b=xW2/GTVV3gHhczMsS0qzeR1UL80EwacVAPU6shdvXaYuKaS2uLyBn0avnXn/eA+k48
         /Un/3Q80vgR397rVKA3/8rYHPQKeTnnrHkv6PejACqJPtU8oBjG9njTmK6Dz+lewya9d
         BoENhl11SHosFatWrZm9iMCbsWqQ3D8gR3LPzrNht6AWKQT2VfivveOADe/WeIOhdvQS
         d2Z5RO3lTTOMGWao4e2Yn/NkwjkS9dqudNxzVbi3GsZHKQQGMbrqQNINaYjxNsFMGarj
         p/niQL+rrEYnbfqvM9TzbA3oY4GFNgidoSzTh2vMUZ/7r3yn5MkAIs7+FXvuZXSa1sSe
         Ga7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5WuKZaiLzVoCG4+51nhsl4nIS0Ta+YQ9r4oS74n3K68=;
        b=eh4ohZpeFRVfa0O+/mrun7ITgs7gsaf2YI3PDsrecz7Bbva0X4Wz4j79438X6j7WrR
         TAXl1RYi1prJ0uAmLZaDhVcJW+auYDxWkS4a1+ZOKry+E9useV+nuY4cAuCAJ4jhuTps
         osSywszePTmS0xZSTjlbYO9MiNMWiwEng/A//nbo+e0nWxRNzySzCAF55Qn5VbJ+vVpP
         o3Diq00hvUyHEV3sVPtWnVujUZaSE6PuRYmhGvDqRWHZ0V2eCpHW6VJE5zA+BBY8iknM
         qa9DutwTpMcL57cII6D/syU3XOk4BeStFdWfPigS2j/KqPo10S0J2IMNjOG/Ip6wxOVh
         ea6Q==
X-Gm-Message-State: AOAM5303cNip9mkTcRxl4ZT96DOIaBsc4oOOEektgrXHkdDetzmJ3nuQ
        F/5LLPofnLKbe/sa8sJoI8poE89+NLI=
X-Google-Smtp-Source: ABdhPJwbEOhhW9ltdXKbS2VzfM7KaM0zkoObA7wkS8w8TtPNM5Y00HzGwOaCzyw3dDSzfgKQ1KBv7A==
X-Received: by 2002:a5d:4751:: with SMTP id o17mr5842107wrs.345.1594915626072;
        Thu, 16 Jul 2020 09:07:06 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id q7sm10073725wra.56.2020.07.16.09.07.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2020 09:07:05 -0700 (PDT)
Date:   Thu, 16 Jul 2020 18:07:04 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Petr Machata <petrm@mellanox.com>
Cc:     netdev@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>, Jiri Pirko <jiri@mellanox.com>
Subject: Re: [PATCH iproute2-next v2 1/2] tc: Look for blocks in qevents
Message-ID: <20200716160704.GB23663@nanopsycho.orion>
References: <cover.1594914405.git.petrm@mellanox.com>
 <7c8ba84ef268fd03e849829278db891a855f4c8e.1594914405.git.petrm@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c8ba84ef268fd03e849829278db891a855f4c8e.1594914405.git.petrm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Jul 16, 2020 at 05:49:45PM CEST, petrm@mellanox.com wrote:
>When a list of filters at a given block is requested, tc first validates
>that the block exists before doing the filter query. Currently the
>validation routine checks ingress and egress blocks. But now that blocks
>can be bound to qevents as well, qevent blocks should be looked for as
>well.
>
>In order to support that, extend struct qdisc_util with a new callback,
>has_block. That should report whether, give the attributes in TCA_OPTIONS,
>a blocks with a given number is bound to a qevent. In
>tc_qdisc_block_exists_cb(), invoke that callback when set.
>
>Add a helper to the tc_qevent module that walks the list of qevents and
>looks for a given block. This is meant to be used by the individual qdiscs.
>
>Signed-off-by: Petr Machata <petrm@mellanox.com>

Reviewed-by: Jiri Pirko <jiri@mellanox.com>
