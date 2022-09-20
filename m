Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 151C35BECC3
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 20:28:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230262AbiITS1z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 14:27:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbiITS1w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 14:27:52 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86B235A897
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 11:27:51 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id t7so5776053wrm.10
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 11:27:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date;
        bh=PnPtfLI7bfunIU5UZT+UnLQ2EPU4SbgSPWE6/nFu9NU=;
        b=jcXSwVW7iZxftdz5MxZ5pp+3OUe2ywRQo0FQY5gbBjmkgkDj7g2WwppLlisr6aYtfh
         KMaybuObCT64DB4zvYQf+vn7Js8ZtQ5aheB2OvgXrRU3jSJeorBRYq+ORKEs1zCNGjck
         hcV0xwWTGCTye0RJtEsxenYrNxzOUXqXbPZsOIFdWQElL4NkPn+Vnw3ITSBDVrzBY1m3
         3hHZMoao2lQ/eh46MbwFRaSm9UHmyE6wisxBWMDJbepyUTabWT1/jewC7zz46JJUIv7x
         yp+XnUKMRseA/ozpTc0SxjLmY9OH6rAZsTRwW2KZ0aXjWeEgVep2uMZd5BeefjpJYj80
         ZqYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date;
        bh=PnPtfLI7bfunIU5UZT+UnLQ2EPU4SbgSPWE6/nFu9NU=;
        b=6JXJQdumcefMfcxWbH8uEiercMTKOXIHLq78chKOdZdD+mlaido1mlnNsQ43SEf6yt
         xHca3ONr74Bw/XZS+V1wng9Ny64aU6ECWX07fbAFvAYPkr6r9uQy//wDzo7EwJmms/xC
         6OmSVvbnMUPE92p7qrcjAagfN8XKrylG9dwuj5Z3mSCCpshA2w7YQxcAc3YZSrXzxmVd
         DPZEov3tl2ccN6WBd/P9NfRbPrv+37K5t0T+UpZDGVZ9wXH/pDpBFKMTO5SMcy8CQn/u
         tWYogMUDx3w9TdnB7fh8pU4CJC1hnr3bnFvyCyVVoSWlfAJRI457J/wO4++FZOxIhb/a
         Ksqg==
X-Gm-Message-State: ACrzQf35PC9qtDQ1f2f2JzYh/u4SxlOhj1MLWhGW0KFfvz7QSM34WH3z
        mp86yi9vF4yieZznBNX7Lp4=
X-Google-Smtp-Source: AMsMyM4YsrF+HS6XbyQJ30reGRcqq39DT39gcr6LNiUKCG0LKf+0PzEICesm/QjnivuMLs+RelfvcQ==
X-Received: by 2002:a05:6000:1446:b0:22b:968:446 with SMTP id v6-20020a056000144600b0022b09680446mr5439529wrx.493.1663698469976;
        Tue, 20 Sep 2022 11:27:49 -0700 (PDT)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id q16-20020a7bce90000000b003b492b30822sm697184wmj.2.2022.09.20.11.27.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Sep 2022 11:27:49 -0700 (PDT)
Subject: Re: [PATCH/RFC net-next 2/3] devlink: Add new "max_vf_queue" generic
 device param
To:     Simon Horman <simon.horman@corigine.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Diana Wang <na.wang@corigine.com>,
        Peng Zhang <peng.zhang@corigine.com>
References: <20220920151419.76050-1-simon.horman@corigine.com>
 <20220920151419.76050-3-simon.horman@corigine.com>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <2af4e971-b480-6aff-c26b-6fd60b7523fb@gmail.com>
Date:   Tue, 20 Sep 2022 19:27:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220920151419.76050-3-simon.horman@corigine.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20/09/2022 16:14, Simon Horman wrote:
> From: Peng Zhang <peng.zhang@corigine.com>
> 
> VF max-queue-number is the MAX num of queues which the VF has.
> 
> Add new device generic parameter to configure the max-queue-number
> of the each VF to be generated dynamically.
> 
> The string format is decided ad vendor specific. The suggested
> format is ...-V-W-X-Y-Z, the V represents generating V VFs that
> have 16 queues, the W represents generating W VFs that have 8
> queues, and so on, the Z represents generating Z VFs that have
> 1 queue.

I don't like this.
If I'm correctly understanding, it hardcodes an assumption that
 lower-numbered VFs will be the ones with more queues, and also
 makes it difficult to change a VF's max-queues on the fly.
Why not instead have a per-VF operation to set that VF's max
 queue count?  Ideally through the VF representor, perhaps as
 an ethtool param/tunable, rather than devlink.  Then the
 mechanism is flexible and makes no assumptions about policy.

-ed
