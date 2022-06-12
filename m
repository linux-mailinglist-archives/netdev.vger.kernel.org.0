Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E431547A7A
	for <lists+netdev@lfdr.de>; Sun, 12 Jun 2022 16:21:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234169AbiFLOUv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jun 2022 10:20:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229800AbiFLOUt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jun 2022 10:20:49 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3CE818B07;
        Sun, 12 Jun 2022 07:20:48 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id 25so4179606edw.8;
        Sun, 12 Jun 2022 07:20:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=YpvWWtIrN1JqPR+ErG0VpGkwET8BJiSLY7OtI30g6vo=;
        b=RX8GVFrcy1qG0ampRBrJgsM1HzTxM96j5S+GQdCc3DppW2+m/AslAGlcbisOFdE09o
         jdscWeaaKOaTNDq1LYM832PPqgkX3ra9KNw08eXRH5tc+mSYkw/2Y5mXCcwmHZ5iUn8i
         M2U0++eTPuC6TAJsSA7uKbKowaTVri2EnL/dQgyold6quP3zdlneYKdmMzWgFW+B5BPy
         849POP/9MC3/VqeR5UtQ1vEmqy28I6K/HIbmGNq3hMHRhTTkJLkB4BkTGkNrnSgWFHwi
         XR7ahinYme7MjIXMNvXTy2viWaWrqEwYO5yepGjwug3iSdvo0W/mUI+cJ8WR2GCyVn7i
         Gq1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YpvWWtIrN1JqPR+ErG0VpGkwET8BJiSLY7OtI30g6vo=;
        b=HLjfBAzmVtPkZd02O7f5qZ+ObhInKMbIgb1LNSHQPGmgQw9rQCkQf+Hgd+JGUFu/wL
         Tqqy10avjl08sx8JqHAteKXwgZTcqJUCQNrJztFl0D+eCwFWWFHd26qAXlFMy4jjGZI8
         ngqiprbR4UlNmt1aSdEjfW4ljzRnAHPOkfdsI4P5xKryySVou29gcjKpYJwkdgVU8TPF
         MVKgJbyWUXyMZMVSpodj/a/StXMXHFulN3IAQY1ZaeqqOuqly4E0R/2bmhCMrBzUBiCr
         P6ZYLz1kUwVbStEbLUbWovetPBOFgK/imXUMQQfplwKr0vbHE751UCX4MlbAvPSziFk5
         V3eA==
X-Gm-Message-State: AOAM533tZxUk1K8Lj1c+1tUBSv3K/GsaTURgu5lG3ld6gcexrYq1Nvom
        D4LXT3ck7UgK04BqtylRizE=
X-Google-Smtp-Source: ABdhPJxLP8WZe7gGgBmVK2NeO5bcQ2Z3pDV6uruVuvuxYt3MU2SbOwcna41ULOeAjXDflB3tyOihdg==
X-Received: by 2002:a50:ff04:0:b0:431:6a31:f19e with SMTP id a4-20020a50ff04000000b004316a31f19emr14163539edu.89.1655043647225;
        Sun, 12 Jun 2022 07:20:47 -0700 (PDT)
Received: from skbuf ([188.25.255.186])
        by smtp.gmail.com with ESMTPSA id hh14-20020a170906a94e00b00703e09dd2easm2534271ejb.147.2022.06.12.07.20.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jun 2022 07:20:46 -0700 (PDT)
Date:   Sun, 12 Jun 2022 17:20:44 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [RFC Patch net-next v2 01/15] net: dsa: microchip: ksz9477:
 cleanup the ksz9477_switch_detect
Message-ID: <20220612142044.qgupbnn6u5p4seef@skbuf>
References: <20220530104257.21485-1-arun.ramadoss@microchip.com>
 <20220530104257.21485-2-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220530104257.21485-2-arun.ramadoss@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 30, 2022 at 04:12:43PM +0530, Arun Ramadoss wrote:
> The ksz9477_switch_detect performs the detecting the chip id from the
> location 0x00 and also check gigabit compatibility check & number of
> ports based on the register global_options0. To prepare the common ksz
> switch detect function, routine other than chip id read is moved to
> ksz9477_switch_init.
> 
> Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
