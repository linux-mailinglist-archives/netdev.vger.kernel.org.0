Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A8D03D82F0
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 00:30:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232600AbhG0Waw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 18:30:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232198AbhG0Wav (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 18:30:51 -0400
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CBF4C061757;
        Tue, 27 Jul 2021 15:30:48 -0700 (PDT)
Received: by mail-oi1-x232.google.com with SMTP id t128so1259414oig.1;
        Tue, 27 Jul 2021 15:30:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TM+0hfl782kZ94bU2+mpLOzzj7zbvQhOg+LQO69XhJk=;
        b=OnZ0m3U6tk3aCgWWTpT1MeD5/y+cwwRGzbM1zoIOCsQa4Vm9x21ssaUT8KnrIx+bhB
         Wa4U8xGQ285YoMNgnePTt2oCAcFoa8EIx3hrP27YcLLsbYrem2nEpOrbnmPnPX0ir/Ic
         V51k/BxJeVFK/eNOf91oJ90M75vlYzafc5fjuq+9/rO8ZtxNzXPK1thYL0Dwh0Tn2olv
         SivSSSssPuoXELYpGRGeF7OTsoxb6Cx0zu/1/SiPhOUEi34dJjExAZbJyPC9Z46LMBVp
         AhzMesAzkabVEr5OAd/P4rBe8czDEUBkikopbW0OPFtJ2NPn2COjgAV4AOGkH4MMFPaQ
         1nfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TM+0hfl782kZ94bU2+mpLOzzj7zbvQhOg+LQO69XhJk=;
        b=GNatqslYyovwt59XqOC+19IUTiuOic4t7U9leDpu70u8DHHyk7c1UilrR4HBNBTo6Z
         9T1Hp2dG5uVGshXJbpWMRr5wK3/4HrVDhDp5fKPcINh8HpTAtD9/mm0azc+MI6dmIvaF
         U6M5M/WjFerrFko2cYXh4V/d4VpA+3O11dPrr6kCCtcbawArcBFsKABfCoPsBiT5vFwG
         EArKoeF+njCVDw/hcrsC+674BLEI42mvaqWJiffCmBAA1wgWCb0H2cXtyT4NBMxMgfw+
         FWjCci+TqGbUl3Sofm5UOoHGzOxxyRm+fbpErne9ptpLK+u/P7uIo0qrdVkKWbNT31DX
         TLVw==
X-Gm-Message-State: AOAM532ykbS4Vz9X0JCEgXxHLm68W32LcyRQpKImA1SBLn9gxEkTDH2j
        KkAdS9PCTPU/0kidMVXQT34=
X-Google-Smtp-Source: ABdhPJz1wrwXjwcPUI1kIk1ky0ig9jrAicZ/h11+lv2H2/uL4SXlKLhoPqS89RPsBt2E7Mkq8bcgCQ==
X-Received: by 2002:aca:d505:: with SMTP id m5mr4174267oig.5.1627425047828;
        Tue, 27 Jul 2021 15:30:47 -0700 (PDT)
Received: from localhost.localdomain (cpe-24-31-246-181.kc.res.rr.com. [24.31.246.181])
        by smtp.gmail.com with ESMTPSA id c16sm783982otd.18.2021.07.27.15.30.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Jul 2021 15:30:46 -0700 (PDT)
Sender: Larry Finger <larry.finger@gmail.com>
Subject: Re: [PATCH 07/64] staging: rtl8192e: Use struct_group() for memcpy()
 region
To:     Kees Cook <keescook@chromium.org>, linux-hardening@vger.kernel.org
Cc:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Keith Packard <keithpac@amazon.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-staging@lists.linux.dev, linux-block@vger.kernel.org,
        linux-kbuild@vger.kernel.org, clang-built-linux@googlegroups.com
References: <20210727205855.411487-1-keescook@chromium.org>
 <20210727205855.411487-8-keescook@chromium.org>
From:   Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <fa3a9a2f-b611-7fe4-9359-88fa51239765@lwfinger.net>
Date:   Tue, 27 Jul 2021 17:30:45 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210727205855.411487-8-keescook@chromium.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/27/21 3:57 PM, Kees Cook wrote:
> In preparation for FORTIFY_SOURCE performing compile-time and run-time
> field bounds checking for memcpy(), memmove(), and memset(), avoid
> intentionally writing across neighboring fields.
> 
> Use struct_group() around members addr1, addr2, and addr3 in struct
> rtllib_hdr_4addr, and members qui, qui_type, qui_subtype, version,
> and ac_info in struct rtllib_qos_information_element, so they can be
> referenced together. This will allow memcpy() and sizeof() to more easily
> reason about sizes, improve readability, and avoid future warnings about
> writing beyond the end of addr1 and qui.
> 
> "pahole" shows no size nor member offset changes to struct
> rtllib_hdr_4addr nor struct rtllib_qos_information_element. "objdump -d"
> shows no meaningful object code changes (i.e. only source line number
> induced differences and optimizations).
> 
> Signed-off-by: Kees Cook<keescook@chromium.org>

Tested-by: Larry Finger <Larry.Finger@lwfinger.net>
Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Looks good.

Larry

