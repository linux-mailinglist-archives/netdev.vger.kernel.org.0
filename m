Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74F6D57A100
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 16:16:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238337AbiGSOPj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 10:15:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233997AbiGSOP3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 10:15:29 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65D0C4F18C;
        Tue, 19 Jul 2022 06:44:32 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id mf4so27280818ejc.3;
        Tue, 19 Jul 2022 06:44:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=oD0/tmmh2SYshMDeiEQ3PzO3Ao4yC2o+AzCLepDtF1c=;
        b=lhtxbx+kEExP6P0W4TaTduw1nqNqYlJLfNeA16hBVgXPCLQqK03t8cJKwBFpJvj8Jo
         3+F8KqRwotdSlBsyOlL0hi+w+1U70gDJbfc57nodec0VIqMY+WCFAOCUqlmJNkkdPK7Z
         jVAY9ltgqP41WZBS76Zri/oSpsxbpmhjYZ9PSrW5kykE9uA+dFpccGqrn2GRfTibWiCO
         J3ccIigBV4NEc/n7GRcy/tVeBypIBUNflvkf245Lw43OZOBbQq3esUqqjmCun9rWIn+r
         oKH/OuQ74XkgiHXgd7d1i5+EWvt40opobU45TptsqmGtYM1m1uQE5lw+sdswiKQoJSsj
         bkSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oD0/tmmh2SYshMDeiEQ3PzO3Ao4yC2o+AzCLepDtF1c=;
        b=lVgpCsitrs2Ml5BpBRCWcr3oFkZrW1yYvZfOTk6mgWsCNEkVq4UFVDM8RhmG8pQKNz
         bWJSbumwr+4yMox7EKHqwVOy5uF4F4evguAX72dSbYI5/MS4D2UJwbiGrLAfVSQ+tvzx
         SQg7dYM/+vYG/t5KCc5IXz2dnjEibpcYRAhaZ0DlNN7LV5CUyNdNUxLR4aLb691Zy/Ac
         IZZh+ZAN21ukpXIESSpoxt/BH7eXrNtMhD/PmvbuJ8zjlBbmWqoUGhOfW++IbPp5o+dH
         f8ZD5YkTK/9KGpKurIrUBalX0h6aoSA63n4lhNLOoFEym6TvhKGUqWfcxzPtM24Mw7Kd
         f0+Q==
X-Gm-Message-State: AJIora+u0fNjtCz4ZRF/jWEgOQZkkt47Dfd/+H63SLlyM+dmROh9K5EJ
        9pYbFlBRFpHXeSwd+ceIQg8=
X-Google-Smtp-Source: AGRyM1sN8frJRiRTwVdvxtbt/bA+p8fdPQuDNrvcBQ6nfdigOUQOxXRPUMytp5elQSWfT+GqDFzUew==
X-Received: by 2002:a17:907:87b0:b0:72b:9f0d:3f89 with SMTP id qv48-20020a17090787b000b0072b9f0d3f89mr29307197ejc.734.1658238270867;
        Tue, 19 Jul 2022 06:44:30 -0700 (PDT)
Received: from skbuf ([188.27.185.104])
        by smtp.gmail.com with ESMTPSA id q14-20020a17090676ce00b00722e50dab2csm6671879ejn.109.2022.07.19.06.44.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 06:44:30 -0700 (PDT)
Date:   Tue, 19 Jul 2022 16:44:27 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [net-next PATCH v2 15/15] net: dsa: qca8k: drop unnecessary
 exposed function and make them static
Message-ID: <20220719134427.qlqm7xp4yyqs2zip@skbuf>
References: <20220719005726.8739-1-ansuelsmth@gmail.com>
 <20220719005726.8739-1-ansuelsmth@gmail.com>
 <20220719005726.8739-17-ansuelsmth@gmail.com>
 <20220719005726.8739-17-ansuelsmth@gmail.com>
 <20220719132931.p3amcmjsjzefmukq@skbuf>
 <62d6b319.1c69fb81.6be76.d6b1@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <62d6b319.1c69fb81.6be76.d6b1@mx.google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 19, 2022 at 03:35:18PM +0200, Christian Marangi wrote:
> On Tue, Jul 19, 2022 at 04:29:31PM +0300, Vladimir Oltean wrote:
> > On Tue, Jul 19, 2022 at 02:57:26AM +0200, Christian Marangi wrote:
> > > Some function were exposed to permit migration to common code. Drop them
> > > and make them static now that the user are in the same common code.
> > > 
> > > Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> > > ---
> > 
> > Hmm, ideally the last patch that removes a certain function from being
> > called from qca8k-8xxx.c would also delete its prototype and make it
> > static in qca8k-common.c. Would that be hard to change?
> 
> Can be done, it's really to compile check the changes and fix them.
> Problem is that the patch number would explode. (ok explode is a big
> thing but i think that would add 2-3 more patch to this big series...
> this is why I did the static change as the last patch instead of in the
> middle of the series)
> 
> But yes it's totally doable and not that hard honestly.

Why would it add to the patch count? I don't think you understood what I
meant.

Take for example qca8k_bulk_read(). You migrated it in patch 4, but
there was still a user left in qca8k_fdb_read(), which you migrated in
patch 5. After patch 5 and until the last one, the prototype of
qca8k_bulk_read() was essentially dangling, but you only removed it in
the last patch. My request is that you prune the dangling definitions
after each patch that stops using something exported. That won't
increase the number of changes, but eliminate the last one.
Also, it would be great if you could create a dependency graph such that
you could avoid temporarily exporting some functions that don't need to be.
