Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2522562C819
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 19:47:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229776AbiKPSrq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 13:47:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239414AbiKPSp0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 13:45:26 -0500
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66CD663CF1
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 10:44:40 -0800 (PST)
Received: by mail-il1-x12e.google.com with SMTP id bp12so9599112ilb.9
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 10:44:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6F8zpl58bT40JxRCaS05R51J3S3Cm7X4seeHIywQrFs=;
        b=G9FKTdHFM94LwDnKYS5xKSiYSZ6Klgc/e1X6czIeXi5ADydt5VC/Y1i2CqukKXDfMb
         TH3fbCu+CCV23jZ9OK2fqDMNizopoWMrYxHNFNZ+edTwowYKC/dYlayMgo88Wk2FGaxr
         EqLeEBDTXmCcmhynbLny9WYtNbkDuwXO6u7NGpA2Ees/gL6kN3tDL9lKgYsxtGJFvy0l
         z00kW0T6KTjqJuneg9b4XnnytM2/n2ZDkR5EpLLgCDDk74yrP0H46qXf+nRlave0ZWt4
         Thm42e6bZ94Vvs3hInMkSGz3kifigkK4I3u72SsSLl826SN20nuqQen+30PVovdrW+58
         58jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6F8zpl58bT40JxRCaS05R51J3S3Cm7X4seeHIywQrFs=;
        b=5K/GFRyYJELcQpTTyOcp6uoHAjMWF7bJ/L+jrAa6p5uBwcy/HspK+UmoTOOA/egcjk
         Cvjy7CNRuDUA+lzwApMmLXAfNHjMw8PtbovbfOiPR96q5iU60yN/3TUhcNNm/wl9+v2b
         OlWwCTHlisCG/SBICD3zfwwjhg8DlHfdYcnb+C2sZXQZjMn0B+HKlXyZCO5BjNx3HewL
         gM9FuTsbLfrxLxe5mZd6J0zhz6lcUrlY9SZpdgrw0jV3CgANsDJFwGOtW3Y5TDX8iElX
         JH+iiZBY98LLlXZTqpK5Bc4tChLy20tKaVoWPnw09zp9lRN0rtJ6eLNOkLXdc9Wx4JGG
         Ibng==
X-Gm-Message-State: ANoB5pmhtaQU/QDXcsrCCP4hUmQmFuhmmx2vQkg/ZquOmrCl3ZjHj/kn
        VqB0+Nyi8TgybsoXCjbxqhiJEQ==
X-Google-Smtp-Source: AA0mqf4H4NmH2GeAZ2fHObtyxSifcKL7+oq1AN7ckxhbHwnflINse6H77JNTx6Q+ynnTnWwP4tyBnw==
X-Received: by 2002:a92:db49:0:b0:300:f59b:6d0c with SMTP id w9-20020a92db49000000b00300f59b6d0cmr11478732ilq.107.1668624279689;
        Wed, 16 Nov 2022 10:44:39 -0800 (PST)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id p1-20020a92d481000000b002f9f001de24sm6513788ilg.21.2022.11.16.10.44.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Nov 2022 10:44:39 -0800 (PST)
Message-ID: <44c2f431-6fd0-13c7-7b53-59237e24380a@kernel.dk>
Date:   Wed, 16 Nov 2022 11:44:38 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [RFC PATCH v3 0/3] io_uring: add napi busy polling support
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, Stefan Roesch <shr@devkernel.io>
Cc:     kernel-team@fb.com, olivier@trillion01.com, netdev@vger.kernel.org,
        io-uring@vger.kernel.org
References: <20221115070900.1788837-1-shr@devkernel.io>
 <20221116103117.6b82e982@kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20221116103117.6b82e982@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/16/22 11:31 AM, Jakub Kicinski wrote:
> On Mon, 14 Nov 2022 23:08:57 -0800 Stefan Roesch wrote:
>> This adds the napi busy polling support in io_uring.c. It adds a new
>> napi_list to the io_ring_ctx structure. This list contains the list of
>> napi_id's that are currently enabled for busy polling. This list is
>> used to determine which napi id's enabled busy polling.
>>
>> To set the new napi busy poll timeout, a new io-uring api has been
>> added. It sets the napi busy poll timeout for the corresponding ring.
>>
>> There is also a corresponding liburing patch series, which enables this
>> feature. The name of the series is "liburing: add add api for napi busy
>> poll timeout". It also contains two programs to test the this.
>>
>> Testing has shown that the round-trip times are reduced to 38us from
>> 55us by enabling napi busy polling with a busy poll timeout of 100us.
> 
> Acked-by: Jakub Kicinski <kuba@kernel.org>
> 
> Thanks!

Thanks Jakub! Question on the need for patch 3, which I think came about
because of comments from you. Can you expand on why we need both an
enable and timeout setting? Are there cases where timeout == 0 and
enabled == true make sense?

-- 
Jens Axboe
