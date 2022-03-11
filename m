Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 554A44D644E
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 16:08:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348449AbiCKPJu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 10:09:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233951AbiCKPJt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 10:09:49 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10DE71B45FA;
        Fri, 11 Mar 2022 07:08:46 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id b8so8374941pjb.4;
        Fri, 11 Mar 2022 07:08:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=2a8WcB1kxQavj2Zya8qxv0wQWFb2RBvuEHqZVDHIJgs=;
        b=QmEdrS9XzWAA5NF5Qa/qDnI2MXBixfUb9FxuhNvljZ03i3uddZHZGN8x+rcljV0OVX
         4zPrtqqFfvwIrpIXOhUAJ81ZyKrWG9Jg+v0DMxSmdXyfdGSOceReNiy7BTEnmlZikT+C
         fSrtLTXAHbD4fa3QDw3HVEH7eBYA3bpquQDpW/RsAJ0PD+BImDY2IlFB9faNGKXgkSFQ
         X7ZVK/74zMABQm8klkldFVyqwcJKstncsrX6f//g9rTlJwiW030f9lW10gZhKxTTlf/g
         IoXW63/ltD4eExJ61U1YBtAMnVVh788Fz4X9QtrFVVRI24BdUf9LyL9TVHLGQ4nc2423
         +LwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=2a8WcB1kxQavj2Zya8qxv0wQWFb2RBvuEHqZVDHIJgs=;
        b=A66b43K3yiWC3EfOggUPyzVFQvHk9IZZGC7l6NNkP6t6QaqtY/zAiMJS/2w4AhOu4m
         ipbhv0eTdhtWLhnbLawj7b5dNuncKc4Ibx2sFupe0JfEIdHH8IPMx47pGURyJJOmNkZj
         D6kK0BXGq1FXd5ZTh9aLPOd6BN6vzzrra2YpF9nSf740mTzPN/onScFkDdLNQN3+bBg0
         CpOUbkGqiCutqw0cl9rvSgs0jM1wfPVXA9wlabLazY7Ebg71tUByJI9UE0+Gl8xVo232
         iLXAQp+CR7bN6GnPki8p9Q6ibreqbLQGgnRFDvQ6Jc4SURqf6m6+orB4oMo2eI0eyi+x
         9VdQ==
X-Gm-Message-State: AOAM531BN9GFtLBl7u7d89iQfzYBPB/plIwnr7ZJQ9gOwvdb2yihyq/+
        cjF9k97Bv+f7UIpgKbEKuiQ=
X-Google-Smtp-Source: ABdhPJxwYBOHL2eqwyqNjDc+Y0PZpxVIDu+w2GlTC32rFOcD1f5ZcrDJK748qv1Z+cgqdloUL8JD/Q==
X-Received: by 2002:a17:903:11c6:b0:151:a247:31eb with SMTP id q6-20020a17090311c600b00151a24731ebmr11005899plh.91.1647011325566;
        Fri, 11 Mar 2022 07:08:45 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id s30-20020a056a001c5e00b004f75773f3fcsm10554840pfw.119.2022.03.11.07.08.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Mar 2022 07:08:45 -0800 (PST)
Date:   Fri, 11 Mar 2022 07:08:42 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>, Divya.Koppera@microchip.com,
        netdev@vger.kernel.org, hkallweit1@gmail.com, davem@davemloft.net,
        kuba@kernel.org, robh+dt@kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, UNGLinuxDriver@microchip.com,
        Madhuri.Sripada@microchip.com, Manohar.Puri@microchip.com
Subject: Re: [PATCH net-next 2/3] dt-bindings: net: micrel: Configure latency
 values and timestamping check for LAN8814 phy
Message-ID: <20220311150842.GC7817@hoboy.vegasvil.org>
References: <CO1PR11MB4771F7C1819E033EC613E262E2099@CO1PR11MB4771.namprd11.prod.outlook.com>
 <YidgHT8CLWrmhbTW@lunn.ch>
 <20220308154345.l4mk2oab4u5ydn5r@soft-dev3-1.localhost>
 <YiecBKGhVui1Gtb/@lunn.ch>
 <20220308221404.bwhujvsdp253t4g3@soft-dev3-1.localhost>
 <YifoltDp4/Fs+9op@lunn.ch>
 <20220309132443.axyzcsc5kyb26su4@soft-dev3-1.localhost>
 <Yii/9RH67BEjNtLM@shell.armlinux.org.uk>
 <20220309195252.GB9663@hoboy.vegasvil.org>
 <20220311142814.z3h5nystnrkvbzek@soft-dev3-1.localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220311142814.z3h5nystnrkvbzek@soft-dev3-1.localhost>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 11, 2022 at 03:28:14PM +0100, Horatiu Vultur wrote:

> What about adding only some sane values in the driver like here [1].
> And the allow the user to use linuxptp to fine tune all this.

I mean, that is the point.  Users will surely have to tune it
themselves, second guessing the driver in any case.  So having hard
coded constants in the driver is useless.

Probably even the tuned values will differ by link speed, so having
the per-link speed constants in the driver doesn't help either.

(And yes, linuxptp should offer configuration variables per link
speed, monitor actual link speed, and switch automatically.  So far no
one is demanding that loudly)

Thanks,
Richard
