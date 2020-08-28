Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06D8D256086
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 20:32:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727056AbgH1Sce (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 14:32:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726010AbgH1Scb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Aug 2020 14:32:31 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB1CBC061264
        for <netdev@vger.kernel.org>; Fri, 28 Aug 2020 11:32:30 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id v2so1497454ilq.4
        for <netdev@vger.kernel.org>; Fri, 28 Aug 2020 11:32:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mGn96G8V5rOR9isAgssuiLo5ei+EZl4WHwBBOVex/Lg=;
        b=VyfKrBGyXLrt4hD6eiaWHNsvHYNHP05jfwaDrtLl1aPIGT637qLw1rJtRycw19E5dK
         Q5ecJvXC9qmBiAOLOW0SwklAU4BubucxeCrzQMSXKskGhVWLFT3Kmsyx9brVormaU31j
         TwhHFCw5+Zhb3x++Ib3R42PdkcOtKu/GbpuAxHHq9q33M7N7eCL9TqsPRqq0jPe1aCQR
         Io4DHOEoQiukuwu5WChZdADPInIIsof5DMX/zLNZgL3MX2p9nHOONiPbZG/0k5WfLN05
         GnxFJD4+Th7CFvx3+/aF7SH8CYXZc8/NbYY1Ct8Hof3Dp5DNh9C36kphGPfLjS8xlWQe
         VoQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mGn96G8V5rOR9isAgssuiLo5ei+EZl4WHwBBOVex/Lg=;
        b=Ns2vUkNwIG293t5sVmYrYxcRaV9kheTtwvYHyLzIjOQz6hUY28kzmy0rht/DC7ObTC
         fVaONWwNyBfXC0/pTxbn77Yeo8o+LXNfyc0k2RoaRLTLZz6hwYXFyQnLomevUHrXYqNh
         0SpvBucqtfUaq8sTBD5W3DAKuEuhEmTvU/DtAn6tdkxhK9lqVK7K3iz/QTvs4pfJtMd+
         OeY7gnTkdl+/RJW0PLhZWLfnFhC6qTpMeadhrOwavzATlEmnX8ltg6eoImahL2oRZ3c1
         gOpAllAF+D9b02uWX+23umksLzBZHe3PhJnjyyu7leeCD3yM9pTfSnRqy8mRm1CoeCXH
         IpBg==
X-Gm-Message-State: AOAM533Gvxamanxc9a48/1a6uOR5qMidhUdUHTWbmRc6jHQ4uNgTcc2T
        dn6wNLQwQQA1CXUY7NBIjyYmCgcM3HstdQErLUN5S+kFlw9TSA==
X-Google-Smtp-Source: ABdhPJwRmp3kLtA4Kgo9DY6kXYCW9VPqRztrsEH6qYKLYQNJdx7HiOgOLLVPdpZOPIMQTUk2URQsaYwCmspQYoiJrWk=
X-Received: by 2002:a92:9a07:: with SMTP id t7mr200612ili.144.1598639550223;
 Fri, 28 Aug 2020 11:32:30 -0700 (PDT)
MIME-Version: 1.0
References: <1598335663-26503-1-git-send-email-wenxu@ucloud.cn>
In-Reply-To: <1598335663-26503-1-git-send-email-wenxu@ucloud.cn>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Fri, 28 Aug 2020 11:32:19 -0700
Message-ID: <CAM_iQpU3LLcm97xH8UUdDBQCny7UzkJ1=wf0Ssog-0YzzJ4=Zw@mail.gmail.com>
Subject: Re: [PATCH net-next] net/sched: add act_ct_output support
To:     wenxu <wenxu@ucloud.cn>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 25, 2020 at 1:45 AM <wenxu@ucloud.cn> wrote:
>
> From: wenxu <wenxu@ucloud.cn>
>
> The fragment packets do defrag in act_ct module. If the reassembled
> packet should send out to another net device. This over mtu big packet
> should be fragmented to send out. This patch add the act ct_output to
> archive this.

There are a lot of things missing in your changelog.

For example: Why do we need a new action here? Why segmentation
is not done on the target device?

At least for the egress side, dev_queue_xmit() is called by act_mirred,
it will perform a segmentation with skb_gso_segment() if needed.
So why bigger packets can not be segmented here?

Please add all these necessary details into your changelog.

Thanks.
