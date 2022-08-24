Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1218E59F685
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 11:41:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235585AbiHXJlg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 05:41:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235637AbiHXJlf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 05:41:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4880233418
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 02:41:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661334093;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rXZAbOi80OJv3uidummRV0C+m8Czemv1wTSXuU14uGc=;
        b=N27Ewjd9B6KTvQuYFsvuwoBGrU3Dhf4T+6maws7V99qNznKp5Oi2Qy4tJUJFu+nudpWLSN
        r/SV0s69SksVE3MN/veXkM2fyZDEZfWyih2ISvzr5NdqVEtrUS4bK4OKPQGKNq2MunqiGi
        a65xLpVqxCHUBADCYGNBcfCyBc1dKOA=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-456-4MrfOO71NqqQoUeCPug2Xw-1; Wed, 24 Aug 2022 05:41:32 -0400
X-MC-Unique: 4MrfOO71NqqQoUeCPug2Xw-1
Received: by mail-wm1-f70.google.com with SMTP id ay21-20020a05600c1e1500b003a6271a9718so8948971wmb.0
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 02:41:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=rXZAbOi80OJv3uidummRV0C+m8Czemv1wTSXuU14uGc=;
        b=KeAG9Z6VrI6vYzMhhVL9rTMsU5C59zadyYhSVEcE+gEMwgyWyCkx1JZMbXA0iWyGY0
         TlYnjjVuqaqErV4ViebdVJkerGBfEcEte791PQpNgDQVUA/XvO/HUsav197cVOz5HulD
         fYt8mjOXP56HvV+oX3AtIZh5N5ULQujv3cpL2zz9ljtTkgG21wsYbYL1591Pl3rKlogd
         gzhEkvcJlBPWvXQZQiXJrOF1IvqqM3OZk+4RJlqvxl/h4r7lSrEUAPGdstzPOlrJcBln
         lgU0JWBk+SizKYO/JA5Wzc0p940ubNEtRmNIQj2CE5h1LNiKbH6fnwkkl/omKJ2tbu5n
         Aw6w==
X-Gm-Message-State: ACgBeo13FI1OQkxEQQidKBFpe2hfGoPlo5Z1NXYua4noU/50yScTXqk7
        p1NmvI1PslFOKmVPg1YRV/LVNz6glTGvsDnvf/wNRXiUFuCXbRyi9rdI2fZ0+FQLYmDONiCcI9X
        +EEYCnncGN3M2EKtM
X-Received: by 2002:adf:e4d0:0:b0:225:2947:3a5f with SMTP id v16-20020adfe4d0000000b0022529473a5fmr15483100wrm.387.1661334090890;
        Wed, 24 Aug 2022 02:41:30 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6A/ocXjWVRFdjan3P7MYJXQ6e2K34PdNA3e511oLDRA0aYA/dzfItM+B5KpyFeSSw6ofRRhg==
X-Received: by 2002:adf:e4d0:0:b0:225:2947:3a5f with SMTP id v16-20020adfe4d0000000b0022529473a5fmr15483088wrm.387.1661334090693;
        Wed, 24 Aug 2022 02:41:30 -0700 (PDT)
Received: from [192.168.110.200] (82-65-22-26.subs.proxad.net. [82.65.22.26])
        by smtp.gmail.com with ESMTPSA id bh19-20020a05600c3d1300b003a2f6367049sm1335730wmb.48.2022.08.24.02.41.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Aug 2022 02:41:29 -0700 (PDT)
Message-ID: <ecb5c967-9913-73e0-65a6-e35893eee411@redhat.com>
Date:   Wed, 24 Aug 2022 11:41:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH bpf-next v7 13/24] HID: initial BPF implementation
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Jiri Kosina <jikos@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Joe Stringer <joe@cilium.io>, Jonathan Corbet <corbet@lwn.net>,
        Tero Kristo <tero.kristo@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org
References: <20220721153625.1282007-1-benjamin.tissoires@redhat.com>
 <20220721153625.1282007-14-benjamin.tissoires@redhat.com>
 <YuKaG18WXkkQlu8e@kroah.com>
From:   Benjamin Tissoires <benjamin.tissoires@redhat.com>
In-Reply-To: <YuKaG18WXkkQlu8e@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Greg,

On 7/28/22 16:15, Greg KH wrote:
> On Thu, Jul 21, 2022 at 05:36:14PM +0200, Benjamin Tissoires wrote:
>> diff --git a/drivers/hid/bpf/Kconfig b/drivers/hid/bpf/Kconfig
>> new file mode 100644
>> index 000000000000..423c02e4c5db
>> --- /dev/null
>> +++ b/drivers/hid/bpf/Kconfig
>> @@ -0,0 +1,18 @@
>> +# SPDX-License-Identifier: GPL-2.0-only
>> +menu "HID-BPF support"
>> +	#depends on x86_64
> 
> Is this comment still needed?

Nope. It was required a few months ago, but I think we now have 
trampoline support also for aarch64, which are the 2 main architectures 
we care right now.

Dropping this from the series.

Cheers,
Benjamin

> 
>> +
>> +config HID_BPF
>> +	bool "HID-BPF support"
>> +	default HID_SUPPORT
>> +	depends on BPF && BPF_SYSCALL
>> +	help
>> +	This option allows to support eBPF programs on the HID subsystem.
>> +	eBPF programs can fix HID devices in a lighter way than a full
>> +	kernel patch and allow a lot more flexibility.
>> +
>> +	For documentation, see Documentation/hid/hid-bpf.rst
>> +
>> +	If unsure, say Y.
>> +
>> +endmenu
> 

