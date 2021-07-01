Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FDF43B97F5
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 23:06:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234230AbhGAVJW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 17:09:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233893AbhGAVJW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Jul 2021 17:09:22 -0400
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C378C061762;
        Thu,  1 Jul 2021 14:06:50 -0700 (PDT)
Received: by mail-qt1-x833.google.com with SMTP id v10so5164069qto.1;
        Thu, 01 Jul 2021 14:06:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JdZfhD8zS8Li7V1IWr5im/Ov0yGZJzdw3SFKa8tmvaA=;
        b=coFXzdn8+GFRVvzHgAyl5ya90JjlYSnS84Ena2i664mPYGWza2mLyEi8CqvbBO8QoK
         AMKqkrmx7AB/snglYTmG5VrGh4KFMVa7MmrarR+R6xWquwmAObVhKQrwP0YBpq0OWeXZ
         ffUGNPzJd2Q0pR2qmS8V2U7qHuxJPArIgljtleqjf3PwLu85WorQ4hrTVQoQLOCZ2fwb
         zk4mMVfXrcghfDxud6b6JG16Psnajj/rrjufSzS+N1gtQT6TfXL6qfak/ryp5/D0kWmv
         FB23x9kxBbkg4Gmi16pIJJ5sNRXbfXSlqkeMVKEeD9YZLh0MnFAwgshvw+7RY6IdV8Mt
         1wFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JdZfhD8zS8Li7V1IWr5im/Ov0yGZJzdw3SFKa8tmvaA=;
        b=kT8STan2hJsl6HR8nrfeAEga18F/Vu0YCEVNjFphBdsH+q1AruUne+FzsMJ4tNJ1Q2
         s1ZNZRWIRU+pGaGh+U0ITUAVOquKTuQ8jfJFzuC5YqwLyNGiU3aXMEHIDM5NOAUBbg1C
         81eYs0BWD9FZ3FcvktNxFL8GE5nuPvtz/lLiWyhaps+g60l9UGHCCfGIU4lhmiUASC0t
         FZOOw4cjq3JAVYxSLn8w8QrwTF4e6EuB4QPnLeuVLxpMGj1vAfPrwB8vAM172oD2LUee
         vnl4U0TzdOwKbr8MWRQXR0hX6YxW33b9xephDnhsOySIi3oDNxv6rYJQGHIR2BvRBGOB
         5JJQ==
X-Gm-Message-State: AOAM532Wo3nfxKuSyJ9N2IWVAv057evM5MaSWjh1J5EnjKn6TKhnu0Tn
        9Dmo0Bc3m/JYAwU/aW+PFg==
X-Google-Smtp-Source: ABdhPJzJZm7Wwvj9JL2Rw3TI6kf2fUOVVJh1b0RQieFYgctpFerkJ6QWAsaYSREJxI0H7Uuwi4ovZg==
X-Received: by 2002:a05:622a:453:: with SMTP id o19mr1903676qtx.122.1625173609396;
        Thu, 01 Jul 2021 14:06:49 -0700 (PDT)
Received: from PWN (104-9-124-193.lightspeed.sntcca.sbcglobal.net. [104.9.124.193])
        by smtp.gmail.com with ESMTPSA id t62sm431440qkc.26.2021.07.01.14.06.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jul 2021 14:06:49 -0700 (PDT)
Date:   Thu, 1 Jul 2021 17:06:45 -0400
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     Alexander Larkin <avlarkin82@gmail.com>
Cc:     davem@davemloft.net, johan.hedberg@gmail.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org, linux@armlinux.org.uk,
        marcel@holtmann.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Subject: Re: maybe similar bug exists for HCI_EV_INQUIRY_RESULT* like
 [Linux-kernel-mentees] [PATCH v2] net/bluetooth: slab-out-of-bounds read in
 hci_extended_inquiry_result_evt()
Message-ID: <20210701210645.GA14471@PWN>
References: <20200709130224.214204-1-yepeilin.cs@gmail.com>
 <20210701153936.2954886-1-avlarkin82@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210701153936.2954886-1-avlarkin82@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 01, 2021 at 06:39:36PM +0300, Alexander Larkin wrote:
> For the net/bluetooth/hci_event.c , maybe similar bug could be inside
> hci_inquiry_result_with_rssi_evt() that is HCI_EV_INQUIRY_RESULT_WITH_RSSI
> and inside hci_inquiry_result_evt() that is HCI_EV_INQUIRY_RESULT. 

Hi Alexander,

Thanks for looking into this, I believe they were handled in commit
629b49c848ee ("Bluetooth: Prevent out-of-bounds read in
hci_inquiry_result_with_rssi_evt()") and commit 75bbd2ea50ba ("Bluetooth:
Prevent out-of-bounds read in hci_inquiry_result_evt()").

Thanks,
Peilin Ye

