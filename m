Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CE892E6E56
	for <lists+netdev@lfdr.de>; Tue, 29 Dec 2020 06:40:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726060AbgL2Fjw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Dec 2020 00:39:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725832AbgL2Fjw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Dec 2020 00:39:52 -0500
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CCDBC0613D6;
        Mon, 28 Dec 2020 21:39:12 -0800 (PST)
Received: by mail-ot1-x32d.google.com with SMTP id n42so11018850ota.12;
        Mon, 28 Dec 2020 21:39:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=R9ByP+N9DCd4W7UAuj76HMoVz7yWv5XpzVlq8HzRTCs=;
        b=soiN9pxj+Jyk7W9celd8J/lBC6Eb+OXxvwR1HU/LFxxyQqOC42vryV6a8rWhV2K9/z
         KH3CaIksDvkjxZPkYkBYj7603nMjqxansAlAiln4HV73I/2LiBE868BDxGcVXWtJIVqt
         ExcGlAOjuygWZYiMiBU4tuoapyuualQxnqhq528elB6Db+E9KitXq0Hs9OS0mrK+A33S
         jMsoJfXDcbdj1tNczG5PTlpqkvTv4j1bzrJhBjRy6FbXP4x75GnwUpKbL4tkH5khrbPu
         fWOwHCZU9i6ps18qv8I9DDX0tqvI1s1mhAb8Spr4HByI7xYxF8HRqmA5959rfNRJDDAC
         yRfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=R9ByP+N9DCd4W7UAuj76HMoVz7yWv5XpzVlq8HzRTCs=;
        b=ezkgiSEkP5oY34j3UIVXH9TQkjV3A/HLUlqhxUDyOrd4rDc4nJB1Rvule0XiiD66HL
         8dCN7H3CynBjWNsXNmx8tBYIBhTeS5qg/5bymBQusseAwRXiToV+D/U/1M8GIAUb9fXs
         TnthN/oBqI+FJya0plkp20zyGUd6rqW/3JbOhFHmP+pCTqpYcM7mlKGMBGIwm2wi8lQC
         Oez1ZmL1u6h6BONMOLAyfKtVVI/q3mikCYbWPbrse+N4zXfP7WntlRLvYJ1PWNgYA+in
         LMOebQ2kQWD+JY1R39zPQlgRQyKxY6zX4plYOgMaZN3Ijb6ZftHFb7eGkg8bi5IdGSeI
         f+dQ==
X-Gm-Message-State: AOAM533POte2i6eqhH2wb8LkTFDiAwlqN1MxaXZVa0CB8knLl7AQ6ABc
        N0XqriyQwlmcnq08T3Fq4Fo=
X-Google-Smtp-Source: ABdhPJwadkeMQU2bhzfp8nb7b2s8tVVrPfTyBUQtg6DgWfXlydpyEZgTRVSupxyGkP40iZNZMHodgQ==
X-Received: by 2002:a9d:1d41:: with SMTP id m59mr35071998otm.100.1609220350678;
        Mon, 28 Dec 2020 21:39:10 -0800 (PST)
Received: from localhost ([184.21.204.5])
        by smtp.gmail.com with ESMTPSA id z14sm9676105otk.70.2020.12.28.21.39.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Dec 2020 21:39:09 -0800 (PST)
Date:   Mon, 28 Dec 2020 21:39:02 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, brouer@redhat.com,
        lorenzo.bianconi@redhat.com, alexander.duyck@gmail.com,
        maciej.fijalkowski@intel.com, saeed@kernel.org
Message-ID: <5feac0f6a2a6c_7421e20843@john-XPS-13-9370.notmuch>
In-Reply-To: <7f8329b6da1434dc2b05a77f2e800b29628a8913.1608670965.git.lorenzo@kernel.org>
References: <cover.1608670965.git.lorenzo@kernel.org>
 <7f8329b6da1434dc2b05a77f2e800b29628a8913.1608670965.git.lorenzo@kernel.org>
Subject: RE: [PATCH v5 bpf-next 1/2] net: xdp: introduce xdp_init_buff utility
 routine
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lorenzo Bianconi wrote:
> Introduce xdp_init_buff utility routine to initialize xdp_buff fields
> const over NAPI iterations (e.g. frame_sz or rxq pointer). Rely on
> xdp_init_buff in all XDP capable drivers.
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---

Seems like a nice bit of cleanup. I spot checked math in a few drivers LGTM.

Acked-by: John Fastabend <john.fastabend@gmail.com>
