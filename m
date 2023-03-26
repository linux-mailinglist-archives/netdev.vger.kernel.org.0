Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CB4A6C9731
	for <lists+netdev@lfdr.de>; Sun, 26 Mar 2023 19:33:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230192AbjCZRc6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Mar 2023 13:32:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbjCZRc5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Mar 2023 13:32:57 -0400
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3076E49D2;
        Sun, 26 Mar 2023 10:32:55 -0700 (PDT)
Received: by mail-oi1-x234.google.com with SMTP id bf30so4713352oib.12;
        Sun, 26 Mar 2023 10:32:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679851974;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=kMIdTPrzs9W2bcOisGTJ32C4tZONe5VcnIYDts13aIw=;
        b=nqNPvS2vEQB9efoFo76JN7ONcu10HLvy2l6zDGCpZmhWoP3oDJITiKYFyR2UA6ylZX
         awrzoBNXSNjmAOOgckqCsw0ZF2HdzXbWe8jpW8/tJzbX6HVqLQnEU6u5J7FBZDLjksTv
         BSGEGgpIJQG7+N3d3OrQnCJVSBRFko45xnzAtvWoxcgJWPK1mqFUtl7lmknTkOeCxsAB
         LzpNO6MVG2bjmWGmYpC6Dx1iUbxzFZgzczeJvoy6K+V1tDUSQWBJP6nj1H9JzhgbRUDa
         EPGh7KEUD+CouiOeFE/Xh4H+RQ2sJKFk39vU8oUzS0MC6ZEk8KJSU+ewb7N802+fSqt0
         8uyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679851974;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kMIdTPrzs9W2bcOisGTJ32C4tZONe5VcnIYDts13aIw=;
        b=toRsyzO4eFcPJmz70an2qLAnzIB2dPo3tIjY7DU9YtckfZkQyiLAMF48sWpHaMaMFd
         aA0shaR6xsj1XiQ91kXcUkWFtiP1OWhrbvPtvng2JyZn7j6782lH2UT1qvH4XKCphcan
         z5d3OttLyPEd+Pw0fV6aiED9UGmFFM1ZOJxc6brPzfdpAPhQaB6CTqMzY7ifkjO6Rf2n
         fKZJAKjc6Ror4GNG+AqrPVLQfbz/nsQHketWNr9xZMrxBDLQGDU0a3XJns2K6OkwfAD1
         MZszRGzl/ikIed+cziTob1ceM+tcPfx2wt3JR8Y/M19HbSUrHZYwmifEGEWZ7TBeYg43
         H0nQ==
X-Gm-Message-State: AO0yUKVNSOffS6XUnvd5E1cEmuCJ6S83Ulf687DaAR7x1XbReBsfHrWF
        ZgcxUoGhaIEDjWmO4mxGYS8=
X-Google-Smtp-Source: AK7set/49UtlldFI6p/rQrGSVBcq35E2L5hx8hQveh7EcQGyM0FugN5APVKlOsGtnXSC2SkRcy1vAA==
X-Received: by 2002:a05:6808:15a7:b0:386:e073:6996 with SMTP id t39-20020a05680815a700b00386e0736996mr5472851oiw.26.1679851974518;
        Sun, 26 Mar 2023 10:32:54 -0700 (PDT)
Received: from [192.168.1.204] ([216.130.59.33])
        by smtp.gmail.com with ESMTPSA id i206-20020acaead7000000b003874e6dfeefsm4607368oih.37.2023.03.26.10.32.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Mar 2023 10:32:54 -0700 (PDT)
Sender: Larry Finger <larry.finger@gmail.com>
Message-ID: <307ebdbb-1b0f-43df-04b1-a2275adcee72@lwfinger.net>
Date:   Sun, 26 Mar 2023 12:32:52 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH] wireless: rtlwifi: fix incorrect error codes in
 rtl_debugfs_set_write_rfreg()
Content-Language: en-US
To:     Simon Horman <simon.horman@corigine.com>,
        Wei Chen <harperchen1110@gmail.com>
Cc:     pkshih@realtek.com, kvalo@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230325083429.3571917-1-harperchen1110@gmail.com>
 <ZB7DSn3wfjU9OVgJ@corigine.com>
 <CAO4mrfduRPKLruShN76VDOMAeZF=A7f84=vcamnHPCtMLGuRvA@mail.gmail.com>
 <ZB/8YDQwc6uzHbZo@corigine.com>
From:   Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <ZB/8YDQwc6uzHbZo@corigine.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=0.4 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/26/23 03:03, Simon Horman wrote:
> On Sun, Mar 26, 2023 at 01:47:51PM +0800, Wei Chen wrote:
>> Dear Simon,
>>
>> Thanks for the advice and review. I have sent the second version of the patch.
>>
>> Besides, rtl_debugfs_set_write_reg also suffers from the incorrect
>> error code problem. I also sent v2 of the corresponding patch. Hope
>> there is no confusion between these two patches.
> 
> Thanks. I now see there are two similar but different patches. My bad.

Avoid all such misunderstandings by making a patch set.

Larry

