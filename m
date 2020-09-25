Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BBEF2784F7
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 12:22:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728060AbgIYKWL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 06:22:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727520AbgIYKWL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 06:22:11 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AD36C0613CE;
        Fri, 25 Sep 2020 03:22:11 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id z19so2719765pfn.8;
        Fri, 25 Sep 2020 03:22:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2lbFg3EfTPubbbEXQCNv75JEtnNzJ5GMo5FQjXXg9gA=;
        b=LSfij8cmE3SRXNOnYNmnoAglcEmSbiz26Yt8p3PrMrnltuSQMEETYBvnz2dbFpghvt
         AqCs5GPJklKK/M1+st7P0ufNsiWQA0W1DLTTli3fHd8cF2PxThflC3I5x7fhxs53HZx/
         zeyiwKAPpDDrCdOshiLl7/CNwimYcxJCi/gf1AMqIQv4RMVsCGXyR1x8f0ko78aYEorx
         5h+wz6H6JdDA/GL2/A2b9lrMahTR5nD2vice+RxkSR7vyveSymLn3YrkLHGHWaOygIwO
         6GmXGHCJT7L6+ZLPyhfeOp1zsiogdSDdEvEPWbpRrgYX1BxJEG8RQqLhzl0SBbhWM1Kr
         P7EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2lbFg3EfTPubbbEXQCNv75JEtnNzJ5GMo5FQjXXg9gA=;
        b=j3Rv4pOwt2Hdlm7Gf7Mp0fvw4SvectYZ/91nfa5vebfjfjZ9vOr/4Cvl0c8xSh3rOR
         LsWdOj69gz/XQI/B7EKfr32FIERW7NJPXTYegWBHILMVSNAbb3/9Aewi3obAzHORUvxM
         E8Xn9RwF3LQx1F0jS1jzE7xe7T1vcoBSpF5TOB4vboarz1/dKRH1+72/Hq7xiGXv0YiP
         qh5rO4vDCbDuum8JvPBZQVbQqU4LaCNgoXQTXBPNsDemOyz5RjMPD+o72X3UGazJgssH
         A8YvbljZLam1vDWec0GVcJUwC6o1MRhvKqt0lsa04ytnN03zPkBeVHKmPcvzPX1AtF6L
         cWLg==
X-Gm-Message-State: AOAM531vTM3FnwSBwaabSKE6meRednFnnDYZXMvAHkZLhdP5hJjBJpyh
        EBM+X64woW44nhowMV7wBtGlPzTvji6RS6CdONs=
X-Google-Smtp-Source: ABdhPJzYlM8hV0nt13kMb7p2rnKTLsPzywseTL+BVDG3rpzy9n7kySSls2sU3iDbAEm+9utxauJoCMzVwRpkG/6HZLg=
X-Received: by 2002:aa7:9201:0:b029:13e:d13d:a10c with SMTP id
 1-20020aa792010000b029013ed13da10cmr3305770pfo.40.1601029330528; Fri, 25 Sep
 2020 03:22:10 -0700 (PDT)
MIME-Version: 1.0
References: <20200925095406.27834-1-vee.khee.wong@intel.com>
In-Reply-To: <20200925095406.27834-1-vee.khee.wong@intel.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Fri, 25 Sep 2020 13:21:52 +0300
Message-ID: <CAHp75VeMJXRhx2FrsRur4e9OLXodmXh5Krj_n6PosuJx6MD=Zg@mail.gmail.com>
Subject: Re: [PATCH net 1/1] net: stmmac: Fix clock handling on remove path
To:     Wong Vee Khee <vee.khee.wong@intel.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Voon Wei Feng <weifeng.voon@intel.com>,
        Vijaya Balan Sadhishkhanna 
        <sadhishkhanna.vijaya.balan@intel.com>,
        Seow Chen Yong <chen.yong.seow@intel.com>,
        Mark Gross <mgross@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 25, 2020 at 12:54 PM Wong Vee Khee <vee.khee.wong@intel.com> wrote:
>
> While unloading the dwmac-intel driver, clk_disable_unprepare() is
> being called twice in stmmac_dvr_remove() and
> intel_eth_pci_remove(). This causes kernel panic on the second call.
>
> Removing the second call of clk_disable_unprepare() in
> intel_eth_pci_remove().

Thanks! I'm not sure how I missed this...

Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>

> Fixes: 09f012e64e4b ("stmmac: intel: Fix clock handling on error and remove paths")
> Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Reviewed-by: Voon Weifeng <weifeng.voon@intel.com>
> Signed-off-by: Wong Vee Khee <vee.khee.wong@intel.com>
> ---
>  drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
> index 2ac9dfb3462c..9e6d60e75f85 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
> @@ -653,7 +653,6 @@ static void intel_eth_pci_remove(struct pci_dev *pdev)
>
>         pci_free_irq_vectors(pdev);
>
> -       clk_disable_unprepare(priv->plat->stmmac_clk);
>         clk_unregister_fixed_rate(priv->plat->stmmac_clk);
>
>         pcim_iounmap_regions(pdev, BIT(0));
> --
> 2.17.0
>


-- 
With Best Regards,
Andy Shevchenko
