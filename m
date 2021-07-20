Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC3AA3CF6A4
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 11:11:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235056AbhGTI3o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 04:29:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235499AbhGTI2j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Jul 2021 04:28:39 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 907D6C061766
        for <netdev@vger.kernel.org>; Tue, 20 Jul 2021 01:45:24 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id k27so27506300edk.9
        for <netdev@vger.kernel.org>; Tue, 20 Jul 2021 01:45:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1pTMpOorH4LXisVDsXChy+V+9uhVQ+gNlcIaEeOCwgw=;
        b=PN0n7YiIgzdEzWTu+Hn+Zg1BVFbf8oa8DRCmTAwLnsS/hNSCj7BW9S5xB97H2O0AMc
         cZv2dH7j3sdKeolAH9wQUkAtIthofsXJVmyKUQer3a4tRlxQ7Mv06d1DRsNWX4PlOT5j
         gj6elyDDBkh0ongrV/OMYJFxmY/riLEenq1ukRLXN36IUCt6Edbuvu02k3Wz1zDII8kJ
         ROiEBPoddxtJ+LTak9vMOz5fJAFwgPalbrUZ1hRk2eEE7VA+aFOVWWyE9lkH8SjcmZp5
         depv9ZvyeSQYnkFCZZX7ugVebi5PQBlIfLwhFgpJLdiJaQNgW9sesCGtjE5Tc/zZhrJH
         hHNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1pTMpOorH4LXisVDsXChy+V+9uhVQ+gNlcIaEeOCwgw=;
        b=uHr2pJOtMgO7L769AHTyhE8ec82rc10GrhopZ9I4jp82T5wosF0E9wL2qsQjeA7qDg
         kXrp7IASNrKavleM/HBjA2dedZ/sJpYInOjSZzI7tIVhZhJWg1h/PkCyfsQfNcI27+Iq
         5XSME9UWAQCPTJYgCH3TtIw+p2Ad2Gbf+fU5jrK9eIcnZDwMSfTk+bY7kmj033DADlJz
         dLhWZSvpNsm89ShOd3x7uhm6E/AnuODubc2zJO4u5+0v4mBbWGOmHQb5/VmhUAHF6iM6
         PrPdZvHIat3AwVOGGCzTGlRMevjMhE9Odr7cUPeLBs5JRXav1YRyu+xGLXw1jbRzJ+ZJ
         ebww==
X-Gm-Message-State: AOAM532Mz+GFdSv6to8YfJHlt7Ri852BOJ7XAFfeIDiK2cdVSO0gnhZK
        TZf90A6Mq2Ic7s3edvFmTbM=
X-Google-Smtp-Source: ABdhPJxDzUmnDBr3FnJxsrTGzmISxnDFYJY0nVkE1Yu2DpPmwDKycq0Um4vr7UGXd0sHFR5RYYV2gQ==
X-Received: by 2002:aa7:c4c9:: with SMTP id p9mr20618792edr.385.1626770723103;
        Tue, 20 Jul 2021 01:45:23 -0700 (PDT)
Received: from skbuf ([82.76.66.29])
        by smtp.gmail.com with ESMTPSA id j11sm6881855ejy.40.2021.07.20.01.45.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jul 2021 01:45:22 -0700 (PDT)
Date:   Tue, 20 Jul 2021 11:45:20 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        bridge@lists.linux-foundation.org,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Marek Behun <kabel@blackhole.sk>,
        DENG Qingfang <dqfext@gmail.com>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: Re: [PATCH v4 net-next 09/15] net: bridge: switchdev: let drivers
 inform which bridge ports are offloaded
Message-ID: <20210720084520.4t7sfshyzeuw4ba3@skbuf>
References: <20210718214434.3938850-1-vladimir.oltean@nxp.com>
 <20210718214434.3938850-10-vladimir.oltean@nxp.com>
 <20210720075354.u57sju7bvn5o3ses@soft-dev3-1.localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210720075354.u57sju7bvn5o3ses@soft-dev3-1.localhost>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Horatiu,

On Tue, Jul 20, 2021 at 09:53:54AM +0200, Horatiu Vultur wrote:
> Tested-by: Horatiu Vultur <horatiu.vultur@microchip.com> # ocelot-switch

Thanks for testing.
Next time could you please trim the quoted portion to maybe just the
commit message? I spent around 30 seconds scrolling down, half expecting
there to be an inline comment on a line of code or something.
