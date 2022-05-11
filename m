Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81447522DFB
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 10:14:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243365AbiEKIOR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 04:14:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233000AbiEKION (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 04:14:13 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAC3D663D9
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 01:14:11 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id iq2-20020a17090afb4200b001d93cf33ae9so4216410pjb.5
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 01:14:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:to:references:from
         :in-reply-to:content-transfer-encoding;
        bh=DwtwD/pThT7dyzm2eofuhTSEvuiZjVz4GYgjeGZ1hZ8=;
        b=prB2z2rN/aH7CG5Y8tItKrpysptNiBBdQXbQB+8MpZwB2WRylRNza1/TAlCqdT5Fhr
         mny6vBYFXErxWssOGNTzXUnpLzajYQgjD+RZ6DhD3aQ6OzL0j81v/zKcBSUYg830Rg9B
         B40pGMuWvqjyDNSCftpK20CnNBeUYeJRyRfrJzr0Pz/sKSi6b8HnYs39qEmC4v0v9aMi
         +B226hm+Jf8qe85fcqbNP5O+NuI/JYAxtCJU5bNtJwRAoi1pU0+8Q0AaU228hbp77j67
         4aisjPC4DOosVt2ZQtT8bi73oC5YuhtRO9kF4xb0g4ylXF04srVfDDTyFAYwOl1D+aPb
         KAYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :to:references:from:in-reply-to:content-transfer-encoding;
        bh=DwtwD/pThT7dyzm2eofuhTSEvuiZjVz4GYgjeGZ1hZ8=;
        b=wuxZfesHoilX0CLIjA6ySc6+tofVnnLYx0spvENJ45cTPPk0pibUzXmpkAxawfkTVa
         Q79Dc2uBlxDnfqwmXWCKNjisGpcshUXAVpcd6KImAsq1+dfz1coSzzbATY7glyy5fu3m
         V4YyZvvWqz0+EvfyupE8228abjB9E2stiXZxUnMWKWOGuyx3haSPwyrNmFZ/ZtEqnQXM
         lFu+NAB5GtcTy4k5RV01lHz4f6TglzTKQXvRLYR01TgW4344jTUTIhL0n5tMr2GgJCSt
         Kx2/lcn+hvRgFBMx4WLms4WPlkeGJTtU0kTqPM5h5Z+p1nI00ITL+XtESgp00j/eBvxv
         HCpQ==
X-Gm-Message-State: AOAM531+H6kKzVdYBQMFhG9Bt7PDO2+5BPOfxyl/KJTDQbj2aPuXY4NJ
        ye7KbONT7OOfvffDY+BgIjk=
X-Google-Smtp-Source: ABdhPJxRw9QNTQuCOMsDh3mg/qAm/q81Eubm62Ix1bBVTL51Op5VcDZa81zZNVckVgtkiS0kKGDhHA==
X-Received: by 2002:a17:90a:ce13:b0:1d9:acbe:7ede with SMTP id f19-20020a17090ace1300b001d9acbe7edemr4134218pju.16.1652256851117;
        Wed, 11 May 2022 01:14:11 -0700 (PDT)
Received: from [172.25.58.87] ([203.246.171.161])
        by smtp.gmail.com with ESMTPSA id y13-20020a170902d64d00b0015e8d4eb2e0sm1036747plh.298.2022.05.11.01.14.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 May 2022 01:14:10 -0700 (PDT)
Message-ID: <9888e938-f987-79b2-2a27-89674baaef6c@gmail.com>
Date:   Wed, 11 May 2022 17:14:06 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [PATCH net 2/2] net: sfc: siena: fix memory leak in
 siena_mtd_probe()
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, ecree.xilinx@gmail.com, netdev@vger.kernel.org
References: <20220510153619.32464-1-ap420073@gmail.com>
 <20220510153619.32464-3-ap420073@gmail.com>
 <20220511062503.s7ndwcvzxzkyyniq@gmail.com>
From:   Taehee Yoo <ap420073@gmail.com>
In-Reply-To: <20220511062503.s7ndwcvzxzkyyniq@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2022. 5. 11. 오후 3:25에 Martin Habets 이(가) 쓴 글:

Hi Martin,
Thanks a lot for your review!

 > On Tue, May 10, 2022 at 03:36:19PM +0000, Taehee Yoo wrote:
 >> In the NIC ->probe callback, ->mtd_probe() callback is called.
 >> If NIC has 2 ports, ->probe() is called twice and ->mtd_probe() too.
 >> In the ->mtd_probe(), which is siena_mtd_probe() it allocates and
 >> initializes mtd partiion.
 >> But mtd partition for sfc is shared data.
 >> So that allocated mtd partition data from last called
 >> siena_mtd_probe() will not be used.
 >
 > On Siena the 2nd port does have MTD partitions. In the output
 > from /proc/mtd below eth3 is the 1st port and eth4 is the 2nd
 > port:
 >
 > mtd12: 00030000 00010000 "eth3 sfc_mcfw:0b"
 > mtd13: 00010000 00010000 "eth3 sfc_dynamic_cfg:00"
 > mtd14: 00030000 00010000 "eth3 sfc_exp_rom:01"
 > mtd15: 00010000 00010000 "eth3 sfc_exp_rom_cfg:00"
 > mtd16: 00120000 00010000 "eth3 sfc_fpga:01"
 > mtd17: 00010000 00010000 "eth4 sfc_dynamic_cfg:00"
 > mtd18: 00010000 00010000 "eth4 sfc_exp_rom_cfg:00"
 >
 > So this patch is not needed, and efx_mtd_remove() will free
 > the memory for both ports.
 >

Okay, I will send a v2 patch tomorrow, that will drop this patch and 
unnecessary cover-letter.

Thanks!
Taehee Yoo

 > Martin
 >
 >> Therefore it must be freed.
 >> But it doesn't free a not used mtd partition data in siena_mtd_probe().
 >>
 >> Fixes: 8880f4ec21e6 ("sfc: Add support for SFC9000 family (2)")
 >> Signed-off-by: Taehee Yoo <ap420073@gmail.com>
 >> ---
 >>   drivers/net/ethernet/sfc/siena.c | 5 +++++
 >>   1 file changed, 5 insertions(+)
 >>
 >> diff --git a/drivers/net/ethernet/sfc/siena.c 
b/drivers/net/ethernet/sfc/siena.c
 >> index ce3060e15b54..8b42951e34d6 100644
 >> --- a/drivers/net/ethernet/sfc/siena.c
 >> +++ b/drivers/net/ethernet/sfc/siena.c
 >> @@ -939,6 +939,11 @@ static int siena_mtd_probe(struct efx_nic *efx)
 >>   		nvram_types >>= 1;
 >>   	}
 >>
 >> +	if (!n_parts) {
 >> +		kfree(parts);
 >> +		return 0;
 >> +	}
 >> +
 >>   	rc = siena_mtd_get_fw_subtypes(efx, parts, n_parts);
 >>   	if (rc)
 >>   		goto fail;
 >> --
 >> 2.17.1
