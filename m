Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DEB46A5999
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 13:59:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231393AbjB1M7d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 07:59:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbjB1M7c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 07:59:32 -0500
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9965166CB
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 04:59:31 -0800 (PST)
Received: by mail-qt1-x836.google.com with SMTP id s12so10166194qtq.11
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 04:59:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3Mvp5a5ow275qoj/bal5XzG6ACLZVXMLG5OcYtj+gP0=;
        b=jaEdNPptrsNiY18ZpELtTn5GAhGJyf2gshKEmPhgJvjGJIuwDMROdBw+sx0+wo9wck
         DndtEHZNPL4ZGyGp3hnhqxA76nvrO+Fp8aums/kZ/uQyWDFGEe9l+vZty0X060ASDxpA
         wqfMYsH42jz461PqPQAWHV27tpwq53oOxgmsPVuLHM3mEDKDQdOYdq6lq2RMLB5UxTVW
         5mt1PW9HcQ/wnYk+3LOLvXlprswyGFq2FWWrhA/TY3NnRYdKwn0g4XeutnkRhM6XgBTb
         pAP/dCjvkfk6nd3433PyJowFHVOHXiHIeRoxXOMYs60+8xpWIpXlUjMSBsDmaiTQl1p1
         oJyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3Mvp5a5ow275qoj/bal5XzG6ACLZVXMLG5OcYtj+gP0=;
        b=UAA2Eq7FvXgm2PE6m2X6CdWqyoBW3qFS8OyJdXi5GMli0hPVWWDYHAK/BexEAIAu9Y
         XaGf9GPz2EhjVrnArrTgYOZN01KQC2TTjoFoE0MUI+s+APcreBmqcURupAxslnw/0XKL
         72SE5hcsVE3pmGQFwlTagHzrvq4mNl2ia035Kk7Z8P7sK+oTnP90ET7wFMKvLTf6T3lk
         oburgU+naAKw8lfttEXMUOoD4AiFraueHbggyBpSVL4ieXP9g1MWfwWz9a0lAV57gyJJ
         SosfwqyO0MDfU0u1bzPRb9997ezM/ZAyw5jUDLOZmpyR9WpvE4A4H2FEmPZY+Fl9e2jE
         zckg==
X-Gm-Message-State: AO0yUKVPFHmENje0VVRwJNvceaD7V3GWpYYBarDvQK7Ij4fUEbfuOK7b
        4bEYpLbPu4lNxEfRav3Og1g=
X-Google-Smtp-Source: AK7set+2T9EEk0fUya7cONVG+TnsDXO8xG9kD4UnMOxoow0EOD+hr9ZQAGQFqx2eMwXzhQzFQ5bZTw==
X-Received: by 2002:ac8:5f08:0:b0:3bf:a5fb:6d6e with SMTP id x8-20020ac85f08000000b003bfa5fb6d6emr3994074qta.29.1677589170918;
        Tue, 28 Feb 2023 04:59:30 -0800 (PST)
Received: from vps.qemfd.net (vps.qemfd.net. [173.230.130.29])
        by smtp.gmail.com with ESMTPSA id x30-20020ac84d5e000000b003bfb62a377fsm6471376qtv.3.2023.02.28.04.59.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Feb 2023 04:59:30 -0800 (PST)
Received: from schwarzgerat.orthanc (schwarzgerat.danknet [192.168.128.2])
        by vps.qemfd.net (Postfix) with ESMTP id 255502B5DE;
        Tue, 28 Feb 2023 07:59:30 -0500 (EST)
Received: by schwarzgerat.orthanc (Postfix, from userid 1000)
        id 0D5AC60025E; Tue, 28 Feb 2023 07:59:30 -0500 (EST)
Date:   Tue, 28 Feb 2023 07:59:30 -0500
From:   nick black <dankamongmen@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jeffrey Ji <jeffreyji@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Subject: Re: [PATCH] [net] add rx_otherhost_dropped sysfs entry
Message-ID: <Y/36sjlV6dWonLhC@schwarzgerat.orthanc>
References: <Y/p5sDErhHtzW03E@schwarzgerat.orthanc>
 <20230227102339.08ddf3fb@kernel.org>
 <Y/z2olg1C4jKD5m9@schwarzgerat.orthanc>
 <20230227104054.4a571060@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230227104054.4a571060@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski left as an exercise for the reader:
> How about a banner before rx_otherhost_dropped? Maybe:
> 
> 	/* end of old stats -- new stats via rtnetlink only */

sounds good to me; I'll also annotate the sysfs documentation to
emphasize that netlink is recommended, and that new stats will
not be reflected there. from the perspective of an outsider like
myself, it just looks like this stat was missed.

i'll have a new patch for you shortly. thank you for your review!

-- 
nick black -=- https://www.nick-black.com
to make an apple pie from scratch,
you need first invent a universe.
