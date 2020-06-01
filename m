Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE3341E9F80
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 09:51:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727989AbgFAHvZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 03:51:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725935AbgFAHvW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 03:51:22 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E959C05BD43
        for <netdev@vger.kernel.org>; Mon,  1 Jun 2020 00:51:21 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id j12so654162lfh.0
        for <netdev@vger.kernel.org>; Mon, 01 Jun 2020 00:51:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lLnsFSRkW5PHb+/oaZ7Mx9bMV/UsiXKKVLVFncEiU3E=;
        b=1bqiI0STU9hw+Veqkv1PIzwq1jo5n3EFM5FwycBBlBHQv9+wYSjymGX/dXiiShRE7K
         6HDjn+4Gsn5SB5km9/6neacSNl+4k4U+dXsddiqIb1d6pqo3TwpvTTje1MUCd30Rig6n
         0OkLjQNOGHAWNCRRmHFT27mYd31OqSC2M4VkQoO3KOxOJRmn0DVC4w5AxyvgmGQ2WjDT
         AX/weecLtERefoRVsjMHBjNn3EYEKEBZNseKuY/gzpV4Tynooat7E6reh212c79jiHBT
         pKeSqXQV5SzB9Ui2CEcg75WUobA1/gVLQdYRQjoLxV7QyenjdXm5QML26ykWybMZ0Sh3
         p5Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lLnsFSRkW5PHb+/oaZ7Mx9bMV/UsiXKKVLVFncEiU3E=;
        b=pHNhvTCoJACzr/OzcZ1HV4bPXDeA+Qjznr5fzIWkUi4IGVw3ouzpTEro8G0CsAhyYa
         EHttPgQLlP6RgfF9c83Ec2qo0mZHaq7XClsxDylvG9KfcinzQfapRyjDWAkD5qIAIZUq
         Ek0giwAVEcPClKlOy1vrkePXSNc7R0mYj5fs5TxueWCRueJmHWaQ5TsC0Kc9tpoYfD+E
         JhxmF3I9DvAER6FhXhrJhw5pnJi0NHYVlWTevwBRIQ4r2MpPhblaq9MMX/kGopQWz2dW
         vslG2NFmMjDWEfa4ldKOmOK3qswO/fYcMLnKi/jQcbF60XQJ5FOvGNU85G1RD5oOLtFX
         hAWQ==
X-Gm-Message-State: AOAM531aaoOHs92aUtPOFtb1Bkk1SUkLrgebv43ktUhs9IVwLdJfwApK
        rqevxdfMlu6BBwi+03YnwG81aZhpad3N2g==
X-Google-Smtp-Source: ABdhPJwo2dgUaeBpdChjWZgpIZXWFgUo4EtTjcBCrgKAD+o3xIGhhsKPMdRz2cnhUIFTlWmg+xtuog==
X-Received: by 2002:ac2:5cac:: with SMTP id e12mr10743762lfq.92.1590997879369;
        Mon, 01 Jun 2020 00:51:19 -0700 (PDT)
Received: from ?IPv6:2a00:1fa0:2dd:a862:f067:6dfa:d209:15e? ([2a00:1fa0:2dd:a862:f067:6dfa:d209:15e])
        by smtp.gmail.com with ESMTPSA id 10sm2361654ljw.134.2020.06.01.00.51.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Jun 2020 00:51:18 -0700 (PDT)
Subject: Re: [PATCH v2] devres: keep both device name and resource name in
 pretty name
To:     Vladimir Oltean <olteanv@gmail.com>, gregkh@linuxfoundation.org,
        arnd@arndb.de, akpm@linux-foundation.org
Cc:     bgolaszewski@baylibre.com, mika.westerberg@linux.intel.com,
        efremov@linux.com, ztuowen@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
References: <20200531180758.1426455-1-olteanv@gmail.com>
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <39107d25-f6e6-6670-0df6-8ae6421e7f9a@cogentembedded.com>
Date:   Mon, 1 Jun 2020 10:51:14 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <20200531180758.1426455-1-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 31.05.2020 21:07, Vladimir Oltean wrote:

> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Sometimes debugging a device is easiest using devmem on its register
> map, and that can be seen with /proc/iomem. But some device drivers have
> many memory regions. Take for example a networking switch. Its memory
> map used to look like this in /proc/iomem:
> 
> 1fc000000-1fc3fffff : pcie@1f0000000
>    1fc000000-1fc3fffff : 0000:00:00.5
>      1fc010000-1fc01ffff : sys
>      1fc030000-1fc03ffff : rew
>      1fc060000-1fc0603ff : s2
>      1fc070000-1fc0701ff : devcpu_gcb
>      1fc080000-1fc0800ff : qs
>      1fc090000-1fc0900cb : ptp
>      1fc100000-1fc10ffff : port0
>      1fc110000-1fc11ffff : port1
>      1fc120000-1fc12ffff : port2
>      1fc130000-1fc13ffff : port3
>      1fc140000-1fc14ffff : port4
>      1fc150000-1fc15ffff : port5
>      1fc200000-1fc21ffff : qsys
>      1fc280000-1fc28ffff : ana
> 
> But after the patch in Fixes: was applied, the information is now
> presented in a much more opaque way:
> 
> 1fc000000-1fc3fffff : pcie@1f0000000
>    1fc000000-1fc3fffff : 0000:00:00.5
>      1fc010000-1fc01ffff : 0000:00:00.5
>      1fc030000-1fc03ffff : 0000:00:00.5
>      1fc060000-1fc0603ff : 0000:00:00.5
>      1fc070000-1fc0701ff : 0000:00:00.5
>      1fc080000-1fc0800ff : 0000:00:00.5
>      1fc090000-1fc0900cb : 0000:00:00.5
>      1fc100000-1fc10ffff : 0000:00:00.5
>      1fc110000-1fc11ffff : 0000:00:00.5
>      1fc120000-1fc12ffff : 0000:00:00.5
>      1fc130000-1fc13ffff : 0000:00:00.5
>      1fc140000-1fc14ffff : 0000:00:00.5
>      1fc150000-1fc15ffff : 0000:00:00.5
>      1fc200000-1fc21ffff : 0000:00:00.5
>      1fc280000-1fc28ffff : 0000:00:00.5
> 
> That patch made a fair comment that /proc/iomem might be confusing when
> it shows resources without an associated device, but we can do better
> than just hide the resource name altogether. Namely, we can print the
> device name _and_ the resource name. Like this:
> 
> 1fc000000-1fc3fffff : pcie@1f0000000
>    1fc000000-1fc3fffff : 0000:00:00.5
>      1fc010000-1fc01ffff : 0000:00:00.5 sys
>      1fc030000-1fc03ffff : 0000:00:00.5 rew
>      1fc060000-1fc0603ff : 0000:00:00.5 s2
>      1fc070000-1fc0701ff : 0000:00:00.5 devcpu_gcb
>      1fc080000-1fc0800ff : 0000:00:00.5 qs
>      1fc090000-1fc0900cb : 0000:00:00.5 ptp
>      1fc100000-1fc10ffff : 0000:00:00.5 port0
>      1fc110000-1fc11ffff : 0000:00:00.5 port1
>      1fc120000-1fc12ffff : 0000:00:00.5 port2
>      1fc130000-1fc13ffff : 0000:00:00.5 port3
>      1fc140000-1fc14ffff : 0000:00:00.5 port4
>      1fc150000-1fc15ffff : 0000:00:00.5 port5
>      1fc200000-1fc21ffff : 0000:00:00.5 qsys
>      1fc280000-1fc28ffff : 0000:00:00.5 ana
> 
> Fixes: 8d84b18f5678 ("devres: always use dev_name() in devm_ioremap_resource()")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
[...]

    You didn't write the version log -- what changed since v1?

MBR, Sergei
