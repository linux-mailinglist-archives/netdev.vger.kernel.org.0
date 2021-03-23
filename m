Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE5613456A1
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 05:18:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbhCWERi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 00:17:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbhCWERK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 00:17:10 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E771C061574;
        Mon, 22 Mar 2021 21:17:10 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id n11so10417705pgm.12;
        Mon, 22 Mar 2021 21:17:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=CUX3mLQWrZfnyxdTSeCG3Sj7YKQRqZrfDF48jRcdMOg=;
        b=Ja/S0tV/SRAeSgHwdw3vK1MNNCSKdgNrd4rq0qwI+vutZrYyUtx8vwTz4utgJsGk8T
         lBpdejYddDuaLdR5XQUfHWZHcWcTHsJTLKJnr2QcbcnhrI8uo0D6n6kby+tIPKtk9Ego
         kWVU6WaV4f5hrV8U6F6EXF7iGKj3oQLCOF1EpXv0E8cWw/Pseob4Kzv/DReQOmA0rKC2
         aUET/7hoGrv7v8jozzOWMrAZYNcxIrUhTUE3nW4nEXiop4WRjv2Iw7oT+DGR3y0BbrOg
         tmcmiH3jUWW4BisYrUXuqOcC0ce81vtSr0kquLA5anJLqy1XYYUXvd5o67Frs48QUmKr
         HyNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=CUX3mLQWrZfnyxdTSeCG3Sj7YKQRqZrfDF48jRcdMOg=;
        b=l6U5A8Yv8ewkt67KVPHZLaKqxCg5ZuAIgehBNfSu8KvJyew3HLqdODTkmFHi41bUdM
         auAqoNUrGcyo0m4vE0TSQGMJtzFagFm4XpJxVzRkgZ6L8P8Z+IJ9pNS6JxnX+AGham+G
         f5+yUlX8mBw1xmVvMiCp2y+lL4mGh4K/nkwKwOxnGmmX6YS0yKcu/LaV0O37esEc2JhW
         OyhoyV2BKe91UD+IEmXM38rB164YoIjikMihKxPMN4go33xp/dCjoD2Yqi9Ipy67+UUd
         5VwfqGHExnGhHcod4NyBh3+/kVp0MLJgm3xgG1Cy/KZw7aB7+ubWO42MhihpKUQa+uqe
         rK9g==
X-Gm-Message-State: AOAM531dGk5sL6Ii672OqsffUEi2CMSyJyy1y9uG7C2xIYHUXMn9JZVc
        e6IysZbX7LqsvsdA55c4Afn7MW0j5cLaoA==
X-Google-Smtp-Source: ABdhPJw2iM5Godyx1NKH/CekPRZlUpMb2ROBXPNMM9MyrR9xlXknQJwkQuISrS3SaivsUfFFxD/QJw==
X-Received: by 2002:a65:430b:: with SMTP id j11mr2432448pgq.143.1616473030034;
        Mon, 22 Mar 2021 21:17:10 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:48:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id i8sm861786pjl.32.2021.03.22.21.17.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 21:17:09 -0700 (PDT)
Date:   Mon, 22 Mar 2021 21:17:07 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     Miroslav Lichvar <mlichvar@redhat.com>,
        intel-wired-lan@lists.osuosl.org, andre.guedes@intel.com,
        linux-pci@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [Intel-wired-lan] [PATCH next-queue v2 3/3] igc: Add support for
 PTP getcrosststamp()
Message-ID: <20210323041707.GB25323@hoboy.vegasvil.org>
References: <20201114025704.GA15240@hoboy.vegasvil.org>
 <874klo7pwp.fsf@intel.com>
 <20201117014926.GA26272@hoboy.vegasvil.org>
 <87d00b5uj7.fsf@intel.com>
 <20201118125451.GC23320@hoboy.vegasvil.org>
 <87czvrkxol.fsf@vcostago-mobl2.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87czvrkxol.fsf@vcostago-mobl2.amr.corp.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 22, 2021 at 08:36:26AM -0700, Vinicius Costa Gomes wrote:
> After a long time, a couple of internal misunderstandings, fixing some
> typos in the delay adjustment constants and better error handling, this
> one shot method is working well.
> 
> I will propose a new version, implementing PTP_SYS_OFFSET_PRECISE using
> the one shot way.

+1
