Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 176AF403003
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 22:55:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346230AbhIGU47 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 16:56:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbhIGU46 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Sep 2021 16:56:58 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE334C061575
        for <netdev@vger.kernel.org>; Tue,  7 Sep 2021 13:55:51 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id t20so90525pju.5
        for <netdev@vger.kernel.org>; Tue, 07 Sep 2021 13:55:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VMaFeakMiWu8ETGTfLee0y6jJnQCckRuTalFED7KEP0=;
        b=uhd/+D3Opjq+HGaJx564mvHn8yiZ3MMEeISdH2AWltkpvMYkCvBJNfOsIC5Tvnc7ds
         Kapy5eKbk2eJZcT6CQUYDK3tnvUjaV+DjByDzBnmBwmX7iQyuFCqWHLbCxxuQIA/64GR
         4YLRBsbdG2EwNXZr/g/yxqW/d45udhI7ruWQNvGqT0YnyS7ucJ/H0tivY887/EcFypnB
         ekBCJM2F5EvRnmnjBdewKj0sQl6V98CkK/VVszdp+4fgbsQ6hyanoxgZxr/hOkP1fx9E
         yOJvgjGY/FuzK7AewNi5mElM310nmqbSkq9q0tMcxbPxW/PKJ+hdL9MD1m2TYxcl1S04
         QzAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VMaFeakMiWu8ETGTfLee0y6jJnQCckRuTalFED7KEP0=;
        b=ekgxUw2HpNIu5qYrvcVDOVn1ESm3KngnPclVDYShjCeAppLhCkSmijJy4oJWeNG7F2
         yDMVeBmR0J7D3Q0lHuVj7bJgIkmTlBcwrgaiRAOG6vNzRA3stW9MeGuOGF/kyk9GAvVY
         0OLWliVJSdUAED5QczaLy5XsSa0lnDGHeYSaYi5AUIFS/RyH9DA5WEuBhB7QxCczxW+u
         4loUMFStoOrIb5plKDzZAvY5CnwkLpS4Lv9uHifAom0JCbaaHWylxQtUQNZ5L7l6dxho
         mqJ0ZnScqEuNwsrK3tGPyfOw/eHihb0LI925OpBMA9kwfLDl37xe3W7kPnzBLvIla/uJ
         5RrQ==
X-Gm-Message-State: AOAM5318/ri4TvwIyqLGPPgL0sr7zooVzZPstKGiyKmRpcv1J/tMqXgv
        UZxMTJEXoAJbnzjJzdO9YvfTdA==
X-Google-Smtp-Source: ABdhPJzKDvSntjSgbAimi5GlRW0QnIumZPw8PCdyxr6E0JkXioUFZ3iVzdQTyezcWCUy4+kbwAnUJQ==
X-Received: by 2002:a17:902:bd86:b0:13a:21a6:d989 with SMTP id q6-20020a170902bd8600b0013a21a6d989mr12812pls.15.1631048151445;
        Tue, 07 Sep 2021 13:55:51 -0700 (PDT)
Received: from hermes.local (204-195-33-123.wavecable.com. [204.195.33.123])
        by smtp.gmail.com with ESMTPSA id s15sm20267pfu.67.2021.09.07.13.55.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Sep 2021 13:55:51 -0700 (PDT)
Date:   Tue, 7 Sep 2021 13:55:48 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Thorsten Glaser <t.glaser@tarent.de>
Cc:     Wen Liang <liangwen12year@gmail.com>, netdev@vger.kernel.org,
        dsahern@gmail.com, aclaudi@redhat.com
Subject: Re: [PATCH iproute2 1/2] tc: u32: add support for json output
Message-ID: <20210907135548.01bab77e@hermes.local>
In-Reply-To: <f9752b7-476-5ae6-6ab4-717e1c8553bb@tarent.de>
References: <cover.1630978600.git.liangwen12year@gmail.com>
        <5c4108ba5d3c30a0366ad79b49e1097bd9cc96e1.1630978600.git.liangwen12year@gmail.com>
        <20210907122914.34b5b1a1@hermes.local>
        <f9752b7-476-5ae6-6ab4-717e1c8553bb@tarent.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 7 Sep 2021 21:32:41 +0200 (CEST)
Thorsten Glaser <t.glaser@tarent.de> wrote:

> On Tue, 7 Sep 2021, Stephen Hemminger wrote:
> 
> > Space is not valid in JSON tag.  
> 
> They are valid. Any strings are valid.

Your right the library is quoting them, but various style guidelines
do not recommend doing this.
