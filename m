Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC0306CB294
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 01:41:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229803AbjC0XlE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 19:41:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbjC0XlD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 19:41:03 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E39CB7
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 16:41:02 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id k17so4658347iob.1
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 16:41:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1679960461;
        h=to:in-reply-to:cc:references:message-id:date:subject:mime-version
         :from:content-transfer-encoding:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JoaFrK1DNRcSQ1ImrxF44n1yrzlCAr4sckNkLw8fzgI=;
        b=ynLrYPNn6MrJNCQybk3kIizkcAFvpdHlUVrlKkTSEFf6vsFf0NdNb+GzmdccfMMi+v
         p/5kub3wqmBElnCB9zoFf+tyhpFJxH8e3odsVyR7ElHioJdCKTwnELseuFLpqNZ1GXst
         RfQwqM7KRmF6SJLzKxuUt2U71O2SiEPJgAcMKPo2s2vCSmvLcuNyseaV5JUdddVN5Wxl
         yKqoc2ZLtUQ+jTyZuvgmGSnOm2lZlNi3EFvV4hu+erMjPY0ZBgc/+oxrOiq65jq9A4nF
         ywPBjX1FsxgQaWaz+1NdPITcer+pRX4EGMdVBlH/jqi7CIcbFTegj1TfoWlkhHc98ZI/
         F1GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679960461;
        h=to:in-reply-to:cc:references:message-id:date:subject:mime-version
         :from:content-transfer-encoding:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JoaFrK1DNRcSQ1ImrxF44n1yrzlCAr4sckNkLw8fzgI=;
        b=Ssevmhs6qkrsS+YBmun/biKUewSlJdS1Qnd/1AZhASaTEF6gCH0ZjPqMO1bgaAEXTo
         4ZGLRz9AOBfRf9SYpfiBUSZkc9lewnhgpSMmJgqvjDYtXEzbc3xUke65ZYRXazLZbk7C
         oj3Yzsg6Rdgnb2RDEMDloZlh1WdbnvGWOX0kkRsMdyO2N+FSLginjEeKtIB825a6GGjb
         ylaN2tDu3I8Jfd/OSskXMWXiI2nXMgeZ7aUqNBTAxzUMCXxyZPP5oFW6qxACJWXacyup
         YpTTBFNgt6aoGPveyPQZeso5MXOPPlww5nqU+WLU4pgnpuiMNa6TPAVFYwj3MlsQGsJt
         WaqA==
X-Gm-Message-State: AO0yUKUzvQH3xfTBe2OFWmllqXRXRiE0qmZhuJQIENXFjjTow3wztF8Z
        AL1jmws8tJ2UIDo1Mljx1eYhSw==
X-Google-Smtp-Source: AK7set+bRCdcdl3Ae9vYyBV57C+4JF+6Noaiw/aikNo5KecpU4wjfRCVr2njCldm4zVFNaxS7XZmZQ==
X-Received: by 2002:a6b:720b:0:b0:74c:bc14:46a1 with SMTP id n11-20020a6b720b000000b0074cbc1446a1mr10993237ioc.4.1679960461433;
        Mon, 27 Mar 2023 16:41:01 -0700 (PDT)
Received: from smtpclient.apple ([152.179.59.114])
        by smtp.gmail.com with ESMTPSA id g8-20020a6b7608000000b0074c7db1470dsm8107156iom.20.2023.03.27.16.41.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Mar 2023 16:41:00 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Alex Elder <alex.elder@linaro.org>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH net] net: ipa: compute DMA pool size properly
Date:   Mon, 27 Mar 2023 18:40:49 -0500
Message-Id: <2E9EE299-E500-429E-9D19-CA8A55326100@linaro.org>
References: <20230327211627.GA3248042@hu-bjorande-lv.qualcomm.com>
Cc:     Alex Elder <elder@linaro.org>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        caleb.connolly@linaro.org, mka@chromium.org, evgreen@chromium.org,
        andersson@kernel.org, quic_cpratapa@quicinc.com,
        quic_avuyyuru@quicinc.com, quic_jponduru@quicinc.com,
        quic_subashab@quicinc.com, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20230327211627.GA3248042@hu-bjorande-lv.qualcomm.com>
To:     Bjorn Andersson <quic_bjorande@quicinc.com>
X-Mailer: iPhone Mail (20D67)
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Mar 27, 2023, at 4:16 PM, Bjorn Andersson <quic_bjorande@quicinc.com> w=
rote:
>=20
> =EF=BB=BFOn Sun, Mar 26, 2023 at 11:52:23AM -0500, Alex Elder wrote:
>> In gsi_trans_pool_init_dma(), the total size of a pool of memory
>> used for DMA transactions is calculated.  However the calculation is
>> done incorrectly.
>>=20
>> For 4KB pages, this total size is currently always more than one
>> page, and as a result, the calculation produces a positive (though
>> incorrect) total size.  The code still works in this case; we just
>> end up with fewer DMA pool entries than we intended.
>>=20
>> Bjorn Andersson tested booting a kernel with 16KB pages, and hit a
>> null pointer derereference in sg_alloc_append_table_from_pages(),
>> descending from gsi_trans_pool_init_dma().  The cause of this was
>> that a 16KB total size was going to be allocated, and with 16KB
>> pages the order of that allocation is 0.  The total_size calculation
>> yielded 0, which eventually led to the crash.
>>=20
>> Correcting the total_size calculation fixes the problem.
>>=20
>> Reported-by: <quic_bjorande@quicinc.com>
>> Tested-by: <quic_bjorande@quicinc.com>
>=20
> It would be nice to add "Bjorn Andersson" to these two.
>=20

Oh yeah sorry about that. I=E2=80=99ll add it.   -Alex

> Regards,
> Bjorn
>=20
>> Fixes: 9dd441e4ed57 ("soc: qcom: ipa: GSI transactions")
>> Signed-off-by: Alex Elder <elder@linaro.org>
>> ---
>> drivers/net/ipa/gsi_trans.c | 2 +-
>> 1 file changed, 1 insertion(+), 1 deletion(-)
>>=20
>> diff --git a/drivers/net/ipa/gsi_trans.c b/drivers/net/ipa/gsi_trans.c
>> index 0f52c068c46d6..ee6fb00b71eb6 100644
>> --- a/drivers/net/ipa/gsi_trans.c
>> +++ b/drivers/net/ipa/gsi_trans.c
>> @@ -156,7 +156,7 @@ int gsi_trans_pool_init_dma(struct device *dev, struc=
t gsi_trans_pool *pool,
>>     * gsi_trans_pool_exit_dma() can assume the total allocated
>>     * size is exactly (count * size).
>>     */
>> -    total_size =3D get_order(total_size) << PAGE_SHIFT;
>> +    total_size =3D PAGE_SIZE << get_order(total_size);
>>=20
>>    virt =3D dma_alloc_coherent(dev, total_size, &addr, GFP_KERNEL);
>>    if (!virt)
>> --=20
>> 2.34.1
>>=20
