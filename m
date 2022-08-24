Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEF9F59F1E4
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 05:16:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231311AbiHXDQZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 23:16:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbiHXDQX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 23:16:23 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8D8080B6B;
        Tue, 23 Aug 2022 20:16:18 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id bh13so13896374pgb.4;
        Tue, 23 Aug 2022 20:16:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=BJUD5l2aVXUXib/aChyV5FqXEQxLOvsk3GBEuWTN+qo=;
        b=SS8PCzr9mCGT6hDCL3MTyOO09cwwZ25pr+45+0P5oELIAY02hfoTdZqmQJcwaoshCV
         9gVdVLTNUyi+Z9PbxSjlLt4W+u3AHp4fUtauvng8SmR5ycmCJ4gpU5aas+n1httTbxVi
         NwHIBlQR0B9clXCc5ehT2BgmVVtFkWU5h9FspXRlz7Kw6MwnWZ0snuUXGHOdB7Xo0+Eu
         HczAJWrkdYv127ZkZAs9douHAUB1YiERR4ehcjx09pU3uP6KoMKgz0ijR+bf2lfRJgHC
         jNvJgwjfd1o+efo5NnzG8V1ZLUDCHPTjz65ZZ9elsPC75X7X+u2Eeus9feEC/bgTxNwM
         HVEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=BJUD5l2aVXUXib/aChyV5FqXEQxLOvsk3GBEuWTN+qo=;
        b=bDJnzk16c6tI7KNVakep9GzA+T3HhbZIOEHx+yqkBd3QuuGM7pxZ70ndneu02L2pak
         Gka56JMyDSJHWo41EBjEsG6fueWuu400IbR14iJHu/RkkVs3AyXA/xLgYjf51LVzi3+Z
         pYAMpb/fNs0hujCO//LHz8OSepcxvHSO4Btzg2p+Xosy4eiutXN9j7gFZ5TCLJjVU9tj
         g2fHKMq57GEgiDNV/W0x0GKAbEuf266Skmxm6zRrlOqgMMeG6O/zDxFAwf19UnoMTl+7
         iw6m0YEUzQuyi7d4STRB1Y7F/7ttI2hgMZ3aAAYaya+XaXDdYRFK0+xnywgnojAplGlE
         kZGA==
X-Gm-Message-State: ACgBeo3zicjYjB5oc3AHMoetKL15Is1JMlQIZ40/DLQEUUxtm92tYRWF
        808HCPxCQ7uqJj/Zn2GCDCqKPBJ4hK0gXi+ZyiQ=
X-Google-Smtp-Source: AA6agR5BmWr4dxeHYbzgF2r3IA5gsuQZCKR7lsQJSY1hZoTXqAIMjDKu2wyQPrlA1TP6jOnZTtK7RPZIAi3vn39Rsbw=
X-Received: by 2002:a63:1c11:0:b0:41d:89d5:8ef0 with SMTP id
 c17-20020a631c11000000b0041d89d58ef0mr22995080pgc.403.1661310978261; Tue, 23
 Aug 2022 20:16:18 -0700 (PDT)
MIME-Version: 1.0
References: <20220819092607.2628716-1-dqfext@gmail.com> <20220823152625.7d0cbaae@kernel.org>
In-Reply-To: <20220823152625.7d0cbaae@kernel.org>
From:   DENG Qingfang <dqfext@gmail.com>
Date:   Wed, 24 Aug 2022 11:16:06 +0800
Message-ID: <CALW65jaMSYOFP0njSCBn+T0TZeKjeWp+GWWWKzE2HH0OOO+FxQ@mail.gmail.com>
Subject: Re: [PATCH net] net: phylink: allow RGMII/RTBI in-band status
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Russell King <linux@armlinux.org.uk>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 24, 2022 at 6:26 AM Jakub Kicinski <kuba@kernel.org> wrote:
> Qingfang is there a platform which require RGMII to be supported
> in upstream LTS branches? If there isn't you should re-target
> the patch at net-next and drop the Fixes tag. Not implementing
> the entire spec is not considered a bug. Please clarify this
> in the commit message.

I'll send a v2 to re-target net-next. Thanks.
