Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B615A62160C
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 15:22:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233737AbiKHOWR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 09:22:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235429AbiKHOWB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 09:22:01 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CC5B54B3A
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 06:21:49 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id ft34so2669401ejc.12
        for <netdev@vger.kernel.org>; Tue, 08 Nov 2022 06:21:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CQJVvugu8oLvsWyJLc1Y3oVePQ9NOwghfaFJZvViXwA=;
        b=B/hN92IL+8Hab/e0WxYLv1wpgyxOtmrQRt5kHiaCdrUnzIcpjcqYotzXQU0Q8oBofu
         +5AzPAY317S1p3806QcDHJlh4e8PqS/a7p2lohbxNyYTFgJ+FspcnFycE3ng/Pdb9JdY
         mc7W3VGG3m0Jx1aPSedDDJiBv7Ce6Af4MR9yKG/HNu5qq5tZ8WpG+Exxpd7l3Pg/tJ0W
         hgnaLc3ayzfSJZObw2fk1TcWv03DbZUMFDJjdL1FEUU+6NSq9n4+9NivRqMehYnCNACz
         ijYqmtQ1Niet+GBQ3P5ahmoWynK6xaXehrK9jKB8uhrx0Y5gtmmlsFfCeYkNmNaVOc/3
         3s5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CQJVvugu8oLvsWyJLc1Y3oVePQ9NOwghfaFJZvViXwA=;
        b=7bDq8mF23AQaKuaaREMB7r/QHNSonDvTOanTUe4G4N1RihPCfo1CYv9KwUGRwOUj7O
         4q2RPEOcyiV/0iyDmkrb2H7SBNE+pw9SnI1Fw45ShBirtA6BKgxF/nhMimUWDCbw6LHn
         WdogSQJcgUNwg6+uhbtsXwdlHSXUtP2K1vOHQYcbNSogYiQMWEN5bKtJI2kAbBT4ix8c
         wxP8RF5GvYfcrA+cb/4Ma7CK8BfIhrJUn5lpoQUCdwGUo/qVlDlUBNc3AG1GhbkF+1pO
         QpYV5jGrgQJihn/snFEhSvkMbOsfl7ocUmFnAh/FXKaAFYUgzlrEOg0zTm5zG0eGIVTO
         ogvA==
X-Gm-Message-State: ACrzQf3xcaFsbYXBGxaKqndv0fTWe3/HD74mOfaI245O+JToLORKiOTL
        1Ef2ZyYpGigfkAXss6inlS0=
X-Google-Smtp-Source: AMsMyM6UZ8Ic3EDXugsTQiZBl1mx1uptKhN1E0pp1A4iLZ9CqVJh9a3ARonhxRi9HfCSYnkgmFIEKQ==
X-Received: by 2002:a17:906:f8b:b0:7ad:a030:4915 with SMTP id q11-20020a1709060f8b00b007ada0304915mr990728ejj.267.1667917307420;
        Tue, 08 Nov 2022 06:21:47 -0800 (PST)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id q3-20020aa7cc03000000b00461aebb2fe2sm5582510edt.54.2022.11.08.06.21.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 06:21:47 -0800 (PST)
Date:   Tue, 8 Nov 2022 16:21:44 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Petr Machata <petrm@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Ivan Vecera <ivecera@redhat.com>, netdev@vger.kernel.org,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Roopa Prabhu <roopa@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        bridge@lists.linux-foundation.org,
        Ido Schimmel <idosch@nvidia.com>,
        "Hans J . Schultz" <netdev@kapio-technology.com>, mlxsw@nvidia.com
Subject: Re: [PATCH net-next 02/15] bridge: switchdev: Allow device drivers
 to install locked FDB entries
Message-ID: <20221108142144.g7wa22k4udaqofmw@skbuf>
References: <cover.1667902754.git.petrm@nvidia.com>
 <cover.1667902754.git.petrm@nvidia.com>
 <68167a3ebca74bb7cd45da0ff7c1268a70c33a96.1667902754.git.petrm@nvidia.com>
 <68167a3ebca74bb7cd45da0ff7c1268a70c33a96.1667902754.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <68167a3ebca74bb7cd45da0ff7c1268a70c33a96.1667902754.git.petrm@nvidia.com>
 <68167a3ebca74bb7cd45da0ff7c1268a70c33a96.1667902754.git.petrm@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 08, 2022 at 11:47:08AM +0100, Petr Machata wrote:
> From: Hans J. Schultz <netdev@kapio-technology.com>
> 
> When the bridge is offloaded to hardware, FDB entries are learned and
> aged-out by the hardware. Some device drivers synchronize the hardware
> and software FDBs by generating switchdev events towards the bridge.
> 
> When a port is locked, the hardware must not learn autonomously, as
> otherwise any host will blindly gain authorization. Instead, the
> hardware should generate events regarding hosts that are trying to gain
> authorization and their MAC addresses should be notified by the device
> driver as locked FDB entries towards the bridge driver.
> 
> Allow device drivers to notify the bridge driver about such entries by
> extending the 'switchdev_notifier_fdb_info' structure with the 'locked'
> bit. The bit can only be set by device drivers and not by the bridge
> driver.
> 
> Prevent a locked entry from being installed if MAB is not enabled on the
> bridge port.
> 
> If an entry already exists in the bridge driver, reject the locked entry
> if the current entry does not have the "locked" flag set or if it points
> to a different port. The same semantics are implemented in the software
> data path.
> 
> Signed-off-by: Hans J. Schultz <netdev@kapio-technology.com>
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> Reviewed-by: Petr Machata <petrm@nvidia.com>
> Signed-off-by: Petr Machata <petrm@nvidia.com>
> ---
> 
> Notes:
>     v1:
>     * Adjust commit message.
>     * Add a check in br_switchdev_fdb_notify().
>     * Use 'false' instead of '0' in br_switchdev_fdb_populate().

Thanks for making the changes.

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>

(imagine this was my NXP email address, I'm not subscribed to netdev @work)
