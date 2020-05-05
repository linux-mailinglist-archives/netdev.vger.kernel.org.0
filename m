Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96C6C1C5EF0
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 19:34:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730359AbgEERe2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 13:34:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729663AbgEERe2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 13:34:28 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 320DDC061A0F
        for <netdev@vger.kernel.org>; Tue,  5 May 2020 10:34:28 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id v2so1096625plp.9
        for <netdev@vger.kernel.org>; Tue, 05 May 2020 10:34:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7JLqCYuJVayCNWZ1ofB2Z3sXmxXGsoqa/HAhVS82vFQ=;
        b=FZPIWdq0ihiP4hoxVfh0TAOv9Icoz8PwZgx2O1bZPeo0SvFTAi9uS0obXv+XMNmuWf
         XbDRw7dH0J63yMu6O8xGlwTnQ+OM+CiyePUCM/H0cXnsE9EcZCT+pttxqlKIPSguxVpZ
         pz1y6V5ToDHKstJWbX7XfBVV3VgEZ0jNM1rRp2TBlyy0/Xw3ftdw08mtiGuwQbeYtVqg
         btpChm/lWxomoV79CvarYEUmOKMB3p/HgHL8V7uGzHt/DswaTMdN1tO/fgGMmr6xNbLo
         fMh3VsLHj2b3eyl34np28WkFfcw0dYQA52qyK3Y+o4WnNMmegPUhDf7zJfql6iNAOnpy
         qGpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7JLqCYuJVayCNWZ1ofB2Z3sXmxXGsoqa/HAhVS82vFQ=;
        b=E5BiEWaqAp8aO02osLe7WkZizQQKJ6uUl9Gspl95euC4mYAAPFEskF7qG0hLvpv4Ib
         dsTwrH4RbvgaVoJbnY1Nl2koPueRAPwecyv0RX8Fvl3IihNEwBkvwOE+C/zILcJIJHje
         OrlP3Nei5iPsj2ytGp0keHUb7ZHZl3FqquC8AXTUBGu5vKP1Flq6dX7IHasnSaP/swO1
         nzcTL0JA3CkfDoLeMKXGw8T63qEn5t/mazJ2v9z48XbPbbQ8lbfq+TKSu+a5R67LHpR1
         FsE4472p9Jzrvoi1AxTIRKxlEM+NqrCJzG74rIMx+pSXYB0e/hX6CPYeHE2kg2x4TgLR
         MeTg==
X-Gm-Message-State: AGi0PuYf2qNLEufhmkph9g3RWEPUD8T0vNXj+3Y0rCWQ4dCXIF+SgVuM
        c5bau0jvJkN0Ew35Xu5ME6uTHQ==
X-Google-Smtp-Source: APiQypKGj130SDYKeCM71sKVZaknc8rVL3DFIyPBk4zQNaK8g1wdy2/LhvyvlDDMveWl1GHixo6/AA==
X-Received: by 2002:a17:902:cf87:: with SMTP id l7mr4090089ply.307.1588700067533;
        Tue, 05 May 2020 10:34:27 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id q19sm2573552pfh.34.2020.05.05.10.34.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2020 10:34:27 -0700 (PDT)
Date:   Tue, 5 May 2020 10:34:19 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     David Ahern <dsahern@gmail.com>, netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH iproute2] tc: fq: fix two issues
Message-ID: <20200505103419.590146ce@hermes.lan>
In-Reply-To: <20200505154348.224941-1-edumazet@google.com>
References: <20200505154348.224941-1-edumazet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  5 May 2020 08:43:48 -0700
Eric Dumazet <edumazet@google.com> wrote:

> My latest patch missed the fact that this file got JSON support.
> 
> Also fixes a spelling error added during JSON change.
> 
> Fixes: be9ca9d54123 ("tc: fq: add timer_slack parameter")
> Fixes: d15e2bfc042b ("tc: fq: add support for JSON output")
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Applied
