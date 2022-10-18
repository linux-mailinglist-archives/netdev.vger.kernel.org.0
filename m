Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F18BF6022EC
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 05:54:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbiJRDyi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 23:54:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbiJRDyg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 23:54:36 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5936F60C7;
        Mon, 17 Oct 2022 20:54:27 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id c24so12673606plo.3;
        Mon, 17 Oct 2022 20:54:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=EXydlB+x9/yS8YgHBF3l/5e7/0G8nhm8UFrGg/lnonk=;
        b=n/C/bdH4+SNwsSk2qM2fUW3BWJTkGU/b6DW/7DY4Q6eeA060oPAXxHBixsQprQe9w3
         hhi4E6QHvO8OYc0XDM9/2Ee/Ab8O1/tRjhY0e9bALy6D2a2CIBgBPi7fTW/MTaxI0Zot
         +O/R1XhzDXDwiRsFRqXRtT+RH2+Ohd/EHfvWM1rY+tN6IzCha3Ywtu+sBrohbYkUYp+3
         VGw/8V8EBI7tlRAe76meLmZ/Qm82U/XZFgsiQcQ8SrDqnZifSJdjk0FHxUImmLs4js2y
         /yO19329xSI3Zoa25islP42dkqKiqi0QXFoqPfwkaA6ZJzs1co3HuRKhRDLpVB9hOxmy
         2YqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EXydlB+x9/yS8YgHBF3l/5e7/0G8nhm8UFrGg/lnonk=;
        b=YRY5RQdoroB6OW0BivKz11H3K74iHpr0dscMIJOdapBacRILI9SxWe4Dozmbkytkya
         sJX5+8WFXthqe6Wo0hbq7bj27/6fjpto6Ou4AVgtXSpx2YtpO9E4yndm8aSg3y2BMcCb
         ibO3MnN0plIEFzbqSCOKrjVGuP7j0Ge7FBgB5qa5TIh/88gxD5pv78INJUo8lg1KIPRm
         draCXlEAd3VcX0PUnoFWGUf4pdhkitTFDNyrINsGP4LFJ+10dOvO3i+eL6iq6XqaWgcn
         cRbosNmeUJ/LpY53kGxMdT+foJahqtVatheB3PaznGl2XQz1rq++BtCDkLIjYNaputfN
         rhEg==
X-Gm-Message-State: ACrzQf14YCT88ZG9TNkQ0/z1RZp24fF0a/PpWp+cLmBpCMGHTqPyJJd3
        yCbbZ2XcfA5KAivalbMDfWGHg7znxJpHXTY7uaw=
X-Google-Smtp-Source: AMsMyM6/EuOW1Hu1tlfs0A5mrlPSH8WDCodmhvAtU8ypPyEo9xHIReWk8lm5S9/ey3Tsh2k+nUWMuXOQ5MeFmXHGejI=
X-Received: by 2002:a17:902:8542:b0:179:eb8d:f41d with SMTP id
 d2-20020a170902854200b00179eb8df41dmr954301plo.62.1666065266837; Mon, 17 Oct
 2022 20:54:26 -0700 (PDT)
MIME-Version: 1.0
References: <20221017191743.75177-1-pmanank200502@gmail.com>
In-Reply-To: <20221017191743.75177-1-pmanank200502@gmail.com>
From:   sundeep subbaraya <sundeep.lkml@gmail.com>
Date:   Tue, 18 Oct 2022 09:24:15 +0530
Message-ID: <CALHRZupuBVAhd=fK+4E=keBTnt=GEGrWOTpN0-xBfu2Yj1+PDA@mail.gmail.com>
Subject: Re: [PATCH] ethernet: marvell: octeontx2 Fix resource not freed after malloc
To:     Manank Patel <pmanank200502@gmail.com>
Cc:     sgoutham@marvell.com, gakula@marvell.com, sbhatta@marvell.com,
        hkelam@marvell.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Tue, Oct 18, 2022 at 1:27 AM Manank Patel <pmanank200502@gmail.com> wrote:
>
> fix rxsc not getting freed before going out of scope
>
> Fixes: c54ffc73601c ("octeontx2-pf: mcs: Introduce MACSEC hardware offloading")
>
> Signed-off-by: Manank Patel <pmanank200502@gmail.com>
> ---
>  drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c
> index 9809f551fc2e..c7b2ebb2c75b 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c
> @@ -870,6 +870,7 @@ static struct cn10k_mcs_rxsc *cn10k_mcs_create_rxsc(struct otx2_nic *pfvf)
>         cn10k_mcs_free_rsrc(pfvf, MCS_RX, MCS_RSRC_TYPE_FLOWID,
>                             rxsc->hw_flow_id, false);
>  fail:
> +       kfree(rxsc);

Thanks for the fix. Can you do the same in cn10k_mcs_create_txsc as well.

Sundeep

>         return ERR_PTR(ret);
>  }
>
> --
> 2.38.0
>
