Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BD206998BA
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 16:22:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229495AbjBPPW4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 10:22:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229883AbjBPPWz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 10:22:55 -0500
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B971C3;
        Thu, 16 Feb 2023 07:22:48 -0800 (PST)
Received: by mail-qt1-x82c.google.com with SMTP id g18so2469438qtb.6;
        Thu, 16 Feb 2023 07:22:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=llIcWF5xbQFOtSjdzgEbhi9FYg30VTrBQCCHC6meyaw=;
        b=oki4ylow6NgZk+g/Xj5mNQxEB/lIn7AZ02l1tiXBWhND/V9+gpydM/7Vorn0vEy2fb
         4W5jWK6PTubapDVGKI3E4wsFB0R8VDtnO5F2eMto4z4dvd4ncEWXZhYfyF66C/HNkSwL
         GsmHGSnmvHDl3I4b6+QamH++PV1eyFsgkB9CKDmAnHT7NvuNMUzYwG/ogUtYCK0q6Cp3
         OH3xvtRK+qxGaLuJpVrtF39Y8anGRfR+xdwV/Kkt+vVazLB/UutVERUxPwYT+VqcAc1Y
         gFrPNfTZgijUx3dRpGIbsZ3sTx1IkvwspD2ZDS3QfEsWmvcCa20FJA18TkoosbFPH4+t
         yFTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=llIcWF5xbQFOtSjdzgEbhi9FYg30VTrBQCCHC6meyaw=;
        b=DFrzORRFd1oOMc13ZrajgqDgPi9QDp9+XOVyaVwzCjse7Ua6DT+QbS1sRmp+VrsoKr
         URCEwwtBKSCwNOsDqIOEOXSklz219JfL5PX08kcltwPF0XDtXqiapHIWsjThVvhDCLen
         GQaYYVxBqGHRJdww1DSmDlXmaaT/Tmzs3wydae0tNxG+Ow7+DBRBplUhl+xlx3RvosZ1
         mCvQbjJVIATHuTWZWmy9zKoUJ1EN3pDFXw73/u9PSS3W3XKtuaxQj0/fUN+vqVqhpNOv
         S3V55mT64PZw/RO8bkFYkhngAbNRRL415tlOOyVGSHXaNNXZeqfbuudKtyJusOcQQg1f
         eWhA==
X-Gm-Message-State: AO0yUKVgCVFtfqKkPy9wWebH4XiFXZ4Dn4CMwu3v25wVD+Cc4VoCn4m8
        VlP2qpsme57WmB6hOe98o3k=
X-Google-Smtp-Source: AK7set/lWNVHIVcZ/04JHySYeT+b2SgUPefHLGkjzzd9UMavpwkuKzypQYLTJUszA6l4HsZJWxVZsQ==
X-Received: by 2002:ac8:7d8a:0:b0:3b8:6b41:104f with SMTP id c10-20020ac87d8a000000b003b86b41104fmr10492674qtd.40.1676560967047;
        Thu, 16 Feb 2023 07:22:47 -0800 (PST)
Received: from t14s.localdomain (rrcs-24-43-123-84.west.biz.rr.com. [24.43.123.84])
        by smtp.gmail.com with ESMTPSA id l2-20020ac87242000000b003b630ea0ea1sm1390993qtp.19.2023.02.16.07.22.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Feb 2023 07:22:46 -0800 (PST)
Received: by t14s.localdomain (Postfix, from userid 1000)
        id 862324C2A55; Thu, 16 Feb 2023 07:22:45 -0800 (PST)
Date:   Thu, 16 Feb 2023 07:22:45 -0800
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Zhengchao Shao <shaozhengchao@huawei.com>
Subject: Re: [PATCH net] sctp: add a refcnt in sctp_stream_priorities to
 avoid a nested loop
Message-ID: <Y+5KRT0FYiI3t25n@t14s.localdomain>
References: <06ac4e517bff69c23646594d3b404b9ffb51001c.1676491484.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <06ac4e517bff69c23646594d3b404b9ffb51001c.1676491484.git.lucien.xin@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 15, 2023 at 03:04:44PM -0500, Xin Long wrote:
> With this refcnt added in sctp_stream_priorities, we don't need to
> traverse all streams to check if the prio is used by other streams
> when freeing one stream's prio in sctp_sched_prio_free_sid(). This
> can avoid a nested loop (up to 65535 * 65535), which may cause a
> stuck as Ying reported:
> 
>     watchdog: BUG: soft lockup - CPU#23 stuck for 26s! [ksoftirqd/23:136]
>     Call Trace:
>      <TASK>
>      sctp_sched_prio_free_sid+0xab/0x100 [sctp]
>      sctp_stream_free_ext+0x64/0xa0 [sctp]
>      sctp_stream_free+0x31/0x50 [sctp]
>      sctp_association_free+0xa5/0x200 [sctp]
> 
> Note that it doesn't need to use refcount_t type for this counter,
> as its accessing is always protected under the sock lock.
> 
> Fixes: 9ed7bfc79542 ("sctp: fix memory leak in sctp_stream_outq_migrate()")
> Reported-by: Ying Xu <yinxu@redhat.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
