Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 812B0620DC8
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 11:52:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232929AbiKHKws (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 05:52:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233970AbiKHKwn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 05:52:43 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC48011A03;
        Tue,  8 Nov 2022 02:52:41 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id n12so37446044eja.11;
        Tue, 08 Nov 2022 02:52:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=GXhEhO2kkG9w3BXRPl6KAt7HKRZJS9R4ZERT274x0RU=;
        b=ipu4bdS+WZU6Gcjx6kIGv+zU4FZTiasQsj89aiazUPILBchJZ73UvbMEHTtN/9hjej
         VuwbnnUFA6yeLNcDXkSl4BPWvCUtHSATAFLX/sYoadFuceEVCFUAQy8PU9EQK9GmOZoN
         /3dA3gfBLNysavXBVUjzuxZd7UGOkWSXOVslaRKQieMZwle+plHlCnCL/ZJiVQCfmrVq
         RHat9olXKcoevWgF5BwaA2YjHq7aZ6lawJ8Y3sWnRmbQehL0hlCXu7+E4r5xSKa5f+aH
         1c5+CNoaanVJKGQG8DhC/6U9mQy8wUCOupJ5oLtM0pc7uAvl9P4HmuunSv/Aa7NAJ2Iu
         R64Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GXhEhO2kkG9w3BXRPl6KAt7HKRZJS9R4ZERT274x0RU=;
        b=UzygLGcn2/1y5NcGLbCr/8mimL5QbAQKeWhyz8cb+hc3n0V/6yaA6W19ysOg1YMWlB
         Hq4KOERmxBWobxB8DsXQKjYazb4w4Pz7Yxir8X2ng4Pe44elKG+Sy0AOHr8Oixeqm8Dv
         CMEwFnfisNU1n1GkRH6GgyfOz4YTwVYVBE8cbBIdiU8aodwk+GFgu9Z+IYIl4GpmxdmU
         M8rrvurIkupRXp10rybLDKSrlKHtK1l3Wc2pTDHvdschmvjbQZp8sPWa949J6owYQrEv
         FFPef0X5DI/hZt7LFXuJtFr6junNkhkGFuUBWcbYOs3/2RYd+AVCAnwpyTbE/PCekqoB
         AZ/g==
X-Gm-Message-State: ANoB5plwCeHhuUk62Z6XmcfzkN5SqiuGz4EyhBobLxK26XYL0hDwSTxd
        Ommfi0N+NWPeovRBbNhTBQtPY7pU5BGBsA==
X-Google-Smtp-Source: AA0mqf7Vtpt6iHNR88AIm2qalPaSmnOAQb0LlHwjcJErq1kSVNfjcOWGCccLnL83urWvGibuFaOioA==
X-Received: by 2002:a17:906:4ecc:b0:7ae:4f8e:1d7 with SMTP id i12-20020a1709064ecc00b007ae4f8e01d7mr14642472ejv.339.1667904760221;
        Tue, 08 Nov 2022 02:52:40 -0800 (PST)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id q9-20020a170906360900b00795bb7d64d8sm4543312ejb.217.2022.11.08.02.52.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 02:52:39 -0800 (PST)
Date:   Tue, 8 Nov 2022 12:52:37 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/14] net: vlan: remove invalid VLAN protocol warning
Message-ID: <20221108105237.v4coebbj7kzee7y6@skbuf>
References: <20221107215745.ascdvnxqrbw4meuv@skbuf>
 <3b275dda-39ac-282d-8a46-d3a95fdfc766@nbd.name>
 <20221108090039.imamht5iyh2bbbnl@skbuf>
 <0948d841-b0eb-8281-455a-92f44586e0c0@nbd.name>
 <20221108094018.6cspe3mkh3hakxpd@skbuf>
 <a9109da1-ba49-d8f4-1315-278e5c890b99@nbd.name>
 <20221108100851.tl5aqhmbc5altdwv@skbuf>
 <5dbfa404-ec02-ac41-8c9b-55f8dfb7800a@nbd.name>
 <20221108103330.xt6wi3x3ugp7bbih@skbuf>
 <1be4d21b-c0a4-e136-ed68-c96470135f14@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1be4d21b-c0a4-e136-ed68-c96470135f14@nbd.name>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 08, 2022 at 11:42:09AM +0100, Felix Fietkau wrote:
> Okay, I will stick with METADATA_HW_PORT_MUX for now. If we use it in the
> flow dissector to avoid the tagger specific fixup, we might as well use it
> in DSA to skip the tag proto receive call. What do you think?

I suppose that dsa_switch_rcv() could test for the presence of a metadata_dst
and treat that generically if present, without unnecessarily calling down into
the tagging protocol ->rcv() call. The assumption being that the metadata_dst
is always formatted (by the DSA master) in a vendor-agnostic way.
