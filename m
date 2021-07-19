Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 719B23CD096
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 11:23:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235807AbhGSIme (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 04:42:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234826AbhGSImd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 04:42:33 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 629FCC061574;
        Mon, 19 Jul 2021 01:24:17 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id k4so21117270wrc.8;
        Mon, 19 Jul 2021 02:23:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yCmS6jgE9qoXHPl/xCPCh3iMxVlBvKybEttdFV1hu5k=;
        b=iguNW/62fyYAcPRJemProMW3fc3p4+S3ySt3D7zyTlRVIU2QFG5G+4aNbtxMuo/thK
         gqNZlP6pYxtr+qPZ1prG55BRFr/P6vqoyWW3V5hHUAoOxjDZRVw6oirlDITQ3A9mkwWq
         81QrC5bRUv3UqrEQT3FLlTLar7t/dULCb+n0c2uAi3LLNZHZXZjv7FRbVre3dhKy9c1b
         qOpL55celNh8a+s9zGix0FFD3Iwrbh30zEXQ9oUzZe3s13YiLATO8DpHwlcQq1Bd9xay
         lsVXeYntDJ+FpjGoNX4oc/jBx2xh8U2heilSq18ZBMi41KstOxEPKvEtHSgQVd6OO+09
         AgFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yCmS6jgE9qoXHPl/xCPCh3iMxVlBvKybEttdFV1hu5k=;
        b=L6bWiwYgWW+MW3SNaBUgcCVM/ql5F/yuZXLT9I29nRTjT/B64BAWoYpdfZS40wxH0Q
         qy3JpGwyTNOh0lSSfMWoWLxCafJen9L24iN6JF7D7xeJ72+XX7PjqoW+KnqQIE2IChaL
         5W2DLK5Bf4tm7WVZUyk4lcFkctFa7CLXx0O3GPgOhTKlF8DIhSkJ2NDAHD0WzQPNFbr4
         /pYvI2e5Sne/e6l2Qq3d/gG8VLdPTrUGMOUbaux5aSpNwnnX1mkiQPEGiZF4LRD69qGL
         DiwbLEzZbnZa/NOFuG4ywRT2jVx4mjDsTUrFnhzcn8yeDyZfR0Hn03Q+KuWViys2jMDW
         HyBA==
X-Gm-Message-State: AOAM533BHo0vHi7a87OynbD9T/X7bRW1tx2yLVF0zrpMrMBDL/v+WyTp
        Hdv5YpVuB42wshyCXo6ChhshH/HDUy0=
X-Google-Smtp-Source: ABdhPJyB7xKB7wf5maC/q0O8ofmKSIa6/wz2CYe8p1LkZxdKTaLHCuoBLIABnqkaX12o5wUJnafckg==
X-Received: by 2002:a05:6402:516c:: with SMTP id d12mr32243644ede.323.1626683061824;
        Mon, 19 Jul 2021 01:24:21 -0700 (PDT)
Received: from skbuf ([82.76.66.29])
        by smtp.gmail.com with ESMTPSA id z8sm5638656ejd.94.2021.07.19.01.24.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jul 2021 01:24:21 -0700 (PDT)
Date:   Mon, 19 Jul 2021 11:24:20 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Lino Sanfilippo <LinoSanfilippo@gmx.de>
Cc:     Andrew Lunn <andrew@lunn.ch>, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] net: dsa: tag_ksz: dont let the hardware process the
 layer 4 checksum
Message-ID: <20210719082420.d7qid2hld26v6kdb@skbuf>
References: <20210714191723.31294-1-LinoSanfilippo@gmx.de>
 <20210714191723.31294-3-LinoSanfilippo@gmx.de>
 <20210714194812.stay3oqyw3ogshhj@skbuf>
 <YO9F2LhTizvr1l11@lunn.ch>
 <20210715065455.7nu7zgle2haa6wku@skbuf>
 <YPAzZXaC/En3s4ly@lunn.ch>
 <20210715143648.yutq6vceoblnhhfp@skbuf>
 <trinity-e0322d42-d4ca-43a6-96d6-cfe89112ad9e-1626682813094@3c-app-gmx-bap33>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <trinity-e0322d42-d4ca-43a6-96d6-cfe89112ad9e-1626682813094@3c-app-gmx-bap33>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 19, 2021 at 10:20:13AM +0200, Lino Sanfilippo wrote:
> Should I then resend the series with patch 1 handling the NETIF_F_SG and
> NETIF_F_FRAGLIST flags (i.e. deleting them if tailroom is needed) in
> dsa_slave_setup_tagger() as you suggested and patch 2 as it is?

Yup. The TX checksum offload flag on DSA interfaces is definitely
net-next material if we want to do it properly, so we can revisit it
there. Thanks.
