Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 681262945D4
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 02:16:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439554AbgJUAQr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 20:16:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392232AbgJUAQr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 20:16:47 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AB23C0613CE
        for <netdev@vger.kernel.org>; Tue, 20 Oct 2020 17:16:47 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id j17so680112ilr.2
        for <netdev@vger.kernel.org>; Tue, 20 Oct 2020 17:16:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=a9hCCs/EOW2b9GaoXMG6DRdDBaBTvM91tVcBdYo77JA=;
        b=HpoAJo9aXCSuUXG0XdcOEYSR85N7gm9DzVIehrsLjo384utpzihufXQZhPlUrc6eef
         4ZIXtvAXV30Gryu+bnAjQ4QYrgEfksbFsbDqL3eXSebYae70E1BMDoZNvdQwsCKbVSa+
         7fBhcODZ6nJ55cSemw7ma+50izzMW/yN49eMp02LOeNZ1X/HmZkyLNQhwcqTpZsuZYal
         jHjUVOqFInTBXa71c62E34HykpnRmrWPoBsCYa8EH/ttiqzh25wk4vZPU4QMKQfy0O0+
         LvUhiRgAVSIccaOOZhNRB0IpcOXlmXf3fzUYRG1uyPGru7oKAL0fzPj9sCjTGjZj8McS
         ynjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=a9hCCs/EOW2b9GaoXMG6DRdDBaBTvM91tVcBdYo77JA=;
        b=aa1AA0PUQeo6U4JMCDrYtkjv+hrKXatNG7HCpyd4HEp3s2XOxvDm63qdYBGDKmHBgO
         8g7iJiLpFO/iqY0qJvsSaLahIGFk7kPluvF1JeGufuKpvMuv291zXORZnayi2N5lMEMC
         0Tv8BlmDUX5AKCxdWrZB20/WMQlhgk+uAc0UNGzaBP+UIMN3sPqdoY2NxWUl0F4Gsq91
         a/x/0SU+NTbnonYY8JuKvDBWDzyQ9ch5oTLF6rcBiXNVdw5WdsA+qhVx1p3Ev5cyG32u
         42148c4FVi9Bs14P076WPSy+Bafvlu/vpDj6PzBei/tOULNk+fsejJ+F36O1inb7CdMv
         EuKw==
X-Gm-Message-State: AOAM5333ss2FpuXngt2cOlkmEOdwVWfchvtrWrjwi13sdX8VGAkyuV3c
        40bpVtByCTnopuWsRkpX9VqCPd2InIA=
X-Google-Smtp-Source: ABdhPJwM27DlIz8vcC5rgvVKzYYF4rzLlT5msBE/RBGwWXj/5jZg/VKE2lPtrDv1wNl7MPS0eDMNcg==
X-Received: by 2002:a92:41cf:: with SMTP id o198mr408626ila.262.1603239406266;
        Tue, 20 Oct 2020 17:16:46 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:2cd9:64d4:cacf:1e54])
        by smtp.googlemail.com with ESMTPSA id k18sm334497ioj.21.2020.10.20.17.16.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Oct 2020 17:16:45 -0700 (PDT)
Subject: Re: [PATCH net] mpls: load mpls_gso after mpls_iptunnel
To:     Alexander Ovechkin <ovov@yandex-team.ru>, netdev@vger.kernel.org
References: <20201020110255.17012-1-ovov@yandex-team.ru>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <a291f6c4-7145-c7b9-62ff-035d4c53ca5b@gmail.com>
Date:   Tue, 20 Oct 2020 18:16:44 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201020110255.17012-1-ovov@yandex-team.ru>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/20/20 5:02 AM, Alexander Ovechkin wrote:
> mpls_iptunnel is used only for mpls encapsuation, and if encaplusated
> packet is larger than MTU we need mpls_gso for segmentation.


Familiar with that problem

> ---
>  net/mpls/mpls_iptunnel.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/net/mpls/mpls_iptunnel.c b/net/mpls/mpls_iptunnel.c
> index 2def85718d94..ef59e25dc482 100644
> --- a/net/mpls/mpls_iptunnel.c
> +++ b/net/mpls/mpls_iptunnel.c
> @@ -300,5 +300,6 @@ static void __exit mpls_iptunnel_exit(void)
>  module_exit(mpls_iptunnel_exit);
>  
>  MODULE_ALIAS_RTNL_LWT(MPLS);
> +MODULE_SOFTDEP("post: mpls_gso");
>  MODULE_DESCRIPTION("MultiProtocol Label Switching IP Tunnels");
>  MODULE_LICENSE("GPL v2");
> 

interesting solution. did not know about the SOFTDEP.

LGTM
Reviewed-by: David Ahern <dsahern@gmail.com>
