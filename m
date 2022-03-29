Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5608E4EA589
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 04:52:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231289AbiC2Cxm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 22:53:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230154AbiC2Cxl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 22:53:41 -0400
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 871941B3716
        for <netdev@vger.kernel.org>; Mon, 28 Mar 2022 19:51:59 -0700 (PDT)
Received: by mail-ot1-x336.google.com with SMTP id a17-20020a9d3e11000000b005cb483c500dso11950549otd.6
        for <netdev@vger.kernel.org>; Mon, 28 Mar 2022 19:51:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=h34tRgLhtbOsVJ1OPkfqGNKfTONMRuk1LxjHuz2UdWw=;
        b=mjyu8zSn0YwPS42kRHB+snvNpOm0Lj51x9HEmkoV5nnGTjLtP79VOZI7jClYa4FIOu
         HYust6PmSN0nRRa5H2OXTHFKuNrLWM20Dw411pVvrmnPbaJA24WQy7X/bPDO/k5zrk77
         mRi9tvAfmL+nRMSfqoQo5OLfnXW3hUyk3ORNDwGCy/DGrI3P0mg4VFeT2Q4PB98IQGqB
         WRDflq9n0iHcyVwLIv5HMEB2X6akQhX4eHZhzG6P7FbR3qjSUCCb37IWL+orBz6UDgBN
         aIV8TN00o8Z0/643llKeF2zbrU2zZn2eA90yvLOB2uLovr8YO7lBNksSPMq/YVcHv+30
         hcOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=h34tRgLhtbOsVJ1OPkfqGNKfTONMRuk1LxjHuz2UdWw=;
        b=ux5cyNRw7FC012r785H7UHjYb8BFbiDQe0JuCUU5TJKIwVmcCB2KKSUwow99MdCIhA
         fhLO4yvT2lMDm5ubKE3ZEJ6+Cqdy2E6MN1WA8YoFl9jA/9cGRbWfMLXZPtt3dqAjD6M7
         RNJTK+gG9USE1ieTt2zcWnxZfB0Dk24dXncCpjLKiEI2iy5j9pVS/W4iWiM36b4+JGJ9
         CAG4RC0wfCIBSd6Gr7Nb823KciYPk8zHivfDWkVYW0xMBkGf7a6M2ET3ZlCO2oe+3PG9
         pd8sFLSWxBEIxWPRbv/lHj6on8JikoHtMzWKzFgZInGAbOfcvcz0xspbF9+/RITjjZyt
         sThA==
X-Gm-Message-State: AOAM533jTRnB5yD7e7m62/FK79xQhKnuvNyIc9R/aN+NJ6x6i8BRnw8k
        QDSbMxJ47kaWwViyGulLEzx0wK3IG3WrPgC1Ps+d+Q==
X-Google-Smtp-Source: ABdhPJzpHoEjlthdH311NH2geeKWuiu6NnEqzdEU8YB8wkidS/ZQGB8K7clR5ej2P2o7Uexd80K5F5yDNtW0SmtR/10=
X-Received: by 2002:a05:6830:2a9f:b0:5cd:d12c:26ba with SMTP id
 s31-20020a0568302a9f00b005cdd12c26bamr239310otu.297.1648522318927; Mon, 28
 Mar 2022 19:51:58 -0700 (PDT)
MIME-Version: 1.0
References: <20220328123238.2569322-1-andy.chiu@sifive.com> <20220328165839.70f964dc@kernel.org>
In-Reply-To: <20220328165839.70f964dc@kernel.org>
From:   Andy Chiu <andy.chiu@sifive.com>
Date:   Tue, 29 Mar 2022 10:49:50 +0800
Message-ID: <CABgGipWXdqU-+HSu7NqoiHuzxh0MEttx=dfnmmW1WdaFGsOz_w@mail.gmail.com>
Subject: Re: [PATCH v6 net 0/4] Fix broken link on Xilinx's AXI Ethernet in
 SGMII mode
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     radhey.shyam.pandey@xilinx.com,
        Robert Hancock <robert.hancock@calian.com>,
        michal.simek@xilinx.com, Andrew Lunn <andrew@lunn.ch>,
        davem@davemloft.net, pabeni@redhat.com, robh+dt@kernel.org,
        linux@armlinux.org.uk, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, robh@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> This set not longer applies, please rebase on latest net/master.
Thanks for reminding me. I have rebased it on the latest net/master
and submitted a v7 patch for that.

Andy
