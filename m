Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A8E966A0F0
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 18:45:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229808AbjAMRpE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 12:45:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230315AbjAMRoj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 12:44:39 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0510F801F8
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 09:32:06 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id b9-20020a17090a7ac900b00226ef160dcaso23313718pjl.2
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 09:32:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XVnLHHo48N4X0rBFMBvhdxO1Y7Dk3ROmqzRUxVRtK/s=;
        b=HtXud1rLxFVNr5f3xf5/SHj2a47laUZH4UdYFlg+uXi4Il0MK5EMSwmBpFAb3CzWo8
         jzlJ4VmAz8EX4yYz2abwULHPpQUt+QuMXlxsqFeGTrVBMmFZlpVzYTV6gQ/HdYcBVXIG
         nLHmyaE3eAT1MDTWNjBjxZlW7hIN6VNrrEZu9DsuTgDZZWOSkPNN+wHHBm9LtRjHC/zQ
         IsfTKyOuCarrh7N6BxBB7SNetlMCObs5pS3Uhp53KpoPcT8rPLbltIqjKwh/iEcQ6JC6
         hp8/EdzhOxwaw7yfXU0FNEuvcd4BekTp6CBLJ6ZApm72ZJTPDRY6t5p1dJWojRcrNfB8
         GxLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XVnLHHo48N4X0rBFMBvhdxO1Y7Dk3ROmqzRUxVRtK/s=;
        b=GKmFza/mfc3p6FhiXW1tk/3DGlElqSMqDztEeoGDKidVuKy5EDDDaaua4RjzNqbcNw
         gu8IQ2prtCEC5KfXL6LDt/xykOZYg5A2DNpgcpTpDb1omV5yvimMvKA5Lyka+Gng8rxl
         VW7XgF18eCvY5EMVvStexaRPhNU/2b0fxcPjp+tY6KV+hc/pp/lU92E4ap7TTbW8Rbnj
         G1S/2tb+HRSt7jRVoYuuDFVzfZ+iRlZ6sAvUWBIZZSqxjkO1GdV4fx+hrQDLwSc7GNvq
         iiwugRAo1ILCZQcLpk6G+wyMHCOgXojxGCMkod/O4SB1VtYK3p1tGZZfkdDvq0E7y4kl
         OHDQ==
X-Gm-Message-State: AFqh2krqjS2ScKpm5+8aFpvuqVF0G3ciLqSzqXsnQcyEPcLZvFF0jdMD
        edFF6mlcv2voljx+0HougexDifDHkM7KipG67+c=
X-Google-Smtp-Source: AMrXdXtn9FrL0XvK+CQiXw3YQEIiR9d+w8sfVzo6q9KBGxaVS7Eqdswt9burBfCSUKxdZI7/WPjCnQ==
X-Received: by 2002:a17:902:6b89:b0:189:cf92:6f5c with SMTP id p9-20020a1709026b8900b00189cf926f5cmr84371882plk.52.1673631125480;
        Fri, 13 Jan 2023 09:32:05 -0800 (PST)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id s14-20020a170902ea0e00b001926bff074fsm14367308plg.276.2023.01.13.09.32.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jan 2023 09:32:05 -0800 (PST)
Date:   Fri, 13 Jan 2023 09:32:03 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH iproute2 09/10] tc: use SPDX
Message-ID: <20230113093203.50235913@hermes.local>
In-Reply-To: <Y8Ez09UmY9qzMlfi@corigine.com>
References: <20230111031712.19037-1-stephen@networkplumber.org>
        <20230111031712.19037-10-stephen@networkplumber.org>
        <Y8Ez09UmY9qzMlfi@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 13 Jan 2023 11:34:59 +0100
Simon Horman <simon.horman@corigine.com> wrote:

> On Tue, Jan 10, 2023 at 07:17:11PM -0800, Stephen Hemminger wrote:
> > Replace GPL boilerplate with SPDX.
> > 
> > Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>  
> 
> ...
> 
> >  #include <stdio.h>
> > diff --git a/tc/q_atm.c b/tc/q_atm.c
> > index 77b56825f777..07866ccf2fce 100644
> > --- a/tc/q_atm.c
> > +++ b/tc/q_atm.c
> > @@ -3,7 +3,6 @@
> >   * q_atm.c		ATM.
> >   *
> >   * Hacked 1998-2000 by Werner Almesberger, EPFL ICA
> > - *
> >   */
> >  
> >  #include <stdio.h>  
> 
> Maybe add an SPDX header here?
> I assume it is GPL-2.0-or-later.
> Or is that pushing our luck?
> 
> >  #include <stdio.h>
> > diff --git a/tc/q_dsmark.c b/tc/q_dsmark.c
> > index d3e8292d777c..9adceba59c99 100644
> > --- a/tc/q_dsmark.c
> > +++ b/tc/q_dsmark.c
> > @@ -3,7 +3,6 @@
> >   * q_dsmark.c		Differentiated Services field marking.
> >   *
> >   * Hacked 1998,1999 by Werner Almesberger, EPFL ICA
> > - *
> >   */
> >  
> >  #include <stdio.h>  
> 
> Ditto.

Both q_dsmark.c and q_atm.c for 1st pass on using SPDX
and both had no previous specific license text.

At the time, my arbitrary decision was that if no other license
was specified the original author expected that the code would
be GPL2.0 only like the kernel.
