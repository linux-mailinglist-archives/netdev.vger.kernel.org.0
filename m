Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF5D63B2DE1
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 13:30:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232442AbhFXLc5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 07:32:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232274AbhFXLc4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 07:32:56 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C87ADC061574;
        Thu, 24 Jun 2021 04:30:35 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id 22-20020a17090a0c16b0290164a5354ad0so5717444pjs.2;
        Thu, 24 Jun 2021 04:30:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=RD4xUDZuCe1wEZ3uQByJXB39CveNW2Qc0Hvr7tXsRJs=;
        b=Sg4Ccr6QlPWrQ2h/+KeJyYDhUFirkHeojycmEO7Iwl8Bv8CqATfb49eED0okGm9l7F
         rZDBIFPyIBc+pkrDmqQv/ql3XlWO+7cAb5t7nL7cD/bVxkbg/i/BEtnTJZrRX+Wl9n60
         +VqqRtE4c3QPLGEIES+g276zgSbuohYiTL8+GQAgsPCG3MJuCQO+sFUmwdP+gwA08k2V
         2eE4Jlz/6qhWG3lVNZIoqIEGs3Yoz7xV2naenK/nfF3HNVaD02q+nSj6F1srNIIpKcYR
         VFVBYZ/Nzrg/QN5NudOkEZAnp2l5UAGK5Ulb4RJZJ9rfld9npcMmHkhu0NDIq/wvczcg
         LVoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RD4xUDZuCe1wEZ3uQByJXB39CveNW2Qc0Hvr7tXsRJs=;
        b=KuEbW/QfYZs/n1sJgkCLCAa2Ep8WUSQ+JbnGXMUfOxV+yp1mDjheatIqryxEk6jBsD
         K+hix4S3WVFSFPyQm9L/IBi4oAzSNX4zc6omfnKxJYKfsjnvD9dW2rEeoRWQLbR/Fc0M
         EWUFESqF9Dr0AgHCtoXfGH+13E4ULsaA18gpJ8P1klwAU+AYpIu04yvC0oo08YZT7U4K
         4nFA5Ylx4aqUQ7jmYkG5Qww1AOgU65p3932LM/JvkkJKGz6KG0hmDp2Vn9i70U22C9YF
         HKOEdivN4mkTWuotDemINk0oMuB0oZu5GjZs+MCw6suZgs1IaVZUa/k/h2yRgLL0mI9f
         ruPA==
X-Gm-Message-State: AOAM530VArK0Ujmut8hXBzIjQDy4XkD5+j1pyZPkYmangAdv7G2jlRZ9
        O1L/1rW30ShR0SSX8315jZrze7eXtE4ChZhC
X-Google-Smtp-Source: ABdhPJyJpYAyhxm8BFVgbRH6hxthIt6tO7a7NutbSFexoL+fixZryLFYEteqplW4/PNJnVgtiu5SWw==
X-Received: by 2002:a17:903:31c3:b029:ed:6f74:49c7 with SMTP id v3-20020a17090331c3b02900ed6f7449c7mr3858261ple.12.1624534235272;
        Thu, 24 Jun 2021 04:30:35 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id q27sm2796735pfg.63.2021.06.24.04.30.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jun 2021 04:30:34 -0700 (PDT)
From:   Coiby Xu <coiby.xu@gmail.com>
X-Google-Original-From: Coiby Xu <Coiby.Xu@gmail.com>
Date:   Thu, 24 Jun 2021 19:25:00 +0800
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     linux-staging@lists.linux.dev, netdev@vger.kernel.org,
        Benjamin Poirier <benjamin.poirier@gmail.com>,
        Shung-Hsi Yu <shung-hsi.yu@suse.com>,
        Manish Chopra <manishc@marvell.com>,
        "supporter:QLOGIC QLGE 10Gb ETHERNET DRIVER" 
        <GR-Linux-NIC-Dev@marvell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 16/19] staging: qlge: remove deadcode in qlge_build_rx_skb
Message-ID: <20210624112500.rhtqp7j3odq6b6bq@Rk>
References: <20210621134902.83587-1-coiby.xu@gmail.com>
 <20210621134902.83587-17-coiby.xu@gmail.com>
 <20210622072939.GL1861@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210622072939.GL1861@kadam>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 22, 2021 at 10:29:39AM +0300, Dan Carpenter wrote:
>On Mon, Jun 21, 2021 at 09:48:59PM +0800, Coiby Xu wrote:
>> This part of code is for the case that "the headers and data are in
>> a single large buffer". However, qlge_process_mac_split_rx_intr is for
>> handling packets that packets underwent head splitting. In reality, with
>> jumbo frame enabled, the part of code couldn't be reached regardless of
>> the packet size when ping the NIC.
>>
>
>This commit message is a bit confusing.  We're just deleting the else
>statement.  Once I knew that then it was easy enough to review
>qlge_process_mac_rx_intr() and see that if if
>ib_mac_rsp->flags3 & IB_MAC_IOCB_RSP_DL is set then
>ib_mac_rsp->flags4 & IB_MAC_IOCB_RSP_HV must be set.

Do you suggest moving to upper if, i.e.

         } else if (ib_mac_rsp->flags3 & IB_MAC_IOCB_RSP_DL && ib_mac_rsp->flags4 & IB_MAC_IOCB_RSP_HS) {

and then deleting the else statement?

>
>regards,
>dan carpenter
>

-- 
Best regards,
Coiby
