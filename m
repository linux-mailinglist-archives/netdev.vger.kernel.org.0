Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24892620CE2
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 11:09:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233784AbiKHKI7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 05:08:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233574AbiKHKI4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 05:08:56 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A829BF46;
        Tue,  8 Nov 2022 02:08:55 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id f27so37275553eje.1;
        Tue, 08 Nov 2022 02:08:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lfrEfHDwRMpqyMO8Vkpm3VmFl5A5Q/ViF7+HOmSNeUc=;
        b=hIq7cDjhfKnRsy2byjOV1hKutDeb78aGEkzyMv6TK48JaGC3p2ndIBxdKKg8f3PKAj
         I5Lq+u4S5hm3LQFKg+Il9X8Rml6aZdhYFj9KVG3mzJ1k5Lf+6RIOHzkx1A8ZDatdlmPq
         vaPT2qCjLhIYbwvUKnoKdwu8ImdMfLqHudDzJiCrPvZHe7QCAwPaYBOGV8ummcz8WzhR
         e9mwSgKip406Wh995AKRZmv8X2+/364zMfewVOqYdnIxdEF84V32m9ltPkVh+mpPp1JK
         nNFwBzgl3081O9Q9GDiv3GPSmrcQ3qh4gBl+xvhpTMBslDroJ0d+0096/LcIjQlQGk2q
         Da9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lfrEfHDwRMpqyMO8Vkpm3VmFl5A5Q/ViF7+HOmSNeUc=;
        b=12m992kCmKL0AlCKrwznirzXrIH9Cfh+1oW4sqAa5YfCu7i8e25vMVlTXkQ5t3wkau
         nLt0WSTgn5JgxulnOGvcrVzYbUMSlxsJEQc71LMbnTbo25mD+pMz25CZmFh+C4XF/bSG
         wHLcjIM+JzTDnUbC2U458KnNFvugNqPKckV5Dmku/zwKDELrutoMvMTi2KL0V58qGfBa
         16yzZ+lTlemsrlR283pfOuEQ40thPg97v0SL/CzKQK7Zqm/mMeGzgi/JucQozSZDuRDe
         T+PgdmmUIPVm+EvGIutSoXvzaqRdfu43cSUrxx3G+9SLXizTNrD3OLpMeCzV3iBZnxbh
         2kFQ==
X-Gm-Message-State: ACrzQf0yFqjn7NkUItCNcXpW76F35sOcju/J/tsYcMQt4XyIZICZzcUK
        bkRiSNeGr8N0h/wJeNg4/FI=
X-Google-Smtp-Source: AMsMyM5C+Donc+uH5SYlpnH+DmAC/vj/ulOq/KuvkCO4/7KKVzoevsh27Puj4+UGLinNP99i4dTOwQ==
X-Received: by 2002:a17:907:1dec:b0:7aa:6262:f23f with SMTP id og44-20020a1709071dec00b007aa6262f23fmr18809237ejc.38.1667902133889;
        Tue, 08 Nov 2022 02:08:53 -0800 (PST)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id g26-20020a056402321a00b00463bc1ddc76sm5331572eda.28.2022.11.08.02.08.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 02:08:53 -0800 (PST)
Date:   Tue, 8 Nov 2022 12:08:51 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/14] net: vlan: remove invalid VLAN protocol warning
Message-ID: <20221108100851.tl5aqhmbc5altdwv@skbuf>
References: <20221107185452.90711-1-nbd@nbd.name>
 <20221107185452.90711-8-nbd@nbd.name>
 <20221107215745.ascdvnxqrbw4meuv@skbuf>
 <3b275dda-39ac-282d-8a46-d3a95fdfc766@nbd.name>
 <20221108090039.imamht5iyh2bbbnl@skbuf>
 <0948d841-b0eb-8281-455a-92f44586e0c0@nbd.name>
 <20221108094018.6cspe3mkh3hakxpd@skbuf>
 <a9109da1-ba49-d8f4-1315-278e5c890b99@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a9109da1-ba49-d8f4-1315-278e5c890b99@nbd.name>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 08, 2022 at 10:46:54AM +0100, Felix Fietkau wrote:
> I think it depends on the hardware. If you can rely on the hardware always
> reporting the port out-of-band, a generic "oob" tagger would be fine.
> In my case, it depends on whether a second non-DSA ethernet MAC is active on
> the same device, so I do need to continue using the "mtk" tag driver.

It's not only about the time dimension (always OOB, vs sometimes OOB),
but also about what is conveyed through the OOB tag. I can see 2 vendors
agreeing today on a common "oob" tagger only to diverge in the future
when they'll need to convey more information than just port id. What do
you do with the tagging protocol string names then. Gotta make them
unique from the get go, can't export "oob" to user space IMO.

> The flow dissector part is already solved: I simply used the existing
> .flow_dissect() tag op.

Yes, well this seems like a generic enough case (DSA offload tag present
=> don't shift network header because it's where it should be) to treat
it in the generic flow dissector and not have to invoke any tagger-specific
fixup method.
