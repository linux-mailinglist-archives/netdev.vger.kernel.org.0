Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF1263F306B
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 17:57:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241429AbhHTP6c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 11:58:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241279AbhHTP6b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Aug 2021 11:58:31 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9F02C061575;
        Fri, 20 Aug 2021 08:57:53 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id s3so2406239edd.11;
        Fri, 20 Aug 2021 08:57:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=EM1YUi8ocQKYlM2aEz0kJgbWH1K9EUbVtCUWQ0eQNV8=;
        b=CiZdrmrVRYr2r7seS0OlIGdyZ90E6GSA+fjrBrcXR76Ggp6lyZLcoSvLGTxbkqNSqF
         cC45er+2UeRtOlOKrZDZ23ZEdWjHPET6GcXpV/zhjxA0JtM/4iD10/ItQ+cK9YtVtzfQ
         zeGCn5cb1wPUq518cUnz394zDjL1tpAI0pnbbCMsA1OB1dToLfNQDLhesQvfP257E0L5
         2et/Lo5Gh5CIifpdPKvNrTIKV6CI0BJQU2sG1iITWAJ47qUEHGg98jnH5ArlwzyWnjro
         G4+lG8ccS1K2FqfDEBcQSMfOqzjWYfFJ7XHnkPGKZjy2g4QhkBs3l5hugwyxn3oU0Ad5
         l2/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=EM1YUi8ocQKYlM2aEz0kJgbWH1K9EUbVtCUWQ0eQNV8=;
        b=q9wEaWEhC9WmEsAMXiDIdPMGbMZThz7u7vtOjKHjzMV2EMiBacxlwQMogJ0xXVPji5
         aPiIQSnHEG/FOpccXh8SehYl0cKW73T16OwNgkNDjnkBpM11YLT3qjfplB1IgA6q7Yvc
         CRKlWSOHb0jFGkCtT29+5axpgIsJCrZMR4IqVdl9Dv0jLb4yz60YzM1NsIU+lXiGhtnI
         6TOzABTdJs785ZZ6Gncct4xT1EPJLExWj3oVRH1E5ncIHqDM7pIuLECfhsJ76MgCdiQI
         xCx5kg5S4sCeiCXiV0eht4toWXa7/H566emJoGjYYdHamfFF2sOPZU6G5wKliXt1u2gu
         8+Ug==
X-Gm-Message-State: AOAM531KADg+iAegwuG5lyavPJCMgkMK17OefRI5U7Uebu6kZ+udxDT1
        d+TFLBhd/CChRGoXgjh7Hqs=
X-Google-Smtp-Source: ABdhPJzUpx/r9rsNlUijtCYF3Y9m9WiPra2IrMX04IGZZVxP01oWxiwZNmOfClI2Op+EX2KbgIf/Bw==
X-Received: by 2002:a05:6402:3128:: with SMTP id dd8mr23282165edb.40.1629475072358;
        Fri, 20 Aug 2021 08:57:52 -0700 (PDT)
Received: from skbuf ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id d22sm3114449ejj.47.2021.08.20.08.57.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Aug 2021 08:57:52 -0700 (PDT)
Date:   Fri, 20 Aug 2021 18:57:49 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        UNGLinuxDriver@microchip.com,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Marek Behun <kabel@blackhole.sk>,
        DENG Qingfang <dqfext@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Jianbo Liu <jianbol@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH v3 net-next 3/7] net: switchdev: move
 SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE to the blocking notifier chain
Message-ID: <20210820155749.ufb6wxgb7ujmihql@skbuf>
References: <20210820115746.3701811-1-vladimir.oltean@nxp.com>
 <20210820115746.3701811-4-vladimir.oltean@nxp.com>
 <20210820085402.3dfbd2a9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210820085402.3dfbd2a9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 20, 2021 at 08:54:02AM -0700, Jakub Kicinski wrote:
> On Fri, 20 Aug 2021 14:57:42 +0300 Vladimir Oltean wrote:
> > Currently, br_switchdev_fdb_notify() uses call_switchdev_notifiers (and
> > br_fdb_replay() open-codes the same thing). This means that drivers
> > handle the SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE events on the atomic
> > switchdev notifier block.
> 
> drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c: In function ‘sparx5_switchdev_fdb_event’:
> drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c:453:1: warning: label ‘err_addr_alloc’ defined but not used [-Wunused-label]
>   453 | err_addr_alloc:
>       | ^~~~~~~~~~~~~~

Yeah, I noticed (too late sadly). Other than a bit of dead code it does
not impact functionality, so that's why I didn't jump to resend until I
got some feedback first (thanks Vlad). Do you think it's time to resend?
