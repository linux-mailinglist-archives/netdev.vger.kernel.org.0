Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EE7520D431
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 21:14:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730727AbgF2TGF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 15:06:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730529AbgF2TCn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 15:02:43 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62B5BC031C5E;
        Mon, 29 Jun 2020 10:44:03 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id 67so4131721pfg.5;
        Mon, 29 Jun 2020 10:44:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=zajKLFBWYvbR/dn70eWOQZrMNaJGoW21UItsytAj4Pg=;
        b=tUchiO1ZmHPcMUQ6nb6f+GBa4GwRs+UmAyEev+2pWA7R/2ylJcq4ZTXHOQeyLtbtKC
         7YJaKxcjh5GVMzls4Q0y2vp3h7D94xr91HPZHTYdn3HRQgzE3dF8791jm9A3v6tBOYqe
         WN40ApOIzVoFRQK49V44l03voWX+TUL36q1dDsY4yrM2g6KHfASEnDkSdp5miGCDrg3+
         PqVW30sWMvrXokrQORmke/VQMfqTpNs7Ifvm3EwToEa83E23Sy5TQACWtjB4RMpJgQPl
         5SmtFPk5qWymIYKBXzKyeUZl7u0NABgETrEC4t95CUwAH4Rcq+4JnrfPp4X4iM/CKla8
         k0ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=zajKLFBWYvbR/dn70eWOQZrMNaJGoW21UItsytAj4Pg=;
        b=Hiyg0VM7FzFORSv7WbPWk/zWDfzusT9C853x3QcYrGF7uSB/PlrwIkjfMc8BqteZPi
         D4w1WwunePVvphKkDXbkdZ1KPgSKMM1kC8xRVVGZ88xjj5r20t3RtsBQ/Xm3gn6QXfOw
         jGOGeI4JmWLhBq5c1tyjr1wrobWBaxWmLOArhMTTo2VUA9xEgUzG1Otot38bWyooYI39
         vWZN5BX18fE66alc6jSYnRmvQocfSicozZ3by9E6WChqQExTvlI3BWQ94u4m9MzoR25h
         BvMm6y+GvyfH/JrsDX7w1ALlQtzzD9U8Rwab6YZszybK+6+gWH5PwFIudxWed2P6BB+U
         h2Cg==
X-Gm-Message-State: AOAM533Vqzx7Cl9NrhPmxMljb5ImMXuuZ3ljDs6nuyTFrzllL1Cb2aAz
        hieoQKu/lihXeBu8EtCNIns=
X-Google-Smtp-Source: ABdhPJzBcLLzwLTBp+SADDEiJRBUHsSxdEdo7/SpaPcZ8T2RJtU5PzmMtmzfSCa+VgpSvypvEpCRVA==
X-Received: by 2002:a63:d74c:: with SMTP id w12mr11600066pgi.260.1593452642988;
        Mon, 29 Jun 2020 10:44:02 -0700 (PDT)
Received: from localhost ([160.16.113.140])
        by smtp.gmail.com with ESMTPSA id j2sm202778pjf.4.2020.06.29.10.44.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2020 10:44:02 -0700 (PDT)
From:   Coiby Xu <coiby.xu@gmail.com>
X-Google-Original-From: Coiby Xu <Coiby.Xu@gmail.com>
Date:   Tue, 30 Jun 2020 01:43:52 +0800
To:     Benjamin Poirier <benjamin.poirier@gmail.com>
Cc:     devel@driverdev.osuosl.org, joe@perches.com,
        dan.carpenter@oracle.com, gregkh@linuxfoundation.org,
        Manish Chopra <manishc@marvell.com>,
        "supporter:QLOGIC QLGE 10Gb ETHERNET DRIVER" 
        <GR-Linux-NIC-Dev@marvell.com>,
        "open list:QLOGIC QLGE 10Gb ETHERNET DRIVER" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 4/4] staging: qlge: replace pr_err with netdev_err
Message-ID: <20200629174352.euw4lckze2k7xtbm@Rk>
References: <20200627145857.15926-1-coiby.xu@gmail.com>
 <20200627145857.15926-5-coiby.xu@gmail.com>
 <20200629053004.GA6165@f3>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200629053004.GA6165@f3>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 29, 2020 at 02:30:04PM +0900, Benjamin Poirier wrote:
>On 2020-06-27 22:58 +0800, Coiby Xu wrote:
>[...]
>>  void ql_dump_qdev(struct ql_adapter *qdev)
>>  {
>> @@ -1611,99 +1618,100 @@ void ql_dump_qdev(struct ql_adapter *qdev)
>>  #ifdef QL_CB_DUMP
>>  void ql_dump_wqicb(struct wqicb *wqicb)
>>  {
>> -	pr_err("Dumping wqicb stuff...\n");
>> -	pr_err("wqicb->len = 0x%x\n", le16_to_cpu(wqicb->len));
>> -	pr_err("wqicb->flags = %x\n", le16_to_cpu(wqicb->flags));
>> -	pr_err("wqicb->cq_id_rss = %d\n",
>> -	       le16_to_cpu(wqicb->cq_id_rss));
>> -	pr_err("wqicb->rid = 0x%x\n", le16_to_cpu(wqicb->rid));
>> -	pr_err("wqicb->wq_addr = 0x%llx\n",
>> -	       (unsigned long long)le64_to_cpu(wqicb->addr));
>> -	pr_err("wqicb->wq_cnsmr_idx_addr = 0x%llx\n",
>> -	       (unsigned long long)le64_to_cpu(wqicb->cnsmr_idx_addr));
>> +	netdev_err(qdev->ndev, "Dumping wqicb stuff...\n");
>
>drivers/staging/qlge/qlge_dbg.c:1621:13: error: ‘qdev’ undeclared (first use in this function); did you mean ‘cdev’?
> 1621 |  netdev_err(qdev->ndev, "Dumping wqicb stuff...\n");
>      |             ^~~~
>      |             cdev
>
>[...]
>and many more like that
>
>Anyways, qlge_dbg.h is a dumpster. It has hundreds of lines of code
>bitrotting away in ifdef land. See this comment from David Miller on the
>topic of ifdef'ed debugging code:
>https://lore.kernel.org/netdev/20200303.145916.1506066510928020193.davem@davemloft.net/

Thank you for spotting this problem! This issue could be fixed by
passing qdev to ql_dump_wqicb. Or are you suggesting we completely
remove qlge_dbg since it's only for the purpose of debugging the driver
by the developer?

Btw, I'm curious how you make this compiling error occur. Do you manually trigger
it via "QL_CB_DUMP=1 make M=drivers/staging/qlge" or use some automate
tools?

--
Best regards,
Coiby
