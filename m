Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BF5B6B9AB3
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 17:09:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229986AbjCNQJN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 12:09:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbjCNQJM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 12:09:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 221612BEC5
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 09:08:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678810107;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ye+Zs2ZnlofuAeakJPo0MMXWynO6qrZaDf6LrDdzxr0=;
        b=ejwrMlFsx1TxgmmnRNZhp3+NMS3Xr5MoIU7OzdUMwnWM4XLbnfPLFFJGDLg0YuDIn/2wBU
        vYwsjMc76wYFtmLwoBEcfF7bWYK4TsPUiitBCW0LNyxzoAtJZYuwfNPv053qToMq7bw0WG
        qRIuEu8hnmiV7jgmnmyMrUqG09lyJhg=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-445-FzaG-8QIM8egT8-RVxpxGA-1; Tue, 14 Mar 2023 12:08:23 -0400
X-MC-Unique: FzaG-8QIM8egT8-RVxpxGA-1
Received: by mail-qv1-f70.google.com with SMTP id a15-20020a0562140c2f00b005ad28a23cffso629897qvd.6
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 09:08:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678810103;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ye+Zs2ZnlofuAeakJPo0MMXWynO6qrZaDf6LrDdzxr0=;
        b=6DS5HZ22X8EipzHpc173tgBWkFFeARe8BJStug7SOTewR4xWufO4qwTIOD665HAY1H
         hkiPFRkVHmu+BOPoYB6SBULykOdFTJEvm07Nj0ik7IBlf3nXuUhFQX8Co6yKxLcj4H/D
         bfDdlW4h2G2yfKtw0HZaVArKNyQL4ij5hGNT6twKu169SZqA/zX6S/zoVHv60pFNW+G7
         rjLlPa4GKn3tP0a84aCIJbGRRmPwLGbm3KknJ+y9IO+yXqIkKwk1TyzXCkjOSDTnnwrQ
         pZ+8zB5f0Io3dgud6B+I7TdCaiN5ry0PFGP2vIjLE/r2Qetn3lMUFM3zM4OKy91JPLfa
         Jcmw==
X-Gm-Message-State: AO0yUKUcM4nGIH1qps+SZRLl8o3GuXmkkb/O3eFEMlerdCp2iFfIiihT
        ZQt12xZSibDExUs6wGIS99za3HtdpRP4bt8Z/mY9Ikefcej9YpJ1smpIWRccYsu6SpSODv4lBR7
        na1ofcLZluDpRKAW1
X-Received: by 2002:a05:622a:134b:b0:3b6:3260:fa1d with SMTP id w11-20020a05622a134b00b003b63260fa1dmr63289009qtk.45.1678810102798;
        Tue, 14 Mar 2023 09:08:22 -0700 (PDT)
X-Google-Smtp-Source: AK7set8+Q/YIESpi+tpsA8aTC6oiVaMszVdOh9hZlBEg5fft+wCfZpLbUpRbaWQbPDeCDDmvmA+rsw==
X-Received: by 2002:a05:622a:134b:b0:3b6:3260:fa1d with SMTP id w11-20020a05622a134b00b003b63260fa1dmr63288928qtk.45.1678810102361;
        Tue, 14 Mar 2023 09:08:22 -0700 (PDT)
Received: from halaney-x13s (104-53-165-62.lightspeed.stlsmo.sbcglobal.net. [104.53.165.62])
        by smtp.gmail.com with ESMTPSA id s81-20020a374554000000b007426b917031sm1989714qka.121.2023.03.14.09.08.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 09:08:21 -0700 (PDT)
Date:   Tue, 14 Mar 2023 11:08:18 -0500
From:   Andrew Halaney <ahalaney@redhat.com>
To:     Konrad Dybcio <konrad.dybcio@linaro.org>
Cc:     linux-kernel@vger.kernel.org, agross@kernel.org,
        andersson@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, vkoul@kernel.org,
        bhupesh.sharma@linaro.org, mturquette@baylibre.com,
        sboyd@kernel.org, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        mcoquelin.stm32@gmail.com, richardcochran@gmail.com,
        linux@armlinux.org.uk, veekhee@apple.com,
        tee.min.tan@linux.intel.com, mohammad.athari.ismail@intel.com,
        jonathanh@nvidia.com, ruppala@nvidia.com, bmasney@redhat.com,
        andrey.konovalov@linaro.org, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-clk@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, ncai@quicinc.com,
        jsuraj@qti.qualcomm.com, hisunil@quicinc.com
Subject: Re: [PATCH net-next 05/11] clk: qcom: gcc-sc8280xp: Add EMAC GDSCs
Message-ID: <20230314160818.2yopv6yeczne7gfi@halaney-x13s>
References: <20230313165620.128463-1-ahalaney@redhat.com>
 <20230313165620.128463-6-ahalaney@redhat.com>
 <3f37eede-6d62-fb92-9cff-b308de333ebd@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3f37eede-6d62-fb92-9cff-b308de333ebd@linaro.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 14, 2023 at 04:13:18PM +0100, Konrad Dybcio wrote:
> 
> 
> On 13.03.2023 17:56, Andrew Halaney wrote:
> > Add the EMAC GDSCs to allow the EMAC hardware to be enabled.
> > 
> > Signed-off-by: Andrew Halaney <ahalaney@redhat.com>
> > ---
> Was it tested to not cause issues on access on "normal" 8280xp?
> AFAICS if there would be any, they would happen at registration
> time, as gdsc_init already accesses its registers

No, I've only tested this series on the sa8540p-ride. I luckily also am
working from an x13s, I will use that to confirm nothing strange happens
with this applied before sending v2 and confirm the results.

Thanks for the idea,
Andrew

> 
> Konrad
> >  drivers/clk/qcom/gcc-sc8280xp.c               | 18 ++++++++++++++++++
> >  include/dt-bindings/clock/qcom,gcc-sc8280xp.h |  2 ++
> >  2 files changed, 20 insertions(+)
> > 
> > diff --git a/drivers/clk/qcom/gcc-sc8280xp.c b/drivers/clk/qcom/gcc-sc8280xp.c
> > index b3198784e1c3..04a99dbaa57e 100644
> > --- a/drivers/clk/qcom/gcc-sc8280xp.c
> > +++ b/drivers/clk/qcom/gcc-sc8280xp.c
> > @@ -6873,6 +6873,22 @@ static struct gdsc usb30_sec_gdsc = {
> >  	.pwrsts = PWRSTS_RET_ON,
> >  };
> >  
> > +static struct gdsc emac_0_gdsc = {
> > +	.gdscr = 0xaa004,
> > +	.pd = {
> > +		.name = "emac_0_gdsc",
> > +	},
> > +	.pwrsts = PWRSTS_OFF_ON,
> > +};
> > +
> > +static struct gdsc emac_1_gdsc = {
> > +	.gdscr = 0xba004,
> > +	.pd = {
> > +		.name = "emac_1_gdsc",
> > +	},
> > +	.pwrsts = PWRSTS_OFF_ON,
> > +};
> > +
> >  static struct clk_regmap *gcc_sc8280xp_clocks[] = {
> >  	[GCC_AGGRE_NOC_PCIE0_TUNNEL_AXI_CLK] = &gcc_aggre_noc_pcie0_tunnel_axi_clk.clkr,
> >  	[GCC_AGGRE_NOC_PCIE1_TUNNEL_AXI_CLK] = &gcc_aggre_noc_pcie1_tunnel_axi_clk.clkr,
> > @@ -7351,6 +7367,8 @@ static struct gdsc *gcc_sc8280xp_gdscs[] = {
> >  	[USB30_MP_GDSC] = &usb30_mp_gdsc,
> >  	[USB30_PRIM_GDSC] = &usb30_prim_gdsc,
> >  	[USB30_SEC_GDSC] = &usb30_sec_gdsc,
> > +	[EMAC_0_GDSC] = &emac_0_gdsc,
> > +	[EMAC_1_GDSC] = &emac_1_gdsc,
> >  };
> >  
> >  static const struct clk_rcg_dfs_data gcc_dfs_clocks[] = {
> > diff --git a/include/dt-bindings/clock/qcom,gcc-sc8280xp.h b/include/dt-bindings/clock/qcom,gcc-sc8280xp.h
> > index cb2fb638825c..721105ea4fad 100644
> > --- a/include/dt-bindings/clock/qcom,gcc-sc8280xp.h
> > +++ b/include/dt-bindings/clock/qcom,gcc-sc8280xp.h
> > @@ -492,5 +492,7 @@
> >  #define USB30_MP_GDSC					9
> >  #define USB30_PRIM_GDSC					10
> >  #define USB30_SEC_GDSC					11
> > +#define EMAC_0_GDSC					12
> > +#define EMAC_1_GDSC					13
> >  
> >  #endif
> 

