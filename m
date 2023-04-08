Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11D866DBC6A
	for <lists+netdev@lfdr.de>; Sat,  8 Apr 2023 20:07:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbjDHR5j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Apr 2023 13:57:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbjDHR5i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Apr 2023 13:57:38 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5B3826AF;
        Sat,  8 Apr 2023 10:57:37 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id q2so6303590pll.7;
        Sat, 08 Apr 2023 10:57:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680976657;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jvEbHjnUF838lN07cBQDokhrXS5LHQhlJGEDy+0X8dg=;
        b=pKaCg9NvbIVEK6K78TRDwr7ES8jioxY4sJm/msDIOVRDyJt+iA1bmB53dmkiZOVL1d
         fOC6DNKI9nUj/jCL38UkC+xWXTwKXzQLBRExgCZ6RQ+2xWDncceniZG9LaIhYY4HzVy3
         L/pamZjnVlGcZ1+N54NEaX5YpYVNnAoRTUFWd5JE5nGQ27nKn3uBuIimLSuuPMjqZ5J6
         CSrcKn5tbqQqQlYEyJfUeFgmJ97xtzDsNwV7w90ErX3Lz/aPgbJ8cka8fImuXYX0AhCW
         5T19DZ53L/uH3KR5juYWxPBzLZCtR86SxXIwqWMCiJgcMgfIe1KZtXAeFgnPdqNzVE4f
         yIXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680976657;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jvEbHjnUF838lN07cBQDokhrXS5LHQhlJGEDy+0X8dg=;
        b=ZcYxqPlxbxJ6Z8TE4w/nQ9B03Ct71MGN6/eH1cjsEcPPMAhekZC4MJ46kW7CBvYuHR
         w0JRtnGgL9VRYK6Tti09SYE2DsIrB1s6zfbhSXTH+YprsFlJvVp2lnVi4BLJzuOoi1jf
         zEU1OmjyO0voIODhgYrrUgHUk2IWW/etfZ4vImyk7jXcbesi+ffrZ1dUzkp/dv+2Ui+i
         oGigUrTGWcrtlcJ8BEpAd1+9vV2g7Lf7wNZitJ2lwS8aO707PhCbmsI2Agq/+aIFjPQ/
         t9r4bJzKSkSjyapGyUBz6hmlB0tj1jZxVusKH3fCM1ghcnsssq51i9k33W9EIN605Eiv
         Ysbg==
X-Gm-Message-State: AAQBX9dpTAkkXZSNxcxQPdPcHYyFTNbJ5YmT9Xs5Lv5Zftds0O1BNxLB
        S0z7cJ9bbzOYLxJVbibiWY8S1M462V5drkf8
X-Google-Smtp-Source: AKy350Z1B6z5jcbAMhr2nmOFpTuBNq3vRV61NMkFifG3bVxk0EXXWJZFza2ZQhnwbrNXiJbTG/UP2g==
X-Received: by 2002:a05:6a20:6014:b0:db:f682:65ed with SMTP id r20-20020a056a20601400b000dbf68265edmr6704234pza.61.1680976657232;
        Sat, 08 Apr 2023 10:57:37 -0700 (PDT)
Received: from sumitra.com ([117.207.136.97])
        by smtp.gmail.com with ESMTPSA id y15-20020aa7804f000000b00590ede84b1csm5178202pfm.147.2023.04.08.10.57.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Apr 2023 10:57:36 -0700 (PDT)
Date:   Sat, 8 Apr 2023 10:57:29 -0700
From:   Sumitra Sharma <sumitraartsy@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Simon Horman <simon.horman@corigine.com>,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com, Coiby Xu <coiby.xu@gmail.com>,
        netdev@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: qlge: Remove macro FILL_SEG
Message-ID: <20230408175729.GA263118@sumitra.com>
References: <20230405150627.GA227254@sumitra.com>
 <ZC2gJdUA6zGOjX4P@corigine.com>
 <20230406144644.GB231658@sumitra.com>
 <2023040648-zeppelin-escapist-86d1@gregkh>
 <20230406152855.GC231658@sumitra.com>
 <2023040618-dedicate-rebalance-90c6@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2023040618-dedicate-rebalance-90c6@gregkh>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 06, 2023 at 06:33:31PM +0200, Greg Kroah-Hartman wrote:
> On Thu, Apr 06, 2023 at 08:28:55AM -0700, Sumitra Sharma wrote:
> > On Thu, Apr 06, 2023 at 04:57:44PM +0200, Greg Kroah-Hartman wrote:
> > > On Thu, Apr 06, 2023 at 07:46:44AM -0700, Sumitra Sharma wrote:
> > > > On Wed, Apr 05, 2023 at 06:21:57PM +0200, Simon Horman wrote:
> > > > > On Wed, Apr 05, 2023 at 08:06:27AM -0700, Sumitra Sharma wrote:
> > > > > > Remove macro FILL_SEG to fix the checkpatch warning:
> > > > > > 
> > > > > > WARNING: Macros with flow control statements should be avoided
> > > > > > 
> > > > > > Macros with flow control statements must be avoided as they
> > > > > > break the flow of the calling function and make it harder to
> > > > > > test the code.
> > > > > > 
> > > > > > Replace all FILL_SEG() macro calls with:
> > > > > > 
> > > > > > err = err || qlge_fill_seg_(...);
> > > > > 
> > > > > Perhaps I'm missing the point here.
> > > > > But won't this lead to err always either being true or false (1 or 0).
> > > > > Rather than the current arrangement where err can be
> > > > > either 0 or a negative error value, such as -EINVAL.
> > > > >
> > > > 
> > > > Hi Simon
> > > > 
> > > > 
> > > > Thank you for the point you mentioned which I missed while working on this
> > > > patch. 
> > > > 
> > > > However, after thinking on it, I am still not able to get any fix to this
> > > > except that we can possibly implement the Ira's solution here which is:
> > > > 
> > > > https://lore.kernel.org/outreachy/64154d438f0c8_28ae5229421@iweiny-mobl.notmuch/
> > > > 
> > > > Although we have to then deal with 40 lines of ifs.
> > > 
> > > Which implies that the current solution is the best one, so I would
> > > recommend just leaving it as-is.
> > >
> > 
> > Hi greg
> > 
> > Before leaving it I would like to know your opinion on the solution Dan is offering.
> 
> I still think you should leave it as-is.
>

Okay, Thank you.


Regards

Sumitra Sharma
> thanks,
> 
> greg k-h
