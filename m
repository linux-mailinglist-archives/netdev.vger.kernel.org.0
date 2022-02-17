Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EFC54BA959
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 20:13:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245020AbiBQTNL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 14:13:11 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242994AbiBQTNK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 14:13:10 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65EF63DA7D
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 11:12:55 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id m7so6565746pjk.0
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 11:12:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3fEJ3C/P4yuKXc5j4CNSm63ZPK4fQ8h1OmBDPcudfp8=;
        b=tctaulTLW+thz+hRCngGh2LZP7Vd916lh+iESaxapvqcNERtlESH/HQdbQ+wDfZuLF
         dU5C8TCj45Tey3TX2g4VIEIoQtPtTZ2AK1VJmjy0eaufk9qpGMCZlFehfTO5zGdCJubc
         vrc2UqcJ3tWE6MpSMns7gpI78+TKSyX6M5BPNZDR51qvrKpMzFwQYI90UGI26nEG9nkb
         bN60sdlJnRqZ1lJfAcAOmWfVSG7ci1d7FSdVw/9CTyCxtRqx15IABwzdqyMkr2dPQHDe
         halu0gwgzFFmkh0LmaUg4mOylFmsckZNORcUrBg6+3U+drr/+KWI6DrQjp246m3+ET0v
         ePzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3fEJ3C/P4yuKXc5j4CNSm63ZPK4fQ8h1OmBDPcudfp8=;
        b=HFZw4IdCvUOkxBxq3OWHKcitM2KCnnrR0YtApbGeeH13EOtFLNtSeXrVQK8qi+s7fP
         ftw8Fycf/ivPhz7MKmgLxrVcsR03Bv1wGxavRaHet6+qza9qru1BEdOz4rxmHbXKFeeT
         OBGO6FvMfW7XfPjhkiGQTCeuT0hTDGruejFpcjuNrZ5h5NbuxiLT71OHXkALv3mz+yM/
         HMv5jATo7mZB9WvycHp7O6DNuwe0nPJ4O4e5XKZheLiGKDcdhtLVbeZw8C6dDc2QrzrQ
         oAZFa2Z85rwCxVnOWfnSkbRiMBWRcnryW0f1gWUc3SGItFqMid9ljRc1g9rkALxjsleQ
         5dRg==
X-Gm-Message-State: AOAM5315d/Tjdjc8qF/hhvMiSXkYG5enDy1Ms9Sk4y8iD1cj4zAJh/Om
        rg/QdDTZxAX1tptrkfwcgKV3H7qf3tYPLUXG
X-Google-Smtp-Source: ABdhPJxDte0eCar7/aNA7N1uLSrUB8Qgyjqd7gadXTgym5+q6VQivFFsM2P0ggvwSJjUQSlDjaCrmg==
X-Received: by 2002:a17:90a:3b05:b0:1b8:af52:e77 with SMTP id d5-20020a17090a3b0500b001b8af520e77mr8793099pjc.180.1645125174880;
        Thu, 17 Feb 2022 11:12:54 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id oo7sm2676886pjb.33.2022.02.17.11.12.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Feb 2022 11:12:54 -0800 (PST)
Date:   Thu, 17 Feb 2022 11:12:51 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     dsahern@gmail.com, gnault@redhat.com, netdev@vger.kernel.org
Subject: Re: [RFC iproute2] tos: interpret ToS in natural numeral system
Message-ID: <20220217111251.30ab3eb5@hermes.local>
In-Reply-To: <20220216194205.3780848-1-kuba@kernel.org>
References: <20220216194205.3780848-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 16 Feb 2022 11:42:05 -0800
Jakub Kicinski <kuba@kernel.org> wrote:

> Silently forcing a base numeral system is very painful for users.
> ip currently interprets tos 10 as 0x10. Imagine user's bash script
> does:
> 
>   .. tos $((TOS * 2)) ..
> 
> or any numerical operation on the ToS.
> 
> This patch breaks existing scripts if they expect 10 to be 0x10.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> --
> I get the feeling this was discussed in the past.
> 
> Also there's more:

> misc/lnstat_util.c:			unsigned long f = strtoul(ptr, &ptr, 16);

This is reading /proc/net/stat/XXX files and those files
are generated in kernel without any prefix. So this has to stay.
