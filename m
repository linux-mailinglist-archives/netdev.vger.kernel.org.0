Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD4D76484A8
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 16:08:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230178AbiLIPIL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 10:08:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230245AbiLIPHp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 10:07:45 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7DF51A053;
        Fri,  9 Dec 2022 07:07:44 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id n20so12253849ejh.0;
        Fri, 09 Dec 2022 07:07:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fRctk+k0gPaHBTzrNjrRIZoG3JHVyfVBq+4oznyPZY8=;
        b=EBFa1314y9Nxx47i5XxY+OwD5FV9EntMPMH5BjpTecf3oK7JZFUd1TAxfbitF+Ztxg
         GHD40j1CshemgpggpWnydQtxn3ncEBeMzr3l2KI0xZlOHRcct6xi247MpDHsx9bBni4l
         sTmaUQUTp4yVv4HgRmC9LudjuAt9r+a6PahHmJnXPJhz0wvN3Z8lVDpOY7SvcoziflbE
         A4IdGTBeDazK6LINtxWQLQ2DwU3Dl4UicwhS6DsYIiWGXrOr06DNtIQJc3mbq0m7y3bn
         QVkFvirOSpkgF68NRfNj3z7OVb3vmY57YW2RKn+MKcsu+lZEXnbFRv3Vv0dDcLR30gQZ
         XCBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fRctk+k0gPaHBTzrNjrRIZoG3JHVyfVBq+4oznyPZY8=;
        b=AMwPDCDGUahpMLkfYG/xUWY8VvgqnDsaIk/MOYqHQCWDMcFOJ52XXzSNnnECd2Pe75
         GphWlQZ3+7DdJDN6ia5+R+x8cLxBinerLgXw2Vj9BVknZO0cUwbRr8p3UEyPtAoDeV04
         uG6b1+ixeRAEveQFwzxHV0GYB1i6CSBYDSzwcVKDZ7PlDkK5PnjUJYbKoVTu7kSkjsfu
         7P+Cj/qfCXVUEDAGDFPG/aQ5iqRq6INQ8tEOc+DSMwnD6zrzDzQ67FKrlJ1shIpt+WrG
         iknyLRZFLIktfDaSaFBlOlLSrvSB6t1SROLg3Vr4TiEvbDoOnDx1hFXbFeFzqkpURgQl
         MaTQ==
X-Gm-Message-State: ANoB5pkE++9n8umf5wPXFVrBg0qq2obDtNiL8oTI+vahSaO9qULJtvcZ
        Sq22I8U3rYA0U4EAKe1dA4pbhDCQr2d3tw==
X-Google-Smtp-Source: AA0mqf6NSSbJT9wonF6KPMM63FOXAmNbPxGapGV1HtdiKoN7DE5ba56Kz4/5TZsH9gxcdLhY6O9L0g==
X-Received: by 2002:a17:907:10c9:b0:7c0:cee0:2f55 with SMTP id rv9-20020a17090710c900b007c0cee02f55mr5598486ejb.28.1670598462809;
        Fri, 09 Dec 2022 07:07:42 -0800 (PST)
Received: from skbuf ([188.27.185.190])
        by smtp.gmail.com with ESMTPSA id o7-20020a17090608c700b0078d9cd0d2d6sm23977eje.11.2022.12.09.07.07.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Dec 2022 07:07:42 -0800 (PST)
Date:   Fri, 9 Dec 2022 17:07:39 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux@armlinux.org.uk,
        Tristram.Ha@microchip.com, richardcochran@gmail.com,
        ceggers@arri.de
Subject: Re: [Patch net-next v3 08/13] net: dsa: microchip: ptp: add packet
 transmission timestamping
Message-ID: <20221209150739.bddwnli5ddaxmws5@skbuf>
References: <20221209072437.18373-1-arun.ramadoss@microchip.com>
 <20221209072437.18373-1-arun.ramadoss@microchip.com>
 <20221209072437.18373-9-arun.ramadoss@microchip.com>
 <20221209072437.18373-9-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221209072437.18373-9-arun.ramadoss@microchip.com>
 <20221209072437.18373-9-arun.ramadoss@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 09, 2022 at 12:54:32PM +0530, Arun Ramadoss wrote:
> From: Christian Eggers <ceggers@arri.de>
> 
> This patch adds the routines for transmission of ptp packets. When the
> ptp pdelay_req packet to be transmitted, it uses the deferred xmit
> worker to schedule the packets.
> During irq_setup, interrupt for Sync, Pdelay_req and Pdelay_rsp are
> enabled. So interrupt is triggered for all three packets. But for
> p2p1step, we require only time stamp of Pdelay_req packet. Hence to
> avoid posting of the completion from ISR routine for Sync and
> Pdelay_resp packets, ts_en flag is introduced. This controls which
> packets need to processed for timestamp.
> After the packet is transmitted, ISR is triggered. The time at which
> packet transmitted is recorded to separate register.
> This value is reconstructed to absolute time and posted to the user
> application through socket error queue.
> 
> Signed-off-by: Christian Eggers <ceggers@arri.de>
> Co-developed-by: Arun Ramadoss <arun.ramadoss@microchip.com>
> Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
