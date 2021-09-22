Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D096041489A
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 14:15:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235439AbhIVMRW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 08:17:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235227AbhIVMRV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 08:17:21 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7724BC061756
        for <netdev@vger.kernel.org>; Wed, 22 Sep 2021 05:15:51 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id u18so6169110wrg.5
        for <netdev@vger.kernel.org>; Wed, 22 Sep 2021 05:15:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Pa+fl9Rsega8suhbx2cwWWJOokOEYcTuSXNs1BTWnJU=;
        b=cJ/kSg2kCbV/XSyL2FhCOA/bzv02g/NCMYSAF6UpI9bCXs0COpTXzSiBWtyi2D4fVp
         NwZ4fZpXSbOyRTPVbHPUFRDvZin9TNrPa+wI1n5IbPcERRXoVQ6F6AQ72ymmaiP5Ai2r
         +wkKQFgbcUxTP+ODLR+vqUuciFIJYm+6gNl4GP4wTnt+yCrlCHtJdypBNOjRoFZU283d
         mvJANPj+dAZ1qauLVbTyhKzighKwgFIZclr3S+pJgnea3OJ02f2b2Iz32gslIrBorvKS
         Z2Se8zpwT0QiFRaHQzBGz2a3uQ0VG/6uDNlUygJT5sHEwffe+tQl9+X86Zfhg87idCue
         3b7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Pa+fl9Rsega8suhbx2cwWWJOokOEYcTuSXNs1BTWnJU=;
        b=ZICyWPDnUkgNJESN9nnsEzECBTVoeyLIduGstyDCfR9cFDUt22AU5zU/5HIFNry4oz
         Mz6Wux09pHDW/GMpqdtIA7qstqsfoDoWVgeSEy5wA8WYe4DzgQrX9x+mGFpjZOWR6PjG
         HL96Rv0P3CW5Lunii1XcCNm17NJE9qhHLNbtKOb0XI4qMtVrn5B9NG95iIV2NSDR4oCN
         e4t7knfRsx8n1N3ak0lDPrcj9FlXHzUxpXHSyxOXUP69rV/7ePLpH1or/cFvUxarz1Y4
         LJ9+WVhmMj/yVkQFGczR1ssdWZMuxEB5reZCV9RutX75DtN85y8uaPqd6PR5SCZOJs6n
         ZeUg==
X-Gm-Message-State: AOAM531CaPNGehhskju0J3NwQLHwhi128DK9yqR6fd+OYUBt8CIdCbHd
        ls9oXFkzBmUOenDFAkpRJTNalA==
X-Google-Smtp-Source: ABdhPJzCZMzjCAO3TxbrSgQDj+5uKJEPtELabH+RXmVdZfiHM6v4eHIkMHhrowjuyXTI3sw5YUsdig==
X-Received: by 2002:a05:600c:35d0:: with SMTP id r16mr9995852wmq.26.1632312949996;
        Wed, 22 Sep 2021 05:15:49 -0700 (PDT)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id n68sm5849702wmn.13.2021.09.22.05.15.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Sep 2021 05:15:49 -0700 (PDT)
Date:   Wed, 22 Sep 2021 14:15:48 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Leon Romanovsky <leonro@nvidia.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>, Ariel Elior <aelior@marvell.com>,
        Bin Luo <luobin9@huawei.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Coiby Xu <coiby.xu@gmail.com>,
        Derek Chickles <dchickles@marvell.com>, drivers@pensando.io,
        Felix Manlunas <fmanlunas@marvell.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        GR-everest-linux-l2@marvell.com, GR-Linux-NIC-Dev@marvell.com,
        hariprasad <hkelam@marvell.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Intel Corporation <linuxwwan@intel.com>,
        intel-wired-lan@lists.osuosl.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Jerin Jacob <jerinj@marvell.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jiri Pirko <jiri@nvidia.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Linu Cherian <lcherian@marvell.com>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-staging@lists.linux.dev,
        Loic Poulain <loic.poulain@linaro.org>,
        Manish Chopra <manishc@marvell.com>,
        M Chetan Kumar <m.chetan.kumar@intel.com>,
        Michael Chan <michael.chan@broadcom.com>,
        netdev@vger.kernel.org, oss-drivers@corigine.com,
        Richard Cochran <richardcochran@gmail.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Satanand Burla <sburla@marvell.com>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Shannon Nelson <snelson@pensando.io>,
        Simon Horman <simon.horman@corigine.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        UNGLinuxDriver@microchip.com, Vadym Kochan <vkochan@marvell.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>
Subject: Re: [PATCH net-next v1] devlink: Make devlink_register to be void
Message-ID: <YUsedPzvmA9u3msV@nanopsycho>
References: <311a6c7e74ad612474446890a12c9d310b9507ed.1632300324.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <311a6c7e74ad612474446890a12c9d310b9507ed.1632300324.git.leonro@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Sep 22, 2021 at 10:58:03AM CEST, leon@kernel.org wrote:
>From: Leon Romanovsky <leonro@nvidia.com>
>
>devlink_register() can't fail and always returns success, but all drivers
>are obligated to check returned status anyway. This adds a lot of boilerplate
>code to handle impossible flow.
>
>Make devlink_register() void and simplify the drivers that use that
>API call.
>
>Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
