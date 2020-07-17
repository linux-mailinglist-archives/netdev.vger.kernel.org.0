Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2CB0223BC9
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 14:57:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726996AbgGQM5d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 08:57:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726335AbgGQM51 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 08:57:27 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEC2CC08C5DB
        for <netdev@vger.kernel.org>; Fri, 17 Jul 2020 05:57:26 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id f2so10966382wrp.7
        for <netdev@vger.kernel.org>; Fri, 17 Jul 2020 05:57:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ERus8fzJ5R62NsLoNGm20p6xoPRFac3PIzhWkEbAo+w=;
        b=lW84lRKAVIr9Fxp6UZcmVAnb+SWK36KcRe2odHnFanXN1oZRrDY6JzC1MLtnjGqe2s
         Db6TSRoG1opsbs6Ywi74Egwi+5i1I2IfxVQEB+inghPbhENMgqS1jfi9umSEohiX0Zfz
         crcIT3Dk9b6yqxJ2FO1zOG6Kc9+9+Ju/3j+bf4AtANStX/5mjcHMUqObxNdkqJfpaBMQ
         VbL2O7IETlXohrwtdFRJFCl+/uwgwE52AmNqObW30xVPh1RxacSu9/sPR+WplJ+xkekb
         bhI2bX3PA+7jYxi5lY6V2NooDqEvs4KiSNH4hCw8jsna0LHeaePrfaMNejiZ0dMaoilZ
         n2KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ERus8fzJ5R62NsLoNGm20p6xoPRFac3PIzhWkEbAo+w=;
        b=fc/xqz11sv2UIXAlrpNUeMdJ0NTloJLPLWhkTZIxzhdST1doHEcUaKFUuvyAsKIrUY
         EE+fpwzAhomB3hX4Teh1YscIO5+1kLW2pzWRTwJOEOoQSFmS2yJvEB6jCpTzC0aOSex3
         LvJcpZDR0rND3LfWliB4L3sE2oh7IPZA4qKU2z+K0FtXeJ/+MsS14W5kRrEjt2M7vNRr
         DGFW/9MZonxmo9A7RifKbzu+DE21EhIpJgGVxqR746OJUAsb99B+Mob8ssRj/5hSldIS
         FN8rNFBpJEucgPLrqf34tlPZNPQBtcInOHgxuxvPdMeHx5dG8sy6i+R6ZR116UdVfBBW
         xuiw==
X-Gm-Message-State: AOAM530JpX8PG/H7WJJaKkDpKnE20R4tathQ5ibDVSAKdr1ZxLgC2uZ4
        cxhaqzz9eJQFnoCwSVeGEc/Inw==
X-Google-Smtp-Source: ABdhPJw9wK67gBrxddm9kpw+jfyaFWJYcfeYa/vhr3AJ6eAu3tNq5H7jsWkSc2ylc0bXNe5kTQaIOw==
X-Received: by 2002:adf:fa10:: with SMTP id m16mr9676787wrr.134.1594990645566;
        Fri, 17 Jul 2020 05:57:25 -0700 (PDT)
Received: from [192.168.1.12] ([194.35.117.41])
        by smtp.gmail.com with ESMTPSA id i67sm13828628wma.12.2020.07.17.05.57.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jul 2020 05:57:24 -0700 (PDT)
Subject: Re: [PATCH bpf-next 09/13] tools/bpftool: add bpftool support for bpf
 map element iterator
To:     Yonghong Song <yhs@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, kernel-team@fb.com,
        Martin KaFai Lau <kafai@fb.com>
References: <20200713161739.3076283-1-yhs@fb.com>
 <20200713161749.3077526-1-yhs@fb.com>
 <9f865c02-291c-8622-b601-f4613356a469@isovalent.com>
 <c70ebb0a-538c-a84f-f606-1d08af426fde@fb.com>
From:   Quentin Monnet <quentin@isovalent.com>
Message-ID: <b845b429-0b9b-72cd-eaf4-3e621055fe71@isovalent.com>
Date:   Fri, 17 Jul 2020 13:57:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <c70ebb0a-538c-a84f-f606-1d08af426fde@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2020-07-16 10:42 UTC-0700 ~ Yonghong Song <yhs@fb.com>
> 
> 
> On 7/16/20 9:39 AM, Quentin Monnet wrote:
>> 2020-07-13 09:17 UTC-0700 ~ Yonghong Song <yhs@fb.com>

[...]

>> Could you please also update the bash completion?
> 
> This is always my hardest part! In this case it is
>   bpftool iter pin <filedir> <filedir> [map MAP]
> 
> Any particular existing bpftool implementation I can imitate?

I would say the closest/easiest to reuse we have would be
completion for the MAP part in either

	bpftool prog attach PROG ATTACH_TYPE [MAP]

or

	bpftool map pin MAP FILE

But I'll save you some time, I gave it a go and this is what
I came up with:

------
diff --git a/tools/bpf/bpftool/bash-completion/bpftool b/tools/bpf/bpftool/bash-completion/bpftool
index 25b25aca1112..6640e18096a8 100644
--- a/tools/bpf/bpftool/bash-completion/bpftool
+++ b/tools/bpf/bpftool/bash-completion/bpftool
@@ -613,9 +613,26 @@ _bpftool()
             esac
             ;;
         iter)
+            local MAP_TYPE='id pinned name'
             case $command in
                 pin)
-                    _filedir
+                    case $prev in
+                        $command)
+                            _filedir
+                            ;;
+                        id)
+                            _bpftool_get_map_ids
+                            ;;
+                        name)
+                            _bpftool_get_map_names
+                            ;;
+                        pinned)
+                            _filedir
+                            ;;
+                        *)
+                            _bpftool_one_of_list $MAP_TYPE
+                            ;;
+                    esac
                     return 0
                     ;;
                 *)
------

So if we complete "bpftool iter pin", if we're right after "pin"
we still complete with file names (for the object file to pin).
If we're after one of the map keywords (id|name|pinned), complete
with map ids or map names or file names, depending on the case.
For other cases (i.e. after object file to pin), offer the map
keywords (id|name|pinned).

Feel free to reuse.

Best,
Quentin
