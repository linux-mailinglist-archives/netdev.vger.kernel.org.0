Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13D226C9EDF
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 11:05:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233046AbjC0JFJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 05:05:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232660AbjC0JEj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 05:04:39 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5FFD90;
        Mon, 27 Mar 2023 02:04:05 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id v1so7894938wrv.1;
        Mon, 27 Mar 2023 02:04:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679907844;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=PXHUgllCiE+YVplh4F0vC+TIMQgHYLAcdKhqqMncm+M=;
        b=UjgOhIU/pavH2tlMiWKycQqAigQYIjgXPIu4oocRPGzCa6LiVMGOvqObrg/PRgkmVu
         9Xnhg4WGVJjU3lOJoCVQ3UYykePZC+rJIGQhsMn5smPo/OHUQWgnk0LqVyle5s5lsPX9
         ToiZQ+OZguuNokmfrIAl2lS9WK4Q4SvyYi+2GIqflDRN3t4HaR+m2AfzLnCmhcdjb9vl
         p5o8JEG89pLh5h9zUx7yYvO8WMqBtMnjVx7B6Bhhv0/XcI8FcsMimYzxslgt9LrfgO6H
         KJEquB69ob74KiHksS94yNZveY1kMYPS4TsXHra/0UD5uSQkXuOjOOe2Vh/wn+YamevJ
         t5jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679907844;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PXHUgllCiE+YVplh4F0vC+TIMQgHYLAcdKhqqMncm+M=;
        b=PsZq4NB9F1NcAtwodSoEAUIEO1XKL5Seg8oPIkCU3J6AYjyUz01lXHmOgUBXbtB99K
         GHCcU2XxMxl8e28FYrIp/K1jxcw15hcVx+EjyupCDGgQfPcWDK5VW/XQZ/g4D2mi4mnr
         fxnsK0CXE7MomOkLtGP6srbWFOFRxMBcpMKh1CRAluxQ1XPWCDF6MSENU+Uy0UlPODnc
         vyCISz2Pi7eWAncdYmuj0JiqJDTMflLpTOEgawOZMJlcoYf6eLbL5cBMIFlJAQ+Pam9V
         f5P1AnXTid1voqmhYPeT+GGeOhWfAPup70Bf2Nfs8Bcr0TtJZ9hB4Ddjfuy1DxdyPDvE
         Ay+g==
X-Gm-Message-State: AAQBX9da2c+j4h4NTyOK5jpZyWQ/fCDsR/7OJf3pgwkNPpGFIPTdMtse
        hBMGtrBJmLX60ZA/MVIicDDNh8wmCo+otQ==
X-Google-Smtp-Source: AKy350ZCDxEOhvB06k/8nFr/OHWO5YAaSfzuL2Y8qzIAkmCg7c3/PINVfRoQvVapYrT+OqZlGSCrbw==
X-Received: by 2002:a5d:63cb:0:b0:2d5:2436:b584 with SMTP id c11-20020a5d63cb000000b002d52436b584mr8944362wrw.42.1679907844064;
        Mon, 27 Mar 2023 02:04:04 -0700 (PDT)
Received: from [192.168.26.216] (54-240-197-238.amazon.com. [54.240.197.238])
        by smtp.gmail.com with ESMTPSA id u13-20020adfdb8d000000b002d2b117a6a6sm24567852wri.41.2023.03.27.02.04.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Mar 2023 02:04:03 -0700 (PDT)
From:   Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <04f7b88c-a7dd-6d63-4938-06e71a194aa3@xen.org>
Date:   Mon, 27 Mar 2023 10:04:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Reply-To: paul@xen.org
Subject: Re: [PATCH 1/2] xen/netback: don't do grant copy across page boundary
Content-Language: en-US
To:     Juergen Gross <jgross@suse.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Wei Liu <wei.liu@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        xen-devel@lists.xenproject.org, stable@vger.kernel.org
References: <20230327083646.18690-1-jgross@suse.com>
 <20230327083646.18690-2-jgross@suse.com>
Organization: Xen Project
In-Reply-To: <20230327083646.18690-2-jgross@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27/03/2023 09:36, Juergen Gross wrote:
> Fix xenvif_get_requests() not to do grant copy operations across local
> page boundaries. This requires to double the maximum number of copy
> operations per queue, as each copy could now be split into 2.
> 
> Make sure that struct xenvif_tx_cb doesn't grow too large.
> 
> Cc: stable@vger.kernel.org
> Fixes: ad7f402ae4f4 ("xen/netback: Ensure protocol headers don't fall in the non-linear area")
> Signed-off-by: Juergen Gross <jgross@suse.com>
> ---
>   drivers/net/xen-netback/common.h  |  2 +-
>   drivers/net/xen-netback/netback.c | 25 +++++++++++++++++++++++--
>   2 files changed, 24 insertions(+), 3 deletions(-)
> 

Reviewed-by: Paul Durrant <paul@xen.org>

