Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDC37514045
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 03:36:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353948AbiD2BjL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 21:39:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234027AbiD2BjL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 21:39:11 -0400
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 794C9286CD;
        Thu, 28 Apr 2022 18:35:54 -0700 (PDT)
Received: by mail-qt1-x82d.google.com with SMTP id f14so4800175qtq.1;
        Thu, 28 Apr 2022 18:35:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jms.id.au; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ilw3aGv9Sgk1Mrf42CfMBYio0brON0wfqjs2FvsTn5A=;
        b=hc4MzDypJLz0fQuTeRPHPO0wVmSfZFP2kv4Nb4g77/gbVk38gQaUTUSTYDJBiNqcOq
         XAF6s8MjQZK7GMG2tApOYlMz2XiHaGT6WSdaVMxy8a8NlzdFMufvC5bmFaeVH5o8VugB
         7a3Lj1YkckAVXcZKvgHR27HLApC631nuW9wyU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ilw3aGv9Sgk1Mrf42CfMBYio0brON0wfqjs2FvsTn5A=;
        b=eUeLR1oK8QHuwVzcOpQfxuqUFsRjkAO/YDdjrMrmbNZN+WEfFHu+/mkqym78f2cVBU
         zEeG1VV+0od1zH2hSM3AdRQAGA0GMuNzpms/gLF6Jem7P4s0Zd5Gldpy6fOFyrvF+sED
         L4lwDT2UFbtLYQpnT6kUYV3BbLOvARZYII50oL4PAbMGAh6xj9lEKRRGVSs8bpBOQspb
         zyGwEq7fJqv+MKIE2MvHT02n9PB972IdqmycRsd8cMfvK16vEQNjxo5T0oimr5HqlDoa
         kYNfnI0ciplWiHEnTp2TDV/Sb7gMitb9cAjQZP/0DTAnPfkWkrwO7WNr+RbrU1kMdhUq
         QmUA==
X-Gm-Message-State: AOAM530BFRo3ldTNDPvMZD6wVHgy81O7zz47K70HHn8X6A2vLk1eCPl1
        WRgafrPjh8yt0cv8w7TtiWTVvDN344s5lx2kbgLYy7Id
X-Google-Smtp-Source: ABdhPJxEHKDPELY9+OtUNhNNa2CM1I9/hqDSmeDbIFwxGnpwoqaIQ9gDWUojvja9Nn0exFx3iPezziPP2uNOOx+HTws=
X-Received: by 2002:a05:622a:58f:b0:2f2:58:578a with SMTP id
 c15-20020a05622a058f00b002f20058578amr25197132qtb.180.1651196153533; Thu, 28
 Apr 2022 18:35:53 -0700 (PDT)
MIME-Version: 1.0
References: <20220428082858.545176-1-joel@jms.id.au> <Yms5JzcVMKDYpR5H@lunn.ch>
In-Reply-To: <Yms5JzcVMKDYpR5H@lunn.ch>
From:   Joel Stanley <joel@jms.id.au>
Date:   Fri, 29 Apr 2022 01:35:43 +0000
Message-ID: <CACPK8Xeq8MLmRmYW=qo7+FDRG_bwaSTMQtrHhPCwGJ8-ZeFp=A@mail.gmail.com>
Subject: Re: [PATCH net] net: ftgmac100: Disable hardware checksum on AST2600
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Dylan Hung <dylan_hung@aspeedtech.com>,
        David Wilder <dwilder@us.ibm.com>,
        OpenBMC Maillist <openbmc@lists.ozlabs.org>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Wilder <wilder@us.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 29 Apr 2022 at 01:02, Andrew Lunn <andrew@lunn.ch> wrote:
>
> > Fixes: 39bfab8844a0 ("net: ftgmac100: Add support for DT phy-handle property")
> > Reported-by: David Wilder <wilder@us.ibm.com>
> > Signed-off-by: Joel Stanley <joel@jms.id.au>
> > ---
> > Net maintainers, if no one has a counter proposal I would like this
> > merged as a fix. Please give Dylan from Aspeed a chance to reply before
> > applying the patch.
>
> What has phy-handle got to do with this? You might want to add an
> explanation why you picked that as a Fixes: commit, if it is in fact
> correct.

If you have a look at that commit, you can see that was where ast2600
support was added to the driver.
