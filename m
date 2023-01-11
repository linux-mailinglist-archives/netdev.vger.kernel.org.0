Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C772E6657E7
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 10:46:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232433AbjAKJq1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 04:46:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232486AbjAKJp4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 04:45:56 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF45D25DD
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 01:42:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673430167;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+mXlqHLDOLyFJjraZrLr0BXsWr/xXhYE6HGBmC7wCe0=;
        b=dzLMD2ICLGzZzY75ArSnkoVZk5wrv7ioQ9zpfcVJLrkwvAYw8IHyv1OqLHivM5NL1dR8pM
        W8CjwkLzgPviOtCUp6bc4rz+erqJ4BSHwD6qKzuJokVSInO861IYc26oPV0JPeqOn88066
        Kv0Zn4o43eGONgF7FfzxdZfkerumZPM=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-26-UkgtnA56N1a34RVUtfWBmg-1; Wed, 11 Jan 2023 04:42:45 -0500
X-MC-Unique: UkgtnA56N1a34RVUtfWBmg-1
Received: by mail-ed1-f71.google.com with SMTP id r14-20020a05640251ce00b0047d67ab2019so9518280edd.12
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 01:42:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+mXlqHLDOLyFJjraZrLr0BXsWr/xXhYE6HGBmC7wCe0=;
        b=BNLTnG6MtSu+rXVCkEbaONHPVu7aO+2L3XaoNbUEJORIZaBFo1LY/IPPyzAs8BHfFt
         akXF82COkIPgXuNFmzIh6Tv8MyTNVcnSlBtPb4fQzCeMI++rPc4gA6F469AC6RjYelBV
         Ub/TJkJVPvoOp7rm4AOtPM9SLHW6yoWVPfBK5NQ7kjYoC23AXkgmx7KsX/VYCuuwXrtm
         SdKcCoCqACCkWEATcM3Upzr6Udn3jZhPtwnTdCuO3S7OQSokxZqNJQNtlmBbCgh+WcCu
         +VqUpJxMRG/R58ItFgJk4j8EZccgvVJp9e8KznWLT6XGcYnl3w4+/0enj5rOKtgmcfz3
         kbXg==
X-Gm-Message-State: AFqh2koa1E5sHb0ceFrjVtkrIjvniiDJogqXvnPvQzGdRRzooaJeI1eE
        07smOh9w9m9n+M+X5UgRaJmIFvHVuAOd8L+3MfkwknYQ5vSL9cM1N3g73RT7y1K4YtgkHmc3l8e
        Ap33epvU7NhyYJt5AOkAassdVsCVQVp/f
X-Received: by 2002:a17:906:f218:b0:828:75be:fd81 with SMTP id gt24-20020a170906f21800b0082875befd81mr7274786ejb.360.1673430163957;
        Wed, 11 Jan 2023 01:42:43 -0800 (PST)
X-Google-Smtp-Source: AMrXdXtpXNHT4W4d5mnoYX9i6t0hHg6a7iscVqYz7rIF7qFPWDkZ14oPFi5o8iBEJ9v/6qp+913JljQ931hxedkpl78=
X-Received: by 2002:a17:906:f218:b0:828:75be:fd81 with SMTP id
 gt24-20020a170906f21800b0082875befd81mr7274785ejb.360.1673430163746; Wed, 11
 Jan 2023 01:42:43 -0800 (PST)
MIME-Version: 1.0
References: <20230110080018.2838769-1-sassmann@redhat.com>
In-Reply-To: <20230110080018.2838769-1-sassmann@redhat.com>
From:   Michal Schmidt <mschmidt@redhat.com>
Date:   Wed, 11 Jan 2023 10:42:32 +0100
Message-ID: <CADEbmW2LLTfZ6h=Cdkbc70Z61BuBKYMbaLYq-c=STP03VJ_O2g@mail.gmail.com>
Subject: Re: [Intel-wired-lan] [PATCH net-queue] iavf: schedule watchdog
 immediately when changing primary MAC
To:     Stefan Assmann <sassmann@redhat.com>
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        patryk.piotrowski@intel.com, anthony.l.nguyen@intel.com,
        sassmann@kpanic.de
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 10, 2023 at 9:01 AM Stefan Assmann <sassmann@redhat.com> wrote:
>
> From: Stefan Assmann <sassmann@kpanic.de>
>
> iavf_replace_primary_mac() utilizes queue_work() to schedule the
> watchdog task but that only ensures that the watchdog task is queued
> to run. To make sure the watchdog is executed asap use
> mod_delayed_work().
>
> Without this patch it may take up to 2s until the watchdog task gets
> executed, which may cause long delays when setting the MAC address.
>
> Fixes: a3e839d539e0 ("iavf: Add usage of new virtchnl format to set default MAC")
> Signed-off-by: Stefan Assmann <sassmann@kpanic.de>
> ---
> Depends on net-queue patch
> ca7facb6602f iavf: fix temporary deadlock and failure to set MAC address
>
>  drivers/net/ethernet/intel/iavf/iavf_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
> index fff06f876c2c..1d3aa740caea 100644
> --- a/drivers/net/ethernet/intel/iavf/iavf_main.c
> +++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
> @@ -1033,7 +1033,7 @@ int iavf_replace_primary_mac(struct iavf_adapter *adapter,
>
>         /* schedule the watchdog task to immediately process the request */
>         if (f) {
> -               queue_work(adapter->wq, &adapter->watchdog_task.work);
> +               mod_delayed_work(adapter->wq, &adapter->watchdog_task, 0);
>                 return 0;
>         }
>         return -ENOMEM;
> --
> 2.38.1

Reviewed-by: Michal Schmidt <mschmidt@redhat.com>
Tested-by: Michal Schmidt <mschmidt@redhat.com>

Beautiful! On my test machine, this takes the time needed to bring up
64 VFs from 92 s down to 7 s.
Michal

