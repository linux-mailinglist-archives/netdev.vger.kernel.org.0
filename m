Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 928DD53FA77
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 11:55:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240173AbiFGJzu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 05:55:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240199AbiFGJzr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 05:55:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9A837E7331
        for <netdev@vger.kernel.org>; Tue,  7 Jun 2022 02:55:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654595734;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=n7hfgQiB1fvAohjSL+LX1HTZTS0xE+mT9eAbQ5SA/1g=;
        b=MihyX/iSOfdBU8KnYBBvw+f/By5mDk2JeGv4aWjTkaNkri/TqZddndcrYhMyiu2+LJrXE6
        gxrnnIr5Oaecf1yxFEhFF4D+0ecM8t5cWGZafMi/pLJKOVUSBz2iuM9iipFK2Dbl7xBpUO
        dWX4A6KCVh01KaYKMTBD29iaOi0QCCc=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-619-lQAGkqlaOUO7niFkq0OapA-1; Tue, 07 Jun 2022 05:55:33 -0400
X-MC-Unique: lQAGkqlaOUO7niFkq0OapA-1
Received: by mail-wm1-f72.google.com with SMTP id bi22-20020a05600c3d9600b0039c4144992cso4798026wmb.5
        for <netdev@vger.kernel.org>; Tue, 07 Jun 2022 02:55:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=n7hfgQiB1fvAohjSL+LX1HTZTS0xE+mT9eAbQ5SA/1g=;
        b=iEyoX2874uNz3oTPnAsgGbiynRGHMlk29LiC9j2byDZUAPXfDgREmeIE5n+9VWq0q/
         cNNOnaetQU1mXo/X3Hrrl08aZ4YEhKKN1fNGskUBOjIIw73tAdgvTI2qktpu4qH7wbPM
         g1aGx5aHEQB/9qfXl2tF5Niw62I5GSUl6TjWUau2ioIOcres25doDjdOnb322lWkn8U3
         OKa9GDSEyKnaX5D1JNwZUQJnPAct5+aO7txiUbPYpdBF/e4AbPSIo2aH87QcShSz1wlA
         lPdW1OwliWqlvEcdAkV3Wk8pscVQHD3njboRAWftP310KKfWIM4kDvVEQKQH1AirLWif
         te/w==
X-Gm-Message-State: AOAM531Q4VqVYhnX2tZBRFTBRHzEyVuXanF4aq6Mkxqg8H6t8x9DIE06
        dLgyEES+qB6AlXsoJg174blOzZ2BhsksTEyIcNa/Nv/hQNvitE18mEZCDbNhX+Vrr3jvcYpkLpk
        5YosxtCpZnwH93M0d
X-Received: by 2002:a5d:58c2:0:b0:210:2baa:52b8 with SMTP id o2-20020a5d58c2000000b002102baa52b8mr26772066wrf.20.1654595732389;
        Tue, 07 Jun 2022 02:55:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwmQQjkSNT69Gzr83bM10Ninlkk05aLiBs5DvzsVAimhJHJr7sP1/XRhlCUmbBJ6Rae13u6jQ==
X-Received: by 2002:a5d:58c2:0:b0:210:2baa:52b8 with SMTP id o2-20020a5d58c2000000b002102baa52b8mr26772049wrf.20.1654595732186;
        Tue, 07 Jun 2022 02:55:32 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-112-184.dyn.eolo.it. [146.241.112.184])
        by smtp.gmail.com with ESMTPSA id bi11-20020a05600c3d8b00b0039c3ecdca66sm12636741wmb.23.2022.06.07.02.55.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jun 2022 02:55:31 -0700 (PDT)
Message-ID: <abbda3f0e47a2b2a3a8304cc0486a7c1304581d9.camel@redhat.com>
Subject: Re: [PATCH] stmmac: intel: Fix an error handling path in
 intel_eth_pci_probe()
From:   Paolo Abeni <pabeni@redhat.com>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Wong Vee Khee <vee.khee.wong@linux.intel.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Date:   Tue, 07 Jun 2022 11:55:30 +0200
In-Reply-To: <75b293bd-ec8d-8c90-ffe5-afa49d6a218d@wanadoo.fr>
References: <1ac9b6787b0db83b0095711882c55c77c8ea8da0.1654462241.git.christophe.jaillet@wanadoo.fr>
         <20220606062650.GA31937@linux.intel.com>
         <75b293bd-ec8d-8c90-ffe5-afa49d6a218d@wanadoo.fr>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2022-06-06 at 22:42 +0200, Christophe JAILLET wrote:
> Le 06/06/2022 à 08:26, Wong Vee Khee a écrit :
> > On Sun, Jun 05, 2022 at 10:50:48PM +0200, Christophe JAILLET wrote:
> > > When the managed API is used, there is no need to explicitly call
> > > pci_free_irq_vectors().
> > > 
> > > This looks to be a left-over from the commit in the Fixes tag. Only the
> > > .remove() function had been updated.
> > > 
> > > So remove this unused function call and update goto label accordingly.
> > > 
> > > Fixes: 8accc467758e ("stmmac: intel: use managed PCI function on probe and resume")
> > > Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> > > ---
> > >   drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c | 4 +---
> > >   1 file changed, 1 insertion(+), 3 deletions(-)
> > > 
> > 
> > LGTM
> > 
> > Reviewed-by: Wong Vee Khee <vee.khee.wong@linux.intel.com>
> > 
> > 
> 
> Hi,
> 
> I've looked at it again.
> 
> I still think that the patch is good, but pcim_release() has changed in 
> 5.18 since commit 3f35d2cf9fbc ("PCI/MSI: Decouple MSI[-X] disable from 
> pcim_release()")
> 
> I guess that all the mechanic is in place so that everything is 
> registered when needed, but I've not been able to figure it out in the 
> case of dwmac-intel.c.
> 
> So, double check :).

AFACIS:

stmmac_config_{single,multi}_msi -> pci_alloc_irq_vectors ->
pci_alloc_irq_vectors_affinity -> __pci_enable_msix_range ->
pcim_setup_msi_release

So LGTM, thanks!

Paolo

