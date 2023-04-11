Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAA1F6DE602
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 22:50:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229831AbjDKUuv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 16:50:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229765AbjDKUuu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 16:50:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDAED3AAA
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 13:50:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681246202;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FnJ89Jr7frkhLpQ5e8FVQom59cKoMcGSZpquVEiks/w=;
        b=YaXFJ05Wm0K+gIXa2FzYO+x2hCiP+LTGms+SDb7lLsU3ApJFPAsQQ85OBbmLFPCjfW/Rdt
        T5W8PPUxbr1tEJgcu9FrdknzxjUBCZ6WHipwAEuQqx74X1tseGne6+5yK5Se5eFFa1R3+k
        5S5Dy7yletVB2TTpolASnzliysPB3qE=
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com
 [209.85.167.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-618-M_0ujHfyNsyGYVMGCoVdpQ-1; Tue, 11 Apr 2023 16:50:01 -0400
X-MC-Unique: M_0ujHfyNsyGYVMGCoVdpQ-1
Received: by mail-oi1-f200.google.com with SMTP id y81-20020acae154000000b003877ce3bfb4so2790031oig.3
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 13:50:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681246201;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FnJ89Jr7frkhLpQ5e8FVQom59cKoMcGSZpquVEiks/w=;
        b=hgUhs6lkchjh/WHsDRpm+Fg+2LAySWtu43LCUCgt+//6gQnzxLci8gSET60HSfkBVH
         t7n8MlUXZGzi3Tqqe9IKVDPcnF6xeHvpPSm3ko7j+NBwNP9t0gfWoxmw8RgoOWmADf76
         Hb8s2OBDJN0iATNBaQbrc8LaC7sz1qdtVpJZWSm5AD17+fC4SraskHHQlPz8YijMpG9D
         +PYbLEdsCa3tw4xUSVlnpfDJxRZxYjLo7rOeMsIkia/KgrR3JDefevckWCzdS53YPk2L
         +5gKKeFxtMZlX3Aeq/V7JOSsaatp8LdD9lLonlXZmtwq2C/dIyssHPuINicy/qugI7Zf
         g9uA==
X-Gm-Message-State: AAQBX9fB5FlWQKWAVBjjeF0MYlUe09h+P/g++aTWP8zD6CEb64LFNsQp
        tlT9worH+h6vRI7+T5qlT+XJL7czF4uIgHudIeDz+2DlxAStnct1cnQ9uWQEr37h8ELmJrTyp3+
        lPtWtybvnrT7/peX6
X-Received: by 2002:a05:6870:32c9:b0:17f:6909:1618 with SMTP id r9-20020a05687032c900b0017f69091618mr8385056oac.5.1681246201168;
        Tue, 11 Apr 2023 13:50:01 -0700 (PDT)
X-Google-Smtp-Source: AKy350a/jKcTh3Dg+IN29kMyFBcT98jFq7QbmEt+C4YJeNTF6M0ET6Rq1bJC/j+OEgYr3vcjHqKpaA==
X-Received: by 2002:a05:6870:32c9:b0:17f:6909:1618 with SMTP id r9-20020a05687032c900b0017f69091618mr8385021oac.5.1681246200922;
        Tue, 11 Apr 2023 13:50:00 -0700 (PDT)
Received: from halaney-x13s (104-53-165-62.lightspeed.stlsmo.sbcglobal.net. [104.53.165.62])
        by smtp.gmail.com with ESMTPSA id s21-20020a056830149500b006a3e377f0d7sm499957otq.4.2023.04.11.13.49.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Apr 2023 13:50:00 -0700 (PDT)
Date:   Tue, 11 Apr 2023 15:49:57 -0500
From:   Andrew Halaney <ahalaney@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     agross@kernel.org, andersson@kernel.org, konrad.dybcio@linaro.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, vkoul@kernel.org,
        bhupesh.sharma@linaro.org, wens@csie.org, jernej.skrabec@gmail.com,
        samuel@sholland.org, mturquette@baylibre.com,
        peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, mcoquelin.stm32@gmail.com,
        richardcochran@gmail.com, linux@armlinux.org.uk, veekhee@apple.com,
        tee.min.tan@linux.intel.com, mohammad.athari.ismail@intel.com,
        jonathanh@nvidia.com, ruppala@nvidia.com, bmasney@redhat.com,
        andrey.konovalov@linaro.org, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, ncai@quicinc.com,
        jsuraj@qti.qualcomm.com, hisunil@quicinc.com, echanude@redhat.com
Subject: Re: [PATCH net-next v4 00/12] Add EMAC3 support for sa8540p-ride
Message-ID: <20230411204957.kt5o4oraoxi7szts@halaney-x13s>
References: <20230411200409.455355-1-ahalaney@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230411200409.455355-1-ahalaney@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 11, 2023 at 03:03:57PM -0500, Andrew Halaney wrote:
> This is a forward port / upstream refactor of code delivered
> downstream by Qualcomm over at [0] to enable the DWMAC5 based
> implementation called EMAC3 on the sa8540p-ride dev board.
> 
> From what I can tell with the board schematic in hand,
> as well as the code delivered, the main changes needed are:
> 
>     1. A new address space layout for dwmac5/EMAC3 MTL/DMA regs
>     2. A new programming sequence required for the EMAC3 based platforms
> 
> This series makes the changes above as well as other housekeeping items
> such as converting dt-bindings to yaml, etc.
> 
> As requested[1], it has been split up by compilation deps / maintainer tree.
> I will post a link to the associated devicetree changes that together
> with this series get the hardware functioning.
> 

Link to the devicetree bits: https://lore.kernel.org/netdev/20230411202009.460650-1-ahalaney@redhat.com/T/#t

Thanks,
Andrew

