Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBF78590E3C
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 11:38:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238091AbiHLJim (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 05:38:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232592AbiHLJik (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 05:38:40 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D14FAA3DA;
        Fri, 12 Aug 2022 02:38:40 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id z16so564690wrh.12;
        Fri, 12 Aug 2022 02:38:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date:from:to:cc;
        bh=ERTAjE4YBXwlIAPuQ54C7Q9lp+2azDksoI412fuEdqY=;
        b=WE9+dHKahuSirjgmF6WXBaHxhhYsKgO2bSeBxRGrYgs38X9K6ev+KamaCiVxcj/uvA
         j9K/6BXpNcRgyG/3UZ/uCKqeHMSlVBDh/O42Mu1j2vVlLeKD+OsvLAFTyi3uVRuhlTck
         GvL1LYQxof0tQEXwClk/KKbROlRMQN+YiXCmIKu9WXg7zQvG/nl+WcxzRzwK0E4XM5wY
         dctVdcnTlfnVxNnZLPIurd+gC0rL/5B3AlFSj2g4XxuhJp9JDsG4tfHhmyC8BFiGkzKW
         PY1oJSXjDXjkg7EClEb2Rs4TiqPZSks2MgL2Jw64MU6fmYhsfsMuAmAUBkFrLKVjt5p9
         pVlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc;
        bh=ERTAjE4YBXwlIAPuQ54C7Q9lp+2azDksoI412fuEdqY=;
        b=3WkOR9ypDeredXsaySz4DWHIHjzy4f1BH8c2jL3HmI72dlFOfYQ9tliZRkUlT+6QT9
         l+h0MeaGYPnPfhutqZHRzcTn7QBLVFYO7jgadvvT0zOFw0Vz1179vVtnr6hYbk4pREgx
         S6hRqnwfwOtHTCWNv+SDBld0suZCABHEsIYlruLnasQZpbjqN1BJN1MCycH2xn59mXb/
         ulL8NnBSQWy21CN/OwSiqr0tMJR3b32UGOgJUAcrlsdBlI2zozL8ZofYCg5w7UC958FT
         FPgb9cmwp7HNAtl+xWWKVLoH4Kw5y0ibUFIrpXsB5OLf4/sz9XkFNG03CLwuM23av34e
         BWwA==
X-Gm-Message-State: ACgBeo2U3i8qNaMTd17i2F6gNLjiP9+jQRi1d5eyA5wMQufVv06x3Hba
        XMQr3rZ7wIW3fj4j7HnFKa3BnGMGpQ4=
X-Google-Smtp-Source: AA6agR4gihiQ5+Svk3TasYVDnVOKo7mZeeXtENUCd/WvNr3gUCwruGgcgmkD8EYL01EdKV2xOOzE8w==
X-Received: by 2002:a5d:6da5:0:b0:222:4634:6a4e with SMTP id u5-20020a5d6da5000000b0022246346a4emr1628955wrs.172.1660297118487;
        Fri, 12 Aug 2022 02:38:38 -0700 (PDT)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id q64-20020a1c4343000000b003a2cf1ba9e2sm2235602wma.6.2022.08.12.02.38.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Aug 2022 02:38:37 -0700 (PDT)
Date:   Fri, 12 Aug 2022 10:38:35 +0100
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Bjorn Helgaas <helgaas@kernel.org>, davem <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        netdev <netdev@vger.kernel.org>, ecree.xilinx@gmail.com,
        linux-pci@vger.kernel.org,
        virtualization <virtualization@lists.linux-foundation.org>,
        mst <mst@redhat.com>
Subject: Re: [PATCH net-next v2 0/2] sfc: Add EF100 BAR config support
Message-ID: <YvYfmw44gpuqexYz@gmail.com>
Mail-Followup-To: Jakub Kicinski <kuba@kernel.org>,
        Bjorn Helgaas <helgaas@kernel.org>, davem <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, Eric Dumazet <edumazet@google.com>,
        netdev <netdev@vger.kernel.org>, ecree.xilinx@gmail.com,
        linux-pci@vger.kernel.org,
        virtualization <virtualization@lists.linux-foundation.org>,
        mst <mst@redhat.com>
References: <165719918216.28149.7678451615870416505.stgit@palantir17.mph.net>
 <20220707155500.GA305857@bhelgaas>
 <Yswn7p+OWODbT7AR@gmail.com>
 <20220711114806.2724b349@kernel.org>
 <Ys6E4fvoufokIFqk@gmail.com>
 <20220713114804.11c7517e@kernel.org>
 <Ys/+vCNAfh/AKuJv@gmail.com>
 <20220714090500.356846ea@kernel.org>
 <CACGkMEt1qLsSf2Stn1YveW-HaDByiYFdCTzdsKESypKNbF=eTg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACGkMEt1qLsSf2Stn1YveW-HaDByiYFdCTzdsKESypKNbF=eTg@mail.gmail.com>
X-Spam-Status: No, score=1.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FSL_HELO_FAKE,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

FYI, during my holiday my colleagues found a way to use the vdpa tool for this.
That means we should not need this series, at least for vDPA.
So we can drop this series.

Thanks,
Martin

On Wed, Aug 03, 2022 at 03:57:34PM +0800, Jason Wang wrote:
> On Fri, Jul 15, 2022 at 12:05 AM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Thu, 14 Jul 2022 12:32:12 +0100 Martin Habets wrote:
> > > > Okay. Indeed, we could easily bolt something onto devlink, I'd think
> > > > but I don't know the space enough to push for one solution over
> > > > another.
> > > >
> > > > Please try to document the problem and the solution... somewhere, tho.
> > > > Otherwise the chances that the next vendor with this problem follows
> > > > the same approach fall from low to none.
> > >
> > > Yeah, good point. The obvious thing would be to create a
> > >  Documentation/networking/device_drivers/ethernet/sfc/sfc/rst
> > > Is that generic enough for other vendors to find out, or there a better place?
> >
> > Documentation/vdpa.rst ? I don't see any kernel level notes on
> > implementing vDPA perhaps virt folks can suggest something.
> 
> Not sure, since it's not a vDPA general thing but a vendor/parent
> specific thing.
> 
> Or maybe Documentation/vdpa/sfc ?
> 
> Thanks
> 
> > I don't think people would be looking into driver-specific docs
> > when trying to implement an interface, so sfc is not a great option
> > IMHO.
> >
> > > I can do a follow-up patch for this.
> >
> > Let's make it part of the same series.
