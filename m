Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D24D696812
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 16:28:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231824AbjBNP2c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 10:28:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233466AbjBNP2a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 10:28:30 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 538D046A1;
        Tue, 14 Feb 2023 07:28:27 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id k3so8424070wrv.5;
        Tue, 14 Feb 2023 07:28:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WVsl9l4EubhzJlt7TkkE/VNTIxfb0isBU8+MYISwK7w=;
        b=DOpPNahHnC142mma4PO3XTbnIwVWtu3B/uqnxqPa27pE2sFN46MFdKJFRufGbhgDu9
         d8HVz12d348C/Mp4UWXFnJyaOh4Vj0EVDpewFUN0FjMu+ZhCPUCi8Kf76egHC+5rUJnF
         kpZtbaxrv4o9J99Czj+TEZdLIc0BMQic42CAkeRBR28eJD/zA94J9M+odKE4KcHqc45g
         wTp33ngFmrHFOfzbXL8+CLz32OCsIOqEtV2Wd+mG1oR5GHObPjFShSz//Vh9GhKJeMbP
         PHnUIukU4okvkwVQ3wgsk/IUvQomjX2pj+9qtCTvK0sA3j5OiO+7kAUlxKLvgYOL8iMd
         KUog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WVsl9l4EubhzJlt7TkkE/VNTIxfb0isBU8+MYISwK7w=;
        b=77ZPe1iW+N/1nEIscuOBGRYs42Dl0uz/+uP4TRJgJn1iBajWIsayLgqCwMntgxCbay
         FF5LF6jX1o319zZYDNNC9qg+XFYcn01SdvJ6cq3D3KlqmQ0YZ0LPr1CCPMejlTrCzBwg
         s0wC6kK0Frdur2TyfkMMCbx2G43Vv/pWB5cBgRrbkDJJGaNE7DfEuhBy8voNDpj34lZc
         10VJWz4MAy4dhIMP64gmSQOFYpC0kovxWl6D4A/vfke8h4bOcLm0jJv77/Bts14Bfyon
         v6YZjxkWts08iC0I25P0x6LVEBFQD5jAFQaKY3+FTKQ/GlzVfYCxBiQxOf2qz+GRllgQ
         XHRw==
X-Gm-Message-State: AO0yUKVLheyqza8fc2vbEHiCRkn5ygKxFtiWeCEzVLR2yqHqnvBQOPbS
        Fd9Shf89B6nwLbyScmVYLQ0=
X-Google-Smtp-Source: AK7set80jw3RTF6Cz9Vwt0wRQ+3xqXTUz6ETuBMbMdkNuPsoAGqJCVrUnHnE3PGmALjRi8PQPaRs1w==
X-Received: by 2002:a5d:5226:0:b0:2c3:e993:9d7d with SMTP id i6-20020a5d5226000000b002c3e9939d7dmr2502114wra.30.1676388505927;
        Tue, 14 Feb 2023 07:28:25 -0800 (PST)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id t15-20020a5d534f000000b002c55306f6edsm7346177wrv.54.2023.02.14.07.28.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Feb 2023 07:28:25 -0800 (PST)
Subject: Re: [PATCH v7 net-next 2/8] sfc: add devlink info support for ef100
To:     Leon Romanovsky <leon@kernel.org>, alejandro.lucero-palau@amd.com
Cc:     netdev@vger.kernel.org, linux-net-drivers@amd.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, habetsm.xilinx@gmail.com,
        linux-doc@vger.kernel.org, corbet@lwn.net, jiri@nvidia.com
References: <20230213183428.10734-1-alejandro.lucero-palau@amd.com>
 <20230213183428.10734-3-alejandro.lucero-palau@amd.com>
 <Y+s6vrDLkpLRwtx3@unreal>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <ef18677a-74d0-87a7-5659-637e63714b15@gmail.com>
Date:   Tue, 14 Feb 2023 15:28:24 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <Y+s6vrDLkpLRwtx3@unreal>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/02/2023 07:39, Leon Romanovsky wrote:
> On Mon, Feb 13, 2023 at 06:34:22PM +0000, alejandro.lucero-palau@amd.com wrote:
>> +#ifdef CONFIG_RTC_LIB
>> +	u64 tstamp;
>> +#endif
> 
> If you are going to resubmit the series.
> 
> Documentation/process/coding-style.rst
>   1140 21) Conditional Compilation
>   1141 ---------------------------
> ....
>   1156 If you have a function or variable which may potentially go unused in a
>   1157 particular configuration, and the compiler would warn about its definition
>   1158 going unused, mark the definition as __maybe_unused rather than wrapping it in
>   1159 a preprocessor conditional.  (However, if a function or variable *always* goes
>   1160 unused, delete it.)
> 
> Thanks

FWIW, the existing code in sfc all uses the preprocessor
 conditional approach; maybe it's better to be consistent
 within the driver?
