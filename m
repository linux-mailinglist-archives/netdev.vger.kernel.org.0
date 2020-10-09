Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03960287F6B
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 02:14:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731147AbgJIAOT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 20:14:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbgJIAOS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 20:14:18 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B527DC0613D2;
        Thu,  8 Oct 2020 17:14:18 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id d23so3582254pll.7;
        Thu, 08 Oct 2020 17:14:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=b3eC80cU37oVexsERv1RLvxgy0Ip+ba6vrmYt/kkXmw=;
        b=ZqDRnMyGL6Rq4n5SeNN4zTe++ETsnoc/SjQ+fPuALikouX1rs4vkOTkrw1cvXkg0N9
         CHd6ztVui8CCzcq9oJqjY/sNZNuNHHbPOLDYyymSmYboH8MhlUJa+3/los62vrNlfvlg
         Ao0AC2Z9bt+2M9y+WMAx/vCz1KypyVY/zLZKXEltu5zVRBVUCLG8Dtn+6mgVohMk4jSS
         yyq5WIWpxJ87hJSgiNjoyGs0cY0YQ4hCxW0lgQ0O+hn3qSMKYKrNvAKIgKUutVbUGx6w
         IzQ7S0cnoEauX8jXb2xmHUlKi15w0G6T7MpJv7fkAHH/daLtjvgPcPyv8QItjJU8BjM1
         7EqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=b3eC80cU37oVexsERv1RLvxgy0Ip+ba6vrmYt/kkXmw=;
        b=S4RIZ7oxCLz7aZ4AWAEKMaoCnia9K69efZXKbgDseKQHIXTYqHY64McariqfzHg4+U
         slfBHavwRc3ZDVA8JmoIgkwvBtCLsAzDz3M+J6WfswwleS5kUwvLmQqHzP4CCiJLCGI/
         3HiRzPU3bv8D0PeHFLvQiQhD1zUtdwkrE5ywdkSCXM1raRPb7YFWgVdYQmkGEQ0VM5HD
         IiuJLK2q6JsSWEYgVEqGDnhbSNLTwp6LNIC54bQbG8KWOD7kP96kDLpQC6jeDj4YIsE2
         0tIl5vEXh/G1jARWscj56ggxuflDmxzJO27Hax8XkF3hHZiP0fEL4S8vM2LFktYVyZ5q
         5NXQ==
X-Gm-Message-State: AOAM530YjUeNcFOtEa+xgCzfcoBVVs/+LRX0Oo2yOxKOL0Q95F0AiihN
        l/ahMivFvnzs8V//kysXAGo=
X-Google-Smtp-Source: ABdhPJz1fDsaqelnVeG+o33xqoP3LCtDr0IZZWEhGVtnV5+xEAl6HpFX9JIRGtpTZ2M/LYW1gdKTdQ==
X-Received: by 2002:a17:902:cd07:b029:d3:9be0:2679 with SMTP id g7-20020a170902cd07b02900d39be02679mr9957750ply.68.1602202458345;
        Thu, 08 Oct 2020 17:14:18 -0700 (PDT)
Received: from localhost ([2001:e42:102:1532:160:16:113:140])
        by smtp.gmail.com with ESMTPSA id x10sm8419333pfc.88.2020.10.08.17.14.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 17:14:17 -0700 (PDT)
From:   Coiby Xu <coiby.xu@gmail.com>
X-Google-Original-From: Coiby Xu <Coiby.Xu@gmail.com>
Date:   Fri, 9 Oct 2020 08:14:11 +0800
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     devel@driverdev.osuosl.org,
        "supporter:QLOGIC QLGE 10Gb ETHERNET DRIVER" 
        <GR-Linux-NIC-Dev@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        "open list:QLOGIC QLGE 10Gb ETHERNET DRIVER" <netdev@vger.kernel.org>,
        Shung-Hsi Yu <shung-hsi.yu@suse.com>,
        open list <linux-kernel@vger.kernel.org>,
        Benjamin Poirier <benjamin.poirier@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v1 2/6] staging: qlge: coredump via devlink health
 reporter
Message-ID: <20201009001411.yi37d25uyqkzaccw@Rk>
References: <20201008115808.91850-1-coiby.xu@gmail.com>
 <20201008115808.91850-3-coiby.xu@gmail.com>
 <20201008133940.GC1042@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20201008133940.GC1042@kadam>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 08, 2020 at 04:39:40PM +0300, Dan Carpenter wrote:
>On Thu, Oct 08, 2020 at 07:58:04PM +0800, Coiby Xu wrote:
>> -static int
>> -qlge_reporter_coredump(struct devlink_health_reporter *reporter,
>> -			struct devlink_fmsg *fmsg, void *priv_ctx,
>> -			struct netlink_ext_ack *extack)
>> +static int fill_seg_(struct devlink_fmsg *fmsg,
>> +		    struct mpi_coredump_segment_header *seg_header,
>> +		    u32 *reg_data)
>>  {
>> -	return 0;
>> +	int i;
>> +	int header_size = sizeof(struct mpi_coredump_segment_header);
>
>Please use the sizeof() directly in the code.  Don't introduce
>indirection if you can help it.
>
>> +	int regs_num = (seg_header->seg_size - header_size) / sizeof(u32);
>> +	int err;
>> +
>
Thank you for the suggestion!
>regards,
>dan carpenter

--
Best regards,
Coiby
