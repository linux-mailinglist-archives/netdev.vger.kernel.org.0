Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A07E51E2B8
	for <lists+netdev@lfdr.de>; Sat,  7 May 2022 02:22:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378268AbiEGAZx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 20:25:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235557AbiEGAZw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 20:25:52 -0400
Received: from novek.ru (unknown [93.153.171.106])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E852B3D1FB
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 17:22:07 -0700 (PDT)
Received: from [192.168.0.18] (unknown [37.228.234.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id E5B9050048B;
        Sat,  7 May 2022 03:12:31 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru E5B9050048B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1651882353; bh=+Iyp4mLKaZpRbtiRcpV13tqWd+HQr+AnDejp0gB9hzk=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=Cj0buFL0jbU3qxWxl/hmMIyv1tFhzRMI5e8BW+PUFH8AVO6hbU3qSCNypXBWNbcTb
         VmGCAOy8cP83FLsWli2AW14JZ4Ws/jF8fpNw8g7AgXVft29z8pkORW2iHjzxbmjJ/n
         isjOYfmkzDoX5Sbqok1WEgInu9upzPpBuJ1G9W4c=
Message-ID: <7caf6b8e-4329-d9a1-5024-f37cc10edc26@novek.ru>
Date:   Sat, 7 May 2022 01:13:12 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH net] ptp: ocp: Use DIV64_U64_ROUND_UP for rounding.
Content-Language: en-US
To:     Jonathan Lemon <jonathan.lemon@gmail.com>, netdev@vger.kernel.org
Cc:     richardcochran@gmail.com, kernel-team@fb.com, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com
References: <20220505234038.3310-1-jonathan.lemon@gmail.com>
From:   Vadim Fedorenko <vfedorenko@novek.ru>
In-Reply-To: <20220505234038.3310-1-jonathan.lemon@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RDNS_NONE,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06.05.2022 00:40, Jonathan Lemon wrote:
> The initial code used roundup() to round the starting time to
> a multiple of a period.  This generated an error on 32-bit
> systems, so was replaced with DIV_ROUND_UP_ULL().
> 
> However, this truncates to 32-bits on a 64-bit system.  Replace
> with DIV64_U64_ROUND_UP() instead.
> 
> Fixes: 'b325af3cfab9 ("ptp: ocp: Add signal generators and update sysfs nodes")'
> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>

Acked-by: Vadim Fedorenko <vfedorenko@novek.ru>
