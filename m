Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02B244EF7E5
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 18:28:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235830AbiDAQaD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 12:30:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346360AbiDAQ1y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 12:27:54 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B6E5BAA
        for <netdev@vger.kernel.org>; Fri,  1 Apr 2022 08:58:12 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id 9so3672953iou.5
        for <netdev@vger.kernel.org>; Fri, 01 Apr 2022 08:58:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=oaN9C0oDq1idmqd2LmsOaaxM8zUlCcCIJMIjqQvndL4=;
        b=ea/IE/fe0VT/Rd2tjIq/T5uvj1KigQvyuF63fwmr58Epj4H7G6yUy7U1w0tkzNRX3d
         stblNmSfNTlJOAyYOqhZUihlV//5gdYlfbG3FJPVku+U8s+os579AyHpvO9YKhFvdXxe
         7ns9sglzF7d4QqAVTR+/QJBAyRghLLTY5DvAA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oaN9C0oDq1idmqd2LmsOaaxM8zUlCcCIJMIjqQvndL4=;
        b=AMOD1V2qxW8FngszjYDfsp08DVD0XcdCLVDPVxw9kNU9CRRGVFPKLGIMmjyHOU+pIV
         hciyU3WsBVqNiEub6cZJTZ4TPtFST4u1b19YBhPXTbYRtZmWFqwNT14rmDZNuJ2Tbilk
         WC2QdvUoTaEnczUo/1SxXS0VJNUoAEru+nqD+ppsRxoj176iE2k+pINQYWzqYBcK1bLV
         eynm2VxEBhXEucZ+aNUDtQAxsO8TAfdyGdD6LMz5Zd6ZLJHeB6Xv2/cu/Wr2F1ltet4M
         4uayWpG+jTFKIt51ns+NT+K6e46BR5uUA9e0oRE9k0Wkwf7zKbRpbpdQqaTA6+yopBDx
         u9fA==
X-Gm-Message-State: AOAM532arGCUnycnViBTB63YrxPMuPJRdSOwAil11HAB3rVLgeJ/LPqs
        iV2yQmmcmJBEt0KCYgB5Rsn66w==
X-Google-Smtp-Source: ABdhPJyVm5eJ6v6Sn0EKwc9zkAf28JqyDggWSu+3Pg9ORPXF0VPnMhMj12LBcd0SANEOxBPO/LSt/Q==
X-Received: by 2002:a05:6602:3787:b0:649:ec10:183b with SMTP id be7-20020a056602378700b00649ec10183bmr185159iob.117.1648828691712;
        Fri, 01 Apr 2022 08:58:11 -0700 (PDT)
Received: from [192.168.1.128] ([71.205.29.0])
        by smtp.gmail.com with ESMTPSA id c15-20020a92b74f000000b002c9cc44ede9sm1458833ilm.86.2022.04.01.08.58.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Apr 2022 08:58:11 -0700 (PDT)
Subject: Re: [PATCH] selftests/bpf: Return true/false (not 1/0) from bool
 functions
To:     Haowen Bai <baihaowen@meizu.com>, Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>
Cc:     linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1648779354-14700-1-git-send-email-baihaowen@meizu.com>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <7af611e7-88dd-9525-dccc-92bda4d1fb8d@linuxfoundation.org>
Date:   Fri, 1 Apr 2022 09:58:10 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <1648779354-14700-1-git-send-email-baihaowen@meizu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/31/22 8:15 PM, Haowen Bai wrote:
> Return boolean values ("true" or "false") instead of 1 or 0 from bool
> functions.  This fixes the following warnings from coccicheck:
> 
> ./tools/testing/selftests/bpf/progs/test_xdp_noinline.c:567:9-10: WARNING:
> return of 0/1 in function 'get_packet_dst' with return type bool
> ./tools/testing/selftests/bpf/progs/test_l4lb_noinline.c:221:9-10: WARNING:
> return of 0/1 in function 'get_packet_dst' with return type bool
> 

Thank you for including details on how the problem was found.

> Signed-off-by: Haowen Bai <baihaowen@meizu.com>
> ---

Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
