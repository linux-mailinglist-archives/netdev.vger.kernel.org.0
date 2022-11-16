Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 396B962CED1
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 00:36:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234176AbiKPXgM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 18:36:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234458AbiKPXgF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 18:36:05 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05E3669DC6;
        Wed, 16 Nov 2022 15:36:03 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id m22so928936eji.10;
        Wed, 16 Nov 2022 15:36:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=dBAFN0qJ+ZbEwO0yCQqjx0NimfGGnvHljyHV/ixfJnA=;
        b=kIdz49oGoTYa+/Mc2hh6UGMJ43QHUjvqMDQQN+7VGf/obtsLQJUdDlVXzFEBbQsWf5
         NxW13bY9ZHXyPp77M0V88Ns1mEM1X0FBY21SG+KoWZhMQgUJppIf0zFBoCTY07Cnmq9Z
         1iJRgAugpODAa6M8yK6W0YPZG1KBLOPXUhIAEG+eqMfJozAmOF8O+1vYD+hxVvUTMxvH
         DheD3af904IZoUfRne/3cTce4aVDkGnZ4h/DeOCVhUsugWUgHQh1jmNrvSSfVVEDTf9P
         isuHG0km7Ij3e4xgNxaEufUE903E5osGQlvRpBDTa5P74P4YFy5i1hF8dNJ03lHu9Ojf
         GQzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dBAFN0qJ+ZbEwO0yCQqjx0NimfGGnvHljyHV/ixfJnA=;
        b=1MAy2Z5nMY9/6RXOVyqRovPqK3TarRbcp1QwNSz4OYyzFd0Vd2hkIuH7LAnUlaGzkh
         k0wnFmIRX1QFG3b/SRsaA96wV3hxBQAi9KayLaFCj+KdH2lK0PQFunykz/o7m3V9WJKB
         e3dNlXNkf+DNLoGzS8GIsnxtzxxHus6zYvLbk3O05qgDtbSHX9pZadTxI+0d3Wof3S0K
         9Y28VWzoL4hLuFm8qifWbomrBDE2iOP6+xzi0h0l5UXYV9wWo1cJY/AwHu3xczxCBGm8
         63SGB4gUtR3QJ2EquAPBz/H7HXS8/IZtiXfmep6vOunYgMUerQhTLpjB13Srmw9MfDpa
         2JMg==
X-Gm-Message-State: ANoB5pkNgU/LKwAsvyCrNgsoG6PsQSMRE0Q6vYYZ+2S9mgVsbTkSK/Xe
        ZcxdQ7sN0nYczXMjqCOHIPE=
X-Google-Smtp-Source: AA0mqf6lH/HYOs0OP1bmDlwRon/nh842xOwetg0ql9dxo8WVClNWos2keMZ8aOWHkrtMgcweA7FHnQ==
X-Received: by 2002:a17:907:b689:b0:78c:f5a1:86bf with SMTP id vm9-20020a170907b68900b0078cf5a186bfmr96042ejc.245.1668641761567;
        Wed, 16 Nov 2022 15:36:01 -0800 (PST)
Received: from skbuf ([188.26.57.53])
        by smtp.gmail.com with ESMTPSA id u18-20020a1709061db200b0073a20469f31sm7353252ejh.41.2022.11.16.15.36.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Nov 2022 15:36:01 -0800 (PST)
Date:   Thu, 17 Nov 2022 01:35:53 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Dan Carpenter <error27@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: Re: [PATCH] net: ethernet: renesas: rswitch: Fix MAC address info
Message-ID: <20221116233553.cr7ou25wbz445kt3@skbuf>
References: <20221115235519.679115-1-yoshihiro.shimoda.uh@renesas.com>
 <Y3Vu7fOrqhHKT5hQ@x130.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y3Vu7fOrqhHKT5hQ@x130.lan>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 16, 2022 at 03:14:53PM -0800, Saeed Mahameed wrote:
> On 16 Nov 08:55, Yoshihiro Shimoda wrote:
> > Smatch detected the following warning.
> > 
> >    drivers/net/ethernet/renesas/rswitch.c:1717 rswitch_init() warn:
> >    '%pM' cannot be followed by 'n'
> > 
> > The 'n' should be '\n'.
> > 
> > Reported-by: Dan Carpenter <error27@gmail.com>
> > Suggested-by: Geert Uytterhoeven <geert+renesas@glider.be>
> > Fixes: 3590918b5d07 ("net: ethernet: renesas: Add support for "Ethernet Switch"")
> 
> I would drop the Fixes tag, this shoiuldn't go to net and -stable. and
> please tag either [PATCH net] or [PATCH net-next], this one should be
> net-next.
> 
> Thanks,
> you can add:
> Reviewed-by: Saeed Mahameed <saeed@kernel.org>

You can have a Fixes: tag on a patch sent to net-next no problem.
No need to drop it. But in the future, using git-format-patch
--subject-prefix="PATCH net" (or net-next) would be indeed advisable.
