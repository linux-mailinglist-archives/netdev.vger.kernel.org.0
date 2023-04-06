Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEAD36D9B10
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 16:48:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236859AbjDFOsh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 10:48:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238150AbjDFOsW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 10:48:22 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AFF1B746;
        Thu,  6 Apr 2023 07:47:02 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id kq3so37673656plb.13;
        Thu, 06 Apr 2023 07:47:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680792410;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=SIhojiTLqyVrTvC+meMw7ddDQq0KQb5DwLtt0z99fS4=;
        b=LPUqTdbAeabs6BLVmyhbYxfBjQSM8+XilE80rFItRmkRM+te/ztDTV20B3uSAbeeVJ
         CjxjKpGHBYXNBSpSDcHDKVV4zmaj5EFhjmH+ck6iY9Q+N50SSrAG82KiRK+TJpuTLy7T
         V4NDpqeZJ8ntPvhXOmKMytJrbLbINT9iA8maFufGDrsu/RXcH5vFxLO3hCGSDueScBy7
         YVOH6vRFhDk3t1X1oxh/a/esJ1frAlD+WQs8aok3HKMTNd6AhHbq+5ggtXJ1N312U071
         gE22a48PM2MWi0V74QQKd/ngayQKb8pickTzR1ee7N7z1y+Y4n6BijOncMGNf0+t435A
         Hk3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680792410;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SIhojiTLqyVrTvC+meMw7ddDQq0KQb5DwLtt0z99fS4=;
        b=0gHk/GTLrQouRUgjgC8h9hXVKZbzqAzFQN40nho8h3ljXXpNOyO6riG7CvkwBFIZXq
         /7qoFng6mVdzCtw+IQsr/HecdF7hi2Uf09tR6D8OSh4odUuLoxDG12sU0pKNiwVweUSc
         1RQT5CdCTe8nL1UP7OcncwbCOnNSsO7daD5K0OM036gJJhgINoU3jQQ1wygWJm3uxqVN
         5nVtM3HHBpteDnQ+mhqXA7J7QPMCl+cMof1FF2Exkfbcv/G6Bz199ygXRDZ5VYwyW3qE
         55WXHh1yZt32LdZm0VeXCHaVug7Zea0HdVPc8cP2qgMobkaatud7edQGaddEEwk6D/zh
         QL4g==
X-Gm-Message-State: AAQBX9cw9EzXev8bdIxvorzcaBwu5GAc+bRyF76q/Pj6EMkkKi1x8zWm
        NITMVEvh/lyhKd0VvvuIRW5EKmEyF4CVieqv
X-Google-Smtp-Source: AKy350abzAKHLW9OvImIJ3zGuffP+U0koYbtzEU9hGSsUT299uxniBCi798jPsKoyBhL1N6xdwz4/Q==
X-Received: by 2002:a05:6a20:c105:b0:db:9e4e:8129 with SMTP id bh5-20020a056a20c10500b000db9e4e8129mr3299859pzb.40.1680792409857;
        Thu, 06 Apr 2023 07:46:49 -0700 (PDT)
Received: from sumitra.com ([59.95.156.146])
        by smtp.gmail.com with ESMTPSA id j11-20020aa78dcb000000b005e4c3e2022fsm1483340pfr.72.2023.04.06.07.46.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Apr 2023 07:46:49 -0700 (PDT)
Date:   Thu, 6 Apr 2023 07:46:44 -0700
From:   Sumitra Sharma <sumitraartsy@gmail.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     Manish Chopra <manishc@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        Coiby Xu <coiby.xu@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: qlge: Remove macro FILL_SEG
Message-ID: <20230406144644.GB231658@sumitra.com>
References: <20230405150627.GA227254@sumitra.com>
 <ZC2gJdUA6zGOjX4P@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZC2gJdUA6zGOjX4P@corigine.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 05, 2023 at 06:21:57PM +0200, Simon Horman wrote:
> On Wed, Apr 05, 2023 at 08:06:27AM -0700, Sumitra Sharma wrote:
> > Remove macro FILL_SEG to fix the checkpatch warning:
> > 
> > WARNING: Macros with flow control statements should be avoided
> > 
> > Macros with flow control statements must be avoided as they
> > break the flow of the calling function and make it harder to
> > test the code.
> > 
> > Replace all FILL_SEG() macro calls with:
> > 
> > err = err || qlge_fill_seg_(...);
> 
> Perhaps I'm missing the point here.
> But won't this lead to err always either being true or false (1 or 0).
> Rather than the current arrangement where err can be
> either 0 or a negative error value, such as -EINVAL.
>

Hi Simon


Thank you for the point you mentioned which I missed while working on this
patch. 

However, after thinking on it, I am still not able to get any fix to this
except that we can possibly implement the Ira's solution here which is:

https://lore.kernel.org/outreachy/64154d438f0c8_28ae5229421@iweiny-mobl.notmuch/

Although we have to then deal with 40 lines of ifs.



Regards

Sumitra



> ...
