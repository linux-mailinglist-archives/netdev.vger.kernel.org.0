Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8731A294681
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 04:28:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439976AbgJUC21 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 22:28:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2439972AbgJUC21 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 22:28:27 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48E26C0613CE
        for <netdev@vger.kernel.org>; Tue, 20 Oct 2020 19:28:27 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id l16so861623ilj.9
        for <netdev@vger.kernel.org>; Tue, 20 Oct 2020 19:28:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=w9bwqRjlEPnVTslhROgv52HhohbcAn/B24oc/NWj44Y=;
        b=Fx8+AdNkEZIAYEozLveUYRyfa33RNXA3RFyaLCw7VFFLML+q3X8y1+5sGOium2oayR
         0miGy/Tsiy/XPJYLX1IbERA4SgVs5pHPFQ2UvmimHhmQha1YDmVp2wGX+/Fx3FSLjpl4
         PRrsEwBboNcrAjFRmlE0Amfn4+IPPUSNi1En7pgWRDcKv2nImLRW8lX5BXi92v6kSWVP
         OheMFfot/FSaLjJuWDLyWIYlit6gxg5+cfkSLBkvWmuQj/l2+DxPB8/epF1/gAv0j9CI
         7G309V3No2JusIrbDSBolt/ot3bLsx1I7xe8AX9U0al3uyqRzG+0REOJ8VxzAm6cJAEJ
         mhXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=w9bwqRjlEPnVTslhROgv52HhohbcAn/B24oc/NWj44Y=;
        b=NhCpZsfPR0dng1l4UPWF3HbT4kLJ05hg1S+B6k5428uA2nB4OMqBGkpGUjVMIvbUZG
         TUmWq+XiTCQ6Lgs/HB56sxF+V8BNxW6Jg4zBXJz8EXtIb540TSRfBChMsKMC3Vu9ZA4x
         p8nz2cph4BaxhDsjWFTrs+ZIw8CddcBi9qA88Q/0P+cOrtGcxu8WJU23EZMnUtyNKt4W
         o9M2ELuH9PwhNZMPK2USmtRERLaLU+lglJhvxGuCsoHl/g43s3DQFpVNcumqGqFygyoF
         9T/9FdVHjkvb7+VpAJNqUWH0fI3Vt/50klbQF9E+zR0aM1R2ETOCEZC3WdloUEAYyQxi
         5GzQ==
X-Gm-Message-State: AOAM530X7T/vBKQpSDRdl6D/NcgTIsCYcZiCGqPJD6pX/rT0eJ3fX5F5
        f9OoS0+Z4AhDUzW7lMPjsmX2QQwEdF0=
X-Google-Smtp-Source: ABdhPJyJVWOXAF6EV/U3m9eHuj8rHQfFHAEFnQpI/Tq1RPT0NivzuMUQpkzNjGyB/A2blO0xLd+YNA==
X-Received: by 2002:a92:c88e:: with SMTP id w14mr642033ilo.185.1603247306505;
        Tue, 20 Oct 2020 19:28:26 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:2cd9:64d4:cacf:1e54])
        by smtp.googlemail.com with ESMTPSA id f65sm330653ilg.88.2020.10.20.19.28.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Oct 2020 19:28:25 -0700 (PDT)
Subject: Re: [PATCH net v2] mpls: load mpls_gso after mpls_iptunnel
To:     Alexander Ovechkin <ovov@yandex-team.ru>, netdev@vger.kernel.org
References: <20201020114333.26866-1-ovov@yandex-team.ru>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <8d95a3f7-6839-5cf8-f844-2b0b14e50890@gmail.com>
Date:   Tue, 20 Oct 2020 20:28:25 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201020114333.26866-1-ovov@yandex-team.ru>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/20/20 5:43 AM, Alexander Ovechkin wrote:
> mpls_iptunnel is used only for mpls encapsuation, and if encaplusated
> packet is larger than MTU we need mpls_gso for segmentation.
> 
> Signed-off-by: Alexander Ovechkin <ovov@yandex-team.ru>
> Acked-by: Dmitry Yakunin <zeil@yandex-team.ru>
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

Reviewed-by: David Ahern <dsahern@gmail.com>
