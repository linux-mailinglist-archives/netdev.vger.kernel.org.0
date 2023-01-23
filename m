Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A44A6785CD
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 20:07:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232448AbjAWTHT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 14:07:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232338AbjAWTHR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 14:07:17 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C9F430196;
        Mon, 23 Jan 2023 11:06:52 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id tz11so33275787ejc.0;
        Mon, 23 Jan 2023 11:06:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=VzT+/AAnkcNZ8TZfovdetYrpqGaxSCI5k19hUgFzi3Y=;
        b=TNjwf8YflAqXrcr8PaPdRr4zx93XtnlZQT65pkJo0YQGBSJ1y52WHiq2IEOYVpUkli
         yp76QIPr5BSRWmdfb8k6cYOPqXz70pO7/einBq3Yv+8HVPjpg2lg2J8/Cj0LpjwuZUqX
         8E3U0av6UGKSGk5HiBSBZK/KSQhjXsm/9Nn9rJw38Wslo680mo5beenccI6Qnak2Bxbs
         dsql/nBBd8HCdXFZRAxe0aNZcbG6N52z5H9eO6my27PoHPI/XwJzDPkDqPiX29uMzU+j
         M9jpkpqpAAfhIY3Iujy5ajvgBNRf+dmdmnOT4E0EZWrUSqs2iRGZd8i43HokQZ4kh9sp
         57fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VzT+/AAnkcNZ8TZfovdetYrpqGaxSCI5k19hUgFzi3Y=;
        b=wAkDgmB1r3beNZRPEje0YOcPTCU9Wx1aF3ix9OJYMfXfMoxrnypp2Os8y8lCBcY2+4
         ipCYohmjQV5RzSc1JzwlmSGFPTv708tULF6Cq6jh9qquuigWAl6Kjovbu7txb9FpbMS7
         F920cV3xTNKWIYBATDiOklgGOeUYQ0DP31a2bA3ddzz2vD1AWfyh2pX69pCDteHKN8D7
         gmtCX3Ejdk2uBJokQi+tZMxaTROWaALnemso04Z0QPpS9nxmhNuoqo7ng0hT+yLJ2XY9
         Uv9407YOVkCxBY/xg6uYju/pZiFM47/KX6WrYbcfGBq9mq4FeNPdF6DeMbMdUCvuo3Km
         J2hA==
X-Gm-Message-State: AFqh2kp0rm5idKqa5kOU+C5DQTQ9PJ/c+QgxVH1X5rWdZHs7mNd7dPC6
        EHCURtVLCj2ptmm5SQgWDTo=
X-Google-Smtp-Source: AMrXdXv1j+KQ6JCKEI7eBFjPkPTxbdbaHeHhec7tdZZIh2iRYdZCvb1FJYylLyqEhRhPgvIX2G4o/w==
X-Received: by 2002:a17:906:514:b0:7c1:1ada:5e1e with SMTP id j20-20020a170906051400b007c11ada5e1emr26505336eja.26.1674500810545;
        Mon, 23 Jan 2023 11:06:50 -0800 (PST)
Received: from skbuf ([188.27.184.249])
        by smtp.gmail.com with ESMTPSA id dn28-20020a05640222fc00b0049148f6461dsm66537edb.65.2023.01.23.11.06.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jan 2023 11:06:50 -0800 (PST)
Date:   Mon, 23 Jan 2023 21:06:47 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, erkin.bozoglu@xeront.com
Subject: Re: [PATCH] net: dsa: mt7530: fix tristate and help description
Message-ID: <20230123190647.vcnv3wrrzljnuhzy@skbuf>
References: <20230123170853.400977-1-arinc.unal@arinc9.com>
 <6d44b799-1843-e233-39ea-ff62d2d64065@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6d44b799-1843-e233-39ea-ff62d2d64065@arinc9.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 23, 2023 at 08:15:07PM +0300, Arınç ÜNAL wrote:
> Just to make sure, the limit for a line is 80 columns for kconfig too, is
> that right? A tab character is 8 columns.

I guess so, yes.
