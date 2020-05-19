Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E0741D8E6D
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 06:00:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726272AbgESEAb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 00:00:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725791AbgESEAb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 00:00:31 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA3B0C061A0C
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 21:00:30 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id i5so13113125qkl.12
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 21:00:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=BOlPFrm4/qGH45+tEMNqY9IZ8v8RnWFNeZXF3KYFalU=;
        b=nuNJCwny9oEdFlBgTkcS/KdiJ1oAiunFFoSbFMkL6WCMzH5T3G0z0CRl/yMi0i+ZDx
         gmwZ4MOAHSnOGQer7yyqNDwpgRc+o0cRrHSYQsC3luSVKh0wynZ+6wt2ubQ1zE9qF3Db
         BTPvaXkIKkN3BVHcBRLpW7fe1bwKtQCxHxcNpfLiJVZ3CeejBTiWv+rVxBWtKWNWwarn
         SsrL48B/GkV92flzud/dj1bCWMEHCNuNzdLBGvipfnju/kCNJXig2uaWtJhjyAH311dA
         cZpUTFquqxAZDKr/cQx+FYUT63sB83lVX8jh/yAT87qhke1G5TgyKea6RW3mK/ngMD1p
         ILIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BOlPFrm4/qGH45+tEMNqY9IZ8v8RnWFNeZXF3KYFalU=;
        b=SOrGJnCn8qKX4Z6OHjFgYPw0o5h9tjSbcnyNflaMHur6nc81CZrCLUxYYFFfSbws4T
         /kfPVBgtf2Mv94mMozTcuUQvdDo0uDTp+OF84QBby0z8GTV33IJDq+x+qUf+Lp2hK/QW
         t/TEKcn9vvEY5tmbyHvVnkcdaX/ZPapUidtI+neKkVWAWviaedlejlC9ewAsX9lnl+8x
         MCccid43HsGKEqpDl9++ylg6gProXJ6QiisJY1p8J5VVrmuFaGC5GF9cDWGV/jXx1Ktk
         KiEzfH0ZDBsyWPwMAbRRYBxjmE9CNBk7fIHtLy14grRCCr2IUJRVGs2t7HIlwuja7JP4
         EIvQ==
X-Gm-Message-State: AOAM5309xJETasJzCYgRrHBLOIvtrlS+5KA4Topx29bM0V13BaTg1Lfn
        lVeH3EaKms33Ep4XsJkMVus=
X-Google-Smtp-Source: ABdhPJwste9EXDSd5lsEH9WJqsW6KErabRIC2nM5anxePSlFghSY2qtI/xjy+THxFCqHkQkV+OTWRQ==
X-Received: by 2002:a37:6547:: with SMTP id z68mr19088165qkb.197.1589860830037;
        Mon, 18 May 2020 21:00:30 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:c5f3:7fed:e95c:6b74? ([2601:282:803:7700:c5f3:7fed:e95c:6b74])
        by smtp.googlemail.com with ESMTPSA id u56sm11404885qtb.91.2020.05.18.21.00.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 May 2020 21:00:29 -0700 (PDT)
Subject: Re: [PATCH net-next 6/6] selftests: net: add fdb nexthop tests
To:     Roopa Prabhu <roopa@cumulusnetworks.com>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, nikolay@cumulusnetworks.com,
        jiri@mellanox.com, idosch@mellanox.com, petrm@mellanox.com
References: <1589854474-26854-1-git-send-email-roopa@cumulusnetworks.com>
 <1589854474-26854-7-git-send-email-roopa@cumulusnetworks.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <e50b08e2-aed3-a90a-5aa3-55278ac3a6a8@gmail.com>
Date:   Mon, 18 May 2020 22:00:28 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <1589854474-26854-7-git-send-email-roopa@cumulusnetworks.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/18/20 8:14 PM, Roopa Prabhu wrote:
> diff --git a/tools/testing/selftests/net/fib_nexthops.sh b/tools/testing/selftests/net/fib_nexthops.sh
> index 50d822f..eb4c270 100755
> --- a/tools/testing/selftests/net/fib_nexthops.sh
> +++ b/tools/testing/selftests/net/fib_nexthops.sh
> @@ -19,8 +19,8 @@ ret=0
>  ksft_skip=4
>  
>  # all tests in this script. Can be overridden with -t option
> -IPV4_TESTS="ipv4_fcnal ipv4_grp_fcnal ipv4_withv6_fcnal ipv4_fcnal_runtime ipv4_compat_mode"
> -IPV6_TESTS="ipv6_fcnal ipv6_grp_fcnal ipv6_fcnal_runtime ipv6_compat_mode"
> +IPV4_TESTS="ipv4_fcnal ipv4_grp_fcnal ipv4_withv6_fcnal ipv4_fcnal_runtime ipv4_compat_mode ipv4_fdb_grp_fcnal"
> +IPV6_TESTS="ipv6_fcnal ipv6_grp_fcnal ipv6_fcnal_runtime ipv6_compat_mode ipv6_fdb_grp_fcnal"
>  
>  ALL_TESTS="basic ${IPV4_TESTS} ${IPV6_TESTS}"
>  TESTS="${ALL_TESTS}"

add negative tests to the other existing sets to verify fdb nh can not
be used with IPv4 or IPv6 routes and fdb nh can be part of v4/v6
multipath group.

