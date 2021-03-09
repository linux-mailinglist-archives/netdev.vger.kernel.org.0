Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48684332FC1
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 21:19:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230431AbhCIUS4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 15:18:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231690AbhCIUSg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 15:18:36 -0500
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E8E3C06174A;
        Tue,  9 Mar 2021 12:18:35 -0800 (PST)
Received: by mail-lf1-x12e.google.com with SMTP id e7so29468326lft.2;
        Tue, 09 Mar 2021 12:18:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YI56kCk/d/oKgbO1mmyispk/GDolN9+8yXUpXqLnSCs=;
        b=bmnI92D2ekBkRiHz8LftqBI+yAr4kf74snHyBMmRCoP9OlXv6BXRi12nLwTS1IZxAT
         Ql27dMjXZTwIAFEeT/LQ342f6XrQaBsCHS8zB+ciizjHwyoofnAHHKYwogz8fPqNRQ2o
         HXvkYP6XRsM3YdG8m8IHwSy7I4chQPDzRiVOF5DrqCAqBoacOvV+tSpJ/zEIVcDKWus+
         seSIMjAK/n/ljrkva8T5Nu+eZxyVQUnofeRYzUjr6wtJUwLmKs/877pc70mSkSdO5K7p
         mPW4vvjyUWzAZ5PN/RrvqMEBBrnjOyhs+uGnjGZiTGZSIjKKN9QnSJUsMDxMdKAC9BS4
         5PbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YI56kCk/d/oKgbO1mmyispk/GDolN9+8yXUpXqLnSCs=;
        b=V/z0iHOHXqd4wPsdbVYJqrupmlSlyPmMAyYH8N3OTXgw8L6XxtpeO6h0opARWpvZL9
         2t6gSUMcBpXJ7ioWCPHzCjiI2rtCl1SeF2j64jAs+rambK9tpKjmmTuOrow/n7VqjSu5
         KaELEdrmWnFig8d2J1Cn049UnPFpj6QtwOiqrtQUCDuRI+10P41UpBURurIEd96nUWA+
         Xor93sJ0BEustHsxFcH8GMujuTTwyqCvsOGCzBOjeRPqlOFkfFlChN0Mlsl1ZZybWDDl
         Uz74AX8OIUdS9PGzcYD+q/FLCKrnGuIM1D3mgMpHVhISZdWPlfsyoZDUg4fGaDY7bfEn
         H5bw==
X-Gm-Message-State: AOAM532yxlVTVE/xElqPBhntrYsudc3I9D5xIFvzdZwHDYtrfwi8TfWJ
        TCYmYo44dI2dAOeu8jHslkyNnWNWUB/eMv2HVX4R1nPE
X-Google-Smtp-Source: ABdhPJxooLs8uG+haMdYUUjAeZvgVCS6pPmrRMwkeGPYx/eKmhOzabotxwOFL7+K8s7/6L4zsgrnVoc5T6kDUt2B+Vc=
X-Received: by 2002:ac2:5ec2:: with SMTP id d2mr19377525lfq.214.1615321114173;
 Tue, 09 Mar 2021 12:18:34 -0800 (PST)
MIME-Version: 1.0
References: <20210309044349.6605-1-tonylu@linux.alibaba.com>
 <20210309124011.709c6cd3@gandalf.local.home> <5fda3ef7-d760-df4f-e076-23b635f6c758@gmail.com>
 <20210309150227.48281a18@gandalf.local.home>
In-Reply-To: <20210309150227.48281a18@gandalf.local.home>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 9 Mar 2021 12:18:23 -0800
Message-ID: <CAADnVQ+tiqKe2HB8rCVmD9pcyNPgnjYYfLiVjMhi6Jfv3XkNtA@mail.gmail.com>
Subject: Re: [PATCH] net: add net namespace inode for all net_dev events
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     David Ahern <dsahern@gmail.com>,
        Tony Lu <tonylu@linux.alibaba.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ingo Molnar <mingo@redhat.com>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 9, 2021 at 12:03 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Tue, 9 Mar 2021 12:53:37 -0700
> David Ahern <dsahern@gmail.com> wrote:
>
> > Changing the order of the fields will impact any bpf programs expecting
> > the existing format
>
> I thought bpf programs were not API.

That is correct.
