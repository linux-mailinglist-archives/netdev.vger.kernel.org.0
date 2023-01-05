Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FC4965F388
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 19:12:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235420AbjAESMC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 13:12:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234720AbjAESL7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 13:11:59 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 871A8DFA8;
        Thu,  5 Jan 2023 10:11:56 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id r26so48683691edc.5;
        Thu, 05 Jan 2023 10:11:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VaqEalELRRS60fT0pWhc7k/aSgD8gHCORo9MWkR6xC0=;
        b=odUMUe6smwZCC13YCKCjGqjOp1KIz1/cqilutwBSkQOALe70TzZGxqpkzVGElKS2Q9
         YihNj9xNJFGMnDJUlFCrCsGayDCbvgUFAfgAXRuApzdgpkhrugKjW4Ee2liVaIO8L9o4
         aAvVAEWsIW7r+c3jxRwu6VJLJtLLSw12c4C2+BbQ0pu/9wmKqDz4lAo9buflzDlYoIW/
         cUDkJ2T+89wUaj9C+DwgHbgTUXB2oJDi+Lkevh3495WDivLOqH80BeQMR829KL/WkdP1
         6cqK/z1iw0ApvatIB0P13CNoOffoJ6jADJmg/icrzO6pZXHSntH7GGEQSEJYvbLcbj2J
         MrSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VaqEalELRRS60fT0pWhc7k/aSgD8gHCORo9MWkR6xC0=;
        b=A2ClHnh2PtzOMeIspj50gyQDHuzOzHXEfsJ3N6QrU8u0cQvJrOz9kZPkKI9GnrvaYJ
         VhDeiA9ZgP7/gr7pGHm+5iS7ZLRJZPh/nF2pRiM0S2nl4hcTweyDB1oNaqcmKb20k/PY
         3wwRUUoUV7Um0az8gwgf23iM3+rmTf/BCxC7rIX0BQI1ARUtsr/aJJBN9bPn4oacSP6j
         oYWEhr1GQFhYZLxuueO5Epn6neizKg/ugYJEVr7Ln+9aSud7vaRwuaGk0/wEr8cuvSA4
         XTtIiFFRJanVq4way42reaAamcGW7vWSv6iuJu0BiOZ6joWjeouyNEz4hz5UCJk2fItS
         UJDg==
X-Gm-Message-State: AFqh2kq0KEGsaHTHwKujXL9qnXFnFX6byk0zaPygPZFGUkZZf7hT3vVt
        hGxeHNzzYYxcZTpWsr5qDd8=
X-Google-Smtp-Source: AMrXdXtxAtNMZ5WBGXyAkwAAzZjuHx/oadPiev8Al70mmJrPZy95W+uDp+vj+iQxOfZznWc2oBeP+w==
X-Received: by 2002:a05:6402:d5c:b0:46b:444b:ec40 with SMTP id ec28-20020a0564020d5c00b0046b444bec40mr42447438edb.15.1672942315139;
        Thu, 05 Jan 2023 10:11:55 -0800 (PST)
Received: from skbuf ([188.26.184.223])
        by smtp.gmail.com with ESMTPSA id p15-20020a056402500f00b0047eeaae9558sm16074218eda.60.2023.01.05.10.11.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jan 2023 10:11:54 -0800 (PST)
Date:   Thu, 5 Jan 2023 20:11:52 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Tim Harvey <tharvey@gateworks.com>
Subject: Re: [PATCH net-next v5 4/4] phy: aquantia: Determine rate adaptation
 support from registers
Message-ID: <20230105181152.ruzdv3iusvan4mek@skbuf>
References: <20230103220511.3378316-1-sean.anderson@seco.com>
 <20230103220511.3378316-5-sean.anderson@seco.com>
 <20230105140421.bqd2aed6du5mtxn4@skbuf>
 <6ffe6719-648c-36aa-74be-467c8db40531@seco.com>
 <20230105173445.72rvdt4etvteageq@skbuf>
 <3919acb9-04bb-0ca0-07b9-45e96c4dad10@seco.com>
 <20230105175206.h3nmvccnzml2xa5d@skbuf>
 <20230105175542.ozqn67o3qmadnaph@skbuf>
 <39660d10-69b9-fa52-5a49-67d5f7e1acaf@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <39660d10-69b9-fa52-5a49-67d5f7e1acaf@seco.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 05, 2023 at 01:03:49PM -0500, Sean Anderson wrote:
> IMO if we really want to support this, the easier way would be to teach
> the phy driver how to change the rate adaptation mode. That way we could
> always advertise rate adaptation, but if someone came along and
> requested 10HD we could reconfigure the phy to support it. However, this
> was deemed too risky in the discussion for v1, since we don't really
> know how the firmware interacts with the registers.

I think I would prefer not exporting anything rate adaptation related to
user space, at least until things clean up a little and we're confident
that we don't need to radically change how it works.
