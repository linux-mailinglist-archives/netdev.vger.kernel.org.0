Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D21F6F102B
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 04:00:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344793AbjD1CAr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 22:00:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344810AbjD1CAp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 22:00:45 -0400
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E904840F0;
        Thu, 27 Apr 2023 19:00:39 -0700 (PDT)
Received: by mail-ot1-x32b.google.com with SMTP id 46e09a7af769-6a5f602a8f7so6867275a34.1;
        Thu, 27 Apr 2023 19:00:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682647239; x=1685239239;
        h=in-reply-to:from:content-language:references:cc:to:subject
         :user-agent:mime-version:date:message-id:sender:from:to:cc:subject
         :date:message-id:reply-to;
        bh=I2fuOCNIZXwXz+mx8tlXZhENNI/BzFR5eBuoszP6NEo=;
        b=OLOSJGO/vraN5WQ0u3DI+V+U4CNhPGsNlznwf5voYGdVinNETFtYiHrJdMv80KtfR8
         puxBUZ3dwATG7d3YGEUvBhPMtF766lHhyxLOhY5z9nMhHItLwUckVltIWzixgzV7I+Rz
         BGZm7tCQPUU/2bswJQmlP+3tvDgJAf0gH1siK1OiW68GrAWuBd9d+Eo21SvF8LJocNm7
         cV4SJ1C3xMfaEUP9usSLuOpYoAnGLinAzdeRTaWnlmFtHFkHliYht2iDe3xGyCAln3Hb
         gLlBWW/zkrNIcq8G+wEu4kQSDJXxd9oggHaMSBxUzNhWFtYKQffvHqTZSLrDFSr6fjDx
         IdYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682647239; x=1685239239;
        h=in-reply-to:from:content-language:references:cc:to:subject
         :user-agent:mime-version:date:message-id:sender:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=I2fuOCNIZXwXz+mx8tlXZhENNI/BzFR5eBuoszP6NEo=;
        b=ThBx6PxainK3Xs/aiLmjXQPh3z5yQJCEAcwZmiq+5cJTDov/QrsF9B1SS5SkekYxmQ
         JgPgkYRIR9vQROOojAUce+d4DCdO/0OK+UNp3+HMIhLtJyUSc2h8wwX934ee7RVb/iGj
         OZq55TFZPrlDiYIzJjp9s+Gnc3smBq5oQmhyGfJL0Z5QVYE9lSdAY862/bfWBZiQPSSU
         Pb+9pJtke9DhuNuXGJumD3IazlXQ7IbkudT2iGCob9DTMk6XwDCNRJOEM76FvMb6DUzW
         K1e2lA2IbdN9pgql5BwbZpsp/GCE7YcbRETvubuyfNC8XFKbhdRonFplhPzEEbH5iRPQ
         1Czw==
X-Gm-Message-State: AC+VfDxaXpCp9F14lRz4sdcgTXd8okEc8EFAhQGaS9m8MaE2XVno9Mgk
        SD1iKSO3Phi72Gi0ktm/IeeY9OwZQ38=
X-Google-Smtp-Source: ACHHUZ4rLeGQhDH5kZOot6k9J4Y1ZmJ1sM9Co3s+j8nP2RFJhQFqzPGmd8aroDvP/u61BOw9hPHMTw==
X-Received: by 2002:a05:6830:1e0e:b0:6a6:3fec:c197 with SMTP id s14-20020a0568301e0e00b006a63fecc197mr1636885otr.38.1682647239040;
        Thu, 27 Apr 2023 19:00:39 -0700 (PDT)
Received: from [192.168.0.143] ([216.130.59.33])
        by smtp.gmail.com with ESMTPSA id v19-20020a9d4e93000000b006a5f2111226sm8523636otk.55.2023.04.27.19.00.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Apr 2023 19:00:38 -0700 (PDT)
Sender: Larry Finger <larry.finger@gmail.com>
Content-Type: multipart/mixed; boundary="------------1Z6k6nMckqgHmYBAFUkW9KKH"
Message-ID: <866570c9-38d8-1006-4721-77e2945170b9@lwfinger.net>
Date:   Thu, 27 Apr 2023 21:00:28 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH] wifi: rtl8xxxu: fix authentication timeout due to
 incorrect RCR value
To:     Yun Lu <luyun_611@163.com>, Jes.Sorensen@gmail.com
Cc:     kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
References: <20230427020512.1221062-1-luyun_611@163.com>
Content-Language: en-US
From:   Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <20230427020512.1221062-1-luyun_611@163.com>
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a multi-part message in MIME format.
--------------1Z6k6nMckqgHmYBAFUkW9KKH
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/26/23 21:05, Yun Lu wrote:
> From: Yun Lu <luyun@kylinos.cn>
> 
> When using rtl8192cu with rtl8xxxu driver to connect wifi, there is a
> probability of failure, which shows "authentication with ... timed out".
> Through debugging, it was found that the RCR register has been inexplicably
> modified to an incorrect value, resulting in the nic not being able to
> receive authenticated frames.
> 
> To fix this problem, add regrcr in rtl8xxxu_priv struct, and store
> the RCR value every time the register is writen, and use it the next
> time the register need to be modified.

I added the attached patch to see what was different between the two values in 
REG_RCR. To my surprise, nothing was logged.

Please add this one on top of you proposed patch, and send me the output from 
the log.

Thanks,

Larry


--------------1Z6k6nMckqgHmYBAFUkW9KKH
Content-Type: text/x-patch; charset=UTF-8; name="log_data.patch"
Content-Disposition: attachment; filename="log_data.patch"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL01ha2VmaWxlIGIvTWFrZWZpbGUKaW5kZXggZjU1NDNlZWY0ZjgyLi42
ZDk4NWExNzVkNzggMTAwNjQ0Ci0tLSBhL01ha2VmaWxlCisrKyBiL01ha2VmaWxlCkBAIC0x
LDggKzEsOCBAQAogIyBTUERYLUxpY2Vuc2UtSWRlbnRpZmllcjogR1BMLTIuMAogVkVSU0lP
TiA9IDYKLVBBVENITEVWRUwgPSAzCitQQVRDSExFVkVMID0gNAogU1VCTEVWRUwgPSAwCi1F
WFRSQVZFUlNJT04gPQorRVhUUkFWRVJTSU9OID0gLXJjMAogTkFNRSA9IEh1cnIgZHVyciBJ
J21hIG5pbmphIHNsb3RoCiAKICMgKkRPQ1VNRU5UQVRJT04qCmRpZmYgLS1naXQgYS9kcml2
ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0bDh4eHh1L3J0bDh4eHh1X2NvcmUuYyBiL2Ry
aXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnRsOHh4eHUvcnRsOHh4eHVfY29yZS5jCmlu
ZGV4IDgzMTYzOWQ3MzY1Ny4uYjUyMTJjZWI0ZWI0IDEwMDY0NAotLS0gYS9kcml2ZXJzL25l
dC93aXJlbGVzcy9yZWFsdGVrL3J0bDh4eHh1L3J0bDh4eHh1X2NvcmUuYworKysgYi9kcml2
ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0bDh4eHh1L3J0bDh4eHh1X2NvcmUuYwpAQCAt
NjUwNCw2ICs2NTA0LDEwIEBAIHN0YXRpYyB2b2lkIHJ0bDh4eHh1X2NvbmZpZ3VyZV9maWx0
ZXIoc3RydWN0IGllZWU4MDIxMV9odyAqaHcsCiAJc3RydWN0IHJ0bDh4eHh1X3ByaXYgKnBy
aXYgPSBody0+cHJpdjsKIAl1MzIgcmNyID0gcHJpdi0+cmVncmNyOwogCisJaWYgKHJjciAh
PSBydGw4eHh4dV9yZWFkMzIocHJpdiwgUkVHX1JDUikpIHsKKwkJcHJfaW5mbygiQkVGT1JF
OiBSRUdfUkNSIGRpZmZlcnMgZnJvbSByZWdyY3I6IDB4JXggaW5zdGVkIG9mIDB4JXhcbiIs
CisJCQlydGw4eHh4dV9yZWFkMzIocHJpdiwgUkVHX1JDUiksIHByaXYtPnJlZ3Jjcik7CisJ
fQogCWRldl9kYmcoJnByaXYtPnVkZXYtPmRldiwgIiVzOiBjaGFuZ2VkX2ZsYWdzICUwOHgs
IHRvdGFsX2ZsYWdzICUwOHhcbiIsCiAJCV9fZnVuY19fLCBjaGFuZ2VkX2ZsYWdzLCAqdG90
YWxfZmxhZ3MpOwogCkBAIC02NTQ3LDYgKzY1NTEsMTAgQEAgc3RhdGljIHZvaWQgcnRsOHh4
eHVfY29uZmlndXJlX2ZpbHRlcihzdHJ1Y3QgaWVlZTgwMjExX2h3ICpodywKIAkgKiBGSUZf
UFJPQkVfUkVRIGlnbm9yZWQgYXMgcHJvYmUgcmVxdWVzdHMgYWx3YXlzIHNlZW0gdG8gYmUg
YWNjZXB0ZWQKIAkgKi8KIAorCWlmIChyY3IgIT0gcnRsOHh4eHVfcmVhZDMyKHByaXYsIFJF
R19SQ1IpKSB7CisJCXByX2luZm8oIkFGVEVSOiBSRUdfUkNSIGRpZmZlcnMgZnJvbSByZWdy
Y3I6IDB4JXggaW5zdGVkIG9mIDB4JXhcbiIsCisJCQlydGw4eHh4dV9yZWFkMzIocHJpdiwg
UkVHX1JDUiksIHByaXYtPnJlZ3Jjcik7CisJfQogCXJ0bDh4eHh1X3dyaXRlMzIocHJpdiwg
UkVHX1JDUiwgcmNyKTsKIAlwcml2LT5yZWdyY3IgPSByY3I7CiAK

--------------1Z6k6nMckqgHmYBAFUkW9KKH--
