Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C76306BACB7
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 10:55:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232160AbjCOJzU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 05:55:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232273AbjCOJy4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 05:54:56 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D6F9848D6;
        Wed, 15 Mar 2023 02:53:12 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id fd5so39218467edb.7;
        Wed, 15 Mar 2023 02:53:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678873990;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=9/vlzq3wEcPhHmbepwTf2BRSLdGIOO/T9TrZasZc+SE=;
        b=Su7Ec/3XrB6ZmPAtelisn25HqbpbRWnTpdR4ySLnyMdruLKLMSMt+ZmwRc6tWzEspJ
         zCWS7fyJ0+TFbUn34ohNkQ+/8uhd1GyWAHDr90ktgyDHH02zzestS/YKXXC/J69Ywe4Z
         lsN+L1LrDGiQGGasnblP5Mfo6WQ472P3ggBl8wBspmvsjjUNCEUIVYbZRnDH5y35yNGA
         WMpKQgTyBOkB51FO/MPrGCego72ugrtRQWft9IfZZ1R0JBSGKuXzEqFfKk+F8exV+dX7
         cFa8SE4qfJUKfI0Gru+LlLOAnwmWHIGlMhDVX5CH1+o9FV3AsZaZ36eM52cSgNwSyu/b
         zgwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678873990;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9/vlzq3wEcPhHmbepwTf2BRSLdGIOO/T9TrZasZc+SE=;
        b=lLwRjM8JhPoP5iLLoi4E9t3lnP1iGCfmycb+G5F2TnDAr9UNJRTU0ysvaCbUPs8OOg
         7EAGQkKm+/+BkHAcnom2Y/5ri28fqT+c4UISRkADMEy/cVJ9lPED2IXXMe8wnJHd12Nr
         Q+x7omD+RoQmN9oU31IUaYNPflKwOflWnRtLslog/QSQ8mvQkNhCeZ4VYZD1iPnfmj+G
         1d6yXq716uqBQE5pAslrViEOWHGujDHmv0om8/rLaNdRreAwvUBLKUlX3i3Rpp+JHT19
         X+nHw7vqFAzozKiACGzXpgV9btbRHzBX+J4qaPfkXXysQXDUxmtEk8hGVLvqfFxd245n
         fddQ==
X-Gm-Message-State: AO0yUKWgyu3X2Uluvy4xIQS0XwkZ2mEI2UhjeEjPfEqlDJIGgToBpZv5
        1OK0t7TbQ9xwupPiC7RyFXchQjjJvkmrOA==
X-Google-Smtp-Source: AK7set/x+o0/wMF1ENn2dSkTLuCSedoyY6Zv1/wIsdVW0+abtr2Rh1Wj/jM7rq6aX/tq1PqZgOlNhQ==
X-Received: by 2002:a17:907:385:b0:8f1:da18:c6ca with SMTP id ss5-20020a170907038500b008f1da18c6camr5043454ejb.3.1678873989971;
        Wed, 15 Mar 2023 02:53:09 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id gy11-20020a170906f24b00b008b17de9d1f2sm2279775ejb.15.2023.03.15.02.53.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 02:53:09 -0700 (PDT)
Date:   Wed, 15 Mar 2023 11:53:07 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Klaus Kudielka <klaus.kudielka@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH] net: dsa: mv88e6xxx: don't dispose of Global2 IRQ
 mappings from mdiobus code
Message-ID: <20230315095307.e7uuxlpnz4lq3swh@skbuf>
References: <20230314182659.63686-1-klaus.kudielka@gmail.com>
 <20230314182659.63686-2-klaus.kudielka@gmail.com>
 <ed91b3db532bfe7131635990acddd82d0a276640.camel@gmail.com>
 <20230314200100.7r2pmj3pb4aew7gp@skbuf>
 <e3ae62c36cfe49abc5371009ba6c29cddc2f2ebe.camel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e3ae62c36cfe49abc5371009ba6c29cddc2f2ebe.camel@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 15, 2023 at 07:07:57AM +0100, Klaus Kudielka wrote:
> On Tue, 2023-03-14 at 22:01 +0200, Vladimir Oltean wrote:
> > 
> > I'm a bit puzzled as to how you managed to get just this one patch to
> > have a different subject-prefix from the others?
> 
> A long story, don't laugh at me.
> 
> I imported your patch with "git am", but I imported the "mbox" of the
> complete message. That was the start of the disaster.
> 
> The whole E-mail was in the commit message (also the notes before the
> patch), but that was easy to fix.
> 
> After git format-patch, checkpatch complained that your "From" E-mail
> != "Signed-off-by" E-mail. Obviously git has taken the "From" from the
> first E-mail header.
> 
> I looked again at your patch, there it was right, and there was also
> a different date (again same root cause).
> 
> So I took the shortcut: Just copy/pasted the whole patch header into
> the generated patch file, without thinking further -> Boom.
> 
> (a) Don't use "git am" blindly
> (b) Don't take shortcuts in the process

Ok, so you need to go through the submission process again, to get it right.
We don't want to accept patches which were edited in-place for anything
other than the change log (the portion between "---" and the short
diffstat, which gets discarded by git anyway). The patches that are
accepted should exactly match the patches from your working git tree.
Also, netdev maintainers extremely rarely edit the patches that they
apply, to avoid introducing traceability issues.
