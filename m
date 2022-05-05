Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9162F51CCC4
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 01:32:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386801AbiEEXf4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 19:35:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233701AbiEEXfz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 19:35:55 -0400
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09C5C5E77F;
        Thu,  5 May 2022 16:32:14 -0700 (PDT)
Received: from fsav117.sakura.ne.jp (fsav117.sakura.ne.jp [27.133.134.244])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 245NVRdq069580;
        Fri, 6 May 2022 08:31:27 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav117.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav117.sakura.ne.jp);
 Fri, 06 May 2022 08:31:27 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav117.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 245NVRRH069575
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Fri, 6 May 2022 08:31:27 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <d9e6cf88-4f19-bd50-3d73-e2aee1caefa4@I-love.SAKURA.ne.jp>
Date:   Fri, 6 May 2022 08:31:24 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH v3 1/2] ath9k: fix use-after-free in ath9k_hif_usb_rx_cb
Content-Language: en-US
To:     Pavel Skripkin <paskripkin@gmail.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@toke.dk>,
        ath9k-devel@qca.qualcomm.com, kvalo@kernel.org,
        davem@davemloft.net, kuba@kernel.org, linville@tuxdriver.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+03110230a11411024147@syzkaller.appspotmail.com,
        syzbot+c6dde1f690b60e0b9fbe@syzkaller.appspotmail.com
References: <80962aae265995d1cdb724f5362c556d494c7566.1644265120.git.paskripkin@gmail.com>
 <87h799a007.fsf@toke.dk> <6f0615da-aa0b-df8e-589c-f5caf09d3449@gmail.com>
 <5fd22dda-01d6-cfae-3458-cb3fa23eb84d@I-love.SAKURA.ne.jp>
 <3cb712d9-c6be-94b7-6135-10b0eabba341@gmail.com>
From:   Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <3cb712d9-c6be-94b7-6135-10b0eabba341@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/05/06 4:09, Pavel Skripkin wrote:
>>> And we can meet NULL defer even if we leave drv_priv = priv initialization
>>> on it's place.
>>
>> I didn't catch the location. As long as "htc_handle->drv_priv = priv;" is done
>> before complete_all(&hif_dev->fw_done) is done, is something wrong?
>>
> 
> I don't really remember why I said that, but looks like I just haven't opened callbacks' code.

OK. Then, why not accept Pavel's patch?
