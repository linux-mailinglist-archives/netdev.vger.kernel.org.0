Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFA3F1DE4F7
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 13:00:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728800AbgEVLAg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 07:00:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728371AbgEVLAd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 07:00:33 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D39A1C061A0E
        for <netdev@vger.kernel.org>; Fri, 22 May 2020 04:00:32 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id e16so9722299wra.7
        for <netdev@vger.kernel.org>; Fri, 22 May 2020 04:00:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=eH7JDwxswS/HOwdEPFW7cD71VLZqs3i6V5BQWFnwrpY=;
        b=FFgsY70w/YAWfaYUrNoJAqdf7ZqIU8jyAhLJXx2vjW/mswpBhJ1c2YI8OP3c2SQeai
         qPHOSZmPFWrHI9Rop13ku5z/1+xTjHd9p9/x1gwHDB6iihB9LgOtLE0Q+x0MZirQF+v+
         UeFs6pNDCJ7M0YxdqoUrTWIlz2GSih/JKDpZkqcNz50NjDJjvmtqbCPyebrkA/N0Taj0
         uN2u5mxvEGbZCS6Ys1FMUq/g/fC1DOmf1Rl6BK3KWE4ODbrk8ZtvxpB6nF7uigWwWZiz
         PaG1ZexcbIfGSLzdWT2g+syVSes7mGufSlPG8Sz4PoDBw2slBKb43CJbpBYBY+Rz0G6I
         +mPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=eH7JDwxswS/HOwdEPFW7cD71VLZqs3i6V5BQWFnwrpY=;
        b=R6og7EArpq0psN07WZ28nXTMNzCnnQFq/riMOJuELkxNZhI7R4rMbDkNrHN0/4G4Hr
         NaQY5RBils9EHxQMegpwrlMhMyZLrzPZRowxynkfiEg73ZVsD+fiofSw8yPDmbJn8NBn
         pXjMaWDQnd11HECHJKkKGtISmaSfRLyRrda2gdtFQhFGY/sPd+Jgs1bSAkUFDf1/nHgr
         MlU+VgL03H+e/Met08+E0bJs6bNdlS7NDn84x8NHol3SlSWPzGjl2Q7F6t2zM/4OmVoo
         dnHFiuipKe+fab3358s4+TEJkJyklBf8ioOayu56xKT7yB79jCeepUwuPrIK1mNLM3m+
         Qiqw==
X-Gm-Message-State: AOAM533xc0VNvHTUqbrvGiUeD3aLzmDQ35syTwkkNnzbr3v3B8VV+yzF
        dyG/kCbyycXFKQB5HKYyLCRvJw==
X-Google-Smtp-Source: ABdhPJy3aUJdQZGVkaohSsr4Ys3+Rr/ZlDi2Da2SjSr82CmYx5+q/UFUqCueKyTMUS09fOWeyoJvow==
X-Received: by 2002:a5d:5682:: with SMTP id f2mr2845727wrv.382.1590145230537;
        Fri, 22 May 2020 04:00:30 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id f5sm9489627wro.18.2020.05.22.04.00.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 May 2020 04:00:29 -0700 (PDT)
Date:   Fri, 22 May 2020 13:00:28 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        Ido Schimmel <idosch@idosch.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        petrm@mellanox.com, amitc@mellanox.com
Subject: Re: devlink interface for asynchronous event/messages from firmware?
Message-ID: <20200522110028.GC2478@nanopsycho>
References: <fea3e7bc-db75-ce15-1330-d80483267ee2@intel.com>
 <20200520171655.08412ba5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <b0435043-269b-9694-b43e-f6740d1862c9@intel.com>
 <20200521205213.GA1093714@splinter>
 <239b02dc-7a02-dcc3-a67c-85947f92f374@intel.com>
 <20200521145113.21f772bf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200521145113.21f772bf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, May 21, 2020 at 11:51:13PM CEST, kuba@kernel.org wrote:
>On Thu, 21 May 2020 13:59:32 -0700 Jacob Keller wrote:
>> >> So the ice firmware can optionally send diagnostic debug messages via
>> >> its control queue. The current solutions we've used internally
>> >> essentially hex-dump the binary contents to the kernel log, and then
>> >> these get scraped and converted into a useful format for human consumption.
>> >>
>> >> I'm not 100% of the format, but I know it's based on a decoding file
>> >> that is specific to a given firmware image, and thus attempting to tie
>> >> this into the driver is problematic.  
>> > 
>> > You explained how it works, but not why it's needed :)  
>> 
>> Well, the reason we want it is to be able to read the debug/diagnostics
>> data in order to debug issues that might be related to firmware or
>> software mis-use of firmware interfaces.
>> 
>> By having it be a separate interface rather than trying to scrape from
>> the kernel message buffer, it becomes something we can have as a
>> possibility for debugging in the field.
>
>For pure debug/tracing perhaps trace_devlink_hwerr() is the right fit?

Well, trace_devlink_hwerr() is for simple errors that are mapped 1:1
with some string. From what I got, Jacob needs to pass some data
structures to the user. Something more similar to health reporter dumps
and their fmsg.

