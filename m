Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 739095FD7A0
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 12:10:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229537AbiJMKKF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 06:10:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229682AbiJMKKD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 06:10:03 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D09161C90D
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 03:09:59 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id iv17so853891wmb.4
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 03:09:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fikJBuc2dKoI5QSH8/aZZj0ff+S7GAGXWa4PY32D5co=;
        b=XeJ7aF8OamDr/+deXK7b7T0q6Wob/Dxwz4PKdqyoq3z/GXE4Uwkl7FPE5xXPU4zYz5
         L9cj/6Yl9pXJoCB7N9Aa85guKhve1R8lHSClh8bJW3444tl0VjgWlGPco2flgib0eP5J
         NxNCr4xdIV0lb/SIi5KaxqzbNwHzkiT09ngVkQxTBEbwAxddFC7VU0+PftupcoQoPHtn
         3qTGv3gh6QiUSz5OLZ0BJbLBzPcqJh9KSmtM26T12LIT52BBf8xwEtpdIW2agc87/OWS
         P7K3iN+UFbl27pOe0ebnThjBnibOdOCdnEVIm1vBXpBXA8PaZMK8cCc3pDzzNvZ40AXX
         88vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fikJBuc2dKoI5QSH8/aZZj0ff+S7GAGXWa4PY32D5co=;
        b=L0yv+XSDAXVMCwp9pi00bwPqF9YNR6uP2/PYkfrlfcd7W0WmvDKj5p1NTt6FxQYYfL
         CgrmHrnRi7Vcc2QwLGjGI0zMNK/DOUsmEDX+OkKR2aBHv1PwmWJuE6qa7VoTFNymHq8D
         4T0UMGQKP4k50zqK8na01Zyz9elwoRlsJptKHSdLJW17HqTbx+JRPdLUadNIunuT8Eo3
         ZAmNE0XNQkzERVlpyCvzACVdI062uZ90vJsijzJouky7GsBQQPPIBt2oR+aH76OlaWPx
         mAqB3BDCOlLCcnMIlkR6A1ftNnTzWoFymPukAJB4gkl51KQJmjaeVkUam9XEYAl6jbYr
         or0g==
X-Gm-Message-State: ACrzQf1LpttnBbnsQFfO1TqM06ffL/FvFwQX+FQxdQNWKlZAXYDuNuON
        8vPxXXl74vmLebHre51f5cg=
X-Google-Smtp-Source: AMsMyM7sd2WU98Dst9i0tIr1av0LA4AxKlhz9vCk+T/IGdM5hBtX7wjAjmev2dbHFid1DZFUd21C7w==
X-Received: by 2002:a05:600c:6885:b0:3c4:de24:638 with SMTP id fn5-20020a05600c688500b003c4de240638mr5860118wmb.183.1665655797879;
        Thu, 13 Oct 2022 03:09:57 -0700 (PDT)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id z6-20020adfdf86000000b00230c9d427f9sm1689831wrl.53.2022.10.13.03.09.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Oct 2022 03:09:57 -0700 (PDT)
Subject: Re: [PATCH net] sfc: Change VF mac via PF as first preference if
 available.
To:     Jonathan Cooper <jonathan.s.cooper@amd.com>,
        netdev@vger.kernel.org, linux-net-drivers@amd.com
Cc:     Martin Habets <habetsm.xilinx@gmail.com>,
        =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
References: <20221013095553.52957-1-jonathan.s.cooper@amd.com>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <5631204c-546f-c45d-9e6f-330c3cddf275@gmail.com>
Date:   Thu, 13 Oct 2022 11:09:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20221013095553.52957-1-jonathan.s.cooper@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13/10/2022 10:55, Jonathan Cooper wrote:
> Changing a VF's mac address through the VF (rather than via the PF)
> fails with EPERM because the latter part of efx_ef10_set_mac_address
> attempts to change the vport mac address list as the VF.
> Even with this fixed it still fails with EBUSY because the vadaptor
> is still assigned on the VF - the vadaptor reassignment must be within
> a section where the VF has torn down its state.
> 
> A major reason this has broken is because we have two functions that
> ostensibly do the same thing - have a PF and VF cooperate to change a
> VF mac address. Rather than do this, if we are changing the mac of a VF
> that has a link to the PF in the same VM then simply call
> sriov_set_vf_mac instead, which is a proven working function that does
> that.
> 
> If there is no PF available, or that fails non-fatally, then attempt to
> change the VF's mac address as we would a PF, without updating the PF's
> data.
> 
> Test case:
> Create a VF:
>   echo 1 > /sys/class/net/<if>/device/sriov_numvfs
> Set the mac address of the VF directly:
>   ip link set <vf> addr 00:11:22:33:44:55
> Set the MAC address of the VF via the PF:
>   ip link set <pf> vf 0 mac 00:11:22:33:44:66
> Without this patch the last command will fail with ENOENT.
> 
> Signed-off-by: Jonathan Cooper <jonathan.s.cooper@amd.com>
> Reported-by: Íñigo Huguet <ihuguet@redhat.com>
> Fixes: 910c8789a777 ("set the MAC address using MC_CMD_VADAPTOR_SET_MAC")

Acked-by: Edward Cree <ecree.xilinx@gmail.com>
