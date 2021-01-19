Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1F512FAEB5
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 03:21:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405809AbhASCVa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 21:21:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405608AbhASCV3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 21:21:29 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 300C9C061573
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 18:20:48 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id x12so9629700plr.10
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 18:20:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/cwIO+WolBwS0/c4/AFhWb3AHfCE0CzYH8h0XaZ0qXw=;
        b=BcwUhUiCZtyxCrdwC0M71uBIC7IO2Wb4OAgyilhuwCUsqOORSlKGMjCcb9YSczIU2a
         JvFs6JKxsCb5BGyQBWuaR1w0Zf4xtXWR0G6yBM56a5QNbg4TKbftOmp+zNSGOMRyEIFz
         O87U2wJ2OZeTdcaTxFJ5Tq/5y4T+kplPkiREanvDpT/xU8XMmxXJvBLR0+Q+vYSyXQpg
         mjkl9MlzU0qDqy7d301nIUh/mLWglxYS+0wSgMV1Wc1J3HAuapmaNzfczNFDVeIZ0Dcc
         +JHOuH8serQym7t/xeupCJnbhuMeLSFq62UcTtm5+v3N4qOJ3ykMOiwjL4yM9Y1e2EA8
         wn1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/cwIO+WolBwS0/c4/AFhWb3AHfCE0CzYH8h0XaZ0qXw=;
        b=ck4hKBM1Qg3rgpNKXwczjgxsEI5z7LjLT5fASP1845RR4DsWlQ8QF4S/8L7uDcJI+6
         zkM7FMp1w0gnkhdsRCbP7G/XkjJapskUjMEB7Q4LYnueGePRU2XfOCsGm9rKB2Dj5xJO
         2DN6dISzE30qNea6ZHwTBs3ILzDkd6UwO4vgcsBFbIRlmU0qP06tXv93sc+PB+sFFzdS
         IEVycsGq/03EYXDCqmigPfkuHXbIsljjLyQbzgIv7KSoDNPZo1bGuF9CEYfMPapH3emn
         JuGS1oEcWd9anwCFzqUCZhzNzOBL1l5m4XTVehjVe9uOhoknByEDW7xYl218dm9n5tUq
         rcjQ==
X-Gm-Message-State: AOAM532lXXCqqkympVbxXRybujQ6KZ3E2MkKD1PCrjcaRQjYyVqT41oJ
        8qEDd5hv0RUlXYYKckwfUd1PaYSnNOG7nXpb
X-Google-Smtp-Source: ABdhPJyQZp7EjEf2/NdLjrVcNyrUdhJCdeGmDYOwKEG/FCkE6nxdFihdIlSLDloIUs0JEA0I38fLkw==
X-Received: by 2002:a17:90a:b28f:: with SMTP id c15mr2458467pjr.79.1611022847728;
        Mon, 18 Jan 2021 18:20:47 -0800 (PST)
Received: from hermes.local (76-14-222-244.or.wavecable.com. [76.14.222.244])
        by smtp.gmail.com with ESMTPSA id f7sm655372pjs.25.2021.01.18.18.20.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jan 2021 18:20:47 -0800 (PST)
Date:   Mon, 18 Jan 2021 18:20:44 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Raju Rangoju <rajur@chelsio.com>
Cc:     netdev@vger.kernel.org, hch@lst.de, rahul.lakkireddy@chelsio.com
Subject: Re: how to determine if buffers are in user-space/kernel-space
Message-ID: <20210118182044.26d59491@hermes.local>
In-Reply-To: <20210118182636.GB15369@chelsio.com>
References: <20210118182636.GB15369@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 18 Jan 2021 23:56:37 +0530
Raju Rangoju <rajur@chelsio.com> wrote:

> Hi,
> 
> We have an out-of-tree kernel module which was using
> segment_eq(get_fs(), KERNEL_DS) to determine whether buffers are in
> Kernel space vs User space. However, with the get_fs() and its friends
> removed[1], we are out of ideas on how to determine if buffers are in
> user space or kernel space. Can someone shed some light on how to
> accomplish it?
> 

Sorry, you are asking in the wrong place. Supporting any out of
tree modules is completely your own problem to deal with.
