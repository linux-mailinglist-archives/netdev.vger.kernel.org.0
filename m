Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26BAA60B3D3
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 19:17:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231835AbiJXRRn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 13:17:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231960AbiJXRRH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 13:17:07 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97E77EE0E;
        Mon, 24 Oct 2022 08:51:49 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id bu30so16944594wrb.8;
        Mon, 24 Oct 2022 08:51:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=12Hfsvc693TZxjDoiKEIy9pxMoUJGBSzkAbLmqYNUHc=;
        b=MBySkf9aiTOI+X0qset5bfU5PmhUY3Ddaq86yiT1By0eVERf8SGpEeZpxIFyVTJT5F
         yUdEstP4Ftp6i17BqHD6xRh1NNuu/bFwj+j9EedEGRk8Vm/D7/79iUMl8G2VoGkZhm1Z
         +eu3sEytauSBAkVW2OBZktRjqAHjwPxZ43MyGARfBCc3onPefeVwvswHGkgZ1JrXSf7/
         n4k3vxKaiH6OQtbeWrL2zVOWM8k3z56iQyspfP89r7TC1mUVR+b6c17JLHui95+x9/y2
         x2vDtI2Hs/ljNsKzmRpQSs9I1X9DQ8nU4dT2xjc+eoCEFy3cNty2sym4/m0JK9/VjihE
         ERQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=12Hfsvc693TZxjDoiKEIy9pxMoUJGBSzkAbLmqYNUHc=;
        b=jEkbzvcHc4eOP2CQgDD3pVCGRXphWGo4Gz6TSDyCQ8ornbJgAHcwrNHl33jkTJ8uCq
         W+KLDk5Sf+Whuktazcmt6wdUL7BBJghowUTv3DfHx1GyFCDCXJahyaMlxxvqc6gb7+G3
         NwGv6RlW4doEthqQNRxz/CTYcaqUnZawBkOYZQ1peQSz6cgOTJQ9kumAvI8GmHr8fxnj
         g4t+zJj54uocDyiSQUneqgw+ddHLPJ5C/t4LTNT5XjMySe/dp779X/r+JsxGnEcx87Gf
         68ct01ZTxIr3fV9NzwREtqRj0pA95OLH2pAekL0BWCJyw0LuYasMsptWK5zJIml0nrJQ
         mdYQ==
X-Gm-Message-State: ACrzQf1o9852AxWCIJLg8bDQPZg7Bs70ocoHhtluni1F9vUtUVAvBigf
        eiPuy0wONv9XlhE2nIeiZLlso1k572O8lZV1
X-Google-Smtp-Source: AMsMyM7ru3zgHPhzmq1cPiu4/GsUgya8geED2sp+Kl1Z2vuNu9KGxL3Ep5jk0PULaQ1+0iBhJn7zEg==
X-Received: by 2002:adf:eb84:0:b0:22a:917e:1c20 with SMTP id t4-20020adfeb84000000b0022a917e1c20mr21439631wrn.223.1666620061633;
        Mon, 24 Oct 2022 07:01:01 -0700 (PDT)
Received: from [192.168.0.210] (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.googlemail.com with ESMTPSA id v1-20020adfedc1000000b00228daaa84aesm27118102wro.25.2022.10.24.07.01.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Oct 2022 07:01:01 -0700 (PDT)
Message-ID: <aeec15d5-6f7a-2c4f-0f90-72c52d082ce8@gmail.com>
Date:   Mon, 24 Oct 2022 15:00:59 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Content-Language: en-US
To:     Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
From:   "Colin King (gmail)" <colin.i.king@gmail.com>
Subject: Variables being modified but not used in
 net/wireless/lib80211_crypt_tkip.c
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I was reviewing some clang scan build static analysis results and found 
an interesting warning:

Source: net/wireless/lib80211_crypt_tkip.c

net/wireless/lib80211_crypt_tkip.c:667:7: warning: variable 'iv32' set 
but not used [-Wunused-but-set-variable]
                 u32 iv32 = tkey->tx_iv32;

The variables iv32 and iv16 are being decremented, but are not 
referenced after that. The seq[] array is being updated with the 
pre-decremented values. Is that correct?

         if (seq) {
                 /* Return the sequence number of the last transmitted 
frame. */
                 u16 iv16 = tkey->tx_iv16;
                 u32 iv32 = tkey->tx_iv32;
                 if (iv16 == 0)
                         iv32--;
                 iv16--;
                 seq[0] = tkey->tx_iv16;
                 seq[1] = tkey->tx_iv16 >> 8;
                 seq[2] = tkey->tx_iv32;
                 seq[3] = tkey->tx_iv32 >> 8;
                 seq[4] = tkey->tx_iv32 >> 16;
                 seq[5] = tkey->tx_iv32 >> 24;
         }

         return TKIP_KEY_LEN;

Colin
