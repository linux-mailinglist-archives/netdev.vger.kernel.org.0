Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1B2F6B7909
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 14:32:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230415AbjCMNcc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 09:32:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230022AbjCMNcb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 09:32:31 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BBBEE191
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 06:32:29 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id q16so11339105wrw.2
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 06:32:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112; t=1678714347;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7gyYi+XtCpD2uG8A40hp6/lB7yhSYk0q2fyJGgOKS0o=;
        b=CfKF5AjrcLwg9yqlB+hGaQQT9RTklzD8GRCrol8or+N36YDgLcwlt55kCQJEoADaDg
         LrBZD8YdT+46nnX5n6PKTSVuucqxEDifDxjh24MJ4SCFnCnfUgPcTKjyNGdqSRdEtuLj
         3/LS2DLd+afwTNz6r19LT8yvelLbOetfGZvJb8gW+JppscvNQC63dBSbfVTAFV7IdcEV
         nK5/HCJqIUlPEDA+UYOSkTKt6TXXaVKkFXUtwiuMkRSPMAjZgpGQfca0nNSeBV11F7sU
         C335UOuy8xsQ4u4mBwZQwK8H3COOfKC/cF1nLmRPxHI/IMKjoVRN3L6BvAKk7v/tiUgj
         oEPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678714347;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7gyYi+XtCpD2uG8A40hp6/lB7yhSYk0q2fyJGgOKS0o=;
        b=DZj59IkQ17F3WBWZ/PkgBCuF1giLH5+fO3T5mxgxQ/t9PAx/GxzWEpzDtRr3fpfyXT
         NsqBGv+pmcpARnWkEtDxYBXFiTmpR5Rowu777/FRDc/cL7xHnWHPyNcjorn9tDe1u+xw
         IaEG9Zj5HwiCJeo9xnnVj4BLLlCjUJqGAH9qK/KGXDwWYgT7ZY+EFSRglSUe/a28lOJM
         +7qbHHPcmG2FlxK9CjUXU7i0eC+ONFObqA3fCjlIq/7qjRU0l7AnFftreieuRCBgVOtq
         dg5TiSn3mRU9A5A8M8y+JW4XcFDFFNp37ag/t57L8RA0pNsPIMrZymyHztfvizOX2U1K
         Iu2w==
X-Gm-Message-State: AO0yUKW/PFzFGEfPe2/sH+ZHrv2I3zhDScmN/8urfvwCKDJqC9P3NQch
        MlXDzhjivJSyWB9pvJiDaKm1ebs/DsBSIfxrYpY=
X-Google-Smtp-Source: AK7set8dr1KCjCcVKALlzA9yTY4HS9XlFTHrTkrNjEhaCO2Ko8oF0ELfj1x0ZQXVa27Dd9jTTOF2JA==
X-Received: by 2002:a5d:4947:0:b0:2ce:a93d:8832 with SMTP id r7-20020a5d4947000000b002cea93d8832mr3897557wrs.35.1678714347138;
        Mon, 13 Mar 2023 06:32:27 -0700 (PDT)
Received: from [192.168.0.161] (62-73-72-43.ip.btc-net.bg. [62.73.72.43])
        by smtp.gmail.com with ESMTPSA id l2-20020a5d4bc2000000b002c57475c375sm7916239wrt.110.2023.03.13.06.32.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Mar 2023 06:32:26 -0700 (PDT)
Message-ID: <7caf0c99-fb6a-389a-4b1e-f2cfe83b258d@blackwall.org>
Date:   Mon, 13 Mar 2023 15:32:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net 2/2] selftests: rtnetlink: add a bond test trying to
 enslave non-eth dev
Content-Language: en-US
To:     netdev@vger.kernel.org
Cc:     syoshida@redhat.com, j.vosburgh@gmail.com, andy@greyhouse.net,
        kuba@kernel.org, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com,
        syzbot+9dfc3f3348729cc82277@syzkaller.appspotmail.com
References: <20230313132834.946360-1-razor@blackwall.org>
 <20230313132834.946360-3-razor@blackwall.org>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20230313132834.946360-3-razor@blackwall.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13/03/2023 15:28, Nikolay Aleksandrov wrote:
[snip]
> +kci_test_enslaved_bond_non_eth()
> +{
> +	local ret=0
> +
> +	ip link add name test-nlmon0 type nlmon
> +	ip link add name test-bond0 type bond
> +	ip link add name test-bond1 type bond
> +	ip link set dev test-bond0 master test-bond1
> +	ip link set dev test-nlmon0 master test-bond0 1>/dev/null 2>/dev/null
> +
> +	ip -d l sh dev test-bond0 | grep -q "SLAVE"
> +	if [ $? -ne 0 ]; then
> +		echo "FAIL: IFF_SLAVE flag is missing from the bond device"
> +		check_err 1
> +	fi
> +	ip -d l sh dev test-bond0 | grep -q "MASTER"
> +	if [ $? -ne 0 ]; then
> +		echo "FAIL: IFF_MASTER flag is missing from the bond device"
> +		check_err 1
> +	fi
> +
> +	# on error we return before cleaning up as that may hang the system

I wasn't sure if this part was ok, let me know if you prefer to always attempt cleaning up
and I'll send v2 moving the return after the cleanup attempt.

> +	if [ $ret -ne 0 ]; then
> +		return 1
> +	fi
> +
> +	# clean up any leftovers
> +	ip link del dev test-bond0
> +	ip link del dev test-bond1
> +	ip link del dev test-nlmon0
> +
> +	echo "PASS: enslaved bond device has flags restored properly"
> +}
> +
>  kci_test_rtnl()
>  {
>  	local ret=0
> @@ -1276,6 +1310,8 @@ kci_test_rtnl()
>  	check_err $?
>  	kci_test_bridge_parent_id
>  	check_err $?
> +	kci_test_enslaved_bond_non_eth
> +	check_err $?
>  
>  	kci_del_dummy
>  	return $ret

