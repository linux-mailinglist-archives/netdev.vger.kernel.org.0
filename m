Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C590063BB84
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 09:27:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230247AbiK2I1c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 03:27:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230249AbiK2I13 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 03:27:29 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C04857B75
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 00:27:27 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id gu23so13708958ejb.10
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 00:27:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4v7Xp4UFwcIIZYZ0RgIN5pAk6f0FzEGlZBS1d7BjE8M=;
        b=tRgxpeUumhzLWsC9NVTgDCLb6XS0lv/rpMqGNhMDpPr2Rq/mAUvJvDgqyVE9rVTHr3
         PLUKB44JXwQ7XIg0oDXwmJ2BDHkmwhB4pzfCWYwM3SrWaYo8wgndawp+QpWpQviZ5Z7+
         T+q8PhrZYvCH84GnWsBe3i67Jv+D/wyYe9rBax2Wl1B80SP5M0CIIfbzBPPKG/EBm2pf
         eiEqZ+FEiD7eaqNOT/0oL2A0jJsp39JaFVijnYra2HosHEXTsYyW6Fz9IOeCc5AmZinv
         rKdJDpSTIqIETiN/h9e/7lmGL6x18E2SIG2b0qPdnsH0pML71bpStt2ATvHcno7vkt8r
         t9RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4v7Xp4UFwcIIZYZ0RgIN5pAk6f0FzEGlZBS1d7BjE8M=;
        b=Xxv46l0B6PGQW6gqbmAcT6P8b+x1UujSimDtdoJnwf0N5Itwe3DuAUcdsRZtlAAZ+e
         zBlUkIy5mON9ypR33bqYzwfkqKeLNqguWtPx9C2p8SNIr0SNThB6tv9G5+rJeUKSyjX0
         jrJsvUUAdjiYwU3vsO4VMWRj5ZGDuL8W8NOU+6PONA/jLoFIId9J5kVRuLh5eSeUssYd
         HHz5loeXUtPQ4lBLMjangIbntDUvYTXca001lCbvyOxqHS5tYc2LqiQkJd208PML59uw
         LRntxWvSf/Xr05y26Ow/4FJX5KU1f+0cO0NS0ooMypqYU6MQXzxkMO3nPE+84dL4Kh8X
         HZGg==
X-Gm-Message-State: ANoB5pm5OcsgnY35cc8ki/10pUw7iDLgLELSXo9QIY7sIiExqNBOjT2p
        fs55hXuGSrMDP7hRraYCNWHGOQ==
X-Google-Smtp-Source: AA0mqf4klzozGLk8G6ChytpzpBsUMkgVkxU4/gqOvr33nL+FktypM4IdS/dR44D+c0D+dCGAFz/q1A==
X-Received: by 2002:a17:906:5a84:b0:7ae:65e4:7204 with SMTP id l4-20020a1709065a8400b007ae65e47204mr45496813ejq.579.1669710445675;
        Tue, 29 Nov 2022 00:27:25 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id kz1-20020a17090777c100b0078de26f66b9sm5851248ejc.114.2022.11.29.00.27.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Nov 2022 00:27:25 -0800 (PST)
Date:   Tue, 29 Nov 2022 09:27:24 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc:     Jiri Pirko <jiri@nvidia.com>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        Boris Brezillon <bbrezillon@kernel.org>,
        Arnaud Ebalard <arno@natisbad.org>,
        Srujana Challa <schalla@marvell.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Dimitris Michailidis <dmichail@fungible.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Jerin Jacob <jerinj@marvell.com>,
        hariprasad <hkelam@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Simon Horman <simon.horman@corigine.com>,
        Shannon Nelson <snelson@pensando.io>, drivers@pensando.io,
        Ariel Elior <aelior@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Vadim Fedorenko <vadfed@fb.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Vadim Pasternak <vadimp@mellanox.com>,
        Shalom Toledo <shalomt@mellanox.com>,
        linux-crypto@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        linux-rdma@vger.kernel.org, oss-drivers@corigine.com,
        Jiri Pirko <jiri@mellanox.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hao Chen <chenhao288@hisilicon.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Minghao Chi <chi.minghao@zte.com.cn>,
        Shijith Thotton <sthotton@marvell.com>
Subject: Re: [PATCH net-next v5 4/4] net: devlink: clean-up empty
 devlink_ops::info_get()
Message-ID: <Y4XCbMooeWxsovHT@nanopsycho>
References: <20221129000550.3833570-1-mailhol.vincent@wanadoo.fr>
 <20221129000550.3833570-5-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221129000550.3833570-5-mailhol.vincent@wanadoo.fr>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Nov 29, 2022 at 01:05:50AM CET, mailhol.vincent@wanadoo.fr wrote:
>devlink_ops::info_get() is now optional and devlink will continue to
>report information even if that callback gets removed.
>
>Remove all the empty devlink_ops::info_get() callbacks from the
>drivers.
>
>Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
