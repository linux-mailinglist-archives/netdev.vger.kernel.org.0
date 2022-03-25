Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E26044E74D4
	for <lists+netdev@lfdr.de>; Fri, 25 Mar 2022 15:09:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356085AbiCYOKc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 10:10:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233381AbiCYOKb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 10:10:31 -0400
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F8A5D8F40
        for <netdev@vger.kernel.org>; Fri, 25 Mar 2022 07:08:57 -0700 (PDT)
Received: by mail-ot1-x333.google.com with SMTP id a17-20020a9d3e11000000b005cb483c500dso5547824otd.6
        for <netdev@vger.kernel.org>; Fri, 25 Mar 2022 07:08:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=OK6b6UML9BtD/HDSE4P4efgw4Ohe3rWv1lPTW/pWI0I=;
        b=TRocpZHSt1fw4R2doATejz+eE4ZXSwfPjT7l8BEcxi3/Tidm3qzj0/hN8HmT5I53O6
         5PIcigxbMhp+Z6s2HkE7U9jTie3ydkJhevSPmKQbZzLn76/1M8f+PtuS809aeMz58IuF
         3oPxp7s5mM1FXKr4BxmL8/9qa2aJSca62uv7BrcMJ3O9tYjCvuFMSxVRiO84uxhsTtuB
         vNMp3minBbRqFFupNVlY5WZXMa39jVy85rM/9lptuCj9j4pko0Rl4Ung9wyiPHjY0Qwh
         edPDClXufSfSEUZo2BA4nO1vQoGMbe2Qsc3m5eETDQqbuktWKMPoh0Pxda62pxaoacGM
         spNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=OK6b6UML9BtD/HDSE4P4efgw4Ohe3rWv1lPTW/pWI0I=;
        b=jT9KIT4qagP5SCukwUQiPfhUpLByzuPLw9MT0ExfkY3ejkyxAV8Ve+bZD1+yNRD1x4
         dAaKPExc/ho9qYGbFBZYnYrXqYhpwWa8EFhEDiu89hbZH0SQ63HU01mPDpcbDOn0+ukC
         vt22+k48g84Xn54d4UHFgHPazBo+kTpxVVKOcVFSjALhVuqb+nYzYudR1ZBzkmvHEyJ9
         EHiQIpGBGLG+S2VlVWR6G+HeNa3w4sw0Dpz4NnFYk+uj+HCvaHi87p+nXDtFWCX0mL2j
         OxkA1RH92pMyV57n/vLo8Sz4XrSnVOfTlRHAXpzC5Hd+dwslQFw9UMVvFLdYERMlwWe+
         hsuA==
X-Gm-Message-State: AOAM5306rc00xXaps1tWmbJzqPyv9D3Sw80oQtHUTnQTlftkVYo3eiPd
        hHsDmomM3Xu9sZ/uZ5GfChETUgNZeaE=
X-Google-Smtp-Source: ABdhPJzREBiIl6DnkVs+9dVKalvuy1Bqqi84YfzBfeQbSLGdXrOIfg+ieI7fH9571H6ZCS0OFKAIeA==
X-Received: by 2002:a9d:f06:0:b0:5b2:37c7:40b9 with SMTP id 6-20020a9d0f06000000b005b237c740b9mr4391291ott.74.1648217336985;
        Fri, 25 Mar 2022 07:08:56 -0700 (PDT)
Received: from [172.16.0.2] ([8.48.134.58])
        by smtp.googlemail.com with ESMTPSA id v17-20020a9d69d1000000b005b2319a08c4sm2598006oto.18.2022.03.25.07.08.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Mar 2022 07:08:56 -0700 (PDT)
Message-ID: <b134fd1b-38da-381a-1d69-2d98a53a54eb@gmail.com>
Date:   Fri, 25 Mar 2022 08:08:53 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [PATCH net] selftests: test_vxlan_under_vrf: Fix broken test case
Content-Language: en-US
To:     Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        abauvin@scaleway.com, akherbouche@scaleway.com, mlxsw@nvidia.com
References: <20220324200514.1638326-1-idosch@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220324200514.1638326-1-idosch@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/24/22 2:05 PM, Ido Schimmel wrote:
> The purpose of the last test case is to test VXLAN encapsulation and
> decapsulation when the underlay lookup takes place in a non-default VRF.
> This is achieved by enslaving the physical device of the tunnel to a
> VRF.
> 
> The binding of the VXLAN UDP socket to the VRF happens when the VXLAN
> device itself is opened, not when its physical device is opened. This
> was also mentioned in the cited commit ("tests that moving the underlay
> from a VRF to another works when down/up the VXLAN interface"), but the
> test did something else.
> 
> Fix it by reopening the VXLAN device instead of its physical device.
> 
> Before:
> 
>  # ./test_vxlan_under_vrf.sh
>  Checking HV connectivity                                           [ OK ]
>  Check VM connectivity through VXLAN (underlay in the default VRF)  [ OK ]
>  Check VM connectivity through VXLAN (underlay in a VRF)            [FAIL]
> 
> After:
> 
>  # ./test_vxlan_under_vrf.sh
>  Checking HV connectivity                                           [ OK ]
>  Check VM connectivity through VXLAN (underlay in the default VRF)  [ OK ]
>  Check VM connectivity through VXLAN (underlay in a VRF)            [ OK ]
> 
> Fixes: 03f1c26b1c56 ("test/net: Add script for VXLAN underlay in a VRF")
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  tools/testing/selftests/net/test_vxlan_under_vrf.sh | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 



Reviewed-by: David Ahern <dsahern@kernel.org>
