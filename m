Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64F7D598A22
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 19:20:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345211AbiHRRR2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 13:17:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345166AbiHRRRH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 13:17:07 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2B1B40548;
        Thu, 18 Aug 2022 10:12:59 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id k26so4425094ejx.5;
        Thu, 18 Aug 2022 10:12:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=/P54HZJG0g2+0M/3+i69f/ETWe6T0m+MxuS/j3Yd2Fw=;
        b=qHrqMdTTPBSFd5grPtKQqzrJEwzV1psr8ZtUlzfjuEoKhWHuo531pkkk46vxEefSMy
         TbZv5+5lBsoeU9YAXGuD5e0WcJl200oQ+EpDltbUWlgh5zx0kRSQqzr3vBsVNoxUIV1h
         Qr9hcBu9zDFMPJEw+AuD/tFPfYyKb4ZYlX+ZR4u+umTWhV3Ob6PjcPYPfSx7ZlSYRqbD
         047WZoz+oDGrtgvi4rA8HOHfX6CMksU5o+L+SGJ4x44BjKXpekY3aqjoD/S56OtuOM6I
         ZnBaXJZyXtqKe8gnv+MRDvB546+H1q9F17CQsaKRZDonuZKoBwjifoctftAaAVNRxOs+
         Yr3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=/P54HZJG0g2+0M/3+i69f/ETWe6T0m+MxuS/j3Yd2Fw=;
        b=guIf311t0MMm6x2CC6xfMgE+Mtd7BB9EdOnJTRjEMJC0a1f4p+PO/Lc2o8ZislQwhu
         vJ/emx75q6w508CK4ADe1841GEtCgkxPlagKsFtt3P8JI0IQhulXHBgJDZtDIcqGG/fA
         iTfZB0kcE4oRRKcq5JbdZSkAgsXfjwaCxTyFa9hvSdkMR49MOp51XptQKU4GUwi7zuDF
         d5PPkhUWkeM5i0+iaalRVXJPUtgzkKdMWP9eCqj2fyIpaXXq7sNq9n/gCwqQznWn2/t5
         3qkOJThYzwCpGefzmr2CBpUzQEZRaWLL6AoyDNDfx0jG3q2YYvKi9fjJq1bpGvpiB+h9
         Gp8w==
X-Gm-Message-State: ACgBeo2v4jq26H53h3E8SsjkAm3Irv6vRg/cwQzjvAqTqU4z+iH7Wy07
        rfYrMHyjF1hivspQKaqEeh4=
X-Google-Smtp-Source: AA6agR7xkGY5TDCWsyFKiJs0W4lz2WLrKbBd4RrKabEXPXcEGegRIT5DuFSd2TYhmokm4nSZjjfXnA==
X-Received: by 2002:a17:906:5a6a:b0:730:bc8a:57dd with SMTP id my42-20020a1709065a6a00b00730bc8a57ddmr2393103ejc.301.1660842778425;
        Thu, 18 Aug 2022 10:12:58 -0700 (PDT)
Received: from skbuf ([188.25.231.137])
        by smtp.gmail.com with ESMTPSA id d10-20020a50c88a000000b00445df5738dfsm1451340edh.73.2022.08.18.10.12.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 10:12:57 -0700 (PDT)
Date:   Thu, 18 Aug 2022 20:12:55 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 02/11] net: phy: Add 1000BASE-KX interface mode
Message-ID: <20220818171255.ntfdxasulitkzinx@skbuf>
References: <20220725153730.2604096-1-sean.anderson@seco.com>
 <20220725153730.2604096-3-sean.anderson@seco.com>
 <20220818165303.zzp57kd7wfjyytza@skbuf>
 <8a7ee3c9-3bf9-cfd1-67ab-bb11c1a0c82a@seco.com>
 <35779736-8787-f4cb-4160-4ff35946666d@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <35779736-8787-f4cb-4160-4ff35946666d@seco.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 18, 2022 at 01:03:54PM -0400, Sean Anderson wrote:
> Well, I suppose the real reason is that this will cause a merge conflict
> (or lack of one), since this series introduces phylink_interface_max_speed
> in patch 7, which is supposed to contain all the phy modes. So depending on
> what gets merged first, the other series will have to be modified and resent.
> 
> To be honest, I had expected that trivial patches like that would have been
> applied and merged already.

There's nothing trivial about this patch. 1000Base-KX is not a phy-mode
in exactly the same way that 1000Base-T isn't, either. If you want to
bring PHY_INTERFACE_MODE_10GKR as a "yes, but" counterexample, it was
later clarified that 10gbase-r was what was actually meant in that case,
and we keep 10gbase-kr as phy-mode only for compatibility with some
device trees.

I'd suggest resolving the merge conflict without 1000Base-KX and
splitting off a separate discussion about this topic. Otherwise it will
unnecessarily detract from PAUSE-based rate adaptation.
