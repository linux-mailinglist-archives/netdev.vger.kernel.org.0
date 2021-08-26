Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A1993F8A49
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 16:41:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242871AbhHZOmF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 10:42:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242842AbhHZOmE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 10:42:04 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9796C061757;
        Thu, 26 Aug 2021 07:41:16 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id dm15so4986361edb.10;
        Thu, 26 Aug 2021 07:41:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Dx/KBvt5TnIKid1SMTzNEyNIVClNkRZzICSwqrMDpUo=;
        b=MH07uWmj/1IqUsI3N/IT1DXUCTR1QqEjIRJj7Cokx/HURpplYEwSM6TJQNMzptCFG5
         SUTDCwmChaEEg4Fg4Y5LPEKUFehIO/qHZlEIMnNWuwd5s/oIY4EyVhQJ6Dz7aC3ztFzC
         XLlELz4JD+emlnInhQuMPVLCwxa3HBKRx4cxZ2tvpnpOg0akkEzcPzETLMOoQZCjGe8Y
         k0oEexrWCSigCW+ZTnjoDQhqnJnquboAkcoNgkwdc1PWoma6KCUqs0IJseLLQUUPH3TR
         bYyRHnTieLD3hi0FjO06aXpnfSWD+fsZv9/Oc1q9oBtWOikuZlSec0zxEL7fFO8WydeS
         WlBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Dx/KBvt5TnIKid1SMTzNEyNIVClNkRZzICSwqrMDpUo=;
        b=URVIUF6SUe18kMq1XKR3Pw1davc4Tws9M2i25IxjTOk/ddMDm3jA231+MwbxDjNWnf
         ARy6WtpCWLC58Pljw8c7asO8TozdOJEnGmvY0HqCI+K2+OEcXSykniBrEH7YN5JXkX/9
         H8t4ce1VF7nQikjJnyWWtQitRNkw/6w8c6LtTffpkyPR/OwfiApgfuKEUf01wk2rfKBl
         NvhB2UplrpWh9T4IMeY6LK9UlrZppDSnKF2csX84dFVbpVNbnqD3kk8ZiRwm2Lsxfhp/
         1TjBh3uTF4eSAgd+etQEnKPoKUPkPoxTG/l+HNPEoCL9olI51N1K2uzRX8Qjr4h42obp
         5ClA==
X-Gm-Message-State: AOAM5329ttwnow+wcDt9bCDFIvdYk7Qc596dNd5st46rHLy4nwfBbx6o
        3yyHgx6Du3wzI1c6NOOi2jg=
X-Google-Smtp-Source: ABdhPJwqiKrS6jLSgcwJKwH0MaxgM3V3aG15lA2CozGjK8WiB2gSm7+P0w406N4AFnjsh7H7XO9ytg==
X-Received: by 2002:a50:a452:: with SMTP id v18mr4619763edb.17.1629988875426;
        Thu, 26 Aug 2021 07:41:15 -0700 (PDT)
Received: from skbuf ([82.78.148.104])
        by smtp.gmail.com with ESMTPSA id f30sm1512279ejl.78.2021.08.26.07.41.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Aug 2021 07:41:14 -0700 (PDT)
Date:   Thu, 26 Aug 2021 17:41:10 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Alexandra Winter <wintera@linux.ibm.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
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
Subject: Re: [PATCH v3 net-next 0/7] Make SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE
 blocking
Message-ID: <20210826144110.wyq5iqlcqn45tsa7@skbuf>
References: <20210820115746.3701811-1-vladimir.oltean@nxp.com>
 <1ebabba2-cb37-1f37-7d9e-4e7b3fee6c1e@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1ebabba2-cb37-1f37-7d9e-4e7b3fee6c1e@linux.ibm.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexandra,

On Thu, Aug 26, 2021 at 04:35:58PM +0200, Alexandra Winter wrote:
> For drivers/s390/net/qeth_l2_main.c :
> 
> Reviewed-and-tested-by: Alexandra Winter <wintera@linux.ibm.com>
> 
> Thank you for this proposal, it makes qeth switchdev code more robust, cleaner and gives the
> opportunity for future enhancements, like you proposed.

Thanks for reviewing and testing, and sorry that I did not copy you on
v2 too, only on v3. The discussion on v2 had not yet completed when I
posted the v3, and unless anybody has any better idea, a v4 is not going
to take place:

https://patchwork.kernel.org/project/netdevbpf/cover/20210819160723.2186424-1-vladimir.oltean@nxp.com/
