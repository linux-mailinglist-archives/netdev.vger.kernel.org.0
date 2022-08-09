Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7566D58D25B
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 05:30:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230406AbiHIDac (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 23:30:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229817AbiHIDaa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 23:30:30 -0400
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47C821109;
        Mon,  8 Aug 2022 20:30:29 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id w6so7904093qkf.3;
        Mon, 08 Aug 2022 20:30:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=Ni63gAQOgqL3rVx5QRs1Ql+8uMsi8IRaIfTqyv6SPMg=;
        b=iH4GEEDLr/n9fbIRXJIfL86UxTHrN+4QzzObag4OOSRbNVj/TinS+CphoSLqOC8rmn
         IgT41B7ayvLyCvW74GmwDxxAe0tGpTf8eN5wY0XSLu02un6jYjFqge94Pc3ypIg4PBja
         NmH5n9qGyZwcCotGP/GFohONvT4+dpZqj+HiDMGhoa91N+EpYjfA3BRN0Bf416vPZoSt
         DOdi50ATkHdOas4YAuMEZVm7CSCjb1+6zLprwGLQUg54Ov7kcIHQF30n7fy8shYWUX8C
         xY0ZB0J9LQ3XPru2Gfh/Tv/exIMAYtcnJWULr9CPPIqnjBu5Zp3j0LZLMSruBZe1bh2R
         R3VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=Ni63gAQOgqL3rVx5QRs1Ql+8uMsi8IRaIfTqyv6SPMg=;
        b=SErehoT2WRnOzGHrnB3tF1qqNB5ydTshVKV502vg8VKQazWFf1nB75YPby7BMs/4vO
         vZgUAFqrARev0CjB9lW0KQZhxlva4epwHugYKeHMHxMb+FXGFpTIzOb0FXqzC4Q8/BWb
         f5HPsSkaEOaeMFaOcNawy7dsR9Z+Ql1a5pfkXglBXIoUNasqKy7L3Muy4agJRbBMqLs9
         F4SFrY7h4ewQYkD0GQcs3c2eRMDTkWArKqqnQKTNfg72xSDNM0yZspFGM/l4FWER6ey9
         pN5t0U6IA0rlurk/bChf73yCsFgvUj2d1dPN1jllWqfb7l3uWRZ1RrGomM5ZnDykJavQ
         TQhw==
X-Gm-Message-State: ACgBeo2h6FOoEk07ZKDCSJ83fC8xgw0KK1FkkVnB3CXNWcWHZYsS4OtG
        VEnAbmX4xS/xpqDqRtG9jUI=
X-Google-Smtp-Source: AA6agR5ysDU+Ec8zr+8uvEcFpdBosOFWEpDQaOGMEESNVEfrh63BdHRTCc7U3AiVqOtgkZmdGYgQ0Q==
X-Received: by 2002:ae9:ef82:0:b0:6b9:6e9a:3da1 with SMTP id d124-20020ae9ef82000000b006b96e9a3da1mr3119057qkg.696.1660015828299;
        Mon, 08 Aug 2022 20:30:28 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id ay36-20020a05622a22a400b0033ae41bd326sm8635779qtb.73.2022.08.08.20.30.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Aug 2022 20:30:26 -0700 (PDT)
Message-ID: <f5c4d092-eeb7-2342-605f-7d86df9b1b10@gmail.com>
Date:   Mon, 8 Aug 2022 20:30:23 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.1
Subject: Re: [PATCH v1] idb: Add lock to avoid data race
Content-Language: en-US
To:     Lin Ma <linma@zju.edu.cn>, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, intel-wired-lan@lists.osuosl.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org
References: <20220809025953.2311-1-linma@zju.edu.cn>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220809025953.2311-1-linma@zju.edu.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/8/2022 7:59 PM, Lin Ma wrote:
> The commit c23d92b80e0b ("igb: Teardown SR-IOV before
> unregister_netdev()") places the unregister_netdev() call after the
> igb_disable_sriov() call to avoid functionality issue.
> 
> However, it introduces several race conditions when detaching a device.
> For example, when .remove() is called, the below interleaving leads to
> use-after-free.
> 
>   (FREE from device detaching)      |   (USE from netdev core)
> igb_remove                         |  igb_ndo_get_vf_config
>   igb_disable_sriov                 |  vf >= adapter->vfs_allocated_count?
>    kfree(adapter->vf_data)          |
>    adapter->vfs_allocated_count = 0 |
>                                     |    memcpy(... adapter->vf_data[vf]
> 
> Moreover, just as commit 1e53834ce541 ("ixgbe: Add locking to
> prevent panic when setting sriov_numvfs to zero") shows. The
> igb_disable_sriov function also need to watch out the requests from VF
> driver.
> 
> To this end, this commit first eliminates the data races from netdev
> core by using rtnl_lock (similar to commit 719479230893 ("dpaa2-eth: add
> MAC/PHY support through phylink")). And then adds a spinlock just as
> 1d53834ce541 did.
> 
> Fixes: c23d92b80e0b ("igb: Teardown SR-IOV before unregister_netdev()")
> Signed-off-by: Lin Ma <linma@zju.edu.cn>

You have a typo in your subject: s/idb/igb/
-- 
Florian
